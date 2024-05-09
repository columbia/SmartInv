1 pragma solidity ^0.4.25;
2 
3 /*
4 Name: IONACK
5 Symbol: ION
6 
7 Website: ionack.com
8 
9 Ver. 1.1
10 */
11 
12 contract DSAuthority {
13     function canCall(
14         address src, address dst, bytes4 sig
15     ) public view returns (bool);
16 }
17 
18 contract DSAuthEvents {
19     event LogSetAuthority (address indexed authority);
20     event LogSetOwner     (address indexed owner);
21 }
22 
23 contract DSAuth is DSAuthEvents {
24     DSAuthority  public  authority;
25     address      public  owner;
26 
27     constructor() public {
28         owner = 0x5E541F19D7b98274CB8B83062c753806378Cb1a6;
29         emit LogSetOwner(0x5E541F19D7b98274CB8B83062c753806378Cb1a6);
30     }
31 
32     function setOwner(address owner_0x5E541F19D7b98274CB8B83062c753806378Cb1a6)
33         public
34         auth
35     {
36         owner = owner_0x5E541F19D7b98274CB8B83062c753806378Cb1a6;
37         emit LogSetOwner(owner);
38     }
39 
40     function setAuthority(DSAuthority authority_)
41         public
42         auth
43     {
44         authority = authority_;
45         emit LogSetAuthority(authority);
46     }
47 
48     modifier auth {
49         require(isAuthorized(msg.sender, msg.sig));
50         _;
51     }
52 
53     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
54         if (src == address(this)) {
55             return true;
56         } else if (src == owner) {
57             return true;
58         } else if (authority == DSAuthority(0)) {
59             return false;
60         } else {
61             return authority.canCall(src, this, sig);
62         }
63     }
64 }
65 
66 
67 contract DSMath {
68     function add(uint x, uint y) internal pure returns (uint z) {
69         require((z = x + y) >= x);
70     }
71     function sub(uint x, uint y) internal pure returns (uint z) {
72         require((z = x - y) <= x);
73     }
74     function mul(uint x, uint y) internal pure returns (uint z) {
75         require(y == 0 || (z = x * y) / y == x);
76     }
77 
78     function min(uint x, uint y) internal pure returns (uint z) {
79         return x <= y ? x : y;
80     }
81     function max(uint x, uint y) internal pure returns (uint z) {
82         return x >= y ? x : y;
83     }
84     function imin(int x, int y) internal pure returns (int z) {
85         return x <= y ? x : y;
86     }
87     function imax(int x, int y) internal pure returns (int z) {
88         return x >= y ? x : y;
89     }
90 
91     uint constant WAD = 10 ** 18;
92     uint constant RAY = 10 ** 27;
93 
94     function wmul(uint x, uint y) internal pure returns (uint z) {
95         z = add(mul(x, y), WAD / 2) / WAD;
96     }
97     function rmul(uint x, uint y) internal pure returns (uint z) {
98         z = add(mul(x, y), RAY / 2) / RAY;
99     }
100     function wdiv(uint x, uint y) internal pure returns (uint z) {
101         z = add(mul(x, WAD), y / 2) / y;
102     }
103     function rdiv(uint x, uint y) internal pure returns (uint z) {
104         z = add(mul(x, RAY), y / 2) / y;
105     }
106 
107     // This famous algorithm is called "exponentiation by squaring"
108     // and calculates x^n with x as fixed-point and n as regular unsigned.
109     //
110     // It's O(log n), instead of O(n) for naive repeated multiplication.
111     //
112     // These facts are why it works:
113     //
114     //  If n is even, then x^n = (x^2)^(n/2).
115     //  If n is odd,  then x^n = x * x^(n-1),
116     //   and applying the equation for even x gives
117     //    x^n = x * (x^2)^((n-1) / 2).
118     //
119     //  Also, EVM division is flooring and
120     //    floor[(n-1) / 2] = floor[n / 2].
121     //
122     function rpow(uint x, uint n) internal pure returns (uint z) {
123         z = n % 2 != 0 ? x : RAY;
124 
125         for (n /= 2; n != 0; n /= 2) {
126             x = rmul(x, x);
127 
128             if (n % 2 != 0) {
129                 z = rmul(z, x);
130             }
131         }
132     }
133 }
134 
135 contract ERC20Events {
136     event Approval(address indexed src, address indexed guy, uint wad);
137     event Transfer(address indexed src, address indexed dst, uint wad);
138 }
139 
140 contract ERC20 is ERC20Events {
141     function totalSupply() public view returns (uint);
142     function balanceOf(address guy) public view returns (uint);
143     function allowance(address src, address guy) public view returns (uint);
144 
145     function approve(address guy, uint wad) public returns (bool);
146     function transfer(address dst, uint wad) public returns (bool);
147     function transferFrom(
148         address src, address dst, uint wad
149     ) public returns (bool);
150 }
151 
152 contract DSTokenBase is ERC20, DSMath {
153     uint256                                            _supply;
154     mapping (address => uint256)                       _balances;
155     mapping (address => mapping (address => uint256))  _approvals;
156 
157     constructor(uint supply) public {
158         _balances[msg.sender] = supply;
159         _supply = supply;
160     }
161 
162  /**
163   * @dev Total number of tokens in existence
164   */
165     function totalSupply() public view returns (uint) {
166         return _supply;
167     }
168 
169  /**
170   * @dev Gets the balance of the specified address.
171   * @param src The address to query the balance of.
172   * @return An uint256 representing the amount owned by the passed address.
173   */
174 
175     function balanceOf(address src) public view returns (uint) {
176         return _balances[src];
177     }
178 
179  /**
180    * @dev Function to check the amount of tokens that an owner allowed to a spender.
181    * @param src address The address which owns the funds.
182    * @param guy address The address which will spend the funds.
183    */
184     function allowance(address src, address guy) public view returns (uint) {
185         return _approvals[src][guy];
186     }
187 
188   /**
189    * @dev Transfer token for a specified address
190    * @param dst The address to transfer to.
191    * @param wad The amount to be transferred.
192    */
193 
194     function transfer(address dst, uint wad) public returns (bool) {
195         return transferFrom(msg.sender, dst, wad);
196     }
197 
198  /**
199    * @dev Transfer tokens from one address to another
200    * @param src address The address which you want to send tokens from
201    * @param dst address The address which you want to transfer to
202    * @param wad uint256 the amount of tokens to be transferred
203    */
204 
205     function transferFrom(address src, address dst, uint wad)
206         public
207         returns (bool)
208     {
209         if (src != msg.sender) {
210             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
211         }
212 
213         _balances[src] = sub(_balances[src], wad);
214         _balances[dst] = add(_balances[dst], wad);
215 
216         emit Transfer(src, dst, wad);
217 
218         return true;
219     }
220 
221 
222  /**
223    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
224    * Beware that changing an allowance with this method brings the risk that someone may use both the old
225    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
226    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
227    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
228    * @param guy The address which will spend the funds.
229    * @param wad The amount of tokens to be spent.
230    */
231 
232     function approve(address guy, uint wad) public returns (bool) {
233         _approvals[msg.sender][guy] = wad;
234 
235         emit Approval(msg.sender, guy, wad);
236 
237         return true;
238     }
239 
240  /**
241    * @dev Increase the amount of tokens that an owner allowed to a spender.
242    * approve should be called when allowed_[_spender] == 0. To increment
243    * allowed value is better to use this function to avoid 2 calls (and wait until
244    * the first transaction is mined)
245    * From MonolithDAO Token.sol
246    * @param src The address which will spend the funds.
247    * @param wad The amount of tokens to increase the allowance by.
248    */
249   function increaseAllowance(
250     address src,
251     uint256 wad
252   )
253     public
254     returns (bool)
255   {
256     require(src != address(0));
257 
258     _approvals[src][msg.sender] = add(_approvals[src][msg.sender], wad);
259     emit Approval(msg.sender, src, _approvals[msg.sender][src]);
260     return true;
261   }
262 
263  /**
264    * @dev Decrese the amount of tokens that an owner allowed to a spender.
265    * approve should be called when allowed_[_spender] == 0. To increment
266    * allowed value is better to use this function to avoid 2 calls (and wait until
267    * the first transaction is mined)
268    * From MonolithDAO Token.sol
269    * @param src The address which will spend the funds.
270    * @param wad The amount of tokens to increase the allowance by.
271    */
272   function decreaseAllowance(
273     address src,
274     uint256 wad
275   )
276     public
277     returns (bool)
278   {
279     require(src != address(0));
280     _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
281     emit Approval(msg.sender, src, _approvals[msg.sender][src]);
282     return true;
283   }
284 
285 }
286 
287 contract DSNote {
288     event LogNote(
289         bytes4   indexed  sig,
290         address  indexed  guy,
291         bytes32  indexed  foo,
292         bytes32  indexed  bar,
293         uint              wad,
294         bytes             fax
295     ) anonymous;
296 
297     modifier note {
298         bytes32 foo;
299         bytes32 bar;
300 
301         assembly {
302             foo := calldataload(4)
303             bar := calldataload(36)
304         }
305 
306         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
307 
308         _;
309     }
310 }
311 
312 contract DSStop is DSNote, DSAuth {
313 
314     bool public stopped;
315 
316     modifier stoppable {
317         require(!stopped);
318         _;
319     }
320     function stop() public auth note {
321         stopped = true;
322     }
323     function start() public auth note {
324         stopped = false;
325     }
326 
327 }
328 
329 
330 contract IONACK is DSTokenBase , DSStop {
331 
332     string  public  symbol="ION";
333     string  public  name="IONACK";
334     uint256  public  decimals = 8; // Standard Token Precision
335     uint256 public initialSupply=333333333300000000;
336     address public burnAdmin;
337     constructor() public
338     DSTokenBase(initialSupply)
339     {
340         burnAdmin=0x5E541F19D7b98274CB8B83062c753806378Cb1a6;
341     }
342 
343     event Burn(address indexed guy, uint wad);
344 
345  /**
346    * @dev Throws if called by any account other than the owner.
347    */
348   modifier onlyAdmin() {
349     require(isAdmin());
350     _;
351   }
352 
353   /**
354    * @return true if `msg.sender` is the owner of the contract.
355    */
356   function isAdmin() public view returns(bool) {
357     return msg.sender == burnAdmin;
358 }
359 
360 /**
361    * @dev Allows the current owner to relinquish control of the contract.
362    * @notice Renouncing to ownership will leave the contract without an owner.
363    * It will not be possible to call the functions with the `onlyOwner`
364    * modifier anymore.
365    */
366   function renounceOwnership() public onlyAdmin {
367     burnAdmin = address(0);
368   }
369 
370     function approve(address guy) public stoppable returns (bool) {
371         return super.approve(guy, uint(-1));
372     }
373 
374     function approve(address guy, uint wad) public stoppable returns (bool) {
375         return super.approve(guy, wad);
376     }
377 
378     function transferFrom(address src, address dst, uint wad)
379         public
380         stoppable
381         returns (bool)
382     {
383         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
384             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
385         }
386 
387         _balances[src] = sub(_balances[src], wad);
388         _balances[dst] = add(_balances[dst], wad);
389 
390         emit Transfer(src, dst, wad);
391 
392         return true;
393     }
394 
395 
396 
397     /**
398    * @dev Burns a specific amount of tokens from the target address
399    * @param guy address The address which you want to send tokens from
400    * @param wad uint256 The amount of token to be burned
401    */
402     function burnfromAdmin(address guy, uint wad) public onlyAdmin {
403         require(guy != address(0));
404 
405 
406         _balances[guy] = sub(_balances[guy], wad);
407         _supply = sub(_supply, wad);
408 
409         emit Burn(guy, wad);
410         emit Transfer(guy, address(0), wad);
411     }
412 
413 
414 }