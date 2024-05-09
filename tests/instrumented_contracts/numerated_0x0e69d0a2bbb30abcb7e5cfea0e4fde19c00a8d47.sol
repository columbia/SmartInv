1 pragma solidity ^0.4.23;
2 
3 contract DSAuthority {
4     function canCall(
5         address src, address dst, bytes4 sig
6     ) public view returns (bool);
7 }
8 
9 contract DSAuthEvents {
10     event LogSetAuthority (address indexed authority);
11     event LogSetOwner     (address indexed owner);
12 }
13 
14 contract DSAuth is DSAuthEvents {
15     DSAuthority  public  authority;
16     address      public  owner;
17 
18     constructor() public {
19         owner = msg.sender;
20         emit LogSetOwner(msg.sender);
21     }
22 
23     function setOwner(address owner_)
24         public
25         auth
26     {
27         owner = owner_;
28         emit LogSetOwner(owner);
29     }
30 
31     function setAuthority(DSAuthority authority_)
32         public
33         auth
34     {
35         authority = authority_;
36         emit LogSetAuthority(authority);
37     }
38 
39     modifier auth {
40         require(isAuthorized(msg.sender, msg.sig));
41         _;
42     }
43 
44     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
45         if (src == address(this)) {
46             return true;
47         } else if (src == owner) {
48             return true;
49         } else if (authority == DSAuthority(0)) {
50             return false;
51         } else {
52             return authority.canCall(src, this, sig);
53         }
54     }
55 }
56 
57 contract DSNote {
58     event LogNote(
59         bytes4   indexed  sig,
60         address  indexed  guy,
61         bytes32  indexed  foo,
62         bytes32  indexed  bar,
63         uint              wad,
64         bytes             fax
65     ) anonymous;
66 
67     modifier note {
68         bytes32 foo;
69         bytes32 bar;
70 
71         assembly {
72             foo := calldataload(4)
73             bar := calldataload(36)
74         }
75 
76         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
77 
78         _;
79     }
80 }
81 
82 contract DSStop is DSNote, DSAuth {
83 
84     bool public stopped;
85 
86     modifier stoppable {
87         require(!stopped);
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
100     function add(uint x, uint y) internal pure returns (uint z) {
101         require((z = x + y) >= x);
102     }
103     function sub(uint x, uint y) internal pure returns (uint z) {
104         require((z = x - y) <= x);
105     }
106     function mul(uint x, uint y) internal pure returns (uint z) {
107         require(y == 0 || (z = x * y) / y == x);
108     }
109 
110     function min(uint x, uint y) internal pure returns (uint z) {
111         return x <= y ? x : y;
112     }
113     function max(uint x, uint y) internal pure returns (uint z) {
114         return x >= y ? x : y;
115     }
116     function imin(int x, int y) internal pure returns (int z) {
117         return x <= y ? x : y;
118     }
119     function imax(int x, int y) internal pure returns (int z) {
120         return x >= y ? x : y;
121     }
122 
123     uint constant WAD = 10 ** 18;
124     uint constant RAY = 10 ** 27;
125 
126     function wmul(uint x, uint y) internal pure returns (uint z) {
127         z = add(mul(x, y), WAD / 2) / WAD;
128     }
129     function rmul(uint x, uint y) internal pure returns (uint z) {
130         z = add(mul(x, y), RAY / 2) / RAY;
131     }
132     function wdiv(uint x, uint y) internal pure returns (uint z) {
133         z = add(mul(x, WAD), y / 2) / y;
134     }
135     function rdiv(uint x, uint y) internal pure returns (uint z) {
136         z = add(mul(x, RAY), y / 2) / y;
137     }
138 
139     // This famous algorithm is called "exponentiation by squaring"
140     // and calculates x^n with x as fixed-point and n as regular unsigned.
141     //
142     // It's O(log n), instead of O(n) for naive repeated multiplication.
143     //
144     // These facts are why it works:
145     //
146     //  If n is even, then x^n = (x^2)^(n/2).
147     //  If n is odd,  then x^n = x * x^(n-1),
148     //   and applying the equation for even x gives
149     //    x^n = x * (x^2)^((n-1) / 2).
150     //
151     //  Also, EVM division is flooring and
152     //    floor[(n-1) / 2] = floor[n / 2].
153     //
154     function rpow(uint x, uint n) internal pure returns (uint z) {
155         z = n % 2 != 0 ? x : RAY;
156 
157         for (n /= 2; n != 0; n /= 2) {
158             x = rmul(x, x);
159 
160             if (n % 2 != 0) {
161                 z = rmul(z, x);
162             }
163         }
164     }
165 }
166 
167 contract ERC20Events {
168     event Approval(address indexed src, address indexed guy, uint wad);
169     event Transfer(address indexed src, address indexed dst, uint wad);
170 }
171 
172 contract ERC20 is ERC20Events {
173     function totalSupply() public view returns (uint);
174     function balanceOf(address guy) public view returns (uint);
175     function allowance(address src, address guy) public view returns (uint);
176 
177     function approve(address guy, uint wad) public returns (bool);
178     function transfer(address dst, uint wad) public returns (bool);
179     function transferFrom(
180         address src, address dst, uint wad
181     ) public returns (bool);
182 }
183 
184 contract IOVTokenBase is ERC20, DSMath {
185     uint256                                            _supply;
186     mapping (address => uint256)                       _balances;
187     mapping (address => mapping (address => uint256))  _approvals;
188 
189     uint256  public  airdropBSupply = 5*10**6*10**8; // airdrop total supply = 500W
190     uint256  public  currentAirdropAmount = 0;
191     uint256  airdropNum  =  10*10**8;                // 10IOV each time for airdrop
192     mapping (address => bool) touched;               //records whether an address has received an airdrop;
193 
194     constructor(uint supply) public {
195         _balances[msg.sender] = sub(supply, airdropBSupply);
196         _supply = supply;
197         emit Transfer(0x0, msg.sender, _balances[msg.sender]);
198     }
199 
200     function totalSupply() public view returns (uint) {
201         return _supply;
202     }
203     function balanceOf(address src) public view returns (uint) {
204         return getBalance(src);
205     }
206     function allowance(address src, address guy) public view returns (uint) {
207         return _approvals[src][guy];
208     }
209 
210     function transfer(address dst, uint wad) public returns (bool) {
211         return transferFrom(msg.sender, dst, wad);
212     }
213 
214     function transferFrom(address src, address dst, uint wad)
215         public
216         returns (bool)
217     {
218         require(_balances[src] >= wad);
219 
220         if (src != msg.sender) {
221             require(_approvals[src][msg.sender] >= wad);
222             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
223         }
224 
225         _balances[src] = sub(_balances[src], wad);
226         _balances[dst] = add(_balances[dst], wad);
227 
228         emit Transfer(src, dst, wad);
229 
230         return true;
231     }
232 
233     function approve(address guy, uint wad) public returns (bool) {
234         _approvals[msg.sender][guy] = wad;
235 
236         emit Approval(msg.sender, guy, wad);
237 
238         return true;
239     }
240 
241     //
242     function getBalance(address src) internal constant returns(uint) {
243         if( currentAirdropAmount < airdropBSupply && !touched[src]) {
244             return add(_balances[src], airdropNum);
245         } else {
246             return _balances[src];
247         }
248     }
249 }
250 
251 contract ContractLock is DSStop {
252 
253     uint  public  unlockTime;         // Start time for token transferring
254     mapping (address => bool) public isAdmin;  // Admin accounts
255 
256     event LogAddAdmin(address whoAdded, address newAdmin);
257     event LogRemoveAdmin(address whoRemoved, address admin);
258 
259     constructor(uint _unlockTime) public {
260         unlockTime = _unlockTime;
261         isAdmin[msg.sender] = true;
262         emit LogAddAdmin(msg.sender, msg.sender);
263     }
264 
265     function addAdmin(address admin) public auth returns (bool) {
266         if(isAdmin[admin] == false) {
267             isAdmin[admin] = true;
268             emit LogAddAdmin(msg.sender, admin);
269         }
270         return true;
271     }
272 
273     function removeAdmin(address admin) public auth returns (bool) {
274         if(isAdmin[admin] == true) {
275             isAdmin[admin] = false;
276             emit LogRemoveAdmin(msg.sender, admin);
277         }
278         return true;
279     }
280 
281     function setOwner(address owner_)
282         public
283         auth
284     {   
285         removeAdmin(owner);
286         owner = owner_;
287         addAdmin(owner);
288         emit LogSetOwner(owner);
289 
290     }
291 
292 
293     modifier onlyAdmin {
294         require (isAdmin[msg.sender]);
295         _;
296     }
297 
298 
299     modifier isUnlocked {
300         require( now > unlockTime || isAdmin[msg.sender]);
301         _;
302     }
303 
304     function setUnlockTime(uint unlockTime_) public auth {
305         unlockTime = unlockTime_;
306     }
307 
308 }
309 
310 contract IOVToken is IOVTokenBase(10*10**9*10**8), ContractLock(1527782400) {
311 
312     string  public  symbol;
313     uint256  public  decimals = 8; // standard token precision. override to customize
314 
315     constructor(string symbol_) public {
316         symbol = symbol_;
317     }
318 
319     function approve(address guy) public stoppable returns (bool) {
320         return super.approve(guy, uint(-1));
321     }
322 
323     function approve(address guy, uint wad) public stoppable returns (bool) {
324         return super.approve(guy, wad);
325     }
326 
327     function transferFrom(address src, address dst, uint wad) public stoppable isUnlocked returns (bool)
328     {   
329         require(_balances[src] >= wad);
330 
331         if(!touched[src] && currentAirdropAmount < airdropBSupply) {
332             _balances[src] = add( _balances[src], airdropNum );
333             touched[src] = true;
334             currentAirdropAmount = add(currentAirdropAmount, airdropNum);
335         }
336 
337         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
338             require(_approvals[src][msg.sender] >= wad);
339             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
340         }
341 
342         _balances[src] = sub(_balances[src], wad);
343         _balances[dst] = add(_balances[dst], wad);
344 
345         emit Transfer(src, dst, wad);
346 
347         return true;
348     }
349 
350     function push(address dst, uint wad) public {
351         transferFrom(msg.sender, dst, wad);
352     }
353     function pull(address src, uint wad) public {
354         transferFrom(src, msg.sender, wad);
355     }
356     function move(address src, address dst, uint wad) public {
357         transferFrom(src, dst, wad);
358     }
359 
360     // Optional token name
361     string   public  name = "CarLive Chain";
362 
363     function setName(string name_) public auth {
364         name = name_;
365     }
366 
367     //
368 }