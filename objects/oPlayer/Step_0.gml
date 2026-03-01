// =====================
// INPUT
// =====================
key_left  = keyboard_check(ord("A")) || keyboard_check(vk_left);
key_right = keyboard_check(ord("D")) || keyboard_check(vk_right);
key_jump  = keyboard_check_pressed(vk_space);
run_key   = keyboard_check(vk_shift);
key_down  = keyboard_check(ord("S")) || keyboard_check(vk_down);

// direction intent (for facing)
var move_dir = key_right - key_left;


// =====================
// DEATH STATE
// =====================
if (is_dead)
{
    hsp = 0;
    vsp = 0;

    sprite_index = sCharacterDie;

    if (image_index >= image_number - 1)
    {
        image_speed = 0;

        if (mouse_check_button_pressed(mb_left) ||
            keyboard_check_pressed(vk_space) ||
            keyboard_check_pressed(vk_enter))
        {
            room_restart();
        }
    }

    exit;
}


// =====================
// MOVEMENT
// =====================
speed_mult = run_key ? run_speed : walk_speed;

if (!is_rolling)
{
    hsp = move_dir * speed_mult;
}

vsp += grv;


// =====================
// FEET OFFSET
// =====================
var foot = bbox_bottom - y;
var left = bbox_left - x + 2;
var right = bbox_right - x - 2;


// =====================
// JUMP
// =====================
if (place_meeting(x, y + foot + 1, oWall) && key_jump)
{
    vsp = jump_speed;
}


// =====================
// HORIZONTAL COLLISION
// =====================
if (hsp > 0)
{
    if (place_meeting(x + hsp + right, y + foot, oWall))
    {
        while (!place_meeting(x + 1 + right, y + foot, oWall))
        {
            x += 1;
        }
        hsp = 0;
    }
}
else if (hsp < 0)
{
    if (place_meeting(x + hsp + left, y + foot, oWall))
    {
        while (!place_meeting(x - 1 + left, y + foot, oWall))
        {
            x -= 1;
        }
        hsp = 0;
    }
}

x += hsp;


// =====================
// VERTICAL COLLISION
// =====================
if (place_meeting(x, y + vsp + foot, oWall))
{
    while (!place_meeting(x, y + sign(vsp) + foot, oWall))
    {
        y += sign(vsp);
    }
    vsp = 0;
}

y += vsp;


// =====================
// ROLL
// =====================
if (!is_rolling)
{
    if (key_down && key_right)
    {
        is_rolling = true;
        roll_timer = roll_time;
        hsp = roll_speed;
    }

    if (key_down && key_left)
    {
        is_rolling = true;
        roll_timer = roll_time;
        hsp = -roll_speed;
    }
}

if (is_rolling)
{
    roll_timer -= 1;
    vsp = 0;

    if (roll_timer <= 0)
    {
        is_rolling = false;
    }
}


// =====================
// FALL DEATH
// =====================
if (y > room_height)
{
    is_dead = true;
    death_reason = "fall";
    sprite_index = sCharacterDie;
    image_index = 0;
    image_speed = 0.6;
}


// =====================
// LAVA DEATH
// =====================
if (
place_meeting(x, y, oLava5) ||
place_meeting(x, y, oLava6) ||
place_meeting(x, y, oLava7) ||
place_meeting(x, y, oLava8) ||
place_meeting(x, y, oLava9) ||
place_meeting(x, y, oLava10)
)
{
    is_dead = true;
    death_reason = "lava";
    sprite_index = sCharacterDie;
    image_index = 0;
    image_speed = 0.6;
}


// =====================
// HEALTH SYSTEM
// =====================
heal_rate = 0;

with (oTorch1)
{
    if (point_distance(x, y, other.x, other.y) < heal_radius)
        other.heal_rate = max(other.heal_rate, heal_power);
}

with (oTorch2)
{
    if (point_distance(x, y, other.x, other.y) < heal_radius)
        other.heal_rate = max(other.heal_rate, heal_power);
}

hp -= hp_drain_rate;
hp += heal_rate;
hp = clamp(hp, 0, max_hp);


// =====================
// HP DEATH
// =====================
if (hp <= 0)
{
    is_dead = true;
    death_reason = "hp";
    sprite_index = sCharacterDie;
    image_index = 0;
    image_speed = 0.6;
}


// =====================
// ANIMATION (ALIVE)
// =====================
if (is_rolling)
{
    sprite_index = sCharacterRoll;
}
else
{
    if (!place_meeting(x, y + foot + 1, oWall))
    {
        sprite_index = sCharacterJump;
    }
    else if (hsp != 0)
    {
        sprite_index = run_key ? sCharacterRun : sCharacterWalk;
    }
    else
    {
        sprite_index = sCharacterIdle;
    }
}


// =====================
// FACING (FIXED)
// =====================
if (move_dir != 0)
{
    image_xscale = move_dir;
}
