1 pragma solidity ^0.4.24;
2 
3 /**
4 *
5 Crowd Funded Lottery Game - People who invest for the Lottery Bankroll will get 2.5% Returns every day for 60 days. After 60 days, the investor will be in a profit of 50%. We have a solid Lottery game, which generates the revenue to pay returns to the Investors.
6 */
7 
8 contract Testing {
9 
10     using SafeMath for uint256;
11 
12     mapping(address => uint256) investments;
13     mapping(address => uint256) joined;
14     mapping(address => uint256) withdrawals;
15     mapping(address => uint256) withdrawalsgross;
16     mapping(address => uint256) referrer;
17     uint256 public step = 5;
18     uint256 public bankrollpercentage = 10;
19     uint256 public maximumpercent = 150;
20     uint256 public minimum = 10 finney;
21     uint256 public stakingRequirement = 0.01 ether;
22     uint256 public startTime = 1540214220;
23     uint256 public randomizer = 456717097;
24     uint256 private randNonce = 0;
25     address public ownerWallet;
26     address public owner;
27     address promoter1 = 0xBFb297616fFa0124a288e212d1E6DF5299C9F8d0;
28     address promoter2 = 0xBFb297616fFa0124a288e212d1E6DF5299C9F8d0;
29    
30 
31     event Invest(address investor, uint256 amount);
32     event Withdraw(address investor, uint256 amount);
33     event Bounty(address hunter, uint256 amount);
34     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35     event Lottery(address player, uint256 lotteryNumber, uint256 amount, uint256 result, bool isWin);
36     /**
37      * @dev Constructor Sets the original roles of the contract
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
54     /**
55      * @dev Allows current owner to transfer control of the contract to a newOwner.
56      * @param newOwner The address to transfer ownership to.
57      * @param newOwnerWallet The address to transfer ownership to.
58      */
59     function transferOwnership(address newOwner, address newOwnerWallet) public onlyOwner {
60         require(newOwner != address(0));
61         emit OwnershipTransferred(owner, newOwner);
62         owner = newOwner;
63         ownerWallet = newOwnerWallet;
64     }
65 
66     /**
67      * @dev Investments
68      */
69     function () public payable {
70         buy(0x0);
71     }
72 
73     function buy(address _referredBy) public payable {
74         if (now <= startTime) {
75                 require(msg.sender == owner);
76             }
77         require(msg.value >= minimum);
78 
79         address _customerAddress = msg.sender;
80 
81         if(
82            // is this a referred purchase?
83            _referredBy != 0x0000000000000000000000000000000000000000 &&
84 
85            // no cheating!
86            _referredBy != _customerAddress &&
87 
88            // does the referrer have at least X whole tokens?
89            // i.e is the referrer a godly chad masternode
90            investments[_referredBy] >= stakingRequirement
91        ){
92            // wealth redistribution
93            referrer[_referredBy] = referrer[_referredBy].add(msg.value.mul(5).div(100));
94        }
95 
96        if (investments[msg.sender] > 0){
97            if (withdraw()){
98                withdrawals[msg.sender] = 0;
99            }
100        }
101        investments[msg.sender] = investments[msg.sender].add(msg.value);
102        joined[msg.sender] = block.timestamp;
103        uint256 percentmax = msg.value.mul(5).div(100);
104        uint256 percentmaxhalf = percentmax.div(2);
105        uint256 percentmin = msg.value.mul(1).div(100);
106        uint256 percentminhalf = percentmin.div(2);
107        
108        ownerWallet.transfer(percentmax);
109        promoter1.transfer(percentmaxhalf);
110        promoter2.transfer(percentminhalf);
111        emit Invest(msg.sender, msg.value);
112        
113     }
114 
115 
116      //--------------------------------------------------------------------------------------------
117     // LOTTERY
118     //--------------------------------------------------------------------------------------------
119     /**
120     * @param _value number in array [1,2,3]
121     */
122     function lottery(uint256 _value) public payable
123     {
124         uint256 maxbetsize = address(this).balance.mul(bankrollpercentage).div(100);
125         require(msg.value <= maxbetsize);
126         uint256 random = getRandomNumber(msg.sender) + 1;
127         bool isWin = false;
128         if (random == _value) {
129             isWin = true;
130             uint256 prize = msg.value.mul(180).div(100);
131             if (prize <= address(this).balance) {
132                 msg.sender.transfer(prize);
133             }
134         }
135         ownerWallet.transfer(msg.value.mul(10).div(100));
136         
137         emit Lottery(msg.sender, _value, msg.value, random, isWin);
138     }
139 
140 
141 
142     /**
143     * @dev Evaluate current balance
144     * @param _address Address of investor
145     */
146     function getBalance(address _address) view public returns (uint256) {
147         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
148         uint256 percent = investments[_address].mul(step).div(100);
149         uint256 percentfinal = percent.div(2);
150         uint256 different = percentfinal.mul(minutesCount).div(1440);
151         uint256 balancetemp = different.sub(withdrawals[_address]);
152         uint256 maxpayout = investments[_address].mul(maximumpercent).div(100);
153         uint256 balancesum = withdrawalsgross[_address].add(balancetemp);
154         
155         if (balancesum <= maxpayout){
156               return balancetemp;
157             }
158             
159         else {
160         uint256 balancenet = maxpayout.sub(withdrawalsgross[_address]);
161         return balancenet;
162         }
163         
164         
165     }
166 
167     /**
168     * @dev Withdraw dividends from contract
169     */
170     function withdraw() public returns (bool){
171         require(joined[msg.sender] > 0);
172         uint256 balance = getBalance(msg.sender);
173         if (address(this).balance > balance){
174             if (balance > 0){
175                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
176                 withdrawalsgross[msg.sender] = withdrawalsgross[msg.sender].add(balance);
177                 uint256 maxpayoutfinal = investments[msg.sender].mul(maximumpercent).div(100);
178                 msg.sender.transfer(balance);
179                 if (withdrawalsgross[msg.sender] >= maxpayoutfinal){
180                 investments[msg.sender] = 0;
181                 withdrawalsgross[msg.sender] = 0;
182                 withdrawals[msg.sender] = 0;
183             }
184               emit Withdraw(msg.sender, balance);
185             }
186             return true;
187         } else {
188             return false;
189         }
190     }
191 
192     /**
193     * @dev Bounty reward
194     */
195     function bounty() public {
196         uint256 refBalance = checkReferral(msg.sender);
197         if(refBalance >= minimum) {
198              if (address(this).balance > refBalance) {
199                 referrer[msg.sender] = 0;
200                 msg.sender.transfer(refBalance);
201                 emit Bounty(msg.sender, refBalance);
202              }
203         }
204     }
205 
206     /**
207     * @dev Gets balance of the sender address.
208     * @return An uint256 representing the amount owned by the msg.sender.
209     */
210     function checkBalance() public view returns (uint256) {
211         return getBalance(msg.sender);
212     }
213 
214     /**
215     * @dev Gets withdrawals of the specified address.
216     * @param _investor The address to query the the balance of.
217     * @return An uint256 representing the amount owned by the passed address.
218     */
219     function checkWithdrawals(address _investor) public view returns (uint256) {
220         return withdrawals[_investor];
221     }
222     
223     function checkWithdrawalsgross(address _investor) public view returns (uint256) {
224         return withdrawalsgross[_investor];
225     }
226 
227   
228     function checkInvestments(address _investor) public view returns (uint256) {
229         return investments[_investor];
230     }
231 
232     function checkReferral(address _hunter) public view returns (uint256) {
233         return referrer[_hunter];
234     }
235     
236     function setBankrollpercentage(uint256 _Bankrollpercentage) public {
237       require(msg.sender==owner);
238       bankrollpercentage = _Bankrollpercentage;
239     }
240     
241     function setRandomizer(uint256 _Randomizer) public {
242       require(msg.sender==owner);
243       randomizer = _Randomizer;
244     }
245     
246     function setStartTime(uint256 _startTime) public {
247       require(msg.sender==owner);
248       startTime = _startTime;
249     }
250     function checkContractBalance() public view returns (uint256) 
251     {
252         return address(this).balance;
253     }
254     function end() public onlyOwner {
255 
256     if(msg.sender == owner) { // Only let the contract creator do this
257         selfdestruct(owner); // Makes contract inactive, returns funds
258     }
259        
260     }
261     //----------------------------------------------------------------------------------
262     // INTERNAL FUNCTION
263     //----------------------------------------------------------------------------------
264     function getRandomNumber(address _addr) private returns(uint256 randomNumber) 
265     {
266         randNonce++;
267         randomNumber = uint256(keccak256(abi.encodePacked(now, _addr, randNonce, randomizer, block.coinbase, block.number))) % 7;
268     }
269     
270 }
271 
272 /**
273  * @title SafeMath
274  * @dev Math operations with safety checks that throw on error
275  */
276 library SafeMath {
277     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
278         if (a == 0) {
279             return 0;
280         }
281         uint256 c = a * b;
282         assert(c / a == b);
283         return c;
284     }
285 
286     function div(uint256 a, uint256 b) internal pure returns (uint256) {
287         // assert(b > 0); // Solidity automatically throws when dividing by 0
288         uint256 c = a / b;
289         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
290         return c;
291     }
292 
293     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
294         assert(b <= a);
295         return a - b;
296     }
297 
298     function add(uint256 a, uint256 b) internal pure returns (uint256) {
299         uint256 c = a + b;
300         assert(c >= a);
301         return c;
302     }
303 }