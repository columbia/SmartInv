1 pragma solidity ^0.4.8;
2 
3 contract OldSmartRouletteToken
4 {
5 	function balanceOf( address who ) external constant returns (uint256);
6 	function totalSupply() constant returns (uint supply);
7 	function tempTokensBalanceOf( address who ) external constant returns (uint256);
8 	function tempTokensPeriodOf( address who ) external constant returns (uint256);
9 	function getCountHolders() external constant returns(uint256);
10 	function getCountTempHolders() external constant returns(uint256);
11 	function getItemHolders(uint256 index) external constant returns(address);
12 	function getItemTempHolders(uint256 index) external constant returns(address);
13 	function isOperationBlocked() external constant returns (bool);
14 }
15 
16 contract SmartRouletteToken {
17 	string public standard = 'ERC20';
18     string public name; // token name
19     string public symbol; // token symbol
20     uint8 public decimals; // a number of symbols after comma
21 
22 	struct holderData {
23 		/**
24 		*	Token holders details
25 		*/
26 		uint256 tokens_count;
27 		bool init;
28 	}
29 
30 	struct tempHolderData {
31 		/**
32 		*	Temporary token holders details
33 		*/
34 		uint256 tokens_count;
35 		uint256 start_date;
36 		uint256 end_date;
37 		bool init;
38 	}
39 
40 	address[] listAddrHolders; // permanent token holders list
41 
42 	mapping( address => holderData ) _balances; // token ownership
43 	mapping( address => tempHolderData ) _temp_balance; // temporary token ownership
44 	mapping( address => mapping( address => uint256 ) ) _approvals; // token transfer right
45 
46 	bool stop_operation; // transaction stop
47 	
48 	uint256 _supply; // total amount of tokens
49 	uint256 _init_count_tokens; // initial amount of tokens
50 	uint256 public costOfOneToken; // token price equivalent to wei
51 	
52 	address wallet_ICO;
53 	bool enableICO; // ico status (launched or not)
54 	uint256 min_value_buyToken; //in wei
55 	uint256 max_value_buyToken; //in wei
56 
57 	address fond_wallet;
58 	address developer_wallet;
59 
60 	address divident_contract = address(0x0);
61 	
62 	event TokenBuy(address buyer, uint256 amountOfTokens);
63 
64 	// emission limits
65 	uint256 max_value_bet; // maximum size of bet for emission
66 	uint256 max_coef_player; // maximum size of emission coefficient for a player
67 	uint256 max_coef_partner; // maximum size of emission coefficient for an affiliate
68 
69 
70 	address developer; // developer's address
71 	address manager; // contract managing address (management can be made from the smart contract)
72 
73 	struct gamesData {
74 		bool init;
75 	}
76 
77 	mapping( address => gamesData) listGames; // List of allowed games
78 	address[] addrGames;
79 
80 	//old token contract for data restorage
81 	OldSmartRouletteToken oldSmartToken;
82 
83 	uint256 countHoldersTransferredFromOldContract; //amount of permanent token holders whose balance has been restored
84 	uint256 countHoldersTempTransferredFromOldContract; //amount of temporary token holders whose balance has been restored
85 
86 	function SmartRouletteToken()
87 	{
88 		_init_count_tokens = 100000000000000000;
89 		developer_wallet = address(0x8521E1f9220A251dE0ab78f6a2E8754Ca9E75242);
90 		wallet_ICO = address(0x2dff87f8892d65f7a97b1287e795405098ae7b7f);
91 		fond_wallet = address(0x3501DD2B515EDC1920f9007782Da5ac018922502);
92 
93         name = 'Roulette Token';                                   
94         symbol = 'RLT';                               
95         decimals = 10;
96         costOfOneToken = 1500000000000000;
97 
98 		max_value_bet = 2560000000000000000;
99 		max_coef_player = 300;
100 		max_coef_partner = 50;
101 
102 		developer = msg.sender;
103 		manager = msg.sender;		
104 		
105 		enableICO = false;
106 		min_value_buyToken = 150000000000000000;
107 		max_value_buyToken = 500000000000000000000;
108 
109 		stop_operation = false;
110 
111 		oldSmartToken = OldSmartRouletteToken(0x2a650356bd894370cc1d6aba71b36c0ad6b3dc18);
112 		countHoldersTransferredFromOldContract= 0;
113 		countHoldersTempTransferredFromOldContract = 0;
114 	}
115 
116 	modifier isDeveloper(){
117 		if (msg.sender!=developer) throw;
118 		_;
119 	}
120 
121 	modifier isManager(){
122 		if (msg.sender!=manager) throw;
123 		_;
124 	}
125 
126 	modifier isAccessStopOperation(){
127 		if (msg.sender!=manager && msg.sender!=developer && (msg.sender!=divident_contract || divident_contract==address(0x0))) throw;
128 		_;
129 	}
130 
131 	function IsTransferFromOldContractDone() constant returns(bool)
132 	{
133 		return countHoldersTransferredFromOldContract == oldSmartToken.getCountHolders();
134 	}
135 
136 	/**
137     *	restoreAllPersistentTokens() - function of restoring the balance of permanent token holders. Once the function has been completed,
138     *	blockchain saves the index with which token holders addresses will start being received during the following function operation.
139     *
140     *	@param limit - amount of token holders addresses requiring the balance restorage.
141     *
142     **/
143 	function restoreAllPersistentTokens(uint256 limit)
144 	{
145 		if(oldSmartToken.isOperationBlocked() && this.isOperationBlocked())
146 		{
147 			uint256 len = oldSmartToken.getCountHolders();
148 			uint256 i = countHoldersTransferredFromOldContract;
149 			for(; i < len; i++)
150 			{
151 				address holder = oldSmartToken.getItemHolders(i);
152 				uint256 count_tokens = oldSmartToken.balanceOf(holder);
153 				if(holder == address(0x2a650356bd894370cc1d6aba71b36c0ad6b3dc18)) {
154 					if(!_balances[fond_wallet].init){
155 						addUserToList(fond_wallet);
156 						_balances[fond_wallet] = holderData(count_tokens, true);
157 					}
158 					else{
159 						_balances[fond_wallet].tokens_count += count_tokens;
160 					}
161 				}
162 				else{
163 					addUserToList(holder);
164 					_balances[holder] = holderData(count_tokens, true);
165 				}
166 
167 				_supply += count_tokens;
168 
169 				if (limit - 1 == 0) break;
170 				limit--;
171 			}
172 			countHoldersTransferredFromOldContract = i;
173 		}
174 	}
175 
176 	function IsTransferTempFromOldContractDone() constant returns(bool)
177 	{
178 		return countHoldersTempTransferredFromOldContract == oldSmartToken.getCountTempHolders();
179 	}
180 
181 	/**
182     *	restoreAllTempTokens() - function of temnporary token balance restorage. Once the function has been completed,
183     *	blockchain saves the index with which temporary token holders addresses will start being received during the following function operation.
184     *
185     *	@param limit - amount of token holders addresses requiring the balance restorage.
186     *
187     **/
188 	function restoreAllTempTokens(uint256 limit)
189 	{
190 		if(oldSmartToken.isOperationBlocked() && this.isOperationBlocked())
191 		{
192 			uint256 len = oldSmartToken.getCountTempHolders();
193 			uint256 i = countHoldersTempTransferredFromOldContract;
194 			for(; i < len; i++)
195 			{
196 				address holder = oldSmartToken.getItemTempHolders(i);
197 				uint256 count_tokens = oldSmartToken.tempTokensBalanceOf(holder);
198 
199 				if(holder == address(0x2a650356bd894370cc1d6aba71b36c0ad6b3dc18)) {
200 					if(!_balances[fond_wallet].init){
201 						_balances[fond_wallet] = holderData(count_tokens, true);
202 						addUserToList(fond_wallet);
203 					}
204 					else{
205 						_balances[fond_wallet].tokens_count += count_tokens;
206 					}
207 				}
208 				else{
209 					listAddrTempHolders.push(holder);
210 					uint256 end_date = oldSmartToken.tempTokensPeriodOf(holder);
211 					_temp_balance[holder] = tempHolderData(count_tokens, now, end_date, true);
212 				}
213 
214 				_supply += count_tokens;
215 
216 				if (limit - 1 == 0) break;
217 				limit--;
218 			}
219 			countHoldersTempTransferredFromOldContract = i;
220 		}
221 	}
222 
223 
224 	function changeDeveloper(address new_developer) isDeveloper
225 	{
226 		if(new_developer == address(0x0)) throw;
227 		developer = new_developer;
228 	}
229 
230 	function changeManager(address new_manager) isManager external
231 	{
232 		if(new_manager == address(0x0)) throw;
233 		manager = new_manager;
234 	}
235 
236 	function changeMaxValueBetForEmission(uint256 new_value) isManager external
237 	{
238 		if(new_value == 0) throw;
239 		max_value_bet = new_value;
240 	}
241 
242 	function changeMaxCoefPlayerForEmission(uint256 new_value) isManager external
243 	{
244 		if(new_value > 1000) throw;
245 		max_coef_player = new_value;
246 	}
247 
248 	function changeMaxCoefPartnerForEmission(uint256 new_value) isManager external
249 	{
250 		if(new_value > 1000) throw;
251 		max_coef_partner = new_value;
252 	}
253 
254 	function changeDividentContract(address new_contract) isManager external
255 	{
256 		if(new_contract!=address(0x0)) throw;
257 		divident_contract = new_contract;
258 	}
259 
260 	function newCostToken(uint256 new_cost)	isManager external
261 	{
262 		if(new_cost == 0) throw;
263 		costOfOneToken = new_cost;
264 	}
265 
266 	function getCostToken() external constant returns(uint256)
267 	{
268 		return costOfOneToken;
269 	}
270 
271 	function addNewGame(address new_game) isManager external
272 	{
273 		if(new_game == address(0x0)) throw;
274 		listGames[new_game] = gamesData(true);
275 		addrGames.push(new_game);
276 	}
277 
278 	function deleteGame(address game) isManager external
279 	{
280 		if(game == address(0x0)) throw;
281 		if(listGames[game].init){
282 			listGames[game].init = false;
283 		}
284 	}
285 
286 	function addUserToList(address user) internal {
287 		if(!_balances[user].init){
288 			listAddrHolders.push(user);
289 		}
290 	}
291 
292     function getListAddressHolders() constant returns(address[]){
293         return listAddrHolders;
294     }
295 
296     function getCountHolders() external constant returns(uint256){
297         return listAddrHolders.length;
298     }
299 
300     function getItemHolders(uint256 index) external constant returns(address){
301         if(index >= listAddrHolders.length) return address(0x0);
302         else return listAddrHolders[index];
303     }
304 
305 	function gameListOf( address who ) external constant returns (bool value) {
306 		gamesData game_data = listGames[who];
307 		return game_data.init;
308 	}
309 
310 	//------------------------------------
311 	// Tokens Functions
312 	//------------------------------------
313 	event Transfer(address indexed from, address indexed to, uint256 value);
314     event Approval(address indexed owner, address indexed spender, uint256 value);
315 
316     function stopOperation() isManager external {
317 		stop_operation = true;
318 	}
319 
320 	function startOperation() isManager external {
321 		stop_operation = false;
322 	}
323 
324 	function isOperationBlocked() external constant returns (bool){
325 		return stop_operation;
326 	}
327 
328 	function isOperationAllowed() external constant returns (bool){
329 		return !stop_operation;
330 	}
331 
332 	function runICO() isManager external {
333 		enableICO = true;
334 		stop_operation = true;
335 	}
336 
337 	function stopICO() isManager external {
338 		enableICO = false;
339 		stop_operation = false;
340 	}
341 
342 	function infoICO() constant returns (bool){
343 		return enableICO;
344 	}
345 
346 	function totalSupply() external constant returns (uint256 supply) {
347 		return _supply;
348 	}
349 
350 	function initCountTokens() external constant returns (uint256 init_count) {
351 		return _init_count_tokens;
352 	}
353 
354 	/**
355     *  balanceOf() - constant function check concrete tokens balance
356     *
357     *  @param who - account owner
358     *
359     *  @return the value of balance
360     */
361 	function balanceOf( address who ) external constant returns (uint256 value) {
362 		return _balances[who].tokens_count;
363 	}
364 
365 	/**
366     *
367     * allowance() - constant function to check how much is
368     *               permitted to spend to 3rd person from owner balance
369     *
370     *  @param owner   - owner of the balance
371     *  @param spender - permitted to spend from this balance person
372     *
373     *  @return - remaining right to spend
374     *
375     */
376 	function allowance(address owner, address spender) constant returns (uint256 _allowance) {
377 		return _approvals[owner][spender];
378 	}
379 
380 
381 	function safeToAdd(uint256 a, uint256 b) internal returns (bool) {
382 		// overflow check
383 		return (a + b >= a && a + b >= b);
384 	}
385 
386 	/**
387     * transfer() - transfer tokens from msg.sender balance
388     *              to requested account
389     *
390     *  @param to    - target address to transfer tokens
391     *  @param value - ammount of tokens to transfer
392     *
393     *  @return - success / failure of the transaction
394     */
395 	function transfer( address to, uint256 value) returns (bool ok) {
396 		if(this.isOperationBlocked()) throw;
397 
398 		if( _balances[msg.sender].tokens_count < value ) {
399 		    throw;
400 		}
401 		if( !safeToAdd(_balances[to].tokens_count, value) ) {
402 		    throw;
403 		}
404 
405 		_balances[msg.sender].tokens_count -= value;
406 		if(_balances[to].init){
407 			_balances[to].tokens_count += value;
408 		}
409 		else{
410 			addUserToList(to);
411 			_balances[to] = holderData(value, true);
412 		}
413 
414 		Transfer( msg.sender, to, value );
415 		return true;
416 	}
417 
418 	/**
419     * transferFrom() - used to move allowed funds from other owner
420     *                  account
421     *
422     *  @param from  - move funds from account
423     *  @param to    - move funds to account
424     *  @param value - move the value
425     *
426     *  @return - return true on success false otherwise
427     */
428 	function transferFrom( address from, address to, uint256 value) returns (bool ok) 
429 	{
430 		if(this.isOperationBlocked()) throw;
431 
432 		if( _balances[from].tokens_count < value ) {
433 		    throw;
434 		}
435 		
436 		if( _approvals[from][msg.sender] < value ) {
437 		    throw;
438 		}
439 		if( !safeToAdd(_balances[to].tokens_count, value) ) {
440 		    throw;
441 		}
442 		// transfer and return true
443 		_approvals[from][msg.sender] -= value;
444 		_balances[from].tokens_count -= value;
445 		if(_balances[to].init){
446 			_balances[to].tokens_count += value;
447 		}
448 		else{
449 			addUserToList(to);
450 			_balances[to] = holderData(value, true);
451 		}		
452 		
453 		Transfer( from, to, value );
454 		return true;
455 	}
456 
457 	/**
458      *
459      * approve() - function approves to a person to spend some tokens from
460      *           owner balance.
461      *
462      *  @param spender - person whom this right been granted.
463      *  @param value   - value to spend.
464      *
465      *  @return true in case of success, otherwise failure
466      *
467      */
468 	function approve(address spender, uint256 value) returns (bool ok) 
469 	{
470 		if(this.isOperationBlocked()) throw;
471 
472 		_approvals[msg.sender][spender] = value;
473 		Approval( msg.sender, spender, value );
474 		return true;
475 	}
476 
477 	event Emission(address indexed to, uint256 value, uint256 bet, uint256 coef, uint256 decimals, uint256 cost_token);
478 
479 	/**
480     *
481     *  emission() - emission of tokens initiated by the game contract.
482     *
483     *  @param player       - player's address.
484     *  @param partner      - affiliate's address.
485     *  @param value_bet    - player's bet value.
486     *  @param coef_player  - player's coefficient emission.
487     *  @param coef_partner - affiliate's coefficient emission.
488     *
489     *  @return (true, 0) in case of success, otherwise (False, error_code)
490     *
491     *
492     *  Error code 1 - operation stoped
493     *  Error code 2 - sender address is not in games list
494     *  Error code 3 - incorrect player's address
495     *  Error code 4 - incorrect value bet
496     *  Error code 5 - incorrect emission coefficient
497     */
498 	function emission(address player, address partner, uint256 value_bet, uint256 coef_player, uint256 coef_partner) external returns(uint256, uint8) {
499         if(this.isOperationBlocked()) return (0, 1);
500 
501         if(listGames[msg.sender].init == false) return (0, 2);
502         if(player == address(0x0)) return (0, 3);
503         if(value_bet == 0 || value_bet > max_value_bet) return (0, 4);
504         if(coef_player > max_coef_player || coef_partner > max_coef_partner) return (0, 5);
505 
506 		uint256 decimals_token = 10**uint256(decimals);
507 
508 		uint256 player_token = ((value_bet*coef_player*decimals_token)/10000)/costOfOneToken;
509 		if(_balances[player].init){
510 			_balances[player].tokens_count += player_token;
511 		}
512 		else{
513 			addUserToList(player);
514 			_balances[player] = holderData(player_token, true);
515 		}
516 		Emission(player, player_token, value_bet, coef_player, decimals_token, costOfOneToken);
517 
518 		uint256 partner_token = 0;
519 		if(partner != address(0x0)){
520 			partner_token = ((value_bet*coef_partner*decimals_token)/10000)/costOfOneToken;
521 			if(_balances[partner].init){
522 				_balances[partner].tokens_count += partner_token;
523 			}
524 			else{
525 				addUserToList(partner);
526 				_balances[partner] = holderData(partner_token, true);
527 			}
528 			Emission(partner, partner_token, value_bet, coef_partner, decimals_token, costOfOneToken);
529 		}
530 
531 		_supply += (player_token+partner_token);
532 
533 		return (player_token, 0);
534 	}
535 
536 	//------------------------------------
537 	// Temporary Tokens
538 	//------------------------------------
539 	address[] listAddrTempHolders;
540 	event TempTokensSend(address indexed recipient, uint256 count, uint256 start, uint256 end);
541 
542 	/**
543      *
544      *  sendTempTokens() - sending temporary tokens to address.
545      *
546      *  @param recipient - recipient's address.
547      *  @param count     - temporary tokens amount.
548      *  @param period    - period of possession of the tokens in seconds.
549      *
550      */
551 	function sendTempTokens(address recipient, uint256 count, uint256 period) isDeveloper {
552 		if(this.isOperationBlocked()) throw;
553 
554 		if(count==0 || period==0) throw;
555 		
556 		uint256 decimals_token = 10**uint256(decimals);
557 		count = count*decimals_token;
558 
559 		if(_balances[fond_wallet].tokens_count < count) throw;
560 		if(_temp_balance[recipient].tokens_count > 0) throw;
561 
562 		if(!_temp_balance[recipient].init){
563 			_temp_balance[recipient] = tempHolderData(count, now, now + period, true);
564 			listAddrTempHolders.push(recipient);
565 		}
566 		else{
567 			_temp_balance[recipient].tokens_count = count;
568 			_temp_balance[recipient].start_date = now;
569 			_temp_balance[recipient].end_date = now + period;
570 		}
571 		_balances[fond_wallet].tokens_count -= count;
572 		TempTokensSend(recipient, count, _temp_balance[recipient].start_date, _temp_balance[recipient].end_date);
573 	}
574 
575 	function tempTokensBalanceOf( address who ) external constant returns (uint256) {
576 		if(_temp_balance[who].end_date < now) return 0;
577 		else return _temp_balance[who].tokens_count;
578 	}
579 
580 	function tempTokensPeriodOf( address who ) external constant returns (uint256) {
581 		if(_temp_balance[who].end_date < now) return 0;
582 		else return _temp_balance[who].end_date;
583 	}
584 
585 	/**
586      *
587      *  returnTempTokens() - return of temporary tokens after the expiration of possession time.
588      *
589      *  @param recipient - temporary token holder address.
590      *
591      */
592 	function returnTempTokens(address recipient) isDeveloper {
593 		if(this.isOperationBlocked()) throw;
594 		
595 		if(_temp_balance[recipient].tokens_count == 0) throw;
596 
597 		_balances[fond_wallet].tokens_count += _temp_balance[recipient].tokens_count;
598 		_temp_balance[recipient].tokens_count = 0;
599 		_temp_balance[recipient].start_date = 0;
600 		_temp_balance[recipient].end_date = 0;
601 	}
602 
603 	function getListTempHolders() constant returns(address[]){
604 		return listAddrTempHolders;
605 	}
606 
607 	function getCountTempHolders() external constant returns(uint256){
608 		return listAddrTempHolders.length;
609 	}
610 
611 	function getItemTempHolders(uint256 index) external constant returns(address){
612 		if(index >= listAddrTempHolders.length) return address(0x0);
613 		else return listAddrTempHolders[index];
614 	}
615 
616 	//------------------------------------
617 	// Invest Functions
618 	//------------------------------------
619 
620 	function() payable
621 	{	
622 		if(this.isOperationBlocked()) throw;
623 		if(msg.sender == developer) throw;
624 		if(msg.sender == manager) throw;
625 		if(msg.sender == developer_wallet) throw;
626 		if(msg.sender == wallet_ICO) throw;
627 		if(msg.sender == fond_wallet) throw;
628 
629 		if(listGames[msg.sender].init) throw;
630 
631 		if(enableICO == false) throw;
632 			
633 		if(msg.value < min_value_buyToken) throw;
634 		
635 		uint256 value_send = msg.value;
636 		if(value_send > max_value_buyToken){
637 			value_send = max_value_buyToken;
638 			if(msg.sender.send(msg.value-max_value_buyToken)==false) throw;
639 		}
640 
641 		uint256 decimals_token = 10**uint256(decimals);
642 		
643 		uint256 count_tokens = (value_send*decimals_token)/costOfOneToken;
644 		
645 		if(count_tokens >_balances[wallet_ICO].tokens_count ){
646 			count_tokens = _balances[wallet_ICO].tokens_count;
647 		}
648 		if(value_send > (count_tokens*costOfOneToken)/decimals_token){				
649 			if(msg.sender.send(value_send-((count_tokens*costOfOneToken)/decimals_token))==false) throw;
650 			value_send = (count_tokens*costOfOneToken)/decimals_token;
651 		}
652 
653 		if(!_balances[msg.sender].init){
654 			if (_balances[wallet_ICO].tokens_count < count_tokens) throw;
655 			addUserToList(msg.sender);
656 			_balances[wallet_ICO].tokens_count -= count_tokens;
657 			_balances[msg.sender] = holderData(count_tokens, true);
658 		}
659 		else{
660 			if(((_balances[msg.sender].tokens_count*costOfOneToken)/decimals_token)+((count_tokens*costOfOneToken)/decimals_token)>max_value_buyToken) {
661 				count_tokens = ((max_value_buyToken*decimals_token)/costOfOneToken)-_balances[msg.sender].tokens_count;					
662 				if(msg.sender.send(value_send-((count_tokens*costOfOneToken)/decimals_token))==false) throw;
663 				value_send = (count_tokens*costOfOneToken)/decimals_token;
664 			}
665 
666 			if (_balances[wallet_ICO].tokens_count < count_tokens) throw;
667 			_balances[wallet_ICO].tokens_count -= count_tokens;
668 			_balances[msg.sender].tokens_count += count_tokens;
669 		}
670 
671 		if(value_send>0){
672 			if(wallet_ICO.send(value_send)==false) throw;
673 		}
674 
675 		if(count_tokens>0){
676 			TokenBuy(msg.sender, count_tokens);
677 		}
678 
679 		if(_balances[wallet_ICO].tokens_count == 0){
680 			enableICO = false;
681 		}
682 	}
683 }