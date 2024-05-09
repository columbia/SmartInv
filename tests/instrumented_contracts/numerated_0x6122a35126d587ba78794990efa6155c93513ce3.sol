1 pragma solidity ^0.4.24;
2 
3 // File: contracts/FiatTokenV1.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract from https://github.com/zeppelinos/labs/blob/master/upgradeability_ownership/contracts/ownership/Ownable.sol
8  * branch: master commit: 3887ab77b8adafba4a26ace002f3a684c1a3388b modified to:
9  * 1) Add emit prefix to OwnershipTransferred event (7/13/18)
10  * 2) Replace constructor with constructor syntax (7/13/18)
11  * 3) consolidate OwnableStorage into this contract
12  */
13 contract Ownable {
14 
15   // Owner of the contract
16   address private _owner;
17 
18   /**
19   * @dev Event to show ownership has been transferred
20   * @param previousOwner representing the address of the previous owner
21   * @param newOwner representing the address of the new owner
22   */
23   event OwnershipTransferred(address previousOwner, address newOwner);
24 
25   /**
26   * @dev The constructor sets the original owner of the contract to the sender account.
27   */
28   constructor() public {
29     setOwner(msg.sender);
30   }
31 
32   /**
33  * @dev Tells the address of the owner
34  * @return the address of the owner
35  */
36   function owner() public view returns (address) {
37     return _owner;
38   }
39 
40   /**
41    * @dev Sets a new owner address
42    */
43   function setOwner(address newOwner) internal {
44     _owner = newOwner;
45   }
46 
47   /**
48   * @dev Throws if called by any account other than the owner.
49   */
50   modifier onlyOwner() {
51     require(msg.sender == owner());
52     _;
53   }
54 
55   /**
56    * @dev Allows the current owner to transfer control of the contract to a newOwner.
57    * @param newOwner The address to transfer ownership to.
58    */
59   function transferOwnership(address newOwner) public onlyOwner {
60     require(newOwner != address(0));
61     emit OwnershipTransferred(owner(), newOwner);
62     setOwner(newOwner);
63   }
64 }
65 
66 // File: contracts/Blacklistable.sol
67 
68 /**
69  * @title Blacklistable Token
70  * @dev Allows accounts to be blacklisted by a "blacklister" role
71 */
72 contract Blacklistable is Ownable {
73 
74   address public blacklister;
75   mapping(address => bool) internal blacklisted;
76 
77   event Blacklisted(address indexed _account);
78   event UnBlacklisted(address indexed _account);
79   event BlacklisterChanged(address indexed newBlacklister);
80 
81   /**
82    * @dev Throws if called by any account other than the blacklister
83   */
84   modifier onlyBlacklister() {
85     require(msg.sender == blacklister);
86     _;
87   }
88 
89   /**
90    * @dev Throws if argument account is blacklisted
91    * @param _account The address to check
92   */
93   modifier notBlacklisted(address _account) {
94     require(blacklisted[_account] == false);
95     _;
96   }
97 
98   /**
99    * @dev Checks if account is blacklisted
100    * @param _account The address to check
101   */
102   function isBlacklisted(address _account) public view returns (bool) {
103     return blacklisted[_account];
104   }
105 
106   /**
107    * @dev Adds account to blacklist
108    * @param _account The address to blacklist
109   */
110   function blacklist(address _account) public onlyBlacklister {
111     blacklisted[_account] = true;
112     emit Blacklisted(_account);
113   }
114 
115   /**
116    * @dev Removes account from blacklist
117    * @param _account The address to remove from the blacklist
118   */
119   function unBlacklist(address _account) public onlyBlacklister {
120     blacklisted[_account] = false;
121     emit UnBlacklisted(_account);
122   }
123 
124   function updateBlacklister(address _newBlacklister) public onlyOwner {
125     require(_newBlacklister != address(0));
126     blacklister = _newBlacklister;
127     emit BlacklisterChanged(blacklister);
128   }
129 }
130 
131 // File: contracts/Pausable.sol
132 
133 /**
134  * @title Pausable
135  * @dev Base contract which allows children to implement an emergency stop mechanism.
136  * Based on openzeppelin tag v1.10.0 commit: feb665136c0dae9912e08397c1a21c4af3651ef3
137  * Modifications:
138  * 1) Added pauser role, switched pause/unpause to be onlyPauser (6/14/2018)
139  * 2) Removed whenNotPause/whenPaused from pause/unpause (6/14/2018)
140  * 3) Removed whenPaused (6/14/2018)
141  * 4) Switches ownable library to use zeppelinos (7/12/18)
142  * 5) Remove constructor (7/13/18)
143  */
144 contract Pausable is Ownable {
145   event Pause();
146   event Unpause();
147   event PauserChanged(address indexed newAddress);
148 
149   address public pauser;
150   bool public paused = false;
151 
152   /**
153    * @dev Modifier to make a function callable only when the contract is not paused.
154    */
155   modifier whenNotPaused() {
156     require(!paused);
157     _;
158   }
159 
160   /**
161    * @dev throws if called by any account other than the pauser
162    */
163   modifier onlyPauser() {
164     require(msg.sender == pauser);
165     _;
166   }
167 
168   /**
169    * @dev called by the owner to pause, triggers stopped state
170    */
171   function pause() onlyPauser public {
172     paused = true;
173     emit Pause();
174   }
175 
176   /**
177    * @dev called by the owner to unpause, returns to normal state
178    */
179   function unpause() onlyPauser public {
180     paused = false;
181     emit Unpause();
182   }
183 
184   /**
185    * @dev update the pauser role
186    */
187   function updatePauser(address _newPauser) onlyOwner public {
188     require(_newPauser != address(0));
189     pauser = _newPauser;
190     emit PauserChanged(pauser);
191   }
192 
193 }
194 
195 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
196 
197 /**
198  * @title SafeMath
199  * @dev Math operations with safety checks that throw on error
200  */
201 library SafeMath {
202 
203   /**
204   * @dev Multiplies two numbers, throws on overflow.
205   */
206   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
207     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
208     // benefit is lost if 'b' is also tested.
209     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
210     if (a == 0) {
211       return 0;
212     }
213 
214     c = a * b;
215     assert(c / a == b);
216     return c;
217   }
218 
219   /**
220   * @dev Integer division of two numbers, truncating the quotient.
221   */
222   function div(uint256 a, uint256 b) internal pure returns (uint256) {
223     // assert(b > 0); // Solidity automatically throws when dividing by 0
224     // uint256 c = a / b;
225     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
226     return a / b;
227   }
228 
229   /**
230   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
231   */
232   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
233     assert(b <= a);
234     return a - b;
235   }
236 
237   /**
238   * @dev Adds two numbers, throws on overflow.
239   */
240   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
241     c = a + b;
242     assert(c >= a);
243     return c;
244   }
245 }
246 
247 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
248 
249 /**
250  * @title ERC20Basic
251  * @dev Simpler version of ERC20 interface
252  * See https://github.com/ethereum/EIPs/issues/179
253  */
254 contract ERC20Basic {
255   function totalSupply() public view returns (uint256);
256   function balanceOf(address who) public view returns (uint256);
257   function transfer(address to, uint256 value) public returns (bool);
258   event Transfer(address indexed from, address indexed to, uint256 value);
259 }
260 
261 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
262 
263 /**
264  * @title ERC20 interface
265  * @dev see https://github.com/ethereum/EIPs/issues/20
266  */
267 contract ERC20 is ERC20Basic {
268   function allowance(address owner, address spender)
269   public view returns (uint256);
270 
271   function transferFrom(address from, address to, uint256 value)
272   public returns (bool);
273 
274   function approve(address spender, uint256 value) public returns (bool);
275   event Approval(
276     address indexed owner,
277     address indexed spender,
278     uint256 value
279   );
280 }
281 
282 // File: contracts/FiatToken.sol
283 
284 /**
285  * @title FiatToken
286  * @dev ERC20 Token backed by fiat reserves
287  */
288 contract FiatTokenV1 is Ownable, ERC20, Pausable, Blacklistable {
289   using SafeMath for uint256;
290 
291   string public name;
292   string public symbol;
293   uint8 public decimals;
294   string public currency;
295   address public masterMinter;
296   bool internal initialized;
297 
298   mapping(address => uint256) internal balances;
299   mapping(address => mapping(address => uint256)) internal allowed;
300   uint256 internal totalSupply_;
301   mapping(address => bool) internal minters;
302   mapping(address => uint256) internal minterAllowed;
303 
304   event Mint(address indexed minter, address indexed to, uint256 amount);
305   event Burn(address indexed burner, uint256 amount);
306   event MinterConfigured(address indexed minter, uint256 minterAllowedAmount);
307   event MinterRemoved(address indexed oldMinter);
308   event MasterMinterChanged(address indexed newMasterMinter);
309 
310   function initialize(
311     string _name,
312     string _symbol,
313     string _currency,
314     uint8 _decimals,
315     address _masterMinter,
316     address _pauser,
317     address _blacklister,
318     address _owner
319   ) public {
320     require(!initialized);
321     require(_masterMinter != address(0));
322     require(_pauser != address(0));
323     require(_blacklister != address(0));
324     require(_owner != address(0));
325 
326     name = _name;
327     symbol = _symbol;
328     currency = _currency;
329     decimals = _decimals;
330     masterMinter = _masterMinter;
331     pauser = _pauser;
332     blacklister = _blacklister;
333     setOwner(_owner);
334     initialized = true;
335   }
336 
337   /**
338    * @dev Throws if called by any account other than a minter
339   */
340   modifier onlyMinters() {
341     require(minters[msg.sender] == true);
342     _;
343   }
344 
345   /**
346    * @dev Function to mint tokens
347    * @param _to The address that will receive the minted tokens.
348    * @param _amount The amount of tokens to mint. Must be less than or equal to the minterAllowance of the caller.
349    * @return A boolean that indicates if the operation was successful.
350   */
351   function mint(address _to, uint256 _amount) whenNotPaused onlyMinters notBlacklisted(msg.sender) notBlacklisted(_to) public returns (bool) {
352     require(_to != address(0));
353     require(_amount > 0);
354 
355     uint256 mintingAllowedAmount = minterAllowed[msg.sender];
356     require(_amount <= mintingAllowedAmount);
357 
358     totalSupply_ = totalSupply_.add(_amount);
359     balances[_to] = balances[_to].add(_amount);
360     minterAllowed[msg.sender] = mintingAllowedAmount.sub(_amount);
361     emit Mint(msg.sender, _to, _amount);
362     emit Transfer(0x0, _to, _amount);
363     return true;
364   }
365 
366   /**
367    * @dev Throws if called by any account other than the masterMinter
368   */
369   modifier onlyMasterMinter() {
370     require(msg.sender == masterMinter);
371     _;
372   }
373 
374   /**
375    * @dev Get minter allowance for an account
376    * @param minter The address of the minter
377   */
378   function minterAllowance(address minter) public view returns (uint256) {
379     return minterAllowed[minter];
380   }
381 
382   /**
383    * @dev Checks if account is a minter
384    * @param account The address to check
385   */
386   function isMinter(address account) public view returns (bool) {
387     return minters[account];
388   }
389 
390   /**
391    * @dev Get allowed amount for an account
392    * @param owner address The account owner
393    * @param spender address The account spender
394   */
395   function allowance(address owner, address spender) public view returns (uint256) {
396     return allowed[owner][spender];
397   }
398 
399   /**
400    * @dev Get totalSupply of token
401   */
402   function totalSupply() public view returns (uint256) {
403     return totalSupply_;
404   }
405 
406   /**
407    * @dev Get token balance of an account
408    * @param account address The account
409   */
410   function balanceOf(address account) public view returns (uint256) {
411     return balances[account];
412   }
413 
414   /**
415    * @dev Adds blacklisted check to approve
416    * @return True if the operation was successful.
417   */
418   function approve(address _spender, uint256 _value) whenNotPaused notBlacklisted(msg.sender) notBlacklisted(_spender) public returns (bool) {
419     allowed[msg.sender][_spender] = _value;
420     emit Approval(msg.sender, _spender, _value);
421     return true;
422   }
423 
424   /**
425    * @dev Transfer tokens from one address to another.
426    * @param _from address The address which you want to send tokens from
427    * @param _to address The address which you want to transfer to
428    * @param _value uint256 the amount of tokens to be transferred
429    * @return bool success
430   */
431   function transferFrom(address _from, address _to, uint256 _value) whenNotPaused notBlacklisted(_to) notBlacklisted(msg.sender) notBlacklisted(_from) public returns (bool) {
432     require(_to != address(0));
433     require(_value <= balances[_from]);
434     require(_value <= allowed[_from][msg.sender]);
435 
436     balances[_from] = balances[_from].sub(_value);
437     balances[_to] = balances[_to].add(_value);
438     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
439     emit Transfer(_from, _to, _value);
440     return true;
441   }
442 
443   /**
444    * @dev transfer token for a specified address
445    * @param _to The address to transfer to.
446    * @param _value The amount to be transferred.
447    * @return bool success
448   */
449   function transfer(address _to, uint256 _value) whenNotPaused notBlacklisted(msg.sender) notBlacklisted(_to) public returns (bool) {
450     require(_to != address(0));
451     require(_value <= balances[msg.sender]);
452 
453     balances[msg.sender] = balances[msg.sender].sub(_value);
454     balances[_to] = balances[_to].add(_value);
455     emit Transfer(msg.sender, _to, _value);
456     return true;
457   }
458 
459   /**
460    * @dev Function to add/update a new minter
461    * @param minter The address of the minter
462    * @param minterAllowedAmount The minting amount allowed for the minter
463    * @return True if the operation was successful.
464   */
465   function configureMinter(address minter, uint256 minterAllowedAmount) whenNotPaused onlyMasterMinter public returns (bool) {
466     minters[minter] = true;
467     minterAllowed[minter] = minterAllowedAmount;
468     emit MinterConfigured(minter, minterAllowedAmount);
469     return true;
470   }
471 
472   /**
473    * @dev Function to remove a minter
474    * @param minter The address of the minter to remove
475    * @return True if the operation was successful.
476   */
477   function removeMinter(address minter) onlyMasterMinter public returns (bool) {
478     minters[minter] = false;
479     minterAllowed[minter] = 0;
480     emit MinterRemoved(minter);
481     return true;
482   }
483 
484   /**
485    * @dev allows a minter to burn some of its own tokens
486    * Validates that caller is a minter and that sender is not blacklisted
487    * amount is less than or equal to the minter's account balance
488    * @param _amount uint256 the amount of tokens to be burned
489   */
490   function burn(uint256 _amount) whenNotPaused onlyMinters notBlacklisted(msg.sender) public {
491     uint256 balance = balances[msg.sender];
492     require(_amount > 0);
493     require(balance >= _amount);
494 
495     totalSupply_ = totalSupply_.sub(_amount);
496     balances[msg.sender] = balance.sub(_amount);
497     emit Burn(msg.sender, _amount);
498     emit Transfer(msg.sender, address(0), _amount);
499   }
500 
501   function updateMasterMinter(address _newMasterMinter) onlyOwner public {
502     require(_newMasterMinter != address(0));
503     masterMinter = _newMasterMinter;
504     emit MasterMinterChanged(masterMinter);
505   }
506 }