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
40       ) public returns (ProofToken newToken);
41 }
42 
43 contract Controllable {
44   address public controller;
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
49    */
50   function Controllable() public {
51     controller = msg.sender;
52   }
53 
54   /**
55    * @dev Throws if called by any account other than the owner.
56    */
57   modifier onlyController() {
58     require(msg.sender == controller);
59     _;
60   }
61 
62   /**
63    * @dev Allows the current owner to transfer control of the contract to a newOwner.
64    * @param newController The address to transfer ownership to.
65    */
66   function transferControl(address newController) public onlyController {
67     if (newController != address(0)) {
68       controller = newController;
69     }
70   }
71 
72 }
73 
74 contract ProofToken is Controllable {
75 
76   using SafeMath for uint256;
77   ProofTokenInterface public parentToken;
78   TokenFactoryInterface public tokenFactory;
79 
80   string public name;
81   string public symbol;
82   string public version;
83   uint8 public decimals;
84 
85   uint256 public parentSnapShotBlock;
86   uint256 public creationBlock;
87   bool public transfersEnabled;
88 
89   bool public masterTransfersEnabled;
90   address public masterWallet = 0xD8271285C255Ce31b9b25E46ac63619322Af5934;
91 
92 
93   struct Checkpoint {
94     uint128 fromBlock;
95     uint128 value;
96   }
97 
98   Checkpoint[] totalSupplyHistory;
99   mapping(address => Checkpoint[]) balances;
100   mapping (address => mapping (address => uint)) allowed;
101 
102   bool public mintingFinished = false;
103   bool public presaleBalancesLocked = false;
104 
105   uint256 public constant TOTAL_PRESALE_TOKENS = 112386712924725508802400;
106 
107   event Mint(address indexed to, uint256 amount);
108   event MintFinished();
109   event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
110   event NewCloneToken(address indexed cloneToken);
111   event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
112   event Transfer(address indexed from, address indexed to, uint256 value);
113 
114 
115 
116 
117   function ProofToken(
118     address _tokenFactory,
119     address _parentToken,
120     uint256 _parentSnapShotBlock,
121     string _tokenName,
122     string _tokenSymbol
123     ) public {
124       tokenFactory = TokenFactoryInterface(_tokenFactory);
125       parentToken = ProofTokenInterface(_parentToken);
126       parentSnapShotBlock = _parentSnapShotBlock;
127       name = _tokenName;
128       symbol = _tokenSymbol;
129       decimals = 18;
130       transfersEnabled = false;
131       masterTransfersEnabled = false;
132       creationBlock = block.number;
133       version = '0.1';
134   }
135 
136   function() public payable {
137     revert();
138   }
139 
140 
141   /**
142   * Returns the total Proof token supply at the current block
143   * @return total supply {uint256}
144   */
145   function totalSupply() public constant returns (uint256) {
146     return totalSupplyAt(block.number);
147   }
148 
149   /**
150   * Returns the total Proof token supply at the given block number
151   * @param _blockNumber {uint256}
152   * @return total supply {uint256}
153   */
154   function totalSupplyAt(uint256 _blockNumber) public constant returns(uint256) {
155     // These next few lines are used when the totalSupply of the token is
156     //  requested before a check point was ever created for this token, it
157     //  requires that the `parentToken.totalSupplyAt` be queried at the
158     //  genesis block for this token as that contains totalSupply of this
159     //  token at this block number.
160     if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
161         if (address(parentToken) != 0) {
162             return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
163         } else {
164             return 0;
165         }
166 
167     // This will return the expected totalSupply during normal situations
168     } else {
169         return getValueAt(totalSupplyHistory, _blockNumber);
170     }
171   }
172 
173   /**
174   * Returns the token holder balance at the current block
175   * @param _owner {address}
176   * @return balance {uint256}
177    */
178   function balanceOf(address _owner) public constant returns (uint256 balance) {
179     return balanceOfAt(_owner, block.number);
180   }
181 
182   /**
183   * Returns the token holder balance the the given block number
184   * @param _owner {address}
185   * @param _blockNumber {uint256}
186   * @return balance {uint256}
187   */
188   function balanceOfAt(address _owner, uint256 _blockNumber) public constant returns (uint256) {
189     // These next few lines are used when the balance of the token is
190     //  requested before a check point was ever created for this token, it
191     //  requires that the `parentToken.balanceOfAt` be queried at the
192     //  genesis block for that token as this contains initial balance of
193     //  this token
194     if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
195         if (address(parentToken) != 0) {
196             return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
197         } else {
198             // Has no parent
199             return 0;
200         }
201 
202     // This will return the expected balance during normal situations
203     } else {
204         return getValueAt(balances[_owner], _blockNumber);
205     }
206   }
207 
208   /**
209   * Standard ERC20 transfer tokens function
210   * @param _to {address}
211   * @param _amount {uint}
212   * @return success {bool}
213   */
214   function transfer(address _to, uint256 _amount) public returns (bool success) {
215     return doTransfer(msg.sender, _to, _amount);
216   }
217 
218   /**
219   * Standard ERC20 transferFrom function
220   * @param _from {address}
221   * @param _to {address}
222   * @param _amount {uint256}
223   * @return success {bool}
224   */
225   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
226     require(allowed[_from][msg.sender] >= _amount);
227     allowed[_from][msg.sender] -= _amount;
228     return doTransfer(_from, _to, _amount);
229   }
230 
231   /**
232   * Standard ERC20 approve function
233   * @param _spender {address}
234   * @param _amount {uint256}
235   * @return success {bool}
236   */
237   function approve(address _spender, uint256 _amount) public returns (bool success) {
238     require(transfersEnabled);
239 
240     //https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
241     require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
242 
243     allowed[msg.sender][_spender] = _amount;
244     Approval(msg.sender, _spender, _amount);
245     return true;
246   }
247 
248   /**
249   * Standard ERC20 approve function
250   * @param _spender {address}
251   * @param _amount {uint256}
252   * @return success {bool}
253   */
254   function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
255     approve(_spender, _amount);
256 
257     ApproveAndCallReceiver(_spender).receiveApproval(
258         msg.sender,
259         _amount,
260         this,
261         _extraData
262     );
263 
264     return true;
265   }
266 
267   /**
268   * Standard ERC20 allowance function
269   * @param _owner {address}
270   * @param _spender {address}
271   * @return remaining {uint256}
272    */
273   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
274     return allowed[_owner][_spender];
275   }
276 
277   /**
278   * Internal Transfer function - Updates the checkpoint ledger
279   * @param _from {address}
280   * @param _to {address}
281   * @param _amount {uint256}
282   * @return success {bool}
283   */
284   function doTransfer(address _from, address _to, uint256 _amount) internal returns(bool) {
285 
286     if (msg.sender != masterWallet) {
287       require(transfersEnabled);
288     } else {
289       require(masterTransfersEnabled);
290     }
291 
292     require(_amount > 0);
293     require(parentSnapShotBlock < block.number);
294     require((_to != 0) && (_to != address(this)));
295 
296     // If the amount being transfered is more than the balance of the
297     // account the transfer returns false
298     uint256 previousBalanceFrom = balanceOfAt(_from, block.number);
299     require(previousBalanceFrom >= _amount);
300 
301     // First update the balance array with the new value for the address
302     //  sending the tokens
303     updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
304 
305     // Then update the balance array with the new value for the address
306     //  receiving the tokens
307     uint256 previousBalanceTo = balanceOfAt(_to, block.number);
308     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
309     updateValueAtNow(balances[_to], previousBalanceTo + _amount);
310 
311     // An event to make the transfer easy to find on the blockchain
312     Transfer(_from, _to, _amount);
313     return true;
314   }
315 
316 
317   /**
318   * Token creation functions - can only be called by the tokensale controller during the tokensale period
319   * @param _owner {address}
320   * @param _amount {uint256}
321   * @return success {bool}
322   */
323   function mint(address _owner, uint256 _amount) public onlyController canMint returns (bool) {
324     uint256 curTotalSupply = totalSupply();
325     uint256 previousBalanceTo = balanceOf(_owner);
326 
327     require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
328     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
329 
330     updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
331     updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
332     Transfer(0, _owner, _amount);
333     return true;
334   }
335 
336   modifier canMint() {
337     require(!mintingFinished);
338     _;
339   }
340 
341 
342   /**
343    * Import presale balances before the start of the token sale. After importing
344    * balances, lockPresaleBalances() has to be called to prevent further modification
345    * of presale balances.
346    * @param _addresses {address[]} Array of presale addresses
347    * @param _balances {uint256[]} Array of balances corresponding to presale addresses.
348    * @return success {bool}
349    */
350   function importPresaleBalances(address[] _addresses, uint256[] _balances) public onlyController returns (bool) {
351     require(presaleBalancesLocked == false);
352 
353     for (uint256 i = 0; i < _addresses.length; i++) {
354       updateValueAtNow(balances[_addresses[i]], _balances[i]);
355       Transfer(0, _addresses[i], _balances[i]);
356     }
357 
358     updateValueAtNow(totalSupplyHistory, TOTAL_PRESALE_TOKENS);
359     return true;
360   }
361 
362   /**
363    * Lock presale balances after successful presale balance import
364    * @return A boolean that indicates if the operation was successful.
365    */
366   function lockPresaleBalances() public onlyController returns (bool) {
367     presaleBalancesLocked = true;
368     return true;
369   }
370 
371   /**
372    * Lock the minting of Proof Tokens - to be called after the presale
373    * @return {bool} success
374   */
375   function finishMinting() public onlyController returns (bool) {
376     mintingFinished = true;
377     MintFinished();
378     return true;
379   }
380 
381   /**
382    * Enable or block transfers - to be called in case of emergency
383    * @param _value {bool}
384   */
385   function enableTransfers(bool _value) public onlyController {
386     transfersEnabled = _value;
387   }
388 
389   /**
390    * Enable or block transfers - to be called in case of emergency
391    * @param _value {bool}
392   */
393   function enableMasterTransfers(bool _value) public onlyController {
394     masterTransfersEnabled = _value;
395   }
396 
397   /**
398    * Internal balance method - gets a certain checkpoint value a a certain _block
399    * @param _checkpoints {Checkpoint[]} List of checkpoints - supply history or balance history
400    * @return value {uint256} Value of _checkpoints at _block
401   */
402   function getValueAt(Checkpoint[] storage _checkpoints, uint256 _block) constant internal returns (uint256) {
403 
404       if (_checkpoints.length == 0)
405         return 0;
406       // Shortcut for the actual value
407       if (_block >= _checkpoints[_checkpoints.length-1].fromBlock)
408         return _checkpoints[_checkpoints.length-1].value;
409       if (_block < _checkpoints[0].fromBlock)
410         return 0;
411 
412       // Binary search of the value in the array
413       uint256 min = 0;
414       uint256 max = _checkpoints.length-1;
415       while (max > min) {
416           uint256 mid = (max + min + 1) / 2;
417           if (_checkpoints[mid].fromBlock<=_block) {
418               min = mid;
419           } else {
420               max = mid-1;
421           }
422       }
423       return _checkpoints[min].value;
424   }
425 
426 
427   /**
428   * Internal update method - updates the checkpoint ledger at the current block
429   * @param _checkpoints {Checkpoint[]}  List of checkpoints - supply history or balance history
430   * @return value {uint256} Value to add to the checkpoints ledger
431    */
432   function updateValueAtNow(Checkpoint[] storage _checkpoints, uint256 _value) internal {
433       if ((_checkpoints.length == 0) || (_checkpoints[_checkpoints.length-1].fromBlock < block.number)) {
434               Checkpoint storage newCheckPoint = _checkpoints[_checkpoints.length++];
435               newCheckPoint.fromBlock = uint128(block.number);
436               newCheckPoint.value = uint128(_value);
437           } else {
438               Checkpoint storage oldCheckPoint = _checkpoints[_checkpoints.length-1];
439               oldCheckPoint.value = uint128(_value);
440           }
441   }
442 
443 
444   function min(uint256 a, uint256 b) internal constant returns (uint) {
445       return a < b ? a : b;
446   }
447 
448   /**
449   * Clones Proof Token at the given snapshot block
450   * @param _snapshotBlock {uint256}
451   * @param _name {string} - The cloned token name
452   * @param _symbol {string} - The cloned token symbol
453   * @return clonedTokenAddress {address}
454    */
455   function createCloneToken(uint256 _snapshotBlock, string _name, string _symbol) public returns(address) {
456 
457       if (_snapshotBlock == 0) {
458         _snapshotBlock = block.number;
459       }
460 
461       if (_snapshotBlock > block.number) {
462         _snapshotBlock = block.number;
463       }
464 
465       ProofToken cloneToken = tokenFactory.createCloneToken(
466           this,
467           _snapshotBlock,
468           _name,
469           _symbol
470         );
471 
472 
473       cloneToken.transferControl(msg.sender);
474 
475       // An event to make the token easy to find on the blockchain
476       NewCloneToken(address(cloneToken));
477       return address(cloneToken);
478     }
479 
480 }
481 
482 contract ProofTokenInterface is Controllable {
483 
484   event Mint(address indexed to, uint256 amount);
485   event MintFinished();
486   event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
487   event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
488   event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
489   event Transfer(address indexed from, address indexed to, uint256 value);
490 
491   function totalSupply() public constant returns (uint);
492   function totalSupplyAt(uint _blockNumber) public constant returns(uint);
493   function balanceOf(address _owner) public constant returns (uint256 balance);
494   function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint);
495   function transfer(address _to, uint256 _amount) public returns (bool success);
496   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
497   function approve(address _spender, uint256 _amount) public returns (bool success);
498   function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success);
499   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
500   function mint(address _owner, uint _amount) public returns (bool);
501   function importPresaleBalances(address[] _addresses, uint256[] _balances, address _presaleAddress) public returns (bool);
502   function lockPresaleBalances() public returns (bool);
503   function finishMinting() public returns (bool);
504   function enableTransfers(bool _value) public;
505   function enableMasterTransfers(bool _value) public;
506   function createCloneToken(uint _snapshotBlock, string _cloneTokenName, string _cloneTokenSymbol) public returns (address);
507 
508 }
509 
510 contract ControllerInterface {
511 
512     function proxyPayment(address _owner) public payable returns(bool);
513     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
514     function onApprove(address _owner, address _spender, uint _amount) public returns(bool);
515 }