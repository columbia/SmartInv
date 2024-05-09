1 pragma solidity ^0.4.24;
2 
3 contract Crowdsale {
4   using SafeMath for uint256;
5   using SafeERC20 for ERC20;
6 
7   // The token being sold
8   ERC20 public token;
9 
10   // Address where funds are collected
11   address public wallet;
12 
13   // How many token units a buyer gets per wei.
14   // The rate is the conversion between wei and the smallest and indivisible token unit.
15   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
16   // 1 wei will give you 1 unit, or 0.001 TOK.
17   uint256 public rate;
18 
19   // Amount of wei raised
20   uint256 public weiRaised;
21 
22   /**
23    * Event for token purchase logging
24    * @param purchaser who paid for the tokens
25    * @param beneficiary who got the tokens
26    * @param value weis paid for purchase
27    * @param amount amount of tokens purchased
28    */
29   event TokenPurchase(
30     address indexed purchaser,
31     address indexed beneficiary,
32     uint256 value,
33     uint256 amount
34   );
35 
36   /**
37    * @param _rate Number of token units a buyer gets per wei
38    * @param _wallet Address where collected funds will be forwarded to
39    * @param _token Address of the token being sold
40    */
41   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
42     require(_rate > 0);
43     require(_wallet != address(0));
44     require(_token != address(0));
45 
46     rate = _rate;
47     wallet = _wallet;
48     token = _token;
49   }
50 
51   // -----------------------------------------
52   // Crowdsale external interface
53   // -----------------------------------------
54 
55   /**
56    * @dev fallback function ***DO NOT OVERRIDE***
57    */
58   function () external payable {
59     buyTokens(msg.sender);
60   }
61 
62   /**
63    * @dev low level token purchase ***DO NOT OVERRIDE***
64    * @param _beneficiary Address performing the token purchase
65    */
66   function buyTokens(address _beneficiary) public payable {
67 
68     uint256 weiAmount = msg.value;
69     _preValidatePurchase(_beneficiary, weiAmount);
70 
71     // calculate token amount to be created
72     uint256 tokens = _getTokenAmount(weiAmount);
73 
74     // update state
75     weiRaised = weiRaised.add(weiAmount);
76 
77     _processPurchase(_beneficiary, tokens, weiAmount);
78     emit TokenPurchase(
79       msg.sender,
80       _beneficiary,
81       weiAmount,
82       tokens
83     );
84 
85     _updatePurchasingState(_beneficiary, weiAmount);
86 
87     _forwardFunds();
88     _postValidatePurchase(_beneficiary, weiAmount);
89   }
90 
91   // -----------------------------------------
92   // Internal interface (extensible)
93   // -----------------------------------------
94 
95   /**
96    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
97    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
98    *   super._preValidatePurchase(_beneficiary, _weiAmount);
99    *   require(weiRaised.add(_weiAmount) <= cap);
100    * @param _beneficiary Address performing the token purchase
101    * @param _weiAmount Value in wei involved in the purchase
102    */
103   function _preValidatePurchase(
104     address _beneficiary,
105     uint256 _weiAmount
106   )
107     internal
108   {
109     require(_beneficiary != address(0));
110     require(_weiAmount != 0);
111   }
112 
113   /**
114    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
115    * @param _beneficiary Address performing the token purchase
116    * @param _weiAmount Value in wei involved in the purchase
117    */
118   function _postValidatePurchase(
119     address _beneficiary,
120     uint256 _weiAmount
121   )
122     internal
123   {
124     // optional override
125   }
126 
127   /**
128    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
129    * @param _beneficiary Address performing the token purchase
130    * @param _tokenAmount Number of tokens to be emitted
131    */
132   function _deliverTokens(
133     address _beneficiary,
134     uint256 _tokenAmount
135   )
136     internal
137   {
138     token.safeTransfer(_beneficiary, _tokenAmount);
139   }
140 
141   /**
142    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
143    * @param _beneficiary Address receiving the tokens
144    * @param _tokenAmount Number of tokens to be purchased
145    */
146   function _processPurchase(
147     address _beneficiary,
148     uint256 _tokenAmount,
149     uint256 _weiAmount
150   )
151     internal
152   {
153     _deliverTokens(_beneficiary, _tokenAmount);
154   }
155 
156   /**
157    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
158    * @param _beneficiary Address receiving the tokens
159    * @param _weiAmount Value in wei involved in the purchase
160    */
161   function _updatePurchasingState(
162     address _beneficiary,
163     uint256 _weiAmount
164   )
165     internal
166   {
167     // optional override
168   }
169 
170   /**
171    * @dev Override to extend the way in which ether is converted to tokens.
172    * @param _weiAmount Value in wei to be converted into tokens
173    * @return Number of tokens that can be purchased with the specified _weiAmount
174    */
175   function _getTokenAmount(uint256 _weiAmount)
176     internal view returns (uint256)
177   {
178     return _weiAmount.mul(rate);
179   }
180 
181   /**
182    * @dev Determines how ETH is stored/forwarded on purchases.
183    */
184   function _forwardFunds() internal {
185     wallet.transfer(msg.value);
186   }
187 }
188 
189 library SafeMath {
190 
191   /**
192   * @dev Multiplies two numbers, throws on overflow.
193   */
194   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
195     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
196     // benefit is lost if 'b' is also tested.
197     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
198     if (_a == 0) {
199       return 0;
200     }
201 
202     c = _a * _b;
203     assert(c / _a == _b);
204     return c;
205   }
206 
207   /**
208   * @dev Integer division of two numbers, truncating the quotient.
209   */
210   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
211     // assert(_b > 0); // Solidity automatically throws when dividing by 0
212     // uint256 c = _a / _b;
213     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
214     return _a / _b;
215   }
216 
217   /**
218   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
219   */
220   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
221     assert(_b <= _a);
222     return _a - _b;
223   }
224 
225   /**
226   * @dev Adds two numbers, throws on overflow.
227   */
228   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
229     c = _a + _b;
230     assert(c >= _a);
231     return c;
232   }
233 }
234 
235 contract Ownable {
236   address public owner;
237 
238 
239   event OwnershipRenounced(address indexed previousOwner);
240   event OwnershipTransferred(
241     address indexed previousOwner,
242     address indexed newOwner
243   );
244 
245 
246   /**
247    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
248    * account.
249    */
250   constructor() public {
251     owner = msg.sender;
252   }
253 
254   /**
255    * @dev Throws if called by any account other than the owner.
256    */
257   modifier onlyOwner() {
258     require(msg.sender == owner);
259     _;
260   }
261 
262   /**
263    * @dev Allows the current owner to relinquish control of the contract.
264    * @notice Renouncing to ownership will leave the contract without an owner.
265    * It will not be possible to call the functions with the `onlyOwner`
266    * modifier anymore.
267    */
268   function renounceOwnership() public onlyOwner {
269     emit OwnershipRenounced(owner);
270     owner = address(0);
271   }
272 
273   /**
274    * @dev Allows the current owner to transfer control of the contract to a newOwner.
275    * @param _newOwner The address to transfer ownership to.
276    */
277   function transferOwnership(address _newOwner) public onlyOwner {
278     _transferOwnership(_newOwner);
279   }
280 
281   /**
282    * @dev Transfers control of the contract to a newOwner.
283    * @param _newOwner The address to transfer ownership to.
284    */
285   function _transferOwnership(address _newOwner) internal {
286     require(_newOwner != address(0));
287     emit OwnershipTransferred(owner, _newOwner);
288     owner = _newOwner;
289   }
290 }
291 
292 contract ERC20Basic {
293   function totalSupply() public view returns (uint256);
294   function balanceOf(address _who) public view returns (uint256);
295   function transfer(address _to, uint256 _value) public returns (bool);
296   event Transfer(address indexed from, address indexed to, uint256 value);
297 }
298 
299 contract ERC20 is ERC20Basic {
300   function allowance(address _owner, address _spender)
301     public view returns (uint256);
302 
303   function transferFrom(address _from, address _to, uint256 _value)
304     public returns (bool);
305 
306   function approve(address _spender, uint256 _value) public returns (bool);
307   event Approval(
308     address indexed owner,
309     address indexed spender,
310     uint256 value
311   );
312 }
313 
314 library SafeERC20 {
315   function safeTransfer(
316     ERC20Basic _token,
317     address _to,
318     uint256 _value
319   )
320     internal
321   {
322     require(_token.transfer(_to, _value));
323   }
324 
325   function safeTransferFrom(
326     ERC20 _token,
327     address _from,
328     address _to,
329     uint256 _value
330   )
331     internal
332   {
333     require(_token.transferFrom(_from, _to, _value));
334   }
335 
336   function safeApprove(
337     ERC20 _token,
338     address _spender,
339     uint256 _value
340   )
341     internal
342   {
343     require(_token.approve(_spender, _value));
344   }
345 }
346 
347 contract QuinadsCrowdsale is Crowdsale, Ownable {
348     using SafeMath for uint8;
349     using SafeERC20 for ERC20;
350 
351     uint256 public TokenSaleSupply = 12000000000000000000000000000;
352     uint256 public tokensSold;
353     
354     // contribution(min) per stage
355     uint256 public preContrib    = 20000000000000000000;
356     uint256 public icoContrib    = 10000000000000000;
357     // bonus pre n ico
358     uint256 public minGetBonus    = 20000000000000000000;
359     // bonus per stage
360     uint8 public prePercentBonus = 10;
361     uint8 public icoPercentBonus  = 5;
362     // supply per stage (without bonus allocation)
363     uint256 public preSupply  = 2400000000000000000000000000;
364     uint256 public icoSupply  = 9600000000000000000000000000;
365     // stage status
366     bool public preOpen = false;
367     bool public icoOpen = false;
368 
369     bool public icoClosed = false;
370 
371     mapping(address => uint256) public contributions;
372     mapping(address => uint256) public presaleTotalBuy;
373     mapping(address => uint256) public icoTotalBuy;
374     mapping(address => uint256) public presaleBonus;
375     mapping(address => uint256) public icoBonus;
376     mapping(uint8 => uint256) public soldPerStage;
377     mapping(uint8 => uint256) public availablePerStage;
378     mapping(address => bool) public allowPre;
379 
380     // STAGE SETUP
381     enum CrowdsaleStage { preSale, ICO }
382     CrowdsaleStage public stage = CrowdsaleStage.preSale;
383     uint256 public minContribution = preContrib;
384     uint256 public stageAllocation = preSupply;
385 
386     constructor(
387         uint256 _rate,
388         address _wallet,
389         ERC20 _token
390     )
391     Crowdsale(_rate, _wallet, _token)
392     public {
393         availablePerStage[0] = stageAllocation;
394     }
395 
396     /** add some function */
397     function openPresale(bool status) public onlyOwner {
398         preOpen = status;
399     }
400     function openICOSale(bool status) public onlyOwner {
401         icoOpen = status;
402     }
403     function closeICO(bool status) public onlyOwner {
404         icoClosed = status;
405     }
406     function setCrowdsaleStage(uint8 _stage) public onlyOwner {
407         _setCrowdsaleStage(_stage);
408     }
409 
410     function _setCrowdsaleStage(uint8 _stage) internal {
411         // can not back to prev stage
412         require(_stage > uint8(stage) && _stage < 2);
413 
414         if(uint8(CrowdsaleStage.preSale) == _stage) {
415             stage = CrowdsaleStage.preSale;
416             minContribution = preContrib;
417             stageAllocation = preSupply;
418         } else {
419             stage = CrowdsaleStage.ICO;
420             minContribution = icoContrib;
421             stageAllocation = icoSupply;
422         }
423 
424         availablePerStage[_stage] = stageAllocation;
425     }
426 
427     function whitelistPresale(address _beneficiary, bool status) public onlyOwner {
428         allowPre[_beneficiary] = status;
429     }
430 
431     function _preValidatePurchase(
432         address _beneficiary,
433         uint256 _weiAmount
434     )
435         internal
436     {
437         // checking
438         require(!icoClosed);
439         require(_beneficiary != address(0));
440         if(stage == CrowdsaleStage.preSale) {
441             require(preOpen);
442             require(allowPre[_beneficiary]);
443             allowPre[_beneficiary] = false;
444             require(_weiAmount == minContribution);
445         } else {
446             require(icoOpen);
447             require(_weiAmount >= minContribution);
448         }
449     }
450 
451     function _processPurchase(
452         address _beneficiary,
453         uint256 _tokenAmount,
454         uint256 _weiAmount
455     )
456         internal
457     {
458         uint8 getBonusStage;
459         uint256 bonusStage_;
460         uint256 additionalBonus = 0;
461         if(stage == CrowdsaleStage.preSale) {
462             getBonusStage = prePercentBonus;
463         } else {
464             if(_weiAmount>=minGetBonus){
465                 getBonusStage = icoPercentBonus;
466             } else {
467                 getBonusStage = 0;
468             }
469         }
470         bonusStage_ = _tokenAmount.mul(getBonusStage).div(100);
471         require(availablePerStage[uint8(stage)] >= _tokenAmount);
472         tokensSold = tokensSold.add(_tokenAmount);
473 
474         soldPerStage[uint8(stage)] = soldPerStage[uint8(stage)].add(_tokenAmount);
475         availablePerStage[uint8(stage)] = availablePerStage[uint8(stage)].sub(_tokenAmount);
476         // next stage or close ICO
477         if(availablePerStage[uint8(stage)]<=0){
478             // now stage false
479             if(stage == CrowdsaleStage.preSale) {
480                 preOpen = false;
481                 stage = CrowdsaleStage.ICO;
482                 _setCrowdsaleStage(1);
483             } else if(stage == CrowdsaleStage.ICO) {
484                 icoOpen = false;
485                 icoClosed = true;
486             }
487         }
488         // contribution / stage and all bonuses
489         if(stage == CrowdsaleStage.preSale) {
490             presaleTotalBuy[_beneficiary] = presaleTotalBuy[_beneficiary] + _tokenAmount;
491             presaleBonus[_beneficiary] = presaleBonus[_beneficiary].add(bonusStage_);
492         } else {
493             icoTotalBuy[_beneficiary] = icoTotalBuy[_beneficiary] + _tokenAmount;
494             icoBonus[_beneficiary] = icoBonus[_beneficiary].add(bonusStage_);
495         }
496         _deliverTokens(_beneficiary, _tokenAmount.add(bonusStage_).add(additionalBonus));
497     }
498 
499     function _updatePurchasingState(
500         address _beneficiary,
501         uint256 _weiAmount
502     )
503         internal
504     {
505         // contribution
506         uint256 _existingContribution = contributions[_beneficiary];
507         uint256 _newContribution = _existingContribution.add(_weiAmount);
508         contributions[_beneficiary] = _newContribution;
509     }
510 
511     function getuserContributions(address _beneficiary) public view returns (uint256) {
512         return contributions[_beneficiary];
513     }
514     function getuserPresaleTotalBuy(address _beneficiary) public view returns (uint256) {
515         return presaleTotalBuy[_beneficiary];
516     }
517     function getuserICOTotalBuy(address _beneficiary) public view returns (uint256) {
518         return icoTotalBuy[_beneficiary];
519     }
520     function getuserPresaleBonus(address _beneficiary) public view returns (uint256) {
521         return presaleBonus[_beneficiary];
522     }
523     function getuserICOBonus(address _beneficiary) public view returns (uint256) {
524         return icoBonus[_beneficiary];
525     }
526     function getAvailableBuyETH(uint8 _stage) public view returns (uint256) {
527         return availablePerStage[_stage].div(rate);
528     }
529 
530     // send back the rest of token to airdrop program
531     function sendToOwner(uint256 _amount) public onlyOwner {
532         require(icoClosed);
533         _deliverTokens(owner, _amount);
534     }
535 
536 }