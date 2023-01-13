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
