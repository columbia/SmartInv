1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     require(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     require(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     require(c >= a);
25     return c;
26   }
27 
28   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
29     return a >= b ? a : b;
30   }
31 
32   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a < b ? a : b;
34   }
35 
36   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
37     return a >= b ? a : b;
38   }
39 
40   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a < b ? a : b;
42   }
43 
44 }
45 
46 contract Ownable {
47   address public owner;
48 
49 
50   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() {
57     owner = msg.sender;
58   }
59 
60 
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     require(msg.sender == owner);
66     _;
67   }
68 
69 
70   /**
71    * @dev Allows the current owner to transfer control of the contract to a newOwner.
72    * @param newOwner The address to transfer ownership to.
73    */
74   function transferOwnership(address newOwner) onlyOwner public {
75     require(newOwner != address(0));
76     OwnershipTransferred(owner, newOwner);
77     owner = newOwner;
78   }
79 
80 }
81 
82 contract ERC20Basic {
83   uint256 public totalSupply;
84   function balanceOf(address who) public constant returns (uint256);
85   function transfer(address to, uint256 value) public returns (bool);
86   event Transfer(address indexed from, address indexed to, uint256 value);
87 }
88 
89 contract BasicToken is ERC20Basic {
90   using SafeMath for uint256;
91 
92   mapping(address => uint256) balances;
93 
94   /**
95   * @dev transfer token for a specified address
96   * @param _to The address to transfer to.
97   * @param _value The amount to be transferred.
98   */
99   function transfer(address _to, uint256 _value) public returns (bool) {
100     require(_to != address(0));
101     require(_value <= balances[msg.sender]);
102 
103     // SafeMath.sub will throw if there is not enough balance.
104     balances[msg.sender] = balances[msg.sender].sub(_value);
105     balances[_to] = balances[_to].add(_value);
106     Transfer(msg.sender, _to, _value);
107     return true;
108   }
109 
110   /**
111   * @dev Gets the balance of the specified address.
112   * @param _owner The address to query the the balance of.
113   * @return An uint256 representing the amount owned by the passed address.
114   */
115   function balanceOf(address _owner) public constant returns (uint256 balance) {
116     return balances[_owner];
117   }
118 
119 }
120 
121 contract ERC20 is ERC20Basic {
122   function allowance(address owner, address spender) public constant returns (uint256);
123   function transferFrom(address from, address to, uint256 value) public returns (bool);
124   function approve(address spender, uint256 value) public returns (bool);
125   event Approval(address indexed owner, address indexed spender, uint256 value);
126 }
127 
128 contract LimitedTransferToken is ERC20 {
129 
130   /**
131    * @dev Checks whether it can transfer or otherwise throws.
132    */
133   modifier canTransfer(address _sender, uint256 _value) {
134    require(_value <= transferableTokens(_sender, uint64(now)));
135    _;
136   }
137 
138   /**
139    * @dev Checks modifier and allows transfer if tokens are not locked.
140    * @param _to The address that will receive the tokens.
141    * @param _value The amount of tokens to be transferred.
142    */
143   function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) public returns (bool) {
144     return super.transfer(_to, _value);
145   }
146 
147   /**
148   * @dev Checks modifier and allows transfer if tokens are not locked.
149   * @param _from The address that will send the tokens.
150   * @param _to The address that will receive the tokens.
151   * @param _value The amount of tokens to be transferred.
152   */
153   function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) public returns (bool) {
154     return super.transferFrom(_from, _to, _value);
155   }
156 
157   /**
158    * @dev Default transferable tokens function returns all tokens for a holder (no limit).
159    * @dev Overwriting transferableTokens(address holder, uint64 time) is the way to provide the
160    * specific logic for limiting token transferability for a holder over time.
161    */
162   function transferableTokens(address holder, uint64 time) public constant returns (uint256) {
163     return balanceOf(holder);
164   }
165 }
166 
167 contract StandardToken is ERC20, BasicToken {
168 
169   mapping (address => mapping (address => uint256)) internal allowed;
170 
171 
172   /**
173    * @dev Transfer tokens from one address to another
174    * @param _from address The address which you want to send tokens from
175    * @param _to address The address which you want to transfer to
176    * @param _value uint256 the amount of tokens to be transferred
177    */
178   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
179     require(_to != address(0));
180     require(_value <= balances[_from]);
181     require(_value <= allowed[_from][msg.sender]);
182 
183     balances[_from] = balances[_from].sub(_value);
184     balances[_to] = balances[_to].add(_value);
185     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
186     Transfer(_from, _to, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
192    *
193    * Beware that changing an allowance with this method brings the risk that someone may use both the old
194    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
195    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
196    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
197    * @param _spender The address which will spend the funds.
198    * @param _value The amount of tokens to be spent.
199    */
200   function approve(address _spender, uint256 _value) public returns (bool) {
201     allowed[msg.sender][_spender] = _value;
202     Approval(msg.sender, _spender, _value);
203     return true;
204   }
205 
206   /**
207    * @dev Function to check the amount of tokens that an owner allowed to a spender.
208    * @param _owner address The address which owns the funds.
209    * @param _spender address The address which will spend the funds.
210    * @return A uint256 specifying the amount of tokens still available for the spender.
211    */
212   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
213     return allowed[_owner][_spender];
214   }
215 
216   /**
217    * approve should be called when allowed[_spender] == 0. To increment
218    * allowed value is better to use this function to avoid 2 calls (and wait until
219    * the first transaction is mined)
220    * From MonolithDAO Token.sol
221    */
222   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
223     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
224     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225     return true;
226   }
227 
228   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
229     uint oldValue = allowed[msg.sender][_spender];
230     if (_subtractedValue > oldValue) {
231       allowed[msg.sender][_spender] = 0;
232     } else {
233       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
234     }
235     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236     return true;
237   }
238 
239 }
240 
241 contract MintableToken is StandardToken, Ownable {
242   event Mint(address indexed to, uint256 amount);
243   event MintFinished();
244   event MintingAgentChanged(address addr, bool state  );
245 
246   bool public mintingFinished = false;
247 
248   /** List of agents that are allowed to create new tokens */
249   mapping (address => bool) public mintAgents;
250 
251   modifier canMint() {
252     require(!mintingFinished);
253     _;
254   }
255 
256   modifier onlyMintAgent() {
257     // Only whitelisted contracts are allowed to mint new tokens
258     if(!mintAgents[msg.sender]) {
259       revert();
260     }
261     _;
262   }
263 
264   /**
265    * @dev Function to mint tokens
266    * @param _to The address that will receive the minted tokens.
267    * @param _amount The amount of tokens to mint.
268    * @return A boolean that indicates if the operation was successful.
269    */
270   function mint(address _to, uint256 _amount) onlyMintAgent canMint public returns (bool) {
271     totalSupply = totalSupply.add(_amount);
272     balances[_to] = balances[_to].add(_amount);
273     Mint(_to, _amount);
274     Transfer(0x0, _to, _amount);
275     return true;
276   }
277 
278   /**
279    * Owner can allow a contract to mint new tokens.
280    */
281   function setMintAgent(address addr, bool state) onlyOwner canMint public {
282     mintAgents[addr] = state;
283     MintingAgentChanged(addr, state);
284   }
285 
286   /**
287    * @dev Function to stop minting new tokens.
288    * @return True if the operation was successful.
289    */
290   function finishMinting() onlyOwner public returns (bool) {
291     mintingFinished = true;
292     MintFinished();
293     return true;
294   }
295 }
296 
297 contract VestedToken is StandardToken, LimitedTransferToken {
298 
299   uint256 MAX_GRANTS_PER_ADDRESS = 20;
300 
301   struct TokenGrant {
302   address granter;     // 20 bytes
303   uint256 value;       // 32 bytes
304   uint64 cliff;
305   uint64 vesting;
306   uint64 start;        // 3 * 8 = 24 bytes
307   bool revokable;
308   bool burnsOnRevoke;  // 2 * 1 = 2 bits? or 2 bytes?
309   } // total 78 bytes = 3 sstore per operation (32 per sstore)
310 
311   mapping (address => TokenGrant[]) public grants;
312 
313   event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint256 grantId);
314 
315   /**
316    * @dev Grant tokens to a specified address
317    * @param _to address The address which the tokens will be granted to.
318    * @param _value uint256 The amount of tokens to be granted.
319    * @param _start uint64 Time of the beginning of the grant.
320    * @param _cliff uint64 Time of the cliff period.
321    * @param _vesting uint64 The vesting period.
322    */
323   function grantVestedTokens(
324   address _to,
325   uint256 _value,
326   uint64 _start,
327   uint64 _cliff,
328   uint64 _vesting,
329   bool _revokable,
330   bool _burnsOnRevoke
331   ) public {
332 
333     // Check for date inconsistencies that may cause unexpected behavior
334     require(_cliff >= _start && _vesting >= _cliff);
335 
336     require(tokenGrantsCount(_to) < MAX_GRANTS_PER_ADDRESS);   // To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).
337 
338     uint256 count = grants[_to].push(
339     TokenGrant(
340     _revokable ? msg.sender : 0, // avoid storing an extra 20 bytes when it is non-revokable
341     _value,
342     _cliff,
343     _vesting,
344     _start,
345     _revokable,
346     _burnsOnRevoke
347     )
348     );
349 
350     transfer(_to, _value);
351 
352     NewTokenGrant(msg.sender, _to, _value, count - 1);
353   }
354 
355   /**
356    * @dev Revoke the grant of tokens of a specifed address.
357    * @param _holder The address which will have its tokens revoked.
358    * @param _grantId The id of the token grant.
359    */
360   function revokeTokenGrant(address _holder, uint256 _grantId) public {
361     TokenGrant storage grant = grants[_holder][_grantId];
362 
363     require(grant.revokable);
364     require(grant.granter == msg.sender); // Only granter can revoke it
365 
366     address receiver = grant.burnsOnRevoke ? 0xdead : msg.sender;
367 
368     uint256 nonVested = nonVestedTokens(grant, uint64(now));
369 
370     // remove grant from array
371     delete grants[_holder][_grantId];
372     grants[_holder][_grantId] = grants[_holder][grants[_holder].length.sub(1)];
373     grants[_holder].length -= 1;
374 
375     balances[receiver] = balances[receiver].add(nonVested);
376     balances[_holder] = balances[_holder].sub(nonVested);
377 
378     Transfer(_holder, receiver, nonVested);
379   }
380 
381 
382   /**
383    * @dev Calculate the total amount of transferable tokens of a holder at a given time
384    * @param holder address The address of the holder
385    * @param time uint64 The specific time.
386    * @return An uint256 representing a holder's total amount of transferable tokens.
387    */
388   function transferableTokens(address holder, uint64 time) public constant returns (uint256) {
389     uint256 grantIndex = tokenGrantsCount(holder);
390 
391     if (grantIndex == 0) return super.transferableTokens(holder, time); // shortcut for holder without grants
392 
393     // Iterate through all the grants the holder has, and add all non-vested tokens
394     uint256 nonVested = 0;
395     for (uint256 i = 0; i < grantIndex; i++) {
396       nonVested = SafeMath.add(nonVested, nonVestedTokens(grants[holder][i], time));
397     }
398 
399     // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time
400     uint256 vestedTransferable = SafeMath.sub(balanceOf(holder), nonVested);
401 
402     // Return the minimum of how many vested can transfer and other value
403     // in case there are other limiting transferability factors (default is balanceOf)
404     return SafeMath.min256(vestedTransferable, super.transferableTokens(holder, time));
405   }
406 
407   /**
408    * @dev Check the amount of grants that an address has.
409    * @param _holder The holder of the grants.
410    * @return A uint256 representing the total amount of grants.
411    */
412   function tokenGrantsCount(address _holder) public constant returns (uint256 index) {
413     return grants[_holder].length;
414   }
415 
416   /**
417    * @dev Calculate amount of vested tokens at a specific time
418    * @param tokens uint256 The amount of tokens granted
419    * @param time uint64 The time to be checked
420    * @param start uint64 The time representing the beginning of the grant
421    * @param cliff uint64  The cliff period, the period before nothing can be paid out
422    * @param vesting uint64 The vesting period
423    * @return An uint256 representing the amount of vested tokens of a specific grant
424    *  transferableTokens
425    *   |                         _/--------   vestedTokens rect
426    *   |                       _/
427    *   |                     _/
428    *   |                   _/
429    *   |                 _/
430    *   |                /
431    *   |              .|
432    *   |            .  |
433    *   |          .    |
434    *   |        .      |
435    *   |      .        |
436    *   |    .          |
437    *   +===+===========+---------+----------> time
438    *      Start       Cliff    Vesting
439    */
440   function calculateVestedTokens(
441   uint256 tokens,
442   uint256 time,
443   uint256 start,
444   uint256 cliff,
445   uint256 vesting) public constant returns (uint256)
446   {
447     // Shortcuts for before cliff and after vesting cases.
448     if (time < cliff) return 0;
449     if (time >= vesting) return tokens;
450 
451     // Interpolate all vested tokens.
452     // As before cliff the shortcut returns 0, we can use just calculate a value
453     // in the vesting rect (as shown in above's figure)
454 
455     // vestedTokens = (tokens * (time - start)) / (vesting - start)
456     uint256 vestedTokens = SafeMath.div(
457     SafeMath.mul(
458     tokens,
459     SafeMath.sub(time, start)
460     ),
461     SafeMath.sub(vesting, start)
462     );
463 
464     return vestedTokens;
465   }
466 
467   /**
468    * @dev Get all information about a specific grant.
469    * @param _holder The address which will have its tokens revoked.
470    * @param _grantId The id of the token grant.
471    * @return Returns all the values that represent a TokenGrant(address, value, start, cliff,
472    * revokability, burnsOnRevoke, and vesting) plus the vested value at the current time.
473    */
474   function tokenGrant(address _holder, uint256 _grantId) public constant returns (address granter, uint256 value, uint256 vested, uint64 start, uint64 cliff, uint64 vesting, bool revokable, bool burnsOnRevoke) {
475     TokenGrant storage grant = grants[_holder][_grantId];
476 
477     granter = grant.granter;
478     value = grant.value;
479     start = grant.start;
480     cliff = grant.cliff;
481     vesting = grant.vesting;
482     revokable = grant.revokable;
483     burnsOnRevoke = grant.burnsOnRevoke;
484 
485     vested = vestedTokens(grant, uint64(now));
486   }
487 
488   /**
489    * @dev Get the amount of vested tokens at a specific time.
490    * @param grant TokenGrant The grant to be checked.
491    * @param time The time to be checked
492    * @return An uint256 representing the amount of vested tokens of a specific grant at a specific time.
493    */
494   function vestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
495     return calculateVestedTokens(
496     grant.value,
497     uint256(time),
498     uint256(grant.start),
499     uint256(grant.cliff),
500     uint256(grant.vesting)
501     );
502   }
503 
504   /**
505    * @dev Calculate the amount of non vested tokens at a specific time.
506    * @param grant TokenGrant The grant to be checked.
507    * @param time uint64 The time to be checked
508    * @return An uint256 representing the amount of non vested tokens of a specific grant on the
509    * passed time frame.
510    */
511   function nonVestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
512     return grant.value.sub(vestedTokens(grant, time));
513   }
514 
515   /**
516    * @dev Calculate the date when the holder can transfer all its tokens
517    * @param holder address The address of the holder
518    * @return An uint256 representing the date of the last transferable tokens.
519    */
520   function lastTokenIsTransferableDate(address holder) public constant returns (uint64 date) {
521     date = uint64(now);
522     uint256 grantIndex = grants[holder].length;
523     for (uint256 i = 0; i < grantIndex; i++) {
524       date = SafeMath.max64(grants[holder][i].vesting, date);
525     }
526   }
527 }
528 
529 contract AlloyToken is MintableToken, VestedToken {
530 
531     string constant public name = 'ALLOY';
532     string constant public symbol = 'ALLOY';
533     uint constant public decimals = 18;
534 
535     function AlloyToken(){
536 
537     }
538 
539 }