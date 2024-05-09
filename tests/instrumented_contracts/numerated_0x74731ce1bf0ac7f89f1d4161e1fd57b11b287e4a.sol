1 // The version of the compiler.
2 pragma solidity ^0.4.24;
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11     /**
12     * @dev Multiplies two numbers, reverts on overflow.
13     */
14     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
15         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16         // benefit is lost if 'b' is also tested.
17         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18         if (_a == 0) {
19             return 0;
20         }
21 
22         uint256 c = _a * _b;
23         require(c / _a == _b);
24 
25         return c;
26     }
27 
28     /**
29     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30     */
31     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
32         require(_b > 0); // Solidity only automatically asserts when dividing by 0
33         uint256 c = _a / _b;
34         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
43         require(_b <= _a);
44         uint256 c = _a - _b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two numbers, reverts on overflow.
51     */
52     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
53         uint256 c = _a + _b;
54         require(c >= _a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 /**
70  * @title ETH_Silver
71  * @dev The main contract of the project.
72  */
73 contract ETH_Silver_White {
74 
75     // Using SafeMath for safe calculations.
76     using SafeMath for uint;
77 
78     // A variable for address of the owner.
79     address owner;
80 
81     // A variable to store deposits of investors.
82     mapping (address => uint) deposit;
83     // A variable to store amount of withdrawn money of investors.
84     mapping (address => uint) withdrawn;
85     // A variable to store reference point to count available money to withdraw.
86     mapping (address => uint) lastTimeWithdraw;
87 
88     // A function to transfer ownership of the contract (available only for the owner).
89     function transferOwnership(address _newOwner) external {
90         require(msg.sender == owner);
91         require(_newOwner != address(0));
92         owner = _newOwner;
93     }
94 
95     // A function to get key info for investors.
96     function getInfo() public view returns(uint Deposit, uint Withdrawn, uint AmountToWithdraw) {
97         // 1) Amount of invested money;
98         Deposit = deposit[msg.sender];
99         // 2) Amount of withdrawn money;
100         Withdrawn = withdrawn[msg.sender];
101         // 3) Amount of money which is available to withdraw;
102         // Formula without SafeMath: ((Current Time - Reference Point) - ((Current Time - Reference Point) % 1 day)) * (Deposit * 3% / 100%) / 1 day
103         AmountToWithdraw = (block.timestamp.sub(lastTimeWithdraw[msg.sender]).sub((block.timestamp.sub(lastTimeWithdraw[msg.sender])).mod(1 days))).mul(deposit[msg.sender].mul(3).div(100)).div(1 days);
104     }
105 
106     // A constructor function for the contract. Being used once at the time as contract is deployed and simply set the owner of the contract.
107     constructor() public {
108         owner = msg.sender;
109     }
110 
111     // A "fallback" function. It is automatically being called when anybody sends money to the contract. Function simply calls the "invest" function.
112     function() external payable {
113         invest();
114     }
115 
116     // A function which accepts money of investors.
117     function invest() public payable {
118         // Requires amount of money to be more than 0.01 ETH. If it is less, automatically reverts the whole function.
119         require(msg.value > 10000000000000000);
120         // Transfers a fee to the owner of the contract. The fee is 20% of the deposit (or Deposit / 5)
121         owner.transfer(msg.value.div(4));
122         // The special algorithm for investors who increase their deposits:
123         if (deposit[msg.sender] > 0) {
124             // Amount of money which is available to withdraw;
125             // Formula without SafeMath: ((Current Time - Reference Point) - ((Current Time - Reference Point) % 1 day)) * (Deposit * 3% / 100%) / 1 day
126             uint amountToWithdraw = (block.timestamp.sub(lastTimeWithdraw[msg.sender]).sub((block.timestamp.sub(lastTimeWithdraw[msg.sender])).mod(1 days))).mul(deposit[msg.sender].mul(3).div(100)).div(1 days);
127             // The additional algorithm for investors who need to withdraw available dividends:
128             if (amountToWithdraw != 0) {
129                 // Increasing amount withdrawn by an investor.
130                 withdrawn[msg.sender] = withdrawn[msg.sender].add(amountToWithdraw);
131                 // Transferring available dividends to an investor.
132                 msg.sender.transfer(amountToWithdraw);
133             }
134             // Setting the reference point to the current time.
135             lastTimeWithdraw[msg.sender] = block.timestamp;
136             // Increasing of the deposit of an investor.
137             deposit[msg.sender] = deposit[msg.sender].add(msg.value);
138             // End of the function for investors who increases their deposits.
139             return;
140         }
141         // The algorithm for new investors:
142         // Setting the reference point to the current time.
143         lastTimeWithdraw[msg.sender] = block.timestamp;
144         // Storing the amount of the deposit for new investors.
145         deposit[msg.sender] = (msg.value);
146     }
147 
148     // A function to get available dividends of an investor.
149     function withdraw() public {
150         // Amount of money which is available to withdraw.
151         // Formula without SafeMath: ((Current Time - Reference Point) - ((Current Time - Reference Point) % 1 day)) * (Deposit * 3% / 100%) / 1 day
152         uint amountToWithdraw = (block.timestamp.sub(lastTimeWithdraw[msg.sender]).sub((block.timestamp.sub(lastTimeWithdraw[msg.sender])).mod(1 days))).mul(deposit[msg.sender].mul(3).div(100)).div(1 days);
153         // Reverting the whole function for investors who got nothing to withdraw yet.
154         if (amountToWithdraw == 0) {
155             revert();
156         }
157         // Increasing amount withdrawn by the investor.
158         withdrawn[msg.sender] = withdrawn[msg.sender].add(amountToWithdraw);
159         // Updating the reference point.
160         // Formula without SafeMath: Current Time - ((Current Time - Previous Reference Point) % 1 day)
161         lastTimeWithdraw[msg.sender] = block.timestamp.sub((block.timestamp.sub(lastTimeWithdraw[msg.sender])).mod(1 days));
162         // Transferring the available dividends to an investor.
163         msg.sender.transfer(amountToWithdraw);
164     }
165 }