-- TENDING THE WAVES
-- play radio Aporee on Norns
-- @maaark
-- after idea of @mlogger @Justmat @infinitedigits
-- !! Requires MPV installed, run 'sudo apt-get install mpv' once, might require 'sudo apt-get update' before!


-- require the `mods` module to gain access to hooks, menu, and other utility
-- functions.
--

local mod=require 'core/mods'

--
-- [optional] a mod is like any normal lua module. local variables can be used
-- to hold any state which needs to be accessible across hooks, the menu, and
-- any api provided by the mod itself.
--
-- here a single table is used to hold some x/y values
--

local state={
  x=0,
}


--
-- [optional] hooks are essentially callbacks which can be used by multiple mods
-- at the same time. each function registered with a hook must also include a
-- name. registering a new function with the name of an existing function will
-- replace the existing function. using descriptive names (which include the
-- name of the mod itself) can help debugging because the name of a callback
-- function will be printed out by matron (making it visible in mainden) before
-- the callback function is called.
--
-- here we have dummy functionality to help confirm things are getting called
-- and test out access to mod level state via mod supplied fuctions.
--

mod.hook.register("system_post_startup","my startup hacks",function()
  state.system_post_startup=true
end)

mod.hook.register("script_pre_init","my init hacks",function()
  -- tweak global environment here ahead of the script `init()` function being called
  print("radio station mod available")
  local debounce=2
  local names={
    "off",
    "aporee",
    "KEXP 90.3FM",
    "WXYC 89.3FM",
    "GD Barton Hall Minglewood Blues",
    "GD Barton Hall Loser",
    "GD Barton Hall El Paso",
    "GD Barton Hall They Love Each Other",
    "GD Barton Hall Jack Straw",
    "GD Barton Hall Deal",
    "GD Barton Hall Lazy Lightning -> Supplication",
    "GD Barton Hall Brown Eyed Women",
    "GD Barton Hall Mama Tried",
    "GD Barton Hall Row Jimmy",
    "GD Barton Hall Dancin in the Streets",
    "GD Barton Hall Take a step back/Tuning",
    "GD Barton Hall Scarlet Begonias -> Fire on the Mountain",
    "GD Barton Hall Estimated Prophet",
    "GD Barton Hall Tuning -> dead air",
    "GD Barton Hall St Stephen",
    "GD Barton Hall Not Fade Away",
    "GD Barton Hall St Stephen",
    "GD Barton Hall Morning Dew",
    "GD Barton Hall Not Fade Away",
  }
  local stations={
    "off",
    "http://radio.aporee.org:8000/aporee_high.m3u",
    "http://live-mp3-128.kexp.org/kexp128.mp3.m3u",
    "http://audio-mp3.ibiblio.org:8000/wxyc.mp3",
    "http://archive.org/download/gd77-05-08.sbd.hicks.4982.sbeok.shnf/gd77-05-08eaton-d1t01.mp3",
    "http://archive.org/download/gd77-05-08.sbd.hicks.4982.sbeok.shnf/gd77-05-08eaton-d1t02.mp3",
    "http://archive.org/download/gd77-05-08.sbd.hicks.4982.sbeok.shnf/gd77-05-08eaton-d1t03.mp3",
    "http://archive.org/download/gd77-05-08.sbd.hicks.4982.sbeok.shnf/gd77-05-08eaton-d1t04.mp3",
    "http://archive.org/download/gd77-05-08.sbd.hicks.4982.sbeok.shnf/gd77-05-08eaton-d1t05.mp3",
    "http://archive.org/download/gd77-05-08.sbd.hicks.4982.sbeok.shnf/gd77-05-08eaton-d1t06.mp3",
    "http://archive.org/download/gd77-05-08.sbd.hicks.4982.sbeok.shnf/gd77-05-08eaton-d1t07.mp3",
    "http://archive.org/download/gd77-05-08.sbd.hicks.4982.sbeok.shnf/gd77-05-08eaton-d1t08.mp3",
    "http://archive.org/download/gd77-05-08.sbd.hicks.4982.sbeok.shnf/gd77-05-08eaton-d1t09.mp3",
    "http://archive.org/download/gd77-05-08.sbd.hicks.4982.sbeok.shnf/gd77-05-08eaton-d2t01.mp3",
    "http://archive.org/download/gd77-05-08.sbd.hicks.4982.sbeok.shnf/gd77-05-08eaton-d2t02.mp3",
    "http://archive.org/download/gd77-05-08.sbd.hicks.4982.sbeok.shnf/gd77-05-08eaton-d2t03.mp3",
    "http://archive.org/download/gd77-05-08.sbd.hicks.4982.sbeok.shnf/gd77-05-08eaton-d2t04.mp3",
    "http://archive.org/download/gd77-05-08.sbd.hicks.4982.sbeok.shnf/gd77-05-08eaton-d3t01.mp3",
    "http://archive.org/download/gd77-05-08.sbd.hicks.4982.sbeok.shnf/gd77-05-08eaton-d3t02.mp3",
    "http://archive.org/download/gd77-05-08.sbd.hicks.4982.sbeok.shnf/gd77-05-08eaton-d3t03.mp3",
    "http://archive.org/download/gd77-05-08.sbd.hicks.4982.sbeok.shnf/gd77-05-08eaton-d3t04.mp3",
    "http://archive.org/download/gd77-05-08.sbd.hicks.4982.sbeok.shnf/gd77-05-08eaton-d3t05.mp3",
    "http://archive.org/download/gd77-05-08.sbd.hicks.4982.sbeok.shnf/gd77-05-08eaton-d3t06.mp3",
    "http://archive.org/download/gd77-05-08.sbd.hicks.4982.sbeok.shnf/gd77-05-08eaton-d3t07.mp3",
  }
  params:add_option("radiostation","RADIO",names,1)
  params:set_action("radiostation",function(x)
    debounce=2
  end)
  clock.run(function()
    while true do
      clock.sleep(0.5)
      if debounce>0 then
        debounce=debounce-1
        if debounce==0 then
          print("debounced")
          if params:get("radiostation")==1 then
            os.execute([[killall -15 mpv]])
          else
            local url=stations[params:get("radiostation")]
            print("loading station "..url)
            os.execute([[killall -15 mpv]])
            io.popen('mpv --no-video --no-terminal --jack-port="crone:input_(1|2)" '..url..' &')
          end
        end
      end
    end
  end)
end)


--
-- [optional] menu: extending the menu system is done by creating a table with
-- all the required menu functions defined.
--

local m={}

m.key=function(n,z)
  if n==2 and z==1 then
    -- return to the mod selection menu
    mod.menu.exit()
  end
end

m.enc=function(n,d)
  -- tell the menu system to redraw, which in turn calls the mod's menu redraw
  -- function
  mod.menu.redraw()
end

m.redraw=function()
  screen.clear()
--  screen.move(64,40)
--  screen.text_center("radio aporee  "..state.x)
  screen.update()
end

m.init=function()

end -- on menu entry, ie, if you wanted to start timers

m.deinit=function() end -- on menu exit

-- register the mod menu
--
-- NOTE: `mod.this_name` is a convienence variable which will be set to the name
-- of the mod which is being loaded. in order for the menu to work it must be
-- registered with a name which matches the name of the mod in the dust folder.
--
mod.menu.register(mod.this_name,m)


--
-- [optional] returning a value from the module allows the mod to provide
-- library functionality to scripts via the normal lua `require` function.
--
-- NOTE: it is important for scripts to use `require` to load mod functionality
-- instead of the norns specific `include` function. using `require` ensures
-- that only one copy of the mod is loaded. if a script were to use `include`
-- new copies of the menu, hook functions, and state would be loaded replacing
-- the previous registered functions/menu each time a script was run.
--
-- here we provide a single function which allows a script to get the mod's
-- state table. using this in a script would look like:
--
-- local mod = require 'name_of_mod/lib/mod'
-- local the_state = mod.get_state()
--
local api={}

api.get_state=function()
  return state
end

return api


