1 pragma solidity 0.5.4;
2 
3 library SafeMath {
4     /**
5      * @dev Multiplies two unsigned integers, reverts on overflow.
6      */
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
9         // benefit is lost if 'b' is also tested.
10         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
11         if (a == 0) {
12             return 0;
13         }
14 
15         uint256 c = a * b;
16         require(c / a == b);
17 
18         return c;
19     }
20 
21     /**
22      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
23      */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // Solidity only automatically asserts when dividing by 0
26         require(b > 0);
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 
30         return c;
31     }
32 
33     /**
34      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35      */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b <= a);
38         uint256 c = a - b;
39 
40         return c;
41     }
42 
43     /**
44      * @dev Adds two unsigned integers, reverts on overflow.
45      */
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a);
49 
50         return c;
51     }
52 
53     /**
54      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
55      * reverts when dividing by zero.
56      */
57     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58         require(b != 0);
59         return a % b;
60     }
61 }
62 
63 interface IERC20 {
64     function transfer(address to, uint256 value) external returns (bool);
65 
66     function approve(address spender, uint256 value) external returns (bool);
67 
68     function transferFrom(address from, address to, uint256 value) external returns (bool);
69 
70     function totalSupply() external view returns (uint256);
71 
72     function balanceOf(address who) external view returns (uint256);
73 
74     function allowance(address owner, address spender) external view returns (uint256);
75 
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 library SafeERC20 {
82     using SafeMath for uint256;
83     using Address for address;
84 
85     function safeTransfer(IERC20 token, address to, uint256 value) internal {
86         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
87     }
88 
89     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
90         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
91     }
92 
93     function safeApprove(IERC20 token, address spender, uint256 value) internal {
94         // safeApprove should only be called when setting an initial allowance,
95         // or when resetting it to zero. To increase and decrease it, use
96         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
97         require((value == 0) || (token.allowance(address(this), spender) == 0));
98         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
99     }
100 
101     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
102         uint256 newAllowance = token.allowance(address(this), spender).add(value);
103         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
104     }
105 
106     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
107         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
108         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
109     }
110 
111     /**
112      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
113      * on the return value: the return value is optional (but if data is returned, it must equal true).
114      * @param token The token targeted by the call.
115      * @param data The call data (encoded using abi.encode or one of its variants).
116      */
117     function callOptionalReturn(IERC20 token, bytes memory data) private {
118         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
119         // we're implementing it ourselves.
120 
121         // A Solidity high level call has three parts:
122         //  1. The target address is checked to verify it contains contract code
123         //  2. The call itself is made, and success asserted
124         //  3. The return value is decoded, which in turn checks the size of the returned data.
125 
126         require(address(token).isContract());
127 
128         // solhint-disable-next-line avoid-low-level-calls
129         (bool success, bytes memory returndata) = address(token).call(data);
130         require(success);
131 
132         if (returndata.length > 0) { // Return data is optional
133             require(abi.decode(returndata, (bool)));
134         }
135     }
136 }
137 
138 library Address {
139     /**
140      * Returns whether the target address is a contract
141      * @dev This function will return false if invoked during the constructor of a contract,
142      * as the code is not actually created until after the constructor finishes.
143      * @param account address of the account to check
144      * @return whether the target address is a contract
145      */
146     function isContract(address account) internal view returns (bool) {
147         uint256 size;
148         // XXX Currently there is no better way to check if there is a contract in an address
149         // than to check the size of the code at that address.
150         // See https://ethereum.stackexchange.com/a/14016/36603
151         // for more details about how this works.
152         // TODO Check this again before the Serenity release, because all addresses will be
153         // contracts then.
154         // solhint-disable-next-line no-inline-assembly
155         assembly { size := extcodesize(account) }
156         return size > 0;
157     }
158 }
159 
160 contract ReentrancyGuard {
161     /// @dev counter to allow mutex lock with only one SSTORE operation
162     uint256 private _guardCounter;
163 
164     constructor () internal {
165         // The counter starts at one to prevent changing it from zero to a non-zero
166         // value, which is a more expensive operation.
167         _guardCounter = 1;
168     }
169 
170     /**
171      * @dev Prevents a contract from calling itself, directly or indirectly.
172      * Calling a `nonReentrant` function from another `nonReentrant`
173      * function is not supported. It is possible to prevent this from happening
174      * by making the `nonReentrant` function external, and make it call a
175      * `private` function that does the actual work.
176      */
177     modifier nonReentrant() {
178         _guardCounter += 1;
179         uint256 localCounter = _guardCounter;
180         _;
181         require(localCounter == _guardCounter);
182     }
183 }
184 
185 contract KyberNetworkProxyInterface {
186   function getExpectedRate(IERC20 src, IERC20 dest, uint256 srcQty) public view returns (uint256 expectedRate, uint256 slippageRate);
187   function trade(IERC20 src, uint256 srcAmount, IERC20 dest, address destAddress, uint256 maxDestAmount, uint256 minConversionRate, address walletId) public payable returns(uint256);
188 }
189 
190 contract LandRegistryProxyInterface {
191   function owner() public view returns (address);
192 }
193 
194 contract PaymentsLayer is ReentrancyGuard {
195   using SafeERC20 for IERC20;
196   using SafeMath for uint256;
197 
198   address public constant ETH_TOKEN_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
199   KyberNetworkProxyInterface public constant KYBER_NETWORK_PROXY = KyberNetworkProxyInterface(0x818E6FECD516Ecc3849DAf6845e3EC868087B755);
200   LandRegistryProxyInterface public constant LAND_REGISTRY_PROXY = LandRegistryProxyInterface(0xe72AD2A335AE18e6C7cdb6dAEB64b0330883CD56);  // 0x0f5Ea0A652E851678Ebf77B69484bFcD31F9459B;
201 
202   event PaymentForwarded(IERC20 indexed src, uint256 srcAmount, IERC20 indexed dest, address indexed destAddress, uint256 destAmount);
203 
204   function forwardPayment(IERC20 src, uint256 srcAmount, IERC20 dest, address destAddress, uint256 minConversionRate, uint256 minDestAmount, bytes memory encodedFunctionCall) public nonReentrant payable returns(uint256) {
205     if (address(src) != ETH_TOKEN_ADDRESS) {
206       require(msg.value == 0);
207       src.safeTransferFrom(msg.sender, address(this), srcAmount);
208       src.safeApprove(address(KYBER_NETWORK_PROXY), srcAmount);
209     }
210 
211     uint256 destAmount = KYBER_NETWORK_PROXY.trade.value((address(src) == ETH_TOKEN_ADDRESS) ? srcAmount : 0)(src, srcAmount, dest, address(this), ~uint256(0), minConversionRate, LAND_REGISTRY_PROXY.owner());
212     require(destAmount >= minDestAmount);
213     if (address(dest) != ETH_TOKEN_ADDRESS)
214       dest.safeApprove(destAddress, destAmount);
215 
216     (bool success, ) = destAddress.call.value((address(dest) == ETH_TOKEN_ADDRESS) ? destAmount : 0)(encodedFunctionCall);
217     require(success, "dest call failed");
218 
219     emit PaymentForwarded(src, srcAmount, dest, destAddress, destAmount);
220     return destAmount;
221   }
222 }