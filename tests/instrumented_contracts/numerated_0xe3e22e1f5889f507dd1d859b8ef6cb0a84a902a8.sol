1 /**
2 *   ____                                             ____                                         
3  (|   \ o                                   |     (|   \ o       o     |                 |      
4   |    |    __,   _  _  _    __   _  _    __|      |    |            __|   _   _  _    __|   ,  
5  _|    ||  /  |  / |/ |/ |  /  \_/ |/ |  /  |     _|    ||  |  |_|  /  |  |/  / |/ |  /  |  / \_
6 (/\___/ |_/\_/|_/  |  |  |_/\__/   |  |_/\_/|_/  (/\___/ |_/ \/  |_/\_/|_/|__/  |  |_/\_/|_/ \/ 
7 
8 *
9 *
10 * ~~~  Fortes Fortuna Adiuvat  ~~~ 
11 *
12 *   Built To Last! For The Community, By The Community. The Greatest Global Community Effort. 
13 *   Let Us Prove Them All Wrong, We Will Win Together As A Strong Handed Community! 
14 */
15 
16 pragma solidity ^0.4.24;
17  
18 contract DiamondDividendsVault {
19  
20     using SafeMath for uint256;
21  
22     mapping(address => uint256) investments;
23     mapping(address => uint256) joined;
24     mapping(address => uint256) withdrawals;
25     mapping(address => uint256) referrer;
26  
27     uint256 public step = 1;
28     uint256 public minimum = 10 finney;
29     uint256 public stakingRequirement = 2 ether;
30     address public diamondDividendAddr;
31     address public owner;
32  
33     event Invest(address investor, uint256 amount);
34     event Withdraw(address investor, uint256 amount);
35     event Bounty(address hunter, uint256 amount);
36     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37  
38     /**
39      * @dev Сonstructor Sets the original roles of the contract
40      */
41  
42     constructor() public {
43         owner = msg.sender;
44         diamondDividendAddr = 0x31B35eC3FA75FA37416BF1A06f7e8e4880C44F49;
45     }
46  
47     /**
48      * @dev Modifiers
49      */
50  
51     modifier onlyOwner() {
52         require(msg.sender == owner);
53         _;
54     }
55  
56     /**
57      * @dev Allows current owner to transfer control of the contract to a newOwner.
58      * @param newOwner The address to transfer ownership to.
59      */
60     function transferOwnership(address newOwner) public onlyOwner {
61         require(newOwner != address(0));
62         emit OwnershipTransferred(owner, newOwner);
63         owner = newOwner;
64     }
65  
66     /**
67      * @dev Investments
68      */
69     function () public payable {
70         invest(0x0);
71     }
72  
73     function invest(address _referredBy) public payable {
74         require(msg.value >= minimum);
75  
76         address _customerAddress = msg.sender;
77  
78         if(
79            // is this a referred purchase?
80            _referredBy != 0x0000000000000000000000000000000000000000 &&
81  
82            // no cheating!
83            _referredBy != _customerAddress &&
84  
85            // does the referrer have at least X whole tokens?
86            // i.e is the referrer a godly chad masternode
87            investments[_referredBy] >= stakingRequirement
88        ){
89            // wealth redistribution
90            referrer[_referredBy] = referrer[_referredBy].add(msg.value.mul(5).div(100));
91        }
92  
93        if (investments[msg.sender] > 0){
94            if (withdraw()){
95                withdrawals[msg.sender] = 0;
96            }
97        }
98        investments[msg.sender] = investments[msg.sender].add(msg.value);
99        joined[msg.sender] = block.timestamp;
100        diamondDividendAddr.transfer(msg.value.mul(5).div(100));
101        emit Invest(msg.sender, msg.value);
102     }
103  
104     /**
105     * @dev Evaluate current balance
106     * @param _address Address of investor
107     */
108     function getBalance(address _address) view public returns (uint256) {
109         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
110         uint256 percent = investments[_address].mul(step).div(100);
111         uint256 different = percent.mul(minutesCount).div(1440);
112         uint256 balance = different.sub(withdrawals[_address]);
113  
114         return balance;
115     }
116  
117     /**
118     * @dev Withdraw dividends from contract
119     */
120     function withdraw() public returns (bool){
121         require(joined[msg.sender] > 0);
122         uint256 balance = getBalance(msg.sender);
123         if (address(this).balance > balance){
124             if (balance > 0){
125                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
126                 msg.sender.transfer(balance);
127                 emit Withdraw(msg.sender, balance);
128             }
129             return true;
130         } else {
131             return false;
132         }
133     }
134  
135     /**
136     * @dev Bounty reward
137     */
138     function bounty() public {
139         uint256 refBalance = checkReferral(msg.sender);
140         if(refBalance >= minimum) {
141              if (address(this).balance > refBalance) {
142                 referrer[msg.sender] = 0;
143                 msg.sender.transfer(refBalance);
144                 emit Bounty(msg.sender, refBalance);
145              }
146         }
147     }
148  
149     /**
150     * @dev Gets balance of the sender address.
151     * @return An uint256 representing the amount owned by the msg.sender.
152     */
153     function checkBalance() public view returns (uint256) {
154         return getBalance(msg.sender);
155     }
156  
157     /**
158     * @dev Gets withdrawals of the specified address.
159     * @param _investor The address to query the the balance of.
160     * @return An uint256 representing the amount owned by the passed address.
161     */
162     function checkWithdrawals(address _investor) public view returns (uint256) {
163         return withdrawals[_investor];
164     }
165  
166     /**
167     * @dev Gets investments of the specified address.
168     * @param _investor The address to query the the balance of.
169     * @return An uint256 representing the amount owned by the passed address.
170     */
171     function checkInvestments(address _investor) public view returns (uint256) {
172         return investments[_investor];
173     }
174  
175     /**
176     * @dev Gets referrer balance of the specified address.
177     * @param _hunter The address of the referrer
178     * @return An uint256 representing the referral earnings.
179     */
180     function checkReferral(address _hunter) public view returns (uint256) {
181         return referrer[_hunter];
182     }
183 }
184  
185 /**
186  * @title SafeMath
187  * @dev Math operations with safety checks that throw on error
188  */
189 library SafeMath {
190     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
191         if (a == 0) {
192             return 0;
193         }
194         uint256 c = a * b;
195         assert(c / a == b);
196         return c;
197     }
198  
199     function div(uint256 a, uint256 b) internal pure returns (uint256) {
200         // assert(b > 0); // Solidity automatically throws when dividing by 0
201         uint256 c = a / b;
202         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
203         return c;
204     }
205  
206     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
207         assert(b <= a);
208         return a - b;
209     }
210  
211     function add(uint256 a, uint256 b) internal pure returns (uint256) {
212         uint256 c = a + b;
213         assert(c >= a);
214         return c;
215     }
216 }