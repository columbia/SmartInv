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
67 contract ETHSurge is Ownable{
68     using SafeMath for uint256;
69     
70     mapping (address => uint256) public investedETH;
71     mapping (address => uint256) public lastInvest;
72     
73     mapping (address => uint256) public affiliateCommision;
74     
75     address public promoter1 = address(0xDf293953Ee1DA472C3BCbAaB8357b8Fcaf162F91);
76     address public promoter2 = address(0x20007c6aa01e6a0e73d1baB69666438FF43B5ed8);
77     address public fund_account = address(0x77BA8AFB97e0fB8372ACBA94559E47DFe6F185C0);
78     address public lastPotWinner;
79     
80     uint256 public pot = 0;
81     
82     event PotWinner(address indexed beneficiary, uint256 amount );
83     
84     constructor () public {
85         _owner = address(0x3866c58937E33163c2DA66Cae169D22fcF591bdD);
86     }
87 
88     function investETH(address referral) public payable {
89         
90         require(msg.value >= 0.5 ether);
91         
92         if(getProfit(msg.sender) > 0){
93             uint256 profit = getProfit(msg.sender);
94             lastInvest[msg.sender] = now;
95             msg.sender.transfer(profit);
96         }
97         
98         amount = msg.value;
99         uint256 commision = SafeMath.div(amount, 20);
100 
101         uint256 commision1 = amount.mul(3).div(100);
102         uint256 commision2 = amount.mul(2).div(100);
103         uint256 _pot = amount.mul(15).div(100);
104         uint256 amount = amount.sub(commision1).sub(commision2).sub(_pot);
105         pot = pot.add(_pot);
106         
107         promoter1.transfer(commision1);
108         promoter2.transfer(commision2);
109         
110         if(referral != msg.sender && referral != 0x1 && referral != promoter1 && referral != promoter2){
111             affiliateCommision[referral] = SafeMath.add(affiliateCommision[referral], commision);
112         }
113         
114         affiliateCommision[promoter1] = SafeMath.add(affiliateCommision[promoter1], commision);
115         affiliateCommision[promoter2] = SafeMath.add(affiliateCommision[promoter2], commision);
116         
117         investedETH[msg.sender] = investedETH[msg.sender].add(amount);
118         lastInvest[msg.sender] = now;
119         
120         bool potWinner = random();
121         if(potWinner){
122             uint256 winningReward = pot.mul(70).div(100);
123             uint256 dev = pot.mul(20).div(100);
124             pot = pot.sub(winningReward).sub(dev);
125             msg.sender.transfer(winningReward);
126             fund_account.transfer(winningReward);
127             lastPotWinner = msg.sender;
128             emit PotWinner(msg.sender, winningReward);
129         }
130     }
131     
132     function divestETH() public {
133         uint256 profit = getProfit(msg.sender);
134         lastInvest[msg.sender] = now;
135         
136         //50% fee on taking capital out
137         uint256 capital = investedETH[msg.sender];
138         uint256 fee = SafeMath.div(capital, 2);
139         capital = SafeMath.sub(capital, fee);
140         
141         uint256 total = SafeMath.add(capital, profit);
142         require(total > 0);
143         investedETH[msg.sender] = 0;
144         msg.sender.transfer(total);
145     }
146     
147     function withdraw() public{
148         uint256 profit = getProfit(msg.sender);
149         require(profit > 0);
150         lastInvest[msg.sender] = now;
151         msg.sender.transfer(profit);
152     }
153     
154     function getProfitFromSender() public view returns(uint256){
155         return getProfit(msg.sender);
156     }
157 
158     function getProfit(address customer) public view returns(uint256){
159         uint256 secondsPassed = SafeMath.sub(now, lastInvest[customer]);
160         uint256 profit = SafeMath.div(SafeMath.mul(secondsPassed, investedETH[customer]), 2851200);
161         uint256 bonus = getBonus();
162         if(bonus == 0){
163             return profit;
164         }
165         return SafeMath.add(profit, SafeMath.div(SafeMath.mul(profit, bonus), 100));
166     }
167     
168     function getBonus() public view returns(uint256){
169         uint256 invested = getInvested();
170         if(invested >= 0.1 ether && 4 ether >= invested){
171             return 0;
172         }else if(invested >= 4.01 ether && 7 ether >= invested){
173             return 20;
174         }else if(invested >= 7.01 ether && 10 ether >= invested){
175             return 40;
176         }else if(invested >= 10.01 ether && 15 ether >= invested){
177             return 60;
178         }else if(invested >= 15.01 ether){
179             return 99;
180         }
181     }
182     
183     function reinvestProfit() public {
184         uint256 profit = getProfit(msg.sender);
185         require(profit > 0);
186         lastInvest[msg.sender] = now;
187         investedETH[msg.sender] = SafeMath.add(investedETH[msg.sender], profit);
188     }
189     
190     function getAffiliateCommision() public view returns(uint256){
191         return affiliateCommision[msg.sender];
192     }
193     
194     function withdrawAffiliateCommision() public {
195         require(affiliateCommision[msg.sender] > 0);
196         uint256 commision = affiliateCommision[msg.sender];
197         affiliateCommision[msg.sender] = 0;
198         msg.sender.transfer(commision);
199     }
200     
201     function getInvested() public view returns(uint256){
202         return investedETH[msg.sender];
203     }
204     
205     function getBalance() public view returns(uint256){
206         return address(this).balance;
207     }
208 
209     function min(uint256 a, uint256 b) private pure returns (uint256) {
210         return a < b ? a : b;
211     }
212     
213     function max(uint256 a, uint256 b) private pure returns (uint256) {
214         return a > b ? a : b;
215     }
216     
217     function updatePromoter1(address _address) external onlyOwner {
218         require(_address != address(0x0));
219         promoter1 = _address;
220     }
221     
222     function updatePromoter2(address _address) external onlyOwner {
223         require(_address != address(0x0));
224         promoter2 = _address;
225     }
226     
227     function updateDev(address _address) external onlyOwner {
228         require(_address != address(0x0));
229         fund_account = _address;
230     }
231     
232     function random() internal view returns (bool) {
233         uint maxRange = 2**(8* 7);
234         for(uint8 a = 0 ; a < 8; a++){
235             uint randomNumber = uint( keccak256(abi.encodePacked(msg.sender,blockhash(block.number), block.timestamp )) ) % maxRange;
236             if ((randomNumber % 13) % 19 == 0){
237                 return true;
238                 break;
239             }
240         }
241         return false;    
242     } 
243 }
244 
245 library SafeMath {
246 
247   /**
248   * @dev Multiplies two numbers, throws on overflow.
249   */
250   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
251     if (a == 0) {
252       return 0;
253     }
254     uint256 c = a * b;
255     assert(c / a == b);
256     return c;
257   }
258 
259   /**
260   * @dev Integer division of two numbers, truncating the quotient.
261   */
262   function div(uint256 a, uint256 b) internal pure returns (uint256) {
263     // assert(b > 0); // Solidity automatically throws when dividing by 0
264     uint256 c = a / b;
265     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
266     return c;
267   }
268 
269   /**
270   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
271   */
272   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
273     assert(b <= a);
274     return a - b;
275   }
276 
277   /**
278   * @dev Adds two numbers, throws on overflow.
279   */
280   function add(uint256 a, uint256 b) internal pure returns (uint256) {
281     uint256 c = a + b;
282     assert(c >= a);
283     return c;
284   }
285 }