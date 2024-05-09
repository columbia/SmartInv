1 /**
2  * Copyright (c) 2019 blockimmo AG license@blockimmo.ch
3  * No license
4  */
5 
6 pragma solidity 0.5.4;
7 
8 library SafeMath {
9     /**
10      * @dev Multiplies two unsigned integers, reverts on overflow.
11      */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         uint256 c = a * b;
21         require(c / a == b);
22 
23         return c;
24     }
25 
26     /**
27      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
28      */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // Solidity only automatically asserts when dividing by 0
31         require(b > 0);
32         uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35         return c;
36     }
37 
38     /**
39      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40      */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b <= a);
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     /**
49      * @dev Adds two unsigned integers, reverts on overflow.
50      */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a);
54 
55         return c;
56     }
57 
58     /**
59      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
60      * reverts when dividing by zero.
61      */
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b != 0);
64         return a % b;
65     }
66 }
67 
68 interface IERC20 {
69     function transfer(address to, uint256 value) external returns (bool);
70 
71     function approve(address spender, uint256 value) external returns (bool);
72 
73     function transferFrom(address from, address to, uint256 value) external returns (bool);
74 
75     function totalSupply() external view returns (uint256);
76 
77     function balanceOf(address who) external view returns (uint256);
78 
79     function allowance(address owner, address spender) external view returns (uint256);
80 
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 library SafeERC20 {
87     using SafeMath for uint256;
88     using Address for address;
89 
90     function safeTransfer(IERC20 token, address to, uint256 value) internal {
91         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
92     }
93 
94     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
95         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
96     }
97 
98     function safeApprove(IERC20 token, address spender, uint256 value) internal {
99         // safeApprove should only be called when setting an initial allowance,
100         // or when resetting it to zero. To increase and decrease it, use
101         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
102         require((value == 0) || (token.allowance(address(this), spender) == 0));
103         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
104     }
105 
106     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
107         uint256 newAllowance = token.allowance(address(this), spender).add(value);
108         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
109     }
110 
111     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
112         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
113         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
114     }
115 
116     /**
117      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
118      * on the return value: the return value is optional (but if data is returned, it must equal true).
119      * @param token The token targeted by the call.
120      * @param data The call data (encoded using abi.encode or one of its variants).
121      */
122     function callOptionalReturn(IERC20 token, bytes memory data) private {
123         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
124         // we're implementing it ourselves.
125 
126         // A Solidity high level call has three parts:
127         //  1. The target address is checked to verify it contains contract code
128         //  2. The call itself is made, and success asserted
129         //  3. The return value is decoded, which in turn checks the size of the returned data.
130 
131         require(address(token).isContract());
132 
133         // solhint-disable-next-line avoid-low-level-calls
134         (bool success, bytes memory returndata) = address(token).call(data);
135         require(success);
136 
137         if (returndata.length > 0) { // Return data is optional
138             require(abi.decode(returndata, (bool)));
139         }
140     }
141 }
142 
143 library Address {
144     /**
145      * Returns whether the target address is a contract
146      * @dev This function will return false if invoked during the constructor of a contract,
147      * as the code is not actually created until after the constructor finishes.
148      * @param account address of the account to check
149      * @return whether the target address is a contract
150      */
151     function isContract(address account) internal view returns (bool) {
152         uint256 size;
153         // XXX Currently there is no better way to check if there is a contract in an address
154         // than to check the size of the code at that address.
155         // See https://ethereum.stackexchange.com/a/14016/36603
156         // for more details about how this works.
157         // TODO Check this again before the Serenity release, because all addresses will be
158         // contracts then.
159         // solhint-disable-next-line no-inline-assembly
160         assembly { size := extcodesize(account) }
161         return size > 0;
162     }
163 }
164 
165 contract ReentrancyGuard {
166     /// @dev counter to allow mutex lock with only one SSTORE operation
167     uint256 private _guardCounter;
168 
169     constructor () internal {
170         // The counter starts at one to prevent changing it from zero to a non-zero
171         // value, which is a more expensive operation.
172         _guardCounter = 1;
173     }
174 
175     /**
176      * @dev Prevents a contract from calling itself, directly or indirectly.
177      * Calling a `nonReentrant` function from another `nonReentrant`
178      * function is not supported. It is possible to prevent this from happening
179      * by making the `nonReentrant` function external, and make it call a
180      * `private` function that does the actual work.
181      */
182     modifier nonReentrant() {
183         _guardCounter += 1;
184         uint256 localCounter = _guardCounter;
185         _;
186         require(localCounter == _guardCounter);
187     }
188 }
189 
190 contract KyberNetworkProxyInterface {
191   function getExpectedRate(IERC20 src, IERC20 dest, uint256 srcQty) public view returns (uint256 expectedRate, uint256 slippageRate);
192   function trade(IERC20 src, uint256 srcAmount, IERC20 dest, address destAddress, uint256 maxDestAmount, uint256 minConversionRate, address walletId) public payable returns(uint256);
193 }
194 
195 contract LandRegistryProxyInterface {
196   function owner() public view returns (address);
197 }
198 
199 contract PaymentsLayer is ReentrancyGuard {
200   using SafeERC20 for IERC20;
201   using SafeMath for uint256;
202 
203   address public constant ETH_TOKEN_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
204   KyberNetworkProxyInterface public constant KYBER_NETWORK_PROXY = KyberNetworkProxyInterface(0x818E6FECD516Ecc3849DAf6845e3EC868087B755);
205   LandRegistryProxyInterface public constant LAND_REGISTRY_PROXY = LandRegistryProxyInterface(0xe72AD2A335AE18e6C7cdb6dAEB64b0330883CD56);  // 0x0f5Ea0A652E851678Ebf77B69484bFcD31F9459B;
206 
207   event PaymentForwarded(IERC20 indexed src, uint256 srcAmount, IERC20 indexed dest, address indexed destAddress, uint256 destAmount);
208 
209   function forwardPayment(IERC20 src, uint256 srcAmount, IERC20 dest, address destAddress, uint256 minConversionRate, uint256 minDestAmount, bytes memory encodedFunctionCall) public nonReentrant payable returns(uint256) {
210     if (address(src) != ETH_TOKEN_ADDRESS) {
211       require(msg.value == 0);
212       src.safeTransferFrom(msg.sender, address(this), srcAmount);
213       src.safeApprove(address(KYBER_NETWORK_PROXY), srcAmount);
214     }
215 
216     uint256 destAmount = KYBER_NETWORK_PROXY.trade.value((address(src) == ETH_TOKEN_ADDRESS) ? srcAmount : 0)(src, srcAmount, dest, address(this), ~uint256(0), minConversionRate, LAND_REGISTRY_PROXY.owner());
217     require(destAmount >= minDestAmount);
218     if (address(dest) != ETH_TOKEN_ADDRESS)
219       dest.safeApprove(destAddress, destAmount);
220 
221     (bool success, ) = destAddress.call.value((address(dest) == ETH_TOKEN_ADDRESS) ? destAmount : 0)(encodedFunctionCall);
222     require(success, "dest call failed");
223 
224     uint256 change = (address(dest) == ETH_TOKEN_ADDRESS) ? address(this).balance : dest.allowance(address(this), destAddress);
225     (change > 0 && address(dest) == ETH_TOKEN_ADDRESS) ? msg.sender.transfer(change) : dest.safeTransfer(msg.sender, change);
226 
227     emit PaymentForwarded(src, srcAmount, dest, destAddress, destAmount.sub(change));
228     return destAmount.sub(change);
229   }
230 }