1 pragma solidity ^0.4.11;
2 
3 contract DSNote {
4     event LogNote(
5         bytes4   indexed  sig,
6         address  indexed  guy,
7         bytes32  indexed  foo,
8         bytes32  indexed  bar,
9     uint           wad,
10         bytes             fax
11     ) anonymous;
12 
13     modifier note {
14         bytes32 foo;
15         bytes32 bar;
16 
17         assembly {
18             foo := calldataload(4)
19             bar := calldataload(36)
20         }
21 
22         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
23 
24         _;
25     }
26 }
27 
28 contract ERC20 {
29     function totalSupply() constant returns (uint supply);
30     function balanceOf( address who ) constant returns (uint value);
31     function allowance( address owner, address spender ) constant returns (uint _allowance);
32 
33     function transfer( address to, uint value) returns (bool ok);
34     function transferFrom( address from, address to, uint value) returns (bool ok);
35     function approve( address spender, uint value ) returns (bool ok);
36 
37     event Transfer( address indexed from, address indexed to, uint value);
38     event Approval( address indexed owner, address indexed spender, uint value);
39 }
40 
41 contract DSAuthority {
42     function canCall(
43         address src, address dst, bytes4 sig
44     ) constant returns (bool);
45 }
46 
47 contract DSAuthEvents {
48     event LogSetAuthority (address indexed authority);
49     event LogSetOwner     (address indexed owner);
50 }
51 
52 contract DSAuth is DSAuthEvents {
53     DSAuthority  public  authority;
54     address      public  owner;
55 
56     function DSAuth() {
57         owner = msg.sender;
58         LogSetOwner(msg.sender);
59     }
60 
61     function setOwner(address owner_)
62         auth
63     {
64         owner = owner_;
65         LogSetOwner(owner);
66     }
67 
68     function setAuthority(DSAuthority authority_)
69         auth
70     {
71         authority = authority_;
72         LogSetAuthority(authority);
73     }
74 
75     modifier auth {
76         assert(isAuthorized(msg.sender, msg.sig));
77         _;
78     }
79 
80     modifier authorized(bytes4 sig) {
81         assert(isAuthorized(msg.sender, sig));
82         _;
83     }
84 
85     function isAuthorized(address src, bytes4 sig) internal returns (bool) {
86         if (src == address(this)) {
87             return true;
88         } else if (src == owner) {
89             return true;
90         } else if (authority == DSAuthority(0)) {
91             return false;
92         } else {
93             return authority.canCall(src, this, sig);
94         }
95     }
96 
97     function assert(bool x) internal {
98         if (!x) throw;
99     }
100 }
101 
102 contract DSExec {
103     function tryExec( address target, bytes calldata, uint value)
104              internal
105              returns (bool call_ret)
106     {
107         return target.call.value(value)(calldata);
108     }
109     function exec( address target, bytes calldata, uint value)
110              internal
111     {
112         if(!tryExec(target, calldata, value)) {
113             throw;
114         }
115     }
116 
117     // Convenience aliases
118     function exec( address t, bytes c )
119         internal
120     {
121         exec(t, c, 0);
122     }
123     function exec( address t, uint256 v )
124         internal
125     {
126         bytes memory c; exec(t, c, v);
127     }
128     function tryExec( address t, bytes c )
129         internal
130         returns (bool)
131     {
132         return tryExec(t, c, 0);
133     }
134     function tryExec( address t, uint256 v )
135         internal
136         returns (bool)
137     {
138         bytes memory c; return tryExec(t, c, v);
139     }
140 }
141 
142 contract DSMath {
143     
144     /*
145     standard uint256 functions
146      */
147 
148     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
149         assert((z = x + y) >= x);
150     }
151 
152     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
153         assert((z = x - y) <= x);
154     }
155 
156     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
157         assert((z = x * y) >= x);
158     }
159 
160     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
161         z = x / y;
162     }
163 
164     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
165         return x <= y ? x : y;
166     }
167     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
168         return x >= y ? x : y;
169     }
170 
171     /*
172     uint128 functions (h is for half)
173      */
174 
175 
176     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
177         assert((z = x + y) >= x);
178     }
179 
180     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
181         assert((z = x - y) <= x);
182     }
183 
184     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
185         assert((z = x * y) >= x);
186     }
187 
188     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
189         z = x / y;
190     }
191 
192     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
193         return x <= y ? x : y;
194     }
195     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
196         return x >= y ? x : y;
197     }
198 
199 
200     /*
201     int256 functions
202      */
203 
204     function imin(int256 x, int256 y) constant internal returns (int256 z) {
205         return x <= y ? x : y;
206     }
207     function imax(int256 x, int256 y) constant internal returns (int256 z) {
208         return x >= y ? x : y;
209     }
210 
211     /*
212     WAD math
213      */
214 
215     uint128 constant WAD = 10 ** 18;
216 
217     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
218         return hadd(x, y);
219     }
220 
221     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
222         return hsub(x, y);
223     }
224 
225     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
226         z = cast((uint256(x) * y + WAD / 2) / WAD);
227     }
228 
229     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
230         z = cast((uint256(x) * WAD + y / 2) / y);
231     }
232 
233     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
234         return hmin(x, y);
235     }
236     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
237         return hmax(x, y);
238     }
239 
240     /*
241     RAY math
242      */
243 
244     uint128 constant RAY = 10 ** 27;
245 
246     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
247         return hadd(x, y);
248     }
249 
250     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
251         return hsub(x, y);
252     }
253 
254     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
255         z = cast((uint256(x) * y + RAY / 2) / RAY);
256     }
257 
258     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
259         z = cast((uint256(x) * RAY + y / 2) / y);
260     }
261 
262     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
263         // This famous algorithm is called "exponentiation by squaring"
264         // and calculates x^n with x as fixed-point and n as regular unsigned.
265         //
266         // It's O(log n), instead of O(n) for naive repeated multiplication.
267         //
268         // These facts are why it works:
269         //
270         //  If n is even, then x^n = (x^2)^(n/2).
271         //  If n is odd,  then x^n = x * x^(n-1),
272         //   and applying the equation for even x gives
273         //    x^n = x * (x^2)^((n-1) / 2).
274         //
275         //  Also, EVM division is flooring and
276         //    floor[(n-1) / 2] = floor[n / 2].
277 
278         z = n % 2 != 0 ? x : RAY;
279 
280         for (n /= 2; n != 0; n /= 2) {
281             x = rmul(x, x);
282 
283             if (n % 2 != 0) {
284                 z = rmul(z, x);
285             }
286         }
287     }
288 
289     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
290         return hmin(x, y);
291     }
292     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
293         return hmax(x, y);
294     }
295 
296     function cast(uint256 x) constant internal returns (uint128 z) {
297         assert((z = uint128(x)) == x);
298     }
299 
300 }
301 
302 contract DSStop is DSAuth, DSNote {
303 
304     bool public stopped;
305 
306     modifier stoppable {
307         assert (!stopped);
308         _;
309     }
310     function stop() auth note {
311         stopped = true;
312     }
313     function start() auth note {
314         stopped = false;
315     }
316 
317 }
318 
319 contract DSTokenBase is ERC20, DSMath {
320     uint256                                            _supply;
321     mapping (address => uint256)                       _balances;
322     mapping (address => mapping (address => uint256))  _approvals;
323     
324     function DSTokenBase(uint256 supply) {
325         _balances[msg.sender] = supply;
326         _supply = supply;
327     }
328     
329     function totalSupply() constant returns (uint256) {
330         return _supply;
331     }
332     function balanceOf(address src) constant returns (uint256) {
333         return _balances[src];
334     }
335     function allowance(address src, address guy) constant returns (uint256) {
336         return _approvals[src][guy];
337     }
338     
339     function transfer(address dst, uint wad) returns (bool) {
340         assert(_balances[msg.sender] >= wad);
341         
342         _balances[msg.sender] = sub(_balances[msg.sender], wad);
343         _balances[dst] = add(_balances[dst], wad);
344         
345         Transfer(msg.sender, dst, wad);
346         
347         return true;
348     }
349     
350     function transferFrom(address src, address dst, uint wad) returns (bool) {
351         assert(_balances[src] >= wad);
352         assert(_approvals[src][msg.sender] >= wad);
353         
354         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
355         _balances[src] = sub(_balances[src], wad);
356         _balances[dst] = add(_balances[dst], wad);
357         
358         Transfer(src, dst, wad);
359         
360         return true;
361     }
362     
363     function approve(address guy, uint256 wad) returns (bool) {
364         _approvals[msg.sender][guy] = wad;
365         
366         Approval(msg.sender, guy, wad);
367         
368         return true;
369     }
370 
371 }
372 
373 contract WhiteList {
374     
375     mapping (address => bool)   public  whiteList;
376     
377     address  public  owner;
378     
379     function WhiteList() public {
380         owner = msg.sender;
381         whiteList[owner] = true;
382     }
383     
384     function addToWhiteList(address [] _addresses) public {
385         require(msg.sender == owner);
386         
387         for (uint i = 0; i < _addresses.length; i++) {
388             whiteList[_addresses[i]] = true;
389         }
390     }
391     
392     function removeFromWhiteList(address [] _addresses) public {
393         require (msg.sender == owner);
394         for (uint i = 0; i < _addresses.length; i++) {
395             whiteList[_addresses[i]] = false;
396         }
397     }
398 }
399 
400 contract DSToken is DSTokenBase(0), DSStop {
401 
402     bytes32  public  symbol = "GENEOS";
403     uint256  public  decimals = 18; // standard token precision. override to customize
404     
405     WhiteList public wlcontract;
406 
407     function DSToken(WhiteList wlc_) {
408         require(msg.sender == wlc_.owner());
409         wlcontract = wlc_;
410     }
411 
412     function transfer(address dst, uint wad) stoppable note returns (bool) {
413         require(wlcontract.whiteList(msg.sender));
414         require(wlcontract.whiteList(dst));
415         return super.transfer(dst, wad);
416     }
417     function transferFrom(
418         address src, address dst, uint wad
419     ) stoppable note returns (bool) {
420         require(wlcontract.whiteList(src));
421         require(wlcontract.whiteList(dst));
422         return super.transferFrom(src, dst, wad);
423     }
424     function approve(address guy, uint wad) stoppable note returns (bool) {
425         require(wlcontract.whiteList(msg.sender));
426         require(wlcontract.whiteList(guy));
427         return super.approve(guy, wad);
428     }
429 
430     function push(address dst, uint128 wad) returns (bool) {
431         return transfer(dst, wad);
432     }
433     function pull(address src, uint128 wad) returns (bool) {
434         return transferFrom(src, msg.sender, wad);
435     }
436 
437     function mint(uint128 wad) auth stoppable note {
438         require(wlcontract.whiteList(msg.sender));
439         _balances[msg.sender] = add(_balances[msg.sender], wad);
440         _supply = add(_supply, wad);
441     }
442     function burn(uint128 wad) auth stoppable note {
443         require(wlcontract.whiteList(msg.sender));
444         _balances[msg.sender] = sub(_balances[msg.sender], wad);
445         _supply = sub(_supply, wad);
446     }
447 
448     // Optional token name
449 
450     bytes32   public  name = "";
451     
452     function setName(bytes32 name_) auth {
453         name = name_;
454     }
455 
456 }