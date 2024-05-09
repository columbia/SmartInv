1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title SafeMath
35  * @dev Math operations with safety checks that throw on error
36  */
37 library Utils {
38 
39     /**
40     @dev Helper function, determines if a given address is an account or a contract.
41     @return True if address is a contract, false otherwise
42      */
43     function isContract(address _addr) constant internal returns (bool) {
44         uint size;
45 
46         assembly {
47             size := extcodesize(_addr)
48         }
49 
50         return (_addr == 0) ? false : size > 0;
51     }
52 }
53 
54 /**
55  * @title Ownable
56  * @dev The Ownable contract has an owner address, and provides basic authorization control
57  * functions, this simplifies the implementation of "user permissions".
58  */
59 contract Ownable {
60   address public owner;
61 
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64   /**
65    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
66    * account.
67    */
68   function Ownable() {
69     owner = msg.sender;
70   }
71 
72   /**
73    * @dev Throws if called by any account other than the owner.
74    */
75   modifier onlyOwner() {
76     require(msg.sender == owner);
77     _;
78   }
79 
80   /**
81    * @dev Allows the current owner to transfer control of the contract to a newOwner.
82    * @param newOwner The address to transfer ownership to.
83    */
84   function transferOwnership(address newOwner) onlyOwner {
85     require(newOwner != address(0));
86     OwnershipTransferred(owner, newOwner);
87     owner = newOwner;
88   }
89 
90 }
91 
92 /**
93  * @title Claimable
94  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
95  * This allows the new owner to accept the transfer.
96  */
97 contract Claimable is Ownable {
98   address public pendingOwner;
99 
100   /**
101    * @dev Modifier throws if called by any account other than the pendingOwner.
102    */
103   modifier onlyPendingOwner() {
104     require(msg.sender == pendingOwner);
105     _;
106   }
107 
108   /**
109    * @dev Allows the current owner to set the pendingOwner address.
110    * @param newOwner The address to transfer ownership to.
111    */
112   function transferOwnership(address newOwner) onlyOwner {
113     pendingOwner = newOwner;
114   }
115 
116   /**
117    * @dev Allows the pendingOwner address to finalize the transfer.
118    */
119   function claimOwnership() onlyPendingOwner {
120     OwnershipTransferred(owner, pendingOwner);
121     owner = pendingOwner;
122     pendingOwner = 0x0;
123   }
124 }
125 
126 /**
127 @title Burnable
128 @dev Burnable custom interface, should allow external contracts to burn tokens on certain conditions.
129  */
130 contract Burnable {
131 
132     event Burn(address who, uint256 amount);
133 
134     modifier onlyBurners {
135         require(isBurner(msg.sender));
136         _;
137     }
138     function burn(address target, uint256 amount) external onlyBurners returns (bool);
139     function setBurner(address who, bool auth) returns (bool);
140     function isBurner(address who) constant returns (bool);
141 }
142 
143 /**
144 @title Lockable
145 @dev Lockable custom interface, should allow external contracts to lock accounts on certain conditions.
146  */
147 contract Lockable {
148 
149     uint256 public lockExpiration;
150 
151     /**
152     @dev Constructor
153     @param _lockExpiration lock expiration datetime in UNIX time
154      */
155     function Lockable(uint256 _lockExpiration) {
156         lockExpiration = _lockExpiration;
157     }
158 
159     function isLocked(address who) constant returns (bool);
160 }
161 
162 /**
163 @title ERC20 interface
164 @dev Standard ERC20 Interface.
165 */
166 contract ERC20 {
167   uint256 public totalSupply;
168   function balanceOf(address who) constant returns (uint256);
169   function transfer(address to, uint256 value) returns (bool);
170   event Transfer(address indexed from, address indexed to, uint256 value);
171   function allowance(address owner, address spender) constant returns (uint256);
172   function transferFrom(address from, address to, uint256 value) returns (bool);
173   function approve(address spender, uint256 value) returns (bool);
174   event Approval(address indexed owner, address indexed spender, uint256 value);
175 }
176 
177 /**
178 @title LWFToken
179 @dev ERC20 standard.
180 @dev Extra features: Burnable and Lockable under certain conditions.
181 @dev contract owner is set to msg.sender, lockExpiration for devs set to: 1535760000 || Saturday, 01-Sep-18 00:00:00 UTC
182  */
183 contract LWFToken is ERC20, Burnable, Lockable(1535760000), Claimable {
184 using SafeMath for uint256;
185 
186     // Snapshot of Account balance at specific block
187     struct Snapshot {
188         uint256 block;
189         uint256 balance;
190     }
191 
192     struct Account {
193         uint256 balance;
194         Snapshot[] history; // history of snapshots
195         mapping(address => uint256) allowed;
196         bool isSet;
197     }
198 
199     address[] accountsList;
200 
201     mapping(address => Account) accounts;
202 
203     bool public maintenance;
204 
205     // BURN SETTINGS
206     mapping(address => bool) burners; // contracts authorized to block tokens
207     bool public burnAllowed;
208 
209     // LOCK SETTINGS
210     mapping(address => bool) locked; //locked users addresses
211 
212     // COSMETIC THINGS
213     string public name = "LWF";
214     string public symbol = "LWF";
215     string public version = "release-1.1";
216 
217     uint256 public decimals = 2;
218 
219     /**
220     @dev Throws if token is under maintenance.
221      */
222     modifier disabledInMaintenance() {
223         if (maintenance)
224             revert();
225         _;
226     }
227 
228     /**
229     @dev Throws if token is not under maintenance.
230      */
231     modifier onlyUnderMaintenance() {
232         if (!maintenance)
233             revert();
234         _;
235     }
236 
237     /**
238     @dev Registers the recipient account when tokens are sent to an unregistered account.
239     @param _recipient the recipient of the transfer
240      */
241     modifier trackNewUsers (address _recipient) {
242         if (!accounts[_recipient].isSet) {
243             accounts[_recipient].isSet = true;
244             accountsList.push(_recipient);
245         }
246         _;
247     }
248 
249     /**
250     @dev The constructor sets the initial balance to 30 million tokens.
251     @dev 27 million assigned to the contract owner.
252     @dev 3 million reserved and locked. (except bounty)
253     @dev Holders history is updated for data integrity.
254     @dev Burn functionality are enabled by default.
255      */
256     function LWFToken() {
257         totalSupply = 30 * (10**6) * (10**decimals);
258 
259         burnAllowed = true;
260         maintenance = false;
261 
262         require(_setup(0x927Dc9F1520CA2237638D0D3c6910c14D9a285A8, 2700000000, false));
263 
264         require(_setup(0x7AE7155fF280D5da523CDDe3855b212A8381F9E8, 30000000, false));
265         require(_setup(0x796d507A80B13c455c2C1D121eDE4bccca59224C, 263000000, true));
266 
267         require(_setup(0xD77d620EC9774295ad8263cBc549789EE39C0BC0, 1000000, true));
268         require(_setup(0x574B35eC5650BE0aC217af9AFCfe1c7a3Ff0BecD, 1000000, true));
269         require(_setup(0x7c5a61f34513965AA8EC090011721a0b0A9d4D3a, 1000000, true));
270         require(_setup(0x0cDBb03DD2E8226A6c3a54081E93750B4f85DB92, 1000000, true));
271         require(_setup(0x03b6cF4A69fF306B3df9B9CeDB6Dc4ED8803cBA7, 1000000, true));
272         require(_setup(0xe2f7A1218E5d4a362D1bee8d2eda2cd285aAE87A, 1000000, true));
273         require(_setup(0xAcceDE2eFD2765520952B7Cb70406A43FC17e4fb, 1000000, true));
274     }
275 
276     /**
277     @return accountsList length
278      */
279     function accountsListLength() external constant returns (uint256) {
280         return accountsList.length;
281     }
282 
283     /**
284     @dev Gets the address of any account in 'accountList'.
285     @param _index The index to query the address of
286     @return An address pointing to a registered account
287     */
288     function getAccountAddress(uint256 _index) external constant returns (address) {
289         return accountsList[_index];
290     }
291 
292     /**
293     @dev Checks if an accounts is registered.
294     @param _address The address to check
295     @return A bool set true if the account is registered, false otherwise
296      */
297     function isSet(address _address) external constant returns (bool) {
298         return accounts[_address].isSet;
299     }
300 
301     /**
302     @dev Gets the balance of the specified address at the first block minor or equal the specified block
303     @param _owner The address to query the the balance of
304     @param _block The block
305     @return An uint256 representing the amount owned by the passed address at the specified block.
306     */
307     function balanceAt(address _owner, uint256 _block) external constant returns (uint256 balance) {
308         uint256 i = accounts[_owner].history.length;
309         do {
310             i--;
311         } while (i > 0 && accounts[_owner].history[i].block > _block);
312         uint256 matchingBlock = accounts[_owner].history[i].block;
313         uint256 matchingBalance = accounts[_owner].history[i].balance;
314         return (i == 0 && matchingBlock > _block) ? 0 : matchingBalance;
315     }
316 
317     /**
318     @dev Authorized contracts can burn tokens.
319     @param _amount Quantity of tokens to burn
320     @return A bool set true if successful, false otherwise
321      */
322     function burn(address _address, uint256 _amount) onlyBurners disabledInMaintenance external returns (bool) {
323         require(burnAllowed);
324 
325         var _balance = accounts[_address].balance;
326         accounts[_address].balance = _balance.sub(_amount);
327 
328         // update history with recent burn
329         require(_updateHistory(_address));
330 
331         totalSupply = totalSupply.sub(_amount);
332         Burn(_address,_amount);
333         Transfer(_address, 0x0, _amount);
334         return true;
335     }
336 
337     /**
338     @dev Send a specified amount of tokens from sender address to '_recipient'.
339     @param _recipient address receiving tokens
340     @param _amount the amount of tokens to be transferred
341     @return A bool set true if successful, false otherwise
342      */
343     function transfer(address _recipient, uint256 _amount) returns (bool) {
344         require(!isLocked(msg.sender));
345         return _transfer(msg.sender,_recipient,_amount);
346     }
347 
348     /**
349     @dev Transfer tokens from one address to another
350     @param _from address The address which you want to send tokens from
351     @param _to address The address which you want to transfer to
352     @param _amount the amount of tokens to be transferred
353     @return A bool set true if successful, false otherwise
354     */
355     function transferFrom(address _from, address _to, uint256 _amount) returns (bool) {
356         require(!isLocked(_from));
357         require(_to != address(0));
358 
359         var _allowance = accounts[_from].allowed[msg.sender];
360 
361         // Check is not needed because sub(_allowance, _amount) will already throw if this condition is not met
362         // require (_amount <= _allowance);
363         accounts[_from].allowed[msg.sender] = _allowance.sub(_amount);
364         return _transfer(_from, _to, _amount);
365     }
366 
367     /**
368     @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
369     @param _spender The address which will spend the funds.
370     @param _value The amount of tokens to be spent.
371     */
372     function approve(address _spender, uint256 _value) returns (bool) {
373         //  To change the approve amount you first have to reduce the addresses`
374         //  allowance to zero by calling `approve(_spender, 0)` if it is not
375         //  already 0 to mitigate the race condition
376         require((_value == 0) || (accounts[msg.sender].allowed[_spender] == 0));
377 
378         accounts[msg.sender].allowed[_spender] = _value;
379         Approval(msg.sender, _spender, _value);
380         return true;
381     }
382 
383     /**
384     @dev Approve should be called when allowed[_spender] == 0. To increment
385          allowed value is better to use this function to avoid 2 calls (and wait until
386          the first transaction is mined)
387     @param _spender The address which will spend the funds
388     @param _addedValue The value which will be added from the allowed balance
389     */
390     function increaseApproval(address _spender, uint _addedValue) returns (bool success) {
391         uint256 _allowance = accounts[msg.sender].allowed[_spender];
392         accounts[msg.sender].allowed[_spender] = _allowance.add(_addedValue);
393         Approval(msg.sender, _spender, accounts[msg.sender].allowed[_spender]);
394         return true;
395     }
396 
397     /**
398     @dev Approve should be called when allowed[_spender] == 0. To decrement
399          allowed value is better to use this function to avoid 2 calls (and wait until
400          the first transaction is mined)
401     @param _spender The address which will spend the funds
402     @param _subtractedValue The value which will be subtracted from the allowed balance
403     @return A bool set true if successful, false otherwise
404     */
405     function decreaseApproval (address _spender, uint _subtractedValue) returns (bool success) {
406         uint oldValue = accounts[msg.sender].allowed[_spender];
407         accounts[msg.sender].allowed[_spender] = (_subtractedValue > oldValue) ? 0 : oldValue.sub(_subtractedValue);
408         Approval(msg.sender, _spender, accounts[msg.sender].allowed[_spender]);
409         return true;
410     }
411 
412     /**
413     @dev Sets a contract authorization to burn tokens.
414     @param _address The address to authorize/deauthorize
415     @param _auth True for authorization, false otherwise
416     @return A bool set true if successful, false otherwise
417      */
418     function setBurner(address _address, bool _auth) onlyOwner returns (bool) {
419         require(burnAllowed);
420         assert(Utils.isContract(_address));
421         burners[_address] = _auth;
422         return true;
423     }
424 
425     /**
426     @dev Checks if the provided contract can burn tokens.
427     @param _address The address to check
428     @return A bool set true if authorized, false otherwise
429      */
430     function isBurner(address _address) constant returns (bool) {
431         return burnAllowed ? burners[_address] : false;
432     }
433 
434     /**
435     @dev Checks if the token owned by the provided address are locked.
436     @param _address The address to check
437     @return A bool set true if locked, false otherwise
438      */
439     function isLocked(address _address) constant returns (bool) {
440         return now >= lockExpiration ? false : locked[_address];
441     }
442 
443     /**
444     @dev Function permanently disabling 'burn()' and 'setBurner()'.
445     @dev Already burned tokens are not recoverable.
446     @dev Effects of this transaction are irreversible.
447     @return A bool set true if successful, false otherwise
448      */
449     function burnFeatureDeactivation() onlyOwner returns (bool) {
450         require(burnAllowed);
451         burnAllowed = false;
452         return true;
453     }
454 
455     /**
456     @dev Gets the balance of the specified address.
457     @param _owner The address to query the the balance of.
458     @return An uint256 representing the amount owned by the passed address.
459     */
460     function balanceOf(address _owner) constant returns (uint256 balance) {
461         return accounts[_owner].balance;
462     }
463 
464     /**
465     @dev Function to check the amount of tokens that an owner allowed to a spender.
466     @param _owner address The address which owns the funds.
467     @param _spender address The address which will spend the funds.
468     @return A uint256 specifying the amount of tokens still available for the spender.
469     */
470     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
471         return accounts[_owner].allowed[_spender];
472     }
473 
474     /**
475     @dev Sets the maintenance mode. During maintenance operations modifying balances are frozen.
476     @param _state true if maintenance is on, false otherwise
477     @return A bool set true if successful, false otherwise
478      */
479     function setMaintenance(bool _state) onlyOwner returns (bool) {
480         maintenance = _state;
481         return true;
482     }
483 
484     /**
485     @dev Maintenance function, if accountsList grows too long back end can safely clean unused accounts
486         and push the renewed list into the contract.
487     @dev Accounts removed from the list must be deactivated with maintenanceDeactivateUser(_user)
488     @param _accountsList A list containing the accounts' addresses
489     @return A bool set true if successful, false otherwise
490      */
491     function maintenanceSetAccountsList(address[] _accountsList) onlyOwner onlyUnderMaintenance returns (bool) {
492         accountsList = _accountsList;
493         return true;
494     }
495 
496     /**
497     @dev Maintenance function reserved to back end, removes an account from the list.
498     @return A bool set true if successful, false otherwise
499      */
500     function maintenanceDeactivateUser(address _user) onlyOwner onlyUnderMaintenance returns (bool) {
501         accounts[_user].isSet = false;
502         delete accounts[_user].history;
503         return true;
504     }
505 
506     /**
507     @dev Auxiliary method used in constructor to reserve some tokens and lock them in some cases.
508     @param _address The address to assign tokens
509     @param _amount The amount of tokens
510     @param _lock True to lock until 'lockExpiration', false to not
511     @return A bool set true if successful, false otherwise
512      */
513     function _setup(address _address, uint256 _amount, bool _lock) internal returns (bool) {
514         locked[_address] = _lock;
515         accounts[_address].balance = _amount;
516         accounts[_address].isSet = true;
517         require(_updateHistory(_address));
518         accountsList.push(_address);
519         Transfer(this, _address, _amount);
520         return true;
521     }
522 
523     /**
524     @dev Function implementing the shared logic of 'transfer()' and 'transferFrom()'
525     @param _from address sending tokens
526     @param _recipient address receiving tokens
527     @param _amount tokens to send
528     @return A bool set true if successful, false otherwise
529      */
530     function _transfer(address _from, address _recipient, uint256 _amount) internal disabledInMaintenance trackNewUsers(_recipient) returns (bool) {
531 
532         accounts[_from].balance = balanceOf(_from).sub(_amount);
533         accounts[_recipient].balance = balanceOf(_recipient).add(_amount);
534 
535         // save this transaction in both accounts history
536         require(_updateHistory(_from));
537         require(_updateHistory(_recipient));
538 
539         Transfer(_from, _recipient, _amount);
540         return true;
541     }
542 
543     /**
544     @dev Updates the user history with the latest balance.
545     @param _address The Account's address to update
546     @return A bool set true if successful, false otherwise
547      */
548     function _updateHistory(address _address) internal returns (bool) {
549         accounts[_address].history.push(Snapshot(block.number, balanceOf(_address)));
550         return true;
551     }
552 
553 }