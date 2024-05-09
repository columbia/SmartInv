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
13 contract Controllable {
14   address public controller;
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
19    */
20   function Controllable() public {
21     controller = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyController() {
28     require(msg.sender == controller);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newController The address to transfer ownership to.
35    */
36   function transferControl(address newController) public onlyController {
37     if (newController != address(0)) {
38       controller = newController;
39     }
40   }
41 
42 }
43 
44 contract ApproveAndCallReceiver {
45     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
46 }
47 
48 library SafeMath {
49   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
50     uint256 c = a * b;
51     assert(a == 0 || c / a == b);
52     return c;
53   }
54 
55   function div(uint256 a, uint256 b) internal constant returns (uint256) {
56     // assert(b > 0); // Solidity automatically throws when dividing by 0
57     uint256 c = a / b;
58     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59     return c;
60   }
61 
62   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
63     assert(b <= a);
64     return a - b;
65   }
66 
67   function add(uint256 a, uint256 b) internal constant returns (uint256) {
68     uint256 c = a + b;
69     assert(c >= a);
70     return c;
71   }
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
85   struct Checkpoint {
86     uint128 fromBlock;
87     uint128 value;
88   }
89 
90   uint256 public parentSnapShotBlock;
91   uint256 public creationBlock;
92   bool public transfersEnabled;
93   bool public masterTransfersEnabled;
94 
95   mapping(address => Checkpoint[]) balances;
96   mapping (address => mapping (address => uint)) allowed;
97 
98   Checkpoint[] totalSupplyHistory;
99 
100   bool public mintingFinished = false;
101   bool public presaleBalancesLocked = false;
102 
103   uint256 public constant TOTAL_PRESALE_TOKENS = 112386712924725508802400;
104   address public constant MASTER_WALLET = 0x740C588C5556e523981115e587892be0961853B8;
105 
106   event Mint(address indexed to, uint256 amount);
107   event MintFinished();
108   event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
109   event NewCloneToken(address indexed cloneToken);
110   event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
111   event Transfer(address indexed from, address indexed to, uint256 value);
112 
113 
114 
115 
116   function ProofToken(
117     address _tokenFactory,
118     address _parentToken,
119     uint256 _parentSnapShotBlock,
120     string _tokenName,
121     string _tokenSymbol
122     ) public {
123       tokenFactory = TokenFactoryInterface(_tokenFactory);
124       parentToken = ProofTokenInterface(_parentToken);
125       parentSnapShotBlock = _parentSnapShotBlock;
126       name = _tokenName;
127       symbol = _tokenSymbol;
128       decimals = 18;
129       transfersEnabled = false;
130       masterTransfersEnabled = false;
131       creationBlock = block.number;
132       version = '0.1';
133   }
134 
135   function() public payable {
136     revert();
137   }
138 
139 
140   /**
141   * Returns the total Proof token supply at the current block
142   * @return total supply {uint}
143   */
144   function totalSupply() public constant returns (uint) {
145     return totalSupplyAt(block.number);
146   }
147 
148   /**
149   * Returns the total Proof token supply at the given block number
150   * @param _blockNumber {uint}
151   * @return total supply {uint}
152   */
153   function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
154     // These next few lines are used when the totalSupply of the token is
155     //  requested before a check point was ever created for this token, it
156     //  requires that the `parentToken.totalSupplyAt` be queried at the
157     //  genesis block for this token as that contains totalSupply of this
158     //  token at this block number.
159     if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
160         if (address(parentToken) != 0) {
161             return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
162         } else {
163             return 0;
164         }
165 
166     // This will return the expected totalSupply during normal situations
167     } else {
168         return getValueAt(totalSupplyHistory, _blockNumber);
169     }
170   }
171 
172   /**
173   * Returns the token holder balance at the current block
174   * @param _owner {address}
175   * @return balance {uint}
176    */
177   function balanceOf(address _owner) public constant returns (uint256 balance) {
178     return balanceOfAt(_owner, block.number);
179   }
180 
181   /**
182   * Returns the token holder balance the the given block number
183   * @param _owner {address}
184   * @param _blockNumber {uint}
185   * @return balance {uint}
186   */
187   function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint) {
188     // These next few lines are used when the balance of the token is
189     //  requested before a check point was ever created for this token, it
190     //  requires that the `parentToken.balanceOfAt` be queried at the
191     //  genesis block for that token as this contains initial balance of
192     //  this token
193     if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
194         if (address(parentToken) != 0) {
195             return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
196         } else {
197             // Has no parent
198             return 0;
199         }
200 
201     // This will return the expected balance during normal situations
202     } else {
203         return getValueAt(balances[_owner], _blockNumber);
204     }
205   }
206 
207   /**
208   * Standard ERC20 transfer tokens
209   * @param _to {address}
210   * @param _amount {uint}
211   * @return success {bool}
212   */
213   function transfer(address _to, uint256 _amount) public returns (bool success) {
214     return doTransfer(msg.sender, _to, _amount);
215   }
216 
217   /**
218   * Standard ERC20 transferFrom interface
219   * @param _from {address}
220   * @param _to {address}
221   * @param _amount {uint256}
222   * @return success {bool}
223   */
224   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
225     require(allowed[_from][msg.sender] >= _amount);
226     allowed[_from][msg.sender] -= _amount;
227     return doTransfer(_from, _to, _amount);
228   }
229 
230   /**
231   * Standard ERC20 approve interface
232   * @param _spender {address}
233   * @param _amount {uint256}
234   * @return success {bool}
235   */
236   function approve(address _spender, uint256 _amount) public returns (bool success) {
237     require(transfersEnabled);
238 
239     // To change the approve amount you first have to reduce the addresses`
240     //  allowance to zero by calling `approve(_spender,0)` if it is not
241     //  already 0 to mitigate the race condition described here:
242     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
243     require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
244 
245     allowed[msg.sender][_spender] = _amount;
246     Approval(msg.sender, _spender, _amount);
247     return true;
248   }
249 
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
263   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
264     return allowed[_owner][_spender];
265   }
266 
267 
268   function doTransfer(address _from, address _to, uint _amount) internal returns(bool) {
269 
270     if (msg.sender != MASTER_WALLET) {
271       require(transfersEnabled);
272     } else {
273       require(masterTransfersEnabled);
274     }
275 
276     require(transfersEnabled);
277     require(_amount > 0);
278     require(parentSnapShotBlock < block.number);
279     require((_to != 0) && (_to != address(this)));
280 
281     // If the amount being transfered is more than the balance of the
282     //  account the transfer returns false
283     var previousBalanceFrom = balanceOfAt(_from, block.number);
284     require(previousBalanceFrom >= _amount);
285 
286     // First update the balance array with the new value for the address
287     //  sending the tokens
288     updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
289 
290     // Then update the balance array with the new value for the address
291     //  receiving the tokens
292     var previousBalanceTo = balanceOfAt(_to, block.number);
293     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
294     updateValueAtNow(balances[_to], previousBalanceTo + _amount);
295 
296     // An event to make the transfer easy to find on the blockchain
297     Transfer(_from, _to, _amount);
298     return true;
299   }
300 
301 
302   function mint(address _owner, uint _amount) public onlyController canMint returns (bool) {
303     uint curTotalSupply = totalSupply();
304     uint previousBalanceTo = balanceOf(_owner);
305 
306     require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
307     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
308 
309     updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
310     updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
311     Transfer(0, _owner, _amount);
312     return true;
313   }
314 
315   modifier canMint() {
316     require(!mintingFinished);
317     _;
318   }
319 
320 
321   /**
322    * Import presale balances before the start of the token sale. After importing
323    * balances, lockPresaleBalances() has to be called to prevent further modification
324    * of presale balances.
325    * @param _addresses {address[]} Array of presale addresses
326    * @param _balances {uint256[]} Array of balances corresponding to presale addresses.
327    * @return success {bool}
328    */
329   function importPresaleBalances(address[] _addresses, uint256[] _balances) public onlyController returns (bool) {
330     require(presaleBalancesLocked == false);
331 
332     for (uint256 i = 0; i < _addresses.length; i++) {
333       updateValueAtNow(balances[_addresses[i]], _balances[i]);
334       Transfer(0, _addresses[i], _balances[i]);
335     }
336 
337     updateValueAtNow(totalSupplyHistory, TOTAL_PRESALE_TOKENS);
338     return true;
339   }
340 
341   /**
342    * Lock presale balances after successful presale balance import
343    * @return A boolean that indicates if the operation was successful.
344    */
345   function lockPresaleBalances() public onlyController returns (bool) {
346     presaleBalancesLocked = true;
347     return true;
348   }
349 
350   /**
351    * Lock the minting of Proof Tokens - to be called after the presale
352    * @return {bool} success
353   */
354   function finishMinting() public onlyController returns (bool) {
355     mintingFinished = true;
356     MintFinished();
357     return true;
358   }
359 
360   /**
361    * Enable or block transfers - to be called in case of emergency
362   */
363   function enableTransfers(bool _value) public onlyController {
364     transfersEnabled = _value;
365   }
366 
367   function enableMasterTransfers(bool _value) public onlyController {
368     masterTransfersEnabled = _value;
369   }
370 
371 
372   function getValueAt(Checkpoint[] storage checkpoints, uint _block) constant internal returns (uint) {
373 
374       if (checkpoints.length == 0)
375         return 0;
376       // Shortcut for the actual value
377       if (_block >= checkpoints[checkpoints.length-1].fromBlock)
378         return checkpoints[checkpoints.length-1].value;
379       if (_block < checkpoints[0].fromBlock)
380         return 0;
381 
382       // Binary search of the value in the array
383       uint min = 0;
384       uint max = checkpoints.length-1;
385       while (max > min) {
386           uint mid = (max + min + 1) / 2;
387           if (checkpoints[mid].fromBlock<=_block) {
388               min = mid;
389           } else {
390               max = mid-1;
391           }
392       }
393       return checkpoints[min].value;
394   }
395 
396   function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
397   ) internal
398   {
399       if ((checkpoints.length == 0) || (checkpoints[checkpoints.length-1].fromBlock < block.number)) {
400               Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
401               newCheckPoint.fromBlock = uint128(block.number);
402               newCheckPoint.value = uint128(_value);
403           } else {
404               Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
405               oldCheckPoint.value = uint128(_value);
406           }
407   }
408 
409   /// @dev Helper function to return a min betwen the two uints
410   function min(uint a, uint b) internal constant returns (uint) {
411       return a < b ? a : b;
412   }
413 
414   /**
415   * Clones Proof Token at the given snapshot block
416   * @param _snapshotBlock {uint}
417   * @param _cloneTokenName {string}
418   * @param _cloneTokenSymbol {string}
419    */
420   function createCloneToken(
421         uint _snapshotBlock,
422         string _cloneTokenName,
423         string _cloneTokenSymbol
424     ) public returns(address) {
425 
426       if (_snapshotBlock == 0) {
427         _snapshotBlock = block.number;
428       }
429 
430       if (_snapshotBlock > block.number) {
431         _snapshotBlock = block.number;
432       }
433 
434       ProofToken cloneToken = tokenFactory.createCloneToken(
435           this,
436           _snapshotBlock,
437           _cloneTokenName,
438           _cloneTokenSymbol
439         );
440 
441 
442       cloneToken.transferControl(msg.sender);
443 
444       // An event to make the token easy to find on the blockchain
445       NewCloneToken(address(cloneToken));
446       return address(cloneToken);
447     }
448 
449 }
450 
451 contract ControllerInterface {
452 
453     function proxyPayment(address _owner) public payable returns(bool);
454     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
455     function onApprove(address _owner, address _spender, uint _amount) public returns(bool);
456 }
457 
458 contract ProofTokenInterface is Controllable {
459 
460   event Mint(address indexed to, uint256 amount);
461   event MintFinished();
462   event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
463   event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
464   event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
465   event Transfer(address indexed from, address indexed to, uint256 value);
466 
467   function totalSupply() public constant returns (uint);
468   function totalSupplyAt(uint _blockNumber) public constant returns(uint);
469   function balanceOf(address _owner) public constant returns (uint256 balance);
470   function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint);
471   function transfer(address _to, uint256 _amount) public returns (bool success);
472   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
473   function approve(address _spender, uint256 _amount) public returns (bool success);
474   function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success);
475   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
476   function mint(address _owner, uint _amount) public returns (bool);
477   function importPresaleBalances(address[] _addresses, uint256[] _balances, address _presaleAddress) public returns (bool);
478   function lockPresaleBalances() public returns (bool);
479   function finishMinting() public returns (bool);
480   function enableTransfers(bool _value) public;
481   function enableMasterTransfers(bool _value) public;
482   function createCloneToken(uint _snapshotBlock, string _cloneTokenName, string _cloneTokenSymbol) public returns (address);
483 
484 }