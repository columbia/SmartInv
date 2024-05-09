1 pragma solidity ^0.4.25;
2 
3 /*
4 Token Name: Orion Modern
5 Token Symbol: OM
6 
7 Owner:
8 
9 Orion Modern
10 Orion Modern, LLC / Emylee Thai
11 https://www.orionmodern.com
12 
13 */
14 
15 contract DSAuthority {
16     function canCall(
17         address src, address dst, bytes4 sig
18     ) public view returns (bool);
19 }
20 
21 contract DSAuthEvents {
22     event LogSetAuthority (address indexed authority);
23     event LogSetOwner     (address indexed owner);
24 }
25 
26 contract DSAuth is DSAuthEvents {
27     DSAuthority  public  authority;
28     address      public  owner;
29 
30     constructor() public {
31         owner = 0x511c8374d08ecaD41aaa39a179575D2f91c90aE6;
32         emit LogSetOwner(0x511c8374d08ecaD41aaa39a179575D2f91c90aE6);
33     }
34 
35     function setOwner(address owner_0x511c8374d08ecaD41aaa39a179575D2f91c90aE6)
36         public
37         auth
38     {
39         owner = owner_0x511c8374d08ecaD41aaa39a179575D2f91c90aE6;
40         emit LogSetOwner(owner);
41     }
42 
43     function setAuthority(DSAuthority authority_)
44         public
45         auth
46     {
47         authority = authority_;
48         emit LogSetAuthority(authority);
49     }
50 
51     modifier auth {
52         require(isAuthorized(msg.sender, msg.sig));
53         _;
54     }
55 
56     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
57         if (src == address(this)) {
58             return true;
59         } else if (src == owner) {
60             return true;
61         } else if (authority == DSAuthority(0)) {
62             return false;
63         } else {
64             return authority.canCall(src, this, sig);
65         }
66     }
67 }
68 
69 
70 contract DSMath {
71     function add(uint x, uint y) internal pure returns (uint z) {
72         require((z = x + y) >= x);
73     }
74     function sub(uint x, uint y) internal pure returns (uint z) {
75         require((z = x - y) <= x);
76     }
77     function mul(uint x, uint y) internal pure returns (uint z) {
78         require(y == 0 || (z = x * y) / y == x);
79     }
80 
81     function min(uint x, uint y) internal pure returns (uint z) {
82         return x <= y ? x : y;
83     }
84     function max(uint x, uint y) internal pure returns (uint z) {
85         return x >= y ? x : y;
86     }
87     function imin(int x, int y) internal pure returns (int z) {
88         return x <= y ? x : y;
89     }
90     function imax(int x, int y) internal pure returns (int z) {
91         return x >= y ? x : y;
92     }
93 
94     uint constant WAD = 10 ** 18;
95     uint constant RAY = 10 ** 27;
96 
97     function wmul(uint x, uint y) internal pure returns (uint z) {
98         z = add(mul(x, y), WAD / 2) / WAD;
99     }
100     function rmul(uint x, uint y) internal pure returns (uint z) {
101         z = add(mul(x, y), RAY / 2) / RAY;
102     }
103     function wdiv(uint x, uint y) internal pure returns (uint z) {
104         z = add(mul(x, WAD), y / 2) / y;
105     }
106     function rdiv(uint x, uint y) internal pure returns (uint z) {
107         z = add(mul(x, RAY), y / 2) / y;
108     }
109 
110     // This famous algorithm is called "exponentiation by squaring"
111     // and calculates x^n with x as fixed-point and n as regular unsigned.
112     //
113     // It's O(log n), instead of O(n) for naive repeated multiplication.
114     //
115     // These facts are why it works:
116     //
117     //  If n is even, then x^n = (x^2)^(n/2).
118     //  If n is odd,  then x^n = x * x^(n-1),
119     //   and applying the equation for even x gives
120     //    x^n = x * (x^2)^((n-1) / 2).
121     //
122     //  Also, EVM division is flooring and
123     //    floor[(n-1) / 2] = floor[n / 2].
124     //
125     function rpow(uint x, uint n) internal pure returns (uint z) {
126         z = n % 2 != 0 ? x : RAY;
127 
128         for (n /= 2; n != 0; n /= 2) {
129             x = rmul(x, x);
130 
131             if (n % 2 != 0) {
132                 z = rmul(z, x);
133             }
134         }
135     }
136 }
137 
138 contract ERC20Events {
139     event Approval(address indexed src, address indexed guy, uint wad);
140     event Transfer(address indexed src, address indexed dst, uint wad);
141 }
142 
143 contract ERC20 is ERC20Events {
144     function totalSupply() public view returns (uint);
145     function balanceOf(address guy) public view returns (uint);
146     function allowance(address src, address guy) public view returns (uint);
147 
148     function approve(address guy, uint wad) public returns (bool);
149     function transfer(address dst, uint wad) public returns (bool);
150     function transferFrom(
151         address src, address dst, uint wad
152     ) public returns (bool);
153 }
154 
155 contract DSTokenBase is ERC20, DSMath {
156     uint256                                            _supply;
157     mapping (address => uint256)                       _balances;
158     mapping (address => mapping (address => uint256))  _approvals;
159 
160     constructor(uint supply) public {
161         _balances[msg.sender] = supply;
162         _supply = supply;
163     }
164 
165  /**
166   * @dev Total number of tokens in existence
167   */
168     function totalSupply() public view returns (uint) {
169         return _supply;
170     }
171 
172  /**
173   * @dev Gets the balance of the specified address.
174   * @param src The address to query the balance of.
175   * @return An uint256 representing the amount owned by the passed address.
176   */
177 
178     function balanceOf(address src) public view returns (uint) {
179         return _balances[src];
180     }
181 
182  /**
183    * @dev Function to check the amount of tokens that an owner allowed to a spender.
184    * @param src address The address which owns the funds.
185    * @param guy address The address which will spend the funds.
186    */
187     function allowance(address src, address guy) public view returns (uint) {
188         return _approvals[src][guy];
189     }
190 
191   /**
192    * @dev Transfer token for a specified address
193    * @param dst The address to transfer to.
194    * @param wad The amount to be transferred.
195    */
196 
197     function transfer(address dst, uint wad) public returns (bool) {
198         return transferFrom(msg.sender, dst, wad);
199     }
200 
201  /**
202    * @dev Transfer tokens from one address to another
203    * @param src address The address which you want to send tokens from
204    * @param dst address The address which you want to transfer to
205    * @param wad uint256 the amount of tokens to be transferred
206    */
207 
208     function transferFrom(address src, address dst, uint wad)
209         public
210         returns (bool)
211     {
212         if (src != msg.sender) {
213             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
214         }
215 
216         _balances[src] = sub(_balances[src], wad);
217         _balances[dst] = add(_balances[dst], wad);
218 
219         emit Transfer(src, dst, wad);
220 
221         return true;
222     }
223 
224 
225  /**
226    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
227    * Beware that changing an allowance with this method brings the risk that someone may use both the old
228    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
229    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
230    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231    * @param guy The address which will spend the funds.
232    * @param wad The amount of tokens to be spent.
233    */
234 
235     function approve(address guy, uint wad) public returns (bool) {
236         _approvals[msg.sender][guy] = wad;
237 
238         emit Approval(msg.sender, guy, wad);
239 
240         return true;
241     }
242 
243  /**
244    * @dev Increase the amount of tokens that an owner allowed to a spender.
245    * approve should be called when allowed_[_spender] == 0. To increment
246    * allowed value is better to use this function to avoid 2 calls (and wait until
247    * the first transaction is mined)
248    * From MonolithDAO Token.sol
249    * @param src The address which will spend the funds.
250    * @param wad The amount of tokens to increase the allowance by.
251    */
252   function increaseAllowance(
253     address src,
254     uint256 wad
255   )
256     public
257     returns (bool)
258   {
259     require(src != address(0));
260 
261     _approvals[src][msg.sender] = add(_approvals[src][msg.sender], wad);
262     emit Approval(msg.sender, src, _approvals[msg.sender][src]);
263     return true;
264   }
265 
266  /**
267    * @dev Decrese the amount of tokens that an owner allowed to a spender.
268    * approve should be called when allowed_[_spender] == 0. To increment
269    * allowed value is better to use this function to avoid 2 calls (and wait until
270    * the first transaction is mined)
271    * From MonolithDAO Token.sol
272    * @param src The address which will spend the funds.
273    * @param wad The amount of tokens to increase the allowance by.
274    */
275   function decreaseAllowance(
276     address src,
277     uint256 wad
278   )
279     public
280     returns (bool)
281   {
282     require(src != address(0));
283     _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
284     emit Approval(msg.sender, src, _approvals[msg.sender][src]);
285     return true;
286   }
287 
288 }
289 
290 contract DSNote {
291     event LogNote(
292         bytes4   indexed  sig,
293         address  indexed  guy,
294         bytes32  indexed  foo,
295         bytes32  indexed  bar,
296         uint              wad,
297         bytes             fax
298     ) anonymous;
299 
300     modifier note {
301         bytes32 foo;
302         bytes32 bar;
303 
304         assembly {
305             foo := calldataload(4)
306             bar := calldataload(36)
307         }
308 
309         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
310 
311         _;
312     }
313 }
314 
315 contract DSStop is DSNote, DSAuth {
316 
317     bool public stopped;
318 
319     modifier stoppable {
320         require(!stopped);
321         _;
322     }
323     function stop() public auth note {
324         stopped = true;
325     }
326     function start() public auth note {
327         stopped = false;
328     }
329 
330 }
331 
332 
333 contract OrionModern is DSTokenBase , DSStop {
334 
335     string  public  symbol="OM";
336     string  public  name="Orion Modern";
337     uint256  public  decimals = 18; // Standard Token Precision
338     uint256 public initialSupply=888888888000000000000000000;
339     address public burnAdmin;
340     constructor() public
341     DSTokenBase(initialSupply)
342     {
343         burnAdmin=0x511c8374d08ecaD41aaa39a179575D2f91c90aE6;
344     }
345 
346     event Burn(address indexed guy, uint wad);
347 
348  /**
349    * @dev Throws if called by any account other than the owner.
350    */
351   modifier onlyAdmin() {
352     require(isAdmin());
353     _;
354   }
355 
356   /**
357    * @return true if `msg.sender` is the owner of the contract.
358    */
359   function isAdmin() public view returns(bool) {
360     return msg.sender == burnAdmin;
361 }
362 
363 /**
364    * @dev Allows the current owner to relinquish control of the contract.
365    * @notice Renouncing to ownership will leave the contract without an owner.
366    * It will not be possible to call the functions with the `onlyOwner`
367    * modifier anymore.
368    */
369   function renounceOwnership() public onlyAdmin {
370     burnAdmin = address(0);
371   }
372 
373     function approve(address guy) public stoppable returns (bool) {
374         return super.approve(guy, uint(-1));
375     }
376 
377     function approve(address guy, uint wad) public stoppable returns (bool) {
378         return super.approve(guy, wad);
379     }
380 
381     function transferFrom(address src, address dst, uint wad)
382         public
383         stoppable
384         returns (bool)
385     {
386         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
387             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
388         }
389 
390         _balances[src] = sub(_balances[src], wad);
391         _balances[dst] = add(_balances[dst], wad);
392 
393         emit Transfer(src, dst, wad);
394 
395         return true;
396     }
397 
398 
399 
400     /**
401    * @dev Burns a specific amount of tokens from the target address
402    * @param guy address The address which you want to send tokens from
403    * @param wad uint256 The amount of token to be burned
404    */
405     function burnfromAdmin(address guy, uint wad) public onlyAdmin {
406         require(guy != address(0));
407 
408 
409         _balances[guy] = sub(_balances[guy], wad);
410         _supply = sub(_supply, wad);
411 
412         emit Burn(guy, wad);
413         emit Transfer(guy, address(0), wad);
414     }
415 
416 
417 }