1 pragma solidity ^0.4.19;
2 /*
3 Game: CryptoPokemon
4 Domain: CryptoPokemon.com
5 Dev: CryptoPokemon Team
6 */
7 
8 library SafeMath {
9 
10 /**
11 * @dev Multiplies two numbers, throws on overflow.
12 */
13 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14 if (a == 0) {
15 return 0;
16 }
17 uint256 c = a * b;
18 assert(c / a == b);
19 return c;
20 }
21 
22 /**
23 * @dev Integer division of two numbers, truncating the quotient.
24 */
25 function div(uint256 a, uint256 b) internal pure returns (uint256) {
26 // assert(b > 0); // Solidity automatically throws when dividing by 0
27 uint256 c = a / b;
28 // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 return c;
30 }
31 
32 /**
33 * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34 */
35 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36 assert(b <= a);
37 return a - b;
38 }
39 
40 /**
41 * @dev Adds two numbers, throws on overflow.
42 */
43 function add(uint256 a, uint256 b) internal pure returns (uint256) {
44 uint256 c = a + b;
45 assert(c >= a);
46 return c;
47 }
48 }
49 
50 contract PokemonInterface {
51 function levels(uint256 _pokemonId) external view returns (
52 uint256 level
53 );
54 
55 function getPokemonOwner(uint _pokemonId)external view returns (
56 address currentOwner
57 );
58 }
59 
60 contract PublicBattle {
61 using SafeMath for uint256;
62 //Guess parameter
63 uint public totalGuess;
64 uint public totalPool;
65 uint public publicBattlepm1;
66 uint public publicBattlepm2;
67 address guesser;
68 bool public publicbattlestart;
69 mapping(uint => address[]) pokemonGuessPlayers;
70 mapping(uint => uint) pokemonGuessNumber;
71 mapping(uint => uint) pokemonGuessPrize;
72 mapping(address => uint) playerGuessPM1Number;
73 mapping(address => uint) playerGuessPM2Number;
74 mapping(uint => uint) battleCD;
75 uint public pbWinner;
76 
77 address cpAddress = 0x77fA1D1Ded3F4bed737e9aE870a6f3605445df9c;
78 PokemonInterface pokemonContract = PokemonInterface(cpAddress);
79 
80 address contractCreator;
81 address devFeeAddress;
82 
83 function PublicBattle () public {
84 
85 contractCreator = msg.sender;
86 devFeeAddress = 0xFb2D26b0caa4C331bd0e101460ec9dbE0A4783A4;
87 publicbattlestart = false;
88 publicBattlepm1 = 99999;
89 publicBattlepm2 = 99999;
90 pbWinner = 99999;
91 isPaused = false;
92 totalPool = 0;
93 initialPokemonInfo();
94 }
95 
96 struct Battlelog {
97 uint pokemonId1;
98 uint pokemonId2;
99 uint result;
100 
101 }
102 Battlelog[] battleresults;
103 
104 struct PokemonDetails {
105 string pokemonName;
106 uint pokemonType;
107 uint total;
108 }
109 PokemonDetails[] pokemoninfo;
110 
111 //modifiers
112 modifier onlyContractCreator() {
113 require (msg.sender == contractCreator);
114 _;
115 }
116 
117 
118 //Owners and admins
119 
120 /* Owner */
121 function setOwner (address _owner) onlyContractCreator() public {
122 contractCreator = _owner;
123 }
124 
125 
126 // Adresses
127 function setdevFeeAddress (address _devFeeAddress) onlyContractCreator() public {
128 devFeeAddress = _devFeeAddress;
129 }
130 
131 bool isPaused;
132 /*
133 When countdowns and events happening, use the checker.
134 */
135 function pauseGame() public onlyContractCreator {
136 isPaused = true;
137 }
138 function unPauseGame() public onlyContractCreator {
139 isPaused = false;
140 }
141 function GetGamestatus() public view returns(bool) {
142 return(isPaused);
143 }
144 
145 //set withdraw only use when bugs happned.
146 function withdrawAmount (uint256 _amount) onlyContractCreator() public {
147 msg.sender.transfer(_amount);
148 totalPool = totalPool - _amount;
149 }
150 
151 function initialBattle(uint _pokemonId1,uint _pokemonId2) public{
152 require(pokemonContract.getPokemonOwner(_pokemonId1) == msg.sender);
153 require(isPaused == false);
154 require(_pokemonId1 != _pokemonId2);
155 require(getPokemonCD(_pokemonId1) == 0);
156 assert(publicbattlestart != true);
157 publicBattlepm1 = _pokemonId1;
158 publicBattlepm2 = _pokemonId2;
159 publicbattlestart = true;
160 pokemonGuessNumber[publicBattlepm1]=0;
161 pokemonGuessNumber[publicBattlepm2]=0;
162 pokemonGuessPrize[publicBattlepm1]=0;
163 pokemonGuessPrize[publicBattlepm2]=0;
164 isPaused = false;
165 battleCD[_pokemonId1] = now + 12 * 1 hours;
166 // add 1% of balance to contract
167 totalGuess = totalPool.div(100);
168 //trigger time
169 
170 }
171 function donateToPool() public payable{
172 // The pool will make this game maintain forever, 1% of prize goto each publicbattle and
173 // gain 1% of each publicbattle back before distributePrizes
174 require(msg.value >= 0);
175 totalPool = totalPool + msg.value;
176 
177 }
178 
179 function guess(uint _pokemonId) public payable{
180 require(isPaused == false);
181 assert(msg.value > 0);
182 assert(_pokemonId == publicBattlepm1 || _pokemonId == publicBattlepm2);
183 
184 uint256 calcValue = msg.value;
185 uint256 cutFee = calcValue.div(16);
186 
187 calcValue = calcValue - cutFee;
188 
189 // %3 to the Owner of the card and %3 to dev
190 pokemonContract.getPokemonOwner(_pokemonId).transfer(cutFee.div(2));
191 devFeeAddress.transfer(cutFee.div(2));
192 
193 // Total amount
194 totalGuess += calcValue;
195 
196 // Each guess time
197 pokemonGuessNumber[_pokemonId]++;
198 
199 
200 // Each amount
201 pokemonGuessPrize[_pokemonId] = pokemonGuessPrize[_pokemonId] + calcValue;
202 
203 
204 // mapping sender and amount
205 
206 if(_pokemonId == publicBattlepm1){
207 
208 if(playerGuessPM1Number[msg.sender] != 0){
209 
210 playerGuessPM1Number[msg.sender] = playerGuessPM1Number[msg.sender] + calcValue;
211 
212 }else{
213 
214 pokemonGuessPlayers[_pokemonId].push(msg.sender);
215 playerGuessPM1Number[msg.sender]  = calcValue;
216 }
217 
218 }else{
219 
220 
221 if(playerGuessPM2Number[msg.sender] != 0){
222 
223 playerGuessPM2Number[msg.sender] = playerGuessPM2Number[msg.sender] + calcValue;
224 
225 }else{
226 
227 pokemonGuessPlayers[_pokemonId].push(msg.sender);
228 playerGuessPM2Number[msg.sender]  = calcValue;
229 }
230 
231 }
232 
233 if(pokemonGuessNumber[publicBattlepm1] + pokemonGuessNumber[publicBattlepm2] > 20){
234 startpublicBattle(publicBattlepm1, publicBattlepm2);
235 }
236 
237 }
238 
239 function startpublicBattle(uint _pokemon1, uint _pokemon2) internal {
240 require(publicBattlepm1 != 99999 && publicBattlepm2 != 99999);
241 uint256 i = uint256(sha256(block.timestamp, block.number-i-1)) % 100 +1;
242 uint256 threshold = dataCalc(_pokemon1, _pokemon2);
243 
244 if(i <= threshold){
245 pbWinner = publicBattlepm1;
246 }else{
247 pbWinner = publicBattlepm2;
248 }
249 battleresults.push(Battlelog(_pokemon1,_pokemon2,pbWinner));
250 distributePrizes();
251 
252 }
253 
254 function distributePrizes() internal{
255 // return 1% to the balance to keep public battle forever
256 totalGuess = totalGuess - totalGuess.div(100);
257 for(uint counter=0; counter < pokemonGuessPlayers[pbWinner].length; counter++){
258 guesser = pokemonGuessPlayers[pbWinner][counter];
259 if(pbWinner == publicBattlepm1){
260 guesser.transfer(playerGuessPM1Number[guesser].mul(totalGuess).div(pokemonGuessPrize[pbWinner]));
261 //delete playerGuessPM1Number[guesser];
262 
263 }else{
264 
265 guesser.transfer(playerGuessPM2Number[guesser].mul(totalGuess).div(pokemonGuessPrize[pbWinner]));
266 
267 
268 }
269 }
270 uint del;
271 if(pbWinner == publicBattlepm1){
272 del = publicBattlepm2;
273 }else{
274 del = publicBattlepm1;
275 }
276 
277 for(uint cdel1=0; cdel1 < pokemonGuessPlayers[pbWinner].length; cdel1++){
278 guesser = pokemonGuessPlayers[pbWinner][cdel1];
279 if(pbWinner == publicBattlepm1){
280 delete playerGuessPM1Number[guesser];
281 }else{
282 delete playerGuessPM2Number[guesser];
283 }
284 }
285 
286 for(uint cdel=0; cdel < pokemonGuessPlayers[del].length; cdel++){
287 guesser = pokemonGuessPlayers[del][cdel];
288 if(del == publicBattlepm1){
289 delete playerGuessPM1Number[guesser];
290 }else{
291 delete playerGuessPM2Number[guesser];
292 }
293 }
294 
295 
296 pokemonGuessNumber[publicBattlepm1]=0;
297 pokemonGuessNumber[publicBattlepm2]=0;
298 
299 pokemonGuessPrize[publicBattlepm1]=0;
300 pokemonGuessPrize[publicBattlepm2]=0;
301 delete pokemonGuessPlayers[publicBattlepm2];
302 delete pokemonGuessPlayers[publicBattlepm1];
303 //for(counter=0; counter < pokemonGuessPlayers[pbWinner].length; counter++){
304 //pokemonGuessPlayers[counter].length = 0;
305 //}
306 counter = 0;
307 publicBattlepm1 = 99999;
308 publicBattlepm2 = 99999;
309 pbWinner = 99999;
310 totalGuess = 0;
311 publicbattlestart = false;
312 }
313 
314 function dataCalc(uint _pokemon1, uint _pokemon2) public view returns (uint256 _threshold){
315 uint _pokemontotal1;
316 uint _pokemontotal2;
317 
318 // We can just leave the other fields blank:
319 (,,_pokemontotal1) = getPokemonDetails(_pokemon1);
320 (,,_pokemontotal2) = getPokemonDetails(_pokemon2);
321 uint256 threshold = _pokemontotal1.mul(100).div(_pokemontotal1+_pokemontotal2);
322 uint256 pokemonlevel1 = pokemonContract.levels(_pokemon1);
323 uint256 pokemonlevel2 = pokemonContract.levels(_pokemon2);
324 uint leveldiff = pokemonlevel1 - pokemonlevel2;
325 if(pokemonlevel1 >= pokemonlevel2){
326 threshold = threshold.mul(11**leveldiff).div(10**leveldiff);
327 
328 }else{
329 //return (100 - dataCalc(_pokemon2, _pokemon1));
330 threshold = 100 - dataCalc(_pokemon2, _pokemon1);
331 }
332 if(threshold > 90){
333 threshold = 90;
334 }
335 if(threshold < 10){
336 threshold = 10;
337 }
338 
339 return threshold;
340 
341 }
342 
343 
344 
345 // This function will return all of the details of the pokemons
346 function getBattleDetails(uint _battleId) public view returns (
347 uint _pokemon1,
348 uint _pokemon2,
349 uint256 _result
350 ) {
351 Battlelog storage _battle = battleresults[_battleId];
352 
353 _pokemon1 = _battle.pokemonId1;
354 _pokemon2 = _battle.pokemonId2;
355 _result = _battle.result;
356 }
357 
358 function addPokemonDetails(string _pokemonName, uint _pokemonType, uint _total) public onlyContractCreator{
359 
360 pokemoninfo.push(PokemonDetails(_pokemonName,_pokemonType,_total));
361 }
362 
363 // This function will return all of the details of the pokemons
364 function getPokemonDetails(uint _pokemonId) public view returns (
365 string _pokemonName,
366 uint _pokemonType,
367 uint _total
368 ) {
369 PokemonDetails storage _pokemoninfomation = pokemoninfo[_pokemonId];
370 
371 _pokemonName = _pokemoninfomation.pokemonName;
372 _pokemonType = _pokemoninfomation.pokemonType;
373 _total = _pokemoninfomation.total;
374 }
375 
376 function totalBattles() public view returns (uint256 _totalSupply) {
377 return battleresults.length;
378 }
379 
380 function getPokemonBet(uint _pokemonId) public view returns (uint256 _pokemonBet){
381 return pokemonGuessPrize[_pokemonId];
382 }
383 
384 function getPokemonOwner(uint _pokemonId) public view returns (
385 address _owner
386 ) {
387 
388 _owner = pokemonContract.getPokemonOwner(_pokemonId);
389 
390 }
391 
392 function getPublicBattlePokemon1() public view returns(uint _pokemonId1){
393 
394 return publicBattlepm1;
395 }
396 function getPublicBattlePokemon2() public view returns(uint _pokemonId1){
397 
398 return publicBattlepm2;
399 }
400 
401 function getPokemonBetTimes(uint _pokemonId) public view returns(uint _pokemonBetTimes){
402 
403 return pokemonGuessNumber[_pokemonId];
404 }
405 
406 function getPokemonCD(uint _pokemonId) public view returns(uint _pokemonCD){
407 if(battleCD[_pokemonId] <= now){
408 return 0;
409 }else{
410 return battleCD[_pokemonId] - now;
411 }
412 }
413 
414 function initialPokemonInfo() public onlyContractCreator{
415 addPokemonDetails("PikaChu" ,1, 300);
416 addPokemonDetails("Ninetales",1,505);
417 addPokemonDetails("Charizard" ,2, 534);
418 addPokemonDetails("Eevee",0,325);
419 addPokemonDetails("Jigglypuff" ,0, 270);
420 addPokemonDetails("Pidgeot",2,469);
421 addPokemonDetails("Aerodactyl" ,2, 515);
422 addPokemonDetails("Bulbasaur",0,318);
423 addPokemonDetails("Abra" ,0, 310);
424 addPokemonDetails("Gengar",2,500);
425 addPokemonDetails("Hoothoot" ,0, 262);
426 addPokemonDetails("Goldeen",0,320);
427 
428 }
429 
430 }