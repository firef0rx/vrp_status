$(function () {
   var vRPStatus = []

   vRPStatus.toggleUI = function (bool) {
      if (bool) {
         $('#container').fadeIn()
      } else {
         $('#container').fadeOut()
      }
   }

   vRPStatus.setData = function (element, value) {
      let height = 25.5;
      let eleHeight = (value / 100) * height;
      let leftOverHeight = height - eleHeight;

      $(element).css("height", eleHeight+"px")
      $(element).css("top", leftOverHeight+"px")
   }

   window.addEventListener("message", function (event) {
      var data = event.data

      if (data.event === "toggleUI" && data.display != null) {
         vRPStatus.toggleUI(data.display)
      }

      if (data.event == "setData") {
         vRPStatus.setData("#boxSetHealth", data.health)
         vRPStatus.setData("#boxSetArmour", data.armour)
         vRPStatus.setData("#boxSetHunger", data.food)
         vRPStatus.setData("#boxSetThirst", data.water)
         vRPStatus.setData("#boxSetOxygen", data.oxygen)
         vRPStatus.setData("#boxSetStress", data.stress)
      }
   })
})