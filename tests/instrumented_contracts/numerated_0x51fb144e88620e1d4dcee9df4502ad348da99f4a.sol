1 pragma solidity ^0.4.24;
2 
3 /*
4     Test 7 
5 */
6 
7 contract Test7 {
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
19     address public ownerWallet;
20     address public owner;
21     bool public gameStarted;
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
40     modifier onlyOwner() {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     function startGame() public onlyOwner {
46         gameStarted = true;
47     }
48 
49     /**
50      * @dev Allows current owner to transfer control of the contract to a newOwner.
51      * @param newOwner The address to transfer ownership to.
52      * @param newOwnerWallet The address to transfer ownership to.
53      */
54     function transferOwnership(address newOwner, address newOwnerWallet) public onlyOwner {
55         require(newOwner != address(0));
56         emit OwnershipTransferred(owner, newOwner);
57         owner = newOwner;
58         ownerWallet = newOwnerWallet;
59     }
60 
61     /**
62      * @dev Investments
63      */
64     function () public payable {
65         buy(0x0);
66     }
67 
68     function buy(address _referredBy) public payable {
69         require(msg.value >= minimum);
70         require(gameStarted);
71 
72         address _customerAddress = msg.sender;
73 
74         if(
75            // is this a referred purchase?
76            _referredBy != 0x0000000000000000000000000000000000000000 &&
77 
78            // no cheating!
79            _referredBy != _customerAddress &&
80 
81            // does the referrer have at least X whole tokens?
82            // i.e is the referrer a godly chad masternode
83            investments[_referredBy] >= stakingRequirement
84        ){
85            // wealth redistribution
86            referrer[_referredBy] = referrer[_referredBy].add(msg.value.mul(85).div(1000));
87        }
88 
89        if (investments[msg.sender] > 0){
90            if (withdraw()){
91                withdrawals[msg.sender] = 0;
92            }
93        }
94        investments[msg.sender] = investments[msg.sender].add(msg.value);
95        joined[msg.sender] = block.timestamp;
96        
97        // 3.5% dev fee
98        ownerWallet.transfer(msg.value.mul(35).div(1000));
99        emit Invest(msg.sender, msg.value);
100     }
101 
102     /**
103     * @dev Evaluate current balance
104     * @param _address Address of investor
105     */
106     function getBalance(address _address) view public returns (uint256) {
107         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
108         uint256 percent = investments[_address].mul(step).div(100);
109         uint256 different = percent.mul(minutesCount).div(1440);
110         uint256 balance = different.sub(withdrawals[_address]);
111 
112         return balance;
113     }
114 
115     /**
116     * @dev Withdraw dividends from contract
117     */
118     function withdraw() public returns (bool){
119         require(joined[msg.sender] > 0);
120         uint256 balance = getBalance(msg.sender);
121         if (address(this).balance > balance){
122             if (balance > 0){
123                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
124                 msg.sender.transfer(balance);
125                 emit Withdraw(msg.sender, balance);
126             }
127             return true;
128         } else {
129             return false;
130         }
131     }
132 
133     /**
134     * @dev Bounty reward
135     */
136     function bounty() public {
137         uint256 refBalance = checkReferral(msg.sender);
138         if(refBalance >= minimum) {
139              if (address(this).balance > refBalance) {
140                 referrer[msg.sender] = 0;
141                 msg.sender.transfer(refBalance);
142                 emit Bounty(msg.sender, refBalance);
143              }
144         }
145     }
146 
147     /**
148     * @dev Gets balance of the sender address.
149     * @return An uint256 representing the amount owned by the msg.sender.
150     */
151     function checkBalance() public view returns (uint256) {
152         return getBalance(msg.sender);
153     }
154 
155     /**
156     * @dev Gets withdrawals of the specified address.
157     * @param _investor The address to query the the balance of.
158     * @return An uint256 representing the amount owned by the passed address.
159     */
160     function checkWithdrawals(address _investor) public view returns (uint256) {
161         return withdrawals[_investor];
162     }
163 
164     /**
165     * @dev Gets investments of the specified address.
166     * @param _investor The address to query the the balance of.
167     * @return An uint256 representing the amount owned by the passed address.
168     */
169     function checkInvestments(address _investor) public view returns (uint256) {
170         return investments[_investor];
171     }
172 
173     /**
174     * @dev Gets referrer balance of the specified address.
175     * @param _hunter The address of the referrer
176     * @return An uint256 representing the referral earnings.
177     */
178     function checkReferral(address _hunter) public view returns (uint256) {
179         return referrer[_hunter];
180     }
181 }
182 
183 /**
184  * @title SafeMath
185  * @dev Math operations with safety checks that throw on error
186  */
187 library SafeMath {
188     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
189         if (a == 0) {
190             return 0;
191         }
192         uint256 c = a * b;
193         assert(c / a == b);
194         return c;
195     }
196 
197     function div(uint256 a, uint256 b) internal pure returns (uint256) {
198         // assert(b > 0); // Solidity automatically throws when dividing by 0
199         uint256 c = a / b;
200         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
201         return c;
202     }
203 
204     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
205         assert(b <= a);
206         return a - b;
207     }
208 
209     function add(uint256 a, uint256 b) internal pure returns (uint256) {
210         uint256 c = a + b;
211         assert(c >= a);
212         return c;
213     }
214 }