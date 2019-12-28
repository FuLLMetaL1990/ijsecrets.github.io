$(document).ready(function () {
  let homeURL = "https://ejelome.com";

  // Change URL icon to homepage:
  $("a.icon.icon-home").attr("href", homeURL);

  // Add homepage links on breadcrumbs:
  $(".wy-breadcrumbs").prepend("<li><a href=\"" + homeURL + "\">Home</a> &raquo;</li>");

  // Replace copyright texts with links:
  let footer = $("footer");
  let licenseURL = "http://creativecommons.org/licenses/by/4.0";
  footer.html(footer.html()
    .replace(/ejelome.com/ig, "<a href=\"" + homeURL + "\">ejelome.com</a>")
    .replace(/Some rights reserved/ig, "<a href=\"" + licenseURL + "\">Some rights reserved</a>"));

  // Change revision text to a link:
  let revision = $("footer .commit code");
  let commitURL = "https://github.com/ejelome/ejelome.com/commit";
  revision.html(revision.html()
                .replace(revision.text(), "<a href=\"" + commitURL + "/" + revision.text() + "\">" + revision.text() + "</a>"));
});
