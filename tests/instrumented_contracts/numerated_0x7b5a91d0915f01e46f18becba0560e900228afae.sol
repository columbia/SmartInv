1 pragma solidity ^0.4.24;
2 
3 /*
4     Lucky 7 - https://luckyseven.me/
5     7% Daily from your investment! Small dev fee - 3.5%,
6 */
7 
8 contract LuckySeven {
9 
10     using SafeMath for uint256;
11 
12     mapping(address => uint256) investments;
13     mapping(address => uint256) joined;
14     mapping(address => uint256) withdrawals;
15     mapping(address => uint256) referrer;
16 
17     uint256 public step = 7;
18     uint256 public minimum = 10 finney;
19     uint256 public stakingRequirement = 0.5 ether;
20     address public ownerWallet;
21     address public owner;
22     bool public gameStarted;
23 
24     event Invest(address investor, uint256 amount);
25     event Withdraw(address investor, uint256 amount);
26     event Bounty(address hunter, uint256 amount);
27     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29     /**
30      * @dev Сonstructor Sets the original roles of the contract
31      */
32 
33     constructor() public {
34         owner = msg.sender;
35         ownerWallet = msg.sender;
36     }
37 
38     /**
39      * @dev Modifiers
40      */
41     modifier onlyOwner() {
42         require(msg.sender == owner);
43         _;
44     }
45 
46     function startGame() public onlyOwner {
47         gameStarted = true;
48     }
49 
50     /**
51      * @dev Allows current owner to transfer control of the contract to a newOwner.
52      * @param newOwner The address to transfer ownership to.
53      * @param newOwnerWallet The address to transfer ownership to.
54      */
55     function transferOwnership(address newOwner, address newOwnerWallet) public onlyOwner {
56         require(newOwner != address(0));
57         emit OwnershipTransferred(owner, newOwner);
58         owner = newOwner;
59         ownerWallet = newOwnerWallet;
60     }
61 
62     /**
63      * @dev Investments
64      */
65     function () public payable {
66         buy(0x0);
67     }
68 
69     function buy(address _referredBy) public payable {
70         require(msg.value >= minimum);
71         require(gameStarted);
72 
73         address _customerAddress = msg.sender;
74 
75         if(
76            // is this a referred purchase?
77            _referredBy != 0x0000000000000000000000000000000000000000 &&
78 
79            // no cheating!
80            _referredBy != _customerAddress &&
81 
82            // does the referrer have at least X whole tokens?
83            // i.e is the referrer a godly chad masternode
84            investments[_referredBy] >= stakingRequirement
85        ){
86            // wealth redistribution
87            referrer[_referredBy] = referrer[_referredBy].add(msg.value.mul(85).div(1000));
88        }
89 
90        if (investments[msg.sender] > 0){
91            if (withdraw()){
92                withdrawals[msg.sender] = 0;
93            }
94        }
95        investments[msg.sender] = investments[msg.sender].add(msg.value);
96        joined[msg.sender] = block.timestamp;
97        
98        // 3.5% dev fee
99        ownerWallet.transfer(msg.value.mul(35).div(1000));
100        emit Invest(msg.sender, msg.value);
101     }
102 
103     /**
104     * @dev Evaluate current balance
105     * @param _address Address of investor
106     */
107     function getBalance(address _address) view public returns (uint256) {
108         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
109         uint256 percent = investments[_address].mul(step).div(100);
110         uint256 different = percent.mul(minutesCount).div(1440);
111         uint256 balance = different.sub(withdrawals[_address]);
112 
113         return balance;
114     }
115 
116     /**
117     * @dev Withdraw dividends from contract
118     */
119     function withdraw() public returns (bool){
120         require(joined[msg.sender] > 0);
121         uint256 balance = getBalance(msg.sender);
122         if (address(this).balance > balance){
123             if (balance > 0){
124                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
125                 msg.sender.transfer(balance);
126                 emit Withdraw(msg.sender, balance);
127             }
128             return true;
129         } else {
130             return false;
131         }
132     }
133 
134     /**
135     * @dev Bounty reward
136     */
137     function bounty() public {
138         uint256 refBalance = checkReferral(msg.sender);
139         if(refBalance >= minimum) {
140              if (address(this).balance > refBalance) {
141                 referrer[msg.sender] = 0;
142                 msg.sender.transfer(refBalance);
143                 emit Bounty(msg.sender, refBalance);
144              }
145         }
146     }
147 
148     /**
149     * @dev Gets balance of the sender address.
150     * @return An uint256 representing the amount owned by the msg.sender.
151     */
152     function checkBalance() public view returns (uint256) {
153         return getBalance(msg.sender);
154     }
155 
156     /**
157     * @dev Gets withdrawals of the specified address.
158     * @param _investor The address to query the the balance of.
159     * @return An uint256 representing the amount owned by the passed address.
160     */
161     function checkWithdrawals(address _investor) public view returns (uint256) {
162         return withdrawals[_investor];
163     }
164 
165     /**
166     * @dev Gets investments of the specified address.
167     * @param _investor The address to query the the balance of.
168     * @return An uint256 representing the amount owned by the passed address.
169     */
170     function checkInvestments(address _investor) public view returns (uint256) {
171         return investments[_investor];
172     }
173 
174     /**
175     * @dev Gets referrer balance of the specified address.
176     * @param _hunter The address of the referrer
177     * @return An uint256 representing the referral earnings.
178     */
179     function checkReferral(address _hunter) public view returns (uint256) {
180         return referrer[_hunter];
181     }
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