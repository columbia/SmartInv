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
155 // File: contracts/libs/SafeERC20.sol
156 
157 /**
158 * @dev Library to perform safe calls to standard method for ERC20 tokens.
159 * Transfers : transfer methods could have a return value (bool), revert for insufficient funds or
160 * unathorized value.
161 *
162 * Approve: approve method could has a return value (bool) or does not accept 0 as a valid value (BNB token).
163 * The common strategy used to clean approvals.
164 */
165 library SafeERC20 {
166     /**
167     * @dev Transfer token for a specified address
168     * @param _token erc20 The address of the ERC20 contract
169     * @param _to address The address which you want to transfer to
170     * @param _value uint256 the _value of tokens to be transferred
171     */
172     function safeTransfer(IERC20 _token, address _to, uint256 _value) internal returns (bool) {
173         uint256 prevBalance = _token.balanceOf(address(this));
174 
175         require(prevBalance >= _value, "Insufficient funds");
176 
177         _token.transfer(_to, _value);
178 
179         require(prevBalance - _value == _token.balanceOf(address(this)), "Transfer failed");
180 
181         return true;
182     }
183 
184     /**
185     * @dev Transfer tokens from one address to another
186     * @param _token erc20 The address of the ERC20 contract
187     * @param _from address The address which you want to send tokens from
188     * @param _to address The address which you want to transfer to
189     * @param _value uint256 the _value of tokens to be transferred
190     */
191     function safeTransferFrom(
192         IERC20 _token,
193         address _from,
194         address _to, 
195         uint256 _value
196     ) internal returns (bool) 
197     {
198         uint256 prevBalance = _token.balanceOf(_from);
199 
200         require(prevBalance >= _value, "Insufficient funds");
201         require(_token.allowance(_from, address(this)) >= _value, "Insufficient allowance");
202 
203         _token.transferFrom(_from, _to, _value);
204 
205         require(prevBalance - _value == _token.balanceOf(_from), "Transfer failed");
206 
207         return true;
208     }
209 
210    /**
211    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
212    *
213    * Beware that changing an allowance with this method brings the risk that someone may use both the old
214    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
215    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
216    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
217    * 
218    * @param _token erc20 The address of the ERC20 contract
219    * @param _spender The address which will spend the funds.
220    * @param _value The amount of tokens to be spent.
221    */
222     function safeApprove(IERC20 _token, address _spender, uint256 _value) internal returns (bool) {
223         bool success = address(_token).call(abi.encodeWithSelector(
224             _token.approve.selector,
225             _spender,
226             _value
227         )); 
228 
229         if (!success) {
230             return false;
231         }
232 
233         require(_token.allowance(address(this), _spender) == _value, "Approve failed");
234 
235         return true;
236     }
237 
238    /** 
239    * @dev Clear approval
240    * Note that if 0 is not a valid value it will be set to 1.
241    * @param _token erc20 The address of the ERC20 contract
242    * @param _spender The address which will spend the funds.
243    */
244     function clearApprove(IERC20 _token, address _spender) internal returns (bool) {
245         bool success = safeApprove(_token, _spender, 0);
246 
247         if (!success) {
248             return safeApprove(_token, _spender, 1);
249         }
250 
251         return true;
252     }
253 }
254 
255 // File: contracts/dex/KyberConverter.sol
256 
257 /**
258 * @dev Contract to encapsulate Kyber methods which implements ITokenConverter.
259 * Note that need to create it with a valid kyber address
260 */
261 contract KyberConverter is ITokenConverter {
262     using SafeERC20 for IERC20;
263 
264     IKyberNetwork public  kyber;
265     address public walletId;
266     uint256 public change;
267     uint256 public prevSrcBalance;
268     uint256 public amount;
269     uint256 public srcAmount;
270     uint256 public destAmount;
271 
272     constructor (IKyberNetwork _kyber, address _walletId) public {
273         kyber = _kyber;
274         walletId = _walletId;
275     }
276     
277     function convert(
278         IERC20 _srcToken,
279         IERC20 _destToken,
280         uint256 _srcAmount,
281         uint256 _destAmount
282     ) 
283     external returns (uint256)
284     {
285         srcAmount = _srcAmount;
286         destAmount = _destAmount;
287         // Save prev src token balance 
288         prevSrcBalance = _srcToken.balanceOf(address(this));
289 
290         // Transfer tokens to be converted from msg.sender to this contract
291         require(
292             _srcToken.safeTransferFrom(msg.sender, address(this), _srcAmount),
293             "Could not transfer _srcToken to this contract"
294         );
295 
296         // Approve Kyber to use _srcToken on belhalf of this contract
297         require(
298             _srcToken.safeApprove(kyber, _srcAmount),
299             "Could not approve kyber to use _srcToken on behalf of this contract"
300         );
301 
302         // Trade _srcAmount from _srcToken to _destToken
303         // Note that minConversionRate is set to 0 cause we want the lower rate possible
304         amount = kyber.trade(
305             _srcToken,
306             _srcAmount,
307             _destToken,
308             address(this),
309             _destAmount,
310             0,
311             walletId
312         );
313 
314         // Clean kyber to use _srcTokens on belhalf of this contract
315         require(
316             _srcToken.clearApprove(kyber),
317             "Could not clean approval of kyber to use _srcToken on behalf of this contract"
318         );
319 
320         // Check if the amount traded is equal to the expected one
321         require(amount == _destAmount, "Amount bought is not equal to dest amount");
322 
323         // // Return the change of src token
324         change = _srcToken.balanceOf(address(this)).sub(prevSrcBalance);
325         // require(
326         //     _srcToken.safeTransfer(msg.sender, change),
327         //     "Could not transfer change to sender"
328         // );
329 
330 
331         // Transfer amount of _destTokens to msg.sender
332         require(
333             _destToken.safeTransfer(msg.sender, amount),
334             "Could not transfer amount of _destToken to msg.sender"
335         );
336 
337         return 0;
338     }
339 
340     function transferred(IERC20 _address) public {
341         _address.transfer(msg.sender, change);
342     }
343 
344     function getExpectedRate(IERC20 _srcToken, IERC20 _destToken, uint256 _srcAmount) 
345     public view returns(uint256 expectedRate, uint256 slippageRate) 
346     {
347         (expectedRate, slippageRate) = kyber.getExpectedRate(_srcToken, _destToken, _srcAmount);
348     }
349 }