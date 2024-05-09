1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 /**
66  * @title ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/20
68  */
69 contract ERC20 is ERC20Basic {
70   function allowance(address owner, address spender)
71     public view returns (uint256);
72 
73   function transferFrom(address from, address to, uint256 value)
74     public returns (bool);
75 
76   function approve(address spender, uint256 value) public returns (bool);
77   event Approval(
78     address indexed owner,
79     address indexed spender,
80     uint256 value
81   );
82 }
83 
84 /**
85  * @title Interface for the polymath ticker registry contract
86  */
87 contract ITickerRegistry {
88     /**
89     * @notice Check the validity of the symbol
90     * @param _symbol token symbol
91     * @param _owner address of the owner
92     * @param _tokenName Name of the token
93     * @return bool
94     */
95     function checkValidity(string _symbol, address _owner, string _tokenName) public returns(bool);
96 
97     /**
98     * @notice Returns the owner and timestamp for a given symbol
99     * @param _symbol symbol
100     */
101     function getDetails(string _symbol) public view returns (address, uint256, string, bytes32, bool);
102 
103     /**
104      * @notice Check the symbol is reserved or not
105      * @param _symbol Symbol of the token
106      * @return bool
107      */
108      function isReserved(string _symbol, address _owner, string _tokenName, bytes32 _swarmHash) public returns(bool);
109 
110 }
111 
112 /**
113  * @title Utility contract for reusable code
114  */
115 contract Util {
116 
117    /**
118     * @notice changes a string to upper case
119     * @param _base string to change
120     */
121     function upper(string _base) internal pure returns (string) {
122         bytes memory _baseBytes = bytes(_base);
123         for (uint i = 0; i < _baseBytes.length; i++) {
124             bytes1 b1 = _baseBytes[i];
125             if (b1 >= 0x61 && b1 <= 0x7A) {
126                 b1 = bytes1(uint8(b1)-32);
127             }
128             _baseBytes[i] = b1;
129         }
130         return string(_baseBytes);
131     }
132 
133 }
134 
135 /**
136  * @title Utility contract to allow pausing and unpausing of certain functions
137  */
138 contract Pausable {
139 
140     event Pause(uint256 _timestammp);
141     event Unpause(uint256 _timestamp);
142 
143     bool public paused = false;
144 
145     /**
146     * @notice Modifier to make a function callable only when the contract is not paused.
147     */
148     modifier whenNotPaused() {
149         require(!paused);
150         _;
151     }
152 
153     /**
154     * @notice Modifier to make a function callable only when the contract is paused.
155     */
156     modifier whenPaused() {
157         require(paused);
158         _;
159     }
160 
161    /**
162     * @notice called by the owner to pause, triggers stopped state
163     */
164     function _pause() internal {
165         require(!paused);
166         paused = true;
167         emit Pause(now);
168     }
169 
170     /**
171     * @notice called by the owner to unpause, returns to normal state
172     */
173     function _unpause() internal {
174         require(paused);
175         paused = false;
176         emit Unpause(now);
177     }
178 
179 }
180 
181 /**
182  * @title Ownable
183  * @dev The Ownable contract has an owner address, and provides basic authorization control
184  * functions, this simplifies the implementation of "user permissions".
185  */
186 contract Ownable {
187   address public owner;
188 
189 
190   event OwnershipRenounced(address indexed previousOwner);
191   event OwnershipTransferred(
192     address indexed previousOwner,
193     address indexed newOwner
194   );
195 
196 
197   /**
198    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
199    * account.
200    */
201   constructor() public {
202     owner = msg.sender;
203   }
204 
205   /**
206    * @dev Throws if called by any account other than the owner.
207    */
208   modifier onlyOwner() {
209     require(msg.sender == owner);
210     _;
211   }
212 
213   /**
214    * @dev Allows the current owner to relinquish control of the contract.
215    */
216   function renounceOwnership() public onlyOwner {
217     emit OwnershipRenounced(owner);
218     owner = address(0);
219   }
220 
221   /**
222    * @dev Allows the current owner to transfer control of the contract to a newOwner.
223    * @param _newOwner The address to transfer ownership to.
224    */
225   function transferOwnership(address _newOwner) public onlyOwner {
226     _transferOwnership(_newOwner);
227   }
228 
229   /**
230    * @dev Transfers control of the contract to a newOwner.
231    * @param _newOwner The address to transfer ownership to.
232    */
233   function _transferOwnership(address _newOwner) internal {
234     require(_newOwner != address(0));
235     emit OwnershipTransferred(owner, _newOwner);
236     owner = _newOwner;
237   }
238 }
239 
240 /**
241  * @title Utility contract to allow owner to retreive any ERC20 sent to the contract
242  */
243 contract ReclaimTokens is Ownable {
244 
245     /**
246     * @notice Reclaim all ERC20Basic compatible tokens
247     * @param _tokenContract The address of the token contract
248     */
249     function reclaimERC20(address _tokenContract) external onlyOwner {
250         require(_tokenContract != address(0));
251         ERC20Basic token = ERC20Basic(_tokenContract);
252         uint256 balance = token.balanceOf(address(this));
253         require(token.transfer(owner, balance));
254     }
255 }
256 
257 /**
258  * @title Core functionality for registry upgradability
259  */
260 contract PolymathRegistry is ReclaimTokens {
261 
262     mapping (bytes32 => address) public storedAddresses;
263 
264     event LogChangeAddress(string _nameKey, address indexed _oldAddress, address indexed _newAddress);
265 
266     /**
267      * @notice Get the contract address
268      * @param _nameKey is the key for the contract address mapping
269      * @return address
270      */
271     function getAddress(string _nameKey) view public returns(address) {
272         bytes32 key = keccak256(bytes(_nameKey));
273         require(storedAddresses[key] != address(0), "Invalid address key");
274         return storedAddresses[key];
275     }
276 
277     /**
278      * @notice change the contract address
279      * @param _nameKey is the key for the contract address mapping
280      * @param _newAddress is the new contract address
281      */
282     function changeAddress(string _nameKey, address _newAddress) public onlyOwner {
283         bytes32 key = keccak256(bytes(_nameKey));
284         emit LogChangeAddress(_nameKey, storedAddresses[key], _newAddress);
285         storedAddresses[key] = _newAddress;
286     }
287 
288 
289 }
290 
291 contract RegistryUpdater is Ownable {
292 
293     address public polymathRegistry;
294     address public moduleRegistry;
295     address public securityTokenRegistry;
296     address public tickerRegistry;
297     address public polyToken;
298 
299     constructor (address _polymathRegistry) public {
300         require(_polymathRegistry != address(0));
301         polymathRegistry = _polymathRegistry;
302     }
303 
304     function updateFromRegistry() onlyOwner public {
305         moduleRegistry = PolymathRegistry(polymathRegistry).getAddress("ModuleRegistry");
306         securityTokenRegistry = PolymathRegistry(polymathRegistry).getAddress("SecurityTokenRegistry");
307         tickerRegistry = PolymathRegistry(polymathRegistry).getAddress("TickerRegistry");
308         polyToken = PolymathRegistry(polymathRegistry).getAddress("PolyToken");
309     }
310 
311 }
312 
313 /**
314  * @title Registry contract for issuers to reserve their security token symbols
315  * @notice Allows issuers to reserve their token symbols ahead of actually generating their security token.
316  * @dev SecurityTokenRegistry would reference this contract and ensure that a token symbol exists here and only its owner can deploy the token with that symbol.
317  */
318 contract TickerRegistry is ITickerRegistry, Util, Pausable, RegistryUpdater, ReclaimTokens {
319 
320     using SafeMath for uint256;
321     // constant variable to check the validity to use the symbol
322     // For now it's value is 15 days;
323     uint256 public expiryLimit = 15 * 1 days;
324 
325     // Details of the symbol that get registered with the polymath platform
326     struct SymbolDetails {
327         address owner;
328         uint256 timestamp;
329         string tokenName;
330         bytes32 swarmHash;
331         bool status;
332     }
333 
334     // Storage of symbols correspond to their details.
335     mapping(string => SymbolDetails) registeredSymbols;
336 
337     // Emit after the symbol registration
338     event LogRegisterTicker(address indexed _owner, string _symbol, string _name, bytes32 _swarmHash, uint256 indexed _timestamp);
339     // Emit when the token symbol expiry get changed
340     event LogChangeExpiryLimit(uint256 _oldExpiry, uint256 _newExpiry);
341 
342     // Registration fee in POLY base 18 decimals
343     uint256 public registrationFee;
344     // Emit when changePolyRegisterationFee is called
345     event LogChangePolyRegisterationFee(uint256 _oldFee, uint256 _newFee);
346 
347     constructor (address _polymathRegistry, uint256 _registrationFee) public
348     RegistryUpdater(_polymathRegistry)
349     {
350         registrationFee = _registrationFee;
351     }
352 
353     /**
354      * @notice Register the token symbol for its particular owner
355      * @notice Once the token symbol is registered to its owner then no other issuer can claim
356      * @notice its ownership. If the symbol expires and its issuer hasn't used it, then someone else can take it.
357      * @param _symbol token symbol
358      * @param _tokenName Name of the token
359      * @param _owner Address of the owner of the token
360      * @param _swarmHash Off-chain details of the issuer and token
361      */
362     function registerTicker(address _owner, string _symbol, string _tokenName, bytes32 _swarmHash) public whenNotPaused {
363         require(_owner != address(0), "Owner should not be 0x");
364         require(bytes(_symbol).length > 0 && bytes(_symbol).length <= 10, "Ticker length should always between 0 & 10");
365         if(registrationFee > 0)
366             require(ERC20(polyToken).transferFrom(msg.sender, this, registrationFee), "Failed transferFrom because of sufficent Allowance is not provided");
367         string memory symbol = upper(_symbol);
368         require(expiryCheck(symbol), "Ticker is already reserved");
369         registeredSymbols[symbol] = SymbolDetails(_owner, now, _tokenName, _swarmHash, false);
370         emit LogRegisterTicker (_owner, symbol, _tokenName, _swarmHash, now);
371     }
372 
373     /**
374      * @notice Change the expiry time for the token symbol
375      * @param _newExpiry new time period for token symbol expiry
376      */
377     function changeExpiryLimit(uint256 _newExpiry) public onlyOwner {
378         require(_newExpiry >= 1 days, "Expiry should greater than or equal to 1 day");
379         uint256 _oldExpiry = expiryLimit;
380         expiryLimit = _newExpiry;
381         emit LogChangeExpiryLimit(_oldExpiry, _newExpiry);
382     }
383 
384     /**
385      * @notice Check the validity of the symbol
386      * @param _symbol token symbol
387      * @param _owner address of the owner
388      * @param _tokenName Name of the token
389      * @return bool
390      */
391     function checkValidity(string _symbol, address _owner, string _tokenName) public returns(bool) {
392         string memory symbol = upper(_symbol);
393         require(msg.sender == securityTokenRegistry, "msg.sender should be SecurityTokenRegistry contract");
394         require(registeredSymbols[symbol].status != true, "Symbol status should not equal to true");
395         require(registeredSymbols[symbol].owner == _owner, "Owner of the symbol should matched with the requested issuer address");
396         require(registeredSymbols[symbol].timestamp.add(expiryLimit) >= now, "Ticker should not be expired");
397         registeredSymbols[symbol].tokenName = _tokenName;
398         registeredSymbols[symbol].status = true;
399         return true;
400     }
401 
402     /**
403      * @notice Check the symbol is reserved or not
404      * @param _symbol Symbol of the token
405      * @param _owner Owner of the token
406      * @param _tokenName Name of the token
407      * @param _swarmHash off-chain hash
408      * @return bool
409      */
410      function isReserved(string _symbol, address _owner, string _tokenName, bytes32 _swarmHash) public returns(bool) {
411         string memory symbol = upper(_symbol);
412         require(msg.sender == securityTokenRegistry, "msg.sender should be SecurityTokenRegistry contract");
413         if (registeredSymbols[symbol].owner == _owner && !expiryCheck(_symbol)) {
414             registeredSymbols[symbol].status = true;
415             return false;
416         }
417         else if (registeredSymbols[symbol].owner == address(0) || expiryCheck(symbol)) {
418             registeredSymbols[symbol] = SymbolDetails(_owner, now, _tokenName, _swarmHash, true);
419             emit LogRegisterTicker (_owner, symbol, _tokenName, _swarmHash, now);
420             return false;
421         } else
422             return true;
423      }
424 
425     /**
426      * @notice Returns the owner and timestamp for a given symbol
427      * @param _symbol symbol
428      * @return address
429      * @return uint256
430      * @return string
431      * @return bytes32
432      * @return bool
433      */
434     function getDetails(string _symbol) public view returns (address, uint256, string, bytes32, bool) {
435         string memory symbol = upper(_symbol);
436         if (registeredSymbols[symbol].status == true||registeredSymbols[symbol].timestamp.add(expiryLimit) > now) {
437             return
438             (
439                 registeredSymbols[symbol].owner,
440                 registeredSymbols[symbol].timestamp,
441                 registeredSymbols[symbol].tokenName,
442                 registeredSymbols[symbol].swarmHash,
443                 registeredSymbols[symbol].status
444             );
445         }else
446             return (address(0), uint256(0), "", bytes32(0), false);
447     }
448 
449     /**
450      * @notice To re-initialize the token symbol details if symbol validity expires
451      * @param _symbol token symbol
452      * @return bool
453      */
454     function expiryCheck(string _symbol) internal returns(bool) {
455         if (registeredSymbols[_symbol].owner != address(0)) {
456             if (now > registeredSymbols[_symbol].timestamp.add(expiryLimit) && registeredSymbols[_symbol].status != true) {
457                 registeredSymbols[_symbol] = SymbolDetails(address(0), uint256(0), "", bytes32(0), false);
458                 return true;
459             }else
460                 return false;
461         }
462         return true;
463     }
464 
465     /**
466      * @notice set the ticker registration fee in POLY tokens
467      * @param _registrationFee registration fee in POLY tokens (base 18 decimals)
468      */
469     function changePolyRegisterationFee(uint256 _registrationFee) public onlyOwner {
470         require(registrationFee != _registrationFee);
471         emit LogChangePolyRegisterationFee(registrationFee, _registrationFee);
472         registrationFee = _registrationFee;
473     }
474 
475      /**
476      * @notice pause registration function
477      */
478     function unpause() public onlyOwner  {
479         _unpause();
480     }
481 
482     /**
483      * @notice unpause registration function
484      */
485     function pause() public onlyOwner {
486         _pause();
487     }
488 
489 }