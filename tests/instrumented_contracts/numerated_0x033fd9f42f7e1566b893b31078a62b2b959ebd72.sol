1 pragma solidity ^0.4.20; 
2 
3 contract ERC20Interface {
4     function totalSupply() public constant returns (uint256);
5     function balanceOf(address owner) public constant returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7     function transferFrom(address from, address to, uint256 value) public returns (bool);
8     function approve(address spender, uint256 value) public returns (bool);
9     function allowance(address owner, address spender) public constant returns (uint256);
10 }
11 
12 // ----------------------------------------------------------------------------
13 // Contract function to receive approval and execute function in one call
14 //
15 // Borrowed from MiniMeToken
16 // ----------------------------------------------------------------------------
17 
18 interface ApproveAndCallFallBack {
19     function receiveApproval(address from, uint256 tokens, address token) external;
20 }
21 
22 contract TRLCoinSale is ApproveAndCallFallBack {
23     // Information about a single period
24     struct Period {
25         uint start;
26         uint end;
27         uint priceInWei;
28         uint tokens;
29     }
30 
31     // Information about payment contribution
32     struct PaymentContribution {
33         uint weiContributed;
34         uint timeContribution;
35         uint receiveTokens;
36     }
37 
38     struct TotalContribution {
39         // total value of contribution;
40         // for empty address it will be zero
41         uint totalReceiveTokens;
42         // Only necessary if users want to be able to see contribution history. 
43         // Otherwise, technically not necessary for the purposes of the sale
44         PaymentContribution[] paymentHistory; 
45     }
46 
47     // Some constant about our expected token distribution
48     uint public constant TRLCOIN_DECIMALS = 0;
49     uint public constant TOTAL_TOKENS_TO_DISTRIBUTE = 800000000 * (10 ** TRLCOIN_DECIMALS); // 800000000  TRL Token for distribution
50     uint public constant TOTAL_TOKENS_AVAILABLE = 1000000000 * (10 ** TRLCOIN_DECIMALS);    // 1000000000 TRL Token totals
51 
52     // ERC20 Contract address.
53     ERC20Interface private tokenWallet; // The token wallet contract used for this crowdsale
54     
55     address private owner;  // The owner of the crowdsale
56     
57     uint private smallBonus; //The small bonus for presale
58     uint private largeBonus; //The large bonus for presale
59     uint private largeBonusStopTime; //The stop time for Large bonus
60 
61     uint private tokensRemainingForSale; //Remaining total amout of tokens  
62     uint private tokensAwardedForSale;   // total awarded tokens
63 
64     uint private distributionTime; // time after we could start distribution tokens
65     
66     Period private preSale; // The configured periods for this crowdsale
67     Period private sale;    // The configured periods for this crowdsale
68     
69     
70     // pair fo variables one for mapping one for iteration
71     mapping(address => TotalContribution) public payments; // Track contributions by each address 
72     address[] public paymentAddresses;
73 
74     bool private hasStarted; // Has the crowdsale started?
75     
76     // Fired once the transfer tokens to contract was successfull
77     event Transfer(address indexed to, uint amount);
78 
79     // Fired once the sale starts
80     event Start(uint timestamp);
81 
82     // Fired whenever a contribution is made
83     event Contribute(address indexed from, uint weiContributed, uint tokensReceived);
84 
85     // Fires whenever we send token to contributor
86     event Distribute( address indexed to, uint tokensSend );
87 
88     function addContribution(address from, uint weiContributed, uint tokensReceived) private returns(bool) {
89         //new contibutor
90         require(weiContributed > 0);
91         require(tokensReceived > 0);
92         require(tokensRemainingForSale >= tokensReceived);
93         
94         PaymentContribution memory newContribution;
95         newContribution.timeContribution = block.timestamp;
96         newContribution.weiContributed = weiContributed;
97         newContribution.receiveTokens = tokensReceived;
98 
99         // Since we cannot contribute zero tokens, if totalReceiveTokens is zero,
100         // then this is the first contribution for this address
101         if (payments[from].totalReceiveTokens == 0) {
102             // new total contribution           
103             payments[from].totalReceiveTokens = tokensReceived;
104             payments[from].paymentHistory.push(newContribution);
105             
106              // push new address to array for iteration by address  during distirbution process
107             paymentAddresses.push(from);
108         } else {
109             payments[from].totalReceiveTokens += tokensReceived;
110             payments[from].paymentHistory.push(newContribution);
111         }
112         tokensRemainingForSale -= tokensReceived;
113         tokensAwardedForSale += tokensReceived;
114         return true;
115     }
116 
117     // public getters for private state variables
118     function getOwner() public view returns (address) { return owner; }
119     function getHasStartedState() public view  returns(bool) { return hasStarted; }
120     function getPresale() public view returns(uint, uint, uint, uint) { 
121         return (preSale.start, preSale.end, preSale.priceInWei, preSale.tokens);
122     }
123     function getSale() public view returns(uint, uint, uint, uint) { 
124         return (sale.start, sale.end, sale.priceInWei, sale.tokens);
125     }
126     function getDistributionTime() public view returns(uint) { return distributionTime; }
127     
128     function getSmallBonus() public view returns(uint) { return smallBonus; }
129     function getLargeBonus() public view returns(uint) { return largeBonus; }
130     function getLargeBonusStopTime() public view returns(uint) { return  largeBonusStopTime; }
131     function getTokenRemaining() public view returns(uint) { return tokensRemainingForSale; }
132     function getTokenAwarded() public view returns(uint) { return tokensAwardedForSale; }
133 
134     // After create sale contract first function should be approveAndCall on Token contract
135     // with this contract as spender and TOTAL_TOKENS_TO_DISTRIBUTE for approval
136     // this callback function called form Token contract after approve on Token contract
137     // eventually tokensRemainingForSale = TOTAL_TOKENS_TO_DISTRIBUTE
138     function receiveApproval(address from, uint256 tokens, address token) external {
139         // make sure the sales was not started
140         require(hasStarted == false);
141         
142         // make sure this token address matches our configured tokenWallet address
143         require(token == address(tokenWallet)); 
144         
145         tokensRemainingForSale += tokens;
146         bool result = tokenWallet.transferFrom(from, this, tokens);
147         // Make sure transfer succeeded
148         require(result == true);
149         
150         Transfer(address(this), tokens);
151     }
152 
153     // contract constructor
154     function TRLCoinSale(address walletAddress) public {
155         // Setup the owner and wallet
156         owner = msg.sender;
157         tokenWallet = ERC20Interface(walletAddress);
158 
159         // Make sure the provided token has the expected number of tokens to distribute
160         require(tokenWallet.totalSupply() == TOTAL_TOKENS_AVAILABLE);
161 
162         // Make sure the owner actually controls all the tokens
163         require(tokenWallet.balanceOf(owner) >= TOTAL_TOKENS_TO_DISTRIBUTE);
164 
165         // The multiplier necessary to change a coin amount to the token amount
166         uint coinToTokenFactor = 10 ** TRLCOIN_DECIMALS;
167 
168         preSale.start = 1520812800; // 00:00:00, March 12, 2018 UTC use next site https://www.epochconverter.com/
169         preSale.end = 1523491199; // 23:59:59, July 11, 2018 UTC
170         preSale.priceInWei = (1 ether) / (20000 * coinToTokenFactor); // 1 ETH = 20000 TRL
171         preSale.tokens = TOTAL_TOKENS_TO_DISTRIBUTE / 2;
172        
173         smallBonus = 10;
174         largeBonus = 20;
175         largeBonusStopTime = 1521504000;
176     
177         sale.start = 1523491200; // 00:00:00, July 12, 2018 UTC use next site https://www.epochconverter.com/
178         sale.end = 1531378799; // 23:59:59, July 11, 2018 UTC
179         sale.priceInWei = (1 ether) / (10000 * coinToTokenFactor); // 1 ETH = 10000 TRL
180         sale.tokens = TOTAL_TOKENS_TO_DISTRIBUTE / 2;
181         
182         distributionTime = 1531378800; // 00:00:00, June 12, 2018 UTC
183 
184         tokensRemainingForSale = 0;
185         tokensAwardedForSale = 0;
186     }
187 
188     // change default presale dates 
189     function setPresaleDates(uint startDate, uint stopDate) public {
190         // Only the owner can do this
191         require(msg.sender == owner); 
192         // Cannot change if already started
193         require(hasStarted == false);
194         //insanity check start < stop and stop resale < start of sale
195         require(startDate < stopDate && stopDate < sale.start);
196         
197         preSale.start = startDate;
198         preSale.end = stopDate;
199     }
200     
201     // change default presale dates 
202     function setlargeBonusStopTime(uint bonusStopTime) public {
203         // Only the owner can do this
204         require(msg.sender == owner); 
205         // Cannot change if already started
206         require(hasStarted == false);
207         //insanity check start < stop and stop resale < start of sale
208         require(preSale.start <= bonusStopTime && bonusStopTime <= preSale.end);
209         
210         largeBonusStopTime = bonusStopTime;
211     }
212     
213     // change default sale dates 
214     function setSale(uint startDate, uint stopDate) public {
215         // Only the owner can do this
216         require(msg.sender == owner); 
217         // Cannot change if already started
218         require(hasStarted == false);
219         // insanity check start < stop and stop resale < start of sale
220         require(startDate < stopDate && startDate > preSale.end);
221         // insanity check sale.end < distirbution token time
222         require(sale.end < distributionTime);
223         
224         sale.start = startDate;
225         sale.end = stopDate;
226     }
227 
228     // change default distibution time
229     function setDistributionTime(uint timeOfDistribution) public {
230         // Only the owner can do this
231         require(msg.sender == owner); 
232         // Cannot change if already started
233         require(hasStarted == false);
234         // insanity check sale.end < distirbution token time
235         require(sale.end < timeOfDistribution);
236         
237         distributionTime = timeOfDistribution;
238     }
239 
240     // this function added Contributor that already made contribution before presale started 
241     // should be called only after token was transfered to Sale contract
242     function addContributorManually( address who, uint contributionWei, uint tokens) public returns(bool) {
243         // only owner
244         require(msg.sender == owner);   
245         //contract must be not active
246         require(hasStarted == false);
247         // all entried must be added before presale started
248         require(block.timestamp < preSale.start);
249         // contract mush have total == TOTAL_TOKENS_TO_DISTRIBUTE
250         require((tokensRemainingForSale + tokensAwardedForSale) == TOTAL_TOKENS_TO_DISTRIBUTE);
251         
252         // decrement presale - token for manual contibution should be taken from presale
253         preSale.tokens -= tokens;
254 
255         addContribution(who, contributionWei, tokens);
256         Contribute(who, contributionWei, tokens);
257         return true;
258     }
259 
260     // Start the crowdsale
261     function startSale() public {
262         // Only the owner can do this
263         require(msg.sender == owner); 
264         // Cannot start if already started
265         require(hasStarted == false);
266         // Make sure the timestamps all make sense
267         require(preSale.end > preSale.start);
268         require(sale.end > sale.start);
269         require(sale.start > preSale.end);
270         require(distributionTime > sale.end);
271 
272         // Make sure the owner actually controls all the tokens for sales
273         require(tokenWallet.balanceOf(address(this)) == TOTAL_TOKENS_TO_DISTRIBUTE);
274         require((tokensRemainingForSale + tokensAwardedForSale) == TOTAL_TOKENS_TO_DISTRIBUTE);
275 
276         // Make sure we allocated all sale tokens
277         require((preSale.tokens + sale.tokens) == tokensRemainingForSale);          
278 
279         // The sale can begin
280         hasStarted = true;
281 
282         // Fire event that the sale has begun
283         Start(block.timestamp);
284     }    
285 
286     // Allow the current owner to change the owner of the crowdsale
287     function changeOwner(address newOwner) public {
288         // Only the owner can do this
289         require(msg.sender == owner);
290 
291         // Change the owner
292         owner = newOwner;
293     }
294 
295     function preSaleFinishedProcess( uint timeOfRequest) private returns(bool) {
296         // if we have Sales event and tokens of presale is not 0 move them to sales
297         require(timeOfRequest >= sale.start && timeOfRequest <= sale.end);
298         if (preSale.tokens != 0) {
299             uint savePreSaleTomens = preSale.tokens;
300             preSale.tokens = 0;
301             sale.tokens += savePreSaleTomens;
302         }
303         return true;
304     }
305     
306     // Calculate how many tokens can be distributed for the given contribution
307     function getTokensForContribution(uint weiContribution) private returns(uint timeOfRequest, uint tokenAmount, uint weiRemainder, uint bonus) { 
308         // Get curent time
309         timeOfRequest = block.timestamp;
310         // just for sure that bonus is initialized
311         bonus = 0;
312                  
313         // checking what period are we
314         if (timeOfRequest <= preSale.end) {
315             // Return the amount of tokens that can be purchased
316             // And the amount of wei that would be left over
317             tokenAmount = weiContribution / preSale.priceInWei;
318             weiRemainder = weiContribution % preSale.priceInWei;
319             // if presale - checking bonuses
320             if (timeOfRequest < largeBonusStopTime) {
321                 bonus = ( tokenAmount * largeBonus ) / 100;
322             } else {
323                 bonus = ( tokenAmount * smallBonus ) / 100;
324             }             
325         } else {
326             // if sales period just started - transfer all remaining tokens from presale to sale
327             preSaleFinishedProcess(timeOfRequest);
328             // Return the amount of tokens that can be purchased
329             // And the amount of wei that would be left over
330             tokenAmount = weiContribution / sale.priceInWei;
331             weiRemainder = weiContribution % sale.priceInWei;
332         } 
333         return(timeOfRequest, tokenAmount, weiRemainder, bonus);
334     }
335     
336     function()public payable {
337         // Cannot contribute if the sale hasn't started
338         require(hasStarted == true);
339         // Cannot contribute if sale is not in this time range
340         require((block.timestamp >= preSale.start && block.timestamp <= preSale.end)
341             || (block.timestamp >= sale.start && block.timestamp <= sale.end)
342         ); 
343 
344         // Cannot contribute if amount of money send is les then 0.1 ETH
345         require(msg.value >= 100 finney);
346         
347         uint timeOfRequest;
348         uint tokenAmount;
349         uint weiRemainder;
350         uint bonus;
351         // Calculate the tokens to be distributed based on the contribution amount
352         (timeOfRequest, tokenAmount, weiRemainder, bonus) = getTokensForContribution(msg.value);
353 
354         // Make sure there are enough tokens left to buy
355         require(tokensRemainingForSale >= tokenAmount + bonus);
356         
357         // Need to contribute enough for at least 1 token
358         require(tokenAmount > 0);
359         
360         // Sanity check: make sure the remainder is less or equal to what was sent to us
361         require(weiRemainder <= msg.value);
362 
363         // Check whether in presale or sale
364         if (timeOfRequest <= preSale.end) {
365             require(tokenAmount <= preSale.tokens);
366             require(bonus <= sale.tokens);
367             preSale.tokens -= tokenAmount;
368             sale.tokens -= bonus;
369         } else {
370             require(tokenAmount <= sale.tokens);
371             // there should be no bonus available after presale
372             require(bonus == 0); 
373             sale.tokens -= tokenAmount;
374         }
375 
376         // setup new contribution
377         addContribution(msg.sender, msg.value - weiRemainder, tokenAmount + bonus);
378 
379         /// Transfer contribution amount to owner
380         owner.transfer(msg.value - weiRemainder);
381         // Return the remainder to the sender
382         msg.sender.transfer(weiRemainder);
383 
384         // Since we refunded the remainder, the actual contribution is the amount sent
385         // minus the remainder
386         
387         // Record the event
388         Contribute(msg.sender, msg.value - weiRemainder, tokenAmount + bonus);
389     } 
390 
391     
392     // Allow the owner to withdraw all the tokens remaining after the
393     // crowdsale is over
394     function withdrawTokensRemaining() public returns (bool) {
395         // Only the owner can do this
396         require(msg.sender == owner);
397         // The crowsale must be over to perform this operation
398         require(block.timestamp > sale.end);
399         // Get the remaining tokens owned by the crowdsale
400         uint tokenToSend = tokensRemainingForSale;
401         // Set available tokens to Zero
402         tokensRemainingForSale = 0;
403         sale.tokens = 0;
404         // Transfer them all to the owner
405         bool result = tokenWallet.transfer(owner, tokenToSend);
406         // Be sure that transfer was successfull
407         require(result == true);
408         Distribute(owner, tokenToSend);
409         return true;
410     }
411 
412     // Allow the owner to withdraw all ether from the contract after the crowdsale is over.
413     // We don't need this function( we transfer ether immediately to owner - just in case
414     function withdrawEtherRemaining() public returns (bool) {
415         // Only the owner can do this
416         require(msg.sender == owner);
417         // The crowsale must be over to perform this operation
418         require(block.timestamp > sale.end);
419 
420         // Transfer them all to the owner
421         owner.transfer(this.balance);
422         return true;
423     }
424 
425     // this function is intentionally internal because we do not check conditions here
426     function transferTokensToContributor(uint idx) private returns (bool) {
427         if (payments[paymentAddresses[idx]].totalReceiveTokens > 0) {
428             // this is for race conditions               
429             uint tokenToSend = payments[paymentAddresses[idx]].totalReceiveTokens;
430             payments[paymentAddresses[idx]].totalReceiveTokens = 0;
431             
432             //decrement awarded token
433             require(tokensAwardedForSale >= tokenToSend);
434             tokensAwardedForSale -= tokenToSend;
435             // Transfer them all to the owner
436             bool result = tokenWallet.transfer(paymentAddresses[idx], tokenToSend);
437             // Be sure that transfer was successfull
438             require(result == true);
439             Distribute(paymentAddresses[idx], tokenToSend);
440         }
441         return true;
442 
443     }
444     
445     // get number of real contributors
446     function getNumberOfContributors( ) public view returns (uint) {
447         return paymentAddresses.length;
448     }
449     
450     // This function for transfer tokens one by one
451     function distributeTokensToContributorByIndex( uint indexVal) public returns (bool) {
452         // this is regular check for this function
453         require(msg.sender == owner);
454         require(block.timestamp >= distributionTime);
455         require(indexVal < paymentAddresses.length);
456         
457         transferTokensToContributor(indexVal);                    
458         return true;        
459     }
460 
461     function distributeTokensToContributor( uint startIndex, uint numberOfContributors )public returns (bool) {
462         // this is regular check for this function
463         require(msg.sender == owner);
464         require(block.timestamp >= distributionTime);
465         require(startIndex < paymentAddresses.length);
466         
467         uint len = paymentAddresses.length < startIndex + numberOfContributors? paymentAddresses.length : startIndex + numberOfContributors;
468         for (uint i = startIndex; i < len; i++) {
469             transferTokensToContributor(i);                    
470         }
471         return true;        
472     }
473 
474     function distributeAllTokensToContributor( )public returns (bool) {
475         // this is regular check for this function
476         require(msg.sender == owner);
477         require(block.timestamp >= distributionTime);
478         
479         for (uint i = 0; i < paymentAddresses.length; i++) {
480             transferTokensToContributor(i); 
481         }
482         return true;        
483     }
484     
485     // Owner can transfer out any accidentally sent ERC20 tokens as long as they are not the sale tokens
486     function transferAnyERC20Token(address tokenAddress, uint tokens) public returns (bool) {
487         require(msg.sender == owner);
488         require(tokenAddress != address(tokenWallet));
489         return ERC20Interface(tokenAddress).transfer(owner, tokens);
490     }
491 }