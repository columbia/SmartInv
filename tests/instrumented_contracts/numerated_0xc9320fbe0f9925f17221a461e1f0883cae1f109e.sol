1 pragma solidity ^0.4.15;
2 
3 
4 /**
5 * @title SafeMath
6 * @dev Math operations with safety checks that throw on error
7 */
8 library SafeMath {
9 function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10 uint256 c = a * b;
11 assert(a == 0 || c / a == b);
12 return c;
13 }
14 
15 function div(uint256 a, uint256 b) internal constant returns (uint256) {
16 // assert(b > 0); // Solidity automatically throws when dividing by 0
17 uint256 c = a / b;
18 // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19 return c;
20 }
21 
22 function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23 assert(b <= a);
24 return a - b;
25 }
26 
27 function add(uint256 a, uint256 b) internal constant returns (uint256) {
28 uint256 c = a + b;
29 assert(c >= a);
30 return c;
31 }
32 }
33 
34 contract ERC20 {
35 uint256 public totalSupply;
36 function balanceOf(address who) constant returns (uint256);
37 function transfer(address to, uint256 value) returns (bool);
38 event Transfer(address indexed from, address indexed to, uint256 value);
39 function allowance(address owner, address spender) constant returns (uint256);
40 function transferFrom(address from, address to, uint256 value) returns (bool);
41 function approve(address spender, uint256 value) returns (bool);
42 event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 contract BasicToken is ERC20 {
46 using SafeMath for uint256;
47 
48 mapping(address => uint256) balances;
49 mapping (address => mapping (address => uint256)) allowed;
50 modifier nonZeroEth(uint _value) {
51 require(_value > 0);
52 _;
53 }
54 
55 modifier onlyPayloadSize() {
56 require(msg.data.length >= 68);
57 _;
58 }
59 /**
60 * @dev transfer token for a specified address
61 * @param _to The address to transfer to.
62 * @param _value The amount to be transferred.
63 */
64 
65 function transfer(address _to, uint256 _value) nonZeroEth(_value) onlyPayloadSize returns (bool) {
66 if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]){
67 balances[msg.sender] = balances[msg.sender].sub(_value);
68 balances[_to] = balances[_to].add(_value);
69 Transfer(msg.sender, _to, _value);
70 return true;
71 }else{
72 return false;
73 }
74 }
75 
76 /**
77 * @dev Transfer tokens from one address to another
78 * @param _from address The address which you want to send tokens from
79 * @param _to address The address which you want to transfer to
80 * @param _value uint256 the amout of tokens to be transfered
81 */
82 
83 function transferFrom(address _from, address _to, uint256 _value) nonZeroEth(_value) onlyPayloadSize returns (bool) {
84 if(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]){
85 uint256 _allowance = allowed[_from][msg.sender];
86 allowed[_from][msg.sender] = _allowance.sub(_value);
87 balances[_to] = balances[_to].add(_value);
88 balances[_from] = balances[_from].sub(_value);
89 Transfer(_from, _to, _value);
90 return true;
91 }else{
92 return false;
93 }
94 }
95 
96 
97 /**
98 * @dev Gets the balance of the specified address.
99 * @param _owner The address to query the the balance of.
100 * @return An uint256 representing the amount owned by the passed address.
101 */
102 
103 function balanceOf(address _owner) constant returns (uint256 balance) {
104 return balances[_owner];
105 }
106 
107 function approve(address _spender, uint256 _value) returns (bool) {
108 
109 // To change the approve amount you first have to reduce the addresses`
110 // allowance to zero by calling `approve(_spender, 0)` if it is not
111 // already 0 to mitigate the race condition described here:
112 // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
113 require((_value == 0) || (allowed[msg.sender][_spender] == 0));
114 
115 allowed[msg.sender][_spender] = _value;
116 Approval(msg.sender, _spender, _value);
117 return true;
118 }
119 
120 /**
121 * @dev Function to check the amount of tokens that an owner allowed to a spender.
122 * @param _owner address The address which owns the funds.
123 * @param _spender address The address which will spend the funds.
124 * @return A uint256 specifing the amount of tokens still avaible for the spender.
125 */
126 function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
127 return allowed[_owner][_spender];
128 }
129 
130 }
131 
132 
133 contract RPTToken is BasicToken {
134 
135 using SafeMath for uint256;
136 
137 string public name = "RPT Token"; //name of the token
138 string public symbol = "RPT"; // symbol of the token
139 uint8 public decimals = 18; // decimals
140 uint256 public totalSupply = 100000000 * 10**18; // total supply of RPT Tokens
141 
142 // variables
143 uint256 public keyEmployeeAllocation; // fund allocated to key employee
144 uint256 public totalAllocatedTokens; // variable to regulate the funds allocation
145 uint256 public tokensAllocatedToCrowdFund; // funds allocated to crowdfund
146 
147 // addresses
148 address public founderMultiSigAddress = 0xf96E905091d38ca25e06C014fE67b5CA939eE83D; // multi sign address of founders which hold
149 address public crowdFundAddress; // address of crowdfund contract
150 
151 //events
152 event ChangeFoundersWalletAddress(uint256 _blockTimeStamp, address indexed _foundersWalletAddress);
153 event TransferPreAllocatedFunds(uint256 _blockTimeStamp , address _to , uint256 _value);
154 
155 //modifiers
156 modifier onlyCrowdFundAddress() {
157 require(msg.sender == crowdFundAddress);
158 _;
159 }
160 
161 modifier nonZeroAddress(address _to) {
162 require(_to != 0x0);
163 _;
164 }
165 
166 modifier onlyFounders() {
167 require(msg.sender == founderMultiSigAddress);
168 _;
169 }
170 
171 // creation of the token contract
172 function RPTToken (address _crowdFundAddress) {
173 crowdFundAddress = _crowdFundAddress;
174 
175 // Token Distribution
176 tokensAllocatedToCrowdFund = 70 * 10 ** 24; // 70 % allocation of totalSupply
177 keyEmployeeAllocation = 30 * 10 ** 24; // 30 % allocation of totalSupply
178 
179 // Assigned balances to respective stakeholders
180 balances[founderMultiSigAddress] = keyEmployeeAllocation;
181 balances[crowdFundAddress] = tokensAllocatedToCrowdFund;
182 
183 totalAllocatedTokens = balances[founderMultiSigAddress];
184 }
185 
186 // function to keep track of the total token allocation
187 function changeTotalSupply(uint256 _amount) onlyCrowdFundAddress {
188 totalAllocatedTokens = totalAllocatedTokens.add(_amount);
189 }
190 
191 // function to change founder multisig wallet address
192 function changeFounderMultiSigAddress(address _newFounderMultiSigAddress) onlyFounders nonZeroAddress(_newFounderMultiSigAddress) {
193 founderMultiSigAddress = _newFounderMultiSigAddress;
194 ChangeFoundersWalletAddress(now, founderMultiSigAddress);
195 }
196 
197 }
198 
199 
200 contract RPTCrowdsale {
201 
202 using SafeMath for uint256;
203 RPTToken public token; // Token variable
204 //variables
205 uint256 public totalWeiRaised; // Flag to track the amount raised
206 uint32 public exchangeRate = 3000; // calculated using priceOfEtherInUSD/priceOfRPTToken
207 uint256 public preDistriToAcquiantancesStartTime = 1510876801; // Friday, 17-Nov-17 00:00:01 UTC
208 uint256 public preDistriToAcquiantancesEndTime = 1511827199; // Monday, 27-Nov-17 23:59:59 UTC
209 uint256 public presaleStartTime = 1511827200; // Tuesday, 28-Nov-17 00:00:00 UTC
210 uint256 public presaleEndTime = 1513036799; // Monday, 11-Dec-17 23:59:59 UTC
211 uint256 public crowdfundStartTime = 1513036800; // Tuesday, 12-Dec-17 00:00:00 UTC
212 uint256 public crowdfundEndTime = 1515628799; // Wednesday, 10-Jan-18 23:59:59 UTC
213 bool internal isTokenDeployed = false; // Flag to track the token deployment
214 // addresses
215 address public founderMultiSigAddress; // Founders multi sign address
216 address public remainingTokenHolder; // Address to hold the remaining tokens after crowdfund end
217 address public beneficiaryAddress; // All funds are transferred to this address
218 
219 enum State { Acquiantances, PreSale, CrowdFund, Closed }
220 
221 //events
222 event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
223 event CrowdFundClosed(uint256 _blockTimeStamp);
224 event ChangeFoundersWalletAddress(uint256 _blockTimeStamp, address indexed _foundersWalletAddress);
225 //Modifiers
226 modifier tokenIsDeployed() {
227 require(isTokenDeployed == true);
228 _;
229 }
230 modifier nonZeroEth() {
231 require(msg.value > 0);
232 _;
233 }
234 
235 modifier nonZeroAddress(address _to) {
236 require(_to != 0x0);
237 _;
238 }
239 
240 modifier onlyFounders() {
241 require(msg.sender == founderMultiSigAddress);
242 _;
243 }
244 
245 modifier onlyPublic() {
246 require(msg.sender != founderMultiSigAddress);
247 _;
248 }
249 
250 modifier inState(State state) {
251 require(getState() == state);
252 _;
253 }
254 
255 modifier inBetween() {
256 require(now >= preDistriToAcquiantancesStartTime && now <= crowdfundEndTime);
257 _;
258 }
259 
260 // Constructor to initialize the local variables
261 function RPTCrowdsale (address _founderWalletAddress, address _remainingTokenHolder, address _beneficiaryAddress) {
262 founderMultiSigAddress = _founderWalletAddress;
263 remainingTokenHolder = _remainingTokenHolder;
264 beneficiaryAddress = _beneficiaryAddress;
265 }
266 
267 // Function to change the founders multi sign address
268 function setFounderMultiSigAddress(address _newFounderAddress) onlyFounders nonZeroAddress(_newFounderAddress) {
269 founderMultiSigAddress = _newFounderAddress;
270 ChangeFoundersWalletAddress(now, founderMultiSigAddress);
271 }
272 // Attach the token contract
273 function setTokenAddress(address _tokenAddress) external onlyFounders nonZeroAddress(_tokenAddress) {
274 require(isTokenDeployed == false);
275 token = RPTToken(_tokenAddress);
276 isTokenDeployed = true;
277 }
278 
279 
280 // function call after crowdFundEndTime it transfers the remaining tokens to remainingTokenHolder address
281 function endCrowdfund() onlyFounders returns (bool) {
282 require(now > crowdfundEndTime);
283 uint256 remainingToken = token.balanceOf(this); // remaining tokens
284 
285 if (remainingToken != 0) {
286 token.transfer(remainingTokenHolder, remainingToken);
287 CrowdFundClosed(now);
288 return true;
289 } else {
290 CrowdFundClosed(now);
291 return false;
292 }
293 }
294 
295 // Buy token function call only in duration of crowdfund active
296 function buyTokens(address beneficiary)
297 nonZeroEth
298 tokenIsDeployed
299 onlyPublic
300 nonZeroAddress(beneficiary)
301 inBetween
302 payable
303 public
304 returns(bool)
305 {
306 fundTransfer(msg.value);
307 
308 uint256 amount = getNoOfTokens(exchangeRate, msg.value);
309 if (token.transfer(beneficiary, amount)) {
310 token.changeTotalSupply(amount);
311 totalWeiRaised = totalWeiRaised.add(msg.value);
312 TokenPurchase(beneficiary, msg.value, amount);
313 return true;
314 }
315 return false;
316 }
317 
318 
319 // function to transfer the funds to founders account
320 function fundTransfer(uint256 weiAmount) internal {
321 beneficiaryAddress.transfer(weiAmount);
322 }
323 
324 // Get functions
325 
326 // function to get the current state of the crowdsale
327 function getState() internal constant returns(State) {
328 if (now >= preDistriToAcquiantancesStartTime && now <= preDistriToAcquiantancesEndTime) {
329 return State.Acquiantances;
330 } if (now >= presaleStartTime && now <= presaleEndTime) {
331 return State.PreSale;
332 } if (now >= crowdfundStartTime && now <= crowdfundEndTime) {
333 return State.CrowdFund;
334 } else {
335 return State.Closed;
336 }
337 }
338 
339 
340 // function to calculate the total no of tokens with bonus multiplication
341 function getNoOfTokens(uint32 _exchangeRate, uint256 _amount) internal returns (uint256) {
342 uint256 noOfToken = _amount.mul(uint256(_exchangeRate));
343 uint256 noOfTokenWithBonus = ((uint256(100 + getCurrentBonusRate())).mul(noOfToken)).div(100);
344 return noOfTokenWithBonus;
345 }
346 
347 
348 // function provide the current bonus rate
349 function getCurrentBonusRate() internal returns (uint8) {
350 if (getState() == State.Acquiantances) {
351 return 40;
352 }
353 if (getState() == State.PreSale) {
354 return 20;
355 }
356 if (getState() == State.CrowdFund) {
357 return 0;
358 } else {
359 return 0;
360 }
361 }
362 
363 // provides the bonus %
364 function getBonus() constant returns (uint8) {
365 return getCurrentBonusRate();
366 }
367 
368 // send ether to the contract address
369 // With at least 200 000 gas
370 function() public payable {
371 buyTokens(msg.sender);
372 }
373 }