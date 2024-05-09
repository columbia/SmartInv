1 pragma solidity ^0.4.25;
2 
3 /**
4 *
5 */
6 contract Percent1200 {
7 
8     using SafeMath for uint256;
9 
10     mapping(address => uint256) investments;
11     mapping(address => uint256) joined;
12     mapping(address => uint256) withdrawals;
13     mapping(address => uint256) referrer;
14 
15     uint256 public step = 100;
16     uint256 public minimum = 10 finney;
17     uint256 public stakingRequirement = 2 ether;
18     address public ownerWallet;
19     address public owner;
20 
21     event Invest(address investor, uint256 amount);
22     event Withdraw(address investor, uint256 amount);
23     event Bounty(address hunter, uint256 amount);
24     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26     /**
27      * @dev Сonstructor Sets the original roles of the contract
28      */
29 
30     constructor() public {
31         owner = msg.sender;
32         ownerWallet = msg.sender;
33     }
34 
35     /**
36      * @dev Modifiers
37      */
38 
39     modifier onlyOwner() {
40         require(msg.sender == owner);
41         _;
42     }
43 
44     /**
45      * @dev Allows current owner to transfer control of the contract to a newOwner.
46      * @param newOwner The address to transfer ownership to.
47      * @param newOwnerWallet The address to transfer ownership to.
48      */
49     function transferOwnership(address newOwner, address newOwnerWallet) public onlyOwner {
50         require(newOwner != address(0));
51         emit OwnershipTransferred(owner, newOwner);
52         owner = newOwner;
53         ownerWallet = newOwnerWallet;
54     }
55 
56     /**
57      * @dev Investments
58      */
59     function () public payable {
60         buy(0x0);
61     }
62 
63     function buy(address _referredBy) public payable {
64         require(msg.value >= minimum);
65 
66         address _customerAddress = msg.sender;
67 
68         if(
69            // is this a referred purchase?
70            _referredBy != 0x0000000000000000000000000000000000000000 &&
71 
72            // no cheating!
73            _referredBy != _customerAddress &&
74 
75            // does the referrer have at least X whole tokens?
76            // i.e is the referrer a godly chad masternode
77            investments[_referredBy] >= stakingRequirement
78        ){
79            // wealth redistribution
80            referrer[_referredBy] = referrer[_referredBy].add(msg.value.mul(5).div(100));
81        }
82 
83        if (investments[msg.sender] > 0){
84            if (withdraw()){
85                withdrawals[msg.sender] = 0;
86            }
87        }
88        investments[msg.sender] = investments[msg.sender].add(msg.value);
89        joined[msg.sender] = block.timestamp;
90        ownerWallet.transfer(msg.value.mul(10).div(100));
91        emit Invest(msg.sender, msg.value);
92     }
93 
94     /**
95     * @dev Evaluate current balance
96     * @param _address Address of investor
97     */
98     function getBalance(address _address) view public returns (uint256) {
99         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
100         uint256 percent = investments[_address].mul(step).div(100);
101         uint256 different = percent.mul(minutesCount).div(120);
102         uint256 balance = different.sub(withdrawals[_address]);
103 
104         return balance;
105     }
106 
107     /**
108     * @dev Withdraw dividends from contract
109     */
110     function withdraw() public returns (bool){
111         require(joined[msg.sender] > 0);
112         uint256 balance = getBalance(msg.sender);
113         if (address(this).balance > balance){
114             if (balance > 0){
115                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
116                 msg.sender.transfer(balance);
117                 emit Withdraw(msg.sender, balance);
118             }
119             return true;
120         } else {
121             return false;
122         }
123     }
124 
125     /**
126     * @dev Bounty reward
127     */
128     function bounty() public {
129         uint256 refBalance = checkReferral(msg.sender);
130         if(refBalance >= minimum) {
131              if (address(this).balance > refBalance) {
132                 referrer[msg.sender] = 0;
133                 msg.sender.transfer(refBalance);
134                 emit Bounty(msg.sender, refBalance);
135              }
136         }
137     }
138 
139     /**
140     * @dev Gets balance of the sender address.
141     * @return An uint256 representing the amount owned by the msg.sender.
142     */
143     function checkBalance() public view returns (uint256) {
144         return getBalance(msg.sender);
145     }
146 
147     /**
148     * @dev Gets withdrawals of the specified address.
149     * @param _investor The address to query the the balance of.
150     * @return An uint256 representing the amount owned by the passed address.
151     */
152     function checkWithdrawals(address _investor) public view returns (uint256) {
153         return withdrawals[_investor];
154     }
155 
156     /**
157     * @dev Gets investments of the specified address.
158     * @param _investor The address to query the the balance of.
159     * @return An uint256 representing the amount owned by the passed address.
160     */
161     function checkInvestments(address _investor) public view returns (uint256) {
162         return investments[_investor];
163     }
164 
165     /**
166     * @dev Gets referrer balance of the specified address.
167     * @param _hunter The address of the referrer
168     * @return An uint256 representing the referral earnings.
169     */
170     function checkReferral(address _hunter) public view returns (uint256) {
171         return referrer[_hunter];
172     }
173 }
174 
175 /**
176  * @title SafeMath
177  * @dev Math operations with safety checks that throw on error
178  */
179 library SafeMath {
180     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
181         if (a == 0) {
182             return 0;
183         }
184         uint256 c = a * b;
185         assert(c / a == b);
186         return c;
187     }
188 
189     function div(uint256 a, uint256 b) internal pure returns (uint256) {
190         // assert(b > 0); // Solidity automatically throws when dividing by 0
191         uint256 c = a / b;
192         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
193         return c;
194     }
195 
196     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
197         assert(b <= a);
198         return a - b;
199     }
200 
201     function add(uint256 a, uint256 b) internal pure returns (uint256) {
202         uint256 c = a + b;
203         assert(c >= a);
204         return c;
205     }
206 }