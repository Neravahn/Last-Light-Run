var cam = view_camera[0];

var cam_w = camera_get_view_width(cam);
var cam_h = camera_get_view_height(cam);

// player visual center (not origin)
var px = bbox_left + (bbox_right - bbox_left) * 0.5;
var py = bbox_top  + (bbox_bottom - bbox_top) * 0.5;

// center camera on player body
var target_x = px - cam_w * 0.5;
var target_y = py - cam_h * 0.5;

// clamp to room
target_x = clamp(target_x, 0, room_width  - cam_w);
target_y = clamp(target_y, 0, room_height - cam_h);

// smooth follow
var cx = camera_get_view_x(cam);
var cy = camera_get_view_y(cam);

cx = lerp(cx, target_x, 0.6);
cy = lerp(cy, target_y, 0.6);

camera_set_view_pos(cam, cx, cy);