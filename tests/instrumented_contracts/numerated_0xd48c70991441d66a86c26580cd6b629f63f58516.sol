1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * See https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21     
22   function allowance(address owner, address spender)
23     public view returns (uint256);
24 
25   function transferFrom(address from, address to, uint256 value)
26     public returns (bool);
27 
28   function approve(address spender, uint256 value) public returns (bool);
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 /**
37  * @title SafeMath
38  * @dev Math operations with safety checks that throw on error
39  */ 
40 library SafeMath {
41 
42   /**
43   * @dev Multiplies two numbers, throws on overflow.
44   */
45   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
46     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
47     // benefit is lost if 'b' is also tested.
48     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
49     if (a == 0) {
50       return 0;
51     }
52 
53     c = a * b;
54     assert(c / a == b);
55     return c;
56   }
57 
58   /**
59   * @dev Integer division of two numbers, truncating the quotient.
60   */
61   function div(uint256 a, uint256 b) internal pure returns (uint256) {
62     // assert(b > 0); // Solidity automatically throws when dividing by 0
63     // uint256 c = a / b;
64     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
65     return a / b;
66   }
67 
68   /**
69   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
70   */
71   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72     assert(b <= a);
73     return a - b;
74   }
75 
76   /**
77   * @dev Adds two numbers, throws on overflow.
78   */
79   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
80     c = a + b;
81     assert(c >= a);
82     return c;
83   }
84 }
85 
86 
87 /**
88  * @title SVGCrowdsale
89  * @dev SVGCrowdsale is a base contract for managing a token crowdsale,
90  * allowing investors to purchase tokens with ether. This contract implements
91  * such functionality in its most fundamental form and can be extended to provide additional
92  * functionality and/or custom behavior.
93  * The external interface represents the basic interface for purchasing tokens, and conform
94  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
95  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
96  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
97  * behavior.
98  */
99 contract SVGCrowdsale {
100     
101   using SafeMath for uint256;
102 
103   // The token being sold
104   ERC20 public token;
105 
106   // Address where funds are collected
107   address public wallet;
108 
109   // Amount of wei raised
110   uint256 public weiRaised;
111   
112   //current round total
113   uint256 public currentRound;
114   
115   //block-time when it was deployed
116   uint startTime = now;
117   
118   //Time Crowdsale completed
119   uint256 public completedAt;
120   
121   /**
122    * Event for token purchase logging
123    * @param purchaser who paid for the tokens
124    * @param beneficiary who got the tokens
125    * @param value weis paid for purchase
126    * @param amount amount of tokens purchased
127    */
128   event TokenPurchase(
129     address indexed purchaser,
130     address indexed beneficiary,
131     uint256 value,
132     uint256 amount
133   );
134   
135   event LogFundingSuccessful(
136       uint _totalRaised
137     );
138 
139   /**
140    * @param _wallet Address where collected funds will be forwarded to
141    * @param _token Address of the token being sold
142    */
143   constructor(address _wallet, ERC20 _token) public {
144     require(_wallet != address(0));
145     require(_token != address(0));
146 
147     wallet = _wallet;
148     token = _token;
149   }
150   
151   //rate
152     uint[5] tablePrices = [
153         13334,
154         11429,
155         10000,
156         9091,
157         8000
158     ];  
159   
160   //caps
161     uint256[5] caps = [
162         10000500e18,
163         10000375e18,
164         10000000e18,
165         10000100e18,
166         10000000e18
167     ];  
168   
169   //5 tranches
170   enum Tranches {
171         Round1,
172         Round2,
173         Round3,
174         Round4,
175         Round5,
176         Successful
177   }
178   
179   Tranches public tranches = Tranches.Round1; //Set Private stage
180   
181 
182   // -----------------------------------------
183   // Crowdsale external interface
184   // -----------------------------------------
185 
186   /**
187    * @dev fallback function ***DO NOT OVERRIDE***
188    */
189   function () external payable {
190     buyTokens(msg.sender);
191   }
192 
193   /**
194    * @dev low level token purchase ***DO NOT OVERRIDE***
195    * @param _beneficiary Address performing the token purchase
196    */
197   function buyTokens(address _beneficiary) public payable {
198 
199     uint256 weiAmount = msg.value;
200     _preValidatePurchase(_beneficiary, weiAmount);
201 
202     // calculate token amount to be created
203     uint256 tokens = getTokenAmount(weiAmount);
204 
205     // update state
206     weiRaised = weiRaised.add(weiAmount);
207 
208     processPurchase(_beneficiary, tokens);
209     
210     emit TokenPurchase(
211       msg.sender,
212       _beneficiary,
213       weiAmount,
214       tokens
215     );
216 
217     updatePurchasingState(_beneficiary, weiAmount);
218 
219     forwardFunds();
220     
221     checkIfFundingCompleteOrExpired();
222     
223     postValidatePurchase(_beneficiary, weiAmount);
224   }
225   
226   /**
227    *  @dev This method update the current state of tranches and currentRound.
228    */
229   
230   function checkIfFundingCompleteOrExpired() internal {
231       
232     if(tranches != Tranches.Successful){
233         
234         if(currentRound > caps[0] && tranches == Tranches.Round1){//plus 8weeks
235             tranches = Tranches.Round2;
236             currentRound = 0;    
237         }
238         else if(currentRound > caps[1] && tranches == Tranches.Round2){ //plus 4weeks
239             tranches = Tranches.Round3;
240             currentRound = 0;    
241         }
242         else if(currentRound > caps[2] && tranches == Tranches.Round3){ //plus 3weeks
243             tranches = Tranches.Round4;
244             currentRound = 0;    
245         }
246         else if(currentRound > caps[3] && tranches == Tranches.Round4){ //plus 3weeks
247             tranches = Tranches.Round5;
248             currentRound = 0; 
249         }
250     }
251     else {
252         tranches = Tranches.Successful;
253         completedAt = now;
254     }
255       
256   }
257 
258   // -----------------------------------------
259   // Internal interface (extensible)
260   // -----------------------------------------
261 
262   /**
263    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
264    * @param _beneficiary Address performing the token purchase
265    * @param _weiAmount Value in wei involved in the purchase
266    */
267   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
268     require(_beneficiary != address(0));
269     require(_weiAmount != 0);
270   }
271 
272   /**
273    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
274    * @param _beneficiary Address performing the token purchase
275    * @param _weiAmount Value in wei involved in the purchase
276    */
277   function postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal{
278     // optional override
279   }
280 
281   /**
282    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
283    * @param _beneficiary Address performing the token purchase
284    * @param _tokenAmount Number of tokens to be emitted
285    */
286   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
287     token.transfer(_beneficiary, _tokenAmount);
288   }
289 
290   /**
291    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
292    * @param _beneficiary Address receiving the tokens
293    * @param _tokenAmount Number of tokens to be purchased
294    */
295   function processPurchase(address _beneficiary, uint256 _tokenAmount )internal{
296     _deliverTokens(_beneficiary, _tokenAmount);
297   }
298 
299   /**
300    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
301    * @param _beneficiary Address receiving the tokens
302    * @param _weiAmount Value in wei involved in the purchase
303    */
304   function updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
305     // optional override
306   }
307 
308   /**
309    * @dev Override to extend the way in which ether is converted to tokens.
310    * @param _weiAmount Value in wei to be converted into tokens
311    * @return Number of tokens that can be purchased with the specified _weiAmount
312    */
313   function getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
314     
315     uint256 tokenBought;
316     
317     if(tranches == Tranches.Round1){
318         
319         tokenBought = _weiAmount.mul(tablePrices[0]);
320         require(SafeMath.add(currentRound, tokenBought) <= caps[0]);
321         
322     }else if(tranches == Tranches.Round2){
323         
324         tokenBought = _weiAmount.mul(tablePrices[1]);
325         require(SafeMath.add(currentRound, tokenBought) <= caps[1]);            
326         
327     }else if(tranches == Tranches.Round3){
328         
329         tokenBought = _weiAmount.mul(tablePrices[2]);
330         require(SafeMath.add(currentRound, tokenBought) <= caps[2]);
331         
332     }else if(tranches == Tranches.Round4){
333         
334         tokenBought = _weiAmount.mul(tablePrices[3]);
335         require(SafeMath.add(currentRound, tokenBought) <= caps[3]);
336         
337     }else if(tranches == Tranches.Round5){
338         
339         tokenBought = _weiAmount.mul(tablePrices[4]);
340         require(SafeMath.add(currentRound, tokenBought) <= caps[4]); 
341         
342     }else{
343         revert();
344     }
345     
346     return tokenBought;    
347     
348   }
349 
350   /**
351    * @dev Determines how ETH is stored/forwarded on purchases.
352    */
353   function forwardFunds() internal {
354     wallet.transfer(msg.value);
355   }
356   
357 }