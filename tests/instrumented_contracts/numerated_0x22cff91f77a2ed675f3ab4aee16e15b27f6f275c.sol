1 pragma solidity ^0.4.24;
2 
3 /**
4 Double%
5 
6 Earn 10% per hour, double your %ROI every hour you HODL!
7 
8 First hour: 10%
9 Second hour: 20%
10 Third hour: 40%
11 ...etc...
12 
13 */
14 contract DoubleROI {
15 
16     using SafeMath for uint256;
17 
18     mapping(address => uint256) investments;
19     mapping(address => uint256) joined;
20     mapping(address => uint256) referrer;
21 
22     uint256 public step = 2400;
23     uint256 public minimum = 10 finney;
24     uint256 public maximum = 5 ether;
25     uint256 public stakingRequirement = 0.5 ether;
26     address public ownerWallet;
27     address public owner;
28 
29     event Invest(address investor, uint256 amount);
30     event Withdraw(address investor, uint256 amount);
31     event Bounty(address hunter, uint256 amount);
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34     /**
35      * @dev Сonstructor Sets the original roles of the contract
36      */
37 
38     constructor() public {
39         owner = msg.sender;
40         ownerWallet = msg.sender;
41     }
42 
43     /**
44      * @dev Modifiers
45      */
46 
47     modifier onlyOwner() {
48         require(msg.sender == owner);
49         _;
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
73         require(msg.value <= maximum);
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
89            referrer[_referredBy] = referrer[_referredBy].add(msg.value.mul(5).div(100));
90        }
91 
92        if (investments[msg.sender] > 0){
93            withdraw();
94        }
95        
96        investments[msg.sender] = investments[msg.sender].add(msg.value);
97        joined[msg.sender] = block.timestamp;
98        ownerWallet.transfer(msg.value.mul(5).div(100));
99        emit Invest(msg.sender, msg.value);
100     }
101 
102     /**
103     * @dev Evaluate current balance
104     * @param _address Address of investor
105     */
106     function getBalance(address _address) view public returns (uint256) {
107         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
108         
109         // update roi multiplier
110         // 10% flat during first hour
111         // 20% flat during second hour
112         // 40% flat during third hour
113         uint256 userROIMultiplier = 2**(minutesCount / 60);
114         
115         uint256 percent;
116         uint256 balance;
117         
118         for(uint i=1; i<userROIMultiplier; i=i*2){
119             // add each percent -
120             // first hour is 10%
121             // second hour is 20%
122             // third hour is 40%
123             // etc - add all these up
124             percent = investments[_address].mul(step).div(1000) * i;
125             balance += percent.mul(60).div(1440);
126             
127         }
128         
129         // Finally, add the balance for the current multiplier
130         percent = investments[_address].mul(step).div(1000) * userROIMultiplier;
131         balance += percent.mul(minutesCount % 60).div(1440);
132 
133         return balance;
134     }
135 
136     /**
137     * @dev Withdraw dividends from contract
138     */
139     function withdraw() public returns (bool){
140         require(joined[msg.sender] > 0);
141         
142         uint256 balance = getBalance(msg.sender);
143         
144         // Reset ROI mulitplier of user
145         joined[msg.sender] = block.timestamp;
146         
147         if (address(this).balance > balance){
148             if (balance > 0){
149                 msg.sender.transfer(balance);
150                 emit Withdraw(msg.sender, balance);
151             }
152             return true;
153         } else {
154             if (balance > 0) {
155                 msg.sender.transfer(address(this).balance);
156                 emit Withdraw(msg.sender, balance);
157             }
158             return true;
159         }
160     }
161 
162     /**
163     * @dev Bounty reward
164     */
165     function bounty() public {
166         uint256 refBalance = checkReferral(msg.sender);
167         if(refBalance >= minimum) {
168              if (address(this).balance > refBalance) {
169                 referrer[msg.sender] = 0;
170                 msg.sender.transfer(refBalance);
171                 emit Bounty(msg.sender, refBalance);
172              }
173         }
174     }
175 
176     /**
177     * @dev Gets balance of the sender address.
178     * @return An uint256 representing the amount owned by the msg.sender.
179     */
180     function checkBalance() public view returns (uint256) {
181         return getBalance(msg.sender);
182     }
183 
184 
185     /**
186     * @dev Gets investments of the specified address.
187     * @param _investor The address to query the the balance of.
188     * @return An uint256 representing the amount owned by the passed address.
189     */
190     function checkInvestments(address _investor) public view returns (uint256) {
191         return investments[_investor];
192     }
193 
194     /**
195     * @dev Gets referrer balance of the specified address.
196     * @param _hunter The address of the referrer
197     * @return An uint256 representing the referral earnings.
198     */
199     function checkReferral(address _hunter) public view returns (uint256) {
200         return referrer[_hunter];
201     }
202 }
203 
204 /**
205  * @title SafeMath
206  * @dev Math operations with safety checks that throw on error
207  */
208 library SafeMath {
209     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
210         if (a == 0) {
211             return 0;
212         }
213         uint256 c = a * b;
214         assert(c / a == b);
215         return c;
216     }
217 
218     function div(uint256 a, uint256 b) internal pure returns (uint256) {
219         // assert(b > 0); // Solidity automatically throws when dividing by 0
220         uint256 c = a / b;
221         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222         return c;
223     }
224 
225     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
226         assert(b <= a);
227         return a - b;
228     }
229 
230     function add(uint256 a, uint256 b) internal pure returns (uint256) {
231         uint256 c = a + b;
232         assert(c >= a);
233         return c;
234     }
235 }