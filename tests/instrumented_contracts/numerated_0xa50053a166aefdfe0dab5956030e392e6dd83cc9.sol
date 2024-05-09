1 pragma solidity ^0.4.13;
2 
3 contract Controllable {
4   address public controller;
5 
6 
7   /**
8    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
9    */
10   function Controllable() public {
11     controller = msg.sender;
12   }
13 
14   /**
15    * @dev Throws if called by any account other than the owner.
16    */
17   modifier onlyController() {
18     require(msg.sender == controller);
19     _;
20   }
21 
22   /**
23    * @dev Allows the current owner to transfer control of the contract to a newOwner.
24    * @param newController The address to transfer ownership to.
25    */
26   function transferControl(address newController) public onlyController {
27     if (newController != address(0)) {
28       controller = newController;
29     }
30   }
31 
32 }
33 
34 library SafeMath {
35   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
36     uint256 c = a * b;
37     assert(a == 0 || c / a == b);
38     return c;
39   }
40 
41   function div(uint256 a, uint256 b) internal constant returns (uint256) {
42     // assert(b > 0); // Solidity automatically throws when dividing by 0
43     uint256 c = a / b;
44     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45     return c;
46   }
47 
48   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   function add(uint256 a, uint256 b) internal constant returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 }
59 
60 contract TokenFactoryInterface {
61 
62     function createCloneToken(
63         address _parentToken,
64         uint _snapshotBlock,
65         string _tokenName,
66         string _tokenSymbol
67       ) public returns (ProofToken newToken);
68 }
69 
70 contract ProofToken is Controllable {
71 
72   using SafeMath for uint256;
73   ProofTokenInterface public parentToken;
74   TokenFactoryInterface public tokenFactory;
75 
76   string public name;
77   string public symbol;
78   string public version;
79   uint8 public decimals;
80 
81   uint256 public parentSnapShotBlock;
82   uint256 public creationBlock;
83   bool public transfersEnabled;
84 
85   bool public masterTransfersEnabled;
86   address public masterWallet = 0x740C588C5556e523981115e587892be0961853B8;
87 
88 
89   struct Checkpoint {
90     uint128 fromBlock;
91     uint128 value;
92   }
93 
94   Checkpoint[] totalSupplyHistory;
95   mapping(address => Checkpoint[]) balances;
96   mapping (address => mapping (address => uint)) allowed;
97 
98   bool public mintingFinished = false;
99   bool public presaleBalancesLocked = false;
100 
101   uint256 public constant TOTAL_PRESALE_TOKENS = 112386712924725508802400;
102 
103   event Mint(address indexed to, uint256 amount);
104   event MintFinished();
105   event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
106   event NewCloneToken(address indexed cloneToken);
107   event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
108   event Transfer(address indexed from, address indexed to, uint256 value);
109 
110 
111 
112 
113   function ProofToken(
114     address _tokenFactory,
115     address _parentToken,
116     uint256 _parentSnapShotBlock,
117     string _tokenName,
118     string _tokenSymbol
119     ) public {
120       tokenFactory = TokenFactoryInterface(_tokenFactory);
121       parentToken = ProofTokenInterface(_parentToken);
122       parentSnapShotBlock = _parentSnapShotBlock;
123       name = _tokenName;
124       symbol = _tokenSymbol;
125       decimals = 18;
126       transfersEnabled = false;
127       masterTransfersEnabled = false;
128       creationBlock = block.number;
129       version = '0.1';
130   }
131 
132   function() public payable {
133     revert();
134   }
135 
136 
137   /**
138   * Returns the total Proof token supply at the current block
139   * @return total supply {uint256}
140   */
141   function totalSupply() public constant returns (uint256) {
142     return totalSupplyAt(block.number);
143   }
144 
145   /**
146   * Returns the total Proof token supply at the given block number
147   * @param _blockNumber {uint256}
148   * @return total supply {uint256}
149   */
150   function totalSupplyAt(uint256 _blockNumber) public constant returns(uint256) {
151     // These next few lines are used when the totalSupply of the token is
152     //  requested before a check point was ever created for this token, it
153     //  requires that the `parentToken.totalSupplyAt` be queried at the
154     //  genesis block for this token as that contains totalSupply of this
155     //  token at this block number.
156     if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
157         if (address(parentToken) != 0) {
158             return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
159         } else {
160             return 0;
161         }
162 
163     // This will return the expected totalSupply during normal situations
164     } else {
165         return getValueAt(totalSupplyHistory, _blockNumber);
166     }
167   }
168 
169   /**
170   * Returns the token holder balance at the current block
171   * @param _owner {address}
172   * @return balance {uint256}
173    */
174   function balanceOf(address _owner) public constant returns (uint256 balance) {
175     return balanceOfAt(_owner, block.number);
176   }
177 
178   /**
179   * Returns the token holder balance the the given block number
180   * @param _owner {address}
181   * @param _blockNumber {uint256}
182   * @return balance {uint256}
183   */
184   function balanceOfAt(address _owner, uint256 _blockNumber) public constant returns (uint256) {
185     // These next few lines are used when the balance of the token is
186     //  requested before a check point was ever created for this token, it
187     //  requires that the `parentToken.balanceOfAt` be queried at the
188     //  genesis block for that token as this contains initial balance of
189     //  this token
190     if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
191         if (address(parentToken) != 0) {
192             return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
193         } else {
194             // Has no parent
195             return 0;
196         }
197 
198     // This will return the expected balance during normal situations
199     } else {
200         return getValueAt(balances[_owner], _blockNumber);
201     }
202   }
203 
204   /**
205   * Standard ERC20 transfer tokens function
206   * @param _to {address}
207   * @param _amount {uint}
208   * @return success {bool}
209   */
210   function transfer(address _to, uint256 _amount) public returns (bool success) {
211     return doTransfer(msg.sender, _to, _amount);
212   }
213 
214   /**
215   * Standard ERC20 transferFrom function
216   * @param _from {address}
217   * @param _to {address}
218   * @param _amount {uint256}
219   * @return success {bool}
220   */
221   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
222     require(allowed[_from][msg.sender] >= _amount);
223     allowed[_from][msg.sender] -= _amount;
224     return doTransfer(_from, _to, _amount);
225   }
226 
227   /**
228   * Standard ERC20 approve function
229   * @param _spender {address}
230   * @param _amount {uint256}
231   * @return success {bool}
232   */
233   function approve(address _spender, uint256 _amount) public returns (bool success) {
234     require(transfersEnabled);
235 
236     //https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
237     require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
238 
239     allowed[msg.sender][_spender] = _amount;
240     Approval(msg.sender, _spender, _amount);
241     return true;
242   }
243 
244   /**
245   * Standard ERC20 approve function
246   * @param _spender {address}
247   * @param _amount {uint256}
248   * @return success {bool}
249   */
250   function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
251     approve(_spender, _amount);
252 
253     ApproveAndCallReceiver(_spender).receiveApproval(
254         msg.sender,
255         _amount,
256         this,
257         _extraData
258     );
259 
260     return true;
261   }
262 
263   /**
264   * Standard ERC20 allowance function
265   * @param _owner {address}
266   * @param _spender {address}
267   * @return remaining {uint256}
268    */
269   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
270     return allowed[_owner][_spender];
271   }
272 
273   /**
274   * Internal Transfer function - Updates the checkpoint ledger
275   * @param _from {address}
276   * @param _to {address}
277   * @param _amount {uint256}
278   * @return success {bool}
279   */
280   function doTransfer(address _from, address _to, uint256 _amount) internal returns(bool) {
281 
282     if (msg.sender != masterWallet) {
283       require(transfersEnabled);
284     } else {
285       require(masterTransfersEnabled);
286     }
287 
288     require(_amount > 0);
289     require(parentSnapShotBlock < block.number);
290     require((_to != 0) && (_to != address(this)));
291 
292     // If the amount being transfered is more than the balance of the
293     // account the transfer returns false
294     uint256 previousBalanceFrom = balanceOfAt(_from, block.number);
295     require(previousBalanceFrom >= _amount);
296 
297     // First update the balance array with the new value for the address
298     //  sending the tokens
299     updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
300 
301     // Then update the balance array with the new value for the address
302     //  receiving the tokens
303     uint256 previousBalanceTo = balanceOfAt(_to, block.number);
304     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
305     updateValueAtNow(balances[_to], previousBalanceTo + _amount);
306 
307     // An event to make the transfer easy to find on the blockchain
308     Transfer(_from, _to, _amount);
309     return true;
310   }
311 
312 
313   /**
314   * Token creation functions - can only be called by the tokensale controller during the tokensale period
315   * @param _owner {address}
316   * @param _amount {uint256}
317   * @return success {bool}
318   */
319   function mint(address _owner, uint256 _amount) public onlyController canMint returns (bool) {
320     uint256 curTotalSupply = totalSupply();
321     uint256 previousBalanceTo = balanceOf(_owner);
322 
323     require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
324     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
325 
326     updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
327     updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
328     Transfer(0, _owner, _amount);
329     return true;
330   }
331 
332   modifier canMint() {
333     require(!mintingFinished);
334     _;
335   }
336 
337 
338   /**
339    * Import presale balances before the start of the token sale. After importing
340    * balances, lockPresaleBalances() has to be called to prevent further modification
341    * of presale balances.
342    * @param _addresses {address[]} Array of presale addresses
343    * @param _balances {uint256[]} Array of balances corresponding to presale addresses.
344    * @return success {bool}
345    */
346   function importPresaleBalances(address[] _addresses, uint256[] _balances) public onlyController returns (bool) {
347     require(presaleBalancesLocked == false);
348 
349     for (uint256 i = 0; i < _addresses.length; i++) {
350       updateValueAtNow(balances[_addresses[i]], _balances[i]);
351       Transfer(0, _addresses[i], _balances[i]);
352     }
353 
354     updateValueAtNow(totalSupplyHistory, TOTAL_PRESALE_TOKENS);
355     return true;
356   }
357 
358   /**
359    * Lock presale balances after successful presale balance import
360    * @return A boolean that indicates if the operation was successful.
361    */
362   function lockPresaleBalances() public onlyController returns (bool) {
363     presaleBalancesLocked = true;
364     return true;
365   }
366 
367   /**
368    * Lock the minting of Proof Tokens - to be called after the presale
369    * @return {bool} success
370   */
371   function finishMinting() public onlyController returns (bool) {
372     mintingFinished = true;
373     MintFinished();
374     return true;
375   }
376 
377   /**
378    * Enable or block transfers - to be called in case of emergency
379    * @param _value {bool}
380   */
381   function enableTransfers(bool _value) public onlyController {
382     transfersEnabled = _value;
383   }
384 
385   /**
386    * Enable or block transfers - to be called in case of emergency
387    * @param _value {bool}
388   */
389   function enableMasterTransfers(bool _value) public onlyController {
390     masterTransfersEnabled = _value;
391   }
392 
393   /**
394    * Internal balance method - gets a certain checkpoint value a a certain _block
395    * @param _checkpoints {Checkpoint[]} List of checkpoints - supply history or balance history
396    * @return value {uint256} Value of _checkpoints at _block
397   */
398   function getValueAt(Checkpoint[] storage _checkpoints, uint256 _block) constant internal returns (uint256) {
399 
400       if (_checkpoints.length == 0)
401         return 0;
402       // Shortcut for the actual value
403       if (_block >= _checkpoints[_checkpoints.length-1].fromBlock)
404         return _checkpoints[_checkpoints.length-1].value;
405       if (_block < _checkpoints[0].fromBlock)
406         return 0;
407 
408       // Binary search of the value in the array
409       uint256 min = 0;
410       uint256 max = _checkpoints.length-1;
411       while (max > min) {
412           uint256 mid = (max + min + 1) / 2;
413           if (_checkpoints[mid].fromBlock<=_block) {
414               min = mid;
415           } else {
416               max = mid-1;
417           }
418       }
419       return _checkpoints[min].value;
420   }
421 
422 
423   /**
424   * Internal update method - updates the checkpoint ledger at the current block
425   * @param _checkpoints {Checkpoint[]}  List of checkpoints - supply history or balance history
426   * @return value {uint256} Value to add to the checkpoints ledger
427    */
428   function updateValueAtNow(Checkpoint[] storage _checkpoints, uint256 _value) internal {
429       if ((_checkpoints.length == 0) || (_checkpoints[_checkpoints.length-1].fromBlock < block.number)) {
430               Checkpoint storage newCheckPoint = _checkpoints[_checkpoints.length++];
431               newCheckPoint.fromBlock = uint128(block.number);
432               newCheckPoint.value = uint128(_value);
433           } else {
434               Checkpoint storage oldCheckPoint = _checkpoints[_checkpoints.length-1];
435               oldCheckPoint.value = uint128(_value);
436           }
437   }
438 
439 
440   function min(uint256 a, uint256 b) internal constant returns (uint) {
441       return a < b ? a : b;
442   }
443 
444   /**
445   * Clones Proof Token at the given snapshot block
446   * @param _snapshotBlock {uint256}
447   * @param _name {string} - The cloned token name
448   * @param _symbol {string} - The cloned token symbol
449   * @return clonedTokenAddress {address}
450    */
451   function createCloneToken(uint256 _snapshotBlock, string _name, string _symbol) public returns(address) {
452 
453       if (_snapshotBlock == 0) {
454         _snapshotBlock = block.number;
455       }
456 
457       if (_snapshotBlock > block.number) {
458         _snapshotBlock = block.number;
459       }
460 
461       ProofToken cloneToken = tokenFactory.createCloneToken(
462           this,
463           _snapshotBlock,
464           _name,
465           _symbol
466         );
467 
468 
469       cloneToken.transferControl(msg.sender);
470 
471       // An event to make the token easy to find on the blockchain
472       NewCloneToken(address(cloneToken));
473       return address(cloneToken);
474     }
475 
476 }
477 
478 contract ControllerInterface {
479 
480     function proxyPayment(address _owner) public payable returns(bool);
481     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
482     function onApprove(address _owner, address _spender, uint _amount) public returns(bool);
483 }
484 
485 contract ProofTokenInterface is Controllable {
486 
487   event Mint(address indexed to, uint256 amount);
488   event MintFinished();
489   event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
490   event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
491   event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
492   event Transfer(address indexed from, address indexed to, uint256 value);
493 
494   function totalSupply() public constant returns (uint);
495   function totalSupplyAt(uint _blockNumber) public constant returns(uint);
496   function balanceOf(address _owner) public constant returns (uint256 balance);
497   function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint);
498   function transfer(address _to, uint256 _amount) public returns (bool success);
499   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
500   function approve(address _spender, uint256 _amount) public returns (bool success);
501   function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success);
502   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
503   function mint(address _owner, uint _amount) public returns (bool);
504   function importPresaleBalances(address[] _addresses, uint256[] _balances, address _presaleAddress) public returns (bool);
505   function lockPresaleBalances() public returns (bool);
506   function finishMinting() public returns (bool);
507   function enableTransfers(bool _value) public;
508   function enableMasterTransfers(bool _value) public;
509   function createCloneToken(uint _snapshotBlock, string _cloneTokenName, string _cloneTokenSymbol) public returns (address);
510 
511 }
512 
513 contract ApproveAndCallReceiver {
514     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
515 }