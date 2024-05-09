1 pragma solidity ^0.4.18;
2 contract DSNote {
3     event LogNote(
4         bytes4   indexed  sig,
5         address  indexed  guy,
6         bytes32  indexed  foo,
7         bytes32  indexed  bar,
8 	    uint	 	      wad,
9         bytes             fax
10     ) anonymous;
11 
12     modifier note {
13         bytes32 foo;
14         bytes32 bar;
15 
16         assembly {
17             foo := calldataload(4)
18             bar := calldataload(36)
19         }
20         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
21         _;
22     }
23 }
24 
25 contract DSAuthority {
26     function canCall(
27         address src, address dst, bytes4 sig
28     ) public constant returns (bool);
29 }
30 
31 contract DSAuthEvents {
32     event LogSetAuthority (address indexed authority);
33     event LogSetOwner     (address indexed owner);
34 }
35 
36 contract DSAuth is DSAuthEvents {
37     DSAuthority  public  authority;
38     address      public  owner;
39 
40     function DSAuth() public {
41         owner = msg.sender;
42         emit LogSetOwner(msg.sender);
43     }
44 
45     function setOwner(address owner_)
46         public auth
47     {
48         owner = owner_;
49         LogSetOwner(owner);
50     }
51 
52     function setAuthority(DSAuthority authority_)
53         public auth
54     {
55         authority = authority_;
56         LogSetAuthority(authority);
57     }
58 
59     modifier auth {
60         assert(isAuthorized(msg.sender, msg.sig));
61         _;
62     }
63 
64     modifier authorized(bytes4 sig) {
65         assert(isAuthorized(msg.sender, sig));
66         _;
67     }
68 
69     function isAuthorized(address src, bytes4 sig) internal returns (bool) {
70         if (src == address(this)) {
71             return true;
72         } else if (src == owner) {
73             return true;
74         } else if (authority == DSAuthority(0)) {
75             return false;
76         } else {
77             return authority.canCall(src, this, sig);
78         }
79     }
80 }
81 
82 contract DSStop is DSAuth, DSNote {
83 
84     bool public stopped;
85 
86     modifier stoppable {
87         assert (!stopped);
88         _;
89     }
90     function stop() public auth note {
91         stopped = true;
92     }
93     function start() public auth note {
94         stopped = false;
95     }
96 
97 }
98 
99 contract DSMath {
100     /*
101     standard uint256 functions
102      */
103     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
104         assert((z = x + y) >= x);
105     }
106 
107     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
108         assert((z = x - y) <= x);
109     }
110 
111     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
112         assert((z = x * y) >= x);
113     }
114 
115     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
116         z = x / y;
117     }
118 
119     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
120         return x <= y ? x : y;
121     }
122     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
123         return x >= y ? x : y;
124     }
125 
126     /*
127     uint128 functions (h is for half)
128      */
129     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
130         assert((z = x + y) >= x);
131     }
132 
133     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
134         assert((z = x - y) <= x);
135     }
136 
137     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
138         assert((z = x * y) >= x);
139     }
140 
141     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
142         z = x / y;
143     }
144 
145     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
146         return x <= y ? x : y;
147     }
148     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
149         return x >= y ? x : y;
150     }
151 
152 
153     /*
154     int256 functions
155      */
156     function imin(int256 x, int256 y) constant internal returns (int256 z) {
157         return x <= y ? x : y;
158     }
159     function imax(int256 x, int256 y) constant internal returns (int256 z) {
160         return x >= y ? x : y;
161     }
162 
163     /*
164     WAD math
165      */
166     uint128 constant WAD = 10 ** 18;
167 
168     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
169         return hadd(x, y);
170     }
171 
172     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
173         return hsub(x, y);
174     }
175 
176     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
177         z = cast((uint256(x) * y + WAD / 2) / WAD);
178     }
179 
180     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
181         z = cast((uint256(x) * WAD + y / 2) / y);
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
194     uint128 constant RAY = 10 ** 27;
195     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
196         return hadd(x, y);
197     }
198 
199     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
200         return hsub(x, y);
201     }
202 
203     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
204         z = cast((uint256(x) * y + RAY / 2) / RAY);
205     }
206 
207     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
208         z = cast((uint256(x) * RAY + y / 2) / y);
209     }
210 
211     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
212         // This famous algorithm is called "exponentiation by squaring"
213         // and calculates x^n with x as fixed-point and n as regular unsigned.
214         //
215         // It's O(log n), instead of O(n) for naive repeated multiplication.
216         //
217         // These facts are why it works:
218         //
219         //  If n is even, then x^n = (x^2)^(n/2).
220         //  If n is odd,  then x^n = x * x^(n-1),
221         //   and applying the equation for even x gives
222         //    x^n = x * (x^2)^((n-1) / 2).
223         //
224         //  Also, EVM division is flooring and
225         //    floor[(n-1) / 2] = floor[n / 2].
226 
227         z = n % 2 != 0 ? x : RAY;
228 
229         for (n /= 2; n != 0; n /= 2) {
230             x = rmul(x, x);
231 
232             if (n % 2 != 0) {
233                 z = rmul(z, x);
234             }
235         }
236     }
237 
238     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
239         return hmin(x, y);
240     }
241     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
242         return hmax(x, y);
243     }
244 
245     function cast(uint256 x) constant internal returns (uint128 z) {
246         assert((z = uint128(x)) == x);
247     }
248 
249 }
250 
251 contract ERC20 {
252     function totalSupply() public constant returns (uint supply);
253     function balanceOf( address who ) public constant returns (uint value);
254     function allowance( address owner, address spender ) public constant returns (uint _allowance);
255 
256     function transfer( address to, uint value) public returns (bool ok);
257     function transferFrom( address from, address to, uint value) public returns (bool ok);
258     function approve( address spender, uint value ) public returns (bool ok);
259 
260     event Transfer( address indexed from, address indexed to, uint value);
261     event Approval( address indexed owner, address indexed spender, uint value);
262 }
263 
264 contract DSTokenBase is ERC20, DSMath {
265     uint256                                            _supply;
266     mapping (address => uint256)                       _balances;
267     mapping (address => mapping (address => uint256))  _approvals;
268     
269     function DSTokenBase(uint256 supply) public {
270         _balances[msg.sender] = supply;
271         _supply = supply;
272     }
273     
274     function totalSupply() public constant returns (uint256) {
275         return _supply;
276     }
277     function balanceOf(address src) public constant returns (uint256) {
278         return _balances[src];
279     }
280     function allowance(address src, address guy) public constant returns (uint256) {
281         return _approvals[src][guy];
282     }
283     
284     function transfer(address dst, uint wad) public returns (bool) {
285         assert(_balances[msg.sender] >= wad);
286         
287         _balances[msg.sender] = sub(_balances[msg.sender], wad);
288         _balances[dst] = add(_balances[dst], wad);
289         
290         Transfer(msg.sender, dst, wad);
291         
292         return true;
293     }
294     
295     function transferFrom(address src, address dst, uint wad) public returns (bool) {
296         assert(_balances[src] >= wad);
297         assert(_approvals[src][msg.sender] >= wad);
298         
299         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
300         _balances[src] = sub(_balances[src], wad);
301         _balances[dst] = add(_balances[dst], wad);
302         
303         Transfer(src, dst, wad);
304         
305         return true;
306     }
307     
308     function approve(address guy, uint256 wad) public returns (bool) {
309         _approvals[msg.sender][guy] = wad;
310         
311         Approval(msg.sender, guy, wad);
312         
313         return true;
314     }
315 
316 }
317 
318 contract LICToken is DSTokenBase(0), DSStop {
319 
320     string  public  symbol = "LIC";
321     string  public  name = "LICToken";
322     uint256  public  decimals = 8; // standard token precision. override to customize
323 
324     struct TokenData {
325         uint count;
326         uint unlockTime;
327     }
328     mapping(address => TokenData[]) accs;
329     
330     mapping(address => string) accsInfo;
331 
332     function LICToken() public {
333     }
334 
335     function transfer(address dst, uint wad) public stoppable note returns (bool) {
336         return super.transfer(dst, wad);
337     }
338     function transferFrom(
339         address src, address dst, uint wad
340     ) public stoppable note returns (bool) {
341         return super.transferFrom(src, dst, wad);
342     }
343     function approve(address guy, uint wad) public stoppable note returns (bool) {
344         return super.approve(guy, wad);
345     }
346 
347     function push(address dst, uint128 wad) public returns (bool) {
348         return transfer(dst, wad);
349     }
350     function pull(address src, uint128 wad) public returns (bool) {
351         return transferFrom(src, msg.sender, wad);
352     }
353 
354     function mint(uint128 wad) public auth stoppable note {
355         assert(owner == msg.sender);
356         _balances[msg.sender] = add(_balances[msg.sender], wad);
357         _supply = add(_supply, wad);
358     }
359     function burn(uint128 wad) public auth stoppable note {
360         assert(owner == msg.sender);
361         _balances[msg.sender] = sub(_balances[msg.sender], wad);
362         _supply = sub(_supply, wad);
363     }
364 
365     function transferByLock(address to,uint c,uint256 lockTime,uint stages) public {
366         assert(owner == msg.sender);
367         assert(_balances[msg.sender] >= c);
368         assert(stages >= 1);
369         uint256 nowtime = now;
370         assert(lockTime > nowtime);
371 
372         _balances[msg.sender] = sub(_balances[msg.sender], c);
373         uint256 waittime = div(sub(lockTime, nowtime), stages);
374         for(uint i = 1; i <= stages; i++){
375             accs[to].push(TokenData(div(c, stages),add(now, mul(i, waittime))));
376         }
377         //发送事件
378         Transfer(msg.sender, to, c);
379     }
380 
381     function unlock() public {
382         uint[] memory d_list = new uint[](accs[msg.sender].length);
383         uint dlen = 0;
384         for(uint i = 0 ; i < accs[msg.sender].length; i++ ) {
385             if ( accs[msg.sender][i].unlockTime < now){
386                 _balances[msg.sender] = add(_balances[msg.sender], accs[msg.sender][i].count);
387                 d_list[dlen] = i;
388                 dlen++;
389             }
390         }
391         for(i = 0;i<dlen;i++){
392             delete (accs[msg.sender][d_list[i]]);
393         }
394     }
395 
396     function getLockAccount(address addr, uint isAvailable) public constant returns (uint256) {
397         uint256 total = 0;
398         for(uint i = 0 ; i < accs[addr].length; i++ ) {
399             if ((isAvailable == 1) && (accs[addr][i].unlockTime > now)) {
400                 continue;
401             }
402             total = add(total, accs[addr][i].count);
403         }
404         return total;
405     }
406     
407     function setLockAccInfo(address addr, string info) public {
408         assert(owner == msg.sender);
409         accsInfo[addr] = info;
410     }
411     
412     function getLockAccInfo(address addr) public constant returns (string) {
413         return accsInfo[addr];
414     }
415 }