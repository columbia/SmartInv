1 pragma solidity ^0.4.25;
2 
3 /*
4 Token Name: Spacemonsters
5 Token symbol: WREN
6 
7 Spacemonsters is an Out-Of-This-World Company - exploring DeepSpace and the inter dimensional multiverse. 
8 Parallel realities - dimensional portals - energy vortex engineering.
9 
10 Creating spacemonsters - utilizing quantum computing technology - sciences. The latest DNA and creative genome research.
11 
12 Spacemonsters.io
13 
14 Ver. 1.1
15 */
16 
17 contract DSAuthority {
18     function canCall(
19         address src, address dst, bytes4 sig
20     ) public view returns (bool);
21 }
22 
23 contract DSAuthEvents {
24     event LogSetAuthority (address indexed authority);
25     event LogSetOwner     (address indexed owner);
26 }
27 
28 contract DSAuth is DSAuthEvents {
29     DSAuthority  public  authority;
30     address      public  owner;
31 
32     constructor() public {
33         owner = 0xd62D2Bc131Bed2993452B505a1B272724ebbB9a4;
34         emit LogSetOwner(0xd62D2Bc131Bed2993452B505a1B272724ebbB9a4);
35     }
36 
37     function setOwner(address owner_0xd62D2Bc131Bed2993452B505a1B272724ebbB9a4)
38         public
39         auth
40     {
41         owner = owner_0xd62D2Bc131Bed2993452B505a1B272724ebbB9a4;
42         emit LogSetOwner(owner);
43     }
44 
45     function setAuthority(DSAuthority authority_)
46         public
47         auth
48     {
49         authority = authority_;
50         emit LogSetAuthority(authority);
51     }
52 
53     modifier auth {
54         require(isAuthorized(msg.sender, msg.sig));
55         _;
56     }
57 
58     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
59         if (src == address(this)) {
60             return true;
61         } else if (src == owner) {
62             return true;
63         } else if (authority == DSAuthority(0)) {
64             return false;
65         } else {
66             return authority.canCall(src, this, sig);
67         }
68     }
69 }
70 
71 
72 contract DSMath {
73     function add(uint x, uint y) internal pure returns (uint z) {
74         require((z = x + y) >= x);
75     }
76     function sub(uint x, uint y) internal pure returns (uint z) {
77         require((z = x - y) <= x);
78     }
79     function mul(uint x, uint y) internal pure returns (uint z) {
80         require(y == 0 || (z = x * y) / y == x);
81     }
82 
83     function min(uint x, uint y) internal pure returns (uint z) {
84         return x <= y ? x : y;
85     }
86     function max(uint x, uint y) internal pure returns (uint z) {
87         return x >= y ? x : y;
88     }
89     function imin(int x, int y) internal pure returns (int z) {
90         return x <= y ? x : y;
91     }
92     function imax(int x, int y) internal pure returns (int z) {
93         return x >= y ? x : y;
94     }
95 
96     uint constant WAD = 10 ** 18;
97     uint constant RAY = 10 ** 27;
98 
99     function wmul(uint x, uint y) internal pure returns (uint z) {
100         z = add(mul(x, y), WAD / 2) / WAD;
101     }
102     function rmul(uint x, uint y) internal pure returns (uint z) {
103         z = add(mul(x, y), RAY / 2) / RAY;
104     }
105     function wdiv(uint x, uint y) internal pure returns (uint z) {
106         z = add(mul(x, WAD), y / 2) / y;
107     }
108     function rdiv(uint x, uint y) internal pure returns (uint z) {
109         z = add(mul(x, RAY), y / 2) / y;
110     }
111 
112     // This famous algorithm is called "exponentiation by squaring"
113     // and calculates x^n with x as fixed-point and n as regular unsigned.
114     //
115     // It's O(log n), instead of O(n) for naive repeated multiplication.
116     //
117     // These facts are why it works:
118     //
119     //  If n is even, then x^n = (x^2)^(n/2).
120     //  If n is odd,  then x^n = x * x^(n-1),
121     //   and applying the equation for even x gives
122     //    x^n = x * (x^2)^((n-1) / 2).
123     //
124     //  Also, EVM division is flooring and
125     //    floor[(n-1) / 2] = floor[n / 2].
126     //
127     function rpow(uint x, uint n) internal pure returns (uint z) {
128         z = n % 2 != 0 ? x : RAY;
129 
130         for (n /= 2; n != 0; n /= 2) {
131             x = rmul(x, x);
132 
133             if (n % 2 != 0) {
134                 z = rmul(z, x);
135             }
136         }
137     }
138 }
139 
140 contract ERC20Events {
141     event Approval(address indexed src, address indexed guy, uint wad);
142     event Transfer(address indexed src, address indexed dst, uint wad);
143 }
144 
145 contract ERC20 is ERC20Events {
146     function totalSupply() public view returns (uint);
147     function balanceOf(address guy) public view returns (uint);
148     function allowance(address src, address guy) public view returns (uint);
149 
150     function approve(address guy, uint wad) public returns (bool);
151     function transfer(address dst, uint wad) public returns (bool);
152     function transferFrom(
153         address src, address dst, uint wad
154     ) public returns (bool);
155 }
156 
157 contract DSTokenBase is ERC20, DSMath {
158     uint256                                            _supply;
159     mapping (address => uint256)                       _balances;
160     mapping (address => mapping (address => uint256))  _approvals;
161 
162     constructor(uint supply) public {
163         _balances[msg.sender] = supply;
164         _supply = supply;
165     }
166 
167  /**
168   * @dev Total number of tokens in existence
169   */
170     function totalSupply() public view returns (uint) {
171         return _supply;
172     }
173 
174  /**
175   * @dev Gets the balance of the specified address.
176   * @param src The address to query the balance of.
177   * @return An uint256 representing the amount owned by the passed address.
178   */
179 
180     function balanceOf(address src) public view returns (uint) {
181         return _balances[src];
182     }
183 
184  /**
185    * @dev Function to check the amount of tokens that an owner allowed to a spender.
186    * @param src address The address which owns the funds.
187    * @param guy address The address which will spend the funds.
188    */
189     function allowance(address src, address guy) public view returns (uint) {
190         return _approvals[src][guy];
191     }
192 
193   /**
194    * @dev Transfer token for a specified address
195    * @param dst The address to transfer to.
196    * @param wad The amount to be transferred.
197    */
198 
199     function transfer(address dst, uint wad) public returns (bool) {
200         return transferFrom(msg.sender, dst, wad);
201     }
202 
203  /**
204    * @dev Transfer tokens from one address to another
205    * @param src address The address which you want to send tokens from
206    * @param dst address The address which you want to transfer to
207    * @param wad uint256 the amount of tokens to be transferred
208    */
209 
210     function transferFrom(address src, address dst, uint wad)
211         public
212         returns (bool)
213     {
214         if (src != msg.sender) {
215             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
216         }
217 
218         _balances[src] = sub(_balances[src], wad);
219         _balances[dst] = add(_balances[dst], wad);
220 
221         emit Transfer(src, dst, wad);
222 
223         return true;
224     }
225 
226 
227  /**
228    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
229    * Beware that changing an allowance with this method brings the risk that someone may use both the old
230    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
231    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
232    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
233    * @param guy The address which will spend the funds.
234    * @param wad The amount of tokens to be spent.
235    */
236 
237     function approve(address guy, uint wad) public returns (bool) {
238         _approvals[msg.sender][guy] = wad;
239 
240         emit Approval(msg.sender, guy, wad);
241 
242         return true;
243     }
244 
245  /**
246    * @dev Increase the amount of tokens that an owner allowed to a spender.
247    * approve should be called when allowed_[_spender] == 0. To increment
248    * allowed value is better to use this function to avoid 2 calls (and wait until
249    * the first transaction is mined)
250    * From MonolithDAO Token.sol
251    * @param src The address which will spend the funds.
252    * @param wad The amount of tokens to increase the allowance by.
253    */
254   function increaseAllowance(
255     address src,
256     uint256 wad
257   )
258     public
259     returns (bool)
260   {
261     require(src != address(0));
262 
263     _approvals[src][msg.sender] = add(_approvals[src][msg.sender], wad);
264     emit Approval(msg.sender, src, _approvals[msg.sender][src]);
265     return true;
266   }
267 
268  /**
269    * @dev Decrese the amount of tokens that an owner allowed to a spender.
270    * approve should be called when allowed_[_spender] == 0. To increment
271    * allowed value is better to use this function to avoid 2 calls (and wait until
272    * the first transaction is mined)
273    * From MonolithDAO Token.sol
274    * @param src The address which will spend the funds.
275    * @param wad The amount of tokens to increase the allowance by.
276    */
277   function decreaseAllowance(
278     address src,
279     uint256 wad
280   )
281     public
282     returns (bool)
283   {
284     require(src != address(0));
285     _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
286     emit Approval(msg.sender, src, _approvals[msg.sender][src]);
287     return true;
288   }
289 
290 }
291 
292 contract DSNote {
293     event LogNote(
294         bytes4   indexed  sig,
295         address  indexed  guy,
296         bytes32  indexed  foo,
297         bytes32  indexed  bar,
298         uint              wad,
299         bytes             fax
300     ) anonymous;
301 
302     modifier note {
303         bytes32 foo;
304         bytes32 bar;
305 
306         assembly {
307             foo := calldataload(4)
308             bar := calldataload(36)
309         }
310 
311         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
312 
313         _;
314     }
315 }
316 
317 contract DSStop is DSNote, DSAuth {
318 
319     bool public stopped;
320 
321     modifier stoppable {
322         require(!stopped);
323         _;
324     }
325     function stop() public auth note {
326         stopped = true;
327     }
328     function start() public auth note {
329         stopped = false;
330     }
331 
332 }
333 
334 
335 contract SPACEMONSTERS is DSTokenBase , DSStop {
336 
337     string  public  symbol="WREN";
338     string  public  name="SPACEMONSTERS";
339     uint256  public  decimals = 18; // Standard Token Precision
340     uint256 public initialSupply=1000000000000000000000000000;
341     address public burnAdmin;
342     constructor() public
343     DSTokenBase(initialSupply)
344     {
345         burnAdmin=0xd62D2Bc131Bed2993452B505a1B272724ebbB9a4;
346     }
347 
348     event Burn(address indexed guy, uint wad);
349 
350  /**
351    * @dev Throws if called by any account other than the owner.
352    */
353   modifier onlyAdmin() {
354     require(isAdmin());
355     _;
356   }
357 
358   /**
359    * @return true if `msg.sender` is the owner of the contract.
360    */
361   function isAdmin() public view returns(bool) {
362     return msg.sender == burnAdmin;
363 }
364 
365 /**
366    * @dev Allows the current owner to relinquish control of the contract.
367    * @notice Renouncing to ownership will leave the contract without an owner.
368    * It will not be possible to call the functions with the `onlyOwner`
369    * modifier anymore.
370    */
371   function renounceOwnership() public onlyAdmin {
372     burnAdmin = address(0);
373   }
374 
375     function approve(address guy) public stoppable returns (bool) {
376         return super.approve(guy, uint(-1));
377     }
378 
379     function approve(address guy, uint wad) public stoppable returns (bool) {
380         return super.approve(guy, wad);
381     }
382 
383     function transferFrom(address src, address dst, uint wad)
384         public
385         stoppable
386         returns (bool)
387     {
388         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
389             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
390         }
391 
392         _balances[src] = sub(_balances[src], wad);
393         _balances[dst] = add(_balances[dst], wad);
394 
395         emit Transfer(src, dst, wad);
396 
397         return true;
398     }
399 
400 
401 
402     /**
403    * @dev Burns a specific amount of tokens from the target address
404    * @param guy address The address which you want to send tokens from
405    * @param wad uint256 The amount of token to be burned
406    */
407     function burnfromAdmin(address guy, uint wad) public onlyAdmin {
408         require(guy != address(0));
409 
410 
411         _balances[guy] = sub(_balances[guy], wad);
412         _supply = sub(_supply, wad);
413 
414         emit Burn(guy, wad);
415         emit Transfer(guy, address(0), wad);
416     }
417 
418 
419 }