1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address public owner;
42 
43 
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   function Ownable() {
52     owner = msg.sender;
53   }
54 
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address newOwner) onlyOwner public {
70     require(newOwner != address(0));
71     OwnershipTransferred(owner, newOwner);
72     owner = newOwner;
73   }
74 }
75 
76 /**
77  * @title Pausable
78  * @dev Base contract which allows children to implement an emergency stop mechanism.
79  */
80 contract Pausable is Ownable {
81   event Pause();
82   event Unpause();
83 
84   bool public paused = false;
85 
86 
87   /**
88    * @dev Modifier to make a function callable only when the contract is not paused.
89    */
90   modifier whenNotPaused() {
91     require(!paused);
92     _;
93   }
94 
95   /**
96    * @dev Modifier to make a function callable only when the contract is paused.
97    */
98   modifier whenPaused() {
99     require(paused);
100     _;
101   }
102 
103   /**
104    * @dev called by the owner to pause, triggers stopped state
105    */
106   function pause() onlyOwner whenNotPaused public {
107     paused = true;
108     Pause();
109   }
110 
111   /**
112    * @dev called by the owner to unpause, returns to normal state
113    */
114   function unpause() onlyOwner whenPaused public {
115     paused = false;
116     Unpause();
117   }
118 }
119 
120 
121 contract InvestorsList is Ownable {
122     using SafeMath for uint;
123 
124     /* Investor */
125 
126     enum WhiteListStatus  {Usual, WhiteList, PreWhiteList}
127 
128     struct Investor {
129         bytes32 id;
130         uint tokensCount;
131         address walletForTokens;
132         WhiteListStatus whiteListStatus;
133         bool isVerified;
134     }
135 
136     /*Investor's end*/
137 
138     mapping (address => bool) manipulators;
139     mapping (address => bytes32) public nativeInvestorsIds;
140     mapping (bytes32 => Investor) public investorsList;
141 
142     /*Manipulators*/
143 
144     modifier allowedToManipulate(){
145         require(manipulators[msg.sender] || msg.sender == owner);
146         _;
147     }
148 
149     function changeManipulatorAddress(address saleAddress, bool isAllowedToManipulate) external onlyOwner{
150         require(saleAddress != 0x0);
151         manipulators[saleAddress] = isAllowedToManipulate;
152     }
153 
154     /*Manipulators' end*/
155 
156     function setInvestorId(address investorAddress, bytes32 id) external onlyOwner{
157         require(investorAddress != 0x0 && id != 0);
158         nativeInvestorsIds[investorAddress] = id;
159     }
160 
161     function addInvestor(
162         bytes32 id,
163         WhiteListStatus status,
164         bool isVerified
165     ) external onlyOwner {
166         require(id != 0);
167         require(investorsList[id].id == 0);
168 
169         investorsList[id].id = id;
170         investorsList[id].tokensCount = 0;
171         investorsList[id].whiteListStatus = status;
172         investorsList[id].isVerified = isVerified;
173     }
174 
175     function removeInvestor(bytes32 id) external onlyOwner {
176         require(id != 0 && investorsList[id].id != 0);
177         investorsList[id].id = 0;
178     }
179 
180     function isAllowedToBuyByAddress(address investor) external view returns(bool){
181         require(investor != 0x0);
182         bytes32 id = nativeInvestorsIds[investor];
183         require(id != 0 && investorsList[id].id != 0);
184         return investorsList[id].isVerified;
185     }
186 
187     function isAllowedToBuyByAddressWithoutVerification(address investor) external view returns(bool){
188         require(investor != 0x0);
189         bytes32 id = nativeInvestorsIds[investor];
190         require(id != 0 && investorsList[id].id != 0);
191         return true;
192     }
193 
194     function isAllowedToBuy(bytes32 id) external view returns(bool){
195         require(id != 0 && investorsList[id].id != 0);
196         return investorsList[id].isVerified;
197     }
198 
199     function isPreWhiteListed(bytes32 id) external constant returns(bool){
200         require(id != 0 && investorsList[id].id != 0);
201         return investorsList[id].whiteListStatus == WhiteListStatus.PreWhiteList;
202     }
203 
204     function isWhiteListed(bytes32 id) external view returns(bool){
205         require(id != 0 && investorsList[id].id != 0);
206         return investorsList[id].whiteListStatus == WhiteListStatus.WhiteList;
207     }
208 
209     function setVerificationStatus(bytes32 id, bool status) external onlyOwner{
210         require(id != 0 && investorsList[id].id != 0);
211         investorsList[id].isVerified = status;
212     }
213 
214     function setWhiteListStatus(bytes32 id, WhiteListStatus status) external onlyOwner{
215         require(id != 0 && investorsList[id].id != 0);
216         investorsList[id].whiteListStatus = status;
217     }
218 
219     function addTokens(bytes32 id, uint tokens) external allowedToManipulate{
220         require(id != 0 && investorsList[id].id != 0);
221         investorsList[id].tokensCount = investorsList[id].tokensCount.add(tokens);
222     }
223 
224     function subTokens(bytes32 id, uint tokens) external allowedToManipulate{
225         require(id != 0 && investorsList[id].id != 0);
226         investorsList[id].tokensCount = investorsList[id].tokensCount.sub(tokens);
227     }
228 
229     function setWalletForTokens(bytes32 id, address wallet) external onlyOwner{
230         require(id != 0 && investorsList[id].id != 0);
231         investorsList[id].walletForTokens = wallet;
232     }
233 }
234 
235 contract BonumPreSale is Pausable{
236     using SafeMath for uint;
237 
238     string public constant name = "Bonum PreSale";
239 
240     uint public startDate;
241     uint public endDate;
242     uint public whiteListPreSaleDuration = 1 days;
243 
244     function setWhiteListDuration(uint duration) external onlyOwner{
245         require(duration > 0);
246         whiteListPreSaleDuration = duration * 1 days;
247     }
248 
249     uint public fiatValueMultiplier = 10**6;
250     uint public tokenDecimals = 10**18;
251 
252     InvestorsList public investors;
253 
254     address beneficiary;
255 
256     uint public ethUsdRate;
257     uint public collected = 0;
258     uint public tokensSold = 0;
259     uint public tokensSoldWithBonus = 0;
260 
261     uint[] firstColumn;
262     uint[] secondColumn;
263 
264     event NewContribution(address indexed holder, uint tokenAmount, uint etherAmount);
265 
266     function BonumPreSale(
267         uint _startDate,
268         uint _endDate,
269         address _investors,
270         address _beneficiary,
271         uint _baseEthUsdRate
272     ) public {
273         startDate = _startDate;
274         endDate = _endDate;
275 
276         investors = InvestorsList(_investors);
277         beneficiary = _beneficiary;
278 
279         ethUsdRate = _baseEthUsdRate;
280 
281         initBonusSystem();
282     }
283 
284 
285     function initBonusSystem() private{
286         firstColumn.push(1750000);
287         firstColumn.push(10360000);
288         firstColumn.push(18980000);
289         firstColumn.push(25000000);
290 
291         secondColumn.push(1560000);
292         secondColumn.push(9220000);
293         secondColumn.push(16880000);
294         secondColumn.push(22230000);
295     }
296 
297     function setNewBeneficiary(address newBeneficiary) external onlyOwner {
298         require(newBeneficiary != 0x0);
299         beneficiary = newBeneficiary;
300     }
301 
302     function setEthUsdRate(uint rate) external onlyOwner {
303         require(rate > 0);
304         ethUsdRate = rate;
305     }
306 
307     function setNewStartDate(uint newStartDate) external onlyOwner{
308         require(newStartDate > 0);
309         startDate = newStartDate;
310     }
311 
312     function setNewEndDate(uint newEndDate) external onlyOwner{
313         require(newEndDate > 0);
314         endDate = newEndDate;
315     }
316 
317     function setNewInvestorsList(address investorsList) external onlyOwner {
318         require(investorsList != 0x0);
319         investors = InvestorsList(investorsList);
320     }
321 
322     modifier activePreSale(){
323         require(now >= startDate && now < endDate);
324         _;
325     }
326 
327     modifier underCap(){
328         require(tokensSold < uint(750000).mul(tokenDecimals));
329         _;
330     }
331 
332     modifier isAllowedToBuy(){
333         require(investors.isAllowedToBuyByAddressWithoutVerification(msg.sender));
334         _;
335     }
336 
337     modifier minimumAmount(){
338         require(msg.value.mul(ethUsdRate).div(fiatValueMultiplier.mul(1 ether)) >= 100);
339         _;
340     }
341 
342     mapping (address => uint) public nativeInvestors;
343 
344     function() payable public whenNotPaused activePreSale minimumAmount underCap{
345         uint tokens = msg.value.mul(ethUsdRate).div(fiatValueMultiplier);
346         tokensSold = tokensSold.add(tokens);
347         
348         tokens = tokens.add(calculateBonus(tokens));
349         nativeInvestors[msg.sender] = tokens;
350         tokensSoldWithBonus =  tokensSoldWithBonus.add(tokens);
351         
352         nativeInvestors[msg.sender] = tokens;
353         NewContribution(msg.sender, tokens, msg.value);
354 
355         collected = collected.add(msg.value);
356 
357         beneficiary.transfer(msg.value);
358     }
359 
360 
361     //usd * 10^6
362     function otherCoinsPurchase(bytes32 id, uint amountInUsd) external whenNotPaused underCap activePreSale onlyOwner {
363         require(id.length > 0 && amountInUsd >= (uint(100).mul(fiatValueMultiplier)) && investors.isAllowedToBuy(id));
364 
365         uint tokens = amountInUsd.mul(tokenDecimals).div(fiatValueMultiplier);
366 
367         tokensSold = tokensSold.add(tokens);
368         tokens = tokens.add(calculateBonus(tokens));
369         tokensSoldWithBonus =  tokensSoldWithBonus.add(tokens);
370 
371         investors.addTokens(id, tokens);
372     }
373 
374 
375     function calculateBonus(uint tokensCount) public constant returns (uint){
376         //+1 because needs whole days
377         uint day = ((now.sub(startDate.add(whiteListPreSaleDuration))).div(1 days)).add(1);
378         uint B1;
379         uint B2;
380 
381         if (tokensCount < uint(1000).mul(tokenDecimals)) {
382             B1 = (((tokensCount - 100 * tokenDecimals) * (firstColumn[1] - firstColumn[0])) /  ((1000-100) * tokenDecimals)) + firstColumn[0];
383             B2 = (((tokensCount - 100 * tokenDecimals) * (secondColumn[1] - secondColumn[0])) /  ((1000-100) * tokenDecimals)) + secondColumn[0];
384         }
385 
386         if (tokensCount >= uint(1000).mul(tokenDecimals) && tokensCount < uint(10000).mul(tokenDecimals)) {
387             B1 = (((tokensCount - 1000 * tokenDecimals) * (firstColumn[2] - firstColumn[1])) / ((10000-1000) * tokenDecimals)) + firstColumn[1];
388             B2 = (((tokensCount - 1000 * tokenDecimals) * (secondColumn[2] - secondColumn[1])) / ((10000-1000) * tokenDecimals)) + secondColumn[1];
389         }
390 
391         if (tokensCount >= uint(10000).mul(tokenDecimals) && tokensCount < uint(50000).mul(tokenDecimals)) {
392             B1 = (((tokensCount - 10000 * tokenDecimals) * (firstColumn[3] - firstColumn[2])) / ((50000-10000) * tokenDecimals)) + firstColumn[2];
393             B2 = (((tokensCount - 10000 * tokenDecimals) * (secondColumn[3] - secondColumn[2])) / ((50000-10000) * tokenDecimals)) + secondColumn[2];
394         }
395 
396         if (tokensCount >=  uint(50000).mul(tokenDecimals)) {
397             B1 = firstColumn[3];
398             B2 = secondColumn[3];
399         }
400 
401         uint bonusPercent = B1.sub(((day - 1).mul(B1 - B2)).div(12));
402 
403         return calculateBonusTokensAmount(tokensCount, bonusPercent);
404     }
405 
406     function calculateBonusTokensAmount(uint tokensCount, uint bonusPercent) private constant returns(uint){
407         uint bonus = tokensCount.mul(bonusPercent);
408         bonus = bonus.div(100);
409         bonus = bonus.div(fiatValueMultiplier);
410         return bonus;
411     }
412 }