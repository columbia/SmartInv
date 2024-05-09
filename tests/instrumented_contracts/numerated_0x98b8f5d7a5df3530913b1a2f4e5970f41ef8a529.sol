1 contract ERC20Basic {
2   function totalSupply() public view returns (uint256);
3   function balanceOf(address who) public view returns (uint256);
4   function transfer(address to, uint256 value) public returns (bool);
5   event Transfer(address indexed from, address indexed to, uint256 value);
6 }
7 
8 
9 /**
10  * @title ERC20 interface
11  * @dev see https://github.com/ethereum/EIPs/issues/20
12  */
13 contract ERC20 is ERC20Basic {
14   function allowance(address owner, address spender)
15     public view returns (uint256);
16 
17   function transferFrom(address from, address to, uint256 value)
18     public returns (bool);
19 
20   function approve(address spender, uint256 value) public returns (bool);
21   event Approval(
22     address indexed owner,
23     address indexed spender,
24     uint256 value
25   );
26 }
27 
28 
29 /**
30  * @title SafeMath
31  * @dev Math operations with safety checks that throw on error
32  */
33 library SafeMath {
34 
35   /**
36   * @dev Multiplies two numbers, throws on overflow.
37   */
38   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
40     // benefit is lost if 'b' is also tested.
41     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
42     if (a == 0) {
43       return 0;
44     }
45 
46     c = a * b;
47     assert(c / a == b);
48     return c;
49   }
50 
51   /**
52   * @dev Integer division of two numbers, truncating the quotient.
53   */
54   function div(uint256 a, uint256 b) internal pure returns (uint256) {
55     // assert(b > 0); // Solidity automatically throws when dividing by 0
56     // uint256 c = a / b;
57     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58     return a / b;
59   }
60 
61   /**
62   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
63   */
64   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65     assert(b <= a);
66     return a - b;
67   }
68 
69   /**
70   * @dev Adds two numbers, throws on overflow.
71   */
72   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
73     c = a + b;
74     assert(c >= a);
75     return c;
76   }
77 }
78 
79 /**
80  * @title SafeERC20
81  * @dev Wrappers around ERC20 operations that throw on failure.
82  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
83  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
84  */
85 library SafeERC20 {
86   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
87     require(token.transfer(to, value));
88   }
89 
90   function safeTransferFrom(
91     ERC20 token,
92     address from,
93     address to,
94     uint256 value
95   )
96     internal
97   {
98     require(token.transferFrom(from, to, value));
99   }
100 
101   function safeApprove(ERC20 token, address spender, uint256 value) internal {
102     require(token.approve(spender, value));
103   }
104 }
105 
106 /**
107   * The contract used for airdrop campaign of ATT token 
108   */
109 contract Airdrop {
110     
111     using SafeMath for uint256;
112     using SafeERC20 for ERC20;
113     
114     // The token being sold
115     ERC20 public token;
116 
117     address owner = 0x0;
118 
119     // How many token units a buyer gets per wei.
120     // The rate is the conversion between wei and the smallest and indivisible token unit.
121     // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
122     // 1 wei will give you 1 unit, or 0.001 TOK.
123     uint256 public rate;
124     
125     modifier isOwner {
126         assert(owner == msg.sender);
127         _;
128     }
129 
130   /**
131    * Event for token drop logging
132    * @param sender who send the tokens
133    * @param beneficiary who got the tokens
134    * @param value weis sent
135    * @param amount amount of tokens dropped
136    */
137   event TokenDropped(
138     address indexed sender,
139     address indexed beneficiary,
140     uint256 value,
141     uint256 amount
142   );
143 
144   /**
145    * @param _token Address of the token being sold
146    */
147   constructor(ERC20 _token) public
148   {
149     require(_token != address(0));
150 
151     owner = msg.sender;
152     token = _token;
153   }
154 
155   // -----------------------------------------
156   // Crowdsale external interface
157   // -----------------------------------------
158 
159   /**
160    * @dev fallback function ***DO NOT OVERRIDE***
161    */
162   function () external payable {
163     sendAirDrops(msg.sender);
164   }
165 
166     /**
167     * @dev low level token purchase ***DO NOT OVERRIDE***
168     * @param _beneficiary Address performing the token purchase
169     */
170     function sendAirDrops(address _beneficiary) public payable
171     {
172         uint256 weiAmount = msg.value;
173         _preValidatePurchase(_beneficiary, weiAmount);
174         
175         // calculate token amount to be created
176         uint256 tokens = 50 * (10 ** 6);
177         
178         _processAirdrop(_beneficiary, tokens);
179         
180         emit TokenDropped(
181             msg.sender,
182             _beneficiary,
183             weiAmount,
184             tokens
185         );
186     }
187   
188     function collect(uint256 _weiAmount) isOwner public {
189         address thisAddress = this;
190         owner.transfer(thisAddress.balance);
191     }
192 
193   // -----------------------------------------
194   // Internal interface (extensible)
195   // -----------------------------------------
196 
197   /**
198    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
199    * @param _beneficiary Address performing the token purchase
200    * @param _weiAmount Value in wei involved in the purchase
201    */
202   function _preValidatePurchase( address _beneficiary, uint256 _weiAmount) internal
203   {
204     require(_beneficiary != address(0));
205     require(_weiAmount >= 1 * (10 ** 15));
206   }
207 
208   /**
209    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
210    * @param _beneficiary Address performing the token purchase
211    * @param _tokenAmount Number of tokens to be emitted
212    */
213   function _deliverTokens(
214     address _beneficiary,
215     uint256 _tokenAmount
216   )
217     internal
218   {
219     token.safeTransfer(_beneficiary, _tokenAmount);
220   }
221 
222   /**
223    * @dev Executed when a purchase has been validated and is ready to be executed.
224    * @param _beneficiary Address receiving the tokens
225    * @param _tokenAmount Number of tokens to be purchased
226    */
227   function _processAirdrop(
228     address _beneficiary,
229     uint256 _tokenAmount
230   )
231     internal
232   {
233     _deliverTokens(_beneficiary, _tokenAmount);
234   }
235 
236 }