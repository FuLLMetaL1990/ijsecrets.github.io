// Global functions:
var createLink = function (href) {
  /*
   * Convenience function to create link tag.
   */
  var link = document.createElement("link");
  link.rel = "stylesheet";
  link.href = href;
  return link;
};

var createScript = function (src) {
  /*
   * Convenience function to create script tag.
   */
  var script = document.createElement("script");
  script.src = src;
  script.async = false;
  return script;
};

var disqus = function () {
  /*
   * Load disqus lazily.
   */
  if (!disqus_loaded) {
    disqus_loaded = true;

    var e = document.createElement("script");
    e.type = "text/javascript";
    e.async = true;
    e.src = "//" + disqus_shortname + ".disqus.com/embed.js";
    (document.getElementsByTagName("head")[0] ||
      document.getElementsByTagName("body")[0])
    .appendChild(e);

    // Hide the button after opening
    document.getElementById("show-comments").style.display = "none";
  }
};

var footnoteBackRef = function (fnId) {
  /*
   * Highlight corresponding footnote-backref.
   */
  var target = $(".footnotes li" + fnId + " p a:first-child");
  $(".footnotes .active").removeClass("active");
  $("sup").prev("em").css({
    fontStyle: "normal"
  }).removeClass("active");

  if (target.length) {
    target.addClass("active");
  }
};

var footnote = function (fnId) {
  /*
   * Highlight corresponding footnote text.
   */
  var target = $("sup" + fnId);
  $(".footnotes .active").removeClass("active");
  $("sup").prev("em").css({
    fontStyle: "normal"
  }).removeClass("active");

  if (target.length) {
    target.prev("em").addClass("active");
  }
};

// Load assets:
window.addEventListener("DOMContentLoaded", function (e) {
  // Load stylesheets:
  var stylesheets = [
    "//fonts.googleapis.com/css?family=Lobster+Two|Roboto+Slab|Ruda",
    "//cdnjs.cloudflare.com/ajax/libs/normalize/8.0.0/normalize.min.css",
    "//cdnjs.cloudflare.com/ajax/libs/jquery.basictable/1.0.9/basictable.min.css",
  ].reverse().forEach(function (href) {
    document.head.prepend(createLink(href));
  });

  // Load scripts:
  scripts = [
    "//code.jquery.com/jquery-3.4.1.min.js",
    "//cdnjs.cloudflare.com/ajax/libs/jquery.basictable/1.0.9/jquery.basictable.min.js",
    "//cdnjs.cloudflare.com/ajax/libs/anchor-js/4.2.0/anchor.min.js",
    "//kit.fontawesome.com/98dccab853.js",
  ].forEach(function (src) {
    document.body.appendChild(createScript(src));
  });
});

// On load:
window.addEventListener("load", function (e) {
  $(document).ready(function () {
    // set TOC height:
    var pageHeight = $(window).innerHeight();
    $(".toc > nav").css({
      maxHeight: (pageHeight - (48 * 8.3)) + "px",
      overflow: "auto",
    });

    // Hide TOC if screen < 960px:
    if ($(window).width() <= 960) {
      $(".toc").remove();
    } else {
      // Distinguish parent from children:
      $(".toc > nav > ul").addClass("parent");
      $(".toc > nav > ul > li > ul").addClass("child");

      // Highlight on scroll:
      $(window).scroll(function () {
        var currentOffset = $(window).scrollTop();
        var sidebarHeight = $(".toc").outerHeight();

        // Sticky TOC:
        $(".toc").css({
          position: "sticky",
          marginBottom: "-" + sidebarHeight + "px",
        });

        // Highlight TOC if aligned to heading:
        $(":header").each(function () {
          var h = $(this);

          var hTopOffsets = [
            parseInt(h.css("border-top")),
            parseInt(h.css("margin-top")),
            parseInt(h.css("padding-top")),
          ].reduce(function (n, a) {
            return n + a;
          }, 0);
          var hId = h.attr("id");
          var tocLink = $(".toc a[href=\"#" + hId + "\"]");
          var offset = $("#" + hId).offset().top - hTopOffsets;

          if (currentOffset >= offset) {
            // Remove active class on un-focused links:
            $(".toc .active").removeClass("active");
            // Add active class on focused link:
            tocLink.addClass("active");
          }
        });
      });
    }

    // Specify content images actual width and height:
    $(".main img").each(function () {
      $(this)
        .attr("width", this.naturalWidth)
        .attr("height", this.naturalHeight)
        .attr("alt", "Website Author");
    });

    // Reset footnotes:
    $(".footnotes .active").removeClass("active");
    $("sup").prev("em").css({
      fontStyle: "normal"
    }).removeClass("active");

    // Wrap footnotes with brackets:
    $(".footnote-ref").each(function () {
      var fn = $(this);
      var text = fn.text();
      fn.text("[" + text + "]");
    });

    // Change footnotes backref to superscript:
    $(".footnote-backref").each(function () {
      $(this).text("^");
    });

    // Append a footnotes header:
    var footnotesHeader = $("<h2 id=\"footnotes\">Footnotes</h2>");
    footnotesHeader.insertAfter(".footnotes hr");

    // Highlight corresponding footnote-backref:
    $(".footnote-backref").each(function () {
      var e = $(this);
      var fnId = e.attr("href").replace(":", "\\:");
      e.click(function () {
        footnote(fnId);
      });
    });

    // Highlight corresponding footnote text:
    $(".footnote-ref").each(function () {
      var e = $(this);
      var fnId = e.attr("href").replace(":", "\\:");
      e.click(function () {
        footnoteBackRef(fnId);
      });
    });

    // Highlight footnote depending on hash:
    if (location.hash) {
      $(".footnotes .footnote-backref").each(function () {
        var e = $(this);
        var eId = e.attr("href");

        if (eId === location.hash) {
          eId = eId.replace(":", "\\:");
          footnote(eId);
        }
      });

      $("sup a").each(function () {
        var e = $(this);
        var eId = e.attr("href");

        if (eId === location.hash) {
          eId = eId.replace(":", "\\:");
          footnoteBackRef(eId);
        }
      });
    }

    // Remove summary links on homepage:
    $("body.list .main sup").remove();

    // Add external link icon on external links
    $(".main a[href^=\"http\"").each(function () {
      var extLink = $("<sup class=\"external-link\"><i class=\"fas fa-external-link-alt\"></i></sup>");
      $(this).append(extLink);
    });

    // Remove empty paragraphs:
    $("p").each(function () {
      if ($(this).is(":empty")) {
        this.remove();
      }
    });

    // Responsive tables:
    $("table").basictable();

    // Modify headings:
    // Add anchors on headings (config):
    anchors.options = {
      visible: "always",
      placement: "left"
    };

    $(".main :header").each(function () {
      // Change heading cursor to pointer:
      var h = $(this);

      h.css({
        cursor: "pointer"
      });

      // Add anchors on headings (heading):
      var hTag = h.prop("tagName").toLowerCase();
      anchors.add(".main " + hTag);

      // Update URL hash on click:
      var hId = "#" + h.attr("id");

      h.click(function () {
        location.hash = hId;
        $(".anchorjs-link.active").removeClass("active");
        $(hId + " .anchorjs-link").addClass("active");
      });

      if (hId === location.hash) {
        // Highlight currently selected hash:
        $(hId + " .anchorjs-link").addClass("active");
      }
    });

    // Scroll to matching hash URL:
    if (location.hash) {
      $(":header").each(function () {
        var h = $(this);
        var hId = "#" + h.attr("id");

        if (hId === location.hash) {
          $(hId).get(0).scrollIntoView();
          $(window).scrollTop($(window).scrollTop() - 1);
        }
      });
    }

    // Disqus:
    // Don't ever inject Disqus on localhost--it creates unwanted
    // discussions from "localhost:1313" on your Disqus account ...
    if (window.location.hostname === "localhost") return;

    var data = $("#disqus_thread").data();
    var disqus_loaded = false;
    var disqus_shortname = data.disqus_shortname;
    var disqus_button = document.getElementById("show-comments");

    disqus_button.style.display = "";
    disqus_button.addEventListener("click", disqus, false);

    // Opens comments when linked to directly:
    var hash = window.location.hash.substr(1);
    if (hash.length > 8) {
      if (hash.substring(0, 8) === "comment-") {
        disqus();
      }
    }

    // Remove this is you don't want to load comments for search engines:
    if (/bot|google|baidu|bing|msn|duckduckgo|slurp|yandex/i.test(navigator.userAgent)) {
      disqus();
    }
  });
});
