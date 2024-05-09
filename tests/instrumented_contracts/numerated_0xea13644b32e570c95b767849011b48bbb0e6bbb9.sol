1 pragma solidity 0.4.18;
2 
3 contract CrowdsaleParameters {
4     // Accounts (2017-11-30)
5     address internal constant presalePoolAddress        = 0xF373BfD05C8035bE6dcB44CABd17557e49D5364C;
6     address internal constant foundersAddress           = 0x0ED375dd94c878703147580F044B6B1CE6a7F053;
7     address internal constant incentiveReserveAddress   = 0xD34121E853af290e61a0F0313B99abb24D4Dc6ea;
8     address internal constant generalSaleAddress        = 0xC107EC2077BA7d65944267B64F005471A6c05692;
9     address internal constant lotteryAddress            = 0x98631b688Bcf78D233C48E464fCfe6dC7aBd32A7;
10     address internal constant marketingAddress          = 0x2C1C916a4aC3d0f2442Fe0A9b9e570eB656582d8;
11 
12     // PreICO and Main sale ICO Timing per requirements
13     uint256 internal constant presaleStartDate      = 1512121500; // 2017-12-01 09:45 GMT
14     uint256 internal constant presaleEndDate        = 1513382430; // 2017-12-16 00:00:30 GMT
15     uint256 internal constant generalSaleStartDate  = 1515319200; // 2018-01-07 10:00 GMT
16     uint256 internal constant generalSaleEndDate    = 1518602400; // 2018-02-14 10:00 GMT
17 }
18 
19 contract TokenRecipient {
20     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
21 }
22 
23 contract Owned {
24     address public owner;
25 
26     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28     /**
29     *  Constructor
30     *
31     *  Sets contract owner to address of constructor caller
32     */
33     function Owned() public {
34         owner = msg.sender;
35     }
36 
37     modifier onlyOwner() {
38         require(msg.sender == owner);
39         _;
40     }
41 
42     /**
43     *  Change Owner
44     *
45     *  Changes ownership of this contract. Only owner can call this method.
46     *
47     * @param newOwner - new owner's address
48     */
49     function changeOwner(address newOwner) onlyOwner public {
50         require(newOwner != address(0));
51         require(newOwner != owner);
52         OwnershipTransferred(owner, newOwner);
53         owner = newOwner;
54     }
55 }
56 
57 contract SeedToken is Owned, CrowdsaleParameters {
58     uint8 public decimals;
59 
60     function totalSupply() public  returns (uint256 result);
61 
62     function balanceOf(address _address) public returns (uint256 balance);
63 
64     function allowance(address _owner, address _spender) public returns (uint256 remaining);
65 
66     function transfer(address _to, uint256 _value) public returns (bool success);
67 
68     function approve(address _spender, uint256 _value) public returns (bool success);
69 
70     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success);
71 
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
73 
74     function accountBalance(address _address) public returns (uint256 balance);
75 }
76 
77 contract LiveTreeCrowdsale is Owned, CrowdsaleParameters {
78     uint[] public ICOStagePeriod;
79 
80     bool public icoClosedManually = false;
81 
82     bool public allowRefunds = false;
83 
84     uint public totalCollected = 0;
85 
86     address private saleWalletAddress;
87 
88     address private presaleWalletAddress;
89 
90     uint private tokenMultiplier = 10;
91 
92     SeedToken private tokenReward;
93 
94     uint private reasonableCostsPercentage;
95 
96     mapping (address => uint256) private investmentRecords;
97 
98     event FundTransfer(address indexed _from, address indexed _to, uint _value);
99 
100     event TokenTransfer(address indexed baker, uint tokenAmount, uint pricePerToken);
101 
102     event Refund(address indexed backer, uint amount);
103 
104     enum Stage { PreSale, GeneralSale, Inactive }
105 
106     /**
107     * Constructor
108     *
109     * @param _tokenAddress - address of SED token (deployed before this contract)
110     */
111     function LiveTreeCrowdsale(address _tokenAddress) public {
112         tokenReward = SeedToken(_tokenAddress);
113         tokenMultiplier = tokenMultiplier ** tokenReward.decimals();
114         saleWalletAddress = CrowdsaleParameters.generalSaleAddress;
115         presaleWalletAddress = CrowdsaleParameters.presalePoolAddress;
116 
117         ICOStagePeriod.push(CrowdsaleParameters.presaleStartDate);
118         ICOStagePeriod.push(CrowdsaleParameters.presaleEndDate);
119         ICOStagePeriod.push(CrowdsaleParameters.generalSaleStartDate);
120         ICOStagePeriod.push(CrowdsaleParameters.generalSaleEndDate);
121     }
122 
123     /**
124     * Get active stage (pre-sale or general sale)
125     *
126     * @return stage - active stage
127     */
128     function getActiveStage() internal constant returns (Stage) {
129         if (ICOStagePeriod[0] <= now && now < ICOStagePeriod[1])
130             return Stage.PreSale;
131 
132         if (ICOStagePeriod[2] <= now && now < ICOStagePeriod[3])
133             return Stage.GeneralSale;
134 
135         return Stage.Inactive;
136     }
137 
138     /**
139     *  Process received payment
140     *
141     *  Determine the number of tokens that was purchased considering current
142     *  stage, bonus tier and remaining amount of tokens in the sale wallet.
143     *  Transfer purchased tokens to bakerAddress and return unused portion of
144     *  ether (change)
145     *
146     * @param bakerAddress - address that ether was sent from
147     * @param amount - amount of Wei received
148     */
149     function processPayment(address bakerAddress, uint amount) internal {
150         // Check current stage, either pre-sale or general sale should be active
151         Stage currentStage = getActiveStage();
152         require(currentStage != Stage.Inactive);
153 
154         // Validate if ICO is not closed manually or reached the threshold
155         require(!icoClosedManually);
156 
157         // Before Metropolis update require will not refund gas, but
158         // for some reason require statement around msg.value always throws
159         assert(amount > 0 finney);
160 
161         // Validate that we received less than a billion ETH to prevent overflow
162         require(amount < 1e27);
163 
164         // Tell everyone about the transfer
165         FundTransfer(bakerAddress, address(this), amount);
166 
167         // Calculate tokens per ETH for this tier
168         uint tokensPerEth = 1130;
169 
170         if (amount < 1.5 ether)
171             tokensPerEth = 1000;
172         else if (amount < 3 ether)
173             tokensPerEth = 1005;
174         else if (amount < 5 ether)
175             tokensPerEth = 1010;
176         else if (amount < 7 ether)
177             tokensPerEth = 1015;
178         else if (amount < 10 ether)
179             tokensPerEth = 1020;
180         else if (amount < 15 ether)
181             tokensPerEth = 1025;
182         else if (amount < 20 ether)
183             tokensPerEth = 1030;
184         else if (amount < 30 ether)
185             tokensPerEth = 1035;
186         else if (amount < 50 ether)
187             tokensPerEth = 1040;
188         else if (amount < 75 ether)
189             tokensPerEth = 1045;
190         else if (amount < 100 ether)
191             tokensPerEth = 1050;
192         else if (amount < 150 ether)
193             tokensPerEth = 1055;
194         else if (amount < 250 ether)
195             tokensPerEth = 1060;
196         else if (amount < 350 ether)
197             tokensPerEth = 1070;
198         else if (amount < 500 ether)
199             tokensPerEth = 1075;
200         else if (amount < 750 ether)
201             tokensPerEth = 1080;
202         else if (amount < 1000 ether)
203             tokensPerEth = 1090;
204         else if (amount < 1500 ether)
205             tokensPerEth = 1100;
206         else if (amount < 2000 ether)
207             tokensPerEth = 1110;
208         else if (amount < 3500 ether)
209             tokensPerEth = 1120;
210 
211         if (currentStage == Stage.PreSale)
212             tokensPerEth = tokensPerEth * 2;
213 
214         // Calculate token amount that is purchased,
215         // truncate to integer
216         uint weiPerEth = 1e18;
217         uint tokenAmount = amount * tokensPerEth * tokenMultiplier / weiPerEth;
218 
219         // Check that stage wallet has enough tokens. If not, sell the rest and
220         // return change.
221         address tokenSaleWallet = currentStage == Stage.PreSale ? presaleWalletAddress : saleWalletAddress;
222         uint remainingTokenBalance = tokenReward.accountBalance(tokenSaleWallet);
223         if (remainingTokenBalance < tokenAmount) {
224             tokenAmount = remainingTokenBalance;
225         }
226 
227         // Calculate Wei amount that was received in this transaction
228         // adjusted to rounding and remaining token amount
229         uint acceptedAmount = tokenAmount * weiPerEth / (tokensPerEth * tokenMultiplier);
230 
231         // Transfer tokens to baker and return ETH change
232         tokenReward.transferFrom(tokenSaleWallet, bakerAddress, tokenAmount);
233 
234         TokenTransfer(bakerAddress, tokenAmount, tokensPerEth);
235 
236         uint change = amount - acceptedAmount;
237         if (change > 0) {
238             if (bakerAddress.send(change)) {
239                 FundTransfer(address(this), bakerAddress, change);
240             }
241             else
242                 revert();
243         }
244 
245         // Update crowdsale performance
246         investmentRecords[bakerAddress] += acceptedAmount;
247         totalCollected += acceptedAmount;
248     }
249 
250     /**
251     * Change pre-sale end date
252     *
253     * @param endDate - end date of pre-sale in milliseconds from unix epoch
254     */
255     function changePresaleEndDate(uint256 endDate) external onlyOwner {
256         require(ICOStagePeriod[0] < endDate);
257         require(ICOStagePeriod[2] >= endDate);
258 
259         ICOStagePeriod[1] = endDate;
260     }
261 
262     /**
263     * Change general sale start date
264     *
265     * @param startDate - start date of general sale in milliseconds from unix epoch
266     */
267     function changeGeneralSaleStartDate(uint256 startDate) external onlyOwner {
268         require(now < startDate);
269         require(ICOStagePeriod[1] <= startDate);
270 
271         ICOStagePeriod[2] = startDate;
272     }
273 
274     /**
275     * Change general sale end date
276     *
277     * @param endDate - end date of general sale in milliseconds from unix epoch
278     */
279     function changeGeneralSaleEndDate(uint256 endDate) external onlyOwner {
280         require(ICOStagePeriod[2] < endDate);
281 
282         ICOStagePeriod[3] = endDate;
283     }
284 
285     /**
286     * Stop ICO manually
287     */
288     function pauseICO() external onlyOwner {
289         require(!icoClosedManually);
290 
291         icoClosedManually = true;
292     }
293 
294     /**
295     * Reopen ICO
296     */
297     function unpauseICO() external onlyOwner {
298         require(icoClosedManually);
299 
300         icoClosedManually = false;
301     }
302 
303     /**
304     * Close main sale and destroy unsold tokens
305     */
306     function closeMainSaleICO() external onlyOwner {
307         var amountToDestroy = tokenReward.balanceOf(CrowdsaleParameters.generalSaleAddress);
308         tokenReward.transferFrom(CrowdsaleParameters.generalSaleAddress, 0, amountToDestroy);
309         ICOStagePeriod[3] = now;
310         TokenTransfer(0, amountToDestroy, 0);
311     }
312 
313     /**
314     * Close pre ICO and transfer all unsold tokens to main sale wallet
315     */
316     function closePreICO() external onlyOwner {
317         var amountToTransfer = tokenReward.balanceOf(CrowdsaleParameters.presalePoolAddress);
318         ICOStagePeriod[1] = now;
319         tokenReward.transferFrom(CrowdsaleParameters.presalePoolAddress, CrowdsaleParameters.generalSaleAddress, amountToTransfer);
320     }
321 
322 
323     /**
324     * Allow or disallow refunds
325     *
326     * @param value - if true, refunds will be allowed; if false, disallowed
327     * @param _reasonableCostsPercentage - non-refundable fraction of total
328     *        collections in tens of a percent. Valid range is 0 to 1000:
329     *        0 = 0.0%, 123 = 12.3%, 1000 = 100.0%
330     */
331     function setAllowRefunds(bool value, uint _reasonableCostsPercentage) external onlyOwner {
332         require(isICOClosed());
333         require(_reasonableCostsPercentage >= 1 && _reasonableCostsPercentage <= 999);
334 
335         allowRefunds = value;
336         reasonableCostsPercentage = _reasonableCostsPercentage;
337     }
338 
339     /**
340     *  Transfer ETH amount from contract to owner's address.
341     *
342     * @param amount - ETH amount to transfer in Wei
343     */
344     function safeWithdrawal(uint amount) external onlyOwner {
345         require(this.balance >= amount);
346 
347         if (owner.send(amount))
348             FundTransfer(address(this), owner, amount);
349     }
350 
351     /**
352     function
353     * Is ICO closed (either closed manually or not started)
354     *
355     * @return true if ICO is closed manually or stage is "Inactive", otherwise false
356     */
357     function isICOClosed() public constant returns (bool closed) {
358         Stage currentStage = getActiveStage();
359         return icoClosedManually || currentStage == Stage.Inactive;
360     }
361 
362     /**
363     *  Default method
364     *
365     *  Processes all ETH that it receives and credits SED tokens to sender
366     *  according to current stage and tier bonus
367     */
368     function () external payable {
369         processPayment(msg.sender, msg.value);
370     }
371 
372     /**
373     *  Kill method
374     *
375     *  Destructs this contract
376     */
377     function kill() external onlyOwner {
378         require(isICOClosed());
379 
380         selfdestruct(owner);
381     }
382 
383     /**
384     *  Refund
385     *
386     *  Sends a partial refund to the sender who calls this method.
387     *  Fraction of collected amount will not be refunded
388     */
389     function refund() external {
390         require(isICOClosed() && allowRefunds && investmentRecords[msg.sender] > 0);
391 
392         var amountToReturn = investmentRecords[msg.sender] * (1000 - reasonableCostsPercentage) / 1000;
393 
394         require(this.balance >= amountToReturn);
395 
396         investmentRecords[msg.sender] = 0;
397         msg.sender.transfer(amountToReturn);
398         Refund(msg.sender, amountToReturn);
399     }
400 }