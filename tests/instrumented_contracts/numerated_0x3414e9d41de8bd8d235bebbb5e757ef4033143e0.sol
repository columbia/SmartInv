1 pragma solidity 0.4.25;
2 
3 /*
4  *  GLOBAL  INVEST FUND PROJECT 130+
5  * Web:         http://Globalinvest.fund 
6  * Twitter:     https://twitter.com/InvestFund_twit?lang=ru 
7  * Telegram:    https://telegram.me/GIFund_Chat
8  * Iinstagram:  https://www.instagram.com/globalinvestfund/
9  * Email:       globalblockchainfund@gmail.com  
10  * 
11  * 
12  *  About the Project
13  * Blockchain-enabled smart contracts have opened a new era of trustless relationships without   intermediaries. 
14  * This technology opens incredible financial possibilities. 
15  * Our automated investment  distribution model is written into a smart contract, uploaded to the Ethereum    blockchain and can be  freely accessed online.
16  * In order to insure our investors' complete security, full control over the  project has been transferred from the organizers to the smart contract: nobody can influence the  system's permanent autonomous functioning.
17  */
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that revert on error
22  */
23 library SafeMath {
24 
25     /**
26     * @dev Multiplies two numbers, reverts on overflow.
27     */
28     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
30         // benefit is lost if 'b' is also tested.
31         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32         if (a == 0) {
33             return 0;
34         }
35 
36         uint256 c = a * b;
37         require(c / a == b);
38 
39         return c;
40     }
41 
42     /**
43     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
44     */
45     function div(uint256 a, uint256 b) internal pure returns (uint256) {
46         require(b > 0); // Solidity only automatically asserts when dividing by 0
47         uint256 c = a / b;
48         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49 
50         return c;
51     }
52 
53     /**
54     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
55     */
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57         require(b <= a);
58         uint256 c = a - b;
59 
60         return c;
61     }
62 
63     /**
64     * @dev Adds two numbers, reverts on overflow.
65     */
66     function add(uint256 a, uint256 b) internal pure returns (uint256) {
67         uint256 c = a + b;
68         require(c >= a);
69 
70         return c;
71     }
72 
73     /**
74     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
75     * reverts when dividing by zero.
76     */
77     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
78         require(b != 0);
79         return a % b;
80     }
81 }
82 
83 library Address {
84     function toAddress(bytes source) internal pure returns(address addr) {
85         assembly { addr := mload(add(source,0x14)) }
86         return addr;
87     }
88 }
89 
90 
91 /**
92  * @title Helps contracts guard against reentrancy attacks.
93  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
94  * @dev If you mark a function `nonReentrant`, you should also
95  * mark it `external`.
96  */
97 contract ReentrancyGuard {
98 
99     /// @dev counter to allow mutex lock with only one SSTORE operation
100     uint256 private _guardCounter;
101 
102     constructor() internal {
103         // The counter starts at one to prevent changing it from zero to a non-zero
104         // value, which is a more expensive operation.
105         _guardCounter = 1;
106     }
107 
108     /**
109      * @dev Prevents a contract from calling itself, directly or indirectly.
110      * Calling a `nonReentrant` function from another `nonReentrant`
111      * function is not supported. It is possible to prevent this from happening
112      * by making the `nonReentrant` function external, and make it call a
113      * `private` function that does the actual work.
114      */
115     modifier nonReentrant() {
116         _guardCounter += 1;
117         uint256 localCounter = _guardCounter;
118         _;
119         require(localCounter == _guardCounter);
120     }
121 
122 }
123 
124 
125 contract GlobalInvestFund130Plus is ReentrancyGuard {
126 
127     using SafeMath for uint;
128     using Address for *;
129 
130     address public marketingAddress;
131     address public techSupportAddress;
132     uint public creationDate;
133     uint constant twoWeeks = 14 days;
134     uint constant oneDay = 1 days;
135     uint constant minInvestment = 100000000000000000 wei;
136     uint constant maxInvestment = 100 ether;
137 
138     struct Investor {
139         uint fullInvestment;
140         uint[] eachInvestmentValues;
141         mapping (uint => uint) timestampsForInvestments;
142         bool isInvestor;
143         bool isLast;
144         bool emergencyAvailable;
145         bool withdrawn;
146     }
147 
148     address[] public allInvestors;
149     mapping (address => Investor) investors;
150     mapping (address => uint) public sendedDividends;
151     mapping (address => uint) public refferalDividends;
152     mapping (address => uint[]) doublePercentsEnd;
153     mapping (address => uint) lastWithdraw;
154 
155     event Invest(address _address, uint _value);
156     event Withdraw(address _address, uint _value);
157 
158     modifier onlyInRangeDeposit() {
159         require(msg.value >= minInvestment && msg.value <= maxInvestment);
160         _;
161     }
162 
163     modifier onlyInvestor() {
164         require(investors[msg.sender].isInvestor && investors[msg.sender].fullInvestment > 0);
165         _;
166     }
167 
168     function() external payable {
169         if(msg.value >= minInvestment && msg.value <= maxInvestment){
170             deposit(msg.data.toAddress());
171         } else {
172             if(msg.value == 112000000000000){
173                 emergencyWithdraw();
174             } else {
175                 if(msg.value == 0){
176                     withdraw();
177                 }
178             }
179         }
180     }
181 
182     constructor(address _marketingAddress, address _techSupportAddress) public {
183         creationDate = block.timestamp;
184         marketingAddress = _marketingAddress;
185         techSupportAddress = _techSupportAddress;
186     }
187 
188     function getDepositAmountFor(address _addr) public view returns(uint){
189         return investors[_addr].fullInvestment;
190     }
191 
192     function calculatePercentsFor(address _addr) external view returns(uint){
193         return calculatePercents(_addr);
194     }
195     
196     function getInvestorsAmount() external view returns(uint){
197         return allInvestors.length;
198     }
199 
200     function deposit(address _refferal) public payable onlyInRangeDeposit {
201 
202         uint investmentValue = msg.value;
203 
204         investmentValue = investmentValue.sub(msg.value.mul(2).div(100));
205         techSupportAddress.transfer(msg.value.mul(2).div(100));
206 
207         investmentValue = investmentValue.sub(msg.value.mul(5).div(100));
208         marketingAddress.transfer(msg.value.mul(5).div(100));
209 
210         // if refferal address is not investor or if it's myself, fine
211         if(!investors[_refferal].isInvestor || _refferal == msg.sender){
212             marketingAddress.transfer(msg.value.mul(2).div(100));
213             investmentValue = investmentValue.sub(msg.value.mul(2).div(100));
214         } else {
215             _refferal.transfer(msg.value.mul(2).div(100));
216             refferalDividends[_refferal] = refferalDividends[_refferal].add(msg.value.mul(2).div(100));
217             investmentValue = investmentValue.sub(msg.value.mul(2).div(100));
218         }
219 
220         // if first investment or investment after emergenct withdraw
221         if(!investors[msg.sender].isInvestor){
222             allInvestors.push(msg.sender);
223             investors[msg.sender].isInvestor = true;
224             investors[msg.sender].isLast = true;
225             if(allInvestors.length > 3) {
226                 doublePercentsEnd[allInvestors[allInvestors.length.sub(4)]].push(block.timestamp);
227                 investors[allInvestors[allInvestors.length.sub(4)]].isLast = false;
228             }
229         }
230 
231         investors[msg.sender].emergencyAvailable = true;
232         investors[msg.sender].fullInvestment = investors[msg.sender].fullInvestment.add(investmentValue);
233         investors[msg.sender].timestampsForInvestments[investors[msg.sender].eachInvestmentValues.length] = block.timestamp;
234         investors[msg.sender].eachInvestmentValues.push(investmentValue);
235 
236         // if investor is not one of the 3 last investors
237         if(!investors[msg.sender].isLast){
238             allInvestors.push(msg.sender);
239             investors[msg.sender].isLast = true;
240             if(allInvestors.length > 3) {
241                 doublePercentsEnd[allInvestors[allInvestors.length.sub(4)]].push(block.timestamp);
242                 investors[allInvestors[allInvestors.length.sub(4)]].isLast = false;
243             }
244         }
245 
246         emit Invest(msg.sender, investmentValue);
247     }
248 
249     function withdraw() public nonReentrant onlyInvestor {
250         require(creationDate.add(twoWeeks)<=block.timestamp);
251         require(lastWithdraw[msg.sender].add(3 days) <= block.timestamp);
252         require(address(this).balance > 0);
253 
254         uint fullDividends;
255         uint marketingFee;
256 
257         investors[msg.sender].emergencyAvailable = false;
258         address receiver = msg.sender;
259 
260         fullDividends = calculatePercents(msg.sender);
261         fullDividends = fullDividends.sub(sendedDividends[receiver]);
262 
263         if(fullDividends < investors[msg.sender].fullInvestment.mul(130).div(100)){
264             marketingFee = fullDividends.mul(5).div(100);
265             marketingAddress.transfer(marketingFee);
266         }
267 
268         lastWithdraw[msg.sender] = block.timestamp;
269         
270         if(address(this).balance >= fullDividends.sub(marketingFee)) {
271             receiver.transfer(fullDividends.sub(marketingFee));
272         } else{
273             receiver.transfer(address(this).balance);
274         }
275 
276         sendedDividends[receiver] = sendedDividends[receiver].add(fullDividends);
277         investors[receiver].withdrawn = true;
278 
279 
280         emit Withdraw(receiver, fullDividends);
281     }
282 
283     function calculatePercents(address _for) internal view returns(uint){
284         uint dividends;
285         uint fullDividends;
286         uint count = 0;
287         for(uint i = 1; i <= investors[_for].eachInvestmentValues.length; i++) {
288             if(i == investors[_for].eachInvestmentValues.length){
289                 if(doublePercentsEnd[_for].length > count && doublePercentsEnd[_for][count] < block.timestamp){
290                     dividends = getDividendsForOnePeriod(investors[_for].timestampsForInvestments[i.sub(1)], block.timestamp, investors[_for].eachInvestmentValues[i.sub(1)], doublePercentsEnd[_for][count++]);
291                 }
292                 else{
293                     dividends = getDividendsForOnePeriod(investors[_for].timestampsForInvestments[i.sub(1)], block.timestamp, investors[_for].eachInvestmentValues[i.sub(1)], 0);
294                 }
295 
296             } else {
297                 if(doublePercentsEnd[_for].length > count && doublePercentsEnd[_for][count] < investors[_for].timestampsForInvestments[i]){
298                     dividends = getDividendsForOnePeriod(investors[_for].timestampsForInvestments[i.sub(1)], investors[_for].timestampsForInvestments[i], investors[_for].eachInvestmentValues[i.sub(1)], doublePercentsEnd[_for][count++]);
299                 }
300                 else {
301                     dividends = getDividendsForOnePeriod(investors[_for].timestampsForInvestments[i.sub(1)], investors[_for].timestampsForInvestments[i], investors[_for].eachInvestmentValues[i.sub(1)], 0);
302                 }
303 
304             }
305             fullDividends = fullDividends.add(dividends);
306         }
307         return fullDividends;
308     }
309 
310     function getDividendsForOnePeriod(uint _startTime, uint _endTime, uint _investmentValue, uint _doublePercentsEnd) internal view returns(uint) {
311         uint fullDaysForDividents = _endTime.sub(_startTime).div(oneDay);
312         uint maxDividends = investors[msg.sender].fullInvestment.mul(130).div(100);
313         uint maxDaysWithFullDividends = maxDividends.div(_investmentValue.mul(35).div(1000));
314         uint maxDaysWithDoubleDividends = maxDividends.div(_investmentValue.mul(7).div(100));
315         uint daysWithDoublePercents;
316 
317         if(_doublePercentsEnd != 0){
318             daysWithDoublePercents = _doublePercentsEnd.sub(_startTime).div(oneDay);
319         } else {
320             daysWithDoublePercents = fullDaysForDividents;
321         }
322 
323         uint dividends;
324 
325         if(daysWithDoublePercents > maxDaysWithDoubleDividends && !investors[msg.sender].withdrawn){
326             dividends = _investmentValue.mul(7).div(100).mul(maxDaysWithDoubleDividends);
327             dividends = dividends.add(_investmentValue.div(100).mul(daysWithDoublePercents.sub(maxDaysWithDoubleDividends)));
328             return dividends;
329         } else {
330             if(daysWithDoublePercents > maxDaysWithDoubleDividends){
331                 dividends = _investmentValue.mul(7).div(100).mul(maxDaysWithDoubleDividends);
332             } else {
333                 dividends = _investmentValue.mul(7).div(100).mul(daysWithDoublePercents);
334             }
335             if(fullDaysForDividents != daysWithDoublePercents){
336                 fullDaysForDividents = fullDaysForDividents.sub(daysWithDoublePercents);
337             } else {
338                 return dividends;
339             }
340 
341             maxDividends = maxDividends.sub(dividends);
342             maxDaysWithFullDividends = maxDividends.div(_investmentValue.mul(35).div(1000));
343 
344             if(fullDaysForDividents > maxDaysWithFullDividends && !investors[msg.sender].withdrawn){
345                 dividends = dividends.add(_investmentValue.mul(35).div(1000).mul(maxDaysWithFullDividends));
346                 dividends = dividends.add(_investmentValue.mul(5).div(1000).mul(fullDaysForDividents.sub(maxDaysWithFullDividends)));
347                 return dividends;
348             } else {
349                 dividends = dividends.add(_investmentValue.mul(35).div(1000).mul(fullDaysForDividents));
350                 return dividends;
351             }
352         }
353     }
354 
355     function emergencyWithdraw() public payable nonReentrant onlyInvestor {
356         require(investors[msg.sender].emergencyAvailable == true);
357 
358         // send 35% of full investment from this address to the tech support address
359         techSupportAddress.transfer(investors[msg.sender].fullInvestment.mul(35).div(100));
360 
361         uint returnValue = investors[msg.sender].fullInvestment.sub(investors[msg.sender].fullInvestment.mul(35).div(100));
362 
363         investors[msg.sender].fullInvestment = 0;
364         investors[msg.sender].isInvestor = false;
365 
366         if(address(this).balance >= returnValue) {
367             // return remaining investments to the investor
368             msg.sender.transfer(returnValue);
369         } else {
370             // if eth is not enough on the contract return remaining eth of the contract to the investor
371             msg.sender.transfer(address(this).balance);
372         }
373 
374 
375         for(uint c = 0; c < investors[msg.sender].eachInvestmentValues.length; c++){
376             investors[msg.sender].eachInvestmentValues[c] = 0;
377         }
378 
379         if(investors[msg.sender].isLast == true){
380             //DELETE from last investors
381             investors[msg.sender].isLast = false;
382             if(allInvestors.length > 3){
383                 for(uint i = allInvestors.length.sub(1); i > allInvestors.length.sub(4); i--){
384                     if(allInvestors[i] == msg.sender){
385                         allInvestors[i] = address(0);
386                     }
387                 }
388             } else {
389                 for(uint y = 0; y < allInvestors.length.sub(1); y++){
390                     if(allInvestors[y] == msg.sender){
391                         allInvestors[y] = address(0);
392                     }
393                 }
394             }
395         }
396     }
397 }