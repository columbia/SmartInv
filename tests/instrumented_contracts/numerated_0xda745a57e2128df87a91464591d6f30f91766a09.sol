1 pragma solidity ^0.4.24;
2 
3 interface IERC20 {
4     function transfer(address to, uint256 value) external returns (bool);
5 
6     function approve(address spender, uint256 value) external returns (bool);
7 
8     function transferFrom(address from, address to, uint256 value) external returns (bool);
9 
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address who) external view returns (uint256);
13 
14     function allowance(address owner, address spender) external view returns (uint256);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 contract DSAuthority {
22     function canCall(address src, address dst, bytes4 sig) public constant returns (bool);
23 }
24 
25 contract DSAuthEvents {
26     event LogSetAuthority (address indexed authority);
27     event LogSetOwner(address indexed owner);
28 }
29 
30 
31 contract DSAuth is DSAuthEvents{
32     DSAuthority  public authority;
33 
34     address public  owner;
35 
36     constructor() public {
37         owner = msg.sender;
38         emit LogSetOwner(msg.sender);
39     }
40 
41     function setOwner(address owner_) public auth {
42         require(owner_ != address(0));
43         owner = owner_;
44         emit LogSetOwner(owner);
45     }
46 
47     function setAuthority(DSAuthority authority_) public auth {
48         authority = authority_;
49         emit LogSetAuthority(authority);
50 
51     }
52 
53     modifier auth {
54         assert(isAuthorized(msg.sender, msg.sig));
55         _;
56     }
57 
58     modifier authorized(bytes4 sig) {
59         assert(isAuthorized(msg.sender, sig));
60         _;
61     }
62 
63     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
64         if (src == address(this)) {
65             return true;
66         } else if (src == owner) {
67             return true;
68         } else if (authority == DSAuthority(0)) {
69             return false;
70         } else {
71             return authority.canCall(src, this, sig);
72         }
73 
74     }
75 }
76 
77 contract DSNote {
78     event LogNote(
79         bytes4  indexed sig,
80         address indexed guy,
81         bytes32 indexed foo,
82         bytes32 indexed bar,
83         uint wad,
84         bytes fax
85     ) anonymous;
86 
87     modifier note {
88         bytes32 foo;
89         bytes32 bar;
90 
91         assembly {
92             foo := calldataload(4)
93             bar := calldataload(36)
94         }
95 
96         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
97         _;
98     }
99 
100 }
101 
102 contract DSStop is DSAuth, DSNote{
103     bool public stopped;
104 
105     modifier stoppable {
106         assert (!stopped);
107         _;
108     }
109 
110     function stop() public auth note {
111         stopped = true;
112     }
113 
114     function start() public auth note {
115         stopped = false;
116     }
117 }
118 
119 
120 library  DSMath {
121 
122     /* standard uint256 functions */
123 
124     function add(uint256 x, uint256 y) pure internal returns (uint256 z) {
125         assert((z = x + y) >= x);
126     }
127 
128     function sub(uint256 x, uint256 y) pure internal returns (uint256 z) {
129         assert((z = x - y) <= x);
130     }
131 
132     function mul(uint256 x, uint256 y) pure internal returns (uint256 z) {
133         assert(y == 0 || (z = x * y) / y == x);
134     }
135 
136     function div(uint256 x, uint256 y) pure internal returns (uint256 z) {
137         z = x / y;
138     }
139 
140     function min(uint256 x, uint256 y) pure internal returns (uint256 z) {
141         return x <= y ? x : y;
142     }
143 
144     function max(uint256 x, uint256 y) pure internal returns (uint256 z) {
145         return x >= y ? x : y;
146     }
147 
148     /* uint128 functions (h is for half) */
149 
150     function hadd(uint128 x, uint128 y) pure internal returns (uint128 z) {
151         assert((z = x + y) >= x);
152     }
153 
154     function hsub(uint128 x, uint128 y) pure internal returns (uint128 z) {
155         assert((z = x - y) <= x);
156     }
157 
158     function hmul(uint128 x, uint128 y) pure internal returns (uint128 z) {
159         assert(y == 0 || (z = x * y) / y == x);
160     }
161 
162     function hdiv(uint128 x, uint128 y) pure internal returns (uint128 z) {
163         z = x / y;
164     }
165 
166     function hmin(uint128 x, uint128 y) pure internal returns (uint128 z) {
167         return x <= y ? x : y;
168     }
169 
170     function hmax(uint128 x, uint128 y) pure internal returns (uint128 z) {
171         return x >= y ? x : y;
172     }
173 
174 
175     /* int256 functions */
176 
177     function imin(int256 x, int256 y) pure internal returns (int256 z) {
178         return x <= y ? x : y;
179     }
180 
181     function imax(int256 x, int256 y) pure internal returns (int256 z) {
182         return x >= y ? x : y;
183     }
184 
185     /* WAD math */
186 
187     uint128 constant WAD = 10 ** 18;
188 
189     function wadd(uint128 x, uint128 y) pure internal returns (uint128) {
190         return hadd(x, y);
191     }
192 
193     function wsub(uint128 x, uint128 y) pure internal returns (uint128) {
194         return hsub(x, y);
195     }
196 
197     function wmul(uint128 x, uint128 y) pure internal returns (uint128 z) {
198         z = cast(add(mul(uint256(x), y), WAD/2) / WAD);
199     }
200 
201     function wdiv(uint128 x, uint128 y) pure internal returns (uint128 z) {
202         z = cast(add(mul(uint256(x), WAD), y/2) / y);
203     }
204 
205     function wmin(uint128 x, uint128 y) pure internal returns (uint128) {
206         return hmin(x, y);
207     }
208 
209     function wmax(uint128 x, uint128 y) pure internal returns (uint128) {
210         return hmax(x, y);
211     }
212 
213     /* RAY math */
214 
215     uint128 constant RAY = 10 ** 27;
216 
217     function radd(uint128 x, uint128 y) pure internal returns (uint128) {
218         return hadd(x, y);
219     }
220 
221     function rsub(uint128 x, uint128 y) pure internal returns (uint128) {
222         return hsub(x, y);
223     }
224 
225     function rmul(uint128 x, uint128 y) pure internal returns (uint128 z) {
226         z = cast(add(mul(uint256(x), y), RAY/2) / RAY);
227     }
228 
229     function rdiv(uint128 x, uint128 y) pure internal returns (uint128 z) {
230         z = cast(add(mul(uint256(x), RAY), y/2) / y);
231     }
232 
233     function rpow(uint128 x, uint64 n) pure internal returns (uint128 z) {
234         z = n % 2 != 0 ? x : RAY;
235         for (n /= 2; n != 0; n /= 2) {
236             x = rmul(x, x);
237             if (n % 2 != 0) {
238                 z = rmul(z, x);
239             }
240         }
241     }
242 
243     function rmin(uint128 x, uint128 y) pure internal returns (uint128) {
244         return hmin(x, y);
245     }
246 
247     function rmax(uint128 x, uint128 y) pure internal returns (uint128) {
248         return hmax(x, y);
249     }
250 
251     function cast(uint256 x) pure internal returns (uint128 z) {
252         assert((z = uint128(x)) == x);
253     }
254 }
255 
256 
257 contract BmsTokenBase is IERC20 {
258 
259     using DSMath for uint256;
260     uint256 _supply;
261 
262     mapping (address => uint256) _balances;
263 
264     mapping (address => mapping (address => uint256)) _approvals;
265 
266     function totalSupply() public view returns (uint256) {
267         return _supply;
268     }
269 
270     function balanceOf(address src) public view returns (uint256) {
271         return _balances[src];
272     }
273 
274     function allowance(address src, address guy) public view returns (uint256) {
275         return _approvals[src][guy];
276     }
277 
278     function transfer(address dst, uint256 wad) public returns (bool) {
279         assert(_balances[msg.sender] >= wad);
280         _balances[msg.sender] = _balances[msg.sender].sub(wad);
281         _balances[dst] =_balances[dst].add(wad);
282         emit Transfer(msg.sender, dst, wad);
283         return true;
284     }
285 
286     function transferFrom(address src, address dst, uint256 wad) public returns (bool) {
287         assert(_balances[src] >= wad);
288         assert(_approvals[src][msg.sender] >= wad);
289         _approvals[src][msg.sender] = _approvals[src][msg.sender].sub(wad);
290         _balances[src] =_balances[src].sub(wad);
291         _balances[dst] = _balances[dst].add(wad);
292         emit Transfer(src, dst, wad);
293 
294         return true;
295     }
296 
297     function approve(address guy, uint256 wad) public returns (bool) {
298         _approvals[msg.sender][guy] = wad;
299         emit Approval(msg.sender, guy, wad);
300         return true;
301     }
302 
303 }
304 
305 
306 
307 contract BmsCoinCore is BmsTokenBase, DSStop {
308     bytes32 public symbol;
309     bytes32 public name;
310     uint256 public decimals = 18; // standard token precision. override to customize
311   
312     mapping(address=>uint256)  lockedBalance;
313     uint256 internal constant INITIAL_SUPPLY = (10**8) * (10**18);
314 
315     event Lock(address indexed locker, uint256 value);
316     event UnLock(address indexed unlocker, uint256 value);
317 
318 
319     constructor() public{
320         symbol = "BMS";
321         name = "BMS";
322 
323         _balances[msg.sender] = INITIAL_SUPPLY;
324         _supply =  INITIAL_SUPPLY;
325     }
326 
327     //balance of locked
328     function lockedOf(address _owner) public constant returns (uint256 balance) {
329         return lockedBalance[_owner];
330     }
331 
332     // transfer to and lock it
333     function transferAndLock(address dst, uint256 _value) public returns (bool success) {
334         require(dst != 0x0);
335         require(_value <= _balances[msg.sender].sub(lockedBalance[msg.sender]));
336         require(_value > 0);
337 
338         _balances[msg.sender] = _balances[msg.sender].sub(_value);
339 
340         lockedBalance[dst] = lockedBalance[dst].add(_value);
341         _balances[dst] = _balances[dst].add(_value);
342 
343         emit Transfer(msg.sender, dst, _value);
344         emit Lock(dst, _value);
345         return true;
346     }
347 
348 
349     /**
350     * @notice Transfers tokens held by lock.
351     */
352     function unlock(address dst, uint256 amount) public auth returns (bool success){
353         uint256 maxAmount = lockedBalance[dst];
354         require(amount > 0);
355         require(amount <= maxAmount);
356 
357         uint256 remainAmount = maxAmount.sub(amount);
358         lockedBalance[dst] = remainAmount;
359 
360         emit Transfer(msg.sender, dst, amount);
361         emit UnLock(dst, amount);
362 
363         return true;
364     }
365 
366     function multisend( address[] dests, uint256[] values) public auth returns (uint256) {
367         uint256 i = 0;
368         while (i < dests.length) {
369             transferAndLock(dests[i], values[i]);
370             i += 1;
371         }
372         return(i);
373     }
374 
375     function transfer(address dst, uint256 wad) public stoppable note returns (bool) {
376         require(_balances[msg.sender].sub(lockedBalance[msg.sender]) >= wad);
377         return super.transfer(dst, wad);
378     }
379 
380     function transferFrom(
381         address src, address dst, uint256 wad
382     ) public stoppable note returns (bool) {
383         require(_balances[src].sub(lockedBalance[src]) >= wad);
384         return super.transferFrom(src, dst, wad);
385     }
386 
387     function approve(address guy, uint256 wad) public stoppable note returns (bool) {
388         return super.approve(guy, wad);
389     }
390 
391     function push(address dst, uint256 wad) public returns (bool) {
392         return transfer(dst, wad);
393     }
394 
395     function pull(address src, uint256 wad) public returns (bool) {
396         return transferFrom(src, msg.sender, wad);
397     }
398 }