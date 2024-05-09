1 /*
2 
3   Copyright 2017 Loopring Foundation.
4 
5   Licensed under the Apache License, Version 2.0 (the "License");
6   you may not use this file except in compliance with the License.
7   You may obtain a copy of the License at
8 
9   http://www.apache.org/licenses/LICENSE-2.0
10 
11   Unless required by applicable law or agreed to in writing, software
12   distributed under the License is distributed on an "AS IS" BASIS,
13   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14   See the License for the specific language governing permissions and
15   limitations under the License.
16 
17 */
18 pragma solidity ^0.4.11;
19 
20 /**
21  * @title ERC20Basic
22  * @dev Simpler version of ERC20 interface
23  * @dev see https://github.com/ethereum/EIPs/issues/20
24  */
25 contract ERC20Basic {
26   uint public totalSupply;
27   function balanceOf(address who) constant returns (uint);
28   function transfer(address to, uint value);
29   event Transfer(address indexed from, address indexed to, uint value);
30 }
31 
32 /**
33  * Math operations with safety checks
34  */
35 library SafeMath {
36   function mul(uint a, uint b) internal returns (uint) {
37     uint c = a * b;
38     assert(a == 0 || c / a == b);
39     return c;
40   }
41 
42   function div(uint a, uint b) internal returns (uint) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     uint c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return c;
47   }
48 
49   function sub(uint a, uint b) internal returns (uint) {
50     assert(b <= a);
51     return a - b;
52   }
53 
54   function add(uint a, uint b) internal returns (uint) {
55     uint c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 
60   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
61     return a >= b ? a : b;
62   }
63 
64   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
65     return a < b ? a : b;
66   }
67 
68   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
69     return a >= b ? a : b;
70   }
71 
72   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
73     return a < b ? a : b;
74   }
75 
76   function assert(bool assertion) internal {
77     if (!assertion) {
78       throw;
79     }
80   }
81 }
82 
83 /**
84  * @title Basic token
85  * @dev Basic version of StandardToken, with no allowances. 
86  */
87 contract BasicToken is ERC20Basic {
88   using SafeMath for uint;
89 
90   mapping(address => uint) balances;
91 
92   /**
93    * @dev Fix for the ERC20 short address attack.
94    */
95   modifier onlyPayloadSize(uint size) {
96      if(msg.data.length < size + 4) {
97        throw;
98      }
99      _;
100   }
101 
102   /**
103   * @dev transfer token for a specified address
104   * @param _to The address to transfer to.
105   * @param _value The amount to be transferred.
106   */
107   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
108     balances[msg.sender] = balances[msg.sender].sub(_value);
109     balances[_to] = balances[_to].add(_value);
110     Transfer(msg.sender, _to, _value);
111   }
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of. 
116   * @return An uint representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) constant returns (uint balance) {
119     return balances[_owner];
120   }
121 
122 }
123 
124 /**
125  * @title ERC20 interface
126  * @dev see https://github.com/ethereum/EIPs/issues/20
127  */
128 contract ERC20 is ERC20Basic {
129   function allowance(address owner, address spender) constant returns (uint);
130   function transferFrom(address from, address to, uint value);
131   function approve(address spender, uint value);
132   event Approval(address indexed owner, address indexed spender, uint value);
133 }
134 
135 /**
136  * @title Standard ERC20 token
137  *
138  * @dev Implemantation of the basic standart token.
139  * @dev https://github.com/ethereum/EIPs/issues/20
140  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
141  */
142 contract StandardToken is BasicToken, ERC20 {
143 
144   mapping (address => mapping (address => uint)) allowed;
145 
146   /**
147    * @dev Transfer tokens from one address to another
148    * @param _from address The address which you want to send tokens from
149    * @param _to address The address which you want to transfer to
150    * @param _value uint the amout of tokens to be transfered
151    */
152   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
153     var _allowance = allowed[_from][msg.sender];
154 
155     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
156     // if (_value > _allowance) throw;
157 
158     balances[_to] = balances[_to].add(_value);
159     balances[_from] = balances[_from].sub(_value);
160     allowed[_from][msg.sender] = _allowance.sub(_value);
161     Transfer(_from, _to, _value);
162   }
163 
164   /**
165    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
166    * @param _spender The address which will spend the funds.
167    * @param _value The amount of tokens to be spent.
168    */
169   function approve(address _spender, uint _value) {
170 
171     // To change the approve amount you first have to reduce the addresses`
172     //  allowance to zero by calling `approve(_spender, 0)` if it is not
173     //  already 0 to mitigate the race condition described here:
174     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
176 
177     allowed[msg.sender][_spender] = _value;
178     Approval(msg.sender, _spender, _value);
179   }
180 
181   /**
182    * @dev Function to check the amount of tokens than an owner allowed to a spender.
183    * @param _owner address The address which owns the funds.
184    * @param _spender address The address which will spend the funds.
185    * @return A uint specifing the amount of tokens still avaible for the spender.
186    */
187   function allowance(address _owner, address _spender) constant returns (uint remaining) {
188     return allowed[_owner][_spender];
189   }
190 
191 }
192 
193 /// @title Loopring Protocol Token.
194 /// For more information about this token sale, please visit https://loopring.org
195 /// @author Kongliang Zhong - <kongliang@loopring.org>, Daniel Wang - <daniel@loopring.org>.
196 contract LoopringToken is StandardToken {
197     string public constant NAME = "LoopringCoin";
198     string public constant SYMBOL = "LRC";
199     uint public constant DECIMALS = 18;
200 
201     /// During token sale, we use one consistent price: 5000 LRC/ETH.
202     /// We split the entire token sale period into 10 phases, each
203     /// phase has a different bonus setting as specified in `bonusPercentages`.
204     /// The real price for phase i is `(1 + bonusPercentages[i]/100.0) * BASE_RATE`.
205     /// The first phase or early-bird phase has a much higher bonus.
206     uint8[10] public bonusPercentages = [
207         20,
208         16,
209         14,
210         12,
211         10,
212         8,
213         6,
214         4,
215         2,
216         0
217     ];
218 
219     uint public constant NUM_OF_PHASE = 10;
220   
221     /// Each phase contains exactly 15250 Ethereum blocks, which is roughly 3 days,
222     /// which makes this 10-phase sale period roughly 30 days.
223     /// See https://www.ethereum.org/crowdsale#scheduling-a-call
224     uint16 public constant BLOCKS_PER_PHASE = 15250;
225 
226     /// This is where we hold ETH during this token sale. We will not transfer any Ether
227     /// out of this address before we invocate the `close` function to finalize the sale. 
228     /// This promise is not guanranteed by smart contract by can be verified with public
229     /// Ethereum transactions data available on several blockchain browsers.
230     /// This is the only address from which `start` and `close` can be invocated.
231     ///
232     /// Note: this will be initialized during the contract deployment.
233     address public target;
234 
235     /// `firstblock` specifies from which block our token sale starts.
236     /// This can only be modified once by the owner of `target` address.
237     uint public firstblock = 0;
238 
239     /// Indicates whether unsold token have been issued. This part of LRC token
240     /// is managed by the project team and is issued directly to `target`.
241     bool public unsoldTokenIssued = false;
242 
243     /// Minimum amount of funds to be raised for the sale to succeed. 
244     uint256 public constant GOAL = 50000 ether;
245 
246     /// Maximum amount of fund to be raised, the sale ends on reaching this amount.
247     uint256 public constant HARD_CAP = 120000 ether;
248 
249     /// Maximum unsold ratio, this is hit when the mininum level of amount of fund is raised.
250     uint public constant MAX_UNSOLD_RATIO = 675; // 67.5%
251 
252     /// Base exchange rate is set to 1 ETH = 5000 LRC.
253     uint256 public constant BASE_RATE = 5000;
254 
255     /// A simple stat for emitting events.
256     uint public totalEthReceived = 0;
257 
258     /// Issue event index starting from 0.
259     uint public issueIndex = 0;
260 
261     /* 
262      * EVENTS
263      */
264 
265     /// Emitted only once after token sale starts.
266     event SaleStarted();
267 
268     /// Emitted only once after token sale ended (all token issued).
269     event SaleEnded();
270 
271     /// Emitted when a function is invocated by unauthorized addresses.
272     event InvalidCaller(address caller);
273 
274     /// Emitted when a function is invocated without the specified preconditions.
275     /// This event will not come alone with an exception.
276     event InvalidState(bytes msg);
277 
278     /// Emitted for each sucuessful token purchase.
279     event Issue(uint issueIndex, address addr, uint ethAmount, uint tokenAmount);
280 
281     /// Emitted if the token sale succeeded.
282     event SaleSucceeded();
283 
284     /// Emitted if the token sale failed.
285     /// When token sale failed, all Ether will be return to the original purchasing
286     /// address with a minor deduction of transaction fee（gas)
287     event SaleFailed();
288 
289     /*
290      * MODIFIERS
291      */
292 
293     modifier onlyOwner {
294         if (target == msg.sender) {
295             _;
296         } else {
297             InvalidCaller(msg.sender);
298             throw;
299         }
300     }
301 
302     modifier beforeStart {
303         if (!saleStarted()) {
304             _;
305         } else {
306             InvalidState("Sale has not started yet");
307             throw;
308         }
309     }
310 
311     modifier inProgress {
312         if (saleStarted() && !saleEnded()) {
313             _;
314         } else {
315             InvalidState("Sale is not in progress");
316             throw;
317         }
318     }
319 
320     modifier afterEnd {
321         if (saleEnded()) {
322             _;
323         } else {
324             InvalidState("Sale is not ended yet");
325             throw;
326         }
327     }
328 
329     /**
330      * CONSTRUCTOR 
331      * 
332      * @dev Initialize the Loopring Token
333      * @param _target The escrow account address, all ethers will
334      * be sent to this address.
335      * This address will be : 0x00073F7155459C9205010Cb3453a0f392a0C3210
336      */
337     function LoopringToken(address _target) {
338         target = _target;
339     }
340 
341     /*
342      * PUBLIC FUNCTIONS
343      */
344 
345     /// @dev Start the token sale.
346     /// @param _firstblock The block from which the sale will start.
347     function start(uint _firstblock) public onlyOwner beforeStart {
348         if (_firstblock <= block.number) {
349             // Must specify a block in the future.
350             throw;
351         }
352 
353         firstblock = _firstblock;
354         SaleStarted();
355     }
356 
357     /// @dev Triggers unsold tokens to be issued to `target` address.
358     function close() public onlyOwner afterEnd {
359         if (totalEthReceived < GOAL) {
360             SaleFailed();
361         } else {
362             issueUnsoldToken();
363             SaleSucceeded();
364         }
365     }
366 
367     /// @dev Returns the current price.
368     function price() public constant returns (uint tokens) {
369         return computeTokenAmount(1 ether);
370     }
371 
372     /// @dev This default function allows token to be purchased by directly
373     /// sending ether to this smart contract.
374     function () payable {
375         issueToken(msg.sender);
376     }
377 
378     /// @dev Issue token based on Ether received.
379     /// @param recipient Address that newly issued token will be sent to.
380     function issueToken(address recipient) payable inProgress {
381         // We only accept minimum purchase of 0.01 ETH.
382         assert(msg.value >= 0.01 ether);
383 
384         uint tokens = computeTokenAmount(msg.value);
385         totalEthReceived = totalEthReceived.add(msg.value);
386         totalSupply = totalSupply.add(tokens);
387         balances[recipient] = balances[recipient].add(tokens);
388 
389         Issue(
390             issueIndex++,
391             recipient,
392             msg.value,
393             tokens
394         );
395 
396         if (!target.send(msg.value)) {
397             throw;
398         }
399     }
400 
401     /*
402      * INTERNAL FUNCTIONS
403      */
404   
405     /// @dev Compute the amount of LRC token that can be purchased.
406     /// @param ethAmount Amount of Ether to purchase LRC.
407     /// @return Amount of LRC token to purchase
408     function computeTokenAmount(uint ethAmount) internal constant returns (uint tokens) {
409         uint phase = (block.number - firstblock).div(BLOCKS_PER_PHASE);
410 
411         // A safe check
412         if (phase >= bonusPercentages.length) {
413             phase = bonusPercentages.length - 1;
414         }
415 
416         uint tokenBase = ethAmount.mul(BASE_RATE);
417         uint tokenBonus = tokenBase.mul(bonusPercentages[phase]).div(100);
418 
419         tokens = tokenBase.add(tokenBonus);
420     }
421 
422     /// @dev Issue unsold token to `target` address.
423     /// The math is as follows:
424     ///   +-------------------------------------------------------------+
425     ///   |       Total Ethers Received        |                        |
426     ///   +------------------------------------+  Unsold Token Portion  |
427     ///   |   Lower Bound   |   Upper Bound    |                        |
428     ///   +-------------------------------------------------------------+
429     ///   |      50,000     |     60,000       |         67.5%          |
430     ///   +-------------------------------------------------------------+
431     ///   |      60,000     |     70,000       |         65.0%          |
432     ///   +-------------------------------------------------------------+
433     ///   |      70,000     |     80,000       |         62.5%          |
434     ///   +-------------------------------------------------------------+
435     ///   |      80,000     |     90,000       |         60.0%          |
436     ///   +-------------------------------------------------------------+
437     ///   |      90,000     |    100,000       |         57.5%          |
438     ///   +-------------------------------------------------------------+
439     ///   |     100,000     |    110,000       |         55.0%          |
440     ///   +-------------------------------------------------------------+
441     ///   |     110,000     |    120,000       |         52.5%          |
442     ///   +-------------------------------------------------------------+
443     ///   |     120,000     |                  |         50.0%          |
444     ///   +-------------------------------------------------------------+
445     function issueUnsoldToken() internal {
446         if (unsoldTokenIssued) {
447             InvalidState("Unsold token has been issued already");
448         } else {
449             // Add another safe guard 
450             require(totalEthReceived >= GOAL);
451 
452             uint level = totalEthReceived.sub(GOAL).div(10000 ether);
453             if (level > 7) {
454                 level = 7;
455             }
456 
457             uint unsoldRatioInThousand = MAX_UNSOLD_RATIO - 25 * level;
458 
459 
460             // Calculate the `unsoldToken` to be issued, the amount of `unsoldToken`
461             // is based on the issued amount, that is the `totalSupply`, during 
462             // the sale:
463             //                   totalSupply
464             //   unsoldToken = --------------- * r
465             //                      1 - r
466             uint unsoldToken = totalSupply.div(1000 - unsoldRatioInThousand).mul(unsoldRatioInThousand);
467 
468             // Adjust `totalSupply`.
469             totalSupply = totalSupply.add(unsoldToken);
470             // Issue `unsoldToken` to the target account.
471             balances[target] = balances[target].add(unsoldToken);
472 
473             Issue(
474                 issueIndex++,
475                 target,
476                 0,
477                 unsoldToken
478             );
479             
480             unsoldTokenIssued = true;
481         }
482     }
483 
484     /// @return true if sale has started, false otherwise.
485     function saleStarted() constant returns (bool) {
486         return (firstblock > 0 && block.number >= firstblock);
487     }
488 
489     /// @return true if sale has ended, false otherwise.
490     function saleEnded() constant returns (bool) {
491         return firstblock > 0 && (saleDue() || hardCapReached());
492     }
493 
494     /// @return true if sale is due when the last phase is finished.
495     function saleDue() constant returns (bool) {
496         return block.number >= firstblock + BLOCKS_PER_PHASE * NUM_OF_PHASE;
497     }
498 
499     /// @return true if the hard cap is reached.
500     function hardCapReached() constant returns (bool) {
501         return totalEthReceived >= HARD_CAP;
502     }
503 }