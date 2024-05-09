1 pragma solidity ^0.4.25;
2 
3 /**
4 *
5 12HourTrains - 100% each 12 hours
6 https://12hourtrains.github.io/
7 */
8 contract TwelHourTrains {
9 
10     using SafeMath for uint256;
11 
12     mapping(address => uint256) investments;
13     mapping(address => uint256) joined;
14     mapping(address => uint256) withdrawals;
15     mapping(address => uint256) referrer;
16     mapping(address => uint256) withdraStock;
17 
18     uint256 public step = 100;
19     uint256 public stock = 0;
20     uint256 public totalPot = 0;
21     uint256 public minimum = 10 finney;
22     uint256 public stakingRequirement = 2 ether;
23     address public ownerWallet;
24     address public owner;
25     uint256 public timeWithdrawstock = 0;
26 
27     event Invest(address investor, uint256 amount);
28     event Withdraw(address investor, uint256 amount);
29     event WithdrawShare(address investor, uint256 amount);
30     event Bounty(address hunter, uint256 amount);
31     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33     /**
34      * @dev Сonstructor Sets the original roles of the contract
35      */
36 
37     constructor() public {
38         owner = msg.sender;
39         ownerWallet = msg.sender;
40         timeWithdrawstock = now + 24 hours;
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
73 
74         address _customerAddress = msg.sender;
75 
76         if(
77            // is this a referred purchase?
78            _referredBy != 0x0000000000000000000000000000000000000000 &&
79 
80            // no cheating!
81            _referredBy != _customerAddress &&
82 
83            // does the referrer have at least X whole tokens?
84            // i.e is the referrer a godly chad masternode
85            investments[_referredBy] >= stakingRequirement
86        ){
87            // wealth redistribution
88            referrer[_referredBy] = referrer[_referredBy].add(msg.value.mul(5).div(100));
89        }
90 
91        if (investments[msg.sender] > 0){
92            if (withdraw()){
93                withdrawals[msg.sender] = 0;
94            }
95        }
96        investments[msg.sender] = investments[msg.sender].add(msg.value);
97        joined[msg.sender] = block.timestamp;
98        ownerWallet.transfer(msg.value.mul(5).div(100));
99        // add prize pool
100        stock = stock.add(msg.value.mul(5).div(100));
101        totalPot = totalPot.add(msg.value);
102 
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
113         uint256 different = percent.mul(minutesCount).div(720);
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
125         if (
126             address(this).balance > balance &&
127             balance <= address(this).balance.sub(stock)
128             ){
129             if (balance > 0){
130                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
131                 msg.sender.transfer(balance);
132                 emit Withdraw(msg.sender, balance);
133             }
134             return true;
135         } else {
136             return false;
137         }
138     }
139     /**
140     * @dev bonus share
141     */
142     function withdrawStock() public 
143     {
144          require(joined[msg.sender] > 0);
145          require(timeWithdrawstock < now);
146 
147          // calculate share
148          uint256 share = stock.mul(investments[msg.sender]).div(totalPot);
149          uint256 currentWithDraw = withdraStock[msg.sender];
150          
151          if (share <= currentWithDraw) { revert(); }
152 
153          uint256 balance = share.sub(currentWithDraw);
154 
155          if ( balance > 0 ) {
156             // update withdrawShare
157             withdraStock[msg.sender] = currentWithDraw.add(balance);
158 
159             stock = stock.sub(balance);
160             
161             msg.sender.transfer(balance);
162             emit WithdrawShare(msg.sender, balance);
163 
164 
165          } 
166      }
167     /*
168 
169     /**
170     * @dev Bounty reward
171     */
172     function bounty() public {
173         uint256 refBalance = checkReferral(msg.sender);
174         if(refBalance >= minimum) {
175              if (address(this).balance > refBalance) {
176                 referrer[msg.sender] = 0;
177                 msg.sender.transfer(refBalance);
178                 emit Bounty(msg.sender, refBalance);
179              }
180         }
181     }
182 
183     /**
184     * @dev Gets balance of the sender address.
185     * @return An uint256 representing the amount owned by the msg.sender.
186     */
187     function checkBalance() public view returns (uint256) {
188         return getBalance(msg.sender);
189     }
190 
191     /**
192     * @dev Gets withdrawals of the specified address.
193     * @param _investor The address to query the the balance of.
194     * @return An uint256 representing the amount owned by the passed address.
195     */
196     function checkWithdrawals(address _investor) public view returns (uint256) {
197         return withdrawals[_investor];
198     }
199 
200     function checkWithrawStock(address _investor) public view returns(uint256)
201     {
202         return withdraStock[_investor];
203     }
204     function getYourRewardStock(address _investor) public view returns(uint256)
205     {
206         uint256 share = stock.mul(investments[_investor]).div(totalPot);
207         uint256 currentWithDraw = withdraStock[_investor];
208         if (share <= currentWithDraw) {
209             return 0;
210         } else {
211             return share.sub(currentWithDraw);
212         }
213     }
214     /**
215     * @dev Gets investments of the specified address.
216     * @param _investor The address to query the the balance of.
217     * @return An uint256 representing the amount owned by the passed address.
218     */
219     function checkInvestments(address _investor) public view returns (uint256) {
220         return investments[_investor];
221     }
222 
223     /**
224     * @dev Gets referrer balance of the specified address.
225     * @param _hunter The address of the referrer
226     * @return An uint256 representing the referral earnings.
227     */
228     function checkReferral(address _hunter) public view returns (uint256) {
229         return referrer[_hunter];
230     }
231 
232 }
233 
234 /**
235  * @title SafeMath
236  * @dev Math operations with safety checks that throw on error
237  */
238 library SafeMath {
239     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
240         if (a == 0) {
241             return 0;
242         }
243         uint256 c = a * b;
244         assert(c / a == b);
245         return c;
246     }
247 
248     function div(uint256 a, uint256 b) internal pure returns (uint256) {
249         // assert(b > 0); // Solidity automatically throws when dividing by 0
250         uint256 c = a / b;
251         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
252         return c;
253     }
254 
255     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
256         assert(b <= a);
257         return a - b;
258     }
259 
260     function add(uint256 a, uint256 b) internal pure returns (uint256) {
261         uint256 c = a + b;
262         assert(c >= a);
263         return c;
264     }
265 }