1 pragma solidity ^0.4.11;
2 
3 contract DSNote {
4     event LogNote(
5         bytes4   indexed  sig,
6         address  indexed  guy,
7         bytes32  indexed  foo,
8         bytes32  indexed  bar,
9 	uint	 	  wad,
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
28 contract DSAuthority {
29     function canCall(
30         address src, address dst, bytes4 sig
31     ) constant returns (bool);
32 }
33 
34 contract DSAuthEvents {
35     event LogSetAuthority (address indexed authority);
36     event LogSetOwner     (address indexed owner);
37 }
38 
39 contract DSAuth is DSAuthEvents {
40     DSAuthority  public  authority;
41     address      public  owner;
42 
43     function DSAuth() {
44         owner = msg.sender;
45         LogSetOwner(msg.sender);
46     }
47 
48     function setOwner(address owner_)
49         auth
50     {
51         owner = owner_;
52         LogSetOwner(owner);
53     }
54 
55     function setAuthority(DSAuthority authority_)
56         auth
57     {
58         authority = authority_;
59         LogSetAuthority(authority);
60     }
61 
62     modifier auth {
63         assert(isAuthorized(msg.sender, msg.sig));
64         _;
65     }
66 
67     modifier authorized(bytes4 sig) {
68         assert(isAuthorized(msg.sender, sig));
69         _;
70     }
71 
72     function isAuthorized(address src, bytes4 sig) internal returns (bool) {
73         if (src == address(this)) {
74             return true;
75         } else if (src == owner) {
76             return true;
77         } else if (authority == DSAuthority(0)) {
78             return false;
79         } else {
80             return authority.canCall(src, this, sig);
81         }
82     }
83 
84     function assert(bool x) internal {
85         if (!x) throw;
86     }
87 }
88 
89 contract DSStop is DSAuth, DSNote {
90 
91     bool public stopped;
92 
93     modifier stoppable {
94         assert (!stopped);
95         _;
96     }
97     function stop() auth note {
98         stopped = true;
99     }
100     function start() auth note {
101         stopped = false;
102     }
103 
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
267     function totalSupply() constant returns (uint supply);
268     function balanceOf( address who ) constant returns (uint value);
269     function allowance( address owner, address spender ) constant returns (uint _allowance);
270 
271     function transfer( address to, uint value) returns (bool ok);
272     function transferFrom( address from, address to, uint value) returns (bool ok);
273     function approve( address spender, uint value ) returns (bool ok);
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
284     function DSTokenBase(uint256 supply) {
285         _balances[msg.sender] = supply;
286         _supply = supply;
287     }
288     
289     function totalSupply() constant returns (uint256) {
290         return _supply;
291     }
292     function balanceOf(address src) constant returns (uint256) {
293         return _balances[src];
294     }
295     function allowance(address src, address guy) constant returns (uint256) {
296         return _approvals[src][guy];
297     }
298     
299     function transfer(address dst, uint wad) returns (bool) {
300         assert(_balances[msg.sender] >= wad);
301         
302         _balances[msg.sender] = sub(_balances[msg.sender], wad);
303         _balances[dst] = add(_balances[dst], wad);
304         
305         Transfer(msg.sender, dst, wad);
306         
307         return true;
308     }
309     
310     function transferFrom(address src, address dst, uint wad) returns (bool) {
311         assert(_balances[src] >= wad);
312         assert(_approvals[src][msg.sender] >= wad);
313         
314         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
315         _balances[src] = sub(_balances[src], wad);
316         _balances[dst] = add(_balances[dst], wad);
317         
318         Transfer(src, dst, wad);
319         
320         return true;
321     }
322     
323     function approve(address guy, uint256 wad) returns (bool) {
324         _approvals[msg.sender][guy] = wad;
325         
326         Approval(msg.sender, guy, wad);
327         
328         return true;
329     }
330 
331 }
332 
333 contract Beebit is DSTokenBase(0), DSStop {
334 
335     bytes32   public  name = "Beebit";
336     bytes32  public  symbol;
337     uint256  public  decimals = 18; // standard token precision. override to customize
338 
339     function Beebit(bytes32 symbol_) {
340         symbol = symbol_;
341     }
342 
343     function transfer(address dst, uint wad) stoppable note returns (bool) {
344         return super.transfer(dst, wad);
345     }
346     function transferFrom(
347         address src, address dst, uint wad
348     ) stoppable note returns (bool) {
349         return super.transferFrom(src, dst, wad);
350     }
351     function approve(address guy, uint wad) stoppable note returns (bool) {
352         return super.approve(guy, wad);
353     }
354 
355     function push(address dst, uint128 wad) returns (bool) {
356         return transfer(dst, wad);
357     }
358     function pull(address src, uint128 wad) returns (bool) {
359         return transferFrom(src, msg.sender, wad);
360     }
361 
362     function mint(uint128 wad) auth stoppable note {
363         _balances[msg.sender] = add(_balances[msg.sender], wad);
364         _supply = add(_supply, wad);
365     }
366     function burn(uint128 wad) auth stoppable note {
367         _balances[msg.sender] = sub(_balances[msg.sender], wad);
368         _supply = sub(_supply, wad);
369     }
370 
371 }