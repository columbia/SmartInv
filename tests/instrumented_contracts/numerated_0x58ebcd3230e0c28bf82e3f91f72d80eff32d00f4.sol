1 pragma solidity ^0.4.13;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) constant returns (uint256);
10   function transfer(address to, uint256 value) returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 /**
14  * @title Math
15  * @dev Assorted math operations
16  */
17 contract Math {
18   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
19     return a >= b ? a : b;
20   }
21   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
22     return a < b ? a : b;
23   }
24   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
25     return a >= b ? a : b;
26   }
27   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
28     return a < b ? a : b;
29   }
30 }
31 /**
32  * @title Ownable
33  * @dev The Ownable contract has an owner address, and provides basic authorization control
34  * functions, this simplifies the implementation of "user permissions".
35  */
36 contract Ownable {
37   address public owner;
38   /**
39    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
40    * account.
41    */
42   function Ownable() {
43     owner = msg.sender;
44   }
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52   /**
53    * @dev Allows the current owner to transfer control of the contract to a newOwner.
54    * @param newOwner The address to transfer ownership to.
55    */
56   function transferOwnership(address newOwner) onlyOwner {
57     require(newOwner != address(0));
58     owner = newOwner;
59   }
60 }
61 /**
62  * @title SafeMath
63  * @dev Math operations with safety checks that throw on error
64  */
65 contract SafeMath {
66   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
67     uint256 c = a * b;
68     assert(a == 0 || c / a == b);
69     return c;
70   }
71   function div(uint256 a, uint256 b) internal constant returns (uint256) {
72     // assert(b > 0); // Solidity automatically throws when dividing by 0
73     uint256 c = a / b;
74     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75     return c;
76   }
77   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
78     assert(b <= a);
79     return a - b;
80   }
81   function add(uint256 a, uint256 b) internal constant returns (uint256) {
82     uint256 c = a + b;
83     assert(c >= a);
84     return c;
85   }
86   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
87     return a >= b ? a : b;
88   }
89   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
90     return a < b ? a : b;
91   }
92   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
93     return a >= b ? a : b;
94   }
95   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
96     return a < b ? a : b;
97   }
98 }
99 /**
100  * @title Basic token
101  * @dev Basic version of StandardToken, with no allowances.
102  */
103 contract BasicToken is SafeMath, ERC20Basic {
104   mapping(address => uint256) balances;
105   /**
106   * @dev transfer token for a specified address
107   * @param _to The address to transfer to.
108   * @param _value The amount to be transferred.
109   */
110   function transfer(address _to, uint _value) returns (bool){
111     balances[msg.sender] = sub(balances[msg.sender],_value);
112     balances[_to] = add(balances[_to],_value);
113     Transfer(msg.sender, _to, _value);
114     return true;
115   }
116   /**
117   * @dev Gets the balance of the specified address.
118   * @param _owner The address to query the the balance of.
119   * @return An uint representing the amount owned by the passed address.
120   */
121   function balanceOf(address _owner) constant returns (uint balance) {
122     return balances[_owner];
123   }
124 }
125 /**
126  * @title ERC20 interface
127  * @dev see https://github.com/ethereum/EIPs/issues/20
128  */
129 contract ERC20 is ERC20Basic {
130   function allowance(address owner, address spender) constant returns (uint256);
131   function transferFrom(address from, address to, uint256 value) returns (bool);
132   function approve(address spender, uint256 value) returns (bool);
133   event Approval(address indexed owner, address indexed spender, uint256 value);
134 }
135 /**
136  * @title Standard ERC20 token
137  *
138  * @dev Implementation of the basic standard token.
139  * @dev https://github.com/ethereum/EIPs/issues/20
140  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
141  */
142 contract StandardToken is ERC20, BasicToken {
143   mapping (address => mapping (address => uint256)) allowed;
144   /**
145    * @dev Transfer tokens from one address to another
146    * @param _from address The address which you want to send tokens from
147    * @param _to address The address which you want to transfer to
148    * @param _value uint256 the amout of tokens to be transfered
149    */
150   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
151     var _allowance = allowed[_from][msg.sender];
152     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
153     // require (_value <= _allowance);
154     balances[_to] = add(balances[_to],_value);
155     balances[_from] = sub(balances[_from],_value);
156     allowed[_from][msg.sender] = sub(_allowance,_value);
157     Transfer(_from, _to, _value);
158     return true;
159   }
160   /**
161    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
162    * @param _spender The address which will spend the funds.
163    * @param _value The amount of tokens to be spent.
164    */
165   function approve(address _spender, uint256 _value) returns (bool) {
166     // To change the approve amount you first have to reduce the addresses`
167     //  allowance to zero by calling `approve(_spender, 0)` if it is not
168     //  already 0 to mitigate the race condition described here:
169     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
171     allowed[msg.sender][_spender] = _value;
172     Approval(msg.sender, _spender, _value);
173     return true;
174   }
175   /**
176    * @dev Function to check the amount of tokens that an owner allowed to a spender.
177    * @param _owner address The address which owns the funds.
178    * @param _spender address The address which will spend the funds.
179    * @return A uint256 specifing the amount of tokens still available for the spender.
180    */
181   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
182     return allowed[_owner][_spender];
183   }
184 }
185 /**
186  * @title Mintable token
187  * @dev Simple ERC20 Token example, with mintable token creation
188  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
189  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
190  */
191 contract MintableToken is StandardToken, Ownable {
192   event Mint(address indexed to, uint256 amount);
193   event MintFinished();
194   bool public mintingFinished = false;
195   modifier canMint() {
196     require(!mintingFinished);
197     _;
198   }
199   /**
200    * @dev Function to mint tokens
201    * @param _to The address that will recieve the minted tokens.
202    * @param _amount The amount of tokens to mint.
203    * @return A boolean that indicates if the operation was successful.
204    */
205   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
206     totalSupply = add(totalSupply,_amount);
207     balances[_to] = add(balances[_to],_amount);
208     Mint(_to, _amount);
209     return true;
210   }
211   /**
212    * @dev Function to stop minting new tokens.
213    * @return True if the operation was successful.
214    */
215   function finishMinting() onlyOwner returns (bool) {
216     mintingFinished = true;
217     MintFinished();
218     return true;
219   }
220 }
221 /**
222  * @title Pausable
223  * @dev Base contract which allows children to implement an emergency stop mechanism.
224  */
225 contract Pausable is Ownable {
226   event Pause();
227   event Unpause();
228   bool public paused = false;
229   /**
230    * @dev modifier to allow actions only when the contract IS paused
231    */
232   modifier whenNotPaused() {
233     require(!paused);
234     _;
235   }
236   /**
237    * @dev modifier to allow actions only when the contract IS NOT paused
238    */
239   modifier whenPaused() {
240     require(paused);
241     _;
242   }
243   /**
244    * @dev called by the owner to pause, triggers stopped state
245    */
246   function pause() onlyOwner whenNotPaused {
247     paused = true;
248     Pause();
249   }
250   /**
251    * @dev called by the owner to unpause, returns to normal state
252    */
253   function unpause() onlyOwner whenPaused {
254     paused = false;
255     Unpause();
256   }
257 }
258 /**
259  * Pausable token
260  *
261  * Simple ERC20 Token example, with pausable token creation
262  **/
263 contract PausableToken is StandardToken, Pausable {
264   function transfer(address _to, uint256 _value) whenNotPaused returns (bool) {
265     return super.transfer(_to, _value);
266   }
267   function transferFrom(address _from, address _to, uint256 _value) whenNotPaused returns (bool) {
268     return super.transferFrom(_from, _to, _value);
269   }
270 }
271 /**
272  * @title LimitedTransferToken
273  * @dev LimitedTransferToken defines the generic interface and the implementation to limit token
274  * transferability for different events. It is intended to be used as a base class for other token
275  * contracts.
276  * LimitedTransferToken has been designed to allow for different limiting factors,
277  * this can be achieved by recursively calling super.transferableTokens() until the base class is
278  * hit. For example:
279  *     function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
280  *       return min256(unlockedTokens, super.transferableTokens(holder, time));
281  *     }
282  * A working example is VestedToken.sol:
283  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/VestedToken.sol
284  */
285 contract LimitedTransferToken is ERC20 {
286   /**
287    * @dev Checks whether it can transfer or otherwise throws.
288    */
289   modifier canTransfer(address _sender, uint256 _value) {
290    require(_value <= transferableTokens(_sender, uint64(now)));
291    _;
292   }
293   /**
294    * @dev Checks modifier and allows transfer if tokens are not locked.
295    * @param _to The address that will recieve the tokens.
296    * @param _value The amount of tokens to be transferred.
297    */
298   function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) returns (bool) {
299     return super.transfer(_to, _value);
300   }
301   /**
302   * @dev Checks modifier and allows transfer if tokens are not locked.
303   * @param _from The address that will send the tokens.
304   * @param _to The address that will recieve the tokens.
305   * @param _value The amount of tokens to be transferred.
306   */
307   function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) returns (bool) {
308     return super.transferFrom(_from, _to, _value);
309   }
310   /**
311    * @dev Default transferable tokens function returns all tokens for a holder (no limit).
312    * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the
313    * specific logic for limiting token transferability for a holder over time.
314    */
315   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
316     return balanceOf(holder);
317   }
318 }
319 /**
320  * @title Vested token
321  * @dev Tokens that can be vested for a group of addresses.
322  */
323 contract VestedToken is Math, StandardToken, LimitedTransferToken {
324   uint256 MAX_GRANTS_PER_ADDRESS = 20;
325   struct TokenGrant {
326     address granter;     // 20 bytes
327     uint256 value;       // 32 bytes
328     uint64 cliff;
329     uint64 vesting;
330     uint64 start;        // 3 * 8 = 24 bytes
331     bool revokable;
332     bool burnsOnRevoke;  // 2 * 1 = 2 bits? or 2 bytes?
333   } // total 78 bytes = 3 sstore per operation (32 per sstore)
334   mapping (address => TokenGrant[]) public grants;
335   event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint256 grantId);
336   /**
337    * @dev Grant tokens to a specified address
338    * @param _to address The address which the tokens will be granted to.
339    * @param _value uint256 The amount of tokens to be granted.
340    * @param _start uint64 Time of the beginning of the grant.
341    * @param _cliff uint64 Time of the cliff period.
342    * @param _vesting uint64 The vesting period.
343    */
344   function grantVestedTokens(
345     address _to,
346     uint256 _value,
347     uint64 _start,
348     uint64 _cliff,
349     uint64 _vesting,
350     bool _revokable,
351     bool _burnsOnRevoke
352   ) public {
353     // Check for date inconsistencies that may cause unexpected behavior
354     require(_cliff >= _start && _vesting >= _cliff);
355     require(tokenGrantsCount(_to) < MAX_GRANTS_PER_ADDRESS);   // To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).
356     uint256 count = grants[_to].push(
357                 TokenGrant(
358                   _revokable ? msg.sender : 0, // avoid storing an extra 20 bytes when it is non-revokable
359                   _value,
360                   _cliff,
361                   _vesting,
362                   _start,
363                   _revokable,
364                   _burnsOnRevoke
365                 )
366               );
367     transfer(_to, _value);
368     NewTokenGrant(msg.sender, _to, _value, count - 1);
369   }
370   /**
371    * @dev Revoke the grant of tokens of a specifed address.
372    * @param _holder The address which will have its tokens revoked.
373    * @param _grantId The id of the token grant.
374    */
375   function revokeTokenGrant(address _holder, uint256 _grantId) public {
376     TokenGrant storage grant = grants[_holder][_grantId];
377     require(grant.revokable);
378     require(grant.granter == msg.sender); // Only granter can revoke it
379     address receiver = grant.burnsOnRevoke ? 0xdead : msg.sender;
380     uint256 nonVested = nonVestedTokens(grant, uint64(now));
381     // remove grant from array
382     delete grants[_holder][_grantId];
383     grants[_holder][_grantId] = grants[_holder][sub(grants[_holder].length,1)];
384     grants[_holder].length -= 1;
385     balances[receiver] = add(balances[receiver],nonVested);
386     balances[_holder] = sub(balances[_holder],nonVested);
387     Transfer(_holder, receiver, nonVested);
388   }
389   /**
390    * @dev Calculate the total amount of transferable tokens of a holder at a given time
391    * @param holder address The address of the holder
392    * @param time uint64 The specific time.
393    * @return An uint256 representing a holder's total amount of transferable tokens.
394    */
395   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
396     uint256 grantIndex = tokenGrantsCount(holder);
397     if (grantIndex == 0) return super.transferableTokens(holder, time); // shortcut for holder without grants
398     // Iterate through all the grants the holder has, and add all non-vested tokens
399     uint256 nonVested = 0;
400     for (uint256 i = 0; i < grantIndex; i++) {
401       nonVested = add(nonVested, nonVestedTokens(grants[holder][i], time));
402     }
403     // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time
404     uint256 vestedTransferable = sub(balanceOf(holder), nonVested);
405     // Return the minimum of how many vested can transfer and other value
406     // in case there are other limiting transferability factors (default is balanceOf)
407     return min256(vestedTransferable, super.transferableTokens(holder, time));
408   }
409   /**
410    * @dev Check the amount of grants that an address has.
411    * @param _holder The holder of the grants.
412    * @return A uint256 representing the total amount of grants.
413    */
414   function tokenGrantsCount(address _holder) constant returns (uint256 index) {
415     return grants[_holder].length;
416   }
417   /**
418    * @dev Calculate amount of vested tokens at a specifc time.
419    * @param tokens uint256 The amount of tokens grantted.
420    * @param time uint64 The time to be checked
421    * @param start uint64 A time representing the begining of the grant
422    * @param cliff uint64 The cliff period.
423    * @param vesting uint64 The vesting period.
424    * @return An uint256 representing the amount of vested tokensof a specif grant.
425    *  transferableTokens
426    *   |                         _/--------   vestedTokens rect
427    *   |                       _/
428    *   |                     _/
429    *   |                   _/
430    *   |                 _/
431    *   |                /
432    *   |              .|
433    *   |            .  |
434    *   |          .    |
435    *   |        .      |
436    *   |      .        |
437    *   |    .          |
438    *   +===+===========+---------+----------> time
439    *      Start       Clift    Vesting
440    */
441   function calculateVestedTokens(
442     uint256 tokens,
443     uint256 time,
444     uint256 start,
445     uint256 cliff,
446     uint256 vesting) constant returns (uint256)
447     {
448       // Shortcuts for before cliff and after vesting cases.
449       if (time < cliff) return 0;
450       if (time >= vesting) return tokens;
451       // Interpolate all vested tokens.
452       // As before cliff the shortcut returns 0, we can use just calculate a value
453       // in the vesting rect (as shown in above's figure)
454       // vestedTokens = tokens * (time - start) / (vesting - start)
455       uint256 vestedTokens = div(
456                                     mul(
457                                       tokens,
458                                       sub(time, start)
459                                       ),
460                                     sub(vesting, start)
461                                     );
462       return vestedTokens;
463   }
464   /**
465    * @dev Get all information about a specifc grant.
466    * @param _holder The address which will have its tokens revoked.
467    * @param _grantId The id of the token grant.
468    * @return Returns all the values that represent a TokenGrant(address, value, start, cliff,
469    * revokability, burnsOnRevoke, and vesting) plus the vested value at the current time.
470    */
471   function tokenGrant(address _holder, uint256 _grantId) constant returns (address granter, uint256 value, uint256 vested, uint64 start, uint64 cliff, uint64 vesting, bool revokable, bool burnsOnRevoke) {
472     TokenGrant storage grant = grants[_holder][_grantId];
473     granter = grant.granter;
474     value = grant.value;
475     start = grant.start;
476     cliff = grant.cliff;
477     vesting = grant.vesting;
478     revokable = grant.revokable;
479     burnsOnRevoke = grant.burnsOnRevoke;
480     vested = vestedTokens(grant, uint64(now));
481   }
482   /**
483    * @dev Get the amount of vested tokens at a specific time.
484    * @param grant TokenGrant The grant to be checked.
485    * @param time The time to be checked
486    * @return An uint256 representing the amount of vested tokens of a specific grant at a specific time.
487    */
488   function vestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
489     return calculateVestedTokens(
490       grant.value,
491       uint256(time),
492       uint256(grant.start),
493       uint256(grant.cliff),
494       uint256(grant.vesting)
495     );
496   }
497   /**
498    * @dev Calculate the amount of non vested tokens at a specific time.
499    * @param grant TokenGrant The grant to be checked.
500    * @param time uint64 The time to be checked
501    * @return An uint256 representing the amount of non vested tokens of a specifc grant on the
502    * passed time frame.
503    */
504   function nonVestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
505     return sub(grant.value,vestedTokens(grant, time));
506   }
507   /**
508    * @dev Calculate the date when the holder can trasfer all its tokens
509    * @param holder address The address of the holder
510    * @return An uint256 representing the date of the last transferable tokens.
511    */
512   function lastTokenIsTransferableDate(address holder) constant public returns (uint64 date) {
513     date = uint64(now);
514     uint256 grantIndex = grants[holder].length;
515     for (uint256 i = 0; i < grantIndex; i++) {
516       date = max64(grants[holder][i].vesting, date);
517     }
518   }
519 }
520 /**
521  * @title Burnable Token
522  * @dev Token that can be irreversibly burned (destroyed).
523  */
524 contract BurnableToken is SafeMath, StandardToken {
525     event Burn(address indexed burner, uint indexed value);
526     /**
527      * @dev Burns a specific amount of tokens.
528      * @param _value The amount of token to be burned.
529      */
530     function burn(uint _value)
531         public
532     {
533         require(_value > 0);
534         address burner = msg.sender;
535         balances[burner] = sub(balances[burner], _value);
536         totalSupply = sub(totalSupply, _value);
537         Burn(burner, _value);
538     }
539 }
540 /**
541  * @title PLC
542  * @dev PLC is ERC20 token contract, inheriting MintableToken, PausableToken,
543  * VestedToken, BurnableToken contract from open zeppelin.
544  */
545 contract PLC is MintableToken, PausableToken, VestedToken, BurnableToken {
546   string public name = "PlusCoin";
547   string public symbol = "PLC";
548   uint256 public decimals = 18;
549 }
550 /**
551  * @title RefundVault
552  * @dev This contract is used for storing funds while a crowdsale
553  * is in progress. Supports refunding the money if crowdsale fails,
554  * and forwarding it if crowdsale is successful.
555  */
556 contract RefundVault is Ownable, SafeMath{
557   enum State { Active, Refunding, Closed }
558   mapping (address => uint256) public deposited;
559   mapping (address => uint256) public refunded;
560   State public state;
561   address public devMultisig;
562   address[] public reserveWallet;
563   event Closed();
564   event RefundsEnabled();
565   event Refunded(address indexed beneficiary, uint256 weiAmount);
566   /**
567    * @dev This constructor sets the addresses of multi-signature wallet and
568    * 5 reserve wallets.
569    * and forwarding it if crowdsale is successful.
570    * @param _devMultiSig address The address of multi-signature wallet.
571    * @param _reserveWallet address[5] The addresses of reserve wallet.
572    */
573   function RefundVault(address _devMultiSig, address[] _reserveWallet) {
574     state = State.Active;
575     devMultisig = _devMultiSig;
576     reserveWallet = _reserveWallet;
577   }
578   /**
579    * @dev This function is called when user buy tokens. Only RefundVault
580    * contract stores the Ether user sent which forwarded from crowdsale
581    * contract.
582    * @param investor address The address who buy the token from crowdsale.
583    */
584   function deposit(address investor) onlyOwner payable {
585     require(state == State.Active);
586     deposited[investor] = add(deposited[investor], msg.value);
587   }
588   event Transferred(address _to, uint _value);
589   /**
590    * @dev This function is called when crowdsale is successfully finalized.
591    */
592   function close() onlyOwner {
593     require(state == State.Active);
594     state = State.Closed;
595     uint256 balance = this.balance;
596     uint256 devAmount = div(balance, 10);
597     devMultisig.transfer(devAmount);
598     Transferred(devMultisig, devAmount);
599     uint256 reserveAmount = div(mul(balance, 9), 10);
600     uint256 reserveAmountForEach = div(reserveAmount, reserveWallet.length);
601     for(uint8 i = 0; i < reserveWallet.length; i++){
602       reserveWallet[i].transfer(reserveAmountForEach);
603       Transferred(reserveWallet[i], reserveAmountForEach);
604     }
605     Closed();
606   }
607   /**
608    * @dev This function is called when crowdsale is unsuccessfully finalized
609    * and refund is required.
610    */
611   function enableRefunds() onlyOwner {
612     require(state == State.Active);
613     state = State.Refunding;
614     RefundsEnabled();
615   }
616   /**
617    * @dev This function allows for user to refund Ether.
618    */
619   function refund(address investor) returns (bool) {
620     require(state == State.Refunding);
621     if (refunded[investor] > 0) {
622       return false;
623     }
624     uint256 depositedValue = deposited[investor];
625     deposited[investor] = 0;
626     refunded[investor] = depositedValue;
627     investor.transfer(depositedValue);
628     Refunded(investor, depositedValue);
629     return true;
630   }
631 }
632 /**
633  * @title KYC
634  * @dev KYC contract handles the white list for PLCCrowdsale contract
635  * Only accounts registered in KYC contract can buy PLC token.
636  * Admins can register account, and the reason why
637  */
638 contract KYC is Ownable, SafeMath, Pausable {
639   // check the address is registered for token sale
640   mapping (address => bool) public registeredAddress;
641   // check the address is admin of kyc contract
642   mapping (address => bool) public admin;
643   event Registered(address indexed _addr);
644   event Unregistered(address indexed _addr);
645   event NewAdmin(address indexed _addr);
646   /**
647    * @dev check whether the address is registered for token sale or not.
648    * @param _addr address
649    */
650   modifier onlyRegistered(address _addr) {
651     require(isRegistered(_addr));
652     _;
653   }
654   /**
655    * @dev check whether the msg.sender is admin or not
656    */
657   modifier onlyAdmin() {
658     require(admin[msg.sender]);
659     _;
660   }
661   function KYC() {
662     admin[msg.sender] = true;
663   }
664   /**
665    * @dev set new admin as admin of KYC contract
666    * @param _addr address The address to set as admin of KYC contract
667    */
668   function setAdmin(address _addr)
669     public
670     onlyOwner
671   {
672     require(_addr != address(0) && admin[_addr] == false);
673     admin[_addr] = true;
674     NewAdmin(_addr);
675   }
676   /**
677    * @dev check the address is register for token sale
678    * @param _addr address The address to check whether register or not
679    */
680   function isRegistered(address _addr)
681     public
682     constant
683     returns (bool)
684   {
685     return registeredAddress[_addr];
686   }
687   /**
688    * @dev register the address for token sale
689    * @param _addr address The address to register for token sale
690    */
691   function register(address _addr)
692     public
693     onlyAdmin
694     whenNotPaused
695   {
696     require(_addr != address(0) && registeredAddress[_addr] == false);
697     registeredAddress[_addr] = true;
698     Registered(_addr);
699   }
700   /**
701    * @dev register the addresses for token sale
702    * @param _addrs address[] The addresses to register for token sale
703    */
704   function registerByList(address[] _addrs)
705     public
706     onlyAdmin
707     whenNotPaused
708   {
709     for(uint256 i = 0; i < _addrs.length; i++) {
710       require(_addrs[i] != address(0) && registeredAddress[_addrs[i]] == false);
711       registeredAddress[_addrs[i]] = true;
712       Registered(_addrs[i]);
713     }
714   }
715   /**
716    * @dev unregister the registered address
717    * @param _addr address The address to unregister for token sale
718    */
719   function unregister(address _addr)
720     public
721     onlyAdmin
722     onlyRegistered(_addr)
723   {
724     registeredAddress[_addr] = false;
725     Unregistered(_addr);
726   }
727   /**
728    * @dev unregister the registered addresses
729    * @param _addrs address[] The addresses to unregister for token sale
730    */
731   function unregisterByList(address[] _addrs)
732     public
733     onlyAdmin
734   {
735     for(uint256 i = 0; i < _addrs.length; i++) {
736       require(isRegistered(_addrs[i]));
737       registeredAddress[_addrs[i]] = false;
738       Unregistered(_addrs[i]);
739     }
740   }
741 }
742 /**
743  * @title PLCCrowdsale
744  * @dev PLCCrowdsale is a base contract for managing a token crowdsale.
745  * Crowdsales have a start and end timestamps, where investors can make
746  * token purchases and the crowdsale will assign them tokens based
747  * on a token per ETH rate. Funds collected are forwarded to a wallet
748  * as they arrive.
749  */
750 contract PLCCrowdsale is Ownable, SafeMath, Pausable {
751   // token registery contract
752   KYC public kyc;
753   // The token being sold
754   PLC public token;
755   // start and end timestamps where investments are allowed (both inclusive)
756   uint64 public startTime; // 1506384000; //2017.9.26 12:00 am (UTC)
757   uint64 public endTime; // 1507593600; //2017.10.10 12:00 am (UTC)
758   uint64[5] public deadlines; // [1506643200, 1506902400, 1507161600, 1507420800, 1507593600]; // [2017.9.26, 2017.10.02, 2017.10.05, 2017.10.08, 2017.10.10]
759   mapping (address => uint256) public presaleRate;
760   uint8[5] public rates = [240, 230, 220, 210, 200];
761   // amount of raised money in wei
762   uint256 public weiRaised;
763   // amount of ether buyer can buy
764   uint256 constant public maxGuaranteedLimit = 5000 ether;
765   // amount of ether presale buyer can buy
766   mapping (address => uint256) public presaleGuaranteedLimit;
767   mapping (address => bool) public isDeferred;
768   // amount of ether funded for each buyer
769   // bool: true if deferred otherwise false
770   mapping (bool => mapping (address => uint256)) public buyerFunded;
771   // amount of tokens minted for deferredBuyers
772   uint256 public deferredTotalTokens;
773   // buyable interval in block number 20
774   uint256 constant public maxCallFrequency = 20;
775   // block number when buyer buy
776   mapping (address => uint256) public lastCallBlock;
777   bool public isFinalized = false;
778   // minimum amount of funds to be raised in weis
779   uint256 public maxEtherCap; // 100000 ether;
780   uint256 public minEtherCap; // 30000 ether;
781   // investor address list
782   address[] buyerList;
783   mapping (address => bool) inBuyerList;
784   // number of refunded investors
785   uint256 refundCompleted;
786   // new owner of token contract when crowdsale is Finalized
787   address newTokenOwner = 0x568E2B5e9643D38e6D8146FeE8d80a1350b2F1B9;
788   // refund vault used to hold funds while crowdsale is running
789   RefundVault public vault;
790   // dev team multisig wallet
791   address devMultisig;
792   // reserve
793   address[] reserveWallet;
794   /**
795    * @dev Checks whether buyer is sending transaction too frequently
796    */
797   modifier canBuyInBlock () {
798     require(add(lastCallBlock[msg.sender], maxCallFrequency) < block.number);
799     lastCallBlock[msg.sender] = block.number;
800     _;
801   }
802   /**
803    * @dev Checks whether ico is started
804    */
805   modifier onlyAfterStart() {
806     require(now >= startTime && now <= endTime);
807     _;
808   }
809   /**
810    * @dev Checks whether ico is not started
811    */
812   modifier onlyBeforeStart() {
813     require(now < startTime);
814     _;
815   }
816   /**
817    * @dev Checks whether the account is registered
818    */
819   modifier onlyRegistered(address _addr) {
820     require(kyc.isRegistered(_addr));
821     _;
822   }
823   /**
824    * event for token purchase logging
825    * @param purchaser who paid for the tokens
826    * @param beneficiary who got the tokens
827    * @param value weis paid for purchase
828    * @param amount amount of tokens purchased
829    */
830   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
831   event PresaleTokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
832   event DeferredPresaleTokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
833   /**
834    * event for finalize logging
835    */
836   event Finalized();
837   /**
838    * event for register presale logging
839    * @param presaleInvestor who register for presale
840    * @param presaleAmount weis presaleInvestor can buy as presale
841    * @param _presaleRate rate at which presaleInvestor can buy tokens
842    * @param _isDeferred whether the investor is deferred investor
843    */
844   event RegisterPresale(address indexed presaleInvestor, uint256 presaleAmount, uint256 _presaleRate, bool _isDeferred);
845   /**
846    * event for unregister presale logging
847    * @param presaleInvestor who register for presale
848    */
849   event UnregisterPresale(address indexed presaleInvestor);
850   /**
851    * @dev PLCCrowdsale constructor sets variables
852    * @param _kyc address The address which KYC contract is deployed at
853    * @param _token address The address which PLC contract is deployed at
854    * @param _refundVault address The address which RefundVault is deployed at
855    * @param _devMultisig address The address which MultiSigWallet for devTeam is deployed at
856    * @param _reserveWallet address[5] The address list of reserveWallet addresses
857    * @param _timelines uint64[5] list of timelines from startTime to endTime with timelines for rate changes
858    * @param _maxEtherCap uint256 The value which maximum weis to be funded
859    * @param _minEtherCap uint256 The value which minimum weis to be funded
860    */
861   function PLCCrowdsale(
862     address _kyc,
863     address _token,
864     address _refundVault,
865     address _devMultisig,
866     address[] _reserveWallet,
867     uint64[6] _timelines, // [startTime, ... , endTime]
868     uint256 _maxEtherCap,
869     uint256 _minEtherCap)
870   {
871     //timelines check
872     for(uint8 i = 0; i < _timelines.length-1; i++){
873       require(_timelines[i] < _timelines[i+1]);
874     }
875     require(_timelines[0] >= now);
876     //address check
877     require(_kyc != 0x00 && _token != 0x00 && _refundVault != 0x00 && _devMultisig != 0x00);
878     for(i = 0; i < _reserveWallet.length; i++){
879       require(_reserveWallet[i] != 0x00);
880     }
881     //cap check
882     require(_minEtherCap < _maxEtherCap);
883     kyc   = KYC(_kyc);
884     token = PLC(_token);
885     vault = RefundVault(_refundVault);
886     devMultisig   = _devMultisig;
887     reserveWallet = _reserveWallet;
888     startTime    = _timelines[0];
889     endTime      = _timelines[5];
890     deadlines[0] = _timelines[1];
891     deadlines[1] = _timelines[2];
892     deadlines[2] = _timelines[3];
893     deadlines[3] = _timelines[4];
894     deadlines[4] = _timelines[5];
895     maxEtherCap  = _maxEtherCap;
896     minEtherCap  = _minEtherCap;
897   }
898   /**
899    * @dev PLCCrowdsale fallback function for buying Tokens
900    */
901   function () payable {
902     if(isDeferred[msg.sender])
903       buyDeferredPresaleTokens(msg.sender);
904     else if(now < startTime)
905       buyPresaleTokens(msg.sender);
906     else
907       buyTokens();
908   }
909   /**
910    * @dev push all token buyers in list
911    * @param _addr address Account to push into buyerList
912    */
913   function pushBuyerList(address _addr) internal {
914     if (!inBuyerList[_addr]) {
915       inBuyerList[_addr] = true;
916       buyerList.push(_addr);
917     }
918   }
919   /**
920    * @dev register presale account checking modifier
921    * @param presaleInvestor address The account to register as presale account
922    * @param presaleAmount uint256 The value which investor is allowed to buy
923    * @param _presaleRate uint256 The rate at which investor buy tokens
924    * @param _isDeferred bool whether presaleInvestor is deferred buyer
925    */
926   function registerPresale(address presaleInvestor, uint256 presaleAmount, uint256 _presaleRate, bool _isDeferred)
927     onlyBeforeStart
928     onlyOwner
929   {
930     require(presaleInvestor != 0x00);
931     require(presaleAmount > 0);
932     require(_presaleRate > 0);
933     require(presaleGuaranteedLimit[presaleInvestor] == 0);
934     presaleGuaranteedLimit[presaleInvestor] = presaleAmount;
935     presaleRate[presaleInvestor] = _presaleRate;
936     isDeferred[presaleInvestor] = _isDeferred;
937     if(_isDeferred) {
938       weiRaised = add(weiRaised, presaleAmount);
939       uint256 deferredInvestorToken = mul(presaleAmount, _presaleRate);
940       uint256 deferredDevToken = div(mul(deferredInvestorToken, 20), 70);
941       uint256 deferredReserveToken = div(mul(deferredInvestorToken, 10), 70);
942       uint256 totalAmount = add(deferredInvestorToken, add(deferredDevToken, deferredReserveToken));
943       token.mint(address(this), totalAmount);
944       deferredTotalTokens = add(deferredTotalTokens, totalAmount);
945     }
946     RegisterPresale(presaleInvestor, presaleAmount, _presaleRate, _isDeferred);
947   }
948   /**
949    * @dev register presale account checking modifier
950    * @param presaleInvestor address The account to register as presale account
951    */
952   function unregisterPresale(address presaleInvestor)
953     onlyBeforeStart
954     onlyOwner
955   {
956     require(presaleInvestor != 0x00);
957     require(presaleGuaranteedLimit[presaleInvestor] > 0);
958     uint256 _amount = presaleGuaranteedLimit[presaleInvestor];
959     uint256 _rate = presaleRate[presaleInvestor];
960     bool _isDeferred = isDeferred[presaleInvestor];
961     require(buyerFunded[_isDeferred][presaleInvestor] == 0);
962     presaleGuaranteedLimit[presaleInvestor] = 0;
963     presaleRate[presaleInvestor] = 0;
964     isDeferred[presaleInvestor] = false;
965     if(_isDeferred) {
966       weiRaised = sub(weiRaised, _amount);
967       uint256 deferredInvestorToken = mul(_amount, _rate);
968       uint256 deferredDevToken = div(mul(deferredInvestorToken, 20), 70);
969       uint256 deferredReserveToken = div(mul(deferredInvestorToken, 10), 70);
970       uint256 totalAmount = add(deferredInvestorToken, add(deferredDevToken, deferredReserveToken));
971       deferredTotalTokens = sub(deferredTotalTokens, totalAmount);
972       token.burn(totalAmount);
973     }
974     UnregisterPresale(presaleInvestor);
975   }
976   /**
977    * @dev buy token (deferred presale investor)
978    * @param beneficiary address The account to receive tokens
979    */
980   function buyDeferredPresaleTokens(address beneficiary)
981     payable
982     whenNotPaused
983   {
984     require(beneficiary != 0x00);
985     require(isDeferred[beneficiary]);
986     uint guaranteedLimit = presaleGuaranteedLimit[beneficiary];
987     require(guaranteedLimit > 0);
988     uint256 weiAmount = msg.value;
989     require(weiAmount != 0);
990     uint256 totalAmount = add(buyerFunded[true][beneficiary], weiAmount);
991     uint256 toFund;
992     if (totalAmount > guaranteedLimit) {
993       toFund = sub(guaranteedLimit, buyerFunded[true][beneficiary]);
994     } else {
995       toFund = weiAmount;
996     }
997     require(toFund > 0);
998     require(weiAmount >= toFund);
999     uint256 tokens = mul(toFund, presaleRate[beneficiary]);
1000     uint256 toReturn = sub(weiAmount, toFund);
1001     buy(beneficiary, tokens, toFund, toReturn, true);
1002     // token distribution : 70% for sale, 20% for dev, 10% for reserve
1003     uint256 devAmount = div(mul(tokens, 20), 70);
1004     uint256 reserveAmount = div(mul(tokens, 10), 70);
1005     distributeToken(devAmount, reserveAmount, true);
1006     // ether distribution : 10% for dev, 90% for reserve
1007     uint256 devEtherAmount = div(toFund, 10);
1008     uint256 reserveEtherAmount = div(mul(toFund, 9), 10);
1009     distributeEther(devEtherAmount, reserveEtherAmount);
1010     DeferredPresaleTokenPurchase(msg.sender, beneficiary, toFund, tokens);
1011   }
1012   /**
1013    * @dev buy token (normal presale investor)
1014    * @param beneficiary address The account to receive tokens
1015    */
1016   function buyPresaleTokens(address beneficiary)
1017     payable
1018     whenNotPaused
1019     onlyBeforeStart
1020   {
1021     // check validity
1022     require(beneficiary != 0x00);
1023     require(validPurchase());
1024     require(!isDeferred[beneficiary]);
1025     uint guaranteedLimit = presaleGuaranteedLimit[beneficiary];
1026     require(guaranteedLimit > 0);
1027     // calculate eth amount
1028     uint256 weiAmount = msg.value;
1029     uint256 totalAmount = add(buyerFunded[false][beneficiary], weiAmount);
1030     uint256 toFund;
1031     if (totalAmount > guaranteedLimit) {
1032       toFund = sub(guaranteedLimit, buyerFunded[false][beneficiary]);
1033     } else {
1034       toFund = weiAmount;
1035     }
1036     require(toFund > 0);
1037     require(weiAmount >= toFund);
1038     uint256 tokens = mul(toFund, presaleRate[beneficiary]);
1039     uint256 toReturn = sub(weiAmount, toFund);
1040     buy(beneficiary, tokens, toFund, toReturn, false);
1041     forwardFunds(toFund);
1042     PresaleTokenPurchase(msg.sender, beneficiary, toFund, tokens);
1043   }
1044   /**
1045    * @dev buy token (normal investors)
1046    */
1047   function buyTokens()
1048     payable
1049     whenNotPaused
1050     canBuyInBlock
1051     onlyAfterStart
1052     onlyRegistered(msg.sender)
1053   {
1054     // check validity
1055     require(validPurchase());
1056     require(buyerFunded[false][msg.sender] < maxGuaranteedLimit);
1057     // calculate eth amount
1058     uint256 weiAmount = msg.value;
1059     uint256 totalAmount = add(buyerFunded[false][msg.sender], weiAmount);
1060     uint256 toFund;
1061     if (totalAmount > maxGuaranteedLimit) {
1062       toFund = sub(maxGuaranteedLimit, buyerFunded[false][msg.sender]);
1063     } else {
1064       toFund = weiAmount;
1065     }
1066     if(add(weiRaised,toFund) > maxEtherCap) {
1067       toFund = sub(maxEtherCap, weiRaised);
1068     }
1069     require(toFund > 0);
1070     require(weiAmount >= toFund);
1071     uint256 tokens = mul(toFund, getRate());
1072     uint256 toReturn = sub(weiAmount, toFund);
1073     buy(msg.sender, tokens, toFund, toReturn, false);
1074     forwardFunds(toFund);
1075     TokenPurchase(msg.sender, msg.sender, toFund, tokens);
1076   }
1077   /**
1078    * @dev get buy rate for now
1079    * @return rate uint256 rate for now
1080    */
1081   function getRate() constant returns (uint256 rate) {
1082     for(uint8 i = 0; i < deadlines.length; i++)
1083       if(now < deadlines[i])
1084         return rates[i];
1085       return rates[rates.length-1];//should never be returned, but to be sure to not divide by 0
1086   }
1087   /**
1088    * @dev get the number of buyers
1089    * @return uint256 the number of buyers
1090    */
1091   function getBuyerNumber() constant returns (uint256) {
1092     return buyerList.length;
1093   }
1094   /**
1095    * @dev send ether to the fund collection wallet
1096    * @param toFund uint256 The value of weis to send to vault
1097    */
1098   function forwardFunds(uint256 toFund) internal {
1099     vault.deposit.value(toFund)(msg.sender);
1100   }
1101   /**
1102    * @dev checks whether purchase value is not zero and maxEtherCap is not reached
1103    * @return true if the transaction can buy tokens
1104    */
1105   function validPurchase() internal constant returns (bool) {
1106     bool nonZeroPurchase = msg.value != 0;
1107     return nonZeroPurchase && !maxReached();
1108   }
1109   function buy(
1110     address _beneficiary,
1111     uint256 _tokens,
1112     uint256 _toFund,
1113     uint256 _toReturn,
1114     bool _isDeferred)
1115     internal
1116   {
1117     if (!_isDeferred) {
1118       pushBuyerList(msg.sender);
1119       weiRaised = add(weiRaised, _toFund);
1120     }
1121     buyerFunded[_isDeferred][_beneficiary] = add(buyerFunded[_isDeferred][_beneficiary], _toFund);
1122     if (!_isDeferred) {
1123       token.mint(address(this), _tokens);
1124     }
1125     // 1 week lock
1126     token.grantVestedTokens(
1127       _beneficiary,
1128       _tokens,
1129       uint64(endTime),
1130       uint64(endTime + 1 weeks),
1131       uint64(endTime + 1 weeks),
1132       false,
1133       false);
1134     // return ether if needed
1135     if (_toReturn > 0) {
1136       msg.sender.transfer(_toReturn);
1137     }
1138   }
1139   /**
1140    * @dev distribute token to multisig wallet and reserve walletes.
1141    * This function is called in two context where crowdsale is closing and
1142    * deferred token is bought.
1143    * @param devAmount uint256 token amount for dev multisig wallet
1144    * @param reserveAmount uint256 token amount for reserve walletes
1145    * @param _isDeferred bool check whether function is called when deferred token is sold
1146    */
1147   function distributeToken(uint256 devAmount, uint256 reserveAmount, bool _isDeferred) internal {
1148     uint256 eachReserveAmount = div(reserveAmount, reserveWallet.length);
1149     token.grantVestedTokens(
1150       devMultisig,
1151       devAmount,
1152       uint64(endTime),
1153       uint64(endTime),
1154       uint64(endTime + 1 years),
1155       false,
1156       false);
1157     if (_isDeferred) {
1158       for(uint8 i = 0; i < reserveWallet.length; i++) {
1159         token.transfer(reserveWallet[i], eachReserveAmount);
1160       }
1161     } else {
1162       for(uint8 j = 0; j < reserveWallet.length; j++) {
1163         token.mint(reserveWallet[j], eachReserveAmount);
1164       }
1165     }
1166   }
1167   /**
1168    * @dev distribute ether to multisig wallet and reserve walletes
1169    * @param devAmount uint256 ether amount for dev multisig wallet
1170    * @param reserveAmount uint256 ether amount for reserve walletes
1171    */
1172   function distributeEther(uint256 devAmount, uint256 reserveAmount) internal {
1173     uint256 eachReserveAmount = div(reserveAmount, reserveWallet.length);
1174     devMultisig.transfer(devAmount);
1175     for(uint8 i = 0; i < reserveWallet.length; i++){
1176       reserveWallet[i].transfer(eachReserveAmount);
1177     }
1178   }
1179   /**
1180    * @dev checks whether crowdsale is ended
1181    * @return true if crowdsale event has ended
1182    */
1183   function hasEnded() public constant returns (bool) {
1184     return now > endTime;
1185   }
1186   /**
1187    * @dev should be called after crowdsale ends, to do
1188    */
1189   function finalize() {
1190     require(!isFinalized);
1191     require(hasEnded() || maxReached());
1192     finalization();
1193     Finalized();
1194     isFinalized = true;
1195   }
1196   /**
1197    * @dev end token minting on finalization, mint tokens for dev team and reserve wallets
1198    */
1199   function finalization() internal {
1200     if (minReached()) {
1201       vault.close();
1202       uint256 totalToken = token.totalSupply();
1203       uint256 tokenSold = sub(totalToken, deferredTotalTokens);
1204       // token distribution : 70% for sale, 20% for dev, 10% for reserve
1205       uint256 devAmount = div(mul(tokenSold, 20), 70);
1206       uint256 reserveAmount = div(mul(tokenSold, 10), 70);
1207       token.mint(address(this), devAmount);
1208       distributeToken(devAmount, reserveAmount, false);
1209     } else {
1210       vault.enableRefunds();
1211     }
1212     token.finishMinting();
1213     token.transferOwnership(newTokenOwner);
1214   }
1215   /**
1216    * @dev should be called when ethereum is forked during crowdsale for refunding ethers on not supported fork
1217    */
1218   function finalizeWhenForked() onlyOwner whenPaused {
1219     require(!isFinalized);
1220     isFinalized = true;
1221     vault.enableRefunds();
1222     token.finishMinting();
1223   }
1224   /**
1225    * @dev refund a lot of investors at a time checking onlyOwner
1226    * @param numToRefund uint256 The number of investors to refund
1227    */
1228   function refundAll(uint256 numToRefund) onlyOwner {
1229     require(isFinalized);
1230     require(!minReached());
1231     require(numToRefund > 0);
1232     uint256 limit = refundCompleted + numToRefund;
1233     if (limit > buyerList.length) {
1234       limit = buyerList.length;
1235     }
1236     for(uint256 i = refundCompleted; i < limit; i++) {
1237       vault.refund(buyerList[i]);
1238     }
1239     refundCompleted = limit;
1240   }
1241   /**
1242    * @dev if crowdsale is unsuccessful, investors can claim refunds here
1243    * @param investor address The account to be refunded
1244    */
1245   function claimRefund(address investor) returns (bool) {
1246     require(isFinalized);
1247     require(!minReached());
1248     return vault.refund(investor);
1249   }
1250   /**
1251    * @dev Checks whether maxEtherCap is reached
1252    * @return true if max ether cap is reaced
1253    */
1254   function maxReached() public constant returns (bool) {
1255     return weiRaised == maxEtherCap;
1256   }
1257   /**
1258    * @dev Checks whether minEtherCap is reached
1259    * @return true if min ether cap is reaced
1260    */
1261   function minReached() public constant returns (bool) {
1262     return weiRaised >= minEtherCap;
1263   }
1264   /**
1265    * @dev should burn unpaid tokens of deferred presale investors
1266    */
1267   function burnUnpaidTokens()
1268     onlyOwner
1269   {
1270     require(isFinalized);
1271     uint256 unpaidTokens = token.balanceOf(address(this));
1272     token.burn(unpaidTokens);
1273   }
1274 }