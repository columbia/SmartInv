1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56     function totalSupply() public view returns (uint256);
57     function balanceOf(address who) public view returns (uint256);
58     function transfer(address to, uint256 value) public returns (bool);
59     event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract ERC20 is ERC20Basic {
67     function allowance(address owner, address spender) public view returns (uint256);
68     function transferFrom(address from, address to, uint256 value) public returns (bool);
69     function approve(address spender, uint256 value) public returns (bool);
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 contract NervesSmartStaking{
74 
75     using SafeMath for uint;
76     ERC20 public token;
77 
78     struct Contribution{
79         uint amount;
80         uint time;
81     }
82 
83     struct User{
84         address user;
85         uint amountAvailableToWithdraw;
86         bool exists;
87         uint totalAmount;
88         uint totalBonusReceived;
89         uint withdrawCount;
90         Contribution[] contributions;       
91     }
92 
93     mapping(address => User) public users;
94     
95     address[] usersList;
96     address owner;
97 
98     uint public totalTokensDeposited;
99 
100     uint public indexOfPayee;
101     uint public EthBonus;
102     uint public stakeContractBalance;
103     uint public bonusRate;
104 
105     uint public indexOfEthSent;
106 
107     bool public depositStatus;
108 
109 
110 
111     modifier onlyOwner(){
112         require(msg.sender == owner);
113         _;
114     }
115 
116     constructor(address _token, uint _bonusRate) public {
117         token = ERC20(_token);
118         owner = msg.sender;
119         bonusRate = _bonusRate;
120     }
121 
122     event OwnerChanged(address newOwner);
123 
124     function ChangeOwner(address _newOwner) public onlyOwner {
125         require(_newOwner != 0x0);
126         require(_newOwner != owner);
127         owner = _newOwner;
128 
129         emit OwnerChanged(_newOwner);
130     }
131 
132     event BonusChanged(uint newBonus);
133 
134     function ChangeBonus(uint _newBonus) public onlyOwner {
135         require(_newBonus > 0);
136         bonusRate = _newBonus;
137 
138         emit BonusChanged(_newBonus);
139     }
140 
141     event Deposited(address from, uint amount);
142 
143     function Deposit(uint _value) public returns(bool) {
144         require(depositStatus);
145         require(_value >= 50000 * (10 ** 18));
146         require(token.allowance(msg.sender, address(this)) >= _value);
147 
148         User storage user = users[msg.sender];
149 
150         if(!user.exists){
151             usersList.push(msg.sender);
152             user.user = msg.sender;
153             user.exists = true;
154         }
155         user.totalAmount = user.totalAmount.add(_value);
156         totalTokensDeposited = totalTokensDeposited.add(_value);
157         user.contributions.push(Contribution(_value, now));
158         token.transferFrom(msg.sender, address(this), _value);
159 
160         stakeContractBalance = token.balanceOf(address(this));
161 
162         emit Deposited(msg.sender, _value);
163 
164         return true;
165 
166     }
167 
168     function ChangeDepositeStatus(bool _status) public onlyOwner{
169         depositStatus = _status;
170     }
171 
172     function StakeMultiSendToken() public onlyOwner {
173         uint i = indexOfPayee;
174         
175         while(i<usersList.length && msg.gas > 90000){
176             User storage currentUser = users[usersList[i]];
177             
178             uint amount = 0;
179             for(uint q = 0; q < currentUser.contributions.length; q++){
180                 if(now > currentUser.contributions[q].time + 24 hours && now < currentUser.contributions[q].time + 84 days){
181                     amount = amount.add(currentUser.contributions[q].amount);
182                 }
183             }
184             
185             if(amount >= 40000 * (10 ** 18) && amount < 50000 * (10 ** 18)){  //TODO
186                 uint bonus = amount.mul(bonusRate).div(10000);
187 
188                 require(token.balanceOf(address(this)) >= bonus);
189                 currentUser.totalBonusReceived = currentUser.totalBonusReceived.add(bonus);
190                
191                 require(token.transfer(currentUser.user, bonus));
192             }
193             i++;
194         }
195 
196         indexOfPayee = i;
197         if( i == usersList.length){
198             indexOfPayee = 0;
199         }
200         stakeContractBalance = token.balanceOf(address(this));
201     }
202 
203     function SuperStakeMultiSendToken() public onlyOwner {
204         uint i = indexOfPayee;
205         
206         while(i<usersList.length && msg.gas > 90000){
207             User storage currentUser = users[usersList[i]];
208             
209             uint amount = 0;
210             for(uint q = 0; q < currentUser.contributions.length; q++){
211                 if(now > currentUser.contributions[q].time + 24 hours && now < currentUser.contributions[q].time + 84 days){
212                     amount = amount.add(currentUser.contributions[q].amount);
213                 }
214             }
215             
216             if(amount >= 50000000 * (10 ** 18) && amount < 200000000 * (10 ** 18)){  //TODO
217                 uint bonus = amount.mul(bonusRate).div(10000);
218 
219                 require(token.balanceOf(address(this)) >= bonus);
220                 currentUser.totalBonusReceived = currentUser.totalBonusReceived.add(bonus);
221                
222                 require(token.transfer(currentUser.user, bonus));
223             }
224             i++;
225         }
226 
227         indexOfPayee = i;
228         if( i == usersList.length){
229             indexOfPayee = 0;
230         }
231         stakeContractBalance = token.balanceOf(address(this));
232     }
233 
234     function MasterStakeMultiSendToken() public onlyOwner {
235         uint i = indexOfPayee;
236             
237         while(i<usersList.length && msg.gas > 90000){
238             User storage currentUser = users[usersList[i]];
239                 
240             uint amount = 0;
241             for(uint q = 0; q < currentUser.contributions.length; q++){
242                 if(now > currentUser.contributions[q].time + 24 hours && now < currentUser.contributions[q].time + 84 days){
243                     amount = amount.add(currentUser.contributions[q].amount);
244                 }
245             }
246                 
247             if(amount >= 200000000 * (10 ** 18)){  //TODO
248                 uint bonus = amount.mul(bonusRate).div(10000);
249 
250                 require(token.balanceOf(address(this)) >= bonus);
251                 currentUser.totalBonusReceived = currentUser.totalBonusReceived.add(bonus);
252                 
253                 require(token.transfer(currentUser.user, bonus));
254             }
255             i++;
256         }
257 
258         indexOfPayee = i;
259         if( i == usersList.length){
260             indexOfPayee = 0;
261         }
262         stakeContractBalance = token.balanceOf(address(this));
263     }
264 
265     event EthBonusSet(uint bonus);
266     function SetEthBonus(uint _EthBonus) public onlyOwner {
267         require(_EthBonus > 0);
268         EthBonus = _EthBonus;
269         stakeContractBalance = token.balanceOf(address(this));
270         indexOfEthSent = 0;
271 
272         emit EthBonusSet(_EthBonus);
273     } 
274 
275     function StakeMultiSendEth() public onlyOwner {
276         require(EthBonus > 0);
277         require(stakeContractBalance > 0);
278         uint p = indexOfEthSent;
279 
280         while(p<usersList.length && msg.gas > 90000){
281             User memory currentUser = users[usersList[p]];
282             
283             uint amount = 0;
284             for(uint q = 0; q < currentUser.contributions.length; q++){
285                 if(now > currentUser.contributions[q].time + 85 days){
286                     amount = amount.add(currentUser.contributions[q].amount);
287                 }
288             }            
289             if(amount >= 40000 * (10 ** 18) && amount < 50000 * (10 ** 18)){  //TODO
290                 uint EthToSend = EthBonus.mul(amount).div(totalTokensDeposited);
291                 
292                 require(address(this).balance >= EthToSend);
293                 currentUser.user.transfer(EthToSend);
294             }
295             p++;
296         }
297 
298         indexOfEthSent = p;
299 
300     }
301 
302     function SuperStakeMultiSendEth() public onlyOwner {
303         require(EthBonus > 0);
304         require(stakeContractBalance > 0);
305         uint p = indexOfEthSent;
306 
307         while(p<usersList.length && msg.gas > 90000){
308             User memory currentUser = users[usersList[p]];
309             
310             uint amount = 0;
311             for(uint q = 0; q < currentUser.contributions.length; q++){
312                 if(now > currentUser.contributions[q].time + 85 days){
313                     amount = amount.add(currentUser.contributions[q].amount);
314                 }
315             }            
316             if(amount >= 50000000 * (10 ** 18) && amount < 200000000 * (10 ** 18)){  //TODO
317                 uint EthToSend = EthBonus.mul(amount).div(totalTokensDeposited);
318                 
319                 require(address(this).balance >= EthToSend);
320                 currentUser.user.transfer(EthToSend);
321             }
322             p++;
323         }
324 
325         indexOfEthSent = p;
326 
327     }
328 
329     function MasterStakeMultiSendEth() public onlyOwner {
330         require(EthBonus > 0);
331         require(stakeContractBalance > 0);
332         uint p = indexOfEthSent;
333 
334         while(p<usersList.length && msg.gas > 90000){
335             User memory currentUser = users[usersList[p]];
336             
337             uint amount = 0;
338             for(uint q = 0; q < currentUser.contributions.length; q++){
339                 if(now > currentUser.contributions[q].time + 85 days){
340                     amount = amount.add(currentUser.contributions[q].amount);
341                 }
342             }            
343             if(amount >= 200000000 * (10 ** 18)){  //TODO
344                 uint EthToSend = EthBonus.mul(amount).div(totalTokensDeposited);
345                 
346                 require(address(this).balance >= EthToSend);
347                 currentUser.user.transfer(EthToSend);
348             }
349             p++;
350         }
351 
352         indexOfEthSent = p;
353 
354     }
355 
356     event MultiSendComplete(bool status);
357     function MultiSendTokenComplete() public onlyOwner {
358         indexOfPayee = 0;
359         emit MultiSendComplete(true);
360     }
361 
362     event Withdrawn(address withdrawnTo, uint amount);
363     function WithdrawTokens(uint _value) public {
364         require(_value > 0);
365 
366         User storage user = users[msg.sender];
367 
368         for(uint q = 0; q < user.contributions.length; q++){
369             if(now > user.contributions[q].time + 4 weeks){
370                 user.amountAvailableToWithdraw = user.amountAvailableToWithdraw.add(user.contributions[q].amount);
371             }
372         }
373 
374         require(_value <= user.amountAvailableToWithdraw);
375         require(token.balanceOf(address(this)) >= _value);
376 
377         user.amountAvailableToWithdraw = user.amountAvailableToWithdraw.sub(_value);
378         user.totalAmount = user.totalAmount.sub(_value);
379 
380         user.withdrawCount = user.withdrawCount.add(1);
381 
382         totalTokensDeposited = totalTokensDeposited.sub(_value);
383         token.transfer(msg.sender, _value);
384 
385         stakeContractBalance = token.balanceOf(address(this));
386         emit Withdrawn(msg.sender, _value);
387 
388 
389     }
390 
391 
392     function() public payable{
393 
394     }
395 
396     function WithdrawETH(uint amount) public onlyOwner{
397         require(amount > 0);
398         require(address(this).balance >= amount * 1 ether);
399 
400         msg.sender.transfer(amount * 1 ether);
401     }
402 
403     function CheckAllowance() public view returns(uint){
404         uint allowance = token.allowance(msg.sender, address(this));
405         return allowance;
406     }
407 
408     function GetBonusReceived() public view returns(uint){
409         User memory user = users[msg.sender];
410         return user.totalBonusReceived;
411     }
412     
413     function GetContributionsCount() public view returns(uint){
414         User memory user = users[msg.sender];
415         return user.contributions.length;
416     }
417 
418     function GetWithdrawCount() public view returns(uint){
419         User memory user = users[msg.sender];
420         return user.withdrawCount;
421     }
422 
423     function GetLockedTokens() public view returns(uint){
424         User memory user = users[msg.sender];
425 
426         uint i;
427         uint lockedTokens = 0;
428         for(i = 0; i < user.contributions.length; i++){
429             if(now < user.contributions[i].time + 24 hours){
430                 lockedTokens = lockedTokens.add(user.contributions[i].amount);
431             }
432         }
433 
434         return lockedTokens;
435 
436     }
437 
438     function ReturnTokens(address destination, address account, uint amount) public onlyOwner{
439         ERC20(destination).transfer(account,amount);
440     }
441    
442 }