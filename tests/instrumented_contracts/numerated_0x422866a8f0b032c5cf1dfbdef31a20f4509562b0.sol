1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20Basic {
9   uint public totalSupply;
10   function balanceOf(address who) constant returns (uint);
11   function transfer(address to, uint value);
12   event Transfer(address indexed from, address indexed to, uint value);
13 }
14 
15 /**
16  * Math operations with safety checks
17  */
18 library SafeMath {
19   function mul(uint a, uint b) internal returns (uint) {
20     uint c = a * b;
21     assert(a == 0 || c / a == b);
22     return c;
23   }
24 
25   function div(uint a, uint b) internal returns (uint) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   function sub(uint a, uint b) internal returns (uint) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   function add(uint a, uint b) internal returns (uint) {
38     uint c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 
43   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
44     return a >= b ? a : b;
45   }
46 
47   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
48     return a < b ? a : b;
49   }
50 
51   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
52     return a >= b ? a : b;
53   }
54 
55   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
56     return a < b ? a : b;
57   }
58   
59   /**
60    * Based on http://www.codecodex.com/wiki/Calculate_an_integer_square_root
61    */
62   function sqrt(uint num) internal returns (uint) {
63     if (0 == num) { // Avoid zero divide 
64       return 0; 
65     }   
66     uint n = (num / 2) + 1;      // Initial estimate, never low  
67     uint n1 = (n + (num / n)) / 2;  
68     while (n1 < n) {  
69       n = n1;  
70       n1 = (n + (num / n)) / 2;  
71     }  
72     return n;  
73   }
74 
75   function assert(bool assertion) internal {
76     if (!assertion) {
77       throw;
78     }
79   }
80 }
81 
82 /**
83  * @title Basic token
84  * @dev Basic version of StandardToken, with no allowances. 
85  */
86 contract BasicToken is ERC20Basic {
87   using SafeMath for uint;
88 
89   mapping(address => uint) balances;
90 
91   /**
92    * @dev Fix for the ERC20 short address attack.
93    */
94   modifier onlyPayloadSize(uint size) {
95      if(msg.data.length < size + 4) {
96        throw;
97      }
98      _;
99   }
100 
101   /**
102   * @dev transfer token for a specified address
103   * @param _to The address to transfer to.
104   * @param _value The amount to be transferred.
105   */
106   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     Transfer(msg.sender, _to, _value);
110   }
111 
112   /**
113   * @dev Gets the balance of the specified address.
114   * @param _owner The address to query the the balance of. 
115   * @return An uint representing the amount owned by the passed address.
116   */
117   function balanceOf(address _owner) constant returns (uint balance) {
118     return balances[_owner];
119   }
120 
121 }
122 
123 /**
124  * @title ERC20 interface
125  * @dev see https://github.com/ethereum/EIPs/issues/20
126  */
127 contract ERC20 is ERC20Basic {
128   function allowance(address owner, address spender) constant returns (uint);
129   function transferFrom(address from, address to, uint value);
130   function approve(address spender, uint value);
131   event Approval(address indexed owner, address indexed spender, uint value);
132 }
133 
134 /**
135  * @title Standard ERC20 token
136  *
137  * @dev Implemantation of the basic standart token.
138  * @dev https://github.com/ethereum/EIPs/issues/20
139  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
140  */
141 contract StandardToken is BasicToken, ERC20 {
142 
143   mapping (address => mapping (address => uint)) allowed;
144 
145   /**
146    * @dev Transfer tokens from one address to another
147    * @param _from address The address which you want to send tokens from
148    * @param _to address The address which you want to transfer to
149    * @param _value uint the amout of tokens to be transfered
150    */
151   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
152     var _allowance = allowed[_from][msg.sender];
153 
154     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
155     // if (_value > _allowance) throw;
156 
157     balances[_to] = balances[_to].add(_value);
158     balances[_from] = balances[_from].sub(_value);
159     allowed[_from][msg.sender] = _allowance.sub(_value);
160     Transfer(_from, _to, _value);
161   }
162 
163   /**
164    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
165    * @param _spender The address which will spend the funds.
166    * @param _value The amount of tokens to be spent.
167    */
168   function approve(address _spender, uint _value) {
169 
170     // To change the approve amount you first have to reduce the addresses`
171     //  allowance to zero by calling `approve(_spender, 0)` if it is not
172     //  already 0 to mitigate the race condition described here:
173     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
175 
176     allowed[msg.sender][_spender] = _value;
177     Approval(msg.sender, _spender, _value);
178   }
179 
180   /**
181    * @dev Function to check the amount of tokens than an owner allowed to a spender.
182    * @param _owner address The address which owns the funds.
183    * @param _spender address The address which will spend the funds.
184    * @return A uint specifing the amount of tokens still avaible for the spender.
185    */
186   function allowance(address _owner, address _spender) constant returns (uint remaining) {
187     return allowed[_owner][_spender];
188   }
189 
190 }
191 
192 /**
193  * @title Adshares ICO token
194  * 
195  * see https://github.com/adshares/ico
196  *
197  */
198 contract AdsharesToken is StandardToken {
199     using SafeMath for uint;
200 
201     // metadata
202     string public constant name = "Adshares Token";
203     string public constant symbol = "ADST";
204     uint public constant decimals = 0;
205     
206     // crowdsale parameters
207     uint public constant tokenCreationMin = 10000000;
208     uint public constant tokenPriceMin = 0.0004 ether;
209     uint public constant tradeSpreadInvert = 50; // 2%
210     uint public constant crowdsaleEndLockTime = 1 weeks;
211     uint public constant fundingUnlockPeriod = 1 weeks;
212     uint public constant fundingUnlockFractionInvert = 100; // 1 %
213     
214     // contructor parameters
215     uint public crowdsaleStartBlock;
216     address public owner1;
217     address public owner2;
218     address public withdrawAddress; // multi-sig wallet that will receive ether
219 
220     
221     // contract state
222     bool public minFundingReached;
223     uint public crowdsaleEndDeclarationTime = 0;
224     uint public fundingUnlockTime = 0;  
225     uint public unlockedBalance = 0;  
226     uint public withdrawnBalance = 0;
227     bool public isHalted = false;
228 
229     // events
230     event LogBuy(address indexed who, uint tokens, uint purchaseValue, uint supplyAfter);
231     event LogSell(address indexed who, uint tokens, uint saleValue, uint supplyAfter);
232     event LogWithdraw(uint amount);
233     event LogCrowdsaleEnd(bool completed);    
234     
235     /**
236      * @dev Checks if funding is active
237      */
238     modifier fundingActive() {
239       // Not yet started
240       if (block.number < crowdsaleStartBlock) {
241         throw;
242       }
243       // Already ended
244       if (crowdsaleEndDeclarationTime > 0 && block.timestamp > crowdsaleEndDeclarationTime + crowdsaleEndLockTime) {
245           throw;
246         }
247       _;
248     }
249     
250     /**
251      * @dev Throws if called by any account other than one of the owners. 
252      */
253     modifier onlyOwner() {
254       if (msg.sender != owner1 && msg.sender != owner2) {
255         throw;
256       }
257       _;
258     }
259     
260     // constructor
261     function AdsharesToken (address _owner1, address _owner2, address _withdrawAddress, uint _crowdsaleStartBlock)
262     {
263         owner1 = _owner1;
264         owner2 = _owner2;
265         withdrawAddress = _withdrawAddress;
266         crowdsaleStartBlock = _crowdsaleStartBlock;
267     }
268     
269     /**
270      * Returns not yet unlocked balance
271      */
272     function getLockedBalance() private constant returns (uint lockedBalance) {
273         return this.balance.sub(unlockedBalance);
274       }
275     
276     /**
277      * @dev Calculates how many tokens one can buy for specified value
278      * @return Amount of tokens one will receive and purchase value without remainder. 
279      */
280     function getBuyPrice(uint _bidValue) constant returns (uint tokenCount, uint purchaseValue) {
281 
282         // Token price formula is twofold. We have flat pricing below tokenCreationMin, 
283         // and above that price linarly increases with supply. 
284 
285         uint flatTokenCount;
286         uint startSupply;
287         uint linearBidValue;
288         
289         if(totalSupply < tokenCreationMin) {
290             uint maxFlatTokenCount = _bidValue.div(tokenPriceMin);
291             // entire purchase in flat pricing
292             if(totalSupply.add(maxFlatTokenCount) <= tokenCreationMin) {
293                 return (maxFlatTokenCount, maxFlatTokenCount.mul(tokenPriceMin));
294             }
295             flatTokenCount = tokenCreationMin.sub(totalSupply);
296             linearBidValue = _bidValue.sub(flatTokenCount.mul(tokenPriceMin));
297             startSupply = tokenCreationMin;
298         } else {
299             flatTokenCount = 0;
300             linearBidValue = _bidValue;
301             startSupply = totalSupply;
302         }
303         
304         // Solves quadratic equation to calculate maximum token count that can be purchased
305         uint currentPrice = tokenPriceMin.mul(startSupply).div(tokenCreationMin);
306         uint delta = (2 * startSupply).mul(2 * startSupply).add(linearBidValue.mul(4 * 1 * 2 * startSupply).div(currentPrice));
307 
308         uint linearTokenCount = delta.sqrt().sub(2 * startSupply).div(2);
309         uint linearAvgPrice = currentPrice.add((startSupply+linearTokenCount+1).mul(tokenPriceMin).div(tokenCreationMin)).div(2);
310         
311         // double check to eliminate rounding errors
312         linearTokenCount = linearBidValue / linearAvgPrice;
313         linearAvgPrice = currentPrice.add((startSupply+linearTokenCount+1).mul(tokenPriceMin).div(tokenCreationMin)).div(2);
314         
315         purchaseValue = linearTokenCount.mul(linearAvgPrice).add(flatTokenCount.mul(tokenPriceMin));
316         return (
317             flatTokenCount + linearTokenCount,
318             purchaseValue
319         );
320      }
321     
322     /**
323      * @dev Calculates average token price for sale of specified token count
324      * @return Total value received for given sale size. 
325      */
326     function getSellPrice(uint _askSizeTokens) constant returns (uint saleValue) {
327         
328         uint flatTokenCount;
329         uint linearTokenMin;
330         
331         if(totalSupply <= tokenCreationMin) {
332             return tokenPriceMin * _askSizeTokens;
333         }
334         if(totalSupply.sub(_askSizeTokens) < tokenCreationMin) {
335             flatTokenCount = tokenCreationMin - totalSupply.sub(_askSizeTokens);
336             linearTokenMin = tokenCreationMin;
337         } else {
338             flatTokenCount = 0;
339             linearTokenMin = totalSupply.sub(_askSizeTokens);
340         }
341         uint linearTokenCount = _askSizeTokens - flatTokenCount;
342         
343         uint minPrice = (linearTokenMin).mul(tokenPriceMin).div(tokenCreationMin);
344         uint maxPrice = (totalSupply+1).mul(tokenPriceMin).div(tokenCreationMin);
345         
346         uint linearAveragePrice = minPrice.add(maxPrice).div(2);
347         return linearAveragePrice.mul(linearTokenCount).add(flatTokenCount.mul(tokenPriceMin));
348     }
349     
350     /**
351      * Default function called by sending Ether to this address with no arguments.
352      * @dev Buy tokens with market order
353      */
354     function() payable fundingActive
355     {
356         buyLimit(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
357     }
358     
359     /**
360      * @dev Buy tokens without price limit
361      */
362     function buy() payable external fundingActive {
363         buyLimit(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);    
364     }
365     
366     /**
367      * @dev Buy tokens with limit maximum average price
368      * @param _maxPrice Maximum price user want to pay for one token
369      */
370     function buyLimit(uint _maxPrice) payable public fundingActive {
371         require(msg.value >= tokenPriceMin);
372         assert(!isHalted);
373         
374         uint boughtTokens;
375         uint averagePrice;
376         uint purchaseValue;
377         
378         (boughtTokens, purchaseValue) = getBuyPrice(msg.value);
379         if(boughtTokens == 0) { 
380             // bid to small, return ether and abort
381             msg.sender.transfer(msg.value);
382             return; 
383         }
384         averagePrice = purchaseValue.div(boughtTokens);
385         if(averagePrice > _maxPrice) { 
386             // price too high, return ether and abort
387             msg.sender.transfer(msg.value);
388             return; 
389         }
390         assert(averagePrice >= tokenPriceMin);
391         assert(purchaseValue <= msg.value);
392         
393         totalSupply = totalSupply.add(boughtTokens);
394         balances[msg.sender] = balances[msg.sender].add(boughtTokens);
395         
396         if(!minFundingReached && totalSupply >= tokenCreationMin) {
397             minFundingReached = true;
398             fundingUnlockTime = block.timestamp;
399             // this.balance contains ether sent in this message
400             unlockedBalance += this.balance.sub(msg.value).div(tradeSpreadInvert);
401         }
402         if(minFundingReached) {
403             unlockedBalance += purchaseValue.div(tradeSpreadInvert);
404         }
405         
406         LogBuy(msg.sender, boughtTokens, purchaseValue, totalSupply);
407         
408         if(msg.value > purchaseValue) {
409             msg.sender.transfer(msg.value.sub(purchaseValue));
410         }
411     }
412     
413     /**
414      * @dev Sell tokens without limit on price
415      * @param _tokenCount Amount of tokens user wants to sell
416      */
417     function sell(uint _tokenCount) external fundingActive {
418         sellLimit(_tokenCount, 0);
419     }
420     
421     /**
422      * @dev Sell tokens with limit on minimum average priceprice
423      * @param _tokenCount Amount of tokens user wants to sell
424      * @param _minPrice Minimum price user wants to receive for one token
425      */
426     function sellLimit(uint _tokenCount, uint _minPrice) public fundingActive {
427         require(_tokenCount > 0);
428 
429         assert(balances[msg.sender] >= _tokenCount);
430         
431         uint saleValue = getSellPrice(_tokenCount);
432         uint averagePrice = saleValue.div(_tokenCount);
433         assert(averagePrice >= tokenPriceMin);
434         if(minFundingReached) {
435             averagePrice -= averagePrice.div(tradeSpreadInvert);
436             saleValue -= saleValue.div(tradeSpreadInvert);
437         }
438         
439         if(averagePrice < _minPrice) {
440             // price too high, abort
441             return;
442         }
443         // not enough ether for buyback
444         assert(saleValue <= this.balance);
445           
446         totalSupply = totalSupply.sub(_tokenCount);
447         balances[msg.sender] = balances[msg.sender].sub(_tokenCount);
448         
449         LogSell(msg.sender, _tokenCount, saleValue, totalSupply);
450         
451         msg.sender.transfer(saleValue);
452     }   
453     
454     /**
455      * @dev Unlock funds for withdrawal. Only 1% can be unlocked weekly.
456      */
457     function unlockFunds() external onlyOwner fundingActive {
458         assert(minFundingReached);
459         assert(block.timestamp >= fundingUnlockTime);
460         
461         uint unlockedAmount = getLockedBalance().div(fundingUnlockFractionInvert);
462         unlockedBalance += unlockedAmount;
463         assert(getLockedBalance() > 0);
464         
465         fundingUnlockTime += fundingUnlockPeriod;
466     }
467     
468     /**
469      * @dev Withdraw funds. Only unlocked funds can be withdrawn.
470      */
471     function withdrawFunds(uint _value) external onlyOwner fundingActive onlyPayloadSize(32) {
472         require(_value <= unlockedBalance);
473         assert(minFundingReached);
474              
475         unlockedBalance -= _value;
476         withdrawnBalance += _value;
477         LogWithdraw(_value);
478         
479         withdrawAddress.transfer(_value);
480     }
481     
482     /**
483      * @dev Declares that crowdsale is about to end. Users have one week to decide if the want to keep token or sell them to contract.
484      */
485     function declareCrowdsaleEnd() external onlyOwner fundingActive {
486         assert(minFundingReached);
487         assert(crowdsaleEndDeclarationTime == 0);
488         
489         crowdsaleEndDeclarationTime = block.timestamp;
490         LogCrowdsaleEnd(false);
491     }
492     
493     /**
494      * @dev Can be called one week after initial declaration. Withdraws ether and stops trading. Tokens remain in circulation.
495      */
496     function confirmCrowdsaleEnd() external onlyOwner {
497         assert(crowdsaleEndDeclarationTime > 0 && block.timestamp > crowdsaleEndDeclarationTime + crowdsaleEndLockTime);
498         
499         LogCrowdsaleEnd(true);
500         withdrawAddress.transfer(this.balance);
501     }
502     
503     /**
504      * @dev Halts crowdsale. Can only be called before minimumFunding is reached. 
505      * @dev When contract is halted no one can buy new tokens, but can sell them back to contract.
506      * @dev Function will be called if minimum funding target isn't reached for extended period of time
507      */
508     function haltCrowdsale() external onlyOwner fundingActive {
509         assert(!minFundingReached);
510         isHalted = !isHalted;
511     }
512 }