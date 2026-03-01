var bar_w = 200;
var bar_h = 20;
var bar_x = 30;
var bar_y = 30;

// HP BAR
draw_set_colour(c_black);
draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, false);

draw_set_colour(c_red);
draw_rectangle(bar_x, bar_y, bar_x + (hp / max_hp) * bar_w, bar_y + bar_h, false);

draw_set_colour(c_white);
draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, true);

// POPUP POSITION (shared)
var popup_x = 500;
var popup_y = 175;

// DEATH POPUP
if (is_dead && image_index >= image_number - 1)
{
    if (death_reason == "lava")  draw_sprite(sLavaDeath, 0, popup_x, popup_y);
    if (death_reason == "fall")  draw_sprite(sFallDeath, 0, popup_x, popup_y);
    if (death_reason == "hp")    draw_sprite(sHealthDeath, 0, popup_x, popup_y);
}

// FINISHED POPUP
if (in_cave)
{
    draw_sprite(sFinished, 0, popup_x, popup_y);
}