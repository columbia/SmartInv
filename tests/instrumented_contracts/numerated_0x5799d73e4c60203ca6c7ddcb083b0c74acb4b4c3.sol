1 pragma solidity ^0.4.25;
2 
3 
4 contract toff {
5 
6     using SafeMath for uint256;
7 
8     mapping(address => uint256) investments;
9     mapping(address => uint256) joined;
10     mapping(address => uint256) withdrawals;
11     mapping(address => uint256) referrer;
12     mapping(address => uint256) withdraStock;
13 
14     uint256 public step = 100;
15     uint256 public stock = 0;
16     uint256 public totalPot = 0;
17     uint256 public minimum = 10 finney;
18     uint256 public stakingRequirement = 2 ether;
19     address public ownerWallet;
20     address public owner;
21     uint256 public timeWithdrawstock = 0;
22 
23     event Invest(address investor, uint256 amount);
24     event Withdraw(address investor, uint256 amount);
25     event WithdrawShare(address investor, uint256 amount);
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
36         timeWithdrawstock = now + 24 hours;
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
48     /**
49      * @dev Allows current owner to transfer control of the contract to a newOwner.
50      * @param newOwner The address to transfer ownership to.
51      * @param newOwnerWallet The address to transfer ownership to.
52      */
53     function transferOwnership(address newOwner, address newOwnerWallet) public onlyOwner {
54         require(newOwner != address(0));
55         emit OwnershipTransferred(owner, newOwner);
56         owner = newOwner;
57         ownerWallet = newOwnerWallet;
58     }
59 
60     /**
61      * @dev Investments
62      */
63     function () public payable {
64         buy(0x0);
65     }
66 
67     function buy(address _referredBy) public payable {
68         require(msg.value >= minimum);
69 
70         address _customerAddress = msg.sender;
71 
72         if(
73            // is this a referred purchase?
74            _referredBy != 0x0000000000000000000000000000000000000000 &&
75 
76            // no cheating!
77            _referredBy != _customerAddress &&
78 
79            // does the referrer have at least X whole tokens?
80            // i.e is the referrer a godly chad masternode
81            investments[_referredBy] >= stakingRequirement
82        ){
83            // wealth redistribution
84            referrer[_referredBy] = referrer[_referredBy].add(msg.value.mul(5).div(100));
85        }
86 
87        if (investments[msg.sender] > 0){
88            if (withdraw()){
89                withdrawals[msg.sender] = 0;
90            }
91        }
92        investments[msg.sender] = investments[msg.sender].add(msg.value);
93        joined[msg.sender] = block.timestamp;
94        ownerWallet.transfer(msg.value.mul(5).div(100));
95        // add prize pool
96        stock = stock.add(msg.value.mul(5).div(100));
97        totalPot = totalPot.add(msg.value);
98 
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
109         uint256 different = percent.mul(minutesCount).div(720);
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
121         if (
122             address(this).balance > balance &&
123             balance <= address(this).balance.sub(stock)
124             ){
125             if (balance > 0){
126                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
127                 msg.sender.transfer(balance);
128                 emit Withdraw(msg.sender, balance);
129             }
130             return true;
131         } else {
132             return false;
133         }
134     }
135     /**
136     * @dev bonus share
137     */
138     function withdrawStock() public 
139     {
140          require(joined[msg.sender] > 0);
141          require(timeWithdrawstock < now);
142 
143          // calculate share
144          uint256 share = stock.mul(investments[msg.sender]).div(totalPot);
145          uint256 currentWithDraw = withdraStock[msg.sender];
146          
147          if (share <= currentWithDraw) { revert(); }
148 
149          uint256 balance = share.sub(currentWithDraw);
150 
151          if ( balance > 0 ) {
152             // update withdrawShare
153             withdraStock[msg.sender] = currentWithDraw.add(balance);
154 
155             stock = stock.sub(balance);
156             
157             msg.sender.transfer(balance);
158             emit WithdrawShare(msg.sender, balance);
159 
160 
161          } 
162      }
163     /*
164 
165     /**
166     * @dev Bounty reward
167     */
168     function bounty() public {
169         uint256 refBalance = checkReferral(msg.sender);
170         if(refBalance >= minimum) {
171              if (address(this).balance > refBalance) {
172                 referrer[msg.sender] = 0;
173                 msg.sender.transfer(refBalance);
174                 emit Bounty(msg.sender, refBalance);
175              }
176         }
177     }
178 
179     /**
180     * @dev Gets balance of the sender address.
181     * @return An uint256 representing the amount owned by the msg.sender.
182     */
183     function checkBalance() public view returns (uint256) {
184         return getBalance(msg.sender);
185     }
186 
187     /**
188     * @dev Gets withdrawals of the specified address.
189     * @param _investor The address to query the the balance of.
190     * @return An uint256 representing the amount owned by the passed address.
191     */
192     function checkWithdrawals(address _investor) public view returns (uint256) {
193         return withdrawals[_investor];
194     }
195 
196     function checkWithrawStock(address _investor) public view returns(uint256)
197     {
198         return withdraStock[_investor];
199     }
200     function getYourRewardStock(address _investor) public view returns(uint256)
201     {
202         uint256 share = stock.mul(investments[_investor]).div(totalPot);
203         uint256 currentWithDraw = withdraStock[_investor];
204         if (share <= currentWithDraw) {
205             return 0;
206         } else {
207             return share.sub(currentWithDraw);
208         }
209     }
210     /**
211     * @dev Gets investments of the specified address.
212     * @param _investor The address to query the the balance of.
213     * @return An uint256 representing the amount owned by the passed address.
214     */
215     function checkInvestments(address _investor) public view returns (uint256) {
216         return investments[_investor];
217     }
218 
219     /**
220     * @dev Gets referrer balance of the specified address.
221     * @param _hunter The address of the referrer
222     * @return An uint256 representing the referral earnings.
223     */
224     function checkReferral(address _hunter) public view returns (uint256) {
225         return referrer[_hunter];
226     }
227 
228 }
229 
230 /**
231  * @title SafeMath
232  * @dev Math operations with safety checks that throw on error
233  */
234 library SafeMath {
235     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
236         if (a == 0) {
237             return 0;
238         }
239         uint256 c = a * b;
240         assert(c / a == b);
241         return c;
242     }
243 
244     function div(uint256 a, uint256 b) internal pure returns (uint256) {
245         // assert(b > 0); // Solidity automatically throws when dividing by 0
246         uint256 c = a / b;
247         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
248         return c;
249     }
250 
251     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
252         assert(b <= a);
253         return a - b;
254     }
255 
256     function add(uint256 a, uint256 b) internal pure returns (uint256) {
257         uint256 c = a + b;
258         assert(c >= a);
259         return c;
260     }
261 }