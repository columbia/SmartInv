1 pragma solidity ^0.4.23;
2 
3 // File: contracts/erc/erc20/ERC20Interface.sol
4 
5 /**
6  * @title ERC-20 Token Standard.
7  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md.
8  */
9 contract ERC20Interface {
10   /**
11    * @dev MUST trigger when tokens are transferred, including zero value transfers.
12    * @dev A token contract which creates new tokens SHOULD trigger a `Transfer` event
13    *   with the `_from` address set to `0x0` when tokens are created.
14    */
15   event Transfer(address indexed _from, address indexed _to, uint256 _value);
16 
17   /**
18    * @dev MUST trigger on any successful call to `approve(address _spender, uint256 _value)`.
19    */
20   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
21 
22   /**
23    * @notice Returns the total token supply.
24    * @return The supply.
25    */
26   function totalSupply() public view returns (uint256 _supply);
27 
28   /**
29    * @notice Returns the balance of an account with address `_owner`.
30    * @return The account balance.
31    */
32   function balanceOf(address _owner) public view returns (uint256 _balance);
33 
34   /**
35    * @notice Transfers `_value` amount of tokens to address `_to`.
36    *
37    * @param _to The address of the recipient.
38    * @param _value The amount of token to be transferred.
39    *
40    * @dev The function MUST fire the `Transfer` event.
41    * @dev The function SHOULD throw if the `_from` account balance does not have enough tokens to spend.
42    * @dev Transfers of 0 values MUST be treated as normal transfers and fire the `Transfer` event.
43    *
44    * @return Whether the transfer was successful or not.
45    */
46   function transfer(address _to, uint256 _value) public returns (bool _success);
47 
48   /**
49    * @notice Transfers `_value` amount of tokens from address `_from` to address `_to`.
50    *
51    * @param _from The address of the sender.
52    * @param _to The address of the recipient.
53    * @param _value The amount of token to be transferred.
54    *
55    * @dev The `transferFrom` method is used for a withdraw workflow,
56    *   allowing contracts to transfer tokens on your behalf.
57    *   This can be used for example to allow a contract to transfer tokens on your behalf
58    *   and/or to charge fees in sub-currencies.
59    * @dev The function MUST fire the `Transfer` event.
60    * @dev The function SHOULD throw unless the `_from` account
61    *   has deliberately authorized the sender of the message via some mechanism.
62    * @dev Transfers of 0 values MUST be treated as normal transfers and fire the `Transfer` event.
63    *
64    * @return Whether the transfer was successful or not.
65    */
66   function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success);
67 
68   /**
69    * @notice Allows `_spender` to withdraw from your account multiple times, up to the `_value` amount.
70    *   If this function is called again it overwrites the current allowance with `_value`.
71    *
72    * @param _spender The address of the account able to transfer the tokens.
73    * @param _value The amount of tokens to be approved for transfer.
74    *
75    * @dev To prevent attack vectors like the one described in
76    *   https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/
77    *   and discussed in
78    *   https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729,
79    *   clients SHOULD make sure to create user interfaces in such a way
80    *   that they set the allowance first to 0 before setting it to another value for the same spender.
81    *   THOUGH The contract itself shouldn't enforce it,
82    *   to allow backwards compatibility with contracts deployed before.
83    *
84    * @return Whether the approval was successful or not.
85    */
86   function approve(address _spender, uint256 _value) public returns (bool _success);
87 
88   /**
89    * @notice Returns the amount which `_spender` is still allowed to withdraw from `_owner`.
90    *
91    * @param _owner The address of the account owning tokens.
92    * @param _spender The address of the account able to transfer the tokens.
93    *
94    * @return Amount of remaining tokens allowed to spent.
95    */
96   function allowance(address _owner, address _spender) public view returns (uint256 _remaining);
97 }
98 
99 // File: zeppelin/contracts/math/SafeMath.sol
100 
101 /**
102  * @title SafeMath
103  * @dev Math operations with safety checks that throw on error
104  */
105 library SafeMath {
106   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
107     uint256 c = a * b;
108     assert(a == 0 || c / a == b);
109     return c;
110   }
111 
112   function div(uint256 a, uint256 b) internal constant returns (uint256) {
113     // assert(b > 0); // Solidity automatically throws when dividing by 0
114     uint256 c = a / b;
115     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
116     return c;
117   }
118 
119   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
120     assert(b <= a);
121     return a - b;
122   }
123 
124   function add(uint256 a, uint256 b) internal constant returns (uint256) {
125     uint256 c = a + b;
126     assert(c >= a);
127     return c;
128   }
129 }
130 
131 // File: contracts/erc/erc20/ERC20.sol
132 
133 /**
134  * @title An implementation of the ERC-20 Token Standard.
135  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md.
136  */
137 contract ERC20 is ERC20Interface {
138   using SafeMath for uint256;
139 
140   uint256 internal _totalSupply;
141   mapping (address => uint256) internal _balance;
142   mapping (address => mapping (address => uint256)) internal _allowed;
143 
144 
145   /**
146    * @notice Returns the total token supply.
147    * @return The supply.
148    */
149   function totalSupply() public view returns (uint256) {
150     return _totalSupply;
151   }
152 
153   /**
154    * @notice Returns the balance of an account with address `_owner`.
155    * @return The account balance.
156    */
157   function balanceOf(address _owner) public view returns (uint256) {
158     return _balance[_owner];
159   }
160 
161   /**
162    * @notice Transfers `_value` amount of tokens to address `_to`.
163    *
164    * @param _to The address of the recipient.
165    * @param _value The amount of token to be transferred.
166    *
167    * @return Whether the transfer was successful or not.
168    */
169   function transfer(address _to, uint256 _value) public returns (bool) {
170     require(_to != address(0));
171 
172     _balance[msg.sender] = _balance[msg.sender].sub(_value);
173     _balance[_to] = _balance[_to].add(_value);
174 
175     emit Transfer(msg.sender, _to, _value);
176 
177     return true;
178   }
179 
180   /**
181    * @notice Transfers `_value` amount of tokens from address `_from` to address `_to`.
182    *
183    * @param _from The address of the sender.
184    * @param _to The address of the recipient.
185    * @param _value The amount of token to be transferred.
186    *
187    * @return Whether the transfer was successful or not.
188    */
189   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
190     require(_to != address(0));
191 
192     _balance[_from] = _balance[_from].sub(_value);
193     _balance[_to] = _balance[_to].add(_value);
194     _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
195 
196     emit Transfer(_from, _to, _value);
197 
198     return true;
199   }
200 
201   /**
202    * @notice Allows `_spender` to withdraw from your account multiple times, up to the `_value` amount.
203    *   If this function is called again it overwrites the current allowance with `_value`.
204    *
205    * @param _spender The address of the account able to transfer the tokens.
206    * @param _value The amount of tokens to be approved for transfer.
207    *
208    * @return Whether the approval was successful or not.
209    */
210   function approve(address _spender, uint256 _value) public returns (bool) {
211     _allowed[msg.sender][_spender] = _value;
212     emit Approval(msg.sender, _spender, _value);
213     return true;
214   }
215 
216   /**
217    * @notice Returns the amount which `_spender` is still allowed to withdraw from `_owner`.
218    *
219    * @param _owner The address of the account owning tokens.
220    * @param _spender The address of the account able to transfer the tokens.
221    *
222    * @return Amount of remaining tokens allowed to spent.
223    */
224   function allowance(address _owner, address _spender) public view returns (uint256) {
225     return _allowed[_owner][_spender];
226   }
227 }
228 
229 // File: contracts/erc/erc20/ERC20Burnable.sol
230 
231 /**
232  * @title An implementation of the ERC-20 Token Standard
233  *   which allows tokens to be burnt.
234  */
235 contract ERC20Burnable is ERC20 {
236   event Burn(address indexed burner, uint256 value);
237 
238   function burn(uint256 _value) public returns (bool) {
239     _balance[msg.sender] = _balance[msg.sender].sub(_value);
240     _totalSupply = _totalSupply.sub(_value);
241 
242     emit Transfer(msg.sender, address(0), _value);
243     emit Burn(msg.sender, _value);
244 
245     return true;
246   }
247 
248   function burnFrom(address _from, uint256 _value) public returns (bool) {
249     _balance[_from] = _balance[_from].sub(_value);
250     _totalSupply = _totalSupply.sub(_value);
251     _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
252 
253     emit Transfer(_from, address(0), _value);
254     emit Burn(_from, _value);
255 
256     return true;
257   }
258 }
259 
260 // File: contracts/erc/erc20/ERC20DetailedInterface.sol
261 
262 /**
263  * @title Contains optional methods which give some detailed information about the token
264  *   in ERC-20 Token Standard.
265  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md.
266  */
267 contract ERC20DetailedInterface is ERC20Interface {
268   /**
269    * @notice Returns the name of the token.
270    * @return The name.
271    */
272   function name() public view returns (string _name);
273 
274   /**
275    * @notice Returns the name of the token.
276    * @return The symbol.
277    */
278   function symbol() public view returns (string _symbol);
279 
280   /**
281    * @notice Returns the number of decimals the token uses.
282    * @dev For example, 8 means to divide the token amount by 100,000,000
283    *   to get its user representation.
284    * @return The number of decimals.
285    */
286   function decimals() public view returns (uint8 _decimals);
287 }
288 
289 // File: contracts/erc/erc20/ERC20RecipientInterface.sol
290 
291 interface ERC20RecipientInterface {
292   function receiveApproval(address _from, uint256 _value, address _erc20Address, bytes _data) external;
293 }
294 
295 // File: contracts/erc/erc20/ERC20Extended.sol
296 
297 /**
298  * @title An implementation of the ERC-20 Token Standard
299  *   which implements `approveAndCall` function according to the extended standard.
300  */
301 contract ERC20Extended is ERC20 {
302   /**
303    * @notice Allows `_spender` to withdraw from your account multiple times, up to the `_value` amount.
304    *   After the approval, executes `receiveApproval` function on `_spender`.
305    *   If this function is called again it overwrites the current allowance with `_value`.
306    *
307    * @param _spender The address that will spend the funds.
308    * @param _value The amount of tokens to be spent.
309    * @param _data Additional data to be passed to `receiveApproval` function on `_spender`.
310    *
311    * @return Whether the approval was successful or not.
312    */
313   function approveAndCall(address _spender, uint256 _value, bytes _data) public returns (bool) {
314     require(approve(_spender, _value));
315     ERC20RecipientInterface(_spender).receiveApproval(msg.sender, _value, this, _data);
316     return true;
317   }
318 }
319 
320 // File: zeppelin/contracts/ownership/Ownable.sol
321 
322 /**
323  * @title Ownable
324  * @dev The Ownable contract has an owner address, and provides basic authorization control
325  * functions, this simplifies the implementation of "user permissions".
326  */
327 contract Ownable {
328   address public owner;
329 
330 
331   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
332 
333 
334   /**
335    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
336    * account.
337    */
338   function Ownable() {
339     owner = msg.sender;
340   }
341 
342 
343   /**
344    * @dev Throws if called by any account other than the owner.
345    */
346   modifier onlyOwner() {
347     require(msg.sender == owner);
348     _;
349   }
350 
351 
352   /**
353    * @dev Allows the current owner to transfer control of the contract to a newOwner.
354    * @param newOwner The address to transfer ownership to.
355    */
356   function transferOwnership(address newOwner) onlyOwner public {
357     require(newOwner != address(0));
358     OwnershipTransferred(owner, newOwner);
359     owner = newOwner;
360   }
361 
362 }
363 
364 // File: contracts/erc/erc20/ERC20Mintable.sol
365 
366 /**
367  * @title An implementation of the ERC-20 Token Standard
368  *   which allows tokens to be minted.
369  */
370 contract ERC20Mintable is ERC20, Ownable {
371   bool public mintingFinished = false;
372 
373   event Mint(address indexed to, uint256 value);
374   event MintFinished();
375 
376   modifier canMint() {
377     require(!mintingFinished);
378     _;
379   }
380 
381   function mint(address _to, uint256 _value) onlyOwner canMint public returns (bool) {
382     _balance[_to] = _balance[_to].add(_value);
383     _totalSupply = _totalSupply.add(_value);
384 
385     emit Mint(_to, _value);
386     emit Transfer(address(0), _to, _value);
387 
388     return true;
389   }
390 
391   function finishMinting() onlyOwner canMint public returns (bool) {
392     mintingFinished = true;
393     emit MintFinished();
394     return true;
395   }
396 }
397 
398 // File: contracts/token/AxieOriginCoin.sol
399 
400 /**
401  * @title The contract which holds Axie Origin Coins.
402  * @dev Five Axie Origin Coins can be redeemed for one Origin Axie.
403  */
404 contract AxieOriginCoin is ERC20DetailedInterface, ERC20Extended, ERC20Mintable, ERC20Burnable {
405   uint256 constant public NUM_COIN_PER_AXIE = 5;
406   uint256 constant public NUM_RESERVED_AXIE = 427;
407   uint256 constant public NUM_RESERVED_COIN = NUM_RESERVED_AXIE * NUM_COIN_PER_AXIE;
408 
409   constructor() public {
410     // Reserve 20% of all remaining Axies from the Presale.
411     mint(msg.sender, NUM_RESERVED_COIN);
412 
413     // As its name says.
414     _allocateUnspentRefTokens();
415 
416     // Don't allow tokens to be minted anymore.
417     finishMinting();
418   }
419 
420   /**
421    * @notice Returns the name of the token.
422    * @return The name.
423    */
424   function name() public view returns (string) {
425     return "Axie Origin Coin";
426   }
427 
428   /**
429    * @notice Returns the name of the token.
430    * @return The symbol.
431    */
432   function symbol() public view returns (string) {
433     return "AOC";
434   }
435 
436   /**
437    * @notice Returns the number of decimals the token uses.
438    * @return The number of decimals.
439    */
440   function decimals() public view returns (uint8) {
441     return 0;
442   }
443 
444   function _allocateUnspentRefTokens() private {
445     // 0
446     mint(0x052731748979e182fdf9Bf849C6df54f9f196645, 3);
447     mint(0x1878B18693fc273DE9FD833B83f9679785c01aB2, 1);
448     mint(0x1E3934EA7E416F4E2BC5F7d55aE9783da0061475, 1);
449     mint(0x32451d81EB31411B2CA4e70F3d87B3DEACCEA2d2, 3);
450     mint(0x494952f01a30547d269aaF147e6226f940f5B041, 8);
451     // 5
452     mint(0x5BD73bB4e2A9f81922dbE7F4b321cfAE208BE2E6, 1);
453     mint(0x6564A5639e17e186f749e493Af98a51fd3092048, 12);
454     mint(0x696A567271BBDAC6f435CAb9D69e56cD115B76eB, 1);
455     mint(0x70580eA14d98a53fd59376dC7e959F4a6129bB9b, 2);
456     mint(0x75f732C1b1D0bBdA60f4B49EF0B36EB6e8AD6531, 1);
457     // 10
458     mint(0x84418eD93d141CFE7471dED46747D003117eCaD5, 2);
459     mint(0x9455A90Cbf43D331Dd76a2d07192431370f64384, 2);
460     mint(0x95fd3579c73Ea675C89415285355C4795118B345, 1);
461     mint(0xa3346F3Af6A3AE749aCA18d7968A03811d15d733, 1);
462     mint(0xA586A3B8939e9C0DC72D88166F6F6bb7558EeDCe, 1);
463     // 15
464     mint(0xAb01D4895b802c38Eee7553bb52A4160CFca2878, 1);
465     mint(0xd6E8D52Be82550B230176b6E9bA49BC3fAF43E4a, 1);
466     mint(0xEAB0c22D927d15391dd0CfbE89a3b59F6e814551, 3);
467     mint(0x03300279d711b8dEb1353DD9719eFf81Ea1b6bEd, 3);
468     mint(0x03b4A1fdeCeC66338071180a7F2f2D518CFf224A, 4);
469     // 20
470     mint(0x0537544De3935408246EE2Ad09949D046F92574D, 4);
471     mint(0x0E26169270D92Ff3649461B55CA51C99703dE59e, 1);
472     mint(0x16Ea1F673E01419BA9aF51365b88138Ac492489a, 1);
473     mint(0x28d02f67316123Dc0293849a0D254AD86b379b34, 2);
474     mint(0x38A6022FECb675a53F31CDaB3457456DD6e5911c, 2);
475     // 25
476     mint(0x4260E8206c58cD0530d9A5cff55B77D6165c7BCd, 1);
477     mint(0x7E1DCf785f0353BF657c38Ab7865C1f184EFE208, 4);
478     mint(0x7f328117b7de7579C6249258d084f75556E2699d, 1);
479     mint(0x8a9d49a6e9D037843560091fC280B9Ff9819e462, 3);
480     mint(0x8C5fC43ad00Cc53e11F61bEce329DDc5E3ea0929, 3);
481     // 30
482     mint(0x8FF9679fc77B077cB5f8818B7B63022582b5d538, 1);
483     mint(0x97bfc7fc1Ee5b25CfAF6075bac5d7EcA037AD694, 1);
484     mint(0x993a64DB27a51D1E6C1AFF56Fb61Ba0Dac253acb, 2);
485     mint(0xa6bCEc585F12CeFBa9709A080cE2EFD38f871024, 1);
486     mint(0xaF6488744207273c79B896922e65651C61033787, 5);
487     // 35
488     mint(0xB3C2a4ce7ce57A74371b7E3dAE8f3393229c2aaC, 3);
489     mint(0xb4A90c06d5bC51D79D44e11336077b6F9ccD5683, 23);
490     mint(0xB94c9e7D28e54cb37fA3B0D3FFeC24A8E4affA90, 3);
491     mint(0xDe0D2e92e85B8B7828723Ee789ffA3Ba9FdCDb9c, 1);
492     mint(0xe37Ba1117746473db68A807aE9E37a2088BDB20f, 1);
493     // 40
494     mint(0x5eA1D56D0ddE1cA5B50c277275855F69edEfA169, 1);
495     mint(0x6692DE2d4b3102ab922cB21157EeBCD9BDDDBb15, 4);
496     // 42
497   }
498 }