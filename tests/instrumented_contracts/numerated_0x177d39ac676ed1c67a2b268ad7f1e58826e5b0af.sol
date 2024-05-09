1 pragma solidity ^0.4.8;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7   function mul(uint a, uint b) internal returns (uint) {
8     uint c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint a, uint b) internal returns (uint) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint a, uint b) internal returns (uint) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint a, uint b) internal returns (uint) {
26     uint c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 
31   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
32     return a >= b ? a : b;
33   }
34 
35   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
36     return a < b ? a : b;
37   }
38 
39   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
40     return a >= b ? a : b;
41   }
42 
43   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
44     return a < b ? a : b;
45   }
46 
47   function assert(bool assertion) internal {
48     if (!assertion) {
49       throw;
50     }
51   }
52 }
53 
54 /**
55  * @title ERC20Basic
56  * @dev Simpler version of ERC20 interface
57  * @dev see https://github.com/ethereum/EIPs/issues/20
58  */
59 contract ERC20Basic {
60   uint public totalSupply;
61   function balanceOf(address who) constant returns (uint);
62   function transfer(address to, uint value);
63   event Transfer(address indexed from, address indexed to, uint value);
64 }
65 
66 /**
67  * @title ERC20 interface
68  * @dev see https://github.com/ethereum/EIPs/issues/20
69  */
70 contract ERC20 is ERC20Basic {
71   function allowance(address owner, address spender) constant returns (uint);
72   function transferFrom(address from, address to, uint value);
73   function approve(address spender, uint value);
74   event Approval(address indexed owner, address indexed spender, uint value);
75 }
76 
77 
78 /**
79  * @title LimitedTransferToken
80  * @dev LimitedTransferToken defines the generic interface and the implementation to limit token 
81  * transferability for different events. It is intended to be used as a base class for other token 
82  * contracts. 
83  * LimitedTransferToken has been designed to allow for different limiting factors,
84  * this can be achieved by recursively calling super.transferableTokens() until the base class is 
85  * hit. For example:
86  *     function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
87  *       return min256(unlockedTokens, super.transferableTokens(holder, time));
88  *     }
89  * A working example is VestedToken.sol:
90  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/VestedToken.sol
91  */
92 
93 contract LimitedTransferToken is ERC20 {
94 
95   /**
96    * @dev Checks whether it can transfer or otherwise throws.
97    */
98   modifier canTransfer(address _sender, uint _value) {
99    if (_value > transferableTokens(_sender, uint64(now))) throw;
100    _;
101   }
102 
103   /**
104    * @dev Checks modifier and allows transfer if tokens are not locked.
105    * @param _to The address that will recieve the tokens.
106    * @param _value The amount of tokens to be transferred.
107    */
108   function transfer(address _to, uint _value) canTransfer(msg.sender, _value) {
109    return super.transfer(_to, _value);
110   }
111 
112   /**
113   * @dev Checks modifier and allows transfer if tokens are not locked.
114   * @param _from The address that will send the tokens.
115   * @param _to The address that will recieve the tokens.
116   * @param _value The amount of tokens to be transferred.
117   */
118   function transferFrom(address _from, address _to, uint _value) canTransfer(_from, _value) {
119    return super.transferFrom(_from, _to, _value);
120   }
121 
122   /**
123    * @dev Default transferable tokens function returns all tokens for a holder (no limit).
124    * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the 
125    * specific logic for limiting token transferability for a holder over time.
126    */
127   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
128     return balanceOf(holder);
129   }
130 }
131 
132 
133 /**
134  * @title Basic token
135  * @dev Basic version of StandardToken, with no allowances. 
136  */
137 contract BasicToken is ERC20Basic {
138   using SafeMath for uint;
139 
140   mapping(address => uint) balances;
141 
142   /**
143    * @dev Fix for the ERC20 short address attack.
144    */
145   modifier onlyPayloadSize(uint size) {
146      if(msg.data.length < size + 4) {
147        throw;
148      }
149      _;
150   }
151 
152   /**
153   * @dev transfer token for a specified address
154   * @param _to The address to transfer to.
155   * @param _value The amount to be transferred.
156   */
157   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
158     balances[msg.sender] = balances[msg.sender].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     Transfer(msg.sender, _to, _value);
161   }
162 
163   /**
164   * @dev Gets the balance of the specified address.
165   * @param _owner The address to query the the balance of. 
166   * @return An uint representing the amount owned by the passed address.
167   */
168   function balanceOf(address _owner) constant returns (uint balance) {
169     return balances[_owner];
170   }
171 
172 }
173 
174 
175 /**
176  * @title Standard ERC20 token
177  *
178  * @dev Implemantation of the basic standart token.
179  * @dev https://github.com/ethereum/EIPs/issues/20
180  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
181  */
182 contract StandardToken is BasicToken, ERC20 {
183 
184   mapping (address => mapping (address => uint)) allowed;
185 
186 
187   /**
188    * @dev Transfer tokens from one address to another
189    * @param _from address The address which you want to send tokens from
190    * @param _to address The address which you want to transfer to
191    * @param _value uint the amout of tokens to be transfered
192    */
193   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
194     var _allowance = allowed[_from][msg.sender];
195 
196     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
197     // if (_value > _allowance) throw;
198 
199     balances[_to] = balances[_to].add(_value);
200     balances[_from] = balances[_from].sub(_value);
201     allowed[_from][msg.sender] = _allowance.sub(_value);
202     Transfer(_from, _to, _value);
203   }
204 
205   /**
206    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
207    * @param _spender The address which will spend the funds.
208    * @param _value The amount of tokens to be spent.
209    */
210   function approve(address _spender, uint _value) {
211 
212     // To change the approve amount you first have to reduce the addresses`
213     //  allowance to zero by calling `approve(_spender, 0)` if it is not
214     //  already 0 to mitigate the race condition described here:
215     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
216     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
217 
218     allowed[msg.sender][_spender] = _value;
219     Approval(msg.sender, _spender, _value);
220   }
221 
222   /**
223    * @dev Function to check the amount of tokens than an owner allowed to a spender.
224    * @param _owner address The address which owns the funds.
225    * @param _spender address The address which will spend the funds.
226    * @return A uint specifing the amount of tokens still avaible for the spender.
227    */
228   function allowance(address _owner, address _spender) constant returns (uint remaining) {
229     return allowed[_owner][_spender];
230   }
231 
232 }
233 
234 
235 /**
236  * @title Vested token
237  * @dev Tokens that can be vested for a group of addresses.
238  */
239 contract VestedToken is StandardToken, LimitedTransferToken {
240 
241   uint256 MAX_GRANTS_PER_ADDRESS = 20;
242 
243   struct TokenGrant {
244     address granter;     // 20 bytes
245     uint256 value;       // 32 bytes
246     uint64 cliff;
247     uint64 vesting;
248     uint64 start;        // 3 * 8 = 24 bytes
249     bool revokable;
250     bool burnsOnRevoke;  // 2 * 1 = 2 bits? or 2 bytes?
251   } // total 78 bytes = 3 sstore per operation (32 per sstore)
252 
253   mapping (address => TokenGrant[]) public grants;
254 
255   event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint256 grantId);
256 
257   /**
258    * @dev Grant tokens to a specified address
259    * @param _to address The address which the tokens will be granted to.
260    * @param _value uint256 The amount of tokens to be granted.
261    * @param _start uint64 Time of the beginning of the grant.
262    * @param _cliff uint64 Time of the cliff period.
263    * @param _vesting uint64 The vesting period.
264    */
265   function grantVestedTokens(
266     address _to,
267     uint256 _value,
268     uint64 _start,
269     uint64 _cliff,
270     uint64 _vesting,
271     bool _revokable,
272     bool _burnsOnRevoke
273   ) public {
274 
275     // Check for date inconsistencies that may cause unexpected behavior
276     if (_cliff < _start || _vesting < _cliff) {
277       throw;
278     }
279 
280     if (tokenGrantsCount(_to) > MAX_GRANTS_PER_ADDRESS) throw;   // To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).
281 
282     uint count = grants[_to].push(
283                 TokenGrant(
284                   _revokable ? msg.sender : 0, // avoid storing an extra 20 bytes when it is non-revokable
285                   _value,
286                   _cliff,
287                   _vesting,
288                   _start,
289                   _revokable,
290                   _burnsOnRevoke
291                 )
292               );
293 
294     transfer(_to, _value);
295 
296     NewTokenGrant(msg.sender, _to, _value, count - 1);
297   }
298 
299   /**
300    * @dev Revoke the grant of tokens of a specifed address.
301    * @param _holder The address which will have its tokens revoked.
302    * @param _grantId The id of the token grant.
303    */
304   function revokeTokenGrant(address _holder, uint _grantId) public {
305     TokenGrant grant = grants[_holder][_grantId];
306 
307     if (!grant.revokable) { // Check if grant was revokable
308       throw;
309     }
310 
311     if (grant.granter != msg.sender) { // Only granter can revoke it
312       throw;
313     }
314 
315     address receiver = grant.burnsOnRevoke ? 0xdead : msg.sender;
316 
317     uint256 nonVested = nonVestedTokens(grant, uint64(now));
318 
319     // remove grant from array
320     delete grants[_holder][_grantId];
321     grants[_holder][_grantId] = grants[_holder][grants[_holder].length.sub(1)];
322     grants[_holder].length -= 1;
323 
324     balances[receiver] = balances[receiver].add(nonVested);
325     balances[_holder] = balances[_holder].sub(nonVested);
326 
327     Transfer(_holder, receiver, nonVested);
328   }
329 
330 
331   /**
332    * @dev Calculate the total amount of transferable tokens of a holder at a given time
333    * @param holder address The address of the holder
334    * @param time uint64 The specific time.
335    * @return An uint representing a holder's total amount of transferable tokens.
336    */
337   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
338     uint256 grantIndex = tokenGrantsCount(holder);
339 
340     if (grantIndex == 0) return balanceOf(holder); // shortcut for holder without grants
341 
342     // Iterate through all the grants the holder has, and add all non-vested tokens
343     uint256 nonVested = 0;
344     for (uint256 i = 0; i < grantIndex; i++) {
345       nonVested = SafeMath.add(nonVested, nonVestedTokens(grants[holder][i], time));
346     }
347 
348     // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time
349     uint256 vestedTransferable = SafeMath.sub(balanceOf(holder), nonVested);
350 
351     // Return the minimum of how many vested can transfer and other value
352     // in case there are other limiting transferability factors (default is balanceOf)
353     return SafeMath.min256(vestedTransferable, super.transferableTokens(holder, time));
354   }
355 
356   /**
357    * @dev Check the amount of grants that an address has.
358    * @param _holder The holder of the grants.
359    * @return A uint representing the total amount of grants.
360    */
361   function tokenGrantsCount(address _holder) constant returns (uint index) {
362     return grants[_holder].length;
363   }
364 
365   /**
366    * @dev Calculate amount of vested tokens at a specifc time.
367    * @param tokens uint256 The amount of tokens grantted.
368    * @param time uint64 The time to be checked
369    * @param start uint64 A time representing the begining of the grant
370    * @param cliff uint64 The cliff period.
371    * @param vesting uint64 The vesting period.
372    * @return An uint representing the amount of vested tokensof a specif grant.
373    *  transferableTokens
374    *   |                         _/--------   vestedTokens rect
375    *   |                       _/
376    *   |                     _/
377    *   |                   _/
378    *   |                 _/
379    *   |                /
380    *   |              .|
381    *   |            .  |
382    *   |          .    |
383    *   |        .      |
384    *   |      .        |
385    *   |    .          |
386    *   +===+===========+---------+----------> time
387    *      Start       Clift    Vesting
388    */
389   function calculateVestedTokens(
390     uint256 tokens,
391     uint256 time,
392     uint256 start,
393     uint256 cliff,
394     uint256 vesting) constant returns (uint256)
395     {
396       // Shortcuts for before cliff and after vesting cases.
397       if (time < cliff) return 0;
398       if (time >= vesting) return tokens;
399 
400       // Interpolate all vested tokens.
401       // As before cliff the shortcut returns 0, we can use just calculate a value
402       // in the vesting rect (as shown in above's figure)
403 
404       // vestedTokens = tokens * (time - start) / (vesting - start)
405       uint256 vestedTokens = SafeMath.div(
406                                     SafeMath.mul(
407                                       tokens,
408                                       SafeMath.sub(time, start)
409                                       ),
410                                     SafeMath.sub(vesting, start)
411                                     );
412 
413       return vestedTokens;
414   }
415 
416   /**
417    * @dev Get all information about a specifc grant.
418    * @param _holder The address which will have its tokens revoked.
419    * @param _grantId The id of the token grant.
420    * @return Returns all the values that represent a TokenGrant(address, value, start, cliff,
421    * revokability, burnsOnRevoke, and vesting) plus the vested value at the current time.
422    */
423   function tokenGrant(address _holder, uint _grantId) constant returns (address granter, uint256 value, uint256 vested, uint64 start, uint64 cliff, uint64 vesting, bool revokable, bool burnsOnRevoke) {
424     TokenGrant grant = grants[_holder][_grantId];
425 
426     granter = grant.granter;
427     value = grant.value;
428     start = grant.start;
429     cliff = grant.cliff;
430     vesting = grant.vesting;
431     revokable = grant.revokable;
432     burnsOnRevoke = grant.burnsOnRevoke;
433 
434     vested = vestedTokens(grant, uint64(now));
435   }
436 
437   /**
438    * @dev Get the amount of vested tokens at a specific time.
439    * @param grant TokenGrant The grant to be checked.
440    * @param time The time to be checked
441    * @return An uint representing the amount of vested tokens of a specific grant at a specific time.
442    */
443   function vestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
444     return calculateVestedTokens(
445       grant.value,
446       uint256(time),
447       uint256(grant.start),
448       uint256(grant.cliff),
449       uint256(grant.vesting)
450     );
451   }
452 
453   /**
454    * @dev Calculate the amount of non vested tokens at a specific time.
455    * @param grant TokenGrant The grant to be checked.
456    * @param time uint64 The time to be checked
457    * @return An uint representing the amount of non vested tokens of a specifc grant on the 
458    * passed time frame.
459    */
460   function nonVestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
461     return grant.value.sub(vestedTokens(grant, time));
462   }
463 
464   /**
465    * @dev Calculate the date when the holder can trasfer all its tokens
466    * @param holder address The address of the holder
467    * @return An uint representing the date of the last transferable tokens.
468    */
469   function lastTokenIsTransferableDate(address holder) constant public returns (uint64 date) {
470     date = uint64(now);
471     uint256 grantIndex = grants[holder].length;
472     for (uint256 i = 0; i < grantIndex; i++) {
473       date = SafeMath.max64(grants[holder][i].vesting, date);
474     }
475   }
476 }
477 
478 contract CDTToken is VestedToken {
479 	using SafeMath for uint;
480 
481 	//FIELDS
482 	//CONSTANTS
483 	uint public constant decimals = 18;  // 18 decimal places, the same as ETH.
484 	string public constant name = "CoinDash Token";
485   	string public constant symbol = "CDT";
486 
487 	//ASSIGNED IN INITIALIZATION
488 	address public creator; //address of the account which may mint new tokens
489 
490 	//May only be called by the owner address
491 	modifier only_owner() {
492 		if (msg.sender != creator) throw;
493 		_;
494 	}
495 
496 
497 	// Initialization contract assigns address of crowdfund contract and end time.
498 	function CDTToken(uint supply) {
499 		totalSupply = supply;
500 		creator = msg.sender;
501 		
502 		balances[msg.sender] = supply;
503 
504 		MAX_GRANTS_PER_ADDRESS = 2;
505 	}
506 
507 	// Fallback function throws when called.
508 	function() {
509 		throw;
510 	}
511 
512 	function vestedBalanceOf(address _owner) constant returns (uint balance) {
513 	    return transferableTokens(_owner, uint64(now));
514     }
515 
516         //failsafe drain
517 	function drain()
518 		only_owner
519 	{
520 		if (!creator.send(this.balance)) throw;
521 	}
522 }