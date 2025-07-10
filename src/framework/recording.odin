package framework

import os "core:os/os2"

Pipe :: struct {
    r: ^os.File,
    w: ^os.File,
    p: os.Process,
}

pipe_open :: proc(command: []string) -> (pipe: Pipe, err: os.Error) {
    pipe.r, pipe.w = os.pipe() or_return
    pipe.p = os.process_start({
        command = command,
        stdout = nil,
        stderr = nil,
        stdin = pipe.r,
    }) or_return

    return
}

pipe_close :: proc(pipe: Pipe) -> (err: os.Error) {
    os.close(pipe.r) or_return
    os.close(pipe.w) or_return
    os.process_close(pipe.p) or_return

    return
}

Recorder :: struct {
    video: Pipe,
    audio: Pipe,
    recording_now: f64,
    is_recording: bool,
}

recorder_start :: proc(recorder: ^Recorder, start_sample_count: u64) -> (err: os.Error) {
    recorder.video = pipe_open({"ffmpeg", "-y", "-f", "rawvideo", "-s", "160x144", "-pix_fmt", "bgra", "-r", "60", "-i", "-", "-crf", "0", "video.mp4"}) or_return
    recorder.audio = pipe_open({"ffmpeg", "-y", "-f", "s16le", "-ar", "2097152", "-ac", "2", "-i", "-", "-af", "volume=0.1", "audio.mp3"}) or_return
    recorder.recording_now = f64(start_sample_count)
    recorder.is_recording = true

    return
}

recorder_stop :: proc(recorder: ^Recorder, filename: string) -> (err: os.Error) {
    pipe_close(recorder.video) or_return
    pipe_close(recorder.audio) or_return
    recorder.is_recording = false

    zipper_process := os.process_start({
        command = {"ffmpeg", "-y", "-i", "video.mp4", "-i", "audio.mp3", "-c:v", "copy", "-c:a", "copy", "-shortest", filename},
    }) or_return
    
    state := os.process_wait(zipper_process) or_return
    if state.exited {
        os.process_close(zipper_process) or_return
    }

    return
}

recorder_submit :: proc(recorder: ^Recorder, video_data: []u8, audio_data: []u8, time_now: u64) -> (err: os.Error) {
    os.write(recorder.audio.w, audio_data) or_return

    if video_data != nil {
        for f64(time_now) > recorder.recording_now {
            os.write(recorder.video.w, video_data) or_return
            recorder.recording_now += 2097152.0 / 60.0
        }
    }

    return
}