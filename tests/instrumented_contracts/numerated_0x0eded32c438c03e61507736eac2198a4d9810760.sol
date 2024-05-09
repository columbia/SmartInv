1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   // it is recommended to define functions which can neither read the state of blockchain nor write in it as pure instead of constant
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         if (a == 0) {
16             return 0;
17         }
18         uint256 c = a * b;
19         assert(c / a == b);
20         return c;
21     }
22 
23     /**
24     * @dev Integer division of two numbers, truncating the quotient.
25     */
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         // assert(b > 0); // Solidity automatically throws when dividing by 0
28         // uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return a / b;
31     }
32 
33     /**
34     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     /**
42     * @dev Adds two numbers, throws on overflow.
43     */
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 
50 }
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 
57 contract Ownable {
58     address public owner;
59     address public creater;
60 
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     /**
64     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65     * account.
66     */
67     function Ownable(address _owner) public {
68         creater = msg.sender;
69         if (_owner != 0) {
70             owner = _owner;
71 
72         }
73         else {
74             owner = creater;
75         }
76 
77     }
78     /**
79     * @dev Throws if called by any account other than the owner.
80     */
81 
82     modifier onlyOwner() {
83         require(msg.sender == owner);
84         _;
85     }
86 
87     modifier isCreator() {
88         require(msg.sender == creater);
89         _;
90     }
91 
92    
93 
94 }
95 
96 
97 contract TravelHelperToken {
98     function transfer (address, uint) public pure { }
99     function burnTokensForSale() public returns (bool);
100     function saleTransfer(address _to, uint256 _value) public returns (bool) {}
101     function finalize() public pure { }
102 }
103 
104 contract Crowdsale is Ownable {
105   using SafeMath for uint256;
106 
107   // The token being sold
108   TravelHelperToken public token;
109   
110   uint public ethPrice;
111 
112   // Address where funds are collected
113   address public wallet;
114 
115   // Amount of wei raised
116   uint256 public weiRaised;
117   bool public crowdsaleStarted = false;
118   uint256 public preIcoCap = uint256(1000000000).mul(1 ether);
119   uint256 public icoCap = uint256(1500000000).mul(1 ether);
120   uint256 public preIcoTokensSold = 0;
121   uint256 public discountedIcoTokensSold = 0;
122   uint256 public icoTokensSold = 0;
123   
124   
125   uint256 public mainTokensPerDollar = 400 * 1 ether;
126   
127   uint256 public totalRaisedInCents;
128   uint256 public presaleTokensPerDollar = 533.3333 * 1 ether;
129   uint256 public discountedTokensPerDollar = 444.4444 * 1 ether;
130   uint256 public hardCapInCents = 525000000;
131   uint256 public preIcoStartBlock;
132   uint256 public discountedIcoStartBlock;
133   uint256 public mainIcoStartBlock;
134   uint256 public mainIcoEndBlock;
135   uint public preSaleDuration =  (7 days)/(15);
136   uint public discountedSaleDuration = (15 days)/(15); 
137   uint public mainSaleDuration = (15 days)/(15); 
138   
139   
140   modifier CrowdsaleStarted(){
141       require(crowdsaleStarted);
142       _;
143   }
144  
145   /**
146    * Event for token purchase logging
147    * @param purchaser who paid for the tokens
148    * @param beneficiary who got the tokens
149    * @param value weis paid for purchase
150    * @param amount amount of tokens purchased
151    */
152   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
153 
154   /**
155    * @param _newOwner Address who has special power to change the ether price in cents according to the market price
156    * @param _wallet Address where collected funds will be forwarded to
157    * @param _token Address of the token being sold
158    *  @param _ethPriceInCents ether price in cents
159    */
160   function Crowdsale(address _newOwner, address _wallet, TravelHelperToken _token,uint256 _ethPriceInCents) Ownable(_newOwner) public {
161     require(_wallet != address(0));
162     require(_token != address(0));
163     require(_ethPriceInCents > 0);
164     wallet = _wallet;
165     owner = _newOwner;
166     token = _token;
167     ethPrice = _ethPriceInCents; //ethPrice in cents
168   }
169 
170   function startCrowdsale() onlyOwner public returns (bool) {
171       require(!crowdsaleStarted);
172       crowdsaleStarted = true;
173       preIcoStartBlock = block.number;
174       discountedIcoStartBlock = block.number + preSaleDuration;
175       mainIcoStartBlock = block.number + preSaleDuration + discountedSaleDuration;
176       mainIcoEndBlock = block.number + preSaleDuration + discountedSaleDuration + mainSaleDuration;
177       
178   }
179   
180   // -----------------------------------------
181   // Crowdsale external interface
182   // -----------------------------------------
183 
184   /**
185    * @dev fallback function ***DO NOT OVERRIDE***
186    */
187   function () external payable {
188     require(msg.sender != owner);
189      buyTokens(msg.sender);
190   }
191 
192   /**
193    * @param _beneficiary Address performing the token purchase
194    */
195   function buyTokens(address _beneficiary) CrowdsaleStarted public payable {
196     uint256 weiAmount = msg.value;
197     require(weiAmount > 0);
198     require(ethPrice > 0);
199     uint256 usdCents = weiAmount.mul(ethPrice).div(1 ether); 
200 
201     // calculate token amount to be created
202     uint256 tokens = _getTokenAmount(usdCents);
203 
204     _validateTokensLimits(tokens);
205 
206     // update state
207     weiRaised = weiRaised.add(weiAmount);
208     totalRaisedInCents = totalRaisedInCents.add(usdCents);
209     _processPurchase(_beneficiary,tokens);
210      emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
211     _forwardFunds();
212   }
213   
214  
215    /**
216    * @dev sets the value of ether price in cents.Can be called only by the owner account.
217    * @param _ethPriceInCents price in cents .
218    */
219  function setEthPriceInDollar(uint _ethPriceInCents) onlyOwner public returns(bool) {
220       ethPrice = _ethPriceInCents;
221       return true;
222   }
223 
224   // -----------------------------------------
225   // Internal interface (extensible)
226   // -----------------------------------------
227 
228 
229   /**
230    * @dev Validation of the capped restrictions.
231    * @param _tokens tokens amount
232    */
233   function _validateTokensLimits(uint256 _tokens) internal {
234     if (block.number > preIcoStartBlock && block.number < discountedIcoStartBlock) {
235       preIcoTokensSold = preIcoTokensSold.add(_tokens);
236       require(preIcoTokensSold <= preIcoCap && totalRaisedInCents <= hardCapInCents);
237     } else if(block.number >= discountedIcoStartBlock && block.number < mainIcoStartBlock ) {
238        require(discountedIcoTokensSold <= icoCap && totalRaisedInCents <= hardCapInCents);
239     } else if(block.number >= mainIcoStartBlock && block.number < mainIcoEndBlock ) {
240       icoTokensSold = icoTokensSold.add(_tokens);
241       require(icoTokensSold <= icoCap && totalRaisedInCents < hardCapInCents);
242     } else {
243       revert();
244     }
245   }
246 
247   /**
248    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
249    * @param _beneficiary Address performing the token purchase
250    * @param _tokenAmount Number of tokens to be emitted
251    */
252   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
253     require(token.saleTransfer(_beneficiary, _tokenAmount));
254   }
255 
256   /**
257    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
258    * @param _beneficiary Address receiving the tokens
259    * @param _tokenAmount Number of tokens to be purchased
260    */
261   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
262     _deliverTokens(_beneficiary, _tokenAmount);
263   }
264   
265 
266   /**
267    * @param _usdCents Value in usd cents to be converted into tokens
268    * @return Number of tokens that can be purchased with the specified _usdCents
269    */
270   function _getTokenAmount(uint256 _usdCents) CrowdsaleStarted public view returns (uint256) {
271     uint256 tokens;
272     
273     if (block.number > preIcoStartBlock && block.number < discountedIcoStartBlock ) tokens = _usdCents.div(100).mul(presaleTokensPerDollar);
274     if (block.number >= discountedIcoStartBlock && block.number < mainIcoStartBlock )  tokens = _usdCents.div(100).mul(discountedTokensPerDollar);
275     if (block.number >= mainIcoStartBlock && block.number < mainIcoEndBlock )  tokens = _usdCents.div(100).mul(mainTokensPerDollar);
276     
277 
278     return tokens;
279   }
280   
281    /**
282    * @return returns the current stage of sale
283    */
284     function getStage() public view returns (string) {
285         if(!crowdsaleStarted){
286             return 'Crowdsale not started yet';
287         }
288         if (block.number > preIcoStartBlock && block.number < discountedIcoStartBlock )
289         {
290             return 'Presale';
291         }
292         else if (block.number >= discountedIcoStartBlock  && block.number < mainIcoStartBlock ) {
293             return 'Discounted sale';
294         }
295         else if (block.number >= mainIcoStartBlock && block.number < mainIcoEndBlock )
296         {
297             return 'Crowdsale';
298         }
299         else if(block.number > mainIcoEndBlock)
300         {
301             return 'Sale ended';
302         }
303       
304      }
305       
306     /**
307        * @dev burn the unsold tokens.
308        
309        */
310      function burnTokens() public onlyOwner {
311         require(block.number > mainIcoEndBlock);
312         require(token.burnTokensForSale());
313       }
314         
315   /**
316    * @dev finalize the crowdsale.After finalizing ,tokens transfer can be done.
317    */
318   function finalizeSale() public onlyOwner {
319     require(block.number > mainIcoEndBlock);
320     token.finalize();
321   }
322   
323   
324   /**
325    * @dev Determines how ETH is stored/forwarded on purchases.
326    */
327   function _forwardFunds() internal {
328     wallet.transfer(msg.value);
329   }
330 }