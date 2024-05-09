1 pragma solidity ^0.4.15;
2 
3 contract TokenFactoryInterface {
4 
5     function createCloneToken(
6         address _parentToken,
7         uint _snapshotBlock,
8         string _tokenName,
9         string _tokenSymbol
10       ) public returns (ProofToken newToken);
11 }
12 
13 contract ControllerInterface {
14 
15     function proxyPayment(address _owner) public payable returns(bool);
16     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
17     function onApprove(address _owner, address _spender, uint _amount) public returns(bool);
18 }
19 
20 library SafeMath {
21   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
22     uint256 c = a * b;
23     assert(a == 0 || c / a == b);
24     return c;
25   }
26 
27   function div(uint256 a, uint256 b) internal constant returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   function add(uint256 a, uint256 b) internal constant returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 contract ApproveAndCallReceiver {
47     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
48 }
49 
50 contract Controllable {
51   address public controller;
52 
53 
54   /**
55    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
56    */
57   function Controllable() public {
58     controller = msg.sender;
59   }
60 
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyController() {
65     require(msg.sender == controller);
66     _;
67   }
68 
69   /**
70    * @dev Allows the current owner to transfer control of the contract to a newOwner.
71    * @param newController The address to transfer ownership to.
72    */
73   function transferControl(address newController) public onlyController {
74     if (newController != address(0)) {
75       controller = newController;
76     }
77   }
78 
79 }
80 
81 contract ProofTokenInterface is Controllable {
82 
83   event Mint(address indexed to, uint256 amount);
84   event MintFinished();
85   event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
86   event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
87   event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
88   event Transfer(address indexed from, address indexed to, uint256 value);
89 
90   function totalSupply() public constant returns (uint);
91   function totalSupplyAt(uint _blockNumber) public constant returns(uint);
92   function balanceOf(address _owner) public constant returns (uint256 balance);
93   function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint);
94   function transfer(address _to, uint256 _amount) public returns (bool success);
95   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
96   function approve(address _spender, uint256 _amount) public returns (bool success);
97   function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success);
98   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
99   function mint(address _owner, uint _amount) public returns (bool);
100   function importPresaleBalances(address[] _addresses, uint256[] _balances, address _presaleAddress) public returns (bool);
101   function lockPresaleBalances() public returns (bool);
102   function finishMinting() public returns (bool);
103   function enableTransfers(bool _transfersEnabled) public;
104   function createCloneToken(uint _snapshotBlock, string _cloneTokenName, string _cloneTokenSymbol) public returns (address);
105 
106 }
107 
108 contract ProofToken is Controllable {
109 
110   using SafeMath for uint256;
111   ProofTokenInterface public parentToken;
112   TokenFactoryInterface public tokenFactory;
113 
114   string public name;
115   string public symbol;
116   string public version;
117   uint8 public decimals;
118 
119   struct Checkpoint {
120     uint128 fromBlock;
121     uint128 value;
122   }
123 
124   uint256 public parentSnapShotBlock;
125   uint256 public creationBlock;
126   bool public transfersEnabled;
127 
128   mapping(address => Checkpoint[]) balances;
129   mapping (address => mapping (address => uint)) allowed;
130 
131   Checkpoint[] totalSupplyHistory;
132 
133   bool public mintingFinished = false;
134   bool public presaleBalancesLocked = false;
135 
136   uint256 public constant TOKENS_ALLOCATED_TO_PROOF = 1181031 * (10 ** 18);
137   uint256 public constant TOTAL_PRESALE_TOKENS = 112386712924725508802400;
138 
139   event Mint(address indexed to, uint256 amount);
140   event MintFinished();
141   event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
142   event NewCloneToken(address indexed cloneToken);
143   event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
144   event Transfer(address indexed from, address indexed to, uint256 value);
145 
146 
147 
148 
149   function ProofToken(
150     address _tokenFactory,
151     address _parentToken,
152     uint256 _parentSnapShotBlock,
153     string _tokenName,
154     string _tokenSymbol
155     ) public {
156       tokenFactory = TokenFactoryInterface(_tokenFactory);
157       parentToken = ProofTokenInterface(_parentToken);
158       parentSnapShotBlock = _parentSnapShotBlock;
159       name = _tokenName;
160       symbol = _tokenSymbol;
161       decimals = 18;
162       transfersEnabled = false;
163       creationBlock = block.number;
164       version = '0.1';
165   }
166 
167   function() public payable {
168     revert();
169   }
170 
171 
172   /**
173   * Returns the total Proof token supply at the current block
174   * @return total supply {uint}
175   */
176   function totalSupply() public constant returns (uint) {
177     return totalSupplyAt(block.number);
178   }
179 
180   /**
181   * Returns the total Proof token supply at the given block number
182   * @param _blockNumber {uint}
183   * @return total supply {uint}
184   */
185   function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
186     // These next few lines are used when the totalSupply of the token is
187     //  requested before a check point was ever created for this token, it
188     //  requires that the `parentToken.totalSupplyAt` be queried at the
189     //  genesis block for this token as that contains totalSupply of this
190     //  token at this block number.
191     if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
192         if (address(parentToken) != 0) {
193             return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
194         } else {
195             return 0;
196         }
197 
198     // This will return the expected totalSupply during normal situations
199     } else {
200         return getValueAt(totalSupplyHistory, _blockNumber);
201     }
202   }
203 
204   /**
205   * Returns the token holder balance at the current block
206   * @param _owner {address}
207   * @return balance {uint}
208    */
209   function balanceOf(address _owner) public constant returns (uint256 balance) {
210     return balanceOfAt(_owner, block.number);
211   }
212 
213   /**
214   * Returns the token holder balance the the given block number
215   * @param _owner {address}
216   * @param _blockNumber {uint}
217   * @return balance {uint}
218   */
219   function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint) {
220     // These next few lines are used when the balance of the token is
221     //  requested before a check point was ever created for this token, it
222     //  requires that the `parentToken.balanceOfAt` be queried at the
223     //  genesis block for that token as this contains initial balance of
224     //  this token
225     if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
226         if (address(parentToken) != 0) {
227             return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
228         } else {
229             // Has no parent
230             return 0;
231         }
232 
233     // This will return the expected balance during normal situations
234     } else {
235         return getValueAt(balances[_owner], _blockNumber);
236     }
237   }
238 
239   /**
240   * Standard ERC20 transfer tokens
241   * @param _to {address}
242   * @param _amount {uint}
243   * @return success {bool}
244   */
245   function transfer(address _to, uint256 _amount) public returns (bool success) {
246     return doTransfer(msg.sender, _to, _amount);
247   }
248 
249   /**
250   * Standard ERC20 transferFrom interface
251   * @param _from {address}
252   * @param _to {address}
253   * @param _amount {uint256}
254   * @return success {bool}
255   */
256   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
257     require(allowed[_from][msg.sender] >= _amount);
258     allowed[_from][msg.sender] -= _amount;
259     return doTransfer(_from, _to, _amount);
260   }
261 
262   /**
263   * Standard ERC20 approve interface
264   * @param _spender {address}
265   * @param _amount {uint256}
266   * @return success {bool}
267   */
268   function approve(address _spender, uint256 _amount) public returns (bool success) {
269     require(transfersEnabled);
270 
271     // To change the approve amount you first have to reduce the addresses`
272     //  allowance to zero by calling `approve(_spender,0)` if it is not
273     //  already 0 to mitigate the race condition described here:
274     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
275     require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
276 
277     // Alerts the token controller of the approve function call
278     if (isContract(controller)) {
279         require(ControllerInterface(controller).onApprove(msg.sender, _spender, _amount));
280     }
281 
282     allowed[msg.sender][_spender] = _amount;
283     Approval(msg.sender, _spender, _amount);
284     return true;
285   }
286 
287   function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
288     approve(_spender, _amount);
289 
290     ApproveAndCallReceiver(_spender).receiveApproval(
291         msg.sender,
292         _amount,
293         this,
294         _extraData
295     );
296 
297     return true;
298   }
299 
300   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
301     return allowed[_owner][_spender];
302   }
303 
304 
305   function doTransfer(address _from, address _to, uint _amount) internal returns(bool) {
306     require(transfersEnabled);
307     require(_amount > 0);
308     require(parentSnapShotBlock < block.number);
309     require((_to != 0) && (_to != address(this)));
310 
311     // If the amount being transfered is more than the balance of the
312     //  account the transfer returns false
313     var previousBalanceFrom = balanceOfAt(_from, block.number);
314     require(previousBalanceFrom >= _amount);
315 
316     // Alerts the token controller of the transfer
317     if (isContract(controller)) {
318       require(ControllerInterface(controller).onTransfer(_from, _to, _amount));
319     }
320 
321     // First update the balance array with the new value for the address
322     //  sending the tokens
323     updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
324 
325     // Then update the balance array with the new value for the address
326     //  receiving the tokens
327     var previousBalanceTo = balanceOfAt(_to, block.number);
328     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
329     updateValueAtNow(balances[_to], previousBalanceTo + _amount);
330 
331     // An event to make the transfer easy to find on the blockchain
332     Transfer(_from, _to, _amount);
333     return true;
334   }
335 
336 
337   function mint(address _owner, uint _amount) public onlyController canMint returns (bool) {
338     uint curTotalSupply = totalSupply();
339     uint previousBalanceTo = balanceOf(_owner);
340 
341     require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
342     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
343 
344     updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
345     updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
346     Transfer(0, _owner, _amount);
347     return true;
348   }
349 
350   modifier canMint() {
351     require(!mintingFinished);
352     _;
353   }
354 
355 
356   /**
357    * Import presale balances before the start of the token sale. After importing
358    * balances, lockPresaleBalances() has to be called to prevent further modification
359    * of presale balances.
360    * @param _addresses {address[]} Array of presale addresses
361    * @param _balances {uint256[]} Array of balances corresponding to presale addresses.
362    * @return success {bool}
363    */
364   function importPresaleBalances(address[] _addresses, uint256[] _balances) public onlyController returns (bool) {
365     require(presaleBalancesLocked == false);
366 
367     for (uint256 i = 0; i < _addresses.length; i++) {
368       updateValueAtNow(balances[_addresses[i]], _balances[i]);
369       Transfer(0, _addresses[i], _balances[i]);
370     }
371 
372     updateValueAtNow(totalSupplyHistory, TOTAL_PRESALE_TOKENS);
373     return true;
374   }
375 
376   /**
377    * Lock presale balances after successful presale balance import
378    * @return A boolean that indicates if the operation was successful.
379    */
380   function lockPresaleBalances() public onlyController returns (bool) {
381     presaleBalancesLocked = true;
382     return true;
383   }
384 
385   /**
386    * Lock the minting of Proof Tokens - to be called after the presale
387    * @return {bool} success
388   */
389   function finishMinting() public onlyController returns (bool) {
390     mintingFinished = true;
391     MintFinished();
392     return true;
393   }
394 
395   /**
396    * Enable or block transfers - to be called in case of emergency
397   */
398   function enableTransfers(bool _transfersEnabled) public onlyController {
399       transfersEnabled = _transfersEnabled;
400   }
401 
402 
403   function getValueAt(Checkpoint[] storage checkpoints, uint _block) constant internal returns (uint) {
404 
405       if (checkpoints.length == 0)
406         return 0;
407       // Shortcut for the actual value
408       if (_block >= checkpoints[checkpoints.length-1].fromBlock)
409         return checkpoints[checkpoints.length-1].value;
410       if (_block < checkpoints[0].fromBlock)
411         return 0;
412 
413       // Binary search of the value in the array
414       uint min = 0;
415       uint max = checkpoints.length-1;
416       while (max > min) {
417           uint mid = (max + min + 1) / 2;
418           if (checkpoints[mid].fromBlock<=_block) {
419               min = mid;
420           } else {
421               max = mid-1;
422           }
423       }
424       return checkpoints[min].value;
425   }
426 
427   function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
428   ) internal
429   {
430       if ((checkpoints.length == 0) || (checkpoints[checkpoints.length-1].fromBlock < block.number)) {
431               Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
432               newCheckPoint.fromBlock = uint128(block.number);
433               newCheckPoint.value = uint128(_value);
434           } else {
435               Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
436               oldCheckPoint.value = uint128(_value);
437           }
438   }
439 
440   function isContract(address _addr) constant internal returns(bool) {
441       uint size;
442       if (_addr == 0)
443         return false;
444       assembly {
445           size := extcodesize(_addr)
446       }
447       return size>0;
448   }
449 
450   /// @dev Helper function to return a min betwen the two uints
451   function min(uint a, uint b) internal constant returns (uint) {
452       return a < b ? a : b;
453   }
454 
455   /**
456   * Clones Proof Token at the given snapshot block
457   * @param _snapshotBlock {uint}
458   * @param _cloneTokenName {string}
459   * @param _cloneTokenSymbol {string}
460    */
461   function createCloneToken(
462         uint _snapshotBlock,
463         string _cloneTokenName,
464         string _cloneTokenSymbol
465     ) public returns(address) {
466 
467       if (_snapshotBlock == 0) {
468         _snapshotBlock = block.number;
469       }
470 
471       if (_snapshotBlock > block.number) {
472         _snapshotBlock = block.number;
473       }
474 
475       ProofToken cloneToken = tokenFactory.createCloneToken(
476           this,
477           _snapshotBlock,
478           _cloneTokenName,
479           _cloneTokenSymbol
480         );
481 
482 
483       cloneToken.transferControl(msg.sender);
484 
485       // An event to make the token easy to find on the blockchain
486       NewCloneToken(address(cloneToken));
487       return address(cloneToken);
488     }
489 
490 }