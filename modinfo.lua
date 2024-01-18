local function en_zh(en, zh)
    return (locale == "zh" or locale == "zhr" or locale == "zht") and zh or en
end

name = "M .louis"
version = "2.2.9.3"
description = en_zh(
"[Don't edit art] \nBut you can fix bug or reupload more powerful version. \n Original author:#ffffff \n Version: " .. version,
"此Mod与岛屿冒险和哈姆雷特兼容 \n我做了什么?:\n优化了Mod代码\n添加了一些新内容 \nVersion: " .. version)
author = en_zh("Sydney", "悉尼")

forumthread = "https://steamcommunity.com/sharedfiles/filedetails/?id=2927695119"

api_version = 10
priority = -1

dst_compatible = true

dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false
all_clients_require_mod = true

mod_dependencies = {
    {
        workshop = "workshop-2521851770",    -- Glassic API
        ["GlassicAPI"] = false,
        ["Glassic API - DEV"] = true
    },
}

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {
    "character",
    "M.louis",
    "manutsawee",
    "Manutsawee",
    "Louis",
    "Manutsawee",
}

local options_enable = {
    {description = en_zh("Disabled", "关闭"), data = false},
    {description = en_zh("Enabled", "开启"), data = true},
}

local function Breaker(title_en, title_zh)  --hover does not work, as this item cannot be hovered
    return {name = en_zh(title_en, title_zh) , options = {{description = "", data = false}}, default = false}
end

local function Space()
	return { name = "", label = "", hover = "", options = { {description = "", data = false}, }, default = false, }
end

local keys_table = {
    {description="TAB", data = 9},
    {description="KP_PERIOD", data = 266},
    {description="KP_DIVIDE", data = 267},
    {description="KP_MULTIPLY", data = 268},
    {description="KP_MINUS", data = 269},
    {description="KP_PLUS", data = 270},
    {description="KP_ENTER", data = 271},
    {description="KP_EQUALS", data = 272},
    {description="MINUS", data = 45},
    {description="EQUALS", data = 61},
    {description="SPACE", data = 32},
    {description="ENTER", data = 13},
    {description="ESCAPE", data = 27},
    {description="HOME", data = 278},
    {description="INSERT", data = 277},
    {description="DELETE", data = 127},
    {description="END", data   = 279},
    {description="PAUSE", data = 19},
    {description="PRINT", data = 316},
    {description="CAPSLOCK", data = 301},
    {description="SCROLLOCK", data = 302},
    {description="RSHIFT", data = 303}, -- use SHIFT instead
    {description="LSHIFT", data = 304}, -- use SHIFT instead
    {description="RCTRL", data = 305}, -- use CTRL instead
    {description="LCTRL", data = 306}, -- use CTRL instead
    {description="RALT", data = 307}, -- use ALT instead
    {description="LALT", data = 308}, -- use ALT instead
    {description="ALT", data = 400},
    {description="CTRL", data = 401},
    {description="SHIFT", data = 402},
    {description="BACKSPACE", data = 8},
    {description="PERIOD", data = 46},
    {description="SLASH", data = 47},
    {description="LEFTBRACKET", data     = 91},
    {description="BACKSLASH", data     = 92},
    {description="RIGHTBRACKET", data = 93},
    {description="TILDE", data = 96},
    {description="A", data = 97},
    {description="B", data = 98},
    {description="C", data = 99},
    {description="D", data = 100},
    {description="E", data = 101},
    {description="F", data = 102},
    {description="G", data = 103},
    {description="H", data = 104},
    {description="I", data = 105},
    {description="J", data = 106},
    {description="K", data = 107},
    {description="L", data = 108},
    {description="M", data = 109},
    {description="N", data = 110},
    {description="O", data = 111},
    {description="P", data = 112},
    {description="Q", data = 113},
    {description="R", data = 114},
    {description="S", data = 115},
    {description="T", data = 116},
    {description="U", data = 117},
    {description="V", data = 118},
    {description="W", data = 119},
    {description="X", data = 120},
    {description="Y", data = 121},
    {description="Z", data = 122},
    {description="F1", data = 282},
    {description="F2", data = 283},
    {description="F3", data = 284},
    {description="F4", data = 285},
    {description="F5", data = 286},
    {description="F6", data = 287},
    {description="F7", data = 288},
    {description="F8", data = 289},
    {description="F9", data = 290},
    {description="F10", data = 291},
    {description="F11", data = 292},
    {description="F12", data = 293},

    {description="UP", data = 273},
    {description="DOWN", data = 274},
    {description="RIGHT", data = 275},
    {description="LEFT", data = 276},
    {description="PAGEUP", data = 280},
    {description="PAGEDOWN", data = 281},

    {description="0", data = 48},
    {description="1", data = 49},
    {description="2", data = 50},
    {description="3", data = 51},
    {description="4", data = 52},
    {description="5", data = 53},
    {description="6", data = 54},
    {description="7", data = 55},
    {description="8", data = 56},
    {description="9", data = 57},
}

local value_table = {
    {description="50", data = 50},
    {description="60", data = 60},
    {description="70", data = 70},
    {description="80", data = 80},
    {description="90", data = 90},
    {description="100", data = 100},
    {description="110", data = 110},
    {description="120", data = 120},
    {description="130", data = 130},
    {description="140", data = 140},
    {description="150", data = 150},
    {description="160", data = 160},
    {description="170", data = 170},
    {description="180", data = 180},
    {description="190", data = 190},
    {description="200", data = 200},
    {description="210", data = 210},
    {description="220", data = 220},
    {description="230", data = 230},
    {description="240", data = 240},
    {description="250", data = 250},
    {description="300", data = 300},
}

configuration_options = {
	Breaker("Option", "选项"),
    {
        name = "locale",
        label = en_zh("Translation", "翻译"),
        hover = en_zh("Select a translation to enable it regardless of language packs.", "选择翻译，而不是自动"),
        options =
        {
            {description = "Auto", data = false},
            {description = "Deutsch", data = "de"},
            {description = "Español", data = "es"},
            {description = "Français", data = "fr"},
            {description = "Italiano", data = "it"},
            {description = "한국어", data = "ko"},
            {description = "Polski", data = "pl"},
            {description = "Português", data = "pt"},
            {description = "Русский", data = "ru"},
            {description = "中文 (简体)", data = "sc"},
            {description = "中文 (繁体)", data = "tc"},
        },
        default = false,
    },
	{
        name = "set_start_item",
        label = en_zh("Start Item", "开局自带太刀类型"),
        hover = en_zh("Select item when select character", "选择你的开始物品"),
        options = {
            {description="Nothing", data = 0},
			{description="Shinai", data = 1},
            {description="Raikiri", data = 2},
            {description="Yasha", data = 3},
            {description="Sakakura", data = 4},
            {description="Nihiru", data = 5},
			{description="Katanablade", data = 6},
        },
        default = 0,
    },
	Space(),
	Breaker("Scout skill", "侦察技能"),
	{
        name = "cancrafttent",
        label = en_zh("Portable-tent Craftable", "可以制作便携式帐篷"),
        hover = "",
        options = options_enable,
        default = false,
    },
	{
        name = "canuseslingshot",
        label = en_zh("Slingshot usable", "可以使用弹弓"),
        hover = "",
        options = options_enable,
        default = false,
    },
	Space(),
	Breaker("Character stat", "角色三维属性"),
	{
        name = "set_hunger",
        label = en_zh("Set Hunger 󰀎", "设置饥饿󰀎度"),
        hover = "",
        options = value_table,
        default = 150,
    },
	{
        name = "set_health",
        label = en_zh("Set Health 󰀍", "设置生命󰀍值"),
        hover = "",
        options = value_table,
        default = 200,
    },
	{
        name = "set_sanity",
        label = en_zh("Set Sanity 󰀓", "设置san󰀓值"),
        hover = "",
        options = value_table,
        default = 200,
    },
	{
        name = "set_max_hunger",
        label = en_zh("Max level Hunger+", "设置最大等级饥饿"),
        hover = "",
        options = {
			{description="0", data = 0},
            {description="10", data = 1},
			{description="20", data = 2},
			{description="30", data = 3},
            {description="40", data = 4},
            {description="50", data = 5},
            {description="60", data = 6},
            {description="70", data = 7},
            {description="80", data = 8},
            {description="90", data = 9},
            {description="100", data = 10},
            {description="110", data = 11},
            {description="120", data = 12},
            {description="130", data = 13},
            {description="140", data = 14},
            {description="150", data = 15},
            {description="160", data = 16},
            {description="170", data = 17},
            {description="180", data = 18},
            {description="190", data = 19},
            {description="200", data = 20},
        },
        default = 0,
    },
	{
        name = "set_max_health",
        label = en_zh("Max level Health+", "设置最大等级生命"),
        hover = "",
        options = {
            {description="0", data = 0},
            {description="10", data = 1},
			{description="20", data = 2},
			{description="30", data = 3},
            {description="40", data = 4},
            {description="50", data = 5},
            {description="60", data = 6},
            {description="70", data = 7},
            {description="80", data = 8},
            {description="90", data = 9},
            {description="100", data = 10},
            {description="110", data = 11},
            {description="120", data = 12},
            {description="130", data = 13},
            {description="140", data = 14},
            {description="150", data = 15},
            {description="160", data = 16},
            {description="170", data = 17},
            {description="180", data = 18},
            {description="190", data = 19},
            {description="200", data = 20},

        },
        default = 0,
    },
	{
        name = "set_max_sanity",
        label = en_zh("Max level Sanity+", "设置最大等级San值"),
        hover = "",
        options = {
			{description="0", data = 0},
            {description="10", data = 1},
			{description="20", data = 2},
			{description="30", data = 3},
            {description="40", data = 4},
            {description="50", data = 5},
            {description="60", data = 6},
            {description="70", data = 7},
            {description="80", data = 8},
            {description="90", data = 9},
            {description="100", data = 10},
            {description="110", data = 11},
            {description="120", data = 12},
            {description="130", data = 13},
            {description="140", data = 14},
            {description="150", data = 15},
            {description="160", data = 16},
            {description="170", data = 17},
            {description="180", data = 18},
            {description="190", data = 19},
            {description="200", data = 20},
        },
        default = 0,
    },
	{
        name = "set_max_mind",
        label = en_zh("Set Mind  󰀈", "设置能量点 󰀈") ,
        hover = en_zh("Set Mind when start. level max + 20", "设置起始能量点, 最大20"),
        options = {
            {description="2", data = 2},
            {description="3", data = 3},
            {description="4", data = 4},
            {description="5", data = 5},
            {description="6", data = 6},
            {description="7", data = 7},
            {description="8", data = 8},
            {description="9", data = 9},
            {description="10", data = 10},
            {description="15", data = 15},
            {description="20", data = 20},
        },
        default = 2,
    },
	{
        name = "set_mindregen_rate",
        label = en_zh("Mind  󰀈 Regen half of max / seccond ", "󰀈恢复最大的一半/秒") ,
        hover = "Mind regenaration unlock level 4.",
        options =
        {
			{description="10", data = 10},
            {description="20", data = 20},
            {description="30", data = 30},
            {description="60", data = 60},
            {description="90", data = 90},
            {description="120", data = 120},
            {description="150", data = 150},
            {description="180", data = 180},
            {description="210", data = 210},
            {description="240", data = 240},
            {description="270", data = 270},
            {description="300", data = 300},
            {description="360", data = 360},
            {description="420", data = 420},
        },
        default = 300,
    },
	{
        name = "mindregen_count",
        label = "Mind  󰀈 Regen / hit",
        hover = "Mind regen/hit that attack with katana.",
        options = {
            {description="4", data = 4},
            {description="6", data = 6},
            {description="8", data = 8},
            {description="10", data = 10},
            {description="12", data = 12},
            {description="14", data = 14},
            {description="16", data = 16},
            {description="18", data = 18},
            {description="20", data = 20},
        },
        default = 10,
    },
    Space(),
    Breaker("Custom Kenjutsu"),
	{
        name = "set_kexpmtp",
        label = "Kenjutsu EXP Multiple",
        hover = "fast Kenjutsu exp gain.",
        options =
        {
            {description="No", data = 1},
            {description="x2", data = 2},
            {description="x3", data = 3},
            {description="x4", data = 4},
            {description="x5", data = 5},
        },
        default = 1,
    },
	{
        name = "is_master",
        label = en_zh("Set Kenjutsu Level", "允许设置初始剑术等级"),
        hover = en_zh("", "Set Kenjutsu Level at start."),
        options = options_enable,
        default = false,
    },
	{
        name = "set_master_value",
        label = en_zh("Kenjutsu Level", "设置初始剑术等级"),
        hover = en_zh("", "Set Kenjutsu Level.") ,
        options = {
            {description="1", data = 1},
            {description="2", data = 2},
            {description="3", data = 3},
            {description="4", data = 4},
            {description="5", data = 5},
            {description="6", data = 6},
            {description="7", data = 7},
            {description="8", data = 8},
            {description="9", data = 9},
            {description="10", data = 10},
        },
        default = 1,
    },
    Space(),
    Breaker("Skill Keys 󰀈", "技能按键 󰀈"),
	{
        name = "enable_skill",
        label = en_zh("Skill 󰀈", "角色技能 󰀈"),
        hover = en_zh("Turn On or Off Character Skill.", "开启或者关闭角色技能") ,
        options = options_enable,
        default = true,
	},
	Space(),
	{
        name = "skill1_key",
        label = en_zh("Skill1:Button", "技能1 按键"),
        hover = en_zh("Skill1", "技能1"),
        options = keys_table,
        default = 114,
    },
	{
        name = "skill2_key",
        label = en_zh("Skill2:Button", "技能2 按键"),
        hover = en_zh("Skill2", "技能2"),
        options = keys_table,
        default = 99,
    },
	{
        name = "skill3_key",
        label = en_zh("Skill3:Button", "技能3 按键"),
        hover = en_zh("Skill3", "技能3"),
        options = keys_table,
        default = 116,
    },
	{
        name = "skill_counter_atk",
        label = en_zh("Counter Attack Skill:Button", "反击技能 按键"),
        hover = en_zh("Counter Attack", "反击技能"),
        options = keys_table,
        default = 122,
    },
	{
        name = "quick_sheath_key",
        label = en_zh("Quick Sheath Katana", "快速收拔刀 按键"),
        hover = en_zh("Quick Sheath Katana", "快速收拔刀"),
        options = keys_table,
        default = 120,
    },
	{
        name = "skill_cancel_key",
        label = en_zh("Skill Cancel", "技能取消 按键"),
        hover = en_zh("Cancel all skill", "技能取消"),
        options = keys_table,
        default = 118,
    },
    Space(),
	{
        name = "counter_attack_cooldown_time",
        label = "Skill Counter Cooldown time(s)",
        hover = "Set Skill Counter Cooldown time.",
        options = {
            {description="0.5", data = .5},
            {description="1", data = 1},
            {description="2", data = 2},
            {description="3", data = 3},
            {description="4", data = 4},
            {description="5", data = 5},
            {description="10", data = 10},
            {description="Default(20)", data = 20},
            {description="30", data = 30},
            {description="40", data = 40},
            {description="50", data = 50},
            {description="60", data = 60},
            {description="120", data = 120},
            {description="180", data = 180},
            {description="240", data = 240},
            {description="300", data = 300},
            {description="360", data = 360},
        },
        default = 20,
    },
	{
        name = "skill1_cooldown_time",
        label = "Skill 1 Cooldown time(s)",
        hover = "Set Skill Cooldown time.",
        options = {
			{description="5", data = 5},
            {description="10", data = 10},
            {description="20", data = 20},
            {description="30", data = 30},
            {description="40", data = 40},
			{description="Default(45)", data = 45},
            {description="50", data = 50},
            {description="60", data = 60},
            {description="120", data = 120},
            {description="180", data = 180},
            {description="240", data = 240},
            {description="300", data = 300},
            {description="360", data = 360},
        },
        default = 45,
    },
	{
        name = "skill2_cooldown_time",
        label = "Skill 2 Cooldown time(s)",
        hover = "Set Skil2 Cooldown time.",
        options = {
			{description="5", data = 5},
            {description="10", data = 10},
            {description="20", data = 20},
            {description="30", data = 30},
            {description="40", data = 40},
			{description="Default(45)", data = 45},
            {description="50", data = 50},
            {description="60", data = 60},
            {description="120", data = 120},
            {description="180", data = 180},
            {description="240", data = 240},
            {description="300", data = 300},
            {description="360", data = 360},
        },
        default = 45,
    },
	{
        name = "skill3_cooldown_time",
        label = "Skill 3 Cooldown time(s)",
        hover = "Set Skil3 Cooldown time.",
        options = {
			{description="5", data = 5},
            {description="10", data = 10},
            {description="20", data = 20},
            {description="30", data = 30},
            {description="40", data = 40},
            {description="Default(45)", data = 45},
            {description="50", data = 50},
            {description="60", data = 60},
            {description="120", data = 120},
            {description="180", data = 180},
            {description="240", data = 240},
            {description="300", data = 300},
            {description="360", data = 360},
        },
        default = 45,
    },
	{
        name = "isshin_skill_cooldown_time",
        label = "Tier 2 Skill Cooldown time(s)",
        hover = "Set Tier 2 Skill Cooldown time.",
        options = {
            {description="50", data = 50},
            {description="60", data = 60},
            {description="Default(90)", data = 90},
            {description="120", data = 120},
            {description="150", data = 150},
            {description="180", data = 180},
            {description="240", data = 240},
            {description="300", data = 300},
            {description="360", data = 360},
        },
        default = 90,
    },
	{
        name = "ryusen_and_susanoo_skill_cooldown_time",
        label = "Tier 3 Skill Cooldown time(s)",
        hover = "Set Tier 3 Skill Cooldown time.",
        options = {
            {description="90", data = 90},
            {description="120", data = 120},
            {description="150", data = 150},
            {description="180", data = 180},
            {description="Default(210)", data = 210},
            {description="240", data = 240},
            {description="300", data = 300},
            {description="360", data = 360},
        },
        default = 210,
    },
    Space(),
    Breaker("Other Keys 󰀮", "其它按键 󰀮"),
    {
        name = "put_glasses_key",
        label = en_zh("EyeGlasses 󰀅", "眼镜"),
        hover = en_zh("wear eyeglasses.", "戴眼镜按键"),
        options = keys_table,
        default = 111,
    },
	{
        name = "change_hairs_key",
        label = en_zh("Change Hair Style 󰀖", "改变发型"),
        hover = en_zh("This is the key to Change Hairstyle.", "改变发型按键"),
        options = keys_table,
        default = 108,
    },
	{
        name = "levelcheck",
        label = en_zh("Show Level  󰀙", "查看人物等级"),
        hover = en_zh("This is the key use to Show level.", "查看人物等级按键"),
        options = keys_table,
        default = 112,
    },
	Space(),
    Breaker("Other Option", "其它选项"),
    {
        name = "idle_anim",
        label = en_zh("Use Wanda idle animation.", "使用旺达的idle动画"),
        hover = en_zh("Use Wanda idle animation.", "使用旺达的idle动画"),
        options = options_enable,
        default = false,
    },
    {
        name = "dodge_enable",
        label = en_zh("enable dodge skill.", "开启滑铲技能"),
        hover = en_zh("enable dodge skill.", "开启滑铲技能"),
        options = options_enable,
        default = false,
    },
    {
        name = "dodge_cd",
        label = en_zh("Set Dodge Skill Cooldown time.", "设置滑铲技能冷却时间"),
        hover = en_zh("Set Dodge Skill Cooldown time.", "设置滑铲技能冷却时间"),
        options = {
            {description="1", data = 1},
            {description="5", data = 5},
            {description="10", data = 10},
            {description="Default(20)", data = 20},
            {description="25", data = 25},
            {description="30", data = 30},
            {description="35", data = 35},
        },
        default = 20,
    },
    Space(),
}
