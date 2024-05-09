1 pragma solidity ^0.4.18;
2 
3 contract DSNote {
4     event LogNote(
5         bytes4   indexed  sig,
6         address  indexed  guy,
7         bytes32  indexed  foo,
8         bytes32  indexed  bar,
9         uint	 	  wad,
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
23         _;
24     }
25 }
26 
27 contract DSAuthority {
28 
29     function canCall(
30         address src, address dst, bytes4 sig
31     ) public constant returns (bool);
32     
33 }
34 
35 contract DSAuthEvents {
36     event LogSetAuthority (address indexed authority);
37     event LogSetOwner     (address indexed owner);
38 }
39 
40 contract DSAuth is DSAuthEvents {
41     DSAuthority  public  authority;
42     address      public  owner;
43 
44     function DSAuth()  public {
45         owner = msg.sender;
46         LogSetOwner(msg.sender);
47     }
48 
49     function setOwner(address owner_)
50         public auth
51     {
52         owner = owner_;
53         LogSetOwner(owner);
54     }
55 
56     function setAuthority(DSAuthority authority_)
57         public auth
58     {
59         authority = authority_;
60         LogSetAuthority(authority);
61     }
62 
63     modifier auth {
64         assert(isAuthorized(msg.sender, msg.sig));
65         _;
66     }
67 
68     modifier authorized(bytes4 sig) {
69         assert(isAuthorized(msg.sender, sig));
70         _;
71     }
72 
73     function isAuthorized(address src, bytes4 sig) internal returns (bool) {
74         if (src == address(this)) {
75             return true;
76         } else if (src == owner) {
77             return true;
78         } else if (authority == DSAuthority(0)) {
79             return false;
80         } else {
81             return authority.canCall(src, this, sig);
82         }
83     }
84 
85     function assert(bool x) internal {
86         require(x);
87     }
88 }
89 
90 contract DSStop is DSAuth, DSNote {
91 
92     bool public stopped;
93 
94     modifier stoppable {
95         assert (!stopped);
96         _;
97     }
98     function stop() public auth note {
99         stopped = true;
100     }
101     function start() public auth note {
102         stopped = false;
103     }
104 }
105 
106 contract DSMath {
107     
108     /*
109     standard uint256 functions
110      */
111 
112     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
113         assert((z = x + y) >= x);
114     }
115 
116     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
117         assert((z = x - y) <= x);
118     }
119 
120     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
121         assert((z = x * y) >= x);
122     }
123 
124     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
125         z = x / y;
126     }
127 
128     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
129         return x <= y ? x : y;
130     }
131     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
132         return x >= y ? x : y;
133     }
134 
135     /*
136     uint128 functions (h is for half)
137      */
138 
139 
140     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
141         assert((z = x + y) >= x);
142     }
143 
144     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
145         assert((z = x - y) <= x);
146     }
147 
148     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
149         assert((z = x * y) >= x);
150     }
151 
152     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
153         z = x / y;
154     }
155 
156     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
157         return x <= y ? x : y;
158     }
159     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
160         return x >= y ? x : y;
161     }
162 
163 
164     /*
165     int256 functions
166      */
167 
168     function imin(int256 x, int256 y) constant internal returns (int256 z) {
169         return x <= y ? x : y;
170     }
171     function imax(int256 x, int256 y) constant internal returns (int256 z) {
172         return x >= y ? x : y;
173     }
174 
175     /*
176     WAD math
177      */
178 
179     uint128 constant WAD = 10 ** 18;
180 
181     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
182         return hadd(x, y);
183     }
184 
185     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
186         return hsub(x, y);
187     }
188 
189     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
190         z = cast((uint256(x) * y + WAD / 2) / WAD);
191     }
192 
193     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
194         z = cast((uint256(x) * WAD + y / 2) / y);
195     }
196 
197     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
198         return hmin(x, y);
199     }
200     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
201         return hmax(x, y);
202     }
203 
204     /*
205     RAY math
206      */
207 
208     uint128 constant RAY = 10 ** 27;
209 
210     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
211         return hadd(x, y);
212     }
213 
214     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
215         return hsub(x, y);
216     }
217 
218     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
219         z = cast((uint256(x) * y + RAY / 2) / RAY);
220     }
221 
222     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
223         z = cast((uint256(x) * RAY + y / 2) / y);
224     }
225 
226     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
227         // This famous algorithm is called "exponentiation by squaring"
228         // and calculates x^n with x as fixed-point and n as regular unsigned.
229         //
230         // It's O(log n), instead of O(n) for naive repeated multiplication.
231         //
232         // These facts are why it works:
233         //
234         //  If n is even, then x^n = (x^2)^(n/2).
235         //  If n is odd,  then x^n = x * x^(n-1),
236         //   and applying the equation for even x gives
237         //    x^n = x * (x^2)^((n-1) / 2).
238         //
239         //  Also, EVM division is flooring and
240         //    floor[(n-1) / 2] = floor[n / 2].
241 
242         z = n % 2 != 0 ? x : RAY;
243 
244         for (n /= 2; n != 0; n /= 2) {
245             x = rmul(x, x);
246 
247             if (n % 2 != 0) {
248                 z = rmul(z, x);
249             }
250         }
251     }
252 
253     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
254         return hmin(x, y);
255     }
256     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
257         return hmax(x, y);
258     }
259 
260     function cast(uint256 x) constant internal returns (uint128 z) {
261         assert((z = uint128(x)) == x);
262     }
263 
264 }
265 
266 contract ERC20 {
267     function totalSupply() constant public returns (uint supply);
268     function balanceOf( address who ) constant public returns (uint value);
269     function allowance( address owner, address spender ) constant public returns (uint _allowance);
270 
271     function transfer( address to, uint value) public returns (bool ok);
272     function transferFrom( address from, address to, uint value) public returns (bool ok);
273     function approve( address spender, uint value ) public returns (bool ok);
274 
275     event Transfer( address indexed from, address indexed to, uint value);
276     event Approval( address indexed owner, address indexed spender, uint value);
277 }
278 
279 contract DSTokenBase is ERC20, DSMath {
280     uint256                                            _supply;
281     mapping (address => uint256)                       _balances;
282     mapping (address => mapping (address => uint256))  _approvals;
283     
284     function DSTokenBase(uint256 supply) public {
285         _balances[msg.sender] = supply;
286         _supply = supply;
287     }
288     
289     function totalSupply() constant public returns (uint256) {
290         return _supply;
291     }
292     
293     function balanceOf(address src) constant public returns (uint256) {
294         return _balances[src];
295     }
296     
297     function allowance(address src, address guy) constant public returns (uint256) {
298         return _approvals[src][guy];
299     }
300     
301     function transfer(address dst, uint wad) public returns (bool) {
302         assert(_balances[msg.sender] >= wad);
303         
304         _balances[msg.sender] = sub(_balances[msg.sender], wad);
305         _balances[dst] = add(_balances[dst], wad);
306         
307         Transfer(msg.sender, dst, wad);
308         
309         return true;
310     }
311     
312     function transferFrom(address src, address dst, uint wad) public returns (bool) {
313         assert(_balances[src] >= wad);
314         assert(_approvals[src][msg.sender] >= wad);
315         
316         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
317         _balances[src] = sub(_balances[src], wad);
318         _balances[dst] = add(_balances[dst], wad);
319         
320         Transfer(src, dst, wad);
321         
322         return true;
323     }
324     
325     function approve(address guy, uint256 wad) public returns (bool) {
326         _approvals[msg.sender][guy] = wad;
327         
328         Approval(msg.sender, guy, wad);
329         
330         return true;
331     }
332 }
333 
334 contract DSToken is DSTokenBase(0), DSStop {
335 
336     string  public  symbol = "QC";
337     uint256  public  decimals = 18; // standard token precision. override to customize
338 
339     function DSToken(string symbol_) public {
340         symbol = symbol_;
341     }
342 
343     function transfer(address dst, uint wad) public stoppable note returns (bool) {
344         return super.transfer(dst, wad);
345     }
346 
347     function transferFrom(
348         address src, address dst, uint wad
349     ) public stoppable note returns (bool) {
350         return super.transferFrom(src, dst, wad);
351     }
352 
353     function approve(address guy, uint wad) public stoppable note returns (bool) {
354         return super.approve(guy, wad);
355     }
356 
357     function push(address dst, uint128 wad) public returns (bool) {
358         return transfer(dst, wad);
359     }
360 
361     function pull(address src, uint128 wad) public returns (bool) {
362         return transferFrom(src, msg.sender, wad);
363     }
364 
365     function mint(uint128 wad) public auth stoppable note {
366         _balances[msg.sender] = add(_balances[msg.sender], wad);
367         _supply = add(_supply, wad);
368     }
369 
370     function burn(uint128 wad) public auth stoppable note {
371         _balances[msg.sender] = sub(_balances[msg.sender], wad);
372         _supply = sub(_supply, wad);
373     }
374 
375     // Optional token name
376     string   public  name = "MixBee Token";
377     
378     function setName(string name_) public auth {
379         name = name_;
380     }
381 
382 }