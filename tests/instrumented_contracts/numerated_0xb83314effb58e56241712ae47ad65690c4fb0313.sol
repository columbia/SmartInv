1 pragma solidity ^0.4.24;
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
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (_a == 0) {
19       return 0;
20     }
21 
22     c = _a * _b;
23     assert(c / _a == _b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34     return _a / _b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     return _a - _b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
49     c = _a + _b;
50     assert(c >= _a);
51     return c;
52   }
53 }
54 
55 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    * @notice Renouncing to ownership will leave the contract without an owner.
92    * It will not be possible to call the functions with the `onlyOwner`
93    * modifier anymore.
94    */
95   function renounceOwnership() public onlyOwner {
96     emit OwnershipRenounced(owner);
97     owner = address(0);
98   }
99 
100   /**
101    * @dev Allows the current owner to transfer control of the contract to a newOwner.
102    * @param _newOwner The address to transfer ownership to.
103    */
104   function transferOwnership(address _newOwner) public onlyOwner {
105     _transferOwnership(_newOwner);
106   }
107 
108   /**
109    * @dev Transfers control of the contract to a newOwner.
110    * @param _newOwner The address to transfer ownership to.
111    */
112   function _transferOwnership(address _newOwner) internal {
113     require(_newOwner != address(0));
114     emit OwnershipTransferred(owner, _newOwner);
115     owner = _newOwner;
116   }
117 }
118 
119 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
120 
121 /**
122  * @title ERC20Basic
123  * @dev Simpler version of ERC20 interface
124  * See https://github.com/ethereum/EIPs/issues/179
125  */
126 contract ERC20Basic {
127   function totalSupply() public view returns (uint256);
128   function balanceOf(address _who) public view returns (uint256);
129   function transfer(address _to, uint256 _value) public returns (bool);
130   event Transfer(address indexed from, address indexed to, uint256 value);
131 }
132 
133 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
134 
135 /**
136  * @title ERC20 interface
137  * @dev see https://github.com/ethereum/EIPs/issues/20
138  */
139 contract ERC20 is ERC20Basic {
140   function allowance(address _owner, address _spender)
141     public view returns (uint256);
142 
143   function transferFrom(address _from, address _to, uint256 _value)
144     public returns (bool);
145 
146   function approve(address _spender, uint256 _value) public returns (bool);
147   event Approval(
148     address indexed owner,
149     address indexed spender,
150     uint256 value
151   );
152 }
153 
154 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
155 
156 /**
157  * @title SafeERC20
158  * @dev Wrappers around ERC20 operations that throw on failure.
159  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
160  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
161  */
162 library SafeERC20 {
163   function safeTransfer(
164     ERC20Basic _token,
165     address _to,
166     uint256 _value
167   )
168     internal
169   {
170     require(_token.transfer(_to, _value));
171   }
172 
173   function safeTransferFrom(
174     ERC20 _token,
175     address _from,
176     address _to,
177     uint256 _value
178   )
179     internal
180   {
181     require(_token.transferFrom(_from, _to, _value));
182   }
183 
184   function safeApprove(
185     ERC20 _token,
186     address _spender,
187     uint256 _value
188   )
189     internal
190   {
191     require(_token.approve(_spender, _value));
192   }
193 }
194 
195 // File: contracts/Collateral.sol
196 
197 contract Collateral is Ownable {
198     // 抵押品合约
199 
200     using SafeMath for SafeMath;
201     using SafeERC20 for ERC20;
202 
203     address public BondAddress;
204     address public DepositAddress; // 抵押品充值，退还地址
205     address public VoceanAddress;  // 违约时，扣除部分转入 VoceanAddress
206 
207     uint public DeductionRate;  // 0~100  退回部分抵押物时计算给VoceanAddress部分的比例
208     uint public Total = 100;
209 
210     uint public AllowWithdrawAmount;
211 
212     ERC20 public BixToken;
213 
214     event SetBondAddress(address bond_address);
215     event RefundAllCollateral(uint amount);
216     event RefundPartCollateral(address addr, uint amount);
217     event PayByBondContract(address addr, uint amount);
218     event SetAllowWithdrawAmount(uint amount);
219     event WithdrawBix(uint amount);
220 
221     constructor(address _DepositAddress, ERC20 _BixToken, address _VoceanAddress, uint _DeductionRate) public{
222         require(_DeductionRate < 100);
223         DepositAddress = _DepositAddress;
224         BixToken = _BixToken;
225         VoceanAddress = _VoceanAddress;
226         DeductionRate = _DeductionRate;
227 
228     }
229 
230     // 设置 债券合约地址
231     function setBondAddress(address _BondAddress) onlyOwner public {
232         BondAddress = _BondAddress;
233         emit SetBondAddress(BondAddress);
234     }
235 
236 
237     // 退回全部抵押物
238     // 只允许 债券合约地址 调用
239     function refundAllCollateral() public {
240         require(msg.sender == BondAddress);
241         uint current_bix = BixToken.balanceOf(address(this));
242 
243         if (current_bix > 0) {
244             BixToken.transfer(DepositAddress, current_bix);
245 
246             emit RefundAllCollateral(current_bix);
247         }
248 
249 
250     }
251 
252     // 退回部分抵押物
253     // 另一部分转给 VoceanAddress
254     function refundPartCollateral() public {
255 
256         require(msg.sender == BondAddress);
257 
258         uint current_bix = BixToken.balanceOf(address(this));
259 
260         if (current_bix > 0) {
261             // 计算各自数量
262             uint refund_deposit_addr_amount = get_refund_deposit_addr_amount(current_bix);
263             uint refund_vocean_addr_amount = get_refund_vocean_addr_amount(current_bix);
264 
265             // 退给 充值地址
266             BixToken.transfer(DepositAddress, refund_deposit_addr_amount);
267             emit RefundPartCollateral(DepositAddress, refund_deposit_addr_amount);
268 
269             // 退给 VoceanAddress
270             BixToken.transfer(VoceanAddress, refund_vocean_addr_amount);
271             emit RefundPartCollateral(VoceanAddress, refund_vocean_addr_amount);
272         }
273 
274 
275     }
276 
277     function get_refund_deposit_addr_amount(uint current_bix) internal view returns (uint){
278         return SafeMath.div(SafeMath.mul(current_bix, SafeMath.sub(Total, DeductionRate)), Total);
279     }
280 
281     function get_refund_vocean_addr_amount(uint current_bix) internal view returns (uint){
282         return SafeMath.div(SafeMath.mul(current_bix, DeductionRate), Total);
283     }
284 
285     // 债券合约使用抵押品赔付
286     function pay_by_bond_contract(address addr, uint amount) public {
287         require(msg.sender == BondAddress);
288         BixToken.transfer(addr, amount);
289         emit PayByBondContract(addr, amount);
290 
291     }
292 
293     // 设置 允许发行方提取的数量
294     function set_allow_withdraw_amount(uint amount) public {
295         require(msg.sender == BondAddress);
296         AllowWithdrawAmount = amount;
297         emit SetAllowWithdrawAmount(amount);
298     }
299 
300     // 允许发行方提取 BIX
301     function withdraw_bix() public {
302         require(msg.sender == DepositAddress);
303         require(AllowWithdrawAmount > 0);
304         BixToken.transfer(msg.sender, AllowWithdrawAmount);
305         // 提取完后 将额度设置为 0
306         AllowWithdrawAmount = 0;
307         emit WithdrawBix(AllowWithdrawAmount);
308     }
309 
310 }