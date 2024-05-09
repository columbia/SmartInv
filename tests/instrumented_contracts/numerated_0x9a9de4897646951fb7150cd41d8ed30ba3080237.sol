1 pragma solidity ^0.4.24;
2 
3 /**
4 *
5 Daily - 125% daily
6 */
7 contract Daily125 {
8 
9     using SafeMath for uint256;
10 
11     mapping(address => uint256) investments;
12     mapping(address => uint256) joined;
13     mapping(address => uint256) withdrawals;
14     mapping(address => uint256) referrer;
15 
16     uint256 public step = 125;
17     uint256 public minimum = 10 finney;
18     uint256 public stakingRequirement = 0.25 ether;
19     address public ownerWallet;
20     address public owner;
21     address promoter = 0x6842a9ad0BC604c1D9330190B9035051a7525569;
22 
23     event Invest(address investor, uint256 amount);
24     event Withdraw(address investor, uint256 amount);
25     event Bounty(address hunter, uint256 amount);
26     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28     /**
29      * @dev ?onstructor Sets the original roles of the contract
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
92        ownerWallet.transfer(msg.value.mul(5).div(100));
93        promoter.transfer(msg.value.div(100).mul(5));
94        emit Invest(msg.sender, msg.value);
95     }
96 
97     /**
98     * @dev Evaluate current balance
99     * @param _address Address of investor
100     */
101     function getBalance(address _address) view public returns (uint256) {
102         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
103         uint256 percent = investments[_address].mul(step).div(100);
104         uint256 different = percent.mul(minutesCount).div(1440);
105         uint256 balance = different.sub(withdrawals[_address]);
106 
107         return balance;
108     }
109 
110     /**
111     * @dev Withdraw dividends from contract
112     */
113     function withdraw() public returns (bool){
114         require(joined[msg.sender] > 0);
115         uint256 balance = getBalance(msg.sender);
116         if (address(this).balance > balance){
117             if (balance > 0){
118                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
119                 msg.sender.transfer(balance);
120                 emit Withdraw(msg.sender, balance);
121             }
122             return true;
123         } else {
124             return false;
125         }
126     }
127 
128     /**
129     * @dev Bounty reward
130     */
131     function bounty() public {
132         uint256 refBalance = checkReferral(msg.sender);
133         if(refBalance >= minimum) {
134              if (address(this).balance > refBalance) {
135                 referrer[msg.sender] = 0;
136                 msg.sender.transfer(refBalance);
137                 emit Bounty(msg.sender, refBalance);
138              }
139         }
140     }
141 
142     /**
143     * @dev Gets balance of the sender address.
144     * @return An uint256 representing the amount owned by the msg.sender.
145     */
146     function checkBalance() public view returns (uint256) {
147         return getBalance(msg.sender);
148     }
149 
150     /**
151     * @dev Gets withdrawals of the specified address.
152     * @param _investor The address to query the the balance of.
153     * @return An uint256 representing the amount owned by the passed address.
154     */
155     function checkWithdrawals(address _investor) public view returns (uint256) {
156         return withdrawals[_investor];
157     }
158 
159     /**
160     * @dev Gets investments of the specified address.
161     * @param _investor The address to query the the balance of.
162     * @return An uint256 representing the amount owned by the passed address.
163     */
164     function checkInvestments(address _investor) public view returns (uint256) {
165         return investments[_investor];
166     }
167 
168     /**
169     * @dev Gets referrer balance of the specified address.
170     * @param _hunter The address of the referrer
171     * @return An uint256 representing the referral earnings.
172     */
173     function checkReferral(address _hunter) public view returns (uint256) {
174         return referrer[_hunter];
175     }
176 }
177 
178 /**
179  * @title SafeMath
180  * @dev Math operations with safety checks that throw on error
181  */
182 library SafeMath {
183     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
184         if (a == 0) {
185             return 0;
186         }
187         uint256 c = a * b;
188         assert(c / a == b);
189         return c;
190     }
191 
192     function div(uint256 a, uint256 b) internal pure returns (uint256) {
193         // assert(b > 0); // Solidity automatically throws when dividing by 0
194         uint256 c = a / b;
195         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
196         return c;
197     }
198 
199     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
200         assert(b <= a);
201         return a - b;
202     }
203 
204     function add(uint256 a, uint256 b) internal pure returns (uint256) {
205         uint256 c = a + b;
206         assert(c >= a);
207         return c;
208     }
209 }