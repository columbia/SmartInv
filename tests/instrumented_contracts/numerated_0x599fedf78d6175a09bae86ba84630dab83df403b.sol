1 pragma solidity ^0.4.18;
2 
3 
4 
5 /**
6  * Math operations with safety checks
7  */
8 library SafeMath {
9   function mul(uint a, uint b) internal pure returns (uint) {
10     uint c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint a, uint b) internal pure returns (uint) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
19     return c;
20   }
21 
22   function sub(uint a, uint b) internal pure returns (uint) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint a, uint b) internal pure returns (uint) {
28     uint c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 
33   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
34     return a >= b ? a : b;
35   }
36 
37   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
38     return a < b ? a : b;
39   }
40 
41   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
42     return a >= b ? a : b;
43   }
44 
45   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
46     return a < b ? a : b;
47   }
48 }
49 
50 
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/20
55  */
56 contract ERC20Basic {
57   uint public totalSupply;
58   function balanceOf(address who) public constant returns (uint);
59   function transfer(address to, uint value) public;
60   event Transfer(address indexed from, address indexed to, uint value);
61 }
62 
63 
64 
65 
66 /**
67  * @title Basic token
68  * @dev Basic version of StandardToken, with no allowances. 
69  */
70 contract BasicToken is ERC20Basic {
71   using SafeMath for uint;
72 
73   mapping(address => uint) balances;
74 
75   /**
76    * @dev Fix for the ERC20 short address attack.
77    */
78   modifier onlyPayloadSize(uint size) {
79      if(msg.data.length < size + 4) {
80        revert();
81      }
82      _;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
91     balances[msg.sender] = balances[msg.sender].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     Transfer(msg.sender, _to, _value);
94   }
95 
96   /**
97   * @dev Gets the balance of the specified address.
98   * @param _owner The address to query the the balance of. 
99   * @return An uint representing the amount owned by the passed address.
100   */
101   function balanceOf(address _owner) public constant returns (uint balance) {
102     return balances[_owner];
103   }
104 
105 }
106 
107 
108 
109 
110 /**
111  * @title ERC20 interface
112  * @dev see https://github.com/ethereum/EIPs/issues/20
113  */
114 contract ERC20 is ERC20Basic {
115   function allowance(address owner, address spender) public constant returns (uint);
116   function transferFrom(address from, address to, uint value) public;
117   function approve(address spender, uint value) public;
118   event Approval(address indexed owner, address indexed spender, uint value);
119 }
120 
121 
122 
123 
124 /**
125  * @title Standard ERC20 token
126  *
127  * @dev Implemantation of the basic standart token.
128  * @dev https://github.com/ethereum/EIPs/issues/20
129  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
130  */
131 contract StandardToken is BasicToken, ERC20 {
132 
133   mapping (address => mapping (address => uint)) allowed;
134 
135 
136   /**
137    * @dev Transfer tokens from one address to another
138    * @param _from address The address which you want to send tokens from
139    * @param _to address The address which you want to transfer to
140    * @param _value uint the amout of tokens to be transfered
141    */
142   function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
143     uint _allowance = allowed[_from][msg.sender];
144 
145     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
146     // if (_value > _allowance) revert();
147 
148     balances[_to] = balances[_to].add(_value);
149     balances[_from] = balances[_from].sub(_value);
150     allowed[_from][msg.sender] = _allowance.sub(_value);
151     Transfer(_from, _to, _value);
152   }
153 
154   /**
155    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
156    * @param _spender The address which will spend the funds.
157    * @param _value The amount of tokens to be spent.
158    */
159   function approve(address _spender, uint _value) public {
160 
161     // To change the approve amount you first have to reduce the addresses`
162     //  allowance to zero by calling `approve(_spender, 0)` if it is not
163     //  already 0 to mitigate the race condition described here:
164     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
166 
167     allowed[msg.sender][_spender] = _value;
168     Approval(msg.sender, _spender, _value);
169   }
170 
171   /**
172    * @dev Function to check the amount of tokens than an owner allowed to a spender.
173    * @param _owner address The address which owns the funds.
174    * @param _spender address The address which will spend the funds.
175    * @return A uint specifing the amount of tokens still avaible for the spender.
176    */
177   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
178     return allowed[_owner][_spender];
179   }
180 
181 }
182 
183 
184 /**
185  * @title LimitedTransferToken
186  * @dev LimitedTransferToken defines the generic interface and the implementation to limit token 
187  * transferability for different events. It is intended to be used as a base class for other token 
188  * contracts. 
189  * LimitedTransferToken has been designed to allow for different limiting factors,
190  * this can be achieved by recursively calling super.transferableTokens() until the base class is 
191  * hit. For example:
192  *     function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
193  *       return min256(unlockedTokens, super.transferableTokens(holder, time));
194  *     }
195  * A working example is VestedToken.sol:
196  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/VestedToken.sol
197  */
198 
199 contract LimitedTransferToken is ERC20 {
200 
201   /**
202    * @dev Checks whether it can transfer or otherwise throws.
203    */
204   modifier canTransfer(address _sender, uint _value) {
205    if (_value > transferableTokens(_sender, uint64(now))) revert();
206    _;
207   }
208 
209   /**
210    * @dev Checks modifier and allows transfer if tokens are not locked.
211    * @param _to The address that will recieve the tokens.
212    * @param _value The amount of tokens to be transferred.
213    */
214   function transfer(address _to, uint _value) public canTransfer(msg.sender, _value) {
215     super.transfer(_to, _value);
216   }
217 
218   /**
219   * @dev Checks modifier and allows transfer if tokens are not locked.
220   * @param _from The address that will send the tokens.
221   * @param _to The address that will recieve the tokens.
222   * @param _value The amount of tokens to be transferred.
223   */
224   function transferFrom(address _from, address _to, uint _value) public canTransfer(_from, _value) {
225     super.transferFrom(_from, _to, _value);
226   }
227 
228   /**
229    * @dev Default transferable tokens function returns all tokens for a holder (no limit).
230    * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the 
231    * specific logic for limiting token transferability for a holder over time.
232    */
233   function transferableTokens(address holder, uint64 /* time */) constant public returns (uint256) {
234     return balanceOf(holder);
235   }
236 }
237 
238 
239 /**
240  * @title Vested token
241  * @dev Tokens that can be vested for a group of addresses.
242  */
243 contract VestedToken is StandardToken, LimitedTransferToken {
244 
245   uint256 MAX_GRANTS_PER_ADDRESS = 20;
246 
247   struct TokenGrant {
248     address granter;     // 20 bytes
249     uint256 value;       // 32 bytes
250     uint64 cliff;
251     uint64 vesting;
252     uint64 start;        // 3 * 8 = 24 bytes
253     bool revokable;
254     bool burnsOnRevoke;  // 2 * 1 = 2 bits? or 2 bytes?
255   } // total 78 bytes = 3 sstore per operation (32 per sstore)
256 
257   mapping (address => TokenGrant[]) public grants;
258 
259   event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint256 grantId);
260 
261   /**
262    * @dev Grant tokens to a specified address
263    * @param _to address The address which the tokens will be granted to.
264    * @param _value uint256 The amount of tokens to be granted.
265    * @param _start uint64 Time of the beginning of the grant.
266    * @param _cliff uint64 Time of the cliff period.
267    * @param _vesting uint64 The vesting period.
268    */
269   function grantVestedTokens(
270     address _to,
271     uint256 _value,
272     uint64 _start,
273     uint64 _cliff,
274     uint64 _vesting,
275     bool _revokable,
276     bool _burnsOnRevoke
277   ) public {
278 
279     // Check for date inconsistencies that may cause unexpected behavior
280     if (_cliff < _start || _vesting < _cliff) {
281       revert();
282     }
283 
284     if (tokenGrantsCount(_to) > MAX_GRANTS_PER_ADDRESS) revert();   // To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).
285 
286     uint count = grants[_to].push(
287                 TokenGrant(
288                   _revokable ? msg.sender : 0, // avoid storing an extra 20 bytes when it is non-revokable
289                   _value,
290                   _cliff,
291                   _vesting,
292                   _start,
293                   _revokable,
294                   _burnsOnRevoke
295                 )
296               );
297 
298     transfer(_to, _value);
299 
300     NewTokenGrant(msg.sender, _to, _value, count - 1);
301   }
302 
303   /**
304    * @dev Revoke the grant of tokens of a specifed address.
305    * @param _holder The address which will have its tokens revoked.
306    * @param _grantId The id of the token grant.
307    */
308   function revokeTokenGrant(address _holder, uint _grantId) public {
309     TokenGrant storage grant = grants[_holder][_grantId];
310 
311     if (!grant.revokable) { // Check if grant was revokable
312       revert();
313     }
314 
315     if (grant.granter != msg.sender) { // Only granter can revoke it
316       revert();
317     }
318 
319     address receiver = grant.burnsOnRevoke ? 0xdead : msg.sender;
320 
321     uint256 nonVested = nonVestedTokens(grant, uint64(now));
322 
323     // remove grant from array
324     delete grants[_holder][_grantId];
325     grants[_holder][_grantId] = grants[_holder][grants[_holder].length.sub(1)];
326     grants[_holder].length -= 1;
327 
328     balances[receiver] = balances[receiver].add(nonVested);
329     balances[_holder] = balances[_holder].sub(nonVested);
330 
331     Transfer(_holder, receiver, nonVested);
332   }
333 
334 
335   /**
336    * @dev Calculate the total amount of transferable tokens of a holder at a given time
337    * @param holder address The address of the holder
338    * @param time uint64 The specific time.
339    * @return An uint representing a holder&#39;s total amount of transferable tokens.
340    */
341   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
342     uint256 grantIndex = tokenGrantsCount(holder);
343 
344     if (grantIndex == 0) return balanceOf(holder); // shortcut for holder without grants
345 
346     // Iterate through all the grants the holder has, and add all non-vested tokens
347     uint256 nonVested = 0;
348     for (uint256 i = 0; i < grantIndex; i++) {
349       nonVested = SafeMath.add(nonVested, nonVestedTokens(grants[holder][i], time));
350     }
351 
352     // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time
353     uint256 vestedTransferable = SafeMath.sub(balanceOf(holder), nonVested);
354 
355     // Return the minimum of how many vested can transfer and other value
356     // in case there are other limiting transferability factors (default is balanceOf)
357     return SafeMath.min256(vestedTransferable, super.transferableTokens(holder, time));
358   }
359 
360   /**
361    * @dev Check the amount of grants that an address has.
362    * @param _holder The holder of the grants.
363    * @return A uint representing the total amount of grants.
364    */
365   function tokenGrantsCount(address _holder) public constant returns (uint index) {
366     return grants[_holder].length;
367   }
368 
369   /**
370    * @dev Calculate amount of vested tokens at a specifc time.
371    * @param tokens uint256 The amount of tokens grantted.
372    * @param time uint64 The time to be checked
373    * @param start uint64 A time representing the begining of the grant
374    * @param cliff uint64 The cliff period.
375    * @param vesting uint64 The vesting period.
376    * @return An uint representing the amount of vested tokensof a specif grant.
377    *  transferableTokens
378    *   |                         _/--------   vestedTokens rect
379    *   |                       _/
380    *   |                     _/
381    *   |                   _/
382    *   |                 _/
383    *   |                /
384    *   |              .|
385    *   |            .  |
386    *   |          .    |
387    *   |        .      |
388    *   |      .        |
389    *   |    .          |
390    *   +===+===========+---------+----------> time
391    *      Start       Clift    Vesting
392    */
393   function calculateVestedTokens(
394     uint256 tokens,
395     uint256 time,
396     uint256 start,
397     uint256 cliff,
398     uint256 vesting) public pure returns (uint256)
399     {
400       // Shortcuts for before cliff and after vesting cases.
401       if (time < cliff) return 0;
402       if (time >= vesting) return tokens;
403 
404       // Interpolate all vested tokens.
405       // As before cliff the shortcut returns 0, we can use just calculate a value
406       // in the vesting rect (as shown in above&#39;s figure)
407 
408       // vestedTokens = tokens * (time - start) / (vesting - start)
409       uint256 vestedTokens = SafeMath.div(
410                                     SafeMath.mul(
411                                       tokens,
412                                       SafeMath.sub(time, start)
413                                       ),
414                                     SafeMath.sub(vesting, start)
415                                     );
416 
417       return vestedTokens;
418   }
419 
420   /**
421    * @dev Get all information about a specifc grant.
422    * @param _holder The address which will have its tokens revoked.
423    * @param _grantId The id of the token grant.
424    * @return Returns all the values that represent a TokenGrant(address, value, start, cliff,
425    * revokability, burnsOnRevoke, and vesting) plus the vested value at the current time.
426    */
427   function tokenGrant(address _holder, uint _grantId) public constant returns (address granter, uint256 value, uint256 vested, uint64 start, uint64 cliff, uint64 vesting, bool revokable, bool burnsOnRevoke) {
428     TokenGrant storage grant = grants[_holder][_grantId];
429 
430     granter = grant.granter;
431     value = grant.value;
432     start = grant.start;
433     cliff = grant.cliff;
434     vesting = grant.vesting;
435     revokable = grant.revokable;
436     burnsOnRevoke = grant.burnsOnRevoke;
437 
438     vested = vestedTokens(grant, uint64(now));
439   }
440 
441   /**
442    * @dev Get the amount of vested tokens at a specific time.
443    * @param grant TokenGrant The grant to be checked.
444    * @param time The time to be checked
445    * @return An uint representing the amount of vested tokens of a specific grant at a specific time.
446    */
447   function vestedTokens(TokenGrant grant, uint64 time) private pure returns (uint256) {
448     return calculateVestedTokens(
449       grant.value,
450       uint256(time),
451       uint256(grant.start),
452       uint256(grant.cliff),
453       uint256(grant.vesting)
454     );
455   }
456 
457   /**
458    * @dev Calculate the amount of non vested tokens at a specific time.
459    * @param grant TokenGrant The grant to be checked.
460    * @param time uint64 The time to be checked
461    * @return An uint representing the amount of non vested tokens of a specifc grant on the 
462    * passed time frame.
463    */
464   function nonVestedTokens(TokenGrant grant, uint64 time) private pure returns (uint256) {
465     return grant.value.sub(vestedTokens(grant, time));
466   }
467 
468   /**
469    * @dev Calculate the date when the holder can trasfer all its tokens
470    * @param holder address The address of the holder
471    * @return An uint representing the date of the last transferable tokens.
472    */
473   function lastTokenIsTransferableDate(address holder) constant public returns (uint64 date) {
474     date = uint64(now);
475     uint256 grantIndex = grants[holder].length;
476     for (uint256 i = 0; i < grantIndex; i++) {
477       date = SafeMath.max64(grants[holder][i].vesting, date);
478     }
479   }
480 }
481 
482 // QUESTIONS FOR AUDITORS:
483 // - Considering we inherit from VestedToken, how much does that hit at our gas price?
484 
485 // vesting: 365 days, 365 days / 1 vesting
486 
487 
488 contract MACHToken is VestedToken {
489   //FIELDS
490   string public name = "Machdary";
491   string public symbol = "MACH";
492   uint public decimals = 18;
493   uint public INITIAL_SUPPLY = 990000000 * 1 ether;
494 
495   // Initialization contract grants msg.sender all of existing tokens.
496   function MACHToken() public {
497     totalSupply = INITIAL_SUPPLY;
498 
499     address toAddress = msg.sender;
500     balances[toAddress] = totalSupply;
501     grantVestedTokens(toAddress, totalSupply.div(100).mul(60), uint64(now), uint64(now), uint64(now), false, false);
502     grantVestedTokens(toAddress, totalSupply.div(100).mul(25), uint64(now), uint64(now) + 91 days , uint64(now) + 91 days, false, false);
503     grantVestedTokens(toAddress, totalSupply.div(100).mul(15), uint64(now), uint64(now) + 365 days , uint64(now) + 365 days, false, false);
504   }
505 
506   // Transfer amount of tokens from sender account to recipient.
507   function transfer(address _to, uint _value) public {
508     if (_to == msg.sender) return; // no-op, allow even during crowdsale, in order to work around using grantVestedTokens() while in crowdsale
509     super.transfer(_to, _value);
510   }
511 
512   // Transfer amount of tokens from a specified address to a recipient.
513   // Transfer amount of tokens from sender account to recipient.
514   function transferFrom(address _from, address _to, uint _value) public {
515     super.transferFrom(_from, _to, _value);
516   }
517 
518 }