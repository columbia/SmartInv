1 pragma solidity ^0.4.24;
2 
3 /**
4 *GainCrypto.com
5 Crowd Funded Lottery Game - People who invest for the Lottery Bankroll will get 2.5% Returns every day for 60 days. After 60 days, the investor will be in a profit of 50%. We have a solid Lottery game, which generates the revenue to pay returns to the Investors.
6 */
7 
8 contract GainCryptoV1 {
9 
10     using SafeMath for uint256;
11 
12     mapping(address => uint256) investments;
13     mapping(address => uint256) joined;
14     mapping(address => uint256) withdrawals;
15     mapping(address => uint256) withdrawalsgross;
16     mapping(address => uint256) referrer;
17     uint256 public step = 5;
18     uint256 public bankrollpercentage = 1;
19     uint256 public maximumpercent = 150;
20     uint256 public minimum = 10 finney;
21     uint256 public stakingRequirement = 0.01 ether;
22     uint256 public startTime = 1540387800; 
23     uint256 private randNonce = 0;
24     address public ownerWallet;
25     address public owner; 
26     uint256 randomizer = 456717097;
27     address mainpromoter = 0xf42934E5C290AA1586d9945Ca8F20cFb72307f91;
28     address subpromoter = 0xfb84cb9ef433264bb4a9a8ceb81873c08ce2db3d;
29     address telegrampromoter = 0x8426D45E28c69B0Fc480532ADe948e58Caf2a61E;
30     address youtuber1 = 0x4ffE17a2A72bC7422CB176bC71c04EE6D87cE329;
31     address youtuber2 = 0xcB0C3b15505f8048849C1D4F32835Bb98807A055;
32     address youtuber3 = 0x05f2c11996d73288AbE8a31d8b593a693FF2E5D8;
33     address youtuber4 = 0x191d636b99f9a1c906f447cC412e27494BB5047F;
34     address youtuber5 = 0x0c0c5F2C7453C30AEd66fF9757a14dcE5Db0aA94;
35     address gameapi = 0x1f4Af40671D6bE6b3c21e184C1763bbD16618518;
36    
37 
38     event Invest(address investor, uint256 amount);
39     event Withdraw(address investor, uint256 amount);
40     event Bounty(address hunter, uint256 amount);
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42     event Lottery(address player, uint256 lotteryNumber, uint256 amount, uint256 result, bool isWin);
43     /**
44      * @dev Constructor Sets the original roles of the contract
45      */
46 
47     constructor() public {
48         owner = msg.sender;
49         ownerWallet = msg.sender;
50     }
51 
52     /**
53      * @dev Modifiers
54      */
55 
56     modifier onlyOwner() {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     /**
62      * @dev Allows current owner to transfer control of the contract to a newOwner.
63      * @param newOwner The address to transfer ownership to.
64      * @param newOwnerWallet The address to transfer ownership to.
65      */
66     function transferOwnership(address newOwner, address newOwnerWallet) public onlyOwner {
67         require(newOwner != address(0));
68         emit OwnershipTransferred(owner, newOwner);
69         owner = newOwner;
70         ownerWallet = newOwnerWallet;
71     }
72 
73     /**
74      * @dev Investments
75      */
76     function () public payable {
77         buy(0x0);
78     }
79 
80     function buy(address _referredBy) public payable {
81         if (now <= startTime) {
82              require(msg.sender==owner);
83             }
84         require(msg.value >= minimum);
85 
86         address _customerAddress = msg.sender;
87 
88         if(
89            // is this a referred purchase?
90            _referredBy != 0x0000000000000000000000000000000000000000 &&
91 
92            // no cheating!
93            _referredBy != _customerAddress &&
94 
95            // does the referrer have at least X whole tokens?
96            // i.e is the referrer a godly chad masternode
97            investments[_referredBy] >= stakingRequirement
98        ){
99            // wealth redistribution
100            referrer[_referredBy] = referrer[_referredBy].add(msg.value.mul(5).div(100));
101        }
102 
103        if (investments[msg.sender] > 0){
104            if (withdraw()){
105                withdrawals[msg.sender] = 0;
106            }
107        }
108        investments[msg.sender] = investments[msg.sender].add(msg.value);
109        joined[msg.sender] = block.timestamp;
110        uint256 percentmax = msg.value.mul(5).div(100);
111        uint256 percentmaxhalf = percentmax.div(2);
112        uint256 percentmin = msg.value.mul(1).div(100);
113        uint256 percentminhalf = percentmin.div(2);
114        
115        ownerWallet.transfer(percentmax);
116        mainpromoter.transfer(percentmaxhalf);
117        subpromoter.transfer(percentmin);
118        telegrampromoter.transfer(percentmin);
119        youtuber1.transfer(percentminhalf);
120        youtuber2.transfer(percentminhalf);
121        youtuber3.transfer(percentminhalf);
122        youtuber4.transfer(percentminhalf);
123        youtuber5.transfer(percentminhalf);
124        emit Invest(msg.sender, msg.value);
125        
126     }
127 
128 
129      //--------------------------------------------------------------------------------------------
130     // LOTTERY
131     //--------------------------------------------------------------------------------------------
132     /**
133     * @param _value number in array [1,2,3]
134     */
135     function lottery(uint256 _value) public payable
136     {
137         uint256 maxbetsize = address(this).balance.mul(bankrollpercentage).div(100);
138         require(msg.value <= maxbetsize);
139         uint256 random = getRandomNumber(msg.sender) + 1;
140         bool isWin = false;
141         if (random == _value) {
142             isWin = true;
143             uint256 prize = msg.value.mul(180).div(100);
144             if (prize <= address(this).balance) {
145                 msg.sender.transfer(prize);
146             }
147         }
148         ownerWallet.transfer(msg.value.mul(5).div(100));
149         gameapi.transfer(msg.value.mul(3).div(100));
150         mainpromoter.transfer(msg.value.mul(2).div(100));
151         emit Lottery(msg.sender, _value, msg.value, random, isWin);
152     }
153 
154 
155     function getBalance(address _address) view public returns (uint256) {
156         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
157         uint256 percent = investments[_address].mul(step).div(100);
158         uint256 percentfinal = percent.div(2);
159         uint256 different = percentfinal.mul(minutesCount).div(1440);
160         uint256 balancetemp = different.sub(withdrawals[_address]);
161         uint256 maxpayout = investments[_address].mul(maximumpercent).div(100);
162         uint256 balancesum = withdrawalsgross[_address].add(balancetemp);
163         
164         if (balancesum <= maxpayout){
165               return balancetemp;
166             }
167             
168         else {
169         uint256 balancenet = maxpayout.sub(withdrawalsgross[_address]);
170         return balancenet;
171         }
172         
173         
174     }
175 
176    
177     function withdraw() public returns (bool){
178         require(joined[msg.sender] > 0);
179         uint256 balance = getBalance(msg.sender);
180         if (address(this).balance > balance){
181             if (balance > 0){
182                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
183                 withdrawalsgross[msg.sender] = withdrawalsgross[msg.sender].add(balance);
184                 uint256 maxpayoutfinal = investments[msg.sender].mul(maximumpercent).div(100);
185                 msg.sender.transfer(balance);
186                 if (withdrawalsgross[msg.sender] >= maxpayoutfinal){
187                 investments[msg.sender] = 0;
188                 withdrawalsgross[msg.sender] = 0;
189                 withdrawals[msg.sender] = 0;
190             }
191               emit Withdraw(msg.sender, balance);
192             }
193             return true;
194         } else {
195             return false;
196         }
197     }
198 
199  
200     function bounty() public {
201         uint256 refBalance = checkReferral(msg.sender);
202         if(refBalance >= minimum) {
203              if (address(this).balance > refBalance) {
204                 referrer[msg.sender] = 0;
205                 msg.sender.transfer(refBalance);
206                 emit Bounty(msg.sender, refBalance);
207              }
208         }
209     }
210 
211   
212     function checkBalance() public view returns (uint256) {
213         return getBalance(msg.sender);
214     }
215 
216     function checkWithdrawals(address _investor) public view returns (uint256) {
217         return withdrawals[_investor];
218     }
219     
220     function checkWithdrawalsgross(address _investor) public view returns (uint256) {
221         return withdrawalsgross[_investor];
222     }
223 
224     function checkInvestments(address _investor) public view returns (uint256) {
225         return investments[_investor];
226     }
227 
228     function checkReferral(address _hunter) public view returns (uint256) {
229         return referrer[_hunter];
230     }
231     
232     function setYoutuber1(address _youtuber1) public {
233       require(msg.sender==owner);
234       youtuber1 = _youtuber1;
235     }
236     
237     function setYoutuber2(address _youtuber2) public {
238       require(msg.sender==owner);
239       youtuber2 = _youtuber2;
240     }
241     
242     function setYoutuber3(address _youtuber3) public {
243       require(msg.sender==owner);
244       youtuber3 = _youtuber3;
245     }
246     
247     function setYoutuber4(address _youtuber4) public {
248       require(msg.sender==owner);
249       youtuber4 = _youtuber4;
250     }
251     
252     function setYoutuber5(address _youtuber5) public {
253       require(msg.sender==owner);
254       youtuber5 = _youtuber5;
255     }
256     
257     function setBankrollpercentage(uint256 _Bankrollpercentage) public {
258       require(msg.sender==owner);
259       bankrollpercentage = _Bankrollpercentage;
260     }
261     
262     function setRandomizer(uint256 _Randomizer) public {
263       require(msg.sender==owner);
264       randomizer = _Randomizer;
265     }
266     
267     function setStartTime(uint256 _startTime) public {
268       require(msg.sender==owner);
269       startTime = _startTime;
270     }
271     function checkContractBalance() public view returns (uint256) 
272     {
273         return address(this).balance;
274     }
275     //----------------------------------------------------------------------------------
276     // INTERNAL FUNCTION
277     //----------------------------------------------------------------------------------
278     function getRandomNumber(address _addr) private returns(uint256 randomNumber) 
279     {
280         randNonce++;
281         randomNumber = uint256(keccak256(abi.encodePacked(now, _addr, randNonce, randomizer, block.coinbase, block.number))) % 7;
282     }
283     
284 }
285 
286 /**
287  * @title SafeMath
288  * @dev Math operations with safety checks that throw on error
289  */
290 library SafeMath {
291     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
292         if (a == 0) {
293             return 0;
294         }
295         uint256 c = a * b;
296         assert(c / a == b);
297         return c;
298     }
299 
300     function div(uint256 a, uint256 b) internal pure returns (uint256) {
301         // assert(b > 0); // Solidity automatically throws when dividing by 0
302         uint256 c = a / b;
303         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
304         return c;
305     }
306 
307     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
308         assert(b <= a);
309         return a - b;
310     }
311 
312     function add(uint256 a, uint256 b) internal pure returns (uint256) {
313         uint256 c = a + b;
314         assert(c >= a);
315         return c;
316     }
317 }