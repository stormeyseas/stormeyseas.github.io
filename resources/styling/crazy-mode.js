// 🤪 Crazy Mode Toggle
(function () {
  var STORAGE_KEY = "crazy-mode";
  var CRAZY_HERO = "/resources/images/Hellish-hero.jpg";

  // Swap hero banner images when toggling crazy mode
  function swapHeroImages(on) {
    var heroes = document.querySelectorAll(".hero-img");
    heroes.forEach(function (el) {
      if (on) {
        // Save the original background-image so we can restore it
        if (!el.dataset.originalBg) {
          el.dataset.originalBg = getComputedStyle(el).backgroundImage;
        }
        el.style.backgroundImage = 'url("' + CRAZY_HERO + '")';
      } else {
        // Restore the original
        if (el.dataset.originalBg) {
          el.style.backgroundImage = el.dataset.originalBg;
          delete el.dataset.originalBg;
        } else {
          el.style.backgroundImage = "";
        }
      }
    });
  }

  function setCrazyMode(on) {
    if (on) {
      document.body.classList.add("crazy-mode");
      localStorage.setItem(STORAGE_KEY, "on");
    } else {
      document.body.classList.remove("crazy-mode");
      localStorage.removeItem(STORAGE_KEY);
    }
    swapHeroImages(on);
  }

  // Restore state from localStorage on every page load
  if (localStorage.getItem(STORAGE_KEY) === "on") {
    // Apply as early as possible to avoid flash
    if (document.body) {
      document.body.classList.add("crazy-mode");
    } else {
      document.addEventListener("DOMContentLoaded", function () {
        document.body.classList.add("crazy-mode");
      });
    }
  }

  // Wait for DOM, then wire up the button and restore hero images
  document.addEventListener("DOMContentLoaded", function () {
    // Re-apply in case the early path didn't fire
    if (localStorage.getItem(STORAGE_KEY) === "on") {
      document.body.classList.add("crazy-mode");
      swapHeroImages(true);
    }

    var btn = document.getElementById("crazy-mode-btn");
    if (btn) {
      btn.addEventListener("click", function () {
        var isOn = document.body.classList.contains("crazy-mode");
        setCrazyMode(!isOn);
      });
    }
  });
})();
