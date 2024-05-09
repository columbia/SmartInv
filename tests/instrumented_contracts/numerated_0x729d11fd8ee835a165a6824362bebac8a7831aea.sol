1 pragma solidity ^0.4.11;
2 
3 contract Controller {
4 
5   /// @notice Called when `_owner` sends ether to the MiniMe Token contract
6   /// @param _owner The address that sent the ether to create tokens
7   /// @return True if the ether is accepted, false if it throws
8   function proxyPayment(address _owner) payable returns(bool) {
9     return false;
10   }
11 
12   /// @notice Notifies the controller about a token transfer allowing the
13   ///  controller to react if desired
14   /// @param _from The origin of the transfer
15   /// @param _to The destination of the transfer
16   /// @param _amount The amount of the transfer
17   /// @return False if the controller does not authorize the transfer
18   function onTransfer(address _from, address _to, uint _amount) returns(bool) {
19     return false;
20   }
21 
22   /// @notice Notifies the controller about an approval allowing the
23   ///  controller to react if desired
24   /// @param _owner The address that calls `approve()`
25   /// @param _spender The spender in the `approve()` call
26   /// @param _amount The amount in the `approve()` call
27   /// @return False if the controller does not authorize the approval
28   function onApprove(address _owner, address _spender, uint _amount) returns(bool) {
29     return false;
30   }
31 }
32 
33 /**
34  * Math operations with safety checks
35  */
36 library SafeMath {
37 
38   function mul(uint a, uint b) internal returns (uint) {
39     uint c = a * b;
40     assert(a == 0 || c / a == b);
41     return c;
42   }
43 
44   function div(uint a, uint b) internal returns (uint) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     uint c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return c;
49   }
50 
51   function sub(uint a, uint b) internal returns (uint) {
52     assert(b <= a);
53     return a - b;
54   }
55 
56   function add(uint a, uint b) internal returns (uint) {
57     uint c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 
62   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
63     return a >= b ? a : b;
64   }
65 
66   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
67     return a < b ? a : b;
68   }
69 
70   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
71     return a >= b ? a : b;
72   }
73 
74   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
75     return a < b ? a : b;
76   }
77 
78   function assert(bool assertion) internal {
79     if (!assertion) {
80       throw;
81     }
82   }
83 }
84 
85 /**
86  * @title ERC20Basic
87  * @dev Simpler version of ERC20 interface
88  * @dev see https://github.com/ethereum/EIPs/issues/20
89  */
90 contract ERC20Basic {
91   uint public totalSupply;
92   function balanceOf(address who) constant returns (uint);
93   function transfer(address to, uint value);
94   event Transfer(address indexed from, address indexed to, uint value);
95 }
96 
97 /**
98  * @title ERC20 interface
99  * @dev see https://github.com/ethereum/EIPs/issues/20
100  */
101 contract ERC20 is ERC20Basic {
102   function allowance(address owner, address spender) constant returns (uint);
103   function transferFrom(address from, address to, uint value);
104   function approve(address spender, uint value);
105   event Approval(address indexed owner, address indexed spender, uint value);
106 }
107 
108 /**
109  * @title Basic token
110  * @dev Basic version of StandardToken, with no allowances.
111  */
112 contract BasicToken is ERC20Basic {
113   using SafeMath for uint;
114 
115   mapping (address => uint) balances;
116 
117   /**
118    * @dev Fix for the ERC20 short address attack.
119    */
120   modifier onlyPayloadSize(uint size) {
121      if(msg.data.length < size + 4) {
122        throw;
123      }
124      _;
125   }
126 
127   /**
128   * @dev transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
133     balances[msg.sender] = balances[msg.sender].sub(_value);
134     balances[_to] = balances[_to].add(_value);
135     Transfer(msg.sender, _to, _value);
136   }
137 
138   /**
139   * @dev Gets the balance of the specified address.
140   * @param _owner The address to query the the balance of.
141   * @return An uint representing the amount owned by the passed address.
142   */
143   function balanceOf(address _owner) constant returns (uint balance) {
144     return balances[_owner];
145   }
146 }
147 
148 
149 /**
150  * @title Standard ERC20 token
151  *
152  * @dev Implemantation of the basic standart token.
153  * @dev https://github.com/ethereum/EIPs/issues/20
154  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155  */
156 contract StandardToken is BasicToken, ERC20 {
157 
158   mapping (address => mapping (address => uint)) allowed;
159 
160   /**
161    * @dev Transfer tokens from one address to another
162    * @param _from address The address which you want to send tokens from
163    * @param _to address The address which you want to transfer to
164    * @param _value uint the amout of tokens to be transfered
165    */
166   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
167     var _allowance = allowed[_from][msg.sender];
168     balances[_to] = balances[_to].add(_value);
169     balances[_from] = balances[_from].sub(_value);
170     allowed[_from][msg.sender] = _allowance.sub(_value);
171     Transfer(_from, _to, _value);
172   }
173 
174   /**
175    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
176    * @param _spender The address which will spend the funds.
177    * @param _value The amount of tokens to be spent.
178    */
179   function approve(address _spender, uint _value) {
180     // To change the approve amount you first have to reduce the addresses`
181     //  allowance to zero by calling `approve(_spender, 0)` if it is not
182     //  already 0 to mitigate the race condition described here:
183     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
184     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
185     allowed[msg.sender][_spender] = _value;
186     Approval(msg.sender, _spender, _value);
187   }
188 
189   /**
190    * @dev Function to check the amount of tokens than an owner allowed to a spender.
191    * @param _owner address The address which owns the funds.
192    * @param _spender address The address which will spend the funds.
193    * @return A uint specifing the amount of tokens still avaible for the spender.
194    */
195   function allowance(address _owner, address _spender) constant returns (uint remaining) {
196     return allowed[_owner][_spender];
197   }
198 }
199 
200 contract Controlled {
201 
202   address public controller;
203 
204   function Controlled() {
205     controller = msg.sender;
206   }
207 
208   function changeController(address _controller) onlyController {
209     controller = _controller;
210   }
211 
212   modifier onlyController {
213     if (msg.sender != controller) throw;
214     _;
215   }
216 }
217 
218 
219 /**
220  * @title Mintable token
221  * @dev Simple ERC20 Token example, with mintable token creation
222  */
223 contract MintableToken is StandardToken, Controlled {
224 
225   event Mint(address indexed to, uint value);
226   event MintFinished();
227 
228   bool public mintingFinished = false;
229   uint public totalSupply = 0;
230 
231   /**
232    * @dev Function to mint tokens
233    * @param _to The address that will recieve the minted tokens.
234    * @param _amount The amount of tokens to mint.
235    * @return A boolean that indicates if the operation was successful.
236    */
237   function mint(address _to, uint _amount) onlyController canMint returns (bool) {
238     totalSupply = totalSupply.add(_amount);
239     balances[_to] = balances[_to].add(_amount);
240     Mint(_to, _amount);
241     return true;
242   }
243 
244   /**
245    * @dev Function to stop minting new tokens.
246    * @return True if the operation was successful.
247    */
248   function finishMinting() onlyController returns (bool) {
249     mintingFinished = true;
250     MintFinished();
251     return true;
252   }
253 
254   modifier canMint() {
255     if (mintingFinished) throw;
256     _;
257   }
258 }
259 
260 /**
261  * @title LimitedTransferToken
262  * @dev LimitedTransferToken defines the generic interface and the implementation to limit token
263  * transferability for different events. It is intended to be used as a base class for other token
264  * contracts.
265  * LimitedTransferToken has been designed to allow for different limiting factors,
266  * this can be achieved by recursively calling super.transferableTokens() until the base class is
267  * hit. For example:
268  *     function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
269  *       return min256(unlockedTokens, super.transferableTokens(holder, time));
270  *     }
271  * A working example is VestedToken.sol:
272  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/VestedToken.sol
273  */
274 contract LimitedTransferToken is ERC20 {
275 
276   /**
277    * @dev Checks whether it can transfer or otherwise throws.
278    */
279   modifier canTransfer(address _sender, uint _value) {
280    if (_value > transferableTokens(_sender, uint64(now))) throw;
281    _;
282   }
283 
284   /**
285    * @dev Checks modifier and allows transfer if tokens are not locked.
286    * @param _to The address that will recieve the tokens.
287    * @param _value The amount of tokens to be transferred.
288    */
289   function transfer(address _to, uint _value) canTransfer(msg.sender, _value) {
290     super.transfer(_to, _value);
291   }
292 
293   /**
294   * @dev Checks modifier and allows transfer if tokens are not locked.
295   * @param _from The address that will send the tokens.
296   * @param _to The address that will recieve the tokens.
297   * @param _value The amount of tokens to be transferred.
298   */
299   function transferFrom(address _from, address _to, uint _value) canTransfer(_from, _value) {
300     super.transferFrom(_from, _to, _value);
301   }
302 
303   /**
304    * @dev Default transferable tokens function returns all tokens for a holder (no limit).
305    * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the
306    * specific logic for limiting token transferability for a holder over time.
307    */
308   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
309     return balanceOf(holder);
310   }
311 }
312 
313 
314 /**
315  * @title Vested token
316  * @dev Tokens that can be vested for a group of addresses.
317  */
318 contract VestedToken is StandardToken, LimitedTransferToken {
319 
320   uint256 MAX_GRANTS_PER_ADDRESS = 20;
321 
322   struct TokenGrant {
323     address granter;     // 20 bytes
324     uint256 value;       // 32 bytes
325     uint64 cliff;
326     uint64 vesting;
327     uint64 start;        // 3 * 8 = 24 bytes
328     bool revokable;
329     bool burnsOnRevoke;  // 2 * 1 = 2 bits? or 2 bytes?
330   } // total 78 bytes = 3 sstore per operation (32 per sstore)
331 
332   mapping (address => TokenGrant[]) public grants;
333 
334   event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint256 grantId);
335 
336   /**
337    * @dev Grant tokens to a specified address
338    * @param _to address The address which the tokens will be granted to.
339    * @param _value uint256 The amount of tokens to be granted.
340    * @param _start uint64 Time of the beginning of the grant.
341    * @param _cliff uint64 Time of the cliff period.
342    * @param _vesting uint64 The vesting period.
343    * @param _revokable bool If the grant is revokable.
344    * @param _burnsOnRevoke bool When true, the tokens are burned if revoked.
345    */
346   function grantVestedTokens(
347     address _to,
348     uint256 _value,
349     uint64 _start,
350     uint64 _cliff,
351     uint64 _vesting,
352     bool _revokable,
353     bool _burnsOnRevoke
354   ) public {
355 
356     // Check for date inconsistencies that may cause unexpected behavior
357     if (_cliff < _start || _vesting < _cliff) {
358       throw;
359     }
360 
361     if (tokenGrantsCount(_to) > MAX_GRANTS_PER_ADDRESS) throw;  // To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).
362 
363     uint count = grants[_to].push(
364                 TokenGrant(
365                   _revokable ? msg.sender : 0,  // avoid storing an extra 20 bytes when it is non-revokable
366                   _value,
367                   _cliff,
368                   _vesting,
369                   _start,
370                   _revokable,
371                   _burnsOnRevoke
372                 )
373               );
374     transfer(_to, _value);
375     NewTokenGrant(msg.sender, _to, _value, count - 1);
376   }
377 
378   /**
379    * @dev Revoke the grant of tokens of a specifed address.
380    * @param _holder The address which will have its tokens revoked.
381    * @param _grantId The id of the token grant.
382    */
383   function revokeTokenGrant(address _holder, uint _grantId) public {
384     TokenGrant grant = grants[_holder][_grantId];
385 
386     if (!grant.revokable) { // Check if grant was revokable
387       throw;
388     }
389 
390     if (grant.granter != msg.sender) { // Only granter can revoke it
391       throw;
392     }
393 
394     address receiver = grant.burnsOnRevoke ? 0xdead : msg.sender;
395     uint256 nonVested = nonVestedTokens(grant, uint64(now));
396 
397     // remove grant from array
398     delete grants[_holder][_grantId];
399     grants[_holder][_grantId] = grants[_holder][grants[_holder].length.sub(1)];
400     grants[_holder].length -= 1;
401 
402     balances[receiver] = balances[receiver].add(nonVested);
403     balances[_holder] = balances[_holder].sub(nonVested);
404 
405     Transfer(_holder, receiver, nonVested);
406   }
407 
408   /**
409    * @dev Calculate the total amount of transferable tokens of a holder at a given time
410    * @param holder address The address of the holder
411    * @param time uint64 The specific time.
412    * @return An uint representing a holder's total amount of transferable tokens.
413    */
414   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
415     uint256 grantIndex = tokenGrantsCount(holder);
416     if (grantIndex == 0) return balanceOf(holder); // shortcut for holder without grants
417 
418     // Iterate through all the grants the holder has, and add all non-vested tokens
419     uint256 nonVested = 0;
420     for (uint256 i = 0; i < grantIndex; i++) {
421       nonVested = nonVested.add(nonVestedTokens(grants[holder][i], time));
422     }
423 
424     // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time
425     uint256 vestedTransferable = balanceOf(holder).sub(nonVested);
426 
427     // Return the minimum of how many vested can transfer and other value
428     // in case there are other limiting transferability factors (default is balanceOf)
429     return SafeMath.min256(vestedTransferable, super.transferableTokens(holder, time));
430   }
431 
432   /**
433    * @dev Check the amount of grants that an address has.
434    * @param _holder The holder of the grants.
435    * @return A uint representing the total amount of grants.
436    */
437   function tokenGrantsCount(address _holder) constant returns (uint index) {
438     return grants[_holder].length;
439   }
440 
441   /**
442    * @dev Calculate amount of vested tokens at a specifc time.
443    * @param tokens uint256 The amount of tokens grantted.
444    * @param time uint64 The time to be checked
445    * @param start uint64 A time representing the begining of the grant
446    * @param cliff uint64 The cliff period.
447    * @param vesting uint64 The vesting period.
448    * @return An uint representing the amount of vested tokensof a specif grant.
449    *  transferableTokens
450    *   |                         _/--------   vestedTokens rect
451    *   |                       _/
452    *   |                     _/
453    *   |                   _/
454    *   |                 _/
455    *   |                /
456    *   |              .|
457    *   |            .  |
458    *   |          .    |
459    *   |        .      |
460    *   |      .        |(grants[_holder] == address(0)) return 0;
461    *   |    .          |
462    *   +===+===========+---------+----------> time
463    *      Start       Clift    Vesting
464    */
465   function calculateVestedTokens(
466     uint256 tokens,
467     uint256 time,
468     uint256 start,
469     uint256 cliff,
470     uint256 vesting) constant returns (uint256)
471     {
472       // Shortcuts for before cliff and after vesting cases.
473       if (time < cliff) return 0;
474       if (time >= vesting) return tokens;
475 
476       // Interpolate all vested tokens.
477       // As before cliff the shortcut returns 0, we can use just calculate a value
478       // in the vesting rect (as shown in above's figure)
479 
480       // vestedTokens = tokens * (time - start) / (vesting - start)
481       uint256 vestedTokens = tokens.mul(time.sub(start)).div(vesting.sub(start));
482       return vestedTokens;
483   }
484 
485   /**
486    * @dev Get all information about a specifc grant.
487    * @param _holder The address which will have its tokens revoked.
488    * @param _grantId The id of the token grant.
489    * @return Returns all the values that represent a TokenGrant(address, value, start, cliff,
490    * revokability, burnsOnRevoke, and vesting) plus the vested value at the current time.
491    */
492   function tokenGrant(address _holder, uint _grantId) constant returns (address granter, uint256 value, uint256 vested, uint64 start, uint64 cliff, uint64 vesting, bool revokable, bool burnsOnRevoke) {
493     TokenGrant grant = grants[_holder][_grantId];
494 
495     granter = grant.granter;
496     value = grant.value;
497     start = grant.start;
498     cliff = grant.cliff;
499     vesting = grant.vesting;
500     revokable = grant.revokable;
501     burnsOnRevoke = grant.burnsOnRevoke;
502 
503     vested = vestedTokens(grant, uint64(now));
504   }
505 
506   /**
507    * @dev Get the amount of vested tokens at a specific time.
508    * @param grant TokenGrant The grant to be checked.
509    * @param time The time to be checked
510    * @return An uint representing the amount of vested tokens of a specific grant at a specific time.
511    */
512   function vestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
513     return calculateVestedTokens(
514       grant.value,
515       uint256(time),
516       uint256(grant.start),
517       uint256(grant.cliff),
518       uint256(grant.vesting)
519     );
520   }
521 
522   /**
523    * @dev Calculate the amount of non vested tokens at a specific time.
524    * @param grant TokenGrant The grant to be checked.
525    * @param time uint64 The time to be checked
526    * @return An uint representing the amount of non vested tokens of a specifc grant on the
527    * passed time frame.
528    */
529   function nonVestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
530     return grant.value.sub(vestedTokens(grant, time));
531   }
532 
533   /**
534    * @dev Calculate the date when the holder can trasfer all its tokens
535    * @param holder address The address of the holder
536    * @return An uint representing the date of the last transferable tokens.
537    */
538   function lastTokenIsTransferableDate(address holder) constant public returns (uint64 date) {
539     date = uint64(now);
540     uint256 grantIndex = grants[holder].length;
541     for (uint256 i = 0; i < grantIndex; i++) {
542       date = SafeMath.max64(grants[holder][i].vesting, date);
543     }
544   }
545 }
546 
547 
548 /// @title Artcoin (ART) - democratizing culture.
549 contract Artcoin is MintableToken, VestedToken {
550 
551   string public constant name = 'Artcoin';
552   string public constant symbol = 'ART';
553   uint public constant decimals = 18;
554 
555   function() public payable {
556     if (isContract(controller)) {
557       if (!Controller(controller).proxyPayment.value(msg.value)(msg.sender)) throw;
558     } else {
559       throw;
560     }
561   }
562 
563   function isContract(address _addr) constant internal returns(bool) {
564     uint size;
565     if (_addr == address(0)) return false;
566     assembly {
567       size := extcodesize(_addr)
568     }
569     return size > 0;
570   }
571 }