1 /**
2  * Copyright (c) 2019 STX AG license@stx.swiss
3  * No license
4  */
5 
6 pragma solidity 0.5.3;
7 
8 /**
9  * @title ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/20
11  */
12 interface IERC20 {
13     function transfer(address to, uint256 value) external returns (bool);
14 
15     function approve(address spender, uint256 value) external returns (bool);
16 
17     function transferFrom(address from, address to, uint256 value) external returns (bool);
18 
19     function totalSupply() external view returns (uint256);
20 
21     function balanceOf(address who) external view returns (uint256);
22 
23     function allowance(address owner, address spender) external view returns (uint256);
24 
25     event Transfer(address indexed from, address indexed to, uint256 value);
26 
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 /**
31  * @title SafeMath
32  * @dev Unsigned math operations with safety checks that revert on error
33  */
34 library SafeMath {
35     /**
36     * @dev Multiplies two unsigned integers, reverts on overflow.
37     */
38     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
40         // benefit is lost if 'b' is also tested.
41         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
42         if (a == 0) {
43             return 0;
44         }
45 
46         uint256 c = a * b;
47         require(c / a == b);
48 
49         return c;
50     }
51 
52     /**
53     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
54     */
55     function div(uint256 a, uint256 b) internal pure returns (uint256) {
56         // Solidity only automatically asserts when dividing by 0
57         require(b > 0);
58         uint256 c = a / b;
59         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60 
61         return c;
62     }
63 
64     /**
65     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
66     */
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         require(b <= a);
69         uint256 c = a - b;
70 
71         return c;
72     }
73 
74     /**
75     * @dev Adds two unsigned integers, reverts on overflow.
76     */
77     function add(uint256 a, uint256 b) internal pure returns (uint256) {
78         uint256 c = a + b;
79         require(c >= a);
80 
81         return c;
82     }
83 
84     /**
85     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
86     * reverts when dividing by zero.
87     */
88     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
89         require(b != 0);
90         return a % b;
91     }
92 }
93 
94 /**
95  * @title SafeERC20
96  * @dev Wrappers around ERC20 operations that throw on failure.
97  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
98  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
99  */
100 library SafeERC20 {
101     using SafeMath for uint256;
102 
103     function safeTransfer(IERC20 token, address to, uint256 value) internal {
104         require(token.transfer(to, value));
105     }
106 
107     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
108         require(token.transferFrom(from, to, value));
109     }
110 
111     function safeApprove(IERC20 token, address spender, uint256 value) internal {
112         // safeApprove should only be called when setting an initial allowance,
113         // or when resetting it to zero. To increase and decrease it, use
114         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
115         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
116         require(token.approve(spender, value));
117     }
118 
119     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
120         uint256 newAllowance = token.allowance(address(this), spender).add(value);
121         require(token.approve(spender, newAllowance));
122     }
123 
124     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
125         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
126         require(token.approve(spender, newAllowance));
127     }
128 }
129 
130 contract KyberNetworkProxyInterface {
131   function swapEtherToToken(IERC20 token, uint minConversionRate) public payable returns (uint);
132   function swapTokenToToken(IERC20 src, uint srcAmount, IERC20 dest, uint minConversionRate) public returns (uint);
133 }
134 
135 contract PaymentsLayer {
136   using SafeERC20 for IERC20;
137   using SafeMath for uint256;
138 
139   address public constant DAI_ADDRESS = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;  // 0x9Ad61E35f8309aF944136283157FABCc5AD371E5;
140   IERC20 public dai = IERC20(DAI_ADDRESS);
141 
142   address public constant ETH_TOKEN_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
143 
144   event PaymentForwarded(address indexed from, address indexed to, address indexed srcToken, uint256 amountDai, uint256 amountSrc, uint256 changeDai, bytes encodedFunctionCall);
145 
146   function forwardEth(KyberNetworkProxyInterface _kyberNetworkProxy, IERC20 _srcToken, uint256 _minimumRate, address _destinationAddress, bytes memory _encodedFunctionCall) public payable {
147     require(address(_srcToken) != address(0) && _minimumRate > 0 && _destinationAddress != address(0), "invalid parameter(s)");
148 
149     uint256 srcQuantity = address(_srcToken) == ETH_TOKEN_ADDRESS ? msg.value : _srcToken.allowance(msg.sender, address(this));
150 
151     if (address(_srcToken) != ETH_TOKEN_ADDRESS) {
152       _srcToken.safeTransferFrom(msg.sender, address(this), srcQuantity);
153 
154       require(_srcToken.allowance(address(this), address(_kyberNetworkProxy)) == 0, "non-zero initial _kyberNetworkProxy allowance");
155       require(_srcToken.approve(address(_kyberNetworkProxy), srcQuantity), "approving _kyberNetworkProxy failed");
156     }
157 
158     uint256 amountDai = address(_srcToken) == ETH_TOKEN_ADDRESS ? _kyberNetworkProxy.swapEtherToToken.value(srcQuantity)(dai, _minimumRate) : _kyberNetworkProxy.swapTokenToToken(_srcToken, srcQuantity, dai, _minimumRate);
159     require(amountDai >= srcQuantity.mul(_minimumRate).div(1e18), "_kyberNetworkProxy failed");
160 
161     require(dai.allowance(address(this), _destinationAddress) == 0, "non-zero initial destination allowance");
162     require(dai.approve(_destinationAddress, amountDai), "approving destination failed");
163 
164     (bool success, ) = _destinationAddress.call(_encodedFunctionCall);
165     require(success, "destination call failed");
166 
167     uint256 changeDai = dai.allowance(address(this), _destinationAddress);
168     if (changeDai > 0) {
169       dai.safeTransfer(msg.sender, changeDai);
170       require(dai.approve(_destinationAddress, 0), "un-approving destination failed");
171     }
172 
173     emit PaymentForwarded(msg.sender, _destinationAddress, address(_srcToken), amountDai.sub(changeDai), srcQuantity, changeDai, _encodedFunctionCall);
174   }
175 }