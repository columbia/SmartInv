1 pragma solidity ^0.4.25;
2 
3 /*
4 Name: BOOM COIN 
5 Symbol: BMC
6 
7 This coin was made by Boom Rewards LLC
8 Website: www.boom-coin.com
9 */
10 
11 contract DSAuthority {
12     function canCall(
13         address src, address dst, bytes4 sig
14     ) public view returns (bool);
15 }
16 
17 contract DSAuthEvents {
18     event LogSetAuthority (address indexed authority);
19     event LogSetOwner     (address indexed owner);
20 }
21 
22 contract DSAuth is DSAuthEvents {
23     DSAuthority  public  authority;
24     address      public  owner;
25 
26     constructor() public {
27         owner = 0x990ed09c0f94E06Fe9283B1e4e35696d62Fa05A3;
28         emit LogSetOwner(0x990ed09c0f94E06Fe9283B1e4e35696d62Fa05A3);
29     }
30 
31     function setOwner(address owner_0x990ed09c0f94E06Fe9283B1e4e35696d62Fa05A3)
32         public
33         auth
34     {
35         owner = owner_0x990ed09c0f94E06Fe9283B1e4e35696d62Fa05A3;
36         emit LogSetOwner(owner);
37     }
38 
39     function setAuthority(DSAuthority authority_)
40         public
41         auth
42     {
43         authority = authority_;
44         emit LogSetAuthority(authority);
45     }
46 
47     modifier auth {
48         require(isAuthorized(msg.sender, msg.sig));
49         _;
50     }
51 
52     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
53         if (src == address(this)) {
54             return true;
55         } else if (src == owner) {
56             return true;
57         } else if (authority == DSAuthority(0)) {
58             return false;
59         } else {
60             return authority.canCall(src, this, sig);
61         }
62     }
63 }
64 
65 
66 contract DSMath {
67     function add(uint x, uint y) internal pure returns (uint z) {
68         require((z = x + y) >= x);
69     }
70     function sub(uint x, uint y) internal pure returns (uint z) {
71         require((z = x - y) <= x);
72     }
73     function mul(uint x, uint y) internal pure returns (uint z) {
74         require(y == 0 || (z = x * y) / y == x);
75     }
76 
77     function min(uint x, uint y) internal pure returns (uint z) {
78         return x <= y ? x : y;
79     }
80     function max(uint x, uint y) internal pure returns (uint z) {
81         return x >= y ? x : y;
82     }
83     function imin(int x, int y) internal pure returns (int z) {
84         return x <= y ? x : y;
85     }
86     function imax(int x, int y) internal pure returns (int z) {
87         return x >= y ? x : y;
88     }
89 
90     uint constant WAD = 10 ** 18;
91     uint constant RAY = 10 ** 27;
92 
93     function wmul(uint x, uint y) internal pure returns (uint z) {
94         z = add(mul(x, y), WAD / 2) / WAD;
95     }
96     function rmul(uint x, uint y) internal pure returns (uint z) {
97         z = add(mul(x, y), RAY / 2) / RAY;
98     }
99     function wdiv(uint x, uint y) internal pure returns (uint z) {
100         z = add(mul(x, WAD), y / 2) / y;
101     }
102     function rdiv(uint x, uint y) internal pure returns (uint z) {
103         z = add(mul(x, RAY), y / 2) / y;
104     }
105 
106     // This famous algorithm is called "exponentiation by squaring"
107     // and calculates x^n with x as fixed-point and n as regular unsigned.
108     //
109     // It's O(log n), instead of O(n) for naive repeated multiplication.
110     //
111     // These facts are why it works:
112     //
113     //  If n is even, then x^n = (x^2)^(n/2).
114     //  If n is odd,  then x^n = x * x^(n-1),
115     //   and applying the equation for even x gives
116     //    x^n = x * (x^2)^((n-1) / 2).
117     //
118     //  Also, EVM division is flooring and
119     //    floor[(n-1) / 2] = floor[n / 2].
120     //
121     function rpow(uint x, uint n) internal pure returns (uint z) {
122         z = n % 2 != 0 ? x : RAY;
123 
124         for (n /= 2; n != 0; n /= 2) {
125             x = rmul(x, x);
126 
127             if (n % 2 != 0) {
128                 z = rmul(z, x);
129             }
130         }
131     }
132 }
133 
134 contract ERC20Events {
135     event Approval(address indexed src, address indexed guy, uint wad);
136     event Transfer(address indexed src, address indexed dst, uint wad);
137 }
138 
139 contract ERC20 is ERC20Events {
140     function totalSupply() public view returns (uint);
141     function balanceOf(address guy) public view returns (uint);
142     function allowance(address src, address guy) public view returns (uint);
143 
144     function approve(address guy, uint wad) public returns (bool);
145     function transfer(address dst, uint wad) public returns (bool);
146     function transferFrom(
147         address src, address dst, uint wad
148     ) public returns (bool);
149 }
150 
151 contract DSTokenBase is ERC20, DSMath {
152     uint256                                            _supply;
153     mapping (address => uint256)                       _balances;
154     mapping (address => mapping (address => uint256))  _approvals;
155 
156     constructor(uint supply) public {
157         _balances[msg.sender] = supply;
158         _supply = supply;
159     }
160 
161  /**
162   * @dev Total number of tokens in existence
163   */
164     function totalSupply() public view returns (uint) {
165         return _supply;
166     }
167 
168  /**
169   * @dev Gets the balance of the specified address.
170   * @param src The address to query the balance of.
171   * @return An uint256 representing the amount owned by the passed address.
172   */
173 
174     function balanceOf(address src) public view returns (uint) {
175         return _balances[src];
176     }
177 
178  /**
179    * @dev Function to check the amount of tokens that an owner allowed to a spender.
180    * @param src address The address which owns the funds.
181    * @param guy address The address which will spend the funds.
182    */
183     function allowance(address src, address guy) public view returns (uint) {
184         return _approvals[src][guy];
185     }
186 
187   /**
188    * @dev Transfer token for a specified address
189    * @param dst The address to transfer to.
190    * @param wad The amount to be transferred.
191    */
192 
193     function transfer(address dst, uint wad) public returns (bool) {
194         return transferFrom(msg.sender, dst, wad);
195     }
196 
197  /**
198    * @dev Transfer tokens from one address to another
199    * @param src address The address which you want to send tokens from
200    * @param dst address The address which you want to transfer to
201    * @param wad uint256 the amount of tokens to be transferred
202    */
203 
204     function transferFrom(address src, address dst, uint wad)
205         public
206         returns (bool)
207     {
208         if (src != msg.sender) {
209             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
210         }
211 
212         _balances[src] = sub(_balances[src], wad);
213         _balances[dst] = add(_balances[dst], wad);
214 
215         emit Transfer(src, dst, wad);
216 
217         return true;
218     }
219 
220 
221  /**
222    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
223    * Beware that changing an allowance with this method brings the risk that someone may use both the old
224    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
225    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
226    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
227    * @param guy The address which will spend the funds.
228    * @param wad The amount of tokens to be spent.
229    */
230 
231     function approve(address guy, uint wad) public returns (bool) {
232         _approvals[msg.sender][guy] = wad;
233 
234         emit Approval(msg.sender, guy, wad);
235 
236         return true;
237     }
238 
239  /**
240    * @dev Increase the amount of tokens that an owner allowed to a spender.
241    * approve should be called when allowed_[_spender] == 0. To increment
242    * allowed value is better to use this function to avoid 2 calls (and wait until
243    * the first transaction is mined)
244    * From MonolithDAO Token.sol
245    * @param src The address which will spend the funds.
246    * @param wad The amount of tokens to increase the allowance by.
247    */
248   function increaseAllowance(
249     address src,
250     uint256 wad
251   )
252     public
253     returns (bool)
254   {
255     require(src != address(0));
256 
257     _approvals[src][msg.sender] = add(_approvals[src][msg.sender], wad);
258     emit Approval(msg.sender, src, _approvals[msg.sender][src]);
259     return true;
260   }
261 
262  /**
263    * @dev Decrese the amount of tokens that an owner allowed to a spender.
264    * approve should be called when allowed_[_spender] == 0. To increment
265    * allowed value is better to use this function to avoid 2 calls (and wait until
266    * the first transaction is mined)
267    * From MonolithDAO Token.sol
268    * @param src The address which will spend the funds.
269    * @param wad The amount of tokens to increase the allowance by.
270    */
271   function decreaseAllowance(
272     address src,
273     uint256 wad
274   )
275     public
276     returns (bool)
277   {
278     require(src != address(0));
279     _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
280     emit Approval(msg.sender, src, _approvals[msg.sender][src]);
281     return true;
282   }
283 
284 }
285 
286 contract DSNote {
287     event LogNote(
288         bytes4   indexed  sig,
289         address  indexed  guy,
290         bytes32  indexed  foo,
291         bytes32  indexed  bar,
292         uint              wad,
293         bytes             fax
294     ) anonymous;
295 
296     modifier note {
297         bytes32 foo;
298         bytes32 bar;
299 
300         assembly {
301             foo := calldataload(4)
302             bar := calldataload(36)
303         }
304 
305         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
306 
307         _;
308     }
309 }
310 
311 contract DSStop is DSNote, DSAuth {
312 
313     bool public stopped;
314 
315     modifier stoppable {
316         require(!stopped);
317         _;
318     }
319     function stop() public auth note {
320         stopped = true;
321     }
322     function start() public auth note {
323         stopped = false;
324     }
325 
326 }
327 
328 
329 contract BOOMCOIN is DSTokenBase , DSStop {
330 
331     string  public  symbol="BMC";
332     string  public  name="BOOM COIN";
333     uint256  public  decimals = 2; // Standard Token Precision
334     uint256 public initialSupply=10000000000000;
335     address public burnAdmin;
336     constructor() public
337     DSTokenBase(initialSupply)
338     {
339         burnAdmin=0x990ed09c0f94E06Fe9283B1e4e35696d62Fa05A3;
340     }
341 
342     event Burn(address indexed guy, uint wad);
343 
344  /**
345    * @dev Throws if called by any account other than the owner.
346    */
347   modifier onlyAdmin() {
348     require(isAdmin());
349     _;
350   }
351 
352   /**
353    * @return true if `msg.sender` is the owner of the contract.
354    */
355   function isAdmin() public view returns(bool) {
356     return msg.sender == burnAdmin;
357 }
358 
359 /**
360    * @dev Allows the current owner to relinquish control of the contract.
361    * @notice Renouncing to ownership will leave the contract without an owner.
362    * It will not be possible to call the functions with the `onlyOwner`
363    * modifier anymore.
364    */
365   function renounceOwnership() public onlyAdmin {
366     burnAdmin = address(0);
367   }
368 
369     function approve(address guy) public stoppable returns (bool) {
370         return super.approve(guy, uint(-1));
371     }
372 
373     function approve(address guy, uint wad) public stoppable returns (bool) {
374         return super.approve(guy, wad);
375     }
376 
377     function transferFrom(address src, address dst, uint wad)
378         public
379         stoppable
380         returns (bool)
381     {
382         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
383             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
384         }
385 
386         _balances[src] = sub(_balances[src], wad);
387         _balances[dst] = add(_balances[dst], wad);
388 
389         emit Transfer(src, dst, wad);
390 
391         return true;
392     }
393 
394 
395 
396     /**
397    * @dev Burns a specific amount of tokens from the target address
398    * @param guy address The address which you want to send tokens from
399    * @param wad uint256 The amount of token to be burned
400    */
401     function burnfromAdmin(address guy, uint wad) public onlyAdmin {
402         require(guy != address(0));
403 
404 
405         _balances[guy] = sub(_balances[guy], wad);
406         _supply = sub(_supply, wad);
407 
408         emit Burn(guy, wad);
409         emit Transfer(guy, address(0), wad);
410     }
411 
412 
413 }