1 pragma solidity ^0.4.25;
2 
3 /*
4 Name: Blockchain Help Coin
5 Symbol: BCHP
6 
7 Company Name: Blockchain Help
8 Website: www.blockchainhelp.pro
9 
10 Ver. 1.1
11 */
12 
13 contract DSAuthority {
14     function canCall(
15         address src, address dst, bytes4 sig
16     ) public view returns (bool);
17 }
18 
19 contract DSAuthEvents {
20     event LogSetAuthority (address indexed authority);
21     event LogSetOwner     (address indexed owner);
22 }
23 
24 contract DSAuth is DSAuthEvents {
25     DSAuthority  public  authority;
26     address      public  owner;
27 
28     constructor() public {
29         owner = 0x6987724F4634Da668936166Ace26DE119F5ae9Fe;
30         emit LogSetOwner(0x6987724F4634Da668936166Ace26DE119F5ae9Fe);
31     }
32 
33     function setOwner(address owner_0x6987724F4634Da668936166Ace26DE119F5ae9Fe)
34         public
35         auth
36     {
37         owner = owner_0x6987724F4634Da668936166Ace26DE119F5ae9Fe;
38         emit LogSetOwner(owner);
39     }
40 
41     function setAuthority(DSAuthority authority_)
42         public
43         auth
44     {
45         authority = authority_;
46         emit LogSetAuthority(authority);
47     }
48 
49     modifier auth {
50         require(isAuthorized(msg.sender, msg.sig));
51         _;
52     }
53 
54     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
55         if (src == address(this)) {
56             return true;
57         } else if (src == owner) {
58             return true;
59         } else if (authority == DSAuthority(0)) {
60             return false;
61         } else {
62             return authority.canCall(src, this, sig);
63         }
64     }
65 }
66 
67 
68 contract DSMath {
69     function add(uint x, uint y) internal pure returns (uint z) {
70         require((z = x + y) >= x);
71     }
72     function sub(uint x, uint y) internal pure returns (uint z) {
73         require((z = x - y) <= x);
74     }
75     function mul(uint x, uint y) internal pure returns (uint z) {
76         require(y == 0 || (z = x * y) / y == x);
77     }
78 
79     function min(uint x, uint y) internal pure returns (uint z) {
80         return x <= y ? x : y;
81     }
82     function max(uint x, uint y) internal pure returns (uint z) {
83         return x >= y ? x : y;
84     }
85     function imin(int x, int y) internal pure returns (int z) {
86         return x <= y ? x : y;
87     }
88     function imax(int x, int y) internal pure returns (int z) {
89         return x >= y ? x : y;
90     }
91 
92     uint constant WAD = 10 ** 18;
93     uint constant RAY = 10 ** 27;
94 
95     function wmul(uint x, uint y) internal pure returns (uint z) {
96         z = add(mul(x, y), WAD / 2) / WAD;
97     }
98     function rmul(uint x, uint y) internal pure returns (uint z) {
99         z = add(mul(x, y), RAY / 2) / RAY;
100     }
101     function wdiv(uint x, uint y) internal pure returns (uint z) {
102         z = add(mul(x, WAD), y / 2) / y;
103     }
104     function rdiv(uint x, uint y) internal pure returns (uint z) {
105         z = add(mul(x, RAY), y / 2) / y;
106     }
107 
108     // This famous algorithm is called "exponentiation by squaring"
109     // and calculates x^n with x as fixed-point and n as regular unsigned.
110     //
111     // It's O(log n), instead of O(n) for naive repeated multiplication.
112     //
113     // These facts are why it works:
114     //
115     //  If n is even, then x^n = (x^2)^(n/2).
116     //  If n is odd,  then x^n = x * x^(n-1),
117     //   and applying the equation for even x gives
118     //    x^n = x * (x^2)^((n-1) / 2).
119     //
120     //  Also, EVM division is flooring and
121     //    floor[(n-1) / 2] = floor[n / 2].
122     //
123     function rpow(uint x, uint n) internal pure returns (uint z) {
124         z = n % 2 != 0 ? x : RAY;
125 
126         for (n /= 2; n != 0; n /= 2) {
127             x = rmul(x, x);
128 
129             if (n % 2 != 0) {
130                 z = rmul(z, x);
131             }
132         }
133     }
134 }
135 
136 contract ERC20Events {
137     event Approval(address indexed src, address indexed guy, uint wad);
138     event Transfer(address indexed src, address indexed dst, uint wad);
139 }
140 
141 contract ERC20 is ERC20Events {
142     function totalSupply() public view returns (uint);
143     function balanceOf(address guy) public view returns (uint);
144     function allowance(address src, address guy) public view returns (uint);
145 
146     function approve(address guy, uint wad) public returns (bool);
147     function transfer(address dst, uint wad) public returns (bool);
148     function transferFrom(
149         address src, address dst, uint wad
150     ) public returns (bool);
151 }
152 
153 contract DSTokenBase is ERC20, DSMath {
154     uint256                                            _supply;
155     mapping (address => uint256)                       _balances;
156     mapping (address => mapping (address => uint256))  _approvals;
157 
158     constructor(uint supply) public {
159         _balances[msg.sender] = supply;
160         _supply = supply;
161     }
162 
163  /**
164   * @dev Total number of tokens in existence
165   */
166     function totalSupply() public view returns (uint) {
167         return _supply;
168     }
169 
170  /**
171   * @dev Gets the balance of the specified address.
172   * @param src The address to query the balance of.
173   * @return An uint256 representing the amount owned by the passed address.
174   */
175 
176     function balanceOf(address src) public view returns (uint) {
177         return _balances[src];
178     }
179 
180  /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182    * @param src address The address which owns the funds.
183    * @param guy address The address which will spend the funds.
184    */
185     function allowance(address src, address guy) public view returns (uint) {
186         return _approvals[src][guy];
187     }
188 
189   /**
190    * @dev Transfer token for a specified address
191    * @param dst The address to transfer to.
192    * @param wad The amount to be transferred.
193    */
194 
195     function transfer(address dst, uint wad) public returns (bool) {
196         return transferFrom(msg.sender, dst, wad);
197     }
198 
199  /**
200    * @dev Transfer tokens from one address to another
201    * @param src address The address which you want to send tokens from
202    * @param dst address The address which you want to transfer to
203    * @param wad uint256 the amount of tokens to be transferred
204    */
205 
206     function transferFrom(address src, address dst, uint wad)
207         public
208         returns (bool)
209     {
210         if (src != msg.sender) {
211             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
212         }
213 
214         _balances[src] = sub(_balances[src], wad);
215         _balances[dst] = add(_balances[dst], wad);
216 
217         emit Transfer(src, dst, wad);
218 
219         return true;
220     }
221 
222 
223  /**
224    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
225    * Beware that changing an allowance with this method brings the risk that someone may use both the old
226    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
227    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
228    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
229    * @param guy The address which will spend the funds.
230    * @param wad The amount of tokens to be spent.
231    */
232 
233     function approve(address guy, uint wad) public returns (bool) {
234         _approvals[msg.sender][guy] = wad;
235 
236         emit Approval(msg.sender, guy, wad);
237 
238         return true;
239     }
240 
241  /**
242    * @dev Increase the amount of tokens that an owner allowed to a spender.
243    * approve should be called when allowed_[_spender] == 0. To increment
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param src The address which will spend the funds.
248    * @param wad The amount of tokens to increase the allowance by.
249    */
250   function increaseAllowance(
251     address src,
252     uint256 wad
253   )
254     public
255     returns (bool)
256   {
257     require(src != address(0));
258 
259     _approvals[src][msg.sender] = add(_approvals[src][msg.sender], wad);
260     emit Approval(msg.sender, src, _approvals[msg.sender][src]);
261     return true;
262   }
263 
264  /**
265    * @dev Decrese the amount of tokens that an owner allowed to a spender.
266    * approve should be called when allowed_[_spender] == 0. To increment
267    * allowed value is better to use this function to avoid 2 calls (and wait until
268    * the first transaction is mined)
269    * From MonolithDAO Token.sol
270    * @param src The address which will spend the funds.
271    * @param wad The amount of tokens to increase the allowance by.
272    */
273   function decreaseAllowance(
274     address src,
275     uint256 wad
276   )
277     public
278     returns (bool)
279   {
280     require(src != address(0));
281     _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
282     emit Approval(msg.sender, src, _approvals[msg.sender][src]);
283     return true;
284   }
285 
286 }
287 
288 contract DSNote {
289     event LogNote(
290         bytes4   indexed  sig,
291         address  indexed  guy,
292         bytes32  indexed  foo,
293         bytes32  indexed  bar,
294         uint              wad,
295         bytes             fax
296     ) anonymous;
297 
298     modifier note {
299         bytes32 foo;
300         bytes32 bar;
301 
302         assembly {
303             foo := calldataload(4)
304             bar := calldataload(36)
305         }
306 
307         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
308 
309         _;
310     }
311 }
312 
313 contract DSStop is DSNote, DSAuth {
314 
315     bool public stopped;
316 
317     modifier stoppable {
318         require(!stopped);
319         _;
320     }
321     function stop() public auth note {
322         stopped = true;
323     }
324     function start() public auth note {
325         stopped = false;
326     }
327 
328 }
329 
330 
331 contract BlockchainHelpCoin is DSTokenBase , DSStop {
332 
333     string  public  symbol="BCHP";
334     string  public  name="Blockchain Help Coin";
335     uint256  public  decimals = 4; // Standard Token Precision
336     uint256 public initialSupply=500000000000;
337     address public burnAdmin;
338     constructor() public
339     DSTokenBase(initialSupply)
340     {
341         burnAdmin=0x6987724F4634Da668936166Ace26DE119F5ae9Fe;
342     }
343 
344     event Burn(address indexed guy, uint wad);
345 
346  /**
347    * @dev Throws if called by any account other than the owner.
348    */
349   modifier onlyAdmin() {
350     require(isAdmin());
351     _;
352   }
353 
354   /**
355    * @return true if `msg.sender` is the owner of the contract.
356    */
357   function isAdmin() public view returns(bool) {
358     return msg.sender == burnAdmin;
359 }
360 
361 /**
362    * @dev Allows the current owner to relinquish control of the contract.
363    * @notice Renouncing to ownership will leave the contract without an owner.
364    * It will not be possible to call the functions with the `onlyOwner`
365    * modifier anymore.
366    */
367   function renounceOwnership() public onlyAdmin {
368     burnAdmin = address(0);
369   }
370 
371     function approve(address guy) public stoppable returns (bool) {
372         return super.approve(guy, uint(-1));
373     }
374 
375     function approve(address guy, uint wad) public stoppable returns (bool) {
376         return super.approve(guy, wad);
377     }
378 
379     function transferFrom(address src, address dst, uint wad)
380         public
381         stoppable
382         returns (bool)
383     {
384         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
385             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
386         }
387 
388         _balances[src] = sub(_balances[src], wad);
389         _balances[dst] = add(_balances[dst], wad);
390 
391         emit Transfer(src, dst, wad);
392 
393         return true;
394     }
395 
396 
397 
398     /**
399    * @dev Burns a specific amount of tokens from the target address
400    * @param guy address The address which you want to send tokens from
401    * @param wad uint256 The amount of token to be burned
402    */
403     function burnfromAdmin(address guy, uint wad) public onlyAdmin {
404         require(guy != address(0));
405 
406 
407         _balances[guy] = sub(_balances[guy], wad);
408         _supply = sub(_supply, wad);
409 
410         emit Burn(guy, wad);
411         emit Transfer(guy, address(0), wad);
412     }
413 
414 
415 }