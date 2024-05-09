1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address internal _owner;
11 
12   event OwnershipTransferred(
13     address indexed previousOwner,
14     address indexed newOwner
15   );
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   constructor() public {
22     _owner = msg.sender;
23   }
24 
25   /**
26    * @return the address of the owner.
27    */
28   function owner() public view returns(address) {
29     return _owner;
30   }
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(isOwner());
37     _;
38   }
39 
40   /**
41    * @return true if `msg.sender` is the owner of the contract.
42    */
43   function isOwner() public view returns(bool) {
44     return msg.sender == _owner;
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address newOwner) public onlyOwner {
52     _transferOwnership(newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address newOwner) internal {
60     require(newOwner != address(0));
61     emit OwnershipTransferred(_owner, newOwner);
62     _owner = newOwner;
63   }
64 }
65 
66 
67 contract HYIPRETH is Ownable{
68     using SafeMath for uint256;
69     
70     mapping (address => uint256) public investedETH;
71     mapping (address => uint256) public lastInvest;
72     
73     mapping (address => uint256) public affiliateCommision;
74     
75     address public promoter1 = address(0x1613CF215c346409753B8f25dB12Aa085BffAA43);
76     address public promoter2 = address(0x1613CF215c346409753B8f25dB12Aa085BffAA43);
77     address public fund_account = address(0x1613CF215c346409753B8f25dB12Aa085BffAA43);
78     address public lastPotWinner;
79     
80     uint256 public pot = 0;
81     
82     
83     event PotWinner(address indexed beneficiary, uint256 amount );
84     
85     constructor () public {
86         _owner = address(0x1613CF215c346409753B8f25dB12Aa085BffAA43);
87     }
88     
89     
90       mapping(address => uint256) public userWithdrawals;
91     mapping(address => uint256[]) public userSequentialDeposits;
92     
93     function maximumProfitUser() public view returns(uint256){
94         //user can withdraw 200% of the investment. 
95         return getInvested() * 2;
96     }
97     
98     function getTotalNumberOfDeposits() public view returns(uint256){
99         return userSequentialDeposits[msg.sender].length;
100     }
101     
102     function() public payable{ }
103     
104     
105     
106       function investETH(address referral) public payable {
107         
108         require(msg.value >= 0.5 ether);
109         
110         if(getProfit(msg.sender) > 0){
111             uint256 profit = getProfit(msg.sender);
112             lastInvest[msg.sender] = now;
113             userWithdrawals[msg.sender] += profit;
114             msg.sender.transfer(profit);
115         }
116         
117         amount = msg.value;
118         uint256 commision = SafeMath.div(amount, 20);
119 
120         uint256 commision1 = amount.mul(10).div(100);
121         uint256 commision2 = amount.mul(9).div(100);
122         uint256 _pot = amount.mul(1).div(100);
123         uint256 amount = amount.sub(commision1).sub(commision2).sub(_pot);
124         pot = pot.add(_pot);
125         
126         promoter1.transfer(commision1);
127         promoter2.transfer(commision2);
128         
129         if(referral != msg.sender && referral != 0x1 && referral != promoter1 && referral != promoter2){
130             affiliateCommision[referral] = SafeMath.add(affiliateCommision[referral], commision);
131         }
132         
133         affiliateCommision[promoter1] = SafeMath.add(affiliateCommision[promoter1], commision);
134         affiliateCommision[promoter2] = SafeMath.add(affiliateCommision[promoter2], commision);
135         
136         investedETH[msg.sender] = investedETH[msg.sender].add(amount);
137         lastInvest[msg.sender] = now;
138         userSequentialDeposits[msg.sender].push(amount);
139         
140         bool potWinner = random();
141         if(potWinner){
142             uint256 winningReward = pot.mul(50).div(100);
143             uint256 dev = pot.mul(40).div(100);
144             pot = pot.sub(winningReward).sub(dev);
145             msg.sender.transfer(winningReward);
146             fund_account.transfer(winningReward);
147             lastPotWinner = msg.sender;
148             emit PotWinner(msg.sender, winningReward);
149         }
150     }
151     
152     function withdraw() public{
153         uint256 profit = getProfit(msg.sender);
154         uint256 maximumProfit = maximumProfitUser();
155         uint256 availableProfit = maximumProfit - userWithdrawals[msg.sender];
156         require(profit > 0);
157         lastInvest[msg.sender] = now;
158         
159         if(profit < availableProfit){
160             userWithdrawals[msg.sender] += profit;
161             msg.sender.transfer(profit);
162         }
163         
164         else if(profit >= availableProfit && userWithdrawals[msg.sender] < maximumProfit){
165             uint256 finalPartialPayment = availableProfit;
166             userWithdrawals[msg.sender] = 0;
167             investedETH[msg.sender] = 0;
168             delete userSequentialDeposits[msg.sender];
169             msg.sender.transfer(finalPartialPayment);
170         }
171         
172         
173     }
174    
175     function getProfitFromSender() public view returns(uint256){
176         return getProfit(msg.sender);
177     }
178 
179     function getProfit(address customer) public view returns(uint256){
180         uint256 secondsPassed = SafeMath.sub(now, lastInvest[customer]);
181         uint256 profit = SafeMath.div(SafeMath.mul(secondsPassed, investedETH[customer]), 1234440);
182         
183         uint256 maximumProfit = maximumProfitUser();
184         uint256 availableProfit = maximumProfit - userWithdrawals[msg.sender];
185 
186         if(profit > availableProfit && userWithdrawals[msg.sender] < maximumProfit){
187             profit = availableProfit;
188         }
189         
190         uint256 bonus = getBonus();
191         if(bonus == 0){
192             return profit;
193         }
194         return SafeMath.add(profit, SafeMath.div(SafeMath.mul(profit, bonus), 100));
195     }
196     
197     function getBonus() public view returns(uint256){
198         uint256 invested = getInvested();
199         if(invested >= 0.5 ether && 4 ether >= invested){
200             return 0;
201         }else if(invested >= 4.01 ether && 7 ether >= invested){
202             return 20;
203         }else if(invested >= 7.01 ether && 10 ether >= invested){
204             return 40;
205         }else if(invested >= 10.01 ether && 15 ether >= invested){
206             return 60;
207         }else if(invested >= 15.01 ether){
208             return 99;
209         }
210     }
211     
212    
213     function getAffiliateCommision() public view returns(uint256){
214         return affiliateCommision[msg.sender];
215     }
216     
217     function withdrawAffiliateCommision() public {
218         require(affiliateCommision[msg.sender] > 0);
219         uint256 commision = affiliateCommision[msg.sender];
220         affiliateCommision[msg.sender] = 0;
221         msg.sender.transfer(commision);
222     }
223     
224     function getInvested() public view returns(uint256){
225         return investedETH[msg.sender];
226     }
227     
228     function getBalance() public view returns(uint256){
229         return address(this).balance;
230     }
231 
232     function min(uint256 a, uint256 b) private pure returns (uint256) {
233         return a < b ? a : b;
234     }
235     
236     function max(uint256 a, uint256 b) private pure returns (uint256) {
237         return a > b ? a : b;
238     }
239     
240     function updatePromoter1(address _address) external onlyOwner {
241         require(_address != address(0x0));
242         promoter1 = _address;
243     }
244     
245     function updatePromoter2(address _address) external onlyOwner {
246         require(_address != address(0x0));
247         promoter2 = _address;
248     }
249     
250     function updateDev(address _address) external onlyOwner {
251         require(_address != address(0x0));
252         fund_account = _address;
253     }
254     
255     function random() internal view returns (bool) {
256         uint maxRange = 2**(8* 7);
257         for(uint8 a = 0 ; a < 8; a++){
258             uint randomNumber = uint( keccak256(abi.encodePacked(msg.sender,blockhash(block.number), block.timestamp )) ) % maxRange;
259             if ((randomNumber % 13) % 19 == 0){
260                 return true;
261                 break;
262             }
263         }
264         return false;    
265     } 
266 }
267 
268 library SafeMath {
269 
270   /**
271   * @dev Multiplies two numbers, throws on overflow.
272   */
273   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
274     if (a == 0) {
275       return 0;
276     }
277     uint256 c = a * b;
278     assert(c / a == b);
279     return c;
280   }
281 
282   /**
283   * @dev Integer division of two numbers, truncating the quotient.
284   */
285   function div(uint256 a, uint256 b) internal pure returns (uint256) {
286     // assert(b > 0); // Solidity automatically throws when dividing by 0
287     uint256 c = a / b;
288     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
289     return c;
290   }
291 
292   /**
293   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
294   */
295   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
296     assert(b <= a);
297     return a - b;
298   }
299 
300   /**
301   * @dev Adds two numbers, throws on overflow.
302   */
303   function add(uint256 a, uint256 b) internal pure returns (uint256) {
304     uint256 c = a + b;
305     assert(c >= a);
306     return c;
307   }
308 }