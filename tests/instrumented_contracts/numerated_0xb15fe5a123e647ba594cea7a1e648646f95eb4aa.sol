1 /*
2   Copyright 2017 Sharder Foundation.
3 
4   Licensed under the Apache License, Version 2.0 (the "License");
5   you may not use this file except in compliance with the License.
6   You may obtain a copy of the License at
7 
8   http://www.apache.org/licenses/LICENSE-2.0
9 
10   Unless required by applicable law or agreed to in writing, software
11   distributed under the License is distributed on an "AS IS" BASIS,
12   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
13   See the License for the specific language governing permissions and
14   limitations under the License.
15 */
16 pragma solidity ^0.4.18;
17 
18 /**
19  * Math operations with safety checks
20  */
21 library SafeMath {
22     function mul(uint a, uint b) internal pure returns (uint) {
23         uint c = a * b;
24         assert(a == 0 || c / a == b);
25         return c;
26     }
27 
28     function div(uint a, uint b) internal pure returns (uint) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         uint c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return c;
33     }
34 
35     function sub(uint a, uint b) internal pure returns (uint) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     function add(uint a, uint b) internal pure returns (uint) {
41         uint c = a + b;
42         assert(c >= a);
43         return c;
44     }
45 
46     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
47         return a >= b ? a : b;
48     }
49 
50     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
51         return a < b ? a : b;
52     }
53 
54     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
55         return a >= b ? a : b;
56     }
57 
58     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
59         return a < b ? a : b;
60     }
61 }
62 
63 /**
64 * @title Sharder Protocol Token.
65 * For more information about this token sale, please visit https://sharder.org
66 * @author Ben - <xy@sharder.org>.
67 * @dev https://github.com/ethereum/EIPs/issues/20
68 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
69 */
70 contract SharderToken {
71     using SafeMath for uint;
72     string public constant NAME = "Sharder Storage";
73     string public constant SYMBOL = "SS";
74     uint public constant DECIMALS = 18;
75     uint public totalSupply;
76 
77     mapping (address => mapping (address => uint256))  public allowed;
78     mapping (address => uint) public balances;
79 
80     /// This is where we hold ether during this crowdsale. We will not transfer any ether
81     /// out of this address before we invocate the `closeCrowdsale` function to finalize the crowdsale.
82     /// This promise is not guanranteed by smart contract by can be verified with public
83     /// Ethereum transactions data available on several blockchain browsers.
84     /// This is the only address from which `startCrowdsale` and `closeCrowdsale` can be invocated.
85     address public owner;
86 
87     /// Admin account used to manage after crowdsale
88     address public admin;
89 
90     mapping (address => bool) public accountLockup;
91     mapping (address => uint) public accountLockupTime;
92     mapping (address => bool) public frozenAccounts;
93 
94     ///   +-----------------------------------------------------------------------------------+
95     ///   |                        SS Token Issue Plan - First Round                          |
96     ///   +-----------------------------------------------------------------------------------+
97     ///   |  Total Sale  |   Airdrop    |  Community Reserve  |  Team Reserve | System Reward |
98     ///   +-----------------------------------------------------------------------------------+
99     ///   |     50%      |     10%      |         10%         |  Don't Issued | Don't Issued  |
100     ///   +-----------------------------------------------------------------------------------+
101     ///   | 250,000,000  |  50,000,000  |     50,000,000      |      None     |      None     |
102     ///   +-----------------------------------------------------------------------------------+
103     uint256 internal constant FIRST_ROUND_ISSUED_SS = 350000000000000000000000000;
104 
105     /// Maximum amount of fund to be raised, the sale ends on reaching this amount.
106     uint256 public constant HARD_CAP = 1500 ether;
107 
108     /// It will be refuned if crowdsale can't acheive the soft cap, all ethers will be refuned.
109     uint256 public constant SOFT_CAP = 1000 ether;
110 
111     /// 1 ether exchange rate
112     /// base the 7-day average close price (Feb.15 through Feb.21, 2018) on CoinMarketCap.com at Feb.21.
113     uint256 public constant BASE_RATE = 20719;
114 
115     /// 1 ether == 1000 finney
116     /// Min contribution: 0.1 ether
117     uint256 public constant CONTRIBUTION_MIN = 100 finney;
118 
119     /// Max contribution: 5 ether
120     uint256 public constant CONTRIBUTION_MAX = 5000 finney;
121 
122     /// Sold SS tokens in crowdsale
123     uint256 public soldSS = 0;
124 
125     uint8[2] internal bonusPercentages = [
126     0,
127     0
128     ];
129 
130     uint256 internal constant MAX_PROMOTION_SS = 0;
131     uint internal constant NUM_OF_PHASE = 2;
132     uint internal constant BLOCKS_PER_PHASE = 86400;
133 
134     /// Crowdsale start block number.
135     uint public saleStartAtBlock = 0;
136 
137     /// Crowdsale ended block number.
138     uint public saleEndAtBlock = 0;
139 
140     /// Unsold ss token whether isssued.
141     bool internal unsoldTokenIssued = false;
142 
143     /// Goal whether achieved
144     bool internal isGoalAchieved = false;
145 
146     /// Received ether
147     uint256 internal totalEthReceived = 0;
148 
149     /// Issue event index starting from 0.
150     uint256 internal issueIndex = 0;
151 
152     /*
153      * EVENTS
154      */
155     /// Emitted only once after token sale starts.
156     event SaleStarted();
157 
158     /// Emitted only once after token sale ended (all token issued).
159     event SaleEnded();
160 
161     /// Emitted when a function is invocated by unauthorized addresses.
162     event InvalidCaller(address caller);
163 
164     /// Emitted when a function is invocated without the specified preconditions.
165     /// This event will not come alone with an exception.
166     event InvalidState(bytes msg);
167 
168     /// Emitted for each sucuessful token purchase.
169     event Issue(uint issueIndex, address addr, uint ethAmount, uint tokenAmount);
170 
171     /// Emitted if the token sale succeeded.
172     event SaleSucceeded();
173 
174     /// Emitted if the token sale failed.
175     /// When token sale failed, all Ether will be return to the original purchasing
176     /// address with a minor deduction of transaction fee（gas)
177     event SaleFailed();
178 
179     // This notifies clients about the amount to transfer
180     event Transfer(address indexed from, address indexed to, uint256 value);
181 
182     // This notifies clients about the amount to approve
183     event Approval(address indexed owner, address indexed spender, uint value);
184 
185     // This notifies clients about the amount burnt
186     event Burn(address indexed from, uint256 value);
187 
188     /**
189      * Internal transfer, only can be called by this contract
190      */
191     function _transfer(address _from, address _to, uint _value) internal isNotFrozen {
192         // Prevent transfer to 0x0 address. Use burn() instead
193         require(_to != 0x0);
194         // Check if the sender has enough
195         require(balances[_from] >= _value);
196         // Check for overflows
197         require(balances[_to] + _value > balances[_to]);
198         // Save this for an assertion in the future
199         uint previousBalances = balances[_from] + balances[_to];
200         // Subtract from the sender
201         balances[_from] -= _value;
202         // Add the same to the recipient
203         balances[_to] += _value;
204         Transfer(_from, _to, _value);
205         // Asserts are used to use static analysis to find bugs in your code. They should never fail
206         assert(balances[_from] + balances[_to] == previousBalances);
207     }
208 
209     /**
210     * @dev transfer token for a specified address
211     * @param _to The address to transfer to.
212     * @param _transferTokensWithDecimal The amount to be transferred.
213     */
214     function transfer(address _to, uint _transferTokensWithDecimal) public {
215         _transfer(msg.sender, _to, _transferTokensWithDecimal);
216     }
217 
218     /**
219     * @dev Transfer tokens from one address to another
220     * @param _from address The address which you want to send tokens from
221     * @param _to address The address which you want to transfer to
222     * @param _transferTokensWithDecimal uint the amout of tokens to be transfered
223     */
224     function transferFrom(address _from, address _to, uint _transferTokensWithDecimal) public returns (bool success) {
225         require(_transferTokensWithDecimal <= allowed[_from][msg.sender]);     // Check allowance
226         allowed[_from][msg.sender] -= _transferTokensWithDecimal;
227         _transfer(_from, _to, _transferTokensWithDecimal);
228         return true;
229     }
230 
231     /**
232     * @dev Gets the balance of the specified address.
233     * @param _owner The address to query the the balance of.
234     * @return An uint representing the amount owned by the passed address.
235     */
236     function balanceOf(address _owner) public constant returns (uint balance) {
237         return balances[_owner];
238     }
239 
240     /**
241      * Set allowance for other address
242      * Allows `_spender` to spend no more than `_approveTokensWithDecimal` tokens in your behalf
243      *
244      * @param _spender The address authorized to spend
245      * @param _approveTokensWithDecimal the max amount they can spend
246      */
247     function approve(address _spender, uint256 _approveTokensWithDecimal) public isNotFrozen returns (bool success) {
248         allowed[msg.sender][_spender] = _approveTokensWithDecimal;
249         Approval(msg.sender, _spender, _approveTokensWithDecimal);
250         return true;
251     }
252 
253     /**
254      * @dev Function to check the amount of tokens than an owner allowed to a spender.
255      * @param _owner address The address which owns the funds.
256      * @param _spender address The address which will spend the funds.
257      * @return A uint specifing the amount of tokens still avaible for the spender.
258      */
259     function allowance(address _owner, address _spender) internal constant returns (uint remaining) {
260         return allowed[_owner][_spender];
261     }
262 
263     /**
264        * Destroy tokens
265        * Remove `_value` tokens from the system irreversibly
266        *
267        * @param _burnedTokensWithDecimal the amount of reserve tokens. !!IMPORTANT is 18 DECIMALS
268        */
269     function burn(uint256 _burnedTokensWithDecimal) public returns (bool success) {
270         require(balances[msg.sender] >= _burnedTokensWithDecimal);   /// Check if the sender has enough
271         balances[msg.sender] -= _burnedTokensWithDecimal;            /// Subtract from the sender
272         totalSupply -= _burnedTokensWithDecimal;                      /// Updates totalSupply
273         Burn(msg.sender, _burnedTokensWithDecimal);
274         return true;
275     }
276 
277     /**
278      * Destroy tokens from other account
279      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
280      *
281      * @param _from the address of the sender
282      * @param _burnedTokensWithDecimal the amount of reserve tokens. !!IMPORTANT is 18 DECIMALS
283      */
284     function burnFrom(address _from, uint256 _burnedTokensWithDecimal) public returns (bool success) {
285         require(balances[_from] >= _burnedTokensWithDecimal);                /// Check if the targeted balance is enough
286         require(_burnedTokensWithDecimal <= allowed[_from][msg.sender]);    /// Check allowance
287         balances[_from] -= _burnedTokensWithDecimal;                        /// Subtract from the targeted balance
288         allowed[_from][msg.sender] -= _burnedTokensWithDecimal;             /// Subtract from the sender's allowance
289         totalSupply -= _burnedTokensWithDecimal;                            /// Update totalSupply
290         Burn(_from, _burnedTokensWithDecimal);
291         return true;
292     }
293 
294     /*
295      * MODIFIERS
296      */
297     modifier onlyOwner {
298         require(msg.sender == owner);
299         _;
300     }
301 
302     modifier onlyAdmin {
303         require(msg.sender == owner || msg.sender == admin);
304         _;
305     }
306 
307     modifier beforeStart {
308         require(!saleStarted());
309         _;
310     }
311 
312     modifier inProgress {
313         require(saleStarted() && !saleEnded());
314         _;
315     }
316 
317     modifier afterEnd {
318         require(saleEnded());
319         _;
320     }
321 
322     modifier isNotFrozen {
323         require( frozenAccounts[msg.sender] != true && now > accountLockupTime[msg.sender] );
324         _;
325     }
326 
327     /**
328      * CONSTRUCTOR
329      *
330      * @dev Initialize the Sharder Token
331      */
332     function SharderToken() public {
333         owner = msg.sender;
334         admin = msg.sender;
335         totalSupply = FIRST_ROUND_ISSUED_SS;
336     }
337 
338     /*
339      * PUBLIC FUNCTIONS
340      */
341 
342     ///@dev Set admin account.
343     function setAdmin(address _address) public onlyOwner {
344        admin=_address;
345     }
346 
347     ///@dev Set frozen status of account.
348     function setAccountFrozenStatus(address _address, bool _frozenStatus) public onlyAdmin {
349         require(unsoldTokenIssued);
350         frozenAccounts[_address] = _frozenStatus;
351     }
352 
353     /// @dev Lockup account till the date. Can't lockup again when this account locked already.
354     /// 1 year = 31536000 seconds
355     /// 0.5 year = 15768000 seconds
356     function lockupAccount(address _address, uint _lockupSeconds) public onlyAdmin {
357         require((accountLockup[_address] && now > accountLockupTime[_address]) || !accountLockup[_address]);
358 
359         // frozen time = now + _lockupSeconds
360         accountLockupTime[_address] = now + _lockupSeconds;
361         accountLockup[_address] = true;
362     }
363 
364     /// @dev Start the crowdsale.
365     function startCrowdsale(uint _saleStartAtBlock) public onlyOwner beforeStart {
366         require(_saleStartAtBlock > block.number);
367         saleStartAtBlock = _saleStartAtBlock;
368         SaleStarted();
369     }
370 
371     /// @dev Close the crowdsale and issue unsold tokens to `owner` address.
372     function closeCrowdsale() public onlyOwner afterEnd {
373         require(!unsoldTokenIssued);
374 
375         if (totalEthReceived >= SOFT_CAP) {
376             saleEndAtBlock = block.number;
377             issueUnsoldToken();
378             SaleSucceeded();
379         } else {
380             SaleFailed();
381         }
382     }
383 
384     /// @dev goal achieved ahead of time
385     function goalAchieved() public onlyOwner {
386         require(!isGoalAchieved && softCapReached());
387         isGoalAchieved = true;
388         closeCrowdsale();
389     }
390 
391     /// @dev Returns the current price.
392     function price() public constant returns (uint tokens) {
393         return computeTokenAmount(1 ether);
394     }
395 
396     /// @dev This default function allows token to be purchased by directly
397     /// sending ether to this smart contract.
398     function () public payable {
399         issueToken(msg.sender);
400     }
401 
402     /// @dev Issue token based on ether received.
403     /// @param recipient Address that newly issued token will be sent to.
404     function issueToken(address recipient) public payable inProgress {
405         // Personal cap check
406         require(balances[recipient].div(BASE_RATE).add(msg.value) <= CONTRIBUTION_MAX);
407         // Contribution cap check
408         require(CONTRIBUTION_MIN <= msg.value && msg.value <= CONTRIBUTION_MAX);
409 
410         uint tokens = computeTokenAmount(msg.value);
411 
412         totalEthReceived = totalEthReceived.add(msg.value);
413         soldSS = soldSS.add(tokens);
414 
415         balances[recipient] = balances[recipient].add(tokens);
416         Issue(issueIndex++,recipient,msg.value,tokens);
417 
418         require(owner.send(msg.value));
419     }
420 
421     /// @dev Issue token for reserve.
422     /// @param recipient Address that newly issued reserve token will be sent to.
423     /// @param _issueTokensWithDecimal the amount of reserve tokens. !!IMPORTANT is 18 DECIMALS
424     function issueReserveToken(address recipient, uint256 _issueTokensWithDecimal) onlyOwner public {
425         balances[recipient] = balances[recipient].add(_issueTokensWithDecimal);
426         totalSupply = totalSupply.add(_issueTokensWithDecimal);
427         Issue(issueIndex++,recipient,0,_issueTokensWithDecimal);
428     }
429 
430     /*
431      * INTERNAL FUNCTIONS
432      */
433     /// @dev Compute the amount of SS token that can be purchased.
434     /// @param ethAmount Amount of Ether to purchase SS.
435     /// @return Amount of SS token to purchase
436     function computeTokenAmount(uint ethAmount) internal constant returns (uint tokens) {
437         uint phase = (block.number - saleStartAtBlock).div(BLOCKS_PER_PHASE);
438 
439         // A safe check
440         if (phase >= bonusPercentages.length) {
441             phase = bonusPercentages.length - 1;
442         }
443 
444         uint tokenBase = ethAmount.mul(BASE_RATE);
445 
446         //Check promotion supply and phase bonus
447         uint tokenBonus = 0;
448         if(totalEthReceived * BASE_RATE < MAX_PROMOTION_SS) {
449             tokenBonus = tokenBase.mul(bonusPercentages[phase]).div(100);
450         }
451 
452         tokens = tokenBase.add(tokenBonus);
453     }
454 
455     /// @dev Issue unsold token to `owner` address.
456     function issueUnsoldToken() internal {
457         if (unsoldTokenIssued) {
458             InvalidState("Unsold token has been issued already");
459         } else {
460             // Add another safe guard
461             require(soldSS > 0);
462 
463             uint256 unsoldSS = totalSupply.sub(soldSS);
464             // Issue 'unsoldToken' to the admin account.
465             balances[owner] = balances[owner].add(unsoldSS);
466             Issue(issueIndex++,owner,0,unsoldSS);
467 
468             unsoldTokenIssued = true;
469         }
470     }
471 
472     /// @return true if sale has started, false otherwise.
473     function saleStarted() public constant returns (bool) {
474         return (saleStartAtBlock > 0 && block.number >= saleStartAtBlock);
475     }
476 
477     /// @return true if sale has ended, false otherwise.
478     /// Sale ended in: a) end time of crowdsale reached, b) hard cap reached, c) goal achieved ahead of time
479     function saleEnded() public constant returns (bool) {
480         return saleStartAtBlock > 0 && (saleDue() || hardCapReached() || isGoalAchieved);
481     }
482 
483     /// @return true if sale is due when the last phase is finished.
484     function saleDue() internal constant returns (bool) {
485         return block.number >= saleStartAtBlock + BLOCKS_PER_PHASE * NUM_OF_PHASE;
486     }
487 
488     /// @return true if the hard cap is reached.
489     function hardCapReached() internal constant returns (bool) {
490         return totalEthReceived >= HARD_CAP;
491     }
492 
493     /// @return true if the soft cap is reached.
494     function softCapReached() internal constant returns (bool) {
495         return totalEthReceived >= SOFT_CAP;
496     }
497 }