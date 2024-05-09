1 pragma solidity ^0.4.25;
2 
3 /**
4 Triple ROI: https://12hourtrains.github.io/
5 
6 Earn 4% per 3 hours, triple your ROI every 3 hours you HODL!
7 
8 3 hours: 4%
9 6 hours: 12%
10 9 hours: 36%
11 12 hours: 108%
12 ...etc...
13 
14 */
15 contract TripleROI {
16 
17     using SafeMath for uint256;
18 
19     mapping(address => uint256) investments;
20     mapping(address => uint256) joined;
21     mapping(address => uint256) referrer;
22 
23     uint256 public step = 1000;
24     uint256 public minimum = 10 finney;
25     uint256 public maximum = 5 ether;
26     uint256 public stakingRequirement = 0.3 ether;
27     address public ownerWallet;
28     address public owner;
29     bool public gameStarted;
30 
31     event Invest(address investor, uint256 amount);
32     event Withdraw(address investor, uint256 amount);
33     event Bounty(address hunter, uint256 amount);
34     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36     /**
37      * @dev Сonstructor Sets the original roles of the contract
38      */
39 
40     constructor() public {
41         owner = msg.sender;
42         ownerWallet = msg.sender;
43     }
44 
45     /**
46      * @dev Modifiers
47      */
48 
49     modifier onlyOwner() {
50         require(msg.sender == owner);
51         _;
52     }
53 
54     function startGame() public onlyOwner {
55         gameStarted = true;
56     }
57 
58     /**
59      * @dev Allows current owner to transfer control of the contract to a newOwner.
60      * @param newOwner The address to transfer ownership to.
61      * @param newOwnerWallet The address to transfer ownership to.
62      */
63     function transferOwnership(address newOwner, address newOwnerWallet) public onlyOwner {
64         require(newOwner != address(0));
65         emit OwnershipTransferred(owner, newOwner);
66         owner = newOwner;
67         ownerWallet = newOwnerWallet;
68     }
69 
70     /**
71      * @dev Investments
72      */
73     function () public payable {
74         buy(0x0);
75     }
76 
77     function buy(address _referredBy) public payable {
78         require(msg.value >= minimum);
79         require(msg.value <= maximum);
80         require(gameStarted);
81 
82         address _customerAddress = msg.sender;
83 
84         if(
85            // is this a referred purchase?
86            _referredBy != 0x0000000000000000000000000000000000000000 &&
87 
88            // no cheating!
89            _referredBy != _customerAddress &&
90 
91            // does the referrer have at least X whole tokens?
92            // i.e is the referrer a godly chad masternode
93            investments[_referredBy] >= stakingRequirement
94        ){
95            // wealth redistribution
96            referrer[_referredBy] = referrer[_referredBy].add(msg.value.mul(5).div(100));
97        }
98 
99        if (investments[msg.sender] > 0){
100            withdraw();
101        }
102        
103        investments[msg.sender] = investments[msg.sender].add(msg.value);
104        joined[msg.sender] = block.timestamp;
105        ownerWallet.transfer(msg.value.mul(5).div(100));
106        emit Invest(msg.sender, msg.value);
107     }
108 
109     /**
110     * @dev Evaluate current balance
111     * @param _address Address of investor
112     */
113     function getBalance(address _address) view public returns (uint256) {
114         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
115         
116         // update roi multiplier
117         // 4% flat during first 3 hours
118         // 12% flat during 6 hours
119         // 36% flat during 9 hours
120         // 108% flat after 12 hours
121         uint256 userROIMultiplier = 3**(minutesCount / 180);
122         
123         uint256 percent;
124         uint256 balance;
125         
126         for(uint i=1; i<userROIMultiplier; i=i*3){
127             // add each percent -
128             // 4% flat during first 3 hours
129             // 12% flat during 6 hours
130             // 36% flat during 9 hours
131             // 108% flat after 12 hours
132             // etc - add all these up
133             percent = investments[_address].mul(step).div(1000) * i;
134             balance += percent.mul(60).div(1500);
135         }
136         
137         // Finally, add the balance for the current multiplier
138         percent = investments[_address].mul(step).div(1000) * userROIMultiplier;
139         balance += percent.mul(minutesCount % 60).div(1500);
140 
141         return balance;
142     }
143 
144     /**
145     * @dev Withdraw dividends from contract
146     */
147     function withdraw() public returns (bool){
148         require(joined[msg.sender] > 0);
149         
150         uint256 balance = getBalance(msg.sender);
151         
152         // Reset ROI mulitplier of user
153         joined[msg.sender] = block.timestamp;
154         
155         if (address(this).balance > balance){
156             if (balance > 0){
157                 msg.sender.transfer(balance);
158                 emit Withdraw(msg.sender, balance);
159             }
160             return true;
161         } else {
162             if (balance > 0) {
163                 msg.sender.transfer(address(this).balance);
164                 emit Withdraw(msg.sender, balance);
165             }
166             return true;
167         }
168     }
169 
170     /**
171     * @dev Bounty reward
172     */
173     function bounty() public {
174         uint256 refBalance = checkReferral(msg.sender);
175         if(refBalance >= minimum) {
176              if (address(this).balance > refBalance) {
177                 referrer[msg.sender] = 0;
178                 msg.sender.transfer(refBalance);
179                 emit Bounty(msg.sender, refBalance);
180              }
181         }
182     }
183 
184     /**
185     * @dev Gets balance of the sender address.
186     * @return An uint256 representing the amount owned by the msg.sender.
187     */
188     function checkBalance() public view returns (uint256) {
189         return getBalance(msg.sender);
190     }
191 
192 
193     /**
194     * @dev Gets investments of the specified address.
195     * @param _investor The address to query the the balance of.
196     * @return An uint256 representing the amount owned by the passed address.
197     */
198     function checkInvestments(address _investor) public view returns (uint256) {
199         return investments[_investor];
200     }
201 
202     /**
203     * @dev Gets referrer balance of the specified address.
204     * @param _hunter The address of the referrer
205     * @return An uint256 representing the referral earnings.
206     */
207     function checkReferral(address _hunter) public view returns (uint256) {
208         return referrer[_hunter];
209     }
210 }
211 
212 /**
213  * @title SafeMath
214  * @dev Math operations with safety checks that throw on error
215  */
216 library SafeMath {
217     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
218         if (a == 0) {
219             return 0;
220         }
221         uint256 c = a * b;
222         assert(c / a == b);
223         return c;
224     }
225 
226     function div(uint256 a, uint256 b) internal pure returns (uint256) {
227         // assert(b > 0); // Solidity automatically throws when dividing by 0
228         uint256 c = a / b;
229         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
230         return c;
231     }
232 
233     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
234         assert(b <= a);
235         return a - b;
236     }
237 
238     function add(uint256 a, uint256 b) internal pure returns (uint256) {
239         uint256 c = a + b;
240         assert(c >= a);
241         return c;
242     }
243 }