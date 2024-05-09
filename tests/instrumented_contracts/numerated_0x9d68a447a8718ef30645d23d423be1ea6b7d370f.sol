1 pragma solidity ^0.4.24;
2 
3 /**
4 *
5 Daily - 25% daily From AceReturns
6 */
7 contract Daily25 {
8 
9     using SafeMath for uint256;
10 
11     mapping(address => uint256) investments;
12     mapping(address => uint256) joined;
13     mapping(address => uint256) withdrawals;
14     mapping(address => uint256) referrer;
15 
16     uint256 public step = 115;
17     uint256 public minimum = 10 finney;
18     uint256 public stakingRequirement = 0.25 ether;
19     address public ownerWallet;
20     address public owner;
21     
22     event Invest(address investor, uint256 amount);
23     event Withdraw(address investor, uint256 amount);
24     event Bounty(address hunter, uint256 amount);
25     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27     /**
28      * @dev ?onstructor Sets the original roles of the contract
29      */
30 
31     constructor() public {
32         owner = msg.sender;
33         ownerWallet = msg.sender;
34     }
35 
36     /**
37      * @dev Modifiers
38      */
39 
40     modifier onlyOwner() {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     /**
46      * @dev Allows current owner to transfer control of the contract to a newOwner.
47      * @param newOwner The address to transfer ownership to.
48      * @param newOwnerWallet The address to transfer ownership to.
49      */
50     function transferOwnership(address newOwner, address newOwnerWallet) public onlyOwner {
51         require(newOwner != address(0));
52         emit OwnershipTransferred(owner, newOwner);
53         owner = newOwner;
54         ownerWallet = newOwnerWallet;
55     }
56 
57     /**
58      * @dev Investments
59      */
60     function () public payable {
61         buy(0x0);
62     }
63 
64     function buy(address _referredBy) public payable {
65         require(msg.value >= minimum);
66 
67         address _customerAddress = msg.sender;
68 
69         if(
70            // is this a referred purchase?
71            _referredBy != 0x0000000000000000000000000000000000000000 &&
72 
73            // no cheating!
74            _referredBy != _customerAddress &&
75 
76            // does the referrer have at least X whole tokens?
77            // i.e is the referrer a godly chad masternode
78            investments[_referredBy] >= stakingRequirement
79        ){
80            // wealth redistribution
81            referrer[_referredBy] = referrer[_referredBy].add(msg.value.mul(5).div(100));
82        }
83 
84        if (investments[msg.sender] > 0){
85            if (withdraw()){
86                withdrawals[msg.sender] = 0;
87            }
88        }
89        investments[msg.sender] = investments[msg.sender].add(msg.value);
90        joined[msg.sender] = block.timestamp;
91        ownerWallet.transfer(msg.value.mul(5).div(100));
92        emit Invest(msg.sender, msg.value);
93     }
94 
95     /**
96     * @dev Evaluate current balance
97     * @param _address Address of investor
98     */
99     function getBalance(address _address) view public returns (uint256) {
100         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
101         uint256 percent = investments[_address].mul(step).div(100);
102         uint256 different = percent.mul(minutesCount).div(1440);
103         uint256 balance = different.sub(withdrawals[_address]);
104 
105         return balance;
106     }
107 
108     /**
109     * @dev Withdraw dividends from contract
110     */
111     function withdraw() public returns (bool){
112         require(joined[msg.sender] > 0);
113         uint256 balance = getBalance(msg.sender);
114         if (address(this).balance > balance){
115             if (balance > 0){
116                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
117                 msg.sender.transfer(balance);
118                 emit Withdraw(msg.sender, balance);
119             }
120             return true;
121         } else {
122             return false;
123         }
124     }
125 
126     /**
127     * @dev Bounty reward
128     */
129     function bounty() public {
130         uint256 refBalance = checkReferral(msg.sender);
131         if(refBalance >= minimum) {
132              if (address(this).balance > refBalance) {
133                 referrer[msg.sender] = 0;
134                 msg.sender.transfer(refBalance);
135                 emit Bounty(msg.sender, refBalance);
136              }
137         }
138     }
139 
140     /**
141     * @dev Gets balance of the sender address.
142     * @return An uint256 representing the amount owned by the msg.sender.
143     */
144     function checkBalance() public view returns (uint256) {
145         return getBalance(msg.sender);
146     }
147 
148     /**
149     * @dev Gets withdrawals of the specified address.
150     * @param _investor The address to query the the balance of.
151     * @return An uint256 representing the amount owned by the passed address.
152     */
153     function checkWithdrawals(address _investor) public view returns (uint256) {
154         return withdrawals[_investor];
155     }
156 
157     /**
158     * @dev Gets investments of the specified address.
159     * @param _investor The address to query the the balance of.
160     * @return An uint256 representing the amount owned by the passed address.
161     */
162     function checkInvestments(address _investor) public view returns (uint256) {
163         return investments[_investor];
164     }
165 
166     /**
167     * @dev Gets referrer balance of the specified address.
168     * @param _hunter The address of the referrer
169     * @return An uint256 representing the referral earnings.
170     */
171     function checkReferral(address _hunter) public view returns (uint256) {
172         return referrer[_hunter];
173     }
174 }
175 
176 /**
177  * @title SafeMath
178  * @dev Math operations with safety checks that throw on error
179  */
180 library SafeMath {
181     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
182         if (a == 0) {
183             return 0;
184         }
185         uint256 c = a * b;
186         assert(c / a == b);
187         return c;
188     }
189 
190     function div(uint256 a, uint256 b) internal pure returns (uint256) {
191         // assert(b > 0); // Solidity automatically throws when dividing by 0
192         uint256 c = a / b;
193         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
194         return c;
195     }
196 
197     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
198         assert(b <= a);
199         return a - b;
200     }
201 
202     function add(uint256 a, uint256 b) internal pure returns (uint256) {
203         uint256 c = a + b;
204         assert(c >= a);
205         return c;
206     }
207 }