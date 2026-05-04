local M = {}

local VALID_THINKING_LEVELS = {
  off = true,
  minimal = true,
  low = true,
  medium = true,
  high = true,
  xhigh = true,
}

M.defaults = {
  provider = nil,
  model = nil,
  thinking = "off",
  system_prompt = nil,
  append_system_prompt = nil,
  context = {
    max_bytes = 24000,
    ask = {
      surrounding_lines = 80,
    },
    selection = {
      surrounding_lines = 40,
    },
  },
  skills = true,
  extensions = true,
}

local values = vim.deepcopy(M.defaults)

local function validate_number(name, value)
  if type(value) ~= "number" or value < 1 then
    error(string.format("pi.nvim: %s must be a positive number", name))
  end
end

function M.validate(opts)
  local context = opts.context
  if context ~= nil then
    if type(context) ~= "table" then
      error("pi.nvim: context must be a table")
    end
    if context.max_bytes ~= nil then
      validate_number("context.max_bytes", context.max_bytes)
    end
    if context.ask ~= nil then
      if type(context.ask) ~= "table" then
        error("pi.nvim: context.ask must be a table")
      end
      if context.ask.surrounding_lines ~= nil then
        validate_number("context.ask.surrounding_lines", context.ask.surrounding_lines)
      end
    end
    if context.selection ~= nil then
      if type(context.selection) ~= "table" then
        error("pi.nvim: context.selection must be a table")
      end
      if context.selection.surrounding_lines ~= nil then
        validate_number("context.selection.surrounding_lines", context.selection.surrounding_lines)
      end
    end
  end
  if opts.skills ~= nil and type(opts.skills) ~= "boolean" then
    error("pi.nvim: skills must be a boolean")
  end
  if opts.extensions ~= nil and type(opts.extensions) ~= "boolean" then
    error("pi.nvim: extensions must be a boolean")
  end
  if opts.thinking ~= nil then
    if type(opts.thinking) ~= "string" then
      error("pi.nvim: thinking must be a string")
    end
    if not VALID_THINKING_LEVELS[opts.thinking] then
      error("pi.nvim: thinking must be one of: off, minimal, low, medium, high, xhigh")
    end
  end
  if opts.system_prompt ~= nil and type(opts.system_prompt) ~= "string" then
    error("pi.nvim: system_prompt must be a string")
  end
  if opts.append_system_prompt ~= nil and type(opts.append_system_prompt) ~= "string" then
    error("pi.nvim: append_system_prompt must be a string")
  end
end

function M.setup(opts)
  opts = opts or {}
  M.validate(opts)
  values = vim.tbl_deep_extend("force", vim.deepcopy(M.defaults), opts)
  return values
end

function M.get()
  return values
end

return M
