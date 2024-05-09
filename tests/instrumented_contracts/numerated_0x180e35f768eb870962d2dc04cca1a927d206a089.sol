1 pragma solidity ^0.4.24;
2 
3 /*
4     Lucky 7 - https://luckyseven.me/
5     7% Daily from your investment!
6 */
7 contract LuckySeven {
8 
9     using SafeMath for uint256;
10 
11     mapping(address => uint256) investments;
12     mapping(address => uint256) joined;
13     mapping(address => uint256) withdrawals;
14     mapping(address => uint256) referrer;
15 
16     uint256 public step = 7;
17     uint256 public minimum = 10 finney;
18     uint256 public stakingRequirement = 0.5 ether;
19     // wallet for charity - GiveEth https://giveth.io/
20     address public charityWallet = 0x5ADF43DD006c6C36506e2b2DFA352E60002d22Dc;
21     address public ownerWallet;
22     address public owner;
23     bool public gameStarted;
24 
25     event Invest(address investor, uint256 amount);
26     event Withdraw(address investor, uint256 amount);
27     event Bounty(address hunter, uint256 amount);
28     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29 
30     /**
31      * @dev Сonstructor Sets the original roles of the contract
32      */
33 
34     constructor() public {
35         owner = msg.sender;
36         ownerWallet = msg.sender;
37     }
38 
39     /**
40      * @dev Modifiers
41      */
42 
43     modifier onlyOwner() {
44         require(msg.sender == owner);
45         _;
46     }
47 
48     function startGame() public onlyOwner {
49         gameStarted = true;
50     }
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
67     function () public payable {
68         buy(0x0);
69     }
70 
71     function buy(address _referredBy) public payable {
72         require(msg.value >= minimum);
73         require(gameStarted);
74 
75         address _customerAddress = msg.sender;
76 
77         if(
78            // is this a referred purchase?
79            _referredBy != 0x0000000000000000000000000000000000000000 &&
80 
81            // no cheating!
82            _referredBy != _customerAddress &&
83 
84            // does the referrer have at least X whole tokens?
85            // i.e is the referrer a godly chad masternode
86            investments[_referredBy] >= stakingRequirement
87        ){
88            // wealth redistribution
89            referrer[_referredBy] = referrer[_referredBy].add(msg.value.mul(7).div(100));
90        }
91 
92        if (investments[msg.sender] > 0){
93            if (withdraw()){
94                withdrawals[msg.sender] = 0;
95            }
96        }
97        investments[msg.sender] = investments[msg.sender].add(msg.value);
98        joined[msg.sender] = block.timestamp;
99        
100        // 4% dev fee and 1% to GiveEth
101        ownerWallet.transfer(msg.value.mul(4).div(100));
102        charityWallet.transfer(msg.value.mul(1).div(100));
103        emit Invest(msg.sender, msg.value);
104     }
105 
106     /**
107     * @dev Evaluate current balance
108     * @param _address Address of investor
109     */
110     function getBalance(address _address) view public returns (uint256) {
111         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
112         uint256 percent = investments[_address].mul(step).div(100);
113         uint256 different = percent.mul(minutesCount).div(1440);
114         uint256 balance = different.sub(withdrawals[_address]);
115 
116         return balance;
117     }
118 
119     /**
120     * @dev Withdraw dividends from contract
121     */
122     function withdraw() public returns (bool){
123         require(joined[msg.sender] > 0);
124         uint256 balance = getBalance(msg.sender);
125         if (address(this).balance > balance){
126             if (balance > 0){
127                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
128                 msg.sender.transfer(balance);
129                 emit Withdraw(msg.sender, balance);
130             }
131             return true;
132         } else {
133             return false;
134         }
135     }
136 
137     /**
138     * @dev Bounty reward
139     */
140     function bounty() public {
141         uint256 refBalance = checkReferral(msg.sender);
142         if(refBalance >= minimum) {
143              if (address(this).balance > refBalance) {
144                 referrer[msg.sender] = 0;
145                 msg.sender.transfer(refBalance);
146                 emit Bounty(msg.sender, refBalance);
147              }
148         }
149     }
150 
151     /**
152     * @dev Gets balance of the sender address.
153     * @return An uint256 representing the amount owned by the msg.sender.
154     */
155     function checkBalance() public view returns (uint256) {
156         return getBalance(msg.sender);
157     }
158 
159     /**
160     * @dev Gets withdrawals of the specified address.
161     * @param _investor The address to query the the balance of.
162     * @return An uint256 representing the amount owned by the passed address.
163     */
164     function checkWithdrawals(address _investor) public view returns (uint256) {
165         return withdrawals[_investor];
166     }
167 
168     /**
169     * @dev Gets investments of the specified address.
170     * @param _investor The address to query the the balance of.
171     * @return An uint256 representing the amount owned by the passed address.
172     */
173     function checkInvestments(address _investor) public view returns (uint256) {
174         return investments[_investor];
175     }
176 
177     /**
178     * @dev Gets referrer balance of the specified address.
179     * @param _hunter The address of the referrer
180     * @return An uint256 representing the referral earnings.
181     */
182     function checkReferral(address _hunter) public view returns (uint256) {
183         return referrer[_hunter];
184     }
185 }
186 
187 /**
188  * @title SafeMath
189  * @dev Math operations with safety checks that throw on error
190  */
191 library SafeMath {
192     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
193         if (a == 0) {
194             return 0;
195         }
196         uint256 c = a * b;
197         assert(c / a == b);
198         return c;
199     }
200 
201     function div(uint256 a, uint256 b) internal pure returns (uint256) {
202         // assert(b > 0); // Solidity automatically throws when dividing by 0
203         uint256 c = a / b;
204         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
205         return c;
206     }
207 
208     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
209         assert(b <= a);
210         return a - b;
211     }
212 
213     function add(uint256 a, uint256 b) internal pure returns (uint256) {
214         uint256 c = a + b;
215         assert(c >= a);
216         return c;
217     }
218 }