1 pragma solidity ^0.4.24;
2 
3 /**
4  * SmartEth.co
5  * ERC20 Token and ICO smart contracts development, smart contracts audit, ICO websites.
6  * contact@smarteth.co
7  */
8 
9 /**
10  * @title SafeMath
11  */
12 library SafeMath {
13 
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function add(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a + b;
37     assert(c >= a);
38     return c;
39   }
40 }
41 
42 /**
43  * @title Ownable
44  */
45 contract Ownable {
46   address public owner;
47 
48   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50   constructor() public {
51     owner = 0x9E93C3aD3762b282bc32E8ea0C76bdf4c06BdcBA;
52   }
53 
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59   function transferOwnership(address newOwner) public onlyOwner {
60     require(newOwner != address(0));
61     emit OwnershipTransferred(owner, newOwner);
62     owner = newOwner;
63   }
64 
65 }
66 
67 /**
68  * @title Pausable
69  */
70 contract Pausable is Ownable {
71   event Pause();
72   event Unpause();
73 
74   bool public paused = false;
75 
76   modifier whenNotPaused() {
77     require(!paused);
78     _;
79   }
80 
81   modifier whenPaused() {
82     require(paused);
83     _;
84   }
85 
86   function pause() onlyOwner whenNotPaused public {
87     paused = true;
88     emit Pause();
89   }
90 
91   function unpause() onlyOwner whenPaused public {
92     paused = false;
93     emit Unpause();
94   }
95 }
96 
97 /**
98  * @title ERC20Basic
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 /**
108  * @title ERC20 interface
109  */
110 contract ERC20 is ERC20Basic {
111   function allowance(address owner, address spender) public view returns (uint256);
112   function transferFrom(address from, address to, uint256 value) public returns (bool);
113   function approve(address spender, uint256 value) public returns (bool);
114   event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 contract FSN_ICO is Pausable {
118   using SafeMath for uint256;
119 
120   // The token being sold
121   ERC20 public token;
122 
123   // Address where funds are collected
124   address public wallet;
125 
126   // Max supply of tokens offered in the crowdsale
127   uint256 public supply;
128 
129   // How many token units a buyer gets per wei
130   uint256 public rate;
131 
132   // Amount of wei raised
133   uint256 public weiRaised;
134   
135   // Min amount of wei an investor can send
136   uint256 public minInvest;
137   
138   // Crowdsale opening time
139   uint256 public openingTime;
140   
141   // Crowdsale closing time
142   uint256 public closingTime;
143 
144   // Crowdsale duration in days
145   uint256 public duration;
146 
147   /**
148    * Event for token purchase logging
149    * @param purchaser who paid for the tokens
150    * @param beneficiary who got the tokens
151    * @param value weis paid for purchase
152    * @param amount amount of tokens purchased
153    */
154   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
155 
156   constructor() public {
157     rate = 479000;
158     wallet = owner;
159     token = ERC20(0xc1cF9219AA4C2bac5C791eEb7B9caAeADA8aFC33);
160     minInvest = 0.1 * 1 ether;
161     duration = 153 days;
162     openingTime = 1533081600;  // Determined by start()
163     closingTime = openingTime + duration;  // Determined by start()
164   }
165   
166   /**
167    * @dev called by the owner to start the crowdsale
168    */
169   function start() public onlyOwner {
170     openingTime = now;       
171     closingTime =  now + duration;
172   }
173 
174   /**
175    * @dev Returns the rate of tokens per wei at the present time.
176    */
177   function getCurrentRate() public view returns (uint256) {
178     if (now <= openingTime.add(31 days)) return rate.add(rate/2);   // Stage 1: Bonus 50%
179     if (now > openingTime.add(31 days) && now <= openingTime.add(61 days)) return rate.add(rate*3/10);   // Stage 2: Bonus 30%
180   }
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
203     uint256 tokens = _getTokenAmount(weiAmount);
204 
205     // update state
206     weiRaised = weiRaised.add(weiAmount);
207 
208     _processPurchase(_beneficiary, tokens);
209     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
210 
211     _forwardFunds();
212   }
213 
214   // -----------------------------------------
215   // Internal interface (extensible)
216   // -----------------------------------------
217 
218   /**
219    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
220    * @param _beneficiary Address performing the token purchase
221    * @param _weiAmount Value in wei involved in the purchase
222    */
223   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal whenNotPaused {
224     require(_beneficiary != address(0));
225     require(_weiAmount >= minInvest);
226     require(now >= openingTime && now <= closingTime);
227   }
228 
229   /**
230    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
231    * @param _beneficiary Address performing the token purchase
232    * @param _tokenAmount Number of tokens to be emitted
233    */
234   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
235     token.transfer(_beneficiary, _tokenAmount);
236   }
237 
238   /**
239    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
240    * @param _beneficiary Address receiving the tokens
241    * @param _tokenAmount Number of tokens to be purchased
242    */
243   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
244     _deliverTokens(_beneficiary, _tokenAmount);
245   }
246 
247   /**
248    * @dev Override to extend the way in which ether is converted to tokens.
249    * @param _weiAmount Value in wei to be converted into tokens
250    * @return Number of tokens that can be purchased with the specified _weiAmount
251    */
252   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
253     uint256 currentRate = getCurrentRate();
254     return currentRate.mul(_weiAmount);
255   }
256 
257   /**
258    * @dev Determines how ETH is stored/forwarded on purchases.
259    */
260   function _forwardFunds() internal {
261     wallet.transfer(msg.value);
262   }
263   
264   /**
265    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
266    * @return Whether crowdsale period has elapsed
267    */
268   function hasClosed() public view returns (bool) {
269     return now > closingTime;
270   }
271 
272   /**
273    * @dev called by the owner to withdraw unsold tokens
274    */
275   function withdrawTokens() public onlyOwner {
276     uint256 unsold = token.balanceOf(this);
277     token.transfer(owner, unsold);
278   }
279 
280 }