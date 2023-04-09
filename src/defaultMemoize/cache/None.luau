local None = newproxy(true)

getmetatable(None).__tostring = function()
	return "<none>"
end

return None
