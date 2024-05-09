1 pragma solidity ^0.4.19;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic
8 {
9     uint256 public totalSupply;
10 
11     function balanceOf(address who) public constant returns (uint256);
12 
13     function transfer(address to, uint256 value) public returns (bool);
14 
15     event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 /**
19  * @title ERC20 interface
20  * @dev see https://github.com/ethereum/EIPs/issues/20
21  */
22 contract ERC20 is ERC20Basic
23 {
24     function allowance(address owner, address spender) public constant returns (uint256);
25 
26     function transferFrom(address from, address to, uint256 value) public returns (bool);
27 
28     function approve(address spender, uint256 value) public returns (bool);
29 
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 
34 // Contract Ownable (defines a contract with an owner)
35 //------------------------------------------------------------------------------------------------------------
36 contract Ownable
37 {
38     /**
39     * @dev Address of the current owner
40     */
41     address public owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     // Constructor. Set the original `owner` of the contract to the sender account.
46     function Ownable() public
47     {
48         owner = msg.sender;
49     }
50 
51     // Throws if called by any account other than the owner.
52     modifier onlyOwner()
53     {
54         require(msg.sender == owner);
55         _;
56     }
57 
58     /** Allows the current owner to transfer control of the contract to a newOwner.
59      * @param newOwner The address to transfer ownership to.
60      */
61     function transferOwnership(address newOwner) onlyOwner public
62     {
63         require(newOwner != address(0));
64         OwnershipTransferred(owner, newOwner);
65         owner = newOwner;
66     }
67 }
68 // ------------------------------------------------------------------------------------------------------------
69 
70 
71 /**
72  * @title SafeMath
73  * @dev Math operations with safety checks that throw on error
74  */
75 library SafeMath
76 {
77     function mul(uint256 a, uint256 b) internal pure returns (uint256)
78     {
79         uint256 c = a * b;
80         assert(a == 0 || c / a == b);
81         return c;
82     }
83 
84     function div(uint256 a, uint256 b) internal pure returns (uint256)
85     {
86         uint256 c = a / b;
87         return c;
88     }
89 
90     function sub(uint256 a, uint256 b) internal pure returns (uint256)
91     {
92         assert(b <= a);
93         return a - b;
94     }
95 
96     function add(uint256 a, uint256 b) internal pure returns (uint256)
97     {
98         uint256 c = a + b;
99         assert(c >= a);
100         return c;
101     }
102 }
103 
104 
105 
106 /**
107  * @title Basic token
108  * @dev Basic version of StandardToken, with no allowances.
109  */
110 contract SafeBasicToken is ERC20Basic
111 {
112     // Use safemath for math operations
113     using SafeMath for uint256;
114 
115     // Maps each address to its current balance
116     mapping(address => uint256) balances;
117 
118     // List of admins that can transfer tokens also during the ICO
119     mapping(address => bool) public admin;
120 
121     // List of addresses that can receive tokens also during the ICO
122     mapping(address => bool) public receivable;
123 
124     // Specifies whether the tokens are locked(ICO is running) - Tokens cannot be transferred during the ICO
125     bool public locked;
126 
127 
128     // Checks the size of the message to avoid attacks
129     modifier onlyPayloadSize(uint size)
130     {
131         assert(msg.data.length >= size + 4);
132         _;
133     }
134 
135     /** Transfer tokens to the specified address
136     * @param _to The address to transfer to.
137     * @param _value The amount to be transferred.
138     */
139     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool)
140     {
141         require(_to != address(0));
142         require(!locked || admin[msg.sender] == true || receivable[_to] == true);
143 
144         balances[msg.sender] = balances[msg.sender].sub(_value);
145         balances[_to] = balances[_to].add(_value);
146         Transfer(msg.sender, _to, _value);
147         return true;
148     }
149 
150 
151     /** Get the balance of the specified address.
152     * @param _owner The address to query the balance of.
153     * @return An uint256 representing the amount owned by the passed address.
154     */
155     function balanceOf(address _owner) public constant returns (uint256)
156     {
157         return balances[_owner];
158     }
159 }
160 
161 
162 /** @title Standard ERC20 token
163  *
164  * @dev Implementation of the basic standard token.
165  * @dev https://github.com/ethereum/EIPs/issues/20
166  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
167  */
168 contract SafeStandardToken is ERC20, SafeBasicToken
169 {
170     /** Map address => (address => value)
171     *   allowed[_owner][_spender] represents the amount of tokens the _spender can use on behalf of the _owner
172     */
173     mapping(address => mapping(address => uint256)) allowed;
174 
175 
176     /** Return the allowance of the _spender on behalf of the _owner
177     * @param _owner address The address which owns the funds.
178     * @param _spender address The address which will be allowed to spend the funds.
179     * @return A uint256 specifying the amount of tokens still available for the spender.
180     */
181     function allowance(address _owner, address _spender) public constant returns (uint256 remaining)
182     {
183         return allowed[_owner][_spender];
184     }
185 
186 
187     /** Allow the _spender to spend _value tokens on behalf of msg.sender.
188      * To avoid race condition, the current allowed amount must be first set to 0 through a different transaction.
189      * @param _spender The address which will spend the funds.
190      * @param _value The amount of tokens to be spent.
191      */
192     function approve(address _spender, uint256 _value) public returns (bool)
193     {
194         require(_value == 0 || allowed[msg.sender][_spender] == 0);
195         allowed[msg.sender][_spender] = _value;
196         Approval(msg.sender, _spender, _value);
197         return true;
198     }
199 
200 
201     /** Increase the allowance for _spender by _addedValue (to be use when allowed[_spender] > 0)
202      */
203     function increaseApproval(address _spender, uint _addedValue) public returns (bool success)
204     {
205         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
206         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207         return true;
208     }
209 
210 
211     /** Decrease the allowance for _spender by _subtractedValue. Set it to 0 if _subtractedValue is less then the current allowance
212     */
213     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success)
214     {
215         uint oldValue = allowed[msg.sender][_spender];
216 
217         if (_subtractedValue > oldValue)
218             allowed[msg.sender][_spender] = 0;
219         else
220             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
221         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222         return true;
223     }
224 
225 
226     /** Transfer tokens on behalf of _from to _to (if allowed)
227      * @param _from address The address which you want to send tokens from
228      * @param _to address The address which you want to transfer to
229      * @param _value uint256 the amount of tokens to be transferred
230      */
231     function transferFrom(address _from, address _to, uint256 _value) public returns (bool)
232     {
233         require(_to != address(0));
234         uint256 _allowance = allowed[_from][msg.sender];
235         balances[_from] = balances[_from].sub(_value);
236         balances[_to] = balances[_to].add(_value);
237         allowed[_from][msg.sender] = _allowance.sub(_value);
238         Transfer(_from, _to, _value);
239         return true;
240     }
241 }
242 
243 
244 
245 // Main contract
246 contract CrystalToken is SafeStandardToken, Ownable
247 {
248     using SafeMath for uint256;
249 
250     string public constant name = "CrystalToken";
251     string public constant symbol = "CYL";
252     uint256 public constant decimals = 18;
253     uint256 public constant INITIAL_SUPPLY = 28000000 * (10 ** uint256(decimals));
254 
255     // Struct representing information of a single round
256     struct Round
257     {
258         uint256 startTime;                      // Timestamp of the start of the round
259         uint256 endTime;                        // Timestamp of the end of the round
260         uint256 availableTokens;                // Number of tokens available in this round
261         uint256 maxPerUser;                     // Number of maximum tokens per user
262         uint256 rate;                           // Number of token per wei in this round
263         mapping(address => uint256) balances;   // Balances of the users in this round
264     }
265 
266     // Array containing information of all the rounds
267     Round[5] rounds;
268 
269     // Address where funds are collected
270     address public wallet;
271 
272     // Amount of collected money in wei
273     uint256 public weiRaised;
274 
275     // Current round index
276     uint256 public runningRound;
277 
278     // Constructor
279     function CrystalToken(address _walletAddress) public
280     {
281         wallet = _walletAddress;
282         totalSupply = INITIAL_SUPPLY;
283         balances[msg.sender] = INITIAL_SUPPLY;
284 
285         rounds[0] = Round(1519052400, 1519138800,  250000 * (10 ** 18), 200 * (10 ** 18), 2000);    // 19 Feb 2018 - 15.00 GMT
286         rounds[1] = Round(1519398000, 1519484400, 1250000 * (10 ** 18), 400 * (10 ** 18), 1333);    // 23 Feb 2018 - 15.00 GMT
287         rounds[2] = Round(1519657200, 1519743600, 1500000 * (10 ** 18), 1000 * (10 ** 18), 1000);   // 26 Feb 2018 - 15.00 GMT
288         rounds[3] = Round(1519830000, 1519916400, 2000000 * (10 ** 18), 1000 * (10 ** 18), 800);    // 28 Feb 2018 - 15.00 GMT
289         rounds[4] = Round(1520262000, 1520348400, 2000000 * (10 ** 18), 2000 * (10 ** 18), 667);    //  5 Mar 2018 - 15.00 GMT
290 
291         // Set the owner as an admin
292         admin[msg.sender] = true;
293 
294         // Lock the tokens for the ICO
295         locked = true;
296 
297         // Set the current round to 100 (no round)
298         runningRound = uint256(0);
299     }
300 
301 
302     /** Event for token purchase logging
303      * @param purchaser who paid for the tokens
304      * @param beneficiary who got the tokens
305      * @param value weis paid for purchase
306      * @param amount amount of tokens purchased
307      */
308     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
309 
310 
311     // Rate change event
312     event RateChanged(address indexed owner, uint round, uint256 old_rate, uint256 new_rate);
313 
314 
315     // Fallback function, used to buy token
316     // If ETH are sent to the contract address, without any additional data, this function is called
317     function() public payable
318     {
319         // Take the address of the buyer
320         address beneficiary = msg.sender;
321 
322         // Check that the sender is not the 0 address
323         require(beneficiary != 0x0);
324 
325         // Check that sent ETH in wei is > 0
326         uint256 weiAmount = msg.value;
327         require(weiAmount != 0);
328 
329         // Get the current round (100 if there is no open round)
330         uint256 roundIndex = runningRound;
331 
332         // Check if there is a running round
333         require(roundIndex != uint256(100));
334 
335         // Get the information of the current round
336         Round storage round = rounds[roundIndex];
337 
338         // Calculate the token amount to sell. Exceeding amount will not generate tokens
339         uint256 tokens = weiAmount.mul(round.rate);
340         uint256 maxPerUser = round.maxPerUser;
341         uint256 remaining = maxPerUser - round.balances[beneficiary];
342         if(remaining < tokens)
343             tokens = remaining;
344 
345         // Check if the tokens can be sold
346         require(areTokensBuyable(roundIndex, tokens));
347 
348         // Reduce the number of available tokens in the round (fails if there are no more available tokens)
349         round.availableTokens = round.availableTokens.sub(tokens);
350 
351         // Add the number of tokens to the current user's balance of this round
352         round.balances[msg.sender] = round.balances[msg.sender].add(tokens);
353 
354         // Transfer the amount of token to the buyer
355         balances[owner] = balances[owner].sub(tokens);
356         balances[beneficiary] = balances[beneficiary].add(tokens);
357         Transfer(owner, beneficiary, tokens);
358 
359         // Raise the event of token purchase
360         TokenPurchase(beneficiary, beneficiary, weiAmount, tokens);
361 
362         // Update the number of collected money
363         weiRaised = weiRaised.add(weiAmount);
364 
365         // Transfer funds to the wallet
366         wallet.transfer(msg.value);
367     }
368 
369 
370     /** Check if there is an open round and if there are enough tokens available for current phase and for the sender
371     * @param _roundIndex index of the current round
372     * @param _tokens number of requested tokens
373     */
374     function areTokensBuyable(uint _roundIndex, uint256 _tokens) internal constant returns (bool)
375     {
376         uint256 current_time = block.timestamp;
377         Round storage round = rounds[_roundIndex];
378 
379         return (
380         _tokens > 0 &&                                              // Check that the user can still buy tokens
381         round.availableTokens >= _tokens &&                         // Check that there are still available tokens
382         current_time >= round.startTime &&                          // Check that the current timestamp is after the start of the round
383         current_time <= round.endTime                               // Check that the current timestamp is before the end of the round
384         );
385     }
386 
387 
388 
389     // Return the current number of unsold tokens
390     function tokenBalance() constant public returns (uint256)
391     {
392         return balanceOf(owner);
393     }
394 
395 
396     event Burn(address burner, uint256 value);
397 
398 
399     /** Burns a specific amount of tokens.
400      * @param _value The amount of token to be burned.
401      */
402     function burn(uint256 _value) public onlyOwner
403     {
404         require(_value <= balances[msg.sender]);
405         address burner = msg.sender;
406         balances[burner] = balances[burner].sub(_value);
407         totalSupply = totalSupply.sub(_value);
408         Burn(burner, _value);
409     }
410 
411 
412 
413     /** Mint a specific amount of tokens.
414    * @param _value The amount of token to be minted.
415    */
416     function mint(uint256 _value) public onlyOwner
417     {
418         totalSupply = totalSupply.add(_value);
419         balances[msg.sender] = balances[msg.sender].add(_value);
420     }
421 
422 
423 
424     // Functions to set the features of each round (only for the owner) and of the whole ICO
425     // ----------------------------------------------------------------------------------------
426     function setTokensLocked(bool _value) onlyOwner public
427     {
428         locked = _value;
429     }
430 
431     /** Set the current round index
432     * @param _roundIndex the new round index to set
433     */
434     function setRound(uint256 _roundIndex) public onlyOwner
435     {
436         runningRound = _roundIndex;
437     }
438 
439     function setAdmin(address _addr, bool _value) onlyOwner public
440     {
441         admin[_addr] = _value;
442     }
443 
444     function setReceivable(address _addr, bool _value) onlyOwner public
445     {
446         receivable[_addr] = _value;
447     }
448 
449     function setRoundStart(uint _round, uint256 _value) onlyOwner public
450     {
451         require(_round >= 0 && _round < rounds.length);
452         rounds[_round].startTime = _value;
453     }
454 
455     function setRoundEnd(uint _round, uint256 _value) onlyOwner public
456     {
457         require(_round >= 0 && _round < rounds.length);
458         rounds[_round].endTime = _value;
459     }
460 
461     function setRoundAvailableToken(uint _round, uint256 _value) onlyOwner public
462     {
463         require(_round >= 0 && _round < rounds.length);
464         rounds[_round].availableTokens = _value;
465     }
466 
467     function setRoundMaxPerUser(uint _round, uint256 _value) onlyOwner public
468     {
469         require(_round >= 0 && _round < rounds.length);
470         rounds[_round].maxPerUser = _value;
471     }
472 
473     function setRoundRate(uint _round, uint256 _round_usd_cents, uint256 _ethvalue_usd) onlyOwner public
474     {
475         require(_round >= 0 && _round < rounds.length);
476         uint256 rate = _ethvalue_usd * 100 / _round_usd_cents;
477         uint256 oldRate = rounds[_round].rate;
478         rounds[_round].rate = rate;
479         RateChanged(msg.sender, _round, oldRate, rounds[_round].rate);
480     }
481     // ----------------------------------------------------------------------------------------
482 
483 
484     // Functions to get the features of each round
485     // ----------------------------------------------------------------------------------------
486     function getRoundUserBalance(uint _round, address _user) public constant returns (uint256)
487     {
488         require(_round >= 0 && _round < rounds.length);
489         return rounds[_round].balances[_user];
490     }
491 
492     function getRoundStart(uint _round) public constant returns (uint256)
493     {
494         require(_round >= 0 && _round < rounds.length);
495         return rounds[_round].startTime;
496     }
497 
498     function getRoundEnd(uint _round) public constant returns (uint256)
499     {
500         require(_round >= 0 && _round < rounds.length);
501         return rounds[_round].endTime;
502     }
503 
504     function getRoundAvailableToken(uint _round) public constant returns (uint256)
505     {
506         require(_round >= 0 && _round < rounds.length);
507         return rounds[_round].availableTokens;
508     }
509 
510     function getRoundMaxPerUser(uint _round) public constant returns (uint256)
511     {
512         require(_round >= 0 && _round < rounds.length);
513         return rounds[_round].maxPerUser;
514     }
515 
516     function getRoundRate(uint _round) public constant returns (uint256)
517     {
518         require(_round >= 0 && _round < rounds.length);
519         return rounds[_round].rate;
520     }
521     // ----------------------------------------------------------------------------------------
522 }