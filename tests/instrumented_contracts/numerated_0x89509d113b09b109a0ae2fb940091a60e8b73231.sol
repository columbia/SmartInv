1 contract DSNote {
2     event LogNote(
3         bytes4   indexed  sig,
4         address  indexed  guy,
5         bytes32  indexed  foo,
6         bytes32  indexed  bar,
7 	uint	 	  wad,
8         bytes             fax
9     ) anonymous;
10 
11     modifier note {
12         bytes32 foo;
13         bytes32 bar;
14 
15         assembly {
16             foo := calldataload(4)
17             bar := calldataload(36)
18         }
19 
20         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
21 
22         _;
23     }
24 }
25 
26 contract DSAuthority {
27     function canCall(
28         address src, address dst, bytes4 sig
29     ) constant returns (bool);
30 }
31 
32 contract DSAuthEvents {
33     event LogSetAuthority (address indexed authority);
34     event LogSetOwner     (address indexed owner);
35 }
36 
37 contract DSAuth is DSAuthEvents {
38     DSAuthority  public  authority;
39     address      public  owner;
40 
41     function DSAuth() {
42         owner = msg.sender;
43         LogSetOwner(msg.sender);
44     }
45 
46     function setOwner(address owner_)
47         auth
48     {
49         owner = owner_;
50         LogSetOwner(owner);
51     }
52 
53     function setAuthority(DSAuthority authority_)
54         auth
55     {
56         authority = authority_;
57         LogSetAuthority(authority);
58     }
59 
60     modifier auth {
61         assert(isAuthorized(msg.sender, msg.sig));
62         _;
63     }
64 
65     modifier authorized(bytes4 sig) {
66         assert(isAuthorized(msg.sender, sig));
67         _;
68     }
69 
70     function isAuthorized(address src, bytes4 sig) internal returns (bool) {
71         if (src == address(this)) {
72             return true;
73         } else if (src == owner) {
74             return true;
75         } else if (authority == DSAuthority(0)) {
76             return false;
77         } else {
78             return authority.canCall(src, this, sig);
79         }
80     }
81 
82     function assert(bool x) internal {
83         if (!x) throw;
84     }
85 }
86 
87 contract DSMath {
88     
89     /*
90     standard uint256 functions
91      */
92 
93     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
94         assert((z = x + y) >= x);
95     }
96 
97     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
98         assert((z = x - y) <= x);
99     }
100 
101     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
102         assert((z = x * y) >= x);
103     }
104 
105     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
106         z = x / y;
107     }
108 
109     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
110         return x <= y ? x : y;
111     }
112     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
113         return x >= y ? x : y;
114     }
115 
116     /*
117     uint128 functions (h is for half)
118      */
119 
120 
121     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
122         assert((z = x + y) >= x);
123     }
124 
125     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
126         assert((z = x - y) <= x);
127     }
128 
129     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
130         assert((z = x * y) >= x);
131     }
132 
133     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
134         z = x / y;
135     }
136 
137     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
138         return x <= y ? x : y;
139     }
140     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
141         return x >= y ? x : y;
142     }
143 
144 
145     /*
146     int256 functions
147      */
148 
149     function imin(int256 x, int256 y) constant internal returns (int256 z) {
150         return x <= y ? x : y;
151     }
152     function imax(int256 x, int256 y) constant internal returns (int256 z) {
153         return x >= y ? x : y;
154     }
155 
156     /*
157     WAD math
158      */
159 
160     uint128 constant WAD = 10 ** 18;
161 
162     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
163         return hadd(x, y);
164     }
165 
166     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
167         return hsub(x, y);
168     }
169 
170     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
171         z = cast((uint256(x) * y + WAD / 2) / WAD);
172     }
173     function wmulfloor(uint128 x, uint128 y) constant internal returns (uint128 z) {
174         z = cast((uint256(x) * y) / WAD);
175     }
176 
177     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
178         z = cast((uint256(x) * WAD + y / 2) / y);
179     }
180     function wdivfloor(uint128 x, uint128 y) constant internal returns (uint128 z) {
181         z = cast((uint256(x) * WAD) / y);
182     }
183 
184     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
185         return hmin(x, y);
186     }
187     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
188         return hmax(x, y);
189     }
190 
191     /*
192     RAY math
193      */
194 
195     uint128 constant RAY = 10 ** 27;
196 
197     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
198         return hadd(x, y);
199     }
200 
201     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
202         return hsub(x, y);
203     }
204 
205     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
206         z = cast((uint256(x) * y + RAY / 2) / RAY);
207     }
208 
209     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
210         z = cast((uint256(x) * RAY + y / 2) / y);
211     }
212 
213     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
214         // This famous algorithm is called "exponentiation by squaring"
215         // and calculates x^n with x as fixed-point and n as regular unsigned.
216         //
217         // It's O(log n), instead of O(n) for naive repeated multiplication.
218         //
219         // These facts are why it works:
220         //
221         //  If n is even, then x^n = (x^2)^(n/2).
222         //  If n is odd,  then x^n = x * x^(n-1),
223         //   and applying the equation for even x gives
224         //    x^n = x * (x^2)^((n-1) / 2).
225         //
226         //  Also, EVM division is flooring and
227         //    floor[(n-1) / 2] = floor[n / 2].
228 
229         z = n % 2 != 0 ? x : RAY;
230 
231         for (n /= 2; n != 0; n /= 2) {
232             x = rmul(x, x);
233 
234             if (n % 2 != 0) {
235                 z = rmul(z, x);
236             }
237         }
238     }
239 
240     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
241         return hmin(x, y);
242     }
243     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
244         return hmax(x, y);
245     }
246 
247     function cast(uint256 x) constant internal returns (uint128 z) {
248         assert((z = uint128(x)) == x);
249     }
250 
251 }
252 
253 contract ERC20 {
254     function totalSupply() constant returns (uint supply);
255     function balanceOf( address who ) constant returns (uint value);
256     function allowance( address owner, address spender ) constant returns (uint _allowance);
257 
258     function transfer( address to, uint value) returns (bool ok);
259     function transferFrom( address from, address to, uint value) returns (bool ok);
260     function approve( address spender, uint value ) returns (bool ok);
261 
262     event Transfer( address indexed from, address indexed to, uint value);
263     event Approval( address indexed owner, address indexed spender, uint value);
264 }
265 
266 contract DSTokenBase is ERC20, DSMath {
267     uint256                                            _supply;
268     mapping (address => uint256)                       _balances;
269     mapping (address => mapping (address => uint256))  _approvals;
270     
271     function DSTokenBase(uint256 supply) {
272         _balances[msg.sender] = supply;
273         _supply = supply;
274     }
275     
276     function totalSupply() constant returns (uint256) {
277         return _supply;
278     }
279     function balanceOf(address src) constant returns (uint256) {
280         return _balances[src];
281     }
282     function allowance(address src, address guy) constant returns (uint256) {
283         return _approvals[src][guy];
284     }
285     
286     function transfer(address dst, uint wad) returns (bool) {
287         assert(_balances[msg.sender] >= wad);
288         
289         _balances[msg.sender] = sub(_balances[msg.sender], wad);
290         _balances[dst] = add(_balances[dst], wad);
291         
292         Transfer(msg.sender, dst, wad);
293         
294         return true;
295     }
296     
297     function transferFrom(address src, address dst, uint wad) returns (bool) {
298         assert(_balances[src] >= wad);
299         assert(_approvals[src][msg.sender] >= wad);
300         
301         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
302         _balances[src] = sub(_balances[src], wad);
303         _balances[dst] = add(_balances[dst], wad);
304         
305         Transfer(src, dst, wad);
306         
307         return true;
308     }
309     
310     function approve(address guy, uint256 wad) returns (bool) {
311         _approvals[msg.sender][guy] = wad;
312         
313         Approval(msg.sender, guy, wad);
314         
315         return true;
316     }
317 
318 }
319 
320 contract DSToken is DSTokenBase, DSAuth, DSNote {
321 
322     bytes32  public  symbol;
323     uint256  public  decimals = 18; // standard token precision. override to customize
324 
325     function DSToken(bytes32 symbol_, uint256 supply_) DSTokenBase(supply_) {
326         symbol = symbol_;
327     }
328 
329     function transfer(address dst, uint wad) note returns (bool) {
330         return super.transfer(dst, wad);
331     }
332     function transferFrom(
333         address src, address dst, uint wad
334     ) note returns (bool) {
335         return super.transferFrom(src, dst, wad);
336     }
337     function approve(address guy, uint wad) note returns (bool) {
338         return super.approve(guy, wad);
339     }
340 
341     function push(address dst, uint128 wad) returns (bool) {
342         return transfer(dst, wad);
343     }
344     function pull(address src, uint128 wad) returns (bool) {
345         return transferFrom(src, msg.sender, wad);
346     }
347 
348     function burn(uint128 wad) auth note {
349         _balances[msg.sender] = sub(_balances[msg.sender], wad);
350         _supply = sub(_supply, wad);
351     }
352 
353     // Optional token name
354 
355     bytes32   public  name = "";
356     
357     function setName(bytes32 name_) auth {
358         name = name_;
359     }
360 
361 }