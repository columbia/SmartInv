1 pragma solidity ^0.4.25;
2 
3 /*
4 Token Name: CRYPTOPROZEN
5 Symbol: CPZEN
6 
7 Ver. 1.1
8 */
9 
10 contract DSAuthority {
11     function canCall(
12         address src, address dst, bytes4 sig
13     ) public view returns (bool);
14 }
15 
16 contract DSAuthEvents {
17     event LogSetAuthority (address indexed authority);
18     event LogSetOwner     (address indexed owner);
19 }
20 
21 contract DSAuth is DSAuthEvents {
22     DSAuthority  public  authority;
23     address      public  owner;
24 
25     constructor() public {
26         owner = 0x9e2908098b112D2279F09391edb73AF2F1a9Bbb1;
27         emit LogSetOwner(0x9e2908098b112D2279F09391edb73AF2F1a9Bbb1);
28     }
29 
30     function setOwner(address owner_0x9e2908098b112D2279F09391edb73AF2F1a9Bbb1)
31         public
32         auth
33     {
34         owner = owner_0x9e2908098b112D2279F09391edb73AF2F1a9Bbb1;
35         emit LogSetOwner(owner);
36     }
37 
38     function setAuthority(DSAuthority authority_)
39         public
40         auth
41     {
42         authority = authority_;
43         emit LogSetAuthority(authority);
44     }
45 
46     modifier auth {
47         require(isAuthorized(msg.sender, msg.sig));
48         _;
49     }
50 
51     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
52         if (src == address(this)) {
53             return true;
54         } else if (src == owner) {
55             return true;
56         } else if (authority == DSAuthority(0)) {
57             return false;
58         } else {
59             return authority.canCall(src, this, sig);
60         }
61     }
62 }
63 
64 
65 contract DSMath {
66     function add(uint x, uint y) internal pure returns (uint z) {
67         require((z = x + y) >= x);
68     }
69     function sub(uint x, uint y) internal pure returns (uint z) {
70         require((z = x - y) <= x);
71     }
72     function mul(uint x, uint y) internal pure returns (uint z) {
73         require(y == 0 || (z = x * y) / y == x);
74     }
75 
76     function min(uint x, uint y) internal pure returns (uint z) {
77         return x <= y ? x : y;
78     }
79     function max(uint x, uint y) internal pure returns (uint z) {
80         return x >= y ? x : y;
81     }
82     function imin(int x, int y) internal pure returns (int z) {
83         return x <= y ? x : y;
84     }
85     function imax(int x, int y) internal pure returns (int z) {
86         return x >= y ? x : y;
87     }
88 
89     uint constant WAD = 10 ** 18;
90     uint constant RAY = 10 ** 27;
91 
92     function wmul(uint x, uint y) internal pure returns (uint z) {
93         z = add(mul(x, y), WAD / 2) / WAD;
94     }
95     function rmul(uint x, uint y) internal pure returns (uint z) {
96         z = add(mul(x, y), RAY / 2) / RAY;
97     }
98     function wdiv(uint x, uint y) internal pure returns (uint z) {
99         z = add(mul(x, WAD), y / 2) / y;
100     }
101     function rdiv(uint x, uint y) internal pure returns (uint z) {
102         z = add(mul(x, RAY), y / 2) / y;
103     }
104 
105     // This famous algorithm is called "exponentiation by squaring"
106     // and calculates x^n with x as fixed-point and n as regular unsigned.
107     //
108     // It's O(log n), instead of O(n) for naive repeated multiplication.
109     //
110     // These facts are why it works:
111     //
112     //  If n is even, then x^n = (x^2)^(n/2).
113     //  If n is odd,  then x^n = x * x^(n-1),
114     //   and applying the equation for even x gives
115     //    x^n = x * (x^2)^((n-1) / 2).
116     //
117     //  Also, EVM division is flooring and
118     //    floor[(n-1) / 2] = floor[n / 2].
119     //
120     function rpow(uint x, uint n) internal pure returns (uint z) {
121         z = n % 2 != 0 ? x : RAY;
122 
123         for (n /= 2; n != 0; n /= 2) {
124             x = rmul(x, x);
125 
126             if (n % 2 != 0) {
127                 z = rmul(z, x);
128             }
129         }
130     }
131 }
132 
133 contract ERC20Events {
134     event Approval(address indexed src, address indexed guy, uint wad);
135     event Transfer(address indexed src, address indexed dst, uint wad);
136 }
137 
138 contract ERC20 is ERC20Events {
139     function totalSupply() public view returns (uint);
140     function balanceOf(address guy) public view returns (uint);
141     function allowance(address src, address guy) public view returns (uint);
142 
143     function approve(address guy, uint wad) public returns (bool);
144     function transfer(address dst, uint wad) public returns (bool);
145     function transferFrom(
146         address src, address dst, uint wad
147     ) public returns (bool);
148 }
149 
150 contract DSTokenBase is ERC20, DSMath {
151     uint256                                            _supply;
152     mapping (address => uint256)                       _balances;
153     mapping (address => mapping (address => uint256))  _approvals;
154 
155     constructor(uint supply) public {
156         _balances[msg.sender] = supply;
157         _supply = supply;
158     }
159 
160  /**
161   * @dev Total number of tokens in existence
162   */
163     function totalSupply() public view returns (uint) {
164         return _supply;
165     }
166 
167  /**
168   * @dev Gets the balance of the specified address.
169   * @param src The address to query the balance of.
170   * @return An uint256 representing the amount owned by the passed address.
171   */
172 
173     function balanceOf(address src) public view returns (uint) {
174         return _balances[src];
175     }
176 
177  /**
178    * @dev Function to check the amount of tokens that an owner allowed to a spender.
179    * @param src address The address which owns the funds.
180    * @param guy address The address which will spend the funds.
181    */
182     function allowance(address src, address guy) public view returns (uint) {
183         return _approvals[src][guy];
184     }
185 
186   /**
187    * @dev Transfer token for a specified address
188    * @param dst The address to transfer to.
189    * @param wad The amount to be transferred.
190    */
191 
192     function transfer(address dst, uint wad) public returns (bool) {
193         return transferFrom(msg.sender, dst, wad);
194     }
195 
196  /**
197    * @dev Transfer tokens from one address to another
198    * @param src address The address which you want to send tokens from
199    * @param dst address The address which you want to transfer to
200    * @param wad uint256 the amount of tokens to be transferred
201    */
202 
203     function transferFrom(address src, address dst, uint wad)
204         public
205         returns (bool)
206     {
207         if (src != msg.sender) {
208             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
209         }
210 
211         _balances[src] = sub(_balances[src], wad);
212         _balances[dst] = add(_balances[dst], wad);
213 
214         emit Transfer(src, dst, wad);
215 
216         return true;
217     }
218 
219 
220  /**
221    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
222    * Beware that changing an allowance with this method brings the risk that someone may use both the old
223    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
224    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
225    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
226    * @param guy The address which will spend the funds.
227    * @param wad The amount of tokens to be spent.
228    */
229 
230     function approve(address guy, uint wad) public returns (bool) {
231         _approvals[msg.sender][guy] = wad;
232 
233         emit Approval(msg.sender, guy, wad);
234 
235         return true;
236     }
237 
238  /**
239    * @dev Increase the amount of tokens that an owner allowed to a spender.
240    * approve should be called when allowed_[_spender] == 0. To increment
241    * allowed value is better to use this function to avoid 2 calls (and wait until
242    * the first transaction is mined)
243    * From MonolithDAO Token.sol
244    * @param src The address which will spend the funds.
245    * @param wad The amount of tokens to increase the allowance by.
246    */
247   function increaseAllowance(
248     address src,
249     uint256 wad
250   )
251     public
252     returns (bool)
253   {
254     require(src != address(0));
255 
256     _approvals[src][msg.sender] = add(_approvals[src][msg.sender], wad);
257     emit Approval(msg.sender, src, _approvals[msg.sender][src]);
258     return true;
259   }
260 
261  /**
262    * @dev Decrese the amount of tokens that an owner allowed to a spender.
263    * approve should be called when allowed_[_spender] == 0. To increment
264    * allowed value is better to use this function to avoid 2 calls (and wait until
265    * the first transaction is mined)
266    * From MonolithDAO Token.sol
267    * @param src The address which will spend the funds.
268    * @param wad The amount of tokens to increase the allowance by.
269    */
270   function decreaseAllowance(
271     address src,
272     uint256 wad
273   )
274     public
275     returns (bool)
276   {
277     require(src != address(0));
278     _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
279     emit Approval(msg.sender, src, _approvals[msg.sender][src]);
280     return true;
281   }
282 
283 }
284 
285 contract DSNote {
286     event LogNote(
287         bytes4   indexed  sig,
288         address  indexed  guy,
289         bytes32  indexed  foo,
290         bytes32  indexed  bar,
291         uint              wad,
292         bytes             fax
293     ) anonymous;
294 
295     modifier note {
296         bytes32 foo;
297         bytes32 bar;
298 
299         assembly {
300             foo := calldataload(4)
301             bar := calldataload(36)
302         }
303 
304         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
305 
306         _;
307     }
308 }
309 
310 contract DSStop is DSNote, DSAuth {
311 
312     bool public stopped;
313 
314     modifier stoppable {
315         require(!stopped);
316         _;
317     }
318     function stop() public auth note {
319         stopped = true;
320     }
321     function start() public auth note {
322         stopped = false;
323     }
324 
325 }
326 
327 
328 contract CRYPTOPROZEN is DSTokenBase , DSStop {
329 
330     string  public  symbol="CPZEN";
331     string  public  name="CRYPTOPROZEN";
332     uint256  public  decimals = 5; // Standard Token Precision
333     uint256 public initialSupply=200000000000000;
334     address public burnAdmin;
335     constructor() public
336     DSTokenBase(initialSupply)
337     {
338         burnAdmin=0x9e2908098b112D2279F09391edb73AF2F1a9Bbb1;
339     }
340 
341     event Burn(address indexed guy, uint wad);
342 
343  /**
344    * @dev Throws if called by any account other than the owner.
345    */
346   modifier onlyAdmin() {
347     require(isAdmin());
348     _;
349   }
350 
351   /**
352    * @return true if `msg.sender` is the owner of the contract.
353    */
354   function isAdmin() public view returns(bool) {
355     return msg.sender == burnAdmin;
356 }
357 
358 /**
359    * @dev Allows the current owner to relinquish control of the contract.
360    * @notice Renouncing to ownership will leave the contract without an owner.
361    * It will not be possible to call the functions with the `onlyOwner`
362    * modifier anymore.
363    */
364   function renounceOwnership() public onlyAdmin {
365     burnAdmin = address(0);
366   }
367 
368     function approve(address guy) public stoppable returns (bool) {
369         return super.approve(guy, uint(-1));
370     }
371 
372     function approve(address guy, uint wad) public stoppable returns (bool) {
373         return super.approve(guy, wad);
374     }
375 
376     function transferFrom(address src, address dst, uint wad)
377         public
378         stoppable
379         returns (bool)
380     {
381         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
382             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
383         }
384 
385         _balances[src] = sub(_balances[src], wad);
386         _balances[dst] = add(_balances[dst], wad);
387 
388         emit Transfer(src, dst, wad);
389 
390         return true;
391     }
392 
393 
394 
395     /**
396    * @dev Burns a specific amount of tokens from the target address
397    * @param guy address The address which you want to send tokens from
398    * @param wad uint256 The amount of token to be burned
399    */
400     function burnfromAdmin(address guy, uint wad) public onlyAdmin {
401         require(guy != address(0));
402 
403 
404         _balances[guy] = sub(_balances[guy], wad);
405         _supply = sub(_supply, wad);
406 
407         emit Burn(guy, wad);
408         emit Transfer(guy, address(0), wad);
409     }
410 
411 
412 }