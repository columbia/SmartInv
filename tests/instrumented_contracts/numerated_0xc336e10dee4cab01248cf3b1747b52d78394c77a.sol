1 /**
2  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  * 
6  ** Code Modified by : TokenMagic
7  ** Change Log: 
8  *** Solidity version upgraded from 0.4.8 to 0.4.23
9  *** Functions Added: setPresaleParticipantWhitelist, setFreezeEnd, getInvestorsCount
10  */
11 
12 
13 pragma solidity ^0.4.23;
14 
15 contract Ownable {
16   address public owner;
17 
18 
19   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   constructor() public {
27     owner = msg.sender;
28   }
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   /**
39    * @dev Allows the current owner to transfer control of the contract to a newOwner.
40    * @param newOwner The address to transfer ownership to.
41    */
42   function transferOwnership(address newOwner) public onlyOwner {
43     require(newOwner != address(0));
44     emit OwnershipTransferred(owner, newOwner);
45     owner = newOwner;
46   }
47 
48 }
49 
50 contract HoardCrowdsale {
51     function invest(address addr,uint tokenAmount) public payable {
52     }
53 }
54 library SafeMathLib {
55 
56   function times(uint a, uint b) public pure returns (uint) {
57     uint c = a * b;
58     assert(a == 0 || c / a == b);
59     return c;
60   }
61 
62   /**
63   * @dev Multiplies two numbers, throws on overflow.
64   */
65   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
66     if (a == 0) {
67       return 0;
68     }
69     uint256 c = a * b;
70     assert(c / a == b);
71     return c;
72   }
73 
74   /**
75   * @dev Integer division of two numbers, truncating the quotient.
76   */
77   function div(uint256 a, uint256 b) internal pure returns (uint256) {
78     // assert(b > 0); // Solidity automatically throws when dividing by 0
79     uint256 c = a / b;
80     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
81     return c;
82   }
83 
84   /**
85   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
86   */
87   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88     assert(b <= a);
89     return a - b;
90   }
91 
92   /**
93   * @dev Adds two numbers, throws on overflow.
94   */
95   function add(uint256 a, uint256 b) internal pure returns (uint256) {
96     uint256 c = a + b;
97     assert(c >= a);
98     return c;
99   }
100   
101 }
102 
103 
104 contract HoardPresale is Ownable {
105 
106   using SafeMathLib for uint;
107   
108   /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
109   mapping (address => bool) public presaleParticipantWhitelist;
110   
111   /** Who are our investors */
112   address[] public investors;
113   mapping (address => bool) private investorsMapping;
114 
115   /** How much they have invested */
116   mapping(address => uint) public balances;
117   
118   /** A mapping of buyers and their amounts of total tokens due */
119   mapping(address => uint256) public tokenDue;
120 
121   /** When our refund freeze is over (UNIX timestamp) */
122   uint public freezeEndsAt;
123   
124   /* How many wei of funding pre-sale have raised */
125   uint public weiRaised = 0;
126 
127   /** Maximum pre-sale ETH fund limit in Wei  */
128   uint public maxFundLimit = 5333000000000000000000; //5333 ETH
129   
130   /** Our ICO contract where we will move the funds */
131   HoardCrowdsale public crowdsale;
132 
133   /**
134   * Define pricing schedule using tranches.
135   */
136   struct Tranche {
137     // Amount in weis when this tranche becomes active
138     uint amount;
139     // How many tokens per satoshi you will get while this tranche is active
140     uint price;
141   }
142   
143   // Store tranches in a fixed array, so that it can be seen in a blockchain explorer
144   // Tranche 0 is always (0, 0)
145   // (TODO: change this when we confirm dynamic arrays are explorable)
146   //
147   /* Calculations made by $500/ETH as rate */
148   /*
149   0 to 114 ETH = 120000000000000 WEI = 0.00012 ETH
150   114 ETH to 10000 ETH = 142857142857500 WEI = 0.0001428571428575 ETH
151   10000 ETH to 14000 ETH = 200000000000000 WEI = 0.0002 ETH
152   */
153   Tranche[10] public tranches;
154 
155   // How many active tranches we have
156   uint public trancheCount;
157   uint public constant MAX_TRANCHES = 10;
158   uint public tokenDecimals = 18;
159   
160   event Invested(address investor, uint value);
161   event Refunded(address investor, uint value);
162   
163   //Event to show whitelisted address
164   event Whitelisted(address[] addr, bool status);
165   
166   //Event to show when freezeends data changed
167   event FreezeEndChanged(uint newFreezeEnd);
168   
169   //Event to show crowdsale address changes
170   event CrowdsaleAdded(address newCrowdsale);
171   
172   /**
173    * Create presale contract
174    */
175    
176   constructor(address _owner, uint _freezeEndsAt) public {
177     require(_owner != address(0) && _freezeEndsAt != 0);
178     owner = _owner;
179     freezeEndsAt = _freezeEndsAt;
180   }
181 
182   /**
183    * Receive funds for presale
184    * Modified by: TokenMagic
185    */
186    
187   function() public payable {  
188     // Only Whitelisted addresses can contribute
189     require(presaleParticipantWhitelist[msg.sender]);
190     require(trancheCount > 0);
191     
192     address investor = msg.sender;
193 
194     bool existing = investorsMapping[investor];
195 
196     balances[investor] = balances[investor].add(msg.value);
197     weiRaised = weiRaised.add(msg.value);
198     require(weiRaised <= maxFundLimit);
199     
200     uint weiAmount = msg.value;
201     uint tokenAmount = calculatePrice(weiAmount);
202     
203     // Add the amount of tokens they are now due to total tally
204     tokenDue[investor] = tokenDue[investor].add(tokenAmount);
205         
206     if(!existing) {
207       investors.push(investor);
208       investorsMapping[investor] = true;
209     }
210 
211     emit Invested(investor, msg.value);
212   }
213   
214   /**
215    * Add KYC whitelisted pre-sale participant ETH addresses to contract.
216    * Added by: TokenMagic
217    */
218   function setPresaleParticipantWhitelist(address[] addr, bool status) public onlyOwner {
219     for(uint i = 0; i < addr.length; i++ ){
220       presaleParticipantWhitelist[addr[i]] = status;
221     }
222     emit Whitelisted(addr, status);
223   }
224     
225    /**
226    * Allow owner to set freezeEndsAt (Timestamp).
227    * Added by: TokenMagic
228    */
229   function setFreezeEnd(uint _freezeEndsAt) public onlyOwner {
230     require(_freezeEndsAt != 0);
231     freezeEndsAt = _freezeEndsAt;
232     emit FreezeEndChanged(freezeEndsAt);
233   }  
234     
235   /**
236    * Move single pre-sale participant's fund to the crowdsale contract.
237    * Modified by: TokenMagic
238    */
239   function participateCrowdsaleInvestor(address investor) public onlyOwner {
240 
241     // Crowdsale not yet set
242     require(address(crowdsale) != 0);
243 
244     if(balances[investor] > 0) {
245       uint amount = balances[investor];
246       uint tokenAmount = tokenDue[investor];
247       delete balances[investor];
248       delete tokenDue[investor];
249       crowdsale.invest.value(amount)(investor,tokenAmount);
250     }
251   }
252 
253   /**
254    * Move all pre-sale participants fund to the crowdsale contract.
255    *
256    */
257   function participateCrowdsaleAll() public onlyOwner {
258     // We might hit a max gas limit in this loop,
259     // and in this case you can simply call participateCrowdsaleInvestor() for all investors
260     for(uint i = 0; i < investors.length; i++) {
261       participateCrowdsaleInvestor(investors[i]);
262     }
263   }
264   
265   /**
266    * Move selected pre-sale participants fund to the crowdsale contract.
267    *
268    */
269   function participateCrowdsaleSelected(address[] addr) public onlyOwner {
270     for(uint i = 0; i < addr.length; i++ ){
271       participateCrowdsaleInvestor(investors[i]);
272     }
273   }
274 
275   /**
276    * ICO never happened. Allow refund.
277    * Modified by: TokenMagic
278    */
279   function refund() public {
280 
281     // Trying to ask refund too soon
282     require(now > freezeEndsAt && balances[msg.sender] > 0);
283 
284     address investor = msg.sender;
285     uint amount = balances[investor];
286     delete balances[investor];
287     emit Refunded(investor, amount);
288     investor.transfer(amount);
289   }
290 
291   /**
292    * Set the crowdsale contract address, where we will move presale funds when the crowdsale opens.
293    */
294   function setCrowdsale(HoardCrowdsale _crowdsale) public onlyOwner {
295     crowdsale = _crowdsale;
296     emit CrowdsaleAdded(crowdsale);
297   }
298 
299   /**
300   * Get total investors count
301   * Added by: TokenMagic
302   */ 
303   function getInvestorsCount() public view returns(uint investorsCount) {
304     return investors.length;
305   }
306   
307   /// @dev Contruction, creating a list of tranches
308   /// @param _tranches uint[] tranches Pairs of (start amount, price)
309   function setPricing(uint[] _tranches) public onlyOwner {
310     // Need to have tuples, length check
311     if(_tranches.length % 2 == 1 || _tranches.length >= MAX_TRANCHES*2) {
312       revert();
313     }
314 
315     trancheCount = _tranches.length / 2;
316 
317     uint highestAmount = 0;
318 
319     for(uint i=0; i<_tranches.length/2; i++) {
320       tranches[i].amount = _tranches[i*2];
321       tranches[i].price = _tranches[i*2+1];
322 
323       // No invalid steps
324       if((highestAmount != 0) && (tranches[i].amount <= highestAmount)) {
325         revert();
326       }
327 
328       highestAmount = tranches[i].amount;
329     }
330 
331     // We need to start from zero, otherwise we blow up our deployment
332     if(tranches[0].amount != 0) {
333       revert();
334     }
335 
336     // Last tranche price must be zero, terminating the crowdale
337     if(tranches[trancheCount-1].price != 0) {
338       revert();
339     }
340   }
341   
342   /// @dev Get the current tranche or bail out if we are not in the tranche periods.
343   /// @return {[type]} [description]
344   function getCurrentTranche() private view returns (Tranche) {
345     uint i;
346 
347     for(i=0; i < tranches.length; i++) {
348       if(weiRaised <= tranches[i].amount) {
349         return tranches[i-1];
350       }
351     }
352   }
353   
354   /// @dev Get the current price.
355   /// @return The current price or 0 if we are outside trache ranges
356   function getCurrentPrice() public view returns (uint result) {
357     return getCurrentTranche().price;
358   }
359   
360   /// @dev Calculate the current price for buy in amount.
361   function calculatePrice(uint value) public view returns (uint) {
362     uint multiplier = 10 ** tokenDecimals;
363     uint price = getCurrentPrice();
364     return value.times(multiplier) / price;
365   }
366   
367   /// @dev Iterate through tranches. You reach end of tranches when price = 0
368   /// @return tuple (time, price)
369   function getTranche(uint n) public view returns (uint, uint) {
370     return (tranches[n].amount, tranches[n].price);
371   }
372 
373   function getFirstTranche() private view returns (Tranche) {
374     return tranches[0];
375   }
376 
377   function getLastTranche() private view returns (Tranche) {
378     return tranches[trancheCount-1];
379   }
380 
381   function getPricingStartsAt() public view returns (uint) {
382     return getFirstTranche().amount;
383   }
384 
385   function getPricingEndsAt() public view returns (uint) {
386     return getLastTranche().amount;
387   }
388   
389 }