1 pragma solidity 0.5.7;
2 pragma experimental ABIEncoderV2;
3 
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 
28 /**
29  * @title SafeMath
30  * @dev Unsigned math operations with safety checks that revert on error
31  */
32 library SafeMath {
33     /**
34     * @dev Multiplies two unsigned integers, reverts on overflow.
35     */
36     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
38         // benefit is lost if 'b' is also tested.
39         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
40         if (a == 0) {
41             return 0;
42         }
43 
44         uint256 c = a * b;
45         require(c / a == b, "SafeMath::mul: Integer overflow");
46 
47         return c;
48     }
49 
50     /**
51     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
52     */
53     function div(uint256 a, uint256 b) internal pure returns (uint256) {
54         // Solidity only automatically asserts when dividing by 0
55         require(b > 0, "SafeMath::div: Invalid divisor zero");
56         uint256 c = a / b;
57         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58 
59         return c;
60     }
61 
62     /**
63     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
64     */
65     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66         require(b <= a, "SafeMath::sub: Integer underflow");
67         uint256 c = a - b;
68 
69         return c;
70     }
71 
72     /**
73     * @dev Adds two unsigned integers, reverts on overflow.
74     */
75     function add(uint256 a, uint256 b) internal pure returns (uint256) {
76         uint256 c = a + b;
77         require(c >= a, "SafeMath::add: Integer overflow");
78 
79         return c;
80     }
81 
82     /**
83     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
84     * reverts when dividing by zero.
85     */
86     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
87         require(b != 0, "SafeMath::mod: Invalid divisor zero");
88         return a % b;
89     }
90 }
91 
92 
93 /**
94  * @title Faucet
95  * @dev Mine Humanity tokens into Uniswap.
96  */
97 contract Faucet {
98     using SafeMath for uint;
99 
100     uint public constant BLOCK_REWARD = 1e18;
101     uint public START_BLOCK = block.number;
102     uint public END_BLOCK = block.number + 5000000;
103 
104     IERC20 public humanity;
105     address public auction;
106 
107     uint public lastMined = block.number;
108 
109     constructor(IERC20 _humanity, address _auction) public {
110         humanity = _humanity;
111         auction = _auction;
112     }
113 
114     function mine() public {
115         uint rewardBlock = block.number < END_BLOCK ? block.number : END_BLOCK;
116         uint reward = rewardBlock.sub(lastMined).mul(BLOCK_REWARD);
117         humanity.transfer(auction, reward);
118         lastMined = block.number;
119     }
120 }