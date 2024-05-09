1 pragma solidity 0.4.25;
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
52   function Ownable() public {
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
89  contract FeedCrowdsale is Ownable{
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
101   uint256 public ratePerWei = 11905;
102 
103   // amount of raised money in wei
104   uint256 public weiRaised;
105   
106   uint256 public weiRaisedInPreICO;
107 
108   uint256 TOKENS_SOLD;
109 
110   bool isCrowdsalePaused = false;
111   
112   uint256 decimals = 18;
113   
114   uint256 step1Contributions = 0;
115   uint256 step2Contributions = 0;
116   uint256 step3Contributions = 0;
117   uint256 step4Contributions = 0;
118   uint256 step5Contributions = 0;
119   uint256 step6Contributions = 0;
120   uint256 step7Contributions = 0;
121   uint256 step8Contributions = 0;
122   
123   
124   
125   /**
126    * event for token purchase logging
127    * @param purchaser who paid for the tokens
128    * @param beneficiary who got the tokens
129    * @param value weis paid for purchase
130    * @param amount amount of tokens purchased
131    */
132   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
133 
134   constructor(address _wallet, address _tokenAddress) public 
135   {
136     require(_wallet != 0x0);
137     owner = _wallet;
138     token = TokenInterface(_tokenAddress);
139   }
140   
141   
142    // fallback function can be used to buy tokens
143    function () public  payable {
144      buyTokens(msg.sender);
145     }
146     
147     function calculateTokens(uint etherAmount) public returns (uint tokenAmount) {
148         
149         if (etherAmount >= 0.05 ether && etherAmount < 0.09 ether)
150         {
151             //step 1 
152             require(step1Contributions<1000);
153             tokenAmount = uint(1000).mul(uint(10)** decimals);
154             step1Contributions = step1Contributions.add(1);
155         }
156         else if (etherAmount>=0.09 ether && etherAmount < 0.24 ether )
157         {
158             //step 2
159             require(step2Contributions<1000);
160             tokenAmount = uint(2000).mul(uint(10)** decimals);
161             step2Contributions = step2Contributions.add(1);
162             
163         }
164         else if (etherAmount>=0.24 ether && etherAmount<0.46 ether )
165         {
166             //step 3 
167             require(step3Contributions<1000);
168             tokenAmount = uint(6000).mul(uint(10)** decimals);
169             step3Contributions = step3Contributions.add(1);
170         
171         }
172         else if (etherAmount>=0.46 ether && etherAmount<0.90 ether)
173         {
174             //step 4 
175             require(step4Contributions<1000);
176             tokenAmount = uint(13000).mul(uint(10)** decimals);
177             step4Contributions = step4Contributions.add(1);
178         
179         }
180         else if (etherAmount>=0.90 ether && etherAmount<2.26 ether)
181         {
182             //step 5 
183             require(step5Contributions<1000);
184             tokenAmount = uint(25000).mul(uint(10)** decimals);
185             step5Contributions = step5Contributions.add(1);
186         
187         }
188         else if (etherAmount>=2.26 ether && etherAmount<4.49 ether)
189         {
190             //step 6 
191             require(step6Contributions<1000);
192             tokenAmount = uint(60000).mul(uint(10)** decimals);
193             step6Contributions = step6Contributions.add(1);
194         
195         }
196         else if (etherAmount>=4.49 ether && etherAmount<8.99 ether)
197         {
198             //step 7 
199             require(step7Contributions<1000);
200             tokenAmount = uint(130000).mul(uint(10)** decimals);
201             step7Contributions = step7Contributions.add(1);
202         
203         }
204         else if (etherAmount>=8.99 ether && etherAmount<=10 ether)
205         {
206             //step 8
207             require(step8Contributions<1000);
208             tokenAmount = uint(200000).mul(uint(10)** decimals);
209             step8Contributions = step8Contributions.add(1);
210         
211         }
212         else 
213         {
214             revert();
215         }
216     }
217   // low level token purchase function
218   
219   function buyTokens(address beneficiary) public payable {
220     require(beneficiary != 0x0);
221     require(isCrowdsalePaused == false);
222     require(msg.value>0);
223     
224     uint256 weiAmount = msg.value;
225     
226     // calculate token amount to be created
227     uint256 tokens = calculateTokens(weiAmount);
228     
229     // update state
230     weiRaised = weiRaised.add(weiAmount);
231     token.transfer(beneficiary,tokens);
232     
233     emit TokenPurchase(owner, beneficiary, weiAmount, tokens);
234     TOKENS_SOLD = TOKENS_SOLD.add(tokens);
235     forwardFunds();
236   }
237 
238   // send ether to the fund collection wallet
239   function forwardFunds() internal {
240     owner.transfer(msg.value);
241   }
242 
243  
244   // @return true if crowdsale event has ended
245   function hasEnded() public constant returns (bool) {
246     return now > endTime;
247   }
248     
249     /**
250     * function to change the rate of tokens
251     * can only be called by owner wallet
252     **/
253     function setPriceRate(uint256 newPrice) public onlyOwner {
254         ratePerWei = newPrice;
255     }
256     
257      /**
258      * function to pause the crowdsale 
259      * can only be called from owner wallet
260      **/
261      
262     function pauseCrowdsale() public onlyOwner {
263         isCrowdsalePaused = true;
264     }
265 
266     /**
267      * function to resume the crowdsale if it is paused
268      * can only be called from owner wallet
269      **/ 
270     function resumeCrowdsale() public onlyOwner {
271         isCrowdsalePaused = false;
272     }
273     
274      function getUnsoldTokensBack() public onlyOwner
275      {
276         uint contractTokenBalance = token.balanceOf(address(this));
277         require(contractTokenBalance>0);
278         token.transfer(owner,contractTokenBalance);
279      }
280 }