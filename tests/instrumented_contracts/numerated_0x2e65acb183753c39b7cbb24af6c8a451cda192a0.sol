1 pragma solidity ^0.4.24;
2 
3 /**
4  *
5  * Infinite3 Contract
6  *  - GAIN 3% EVERY 24 HOURS (every 5900 blocks)
7  *  - 0.5% for Promotion on your investment (every ether stays on contract's balance)
8  *  - 0.5% dev commision
9  *  - 10% affliate commision 
10  *  - 89% Payout commision 
11  *
12  * How to use:
13  *  1. Send any amount of ether to make an investment(minimum 0.01)
14  *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)
15  *  OR
16  *  2b. Send more ether to reinvest AND get your profit at the same time
17  *
18  * RECOMMENDED GAS LIMIT: 100000000000000000000
19  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
20  * https://infinite3.life
21  * https://discord.gg/qnjcFWq
22  * Contract reviewed and approved by professionals!
23  *
24  */
25 
26 contract Infinite3{
27     
28     using SafeMath for uint256;
29 
30     mapping(address => uint256) investments;
31     mapping(address => uint256) joined;
32     mapping(address => uint256) withdrawals;
33     mapping(address => uint256) referrer;
34 
35     uint256 public minimum = 10000000000000000;
36     uint256 public step = 3;
37     address public ownerWallet;
38     address public owner;
39     address public bountyManager;
40     address promoter = 0xf8EeAe7abe051A0B7a4ec5758af411F870A8Add3;
41 
42     event Invest(address investor, uint256 amount);
43     event Withdraw(address investor, uint256 amount);
44     event Bounty(address hunter, uint256 amount);
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46     
47     /**
48      * @dev Сonstructor Sets the original roles of the contract 
49      */
50      
51     constructor(address _bountyManager) public {
52         owner = msg.sender;
53         ownerWallet = msg.sender;
54         bountyManager = _bountyManager;
55     }
56 
57     /**
58      * @dev Modifiers
59      */
60      
61     modifier onlyOwner() {
62         require(msg.sender == owner);
63         _;
64     }
65 
66     modifier onlyBountyManager() {
67         require(msg.sender == bountyManager);
68         _;
69 	}
70 
71     /**
72      * @dev Allows current owner to transfer control of the contract to a newOwner.
73      * @param newOwner The address to transfer ownership to.
74      * @param newOwnerWallet The address to transfer ownership to.
75      */
76     function transferOwnership(address newOwner, address newOwnerWallet) public onlyOwner {
77         require(newOwner != address(0));
78         emit OwnershipTransferred(owner, newOwner);
79         owner = newOwner;
80         ownerWallet = newOwnerWallet;
81     }
82 
83     /**
84      * @dev Investments
85      */
86     function () external payable {
87         require(msg.value >= minimum);
88         if (investments[msg.sender] > 0){
89             if (withdraw()){
90                 withdrawals[msg.sender] = 0;
91             }
92         }
93         investments[msg.sender] = investments[msg.sender].add(msg.value);
94         joined[msg.sender] = block.timestamp;
95         ownerWallet.transfer(msg.value.div(1000).mul(5));
96         promoter.transfer(msg.value.div(1000).mul(5));
97         emit Invest(msg.sender, msg.value);
98     }
99 
100     /**
101     * @dev Evaluate current balance
102     * @param _address Address of investor
103     */
104     function getBalance(address _address) view public returns (uint256) {
105         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
106         uint256 percent = investments[_address].mul(step).div(100);
107         uint256 different = percent.mul(minutesCount).div(1440);
108         uint256 balance = different.sub(withdrawals[_address]);
109 
110         return balance;
111     }
112 
113     /**
114     * @dev Withdraw dividends from contract
115     */
116     function withdraw() public returns (bool){
117         require(joined[msg.sender] > 0);
118         uint256 balance = getBalance(msg.sender);
119         if (address(this).balance > balance){
120             if (balance > 0){
121                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
122                 msg.sender.transfer(balance);
123                 emit Withdraw(msg.sender, balance);
124             }
125             return true;
126         } else {
127             return false;
128         }
129     }
130     
131     /**
132     * @dev Bounty reward
133     */
134     function bounty() public {
135         uint256 refBalance = checkReferral(msg.sender);
136         if(refBalance >= minimum) {
137              if (address(this).balance > refBalance) {
138                 referrer[msg.sender] = 0;
139                 msg.sender.transfer(refBalance);
140                 emit Bounty(msg.sender, refBalance);
141              }
142         }
143     }
144 
145     /**
146     * @dev Gets balance of the sender address.
147     * @return An uint256 representing the amount owned by the msg.sender.
148     */
149     function checkBalance() public view returns (uint256) {
150         return getBalance(msg.sender);
151     }
152 
153     /**
154     * @dev Gets withdrawals of the specified address.
155     * @param _investor The address to query the the balance of.
156     * @return An uint256 representing the amount owned by the passed address.
157     */
158     function checkWithdrawals(address _investor) public view returns (uint256) {
159         return withdrawals[_investor];
160     }
161 
162     /**
163     * @dev Gets investments of the specified address.
164     * @param _investor The address to query the the balance of.
165     * @return An uint256 representing the amount owned by the passed address.
166     */
167     function checkInvestments(address _investor) public view returns (uint256) {
168         return investments[_investor];
169     }
170 
171     /**
172     * @dev Gets referrer balance of the specified address.
173     * @param _hunter The address of the referrer
174     * @return An uint256 representing the referral earnings.
175     */
176     function checkReferral(address _hunter) public view returns (uint256) {
177         return referrer[_hunter];
178     }
179     
180     /**
181     * @dev Updates referrer balance 
182     * @param _hunter The address of the referrer
183     * @param _amount An uint256 representing the referral earnings.
184     */
185     function updateReferral(address _hunter, uint256 _amount) onlyBountyManager public {
186         referrer[_hunter] = referrer[_hunter].add(_amount);
187     }
188     
189 }
190 
191 /**
192  * @title SafeMath
193  * @dev Math operations with safety checks that throw on error
194  */
195 library SafeMath {
196     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
197         if (a == 0) {
198             return 0;
199         }
200         uint256 c = a * b;
201         assert(c / a == b);
202         return c;
203     }
204 
205     function div(uint256 a, uint256 b) internal pure returns (uint256) {
206         // assert(b > 0); // Solidity automatically throws when dividing by 0
207         uint256 c = a / b;
208         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
209         return c;
210     }
211 
212     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
213         assert(b <= a);
214         return a - b;
215     }
216 
217     function add(uint256 a, uint256 b) internal pure returns (uint256) {
218         uint256 c = a + b;
219         assert(c >= a);
220         return c;
221     }
222 }