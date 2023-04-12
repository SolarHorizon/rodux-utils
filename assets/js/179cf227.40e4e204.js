"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[722],{3905:(e,t,n)=>{n.d(t,{Zo:()=>c,kt:()=>h});var a=n(67294);function l(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function r(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);t&&(a=a.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,a)}return n}function o(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?r(Object(n),!0).forEach((function(t){l(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):r(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function s(e,t){if(null==e)return{};var n,a,l=function(e,t){if(null==e)return{};var n,a,l={},r=Object.keys(e);for(a=0;a<r.length;a++)n=r[a],t.indexOf(n)>=0||(l[n]=e[n]);return l}(e,t);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);for(a=0;a<r.length;a++)n=r[a],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(l[n]=e[n])}return l}var i=a.createContext({}),u=function(e){var t=a.useContext(i),n=t;return e&&(n="function"==typeof e?e(t):o(o({},t),e)),n},c=function(e){var t=u(e.components);return a.createElement(i.Provider,{value:t},e.children)},m="mdxType",p={inlineCode:"code",wrapper:function(e){var t=e.children;return a.createElement(a.Fragment,{},t)}},d=a.forwardRef((function(e,t){var n=e.components,l=e.mdxType,r=e.originalType,i=e.parentName,c=s(e,["components","mdxType","originalType","parentName"]),m=u(n),d=l,h=m["".concat(i,".").concat(d)]||m[d]||p[d]||r;return n?a.createElement(h,o(o({ref:t},c),{},{components:n})):a.createElement(h,o({ref:t},c))}));function h(e,t){var n=arguments,l=t&&t.mdxType;if("string"==typeof e||l){var r=n.length,o=new Array(r);o[0]=d;var s={};for(var i in t)hasOwnProperty.call(t,i)&&(s[i]=t[i]);s.originalType=e,s[m]="string"==typeof e?e:l,o[1]=s;for(var u=2;u<r;u++)o[u]=n[u];return a.createElement.apply(null,o)}return a.createElement.apply(null,n)}d.displayName="MDXCreateElement"},8273:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>i,contentTitle:()=>o,default:()=>p,frontMatter:()=>r,metadata:()=>s,toc:()=>u});var a=n(87462),l=(n(67294),n(3905));const r={},o="Deriving data from State",s={unversionedId:"solutions/selectors",id:"solutions/selectors",title:"Deriving data from State",description:"Ideally, your Rodux store should contain the least amount of data it possibly",source:"@site/docs/solutions/selectors.md",sourceDirName:"solutions",slug:"/solutions/selectors",permalink:"/rodux-utils/docs/solutions/selectors",draft:!1,editUrl:"https://github.com/SolarHorizon/rodux-utils/edit/master/docs/solutions/selectors.md",tags:[],version:"current",frontMatter:{},sidebar:"defaultSidebar",previous:{title:"Dealing with Immutable data",permalink:"/rodux-utils/docs/solutions/immut"},next:{title:"Organizing your Rodux code",permalink:"/rodux-utils/docs/solutions/slices"}},i={},u=[{value:"Selectors",id:"selectors",level:2},{value:"Memoization &amp; createSelector",id:"memoization--createselector",level:2},{value:"The basics",id:"the-basics",level:3},{value:"Passing arguments",id:"passing-arguments",level:3},{value:"Custom memoization settings",id:"custom-memoization-settings",level:2},{value:"Increasing the cache size",id:"increasing-the-cache-size",level:3},{value:"Reducing recomputations with custom equality checks",id:"reducing-recomputations-with-custom-equality-checks",level:3}],c={toc:u},m="wrapper";function p(e){let{components:t,...n}=e;return(0,l.kt)(m,(0,a.Z)({},c,n,{components:t,mdxType:"MDXLayout"}),(0,l.kt)("h1",{id:"deriving-data-from-state"},"Deriving data from State"),(0,l.kt)("p",null,"Ideally, your Rodux store should contain the least amount of data it possibly\ncan while still being useful as the single source of truth. Any additional data\ncan be derived from that state when you need it. Rodux stores contain global\nstate. They shouldn't be concerned with filtering or sorting data for your UI.\nYour UI should be doing that!"),(0,l.kt)("h2",{id:"selectors"},"Selectors"),(0,l.kt)("p",null,"Selectors are functions that encapsulate the logic for deriving data from\nstate. They allow you to keep your state minimal by shifting the burden of\ncalculating more complicated data to the consumer of the state."),(0,l.kt)("p",null,"We'll use this pattern in the following example to filter some data. Our state\ncontains a list of all of the players ingame right now. We're going to create\na filter that only returns players who are on the blue team."),(0,l.kt)("p",null,"Here's what our state looks like:"),(0,l.kt)("pre",null,(0,l.kt)("code",{parentName:"pre",className:"language-lua"},'local state = {\n    players = {\n        { username = "Alex", team = "green" },\n        { username = "Ben", team = "red" },\n        { username = "Matt", team = "blue" },\n    }\n}\n')),(0,l.kt)("p",null,"And here's how we'll filter it, using a selector:"),(0,l.kt)("pre",null,(0,l.kt)("code",{parentName:"pre",className:"language-lua"},'local function selectBlueTeam(state)\n    local blueTeam = {}\n\n    for _, player in state.players do\n        if player.team == "blue" then\n            table.insert(blueTeam, player)\n        end\n    end\n\n    return blueTeam\nend\n')),(0,l.kt)("p",null,"Now we can get all of the Blue team's players from our state when it changes."),(0,l.kt)("pre",null,(0,l.kt)("code",{parentName:"pre",className:"language-lua"},"-- A Roact component somewhere...\nlocal function blueTeamList(props)\n    local blueTeam = useSelector(selectBlueTeam)\n\n    ...\nend\n")),(0,l.kt)("p",null,"As you can see, this made it pretty easy to get exactly what we were looking\nfor without having to split our state up to accomodate the team feature of our\ngame. We don't need a reducer for teams, we can just derive team data from our\nexisting players reducer."),(0,l.kt)("p",null,"There is a problem with this implementation, though. Every time the store\nupdates, we're going to call that ",(0,l.kt)("inlineCode",{parentName:"p"},"selectBlueTeam")," selector. It might not be\nthat bad with only four players, but as the size of the server expands, that\nfilter is going to become slower. It would be nice if we could only run the\nselector when we needed to."),(0,l.kt)("h2",{id:"memoization--createselector"},"Memoization & createSelector"),(0,l.kt)("h3",{id:"the-basics"},"The basics"),(0,l.kt)("p",null,"Memoization is a technique that prevents calling a pure function when the\nresult would be the same as the last time it was called. It does this by\ncaching the result of the function and the arguments passed to it. Since a\nselector is a pure function, we can use it here! RoduxUtils includes a helper\nfor creating memoized selectors named ",(0,l.kt)("inlineCode",{parentName:"p"},"createSelector"),"."),(0,l.kt)("p",null,"Let's rewrite our ",(0,l.kt)("inlineCode",{parentName:"p"},"selectBlueTeam")," selector using ",(0,l.kt)("inlineCode",{parentName:"p"},"createSelector"),"."),(0,l.kt)("pre",null,(0,l.kt)("code",{parentName:"pre",className:"language-lua"},'local function selectPlayers(state)\n    return state.players\nend\n\nlocal selectBlueTeam = createSelector({ selectPlayers }, function(players)\n    local blueTeam = {}\n\n    for _, player in players do\n        if player.team == "blue" then\n            table.insert(blueTeam, player)\n        end\n    end\n\n    return blueTeam\nend)\n')),(0,l.kt)("p",null,"There's a lot to unpack here! Let's start with the ",(0,l.kt)("inlineCode",{parentName:"p"},"selectPlayers")," function.\nIt's another selector, but it's very simple. Even simpler than our original\n",(0,l.kt)("inlineCode",{parentName:"p"},"selectBlueTeam")," selector."),(0,l.kt)("p",null,"So, what's its purpose here? ",(0,l.kt)("inlineCode",{parentName:"p"},"selectPlayers")," is an input selector. Under the\nhood, ",(0,l.kt)("inlineCode",{parentName:"p"},"createSelector")," is passing the result of ",(0,l.kt)("inlineCode",{parentName:"p"},"selectPlayers")," to our result\nfunction, which, in this case, is the function responsible for actually\nfiltering the players. Since our state is immutable, that means if nothing in\n",(0,l.kt)("inlineCode",{parentName:"p"},"state.players")," has changed, it's going to be the same value that was passed to\nour result function before."),(0,l.kt)("p",null,"That's where memoization kicks in! Since ",(0,l.kt)("inlineCode",{parentName:"p"},"createSelector")," memoizes the result\nfunction for us, it won't run it again unless ",(0,l.kt)("inlineCode",{parentName:"p"},"state.players")," has changed."),(0,l.kt)("h3",{id:"passing-arguments"},"Passing arguments"),(0,l.kt)("p",null,"The usefulness of ",(0,l.kt)("inlineCode",{parentName:"p"},"createSelector")," doesn't end there, though. You can also use\nit to create selectors that are capable of taking more arguments than just\n",(0,l.kt)("inlineCode",{parentName:"p"},"state"),". Our ",(0,l.kt)("inlineCode",{parentName:"p"},"selectBlueTeam")," selector would be a lot more useful if it could\nselect any team we wanted, wouldn't it? Let's rewrite it again with that in\nmind."),(0,l.kt)("pre",null,(0,l.kt)("code",{parentName:"pre",className:"language-lua"},"local function selectPlayers(state)\n    return state.players\nend\n\nlocal function selectTeamName(state, teamName)\n    return teamName\nend\n\nlocal selectTeam = createSelector({\n    selectPlayers,\n    selectTeamName,\n}, function(players, teamName)\n    local team = {}\n\n    for _, player in players do\n        if player.team == teamName then\n            table.insert(team, player)\n        end\n    end\n\n    return team\nend)\n")),(0,l.kt)("p",null,"That'll work, but how do we use it? Where is the ",(0,l.kt)("inlineCode",{parentName:"p"},"teamName")," argument coming\nfrom? When you call a selector created with ",(0,l.kt)("inlineCode",{parentName:"p"},"createSelector"),", it can take as\nmany arguments as you'd like. The first argument should always be your state.\nTo use this selector, we'd call it like so:"),(0,l.kt)("pre",null,(0,l.kt)("code",{parentName:"pre",className:"language-lua"},'    selectTeam(state, "red")\n')),(0,l.kt)("h2",{id:"custom-memoization-settings"},"Custom memoization settings"),(0,l.kt)("h3",{id:"increasing-the-cache-size"},"Increasing the cache size"),(0,l.kt)("p",null,"By default, ",(0,l.kt)("inlineCode",{parentName:"p"},"createSelector")," will only cache the last result. You can tweak this\nto your liking by passing in an additional configuration argument."),(0,l.kt)("pre",null,(0,l.kt)("code",{parentName:"pre",className:"language-lua"},"local selectTeam = createSelector({ selectPlayers }, function(players)\n    ...\nend, {\n    -- set the cache size to 3\n    maxSize = 3,\n})\n")),(0,l.kt)("p",null,"Now we'll cache the last 3 results of our result function. The included\nmemoization function uses an LRU cache when the size is greater than 1."),(0,l.kt)("h3",{id:"reducing-recomputations-with-custom-equality-checks"},"Reducing recomputations with custom equality checks"),(0,l.kt)("p",null,"You can change the function used to check for equality between old and new\narguments that are passed to your selector. This might be useful when the\nresult one of your input selectors has some nested values that you want to pay\nextra attention to."),(0,l.kt)("p",null,"For our example, let's take our selectors for the red and blue team and use\nthem as our inputs. With them, we'll create a new purple team. Since our\nred and blue team selectors return a new table every time we run them, we will\nhave to check the contents of each table to be sure that they're actually\ndifferent. Otherwise, our result function will run every time the players in\nour state change, even if they aren't relevant to the purple team!"),(0,l.kt)("pre",null,(0,l.kt)("code",{parentName:"pre",className:"language-lua"},"local inputSelectors = { selectRedTeam, selectBlueTeam }\n\nlocal selectPurpleTeam = createSelector(inputSelectors, function(red, blue)\n    local purpleTeam = {}\n\n    for _, player in red do\n        table.insert(purpleTeam, player)\n    end\n\n    for _, player in blue do\n        table.insert(purpleTeam, player)\n    end\n\n    return purpleTeam\nend, {\n    -- returns true if red & blue team's players are the same as they were\n    -- the last time the function was called\n    equalityFn = shallowEquals,\n})\n")),(0,l.kt)("p",null,"Nice! We've created a new team just by deriving data from what's available in\nour state."),(0,l.kt)("p",null,"It doesn't end there! There's actually another way to solve this problem. We\ncan use ",(0,l.kt)("inlineCode",{parentName:"p"},"resultEqualityFn")," to check the equality of a result. Remember how we\nhad to use a custom ",(0,l.kt)("inlineCode",{parentName:"p"},"equalityFn")," because our selectors were returning a new\ntable every time? We can avoid that problem entirely this way."),(0,l.kt)("p",null,"We'll only refactor ",(0,l.kt)("inlineCode",{parentName:"p"},"selectBlueTeam")," for now."),(0,l.kt)("pre",null,(0,l.kt)("code",{parentName:"pre",className:"language-lua"},'local function selectPlayers(state)\n    return state.players\nend\n\nlocal selectBlueTeam = createSelector({ selectPlayers }, function(players)\n    local blueTeam = {}\n\n    for _, player in players do\n        if player.team == "blue" then\n            table.insert(blueTeam, player)\n        end\n    end\n\n    return blueTeam\nend, {\n    resultEqualityFn = shallowEquals,\n})\n')),(0,l.kt)("p",null,"That's all it needed! Now, when all of the players on the blue team are the\nsame as they were before, the selector will return the old table instead of a\nnew one. This can help with avoiding unnecessary reconciliation in a Roact\ncomponent, or prevent another selector that uses this one as an input from\nrunning again. Like our ",(0,l.kt)("inlineCode",{parentName:"p"},"selectPurpleTeam")," selector!"),(0,l.kt)("p",null,"If you made this change to the ",(0,l.kt)("inlineCode",{parentName:"p"},"selectRedTeam")," selector as well, you'll have\nsolved the problem that required us to use a shallow comparison for the\narguments passed to the ",(0,l.kt)("inlineCode",{parentName:"p"},"selectPurpleTeam")," selector. Neat!"))}p.isMDXComponent=!0}}]);