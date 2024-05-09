1 pragma solidity ^0.4.18;
2 
3 /* taking ideas from Zeppelin solidity module */
4 contract SafeMath {
5 
6     // it is recommended to define functions which can neither read the state of blockchain nor write in it as pure instead of constant
7 
8     function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
9         uint256 z = x + y;
10         assert((z >= x));
11         return z;
12     }
13 
14     function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {
15         assert(x >= y);
16         return x - y;
17     }
18 
19     function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
20         uint256 z = x * y;
21         assert((x == 0)||(z/x == y));
22         return z;
23     }
24 
25     function safeDiv(uint256 x, uint256 y) internal pure returns (uint256) {
26         uint256 z = x / y;
27         return z;
28     }
29 
30     // mitigate short address attack
31     // thanks to https://github.com/numerai/contract/blob/c182465f82e50ced8dacb3977ec374a892f5fa8c/contracts/Safe.sol#L30-L34.
32     // TODO: doublecheck implication of >= compared to ==
33     modifier onlyPayloadSize(uint numWords) {
34         assert(msg.data.length >= numWords * 32 + 4);
35         _;
36     }
37 
38 }
39 // The abstract token contract
40 
41 contract TrakToken {
42     function TrakToken () public {}
43     function transfer (address ,uint) public pure { }
44     function burn (uint256) public pure { }
45     function finalize() public pure { }
46     function changeTokensWallet (address) public pure { }
47 }
48 
49 contract CrowdSale is SafeMath {
50 
51     ///metadata
52     enum State { Fundraising,Paused,Successful,Closed }
53     State public state = State.Fundraising; // equal to 0
54     string public version = "1.0";
55 
56     //External contracts
57     TrakToken public trakToken;
58     // who created smart contract
59     address public creator;
60     // Address which will receive raised funds
61     address public contractOwner;
62     // adreess vs state mapping (1 for exists , zero default);
63     mapping (address => bool) public whitelistedContributors;
64 
65     uint256 public fundingStartBlock; // Dec 15 - Dec 25
66     uint256 public firstChangeBlock;  // December 25 - January 5
67     uint256 public secondChangeBlock; // January 5 -January 15
68     uint256 public thirdChangeBlock;  // January 16
69     uint256 public fundingEndBlock;   // Jan 31
70     // funding maximum duration in hours
71     uint256 public fundingDurationInHours;
72     uint256 constant public fundingMaximumTargetInWei = 66685 ether;
73     // We need to keep track of how much ether (in units of Wei) has been contributed
74     uint256 public totalRaisedInWei;
75     // maximum ether we will accept from one user
76     uint256 constant public maxPriceInWeiFromUser = 1500 ether;
77     uint256 public minPriceInWeiForPre = 1 ether;
78     uint256 public minPriceInWeiForIco = 0.5 ether;
79     uint8 constant public  decimals = 18;
80     // Number of tokens distributed to investors
81     uint public tokensDistributed = 0;
82     // tokens per tranche
83     uint constant public tokensPerTranche = 11000000 * (uint256(10) ** decimals);
84     uint256 public privateExchangeRate = 1420; // 23.8%
85     uint256 public firstExchangeRate   = 1289; // 15.25%
86     uint256 public secondExchangeRate  = 1193;  //  8.42%
87     uint256 public thirdExchangeRate   = 1142;  //  4.31%
88     uint256 public fourthExchangeRate  = 1118;  //  2.25%
89     uint256 public fifthExchangeRate   = 1105;  // 1.09%
90 
91     /// modifiers
92     modifier onlyOwner() {
93         require(msg.sender == contractOwner);
94         _;
95     }
96 
97     modifier isIcoOpen() {
98         require(block.number >= fundingStartBlock);
99         require(block.number <= fundingEndBlock);
100         require(totalRaisedInWei <= fundingMaximumTargetInWei);
101         _;
102     }
103 
104 
105     modifier isMinimumPrice() {
106         if (tokensDistributed < safeMult(3,tokensPerTranche) || block.number < thirdChangeBlock ) {
107            require(msg.value >= minPriceInWeiForPre);
108         }
109         else if (tokensDistributed <= safeMult(6,tokensPerTranche)) {
110            require(msg.value >= minPriceInWeiForIco);
111         }
112 
113         require(msg.value <= maxPriceInWeiFromUser);
114 
115          _;
116     }
117 
118     modifier isIcoFinished() {
119         require(totalRaisedInWei >= fundingMaximumTargetInWei || (block.number > fundingEndBlock) || state == State.Successful );
120         _;
121     }
122 
123     modifier inState(State _state) {
124         require(state == _state);
125         _;
126     }
127 
128     modifier isCreator() {
129         require(msg.sender == creator);
130         _;
131     }
132 
133     // wait 100 block after final contract state before allowing contract destruction
134     modifier atEndOfLifecycle() {
135         require(totalRaisedInWei >= fundingMaximumTargetInWei || (block.number > fundingEndBlock + 40000));
136         _;
137     }
138 
139     /// constructor
140     function CrowdSale(
141     address _fundsWallet,
142     uint256 _fundingStartBlock,
143     uint256 _firstInHours,
144     uint256 _secondInHours,
145     uint256 _thirdInHours,
146     uint256 _fundingDurationInHours,
147     TrakToken _tokenAddress
148     ) public {
149 
150         require(safeAdd(_fundingStartBlock, safeMult(_fundingDurationInHours , 212)) > _fundingStartBlock);
151 
152         creator = msg.sender;
153 
154         if (_fundsWallet !=0) {
155             contractOwner = _fundsWallet;
156         }
157         else {
158             contractOwner = msg.sender;
159         }
160 
161         fundingStartBlock = _fundingStartBlock;
162         firstChangeBlock =  safeAdd(fundingStartBlock, safeMult(_firstInHours , 212));
163         secondChangeBlock = safeAdd(fundingStartBlock, safeMult(_secondInHours , 212));
164         thirdChangeBlock =  safeAdd(fundingStartBlock, safeMult(_thirdInHours , 212));
165         fundingDurationInHours = _fundingDurationInHours;
166         fundingEndBlock = safeAdd(fundingStartBlock, safeMult(_fundingDurationInHours , 212));
167         trakToken = TrakToken(_tokenAddress);
168     }
169 
170 
171     // fallback function can be used to buy tokens
172     function () external payable {
173         buyTokens(msg.sender);
174     }
175 
176 
177     function buyTokens(address beneficiary) inState(State.Fundraising) isIcoOpen isMinimumPrice  public  payable  {
178         require(beneficiary != 0x0);
179         // state 1 is set for
180         require(whitelistedContributors[beneficiary] == true );
181         uint256 tokenAmount;
182         uint256 checkedReceivedWei = safeAdd(totalRaisedInWei, msg.value);
183         // Check that this transaction wouldn't exceed the ETH max cap
184 
185         if (checkedReceivedWei > fundingMaximumTargetInWei ) {
186 
187             // update totalRaised After Subtracting
188             totalRaisedInWei = safeAdd(totalRaisedInWei,safeSubtract(fundingMaximumTargetInWei,totalRaisedInWei));
189             // Calculate how many tokens (in units of Wei) should be awarded on this transaction
190             var (rate,/*trancheMaxTokensLeft */) = getCurrentTokenPrice();
191             // Calculate how many tokens (in units of Wei) should be awarded on this transaction
192             tokenAmount = safeMult(safeSubtract(fundingMaximumTargetInWei,totalRaisedInWei), rate);
193             // Send change extra ether to user.
194             beneficiary.transfer(safeSubtract(checkedReceivedWei,fundingMaximumTargetInWei));
195         }
196         else {
197             totalRaisedInWei = safeAdd(totalRaisedInWei,msg.value);
198             var (currentRate,trancheMaxTokensLeft) = getCurrentTokenPrice();
199             // Calculate how many tokens (in units of Wei) should be awarded on this transaction
200             tokenAmount = safeMult(msg.value, currentRate);
201             if (tokenAmount > trancheMaxTokensLeft) {
202                 // handle round off error by adding .1 token
203                 tokensDistributed =  safeAdd(tokensDistributed,safeAdd(trancheMaxTokensLeft,safeDiv(1,10)));
204                 //find remaining tokens by getCurrentTokenPrice() function and sell them from remaining ethers left
205                 var (nextCurrentRate,nextTrancheMaxTokensLeft) = getCurrentTokenPrice();
206 
207                 if (nextTrancheMaxTokensLeft <= 0) {
208                     tokenAmount = safeAdd(trancheMaxTokensLeft,safeDiv(1,10));
209                     state =  State.Successful;
210                     // Send change extra ether to user.
211                     beneficiary.transfer(safeDiv(safeSubtract(tokenAmount,trancheMaxTokensLeft),currentRate));
212                 } else {
213                     uint256 nextTokenAmount = safeMult(safeSubtract(msg.value,safeMult(trancheMaxTokensLeft,safeDiv(1,currentRate))),nextCurrentRate);
214                     tokensDistributed =  safeAdd(tokensDistributed,nextTokenAmount);
215                     tokenAmount = safeAdd(nextTokenAmount,safeAdd(trancheMaxTokensLeft,safeDiv(1,10)));
216                 }
217             }
218             else {
219                 tokensDistributed =  safeAdd(tokensDistributed,tokenAmount);
220             }
221         }
222 
223         trakToken.transfer(beneficiary,tokenAmount);
224         // immediately transfer ether to fundsWallet
225         forwardFunds();
226     }
227 
228     function forwardFunds() internal {
229         contractOwner.transfer(msg.value);
230     }
231 
232     /// @dev Returns the current token rate , minimum ether needed and maximum tokens left in currenttranche
233     function getCurrentTokenPrice() private constant returns (uint256 currentRate, uint256 maximumTokensLeft) {
234 
235         if (tokensDistributed < safeMult(1,tokensPerTranche) && (block.number < firstChangeBlock)) {
236             //  return ( privateExchangeRate, minPriceInWeiForPre, safeSubtract(tokensPerTranche,tokensDistributed) );
237             return ( privateExchangeRate, safeSubtract(tokensPerTranche,tokensDistributed) );
238         }
239         else if (tokensDistributed < safeMult(2,tokensPerTranche) && (block.number < secondChangeBlock)) {
240             return ( firstExchangeRate, safeSubtract(safeMult(2,tokensPerTranche),tokensDistributed) );
241         }
242         else if (tokensDistributed < safeMult(3,tokensPerTranche) && (block.number < thirdChangeBlock)) {
243             return ( secondExchangeRate, safeSubtract(safeMult(3,tokensPerTranche),tokensDistributed) );
244         }
245         else if (tokensDistributed < safeMult(4,tokensPerTranche) && (block.number < fundingEndBlock)) {
246             return  (thirdExchangeRate,safeSubtract(safeMult(4,tokensPerTranche),tokensDistributed)  );
247         }
248         else if (tokensDistributed < safeMult(5,tokensPerTranche) && (block.number < fundingEndBlock)) {
249             return  (fourthExchangeRate,safeSubtract(safeMult(5,tokensPerTranche),tokensDistributed)  );
250         }
251         else if (tokensDistributed <= safeMult(6,tokensPerTranche)) {
252             return  (fifthExchangeRate,safeSubtract(safeMult(6,tokensPerTranche),tokensDistributed)  );
253         }
254     }
255 
256 
257     function authorizeKyc(address[] addrs) external onlyOwner returns (bool success) {
258 
259         //@TODO  maximum batch size for uploading
260         // @TODO amount of gas for a block of code - and will fail if that is exceeded
261         uint arrayLength = addrs.length;
262 
263         for (uint x = 0; x < arrayLength; x++) {
264             whitelistedContributors[addrs[x]] = true;
265         }
266 
267         return true;
268     }
269 
270 
271     function withdrawWei () external onlyOwner {
272         // send the eth to the project multisig wallet
273         contractOwner.transfer(this.balance);
274     }
275 
276     function updateFundingEndBlock(uint256 newFundingEndBlock)  external onlyOwner {
277         require(newFundingEndBlock > fundingStartBlock);
278         //require(newFundingEndBlock >= fundingEndBlock);
279         fundingEndBlock = newFundingEndBlock;
280     }
281 
282 
283     // after ICO only owner can call this
284     function burnRemainingToken(uint256 _value) external  onlyOwner isIcoFinished {
285         //@TODO - check balance of address if no value passed
286         require(_value > 0);
287         trakToken.burn(_value);
288     }
289 
290     // after ICO only owner can call this
291     function withdrawRemainingToken(uint256 _value,address trakTokenAdmin)  external onlyOwner isIcoFinished {
292         //@TODO - check balance of address if no value passed
293         require(trakTokenAdmin != 0x0);
294         require(_value > 0);
295         trakToken.transfer(trakTokenAdmin,_value);
296     }
297 
298 
299     // after ICO only owner can call this
300     function finalize() external  onlyOwner isIcoFinished  {
301         state =  State.Closed;
302         trakToken.finalize();
303     }
304 
305     // after ICO only owner can call this
306     function changeTokensWallet(address newAddress) external  onlyOwner  {
307         require(newAddress != address(0));
308         trakToken.changeTokensWallet(newAddress);
309     }
310 
311 
312     function removeContract ()  external onlyOwner atEndOfLifecycle {
313         // msg.sender will receive all the ethers if this contract has ethers
314         selfdestruct(msg.sender);
315     }
316 
317     /// @param newAddress Address of new owner.
318     function changeFundsWallet(address newAddress) external onlyOwner returns (bool)
319     {
320         require(newAddress != address(0));
321         contractOwner = newAddress;
322     }
323 
324 
325     /// @dev Pauses the contract
326     function pause() external onlyOwner inState(State.Fundraising) {
327         // Move the contract to Paused state
328         state =  State.Paused;
329     }
330 
331 
332     /// @dev Resume the contract
333     function resume() external onlyOwner {
334         // Move the contract out of the Paused state
335         state =  State.Fundraising;
336     }
337 
338     function updateFirstChangeBlock(uint256 newFirstChangeBlock)  external onlyOwner {
339         firstChangeBlock = newFirstChangeBlock;
340     }
341 
342     function updateSecondChangeBlock(uint256 newSecondChangeBlock)  external onlyOwner {
343         secondChangeBlock = newSecondChangeBlock;
344     }  
345 
346     function updateThirdChangeBlock(uint256 newThirdChangeBlock)  external onlyOwner {
347         thirdChangeBlock = newThirdChangeBlock;
348     }      
349 
350     function updatePrivateExhangeRate(uint256 newPrivateExchangeRate)  external onlyOwner {
351         privateExchangeRate = newPrivateExchangeRate;
352     } 
353 
354     function updateFirstExhangeRate(uint256 newFirstExchangeRate)  external onlyOwner {
355         firstExchangeRate = newFirstExchangeRate;
356     }    
357 
358     function updateSecondExhangeRate(uint256 newSecondExchangeRate)  external onlyOwner {
359         secondExchangeRate = newSecondExchangeRate;
360     }
361 
362     function updateThirdExhangeRate(uint256 newThirdExchangeRate)  external onlyOwner {
363         thirdExchangeRate = newThirdExchangeRate;
364     }      
365 
366     function updateFourthExhangeRate(uint256 newFourthExchangeRate)  external onlyOwner {
367         fourthExchangeRate = newFourthExchangeRate;
368     }    
369 
370     function updateFifthExhangeRate(uint256 newFifthExchangeRate)  external onlyOwner {
371         fifthExchangeRate = newFifthExchangeRate;
372     }    
373     
374     function updateMinInvestmentForPreIco(uint256 newMinPriceInWeiForPre)  external onlyOwner {
375         minPriceInWeiForPre = newMinPriceInWeiForPre;
376     }
377     function updateMinInvestmentForIco(uint256 newMinPriceInWeiForIco)  external onlyOwner {
378         minPriceInWeiForIco = newMinPriceInWeiForIco;
379     }
380 
381 }