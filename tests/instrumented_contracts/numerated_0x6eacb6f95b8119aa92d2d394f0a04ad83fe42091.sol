1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipRenounced(address indexed previousOwner);
54   event OwnershipTransferred(
55     address indexed previousOwner,
56     address indexed newOwner
57   );
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   constructor() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   /**
77    * @dev Allows the current owner to transfer control of the contract to a newOwner.
78    * @param newOwner The address to transfer ownership to.
79    */
80   function transferOwnership(address newOwner) public onlyOwner {
81     require(newOwner != address(0));
82     emit OwnershipTransferred(owner, newOwner);
83     owner = newOwner;
84   }
85 
86   /**
87    * @dev Allows the current owner to relinquish control of the contract.
88    */
89   function renounceOwnership() public onlyOwner {
90     emit OwnershipRenounced(owner);
91     owner = address(0);
92   }
93 }
94 
95 contract Token {
96   function transfer(address _to, uint256 _value) public returns (bool);
97 }
98 
99 /**
100  * @title Crowdsale
101  * @dev Crowdsale is a base contract for managing a token crowdsale,
102  * allowing investors to purchase tokens with ether. This contract implements
103  * such functionality in its most fundamental form and can be extended to provide additional
104  * functionality and/or custom behavior.
105  * The external interface represents the basic interface for purchasing tokens, and conform
106  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
107  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
108  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
109  * behavior.
110  */
111 contract Crowdsale is Ownable {
112   using SafeMath for uint256;
113 
114   // The token being sold
115   Token public token;
116 
117   // Address where funds are collected
118   address public wallet;
119 
120   // How many token units a buyer gets per ether.
121   uint256 public rate;
122 
123   // Amount of wei raised
124   uint256 public weiRaised;
125 
126   // ICO start timestamp
127   uint256 public startTime = now;
128 
129   // periods timestamps
130   uint256 round1StartTime;
131   uint256 round1EndTime;
132   uint256 round2StartTime;
133   uint256 round2EndTime;
134   uint256 round3StartTime;
135   uint256 round3EndTime;
136   uint256 round4StartTime;
137   uint256 round4EndTime;
138 
139   // bonuses in %
140   uint256 public round1Bonus = 20;
141   uint256 public round2Bonus = 15;
142   uint256 public round3Bonus = 5;
143 
144   // min contribution in wei
145   uint256 public minContribution = 100 finney;
146 
147   // hardcaps in tokens
148   uint256 public round1Cap = uint256(9e8).mul(1 ether);
149   uint256 public round2Cap = uint256(12e8).mul(1 ether);
150   uint256 public round3Cap = uint256(15e8).mul(1 ether);
151   uint256 public round4Cap = uint256(24e8).mul(1 ether);
152 
153   // tokens sold
154   uint256 public round1Sold;
155   uint256 public round2Sold;
156   uint256 public round3Sold;
157   uint256 public round4Sold;
158 
159   // Contributions
160   mapping(address => uint256) public contributions;
161 
162   // hardCap in ETH
163   uint256 hardCap = 12500 ether;
164   // softCap in ETH
165   uint256 softCap = 1250 ether;
166 
167   /**
168    * Event for token purchase logging
169    * @param purchaser who paid for the tokens
170    * @param beneficiary who got the tokens
171    * @param value weis paid for purchase
172    * @param amount amount of tokens purchased
173    */
174   event TokenPurchase(
175     address indexed purchaser,
176     address indexed beneficiary,
177     uint256 value,
178     uint256 amount
179   );
180 
181   /**
182    * Event for external token purchase logging
183    * @param purchaser who paid for the tokens
184    * @param beneficiary who got the tokens
185    * @param amount amount of tokens purchased
186    */
187   event ExternalTokenPurchase(
188     address indexed purchaser,
189     address indexed beneficiary,
190     uint256 amount
191   );
192 
193   /**
194    * @param _rate Base rate
195    * @param _wallet Address where collected funds will be forwarded to
196    * @param _token Address of the token being sold
197    */
198   constructor(uint256 _rate, address _newOwner, address _wallet, Token _token) public {
199     require(_wallet != address(0));
200     require(_token != address(0));
201     rate = _rate;
202     owner = _newOwner;
203     wallet = _wallet;
204     token = _token;
205     round1StartTime = startTime;
206     round1EndTime = round1StartTime.add(7 days);
207     round2StartTime = round1EndTime.add(1 days);
208     round2EndTime = round2StartTime.add(10 days);
209     round3StartTime = round2EndTime.add(1 days);
210     round3EndTime = round3StartTime.add(14 days);
211     round4StartTime = round3EndTime.add(1 days);
212     round4EndTime = round4StartTime.add(21 days);
213   }
214 
215   // -----------------------------------------
216   // Crowdsale external interface
217   // -----------------------------------------
218 
219   /**
220    * @dev fallback function ***DO NOT OVERRIDE***
221    */
222   function () external payable {
223     buyTokens(msg.sender);
224   }
225 
226   /**
227    * @dev getting stage index
228    */
229 
230   function _getStageIndex () internal view returns (uint8) {
231     if (now < round1StartTime) return 0;
232     if (now <= round1EndTime) return 1;
233     if (now < round2StartTime) return 2;
234     if (now <= round2EndTime) return 3;
235     if (now < round3StartTime) return 4;
236     if (now <= round3EndTime) return 5;
237     if (now < round4StartTime) return 6;
238     if (now <= round4EndTime) return 7;
239     return 8;
240   }
241 
242   /**
243    * @dev getting stage name
244    */
245 
246   function getStageName () public view returns (string) {
247     uint8 stageIndex = _getStageIndex();
248     if (stageIndex == 0) return 'Pause';
249     if (stageIndex == 1) return 'Round1';
250     if (stageIndex == 2) return 'Round1 end';
251     if (stageIndex == 3) return 'Round2';
252     if (stageIndex == 4) return 'Round2 end';
253     if (stageIndex == 5) return 'Round3';
254     if (stageIndex == 6) return 'Round3 end';
255     if (stageIndex == 7) return 'Round4';
256     if (stageIndex == 8) return 'Round4 end';
257     return 'Pause';
258   }
259 
260   /**
261    * @dev low level token purchase ***DO NOT OVERRIDE***
262    * @param _beneficiary Address performing the token purchase
263    */
264   function buyTokens(address _beneficiary) public payable {
265 
266     uint256 weiAmount = msg.value;
267     uint8 stageIndex = _getStageIndex();
268     require(stageIndex > 0);
269     require(stageIndex <= 8);
270 
271     _preValidatePurchase(_beneficiary, weiAmount);
272 
273     // calculate token amount to be created
274     uint256 tokens = _getTokenAmount(weiAmount, stageIndex);
275 
276     // update state
277     weiRaised = weiRaised.add(weiAmount);
278     contributions[msg.sender] = contributions[msg.sender].add(weiAmount);
279 
280     if (stageIndex == 1 || stageIndex == 2) round1Sold = round1Sold.add(tokens);
281     else if (stageIndex == 3 || stageIndex == 4) round2Sold = round2Sold.add(tokens);
282     else if (stageIndex == 5 || stageIndex == 6) round3Sold = round3Sold.add(tokens);
283     else round4Sold = round4Sold.add(tokens);
284 
285     _processPurchase(_beneficiary, tokens);
286     emit TokenPurchase(
287       msg.sender,
288       _beneficiary,
289       weiAmount,
290       tokens
291     );
292     if (weiRaised >= softCap) _forwardFunds();
293   }
294 
295   // -----------------------------------------
296   // Internal interface (extensible)
297   // -----------------------------------------
298 
299   /**
300    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
301    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
302    *   super._preValidatePurchase(_beneficiary, _weiAmount);
303    *   require(weiRaised.add(_weiAmount) <= cap);
304    * @param _beneficiary Address performing the token purchase
305    * @param _weiAmount Value in wei involved in the purchase
306    */
307   function _preValidatePurchase(
308     address _beneficiary,
309     uint256 _weiAmount
310   )
311     internal view
312   {
313     require(_beneficiary != address(0));
314     require(_weiAmount > 0);
315     require(weiRaised.add(_weiAmount) <= hardCap);
316 
317     require(_weiAmount >= minContribution);
318   }
319 
320   /**
321    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
322    * @param _beneficiary Address performing the token purchase
323    * @param _tokenAmount Number of tokens to be emitted
324    */
325   function _deliverTokens(
326     address _beneficiary,
327     uint256 _tokenAmount
328   )
329     internal
330   {
331     require(token.transfer(_beneficiary, _tokenAmount));
332   }
333 
334   /**
335    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
336    * @param _beneficiary Address receiving the tokens
337    * @param _tokenAmount Number of tokens to be purchased
338    */
339   function _processPurchase(
340     address _beneficiary,
341     uint256 _tokenAmount
342   )
343     internal
344   {
345     _deliverTokens(_beneficiary, _tokenAmount);
346   }
347 
348   /**
349    * @dev Override to extend the way in which ether is converted to tokens.
350    * @param _weiAmount Value in wei to be converted into tokens
351    * @return Number of tokens that can be purchased with the specified _weiAmount
352    */
353   function _getTokenAmount(uint256 _weiAmount, uint8 _stageIndex)
354     internal view returns (uint256)
355   {
356     uint256 _bonus = 0;
357     uint256 _cap;
358     if (_stageIndex == 1) {
359       _bonus = round1Bonus;
360       _cap = round1Cap.sub(round1Sold);
361     } else if (_stageIndex == 2) {
362       _cap = round2Cap.sub(round1Sold);
363     } else if (_stageIndex == 3) {
364       _bonus = round2Bonus;
365       _cap = round1Cap.sub(round1Sold).add(round2Cap).sub(round2Sold);
366     } else if (_stageIndex == 4) {
367       _cap = round1Cap.sub(round1Sold).add(round2Cap).sub(round2Sold);
368     } else if (_stageIndex == 5) {
369       _bonus = round3Bonus;
370       _cap = round1Cap.sub(round1Sold).add(round2Cap).sub(round2Sold).add(round3Cap).sub(round3Sold);
371     }  else if (_stageIndex == 6) {
372       _cap = round1Cap.sub(round1Sold).add(round2Cap).sub(round2Sold).add(round3Cap).sub(round3Sold);
373     } else {
374       _cap = round1Cap.sub(round1Sold).add(round2Cap).sub(round2Sold).add(round3Cap).sub(round3Sold).add(round4Cap).sub(round4Sold);
375     }
376 
377     uint256 _tokenAmount = _weiAmount.mul(rate);
378     if (_bonus > 0) {
379       uint256 _bonusTokens = _tokenAmount.mul(_bonus).div(100);
380       _tokenAmount = _tokenAmount.add(_bonusTokens);
381     }
382     if (_stageIndex < 8) require(_tokenAmount <= _cap);
383     return _tokenAmount;
384   }
385 
386   function refund () public returns (bool) {
387     require(now > round4EndTime);
388     require(weiRaised < softCap);
389     require(contributions[msg.sender] > 0);
390     uint256 refundAmount = contributions[msg.sender];
391     contributions[msg.sender] = 0;
392     weiRaised = weiRaised.sub(refundAmount);
393     msg.sender.transfer(refundAmount);
394     return true;
395   }
396 
397   /**
398    * @dev Determines how ETH is stored/forwarded on purchases.
399    */
400   function _forwardFunds() internal {
401     wallet.transfer(address(this).balance);
402   }
403 
404   function transferSoldTokens(address _beneficiary, uint256 _tokenAmount) public onlyOwner returns (bool) {
405     uint8 stageIndex = _getStageIndex();
406     require(stageIndex > 0);
407     require(stageIndex <= 8);
408 
409     if (stageIndex == 1 || stageIndex == 2) {
410       round1Sold = round1Sold.add(_tokenAmount);
411       require(round1Sold <= round1Cap);
412     } else if (stageIndex == 3 || stageIndex == 4) {
413       round2Sold = round2Sold.add(_tokenAmount);
414       require(round2Sold <= round2Cap);
415     } else if (stageIndex == 5 || stageIndex == 6) {
416       round3Sold = round3Sold.add(_tokenAmount);
417       require(round3Sold <= round3Cap);
418     } else if (stageIndex == 7) {
419       round4Sold = round4Sold.add(_tokenAmount);
420       require(round4Sold <= round4Cap);
421     }
422     emit ExternalTokenPurchase(
423       _beneficiary,
424       _beneficiary,
425       _tokenAmount
426     );
427 
428     require(token.transfer(_beneficiary, _tokenAmount));
429     return true;
430   }
431 }