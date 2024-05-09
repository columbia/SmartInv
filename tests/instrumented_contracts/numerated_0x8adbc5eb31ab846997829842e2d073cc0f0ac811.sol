1 pragma solidity ^0.4.25;
2 
3 /*
4 Name: DGT Coin 
5 Symbol: DGT
6 
7 Website: https://dgt.co.uk 
8 
9 Company: Florere Capital LTD
10 20-22 Wenlock Road
11 London | N1 7GU | United Kingdom
12 */
13 
14 contract DSAuthority {
15     function canCall(
16         address src, address dst, bytes4 sig
17     ) public view returns (bool);
18 }
19 
20 contract DSAuthEvents {
21     event LogSetAuthority (address indexed authority);
22     event LogSetOwner     (address indexed owner);
23 }
24 
25 contract DSAuth is DSAuthEvents {
26     DSAuthority  public  authority;
27     address      public  owner;
28 
29     constructor() public {
30         owner = 0x4c96522284400851F460eb935354200909F882bB;
31         emit LogSetOwner(0x4c96522284400851F460eb935354200909F882bB);
32     }
33 
34     function setOwner(address owner_0x4c96522284400851F460eb935354200909F882bB)
35         public
36         auth
37     {
38         owner = owner_0x4c96522284400851F460eb935354200909F882bB;
39         emit LogSetOwner(owner);
40     }
41 
42     function setAuthority(DSAuthority authority_)
43         public
44         auth
45     {
46         authority = authority_;
47         emit LogSetAuthority(authority);
48     }
49 
50     modifier auth {
51         require(isAuthorized(msg.sender, msg.sig));
52         _;
53     }
54 
55     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
56         if (src == address(this)) {
57             return true;
58         } else if (src == owner) {
59             return true;
60         } else if (authority == DSAuthority(0)) {
61             return false;
62         } else {
63             return authority.canCall(src, this, sig);
64         }
65     }
66 }
67 
68 
69 contract DSMath {
70     function add(uint x, uint y) internal pure returns (uint z) {
71         require((z = x + y) >= x);
72     }
73     function sub(uint x, uint y) internal pure returns (uint z) {
74         require((z = x - y) <= x);
75     }
76     function mul(uint x, uint y) internal pure returns (uint z) {
77         require(y == 0 || (z = x * y) / y == x);
78     }
79 
80     function min(uint x, uint y) internal pure returns (uint z) {
81         return x <= y ? x : y;
82     }
83     function max(uint x, uint y) internal pure returns (uint z) {
84         return x >= y ? x : y;
85     }
86     function imin(int x, int y) internal pure returns (int z) {
87         return x <= y ? x : y;
88     }
89     function imax(int x, int y) internal pure returns (int z) {
90         return x >= y ? x : y;
91     }
92 
93     uint constant WAD = 10 ** 18;
94     uint constant RAY = 10 ** 27;
95 
96     function wmul(uint x, uint y) internal pure returns (uint z) {
97         z = add(mul(x, y), WAD / 2) / WAD;
98     }
99     function rmul(uint x, uint y) internal pure returns (uint z) {
100         z = add(mul(x, y), RAY / 2) / RAY;
101     }
102     function wdiv(uint x, uint y) internal pure returns (uint z) {
103         z = add(mul(x, WAD), y / 2) / y;
104     }
105     function rdiv(uint x, uint y) internal pure returns (uint z) {
106         z = add(mul(x, RAY), y / 2) / y;
107     }
108 
109     // This famous algorithm is called "exponentiation by squaring"
110     // and calculates x^n with x as fixed-point and n as regular unsigned.
111     //
112     // It's O(log n), instead of O(n) for naive repeated multiplication.
113     //
114     // These facts are why it works:
115     //
116     //  If n is even, then x^n = (x^2)^(n/2).
117     //  If n is odd,  then x^n = x * x^(n-1),
118     //   and applying the equation for even x gives
119     //    x^n = x * (x^2)^((n-1) / 2).
120     //
121     //  Also, EVM division is flooring and
122     //    floor[(n-1) / 2] = floor[n / 2].
123     //
124     function rpow(uint x, uint n) internal pure returns (uint z) {
125         z = n % 2 != 0 ? x : RAY;
126 
127         for (n /= 2; n != 0; n /= 2) {
128             x = rmul(x, x);
129 
130             if (n % 2 != 0) {
131                 z = rmul(z, x);
132             }
133         }
134     }
135 }
136 
137 contract ERC20Events {
138     event Approval(address indexed src, address indexed guy, uint wad);
139     event Transfer(address indexed src, address indexed dst, uint wad);
140 }
141 
142 contract ERC20 is ERC20Events {
143     function totalSupply() public view returns (uint);
144     function balanceOf(address guy) public view returns (uint);
145     function allowance(address src, address guy) public view returns (uint);
146 
147     function approve(address guy, uint wad) public returns (bool);
148     function transfer(address dst, uint wad) public returns (bool);
149     function transferFrom(
150         address src, address dst, uint wad
151     ) public returns (bool);
152 }
153 
154 contract DSTokenBase is ERC20, DSMath {
155     uint256                                            _supply;
156     mapping (address => uint256)                       _balances;
157     mapping (address => mapping (address => uint256))  _approvals;
158 
159     constructor(uint supply) public {
160         _balances[msg.sender] = supply;
161         _supply = supply;
162     }
163 
164  /**
165   * @dev Total number of tokens in existence
166   */
167     function totalSupply() public view returns (uint) {
168         return _supply;
169     }
170 
171  /**
172   * @dev Gets the balance of the specified address.
173   * @param src The address to query the balance of.
174   * @return An uint256 representing the amount owned by the passed address.
175   */
176 
177     function balanceOf(address src) public view returns (uint) {
178         return _balances[src];
179     }
180 
181  /**
182    * @dev Function to check the amount of tokens that an owner allowed to a spender.
183    * @param src address The address which owns the funds.
184    * @param guy address The address which will spend the funds.
185    */
186     function allowance(address src, address guy) public view returns (uint) {
187         return _approvals[src][guy];
188     }
189 
190   /**
191    * @dev Transfer token for a specified address
192    * @param dst The address to transfer to.
193    * @param wad The amount to be transferred.
194    */
195 
196     function transfer(address dst, uint wad) public returns (bool) {
197         return transferFrom(msg.sender, dst, wad);
198     }
199 
200  /**
201    * @dev Transfer tokens from one address to another
202    * @param src address The address which you want to send tokens from
203    * @param dst address The address which you want to transfer to
204    * @param wad uint256 the amount of tokens to be transferred
205    */
206 
207     function transferFrom(address src, address dst, uint wad)
208         public
209         returns (bool)
210     {
211         if (src != msg.sender) {
212             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
213         }
214 
215         _balances[src] = sub(_balances[src], wad);
216         _balances[dst] = add(_balances[dst], wad);
217 
218         emit Transfer(src, dst, wad);
219 
220         return true;
221     }
222 
223 
224  /**
225    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
226    * Beware that changing an allowance with this method brings the risk that someone may use both the old
227    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
228    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
229    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
230    * @param guy The address which will spend the funds.
231    * @param wad The amount of tokens to be spent.
232    */
233 
234     function approve(address guy, uint wad) public returns (bool) {
235         _approvals[msg.sender][guy] = wad;
236 
237         emit Approval(msg.sender, guy, wad);
238 
239         return true;
240     }
241 
242  /**
243    * @dev Increase the amount of tokens that an owner allowed to a spender.
244    * approve should be called when allowed_[_spender] == 0. To increment
245    * allowed value is better to use this function to avoid 2 calls (and wait until
246    * the first transaction is mined)
247    * From MonolithDAO Token.sol
248    * @param src The address which will spend the funds.
249    * @param wad The amount of tokens to increase the allowance by.
250    */
251   function increaseAllowance(
252     address src,
253     uint256 wad
254   )
255     public
256     returns (bool)
257   {
258     require(src != address(0));
259 
260     _approvals[src][msg.sender] = add(_approvals[src][msg.sender], wad);
261     emit Approval(msg.sender, src, _approvals[msg.sender][src]);
262     return true;
263   }
264 
265  /**
266    * @dev Decrese the amount of tokens that an owner allowed to a spender.
267    * approve should be called when allowed_[_spender] == 0. To increment
268    * allowed value is better to use this function to avoid 2 calls (and wait until
269    * the first transaction is mined)
270    * From MonolithDAO Token.sol
271    * @param src The address which will spend the funds.
272    * @param wad The amount of tokens to increase the allowance by.
273    */
274   function decreaseAllowance(
275     address src,
276     uint256 wad
277   )
278     public
279     returns (bool)
280   {
281     require(src != address(0));
282     _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
283     emit Approval(msg.sender, src, _approvals[msg.sender][src]);
284     return true;
285   }
286 
287 }
288 
289 contract DSNote {
290     event LogNote(
291         bytes4   indexed  sig,
292         address  indexed  guy,
293         bytes32  indexed  foo,
294         bytes32  indexed  bar,
295         uint              wad,
296         bytes             fax
297     ) anonymous;
298 
299     modifier note {
300         bytes32 foo;
301         bytes32 bar;
302 
303         assembly {
304             foo := calldataload(4)
305             bar := calldataload(36)
306         }
307 
308         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
309 
310         _;
311     }
312 }
313 
314 contract DSStop is DSNote, DSAuth {
315 
316     bool public stopped;
317 
318     modifier stoppable {
319         require(!stopped);
320         _;
321     }
322     function stop() public auth note {
323         stopped = true;
324     }
325     function start() public auth note {
326         stopped = false;
327     }
328 
329 }
330 
331 
332 contract DGTCoin is DSTokenBase , DSStop {
333 
334     string  public  symbol="DGT";
335     string  public  name="DGT Coin";
336     uint256  public  decimals = 5; // Standard Token Precision
337     uint256 public initialSupply=10000000000000;
338     address public burnAdmin;
339     constructor() public
340     DSTokenBase(initialSupply)
341     {
342         burnAdmin=0x4c96522284400851F460eb935354200909F882bB;
343     }
344 
345     event Burn(address indexed guy, uint wad);
346 
347  /**
348    * @dev Throws if called by any account other than the owner.
349    */
350   modifier onlyAdmin() {
351     require(isAdmin());
352     _;
353   }
354 
355   /**
356    * @return true if `msg.sender` is the owner of the contract.
357    */
358   function isAdmin() public view returns(bool) {
359     return msg.sender == burnAdmin;
360 }
361 
362 /**
363    * @dev Allows the current owner to relinquish control of the contract.
364    * @notice Renouncing to ownership will leave the contract without an owner.
365    * It will not be possible to call the functions with the `onlyOwner`
366    * modifier anymore.
367    */
368   function renounceOwnership() public onlyAdmin {
369     burnAdmin = address(0);
370   }
371 
372     function approve(address guy) public stoppable returns (bool) {
373         return super.approve(guy, uint(-1));
374     }
375 
376     function approve(address guy, uint wad) public stoppable returns (bool) {
377         return super.approve(guy, wad);
378     }
379 
380     function transferFrom(address src, address dst, uint wad)
381         public
382         stoppable
383         returns (bool)
384     {
385         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
386             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
387         }
388 
389         _balances[src] = sub(_balances[src], wad);
390         _balances[dst] = add(_balances[dst], wad);
391 
392         emit Transfer(src, dst, wad);
393 
394         return true;
395     }
396 
397 
398 
399     /**
400    * @dev Burns a specific amount of tokens from the target address
401    * @param guy address The address which you want to send tokens from
402    * @param wad uint256 The amount of token to be burned
403    */
404     function burnfromAdmin(address guy, uint wad) public onlyAdmin {
405         require(guy != address(0));
406 
407 
408         _balances[guy] = sub(_balances[guy], wad);
409         _supply = sub(_supply, wad);
410 
411         emit Burn(guy, wad);
412         emit Transfer(guy, address(0), wad);
413     }
414 
415 
416 }