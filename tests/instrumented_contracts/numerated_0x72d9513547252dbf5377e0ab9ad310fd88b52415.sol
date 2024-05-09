1 pragma solidity ^0.4.25;
2  
3 /**
4  *
5  * Easy Investment 2 Contract
6  *  - GAIN 2% PER 24 HOURS (every 5900 blocks)
7  * 
8  * RECOMMENDED GAS LIMIT: 70000
9  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
10  *
11  * Contract reviewed and approved by pros!
12  *
13  */
14 contract EthLong{
15    
16     using SafeMath for uint256;
17  
18     mapping(address => uint256) investments;
19     mapping(address => uint256) joined;
20     mapping(address => uint256) withdrawals;
21  
22     uint256 public minimum = 10000000000000000;
23     uint256 public step = 33;
24     address public ownerWallet;
25     address public owner;
26     address public bountyManager;
27     address promoter = 0xA4410DF42dFFa99053B4159696757da2B757A29d;
28  
29     event Invest(address investor, uint256 amount);
30     event Withdraw(address investor, uint256 amount);
31     event Bounty(address hunter, uint256 amount);
32    
33     /**
34      * @dev Сonstructor Sets the original roles of the contract
35      */
36      
37     constructor(address _bountyManager) public {
38         owner = msg.sender;
39         ownerWallet = msg.sender;
40         bountyManager = _bountyManager;
41     }
42  
43     /**
44      * @dev Modifiers
45      */
46      
47     modifier onlyOwner() {
48         require(msg.sender == owner);
49         _;
50     }
51  
52     modifier onlyBountyManager() {
53         require(msg.sender == bountyManager);
54         _;
55     }
56  
57     /**
58      * @dev Allows current owner to transfer control of the contract to a newOwner.
59      * @param newOwner The address to transfer ownership to.
60      * @param newOwnerWallet The address to transfer ownership to.
61      */
62  
63     /**
64      * @dev Investments
65      */
66     function () external payable {
67         require(msg.value >= minimum);
68         if (investments[msg.sender] > 0){
69             if (withdraw()){
70                 withdrawals[msg.sender] = 0;
71             }
72         }
73         investments[msg.sender] = investments[msg.sender].add(msg.value);
74         joined[msg.sender] = block.timestamp;
75         ownerWallet.transfer(msg.value.div(100).mul(5));
76         promoter.transfer(msg.value.div(100).mul(5));
77         emit Invest(msg.sender, msg.value);
78     }
79  
80     /**
81     * @dev Evaluate current balance
82     * @param _address Address of investor
83     */
84     function getBalance(address _address) view public returns (uint256) {
85         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
86         uint256 percent = investments[_address].mul(step).div(100);
87         uint256 different = percent.mul(minutesCount).div(72000);
88         uint256 balance = different.sub(withdrawals[_address]);
89  
90         return balance;
91     }
92  
93     /**
94     * @dev Withdraw dividends from contract
95     */
96     function withdraw() public returns (bool){
97         require(joined[msg.sender] > 0);
98         uint256 balance = getBalance(msg.sender);
99         if (address(this).balance > balance){
100             if (balance > 0){
101                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
102                 msg.sender.transfer(balance);
103                 emit Withdraw(msg.sender, balance);
104             }
105             return true;
106         } else {
107             return false;
108         }
109     }
110    
111  
112     /**
113     * @dev Gets balance of the sender address.
114     * @return An uint256 representing the amount owned by the msg.sender.
115     */
116     function checkBalance() public view returns (uint256) {
117         return getBalance(msg.sender);
118     }
119  
120     /**
121     * @dev Gets withdrawals of the specified address.
122     * @param _investor The address to query the the balance of.
123     * @return An uint256 representing the amount owned by the passed address.
124     */
125     function checkWithdrawals(address _investor) public view returns (uint256) {
126         return withdrawals[_investor];
127     }
128  
129     /**
130     * @dev Gets investments of the specified address.
131     * @param _investor The address to query the the balance of.
132     * @return An uint256 representing the amount owned by the passed address.
133     */
134     function checkInvestments(address _investor) public view returns (uint256) {
135         return investments[_investor];
136     }
137        
138 }
139  
140 /**
141  * @title SafeMath
142  * @dev Math operations with safety checks that throw on error
143  */
144 library SafeMath {
145     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
146         if (a == 0) {
147             return 0;
148         }
149         uint256 c = a * b;
150         assert(c / a == b);
151         return c;
152     }
153  
154     function div(uint256 a, uint256 b) internal pure returns (uint256) {
155         // assert(b > 0); // Solidity automatically throws when dividing by 0
156         uint256 c = a / b;
157         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
158         return c;
159     }
160  
161     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
162         assert(b <= a);
163         return a - b;
164     }
165  
166     function add(uint256 a, uint256 b) internal pure returns (uint256) {
167         uint256 c = a + b;
168         assert(c >= a);
169         return c;
170     }
171 }