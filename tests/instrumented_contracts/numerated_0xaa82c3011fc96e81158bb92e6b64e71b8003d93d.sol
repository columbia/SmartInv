1 /**
2  * Copyright (c) 2019 blockimmo AG license@blockimmo.ch
3  * Non-Profit Open Software License 3.0 (NPOSL-3.0)
4  * https://opensource.org/licenses/NPOSL-3.0
5  */
6 
7 pragma solidity ^0.5.2;
8 
9 /**
10  * @title SafeMath
11  * @dev Unsigned math operations with safety checks that revert on error
12  */
13 library SafeMath {
14     /**
15     * @dev Multiplies two unsigned integers, reverts on overflow.
16     */
17     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
19         // benefit is lost if 'b' is also tested.
20         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
21         if (a == 0) {
22             return 0;
23         }
24 
25         uint256 c = a * b;
26         require(c / a == b);
27 
28         return c;
29     }
30 
31     /**
32     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
33     */
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         // Solidity only automatically asserts when dividing by 0
36         require(b > 0);
37         uint256 c = a / b;
38         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39 
40         return c;
41     }
42 
43     /**
44     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
45     */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         require(b <= a);
48         uint256 c = a - b;
49 
50         return c;
51     }
52 
53     /**
54     * @dev Adds two unsigned integers, reverts on overflow.
55     */
56     function add(uint256 a, uint256 b) internal pure returns (uint256) {
57         uint256 c = a + b;
58         require(c >= a);
59 
60         return c;
61     }
62 
63     /**
64     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
65     * reverts when dividing by zero.
66     */
67     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
68         require(b != 0);
69         return a % b;
70     }
71 }
72 
73 /**
74  * @title ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/20
76  */
77 interface IERC20 {
78     function transfer(address to, uint256 value) external returns (bool);
79 
80     function approve(address spender, uint256 value) external returns (bool);
81 
82     function transferFrom(address from, address to, uint256 value) external returns (bool);
83 
84     function totalSupply() external view returns (uint256);
85 
86     function balanceOf(address who) external view returns (uint256);
87 
88     function allowance(address owner, address spender) external view returns (uint256);
89 
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 contract KyberNetworkProxyInterface {
96   function swapEtherToToken(IERC20 token, uint minConversionRate) public payable returns(uint);
97 }
98 
99 contract PaymentsLayer {
100   using SafeMath for uint256;
101 
102   address public constant DAI_ADDRESS = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;  // 0x9Ad61E35f8309aF944136283157FABCc5AD371E5;
103   IERC20 public dai = IERC20(DAI_ADDRESS);
104 
105   address public constant ETH_TOKEN_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
106   IERC20 public eth = IERC20(ETH_TOKEN_ADDRESS);
107 
108   event PaymentForwarded(address indexed from, address indexed to, uint256 amountEth, uint256 amountDai, bytes encodedFunctionCall);
109 
110   function forwardEth(KyberNetworkProxyInterface _kyberNetworkProxy, uint256 _minimumRate, address _destinationAddress, bytes memory _encodedFunctionCall) public payable {
111     require(msg.value > 0 && _minimumRate > 0 && _destinationAddress != address(0), "invalid parameter(s)");
112 
113     uint256 amountDai = _kyberNetworkProxy.swapEtherToToken.value(msg.value)(dai, _minimumRate);
114     require(amountDai >= msg.value.mul(_minimumRate), "_kyberNetworkProxy failed");
115 
116     require(dai.allowance(address(this), _destinationAddress) == 0, "non-zero initial destination allowance");
117     require(dai.approve(_destinationAddress, amountDai), "approving destination failed");
118 
119     (bool success, ) = _destinationAddress.call(_encodedFunctionCall);
120     require(success, "destination call failed");
121     require(dai.allowance(address(this), _destinationAddress) == 0, "allowance not fully consumed by destination");
122 
123     emit PaymentForwarded(msg.sender, _destinationAddress, msg.value, amountDai, _encodedFunctionCall);
124   }
125 }