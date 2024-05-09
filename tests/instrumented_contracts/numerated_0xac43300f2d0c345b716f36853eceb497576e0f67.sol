1 /** @title Interactive Coin Offering
2  *  @author Clément Lesaege - <clement@lesaege.com>
3  */
4 
5 pragma solidity ^0.4.23;
6 
7 /**
8  * @title ERC20Basic
9  * @dev Simpler version of ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/179
11  */
12 contract ERC20Basic {
13   function totalSupply() public view returns (uint256);
14   function balanceOf(address who) public view returns (uint256);
15   function transfer(address to, uint256 value) public returns (bool);
16   event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender) public view returns (uint256);
25   function transferFrom(address from, address to, uint256 value) public returns (bool);
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 /** @title Interactive Coin Offering
31  *  This contract implements the Interactive Coin Offering token sale as described in this paper:
32  *  https://people.cs.uchicago.edu/~teutsch/papers/ico.pdf
33  *  Implementation details and modifications compared to the paper:
34  *  -A fixed amount of tokens is sold. This allows more flexibility for the distribution of the remaining tokens (rounds, team tokens which can be preallocated, non-initial sell of some cryptographic assets).
35  *  -The valuation pointer is only moved when the sale is over. This greatly reduces the amount of write operations and code complexity. However, at least one party must make one or multiple calls to finalize the sale.
36  *  -Buckets are not used as they are not required and increase code complexity.
37  *  -The bid submitter must provide the insertion spot. A search of the insertion spot is still done in the contract just in case the one provided was wrong or other bids were added between when the TX got signed and executed, but giving the search starting point greatly lowers gas consumption.
38  *  -Automatic withdrawals are only possible at the end of the sale. This decreases code complexity and possible interactions between different parts of the code.
39  *  -We put a full bonus, free withdrawal period at the beginning. This allows everyone to have a chance to place bids with full bonus and avoids clogging the network just after the sale starts. Note that at this moment, no information can be taken for granted as parties can withdraw freely.
40  *  -Calling the fallback function while sending ETH places a bid with an infinite maximum valuation. This allows buyers who want to buy no matter the price not need to use a specific interface and just send ETH. Without ETH, a call to the fallback function redeems the bids of the caller.
41  */
42 contract IICO {
43 
44     /* *** General *** */
45     address public owner;       // The one setting up the contract.
46     address public beneficiary; // The address which will get the funds.
47 
48     /* *** Bid *** */
49     uint constant HEAD = 0;            // Minimum value used for both the maxValuation and bidID of the head of the linked list.
50     uint constant TAIL = uint(-1);     // Maximum value used for both the maxValuation and bidID of the tail of the linked list.
51     uint constant INFINITY = uint(-2); // A value so high that a bid using it is guaranteed to succeed. Still lower than TAIL to be placed before TAIL.
52     // A bid to buy tokens as long as the personal maximum valuation is not exceeded.
53     // Bids are in a sorted doubly linked list.
54     // They are sorted in ascending order by (maxValuation,bidID) where bidID is the ID and key of the bid in the mapping.
55     // The list contains two artificial bids HEAD and TAIL having respectively the minimum and maximum bidID and maxValuation.
56     struct Bid {
57         /* *** Linked List Members *** */
58         uint prev;            // bidID of the previous element.
59         uint next;            // bidID of the next element.
60         /* ***     Bid Members     *** */
61         uint maxValuation;    // Maximum valuation in wei beyond which the contributor prefers refund.
62         uint contrib;         // Contribution in wei.
63         uint bonus;           // The numerator of the bonus that will be divided by BONUS_DIVISOR.
64         address contributor;  // The contributor who placed the bid.
65         bool withdrawn;       // True if the bid has been withdrawn.
66         bool redeemed;        // True if the ETH or tokens have been redeemed.
67     }
68     mapping (uint => Bid) public bids; // Map bidID to bid.
69     mapping (address => uint[]) public contributorBidIDs; // Map contributor to a list of its bid ID.
70     uint public lastBidID = 0; // The last bidID not accounting TAIL.
71 
72     /* *** Sale parameters *** */
73     uint public startTime;                      // When the sale starts.
74     uint public endFullBonusTime;               // When the full bonus period ends.
75     uint public withdrawalLockTime;             // When the contributors can't withdraw their bids manually anymore.
76     uint public endTime;                        // When the sale ends.
77     ERC20 public token;                         // The token which is sold.
78     uint public tokensForSale;                  // The amount of tokens which will be sold.
79     uint public maxBonus;                       // The maximum bonus. Will be normalized by BONUS_DIVISOR. For example for a 20% bonus, _maxBonus must be 0.2 * BONUS_DIVISOR.
80     uint constant BONUS_DIVISOR = 1E9;          // The quantity we need to divide by to normalize the bonus.
81 
82     /* *** Finalization variables *** */
83     bool public finalized;                 // True when the cutting bid has been found. The following variables are final only after finalized==true.
84     uint public cutOffBidID = TAIL;        // The first accepted bid. All bids after it are accepted.
85     uint public sumAcceptedContrib;        // The sum of accepted contributions.
86     uint public sumAcceptedVirtualContrib; // The sum of virtual (taking into account bonuses) contributions.
87 
88     /* *** Events *** */
89     event BidSubmitted(address indexed contributor, uint indexed bidID, uint indexed time);
90 
91     /* *** Modifiers *** */
92     modifier onlyOwner{ require(owner == msg.sender); _; }
93 
94     /* *** Functions Modifying the state *** */
95 
96     /** @dev Constructor. First contract set up (tokens will also need to be transferred to the contract and then setToken needs to be called to finish the setup).
97      *  @param _startTime Time the sale will start in seconds since the Unix Epoch.
98      *  @param _fullBonusLength Amount of seconds the sale lasts in the full bonus period.
99      *  @param _partialWithdrawalLength Amount of seconds the sale lasts in the partial withdrawal period.
100      *  @param _withdrawalLockUpLength Amount of seconds the sale lasts in the withdrawal lockup period.
101      *  @param _maxBonus The maximum bonus. Will be normalized by BONUS_DIVISOR. For example for a 20% bonus, _maxBonus must be 0.2 * BONUS_DIVISOR.
102      *  @param _beneficiary The party which will get the funds of the token sale.
103      */
104     function IICO(uint _startTime, uint _fullBonusLength, uint _partialWithdrawalLength, uint _withdrawalLockUpLength, uint _maxBonus, address _beneficiary) public {
105         owner = msg.sender;
106         startTime = _startTime;
107         endFullBonusTime = startTime + _fullBonusLength;
108         withdrawalLockTime = endFullBonusTime + _partialWithdrawalLength;
109         endTime = withdrawalLockTime + _withdrawalLockUpLength;
110         maxBonus = _maxBonus;
111         beneficiary = _beneficiary;
112 
113         // Add the virtual bids. This simplifies other functions.
114         bids[HEAD] = Bid({
115             prev: TAIL,
116             next: TAIL,
117             maxValuation: HEAD,
118             contrib: 0,
119             bonus: 0,
120             contributor: address(0),
121             withdrawn: false,
122             redeemed: false
123         });
124         bids[TAIL] = Bid({
125             prev: HEAD,
126             next: HEAD,
127             maxValuation: TAIL,
128             contrib: 0,
129             bonus: 0,
130             contributor: address(0),
131             withdrawn: false,
132             redeemed: false
133         });
134     }
135 
136     /** @dev Set the token. Must only be called after the IICO contract receives the tokens to be sold.
137      *  @param _token The token to be sold.
138      */
139     function setToken(ERC20 _token) public onlyOwner {
140         require(address(token) == address(0)); // Make sure the token is not already set.
141 
142         token = _token;
143         tokensForSale = token.balanceOf(this);
144     }
145 
146     /** @dev Submit a bid. The caller must give the exact position the bid must be inserted into in the list.
147      *  In practice, use searchAndBid to avoid the position being incorrect due to a new bid being inserted and changing the position the bid must be inserted at.
148      *  @param _maxValuation The maximum valuation given by the contributor. If the amount raised is higher, the bid is cancelled and the contributor refunded because it prefers a refund instead of this level of dilution. To buy no matter what, use INFINITY.
149      *  @param _next The bidID of the next bid in the list.
150      */
151     function submitBid(uint _maxValuation, uint _next) public payable {
152         Bid storage nextBid = bids[_next];
153         uint prev = nextBid.prev;
154         Bid storage prevBid = bids[prev];
155         require(_maxValuation >= prevBid.maxValuation && _maxValuation < nextBid.maxValuation); // The new bid maxValuation is higher than the previous one and strictly lower than the next one.
156         require(now >= startTime && now < endTime); // Check that the bids are still open.
157 
158         ++lastBidID; // Increment the lastBidID. It will be the new bid's ID.
159         // Update the pointers of neighboring bids.
160         prevBid.next = lastBidID;
161         nextBid.prev = lastBidID;
162 
163         // Insert the bid.
164         bids[lastBidID] = Bid({
165             prev: prev,
166             next: _next,
167             maxValuation: _maxValuation,
168             contrib: msg.value,
169             bonus: bonus(),
170             contributor: msg.sender,
171             withdrawn: false,
172             redeemed: false
173         });
174 
175         // Add the bid to the list of bids by this contributor.
176         contributorBidIDs[msg.sender].push(lastBidID);
177 
178         // Emit event
179         emit BidSubmitted(msg.sender, lastBidID, now);
180     }
181 
182 
183     /** @dev Search for the correct insertion spot and submit a bid.
184      *  This function is O(n), where n is the amount of bids between the initial search position and the insertion position.
185      *  The UI must first call search to find the best point to start the search such that it consumes the least amount of gas possible.
186      *  Using this function instead of calling submitBid directly prevents it from failing in the case where new bids are added before the transaction is executed.
187      *  @param _maxValuation The maximum valuation given by the contributor. If the amount raised is higher, the bid is cancelled and the contributor refunded because it prefers a refund instead of this level of dilution. To buy no matter what, use INFINITY.
188      *  @param _next The bidID of the next bid in the list.
189      */
190     function searchAndBid(uint _maxValuation, uint _next) public payable {
191         submitBid(_maxValuation, search(_maxValuation,_next));
192     }
193 
194     /** @dev Withdraw a bid. Can only be called before the end of the withdrawal lock period.
195      *  Withdrawing a bid reduces its bonus by 1/3.
196      *  For retrieving ETH after an automatic withdrawal, use the redeem function.
197      *  @param _bidID The ID of the bid to withdraw.
198      */
199     function withdraw(uint _bidID) public {
200         Bid storage bid = bids[_bidID];
201         require(msg.sender == bid.contributor);
202         require(now < withdrawalLockTime);
203         require(!bid.withdrawn);
204 
205         bid.withdrawn = true;
206 
207         // Before endFullBonusTime, everything is refunded. Otherwise, an amount decreasing linearly from endFullBonusTime to withdrawalLockTime is refunded.
208         uint refund = (now < endFullBonusTime) ? bid.contrib : (bid.contrib * (withdrawalLockTime - now)) / (withdrawalLockTime - endFullBonusTime);
209         assert(refund <= bid.contrib); // Make sure that we don't refund more than the contribution. Would a bug arise, we prefer blocking withdrawal than letting someone steal money.
210         bid.contrib -= refund;
211         bid.bonus = (bid.bonus * 2) / 3; // Reduce the bonus by 1/3.
212 
213         msg.sender.transfer(refund);
214     }
215 
216     /** @dev Finalize by finding the cut-off bid.
217      *  Since the amount of bids is not bounded, this function may have to be called multiple times.
218      *  The function is O(min(n,_maxIt)) where n is the amount of bids. In total it will perform O(n) computations, possibly in multiple calls.
219      *  Each call only has a O(1) storage write operations.
220      *  @param _maxIt The maximum amount of bids to go through. This value must be set in order to not exceed the gas limit.
221      */
222     function finalize(uint _maxIt) public {
223         require(now >= endTime);
224         require(!finalized);
225 
226         // Make local copies of the finalization variables in order to avoid modifying storage in order to save gas.
227         uint localCutOffBidID = cutOffBidID;
228         uint localSumAcceptedContrib = sumAcceptedContrib;
229         uint localSumAcceptedVirtualContrib = sumAcceptedVirtualContrib;
230 
231         // Search for the cut-off bid while adding the contributions.
232         for (uint it = 0; it < _maxIt && !finalized; ++it) {
233             Bid storage bid = bids[localCutOffBidID];
234             if (bid.contrib+localSumAcceptedContrib < bid.maxValuation) { // We haven't found the cut-off yet.
235                 localSumAcceptedContrib        += bid.contrib;
236                 localSumAcceptedVirtualContrib += bid.contrib + (bid.contrib * bid.bonus) / BONUS_DIVISOR;
237                 localCutOffBidID = bid.prev; // Go to the previous bid.
238             } else { // We found the cut-off. This bid will be taken partially.
239                 finalized = true;
240                 uint contribCutOff = bid.maxValuation >= localSumAcceptedContrib ? bid.maxValuation - localSumAcceptedContrib : 0; // The amount of the contribution of the cut-off bid that can stay in the sale without spilling over the maxValuation.
241                 contribCutOff = contribCutOff < bid.contrib ? contribCutOff : bid.contrib; // The amount that stays in the sale should not be more than the original contribution. This line is not required but it is added as an extra security measure.
242                 bid.contributor.send(bid.contrib-contribCutOff); // Send the non-accepted part. Use send in order to not block if the contributor's fallback reverts.
243                 bid.contrib = contribCutOff; // Update the contribution value.
244                 localSumAcceptedContrib += bid.contrib;
245                 localSumAcceptedVirtualContrib += bid.contrib + (bid.contrib * bid.bonus) / BONUS_DIVISOR;
246                 beneficiary.send(localSumAcceptedContrib); // Use send in order to not block if the beneficiary's fallback reverts.
247             }
248         }
249 
250         // Update storage.
251         cutOffBidID = localCutOffBidID;
252         sumAcceptedContrib = localSumAcceptedContrib;
253         sumAcceptedVirtualContrib = localSumAcceptedVirtualContrib;
254     }
255 
256     /** @dev Redeem a bid. If the bid is accepted, send the tokens, otherwise refund the ETH.
257      *  Note that anyone can call this function, not only the party which made the bid.
258      *  @param _bidID ID of the bid to withdraw.
259      */
260     function redeem(uint _bidID) public {
261         Bid storage bid = bids[_bidID];
262         Bid storage cutOffBid = bids[cutOffBidID];
263         require(finalized);
264         require(!bid.redeemed);
265 
266         bid.redeemed=true;
267         if (bid.maxValuation > cutOffBid.maxValuation || (bid.maxValuation == cutOffBid.maxValuation && _bidID >= cutOffBidID)) // Give tokens if the bid is accepted.
268             require(token.transfer(bid.contributor, (tokensForSale * (bid.contrib + (bid.contrib * bid.bonus) / BONUS_DIVISOR)) / sumAcceptedVirtualContrib));
269         else                                                                                            // Reimburse ETH otherwise.
270             bid.contributor.transfer(bid.contrib);
271     }
272 
273     /** @dev Fallback. Make a bid if ETH are sent. Redeem all the bids of the contributor otherwise.
274      *  Note that the contributor could make this function go out of gas if it has too much bids. This in not a problem as it is still possible to redeem using the redeem function directly.
275      *  This allows users to bid and get their tokens back using only send operations.
276      */
277     function () public payable {
278         if (msg.value != 0 && now >= startTime && now < endTime) // Make a bid with an infinite maxValuation if some ETH was sent.
279             submitBid(INFINITY, TAIL);
280         else if (msg.value == 0 && finalized)                    // Else, redeem all the non redeemed bids if no ETH was sent.
281             for (uint i = 0; i < contributorBidIDs[msg.sender].length; ++i)
282             {
283                 if (!bids[contributorBidIDs[msg.sender][i]].redeemed)
284                     redeem(contributorBidIDs[msg.sender][i]);
285             }
286         else                                                     // Otherwise, no actions are possible.
287             revert();
288     }
289 
290     /* *** View Functions *** */
291 
292     /** @dev Search for the correct insertion spot of a bid.
293      *  This function is O(n), where n is the amount of bids between the initial search position and the insertion position.
294      *  @param _maxValuation The maximum valuation given by the contributor. Or INFINITY if no maximum valuation is given.
295      *  @param _nextStart The bidID of the next bid from the initial position to start the search from.
296      *  @return nextInsert The bidID of the next bid from the position the bid must be inserted at.
297      */
298     function search(uint _maxValuation, uint _nextStart) view public returns(uint nextInsert) {
299         uint next = _nextStart;
300         bool found;
301 
302         while(!found) { // While we aren't at the insertion point.
303             Bid storage nextBid = bids[next];
304             uint prev = nextBid.prev;
305             Bid storage prevBid = bids[prev];
306 
307             if (_maxValuation < prevBid.maxValuation)       // It should be inserted before.
308                 next = prev;
309             else if (_maxValuation >= nextBid.maxValuation) // It should be inserted after. The second value we sort by is bidID. Those are increasing, thus if the next bid is of the same maxValuation, we should insert after it.
310                 next = nextBid.next;
311             else                                // We found the insertion point.
312                 found = true;
313         }
314 
315         return next;
316     }
317 
318     /** @dev Return the current bonus. The bonus only changes in 1/BONUS_DIVISOR increments.
319      *  @return b The bonus expressed in 1/BONUS_DIVISOR. Will be normalized by BONUS_DIVISOR. For example for a 20% bonus, _maxBonus must be 0.2 * BONUS_DIVISOR.
320      */
321     function bonus() public view returns(uint b) {
322         if (now < endFullBonusTime) // Full bonus.
323             return maxBonus;
324         else if (now > endTime)     // Assume no bonus after end.
325             return 0;
326         else                        // Compute the bonus decreasing linearly from endFullBonusTime to endTime.
327             return (maxBonus * (endTime - now)) / (endTime - endFullBonusTime);
328     }
329 
330     /** @dev Get the total contribution of an address.
331      *  This can be used for a KYC threshold.
332      *  This function is O(n) where n is the amount of bids made by the contributor.
333      *  This means that the contributor can make totalContrib(contributor) revert due to an out of gas error on purpose.
334      *  @param _contributor The contributor whose contribution will be returned.
335      *  @return contribution The total contribution of the contributor.
336      */
337     function totalContrib(address _contributor) public view returns (uint contribution) {
338         for (uint i = 0; i < contributorBidIDs[_contributor].length; ++i)
339             contribution += bids[contributorBidIDs[_contributor][i]].contrib;
340     }
341 
342     /* *** Interface Views *** */
343 
344     /** @dev Get the current valuation and cut off bid's details.
345      *  This function is O(n), where n is the amount of bids. This could exceed the gas limit, therefore this function should only be used for interface display and not by other contracts.
346      *  @return The current valuation and cut off bid's details.
347      */
348     function valuationAndCutOff() public view returns (uint valuation, uint virtualValuation, uint currentCutOffBidID, uint currentCutOffBidmaxValuation, uint currentCutOffBidContrib) {
349         currentCutOffBidID = bids[TAIL].prev;
350 
351         // Loop over all bids or until cut off bid is found
352         while (currentCutOffBidID != HEAD) {
353             Bid storage bid = bids[currentCutOffBidID];
354             if (bid.contrib + valuation < bid.maxValuation) { // We haven't found the cut-off yet.
355                 valuation += bid.contrib;
356                 virtualValuation += bid.contrib + (bid.contrib * bid.bonus) / BONUS_DIVISOR;
357                 currentCutOffBidID = bid.prev; // Go to the previous bid.
358             } else { // We found the cut-off bid. This bid will be taken partially.
359                 currentCutOffBidContrib = bid.maxValuation >= valuation ? bid.maxValuation - valuation : 0; // The amount of the contribution of the cut-off bid that can stay in the sale without spilling over the maxValuation.
360                 valuation += currentCutOffBidContrib;
361                 virtualValuation += currentCutOffBidContrib + (currentCutOffBidContrib * bid.bonus) / BONUS_DIVISOR;
362                 break;
363             }
364         }
365 
366         currentCutOffBidmaxValuation = bids[currentCutOffBidID].maxValuation;
367     }
368 }
369 
370 /** @title Level Whitelisted Interactive Coin Offering
371  *  This contract implements an Interactive Coin Offering with two whitelists:
372  *  - The base one, with limited contribution.
373  *  - The reinforced one, with unlimited contribution.
374  */
375 contract LevelWhitelistedIICO is IICO {
376     
377     uint public maximumBaseContribution;
378     mapping (address => bool) public baseWhitelist; // True if in the base whitelist (has a contribution limit).
379     mapping (address => bool) public reinforcedWhitelist; // True if in the reinforced whitelist (does not have a contribution limit).
380     address public whitelister; // The party which can add or remove people from the whitelist.
381     
382     modifier onlyWhitelister{ require(whitelister == msg.sender); _; }
383     
384     /** @dev Constructor. First contract set up (tokens will also need to be transferred to the contract and then setToken needs to be called to finish the setup).
385      *  @param _startTime Time the sale will start in seconds since the Unix Epoch.
386      *  @param _fullBonusLength Amount of seconds the sale lasts in the full bonus period.
387      *  @param _partialWithdrawalLength Amount of seconds the sale lasts in the partial withdrawal period.
388      *  @param _withdrawalLockUpLength Amount of seconds the sale lasts in the withdrawal lockup period.
389      *  @param _maxBonus The maximum bonus. Will be normalized by BONUS_DIVISOR. For example for a 20% bonus, _maxBonus must be 0.2 * BONUS_DIVISOR.
390      *  @param _beneficiary The party which will get the funds of the token sale.
391      *  @param _maximumBaseContribution The maximum contribution for buyers on the base list.
392      */
393     function LevelWhitelistedIICO(uint _startTime, uint _fullBonusLength, uint _partialWithdrawalLength, uint _withdrawalLockUpLength, uint _maxBonus, address _beneficiary, uint _maximumBaseContribution) IICO(_startTime,_fullBonusLength,_partialWithdrawalLength,_withdrawalLockUpLength,_maxBonus,_beneficiary) public {
394         maximumBaseContribution=_maximumBaseContribution;
395     }
396     
397     /** @dev Submit a bid. The caller must give the exact position the bid must be inserted into in the list.
398      *  In practice, use searchAndBid to avoid the position being incorrect due to a new bid being inserted and changing the position the bid must be inserted at.
399      *  @param _maxValuation The maximum valuation given by the contributor. If the amount raised is higher, the bid is cancelled and the contributor refunded because it prefers a refund instead of this level of dilution. To buy no matter what, use INFINITY.
400      *  @param _next The bidID of the next bid in the list.
401      */
402     function submitBid(uint _maxValuation, uint _next) public payable {
403         require(reinforcedWhitelist[msg.sender] || (baseWhitelist[msg.sender] && (msg.value + totalContrib(msg.sender) <= maximumBaseContribution))); // Check if the buyer is in the reinforced whitelist or if it is on the base one and this would not make its total contribution exceed the limit.
404         super.submitBid(_maxValuation,_next);
405     }
406     
407     /** @dev Set the whitelister.
408      *  @param _whitelister The whitelister.
409      */
410     function setWhitelister(address _whitelister) public onlyOwner {
411         whitelister=_whitelister;
412     }
413     
414     /** @dev Add buyers to the base whitelist.
415      *  @param _buyersToWhitelist Buyers to add to the whitelist.
416      */
417     function addBaseWhitelist(address[] _buyersToWhitelist) public onlyWhitelister {
418         for(uint i=0;i<_buyersToWhitelist.length;++i)
419             baseWhitelist[_buyersToWhitelist[i]]=true;
420     }
421     
422     /** @dev Add buyers to the reinforced whitelist.
423      *  @param _buyersToWhitelist Buyers to add to the whitelist.
424      */
425     function addReinforcedWhitelist(address[] _buyersToWhitelist) public onlyWhitelister {
426         for(uint i=0;i<_buyersToWhitelist.length;++i)
427             reinforcedWhitelist[_buyersToWhitelist[i]]=true;
428     }
429     
430     /** @dev Remove buyers from the base whitelist.
431      *  @param _buyersToRemove Buyers to remove from the whitelist.
432      */
433     function removeBaseWhitelist(address[] _buyersToRemove) public onlyWhitelister {
434         for(uint i=0;i<_buyersToRemove.length;++i)
435             baseWhitelist[_buyersToRemove[i]]=false;
436     }
437     
438     /** @dev Remove buyers from the reinforced whitelist.
439      *  @param _buyersToRemove Buyers to remove from the whitelist.
440      */
441     function removeReinforcedWhitelist(address[] _buyersToRemove) public onlyWhitelister {
442         for(uint i=0;i<_buyersToRemove.length;++i)
443             reinforcedWhitelist[_buyersToRemove[i]]=false;
444     }
445 
446 }