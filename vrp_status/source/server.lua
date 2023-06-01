local vRPStatus = class("vRPStatus", vRP.Extension)

function vRPStatus:__construct()
   vRP.Extension.__construct(self)

   self.cfg = module("vrp_status", "cfg/cfg")
   self.luang = Luang()
   self.luang:loadLocale(vRP.cfg.lang, module("vrp_status", "cfg/lang/"..vRP.cfg.lang))
   self.lang = self.luang.lang[vRP.cfg.lang]
end

function vRPStatus:getStatusData()
   local user = vRP.users_by_source[source]
   if not user then return end

   local data = {
      health = vRP.EXT.PlayerState.remote.getHealth(user.source),
      armour = vRP.EXT.PlayerState.remote.getArmour(user.source),
      food = user:getVital("food") * 100,
      water = user:getVital("water") * 100
   }

   return data
end

vRPStatus.tunnel = {}
vRPStatus.tunnel.getStatusData = vRPStatus.getStatusData

function vRPStatus.tunnel:notify(text)
   local user = vRP.users_by_source[source]
   if not user then return end

   vRP.EXT.Base.remote._notify(user.source, text)
end

function vRPStatus.tunnel:getConfig()
   return self.cfg, self.lang
end

vRPStatus.event = {}

function vRPStatus.event:characterLoad(user)
   if user then
      local data = {
         food = user:getVital("food") * 100,
         water = user:getVital("water") * 100
      }

      self.remote._setConfig(user.source, self.cfg, self.lang)
      self.remote._setStatusData(user.source, data)
   end
end

function vRPStatus.event:playerVitalChange(user, name)
   if user then
      local data = {
         food = user:getVital("food") * 100,
         water = user:getVital("water") * 100
      }

      self.remote._setStatusData(user.source, data)
   end
end

vRP:registerExtension(vRPStatus)