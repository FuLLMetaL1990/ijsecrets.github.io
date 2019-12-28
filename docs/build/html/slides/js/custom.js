$(document).ready(function () {
  // Prepend a logo on postamble:
  let logo = $("<img />")
  logo
    .attr({
      src: "./img/logo-48x48.png",
      alt: "",
      width: 48,
      height: 48,
    });
  $(".author").prepend(logo);
  $(".reveal section .author img")
    .css({
      border: 0,
      boxShadow: "none",
      margin: "0 12px 0 0",
      position: "relative",
      top: "16px"
    });

  // Wrap author text with a link:
  let author = $("h2.author");
  author.html(author.html()
    .replace(author.text(), "<a href=\"https://ejelome.com\">" + author.text() + "</a>"));

  // Wrap author logo with a link:
  let authorLogo = $("h2.author img")
  authorLogo.wrap("<a href=\"https://ejelome.com\"></a>");
});