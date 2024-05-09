1 pragma solidity ^0.4.18;
2 
3 contract ERC20 {
4     function totalSupply() constant public returns (uint supply);
5     function balanceOf( address who ) constant public returns (uint value);
6     function allowance( address owner, address spender ) constant public returns (uint _allowance);
7 
8     function transfer( address to, uint value) public returns (bool ok);
9     function transferFrom( address from, address to, uint value) public returns (bool ok);
10     function approve( address spender, uint value ) public returns (bool ok);
11 
12     event Transfer( address indexed from, address indexed to, uint value);
13     event Approval( address indexed owner, address indexed spender, uint value);
14 }
15 
16 contract DSNote {
17     event LogNote(
18         bytes4   indexed  sig,
19         address  indexed  guy,
20         bytes32  indexed  foo,
21         bytes32  indexed  bar,
22         uint              wad,
23         bytes             fax
24     ) anonymous;
25 
26     modifier note {
27         bytes32 foo;
28         bytes32 bar;
29 
30         assembly {
31             foo := calldataload(4)
32             bar := calldataload(36)
33         }
34 
35         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
36 
37         _;
38     }
39 }
40 
41 contract DSAuthority {
42     function canCall(
43         address src, address dst, bytes4 sig
44     ) constant public returns (bool);
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
56     constructor() public {
57         owner = msg.sender;
58         emit LogSetOwner(msg.sender);
59     }
60 
61     function setOwner(address owner_) public
62         auth
63     {
64         require(owner_ != address(0));
65         
66         owner = owner_;
67         emit LogSetOwner(owner);
68     }
69 
70     function setAuthority(DSAuthority authority_) public
71         auth
72     {
73         authority = authority_;
74         emit LogSetAuthority(authority);
75     }
76 
77     modifier auth {
78         assert(isAuthorized(msg.sender, msg.sig));
79         _;
80     }
81 
82     modifier authorized(bytes4 sig) {
83         assert(isAuthorized(msg.sender, sig));
84         _;
85     }
86 
87     function isAuthorized(address src, bytes4 sig) view internal returns (bool) {
88         if (src == address(this)) {
89             return true;
90         } else if (src == owner) {
91             return true;
92         } else if (authority == DSAuthority(0)) {
93             return false;
94         } else {
95             return authority.canCall(src, this, sig);
96         }
97     }
98 }
99 
100 contract DSStop is DSAuth, DSNote {
101 
102     bool public stopped;
103 
104     modifier stoppable {
105         assert (!stopped);
106         _;
107     }
108     
109     function stop() public auth note {
110         stopped = true;
111     }
112     
113     function start() public auth note {
114         stopped = false;
115     }
116 
117 }
118 
119 contract DSMath {
120     
121     /*
122     standard uint256 functions
123      */
124 
125     function add(uint256 x, uint256 y) pure internal returns (uint256 z) {
126         assert((z = x + y) >= x);
127     }
128 
129     function sub(uint256 x, uint256 y) pure internal returns (uint256 z) {
130         assert((z = x - y) <= x);
131     }
132 
133     function mul(uint256 x, uint256 y) pure internal returns (uint256 z) {
134         assert((z = x * y) >= x);
135     }
136 
137     function div(uint256 x, uint256 y) pure internal returns (uint256 z) {
138         z = x / y;
139     }
140 
141     function min(uint256 x, uint256 y) pure internal returns (uint256 z) {
142         return x <= y ? x : y;
143     }
144     
145     function max(uint256 x, uint256 y) pure internal returns (uint256 z) {
146         return x >= y ? x : y;
147     }
148     
149 
150     /*
151     uint128 functions (h is for half)
152      */
153 
154     function hadd(uint128 x, uint128 y) pure internal returns (uint128 z) {
155         assert((z = x + y) >= x);
156     }
157 
158     function hsub(uint128 x, uint128 y) pure internal returns (uint128 z) {
159         assert((z = x - y) <= x);
160     }
161 
162     function hmul(uint128 x, uint128 y) pure internal returns (uint128 z) {
163         assert((z = x * y) >= x);
164     }
165 
166     function hdiv(uint128 x, uint128 y) pure internal returns (uint128 z) {
167         z = x / y;
168     }
169 
170     function hmin(uint128 x, uint128 y) pure internal returns (uint128 z) {
171         return x <= y ? x : y;
172     }
173     
174     function hmax(uint128 x, uint128 y) pure internal returns (uint128 z) {
175         return x >= y ? x : y;
176     }
177 
178 
179     /*
180     int256 functions
181      */
182 
183     function imin(int256 x, int256 y) pure internal returns (int256 z) {
184         return x <= y ? x : y;
185     }
186     
187     function imax(int256 x, int256 y) pure internal returns (int256 z) {
188         return x >= y ? x : y;
189     }
190 
191     /*
192     WAD math
193      */
194 
195     uint128 constant WAD = 10 ** 18;
196 
197     function wadd(uint128 x, uint128 y) pure internal returns (uint128) {
198         return hadd(x, y);
199     }
200 
201     function wsub(uint128 x, uint128 y) pure internal returns (uint128) {
202         return hsub(x, y);
203     }
204 
205     function wmul(uint128 x, uint128 y) pure internal returns (uint128 z) {
206         z = cast((uint256(x) * y + WAD / 2) / WAD);
207     }
208 
209     function wdiv(uint128 x, uint128 y) pure internal returns (uint128 z) {
210         z = cast((uint256(x) * WAD + y / 2) / y);
211     }
212 
213     function wmin(uint128 x, uint128 y) pure internal returns (uint128) {
214         return hmin(x, y);
215     }
216     
217     function wmax(uint128 x, uint128 y) pure internal returns (uint128) {
218         return hmax(x, y);
219     }
220 
221     /*
222     RAY math
223      */
224 
225     uint128 constant RAY = 10 ** 27;
226 
227     function radd(uint128 x, uint128 y) pure internal returns (uint128) {
228         return hadd(x, y);
229     }
230 
231     function rsub(uint128 x, uint128 y) pure internal returns (uint128) {
232         return hsub(x, y);
233     }
234 
235     function rmul(uint128 x, uint128 y) pure internal returns (uint128 z) {
236         z = cast((uint256(x) * y + RAY / 2) / RAY);
237     }
238 
239     function rdiv(uint128 x, uint128 y) pure internal returns (uint128 z) {
240         z = cast((uint256(x) * RAY + y / 2) / y);
241     }
242 
243     function rpow(uint128 x, uint64 n) pure internal returns (uint128 z) {
244         // This famous algorithm is called "exponentiation by squaring"
245         // and calculates x^n with x as fixed-point and n as regular unsigned.
246         //
247         // It's O(log n), instead of O(n) for naive repeated multiplication.
248         //
249         // These facts are why it works:
250         //
251         //  If n is even, then x^n = (x^2)^(n/2).
252         //  If n is odd,  then x^n = x * x^(n-1),
253         //   and applying the equation for even x gives
254         //    x^n = x * (x^2)^((n-1) / 2).
255         //
256         //  Also, EVM division is flooring and
257         //    floor[(n-1) / 2] = floor[n / 2].
258 
259         z = n % 2 != 0 ? x : RAY;
260 
261         for (n /= 2; n != 0; n /= 2) {
262             x = rmul(x, x);
263 
264             if (n % 2 != 0) {
265                 z = rmul(z, x);
266             }
267         }
268     }
269 
270     function rmin(uint128 x, uint128 y) pure internal returns (uint128) {
271         return hmin(x, y);
272     }
273     
274     function rmax(uint128 x, uint128 y) pure internal returns (uint128) {
275         return hmax(x, y);
276     }
277 
278     function cast(uint256 x) pure internal returns (uint128 z) {
279         assert((z = uint128(x)) == x);
280     }
281 
282 }
283 
284 contract DSTokenBase is ERC20, DSMath {
285     uint256                                            _supply;
286     mapping (address => uint256)                       _balances;
287     mapping (address => mapping (address => uint256))  _approvals;
288     
289     
290     constructor(uint256 supply) public {
291         _balances[msg.sender] = supply;
292         _supply = supply;
293     }
294     
295     function totalSupply() public constant returns (uint256) {
296         return _supply;
297     }
298     
299     function balanceOf(address src) public constant returns (uint256) {
300         return _balances[src];
301     }
302     
303     function allowance(address src, address guy) public constant returns (uint256) {
304         return _approvals[src][guy];
305     }
306     
307     function transfer(address dst, uint wad) public returns (bool) {
308         assert(_balances[msg.sender] >= wad);
309         
310         _balances[msg.sender] = sub(_balances[msg.sender], wad);
311         _balances[dst] = add(_balances[dst], wad);
312         
313         emit Transfer(msg.sender, dst, wad);
314         
315         return true;
316     }
317     
318     function transferFrom(address src, address dst, uint wad) public returns (bool) {
319         assert(_balances[src] >= wad);
320         assert(_approvals[src][msg.sender] >= wad);
321         
322         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
323         _balances[src] = sub(_balances[src], wad);
324         _balances[dst] = add(_balances[dst], wad);
325         
326         emit Transfer(src, dst, wad);
327         
328         return true;
329     }
330     
331     function approve(address guy, uint256 wad) public returns (bool) {
332         _approvals[msg.sender][guy] = wad;
333         
334         emit Approval(msg.sender, guy, wad);
335         
336         return true;
337     }
338 }
339 
340 contract DSToken is DSTokenBase(0), DSStop {
341 
342     string public name = "ERC20 CES";
343     string public symbol = "CES"; // token name
344     uint8  public decimals = 0;   // standard token precision
345 
346     function transfer(address dst, uint wad) public stoppable note returns (bool) {
347         return super.transfer(dst, wad);
348     }
349     
350     function transferFrom(address src, address dst, uint wad) 
351         public stoppable note returns (bool) {
352         return super.transferFrom(src, dst, wad);
353     }
354     
355     function approve(address guy, uint wad) public stoppable note returns (bool) {
356         return super.approve(guy, wad);
357     }
358 
359     function push(address dst, uint128 wad) public returns (bool) {
360         return transfer(dst, wad);
361     }
362     
363     function pull(address src, uint128 wad) public returns (bool) {
364         return transferFrom(src, msg.sender, wad);
365     }
366 
367     function mint(uint128 wad) public auth stoppable note {
368         _balances[msg.sender] = add(_balances[msg.sender], wad);
369         _supply = add(_supply, wad);
370     }
371 
372     function burn(uint128 wad) public auth stoppable note {
373         _balances[msg.sender] = sub(_balances[msg.sender], wad);
374         _supply = sub(_supply, wad);
375     }
376     
377     /*
378     function setName(string name_, string symbol_) public auth {
379         name = name_;
380         symbol = symbol_;
381     }
382     */
383 }