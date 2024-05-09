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
67 contract HYIPRETHPRO440 is Ownable{
68     using SafeMath for uint256;
69     
70     mapping (address => uint256) public investedETH;
71     mapping (address => uint256) public lastInvest;
72     mapping (address => uint256) public lastWithdraw;
73     
74     mapping (address => uint256) public affiliateCommision;
75     
76     address public dev = address(0xBFb297616fFa0124a288e212d1E6DF5299C9F8d0);
77     address public promoter1 = address(0xdbDf0Ae8DB4549cb5E70e80ad54246C9E325dE4f);
78     address public promoter2 = address(0x522F73DFb71168D4df4afCB1d67Cc4E17b832420);
79     address public promoter3 = address(0x342D8F4120380A435CF895D50B91C0cFbAb7eDbB);
80     address public promoter4 = address(0x5697428D9488a2b84505E6D964bCa96FBfD1Bf19);
81     address public promoter5 = address(0x6aF9E412AC9ED0507376963fC41682a011FfFf25);
82     address public promoter6 = address(0x2f192b34Fa55B8E5C35d8864C253D292949a741c);
83     
84     address public lastPotWinner;
85     
86     uint256 public pot = 0;
87     uint256 public maxpot = 3000000000000000000;
88     uint256 public launchtime = 1554822000;
89     uint256 public maxwithdraw = SafeMath.div(87, 10);
90     uint256 maxprofit = SafeMath.div(44, 10);
91    
92     
93     
94     event PotWinner(address indexed beneficiary, uint256 amount );
95     
96     constructor () public {
97         _owner = address(0xBFb297616fFa0124a288e212d1E6DF5299C9F8d0);
98     }
99     
100     
101       mapping(address => uint256) public userWithdrawals;
102     mapping(address => uint256[]) public userSequentialDeposits;
103     
104     function maximumProfitUser() public view returns(uint256){ 
105         return getInvested() * maxprofit;
106     }
107     
108     function getTotalNumberOfDeposits() public view returns(uint256){
109         return userSequentialDeposits[msg.sender].length;
110     }
111     
112     function() public payable{ }
113     
114     
115     
116       function investETH(address referral) public payable {
117       require(now >= launchtime);
118       require(msg.value >= 0.5 ether);
119       uint256 timelimit = SafeMath.sub(now, launchtime);
120       
121       
122       if(timelimit < 1728000 && getProfit(msg.sender) > 0){
123           reinvestProfit();
124         }
125         
126       if(timelimit > 1728000 && getProfit(msg.sender) > 0){
127             
128              uint256 profit = getProfit(msg.sender);
129              lastInvest[msg.sender] = now;
130              lastWithdraw[msg.sender] = now;
131              userWithdrawals[msg.sender] += profit;
132              msg.sender.transfer(profit);
133  
134            
135         }
136        
137         
138         amount = msg.value;
139         uint256 commision = amount.mul(7).div(100);
140         uint256 commision1 = amount.mul(3).div(100);
141         uint256 commision2 = amount.mul(2).div(100);
142         uint256 _pot = amount.mul(3).div(100);
143         pot = pot.add(_pot);
144         uint256 amount = amount;
145         
146         
147         dev.transfer(commision1);
148         promoter1.transfer(commision1);
149         promoter2.transfer(commision1);
150         promoter3.transfer(commision1);
151         promoter4.transfer(commision1);
152         promoter5.transfer(commision1);
153         promoter6.transfer(commision2);
154        
155         
156         if(referral != msg.sender && referral != 0x1 && referral != promoter1 && referral != promoter2  && referral != promoter3  && referral != promoter4  && referral != promoter5  && referral != promoter6){
157             affiliateCommision[referral] = SafeMath.add(affiliateCommision[referral], commision);
158         }
159         
160         //affiliateCommision[dev] = SafeMath.add(affiliateCommision[dev], commision);
161         
162         
163         investedETH[msg.sender] = investedETH[msg.sender].add(amount);
164         lastInvest[msg.sender] = now;
165         userSequentialDeposits[msg.sender].push(amount);
166         if(pot >= maxpot){
167             uint256 winningReward = pot;
168             msg.sender.transfer(winningReward);
169             lastPotWinner = msg.sender;
170             emit PotWinner(msg.sender, winningReward);
171             pot = 0;
172              }
173        
174     }
175     
176  
177     
178     function withdraw() public{
179         uint256 profit = getProfit(msg.sender);
180         uint256 timelimit = SafeMath.sub(now, launchtime);
181         uint256 maximumProfit = maximumProfitUser();
182         uint256 availableProfit = maximumProfit - userWithdrawals[msg.sender];
183         uint256 maxwithdrawlimit = SafeMath.div(SafeMath.mul(maxwithdraw, investedETH[msg.sender]), 100);
184        
185 
186         require(profit > 0);
187         require(timelimit >= 1728000);
188        
189         lastInvest[msg.sender] = now;
190         lastWithdraw[msg.sender] = now;
191        
192        
193        
194         if(profit < availableProfit){
195         
196         if(profit < maxwithdrawlimit){
197         userWithdrawals[msg.sender] += profit;
198         msg.sender.transfer(profit);
199         }
200         else if(profit >= maxwithdrawlimit){
201         uint256 PartPayment = maxwithdrawlimit;
202         uint256 finalprofit = SafeMath.sub(profit, PartPayment);
203         userWithdrawals[msg.sender] += profit;
204         msg.sender.transfer(PartPayment);
205         investedETH[msg.sender] = SafeMath.add(investedETH[msg.sender], finalprofit);
206         } 
207           
208         }
209         
210         else if(profit >= availableProfit && userWithdrawals[msg.sender] < maximumProfit){
211             uint256 finalPartialPayment = availableProfit;
212             if(finalPartialPayment < maxwithdrawlimit){
213             userWithdrawals[msg.sender] = 0;
214             investedETH[msg.sender] = 0;
215             delete userSequentialDeposits[msg.sender];
216             msg.sender.transfer(finalPartialPayment);
217             }
218              else if(finalPartialPayment >= maxwithdrawlimit){
219              
220         uint256 finalPartPayment = maxwithdrawlimit;
221         uint256 finalprofits = SafeMath.sub(finalPartialPayment, finalPartPayment);
222         userWithdrawals[msg.sender] += finalPartialPayment;
223         msg.sender.transfer(finalPartPayment);
224         investedETH[msg.sender] = SafeMath.add(investedETH[msg.sender], finalprofits);
225         
226         
227              }
228         }
229     
230         
231     }
232    
233     function getProfitFromSender() public view returns(uint256){
234         return getProfit(msg.sender);
235     }
236 
237     function getProfit(address customer) public view returns(uint256){
238         uint256 secondsPassed = SafeMath.sub(now, lastInvest[customer]);
239         uint256 profit = SafeMath.div(SafeMath.mul(secondsPassed, investedETH[customer]), 985010);
240         uint256 maximumProfit = maximumProfitUser();
241         uint256 availableProfit = maximumProfit - userWithdrawals[msg.sender];
242 
243         if(profit > availableProfit && userWithdrawals[msg.sender] < maximumProfit){
244             profit = availableProfit;
245         }
246         
247         uint256 bonus = getBonus();
248         if(bonus == 0){
249             return profit;
250         }
251         return SafeMath.add(profit, SafeMath.div(SafeMath.mul(profit, bonus), 100));
252     }
253     
254     function getBonus() public view returns(uint256){
255         uint256 invested = getInvested();
256         if(invested >= 0.5 ether && 4 ether >= invested){
257             return 0;
258         }else if(invested >= 4.01 ether && 7 ether >= invested){
259             return 20;
260         }else if(invested >= 7.01 ether && 10 ether >= invested){
261             return 40;
262         }else if(invested >= 10.01 ether && 15 ether >= invested){
263             return 60;
264         }else if(invested >= 15.01 ether){
265             return 99;
266         }
267     }
268     
269     function reinvestProfit() public {
270         uint256 profit = getProfit(msg.sender);
271         require(profit > 0);
272         lastInvest[msg.sender] = now;
273         userWithdrawals[msg.sender] += profit;
274         investedETH[msg.sender] = SafeMath.add(investedETH[msg.sender], profit);
275     } 
276  
277    
278     function getAffiliateCommision() public view returns(uint256){
279         return affiliateCommision[msg.sender];
280     }
281     
282     function withdrawAffiliateCommision() public {
283         require(affiliateCommision[msg.sender] > 0);
284         uint256 commision = affiliateCommision[msg.sender];
285         affiliateCommision[msg.sender] = 0;
286         msg.sender.transfer(commision);
287     }
288     
289     function getInvested() public view returns(uint256){
290         return investedETH[msg.sender];
291     }
292     
293     function getBalance() public view returns(uint256){
294         return address(this).balance;
295     }
296 
297     function min(uint256 a, uint256 b) private pure returns (uint256) {
298         return a < b ? a : b;
299     }
300     
301     function max(uint256 a, uint256 b) private pure returns (uint256) {
302         return a > b ? a : b;
303     }
304     
305     function updatePromoter1(address _address) external onlyOwner {
306         require(_address != address(0x0));
307         promoter1 = _address;
308     }
309     
310     function updatePromoter2(address _address) external onlyOwner {
311         require(_address != address(0x0));
312         promoter2 = _address;
313     }
314     
315     function updatePromoter3(address _address) external onlyOwner {
316         require(_address != address(0x0));
317         promoter3 = _address;
318     }
319     
320      function updatePromoter4(address _address) external onlyOwner {
321         require(_address != address(0x0));
322         promoter4 = _address;
323     }
324     
325      function updatePromoter5(address _address) external onlyOwner {
326         require(_address != address(0x0));
327         promoter5 = _address;
328     }
329     
330      function updatePromoter6(address _address) external onlyOwner {
331         require(_address != address(0x0));
332         promoter6 = _address;
333     }
334     
335     
336     
337     
338      function updateMaxpot(uint256 _Maxpot) external onlyOwner {
339         maxpot = _Maxpot;
340     }
341     
342      function updateLaunchtime(uint256 _Launchtime) external onlyOwner {
343         launchtime = _Launchtime;
344     }
345    
346 
347         /**
348   *  function random() internal view returns (bool) {
349         uint maxRange = 2**(8* 7);
350         for(uint8 a = 0 ; a < 8; a++){
351             uint randomNumber = uint( keccak256(abi.encodePacked(msg.sender,blockhash(block.number), block.timestamp )) ) % maxRange;
352            if ((randomNumber % 13) % 19 == 0){
353              return true;
354                 break;
355             }
356         }
357         return false;    
358     }  */
359     
360 }
361 
362 library SafeMath {
363 
364   /**
365   * @dev Multiplies two numbers, throws on overflow.
366   */
367   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
368     if (a == 0) {
369       return 0;
370     }
371     uint256 c = a * b;
372     assert(c / a == b);
373     return c;
374   }
375 
376   /**
377   * @dev Integer division of two numbers, truncating the quotient.
378   */
379   function div(uint256 a, uint256 b) internal pure returns (uint256) {
380     // assert(b > 0); // Solidity automatically throws when dividing by 0
381     uint256 c = a / b;
382     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
383     return c;
384   }
385 
386   /**
387   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
388   */
389   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
390     assert(b <= a);
391     return a - b;
392   }
393 
394   /**
395   * @dev Adds two numbers, throws on overflow.
396   */
397   function add(uint256 a, uint256 b) internal pure returns (uint256) {
398     uint256 c = a + b;
399     assert(c >= a);
400     return c;
401   }
402 }