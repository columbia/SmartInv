1 pragma solidity ^0.4.13;
2 
3 contract OracleInterface {
4     struct PriceData {
5         uint ARTTokenPrice;
6         uint blockHeight;
7     }
8 
9     mapping(uint => PriceData) public historicPricing;
10     uint public index;
11     address public owner;
12     uint8 public decimals;
13 
14     function setPrice(uint price) public returns (uint _index) {}
15 
16     function getPrice() public view returns (uint price, uint _index, uint blockHeight) {}
17 
18     function getHistoricalPrice(uint _index) public view returns (uint price, uint blockHeight) {}
19 
20     event Updated(uint indexed price, uint indexed index);
21 }
22 
23 contract ERC20Basic {
24   function totalSupply() public view returns (uint256);
25   function balanceOf(address who) public view returns (uint256);
26   function transfer(address to, uint256 value) public returns (bool);
27   event Transfer(address indexed from, address indexed to, uint256 value);
28 }
29 
30 contract ERC20Interface is ERC20Basic {
31     uint8 public decimals;
32 }
33 
34 contract HasNoTokens {
35 
36  /**
37   * @dev Reject all ERC223 compatible tokens
38   * @param from_ address The address that is transferring the tokens
39   * @param value_ uint256 the amount of the specified token
40   * @param data_ Bytes The data passed from the caller.
41   */
42   function tokenFallback(address from_, uint256 value_, bytes data_) external {
43     from_;
44     value_;
45     data_;
46     revert();
47   }
48 
49 }
50 
51 contract Ownable {
52   address public owner;
53 
54 
55   event OwnershipRenounced(address indexed previousOwner);
56   event OwnershipTransferred(
57     address indexed previousOwner,
58     address indexed newOwner
59   );
60 
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   constructor() public {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to relinquish control of the contract.
80    */
81   function renounceOwnership() public onlyOwner {
82     emit OwnershipRenounced(owner);
83     owner = address(0);
84   }
85 
86   /**
87    * @dev Allows the current owner to transfer control of the contract to a newOwner.
88    * @param _newOwner The address to transfer ownership to.
89    */
90   function transferOwnership(address _newOwner) public onlyOwner {
91     _transferOwnership(_newOwner);
92   }
93 
94   /**
95    * @dev Transfers control of the contract to a newOwner.
96    * @param _newOwner The address to transfer ownership to.
97    */
98   function _transferOwnership(address _newOwner) internal {
99     require(_newOwner != address(0));
100     emit OwnershipTransferred(owner, _newOwner);
101     owner = _newOwner;
102   }
103 }
104 
105 contract HasNoEther is Ownable {
106 
107   /**
108   * @dev Constructor that rejects incoming Ether
109   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
110   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
111   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
112   * we could use assembly to access msg.value.
113   */
114   constructor() public payable {
115     require(msg.value == 0);
116   }
117 
118   /**
119    * @dev Disallows direct send by settings a default function without the `payable` flag.
120    */
121   function() external {
122   }
123 
124   /**
125    * @dev Transfer all Ether held by the contract to the owner.
126    */
127   function reclaimEther() external onlyOwner {
128     owner.transfer(address(this).balance);
129   }
130 }
131 
132 contract DutchAuction is Ownable, HasNoEther, HasNoTokens {
133 
134     using SafeMath for uint256;
135 
136     /// @notice Auction Data
137     uint public min_shares_to_sell;
138     uint public max_shares_to_sell;
139     uint public min_share_price;
140     uint public available_shares;
141 
142     bool private fundraise_defined;
143     uint public fundraise_max;
144 
145     /// @notice Auction status
146     state public status = state.pending;
147     enum state { pending, active, ended, decrypted, success, failure }
148 
149     /// @notice Events
150     event Started(uint block_number);
151     event BidAdded(uint index);
152     event Ended(uint block_number);
153     event BidDecrypted(uint index, bool it_will_process);
154     event FundraiseDefined(uint min_share_price, uint max);
155     event BidBurned(uint index);
156     event Decrypted(uint blocknumber, uint bids_decrypted, uint bids_burned);
157     event Computed(uint index, uint share_price, uint shares_count);
158     event Assigned(uint index, uint shares, uint executed_amout, uint refunded);
159     event Refunded(uint index, uint refunded);
160     event Success(uint raised, uint share_price, uint delivered_shares);
161     event Failure(uint raised, uint share_price);
162 
163     event Execution(address destination,uint value,bytes data);
164     event ExecutionFailure(address destination,uint value,bytes data);
165 
166     /// @notice Token assignment data
167     uint public final_share_price;
168     uint public computed_fundraise;
169     uint public final_fundraise;
170     uint public computed_shares_sold;
171     uint public final_shares_sold;
172     uint public winner_bids;
173     uint public assigned_bids;
174     uint public assigned_shares;
175 
176     /// @notice Bidding data
177     struct BidData {
178         uint origin_index;
179         uint bid_id;
180         address investor_address;
181         uint share_price;
182         uint shares_count;
183         uint transfer_valuation;
184         uint transfer_token;
185         uint asigned_shares_count;
186         uint executed_amount;
187         bool closed;
188     }
189     uint public bids_sorted_count;
190     uint public bids_sorted_refunded;
191     mapping (uint => BidData) public bids_sorted; //Is sorted
192 
193     uint public bids_burned_count;
194     mapping (uint => uint) public bids_burned;
195 
196     uint public bids_ignored_count;
197     uint public bids_ignored_refunded;
198     mapping (uint => BidData) public bids_ignored;
199 
200 
201     uint public bids_decrypted_count;
202     mapping (uint => uint) public bids_decrypted;
203     uint private bids_reset_count;
204 
205     struct Bid {
206         // https://ethereum.stackexchange.com/questions/3184/what-is-the-cheapest-hash-function-available-in-solidity#3200
207         bytes32 bid_hash;
208         uint art_price;
209         uint art_price_index;
210         bool exist;
211         bool is_decrypted;
212         bool is_burned;
213         bool will_compute;
214     }
215     uint public bids_count;
216     mapping (uint => Bid) public bids;
217 
218     uint public bids_computed_cursor;
219 
220     uint public shares_holders_count;
221     mapping (uint => address) public shares_holders;
222     mapping (address => uint) public shares_holders_balance;
223 
224     /// @notice External dependencies
225 
226     OracleInterface oracle;
227     uint public oracle_price_decimals_factor;
228     ERC20Interface art_token_contract;
229     uint public decimal_precission_difference_factor;
230 
231     /// @notice Set up the dutch auction
232     /// @param _min_shares_to_sell The minimum amount of asset shares to be sold
233     /// @param _max_shares_to_sell The maximum amount of asset shares to be sold
234     /// @param _available_shares The total share amount the asset will be divided into
235     /// @param _oracle Address of the ART/USD price oracle contract
236     /// @param _art_token_contract Address of the ART token contract
237     constructor(
238         uint _min_shares_to_sell,
239         uint _max_shares_to_sell,
240         uint _available_shares,
241         address _oracle,
242         address _art_token_contract
243     ) public {
244         require(_max_shares_to_sell > 0);
245         require(_max_shares_to_sell >= _min_shares_to_sell);
246         require(_available_shares >= _max_shares_to_sell);
247         require(_oracle != address(0x0));
248         owner = msg.sender;
249         min_shares_to_sell = _min_shares_to_sell;
250         max_shares_to_sell = _max_shares_to_sell;
251         available_shares = _available_shares;
252         oracle = OracleInterface(_oracle);
253         uint256 oracle_decimals = uint256(oracle.decimals());
254         oracle_price_decimals_factor = 10**oracle_decimals;
255         art_token_contract = ERC20Interface(_art_token_contract);
256         uint256 art_token_decimals = uint256(art_token_contract.decimals());
257         decimal_precission_difference_factor = 10**(art_token_decimals.sub(oracle_decimals));
258     }
259 
260     /// @notice Allows configuration of the final parameters needed for
261     /// auction end state calculation. This is only allowed once the auction
262     /// has closed and no more bids can enter
263     /// @param _min_share_price Minimum price accepted for individual asset shares
264     /// @param _fundraise_max Maximum cap for fundraised capital
265     function setFundraiseLimits(uint _min_share_price, uint _fundraise_max) public onlyOwner{
266         require(!fundraise_defined);
267         require(_min_share_price > 0);
268         require(_fundraise_max > 0);
269         require(status == state.ended);
270         fundraise_max = _fundraise_max;
271         min_share_price = _min_share_price;
272         emit FundraiseDefined(min_share_price,fundraise_max);
273         fundraise_defined = true;
274     }
275 
276     /// @notice Starts the auction
277     function startAuction() public onlyOwner{
278         require(status == state.pending);
279         status = state.active;
280         emit Started(block.number);
281     }
282 
283     /// @notice Ends the auction, preventing new bids from entering
284     function endAuction() public onlyOwner{
285         require(status == state.active);
286         status = state.ended;
287         emit Ended(block.number);
288     }
289 
290     /// @notice Append an encrypted bid to the auction. This allows the contract
291     /// to keep a count on how many bids it has, while staying ignorant of the 
292     /// bid contents.
293     function appendEncryptedBid(bytes32 _bid_hash, uint price_index) public onlyOwner returns (uint index){
294         require(status == state.active);
295         uint art_price;
296         uint art_price_blockHeight;
297         (art_price, art_price_blockHeight) = oracle.getHistoricalPrice(price_index);
298         bids[bids_count] = Bid(_bid_hash, art_price, price_index, true, false, false, false);
299         index = bids_count;
300         emit BidAdded(bids_count++);
301     }
302 
303     /// @notice Helper function for calculating a bid's hash.
304     function getBidHash(uint nonce, uint bid_id, address investor_address, uint share_price, uint shares_count) public pure returns(bytes32) {
305         return keccak256(abi.encodePacked(nonce, bid_id, investor_address, share_price, shares_count));
306     }
307 
308     /// @notice Allows the "burning" of a bid, for cases in which a bid was corrupted and can't be decrypted.
309     /// "Burnt" bids do not participate in the final calculations for auction participants
310     /// @param _index Indicates the index of the bid to be burnt
311     function burnBid(uint _index) public onlyOwner {
312         require(status == state.ended);
313         require(bids_sorted_count == 0);
314         require(bids[_index].exist == true);
315         require(bids[_index].is_decrypted == false);
316         require(bids[_index].is_burned == false);
317         
318         bids_burned[bids_burned_count] = _index;
319         bids_burned_count++;
320         
321         bids_decrypted[bids_decrypted_count] = _index;
322         bids_decrypted_count++;
323 
324         bids[_index].is_burned = true;
325         emit BidBurned(_index);
326     }
327 
328     /// @notice Appends the bid's data to the contract, for use in the final calculations
329     /// Once all bids are appended, the auction is locked and changes its state to "decrypted"
330     /// @dev Bids MUST be appended in order of asset valuation,
331     /// since the contract relies on off-chain sorting and checks if the order is correct
332     /// @param _nonce Bid parameter
333     /// @param _index Bid's index inside the contract
334     /// @param _bid_id Bid parameter
335     /// @param _investor_address Bid parameter - address of the bid's originator
336     /// @param _share_price Bid parameter - estimated value of the asset's share price
337     /// @param _shares_count Bid parameter - amount of shares bid for
338     /// @param _transfered_token Bid parameter - amount of ART tokens sent with the bid
339     function appendDecryptedBid(uint _nonce, uint _index, uint _bid_id, address _investor_address, uint _share_price, uint _shares_count, uint _transfered_token) onlyOwner public {
340         require(status == state.ended);
341         require(fundraise_defined);
342         require(bids[_index].exist == true);
343         require(bids[_index].is_decrypted == false);
344         require(bids[_index].is_burned == false);
345         require(_share_price > 0);
346         require(_shares_count > 0);
347         require(_transfered_token >= convert_valuation_to_art(_shares_count.mul(_share_price),bids[_index].art_price));
348         
349         if (bids_sorted_count > 0){
350             BidData memory previous_bid_data = bids_sorted[bids_sorted_count-1];
351             require(_share_price <= previous_bid_data.share_price);
352             if (_share_price == previous_bid_data.share_price){
353                 require(_index > previous_bid_data.origin_index);
354             }
355         }
356         
357         require(
358             getBidHash(_nonce, _bid_id,_investor_address,_share_price,_shares_count) == bids[_index].bid_hash
359         );
360         
361         uint _transfer_amount = _share_price.mul(_shares_count);
362         
363         BidData memory bid_data = BidData(_index, _bid_id, _investor_address, _share_price, _shares_count, _transfer_amount, _transfered_token, 0, 0, false);
364         bids[_index].is_decrypted = true;
365         
366         if (_share_price >= min_share_price){
367             bids[_index].will_compute = true;
368             bids_sorted[bids_sorted_count] = bid_data;
369             bids_sorted_count++;
370             emit BidDecrypted(_index,true);
371         }else{
372             bids[_index].will_compute = false;
373             bids_ignored[bids_ignored_count] = bid_data;
374             bids_ignored_count++;
375             emit BidDecrypted(_index,false);
376         }
377         bids_decrypted[bids_decrypted_count] = _index;
378         bids_decrypted_count++;
379         if(bids_decrypted_count == bids_count){
380             emit Decrypted(block.number, bids_decrypted_count.sub(bids_burned_count), bids_burned_count);
381             status = state.decrypted;
382         }
383     }
384 
385     /// @notice Allows appending multiple decrypted bids (in order) at once.
386     /// @dev Parameters are the same as appendDecryptedBid but in array format.
387     function appendDecryptedBids(uint[] _nonce, uint[] _index, uint[] _bid_id, address[] _investor_address, uint[] _share_price, uint[] _shares_count, uint[] _transfered_token) public onlyOwner {
388         require(_nonce.length == _index.length);
389         require(_index.length == _bid_id.length);
390         require(_bid_id.length == _investor_address.length);
391         require(_investor_address.length == _share_price.length);
392         require(_share_price.length == _shares_count.length);
393         require(_shares_count.length == _transfered_token.length);
394         require(bids_count.sub(bids_decrypted_count) > 0);
395         for (uint i = 0; i < _index.length; i++){
396             appendDecryptedBid(_nonce[i], _index[i], _bid_id[i], _investor_address[i], _share_price[i], _shares_count[i], _transfered_token[i]);
397         }
398     }
399 
400     /// @notice Allows resetting the entire bid decryption/appending process
401     /// in case a mistake was made and it is not possible to continue appending further bids.
402     function resetAppendDecryptedBids(uint _count) public onlyOwner{
403         require(status == state.ended);
404         require(bids_decrypted_count > 0);
405         require(_count > 0);
406         if (bids_reset_count == 0){
407             bids_reset_count = bids_decrypted_count;
408         }
409         uint count = _count;
410         if(bids_reset_count < count){
411             count = bids_reset_count;
412         }
413 
414         do {
415             bids_reset_count--;
416             bids[bids_decrypted[bids_reset_count]].is_decrypted = false;
417             bids[bids_decrypted[bids_reset_count]].is_burned = false;
418             bids[bids_decrypted[bids_reset_count]].will_compute = false;
419             count--;
420         } while(count > 0);
421         
422         if (bids_reset_count == 0){
423             bids_sorted_count = 0;
424             bids_ignored_count = 0;
425             bids_decrypted_count = 0;
426             bids_burned_count = 0;
427         }
428     }
429 
430     /// @notice Performs the computation of auction winners and losers.
431     /// Also, determines if the auction is successful or failed.
432     /// Bids which place the asset valuation below the minimum fundraise cap
433     /// as well as bids below the final valuation are marked as ignored or "loser" respectively
434     /// and do not count towards the process.
435     /// @dev Since this function is resource intensive, computation is done in batches
436     /// of `_count` bids, so as to not encounter an OutOfGas exception in the middle
437     /// of the process.
438     /// @param _count Amount of bids to be processed in this run.
439     function computeBids(uint _count) public onlyOwner{
440         require(status == state.decrypted);
441         require(_count > 0);
442         uint count = _count;
443         // No bids
444         if (bids_sorted_count == 0){
445             status = state.failure;
446             emit Failure(0, 0);
447             return;
448         }
449         //bids_computed_cursor: How many bid already processed
450         //bids_sorted_count: How many bids can compunte
451         require(bids_computed_cursor < bids_sorted_count);
452         
453         //bid: Auxiliary variable
454         BidData memory bid;
455 
456         do{
457             //bid: Current bid to compute
458             bid = bids_sorted[bids_computed_cursor];
459             //if only one share of current bid leave us out of fundraise limitis, ignore the bid
460             //computed_shares_sold: Sumarize shares sold
461             if (bid.share_price.mul(computed_shares_sold).add(bid.share_price) > fundraise_max){
462                 if(bids_computed_cursor > 0){
463                     bids_computed_cursor--;
464                 }
465                 bid = bids_sorted[bids_computed_cursor];
466                 break;
467             }
468             //computed_shares_sold: Sumarize cumpued shares
469             computed_shares_sold = computed_shares_sold.add(bid.shares_count);
470             //computed_fundraise: Sumarize fundraise
471             computed_fundraise = bid.share_price.mul(computed_shares_sold);
472             emit Computed(bid.origin_index, bid.share_price, bid.shares_count);
473             //Next bid
474             bids_computed_cursor++;
475             count--;
476         }while(
477             count > 0 && //We have limite to compute
478             bids_computed_cursor < bids_sorted_count && //We have more bids to compute 
479             (
480                 computed_fundraise < fundraise_max && //Fundraise is more or equal to max
481                 computed_shares_sold < max_shares_to_sell //Assigned shares are more or equal to max
482             )
483         );
484 
485         if (
486             bids_computed_cursor == bids_sorted_count ||  //All bids computed
487             computed_fundraise >= fundraise_max ||//Fundraise is more or equal to max
488             computed_shares_sold >= max_shares_to_sell//Max shares raised
489         ){
490             
491             final_share_price = bid.share_price;
492             
493             //More than max shares
494             if(computed_shares_sold >= max_shares_to_sell){
495                 computed_shares_sold = max_shares_to_sell;//Limit shares
496                 computed_fundraise = final_share_price.mul(computed_shares_sold);
497                 winner_bids = bids_computed_cursor;
498                 status = state.success;
499                 emit Success(computed_fundraise, final_share_price, computed_shares_sold);
500                 return;            
501             }
502 
503             //Max fundraise is raised
504             if(computed_fundraise.add(final_share_price.mul(1)) >= fundraise_max){//More than max fundraise
505                 computed_fundraise = fundraise_max;//Limit fundraise
506                 winner_bids = bids_computed_cursor;
507                 status = state.success;
508                 emit Success(computed_fundraise, final_share_price, computed_shares_sold);
509                 return;
510             }
511             
512             //All bids computed
513             if (bids_computed_cursor == bids_sorted_count){
514                 if (computed_shares_sold >= min_shares_to_sell){
515                     winner_bids = bids_computed_cursor;
516                     status = state.success;
517                     emit Success(computed_fundraise, final_share_price, computed_shares_sold);
518                     return;
519                 }else{
520                     status = state.failure;
521                     emit Failure(computed_fundraise, final_share_price);
522                     return;
523                 }
524             }
525         }
526     }
527 
528     /// @notice Helper function that calculates the valuation of the asset
529     /// in terms of an ART token quantity.
530     function convert_valuation_to_art(uint _valuation, uint _art_price) view public returns(uint amount){
531         amount = ((
532                 _valuation.mul(oracle_price_decimals_factor)
533             ).div(
534                 _art_price
535             )).mul(decimal_precission_difference_factor);
536     }
537 
538     /// @notice Performs the refund of the ignored bids ART tokens
539     /// @dev Since this function is resource intensive, computation is done in batches
540     /// of `_count` bids, so as to not encounter an OutOfGas exception in the middle
541     /// of the process.
542     /// @param _count Amount of bids to be processed in this run.
543     function refundIgnoredBids(uint _count) public onlyOwner{
544         require(status == state.success || status == state.failure);
545         uint count = _count;
546         if(bids_ignored_count < bids_ignored_refunded.add(count)){
547             count = bids_ignored_count.sub(bids_ignored_refunded);
548         }
549         require(count > 0);
550         uint cursor = bids_ignored_refunded;
551         bids_ignored_refunded = bids_ignored_refunded.add(count);
552         BidData storage bid;
553         while (count > 0) {
554             bid = bids_ignored[cursor];
555             if(bid.closed){
556                 continue;
557             }
558             bid.closed = true;
559             art_token_contract.transfer(bid.investor_address, bid.transfer_token);
560             emit Refunded(bid.origin_index, bid.transfer_token);
561             cursor ++;
562             count --;
563         }
564     }
565 
566     /// @notice Performs the refund of the "loser" bids ART tokens
567     /// @dev Since this function is resource intensive, computation is done in batches
568     /// of `_count` bids, so as to not encounter an OutOfGas exception in the middle
569     /// of the process.
570     /// @param _count Amount of bids to be processed in this run.
571     function refundLosersBids(uint _count) public onlyOwner{
572         require(status == state.success || status == state.failure);
573         uint count = _count;
574         if(bids_sorted_count.sub(winner_bids) < bids_sorted_refunded.add(count)){
575             count = bids_sorted_count.sub(winner_bids).sub(bids_sorted_refunded);
576         }
577         require(count > 0);
578         uint cursor = bids_sorted_refunded.add(winner_bids);
579         bids_sorted_refunded = bids_sorted_refunded.add(count);
580         BidData memory bid;
581         while (count > 0) {
582             bid = bids_sorted[cursor];
583             if(bid.closed){
584                 continue;
585             }
586             bids_sorted[cursor].closed = true;
587             art_token_contract.transfer(bid.investor_address, bid.transfer_token);
588             emit Refunded(bid.origin_index, bid.transfer_token);
589             cursor ++;
590             count --;
591         }
592     }
593 
594     /// @notice Calculates how many shares are assigned to a bid.
595     /// @param _shares_count Amount of shares bid for.
596     /// @param _transfer_valuation Unused parameter
597     /// @param _final_share_price Final share price calculated from all winning bids
598     /// @param _art_price Price of the ART token
599     /// @param transfer_token Amount of ART tokens transferred with the bid
600     function calculate_shares_and_return(uint _shares_count, uint _share_price, uint _transfer_valuation, uint _final_share_price, uint _art_price, uint transfer_token) view public 
601         returns(
602             uint _shares_to_assign,
603             uint _executed_amount_valuation,
604             uint _return_amount
605         ){
606         if(assigned_shares.add(_shares_count) > max_shares_to_sell){
607             _shares_to_assign = max_shares_to_sell.sub(assigned_shares);
608         }else{
609             _shares_to_assign = _shares_count;
610         }
611         _executed_amount_valuation = _shares_to_assign.mul(_final_share_price);
612         if (final_fundraise.add(_executed_amount_valuation) > fundraise_max){
613             _executed_amount_valuation = fundraise_max.sub(final_fundraise);
614             _shares_to_assign = _executed_amount_valuation.div(_final_share_price);
615             _executed_amount_valuation = _shares_to_assign.mul(_final_share_price);
616         }
617         uint _executed_amount = convert_valuation_to_art(_executed_amount_valuation, _art_price);
618         _return_amount = transfer_token.sub(_executed_amount);
619     }
620 
621 
622     /// @notice Assign the asset share tokens to winner bid's authors
623     /// @dev Since this function is resource intensive, computation is done in batches
624     /// of `_count` bids, so as to not encounter an OutOfGas exception in the middle
625     /// of the process.
626     /// @param _count Amount of bids to be processed in this run.
627     function assignShareTokens(uint _count) public onlyOwner{
628         require(status == state.success);
629         uint count = _count;
630         if(winner_bids < assigned_bids.add(count)){
631             count = winner_bids.sub(assigned_bids);
632         }
633         require(count > 0);
634         uint cursor = assigned_bids;
635         assigned_bids = assigned_bids.add(count);
636         BidData storage bid;
637 
638         while (count > 0) {
639             bid = bids_sorted[cursor];
640             uint _shares_to_assign;
641             uint _executed_amount_valuation;
642             uint _return_amount;
643             (_shares_to_assign, _executed_amount_valuation, _return_amount) = calculate_shares_and_return(
644                 bid.shares_count,
645                 bid.share_price,
646                 bid.transfer_valuation,
647                 final_share_price,
648                 bids[bid.origin_index].art_price,
649                 bid.transfer_token
650             );
651             bid.executed_amount = _executed_amount_valuation;
652             bid.asigned_shares_count = _shares_to_assign;
653             assigned_shares = assigned_shares.add(_shares_to_assign);
654             final_fundraise = final_fundraise.add(_executed_amount_valuation);
655             final_shares_sold = final_shares_sold.add(_shares_to_assign);
656             if(_return_amount > 0){
657                 art_token_contract.transfer(bid.investor_address, _return_amount);
658             }
659             bid.closed = true;
660             if (shares_holders_balance[bid.investor_address] == 0){
661                 shares_holders[shares_holders_count++] = bid.investor_address;
662             }
663             emit Assigned(bid.origin_index,_shares_to_assign, _executed_amount_valuation, _return_amount);
664             shares_holders_balance[bid.investor_address] = shares_holders_balance[bid.investor_address].add(_shares_to_assign);
665             cursor ++;
666             count --;
667         }
668     }
669 
670     /**
671     * @dev Return share balance of sender
672     * @return uint256 share_balance
673     */
674     function getShareBalance() view public returns (uint256 share_balance){
675         require(status == state.success);
676         require(winner_bids == assigned_bids);
677         share_balance = shares_holders_balance[msg.sender];
678     }
679 
680     /**
681     * @dev Reclaim all (Except ART) ERC20Basic compatible tokens
682     * @param token ERC20Basic The address of the token contract
683     */
684     function reclaimToken(ERC20Basic token) external onlyOwner {
685         require(token != art_token_contract);
686         uint256 balance = token.balanceOf(this);
687         token.transfer(owner, balance);
688     }
689 
690     function reclaim_art_token() external onlyOwner {
691         require(status == state.success || status == state.failure);
692         require(winner_bids == assigned_bids);
693         uint256 balance = art_token_contract.balanceOf(this);
694         art_token_contract.transfer(owner, balance); 
695     }
696 
697     /// @notice Proxy function which allows sending of transactions
698     /// in behalf of the contract
699     function executeTransaction(
700         address destination,
701         uint value,
702         bytes data
703     )
704         public
705         onlyOwner
706     {
707         if (destination.call.value(value)(data))
708             emit Execution(destination,value,data);
709         else
710             emit ExecutionFailure(destination,value,data);
711     }
712 }
713 
714 library SafeMath {
715 
716   /**
717   * @dev Multiplies two numbers, throws on overflow.
718   */
719   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
720     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
721     // benefit is lost if 'b' is also tested.
722     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
723     if (a == 0) {
724       return 0;
725     }
726 
727     c = a * b;
728     assert(c / a == b);
729     return c;
730   }
731 
732   /**
733   * @dev Integer division of two numbers, truncating the quotient.
734   */
735   function div(uint256 a, uint256 b) internal pure returns (uint256) {
736     // assert(b > 0); // Solidity automatically throws when dividing by 0
737     // uint256 c = a / b;
738     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
739     return a / b;
740   }
741 
742   /**
743   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
744   */
745   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
746     assert(b <= a);
747     return a - b;
748   }
749 
750   /**
751   * @dev Adds two numbers, throws on overflow.
752   */
753   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
754     c = a + b;
755     assert(c >= a);
756     return c;
757   }
758 }