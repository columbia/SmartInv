1 pragma solidity ^0.4.8;
2 
3 contract SmartRouletteToken {
4 	//Tokens data
5 	string public standard = 'ERC20';
6     string public name;
7     string public symbol;
8     uint8 public decimals;
9 
10 	struct holderData {
11 		uint256 tokens_count;
12 		bool init;
13 	}
14 
15 	struct tempHolderData {
16 		uint256 tokens_count;
17 		uint256 start_date;
18 		uint256 end_date;
19 	}
20 
21 	address[] listAddrHolders;
22 
23 	mapping( address => holderData ) _balances;
24 	mapping( address => tempHolderData ) _temp_balance;
25 	mapping( address => mapping( address => uint256 ) ) _approvals;
26 
27 	bool stop_operation;
28 	
29 	uint256 _supply;
30 	uint256 _init_count_tokens;
31 	uint256 public costOfOneToken; //the cost of one token in wei
32 	
33 	address wallet_ICO;
34 	bool enableICO;
35 	uint256 min_value_buyToken; //in wei
36 	uint256 max_value_buyToken; //in wei
37 
38 	address fond_wallet;
39 	address developer_wallet;
40 
41 	address divident_contract = address(0x0);
42 	
43 	event TokenBuy(address buyer, uint256 amountOfTokens);
44 
45     //Contract data
46 	address developer;
47 	address manager;
48 
49 	struct gamesData {
50 		bool init;
51 	}
52 
53 	mapping( address => gamesData) listGames;
54 	address[] addrGames;
55 
56 
57 	function SmartRouletteToken()
58 	{
59 		_supply = 100000000000000000;
60 		_init_count_tokens = 100000000000000000;
61 
62 		developer_wallet = address(0x8521E1f9220A251dE0ab78f6a2E8754Ca9E75242);
63 		_balances[developer_wallet] = holderData((_supply*20)/100, true);
64 		
65 		wallet_ICO = address(0x2dff87f8892d65f7a97b1287e795405098ae7b7f);
66 		_balances[wallet_ICO] = holderData((_supply*60)/100, true);
67 		
68 		fond_wallet = address(0x3501DD2B515EDC1920f9007782Da5ac018922502);
69 		_balances[fond_wallet] = holderData((_supply*20)/100, true);
70 		
71 		listAddrHolders.push(developer_wallet);
72 		listAddrHolders.push(wallet_ICO);
73 		listAddrHolders.push(fond_wallet);
74         
75         name = 'Roulette Token';                                   
76         symbol = 'RLT';                               
77         decimals = 10;
78         costOfOneToken = 1500000000000000;
79 
80 		developer = msg.sender;
81 		manager = msg.sender;		
82 		
83 		enableICO = false;
84 		min_value_buyToken = 1000000000000000000;
85 		max_value_buyToken = 500000000000000000000;
86 
87 		stop_operation = false;
88 	}
89 
90 	modifier isDeveloper(){
91 		if (msg.sender!=developer) throw;
92 		_;
93 	}
94 
95 	modifier isManager(){
96 		if (msg.sender!=manager && msg.sender!=developer) throw;
97 		_;
98 	}
99 
100 	modifier isAccessStopOperation(){
101 		if (msg.sender!=manager && msg.sender!=developer && (msg.sender!=divident_contract || divident_contract==address(0x0))) throw;
102 		_;
103 	}
104 
105 	function changeDeveloper(address new_developer)
106 	isDeveloper
107 	{
108 		if(new_developer == address(0x0)) throw;
109 		developer = new_developer;
110 	}
111 
112 	function changeManager(address new_manager)
113 	isDeveloper
114 	{
115 		if(new_manager == address(0x0)) throw;
116 		manager = new_manager;
117 	}
118 
119 	function changeDividentContract(address new_contract) isManager
120 	{
121 		if(divident_contract!=address(0x0)) throw;
122 		if(divident_contract==address(0x0)) throw;
123 		divident_contract = new_contract;
124 	}
125 
126 	function newCostToken(uint256 new_cost)
127 	isManager
128 	{
129 		if(new_cost == 0) throw;
130 		costOfOneToken = new_cost;
131 	}
132 
133 	function getostToken() external constant returns(uint256)
134 	{
135 		return costOfOneToken;
136 	}
137 
138 	function addNewGame(address new_game)
139 	isManager
140 	{
141 		if(new_game == address(0x0)) throw;
142 		listGames[new_game] = gamesData(true);
143 		addrGames.push(new_game);
144 	}
145 
146 	function deleteGame(address game)
147 	isManager
148 	{
149 		if(game == address(0x0)) throw;
150 		if(listGames[game].init){
151 			listGames[game].init = false;
152 		}
153 	}
154 
155 	function kill() isDeveloper {
156 		/*uint256 token_price = this.balance/_supply;
157 		for(uint256 i = 0; i < listAddrHolders.length; i++){
158 			if(_balances[listAddrHolders[i]].tokens_count>0){
159 				if(listAddrHolders[i].send(token_price*_balances[listAddrHolders[i]].tokens_count)==false){ throw; }
160 				else{
161 					_balances[listAddrHolders[i]].tokens_count = 0;
162 				}
163 			}
164 		}*/
165 		suicide(developer);
166 	}
167 
168 	function getListGames() constant returns(address[]){
169 		return addrGames;
170 	}
171 
172 	function addUserToList(address user) internal {
173 		if(!_balances[user].init){
174 			listAddrHolders.push(user);
175 		}
176 	}
177 
178 	function gameListOf( address who ) external constant returns (bool value) {
179 		gamesData game_data = listGames[who];
180 		return game_data.init;
181 	}
182 
183 	//------------------------------------
184 	// Tokens Functions
185 	//------------------------------------
186 	event Transfer(address indexed from, address indexed to, uint256 value);
187     event Approval(address indexed owner, address indexed spender, uint256 value);
188 
189     function stopOperation() isAccessStopOperation {
190 		stop_operation = true;
191 	}
192 
193 	function startOperation() isAccessStopOperation {
194 		stop_operation = false;
195 	}
196 
197 	function statusOperation() constant returns (bool){
198 		return stop_operation;
199 	}
200 
201 	function runICO() isManager {
202 		enableICO = true;
203 	}
204 
205 	function stopICO() isManager {
206 		enableICO = false;
207 	}
208 
209 	function infoICO() constant returns (bool){
210 		return enableICO;
211 	}
212 
213 	function totalSupply() constant returns (uint256 supply) {
214 		return _supply;
215 	}
216 
217 	function initCountTokens() constant returns (uint256 init_count) {
218 		return _init_count_tokens;
219 	}
220 
221 	function balanceOf( address who ) external constant returns (uint256 value) {
222 		//holderData data_holder = _balances[who];
223 		return _balances[who].tokens_count;
224 	}
225 
226 	function allowance(address owner, address spender) constant returns (uint256 _allowance) {
227 		return _approvals[owner][spender];
228 	}
229 
230 	// overflow check
231 	function safeToAdd(uint256 a, uint256 b) internal returns (bool) {
232 		return (a + b >= a && a + b >= b);
233 	}
234 
235 	function transfer( address to, uint256 value) returns (bool ok) {
236 		if(stop_operation) throw;
237 
238 		if( _balances[msg.sender].tokens_count < value ) {
239 		    throw;
240 		}
241 		if( !safeToAdd(_balances[to].tokens_count, value) ) {
242 		    throw;
243 		}
244 
245 		_balances[msg.sender].tokens_count -= value;
246 		if(_balances[to].init){
247 			_balances[to].tokens_count += value;
248 		}
249 		else{
250 			addUserToList(to);
251 			_balances[to] = holderData(value, true);
252 		}
253 
254 		Transfer( msg.sender, to, value );
255 		return true;
256 	}
257 
258 	function transferFrom( address from, address to, uint256 value) returns (bool ok) {
259 		if(stop_operation) throw;
260 
261 		if( _balances[from].tokens_count < value ) {
262 		    throw;
263 		}
264 		
265 		if( _approvals[from][msg.sender] < value ) {
266 		    throw;
267 		}
268 		if( !safeToAdd(_balances[to].tokens_count, value) ) {
269 		    throw;
270 		}
271 		// transfer and return true
272 		_approvals[from][msg.sender] -= value;
273 		_balances[from].tokens_count -= value;
274 		if(_balances[to].init){
275 			_balances[to].tokens_count += value;
276 		}
277 		else{
278 			addUserToList(to);
279 			_balances[to] = holderData(value, true);
280 		}		
281 		
282 		Transfer( from, to, value );
283 		return true;
284 	}
285 
286 	function approve(address spender, uint256 value) returns (bool ok) {
287 		if(stop_operation) throw;
288 
289 		_approvals[msg.sender][spender] = value;
290 		Approval( msg.sender, spender, value );
291 		return true;
292 	}
293 
294 	event Emission(address indexed to, uint256 value, uint256 bet, uint256 coef, uint256 decimals, uint256 cost_token);
295 
296 	function emission(address player, address partner, uint256 value_bet, uint16 coef_player, uint16 coef_partner) external returns(uint256) {
297 		if(stop_operation) throw;
298 
299 		if(listGames[msg.sender].init == false) throw;
300 		if(player == address(0x0)) throw;
301 		if(value_bet == 0) throw;
302 
303 		uint256 decimals_token = 10**uint256(decimals);
304 
305 		uint256 player_token = ((value_bet*coef_player*decimals_token)/10000)/costOfOneToken;
306 		if(_balances[player].init){
307 			_balances[player].tokens_count += player_token;
308 		}
309 		else{
310 			addUserToList(player);
311 			_balances[player] = holderData(player_token, true);
312 		}
313 		Emission(player, player_token, value_bet, coef_player, decimals_token, costOfOneToken);
314 
315 		uint256 partner_token = 0;
316 		if(partner != address(0x0)){
317 			partner_token = ((value_bet*coef_partner*decimals_token)/10000)/costOfOneToken;
318 			if(_balances[partner].init){
319 				_balances[partner].tokens_count += partner_token;
320 			}
321 			else{
322 				addUserToList(partner);
323 				_balances[partner] = holderData(partner_token, true);
324 			}
325 			Emission(partner, partner_token, value_bet, coef_partner, decimals_token, costOfOneToken);
326 		}
327 
328 		_supply += (player_token+partner_token);
329 
330 		return player_token;
331 	}
332 
333 	//------------------------------------
334 	// Temporary Tokens
335 	//------------------------------------
336 	address[] listAddrTempHolders;
337 	event TempTokensSend(address indexed recipient, uint256 count, uint256 start, uint256 end);
338 
339 	function sendTempTokens(address recipient, uint256 count, uint256 period) isManager {
340 		if(!stop_operation) throw;
341 
342 		if(count==0 || period==0) throw;
343 		
344 		uint256 decimals_token = 10**uint256(decimals);
345 		count = count*decimals_token;
346 
347 		if(_balances[fond_wallet].tokens_count < count) throw;
348 		if(_temp_balance[recipient].tokens_count > 0) throw;
349 
350 		_temp_balance[recipient] = tempHolderData(count, now, now + period);
351 		listAddrTempHolders.push(recipient);
352 		_balances[fond_wallet].tokens_count -= count;
353 		TempTokensSend(recipient, count, _temp_balance[recipient].start_date, _temp_balance[recipient].end_date);
354 	}
355 
356 	function tempTokensBalanceOf( address who ) external constant returns (uint256) {
357 		//tempHolderData data_holder = __temp_balance[who];
358 		if(_temp_balance[who].end_date < now) return 0;
359 		else return _temp_balance[who].tokens_count;
360 	}
361 
362 	function tempTokensPeriodOf( address who ) external constant returns (uint256) {
363 		if(_temp_balance[who].end_date < now) return 0;
364 		else return _temp_balance[who].end_date;
365 	}
366 
367 	function returnTempTokens(address recipient) isManager {
368 		if(!stop_operation) throw;
369 		
370 		if(_temp_balance[recipient].tokens_count == 0) throw;
371 
372 		_balances[fond_wallet].tokens_count += _temp_balance[recipient].tokens_count;
373 		_temp_balance[recipient] = tempHolderData(0, 0, 0);		
374 	}
375 
376 	function getListTempHolders() constant returns(address[]){
377 		return listAddrTempHolders;
378 	}
379 
380 	function getCountTempHolders() external constant returns(uint256){
381 		return listAddrTempHolders.length;
382 	}
383 
384 	function getItemTempHolders(uint256 index) external constant returns(address){
385 		if(index >= listAddrTempHolders.length) return address(0x0);
386 		else return listAddrTempHolders[index];
387 	}
388 
389 	//------------------------------------
390 	// Invest Functions
391 	//------------------------------------
392 	/*event SuccessProfitSend(address indexed holder, uint value);
393 	event FailProfitSend(address indexed holder, uint value);*/
394 
395 	function() payable
396 	{	
397 		if(!stop_operation) throw;
398 		if(msg.sender == developer) throw;
399 		if(msg.sender == manager) throw;
400 		if(msg.sender == developer_wallet) throw;
401 		if(msg.sender == wallet_ICO) throw;
402 		if(msg.sender == fond_wallet) throw;
403 
404 		/*if(listGames[msg.sender].init){
405 			uint256 profit_one_token = (msg.value+this.balance)/_supply;
406 			for(uint256 i = 0; i < listAddrHolders.length; i++){
407 				if(_balances[listAddrHolders[i]].tokens_count>0){
408 					if(listAddrHolders[i].send(profit_one_token*_balances[listAddrHolders[i]].tokens_count)){
409 						SuccessProfitSend(listAddrHolders[i], profit_one_token*_balances[listAddrHolders[i]].tokens_count);
410 					}
411 					else{
412 						FailProfitSend(listAddrHolders[i], profit_one_token*_balances[listAddrHolders[i]].tokens_count);
413 					}
414 				}
415 			}
416 		}*/
417 		if(listGames[msg.sender].init) throw;
418 
419 		if(enableICO == false) throw;
420 			
421 		if(msg.value < min_value_buyToken) throw;
422 		
423 		uint256 value_send = msg.value;
424 		if(value_send > max_value_buyToken){
425 			value_send = max_value_buyToken;
426 			if(msg.sender.send(msg.value-max_value_buyToken)==false) throw;
427 		}
428 
429 		uint256 decimals_token = 10**uint256(decimals);
430 		
431 		uint256 count_tokens = (value_send*decimals_token)/costOfOneToken;
432 		
433 		if(count_tokens >_balances[wallet_ICO].tokens_count ){
434 			count_tokens = _balances[wallet_ICO].tokens_count;
435 		}
436 		if(value_send > (count_tokens*costOfOneToken)/decimals_token){				
437 			if(msg.sender.send(value_send-((count_tokens*costOfOneToken)/decimals_token))==false) throw;
438 			value_send = value_send - ((count_tokens*costOfOneToken)/decimals_token);
439 		}
440 
441 		if(!_balances[msg.sender].init){
442 			addUserToList(msg.sender);
443 			_balances[wallet_ICO].tokens_count -= count_tokens;			
444 			_balances[msg.sender] = holderData(count_tokens, true);
445 		}
446 		else{
447 			if(((_balances[msg.sender].tokens_count*costOfOneToken)/decimals_token)+((count_tokens*costOfOneToken)/decimals_token)>max_value_buyToken) {
448 				count_tokens = ((max_value_buyToken*decimals_token)/costOfOneToken)-_balances[msg.sender].tokens_count;					
449 				if(msg.sender.send(value_send-((count_tokens*costOfOneToken)/decimals_token))==false) throw;
450 				value_send = ((count_tokens*costOfOneToken)/decimals_token);
451 			}
452 
453 			_balances[wallet_ICO].tokens_count -= count_tokens;
454 			_balances[msg.sender].tokens_count += count_tokens;
455 		}
456 
457 		if(value_send>0){
458 			if(wallet_ICO.send(value_send)==false) throw;
459 		}
460 
461 		if(count_tokens>0){
462 			TokenBuy(msg.sender, count_tokens);
463 		}
464 
465 		if(_balances[wallet_ICO].tokens_count == 0){
466 			enableICO = false;
467 		}
468 	}
469 
470 	function getListAddressHolders() constant returns(address[]){
471 		return listAddrHolders;
472 	}
473 
474 	function getCountHolders() external constant returns(uint256){
475 		return listAddrHolders.length;
476 	}
477 
478 	function getItemHolders(uint256 index) external constant returns(address){
479 		if(index >= listAddrHolders.length) return address(0x0);
480 		else return listAddrHolders[index];
481 	}
482 }