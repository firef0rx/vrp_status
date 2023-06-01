Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")

local cvRP = module("vrp", "client/vRP")
vRP = cvRP()

local pvRP = {}
-- load script in vRP context
pvRP.loadScript = module
Proxy.addInterface("vRP", pvRP)

local vRPStatus = class("vRPStatus", vRP.Extension)

local function registerCommands(self)
   RegisterCommand("togglehud", function()
      self:setDisplay(not self.display)
   end)

   RegisterKeyMapping("togglehud", "Toggle Status HUD", "KEYBOARD", "F1")
end

function vRPStatus:__construct()
   vRP.Extension.__construct(self)

   self.cfg = {}
   self.lang = {}
   self.data = {}
   self.display = false
   self.playerPed = PlayerPedId()
   self.playerId = PlayerId()

   async(function ()
      while true do
         if self.cfg.refreshTime == nil then
            print("config nill")
            self:setConfig(self.remote.getConfig())
            Wait(500)
         end

         Wait(self.cfg.refreshTime or 200)

         self:setStatusData(self.remote.getStatusData())

         if not self.playerPed == PlayerPedId() or not self.playerId == PlayerId() then
            self.playerPed = PlayerPedId()
            self.playerId = PlayerId()
         end

         if tonumber(self.data.oxygen) <= 50 then
            self.remote._notify(self.lang.survival.run_out_of_oxigen())
         end

         if tonumber(self.data.food) <= 65 then
            self.remote._notify(self.lang.survival.hungry_warning())
         end

         if tonumber(self.data.water) <= 45 then
            self.remote._notify(self.lang.survival.thirsty_warning())
         end
      end
   end)

   registerCommands(self)
end

local first_toggle = false

function vRPStatus:setStatusData(data)
   if not data then return end

   if not first_toggle then
      first_toggle = true
      self:setDisplay(first_toggle)
   end

   self.data = data

   self.data.health = GetEntityHealth(self.playerPed)
   self.data.armour = GetPedArmour(self.playerPed)
   self.data.oxygen = GetPlayerUnderwaterTimeRemaining(self.playerId) * 10
   self.data.stress = 100 - GetPlayerSprintStaminaRemaining(self.playerId)

   self.data.health = self.data.health - 100

   SendNUIMessage({
      event = "setData",
      health = self.data.health,
      armour = self.data.armour,
      food = self.data.food,
      water = self.data.water,
      oxygen = self.data.oxygen,
      stress = self.data.stress,
   })
end

function vRPStatus:setConfig(cfg, lang)
   self.cfg = cfg
   self.lang = lang
end

function vRPStatus:setDisplay(bool)
   self:setConfig(self.remote.getConfig())
   self.display = bool

   SendNUIMessage({
      event = "toggleUI",
      display = self.display
   })
end

vRPStatus.tunnel = {}
vRPStatus.tunnel.setStatusData = vRPStatus.setStatusData
vRPStatus.tunnel.setDisplay = vRPStatus.setDisplay
vRPStatus.tunnel.setConfig = vRPStatus.setConfig

vRP:registerExtension(vRPStatus)