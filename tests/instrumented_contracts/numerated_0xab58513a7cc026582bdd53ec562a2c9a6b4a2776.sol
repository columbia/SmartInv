1 pragma solidity ^0.4.24;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 
11 /**
12  * @title ERC20 interface
13  * @dev see https://github.com/ethereum/EIPs/issues/20
14  */
15 contract ERC20 is ERC20Basic {
16   function allowance(address owner, address spender)
17     public view returns (uint256);
18 
19   function transferFrom(address from, address to, uint256 value)
20     public returns (bool);
21 
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(
24     address indexed owner,
25     address indexed spender,
26     uint256 value
27   );
28 }
29 
30 
31 /**
32  * @title SafeMath
33  * @dev Math operations with safety checks that throw on error
34  */
35 library SafeMath {
36 
37   /**
38   * @dev Multiplies two numbers, throws on overflow.
39   */
40   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
41     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
42     // benefit is lost if 'b' is also tested.
43     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
44     if (a == 0) {
45       return 0;
46     }
47 
48     c = a * b;
49     assert(c / a == b);
50     return c;
51   }
52 
53   /**
54   * @dev Integer division of two numbers, truncating the quotient.
55   */
56   function div(uint256 a, uint256 b) internal pure returns (uint256) {
57     // assert(b > 0); // Solidity automatically throws when dividing by 0
58     // uint256 c = a / b;
59     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60     return a / b;
61   }
62 
63   /**
64   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
65   */
66   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67     assert(b <= a);
68     return a - b;
69   }
70 
71   /**
72   * @dev Adds two numbers, throws on overflow.
73   */
74   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
75     c = a + b;
76     assert(c >= a);
77     return c;
78   }
79 }
80 
81 /**
82  * @title SafeERC20
83  * @dev Wrappers around ERC20 operations that throw on failure.
84  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
85  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
86  */
87 library SafeERC20 {
88   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
89     require(token.transfer(to, value));
90   }
91 
92   function safeTransferFrom(
93     ERC20 token,
94     address from,
95     address to,
96     uint256 value
97   )
98     internal
99   {
100     require(token.transferFrom(from, to, value));
101   }
102 
103   function safeApprove(ERC20 token, address spender, uint256 value) internal {
104     require(token.approve(spender, value));
105   }
106 }
107 
108 /**
109   * The contract used for airdrop campaign of ATT token 
110   */
111 contract Airdrop {
112     
113     using SafeMath for uint256;
114     using SafeERC20 for ERC20;
115     
116     // The token being sold
117     ERC20 public token;
118 
119     address owner = 0x0;
120 
121     // How many token units a buyer gets per wei.
122     // The rate is the conversion between wei and the smallest and indivisible token unit.
123     // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
124     // 1 wei will give you 1 unit, or 0.001 TOK.
125     uint256 public rate;
126     
127     modifier isOwner {
128         assert(owner == msg.sender);
129         _;
130     }
131 
132   /**
133    * Event for token drop logging
134    * @param sender who send the tokens
135    * @param beneficiary who got the tokens
136    * @param value weis sent
137    * @param amount amount of tokens dropped
138    */
139   event TokenDropped(
140     address indexed sender,
141     address indexed beneficiary,
142     uint256 value,
143     uint256 amount
144   );
145 
146   /**
147    * @param _token Address of the token being sold
148    */
149   constructor(ERC20 _token) public
150   {
151     require(_token != address(0));
152 
153     owner = msg.sender;
154     token = _token;
155   }
156 
157   // -----------------------------------------
158   // External interface
159   // -----------------------------------------
160 
161   /**
162    * @dev fallback function ***DO NOT OVERRIDE***
163    */
164   function () external payable {
165     sendAirDrops(msg.sender);
166   }
167 
168     /**
169     * @dev low level token purchase ***DO NOT OVERRIDE***
170     * @param _beneficiary Address performing the token purchase
171     */
172     function sendAirDrops(address _beneficiary) public payable
173     {
174         uint256 weiAmount = msg.value;
175         _preValidatePurchase(_beneficiary, weiAmount);
176         
177         // calculate token amount to be created
178         // uint256 tokens = 50 * (10 ** 6);
179         uint256 tokens = _getTokenAmount(weiAmount);
180         
181         _processAirdrop(_beneficiary, tokens);
182         
183         emit TokenDropped(
184             msg.sender,
185             _beneficiary,
186             weiAmount,
187             tokens
188         );
189     }
190   
191     function collect(uint256 _weiAmount) isOwner public {
192         address thisAddress = this;
193         owner.transfer(thisAddress.balance);
194     }
195     
196     function withdraw(uint256 _tokenAmount) isOwner public {
197         token.safeTransfer(owner, _tokenAmount);
198     }
199 
200   // -----------------------------------------
201   // Internal interface (extensible)
202   // -----------------------------------------
203 
204   /**
205    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
206    * @param _beneficiary Address performing the token purchase
207    * @param _weiAmount Value in wei involved in the purchase
208    */
209   function _preValidatePurchase( address _beneficiary, uint256 _weiAmount) internal
210   {
211     require(_beneficiary != address(0));
212     require(_weiAmount >= 1 * (10 ** 17));
213   }
214   
215   function _getTokenAmount(uint256 _weiAmount)
216     internal view returns (uint256)
217   {
218         uint256 seed = _weiAmount.div(1 * (10**9));
219         return seed.mul(33);
220   }
221 
222   /**
223    * @dev Source of tokens. Override this method to modify the way in which the action ultimately gets and sends its tokens.
224    * @param _beneficiary Address performing the token purchase
225    * @param _tokenAmount Number of tokens to be emitted
226    */
227   function _deliverTokens(
228     address _beneficiary,
229     uint256 _tokenAmount
230   )
231     internal
232   {
233     token.safeTransfer(_beneficiary, _tokenAmount);
234   }
235 
236   /**
237    * @dev Executed when a purchase has been validated and is ready to be executed.
238    * @param _beneficiary Address receiving the tokens
239    * @param _tokenAmount Number of tokens to be purchased
240    */
241   function _processAirdrop(
242     address _beneficiary,
243     uint256 _tokenAmount
244   )
245     internal
246   {
247     _deliverTokens(_beneficiary, _tokenAmount);
248   }
249 
250 }