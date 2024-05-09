1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-eth/contracts/token/ERC20/IERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10   function totalSupply() external view returns (uint256);
11 
12   function balanceOf(address who) external view returns (uint256);
13 
14   function allowance(address owner, address spender)
15     external view returns (uint256);
16 
17   function transfer(address to, uint256 value) external returns (bool);
18 
19   function approve(address spender, uint256 value)
20     external returns (bool);
21 
22   function transferFrom(address from, address to, uint256 value)
23     external returns (bool);
24 
25   event Transfer(
26     address indexed from,
27     address indexed to,
28     uint256 value
29   );
30 
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: openzeppelin-eth/contracts/math/SafeMath.sol
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that revert on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, reverts on overflow.
48   */
49   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (a == 0) {
54       return 0;
55     }
56 
57     uint256 c = a * b;
58     require(c / a == b);
59 
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     require(b > 0); // Solidity only automatically asserts when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70 
71     return c;
72   }
73 
74   /**
75   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
76   */
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     require(b <= a);
79     uint256 c = a - b;
80 
81     return c;
82   }
83 
84   /**
85   * @dev Adds two numbers, reverts on overflow.
86   */
87   function add(uint256 a, uint256 b) internal pure returns (uint256) {
88     uint256 c = a + b;
89     require(c >= a);
90 
91     return c;
92   }
93 
94   /**
95   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
96   * reverts when dividing by zero.
97   */
98   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
99     require(b != 0);
100     return a % b;
101   }
102 }
103 
104 // File: contracts/dex/ITokenConverter.sol
105 
106 contract ITokenConverter {    
107     using SafeMath for uint256;
108 
109     /**
110     * @dev Makes a simple ERC20 -> ERC20 token trade
111     * @param _srcToken - IERC20 token
112     * @param _destToken - IERC20 token 
113     * @param _srcAmount - uint256 amount to be converted
114     * @param _destAmount - uint256 amount to get after conversion
115     * @return uint256 for the change. 0 if there is no change
116     */
117     function convert(
118         IERC20 _srcToken,
119         IERC20 _destToken,
120         uint256 _srcAmount,
121         uint256 _destAmount
122         ) external returns (uint256);
123 
124     /**
125     * @dev Get exchange rate and slippage rate. 
126     * Note that these returned values are in 18 decimals regardless of the destination token's decimals.
127     * @param _srcToken - IERC20 token
128     * @param _destToken - IERC20 token 
129     * @param _srcAmount - uint256 amount to be converted
130     * @return uint256 of the expected rate
131     * @return uint256 of the slippage rate
132     */
133     function getExpectedRate(IERC20 _srcToken, IERC20 _destToken, uint256 _srcAmount) 
134         public view returns(uint256 expectedRate, uint256 slippageRate);
135 }
136 
137 // File: contracts/dex/IKyberNetwork.sol
138 
139 contract IKyberNetwork {
140     function trade(
141         IERC20 _srcToken,
142         uint _srcAmount,
143         IERC20 _destToken,
144         address _destAddress, 
145         uint _maxDestAmount,	
146         uint _minConversionRate,	
147         address _walletId
148         ) 
149         public payable returns(uint);
150 
151     function getExpectedRate(IERC20 _srcToken, IERC20 _destToken, uint _srcAmount) 
152         public view returns(uint expectedRate, uint slippageRate);
153 }
154 
155 // File: contracts/libs/SafeTransfer.sol
156 
157 /**
158 * @dev Library to perform transfer for ERC20 tokens.
159 * Not all the tokens transfer method has a return value (bool) neither revert for insufficient funds or 
160 * unathorized _value
161 */
162 library SafeTransfer {
163     /**
164     * @dev Transfer token for a specified address
165     * @param _token erc20 The address of the ERC20 contract
166     * @param _to address The address which you want to transfer to
167     * @param _value uint256 the _value of tokens to be transferred
168     */
169     function safeTransfer(IERC20 _token, address _to, uint256 _value) internal returns (bool) {
170         uint256 prevBalance = _token.balanceOf(address(this));
171 
172         require(prevBalance >= _value, "Insufficient funds");
173 
174         _token.transfer(_to, _value);
175 
176         require(prevBalance - _value == _token.balanceOf(address(this)), "Transfer failed");
177 
178         return true;
179     }
180 
181     /**
182     * @dev Transfer tokens from one address to another
183     * @param _token erc20 The address of the ERC20 contract
184     * @param _from address The address which you want to send tokens from
185     * @param _to address The address which you want to transfer to
186     * @param _value uint256 the _value of tokens to be transferred
187     */
188     function safeTransferFrom(
189         IERC20 _token,
190         address _from,
191         address _to, 
192         uint256 _value
193     ) internal returns (bool) 
194     {
195         uint256 prevBalance = _token.balanceOf(_from);
196 
197         require(prevBalance >= _value, "Insufficient funds");
198         require(_token.allowance(_from, address(this)) >= _value, "Insufficient allowance");
199 
200         _token.transferFrom(_from, _to, _value);
201 
202         require(prevBalance - _value == _token.balanceOf(_from), "Transfer failed");
203 
204         return true;
205     }
206 }
207 
208 // File: contracts/dex/KyberConverter.sol
209 
210 /**
211 * @dev Contract to encapsulate Kyber methods which implements ITokenConverter.
212 * Note that need to create it with a valid kyber address
213 */
214 contract KyberConverter is ITokenConverter {
215     using SafeTransfer for IERC20;
216 
217     IKyberNetwork internal  kyber;
218     uint256 private constant MAX_UINT = uint256(0) - 1;
219     address internal walletId;
220 
221     constructor (IKyberNetwork _kyber, address _walletId) public {
222         kyber = _kyber;
223         walletId = _walletId;
224     }
225     
226     function convert(
227         IERC20 _srcToken,
228         IERC20 _destToken,
229         uint256 _srcAmount,
230         uint256 _destAmount
231     ) 
232     external returns (uint256)
233     {
234         // Save prev src token balance 
235         uint256 prevSrcBalance = _srcToken.balanceOf(address(this));
236 
237         // Transfer tokens to be converted from msg.sender to this contract
238         require(
239             _srcToken.safeTransferFrom(msg.sender, address(this), _srcAmount),
240             "Could not transfer _srcToken to this contract"
241         );
242 
243         // Approve Kyber to use _srcToken on belhalf of this contract
244         require(
245             _srcToken.approve(kyber, _srcAmount),
246             "Could not approve kyber to use _srcToken on behalf of this contract"
247         );
248 
249         // Trade _srcAmount from _srcToken to _destToken
250         // Note that minConversionRate is set to 0 cause we want the lower rate possible
251         uint256 amount = kyber.trade(
252             _srcToken,
253             _srcAmount,
254             _destToken,
255             address(this),
256             _destAmount,
257             0,
258             walletId
259         );
260 
261         // Clean kyber to use _srcTokens on belhalf of this contract
262         require(
263             _srcToken.approve(kyber, 0),
264             "Could not clean approval of kyber to use _srcToken on behalf of this contract"
265         );
266 
267         // Check if the amount traded is equal to the expected one
268         require(amount == _destAmount, "Amount bought is not equal to dest amount");
269 
270         // Return the change of src token
271         uint256 change = _srcToken.balanceOf(address(this)).sub(prevSrcBalance);
272         require(
273             _srcToken.safeTransfer(msg.sender, change),
274             "Could not transfer change to sender"
275         );
276 
277 
278         // Transfer amount of _destTokens to msg.sender
279         require(
280             _destToken.safeTransfer(msg.sender, amount),
281             "Could not transfer amount of _destToken to msg.sender"
282         );
283 
284         return change;
285     }
286 
287     function getExpectedRate(IERC20 _srcToken, IERC20 _destToken, uint256 _srcAmount) 
288     public view returns(uint256 expectedRate, uint256 slippageRate) 
289     {
290         (expectedRate, slippageRate) = kyber.getExpectedRate(_srcToken, _destToken, _srcAmount);
291     }
292 }