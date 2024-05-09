1 pragma solidity ^0.4.0;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11 
12     /**
13      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14      * account.
15      */
16     function Ownable() public {
17         owner = msg.sender;
18     }
19 
20 
21     /**
22      * @dev Throws if called by any account other than the owner.
23      */
24     modifier onlyOwner() {
25         require(msg.sender == owner);
26         _;
27     }
28 
29 }
30 
31 contract SafeMath {
32     function safeMul(uint a, uint b) internal returns (uint) {
33         uint c = a * b;
34         assert(a == 0 || c / a == b);
35         return c;
36     }
37 
38     function safeDiv(uint a, uint b) internal returns (uint) {
39         assert(b > 0);
40         uint c = a / b;
41         assert(a == b * c + a % b);
42         return c;
43     }
44 
45     function safeSub(uint a, uint b) internal returns (uint) {
46         assert(b <= a);
47         return a - b;
48     }
49 
50     function safeAdd(uint a, uint b) internal returns (uint) {
51         uint c = a + b;
52         assert(c>=a && c>=b);
53         return c;
54     }
55 
56     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
57         return a >= b ? a : b;
58     }
59 
60     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
61         return a < b ? a : b;
62     }
63 
64     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
65         return a >= b ? a : b;
66     }
67 
68     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
69         return a < b ? a : b;
70     }
71 
72 }
73 
74 
75 /**
76  * Safe unsigned safe math.
77  *
78  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
79  *
80  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
81  *
82  * Maintained here until merged to mainline zeppelin-solidity.
83  *
84  */
85 library SafeMathLibExt {
86 
87     function times(uint a, uint b) returns (uint) {
88         uint c = a * b;
89         assert(a == 0 || c / a == b);
90         return c;
91     }
92 
93     function divides(uint a, uint b) returns (uint) {
94         assert(b > 0);
95         uint c = a / b;
96         assert(a == b * c + a % b);
97         return c;
98     }
99 
100     function minus(uint a, uint b) returns (uint) {
101         assert(b <= a);
102         return a - b;
103     }
104 
105     function plus(uint a, uint b) returns (uint) {
106         uint c = a + b;
107         assert(c>=a);
108         return c;
109     }
110 
111 }
112 
113 
114 contract Destructable is Ownable {
115 
116     function burn() public onlyOwner {
117         selfdestruct(owner);
118     }
119 
120 }
121 
122 
123 contract TokensContract {
124     function balanceOf(address who) public constant returns (uint256);
125     function transferFrom(address _from, address _to, uint _value) returns (bool success);
126     function approve(address _spender, uint _value) returns (bool success);
127 }
128 
129 contract Insurance is Destructable, SafeMath  {
130 
131     uint startClaimDate;
132     uint endClaimDate;
133     uint rewardWeiCoefficient;
134     uint256 buyPrice;
135     address tokensContractAddress;
136     uint256 ichnDecimals;
137 
138     mapping (address => uint256) buyersBalances;
139 
140     struct ClientInsurance {
141         uint256 tokensCount;
142         bool isApplied;
143         bool exists;
144         bool isBlocked;
145     }
146 
147 
148     mapping(address => ClientInsurance) insurancesMap;
149 
150 
151     function Insurance() public {
152         /* I-CHAIN.NET (ICHN) ERC20 token */
153         tokensContractAddress = 0x3ab7b695573017eeBD6377c433F9Cf3eF5B4cd48;
154 
155         /* UTC, 31 dec 2020 00:00 - 2 feb 2021 00:00 */
156         startClaimDate = 1609372800;
157         endClaimDate = 1612224000;
158 
159 
160         /* 0.1 ether */
161         rewardWeiCoefficient = 100000000000000000;
162 
163         /* 0.05 ether */
164         buyPrice = 50000000000000000;
165 
166         /* ICHN Token Decimals is 18 */
167         ichnDecimals = 1000000000000000000;
168     }
169 
170     /**
171      * Don't expect to just send money by anyone except the owner
172      */
173     function () public payable {
174         throw;
175     }
176 
177     /**
178      * Owner can add ETH to contract
179      */
180     function addEth() public payable onlyOwner {
181     }
182     
183     /**
184      * Owner can transfer ETH from contract to address
185      * Amount - 18 decimals
186      */
187     function transferEthTo(address to, uint256 amount) public payable onlyOwner {
188         require(address(this).balance > amount);
189         to.transfer(amount);
190     }
191 
192     /**
193      * Basic entry point for buy insurance
194      */
195     function buy() public payable {
196         /* Can be called only once for address */
197         require(buyersBalances[msg.sender] == 0);
198 
199         /* Checking price */
200         require(msg.value == buyPrice);
201 
202         /* At least one token */
203         require(hasTokens(msg.sender));
204 
205         /* Remember payment */
206         buyersBalances[msg.sender] = safeAdd(buyersBalances[msg.sender], msg.value);
207     }
208 
209     function isClient(address clientAddress) public constant onlyOwner returns(bool) {
210         return insurancesMap[clientAddress].exists;
211     }
212 
213     function addBuyer(address clientAddress, uint256 tokensCount) public onlyOwner {
214         require( (clientAddress != address(0)) && (tokensCount > 0) );
215 
216         /* Checking payment */
217         require(buyersBalances[clientAddress] == buyPrice);
218 
219         /* Can be called only once for address */
220         require(!insurancesMap[clientAddress].exists);
221 
222         /* Checking the current number of tokens */
223         require(getTokensCount(clientAddress) >= tokensCount);
224 
225         insurancesMap[clientAddress] = ClientInsurance(tokensCount, false, true, false);
226     }
227 
228     function claim(address to, uint256 returnedTokensCount) public onlyOwner {
229         /* Can be called only on time range */
230         require(now > startClaimDate && now < endClaimDate);
231 
232         /* Can be called once for address */
233         require( (to != address(0)) && (insurancesMap[to].exists) && (!insurancesMap[to].isApplied) && (!insurancesMap[to].isBlocked) );
234 
235         /* Tokens returned */
236         require(returnedTokensCount >= insurancesMap[to].tokensCount);
237 
238         /* Start transfer */
239         uint amount = getRewardWei(to);
240 
241         require(address(this).balance > amount);
242         insurancesMap[to].isApplied = true;
243 
244         to.transfer(amount);
245     }
246 
247     function blockClient(address clientAddress) public onlyOwner {
248         insurancesMap[clientAddress].isBlocked = true;
249     }
250 
251     function unblockClient(address clientAddress) public onlyOwner {
252         insurancesMap[clientAddress].isBlocked = false;
253     }
254 
255     function isClientBlocked(address clientAddress) public constant onlyOwner returns(bool) {
256         return insurancesMap[clientAddress].isBlocked;
257     }
258 
259     /**
260      * Sets buy price for insurance
261      */
262     function setBuyPrice(uint256 priceWei) public onlyOwner {
263         buyPrice = priceWei;
264     }
265 
266     /**
267      * Sets tokens contract address from which check balance of tokens
268      */
269     function setTokensContractAddress(address contractAddress) public onlyOwner {
270         tokensContractAddress = contractAddress;
271     }
272 
273     /**
274      * Returns address of tokens contract from which check balance of tokens
275      */
276     function getTokensContractAddress() public constant onlyOwner returns(address) {
277         return tokensContractAddress;
278     }
279 
280     function getRewardWei(address clientAddress) private constant returns (uint256) {
281         uint tokensCount = insurancesMap[clientAddress].tokensCount;
282         return safeMul(tokensCount, rewardWeiCoefficient);
283     }
284 
285     function hasTokens(address clientAddress) private constant returns (bool) {
286         return getTokensCount(clientAddress) > 0;
287     }
288 
289     function getTokensCount(address clientAddress) private constant returns (uint256) {
290         TokensContract tokensContract = TokensContract(tokensContractAddress);
291 
292         uint256 tcBalance = tokensContract.balanceOf(clientAddress);
293 
294         return safeDiv(tcBalance, ichnDecimals);
295     }
296     
297     /**
298      * Transfer ERC20 tokens from contract to address
299      * tokensAmount - 18 decimals
300      */
301     function transferTokensTo(address to, uint256 tokensAmount) public onlyOwner {
302        TokensContract tokensContract = TokensContract(tokensContractAddress);
303        tokensContract.approve(address(this), tokensAmount);
304        tokensContract.transferFrom(address(this), to, tokensAmount);
305     }
306     
307     function getStartClaimDate() public constant onlyOwner returns(uint) {
308         return startClaimDate;
309     }
310     
311     function getEndClaimDate() public constant onlyOwner returns(uint) {
312         return endClaimDate;
313     }
314 }