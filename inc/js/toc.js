//https://stackoverflow.com/questions/187619/is-there-a-javascript-solution-to-generating-a-table-of-contents-for-a-page
//http://magnetiq.com/exports/toc.htm#Tomato
//http://www.whitsoftdev.com/articles/toc.html#section2.1


window.onload = function () {
  var toc = "";
  var level = 0;
  
  document.getElementById("contents").innerHTML =
    document.getElementById("contents").innerHTML.replace(
      /<h([\d])>([^<]+)<\/h([\d])>/gi,
      function (str, openLevel, titleText, closeLevel) {
        if (openLevel != closeLevel) {
          return str;
        }

        if (openLevel > level) {
          toc += (new Array(openLevel - level + 1)).join(""); //<ul>
        } else if (openLevel < level) {
          toc += (new Array(level - openLevel + 1)).join(""); //</ul>
        }

        level = parseInt(openLevel);

        var anchor = titleText.replace(/ /g, "_");
        toc += "<a href=\"#" + anchor + "\">" + titleText
          + "</a><br/>";
        
        return "<h" + openLevel + "><a name=\"" + anchor + "\">"
          + titleText + "</a></h" + closeLevel + ">";
      }
    );

  if (level) {
    toc += (new Array(level + 1)).join(""); //</ul>
  }

  document.getElementById("toc").innerHTML += toc;
};