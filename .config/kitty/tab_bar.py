from kitty.fast_data_types import Screen
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb, draw_title
from kitty.rgb import Color, alpha_blend
from kitty.utils import color_from_int, color_as_int

def draw_tab(
    draw_data: DrawData, screen: Screen, tab: TabBarData,
    before: int, max_tab_length: int, index: int, is_last: bool,
    extra_data: ExtraData
) -> int:
    orig_bg = screen.cursor.bg
    tab_bg = color_from_int(orig_bg >> 8)
    fade_colors = [as_rgb(color_as_int(alpha_blend(tab_bg, draw_data.default_bg, alpha))) for alpha in draw_data.alpha]
    for bg in fade_colors:
        screen.cursor.bg = bg
        screen.draw(' ')
    screen.cursor.bg = orig_bg
    draw_title(draw_data, screen, tab, index, max(0, max_tab_length - 8))
    extra = screen.cursor.x - before - max_tab_length
    if extra > 0:
        screen.cursor.x = before
        draw_title(draw_data, screen, tab, index, max(0, max_tab_length - 4))
        extra = screen.cursor.x - before - max_tab_length
        if extra > 0:
            screen.cursor.x -= extra + 1
            screen.draw('…')
    for bg in reversed(fade_colors):
        if extra >= 0:
            break
        extra += 1
        screen.cursor.bg = bg
        screen.draw(" ")
    end = screen.cursor.x
    return end

# def draw(canvas, tab_bar, layout, style, tab_data, selected_tab, current_window):
#     # Iterate over the tabs
#     for i, tab in enumerate(tab_data):
#         # Calculate the position and size of the tab
#         x = tab_left(tab_bar, layout, style, tab_data, tab, current_window)
#         y = tab_top(tab_bar, layout, style, tab_data, tab, current_window)
#         w = tab_width(tab_bar, layout, style, tab_data, tab, current_window)
#         h = tab_height(tab_bar, layout, style, tab_data, tab, current_window)

#         # Set the fill color based on whether the tab is selected or not
#         if i == selected_tab:
#             fill_color = style.tab_bar_selected_tab_color
#         else:
#             fill_color = style.tab_bar_unselected_tab_color

#         # Draw the tab background
#         canvas.fill_rect(x, y, w, h, fill_color)

#         # Draw the tab name
#         canvas.draw_text(tab.name, style.tab_bar_font, style.tab_bar_text_color, x=x, y=y)

#         # Check for a bell notification
#         if tab.bell:
#             # Display the bell notification
#             notification_text = f"Bell on tab {i + 1}"
#             notification_x = x + (w - len(notification_text) * style.tab_bar_font.size) / 2
#             canvas.draw_text(notification_text, style.tab_bar_font, style.tab_bar_bell_color, x=notification_x, y=y)
