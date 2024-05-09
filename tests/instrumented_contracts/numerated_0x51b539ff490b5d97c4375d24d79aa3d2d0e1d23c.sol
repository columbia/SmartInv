1 pragma solidity ^0.4.24;
2 
3 contract ETH666{
4 
5     using SafeMath for uint256;
6 
7     mapping(address => uint256) investments;
8     mapping(address => uint256) joined;
9     mapping(address => uint256) withdrawals;
10 
11     uint256 public minimum = 10000000000000000;
12     uint256 public step = 666;
13     address public ownerWallet;
14     address public owner;
15 
16     event Invest(address investor, uint256 amount);
17     event Withdraw(address investor, uint256 amount);
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20     /**
21      * @dev Сonstructor Sets the original roles of the contract
22      */
23 
24     constructor() public {
25         owner = msg.sender;
26         ownerWallet = msg.sender;
27     }
28 
29     /**
30      * @dev Modifiers
31      */
32 
33     modifier onlyOwner() {
34         require(msg.sender == owner);
35         _;
36     }
37 
38     /**
39      * @dev Allows current owner to transfer control of the contract to a newOwner.
40      * @param newOwner The address to transfer ownership to.
41      * @param newOwnerWallet The address to transfer ownership to.
42      */
43     function transferOwnership(address newOwner, address newOwnerWallet) public onlyOwner {
44         require(newOwner != address(0));
45         emit OwnershipTransferred(owner, newOwner);
46         owner = newOwner;
47         ownerWallet = newOwnerWallet;
48     }
49 
50     /**
51      * @dev Investments
52      */
53     function () external payable {
54         require(msg.value >= minimum);
55         if (investments[msg.sender] > 0){
56             if (withdraw()){
57                 withdrawals[msg.sender] = 0;
58             }
59         }
60         investments[msg.sender] = investments[msg.sender].add(msg.value);
61         joined[msg.sender] = block.timestamp;
62         ownerWallet.transfer(msg.value.div(100).mul(10));
63         emit Invest(msg.sender, msg.value);
64     }
65 
66     /**
67     * @dev Evaluate current balance
68     * @param _address Address of investor
69     */
70     function getBalance(address _address) view public returns (uint256) {
71         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
72         uint256 percent = investments[_address].mul(step).div(10000);
73         uint256 different = percent.mul(minutesCount).div(1440);
74         uint256 balance = different.sub(withdrawals[_address]);
75 
76         return balance;
77     }
78 
79     /**
80     * @dev Withdraw dividends from contract
81     */
82     function withdraw() public returns (bool){
83         require(joined[msg.sender] > 0);
84         uint256 balance = getBalance(msg.sender);
85         if (address(this).balance > balance){
86             if (balance > 0){
87                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
88                 msg.sender.transfer(balance);
89                 emit Withdraw(msg.sender, balance);
90             }
91             return true;
92         } else {
93             return false;
94         }
95     }
96 
97     /**
98     * @dev Gets balance of the sender address.
99     * @return An uint256 representing the amount owned by the msg.sender.
100     */
101     function checkBalance() public view returns (uint256) {
102         return getBalance(msg.sender);
103     }
104 
105     /**
106     * @dev Gets withdrawals of the specified address.
107     * @param _investor The address to query the the balance of.
108     * @return An uint256 representing the amount owned by the passed address.
109     */
110     function checkWithdrawals(address _investor) public view returns (uint256) {
111         return withdrawals[_investor];
112     }
113 
114     /**
115     * @dev Gets investments of the specified address.
116     * @param _investor The address to query the the balance of.
117     * @return An uint256 representing the amount owned by the passed address.
118     */
119     function checkInvestments(address _investor) public view returns (uint256) {
120         return investments[_investor];
121     }
122 
123 }
124 
125 /**
126  * @title SafeMath
127  * @dev Math operations with safety checks that throw on error
128  */
129 library SafeMath {
130     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
131         if (a == 0) {
132             return 0;
133         }
134         uint256 c = a * b;
135         assert(c / a == b);
136         return c;
137     }
138 
139     function div(uint256 a, uint256 b) internal pure returns (uint256) {
140         // assert(b > 0); // Solidity automatically throws when dividing by 0
141         uint256 c = a / b;
142         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
143         return c;
144     }
145 
146     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147         assert(b <= a);
148         return a - b;
149     }
150 
151     function add(uint256 a, uint256 b) internal pure returns (uint256) {
152         uint256 c = a + b;
153         assert(c >= a);
154         return c;
155     }
156 }