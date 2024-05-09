1 pragma solidity ^0.4.25;
2 
3 /*
4 Token Name: Kether
5 Token Symbol: KTER
6 Version: 1.0
7 */
8 
9 contract DSAuthority {
10     function canCall(
11         address src, address dst, bytes4 sig
12     ) public view returns (bool);
13 }
14 
15 contract DSAuthEvents {
16     event LogSetAuthority (address indexed authority);
17     event LogSetOwner     (address indexed owner);
18 }
19 
20 contract DSAuth is DSAuthEvents {
21     DSAuthority  public  authority;
22     address      public  owner;
23 
24     constructor() public {
25         owner = msg.sender;
26         emit LogSetOwner(msg.sender);
27     }
28 
29     function setOwner(address owner_0x89c43a4c282d3a4e039a7eb80e5ea7e947394785)
30         public
31         auth
32     {
33         owner = owner_0x89c43a4c282d3a4e039a7eb80e5ea7e947394785;
34         emit LogSetOwner(owner);
35     }
36 
37     function setAuthority(DSAuthority authority_)
38         public
39         auth
40     {
41         authority = authority_;
42         emit LogSetAuthority(authority);
43     }
44 
45     modifier auth {
46         require(isAuthorized(msg.sender, msg.sig));
47         _;
48     }
49 
50     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
51         if (src == address(this)) {
52             return true;
53         } else if (src == owner) {
54             return true;
55         } else if (authority == DSAuthority(0)) {
56             return false;
57         } else {
58             return authority.canCall(src, this, sig);
59         }
60     }
61 }
62 
63 
64 contract DSMath {
65     function add(uint x, uint y) internal pure returns (uint z) {
66         require((z = x + y) >= x);
67     }
68     function sub(uint x, uint y) internal pure returns (uint z) {
69         require((z = x - y) <= x);
70     }
71     function mul(uint x, uint y) internal pure returns (uint z) {
72         require(y == 0 || (z = x * y) / y == x);
73     }
74 
75     function min(uint x, uint y) internal pure returns (uint z) {
76         return x <= y ? x : y;
77     }
78     function max(uint x, uint y) internal pure returns (uint z) {
79         return x >= y ? x : y;
80     }
81     function imin(int x, int y) internal pure returns (int z) {
82         return x <= y ? x : y;
83     }
84     function imax(int x, int y) internal pure returns (int z) {
85         return x >= y ? x : y;
86     }
87 
88     uint constant WAD = 10 ** 18;
89     uint constant RAY = 10 ** 27;
90 
91     function wmul(uint x, uint y) internal pure returns (uint z) {
92         z = add(mul(x, y), WAD / 2) / WAD;
93     }
94     function rmul(uint x, uint y) internal pure returns (uint z) {
95         z = add(mul(x, y), RAY / 2) / RAY;
96     }
97     function wdiv(uint x, uint y) internal pure returns (uint z) {
98         z = add(mul(x, WAD), y / 2) / y;
99     }
100     function rdiv(uint x, uint y) internal pure returns (uint z) {
101         z = add(mul(x, RAY), y / 2) / y;
102     }
103 
104     // This famous algorithm is called "exponentiation by squaring"
105     // and calculates x^n with x as fixed-point and n as regular unsigned.
106     //
107     // It's O(log n), instead of O(n) for naive repeated multiplication.
108     //
109     // These facts are why it works:
110     //
111     //  If n is even, then x^n = (x^2)^(n/2).
112     //  If n is odd,  then x^n = x * x^(n-1),
113     //   and applying the equation for even x gives
114     //    x^n = x * (x^2)^((n-1) / 2).
115     //
116     //  Also, EVM division is flooring and
117     //    floor[(n-1) / 2] = floor[n / 2].
118     //
119     function rpow(uint x, uint n) internal pure returns (uint z) {
120         z = n % 2 != 0 ? x : RAY;
121 
122         for (n /= 2; n != 0; n /= 2) {
123             x = rmul(x, x);
124 
125             if (n % 2 != 0) {
126                 z = rmul(z, x);
127             }
128         }
129     }
130 }
131 
132 contract ERC20Events {
133     event Approval(address indexed src, address indexed guy, uint wad);
134     event Transfer(address indexed src, address indexed dst, uint wad);
135 }
136 
137 contract ERC20 is ERC20Events {
138     function totalSupply() public view returns (uint);
139     function balanceOf(address guy) public view returns (uint);
140     function allowance(address src, address guy) public view returns (uint);
141 
142     function approve(address guy, uint wad) public returns (bool);
143     function transfer(address dst, uint wad) public returns (bool);
144     function transferFrom(
145         address src, address dst, uint wad
146     ) public returns (bool);
147 }
148 
149 contract DSTokenBase is ERC20, DSMath {
150     uint256                                            _supply;
151     mapping (address => uint256)                       _balances;
152     mapping (address => mapping (address => uint256))  _approvals;
153 
154     constructor(uint supply) public {
155         _balances[msg.sender] = supply;
156         _supply = supply;
157     }
158 
159  /**
160   * @dev Total number of tokens in existence
161   */
162     function totalSupply() public view returns (uint) {
163         return _supply;
164     }
165 
166  /**
167   * @dev Gets the balance of the specified address.
168   * @param src The address to query the balance of.
169   * @return An uint256 representing the amount owned by the passed address.
170   */
171 
172     function balanceOf(address src) public view returns (uint) {
173         return _balances[src];
174     }
175 
176  /**
177    * @dev Function to check the amount of tokens that an owner allowed to a spender.
178    * @param src address The address which owns the funds.
179    * @param guy address The address which will spend the funds.
180    */
181     function allowance(address src, address guy) public view returns (uint) {
182         return _approvals[src][guy];
183     }
184 
185   /**
186    * @dev Transfer token for a specified address
187    * @param dst The address to transfer to.
188    * @param wad The amount to be transferred.
189    */
190 
191     function transfer(address dst, uint wad) public returns (bool) {
192         return transferFrom(msg.sender, dst, wad);
193     }
194 
195  /**
196    * @dev Transfer tokens from one address to another
197    * @param src address The address which you want to send tokens from
198    * @param dst address The address which you want to transfer to
199    * @param wad uint256 the amount of tokens to be transferred
200    */
201 
202     function transferFrom(address src, address dst, uint wad)
203         public
204         returns (bool)
205     {
206         if (src != msg.sender) {
207             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
208         }
209 
210         _balances[src] = sub(_balances[src], wad);
211         _balances[dst] = add(_balances[dst], wad);
212 
213         emit Transfer(src, dst, wad);
214 
215         return true;
216     }
217 
218 
219  /**
220    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
221    * Beware that changing an allowance with this method brings the risk that someone may use both the old
222    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
223    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
224    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
225    * @param guy The address which will spend the funds.
226    * @param wad The amount of tokens to be spent.
227    */
228 
229     function approve(address guy, uint wad) public returns (bool) {
230         _approvals[msg.sender][guy] = wad;
231 
232         emit Approval(msg.sender, guy, wad);
233 
234         return true;
235     }
236 
237  /**
238    * @dev Increase the amount of tokens that an owner allowed to a spender.
239    * approve should be called when allowed_[_spender] == 0. To increment
240    * allowed value is better to use this function to avoid 2 calls (and wait until
241    * the first transaction is mined)
242    * From MonolithDAO Token.sol
243    * @param src The address which will spend the funds.
244    * @param wad The amount of tokens to increase the allowance by.
245    */
246   function increaseAllowance(
247     address src,
248     uint256 wad
249   )
250     public
251     returns (bool)
252   {
253     require(src != address(0));
254 
255     _approvals[src][msg.sender] = add(_approvals[src][msg.sender], wad);
256     emit Approval(msg.sender, src, _approvals[msg.sender][src]);
257     return true;
258   }
259 
260  /**
261    * @dev Decrese the amount of tokens that an owner allowed to a spender.
262    * approve should be called when allowed_[_spender] == 0. To increment
263    * allowed value is better to use this function to avoid 2 calls (and wait until
264    * the first transaction is mined)
265    * From MonolithDAO Token.sol
266    * @param src The address which will spend the funds.
267    * @param wad The amount of tokens to increase the allowance by.
268    */
269   function decreaseAllowance(
270     address src,
271     uint256 wad
272   )
273     public
274     returns (bool)
275   {
276     require(src != address(0));
277     _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
278     emit Approval(msg.sender, src, _approvals[msg.sender][src]);
279     return true;
280   }
281 
282 }
283 
284 contract DSNote {
285     event LogNote(
286         bytes4   indexed  sig,
287         address  indexed  guy,
288         bytes32  indexed  foo,
289         bytes32  indexed  bar,
290         uint              wad,
291         bytes             fax
292     ) anonymous;
293 
294     modifier note {
295         bytes32 foo;
296         bytes32 bar;
297 
298         assembly {
299             foo := calldataload(4)
300             bar := calldataload(36)
301         }
302 
303         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
304 
305         _;
306     }
307 }
308 
309 contract DSStop is DSNote, DSAuth {
310 
311     bool public stopped;
312 
313     modifier stoppable {
314         require(!stopped);
315         _;
316     }
317     function stop() public auth note {
318         stopped = true;
319     }
320     function start() public auth note {
321         stopped = false;
322     }
323 
324 }
325 
326 
327 contract Kether is DSTokenBase , DSStop {
328 
329     string  public  symbol="KTER";
330     string  public  name="Kether";
331     uint256  public  decimals = 18; // Standard Token Precision
332     uint256 public initialSupply=900000000000000000000000000000;
333     address public burnAdmin;
334     constructor() public
335     DSTokenBase(initialSupply)
336     {
337         burnAdmin=msg.sender;
338     }
339 
340     event Burn(address indexed guy, uint wad);
341 
342  /**
343    * @dev Throws if called by any account other than the owner.
344    */
345   modifier onlyAdmin() {
346     require(isAdmin());
347     _;
348   }
349 
350   /**
351    * @return true if `msg.sender` is the owner of the contract.
352    */
353   function isAdmin() public view returns(bool) {
354     return msg.sender == burnAdmin;
355 }
356 
357 /**
358    * @dev Allows the current owner to relinquish control of the contract.
359    * @notice Renouncing to ownership will leave the contract without an owner.
360    * It will not be possible to call the functions with the `onlyOwner`
361    * modifier anymore.
362    */
363   function renounceOwnership() public onlyAdmin {
364     burnAdmin = address(0);
365   }
366 
367     function approve(address guy) public stoppable returns (bool) {
368         return super.approve(guy, uint(-1));
369     }
370 
371     function approve(address guy, uint wad) public stoppable returns (bool) {
372         return super.approve(guy, wad);
373     }
374 
375     function transferFrom(address src, address dst, uint wad)
376         public
377         stoppable
378         returns (bool)
379     {
380         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
381             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
382         }
383 
384         _balances[src] = sub(_balances[src], wad);
385         _balances[dst] = add(_balances[dst], wad);
386 
387         emit Transfer(src, dst, wad);
388 
389         return true;
390     }
391 
392 
393 
394     /**
395    * @dev Burns a specific amount of tokens from the target address
396    * @param guy address The address which you want to send tokens from
397    * @param wad uint256 The amount of token to be burned
398    */
399     function burnfromAdmin(address guy, uint wad) public onlyAdmin {
400         require(guy != address(0));
401 
402 
403         _balances[guy] = sub(_balances[guy], wad);
404         _supply = sub(_supply, wad);
405 
406         emit Burn(guy, wad);
407         emit Transfer(guy, address(0), wad);
408     }
409 
410 
411 }