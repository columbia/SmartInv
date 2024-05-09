1 pragma solidity ^0.4.25;
2 
3 /**
4 *
5 12HourTrains - 3% every 12 hours. Want to get quick ETH? Try our new Dice game.
6 https://12hourtrains.github.io/
7 Version 3
8 */
9 contract TwelveHourTrains {
10 
11     using SafeMath for uint256;
12 
13     mapping(address => uint256) investments;
14     mapping(address => uint256) joined;
15     mapping(address => uint256) withdrawals;
16     mapping(address => uint256) referrer;
17 
18     uint256 public step = 100;
19     uint256 public minimum = 10 finney;
20     uint256 public stakingRequirement = 2 ether;
21     address public ownerWallet;
22     address public owner;
23     uint256 private randNonce = 0;
24 
25     /**
26     * @dev Modifiers
27     */
28 
29     modifier onlyOwner() 
30     {
31         require(msg.sender == owner);
32         _;
33     }
34     modifier disableContract()
35     {
36         require(tx.origin == msg.sender);
37         _;
38     }
39     /**
40     * @dev Event
41     */
42     event Invest(address investor, uint256 amount);
43     event Withdraw(address investor, uint256 amount);
44     event Bounty(address hunter, uint256 amount);
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46     event Lottery(address player, uint256 lotteryNumber, uint256 amount, uint256 result,bool isWin);
47     /**
48     * @dev Сonstructor Sets the original roles of the contract
49     */
50 
51     constructor() public 
52     {
53         owner = msg.sender;
54         ownerWallet = msg.sender;
55     }
56 
57     /**
58     * @dev Allows current owner to transfer control of the contract to a newOwner.
59     * @param newOwner The address to transfer ownership to.
60     * @param newOwnerWallet The address to transfer ownership to.
61     */
62     function transferOwnership(address newOwner, address newOwnerWallet) public onlyOwner 
63     {
64         require(newOwner != address(0));
65 
66         owner = newOwner;
67         ownerWallet = newOwnerWallet;
68 
69         emit OwnershipTransferred(owner, newOwner);
70     }
71 
72     /**
73     * @dev Investments
74     */
75     function () public payable 
76     {
77         buy(0x0);
78     }
79 
80     function buy(address _referredBy) public payable 
81     {
82         require(msg.value >= minimum);
83 
84         address _customerAddress = msg.sender;
85 
86         if(
87            // is this a referred purchase?
88            _referredBy != 0x0000000000000000000000000000000000000000 &&
89 
90            // no cheating!
91            _referredBy != _customerAddress &&
92 
93            // does the referrer have at least X whole tokens?
94            // i.e is the referrer a godly chad masternode
95            investments[_referredBy] >= stakingRequirement
96        ){
97            // wealth redistribution
98            referrer[_referredBy] = referrer[_referredBy].add(msg.value.mul(5).div(100));
99        }
100 
101        if (investments[msg.sender] > 0){
102            if (withdraw()){
103                withdrawals[msg.sender] = 0;
104            }
105        }
106        investments[msg.sender] = investments[msg.sender].add(msg.value);
107        joined[msg.sender] = block.timestamp;
108        ownerWallet.transfer(msg.value.mul(5).div(100));
109 
110        emit Invest(msg.sender, msg.value);
111     }
112     //--------------------------------------------------------------------------------------------
113     // LOTTERY
114     //--------------------------------------------------------------------------------------------
115     /**
116     * @param _value number in array [1,2,3]
117     */
118     function lottery(uint256 _value) public payable disableContract
119     {
120         uint256 random = getRandomNumber(msg.sender) + 1;
121         bool isWin = false;
122         if (random == _value) {
123             isWin = true;
124             uint256 prize = msg.value.mul(249).div(100);
125             if (prize <= address(this).balance) {
126                 msg.sender.transfer(prize);
127             }
128         }
129         ownerWallet.transfer(msg.value.mul(5).div(100));
130         
131         emit Lottery(msg.sender, _value, msg.value, random, isWin);
132     }
133 
134     /**
135     * @dev Evaluate current balance
136     * @param _address Address of investor
137     */
138     function getBalance(address _address) view public returns (uint256) {
139         uint256 minutesCount = now.sub(joined[_address]).div(1 minutes);
140         uint256 percent = investments[_address].mul(step).div(100);
141         uint256 different = percent.mul(minutesCount).div(24000);
142         uint256 balance = different.sub(withdrawals[_address]);
143 
144         return balance;
145     }
146 
147     /**
148     * @dev Withdraw dividends from contract
149     */
150     function withdraw() public returns (bool){
151         require(joined[msg.sender] > 0);
152         uint256 balance = getBalance(msg.sender);
153         if (address(this).balance > balance){
154             if (balance > 0){
155                 withdrawals[msg.sender] = withdrawals[msg.sender].add(balance);
156                 msg.sender.transfer(balance);
157                 emit Withdraw(msg.sender, balance);
158             }
159             return true;
160         } else {
161             return false;
162         }
163     }
164     /**
165     * @dev Bounty reward
166     */
167     function bounty() public {
168         uint256 refBalance = checkReferral(msg.sender);
169         if(refBalance >= minimum) {
170              if (address(this).balance > refBalance) {
171                 referrer[msg.sender] = 0;
172                 msg.sender.transfer(refBalance);
173                 emit Bounty(msg.sender, refBalance);
174              }
175         }
176     }
177 
178     /**
179     * @dev Gets balance of the sender address.
180     * @return An uint256 representing the amount owned by the msg.sender.
181     */
182     function checkBalance() public view returns (uint256) {
183         return getBalance(msg.sender);
184     }
185 
186     /**
187     * @dev Gets withdrawals of the specified address.
188     * @param _investor The address to query the the balance of.
189     * @return An uint256 representing the amount owned by the passed address.
190     */
191     function checkWithdrawals(address _investor) public view returns (uint256) 
192     {
193         return withdrawals[_investor];
194     }
195     /**
196     * @dev Gets investments of the specified address.
197     * @param _investor The address to query the the balance of.
198     * @return An uint256 representing the amount owned by the passed address.
199     */
200     function checkInvestments(address _investor) public view returns (uint256) 
201     {
202         return investments[_investor];
203     }
204 
205     /**
206     * @dev Gets referrer balance of the specified address.
207     * @param _hunter The address of the referrer
208     * @return An uint256 representing the referral earnings.
209     */
210     function checkReferral(address _hunter) public view returns (uint256) 
211     {
212         return referrer[_hunter];
213     }
214     function checkContractBalance() public view returns (uint256) 
215     {
216         return address(this).balance;
217     }
218     //----------------------------------------------------------------------------------
219     // INTERNAL FUNCTION
220     //----------------------------------------------------------------------------------
221     function getRandomNumber(address _addr) private returns(uint256 randomNumber) 
222     {
223         randNonce++;
224         randomNumber = uint256(keccak256(abi.encodePacked(now, _addr, randNonce, block.coinbase, block.number))) % 3;
225     }
226 
227 }
228 
229 /**
230  * @title SafeMath
231  * @dev Math operations with safety checks that throw on error
232  */
233 library SafeMath {
234     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
235         if (a == 0) {
236             return 0;
237         }
238         uint256 c = a * b;
239         assert(c / a == b);
240         return c;
241     }
242 
243     function div(uint256 a, uint256 b) internal pure returns (uint256) {
244         // assert(b > 0); // Solidity automatically throws when dividing by 0
245         uint256 c = a / b;
246         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
247         return c;
248     }
249 
250     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
251         assert(b <= a);
252         return a - b;
253     }
254 
255     function add(uint256 a, uint256 b) internal pure returns (uint256) {
256         uint256 c = a + b;
257         assert(c >= a);
258         return c;
259     }
260 }