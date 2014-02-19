do
	local addon, namespace = ...
	_G[addon] = _G[addon] or {}
	setfenv(1, setmetatable(namespace, { __index = _G }))
end

local aliases = { --redundant aliases added by WoW
	-- Table library
	foreach = table.foreach,
	foreachi = table.foreachi,
	getn = table.getn,
	tinsert = table.insert,
	tremove = table.remove,
	sort = table.sort,
	wipe = table.wipe,
	
	-- Math library
	abs = math.abs,
	--acos = function (x) return math.deg(math.acos(x)) end
	--asin = function (x) return math.deg(math.asin(x)) end
	--atan = function (x) return math.deg(math.atan(x)) end
	--atan2 = function (x,y) return math.deg(math.atan2(x,y)) end
	ceil = math.ceil,
	--cos = function (x) return math.cos(math.rad(x)) end
	deg = math.deg,
	exp  = math.exp,
	floor = math.floor,
	frexp = math.frexp,
	ldexp = math.ldexp,
	log = math.log,
	log10 = math.log10,
	max = math.max,
	min = math.min,
	mod = math.fmod,
	PI = math.pi,
	--??? pow = math.pow
	rad = math.rad,
	random = math.random,
	--randomseed = math.randomseed
	--sin = function (x) return math.sin(math.rad(x)) end
	sqrt = math.sqrt,
	--tan = function (x) return math.tan(math.rad(x)) end
	
	-- String library
	strbyte = string.byte,
	strchar = string.char,
	strfind = string.find,
	format = string.format,
	gmatch = string.gmatch,
	gsub = string.gsub,
	strlen = string.len,
	strlower = string.lower,
	strmatch = string.match,
	strrep = string.rep,
	strrev = string.reverse,
	strsub = string.sub,
	strupper = string.upper,
	-- "custom" string functions
	strtrim = string.trim,
	strsplit = string.split,
	strjoin = string.join,
	
}

for k, v in pairs(aliases) do
	if _G[k] == v and not keepers[k] then
		_G[k] = nil
	end
end

--deprecated functions
table.foreach = nil
table.foreachi = nil
table.getn = nil
_G.gcinfo = nil
_G.getglobal = nil
_G.setglobal = nil

--debug-only C functions
_G.debugbreak = nil
_G.debugdump = nil
_G.debuginfo = nil
_G.debugload = nil
_G.debugprint = nil
_G.debugtimestamp = nil
