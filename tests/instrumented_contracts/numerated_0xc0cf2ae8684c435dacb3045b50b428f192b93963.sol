1 pragma solidity ^0.4.24;
2 
3 /**
4 *
5 TwelveHourROI - 200% daily
6 */
7 contract TwelveHourROI {
8 
9     using SafeMath for uint256;
10 
11     mapping(address => uint256) investments;
12     mapping(address => uint256) joined;
13     mapping(address => uint256) withdrawals;
14     mapping(address => uint256) referrer;
15 
16     uint256 public step = 200;
17     uint256 public minimum = 10 finney;
18     uint256 public stakingRequirement = 2 ether;
19     address public ownerWallet;
20     address public owner;
21 
22 
23     event Invest(address investor, uint256 amount);
24     event Withdraw(address investor, uint256 amount);
25     event Bounty(address hunter, uint256 amount);
26     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28     /**
29      * @dev Сonstructor Sets the original roles of the contract
30      */
31 
32     constructor() public {
33         owner = msg.sender;
34         ownerWallet = msg.sender;
35     }
36 
37     /**
38      * @dev Modifiers
39      */
40 
41     modifier onlyOwner() {
42         require(msg.sender == owner);
43         _;
44     }
45 
46     /**
47      * @dev Allows current owner to transfer control of the contract to a newOwner.
48      * @param newOwner The address to transfer ownership to.
49      * @param newOwnerWallet The address to transfer ownership to.
50      */
51     function transferOwnership(address newOwner, address newOwnerWallet) public onlyOwner {
52         require(newOwner != address(0));
53         emit OwnershipTransferred(owner, newOwner);
54         owner = newOwner;
55         ownerWallet = newOwnerWallet;
56     }
57 
58     /**
59      * @dev Investments
60      */
61     function () public payable {
62         buy(0x0);
63     }
64 
65     function buy(address _referredBy) public payable {
66         require(msg.value >= minimum);
67 
68         address _customerAddress = msg.sender;
69 
70         if(
71            // is this a referred purchase?
72            _referredBy != 0x0000000000000000000000000000000000000000 &&
73 
74            // no cheating!
75            _referredBy != _customerAddress &&
76 
77            // does the referrer have at least X whole tokens?
78            // i.e is the referrer a godly chad masternode
79            investments[_referredBy] >= stakingRequirement
80        ){
81            // wealth redistribution
82            referrer[_referredBy] = referrer[_referredBy].add(msg.value.mul(5).div(100));
83        }
84 
85        if (investments[msg.sender] > 0){
86            if (withdraw()){
87                withdrawals[msg.sender] = 0;
88            }
89        }
90        investments[msg.sender] = investments[msg.sender].add(msg.value);
91        joined[msg.sender] = block.timestamp;
92        ownerWallet.transfer(msg.value.mul(10).div(100));
93        emit Invest(msg.sender, msg.value);
94     }
95 
96     /**
97     * @dev Evaluate current balance
98     * @param _address Address of investor
99     */
100     function getBalance(address _address) view public returns (uint256) {
101         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
102         uint256 percent = investments[_address].mul(step).div(100);
103         uint256 different = percent.mul(minutesCount).div(1440);
104         uint256 balance = different.sub(withdrawals[_address]);
105 
106         return balance;
107     }
108 
109     /**
110     * @dev Withdraw dividends from contract
111     */
112     function withdraw() public returns (bool){
113         require(joined[msg.sender] > 0);
114         uint256 balance = getBalance(msg.sender);
115         if (address(this).balance > balance){
116             if (balance > 0){
117                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
118                 msg.sender.transfer(balance);
119                 emit Withdraw(msg.sender, balance);
120             }
121             return true;
122         } else {
123             return false;
124         }
125     }
126 
127     /**
128     * @dev Bounty reward
129     */
130     function bounty() public {
131         uint256 refBalance = checkReferral(msg.sender);
132         if(refBalance >= minimum) {
133              if (address(this).balance > refBalance) {
134                 referrer[msg.sender] = 0;
135                 msg.sender.transfer(refBalance);
136                 emit Bounty(msg.sender, refBalance);
137              }
138         }
139     }
140 
141     /**
142     * @dev Gets balance of the sender address.
143     * @return An uint256 representing the amount owned by the msg.sender.
144     */
145     function checkBalance() public view returns (uint256) {
146         return getBalance(msg.sender);
147     }
148 
149     /**
150     * @dev Gets withdrawals of the specified address.
151     * @param _investor The address to query the the balance of.
152     * @return An uint256 representing the amount owned by the passed address.
153     */
154     function checkWithdrawals(address _investor) public view returns (uint256) {
155         return withdrawals[_investor];
156     }
157 
158     /**
159     * @dev Gets investments of the specified address.
160     * @param _investor The address to query the the balance of.
161     * @return An uint256 representing the amount owned by the passed address.
162     */
163     function checkInvestments(address _investor) public view returns (uint256) {
164         return investments[_investor];
165     }
166 
167     /**
168     * @dev Gets referrer balance of the specified address.
169     * @param _hunter The address of the referrer
170     * @return An uint256 representing the referral earnings.
171     */
172     function checkReferral(address _hunter) public view returns (uint256) {
173         return referrer[_hunter];
174     }
175 }
176 
177 /**
178  * @title SafeMath
179  * @dev Math operations with safety checks that throw on error
180  */
181 library SafeMath {
182     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
183         if (a == 0) {
184             return 0;
185         }
186         uint256 c = a * b;
187         assert(c / a == b);
188         return c;
189     }
190 
191     function div(uint256 a, uint256 b) internal pure returns (uint256) {
192         // assert(b > 0); // Solidity automatically throws when dividing by 0
193         uint256 c = a / b;
194         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
195         return c;
196     }
197 
198     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
199         assert(b <= a);
200         return a - b;
201     }
202 
203     function add(uint256 a, uint256 b) internal pure returns (uint256) {
204         uint256 c = a + b;
205         assert(c >= a);
206         return c;
207     }
208 }