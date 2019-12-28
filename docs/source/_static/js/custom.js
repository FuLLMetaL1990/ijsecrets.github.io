$(document).ready(function () {
  // Replace copyright texts with links:
  let footer = $("footer");
  footer.html(footer.html()
    .replace(/ejelome.com/ig, "<a href=\"https://ejelome.com\">ejelome.com</a>")
    .replace(/Some rights reserved/ig, "<a href=\"http://creativecommons.org/licenses/by/4.0\">Some rights reserved</a>"));

  // Change revision text to a link:
  let revision = $("footer .commit code");
  revision.html(revision.html()
    .replace(revision.text(), "<a href=\"https://github.com/ejelome/ejelome.com/commit/" + revision.text() + "\">" + revision.text() + "</a>"));
});
