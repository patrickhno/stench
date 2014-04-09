
require 'ffi'

module Stench
  module WinBase
    extend FFI::Library
    ffi_lib('user32', 'gdi32', 'kernel32')
    ffi_convention(:stdcall)

    def self._func(*args)
      attach_function *args
      case args.size
        when 3
          module_function args[0]
        when 4
          module_function args[0]
          alias_method(args[1], args[0])
          module_function args[1]
      end
    end

    ULONG_PTR = FFI::TypeDefs[:ulong]
    LONG_PTR = FFI::TypeDefs[:long]

    ULONG = FFI::TypeDefs[:ulong]
    LONG = FFI::TypeDefs[:long]
    LPVOID = FFI::TypeDefs[:pointer]
    INT = FFI::TypeDefs[:int]
    BYTE = FFI::TypeDefs[:uint16]
    DWORD = FFI::TypeDefs[:ulong]
    BOOL = FFI::TypeDefs[:int]
    UINT = FFI::TypeDefs[:uint]
    POINTER = FFI::TypeDefs[:pointer]
    VOID = FFI::TypeDefs[:void]

    HWND = HICON = HCURSOR = HBRUSH = HINSTANCE = HGDIOBJ =
        HMENU = HMODULE = HANDLE = ULONG_PTR
    LPARAM = LONG_PTR
    WPARAM = ULONG_PTR
    LPCTSTR = LPMSG = LPVOID
    LRESULT = LONG_PTR
    ATOM = BYTE

    WNDPROC = callback(:WindowProc, [HWND, UINT, WPARAM, LPARAM], LRESULT)

    class WNDCLASSEX < FFI::Struct
      layout :cbSize, UINT,
             :style, UINT,
             :lpfnWndProc, WNDPROC,
             :cbClsExtra, INT,
             :cbWndExtra, INT,
             :hInstance, HANDLE,
             :hIcon, HICON,
             :hCursor, HCURSOR,
             :hbrBackground, HBRUSH,
             :lpszMenuName, LPCTSTR,
             :lpszClassName, LPCTSTR,
             :hIconSm, HICON

      def initialize(*args)
        super
        self[:cbSize] = self.size
        @atom = 0
      end

      def register_class_ex
        (@atom = WinBase::RegisterClassEx(self)) != 0 ? @atom : raise("RegisterClassEx Error")
      end

      def atom
        @atom != 0 ? @atom : register_class_ex
      end
    end # WNDCLASSEX

    class POINT < FFI::Struct
      layout :x, LONG,
             :y, LONG
    end

    class MSG < FFI::Struct
      layout :hwnd, HWND,
             :message, UINT,
             :wParam, WPARAM,
             :lParam, LPARAM,
             :time, DWORD,
             :pt, POINT
    end

    _func(:GetModuleHandle,
          :GetModuleHandleA, [LPCTSTR], HMODULE)
    _func(:LoadImage,
          :LoadImageA, [HINSTANCE, LPCTSTR, UINT, INT, INT, UINT], HANDLE)
    _func(:GetStockObject, [INT], HGDIOBJ)
    _func(:RegisterClassEx,
          :RegisterClassExA, [LPVOID], ATOM)
    _func(:CreateWindowEx,
          :CreateWindowExA, [DWORD, LPCTSTR, LPCTSTR, DWORD,
                             INT, INT, INT, INT, HWND, HMENU, HINSTANCE, LPVOID], HWND)
    _func(:ShowWindow, [HWND, INT], BOOL)
    _func(:UpdateWindow, [HWND], BOOL)
    _func(:GetMessage,
          :GetMessageA, [LPMSG, HWND, UINT, UINT], BOOL)
    _func(:TranslateMessage, [LPVOID], BOOL)
    _func(:DispatchMessage,
          :DispatchMessageA, [LPVOID], BOOL)
    _func(:PostQuitMessage, [INT], VOID)
    _func(:DefWindowProc,
          :DefWindowProcA, [HWND, UINT, WPARAM, LPARAM], LRESULT)
    _func(:IsWindow, [HWND], BOOL)
    _func(:DestroyWindow, [HWND], BOOL)
    _func(:SetClassLong,
          :SetClassLongA, [HWND, INT, LONG], DWORD)
    _func(:InvalidateRect, [HWND, LPVOID, BOOL], BOOL)

    _func(:MessageBoxW, [HWND, LPCTSTR, LPCTSTR, UINT], INT)

    GWL_HINSTANCE = -6
    NULL = 0
    IDI_APPLICATION = 32512
    IMAGE_ICON = 1
    LR_SHARED = 32768
    IDC_ARROW = 32512
    IMAGE_CURSOR = 2
    WHITE_BRUSH = 0
    BLACK_BRUSH = 4
    WS_EX_LEFT = 0
    WS_OVERLAPPEDWINDOW = 13565952
    WS_VISIBLE = 268435456
    CW_USEDEFAULT = -2147483648
    WM_DESTROY = 2
    WM_LBUTTONDOWN = 513
    WM_RBUTTONUP = 517
    GCL_HBRBACKGROUND = -10
    TRUE = 1
    MB_OK = 0
  end

  HINST = WinBase.GetModuleHandle(nil)
end
