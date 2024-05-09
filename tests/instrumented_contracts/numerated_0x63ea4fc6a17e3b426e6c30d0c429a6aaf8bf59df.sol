1 pragma solidity ^0.4.24;
2 
3 /**
4 *
5 12HourRush
6 website:http://12HourRush.com
7 Discord:https://discordapp.com/invite/tey5cG
8 Twitter:https://twitter.com/TwelveHourRush
9 */
10 contract    TwelveHourRush{
11     
12     using SafeMath for uint256;
13 
14     mapping(address => uint256) investments;
15     mapping(address => uint256) joined;
16     mapping(address => uint256) withdrawals;
17     mapping(address => uint256) referrer;
18 
19     uint256 public minimum = 10000000000000000;
20     uint256 public step = 12;
21     address public ownerWallet;
22     address public owner;
23     address public bountyManager;
24     address promoter = 0x4c3B215a24fCd7dd34d4EDF098A5d8609FfEBD63;
25 
26     event Invest(address investor, uint256 amount);
27     event Withdraw(address investor, uint256 amount);
28     event Bounty(address hunter, uint256 amount);
29     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30     
31     /**
32      * @dev Сonstructor Sets the original roles of the contract 
33      */
34      
35     constructor(address _bountyManager) public {
36         owner = msg.sender;
37         ownerWallet = msg.sender;
38         bountyManager = _bountyManager;
39     }
40 
41     /**
42      * @dev Modifiers
43      */
44      
45     modifier onlyOwner() {
46         require(msg.sender == owner);
47         _;
48     }
49 
50     modifier onlyBountyManager() {
51         require(msg.sender == bountyManager);
52         _;
53 	}
54 
55     /**
56      * @dev Allows current owner to transfer control of the contract to a newOwner.
57      * @param newOwner The address to transfer ownership to.
58      * @param newOwnerWallet The address to transfer ownership to.
59      */
60     function transferOwnership(address newOwner, address newOwnerWallet) public onlyOwner {
61         require(newOwner != address(0));
62         emit OwnershipTransferred(owner, newOwner);
63         owner = newOwner;
64         ownerWallet = newOwnerWallet;
65     }
66 
67     /**
68      * @dev Investments
69      */
70     function () external payable {
71         require(msg.value >= minimum);
72         if (investments[msg.sender] > 0){
73             if (withdraw()){
74                 withdrawals[msg.sender] = 0;
75             }
76         }
77         investments[msg.sender] = investments[msg.sender].add(msg.value);
78         joined[msg.sender] = block.timestamp;
79         ownerWallet.transfer(msg.value.div(100).mul(5));
80         promoter.transfer(msg.value.div(100).mul(5));
81         emit Invest(msg.sender, msg.value);
82     }
83 
84     /**
85     * @dev Evaluate current balance
86     * @param _address Address of investor
87     */
88     function getBalance(address _address) view public returns (uint256) {
89         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
90         uint256 percent = investments[_address].mul(step).div(100);
91         uint256 different = percent.mul(minutesCount).div(720);
92         uint256 balance = different.sub(withdrawals[_address]);
93 
94         return balance;
95     }
96 
97     /**
98     * @dev Withdraw dividends from contract
99     */
100     function withdraw() public returns (bool){
101         require(joined[msg.sender] > 0);
102         uint256 balance = getBalance(msg.sender);
103         if (address(this).balance > balance){
104             if (balance > 0){
105                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
106                 msg.sender.transfer(balance);
107                 emit Withdraw(msg.sender, balance);
108             }
109             return true;
110         } else {
111             return false;
112         }
113     }
114     
115     /**
116     * @dev Bounty reward
117     */
118     function bounty() public {
119         uint256 refBalance = checkReferral(msg.sender);
120         if(refBalance >= minimum) {
121              if (address(this).balance > refBalance) {
122                 referrer[msg.sender] = 0;
123                 msg.sender.transfer(refBalance);
124                 emit Bounty(msg.sender, refBalance);
125              }
126         }
127     }
128 
129     /**
130     * @dev Gets balance of the sender address.
131     * @return An uint256 representing the amount owned by the msg.sender.
132     */
133     function checkBalance() public view returns (uint256) {
134         return getBalance(msg.sender);
135     }
136 
137     /**
138     * @dev Gets withdrawals of the specified address.
139     * @param _investor The address to query the the balance of.
140     * @return An uint256 representing the amount owned by the passed address.
141     */
142     function checkWithdrawals(address _investor) public view returns (uint256) {
143         return withdrawals[_investor];
144     }
145 
146     /**
147     * @dev Gets investments of the specified address.
148     * @param _investor The address to query the the balance of.
149     * @return An uint256 representing the amount owned by the passed address.
150     */
151     function checkInvestments(address _investor) public view returns (uint256) {
152         return investments[_investor];
153     }
154 
155     /**
156     * @dev Gets referrer balance of the specified address.
157     * @param _hunter The address of the referrer
158     * @return An uint256 representing the referral earnings.
159     */
160     function checkReferral(address _hunter) public view returns (uint256) {
161         return referrer[_hunter];
162     }
163     
164     /**
165     * @dev Updates referrer balance 
166     * @param _hunter The address of the referrer
167     * @param _amount An uint256 representing the referral earnings.
168     */
169     function updateReferral(address _hunter, uint256 _amount) onlyBountyManager public {
170         referrer[_hunter] = referrer[_hunter].add(_amount);
171     }
172     
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