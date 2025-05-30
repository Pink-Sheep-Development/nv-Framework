document.addEventListener("DOMContentLoaded", () => {
  const bar = document.getElementById("bar");
  let cycle = 0;
  setInterval(() => {
    bar.style.width = (cycle % 2 === 0) ? "100%" : "0%";
    cycle++;
  }, 5000);
});