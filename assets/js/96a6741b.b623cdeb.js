"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[181],{3905:(e,t,n)=>{n.d(t,{Zo:()=>d,kt:()=>h});var a=n(67294);function r(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function o(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);t&&(a=a.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,a)}return n}function i(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?o(Object(n),!0).forEach((function(t){r(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):o(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function l(e,t){if(null==e)return{};var n,a,r=function(e,t){if(null==e)return{};var n,a,r={},o=Object.keys(e);for(a=0;a<o.length;a++)n=o[a],t.indexOf(n)>=0||(r[n]=e[n]);return r}(e,t);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(a=0;a<o.length;a++)n=o[a],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(r[n]=e[n])}return r}var u=a.createContext({}),s=function(e){var t=a.useContext(u),n=t;return e&&(n="function"==typeof e?e(t):i(i({},t),e)),n},d=function(e){var t=s(e.components);return a.createElement(u.Provider,{value:t},e.children)},c="mdxType",m={inlineCode:"code",wrapper:function(e){var t=e.children;return a.createElement(a.Fragment,{},t)}},p=a.forwardRef((function(e,t){var n=e.components,r=e.mdxType,o=e.originalType,u=e.parentName,d=l(e,["components","mdxType","originalType","parentName"]),c=s(n),p=r,h=c["".concat(u,".").concat(p)]||c[p]||m[p]||o;return n?a.createElement(h,i(i({ref:t},d),{},{components:n})):a.createElement(h,i({ref:t},d))}));function h(e,t){var n=arguments,r=t&&t.mdxType;if("string"==typeof e||r){var o=n.length,i=new Array(o);i[0]=p;var l={};for(var u in t)hasOwnProperty.call(t,u)&&(l[u]=t[u]);l.originalType=e,l[c]="string"==typeof e?e:r,i[1]=l;for(var s=2;s<o;s++)i[s]=n[s];return a.createElement.apply(null,i)}return a.createElement.apply(null,n)}p.displayName="MDXCreateElement"},38913:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>u,contentTitle:()=>i,default:()=>m,frontMatter:()=>o,metadata:()=>l,toc:()=>s});var a=n(87462),r=(n(67294),n(3905));const o={},i="Dealing with Immutable data",l={unversionedId:"solutions/immut",id:"solutions/immut",title:"Dealing with Immutable data",description:"One major pain point a lot of Rodux developers have to deal with is that",source:"@site/docs/solutions/immut.md",sourceDirName:"solutions",slug:"/solutions/immut",permalink:"/rodux-utils/docs/solutions/immut",draft:!1,editUrl:"https://github.com/SolarHorizon/rodux-utils/edit/master/docs/solutions/immut.md",tags:[],version:"current",frontMatter:{},sidebar:"defaultSidebar",previous:{title:"About",permalink:"/rodux-utils/docs/intro"},next:{title:"Deriving data from State",permalink:"/rodux-utils/docs/solutions/selectors"}},u={},s=[{value:"Introducing Immut",id:"introducing-immut",level:2},{value:"Returning",id:"returning",level:2},{value:"A value",id:"a-value",level:3},{value:"nil",id:"nil",level:3},{value:"Using the table library",id:"using-the-table-library",level:2},{value:"Opting out",id:"opting-out",level:2}],d={toc:s},c="wrapper";function m(e){let{components:t,...n}=e;return(0,r.kt)(c,(0,a.Z)({},d,n,{components:t,mdxType:"MDXLayout"}),(0,r.kt)("h1",{id:"dealing-with-immutable-data"},"Dealing with Immutable data"),(0,r.kt)("p",null,"One major pain point a lot of Rodux developers have to deal with is that\nworking with immutable state can be cumbersome. Handling it yourself becomes\nincreasingly complicated as the complexity of your state increases. There are\nsome great libraries that help with this, but with them comes a lot of\nboilerplate."),(0,r.kt)("h2",{id:"introducing-immut"},"Introducing Immut"),(0,r.kt)("p",null,(0,r.kt)("a",{parentName:"p",href:"https://github.com/solarhorizon/immut"},"Immut")," can address this problem. With\nImmut, you can write code that ",(0,r.kt)("em",{parentName:"p"},"looks")," like it is mutating your immutable data,\nbut actually isn't. Immut uses a proxy that allows you to alter it directly,\nand only applies your changes to a copy of the original table."),(0,r.kt)("p",null,"Rodux Utils uses Immut in its ",(0,r.kt)("a",{parentName:"p",href:"/api/RoduxUtils#createReducer"},(0,r.kt)("inlineCode",{parentName:"a"},"createReducer")),"\nfunction to allow you to write reducers in this way. Let's take a look at an\nexample to illustrate the differences between Immut and a more common Immutable\ndata library."),(0,r.kt)("p",null,"In this example, we're using Rodux on the server to keep track of multiple\nplayers' inventories. We're going to write a handler for an ",(0,r.kt)("inlineCode",{parentName:"p"},"itemAdded")," action.\nIt'll add the item stored in ",(0,r.kt)("inlineCode",{parentName:"p"},"action.payload"),", to the player's inventory. We'll\nget the UserId of the player from ",(0,r.kt)("inlineCode",{parentName:"p"},"action.meta.userId"),"."),(0,r.kt)("p",null,'Using an Immut "producer":'),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-lua"},"local inventoryReducer = Rodux.createReducer({\n    itemAdded = function(state, action)\n        return Immut.produce(state, function(draft)\n            local inventory = draft.players[action.meta.userId]\n            inventory[action.payload.itemId] = action.payload\n        end)\n    end,\n})\n")),(0,r.kt)("p",null,"Using an existing Immutable data library:"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-lua"},"local inventoryReducer = Rodux.createReducer({\n    itemAdded = function(state, action)\n        return Dictionary.merge(state, {\n            players = Dictionary.merge(state, {\n                [action.meta.userId] = Dictionary.merge(state[action.meta.userId], {\n                    [action.payload.itemId] = action.payload\n                })\n            })\n        })\n    end,\n})\n")),(0,r.kt)("p",null,"As you can see, the Immut-powered reducer is a lot more readable, and was a lot\nsimpler to write. Ultimately, both of these reducers are doing the same thing.\nThey're shallow copying any table you intend to modify, and adding new data to\nthose tables."),(0,r.kt)("p",null,"With the RoduxUtils version of ",(0,r.kt)("inlineCode",{parentName:"p"},"createReducer"),", your handlers are automatically\nwrapped with ",(0,r.kt)("inlineCode",{parentName:"p"},"Immut.produce"),", so you don't need to worry about including it\nyourself. The rest of the examples on this page will be using the RoduxUtils\nversion. We'll refer to this version as an \"Immut reducer\" to keep it simple."),(0,r.kt)("admonition",{type:"tip"},(0,r.kt)("p",{parentName:"admonition"},"From this point onwards, this article will use the callback notation of\n",(0,r.kt)("inlineCode",{parentName:"p"},"RoduxUtils.createReducer")," when creating a reducer. Read the\n",(0,r.kt)("a",{parentName:"p",href:"/api/RoduxUtils#createReducer"},"API section")," on ",(0,r.kt)("inlineCode",{parentName:"p"},"createReducer")," for more info.")),(0,r.kt)("h2",{id:"returning"},"Returning"),(0,r.kt)("h3",{id:"a-value"},"A value"),(0,r.kt)("p",null,"When returning a value from an Immut reducer, the returned value will be used\nas the result rather than the draft. This is useful when we're doing something\nlike discarding the whole state and replacing it with a new one."),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-lua"},'local reducer = RoduxUtils.createReducer(function(builder)\n    builder:addCase("stateReset", function(state, action)\n        return {} -- sets state to {}\n    end)\nend)\n')),(0,r.kt)("h3",{id:"nil"},"nil"),(0,r.kt)("p",null,"Returning nil from an Immut reducer is the same as returning state."),(0,r.kt)("p",null,"All three of the following handlers will have the same result."),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-lua"},'local reducer = RoduxUtils.createReducer(function(builder)\n    builder\n        :addCase("returnState", function(state, action)\n            state.value += 1\n            return state\n        end)\n        :addCase("returnNil", function(state, action)\n            state.value += 1\n            return nil\n        end)\n        :addCase("noReturn", function(state, action)\n            state.value += 1\n        end)\nend)\n')),(0,r.kt)("h2",{id:"using-the-table-library"},"Using the table library"),(0,r.kt)("p",null,"Unfortunately, Lua's (and by extension, Luau's) builtin table library does not\nwork as expected with drafts. To get around this, Immut comes with replacements\nfor ",(0,r.kt)("inlineCode",{parentName:"p"},"table.remove")," and ",(0,r.kt)("inlineCode",{parentName:"p"},"table.insert"),". They are exposed from RoduxUtils as\n",(0,r.kt)("a",{parentName:"p",href:"/api/Draft#remove"},(0,r.kt)("inlineCode",{parentName:"a"},"Draft.remove"))," and ",(0,r.kt)("a",{parentName:"p",href:"/api/Draft#insert"},(0,r.kt)("inlineCode",{parentName:"a"},"Draft.insert")),"."),(0,r.kt)("h2",{id:"opting-out"},"Opting out"),(0,r.kt)("p",null,"None of this is to say that Immut is always better. There may be cases where you\nfind that being explicit is better. In that case, you may opt to write your\nreducer manually. You should always try to use the best tool for the job!"),(0,r.kt)("p",null,"Opting out of Immut for certain handlers is easy. Just call ",(0,r.kt)("inlineCode",{parentName:"p"},"Draft.original")," on\nthe draft state passed into your handler to get the original table. You can\nthen proceeed as you would normally."),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-lua"},'local inventoryReducer = RoduxUtils.createReducer(function(builder)\n    builder:addCase("itemRemoved", function(draft, action)\n        local state = Draft.original(draft)\n        local newState = table.clone(state)\n\n        -- we can now write our reducer without Immut\n\n        return newState\n    end)\nend)\n})\n')),(0,r.kt)("p",null,"You can do this at any point in your handler. It doesn't need to be from the\nstart."))}m.isMDXComponent=!0}}]);