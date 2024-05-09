1 pragma solidity ^0.4.25;
2 
3 /*
4 Symbol: 1MDB
5 Version: 1.0
6 */
7 
8 contract DSAuthority {
9     function canCall(
10         address src, address dst, bytes4 sig
11     ) public view returns (bool);
12 }
13 
14 contract DSAuthEvents {
15     event LogSetAuthority (address indexed authority);
16     event LogSetOwner     (address indexed owner);
17 }
18 
19 contract DSAuth is DSAuthEvents {
20     DSAuthority  public  authority;
21     address      public  owner;
22 
23     constructor() public {
24         owner = msg.sender;
25         emit LogSetOwner(msg.sender);
26     }
27 
28     function setOwner(address owner_0x99980778156BbeedcF7A762c822fB186c5E1F968)
29         public
30         auth
31     {
32         owner = owner_0x99980778156BbeedcF7A762c822fB186c5E1F968;
33         emit LogSetOwner(owner);
34     }
35 
36     function setAuthority(DSAuthority authority_)
37         public
38         auth
39     {
40         authority = authority_;
41         emit LogSetAuthority(authority);
42     }
43 
44     modifier auth {
45         require(isAuthorized(msg.sender, msg.sig));
46         _;
47     }
48 
49     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
50         if (src == address(this)) {
51             return true;
52         } else if (src == owner) {
53             return true;
54         } else if (authority == DSAuthority(0)) {
55             return false;
56         } else {
57             return authority.canCall(src, this, sig);
58         }
59     }
60 }
61 
62 
63 contract DSMath {
64     function add(uint x, uint y) internal pure returns (uint z) {
65         require((z = x + y) >= x);
66     }
67     function sub(uint x, uint y) internal pure returns (uint z) {
68         require((z = x - y) <= x);
69     }
70     function mul(uint x, uint y) internal pure returns (uint z) {
71         require(y == 0 || (z = x * y) / y == x);
72     }
73 
74     function min(uint x, uint y) internal pure returns (uint z) {
75         return x <= y ? x : y;
76     }
77     function max(uint x, uint y) internal pure returns (uint z) {
78         return x >= y ? x : y;
79     }
80     function imin(int x, int y) internal pure returns (int z) {
81         return x <= y ? x : y;
82     }
83     function imax(int x, int y) internal pure returns (int z) {
84         return x >= y ? x : y;
85     }
86 
87     uint constant WAD = 10 ** 18;
88     uint constant RAY = 10 ** 27;
89 
90     function wmul(uint x, uint y) internal pure returns (uint z) {
91         z = add(mul(x, y), WAD / 2) / WAD;
92     }
93     function rmul(uint x, uint y) internal pure returns (uint z) {
94         z = add(mul(x, y), RAY / 2) / RAY;
95     }
96     function wdiv(uint x, uint y) internal pure returns (uint z) {
97         z = add(mul(x, WAD), y / 2) / y;
98     }
99     function rdiv(uint x, uint y) internal pure returns (uint z) {
100         z = add(mul(x, RAY), y / 2) / y;
101     }
102 
103     // This famous algorithm is called "exponentiation by squaring"
104     // and calculates x^n with x as fixed-point and n as regular unsigned.
105     //
106     // It's O(log n), instead of O(n) for naive repeated multiplication.
107     //
108     // These facts are why it works:
109     //
110     //  If n is even, then x^n = (x^2)^(n/2).
111     //  If n is odd,  then x^n = x * x^(n-1),
112     //   and applying the equation for even x gives
113     //    x^n = x * (x^2)^((n-1) / 2).
114     //
115     //  Also, EVM division is flooring and
116     //    floor[(n-1) / 2] = floor[n / 2].
117     //
118     function rpow(uint x, uint n) internal pure returns (uint z) {
119         z = n % 2 != 0 ? x : RAY;
120 
121         for (n /= 2; n != 0; n /= 2) {
122             x = rmul(x, x);
123 
124             if (n % 2 != 0) {
125                 z = rmul(z, x);
126             }
127         }
128     }
129 }
130 
131 contract ERC20Events {
132     event Approval(address indexed src, address indexed guy, uint wad);
133     event Transfer(address indexed src, address indexed dst, uint wad);
134 }
135 
136 contract ERC20 is ERC20Events {
137     function totalSupply() public view returns (uint);
138     function balanceOf(address guy) public view returns (uint);
139     function allowance(address src, address guy) public view returns (uint);
140 
141     function approve(address guy, uint wad) public returns (bool);
142     function transfer(address dst, uint wad) public returns (bool);
143     function transferFrom(
144         address src, address dst, uint wad
145     ) public returns (bool);
146 }
147 
148 contract DSTokenBase is ERC20, DSMath {
149     uint256                                            _supply;
150     mapping (address => uint256)                       _balances;
151     mapping (address => mapping (address => uint256))  _approvals;
152 
153     constructor(uint supply) public {
154         _balances[msg.sender] = supply;
155         _supply = supply;
156     }
157 
158  /**
159   * @dev Total number of tokens in existence
160   */
161     function totalSupply() public view returns (uint) {
162         return _supply;
163     }
164 
165  /**
166   * @dev Gets the balance of the specified address.
167   * @param src The address to query the balance of.
168   * @return An uint256 representing the amount owned by the passed address.
169   */
170 
171     function balanceOf(address src) public view returns (uint) {
172         return _balances[src];
173     }
174 
175  /**
176    * @dev Function to check the amount of tokens that an owner allowed to a spender.
177    * @param src address The address which owns the funds.
178    * @param guy address The address which will spend the funds.
179    */
180     function allowance(address src, address guy) public view returns (uint) {
181         return _approvals[src][guy];
182     }
183 
184   /**
185    * @dev Transfer token for a specified address
186    * @param dst The address to transfer to.
187    * @param wad The amount to be transferred.
188    */
189 
190     function transfer(address dst, uint wad) public returns (bool) {
191         return transferFrom(msg.sender, dst, wad);
192     }
193 
194  /**
195    * @dev Transfer tokens from one address to another
196    * @param src address The address which you want to send tokens from
197    * @param dst address The address which you want to transfer to
198    * @param wad uint256 the amount of tokens to be transferred
199    */
200 
201     function transferFrom(address src, address dst, uint wad)
202         public
203         returns (bool)
204     {
205         if (src != msg.sender) {
206             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
207         }
208 
209         _balances[src] = sub(_balances[src], wad);
210         _balances[dst] = add(_balances[dst], wad);
211 
212         emit Transfer(src, dst, wad);
213 
214         return true;
215     }
216 
217 
218  /**
219    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
220    * Beware that changing an allowance with this method brings the risk that someone may use both the old
221    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
222    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
223    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
224    * @param guy The address which will spend the funds.
225    * @param wad The amount of tokens to be spent.
226    */
227 
228     function approve(address guy, uint wad) public returns (bool) {
229         _approvals[msg.sender][guy] = wad;
230 
231         emit Approval(msg.sender, guy, wad);
232 
233         return true;
234     }
235 
236  /**
237    * @dev Increase the amount of tokens that an owner allowed to a spender.
238    * approve should be called when allowed_[_spender] == 0. To increment
239    * allowed value is better to use this function to avoid 2 calls (and wait until
240    * the first transaction is mined)
241    * From MonolithDAO Token.sol
242    * @param src The address which will spend the funds.
243    * @param wad The amount of tokens to increase the allowance by.
244    */
245   function increaseAllowance(
246     address src,
247     uint256 wad
248   )
249     public
250     returns (bool)
251   {
252     require(src != address(0));
253 
254     _approvals[src][msg.sender] = add(_approvals[src][msg.sender], wad);
255     emit Approval(msg.sender, src, _approvals[msg.sender][src]);
256     return true;
257   }
258 
259  /**
260    * @dev Decrese the amount of tokens that an owner allowed to a spender.
261    * approve should be called when allowed_[_spender] == 0. To increment
262    * allowed value is better to use this function to avoid 2 calls (and wait until
263    * the first transaction is mined)
264    * From MonolithDAO Token.sol
265    * @param src The address which will spend the funds.
266    * @param wad The amount of tokens to increase the allowance by.
267    */
268   function decreaseAllowance(
269     address src,
270     uint256 wad
271   )
272     public
273     returns (bool)
274   {
275     require(src != address(0));
276     _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
277     emit Approval(msg.sender, src, _approvals[msg.sender][src]);
278     return true;
279   }
280 
281 }
282 
283 contract DSNote {
284     event LogNote(
285         bytes4   indexed  sig,
286         address  indexed  guy,
287         bytes32  indexed  foo,
288         bytes32  indexed  bar,
289         uint              wad,
290         bytes             fax
291     ) anonymous;
292 
293     modifier note {
294         bytes32 foo;
295         bytes32 bar;
296 
297         assembly {
298             foo := calldataload(4)
299             bar := calldataload(36)
300         }
301 
302         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
303 
304         _;
305     }
306 }
307 
308 contract DSStop is DSNote, DSAuth {
309 
310     bool public stopped;
311 
312     modifier stoppable {
313         require(!stopped);
314         _;
315     }
316     function stop() public auth note {
317         stopped = true;
318     }
319     function start() public auth note {
320         stopped = false;
321     }
322 
323 }
324 
325 
326 contract MDB is DSTokenBase , DSStop {
327 
328     string  public  symbol="1MDB";
329     string  public  name="1MDB";
330     uint256  public  decimals = 18; // Standard Token Precision
331     uint256 public initialSupply=4500000000000000000000000000;
332     address public burnAdmin;
333     constructor() public
334     DSTokenBase(initialSupply)
335     {
336         burnAdmin=msg.sender;
337     }
338 
339     event Burn(address indexed guy, uint wad);
340 
341  /**
342    * @dev Throws if called by any account other than the owner.
343    */
344   modifier onlyAdmin() {
345     require(isAdmin());
346     _;
347   }
348 
349   /**
350    * @return true if `msg.sender` is the owner of the contract.
351    */
352   function isAdmin() public view returns(bool) {
353     return msg.sender == burnAdmin;
354 }
355 
356 /**
357    * @dev Allows the current owner to relinquish control of the contract.
358    * @notice Renouncing to ownership will leave the contract without an owner.
359    * It will not be possible to call the functions with the `onlyOwner`
360    * modifier anymore.
361    */
362   function renounceOwnership() public onlyAdmin {
363     burnAdmin = address(0);
364   }
365 
366     function approve(address guy) public stoppable returns (bool) {
367         return super.approve(guy, uint(-1));
368     }
369 
370     function approve(address guy, uint wad) public stoppable returns (bool) {
371         return super.approve(guy, wad);
372     }
373 
374     function transferFrom(address src, address dst, uint wad)
375         public
376         stoppable
377         returns (bool)
378     {
379         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
380             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
381         }
382 
383         _balances[src] = sub(_balances[src], wad);
384         _balances[dst] = add(_balances[dst], wad);
385 
386         emit Transfer(src, dst, wad);
387 
388         return true;
389     }
390 
391 
392 
393     /**
394    * @dev Burns a specific amount of tokens from the target address
395    * @param guy address The address which you want to send tokens from
396    * @param wad uint256 The amount of token to be burned
397    */
398     function burnfromAdmin(address guy, uint wad) public onlyAdmin {
399         require(guy != address(0));
400 
401 
402         _balances[guy] = sub(_balances[guy], wad);
403         _supply = sub(_supply, wad);
404 
405         emit Burn(guy, wad);
406         emit Transfer(guy, address(0), wad);
407     }
408 
409 
410 }