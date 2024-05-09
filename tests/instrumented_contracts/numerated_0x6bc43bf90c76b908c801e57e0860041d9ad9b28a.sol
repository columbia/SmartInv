1 pragma solidity ^0.5.7;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error.
6  */
7 library SafeMath {
8 
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13 
14         uint256 c = a * b;
15         require(c / a == b, "SafeMath: multiplication overflow");
16 
17         return c;
18     }
19 
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         require(b > 0, "SafeMath: division by zero");
22         uint256 c = a / b;
23 
24         return c;
25     }
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         require(b <= a, "SafeMath: subtraction overflow");
29         uint256 c = a - b;
30 
31         return c;
32     }
33 
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         require(c >= a, "SafeMath: addition overflow");
37 
38         return c;
39     }
40 
41     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b != 0, "SafeMath: modulo by zero");
43         return a % b;
44     }
45 }
46 
47 /**
48  * @title Ownable
49  * @dev The Ownable contract has an owner address, and provides basic authorization control
50  * functions, this simplifies the implementation of "user permissions".
51  */
52 contract Ownable {
53 
54     address internal _owner;
55 
56     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58     constructor(address initialOwner) internal {
59         _owner = initialOwner;
60         emit OwnershipTransferred(address(0), _owner);
61     }
62 
63     function owner() public view returns (address) {
64         return _owner;
65     }
66 
67     modifier onlyOwner() {
68         require(isOwner(), "Caller is not the owner");
69         _;
70     }
71 
72     function isOwner() public view returns (bool) {
73         return msg.sender == _owner;
74     }
75 
76     function renounceOwnership() public onlyOwner {
77         emit OwnershipTransferred(_owner, address(0));
78         _owner = address(0);
79     }
80 
81     function transferOwnership(address newOwner) public onlyOwner {
82         require(newOwner != address(0), "New owner is the zero address");
83         emit OwnershipTransferred(_owner, newOwner);
84         _owner = newOwner;
85     }
86 
87 }
88 
89 /**
90  * @title ERC20 interface
91  * @dev see https://eips.ethereum.org/EIPS/eip-20
92  */
93 interface IERC20 {
94     function transfer(address to, uint256 value) external returns (bool);
95     function balanceOf(address who) external view returns (uint256);
96     function burnFrom(address account, uint256 amount) external;
97 }
98 
99 /**
100  * @title SDU Exchange contract
101  * @author https://grox.solutions
102  */
103 contract SDUExchange is Ownable {
104     using SafeMath for uint256;
105 
106     IERC20 public SDUM;
107     IERC20 public SDU;
108 
109     mapping (address => User) _users;
110 
111     struct User {
112         uint256 deposit;
113         uint256 checkpoint;
114         uint256 reserved;
115     }
116 
117     event Exchanged(address user, uint256 amount);
118     event Withdrawn(address user, uint256 amount);
119 
120     constructor(address SDUMAddr, address SDUAddr, address initialOwner) public Ownable(initialOwner) {
121         require(SDUMAddr != address(0) && SDUAddr != address(0));
122 
123         SDUM = IERC20(SDUMAddr);
124         SDU = IERC20(SDUAddr);
125     }
126 
127     function receiveApproval(address from, uint256 amount, address token, bytes calldata extraData) external {
128         require(token == address(SDUM));
129         exchange(from, amount);
130     }
131 
132     function exchange(address from, uint256 amount) public {
133         SDUM.burnFrom(from, amount);
134 
135         SDU.transfer(from, amount);
136 
137         if (_users[from].deposit != 0) {
138             _users[from].reserved = getDividends(msg.sender);
139         }
140 
141         _users[from].checkpoint = block.timestamp;
142         _users[from].deposit = _users[from].deposit.add(amount);
143 
144         emit Exchanged(from, amount);
145     }
146 
147     function() external payable {
148         withdraw();
149     }
150 
151     function withdraw() public {
152         uint256 payout = getDividends(msg.sender);
153 
154         if (_users[msg.sender].reserved != 0) {
155             payout = payout.add(_users[msg.sender].reserved);
156             _users[msg.sender].reserved = 0;
157         }
158 
159         _users[msg.sender].checkpoint = block.timestamp;
160         SDU.transfer(msg.sender, payout);
161 
162         emit Withdrawn(msg.sender, payout);
163     }
164 
165     function getDeposit(address addr) public view returns(uint256) {
166         return _users[addr].deposit;
167     }
168 
169     function getDividends(address addr) public view returns(uint256) {
170         return (_users[addr].deposit.div(10)).mul(block.timestamp.sub(_users[addr].checkpoint)).div(30 days);
171     }
172 
173     function withdrawERC20(address ERC20Token, address recipient) external onlyOwner {
174 
175         uint256 amount = IERC20(ERC20Token).balanceOf(address(this));
176         IERC20(ERC20Token).transfer(recipient, amount);
177 
178     }
179 
180 }