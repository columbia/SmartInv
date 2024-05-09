1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 contract Ownable {
51 
52   address public owner;
53 
54   function Ownable() public {
55     owner = msg.sender;
56   }
57 
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   } 
62 
63   function transferOwnership(address newOwner) public onlyOwner {
64     require(newOwner != address(0));
65     owner = newOwner;
66   }
67 }
68 
69 contract LoveToken {
70   function transfer(address _to, uint256 _value) public returns (bool);
71   function balanceOf(address _owner) public view returns (uint256 balance);
72   function freeze(address target) public returns (bool);
73   function release(address target) public returns (bool);
74 }
75 
76 contract LoveContribution is Ownable {
77 
78   using SafeMath for uint256;
79 
80   //The token being given
81   LoveToken  token;
82   
83   // contribution in wei
84   mapping(address => uint256) public contributionOf;
85   
86   // array of contributors
87   address[] contributors;
88   
89   // array of top contributed winners
90    address[] topWinners=[address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0)];
91   
92   // array of random winners
93   address[] randomWinners;
94   
95   // won amount in wei
96   mapping(address => uint256) public amountWon;
97   
98   // ckeck whether the winner withdrawn the won amount
99   mapping(address => bool) public claimed;
100   
101   // ckeck whether the contributor completed KYC
102   mapping(address => bool) public KYCDone;
103 
104   // start and end timestamps
105   uint256 public startTime;
106   uint256 public endTime;
107 
108   // price of token in wei
109   uint256 public rate = 10e14;
110 
111   // amount of wei raised
112   uint256 public weiRaised;
113   
114   // amount of wei withdrawn by owner
115   uint256 public ownerWithdrawn;
116   
117   event contributionSuccessful(address indexed contributedBy, uint256 contribution, uint256 tokenReceived);
118   event FundTransfer(address indexed beneficiary, uint256 amount);
119   event FundTransferFailed();
120   event KYCApproved(address indexed contributor);
121 
122   function LoveContribution(uint256 _startTime, uint256 _endTime, LoveToken  _token) public {
123     require(_startTime >= now);
124     require(_endTime >= _startTime);
125     require(_token != address(0));
126 
127     startTime = _startTime;
128     endTime = _endTime;
129     token = _token;
130   }
131 
132   // fallback function can be used to buy tokens
133   function () external payable {
134     contribute();
135   }
136     
137    
138   /**
139    * @dev low level token purchase function
140    */
141   function contribute() internal {
142     uint256 weiAmount = msg.value;
143     require(msg.sender != address(0) && weiAmount >= 5e15);
144     require(now >= startTime && now <= endTime);
145     
146     // calculate the number of tokens to be send. multipling with (10 ** 8) since the token used has 8 decimals
147     uint256 numToken = getTokenAmount(weiAmount).mul(10 ** 8);
148     
149     // check whether the contract have enough token balance 
150     require(token.balanceOf(this).sub(numToken) > 0 );
151     
152     // check whether the sender is contributing for the first time
153     if(contributionOf[msg.sender] <= 0){
154         contributors.push(msg.sender);
155         token.freeze(msg.sender);
156     }
157     
158     contributionOf[msg.sender] = contributionOf[msg.sender].add(weiAmount);
159     
160     token.transfer(msg.sender, numToken);
161     
162     weiRaised = weiRaised.add(weiAmount);
163     
164     updateWinnersList();
165     
166     contributionSuccessful(msg.sender,weiAmount,numToken);
167   }
168 
169   // @return Number of tokens
170   function getTokenAmount(uint256 weiAmount) internal returns(uint256) {
171        uint256 tokenAmount;
172        
173         if(weiRaised <= 100 ether){
174             rate = 10e14;
175             tokenAmount = weiAmount.div(rate);
176             return tokenAmount;
177         }
178         else if(weiRaised > 100 ether && weiRaised <= 150 ether){
179             rate = 15e14;
180             tokenAmount = weiAmount.div(rate);
181             return tokenAmount;
182         }
183         else if(weiRaised > 150 ether && weiRaised <= 200 ether){
184             rate = 20e14;
185             tokenAmount = weiAmount.div(rate);
186             return tokenAmount;
187         }
188         else if(weiRaised > 200 ether && weiRaised <= 250 ether){
189             rate = 25e14;
190             tokenAmount = weiAmount.div(rate);
191             return tokenAmount;
192         }
193         else if(weiRaised > 250){
194             rate = 30e14;
195             tokenAmount = weiAmount.div(rate);
196             return tokenAmount;
197         }
198         
199   }
200   
201   // update winners list
202   function updateWinnersList() internal returns(bool) {
203       if(topWinners[0] != msg.sender){
204        bool flag=false;
205        for(uint256 i = 0; i < 10; i++){
206            if(topWinners[i] == msg.sender){
207                break;
208            }
209            if(contributionOf[msg.sender] > contributionOf[topWinners[i]]){
210                flag=true;
211                break;
212            }
213        }
214        if(flag == true){
215            for(uint256 j = 10; j > i; j--){
216                if(topWinners[j-1] != msg.sender){
217                    topWinners[j]=topWinners[j-1];
218                }
219                else{
220                    for(uint256 k = j; k < 10; k++){
221                        topWinners[k]=topWinners[k+1];
222                    }
223                }
224             }
225             topWinners[i]=msg.sender;
226        }
227        return true;
228      }
229   }
230 
231   // @return true if contract is expired
232   function hasEnded() public view returns (bool) {
233     return (now > endTime) ;
234   }
235   
236   /**
237    * @dev Function to find the winners
238    */
239   function findWinners() public onlyOwner {
240     require(now >= endTime);
241     
242     // number of contributors
243     uint256 len=contributors.length;
244     
245     // factor multiplied to get the deserved percentage of weiRaised for a winner
246     uint256 mulFactor=50;
247     
248     // setting top ten winners with won amount 
249     for(uint256 num = 0; num < 10 && num < len; num++){
250       amountWon[topWinners[num]]=(weiRaised.div(1000)).mul(mulFactor);
251       mulFactor=mulFactor.sub(5);
252      }
253      topWinners.length--;
254        
255     // setting next 10 random winners 
256     if(len > 10 && len <= 20 ){
257         for(num = 0 ; num < 20 && num < len; num++){
258             if(amountWon[contributors[num]] <= 0){
259             randomWinners.push(contributors[num]);
260             amountWon[contributors[num]]=(weiRaised.div(1000)).mul(3);
261             }
262         }
263     }
264     else if(len > 20){
265         for(uint256 i = 0 ; i < 10; i++){
266             // finding a random number(winner) excluding the top 10 winners
267             uint256 randomNo=random(i+1) % len;
268             // To avoid multiple wining by same address
269             if(amountWon[contributors[randomNo]] <= 0){
270                 randomWinners.push(contributors[randomNo]);
271                 amountWon[contributors[randomNo]]=(weiRaised.div(1000)).mul(3);
272             }
273             else{
274                 
275                 for(uint256 j = 0; j < len; j++){
276                     randomNo=(randomNo.add(1)) % len;
277                     if(amountWon[contributors[randomNo]] <= 0){
278                         randomWinners.push(contributors[randomNo]);
279                         amountWon[contributors[randomNo]]=(weiRaised.div(1000)).mul(3);
280                         break;
281                     }
282                 }
283             }
284         }    
285     }
286   }
287   
288     
289   /**
290    * @dev Generate a random using the block number and loop count as the seed of randomness.
291    */
292    function random(uint256 count) internal constant returns (uint256) {
293     uint256 rand = block.number.mul(count);
294     return rand;
295   }
296   
297   /**
298    * @dev Function to stop the contribution
299    */
300   function stop() public onlyOwner  {
301     endTime = now ;
302   }
303   
304   /**
305    * @dev Function for withdrawing eth by the owner
306    */
307   function ownerWithdrawal(uint256 amt) public onlyOwner  {
308     // Limit owner from withdrawing not more than 70% 
309     require((amt.add(ownerWithdrawn)) <= (weiRaised.div(100)).mul(70));
310     if (owner.send(amt)) {
311         ownerWithdrawn=ownerWithdrawn.add(amt);
312         FundTransfer(owner, amt);
313     }
314   }
315   
316   /**
317    * @dev Function for approving contributors after KYC
318    */
319   function KYCApprove(address[] contributorsList) public onlyOwner  {
320     for (uint256 i = 0; i < contributorsList.length; i++) {
321         address addr=contributorsList[i];
322         //set KYC Status
323         KYCDone[addr]=true;
324         KYCApproved(addr);
325         token.release(addr);
326     }
327   }
328   
329   /**
330    * @dev Function for withdrawing won amount by the winners
331    */
332   function winnerWithdrawal() public {
333     require(now >= endTime);
334     //check whether winner
335     require(amountWon[msg.sender] > 0);
336     //check whether winner done KYC
337     require(KYCDone[msg.sender]);
338     //check whether winner already withdrawn the won amount 
339     require(!claimed[msg.sender]);
340 
341     if (msg.sender.send(amountWon[msg.sender])) {
342         claimed[msg.sender]=true;
343         FundTransfer(msg.sender,amountWon[msg.sender] );
344     }
345   }
346   
347   // @return Current token balance of this contract
348   function tokensAvailable()public view returns (uint256) {
349     return token.balanceOf(this);
350   }
351   
352   // @return List of top winners
353   function showTopWinners() public view returns (address[]) {
354     require(now >= endTime);
355         return (topWinners);
356   }
357   
358   // @return List of random winners
359   function showRandomWinners() public view returns (address[]) {
360     require(now >= endTime);
361         return (randomWinners);
362   }
363   
364   /**
365    * @dev Function to destroy contract
366    */
367   function destroy() public onlyOwner {
368     require(now >= endTime);
369     uint256 balance= this.balance;
370     owner.transfer(balance);
371     FundTransfer(owner, balance);
372     uint256 balanceToken = tokensAvailable();
373     token.transfer(owner, balanceToken);
374     selfdestruct(owner);
375   }
376 }