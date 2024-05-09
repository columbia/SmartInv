1 pragma solidity 0.4.18;
2 
3 
4 /*
5  * https://github.com/OpenZeppelin/zeppelin-solidity
6  *
7  * The MIT License (MIT)
8  * Copyright (c) 2016 Smart Contract Solutions, Inc.
9  */
10 library SafeMath {
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         if (a == 0) {
13             return 0;
14         }
15         uint256 c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         assert(b <= a);
29         return a - b;
30     }
31 
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         assert(c >= a);
35         return c;
36     }
37 }
38 
39 
40 /*
41  * https://github.com/OpenZeppelin/zeppelin-solidity
42  *
43  * The MIT License (MIT)
44  * Copyright (c) 2016 Smart Contract Solutions, Inc.
45  */
46 contract Ownable {
47     address public owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
53      * account.
54      */
55     function Ownable() public {
56         owner = msg.sender;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(msg.sender == owner);
64         _;
65     }
66 
67     /**
68      * @dev Allows the current owner to transfer control of the contract to a newOwner.
69      * @param newOwner The address to transfer ownership to.
70      */
71     function transferOwnership(address newOwner) public onlyOwner {
72         require(newOwner != address(0));
73         OwnershipTransferred(owner, newOwner);
74         owner = newOwner;
75     }
76 }
77 
78 
79 /**
80  * @title Token interface compatible with ICO Crowdsale
81  * @author Jakub Stefanski (https://github.com/jstefanski)
82  * @author Wojciech Harzowski (https://github.com/harzo)
83  * @author Dominik Kroliczek (https://github.com/kruligh)
84  *
85  * https://github.com/OnLivePlatform/onlive-contracts
86  *
87  * The BSD 3-Clause Clear License
88  * Copyright (c) 2018 OnLive LTD
89  */
90 contract IcoToken {
91     uint256 public decimals;
92 
93     function transfer(address to, uint256 amount) public;
94     function mint(address to, uint256 amount) public;
95     function burn(uint256 amount) public;
96 
97     function balanceOf(address who) public view returns (uint256);
98 }
99 
100 
101 /**
102  * @title ICO Crowdsale with multiple price tiers and limited supply
103  * @author Jakub Stefanski (https://github.com/jstefanski)
104  * @author Wojciech Harzowski (https://github.com/harzo)
105  * @author Dominik Kroliczek (https://github.com/kruligh)
106  *
107  * https://github.com/OnLivePlatform/onlive-contracts
108  *
109  * The BSD 3-Clause Clear License
110  * Copyright (c) 2018 OnLive LTD
111  */
112 contract IcoCrowdsale is Ownable {
113 
114     using SafeMath for uint256;
115 
116     /**
117      * @dev Structure representing price tier
118      */
119     struct Tier {
120         /**
121         * @dev The first block of the tier (inclusive)
122         */
123         uint256 startBlock;
124         /**
125         * @dev Price of token in Wei
126         */
127         uint256 price;
128     }
129 
130     /**
131      * @dev Address of contribution wallet
132      */
133     address public wallet;
134 
135     /**
136      * @dev Address of compatible token instance
137      */
138     IcoToken public token;
139 
140     /**
141      * @dev Minimum ETH value sent as contribution
142      */
143     uint256 public minValue;
144 
145     /**
146      * @dev Indicates whether contribution identified by bytes32 id is already registered
147      */
148     mapping (bytes32 => bool) public isContributionRegistered;
149 
150     /**
151      * @dev Stores price tiers in chronological order
152      */
153     Tier[] private tiers;
154 
155     /**
156     * @dev The last block of crowdsale (inclusive)
157     */
158     uint256 public endBlock;
159 
160     modifier onlySufficientValue(uint256 value) {
161         require(value >= minValue);
162         _;
163     }
164 
165     modifier onlyUniqueContribution(bytes32 id) {
166         require(!isContributionRegistered[id]);
167         _;
168     }
169 
170     modifier onlyActive() {
171         require(isActive());
172         _;
173     }
174 
175     modifier onlyFinished() {
176         require(isFinished());
177         _;
178     }
179 
180     modifier onlyScheduledTiers() {
181         require(tiers.length > 0);
182         _;
183     }
184 
185     modifier onlyNotFinalized() {
186         require(!isFinalized());
187         _;
188     }
189 
190     modifier onlySubsequentBlock(uint256 startBlock) {
191         if (tiers.length > 0) {
192             require(startBlock > tiers[tiers.length - 1].startBlock);
193         }
194         _;
195     }
196 
197     modifier onlyNotZero(uint256 value) {
198         require(value != 0);
199         _;
200     }
201 
202     modifier onlyValid(address addr) {
203         require(addr != address(0));
204         _;
205     }
206 
207     function IcoCrowdsale(
208         address _wallet,
209         IcoToken _token,
210         uint256 _minValue
211     )
212         public
213         onlyValid(_wallet)
214         onlyValid(_token)
215     {
216         wallet = _wallet;
217         token = _token;
218         minValue = _minValue;
219     }
220 
221     /**
222      * @dev Contribution is accepted
223      * @param contributor address The recipient of the tokens
224      * @param value uint256 The amount of contributed ETH
225      * @param amount uint256 The amount of tokens
226      */
227     event ContributionAccepted(address indexed contributor, uint256 value, uint256 amount);
228 
229     /**
230      * @dev Off-chain contribution registered
231      * @param id bytes32 A unique contribution id
232      * @param contributor address The recipient of the tokens
233      * @param amount uint256 The amount of tokens
234      */
235     event ContributionRegistered(bytes32 indexed id, address indexed contributor, uint256 amount);
236 
237     /**
238      * @dev Tier scheduled with given start block and price
239      * @param startBlock uint256 The first block of tier activation (inclusive)
240      * @param price uint256 The price active during tier
241      */
242     event TierScheduled(uint256 startBlock, uint256 price);
243 
244     /**
245      * @dev Crowdsale end block scheduled
246      * @param availableAmount uint256 The amount of tokens available in crowdsale
247      * @param endBlock uint256 The last block of crowdsale (inclusive)
248      */
249     event Finalized(uint256 endBlock, uint256 availableAmount);
250 
251     /**
252      * @dev Unsold tokens burned
253      */
254     event RemainsBurned(uint256 burnedAmount);
255 
256     /**
257      * @dev Accept ETH transfers as contributions
258      */
259     function () public payable {
260         acceptContribution(msg.sender, msg.value);
261     }
262 
263     /**
264      * @dev Contribute ETH in exchange for tokens
265      * @param contributor address The address that receives tokens
266      * @return uint256 Amount of received ONL tokens
267      */
268     function contribute(address contributor) public payable returns (uint256) {
269         return acceptContribution(contributor, msg.value);
270     }
271 
272     /**
273      * @dev Register contribution with given id
274      * @param id bytes32 A unique contribution id
275      * @param contributor address The recipient of the tokens
276      * @param amount uint256 The amount of tokens
277      */
278     function registerContribution(bytes32 id, address contributor, uint256 amount)
279         public
280         onlyOwner
281         onlyActive
282         onlyValid(contributor)
283         onlyNotZero(amount)
284         onlyUniqueContribution(id)
285     {
286         isContributionRegistered[id] = true;
287 
288         token.transfer(contributor, amount);
289 
290         ContributionRegistered(id, contributor, amount);
291     }
292 
293     /**
294      * @dev Schedule price tier
295      * @param _startBlock uint256 Block when the tier activates, inclusive
296      * @param _price uint256 The price of the tier
297      */
298     function scheduleTier(uint256 _startBlock, uint256 _price)
299         public
300         onlyOwner
301         onlyNotFinalized
302         onlySubsequentBlock(_startBlock)
303         onlyNotZero(_startBlock)
304         onlyNotZero(_price)
305     {
306         tiers.push(
307             Tier({
308                 startBlock: _startBlock,
309                 price: _price
310             })
311         );
312 
313         TierScheduled(_startBlock, _price);
314     }
315 
316     /**
317      * @dev Schedule crowdsale end
318      * @param _endBlock uint256 The last block end of crowdsale (inclusive)
319      * @param _availableAmount uint256 Amount of tokens available in crowdsale
320      */
321     function finalize(uint256 _endBlock, uint256 _availableAmount)
322         public
323         onlyOwner
324         onlyNotFinalized
325         onlyScheduledTiers
326         onlySubsequentBlock(_endBlock)
327         onlyNotZero(_availableAmount)
328     {
329         endBlock = _endBlock;
330 
331         token.mint(this, _availableAmount);
332 
333         Finalized(_endBlock, _availableAmount);
334     }
335 
336     /**
337      * @dev Burns all tokens which have not been sold
338      */
339     function burnRemains()
340         public
341         onlyOwner
342         onlyFinished
343     {
344         uint256 amount = availableAmount();
345 
346         token.burn(amount);
347 
348         RemainsBurned(amount);
349     }
350 
351     /**
352      * @dev Calculate amount of ONL tokens received for given ETH value
353      * @param value uint256 Contribution value in wei
354      * @return uint256 Amount of received ONL tokens if contract active, otherwise 0
355      */
356     function calculateContribution(uint256 value) public view returns (uint256) {
357         uint256 price = currentPrice();
358         if (price > 0) {
359             return value.mul(10 ** token.decimals()).div(price);
360         }
361 
362         return 0;
363     }
364 
365     /**
366      * @dev Find closest tier id to given block
367      * @return uint256 Tier containing the block or zero if before start or last if after finished
368      */
369     function getTierId(uint256 blockNumber) public view returns (uint256) {
370         for (uint256 i = tiers.length - 1; i >= 0; i--) {
371             if (blockNumber >= tiers[i].startBlock) {
372                 return i;
373             }
374         }
375 
376         return 0;
377     }
378 
379     /**
380      * @dev Get price of the current tier
381      * @return uint256 Current price if tiers defined, otherwise 0
382      */
383     function currentPrice() public view returns (uint256) {
384         if (tiers.length > 0) {
385             uint256 id = getTierId(block.number);
386             return tiers[id].price;
387         }
388 
389         return 0;
390     }
391 
392     /**
393      * @dev Get current tier id
394      * @return uint256 Tier containing the block or zero if before start or last if after finished
395      */
396     function currentTierId() public view returns (uint256) {
397         return getTierId(block.number);
398     }
399 
400     /**
401      * @dev Get available amount of tokens
402      * @return uint256 Amount of unsold tokens
403      */
404     function availableAmount() public view returns (uint256) {
405         return token.balanceOf(this);
406     }
407 
408     /**
409      * @dev Get specification of all tiers
410      */
411     function listTiers()
412         public
413         view
414         returns (uint256[] startBlocks, uint256[] endBlocks, uint256[] prices)
415     {
416         startBlocks = new uint256[](tiers.length);
417         endBlocks = new uint256[](tiers.length);
418         prices = new uint256[](tiers.length);
419 
420         for (uint256 i = 0; i < tiers.length; i++) {
421             startBlocks[i] = tiers[i].startBlock;
422             prices[i] = tiers[i].price;
423 
424             if (i + 1 < tiers.length) {
425                 endBlocks[i] = tiers[i + 1].startBlock - 1;
426             } else {
427                 endBlocks[i] = endBlock;
428             }
429         }
430     }
431 
432     /**
433      * @dev Check whether crowdsale is currently active
434      * @return boolean True if current block number is within tier ranges, otherwise False
435      */
436     function isActive() public view returns (bool) {
437         return
438             tiers.length > 0 &&
439             block.number >= tiers[0].startBlock &&
440             block.number <= endBlock;
441     }
442 
443     /**
444      * @dev Check whether sale end is scheduled
445      * @return boolean True if end block is defined, otherwise False
446      */
447     function isFinalized() public view returns (bool) {
448         return endBlock > 0;
449     }
450 
451     /**
452      * @dev Check whether crowdsale has finished
453      * @return boolean True if end block passed, otherwise False
454      */
455     function isFinished() public view returns (bool) {
456         return endBlock > 0 && block.number > endBlock;
457     }
458 
459     function acceptContribution(address contributor, uint256 value)
460         private
461         onlyActive
462         onlyValid(contributor)
463         onlySufficientValue(value)
464         returns (uint256)
465     {
466         uint256 amount = calculateContribution(value);
467         token.transfer(contributor, amount);
468 
469         wallet.transfer(value);
470 
471         ContributionAccepted(contributor, value, amount);
472 
473         return amount;
474     }
475 }