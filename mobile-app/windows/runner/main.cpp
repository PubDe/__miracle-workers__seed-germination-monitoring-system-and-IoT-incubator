#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>
#include <iostream>
#include <webview.h>  // Ensure you include the webview library

int APIENTRY wWinMain(_In_ HINSTANCE instance,
                      _In_opt_ HINSTANCE prev,
                      _In_ wchar_t* command_line,
                      _In_ int show_command) {
  // Attach to console when present (e.g., 'flutter run') or create a new
  // console when running with a debugger.
  if (::GetConsoleWindow() == nullptr) {
    AllocConsole();
    FILE *unused;
    freopen_s(&unused, "CONOUT$", "w", stdout);
    freopen_s(&unused, "CONOUT$", "w", stderr);
    freopen_s(&unused, "CONIN$", "r", stdin);
  }

  // Initialize webview
  WebView::Initialize();

  // Initialize the Dart project
  flutter::DartProject project(L"data");
  flutter::FlutterViewController controller(1280, 720, project);

  // Run the application
  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  // Cleanup webview
  WebView::Uninitialize();

  return EXIT_SUCCESS;
}
