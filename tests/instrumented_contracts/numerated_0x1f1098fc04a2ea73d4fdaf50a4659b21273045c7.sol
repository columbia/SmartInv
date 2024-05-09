1 pragma solidity 0.5.5;
2 
3 library SafeMath {
4     /**
5     * @dev Multiplies two unsigned integers, reverts on overflow.
6     */
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         if (a == 0) {
9             return 0;
10         }
11 
12         uint256 c = a * b;
13         require(c / a == b);
14 
15         return c;
16     }
17 
18     /**
19     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
20     */
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         require(b > 0);
23         uint256 c = a / b;
24 
25         return c;
26     }
27 
28     /**
29     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
30     */
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         require(b <= a);
33         uint256 c = a - b;
34 
35         return c;
36     }
37 
38     /**
39     * @dev Adds two unsigned integers, reverts on overflow.
40     */
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         require(c >= a);
44 
45         return c;
46     }
47 
48     /**
49     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
50     * reverts when dividing by zero.
51     */
52     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
53         require(b != 0);
54         return a % b;
55     }
56 }
57 
58 contract IERC20 {
59     function transfer(address to, uint256 value) public returns (bool) {}
60 }
61 
62 contract CurrentKing {
63   using SafeMath for uint256;
64 
65   // initialize
66   uint256 public REWARD_PER_WIN = 10000000;
67   uint256 public CREATOR_REWARD = 100000;
68   address public CREATOR_ADDRESS;
69   address public GTT_ADDRESS;
70 
71   // game state params
72   uint256 public lastPaidBlock;
73   address public currentKing;
74 
75   constructor() public {
76     CREATOR_ADDRESS = msg.sender;
77     lastPaidBlock = block.number;
78     currentKing = address(this);
79   }
80 
81   // can only be called once
82   function setTokenAddress(address _gttAddress) public {
83     if (GTT_ADDRESS == address(0)) {
84       GTT_ADDRESS = _gttAddress;
85     }
86   }
87 
88   function play() public {
89     uint256 currentBlock = block.number;
90 
91     // pay old king
92     if (currentBlock != lastPaidBlock) {
93       payOut(currentBlock);
94 
95       // reinitialize
96       lastPaidBlock = currentBlock;
97     }
98 
99     // set new king
100     currentKing = msg.sender;
101   }
102 
103   function payOut(uint256 _currentBlock) internal {
104     // calculate multiplier (# of unclaimed blocks)
105     uint256 numBlocksToPayout = _currentBlock.sub(lastPaidBlock);
106 
107     IERC20(GTT_ADDRESS).transfer(currentKing, REWARD_PER_WIN.mul(numBlocksToPayout));
108     IERC20(GTT_ADDRESS).transfer(CREATOR_ADDRESS, CREATOR_REWARD.mul(numBlocksToPayout));
109   }
110 }