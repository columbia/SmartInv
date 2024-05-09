1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42   address public owner;
43 
44 
45   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   constructor() public {
53     owner = msg.sender;
54   }
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) public onlyOwner {
69     require(newOwner != address(0));
70     emit OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 
76 interface TokenInterface {
77      function totalSupply() external constant returns (uint);
78      function balanceOf(address tokenOwner) external constant returns (uint balance);
79      function allowance(address tokenOwner, address spender) external constant returns (uint remaining);
80      function transfer(address to, uint tokens) external returns (bool success);
81      function approve(address spender, uint tokens) external returns (bool success);
82      function transferFrom(address from, address to, uint tokens) external returns (bool success);
83      function burn(uint256 _value) external; 
84      event Transfer(address indexed from, address indexed to, uint tokens);
85      event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
86      event Burn(address indexed burner, uint256 value);
87 }
88 
89  contract EzeCrowdsale is Ownable{
90   using SafeMath for uint256;
91  
92   // The token being sold
93   TokenInterface public token;
94 
95   // start and end timestamps where investments are allowed (both inclusive)
96   uint256 public startTime;
97   uint256 public endTime;
98 
99 
100   // how many token units a buyer gets per wei
101   uint256 public ratePerWeiInSelfDrop = 60000;
102   uint256 public ratePerWeiInPrivateSale = 30000;
103   uint256 public ratePerWeiInPreICO = 20000;
104   uint256 public ratePerWeiInMainICO = 15000;
105 
106   // amount of raised money in wei
107   uint256 public weiRaised;
108 
109   uint256 public TOKENS_SOLD;
110   
111   uint256 maxTokensToSale;
112   
113   uint256 bonusInSelfDrop = 20;
114   uint256 bonusInPrivateSale = 10;
115   uint256 bonusInPreICO = 5;
116   uint256 bonusInMainICO = 2;
117   
118   bool isCrowdsalePaused = false;
119   
120   uint256 totalDurationInDays = 213 days;
121   
122   /**
123    * event for token purchase logging
124    * @param purchaser who paid for the tokens
125    * @param beneficiary who got the tokens
126    * @param value weis paid for purchase
127    * @param amount amount of tokens purchased
128    */
129   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
130 
131   constructor(uint256 _startTime, address _wallet, address _tokenAddress) public 
132   {
133     require(_startTime >=now);
134     require(_wallet != 0x0);
135 
136     startTime = _startTime;  
137     endTime = startTime + totalDurationInDays;
138     require(endTime >= startTime);
139    
140     owner = _wallet;
141     
142     maxTokensToSale = uint(15000000000).mul( 10 ** uint256(18));
143    
144     token = TokenInterface(_tokenAddress);
145   }
146   
147   
148    // fallback function can be used to buy tokens
149    function () public  payable {
150      buyTokens(msg.sender);
151     }
152     
153     function calculateTokens(uint value) internal view returns (uint256 tokens) 
154     {
155         uint256 timeElapsed = now - startTime;
156         uint256 timeElapsedInDays = timeElapsed.div(1 days);
157         uint256 bonus = 0;
158         //Phase 1 (30 days)
159         if (timeElapsedInDays <30)
160         {
161             tokens = value.mul(ratePerWeiInSelfDrop);
162             bonus = tokens.mul(bonusInSelfDrop); 
163             bonus = bonus.div(100);
164             tokens = tokens.add(bonus);
165             require (TOKENS_SOLD.add(tokens) <= maxTokensToSale);
166         }
167         //Phase 2 (31 days)
168         else if (timeElapsedInDays >=30 && timeElapsedInDays <61)
169         {
170             tokens = value.mul(ratePerWeiInPrivateSale);
171             bonus = tokens.mul(bonusInPrivateSale); 
172             bonus = bonus.div(100);
173             tokens = tokens.add(bonus);
174             require (TOKENS_SOLD.add(tokens) <= maxTokensToSale);
175         }
176        
177         //Phase 3 (30 days)
178         else if (timeElapsedInDays >=61 && timeElapsedInDays <91)
179         {
180             tokens = value.mul(ratePerWeiInPreICO);
181             bonus = tokens.mul(bonusInPreICO); 
182             bonus = bonus.div(100);
183             tokens = tokens.add(bonus);
184             require (TOKENS_SOLD.add(tokens) <= maxTokensToSale);
185         }
186         
187         //Phase 4 (122 days)
188         else if (timeElapsedInDays >=91 && timeElapsedInDays <213)
189         {
190             tokens = value.mul(ratePerWeiInMainICO);
191             bonus = tokens.mul(bonusInMainICO); 
192             bonus = bonus.div(100);
193             tokens = tokens.add(bonus);
194             require (TOKENS_SOLD.add(tokens) <= maxTokensToSale);
195         }
196         else 
197         {
198             bonus = 0;
199         }
200     }
201 
202   // low level token purchase function
203   
204   function buyTokens(address beneficiary) public payable {
205     require(beneficiary != 0x0);
206     require(isCrowdsalePaused == false);
207     require(validPurchase());
208 
209     
210     require(TOKENS_SOLD<maxTokensToSale);
211    
212     uint256 weiAmount = msg.value;
213     
214     uint256 tokens = calculateTokens(weiAmount);
215     
216     // update state
217     weiRaised = weiRaised.add(msg.value);
218     
219     token.transfer(beneficiary,tokens);
220     emit TokenPurchase(owner, beneficiary, msg.value, tokens);
221     TOKENS_SOLD = TOKENS_SOLD.add(tokens);
222     forwardFunds();
223   }
224 
225   // send ether to the fund collection wallet
226   function forwardFunds() internal {
227     owner.transfer(msg.value);
228   }
229 
230   // @return true if the transaction can buy tokens
231   function validPurchase() internal constant returns (bool) {
232     bool withinPeriod = now >= startTime && now <= endTime;
233     bool nonZeroPurchase = msg.value != 0;
234     return withinPeriod && nonZeroPurchase;
235   }
236 
237   // @return true if crowdsale event has ended
238   function hasEnded() public constant returns (bool) {
239     return now > endTime;
240   }
241   
242    /**
243     * function to change the end timestamp of the ico
244     * can only be called by owner wallet
245     **/
246     function changeEndDate(uint256 endTimeUnixTimestamp) public onlyOwner{
247         endTime = endTimeUnixTimestamp;
248     }
249     
250     /**
251     * function to change the start timestamp of the ico
252     * can only be called by owner wallet
253     **/
254     
255     function changeStartDate(uint256 startTimeUnixTimestamp) public onlyOwner{
256         startTime = startTimeUnixTimestamp;
257     }
258     
259      /**
260      * function to pause the crowdsale 
261      * can only be called from owner wallet
262      **/
263      
264     function pauseCrowdsale() public onlyOwner {
265         isCrowdsalePaused = true;
266     }
267 
268     /**
269      * function to resume the crowdsale if it is paused
270      * can only be called from owner wallet
271      **/ 
272     function resumeCrowdsale() public onlyOwner {
273         isCrowdsalePaused = false;
274     }
275      
276      function takeTokensBack() public onlyOwner
277      {
278          uint remainingTokensInTheContract = token.balanceOf(address(this));
279          token.transfer(owner,remainingTokensInTheContract);
280      }
281 }