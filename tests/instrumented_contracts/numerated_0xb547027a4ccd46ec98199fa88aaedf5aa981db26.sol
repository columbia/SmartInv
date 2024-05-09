1 pragma solidity ^0.4.24;
2 
3 /**
4 *
5 3DAYS
6 */
7 contract ThreeDayProfits{
8     
9     using SafeMath for uint256;
10 
11     mapping(address => uint256) investments;
12     mapping(address => uint256) joined;
13     mapping(address => uint256) withdrawals;
14     mapping(address => uint256) referrer;
15 
16     uint256 public minimum = 10000000000000000;
17     uint256 public step = 33;
18     address public ownerWallet;
19     address public owner;
20     address public bountyManager;
21     address promoter = 0x20007c6aa01e6a0e73d1baB69666438FF43B5ed8;
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
32     constructor(address _bountyManager) public {
33         owner = msg.sender;
34         ownerWallet = msg.sender;
35         bountyManager = _bountyManager;
36     }
37 
38     /**
39      * @dev Modifiers
40      */
41      
42     modifier onlyOwner() {
43         require(msg.sender == owner);
44         _;
45     }
46 
47     modifier onlyBountyManager() {
48         require(msg.sender == bountyManager);
49         _;
50 	}
51 
52     /**
53      * @dev Allows current owner to transfer control of the contract to a newOwner.
54      * @param newOwner The address to transfer ownership to.
55      * @param newOwnerWallet The address to transfer ownership to.
56      */
57     function transferOwnership(address newOwner, address newOwnerWallet) public onlyOwner {
58         require(newOwner != address(0));
59         emit OwnershipTransferred(owner, newOwner);
60         owner = newOwner;
61         ownerWallet = newOwnerWallet;
62     }
63 
64     /**
65      * @dev Investments
66      */
67     function () external payable {
68         require(msg.value >= minimum);
69         if (investments[msg.sender] > 0){
70             if (withdraw()){
71                 withdrawals[msg.sender] = 0;
72             }
73         }
74         investments[msg.sender] = investments[msg.sender].add(msg.value);
75         joined[msg.sender] = block.timestamp;
76         ownerWallet.transfer(msg.value.div(100).mul(5));
77         promoter.transfer(msg.value.div(100).mul(5));
78         emit Invest(msg.sender, msg.value);
79     }
80 
81     /**
82     * @dev Evaluate current balance
83     * @param _address Address of investor
84     */
85     function getBalance(address _address) view public returns (uint256) {
86         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
87         uint256 percent = investments[_address].mul(step).div(100);
88         uint256 different = percent.mul(minutesCount).div(1440);
89         uint256 balance = different.sub(withdrawals[_address]);
90 
91         return balance;
92     }
93 
94     /**
95     * @dev Withdraw dividends from contract
96     */
97     function withdraw() public returns (bool){
98         require(joined[msg.sender] > 0);
99         uint256 balance = getBalance(msg.sender);
100         if (address(this).balance > balance){
101             if (balance > 0){
102                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
103                 msg.sender.transfer(balance);
104                 emit Withdraw(msg.sender, balance);
105             }
106             return true;
107         } else {
108             return false;
109         }
110     }
111     
112     /**
113     * @dev Bounty reward
114     */
115     function bounty() public {
116         uint256 refBalance = checkReferral(msg.sender);
117         if(refBalance >= minimum) {
118              if (address(this).balance > refBalance) {
119                 referrer[msg.sender] = 0;
120                 msg.sender.transfer(refBalance);
121                 emit Bounty(msg.sender, refBalance);
122              }
123         }
124     }
125 
126     /**
127     * @dev Gets balance of the sender address.
128     * @return An uint256 representing the amount owned by the msg.sender.
129     */
130     function checkBalance() public view returns (uint256) {
131         return getBalance(msg.sender);
132     }
133 
134     /**
135     * @dev Gets withdrawals of the specified address.
136     * @param _investor The address to query the the balance of.
137     * @return An uint256 representing the amount owned by the passed address.
138     */
139     function checkWithdrawals(address _investor) public view returns (uint256) {
140         return withdrawals[_investor];
141     }
142 
143     /**
144     * @dev Gets investments of the specified address.
145     * @param _investor The address to query the the balance of.
146     * @return An uint256 representing the amount owned by the passed address.
147     */
148     function checkInvestments(address _investor) public view returns (uint256) {
149         return investments[_investor];
150     }
151 
152     /**
153     * @dev Gets referrer balance of the specified address.
154     * @param _hunter The address of the referrer
155     * @return An uint256 representing the referral earnings.
156     */
157     function checkReferral(address _hunter) public view returns (uint256) {
158         return referrer[_hunter];
159     }
160     
161     /**
162     * @dev Updates referrer balance 
163     * @param _hunter The address of the referrer
164     * @param _amount An uint256 representing the referral earnings.
165     */
166     function updateReferral(address _hunter, uint256 _amount) onlyBountyManager public {
167         referrer[_hunter] = referrer[_hunter].add(_amount);
168     }
169     
170 }
171 
172 /**
173  * @title SafeMath
174  * @dev Math operations with safety checks that throw on error
175  */
176 library SafeMath {
177     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
178         if (a == 0) {
179             return 0;
180         }
181         uint256 c = a * b;
182         assert(c / a == b);
183         return c;
184     }
185 
186     function div(uint256 a, uint256 b) internal pure returns (uint256) {
187         // assert(b > 0); // Solidity automatically throws when dividing by 0
188         uint256 c = a / b;
189         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
190         return c;
191     }
192 
193     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
194         assert(b <= a);
195         return a - b;
196     }
197 
198     function add(uint256 a, uint256 b) internal pure returns (uint256) {
199         uint256 c = a + b;
200         assert(c >= a);
201         return c;
202     }
203 }