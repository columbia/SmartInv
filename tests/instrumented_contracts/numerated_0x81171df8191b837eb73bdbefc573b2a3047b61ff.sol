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
67 contract HYIPRETHPRO441 is Ownable{
68     using SafeMath for uint256;
69     
70     mapping (address => uint256) public investedETH;
71     mapping (address => uint256) public lastInvest;
72     mapping (address => uint256) public lastWithdraw;
73     
74     mapping (address => uint256) public affiliateCommision;
75     
76     address public dev = address(0xB5f6a633992cC9BF735974c3E09B5849c7633E2f);
77     address public promoter1 = address(0xcF8Fd8bA33A341130B5662Ba4cDee8de61366DF0);
78     address public promoter2 = address(0xB5f6a633992cC9BF735974c3E09B5849c7633E2f);
79     
80     address public lastPotWinner;
81     
82     uint256 public pot = 0;
83     uint256 public maxpot = 3000000000000000000;
84     uint256 public launchtime = 1554822000;
85     uint256 public maxwithdraw = SafeMath.div(87, 10);
86     uint256 maxprofit = SafeMath.div(44, 10);
87    
88     
89     
90     event PotWinner(address indexed beneficiary, uint256 amount );
91     
92     constructor () public {
93         _owner = address(0xB5f6a633992cC9BF735974c3E09B5849c7633E2f);
94     }
95     
96     
97       mapping(address => uint256) public userWithdrawals;
98     mapping(address => uint256[]) public userSequentialDeposits;
99     
100     function maximumProfitUser() public view returns(uint256){ 
101         return getInvested() * maxprofit;
102     }
103     
104     function getTotalNumberOfDeposits() public view returns(uint256){
105         return userSequentialDeposits[msg.sender].length;
106     }
107     
108     function() public payable{ }
109     
110     
111     
112       function investETH(address referral) public payable {
113       require(now >= launchtime);
114       require(msg.value >= 0.1 ether);
115       uint256 timelimit = SafeMath.sub(now, launchtime);
116       
117       
118       if(timelimit < 1728000 && getProfit(msg.sender) > 0){
119           reinvestProfit();
120         }
121         
122       if(timelimit > 1728000 && getProfit(msg.sender) > 0){
123             
124              uint256 profit = getProfit(msg.sender);
125              lastInvest[msg.sender] = now;
126              lastWithdraw[msg.sender] = now;
127              userWithdrawals[msg.sender] += profit;
128              msg.sender.transfer(profit);
129  
130            
131         }
132        
133         
134         amount = msg.value;
135         uint256 commision = amount.mul(9).div(100);
136         uint256 commision1 = amount.mul(8).div(100);
137         uint256 _pot = amount.mul(3).div(100);
138         pot = pot.add(_pot);
139         uint256 amount = amount;
140         
141         
142         dev.transfer(commision1);
143         promoter1.transfer(commision1);
144        
145         
146         if(referral != msg.sender && referral != 0x1 && referral != promoter1){
147             affiliateCommision[referral] = SafeMath.add(affiliateCommision[referral], commision);
148         }
149         
150         //affiliateCommision[dev] = SafeMath.add(affiliateCommision[dev], commision);
151         
152         
153         investedETH[msg.sender] = investedETH[msg.sender].add(amount);
154         lastInvest[msg.sender] = now;
155         userSequentialDeposits[msg.sender].push(amount);
156         if(pot >= maxpot){
157             uint256 winningReward = pot;
158             msg.sender.transfer(winningReward);
159             lastPotWinner = msg.sender;
160             emit PotWinner(msg.sender, winningReward);
161             pot = 0;
162              }
163        
164     }
165     
166  
167     
168     function withdraw() public{
169         uint256 profit = getProfit(msg.sender);
170         uint256 timelimit = SafeMath.sub(now, launchtime);
171         uint256 maximumProfit = maximumProfitUser();
172         uint256 availableProfit = maximumProfit - userWithdrawals[msg.sender];
173         uint256 maxwithdrawlimit = SafeMath.div(SafeMath.mul(maxwithdraw, investedETH[msg.sender]), 100);
174        
175 
176         require(profit > 0);
177         require(timelimit >= 1728000);
178        
179         lastInvest[msg.sender] = now;
180         lastWithdraw[msg.sender] = now;
181        
182        
183        
184         if(profit < availableProfit){
185         
186         if(profit < maxwithdrawlimit){
187         userWithdrawals[msg.sender] += profit;
188         msg.sender.transfer(profit);
189         }
190         else if(profit >= maxwithdrawlimit){
191         uint256 PartPayment = maxwithdrawlimit;
192         uint256 finalprofit = SafeMath.sub(profit, PartPayment);
193         userWithdrawals[msg.sender] += profit;
194         msg.sender.transfer(PartPayment);
195         investedETH[msg.sender] = SafeMath.add(investedETH[msg.sender], finalprofit);
196         } 
197           
198         }
199         
200         else if(profit >= availableProfit && userWithdrawals[msg.sender] < maximumProfit){
201             uint256 finalPartialPayment = availableProfit;
202             if(finalPartialPayment < maxwithdrawlimit){
203             userWithdrawals[msg.sender] = 0;
204             investedETH[msg.sender] = 0;
205             delete userSequentialDeposits[msg.sender];
206             msg.sender.transfer(finalPartialPayment);
207             }
208              else if(finalPartialPayment >= maxwithdrawlimit){
209              
210         uint256 finalPartPayment = maxwithdrawlimit;
211         uint256 finalprofits = SafeMath.sub(finalPartialPayment, finalPartPayment);
212         userWithdrawals[msg.sender] += finalPartialPayment;
213         msg.sender.transfer(finalPartPayment);
214         investedETH[msg.sender] = SafeMath.add(investedETH[msg.sender], finalprofits);
215         
216         
217              }
218         }
219     
220         
221     }
222    
223     function getProfitFromSender() public view returns(uint256){
224         return getProfit(msg.sender);
225     }
226 
227     function getProfit(address customer) public view returns(uint256){
228         uint256 secondsPassed = SafeMath.sub(now, lastInvest[customer]);
229         uint256 profit = SafeMath.div(SafeMath.mul(secondsPassed, investedETH[customer]), 985010);
230         uint256 maximumProfit = maximumProfitUser();
231         uint256 availableProfit = maximumProfit - userWithdrawals[msg.sender];
232 
233         if(profit > availableProfit && userWithdrawals[msg.sender] < maximumProfit){
234             profit = availableProfit;
235         }
236         
237         uint256 bonus = getBonus();
238         if(bonus == 0){
239             return profit;
240         }
241         return SafeMath.add(profit, SafeMath.div(SafeMath.mul(profit, bonus), 100));
242     }
243     
244     function getBonus() public view returns(uint256){
245         uint256 invested = getInvested();
246         if(invested >= 0.1 ether && 4 ether >= invested){
247             return 0;
248         }else if(invested >= 4.01 ether && 7 ether >= invested){
249             return 20;
250         }else if(invested >= 7.01 ether && 10 ether >= invested){
251             return 40;
252         }else if(invested >= 10.01 ether && 15 ether >= invested){
253             return 60;
254         }else if(invested >= 15.01 ether){
255             return 99;
256         }
257     }
258     
259     function reinvestProfit() public {
260         uint256 profit = getProfit(msg.sender);
261         require(profit > 0);
262         lastInvest[msg.sender] = now;
263         userWithdrawals[msg.sender] += profit;
264         investedETH[msg.sender] = SafeMath.add(investedETH[msg.sender], profit);
265     } 
266  
267    
268     function getAffiliateCommision() public view returns(uint256){
269         return affiliateCommision[msg.sender];
270     }
271     
272     function withdrawAffiliateCommision() public {
273         require(affiliateCommision[msg.sender] > 0);
274         uint256 commision = affiliateCommision[msg.sender];
275         affiliateCommision[msg.sender] = 0;
276         msg.sender.transfer(commision);
277     }
278     
279     function getInvested() public view returns(uint256){
280         return investedETH[msg.sender];
281     }
282     
283     function getBalance() public view returns(uint256){
284         return address(this).balance;
285     }
286 
287     function min(uint256 a, uint256 b) private pure returns (uint256) {
288         return a < b ? a : b;
289     }
290     
291     function max(uint256 a, uint256 b) private pure returns (uint256) {
292         return a > b ? a : b;
293     }
294     
295     function updatePromoter1(address _address) external onlyOwner {
296         require(_address != address(0x0));
297         promoter1 = _address;
298     }
299     
300     function updatePromoter2(address _address) external onlyOwner {
301         require(_address != address(0x0));
302         promoter2 = _address;
303     }
304     
305     
306     
307     
308      function updateMaxpot(uint256 _Maxpot) external onlyOwner {
309         maxpot = _Maxpot;
310     }
311     
312      function updateLaunchtime(uint256 _Launchtime) external onlyOwner {
313         launchtime = _Launchtime;
314     }
315    
316 
317         /**
318   *  function random() internal view returns (bool) {
319         uint maxRange = 2**(8* 7);
320         for(uint8 a = 0 ; a < 8; a++){
321             uint randomNumber = uint( keccak256(abi.encodePacked(msg.sender,blockhash(block.number), block.timestamp )) ) % maxRange;
322            if ((randomNumber % 13) % 19 == 0){
323              return true;
324                 break;
325             }
326         }
327         return false;    
328     }  */
329     
330 }
331 
332 library SafeMath {
333 
334   /**
335   * @dev Multiplies two numbers, throws on overflow.
336   */
337   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
338     if (a == 0) {
339       return 0;
340     }
341     uint256 c = a * b;
342     assert(c / a == b);
343     return c;
344   }
345 
346   /**
347   * @dev Integer division of two numbers, truncating the quotient.
348   */
349   function div(uint256 a, uint256 b) internal pure returns (uint256) {
350     // assert(b > 0); // Solidity automatically throws when dividing by 0
351     uint256 c = a / b;
352     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
353     return c;
354   }
355 
356   /**
357   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
358   */
359   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
360     assert(b <= a);
361     return a - b;
362   }
363 
364   /**
365   * @dev Adds two numbers, throws on overflow.
366   */
367   function add(uint256 a, uint256 b) internal pure returns (uint256) {
368     uint256 c = a + b;
369     assert(c >= a);
370     return c;
371   }
372 }