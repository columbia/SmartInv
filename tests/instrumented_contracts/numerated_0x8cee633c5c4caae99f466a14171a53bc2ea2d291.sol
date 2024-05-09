1 pragma solidity ^0.4.21;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 contract ERC20 is ERC20Basic {
72   function allowance(address owner, address spender) public view returns (uint256);
73   function transferFrom(address from, address to, uint256 value) public returns (bool);
74   function approve(address spender, uint256 value) public returns (bool);
75   event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
79 
80 /**
81  * @title Crowdsale
82  * @dev Crowdsale is a base contract for managing a token crowdsale,
83  * allowing investors to purchase tokens with ether. This contract implements
84  * such functionality in its most fundamental form and can be extended to provide additional
85  * functionality and/or custom behavior.
86  * The external interface represents the basic interface for purchasing tokens, and conform
87  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
88  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
89  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
90  * behavior.
91  */
92 contract Crowdsale {
93   using SafeMath for uint256;
94 
95   // The token being sold
96   ERC20 public token;
97 
98   // Address where funds are collected
99   address public wallet;
100 
101   // How many token units a buyer gets per wei
102   uint256 public rate;
103 
104   // Amount of wei raised
105   uint256 public weiRaised;
106 
107   /**
108    * Event for token purchase logging
109    * @param purchaser who paid for the tokens
110    * @param beneficiary who got the tokens
111    * @param value weis paid for purchase
112    * @param amount amount of tokens purchased
113    */
114   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
115 
116   /**
117    * @param _rate Number of token units a buyer gets per wei
118    * @param _wallet Address where collected funds will be forwarded to
119    * @param _token Address of the token being sold
120    */
121   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
122     require(_rate > 0);
123     require(_wallet != address(0));
124     require(_token != address(0));
125 
126     rate = _rate;
127     wallet = _wallet;
128     token = _token;
129   }
130 
131   // -----------------------------------------
132   // Crowdsale external interface
133   // -----------------------------------------
134 
135   /**
136    * @dev fallback function ***DO NOT OVERRIDE***
137    */
138   function () external payable {
139     buyTokens(msg.sender);
140   }
141 
142   /**
143    * @dev low level token purchase ***DO NOT OVERRIDE***
144    * @param _beneficiary Address performing the token purchase
145    */
146   function buyTokens(address _beneficiary) public payable {
147 
148     uint256 weiAmount = msg.value;
149     _preValidatePurchase(_beneficiary, weiAmount);
150 
151     // calculate token amount to be created
152     uint256 tokens = _getTokenAmount(weiAmount);
153 
154     // update state
155     weiRaised = weiRaised.add(weiAmount);
156 
157     _processPurchase(_beneficiary, tokens);
158     emit TokenPurchase(
159       msg.sender,
160       _beneficiary,
161       weiAmount,
162       tokens
163     );
164 
165     _updatePurchasingState(_beneficiary, weiAmount);
166 
167     _forwardFunds();
168     _postValidatePurchase(_beneficiary, weiAmount);
169   }
170 
171   // -----------------------------------------
172   // Internal interface (extensible)
173   // -----------------------------------------
174 
175   /**
176    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
177    * @param _beneficiary Address performing the token purchase
178    * @param _weiAmount Value in wei involved in the purchase
179    */
180   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
181     require(_beneficiary != address(0));
182     require(_weiAmount != 0);
183   }
184 
185   /**
186    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
187    * @param _beneficiary Address performing the token purchase
188    * @param _weiAmount Value in wei involved in the purchase
189    */
190   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
191     // optional override
192   }
193 
194   /**
195    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
196    * @param _beneficiary Address performing the token purchase
197    * @param _tokenAmount Number of tokens to be emitted
198    */
199   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
200     token.transfer(_beneficiary, _tokenAmount);
201   }
202 
203   /**
204    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
205    * @param _beneficiary Address receiving the tokens
206    * @param _tokenAmount Number of tokens to be purchased
207    */
208   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
209     _deliverTokens(_beneficiary, _tokenAmount);
210   }
211 
212   /**
213    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
214    * @param _beneficiary Address receiving the tokens
215    * @param _weiAmount Value in wei involved in the purchase
216    */
217   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
218     // optional override
219   }
220 
221   /**
222    * @dev Override to extend the way in which ether is converted to tokens.
223    * @param _weiAmount Value in wei to be converted into tokens
224    * @return Number of tokens that can be purchased with the specified _weiAmount
225    */
226   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
227     return _weiAmount.mul(rate);
228   }
229 
230   /**
231    * @dev Determines how ETH is stored/forwarded on purchases.
232    */
233   function _forwardFunds() internal {
234     wallet.transfer(msg.value);
235   }
236 }
237 
238 // File: contracts/CCCCrowdSale.sol
239 
240 contract CCCCrowdSale is Crowdsale {
241 
242     constructor(uint256 _rate, address _wallet, address _tokenAddress) Crowdsale(_rate,_wallet, ERC20(_tokenAddress)) public {
243     }
244 }