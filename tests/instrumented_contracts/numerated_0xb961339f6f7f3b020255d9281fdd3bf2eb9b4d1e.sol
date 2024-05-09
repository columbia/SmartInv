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
156 		suicide(developer);
157 	}
158 
159 	function addUserToList(address user) internal {
160 		if(!_balances[user].init){
161 			listAddrHolders.push(user);
162 		}
163 	}
164 
165 	function gameListOf( address who ) external constant returns (bool value) {
166 		gamesData game_data = listGames[who];
167 		return game_data.init;
168 	}
169 
170 	//------------------------------------
171 	// Tokens Functions
172 	//------------------------------------
173 	event Transfer(address indexed from, address indexed to, uint256 value);
174     event Approval(address indexed owner, address indexed spender, uint256 value);
175 
176     function stopOperation() isAccessStopOperation {
177 		stop_operation = true;
178 	}
179 
180 	function startOperation() isAccessStopOperation {
181 		stop_operation = false;
182 	}
183 
184 	function isOperationBlocked() external constant returns (bool){
185 		return stop_operation;
186 	}
187 
188 	function runICO() isManager {
189 		enableICO = true;
190 	}
191 
192 	function stopICO() isManager {
193 		enableICO = false;
194 	}
195 
196 	function infoICO() constant returns (bool){
197 		return enableICO;
198 	}
199 
200 	function totalSupply() constant returns (uint256 supply) {
201 		return _supply;
202 	}
203 
204 	function initCountTokens() constant returns (uint256 init_count) {
205 		return _init_count_tokens;
206 	}
207 
208 	function balanceOf( address who ) external constant returns (uint256 value) {
209 		return _balances[who].tokens_count;
210 	}
211 
212 	function allowance(address owner, address spender) constant returns (uint256 _allowance) {
213 		return _approvals[owner][spender];
214 	}
215 
216 	// overflow check
217 	function safeToAdd(uint256 a, uint256 b) internal returns (bool) {
218 		return (a + b >= a && a + b >= b);
219 	}
220 
221 	function transfer( address to, uint256 value) returns (bool ok) {
222 		if(stop_operation) throw;
223 
224 		if( _balances[msg.sender].tokens_count < value ) {
225 		    throw;
226 		}
227 		if( !safeToAdd(_balances[to].tokens_count, value) ) {
228 		    throw;
229 		}
230 
231 		_balances[msg.sender].tokens_count -= value;
232 		if(_balances[to].init){
233 			_balances[to].tokens_count += value;
234 		}
235 		else{
236 			addUserToList(to);
237 			_balances[to] = holderData(value, true);
238 		}
239 
240 		Transfer( msg.sender, to, value );
241 		return true;
242 	}
243 
244 	function transferFrom( address from, address to, uint256 value) returns (bool ok) {
245 		if(stop_operation) throw;
246 
247 		if( _balances[from].tokens_count < value ) {
248 		    throw;
249 		}
250 		
251 		if( _approvals[from][msg.sender] < value ) {
252 		    throw;
253 		}
254 		if( !safeToAdd(_balances[to].tokens_count, value) ) {
255 		    throw;
256 		}
257 		// transfer and return true
258 		_approvals[from][msg.sender] -= value;
259 		_balances[from].tokens_count -= value;
260 		if(_balances[to].init){
261 			_balances[to].tokens_count += value;
262 		}
263 		else{
264 			addUserToList(to);
265 			_balances[to] = holderData(value, true);
266 		}		
267 		
268 		Transfer( from, to, value );
269 		return true;
270 	}
271 
272 	function approve(address spender, uint256 value) returns (bool ok) {
273 		if(stop_operation) throw;
274 
275 		_approvals[msg.sender][spender] = value;
276 		Approval( msg.sender, spender, value );
277 		return true;
278 	}
279 
280 	event Emission(address indexed to, uint256 value, uint256 bet, uint256 coef, uint256 decimals, uint256 cost_token);
281 
282 	function emission(address player, address partner, uint256 value_bet, uint16 coef_player, uint16 coef_partner) external returns(uint256) {
283 		if(stop_operation) throw;
284 
285 		if(listGames[msg.sender].init == false) throw;
286 		if(player == address(0x0)) throw;
287 		if(value_bet == 0) throw;
288 
289 		uint256 decimals_token = 10**uint256(decimals);
290 
291 		uint256 player_token = ((value_bet*coef_player*decimals_token)/10000)/costOfOneToken;
292 		if(_balances[player].init){
293 			_balances[player].tokens_count += player_token;
294 		}
295 		else{
296 			addUserToList(player);
297 			_balances[player] = holderData(player_token, true);
298 		}
299 		Emission(player, player_token, value_bet, coef_player, decimals_token, costOfOneToken);
300 
301 		uint256 partner_token = 0;
302 		if(partner != address(0x0)){
303 			partner_token = ((value_bet*coef_partner*decimals_token)/10000)/costOfOneToken;
304 			if(_balances[partner].init){
305 				_balances[partner].tokens_count += partner_token;
306 			}
307 			else{
308 				addUserToList(partner);
309 				_balances[partner] = holderData(partner_token, true);
310 			}
311 			Emission(partner, partner_token, value_bet, coef_partner, decimals_token, costOfOneToken);
312 		}
313 
314 		_supply += (player_token+partner_token);
315 
316 		return player_token;
317 	}
318 
319 	//------------------------------------
320 	// Temporary Tokens
321 	//------------------------------------
322 	address[] listAddrTempHolders;
323 	event TempTokensSend(address indexed recipient, uint256 count, uint256 start, uint256 end);
324 
325 	function sendTempTokens(address recipient, uint256 count, uint256 period) isManager {
326 		if(stop_operation) throw;
327 
328 		if(count==0 || period==0) throw;
329 		
330 		uint256 decimals_token = 10**uint256(decimals);
331 		count = count*decimals_token;
332 
333 		if(_balances[fond_wallet].tokens_count < count) throw;
334 		if(_temp_balance[recipient].tokens_count > 0) throw;
335 
336 		_temp_balance[recipient] = tempHolderData(count, now, now + period);
337 		listAddrTempHolders.push(recipient);
338 		_balances[fond_wallet].tokens_count -= count;
339 		TempTokensSend(recipient, count, _temp_balance[recipient].start_date, _temp_balance[recipient].end_date);
340 	}
341 
342 	function tempTokensBalanceOf( address who ) external constant returns (uint256) {
343 		//tempHolderData data_holder = __temp_balance[who];
344 		if(_temp_balance[who].end_date < now) return 0;
345 		else return _temp_balance[who].tokens_count;
346 	}
347 
348 	function tempTokensPeriodOf( address who ) external constant returns (uint256) {
349 		if(_temp_balance[who].end_date < now) return 0;
350 		else return _temp_balance[who].end_date;
351 	}
352 
353 	function returnTempTokens(address recipient) isManager {
354 		if(stop_operation) throw;
355 		
356 		if(_temp_balance[recipient].tokens_count == 0) throw;
357 
358 		_balances[fond_wallet].tokens_count += _temp_balance[recipient].tokens_count;
359 		_temp_balance[recipient] = tempHolderData(0, 0, 0);		
360 	}
361 
362 	function getListTempHolders() constant returns(address[]){
363 		return listAddrTempHolders;
364 	}
365 
366 	function getCountTempHolders() external constant returns(uint256){
367 		return listAddrTempHolders.length;
368 	}
369 
370 	function getItemTempHolders(uint256 index) external constant returns(address){
371 		if(index >= listAddrTempHolders.length) return address(0x0);
372 		else return listAddrTempHolders[index];
373 	}
374 
375 	//------------------------------------
376 	// Invest Functions
377 	//------------------------------------
378 	/*event SuccessProfitSend(address indexed holder, uint value);
379 	event FailProfitSend(address indexed holder, uint value);*/
380 
381 	function() payable
382 	{	
383 		if(stop_operation) throw;
384 		if(msg.sender == developer) throw;
385 		if(msg.sender == manager) throw;
386 		if(msg.sender == developer_wallet) throw;
387 		if(msg.sender == wallet_ICO) throw;
388 		if(msg.sender == fond_wallet) throw;
389 
390 		if(listGames[msg.sender].init) throw;
391 
392 		if(enableICO == false) throw;
393 			
394 		if(msg.value < min_value_buyToken) throw;
395 		
396 		uint256 value_send = msg.value;
397 		if(value_send > max_value_buyToken){
398 			value_send = max_value_buyToken;
399 			if(msg.sender.send(msg.value-max_value_buyToken)==false) throw;
400 		}
401 
402 		uint256 decimals_token = 10**uint256(decimals);
403 		
404 		uint256 count_tokens = (value_send*decimals_token)/costOfOneToken;
405 		
406 		if(count_tokens >_balances[wallet_ICO].tokens_count ){
407 			count_tokens = _balances[wallet_ICO].tokens_count;
408 		}
409 		if(value_send > (count_tokens*costOfOneToken)/decimals_token){				
410 			if(msg.sender.send(value_send-((count_tokens*costOfOneToken)/decimals_token))==false) throw;
411 			value_send = value_send - ((count_tokens*costOfOneToken)/decimals_token);
412 		}
413 
414 		if(!_balances[msg.sender].init){
415 			addUserToList(msg.sender);
416 			_balances[wallet_ICO].tokens_count -= count_tokens;			
417 			_balances[msg.sender] = holderData(count_tokens, true);
418 		}
419 		else{
420 			if(((_balances[msg.sender].tokens_count*costOfOneToken)/decimals_token)+((count_tokens*costOfOneToken)/decimals_token)>max_value_buyToken) {
421 				count_tokens = ((max_value_buyToken*decimals_token)/costOfOneToken)-_balances[msg.sender].tokens_count;					
422 				if(msg.sender.send(value_send-((count_tokens*costOfOneToken)/decimals_token))==false) throw;
423 				value_send = ((count_tokens*costOfOneToken)/decimals_token);
424 			}
425 
426 			_balances[wallet_ICO].tokens_count -= count_tokens;
427 			_balances[msg.sender].tokens_count += count_tokens;
428 		}
429 
430 		if(value_send>0){
431 			if(wallet_ICO.send(value_send)==false) throw;
432 		}
433 
434 		if(count_tokens>0){
435 			TokenBuy(msg.sender, count_tokens);
436 		}
437 
438 		if(_balances[wallet_ICO].tokens_count == 0){
439 			enableICO = false;
440 		}
441 	}
442 
443 	function getListAddressHolders() constant returns(address[]){
444 		return listAddrHolders;
445 	}
446 
447 	function getCountHolders() external constant returns(uint256){
448 		return listAddrHolders.length;
449 	}
450 
451 	function getItemHolders(uint256 index) external constant returns(address){
452 		if(index >= listAddrHolders.length) return address(0x0);
453 		else return listAddrHolders[index];
454 	}
455 }