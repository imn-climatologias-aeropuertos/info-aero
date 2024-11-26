import flet as ft


def main(page: ft.Page) -> None:
    page.add(ft.SafeArea(ft.Text("Hello, Diego!")))


ft.app(main)
