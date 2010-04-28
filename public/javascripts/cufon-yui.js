/*
 * Copyright (c) 2009 Simo Kinnunen.
 * Licensed under the MIT license.
 *
 * @version 1.01
 */
var Cufon = (function() {
    var m = function() {
        return m.replace.apply(null, arguments)
    };
    var x = m.DOM = {ready:(function() {
        var C = false,E = {loaded:1,complete:1};
        var B = [],D = function() {
            if (C) {
                return
            }
            C = true;
            for (var F; F = B.shift(); F()) {
            }
        };
        if (document.addEventListener) {
            document.addEventListener("DOMContentLoaded", D, false);
            window.addEventListener("pageshow", D, false)
        }
        if (!window.opera && document.readyState) {
            (function() {
                E[document.readyState] ? D() : setTimeout(arguments.callee, 10)
            })()
        }
        if (document.readyState && document.createStyleSheet) {
            (function() {
                try {
                    document.body.doScroll("left");
                    D()
                } catch(F) {
                    setTimeout(arguments.callee, 1)
                }
            })()
        }
        q(window, "load", D);
        return function(F) {
            if (!arguments.length) {
                D()
            } else {
                C ? F() : B.push(F)
            }
        }
    })(),root:function() {
        return document.documentElement || document.body
    }};
    var n = m.CSS = {Size:function(C, B) {
        this.value = parseFloat(C);
        this.unit = String(C).match(/[a-z%]*$/)[0] || "px";
        this.convert = function(D) {
            return D / B * this.value
        };
        this.convertFrom = function(D) {
            return D / this.value * B
        };
        this.toString = function() {
            return this.value + this.unit
        }
    },addClass:function(C, B) {
        var D = C.className;
        C.className = D + (D && " ") + B;
        return C
    },color:j(function(C) {
        var B = {};
        B.color = C.replace(/^rgba\((.*?),\s*([\d.]+)\)/, function(E, D, F) {
            B.opacity = parseFloat(F);
            return"rgb(" + D + ")"
        });
        return B
    }),fontStretch:j(function(B) {
        if (typeof B == "number") {
            return B
        }
        if (/%$/.test(B)) {
            return parseFloat(B) / 100
        }
        return{"ultra-condensed":0.5,"extra-condensed":0.625,condensed:0.75,"semi-condensed":0.875,"semi-expanded":1.125,expanded:1.25,"extra-expanded":1.5,"ultra-expanded":2}[B] || 1
    }),getStyle:function(C) {
        var B = document.defaultView;
        if (B && B.getComputedStyle) {
            return new a(B.getComputedStyle(C, null))
        }
        if (C.currentStyle) {
            return new a(C.currentStyle)
        }
        return new a(C.style)
    },gradient:j(function(F) {
        var G = {id:F,type:F.match(/^-([a-z]+)-gradient\(/)[1],stops:[]},C = F.substr(F.indexOf("(")).match(/([\d.]+=)?(#[a-f0-9]+|[a-z]+\(.*?\)|[a-z]+)/ig);
        for (var E = 0,B = C.length,D; E < B; ++E) {
            D = C[E].split("=", 2).reverse();
            G.stops.push([D[1] || E / (B - 1),D[0]])
        }
        return G
    }),quotedList:j(function(E) {
        var D = [],C = /\s*((["'])([\s\S]*?[^\\])\2|[^,]+)\s*/g,B;
        while (B = C.exec(E)) {
            D.push(B[3] || B[1])
        }
        return D
    }),recognizesMedia:j(function(G) {
        var E = document.createElement("style"),D,C,B;
        E.type = "text/css";
        E.media = G;
        try {
            E.appendChild(document.createTextNode("/**/"))
        } catch(F) {
        }
        C = g("head")[0];
        C.insertBefore(E, C.firstChild);
        D = (E.sheet || E.styleSheet);
        B = D && !D.disabled;
        C.removeChild(E);
        return B
    }),removeClass:function(D, C) {
        var B = RegExp("(?:^|\\s+)" + C + "(?=\\s|$)", "g");
        D.className = D.className.replace(B, "");
        return D
    },supports:function(D, C) {
        var B = document.createElement("span").style;
        if (B[D] === undefined) {
            return false
        }
        B[D] = C;
        return B[D] === C
    },textAlign:function(E, D, B, C) {
        if (D.get("textAlign") == "right") {
            if (B > 0) {
                E = " " + E
            }
        } else {
            if (B < C - 1) {
                E += " "
            }
        }
        return E
    },textDecoration:function(G, F) {
        if (!F) {
            F = this.getStyle(G)
        }
        var C = {underline:null,overline:null,"line-through":null};
        for (var B = G; B.parentNode && B.parentNode.nodeType == 1;) {
            var E = true;
            for (var D in C) {
                if (!k(C, D) || C[D]) {
                    continue
                }
                if (F.get("textDecoration").indexOf(D) != -1) {
                    C[D] = F.get("color")
                }
                E = false
            }
            if (E) {
                break
            }
            F = this.getStyle(B = B.parentNode)
        }
        return C
    },textShadow:j(function(F) {
        if (F == "none") {
            return null
        }
        var E = [],G = {},B,C = 0;
        var D = /(#[a-f0-9]+|[a-z]+\(.*?\)|[a-z]+)|(-?[\d.]+[a-z%]*)|,/ig;
        while (B = D.exec(F)) {
            if (B[0] == ",") {
                E.push(G);
                G = {};
                C = 0
            } else {
                if (B[1]) {
                    G.color = B[1]
                } else {
                    G[["offX","offY","blur"][C++]] = B[2]
                }
            }
        }
        E.push(G);
        return E
    }),textTransform:(function() {
        var B = {uppercase:function(C) {
            return C.toUpperCase()
        },lowercase:function(C) {
            return C.toLowerCase()
        },capitalize:function(C) {
            return C.replace(/\b./g, function(D) {
                return D.toUpperCase()
            })
        }};
        return function(E, D) {
            var C = B[D.get("textTransform")];
            return C ? C(E) : E
        }
    })(),whiteSpace:(function() {
        var B = {inline:1,"inline-block":1,"run-in":1};
        return function(E, C, D) {
            if (B[C.get("display")]) {
                return E
            }
            if (!D.previousSibling) {
                E = E.replace(/^\s+/, "")
            }
            if (!D.nextSibling) {
                E = E.replace(/\s+$/, "")
            }
            return E
        }
    })()};
    n.ready = (function() {
        var B = !n.recognizesMedia("all"),E = false;
        var D = [],H = function() {
            B = true;
            for (var K; K = D.shift(); K()) {
            }
        };
        var I = g("link"),J = g("style");

        function C(K) {
            return K.disabled || G(K.sheet, K.media || "screen")
        }

        function G(M, P) {
            if (!n.recognizesMedia(P || "all")) {
                return true
            }
            if (!M || M.disabled) {
                return false
            }
            try {
                var Q = M.cssRules,O;
                if (Q) {
                    search:for (var L = 0,K = Q.length; O = Q[L],L < K; ++L) {
                        switch (O.type) {case 2:break;case 3:if (!G(O.styleSheet, O.media.mediaText)) {
                            return false
                        }break;default:break search
                        }
                    }
                }
            } catch(N) {
            }
            return true
        }

        function F() {
            if (document.createStyleSheet) {
                return true
            }
            var L,K;
            for (K = 0; L = I[K]; ++K) {
                if (L.rel.toLowerCase() == "stylesheet" && !C(L)) {
                    return false
                }
            }
            for (K = 0; L = J[K]; ++K) {
                if (!C(L)) {
                    return false
                }
            }
            return true
        }

        x.ready(function() {
            if (!E) {
                E = n.getStyle(document.body).isUsable()
            }
            if (B || (E && F())) {
                H()
            } else {
                setTimeout(arguments.callee, 10)
            }
        });
        return function(K) {
            if (B) {
                K()
            } else {
                D.push(K)
            }
        }
    })();
    function s(C) {
        var B = this.face = C.face;
        this.glyphs = C.glyphs;
        this.w = C.w;
        this.baseSize = parseInt(B["units-per-em"], 10);
        this.family = B["font-family"].toLowerCase();
        this.weight = B["font-weight"];
        this.style = B["font-style"] || "normal";
        this.viewBox = (function() {
            var E = B.bbox.split(/\s+/);
            var D = {minX:parseInt(E[0], 10),minY:parseInt(E[1], 10),maxX:parseInt(E[2], 10),maxY:parseInt(E[3], 10)};
            D.width = D.maxX - D.minX;
            D.height = D.maxY - D.minY;
            D.toString = function() {
                return[this.minX,this.minY,this.width,this.height].join(" ")
            };
            return D
        })();
        this.ascent = -parseInt(B.ascent, 10);
        this.descent = -parseInt(B.descent, 10);
        this.height = -this.ascent + this.descent
    }

    function f() {
        var C = {},B = {oblique:"italic",italic:"oblique"};
        this.add = function(D) {
            (C[D.style] || (C[D.style] = {}))[D.weight] = D
        };
        this.get = function(H, I) {
            var G = C[H] || C[B[H]] || C.normal || C.italic || C.oblique;
            if (!G) {
                return null
            }
            I = {normal:400,bold:700}[I] || parseInt(I, 10);
            if (G[I]) {
                return G[I]
            }
            var E = {1:1,99:0}[I % 100],K = [],F,D;
            if (E === undefined) {
                E = I > 400
            }
            if (I == 500) {
                I = 400
            }
            for (var J in G) {
                if (!k(G, J)) {
                    continue
                }
                J = parseInt(J, 10);
                if (!F || J < F) {
                    F = J
                }
                if (!D || J > D) {
                    D = J
                }
                K.push(J)
            }
            if (I < F) {
                I = F
            }
            if (I > D) {
                I = D
            }
            K.sort(function(M, L) {
                return(E ? (M > I && L > I) ? M < L : M > L : (M < I && L < I) ? M > L : M < L) ? -1 : 1
            });
            return G[K[0]]
        }
    }

    function r() {
        function D(F, G) {
            if (F.contains) {
                return F.contains(G)
            }
            return F.compareDocumentPosition(G) & 16
        }

        function B(G) {
            var F = G.relatedTarget;
            if (!F || D(this, F)) {
                return
            }
            C(this)
        }

        function E(F) {
            C(this)
        }

        function C(F) {
            setTimeout(function() {
                m.replace(F, d.get(F).options, true)
            }, 10)
        }

        this.attach = function(F) {
            if (F.onmouseenter === undefined) {
                q(F, "mouseover", B);
                q(F, "mouseout", B)
            } else {
                q(F, "mouseenter", E);
                q(F, "mouseleave", E)
            }
        }
    }

    function u() {
        var C = [],D = {};

        function B(H) {
            var E = [],G;
            for (var F = 0; G = H[F]; ++F) {
                E[F] = C[D[G]]
            }
            return E
        }

        this.add = function(F, E) {
            D[F] = C.push(E) - 1
        };
        this.repeat = function() {
            var E = arguments.length ? B(arguments) : C,F;
            for (var G = 0; F = E[G++];) {
                m.replace(F[0], F[1], true)
            }
        }
    }

    function A() {
        var D = {},B = 0;

        function C(E) {
            return E.cufid || (E.cufid = ++B)
        }

        this.get = function(E) {
            var F = C(E);
            return D[F] || (D[F] = {})
        }
    }

    function a(B) {
        var D = {},C = {};
        this.extend = function(E) {
            for (var F in E) {
                if (k(E, F)) {
                    D[F] = E[F]
                }
            }
            return this
        };
        this.get = function(E) {
            return D[E] != undefined ? D[E] : B[E]
        };
        this.getSize = function(F, E) {
            return C[F] || (C[F] = new n.Size(this.get(F), E))
        };
        this.isUsable = function() {
            return !!B
        }
    }

    function q(C, B, D) {
        if (C.addEventListener) {
            C.addEventListener(B, D, false)
        } else {
            if (C.attachEvent) {
                C.attachEvent("on" + B, function() {
                    return D.call(C, window.event)
                })
            }
        }
    }

    function v(C, B) {
        var D = d.get(C);
        if (D.options) {
            return C
        }
        if (B.hover && B.hoverables[C.nodeName.toLowerCase()]) {
            b.attach(C)
        }
        D.options = B;
        return C
    }

    function j(B) {
        var C = {};
        return function(D) {
            if (!k(C, D)) {
                C[D] = B.apply(null, arguments)
            }
            return C[D]
        }
    }

    function c(F, E) {
        var B = n.quotedList(E.get("fontFamily").toLowerCase()),D;
        for (var C = 0; D = B[C]; ++C) {
            if (i[D]) {
                return i[D].get(E.get("fontStyle"), E.get("fontWeight"))
            }
        }
        return null
    }

    function g(B) {
        return document.getElementsByTagName(B)
    }

    function k(C, B) {
        return C.hasOwnProperty(B)
    }

    function h() {
        var B = {},D,F;
        for (var E = 0,C = arguments.length; D = arguments[E],E < C; ++E) {
            for (F in D) {
                if (k(D, F)) {
                    B[F] = D[F]
                }
            }
        }
        return B
    }

    function o(E, M, C, N, F, D) {
        var K = document.createDocumentFragment(),H;
        if (M === "") {
            return K
        }
        var L = N.separate;
        var I = M.split(p[L]),B = (L == "words");
        if (B && t) {
            if (/^\s/.test(M)) {
                I.unshift("")
            }
            if (/\s$/.test(M)) {
                I.push("")
            }
        }
        for (var J = 0,G = I.length; J < G; ++J) {
            H = z[N.engine](E, B ? n.textAlign(I[J], C, J, G) : I[J], C, N, F, D, J < G - 1);
            if (H) {
                K.appendChild(H)
            }
        }
        return K
    }

    function l(C, J) {
        var B = n.getStyle(v(C, J)).extend(J);
        var D = c(C, B),E,H,G,F,I;
        for (E = C.firstChild; E; E = G) {
            H = E.nodeType;
            G = E.nextSibling;
            if (H == 3) {
                if (F) {
                    F.appendData(E.data);
                    C.removeChild(E)
                } else {
                    F = E
                }
                if (G) {
                    continue
                }
            }
            if (F) {
                C.replaceChild(o(D, n.whiteSpace(F.data, B, E), B, J, E, C), F);
                F = null
            }
            if (H == 1 && E.firstChild) {
                if (/cufon/.test(E.className)) {
                    z[J.engine](D, null, B, J, E, C)
                } else {
                    arguments.callee(E, J)
                }
            }
        }
    }

    var t = " ".split(/\s+/).length == 0;
    var d = new A();
    var b = new r();
    var y = new u();
    var e = false;
    var z = {},i = {},w = {enableTextDecoration:false,engine:null,forceHitArea:false,hover:false,hoverables:{a:true},printable:true,selector:(window.Sizzle || (window.jQuery && function(B) {
        return jQuery(B)
    }) || (window.dojo && dojo.query) || (window.$$ && function(B) {
        return $$(B)
    }) || (window.$ && function(B) {
        return $(B)
    }) || (document.querySelectorAll && function(B) {
        return document.querySelectorAll(B)
    }) || (window.Ext && Ext.query) || g),separate:"words",textShadow:"none"};
    var p = {words:/[^\S\u00a0]+/,characters:"",none:/^/};
    m.now = function() {
        x.ready();
        return m
    };
    m.refresh = function() {
        y.repeat.apply(y, arguments);
        return m
    };
    m.registerEngine = function(C, B) {
        if (!B) {
            return m
        }
        z[C] = B;
        return m.set("engine", C)
    };
    m.registerFont = function(D) {
        var B = new s(D),C = B.family;
        if (!i[C]) {
            i[C] = new f()
        }
        i[C].add(B);
        return m.set("fontFamily", '"' + C + '"')
    };
    m.replace = function(D, C, B) {
        C = h(w, C);
        if (!C.engine) {
            return m
        }
        if (!e) {
            n.addClass(x.root(), "cufon-active cufon-loading");
            n.ready(function() {
                n.removeClass(x.root(), "cufon-loading")
            });
            e = true
        }
        if (C.hover) {
            C.forceHitArea = true
        }
        if (typeof C.textShadow == "string") {
            C.textShadow = n.textShadow(C.textShadow)
        }
        if (typeof C.color == "string" && /^-/.test(C.color)) {
            C.textGradient = n.gradient(C.color)
        }
        if (!B) {
            y.add(D, arguments)
        }
        if (D.nodeType || typeof D == "string") {
            D = [D]
        }
        n.ready(function() {
            for (var F = 0,E = D.length; F < E; ++F) {
                var G = D[F];
                if (typeof G == "string") {
                    m.replace(C.selector(G), C, true)
                } else {
                    l(G, C)
                }
            }
        });
        return m
    };
    m.set = function(B, C) {
        w[B] = C;
        return m
    };
    return m
})();
Cufon.registerEngine("canvas", (function() {
    var b = document.createElement("canvas");
    if (!b || !b.getContext || !b.getContext.apply) {
        return
    }
    b = null;
    var a = Cufon.CSS.supports("display", "inline-block");
    var e = !a && (document.compatMode == "BackCompat" || /frameset|transitional/i.test(document.doctype.publicId));
    var f = document.createElement("style");
    f.type = "text/css";
    f.appendChild(document.createTextNode((".cufon-canvas{text-indent:0;}@media screen,projection{.cufon-canvas{display:inline;display:inline-block;position:relative;vertical-align:middle;" + (e ? "" : "font-size:1px;line-height:1px;") + "}.cufon-canvas .cufon-alt{display:-moz-inline-box;display:inline-block;width:0;height:0;overflow:hidden;text-indent:-10000in;}" + (a ? ".cufon-canvas canvas{position:relative;}" : ".cufon-canvas canvas{position:absolute;}") + "}@media print{.cufon-canvas{padding:0;}.cufon-canvas canvas{display:none;}.cufon-canvas .cufon-alt{display:inline;}}").replace(/;/g, "!important;")));
    document.getElementsByTagName("head")[0].appendChild(f);
    function d(p, h) {
        var n = 0,m = 0;
        var g = [],o = /([mrvxe])([^a-z]*)/g,k;
        generate:for (var j = 0; k = o.exec(p); ++j) {
            var l = k[2].split(",");
            switch (k[1]) {case"v":g[j] = {m:"bezierCurveTo",a:[n + ~~l[0],m + ~~l[1],n + ~~l[2],m + ~~l[3],n += ~~l[4],m += ~~l[5]]};break;case"r":g[j] = {m:"lineTo",a:[n += ~~l[0],m += ~~l[1]]};break;case"m":g[j] = {m:"moveTo",a:[n = ~~l[0],m = ~~l[1]]};break;case"x":g[j] = {m:"closePath"};break;case"e":break generate
            }
            h[g[j].m].apply(h, g[j].a)
        }
        return g
    }

    function c(m, k) {
        for (var j = 0,h = m.length; j < h; ++j) {
            var g = m[j];
            k[g.m].apply(k, g.a)
        }
    }

    return function(ah, H, Z, D, L, ai) {
        var n = (H === null);
        if (n) {
            H = L.alt
        }
        var J = ah.viewBox;
        var p = Z.getSize("fontSize", ah.baseSize);
        var X = Z.get("letterSpacing");
        X = (X == "normal") ? 0 : p.convertFrom(parseInt(X, 10));
        var K = 0,Y = 0,W = 0,F = 0;
        var I = D.textShadow,U = [];
        if (I) {
            for (var ag = I.length; ag--;) {
                var O = I[ag];
                var T = p.convertFrom(parseFloat(O.offX));
                var R = p.convertFrom(parseFloat(O.offY));
                U[ag] = [T,R];
                if (R < K) {
                    K = R
                }
                if (T > Y) {
                    Y = T
                }
                if (R > W) {
                    W = R
                }
                if (T < F) {
                    F = T
                }
            }
        }
        var al = Cufon.CSS.textTransform(H, Z).split(""),B;
        var o = ah.glyphs,E,r,ac;
        var h = 0,v,N = [];
        for (var ag = 0,ae = 0,ab = al.length; ag < ab; ++ag) {
            E = o[B = al[ag]] || ah.missingGlyph;
            if (!E) {
                continue
            }
            if (r) {
                h -= ac = r[B] || 0;
                N[ae - 1] -= ac
            }
            h += v = N[ae++] = ~~(E.w || ah.w) + X;
            r = E.k
        }
        if (v === undefined) {
            return null
        }
        Y += J.width - v;
        F += J.minX;
        var C,q;
        if (n) {
            C = L;
            q = L.firstChild
        } else {
            C = document.createElement("span");
            C.className = "cufon cufon-canvas";
            C.alt = H;
            q = document.createElement("canvas");
            C.appendChild(q);
            if (D.printable) {
                var ad = document.createElement("span");
                ad.className = "cufon-alt";
                ad.appendChild(document.createTextNode(H));
                C.appendChild(ad)
            }
        }
        var am = C.style;
        var Q = q.style;
        var m = p.convert(J.height);
        var ak = Math.ceil(m);
        var V = ak / m;
        var P = V * Cufon.CSS.fontStretch(Z.get("fontStretch"));
        var S = h * P;
        var aa = Math.ceil(p.convert(S + Y - F));
        var t = Math.ceil(p.convert(J.height - K + W));
        q.width = aa;
        q.height = t;
        Q.width = aa + "px";
        Q.height = t + "px";
        K += J.minY;
        Q.top = Math.round(p.convert(K - ah.ascent)) + "px";
        Q.left = Math.round(p.convert(F)) + "px";
        var A = Math.ceil(p.convert(S)) + "px";
        if (a) {
            am.width = A;
            am.height = p.convert(ah.height) + "px"
        } else {
            am.paddingLeft = A;
            am.paddingBottom = (p.convert(ah.height) - 1) + "px"
        }
        var aj = q.getContext("2d"),M = m / J.height;
        aj.scale(M, M * V);
        aj.translate(-F, -K);
        aj.lineWidth = ah.face["underline-thickness"];
        aj.save();
        function s(i, g) {
            aj.strokeStyle = g;
            aj.beginPath();
            aj.moveTo(0, i);
            aj.lineTo(h, i);
            aj.stroke()
        }

        var u = D.enableTextDecoration ? Cufon.CSS.textDecoration(ai, Z) : {};
        if (u.underline) {
            s(-ah.face["underline-position"], u.underline)
        }
        if (u.overline) {
            s(ah.ascent, u.overline)
        }
        function af() {
            aj.scale(P, 1);
            for (var x = 0,k = 0,g = al.length; x < g; ++x) {
                var y = o[al[x]] || ah.missingGlyph;
                if (!y) {
                    continue
                }
                if (y.d) {
                    aj.beginPath();
                    if (y.code) {
                        c(y.code, aj)
                    } else {
                        y.code = d("m" + y.d, aj)
                    }
                    aj.fill()
                }
                aj.translate(N[k++], 0)
            }
            aj.restore()
        }

        if (I) {
            for (var ag = I.length; ag--;) {
                var O = I[ag];
                aj.save();
                aj.fillStyle = O.color;
                aj.translate.apply(aj, U[ag]);
                af()
            }
        }
        var z = D.textGradient;
        if (z) {
            var G = z.stops,w = aj.createLinearGradient(0, J.minY, 0, J.maxY);
            for (var ag = 0,ab = G.length; ag < ab; ++ag) {
                w.addColorStop.apply(w, G[ag])
            }
            aj.fillStyle = w
        } else {
            aj.fillStyle = Z.get("color")
        }
        af();
        if (u["line-through"]) {
            s(-ah.descent, u["line-through"])
        }
        return C
    }
})());
Cufon.registerEngine("vml", (function() {
    if (!document.namespaces) {
        return
    }
    if (document.namespaces.cvml == null) {
        document.namespaces.add("cvml", "urn:schemas-microsoft-com:vml")
    }
    var b = document.createElement("cvml:shape");
    b.style.behavior = "url(#default#VML)";
    if (!b.coordsize) {
        return
    }
    b = null;
    var f = (document.documentMode || 0) < 8;
    document.write(('<style type="text/css">.cufon-vml-canvas{text-indent:0;}@media screen{cvml\\:shape,cvml\\:rect,cvml\\:fill,cvml\\:shadow{behavior:url(#default#VML);display:block;antialias:true;position:absolute;}.cufon-vml-canvas{position:absolute;text-align:left;}.cufon-vml{display:inline-block;position:relative;vertical-align:' + (f ? "middle" : "text-bottom") + ";}.cufon-vml .cufon-alt{position:absolute;left:-10000in;font-size:1px;}a .cufon-vml{cursor:pointer}}@media print{.cufon-vml *{display:none;}.cufon-vml .cufon-alt{display:inline;}}</style>").replace(/;/g, "!important;"));
    function c(g, h) {
        return a(g, /(?:em|ex|%)$|^[a-z-]+$/i.test(h) ? "1em" : h)
    }

    function a(j, k) {
        if (/px$/i.test(k)) {
            return parseFloat(k)
        }
        var i = j.style.left,h = j.runtimeStyle.left;
        j.runtimeStyle.left = j.currentStyle.left;
        j.style.left = k.replace("%", "em");
        var g = j.style.pixelLeft;
        j.style.left = i;
        j.runtimeStyle.left = h;
        return g
    }

    var e = {};

    function d(n) {
        var o = n.id;
        if (!e[o]) {
            var l = n.stops,m = document.createElement("cvml:fill"),g = [];
            m.type = "gradient";
            m.angle = 180;
            m.focus = "0";
            m.method = "sigma";
            m.color = l[0][1];
            for (var i = 1,h = l.length - 1; i < h; ++i) {
                g.push(l[i][0] * 100 + "% " + l[i][1])
            }
            m.colors = g.join(",");
            m.color2 = l[h][1];
            e[o] = m
        }
        return e[o]
    }

    return function(ai, J, ac, F, N, aj, aa) {
        var n = (J === null);
        if (n) {
            J = N.alt
        }
        var L = ai.viewBox;
        var p = ac.computedFontSize || (ac.computedFontSize = new Cufon.CSS.Size(c(aj, ac.get("fontSize")) + "px", ai.baseSize));
        var Z = ac.computedLSpacing;
        if (Z == undefined) {
            Z = ac.get("letterSpacing");
            ac.computedLSpacing = Z = (Z == "normal") ? 0 : ~~p.convertFrom(a(aj, Z))
        }
        var B,q;
        if (n) {
            B = N;
            q = N.firstChild
        } else {
            B = document.createElement("span");
            B.className = "cufon cufon-vml";
            B.alt = J;
            q = document.createElement("span");
            q.className = "cufon-vml-canvas";
            B.appendChild(q);
            if (F.printable) {
                var af = document.createElement("span");
                af.className = "cufon-alt";
                af.appendChild(document.createTextNode(J));
                B.appendChild(af)
            }
            if (!aa) {
                B.appendChild(document.createElement("cvml:shape"))
            }
        }
        var ao = B.style;
        var U = q.style;
        var h = p.convert(L.height),al = Math.ceil(h);
        var Y = al / h;
        var S = Y * Cufon.CSS.fontStretch(ac.get("fontStretch"));
        var X = L.minX,W = L.minY;
        U.height = al;
        U.top = Math.round(p.convert(W - ai.ascent));
        U.left = Math.round(p.convert(X));
        ao.height = p.convert(ai.height) + "px";
        var u = F.enableTextDecoration ? Cufon.CSS.textDecoration(aj, ac) : {};
        var I = ac.get("color");
        var an = Cufon.CSS.textTransform(J, ac).split(""),A;
        var o = ai.glyphs,G,r,ae;
        var g = 0,O = [],V = 0,w;
        var y,K = F.textShadow;
        for (var ah = 0,ag = 0,ad = an.length; ah < ad; ++ah) {
            G = o[A = an[ah]] || ai.missingGlyph;
            if (!G) {
                continue
            }
            if (r) {
                g -= ae = r[A] || 0;
                O[ag - 1] -= ae
            }
            g += w = O[ag++] = ~~(G.w || ai.w) + Z;
            r = G.k
        }
        if (w === undefined) {
            return null
        }
        var z = -X + g + (L.width - w);
        var am = p.convert(z * S),ab = Math.round(am);
        var R = z + "," + L.height,m;
        var M = "r" + R + "ns";
        var x = F.textGradient && d(F.textGradient);
        for (ah = 0,ag = 0; ah < ad; ++ah) {
            G = o[an[ah]] || ai.missingGlyph;
            if (!G) {
                continue
            }
            if (n) {
                y = q.childNodes[ag];
                while (y.firstChild) {
                    y.removeChild(y.firstChild)
                }
            } else {
                y = document.createElement("cvml:shape");
                q.appendChild(y)
            }
            y.stroked = "f";
            y.coordsize = R;
            y.coordorigin = m = (X - V) + "," + W;
            y.path = (G.d ? "m" + G.d + "xe" : "") + "m" + m + M;
            y.fillcolor = I;
            if (x) {
                y.appendChild(x.cloneNode(false))
            }
            var ak = y.style;
            ak.width = ab;
            ak.height = al;
            if (K) {
                var t = K[0],s = K[1];
                var E = Cufon.CSS.color(t.color),C;
                var Q = document.createElement("cvml:shadow");
                Q.on = "t";
                Q.color = E.color;
                Q.offset = t.offX + "," + t.offY;
                if (s) {
                    C = Cufon.CSS.color(s.color);
                    Q.type = "double";
                    Q.color2 = C.color;
                    Q.offset2 = s.offX + "," + s.offY
                }
                Q.opacity = E.opacity || (C && C.opacity) || 1;
                y.appendChild(Q)
            }
            V += O[ag++]
        }
        var P = y.nextSibling,v,D;
        if (F.forceHitArea) {
            if (!P) {
                P = document.createElement("cvml:rect");
                P.stroked = "f";
                P.className = "cufon-vml-cover";
                v = document.createElement("cvml:fill");
                v.opacity = 0;
                P.appendChild(v);
                q.appendChild(P)
            }
            D = P.style;
            D.width = ab;
            D.height = al
        } else {
            if (P) {
                q.removeChild(P)
            }
        }
        ao.width = Math.max(Math.ceil(p.convert(g * S)), 0);
        if (f) {
            var T = ac.computedYAdjust;
            if (T === undefined) {
                var H = ac.get("lineHeight");
                if (H == "normal") {
                    H = "1em"
                } else {
                    if (!isNaN(H)) {
                        H += "em"
                    }
                }
                ac.computedYAdjust = T = 0.5 * (a(aj, H) - parseFloat(ao.height))
            }
            if (T) {
                ao.marginTop = Math.ceil(T) + "px";
                ao.marginBottom = T + "px"
            }
        }
        return B
    }
})());