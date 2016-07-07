#![feature(lang_items)]
#![feature(const_fn)]
#![no_std]

extern crate spin;
use spin::Mutex;

const CONSOLE_COLS: isize = 80;
const CONSOLE_ROWS: isize = 25;

#[lang = "eh_personality"]
extern fn eh_personality() {
}

#[lang = "panic_fmt"]
extern fn rust_begin_panic() -> ! {
    loop {}
}

#[no_mangle]
pub extern fn kmain() -> ! {
    unsafe {
        let message = "Hello, world!";
        let mut b = BUFFER.lock();
        b.write_str(message);

        let vga = 0xb8000 as *mut u8;
        let length = b.buffer.len() * 2;
        let buffer = b.buffer.as_ptr() as *const u8;
        core::ptr::copy_nonoverlapping(buffer, vga, length);
    };

    loop { }
}

pub static BUFFER: Mutex<VgaBuffer> = Mutex::new(VgaBuffer{
    buffer: [VgaCell{character: b' ', color: DEFAULT_COLOR}; (CONSOLE_ROWS * CONSOLE_COLS) as usize],
    position: 0
});

pub struct VgaBuffer {
    buffer: [VgaCell; (CONSOLE_ROWS * CONSOLE_COLS) as usize],
    position: usize
}

impl VgaBuffer {
    pub fn write_byte(&mut self, byte: u8, color: ColorCode) {
        let cell = VgaCell{character: byte, color: color};
        self.buffer[self.position] = cell;
        self.position += 1;
    }

    pub fn write_str(&mut self, message: &str) {
        for character in message.chars() {
            self.write_byte(character as u8, DEFAULT_COLOR);
        }
    }
}

#[derive(Copy,Clone)]
#[repr(C)]
pub struct VgaCell {
    character: u8,
    color: ColorCode
}

#[derive(Copy, Clone)]
#[repr(C)]
pub struct ColorCode {
    background: u8,
    foreground: u8
}

const DEFAULT_COLOR: ColorCode = ColorCode{background: Color::Blue as u8, foreground: Color::LightMagenta as u8};

#[repr(u8)]
pub enum Color {
    Black = 0,
    Blue = 1,
    Green = 2,
    Cyan = 3,
    Red = 4,
    Magenta = 5,
    Brown = 6,
    LightGray = 7,
    DarkGray = 8,
    LightBlue = 9,
    LightGreen = 10,
    LightCyan = 11,
    LightRed = 12,
    LightMagenta = 13,
    Yellow = 14,
    White = 15,
}
