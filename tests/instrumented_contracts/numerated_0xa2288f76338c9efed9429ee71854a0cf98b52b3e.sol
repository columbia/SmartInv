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
80  * @title One-time schedulable contract
81  * @author Jakub Stefanski (https://github.com/jstefanski)
82  *
83  * https://github.com/OnLivePlatform/onlive-contracts
84  *
85  * The BSD 3-Clause Clear License
86  * Copyright (c) 2018 OnLive LTD
87  */
88 contract Schedulable is Ownable {
89 
90     /**
91      * @dev First block when contract is active (inclusive). Zero if not scheduled.
92      */
93     uint256 public startBlock;
94 
95     /**
96      * @dev Last block when contract is active (inclusive). Zero if not scheduled.
97      */
98     uint256 public endBlock;
99 
100     /**
101      * @dev Contract scheduled within given blocks
102      * @param startBlock uint256 The first block when contract is active (inclusive)
103      * @param endBlock uint256 The last block when contract is active (inclusive)
104      */
105     event Scheduled(uint256 startBlock, uint256 endBlock);
106 
107     modifier onlyNotZero(uint256 value) {
108         require(value != 0);
109         _;
110     }
111 
112     modifier onlyScheduled() {
113         require(isScheduled());
114         _;
115     }
116 
117     modifier onlyNotScheduled() {
118         require(!isScheduled());
119         _;
120     }
121 
122     modifier onlyActive() {
123         require(isActive());
124         _;
125     }
126 
127     modifier onlyNotActive() {
128         require(!isActive());
129         _;
130     }
131 
132     /**
133      * @dev Schedule contract activation for given block range
134      * @param _startBlock uint256 The first block when contract is active (inclusive)
135      * @param _endBlock uint256 The last block when contract is active (inclusive)
136      */
137     function schedule(uint256 _startBlock, uint256 _endBlock)
138         public
139         onlyOwner
140         onlyNotScheduled
141         onlyNotZero(_startBlock)
142         onlyNotZero(_endBlock)
143     {
144         require(_startBlock < _endBlock);
145 
146         startBlock = _startBlock;
147         endBlock = _endBlock;
148 
149         Scheduled(_startBlock, _endBlock);
150     }
151 
152     /**
153      * @dev Check whether activation is scheduled
154      */
155     function isScheduled() public view returns (bool) {
156         return startBlock > 0 && endBlock > 0;
157     }
158 
159     /**
160      * @dev Check whether contract is currently active
161      */
162     function isActive() public view returns (bool) {
163         return block.number >= startBlock && block.number <= endBlock;
164     }
165 }
166 
167 
168 /**
169  * @title Pre-ICO Crowdsale with constant price and limited supply
170  * @author Jakub Stefanski (https://github.com/jstefanski)
171  *
172  * https://github.com/OnLivePlatform/onlive-contracts
173  *
174  * The BSD 3-Clause Clear License
175  * Copyright (c) 2018 OnLive LTD
176  */
177 contract Mintable {
178     uint256 public decimals;
179 
180     function mint(address to, uint256 amount) public;
181 }
182 
183 
184 /**
185  * @title Crowdsale for off-chain payment methods
186  * @author Jakub Stefanski (https://github.com/jstefanski)
187  *
188  * https://github.com/OnLivePlatform/onlive-contracts
189  *
190  * The BSD 3-Clause Clear License
191  * Copyright (c) 2018 OnLive LTD
192  */
193 contract PreIcoCrowdsale is Schedulable {
194 
195     using SafeMath for uint256;
196 
197     /**
198      * @dev Address of contribution wallet
199      */
200     address public wallet;
201 
202     /**
203      * @dev Address of mintable token instance
204      */
205     Mintable public token;
206 
207     /**
208      * @dev Current amount of tokens available for sale
209      */
210     uint256 public availableAmount;
211 
212     /**
213      * @dev Price of token in Wei
214      */
215     uint256 public price;
216 
217     /**
218      * @dev Minimum ETH value sent as contribution
219      */
220     uint256 public minValue;
221 
222     /**
223      * @dev Indicates whether contribution identified by bytes32 id is already registered
224      */
225     mapping (bytes32 => bool) public isContributionRegistered;
226 
227     function PreIcoCrowdsale(
228         address _wallet,
229         Mintable _token,
230         uint256 _availableAmount,
231         uint256 _price,
232         uint256 _minValue
233     )
234         public
235         onlyValid(_wallet)
236         onlyValid(_token)
237         onlyNotZero(_availableAmount)
238         onlyNotZero(_price)
239     {
240         wallet = _wallet;
241         token = _token;
242         availableAmount = _availableAmount;
243         price = _price;
244         minValue = _minValue;
245     }
246 
247     /**
248      * @dev Contribution is accepted
249      * @param contributor address The recipient of the tokens
250      * @param value uint256 The amount of contributed ETH
251      * @param amount uint256 The amount of tokens
252      */
253     event ContributionAccepted(address indexed contributor, uint256 value, uint256 amount);
254 
255     /**
256      * @dev Off-chain contribution registered
257      * @param id bytes32 A unique contribution id
258      * @param contributor address The recipient of the tokens
259      * @param amount uint256 The amount of tokens
260      */
261     event ContributionRegistered(bytes32 indexed id, address indexed contributor, uint256 amount);
262 
263     modifier onlyValid(address addr) {
264         require(addr != address(0));
265         _;
266     }
267 
268     modifier onlySufficientValue(uint256 value) {
269         require(value >= minValue);
270         _;
271     }
272 
273     modifier onlySufficientAvailableTokens(uint256 amount) {
274         require(availableAmount >= amount);
275         _;
276     }
277 
278     modifier onlyUniqueContribution(bytes32 id) {
279         require(!isContributionRegistered[id]);
280         _;
281     }
282 
283     /**
284      * @dev Accept ETH transfers as contributions
285      */
286     function () public payable {
287         acceptContribution(msg.sender, msg.value);
288     }
289 
290     /**
291      * @dev Contribute ETH in exchange for tokens
292      * @param contributor address The address that receives tokens
293      */
294     function contribute(address contributor) public payable returns (uint256) {
295         return acceptContribution(contributor, msg.value);
296     }
297 
298     /**
299      * @dev Register contribution with given id
300      * @param id bytes32 A unique contribution id
301      * @param contributor address The recipient of the tokens
302      * @param amount uint256 The amount of tokens
303      */
304     function registerContribution(bytes32 id, address contributor, uint256 amount)
305         public
306         onlyOwner
307         onlyActive
308         onlyValid(contributor)
309         onlyNotZero(amount)
310         onlyUniqueContribution(id)
311     {
312         isContributionRegistered[id] = true;
313         mintTokens(contributor, amount);
314 
315         ContributionRegistered(id, contributor, amount);
316     }
317 
318     /**
319      * @dev Calculate amount of ONL tokens received for given ETH value
320      * @param value uint256 Contribution value in ETH
321      * @return uint256 Amount of received ONL tokens
322      */
323     function calculateContribution(uint256 value) public view returns (uint256) {
324         return value.mul(10 ** token.decimals()).div(price);
325     }
326 
327     function acceptContribution(address contributor, uint256 value)
328         private
329         onlyActive
330         onlyValid(contributor)
331         onlySufficientValue(value)
332         returns (uint256)
333     {
334         uint256 amount = calculateContribution(value);
335         mintTokens(contributor, amount);
336 
337         wallet.transfer(value);
338 
339         ContributionAccepted(contributor, value, amount);
340 
341         return amount;
342     }
343 
344     function mintTokens(address to, uint256 amount)
345         private
346         onlySufficientAvailableTokens(amount)
347     {
348         availableAmount = availableAmount.sub(amount);
349         token.mint(to, amount);
350     }
351 }