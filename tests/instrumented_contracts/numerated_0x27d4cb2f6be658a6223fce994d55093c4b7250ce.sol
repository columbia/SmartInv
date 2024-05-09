1 pragma solidity ^0.4.15;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract ApproveAndCallReceiver {
30     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
31 }
32 
33 contract TokenFactoryInterface {
34 
35     function createCloneToken(
36         address _parentToken,
37         uint _snapshotBlock,
38         string _tokenName,
39         string _tokenSymbol
40       ) public returns (ServusToken newToken);
41 }
42 
43 /**
44  * @title Controllable
45  * @dev The Controllable contract has an controller address, and provides basic authorization control
46  * functions, this simplifies the implementation of "user permissions".
47  */
48 contract Controllable {
49   address public controller;
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
54    */
55   function Controllable() public {
56     controller = msg.sender;
57   }
58 
59   /**
60    * @dev Throws if called by any account other than the owner.
61    */
62   modifier onlyController() {
63     require(msg.sender == controller);
64     _;
65   }
66 
67   /**
68    * @dev Allows the current owner to transfer control of the contract to a newOwner.
69    * @param newController The address to transfer ownership to.
70    */
71   function transferControl(address newController) public onlyController {
72     if (newController != address(0)) {
73       controller = newController;
74     }
75   }
76 
77 }
78 
79 /**
80  * @title ServusToken (SRV)
81  * Standard Mintable ERC20 Token
82  * https://github.com/ethereum/EIPs/issues/20
83  * Based on code by FirstBlood:
84  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
85  */
86 contract ServusTokenInterface is Controllable {
87 
88   event Mint(address indexed to, uint256 amount);
89   event MintFinished();
90   event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
91   event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
92   event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 
95   function totalSupply() public constant returns (uint);
96   function totalSupplyAt(uint _blockNumber) public constant returns(uint);
97   function balanceOf(address _owner) public constant returns (uint256 balance);
98   function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint);
99   function transfer(address _to, uint256 _amount) public returns (bool success);
100   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
101   function approve(address _spender, uint256 _amount) public returns (bool success);
102   function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success);
103   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
104   function mint(address _owner, uint _amount) public returns (bool);
105   function importPresaleBalances(address[] _addresses, uint256[] _balances, address _presaleAddress) public returns (bool);
106   function lockPresaleBalances() public returns (bool);
107   function finishMinting() public returns (bool);
108   function enableTransfers(bool _value) public;
109   function enableMasterTransfers(bool _value) public;
110   function createCloneToken(uint _snapshotBlock, string _cloneTokenName, string _cloneTokenSymbol) public returns (address);
111 
112 }
113 
114 
115 contract ServusToken is Controllable {
116 
117   using SafeMath for uint256;
118   ServusTokenInterface public parentToken;
119   TokenFactoryInterface public tokenFactory;
120 
121   string public name;
122   string public symbol;
123   string public version;
124   uint8 public decimals;
125 
126   uint256 public parentSnapShotBlock;
127   uint256 public creationBlock;
128   bool public transfersEnabled;
129 
130   bool public masterTransfersEnabled;
131   address public masterWallet = 0x9d23cc4efa366b70f34f1879bc6178e6f3342441;
132 
133 
134   struct Checkpoint {
135     uint128 fromBlock;
136     uint128 value;
137   }
138 
139   Checkpoint[] totalSupplyHistory;
140   mapping(address => Checkpoint[]) balances;
141   mapping (address => mapping (address => uint)) allowed;
142 
143   bool public mintingFinished = false;
144   bool public presaleBalancesLocked = false;
145 
146   uint256 public constant TOTAL_PRESALE_TOKENS = 2896000000000000000000;
147 
148   event Mint(address indexed to, uint256 amount);
149   event MintFinished();
150   event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
151   event NewCloneToken(address indexed cloneToken);
152   event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
153   event Transfer(address indexed from, address indexed to, uint256 value);
154 
155 
156 
157 
158   function ServusToken(
159     address _tokenFactory,
160     address _parentToken,
161     uint256 _parentSnapShotBlock,
162     string _tokenName,
163     string _tokenSymbol
164     ) public {
165       tokenFactory = TokenFactoryInterface(_tokenFactory);
166       parentToken = ServusTokenInterface(_parentToken);
167       parentSnapShotBlock = _parentSnapShotBlock;
168       name = _tokenName;
169       symbol = _tokenSymbol;
170       decimals = 6;
171       transfersEnabled = false;
172       masterTransfersEnabled = false;
173       creationBlock = block.number;
174       version = '0.1';
175   }
176 
177   function() public payable {
178     revert();
179   }
180 
181 
182   /**
183   * Returns the total Servus token supply at the current block
184   * @return total supply {uint256}
185   */
186   function totalSupply() public constant returns (uint256) {
187     return totalSupplyAt(block.number);
188   }
189 
190   /**
191   * Returns the total Servus token supply at the given block number
192   * @param _blockNumber {uint256}
193   * @return total supply {uint256}
194   */
195   function totalSupplyAt(uint256 _blockNumber) public constant returns(uint256) {
196     // These next few lines are used when the totalSupply of the token is
197     //  requested before a check point was ever created for this token, it
198     //  requires that the `parentToken.totalSupplyAt` be queried at the
199     //  genesis block for this token as that contains totalSupply of this
200     //  token at this block number.
201     if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
202         if (address(parentToken) != 0) {
203             return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
204         } else {
205             return 0;
206         }
207 
208     // This will return the expected totalSupply during normal situations
209     } else {
210         return getValueAt(totalSupplyHistory, _blockNumber);
211     }
212   }
213 
214   /**
215   * Returns the token holder balance at the current block
216   * @param _owner {address}
217   * @return balance {uint256}
218    */
219   function balanceOf(address _owner) public constant returns (uint256 balance) {
220     return balanceOfAt(_owner, block.number);
221   }
222 
223   /**
224   * Returns the token holder balance the the given block number
225   * @param _owner {address}
226   * @param _blockNumber {uint256}
227   * @return balance {uint256}
228   */
229   function balanceOfAt(address _owner, uint256 _blockNumber) public constant returns (uint256) {
230     // These next few lines are used when the balance of the token is
231     //  requested before a check point was ever created for this token, it
232     //  requires that the `parentToken.balanceOfAt` be queried at the
233     //  genesis block for that token as this contains initial balance of
234     //  this token
235     if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
236         if (address(parentToken) != 0) {
237             return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
238         } else {
239             // Has no parent
240             return 0;
241         }
242 
243     // This will return the expected balance during normal situations
244     } else {
245         return getValueAt(balances[_owner], _blockNumber);
246     }
247   }
248 
249   /**
250   * Standard ERC20 transfer tokens function
251   * @param _to {address}
252   * @param _amount {uint}
253   * @return success {bool}
254   */
255   function transfer(address _to, uint256 _amount) public returns (bool success) {
256     return doTransfer(msg.sender, _to, _amount);
257   }
258 
259   /**
260   * Standard ERC20 transferFrom function
261   * @param _from {address}
262   * @param _to {address}
263   * @param _amount {uint256}
264   * @return success {bool}
265   */
266   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
267     require(allowed[_from][msg.sender] >= _amount);
268     allowed[_from][msg.sender] -= _amount;
269     return doTransfer(_from, _to, _amount);
270   }
271 
272   /**
273   * Standard ERC20 approve function
274   * @param _spender {address}
275   * @param _amount {uint256}
276   * @return success {bool}
277   */
278   function approve(address _spender, uint256 _amount) public returns (bool success) {
279     require(transfersEnabled);
280 
281     //https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
282     require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
283 
284     allowed[msg.sender][_spender] = _amount;
285     Approval(msg.sender, _spender, _amount);
286     return true;
287   }
288 
289   /**
290   * Standard ERC20 approve function
291   * @param _spender {address}
292   * @param _amount {uint256}
293   * @return success {bool}
294   */
295   function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
296     approve(_spender, _amount);
297 
298     ApproveAndCallReceiver(_spender).receiveApproval(
299         msg.sender,
300         _amount,
301         this,
302         _extraData
303     );
304 
305     return true;
306   }
307 
308   /**
309   * Standard ERC20 allowance function
310   * @param _owner {address}
311   * @param _spender {address}
312   * @return remaining {uint256}
313    */
314   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
315     return allowed[_owner][_spender];
316   }
317 
318   /**
319   * Internal Transfer function - Updates the checkpoint ledger
320   * @param _from {address}
321   * @param _to {address}
322   * @param _amount {uint256}
323   * @return success {bool}
324   */
325   function doTransfer(address _from, address _to, uint256 _amount) internal returns(bool) {
326 
327     if (msg.sender != masterWallet) {
328       require(transfersEnabled);
329     } else {
330       require(masterTransfersEnabled);
331     }
332 
333     require(_amount > 0);
334     require(parentSnapShotBlock < block.number);
335     require((_to != 0) && (_to != address(this)));
336 
337     // If the amount being transfered is more than the balance of the
338     // account the transfer returns false
339     uint256 previousBalanceFrom = balanceOfAt(_from, block.number);
340     require(previousBalanceFrom >= _amount);
341 
342     // First update the balance array with the new value for the address
343     //  sending the tokens
344     updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
345 
346     // Then update the balance array with the new value for the address
347     //  receiving the tokens
348     uint256 previousBalanceTo = balanceOfAt(_to, block.number);
349     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
350     updateValueAtNow(balances[_to], previousBalanceTo + _amount);
351 
352     // An event to make the transfer easy to find on the blockchain
353     Transfer(_from, _to, _amount);
354     return true;
355   }
356 
357 
358   /**
359   * Token creation functions - can only be called by the tokensale controller during the tokensale period
360   * @param _owner {address}
361   * @param _amount {uint256}
362   * @return success {bool}
363   */
364   function mint(address _owner, uint256 _amount) public onlyController canMint returns (bool) {
365     uint256 curTotalSupply = totalSupply();
366     uint256 previousBalanceTo = balanceOf(_owner);
367 
368     require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
369     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
370 
371     updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
372     updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
373     Transfer(0, _owner, _amount);
374     return true;
375   }
376 
377   modifier canMint() {
378     require(!mintingFinished);
379     _;
380   }
381 
382 
383   /**
384    * Import presale balances before the start of the token sale. After importing
385    * balances, lockPresaleBalances() has to be called to prevent further modification
386    * of presale balances.
387    * @param _addresses {address[]} Array of presale addresses
388    * @param _balances {uint256[]} Array of balances corresponding to presale addresses.
389    * @return success {bool}
390    */
391   function importPresaleBalances(address[] _addresses, uint256[] _balances) public onlyController returns (bool) {
392     require(presaleBalancesLocked == false);
393 
394     for (uint256 i = 0; i < _addresses.length; i++) {
395       updateValueAtNow(balances[_addresses[i]], _balances[i]);
396       Transfer(0, _addresses[i], _balances[i]);
397     }
398 
399     updateValueAtNow(totalSupplyHistory, TOTAL_PRESALE_TOKENS);
400     return true;
401   }
402 
403   /**
404    * Lock presale balances after successful presale balance import
405    * @return A boolean that indicates if the operation was successful.
406    */
407   function lockPresaleBalances() public onlyController returns (bool) {
408     presaleBalancesLocked = true;
409     return true;
410   }
411 
412   /**
413    * Lock the minting of Servus Tokens - to be called after the presale
414    * @return {bool} success
415   */
416   function finishMinting() public onlyController returns (bool) {
417     mintingFinished = true;
418     MintFinished();
419     return true;
420   }
421 
422   /**
423    * Enable or block transfers - to be called in case of emergency
424    * @param _value {bool}
425   */
426   function enableTransfers(bool _value) public onlyController {
427     transfersEnabled = _value;
428   }
429 
430   /**
431    * Enable or block transfers - to be called in case of emergency
432    * @param _value {bool}
433   */
434   function enableMasterTransfers(bool _value) public onlyController {
435     masterTransfersEnabled = _value;
436   }
437 
438   /**
439    * Internal balance method - gets a certain checkpoint value a a certain _block
440    * @param _checkpoints {Checkpoint[]} List of checkpoints - supply history or balance history
441    * @return value {uint256} Value of _checkpoints at _block
442   */
443   function getValueAt(Checkpoint[] storage _checkpoints, uint256 _block) constant internal returns (uint256) {
444 
445       if (_checkpoints.length == 0)
446         return 0;
447       // Shortcut for the actual value
448       if (_block >= _checkpoints[_checkpoints.length-1].fromBlock)
449         return _checkpoints[_checkpoints.length-1].value;
450       if (_block < _checkpoints[0].fromBlock)
451         return 0;
452 
453       // Binary search of the value in the array
454       uint256 min = 0;
455       uint256 max = _checkpoints.length-1;
456       while (max > min) {
457           uint256 mid = (max + min + 1) / 2;
458           if (_checkpoints[mid].fromBlock<=_block) {
459               min = mid;
460           } else {
461               max = mid-1;
462           }
463       }
464       return _checkpoints[min].value;
465   }
466 
467 
468   /**
469   * Internal update method - updates the checkpoint ledger at the current block
470   * @param _checkpoints {Checkpoint[]}  List of checkpoints - supply history or balance history
471   * @return value {uint256} Value to add to the checkpoints ledger
472    */
473   function updateValueAtNow(Checkpoint[] storage _checkpoints, uint256 _value) internal {
474       if ((_checkpoints.length == 0) || (_checkpoints[_checkpoints.length-1].fromBlock < block.number)) {
475               Checkpoint storage newCheckPoint = _checkpoints[_checkpoints.length++];
476               newCheckPoint.fromBlock = uint128(block.number);
477               newCheckPoint.value = uint128(_value);
478           } else {
479               Checkpoint storage oldCheckPoint = _checkpoints[_checkpoints.length-1];
480               oldCheckPoint.value = uint128(_value);
481           }
482   }
483 
484 
485   function min(uint256 a, uint256 b) internal constant returns (uint) {
486       return a < b ? a : b;
487   }
488 
489   /**
490   * Clones Servus Token at the given snapshot block
491   * @param _snapshotBlock {uint256}
492   * @param _name {string} - The cloned token name
493   * @param _symbol {string} - The cloned token symbol
494   * @return clonedTokenAddress {address}
495    */
496   function createCloneToken(uint256 _snapshotBlock, string _name, string _symbol) public returns(address) {
497 
498       if (_snapshotBlock == 0) {
499         _snapshotBlock = block.number;
500       }
501 
502       if (_snapshotBlock > block.number) {
503         _snapshotBlock = block.number;
504       }
505 
506       ServusToken cloneToken = tokenFactory.createCloneToken(
507           this,
508           _snapshotBlock,
509           _name,
510           _symbol
511         );
512 
513 
514       cloneToken.transferControl(msg.sender);
515 
516       // An event to make the token easy to find on the blockchain
517       NewCloneToken(address(cloneToken));
518       return address(cloneToken);
519     }
520 
521 }