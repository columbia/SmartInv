1 pragma solidity ^0.4.24;
2  
3 contract BCFVault {
4  
5     using SafeMath for uint256;
6  
7     mapping(address => uint256) investments;
8     mapping(address => uint256) joined;
9     mapping(address => uint256) withdrawals;
10     mapping(address => uint256) referrer;
11  
12     uint256 public step = 1;
13     uint256 public minimum = 10 finney;
14     uint256 public stakingRequirement = 2 ether;
15     address public blueDividendAddr;
16     address public owner;
17  
18     event Invest(address investor, uint256 amount);
19     event Withdraw(address investor, uint256 amount);
20     event Bounty(address hunter, uint256 amount);
21     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22  
23     /**
24      * @dev Сonstructor Sets the original roles of the contract
25      */
26  
27     constructor() public {
28         owner = msg.sender;
29         blueDividendAddr = 0xB40b8e3C726155FF1c6EEBD22067436D0e2669dd;
30     }
31  
32     /**
33      * @dev Modifiers
34      */
35  
36     modifier onlyOwner() {
37         require(msg.sender == owner);
38         _;
39     }
40  
41     /**
42      * @dev Allows current owner to transfer control of the contract to a newOwner.
43      * @param newOwner The address to transfer ownership to.
44      */
45     function transferOwnership(address newOwner) public onlyOwner {
46         require(newOwner != address(0));
47         emit OwnershipTransferred(owner, newOwner);
48         owner = newOwner;
49     }
50  
51     /**
52      * @dev Investments
53      */
54     function () public payable {
55         invest(0x0);
56     }
57  
58     function invest(address _referredBy) public payable {
59         require(msg.value >= minimum);
60  
61         address _customerAddress = msg.sender;
62  
63         if(
64            // is this a referred purchase?
65            _referredBy != 0x0000000000000000000000000000000000000000 &&
66  
67            // no cheating!
68            _referredBy != _customerAddress &&
69  
70            // does the referrer have at least X whole tokens?
71            // i.e is the referrer a godly chad masternode
72            investments[_referredBy] >= stakingRequirement
73        ){
74            // wealth redistribution
75            referrer[_referredBy] = referrer[_referredBy].add(msg.value.mul(5).div(100));
76        }
77  
78        if (investments[msg.sender] > 0){
79            if (withdraw()){
80                withdrawals[msg.sender] = 0;
81            }
82        }
83        investments[msg.sender] = investments[msg.sender].add(msg.value);
84        joined[msg.sender] = block.timestamp;
85        blueDividendAddr.transfer(msg.value.mul(5).div(100));
86        emit Invest(msg.sender, msg.value);
87     }
88  
89     /**
90     * @dev Evaluate current balance
91     * @param _address Address of investor
92     */
93     function getBalance(address _address) view public returns (uint256) {
94         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
95         uint256 percent = investments[_address].mul(step).div(100);
96         uint256 different = percent.mul(minutesCount).div(1440);
97         uint256 balance = different.sub(withdrawals[_address]);
98  
99         return balance;
100     }
101  
102     /**
103     * @dev Withdraw dividends from contract
104     */
105     function withdraw() public returns (bool){
106         require(joined[msg.sender] > 0);
107         uint256 balance = getBalance(msg.sender);
108         if (address(this).balance > balance){
109             if (balance > 0){
110                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
111                 msg.sender.transfer(balance);
112                 emit Withdraw(msg.sender, balance);
113             }
114             return true;
115         } else {
116             return false;
117         }
118     }
119  
120     /**
121     * @dev Bounty reward
122     */
123     function bounty() public {
124         uint256 refBalance = checkReferral(msg.sender);
125         if(refBalance >= minimum) {
126              if (address(this).balance > refBalance) {
127                 referrer[msg.sender] = 0;
128                 msg.sender.transfer(refBalance);
129                 emit Bounty(msg.sender, refBalance);
130              }
131         }
132     }
133  
134     /**
135     * @dev Gets balance of the sender address.
136     * @return An uint256 representing the amount owned by the msg.sender.
137     */
138     function checkBalance() public view returns (uint256) {
139         return getBalance(msg.sender);
140     }
141  
142     /**
143     * @dev Gets withdrawals of the specified address.
144     * @param _investor The address to query the the balance of.
145     * @return An uint256 representing the amount owned by the passed address.
146     */
147     function checkWithdrawals(address _investor) public view returns (uint256) {
148         return withdrawals[_investor];
149     }
150  
151     /**
152     * @dev Gets investments of the specified address.
153     * @param _investor The address to query the the balance of.
154     * @return An uint256 representing the amount owned by the passed address.
155     */
156     function checkInvestments(address _investor) public view returns (uint256) {
157         return investments[_investor];
158     }
159  
160     /**
161     * @dev Gets referrer balance of the specified address.
162     * @param _hunter The address of the referrer
163     * @return An uint256 representing the referral earnings.
164     */
165     function checkReferral(address _hunter) public view returns (uint256) {
166         return referrer[_hunter];
167     }
168 }
169  
170 /**
171  * @title SafeMath
172  * @dev Math operations with safety checks that throw on error
173  */
174 library SafeMath {
175     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
176         if (a == 0) {
177             return 0;
178         }
179         uint256 c = a * b;
180         assert(c / a == b);
181         return c;
182     }
183  
184     function div(uint256 a, uint256 b) internal pure returns (uint256) {
185         // assert(b > 0); // Solidity automatically throws when dividing by 0
186         uint256 c = a / b;
187         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
188         return c;
189     }
190  
191     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
192         assert(b <= a);
193         return a - b;
194     }
195  
196     function add(uint256 a, uint256 b) internal pure returns (uint256) {
197         uint256 c = a + b;
198         assert(c >= a);
199         return c;
200     }
201 }