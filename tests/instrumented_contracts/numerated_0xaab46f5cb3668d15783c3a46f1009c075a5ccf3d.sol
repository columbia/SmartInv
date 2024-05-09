1 pragma solidity ^0.4.21;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7     function mul(uint a, uint b) internal pure returns (uint) {
8         uint c = a * b;
9         assert(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function div(uint a, uint b) internal pure returns (uint) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
17         return c;
18     }
19 
20     function sub(uint a, uint b) internal pure returns (uint) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint a, uint b) internal pure returns (uint) {
26         uint c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 
31     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
32         return a >= b ? a : b;
33     }
34 
35     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
36         return a < b ? a : b;
37     }
38 
39     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
40         return a >= b ? a : b;
41     }
42 
43     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
44         return a < b ? a : b;
45     }
46 }
47 
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/20
53  */
54 contract ERC20Basic {
55     uint public totalSupply;
56     function balanceOf(address who) public view returns (uint);
57     function transfer(address to, uint value) public returns (bool);
58     event Transfer(address indexed from, address indexed to, uint value);
59 }
60 
61 
62 
63 
64 /**
65  * @title Basic token
66  * @dev Basic version of StandardToken, with no allowances. 
67  */
68 contract BasicToken is ERC20Basic {
69     using SafeMath for uint;
70 
71     mapping(address => uint) balances;
72 
73     /**
74      * @dev Fix for the ERC20 short address attack.
75      */
76     modifier onlyPayloadSize(uint size) {
77         if(msg.data.length < size + 4) {
78             revert();
79         }
80         _;
81     }
82 
83     /**
84     * @dev transfer token for a specified address
85     * @param _to The address to transfer to.
86     * @param _value The amount to be transferred.
87     */
88     function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) returns (bool) {
89         balances[msg.sender] = balances[msg.sender].sub(_value);
90         balances[_to] = balances[_to].add(_value);
91         emit Transfer(msg.sender, _to, _value);
92         return true;
93     }
94 
95     /**
96     * @dev Gets the balance of the specified address.
97     * @param _owner The address to query the the balance of. 
98     * @return An uint representing the amount owned by the passed address.
99     */
100     function balanceOf(address _owner) public view returns (uint balance) {
101         return balances[_owner];
102     }
103 
104 }
105 
106 
107 
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114     function allowance(address owner, address spender) public view returns (uint);
115     function transferFrom(address from, address to, uint value) public returns (bool);
116     function approve(address spender, uint value) public returns (bool);
117     event Approval(address indexed owner, address indexed spender, uint value);
118 }
119 
120 
121 
122 
123 /**
124  * @title Standard ERC20 token
125  *
126  * @dev Implemantation of the basic standart token.
127  * @dev https://github.com/ethereum/EIPs/issues/20
128  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
129  */
130 contract StandardToken is BasicToken, ERC20 {
131 
132     mapping (address => mapping (address => uint)) allowed;
133 
134 
135     /**
136      * @dev Transfer tokens from one address to another
137      * @param _from address The address which you want to send tokens from
138      * @param _to address The address which you want to transfer to
139      * @param _value uint the amout of tokens to be transfered
140      */
141     function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) returns (bool) {
142         uint _allowance = allowed[_from][msg.sender];
143 
144         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
145         // if (_value > _allowance) revert();
146 
147         balances[_to] = balances[_to].add(_value);
148         balances[_from] = balances[_from].sub(_value);
149         allowed[_from][msg.sender] = _allowance.sub(_value);
150         emit Transfer(_from, _to, _value);
151         return true;
152     }
153 
154     /**
155      * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
156      * @param _spender The address which will spend the funds.
157      * @param _value The amount of tokens to be spent.
158      */
159     function approve(address _spender, uint _value) public returns (bool) {
160 
161         // To change the approve amount you first have to reduce the addresses`
162         //    allowance to zero by calling `approve(_spender, 0)` if it is not
163         //    already 0 to mitigate the race condition described here:
164         //    https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
166 
167         allowed[msg.sender][_spender] = _value;
168         emit Approval(msg.sender, _spender, _value);
169         return true;
170     }
171 
172     /**
173      * @dev Function to check the amount of tokens than an owner allowed to a spender.
174      * @param _owner address The address which owns the funds.
175      * @param _spender address The address which will spend the funds.
176      * @return A uint specifing the amount of tokens still avaible for the spender.
177      */
178     function allowance(address _owner, address _spender) public view returns (uint remaining) {
179         return allowed[_owner][_spender];
180     }
181 
182 }
183 
184 
185 /**
186  * @title LimitedTransferToken
187  * @dev LimitedTransferToken defines the generic interface and the implementation to limit token 
188  * transferability for different events. It is intended to be used as a base class for other token 
189  * contracts. 
190  * LimitedTransferToken has been designed to allow for different limiting factors,
191  * this can be achieved by recursively calling super.transferableTokens() until the base class is 
192  * hit. For example:
193  *         function transferableTokens(address holder, uint time, uint number) constant public returns (uint256) {
194  *             return min256(unlockedTokens, super.transferableTokens(holder, time, number));
195  *         }
196  * A working example is VestedToken.sol:
197  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/VestedToken.sol
198  */
199 
200 contract LimitedTransferToken is ERC20 {
201 
202     /**
203      * @dev Checks whether it can transfer or otherwise throws.
204      */
205     modifier canTransfer(address _sender, uint _value) {
206         if (_value > transferableTokens(_sender, now, block.number)) revert();
207         _;
208     }
209 
210     /**
211      * @dev Checks modifier and allows transfer if tokens are not locked.
212      * @param _to The address that will recieve the tokens.
213      * @param _value The amount of tokens to be transferred.
214      */
215     function transfer(address _to, uint _value) public canTransfer(msg.sender, _value) returns (bool) {
216         return super.transfer(_to, _value);
217     }
218 
219     /**
220     * @dev Checks modifier and allows transfer if tokens are not locked.
221     * @param _from The address that will send the tokens.
222     * @param _to The address that will recieve the tokens.
223     * @param _value The amount of tokens to be transferred.
224     */
225     function transferFrom(address _from, address _to, uint _value) public canTransfer(_from, _value) returns (bool) {
226         return super.transferFrom(_from, _to, _value);
227     }
228 
229     /**
230      * @dev Default transferable tokens function returns all tokens for a holder (no limit).
231      * @dev Overwriting transferableTokens(address holder, uint time, uint number) is the way to provide the 
232      * specific logic for limiting token transferability for a holder over time or number.
233      */
234     function transferableTokens(address holder, uint /* time */, uint /* number */) view public returns (uint256) {
235         return balanceOf(holder);
236     }
237 }
238 
239 
240 /**
241  * @title Vested token
242  * @dev Tokens that can be vested for a group of addresses.
243  */
244 contract VestedToken is StandardToken, LimitedTransferToken {
245 
246     uint256 MAX_GRANTS_PER_ADDRESS = 20;
247 
248     struct TokenGrant {
249         address granter;         // 20 bytes
250         uint256 value;             // 32 bytes
251         uint start;
252         uint cliff;
253         uint vesting;                // 3 * 8 = 24 bytes
254         bool revokable;
255         bool burnsOnRevoke;    // 2 * 1 = 2 bits? or 2 bytes?
256         bool timeOrNumber;
257     } // total 78 bytes = 3 sstore per operation (32 per sstore)
258 
259     mapping (address => TokenGrant[]) public grants;
260 
261     event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint256 grantId);
262 
263     /**
264      * @dev Grant tokens to a specified address
265      * @param _to address The address which the tokens will be granted to.
266      * @param _value uint256 The amount of tokens to be granted.
267      * @param _start uint64 Time of the beginning of the grant.
268      * @param _cliff uint64 Time of the cliff period.
269      * @param _vesting uint64 The vesting period.
270      */
271     function grantVestedTokens(
272         address _to,
273         uint256 _value,
274         uint _start,
275         uint _cliff,
276         uint _vesting,
277         bool _revokable,
278         bool _burnsOnRevoke,
279         bool _timeOrNumber
280     ) public returns (bool) {
281 
282         // Check for date inconsistencies that may cause unexpected behavior
283         if (_cliff < _start || _vesting < _cliff) {
284             revert();
285         }
286 
287         // To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).
288         if (tokenGrantsCount(_to) > MAX_GRANTS_PER_ADDRESS) revert();
289 
290         uint count = grants[_to].push(
291             TokenGrant(
292                 _revokable ? msg.sender : 0, // avoid storing an extra 20 bytes when it is non-revokable
293                 _value,
294                 _start,
295                 _cliff,
296                 _vesting,
297                 _revokable,
298                 _burnsOnRevoke,
299                 _timeOrNumber
300             )
301         );
302 
303         transfer(_to, _value);
304 
305         emit NewTokenGrant(msg.sender, _to, _value, count - 1);
306         return true;
307     }
308 
309     /**
310      * @dev Revoke the grant of tokens of a specifed address.
311      * @param _holder The address which will have its tokens revoked.
312      * @param _grantId The id of the token grant.
313      */
314     function revokeTokenGrant(address _holder, uint _grantId) public returns (bool) {
315         TokenGrant storage grant = grants[_holder][_grantId];
316 
317         if (!grant.revokable) { // Check if grant was revokable
318             revert();
319         }
320 
321         if (grant.granter != msg.sender) { // Only granter can revoke it
322             revert();
323         }
324 
325         address receiver = grant.burnsOnRevoke ? 0xdead : msg.sender;
326 
327         uint256 nonVested = nonVestedTokens(grant, now, block.number);
328 
329         // remove grant from array
330         delete grants[_holder][_grantId];
331         grants[_holder][_grantId] = grants[_holder][grants[_holder].length.sub(1)];
332         grants[_holder].length -= 1;
333 
334         balances[receiver] = balances[receiver].add(nonVested);
335         balances[_holder] = balances[_holder].sub(nonVested);
336 
337         emit Transfer(_holder, receiver, nonVested);
338         return true;
339     }
340 
341 
342     /**
343      * @dev Calculate the total amount of transferable tokens of a holder at a given time
344      * @param holder address The address of the holder
345      * @param time uint The specific time.
346      * @return An uint representing a holder&#39;s total amount of transferable tokens.
347      */
348     function transferableTokens(address holder, uint time, uint number) view public returns (uint256) {
349         uint256 grantIndex = tokenGrantsCount(holder);
350 
351         if (grantIndex == 0) return balanceOf(holder); // shortcut for holder without grants
352 
353         // Iterate through all the grants the holder has, and add all non-vested tokens
354         uint256 nonVested = 0;
355         for (uint256 i = 0; i < grantIndex; i++) {
356             nonVested = SafeMath.add(nonVested, nonVestedTokens(grants[holder][i], time, number));
357         }
358 
359         // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time
360         uint256 vestedTransferable = SafeMath.sub(balanceOf(holder), nonVested);
361 
362         // Return the minimum of how many vested can transfer and other value
363         // in case there are other limiting transferability factors (default is balanceOf)
364         return SafeMath.min256(vestedTransferable, super.transferableTokens(holder, time, number));
365     }
366 
367     /**
368      * @dev Check the amount of grants that an address has.
369      * @param _holder The holder of the grants.
370      * @return A uint representing the total amount of grants.
371      */
372     function tokenGrantsCount(address _holder) public view returns (uint index) {
373         return grants[_holder].length;
374     }
375 
376     /**
377      * @dev Calculate amount of vested tokens at a specifc time.
378      * @param tokens uint256 The amount of tokens grantted.
379      * @param time uint64 The time to be checked
380      * @param start uint64 A time representing the begining of the grant
381      * @param cliff uint64 The cliff period.
382      * @param vesting uint64 The vesting period.
383      * @return An uint representing the amount of vested tokensof a specif grant.
384     *  transferableTokens
385     *   |                         _/--------   vestedTokens rect
386     *   |                       _/
387     *   |                     _/
388     *   |                   _/
389     *   |                 _/
390     *   |                /
391     *   |              .|
392     *   |            .  |
393     *   |          .    |
394     *   |        .      |
395     *   |      .        |
396     *   |    .          |
397     *   +===+===========+---------+----------> time
398     *      Start       Clift    Vesting
399     */
400     function calculateVestedTokensTime(
401         uint256 tokens,
402         uint256 time,
403         uint256 start,
404         uint256 cliff,
405         uint256 vesting) public pure returns (uint256) {
406         // Shortcuts for before cliff and after vesting cases.
407         if (time < cliff) return 0;
408         if (time >= vesting) return tokens;
409 
410         // Interpolate all vested tokens.
411         // As before cliff the shortcut returns 0, we can use just calculate a value
412         // in the vesting rect (as shown in above&#39;s figure)
413 
414         // vestedTokens = tokens * (time - start) / (vesting - start)
415         uint256 vestedTokens = SafeMath.div(SafeMath.mul(tokens, SafeMath.sub(time, start)), SafeMath.sub(vesting, start));
416 
417         return vestedTokens;
418     }
419 
420     function calculateVestedTokensNumber(
421         uint256 tokens,
422         uint256 number,
423         uint256 start,
424         uint256 cliff,
425         uint256 vesting) public pure returns (uint256) {
426         // Shortcuts for before cliff and after vesting cases.
427         if (number < cliff) return 0;
428         if (number >= vesting) return tokens;
429 
430         // Interpolate all vested tokens.
431         // As before cliff the shortcut returns 0, we can use just calculate a value
432         // in the vesting rect (as shown in above&#39;s figure)
433 
434         // vestedTokens = tokens * (number - start) / (vesting - start)
435         uint256 vestedTokens = SafeMath.div(SafeMath.mul(tokens, SafeMath.sub(number, start)), SafeMath.sub(vesting, start));
436 
437         return vestedTokens;
438     }
439 
440     function calculateVestedTokens(
441         bool timeOrNumber,
442         uint256 tokens,
443         uint256 time,
444         uint256 number,
445         uint256 start,
446         uint256 cliff,
447         uint256 vesting) public pure returns (uint256) {
448         if (timeOrNumber) {
449             return calculateVestedTokensTime(
450                 tokens,
451                 time,
452                 start,
453                 cliff,
454                 vesting
455             );
456         } else {
457             return calculateVestedTokensNumber(
458                 tokens,
459                 number,
460                 start,
461                 cliff,
462                 vesting
463             );
464         }
465     }
466 
467     /**
468      * @dev Get all information about a specifc grant.
469      * @param _holder The address which will have its tokens revoked.
470      * @param _grantId The id of the token grant.
471      * @return Returns all the values that represent a TokenGrant(address, value, start, cliff,
472      * revokability, burnsOnRevoke, and vesting) plus the vested value at the current time.
473      */
474     function tokenGrant(address _holder, uint _grantId) public view 
475         returns (address granter, uint256 value, uint256 vested, uint start, uint cliff, uint vesting, bool revokable, bool burnsOnRevoke, bool timeOrNumber) {
476         TokenGrant storage grant = grants[_holder][_grantId];
477 
478         granter = grant.granter;
479         value = grant.value;
480         start = grant.start;
481         cliff = grant.cliff;
482         vesting = grant.vesting;
483         revokable = grant.revokable;
484         burnsOnRevoke = grant.burnsOnRevoke;
485         timeOrNumber = grant.timeOrNumber;
486 
487         vested = vestedTokens(grant, now, block.number);
488     }
489 
490     /**
491      * @dev Get the amount of vested tokens at a specific time.
492      * @param grant TokenGrant The grant to be checked.
493      * @param time The time to be checked
494      * @return An uint representing the amount of vested tokens of a specific grant at a specific time.
495      */
496     function vestedTokens(TokenGrant grant, uint time, uint number) private pure returns (uint256) {
497         return calculateVestedTokens(
498             grant.timeOrNumber,
499             grant.value,
500             uint256(time),
501             uint256(number),
502             uint256(grant.start),
503             uint256(grant.cliff),
504             uint256(grant.vesting)
505         );
506     }
507 
508     /**
509      * @dev Calculate the amount of non vested tokens at a specific time.
510      * @param grant TokenGrant The grant to be checked.
511      * @param time uint64 The time to be checked
512      * @return An uint representing the amount of non vested tokens of a specifc grant on the 
513      * passed time frame.
514      */
515     function nonVestedTokens(TokenGrant grant, uint time, uint number) private pure returns (uint256) {
516         return grant.value.sub(vestedTokens(grant, time, number));
517     }
518 
519     /**
520      * @dev Calculate the date when the holder can trasfer all its tokens
521      * @param holder address The address of the holder
522      * @return An uint representing the date of the last transferable tokens.
523      */
524     function lastTokenIsTransferableDate(address holder) view public returns (uint date) {
525         date = now;
526         uint256 grantIndex = grants[holder].length;
527         for (uint256 i = 0; i < grantIndex; i++) {
528             if (grants[holder][i].timeOrNumber) {
529                 date = SafeMath.max256(grants[holder][i].vesting, date);
530             }
531         }
532     }
533     function lastTokenIsTransferableNumber(address holder) view public returns (uint number) {
534         number = block.number;
535         uint256 grantIndex = grants[holder].length;
536         for (uint256 i = 0; i < grantIndex; i++) {
537             if (!grants[holder][i].timeOrNumber) {
538                 number = SafeMath.max256(grants[holder][i].vesting, number);
539             }
540         }
541     }
542 }
543 
544 // QUESTIONS FOR AUDITORS:
545 // - Considering we inherit from VestedToken, how much does that hit at our gas price?
546 
547 // vesting: 365 days, 365 days / 1 vesting
548 
549 
550 contract GOCToken is VestedToken {
551     //FIELDS
552     string public name = "Global Optimal Chain";
553     string public symbol = "GOC";
554     uint public decimals = 18;
555     uint public INITIAL_SUPPLY = 20 * 100000000 * 1 ether;
556     uint public iTime;
557     uint public iBlock;
558 
559     // Initialization contract grants msg.sender all of existing tokens.
560     function GOCToken() public {
561         totalSupply = INITIAL_SUPPLY;
562         iTime = now;
563         iBlock = block.number;
564 
565         address toAddress = msg.sender;
566         balances[toAddress] = totalSupply;
567 
568         grantVestedTokens(toAddress, totalSupply.div(100).mul(30), iTime, iTime, iTime, false, false, true);
569 
570         grantVestedTokens(toAddress, totalSupply.div(100).mul(30), iTime, iTime + 365 days, iTime + 365 days, false, false, true);
571 
572         grantVestedTokens(toAddress, totalSupply.div(100).mul(20), iTime + 1095 days, iTime + 1095 days, iTime + 1245 days, false, false, true);
573         
574         uint startMine = uint(1054080) + block.number;// 1054080 = (183 * 24 * 60 * 60 / 15)
575         uint finishMine = uint(210240000) + block.number;// 210240000 = (100 * 365 * 24 * 60 * 60 / 15)
576         grantVestedTokens(toAddress, totalSupply.div(100).mul(20), startMine, startMine, finishMine, false, false, false);
577     }
578 
579     // Transfer amount of tokens from sender account to recipient.
580     function transfer(address _to, uint _value) public returns (bool) {
581         // no-op, allow even during crowdsale, in order to work around using grantVestedTokens() while in crowdsale
582         if (_to == msg.sender) return false;
583         return super.transfer(_to, _value);
584     }
585 
586     // Transfer amount of tokens from a specified address to a recipient.
587     // Transfer amount of tokens from sender account to recipient.
588     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
589         return super.transferFrom(_from, _to, _value);
590     }
591 
592     function currentTransferableTokens(address holder) view public returns (uint256) {
593         return transferableTokens(holder, now, block.number);
594     }
595 }