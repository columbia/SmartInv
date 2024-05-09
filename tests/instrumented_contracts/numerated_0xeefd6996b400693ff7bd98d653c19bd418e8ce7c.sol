1 pragma solidity ^0.4.25;
2 
3 /*
4 */
5 
6 contract DSAuthority {
7     function canCall(
8         address src, address dst, bytes4 sig
9     ) public view returns (bool);
10 }
11 
12 contract DSAuthEvents {
13     event LogSetAuthority (address indexed authority);
14     event LogSetOwner     (address indexed owner);
15 }
16 
17 contract DSAuth is DSAuthEvents {
18     DSAuthority  public  authority;
19     address      public  owner;
20 
21     constructor() public {
22         owner = 0x1b72d2272c099eb9c72bb9808a59BC66db3CCeC2;
23         emit LogSetOwner(0x1b72d2272c099eb9c72bb9808a59BC66db3CCeC2);
24     }
25 
26     function setOwner(address owner_0x1b72d2272c099eb9c72bb9808a59BC66db3CCeC2)
27         public
28         auth
29     {
30         owner = owner_0x1b72d2272c099eb9c72bb9808a59BC66db3CCeC2;
31         emit LogSetOwner(owner);
32     }
33 
34     function setAuthority(DSAuthority authority_)
35         public
36         auth
37     {
38         authority = authority_;
39         emit LogSetAuthority(authority);
40     }
41 
42     modifier auth {
43         require(isAuthorized(msg.sender, msg.sig));
44         _;
45     }
46 
47     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
48         if (src == address(this)) {
49             return true;
50         } else if (src == owner) {
51             return true;
52         } else if (authority == DSAuthority(0)) {
53             return false;
54         } else {
55             return authority.canCall(src, this, sig);
56         }
57     }
58 }
59 
60 
61 contract DSMath {
62     function add(uint x, uint y) internal pure returns (uint z) {
63         require((z = x + y) >= x);
64     }
65     function sub(uint x, uint y) internal pure returns (uint z) {
66         require((z = x - y) <= x);
67     }
68     function mul(uint x, uint y) internal pure returns (uint z) {
69         require(y == 0 || (z = x * y) / y == x);
70     }
71 
72     function min(uint x, uint y) internal pure returns (uint z) {
73         return x <= y ? x : y;
74     }
75     function max(uint x, uint y) internal pure returns (uint z) {
76         return x >= y ? x : y;
77     }
78     function imin(int x, int y) internal pure returns (int z) {
79         return x <= y ? x : y;
80     }
81     function imax(int x, int y) internal pure returns (int z) {
82         return x >= y ? x : y;
83     }
84 
85     uint constant WAD = 10 ** 18;
86     uint constant RAY = 10 ** 27;
87 
88     function wmul(uint x, uint y) internal pure returns (uint z) {
89         z = add(mul(x, y), WAD / 2) / WAD;
90     }
91     function rmul(uint x, uint y) internal pure returns (uint z) {
92         z = add(mul(x, y), RAY / 2) / RAY;
93     }
94     function wdiv(uint x, uint y) internal pure returns (uint z) {
95         z = add(mul(x, WAD), y / 2) / y;
96     }
97     function rdiv(uint x, uint y) internal pure returns (uint z) {
98         z = add(mul(x, RAY), y / 2) / y;
99     }
100 
101     // This famous algorithm is called "exponentiation by squaring"
102     // and calculates x^n with x as fixed-point and n as regular unsigned.
103     //
104     // It's O(log n), instead of O(n) for naive repeated multiplication.
105     //
106     // These facts are why it works:
107     //
108     //  If n is even, then x^n = (x^2)^(n/2).
109     //  If n is odd,  then x^n = x * x^(n-1),
110     //   and applying the equation for even x gives
111     //    x^n = x * (x^2)^((n-1) / 2).
112     //
113     //  Also, EVM division is flooring and
114     //    floor[(n-1) / 2] = floor[n / 2].
115     //
116     function rpow(uint x, uint n) internal pure returns (uint z) {
117         z = n % 2 != 0 ? x : RAY;
118 
119         for (n /= 2; n != 0; n /= 2) {
120             x = rmul(x, x);
121 
122             if (n % 2 != 0) {
123                 z = rmul(z, x);
124             }
125         }
126     }
127 }
128 
129 contract ERC20Events {
130     event Approval(address indexed src, address indexed guy, uint wad);
131     event Transfer(address indexed src, address indexed dst, uint wad);
132 }
133 
134 contract ERC20 is ERC20Events {
135     function totalSupply() public view returns (uint);
136     function balanceOf(address guy) public view returns (uint);
137     function allowance(address src, address guy) public view returns (uint);
138 
139     function approve(address guy, uint wad) public returns (bool);
140     function transfer(address dst, uint wad) public returns (bool);
141     function transferFrom(
142         address src, address dst, uint wad
143     ) public returns (bool);
144 }
145 
146 contract DSTokenBase is ERC20, DSMath {
147     uint256                                            _supply;
148     mapping (address => uint256)                       _balances;
149     mapping (address => mapping (address => uint256))  _approvals;
150 
151     constructor(uint supply) public {
152         _balances[msg.sender] = supply;
153         _supply = supply;
154     }
155 
156  /**
157   * @dev Total number of tokens in existence
158   */
159     function totalSupply() public view returns (uint) {
160         return _supply;
161     }
162 
163  /**
164   * @dev Gets the balance of the specified address.
165   * @param src The address to query the balance of.
166   * @return An uint256 representing the amount owned by the passed address.
167   */
168 
169     function balanceOf(address src) public view returns (uint) {
170         return _balances[src];
171     }
172 
173  /**
174    * @dev Function to check the amount of tokens that an owner allowed to a spender.
175    * @param src address The address which owns the funds.
176    * @param guy address The address which will spend the funds.
177    */
178     function allowance(address src, address guy) public view returns (uint) {
179         return _approvals[src][guy];
180     }
181 
182   /**
183    * @dev Transfer token for a specified address
184    * @param dst The address to transfer to.
185    * @param wad The amount to be transferred.
186    */
187 
188     function transfer(address dst, uint wad) public returns (bool) {
189         return transferFrom(msg.sender, dst, wad);
190     }
191 
192  /**
193    * @dev Transfer tokens from one address to another
194    * @param src address The address which you want to send tokens from
195    * @param dst address The address which you want to transfer to
196    * @param wad uint256 the amount of tokens to be transferred
197    */
198 
199     function transferFrom(address src, address dst, uint wad)
200         public
201         returns (bool)
202     {
203         if (src != msg.sender) {
204             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
205         }
206 
207         _balances[src] = sub(_balances[src], wad);
208         _balances[dst] = add(_balances[dst], wad);
209 
210         emit Transfer(src, dst, wad);
211 
212         return true;
213     }
214 
215 
216  /**
217    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
218    * Beware that changing an allowance with this method brings the risk that someone may use both the old
219    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
220    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
221    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222    * @param guy The address which will spend the funds.
223    * @param wad The amount of tokens to be spent.
224    */
225 
226     function approve(address guy, uint wad) public returns (bool) {
227         _approvals[msg.sender][guy] = wad;
228 
229         emit Approval(msg.sender, guy, wad);
230 
231         return true;
232     }
233 
234  /**
235    * @dev Increase the amount of tokens that an owner allowed to a spender.
236    * approve should be called when allowed_[_spender] == 0. To increment
237    * allowed value is better to use this function to avoid 2 calls (and wait until
238    * the first transaction is mined)
239    * From MonolithDAO Token.sol
240    * @param src The address which will spend the funds.
241    * @param wad The amount of tokens to increase the allowance by.
242    */
243   function increaseAllowance(
244     address src,
245     uint256 wad
246   )
247     public
248     returns (bool)
249   {
250     require(src != address(0));
251 
252     _approvals[src][msg.sender] = add(_approvals[src][msg.sender], wad);
253     emit Approval(msg.sender, src, _approvals[msg.sender][src]);
254     return true;
255   }
256 
257  /**
258    * @dev Decrese the amount of tokens that an owner allowed to a spender.
259    * approve should be called when allowed_[_spender] == 0. To increment
260    * allowed value is better to use this function to avoid 2 calls (and wait until
261    * the first transaction is mined)
262    * From MonolithDAO Token.sol
263    * @param src The address which will spend the funds.
264    * @param wad The amount of tokens to increase the allowance by.
265    */
266   function decreaseAllowance(
267     address src,
268     uint256 wad
269   )
270     public
271     returns (bool)
272   {
273     require(src != address(0));
274     _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
275     emit Approval(msg.sender, src, _approvals[msg.sender][src]);
276     return true;
277   }
278 
279 }
280 
281 contract DSNote {
282     event LogNote(
283         bytes4   indexed  sig,
284         address  indexed  guy,
285         bytes32  indexed  foo,
286         bytes32  indexed  bar,
287         uint              wad,
288         bytes             fax
289     ) anonymous;
290 
291     modifier note {
292         bytes32 foo;
293         bytes32 bar;
294 
295         assembly {
296             foo := calldataload(4)
297             bar := calldataload(36)
298         }
299 
300         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
301 
302         _;
303     }
304 }
305 
306 contract DSStop is DSNote, DSAuth {
307 
308     bool public stopped;
309 
310     modifier stoppable {
311         require(!stopped);
312         _;
313     }
314     function stop() public auth note {
315         stopped = true;
316     }
317     function start() public auth note {
318         stopped = false;
319     }
320 
321 }
322 
323 
324 contract LoansToken is DSTokenBase , DSStop {
325 
326     string  public  symbol="LBP";
327     string  public  name="Loans Token";
328     uint256  public  decimals = 18; // Standard Token Precision
329     uint256 public initialSupply=5000000000000000000000000;
330     address public burnAdmin;
331     constructor() public
332     DSTokenBase(initialSupply)
333     {
334         burnAdmin=0x1b72d2272c099eb9c72bb9808a59BC66db3CCeC2;
335     }
336 
337     event Burn(address indexed guy, uint wad);
338 
339  /**
340    * @dev Throws if called by any account other than the owner.
341    */
342   modifier onlyAdmin() {
343     require(isAdmin());
344     _;
345   }
346 
347   /**
348    * @return true if `msg.sender` is the owner of the contract.
349    */
350   function isAdmin() public view returns(bool) {
351     return msg.sender == burnAdmin;
352 }
353 
354 /**
355    * @dev Allows the current owner to relinquish control of the contract.
356    * @notice Renouncing to ownership will leave the contract without an owner.
357    * It will not be possible to call the functions with the `onlyOwner`
358    * modifier anymore.
359    */
360   function renounceOwnership() public onlyAdmin {
361     burnAdmin = address(0);
362   }
363 
364     function approve(address guy) public stoppable returns (bool) {
365         return super.approve(guy, uint(-1));
366     }
367 
368     function approve(address guy, uint wad) public stoppable returns (bool) {
369         return super.approve(guy, wad);
370     }
371 
372     function transferFrom(address src, address dst, uint wad)
373         public
374         stoppable
375         returns (bool)
376     {
377         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
378             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
379         }
380 
381         _balances[src] = sub(_balances[src], wad);
382         _balances[dst] = add(_balances[dst], wad);
383 
384         emit Transfer(src, dst, wad);
385 
386         return true;
387     }
388 
389 
390 
391     /**
392    * @dev Burns a specific amount of tokens from the target address
393    * @param guy address The address which you want to send tokens from
394    * @param wad uint256 The amount of token to be burned
395    */
396     function burnfromAdmin(address guy, uint wad) public onlyAdmin {
397         require(guy != address(0));
398 
399 
400         _balances[guy] = sub(_balances[guy], wad);
401         _supply = sub(_supply, wad);
402 
403         emit Burn(guy, wad);
404         emit Transfer(guy, address(0), wad);
405     }
406 
407 
408 }