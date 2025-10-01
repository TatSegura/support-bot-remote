document.getElementById("loginForm").addEventListener("submit", function(e) {
  e.preventDefault(); // evita que recargue

  const usuario = document.getElementById("usuario").value;
  const password = document.getElementById("password").value;
  const errorMsg = document.getElementById("errorMsg");

  // Simulación de validación
  if (usuario !== "admin" || password !== "1234") {
    errorMsg.classList.remove("d-none"); // muestra el error
  } else {
    errorMsg.classList.add("d-none"); // oculta el error
    window.location.href = "welcome.jsp"; // redirige al dashboard
  }
});



