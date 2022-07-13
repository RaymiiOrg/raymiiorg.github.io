<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:dc="http://purl.org/dc/elements/1.1/">
    <xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title><xsl:value-of select="/rss/channel/title"/></title>
                <meta charset="UTF-8" />
                <meta http-equiv="x-ua-compatible" content="IE=edge,chrome=1" />
                <meta name="viewport" content="width=device-width,minimum-scale=1,initial-scale=1,shrink-to-fit=no" />
                <style>
                    body{
                        font-family:system-ui;
                        font-size: 16px;
                        margin: 0 auto;
                        max-width: 653px;
                        padding: 10px;
                        background-color: #ffffff;
                    }
                    nav ul {
                        list-style: none;
                        padding: 0;
                    }
                    nav ul li {
                        display: inline-block;
                        margin-right: 10px;
                    }
                    h1 {
                        border-bottom: 1px solid lightgrey;
                        margin-bottom: 0;
                        padding-bottom: 0.5em;
                    }
                    .date{
                        display: block;
                        font-family: monospace;
                        margin-top: 1em;
                        overflow: hidden;
                        white-space: nowrap;
                        width: 16ch;
                    }
                </style>
            </head>
            <body>
                <nav>
                    <ul>
                        <li><a href="/s/">Home</a></li>
                        <li><a href="/s/static/About.html">About</a></li>
                        <li>Feed styling via: <a href="https://tdarb.org/blog/rss-click.html">tdarb.org</a>.</li>
                    </ul>
                </nav>
                <h1><xsl:value-of select="/rss/channel/title"/></h1>
                <xsl:for-each select="/rss/channel/item">
                    <xsl:sort select="category" order="descending"/>
                        <span class="date"><xsl:value-of select="pubDate" /></span>
                        <xsl:element name="a">
                            <xsl:attribute name="href">
                                <xsl:value-of select="link"/>
                            </xsl:attribute>
                            <span><xsl:value-of select="title"/></span>
                        </xsl:element>
                </xsl:for-each>                
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
