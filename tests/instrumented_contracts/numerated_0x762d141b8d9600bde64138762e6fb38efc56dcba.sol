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
93 contract IHumanity {
94     function mint(address account, uint256 value) public;
95     function totalSupply() public view returns (uint256);
96 }
97 
98 
99 /**
100  * @title HumanityRegistry
101  * @dev A list of Ethereum addresses that belong to unique humans as determined by Humanity governance.
102  */
103 contract HumanityRegistry {
104 
105     mapping (address => bool) public humans;
106 
107     IHumanity public humanity;
108     address public governance;
109 
110     constructor(IHumanity _humanity, address _governance) public {
111         humanity = _humanity;
112         governance = _governance;
113     }
114 
115     function add(address who) public {
116         require(msg.sender == governance, "HumanityRegistry::add: Only governance can add an identity");
117         require(humans[who] == false, "HumanityRegistry::add: Address is already on the registry");
118 
119         _reward(who);
120         humans[who] = true;
121     }
122 
123     function remove(address who) public {
124         require(
125             msg.sender == governance || msg.sender == who,
126             "HumanityRegistry::remove: Only governance or the identity owner can remove an identity"
127         );
128         delete humans[who];
129     }
130 
131     function isHuman(address who) public view returns (bool) {
132         return humans[who];
133     }
134 
135     function _reward(address who) internal {
136         uint totalSupply = humanity.totalSupply();
137 
138         if (totalSupply < 28000000e18) {
139             humanity.mint(who, 30000e18); // 1 - 100
140         } else if (totalSupply < 46000000e18) {
141             humanity.mint(who, 20000e18); // 101 - 1000
142         } else if (totalSupply < 100000000e18) {
143             humanity.mint(who, 6000e18); // 1001 - 10000
144         }
145 
146     }
147 
148 }
149 
150 
151 /**
152  * @title UniversalBasicIncome
153  * @dev Dai that can be claimed by humans on the Human Registry.
154  */
155 contract UniversalBasicIncome {
156     using SafeMath for uint;
157 
158     HumanityRegistry public registry;
159     IERC20 public dai;
160 
161     uint public constant MONTHLY_INCOME = 1e18; // 1 Dai
162     uint public constant INCOME_PER_SECOND = MONTHLY_INCOME / 30 days;
163 
164     mapping (address => uint) public claimTimes;
165 
166     constructor(HumanityRegistry _registry, IERC20 _dai) public {
167         registry = _registry;
168         dai = _dai;
169     }
170 
171     function claim() public {
172         require(registry.isHuman(msg.sender), "UniversalBasicIncome::claim: You must be on the Humanity registry to claim income");
173 
174         uint income;
175         uint time = block.timestamp;
176 
177         // If claiming for the first time, send 1 month of UBI
178         if (claimTimes[msg.sender] == 0) {
179             income = MONTHLY_INCOME;
180         } else {
181             income = time.sub(claimTimes[msg.sender]).mul(INCOME_PER_SECOND);
182         }
183 
184         uint balance = dai.balanceOf(address(this));
185         // If not enough Dai reserves, send the remaining balance
186         uint actualIncome = balance < income ? balance : income;
187 
188         dai.transfer(msg.sender, actualIncome);
189         claimTimes[msg.sender] = time;
190     }
191 
192 }