// import "@hotwired/turbo-rails";
// import { Application } from "@hotwired/stimulus";
import React from "react";
import { createRoot } from "react-dom/client";
import App from "../components/App";

// Stimulus setup
// const application = Application.start();
// window.Stimulus = application;

// React setup
document.addEventListener("DOMContentLoaded", () => {
  const container = document.getElementById("react-app");
  if (container) {
    const root = createRoot(container);
    root.render(<App />);
  }
});
