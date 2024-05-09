1 /*
2 
3   Copyright 2017 TGC Foundation.
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
19 /**
20  * Math operations with safety checks
21  */
22 library SafeMath {
23   function mul(uint a, uint b) internal returns (uint) {
24     uint c = a * b;
25     assert(a == 0 || c / a == b);
26     return c;
27   }
28 
29   function div(uint a, uint b) internal returns (uint) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36   function sub(uint a, uint b) internal returns (uint) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function add(uint a, uint b) internal returns (uint) {
42     uint c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 
47   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
48     return a >= b ? a : b;
49   }
50 
51   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
52     return a < b ? a : b;
53   }
54 
55   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
56     return a >= b ? a : b;
57   }
58 
59   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
60     return a < b ? a : b;
61   }
62 
63   function assert(bool assertion) internal {
64     if (!assertion) {
65       throw;
66     }
67   }
68 }
69 /**
70  * @title ERC20Basic
71  * @dev Simpler version of ERC20 interface
72  * @dev see https://github.com/ethereum/EIPs/issues/20
73  */
74 contract ERC20Basic {
75   uint public totalSupply;
76   function balanceOf(address who) constant returns (uint);
77   function transfer(address to, uint value);
78   event Transfer(address indexed from, address indexed to, uint value);
79 }
80 /**
81  * @title ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/20
83  */
84 contract ERC20 is ERC20Basic {
85   function allowance(address owner, address spender) constant returns (uint);
86   function transferFrom(address from, address to, uint value);
87   function approve(address spender, uint value);
88   event Approval(address indexed owner, address indexed spender, uint value);
89 }
90 
91 /**
92  * @title Basic token
93  * @dev Basic version of StandardToken, with no allowances. 
94  */
95 contract BasicToken is ERC20Basic {
96   using SafeMath for uint;
97 
98   mapping(address => uint) balances;
99 
100   /**
101    * @dev Fix for the ERC20 short address attack.
102    */
103   modifier onlyPayloadSize(uint size) {
104      if(msg.data.length < size + 4) {
105        throw;
106      }
107      _;
108   }
109 
110   /**
111   * @dev transfer token for a specified address
112   * @param _to The address to transfer to.
113   * @param _value The amount to be transferred.
114   */
115   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
116     balances[msg.sender] = balances[msg.sender].sub(_value);
117     balances[_to] = balances[_to].add(_value);
118     Transfer(msg.sender, _to, _value);
119   }
120 
121   /**
122   * @dev Gets the balance of the specified address.
123   * @param _owner The address to query the the balance of. 
124   * @return An uint representing the amount owned by the passed address.
125   */
126   function balanceOf(address _owner) constant returns (uint balance) {
127     return balances[_owner];
128   }
129 
130 }
131 
132 /**
133  * @title Standard ERC20 token
134  *
135  * @dev Implemantation of the basic standart token.
136  * @dev https://github.com/ethereum/EIPs/issues/20
137  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
138  */
139 contract StandardToken is BasicToken, ERC20 {
140 
141   mapping (address => mapping (address => uint)) allowed;
142 
143 
144   /**
145    * @dev Transfer tokens from one address to another
146    * @param _from address The address which you want to send tokens from
147    * @param _to address The address which you want to transfer to
148    * @param _value uint the amout of tokens to be transfered
149    */
150   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
151     var _allowance = allowed[_from][msg.sender];
152 
153     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
154     // if (_value > _allowance) throw;
155 
156     balances[_to] = balances[_to].add(_value);
157     balances[_from] = balances[_from].sub(_value);
158     allowed[_from][msg.sender] = _allowance.sub(_value);
159     Transfer(_from, _to, _value);
160   }
161 
162   /**
163    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
164    * @param _spender The address which will spend the funds.
165    * @param _value The amount of tokens to be spent.
166    */
167   function approve(address _spender, uint _value) {
168 
169     // To change the approve amount you first have to reduce the addresses`
170     //  allowance to zero by calling `approve(_spender, 0)` if it is not
171     //  already 0 to mitigate the race condition described here:
172     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
174 
175     allowed[msg.sender][_spender] = _value;
176     Approval(msg.sender, _spender, _value);
177   }
178 
179   /**
180    * @dev Function to check the amount of tokens than an owner allowed to a spender.
181    * @param _owner address The address which owns the funds.
182    * @param _spender address The address which will spend the funds.
183    * @return A uint specifing the amount of tokens still avaible for the spender.
184    */
185   function allowance(address _owner, address _spender) constant returns (uint remaining) {
186     return allowed[_owner][_spender];
187   }
188 
189 }
190 
191 
192 /// @title TGC Protocol Token.
193 /// For more information about this token sale, please visit http://mijunyun.com
194 /// @author lengfeng - <lengfeng@mijunyun.com>, tianlong - <tianlong@mijunyun.com>.
195 contract TGCToken is StandardToken {
196     string public constant NAME = "Tigercoin";
197     string public constant SYMBOL = "TGC";
198     uint public constant DECIMALS = 18;
199 
200     /// During token sale, we use one consistent price: 1000 TGC/ETH.
201     /// We split the entire token sale period into 3 phases, each
202     /// phase has a different bonus setting as specified in `bonusPercentages`.
203     /// The real price for phase i is `(1 + bonusPercentages[i]/100.0) * BASE_RATE`.
204     /// The first phase or early-bird phase has a much higher bonus.
205     uint8[10] public bonusPercentages = [
206         20,
207         10,
208         0
209     ];
210 
211     uint public constant NUM_OF_PHASE = 3;
212   
213     /// Each phase contains exactly 29000 Ethereum blocks, which is roughly 7 days,
214     /// which makes this 3-phase sale period roughly 21 days.
215     /// See https://www.ethereum.org/crowdsale#scheduling-a-call
216     uint16 public constant BLOCKS_PER_PHASE = 29000;
217 
218     /// This is where we hold ETH during this token sale. We will not transfer any Ether
219     /// out of this address before we invocate the `close` function to finalize the sale. 
220     /// This promise is not guanranteed by smart contract by can be verified with public
221     /// Ethereum transactions data available on several blockchain browsers.
222     /// This is the only address from which `start` and `close` can be invocated.
223     ///
224     /// Note: this will be initialized during the contract deployment.
225     address public target;
226 
227     /// `firstblock` specifies from which block our token sale starts.
228     /// This can only be modified once by the owner of `target` address.
229     uint public firstblock = 0;
230 
231     /// Indicates whether unsold token have been issued. This part of TGC token
232     /// is managed by the project team and is issued directly to `target`.
233     bool public unsoldTokenIssued = false;
234 
235     /// Minimum amount of funds to be raised for the sale to succeed. 
236     uint256 public constant GOAL = 3000 ether;
237 
238     /// Maximum amount of fund to be raised, the sale ends on reaching this amount.
239     uint256 public constant HARD_CAP = 4500 ether;
240 
241     /// Base exchange rate is set to 1 ETH = 10000 TGC.
242     uint256 public constant BASE_RATE = 10000;
243 
244     /// A simple stat for emitting events.
245     uint public totalEthReceived = 0;
246 
247     /// Issue event index starting from 0.
248     uint public issueIndex = 0;
249 
250     /* 
251      * EVENTS
252      */
253 
254     /// Emitted only once after token sale starts.
255     event SaleStarted();
256 
257     /// Emitted only once after token sale ended (all token issued).
258     event SaleEnded();
259 
260     /// Emitted when a function is invocated by unauthorized addresses.
261     event InvalidCaller(address caller);
262 
263     /// Emitted when a function is invocated without the specified preconditions.
264     /// This event will not come alone with an exception.
265     event InvalidState(bytes msg);
266 
267     /// Emitted for each sucuessful token purchase.
268     event Issue(uint issueIndex, address addr, uint ethAmount, uint tokenAmount);
269 
270     /// Emitted if the token sale succeeded.
271     event SaleSucceeded();
272 
273     /// Emitted if the token sale failed.
274     /// When token sale failed, all Ether will be return to the original purchasing
275     /// address with a minor deduction of transaction fee（gas)
276     event SaleFailed();
277 
278     /*
279      * MODIFIERS
280      */
281 
282     modifier onlyOwner {
283         if (target == msg.sender) {
284             _;
285         } else {
286             InvalidCaller(msg.sender);
287             throw;
288         }
289     }
290 
291     modifier beforeStart {
292         if (!saleStarted()) {
293             _;
294         } else {
295             InvalidState("Sale has not started yet");
296             throw;
297         }
298     }
299 
300     modifier inProgress {
301         if (saleStarted() && !saleEnded()) {
302             _;
303         } else {
304             InvalidState("Sale is not in progress");
305             throw;
306         }
307     }
308 
309     modifier afterEnd {
310         if (saleEnded()) {
311             _;
312         } else {
313             InvalidState("Sale is not ended yet");
314             throw;
315         }
316     }
317 
318     /**
319      * CONSTRUCTOR 
320      * 
321      * @dev Initialize the TGC Token
322      * @param _target The escrow account address, all ethers will
323      * be sent to this address.
324      * This address will be : 0x778b80a5A63ff096274073B0Eb4d2DAEE7b05967
325      */
326     function TGCToken(address _target) {
327         target = _target;
328         totalSupply = 10 ** 26;
329         balances[target] = totalSupply;
330     }
331 
332     /*
333      * PUBLIC FUNCTIONS
334      */
335 
336     /// @dev Start the token sale.
337     /// @param _firstblock The block from which the sale will start.
338     function start(uint _firstblock) public onlyOwner beforeStart {
339         if (_firstblock <= block.number) {
340             // Must specify a block in the future.
341             throw;
342         }
343 
344         firstblock = _firstblock;
345         SaleStarted();
346     }
347 
348     /// @dev Triggers unsold tokens to be issued to `target` address.
349     function close() public onlyOwner afterEnd {
350         if (totalEthReceived < GOAL) {
351             SaleFailed();
352         } else {
353             SaleSucceeded();
354         }
355     }
356 
357     /// @dev Returns the current price.
358     function price() public constant returns (uint tokens) {
359         return computeTokenAmount(1 ether);
360     }
361 
362     /// @dev This default function allows token to be purchased by directly
363     /// sending ether to this smart contract.
364     function () payable {
365         issueToken(msg.sender);
366     }
367 
368     /// @dev Issue token based on Ether received.
369     /// @param recipient Address that newly issued token will be sent to.
370     function issueToken(address recipient) payable inProgress {
371         // We only accept minimum purchase of 0.01 ETH.
372         assert(msg.value >= 0.01 ether);
373 
374         // We only accept maximum purchase of 35 ETH.
375         assert(msg.value <= 35 ether);
376 
377         // We only accept totalEthReceived < HARD_CAP
378         uint ethReceived = totalEthReceived + msg.value;
379         assert(ethReceived <= HARD_CAP);
380 
381         uint tokens = computeTokenAmount(msg.value);
382         totalEthReceived = totalEthReceived.add(msg.value);
383         
384         balances[msg.sender] = balances[msg.sender].add(tokens);
385         balances[target] = balances[target].sub(tokens);
386 
387         Issue(
388             issueIndex++,
389             recipient,
390             msg.value,
391             tokens
392         );
393 
394         if (!target.send(msg.value)) {
395             throw;
396         }
397     }
398 
399     /*
400      * INTERNAL FUNCTIONS
401      */
402   
403     /// @dev Compute the amount of TGC token that can be purchased.
404     /// @param ethAmount Amount of Ether to purchase TGC.
405     /// @return Amount of TGC token to purchase
406     function computeTokenAmount(uint ethAmount) internal constant returns (uint tokens) {
407         uint phase = (block.number - firstblock).div(BLOCKS_PER_PHASE);
408 
409         // A safe check
410         if (phase >= bonusPercentages.length) {
411             phase = bonusPercentages.length - 1;
412         }
413 
414         uint tokenBase = ethAmount.mul(BASE_RATE);
415         uint tokenBonus = tokenBase.mul(bonusPercentages[phase]).div(100);
416 
417         tokens = tokenBase.add(tokenBonus);
418     }
419 
420     /// @return true if sale has started, false otherwise.
421     function saleStarted() constant returns (bool) {
422         return (firstblock > 0 && block.number >= firstblock);
423     }
424 
425     /// @return true if sale has ended, false otherwise.
426     function saleEnded() constant returns (bool) {
427         return firstblock > 0 && (saleDue() || hardCapReached());
428     }
429 
430     /// @return true if sale is due when the last phase is finished.
431     function saleDue() constant returns (bool) {
432         return block.number >= firstblock + BLOCKS_PER_PHASE * NUM_OF_PHASE;
433     }
434 
435     /// @return true if the hard cap is reached.
436     function hardCapReached() constant returns (bool) {
437         return totalEthReceived >= HARD_CAP;
438     }
439 }