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
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
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
65 /**
66  * @title ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/20
68  */
69 contract ERC20 is ERC20Basic {
70   function allowance(address owner, address spender)
71     public view returns (uint256);
72 
73   function transferFrom(address from, address to, uint256 value)
74     public returns (bool);
75 
76   function approve(address spender, uint256 value) public returns (bool);
77   event Approval(
78     address indexed owner,
79     address indexed spender,
80     uint256 value
81   );
82 }
83 
84 /**
85  * @title Ownable
86  * @dev The Ownable contract has an owner address, and provides basic authorization control
87  * functions, this simplifies the implementation of "user permissions".
88  */
89 contract Ownable {
90   address public owner;
91 
92 
93   event OwnershipRenounced(address indexed previousOwner);
94   event OwnershipTransferred(
95     address indexed previousOwner,
96     address indexed newOwner
97   );
98 
99 
100   /**
101    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
102    * account.
103    */
104   constructor() public {
105     owner = msg.sender;
106   }
107 
108   /**
109    * @dev Throws if called by any account other than the owner.
110    */
111   modifier onlyOwner() {
112     require(msg.sender == owner);
113     _;
114   }
115 
116   /**
117    * @dev Allows the current owner to relinquish control of the contract.
118    */
119   function renounceOwnership() public onlyOwner {
120     emit OwnershipRenounced(owner);
121     owner = address(0);
122   }
123 
124   /**
125    * @dev Allows the current owner to transfer control of the contract to a newOwner.
126    * @param _newOwner The address to transfer ownership to.
127    */
128   function transferOwnership(address _newOwner) public onlyOwner {
129     _transferOwnership(_newOwner);
130   }
131 
132   /**
133    * @dev Transfers control of the contract to a newOwner.
134    * @param _newOwner The address to transfer ownership to.
135    */
136   function _transferOwnership(address _newOwner) internal {
137     require(_newOwner != address(0));
138     emit OwnershipTransferred(owner, _newOwner);
139     owner = _newOwner;
140   }
141 }
142 
143 /**
144  * @title Crowdsale
145  * @dev Crowdsale is a base contract for managing a token crowdsale,
146  * allowing investors to purchase tokens with ether. This contract implements
147  * such functionality in its most fundamental form and can be extended to provide additional
148  * functionality and/or custom behavior.
149  * The external interface represents the basic interface for purchasing tokens, and conform
150  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
151  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
152  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
153  * behavior.
154  */
155 contract EmploySale is Ownable {
156   using SafeMath for uint256;
157 
158   // The token being sold
159   ERC20 public token;
160 
161   // Amount of wei raised
162   uint256 public weiRaised;
163 
164   /**
165    * Event for token purchase logging
166    * @param purchaser who paid for the tokens
167    * @param beneficiary who got the tokens
168    * @param value weis paid for purchase
169    * @param amount amount of tokens purchased
170    */
171   event TokenPurchase(
172     address indexed purchaser,
173     address indexed beneficiary,
174     uint256 value,
175     uint256 amount
176   );
177 
178   /**
179    * @param _token Address of the token being sold
180    */
181   constructor(ERC20 _token) public {
182     token = _token;
183   }
184 
185   // -----------------------------------------
186   // Crowdsale external interface
187   // -----------------------------------------
188 
189   /**
190    * @dev low level token purchase ***DO NOT OVERRIDE***
191    * @param _beneficiary Address performing the token purchase
192    */
193   function buyTokens(address _beneficiary, uint256 _rate, address _wallet) public payable {
194     require(_wallet != address(0));
195     require(_rate != 0);
196 
197     uint256 weiAmount = msg.value;
198     _preValidatePurchase(_beneficiary, weiAmount);
199 
200     // calculate token amount to be created
201     uint256 tokens = _getTokenAmount(weiAmount, _rate);
202 
203     // update state
204     weiRaised = weiRaised.add(weiAmount);
205 
206     _processPurchase(_beneficiary, tokens);
207     emit TokenPurchase(
208       msg.sender,
209       _beneficiary,
210       weiAmount,
211       tokens
212     );
213 
214     _forwardFunds(_wallet);
215   }
216 
217   // -----------------------------------------
218   // Internal interface (extensible)
219   // -----------------------------------------
220 
221   /**
222    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
223    * @param _beneficiary Address performing the token purchase
224    * @param _weiAmount Value in wei involved in the purchase
225    */
226   function _preValidatePurchase(
227     address _beneficiary,
228     uint256 _weiAmount
229   )
230     internal
231   {
232     require(_beneficiary != address(0));
233     require(_weiAmount != 0);
234   }
235 
236   /**
237    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
238    * @param _beneficiary Address performing the token purchase
239    * @param _tokenAmount Number of tokens to be emitted
240    */
241   function _deliverTokens(
242     address _beneficiary,
243     uint256 _tokenAmount
244   )
245     internal
246   {
247     token.transfer(_beneficiary, _tokenAmount);
248   }
249 
250   /**
251    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
252    * @param _beneficiary Address receiving the tokens
253    * @param _tokenAmount Number of tokens to be purchased
254    */
255   function _processPurchase(
256     address _beneficiary,
257     uint256 _tokenAmount
258   )
259     internal
260   {
261     _deliverTokens(_beneficiary, _tokenAmount);
262   }
263 
264 
265   /**
266    * @dev Override to extend the way in which ether is converted to tokens.
267    * @param _weiAmount Value in wei to be converted into tokens
268    * @param _rate It is number of tokens transfered per ETH investment 
269    * @return Number of tokens that can be purchased with the specified _weiAmount
270    */
271   function _getTokenAmount(uint256 _weiAmount, uint256 _rate)
272     internal pure returns (uint256)
273   {
274     return _weiAmount.mul(_rate);
275   }
276 
277   /**
278    * @dev Determines how ETH is stored/forwarded on purchases.
279    */
280   function _forwardFunds(address _wallet) internal {
281     _wallet.transfer(msg.value);
282   }
283 
284   function withdrawToken() onlyOwner external returns(bool) {
285     require(token.transfer(owner, token.balanceOf(address(this))));
286     return true;
287   }
288 
289 }