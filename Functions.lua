---A basic error handler that outputs debugging information to the developer console.
--This replaces the default error handler, which loads a Blizzard addon that is broken by BlankSlate.
--BlankSlate-aware error handling addons should OptDep BlankSlate and use seterrorhandler() to override this.
--@class function
--@name error
--@param msg Error message.
seterrorhandler(function(msg)
	ConsoleAddMessage("***ERROR***")
	ConsoleAddMessage(msg)
	if debugstack(4) and debugstack(4) ~= "" then
		ConsoleAddMessage("   [@trace]")
		debugstack(4):gsub("[^\n]+", ConsoleAddMessage, 5)
	end
	if debuglocals(4) and debuglocals(4) ~= "" then
		ConsoleAddMessage("   [@locals]")
		debuglocals(4):gsub("[^\n]+", ConsoleAddMessage, 10)
	end
end)

---Prints to the developer console.
--This replaces WoW's default print handler, which outputs to a chat frame that is removed by BlankSlate.
--@param ... Content to print.
function print(...)
	local t = {}
	for i = 1, select('#', ...) do
		t[i] = tostring(select(i, ...))
	end
	ConsoleAddMessage(table.concat(t, "   "))
end
