1 /* 		
2 		https://mycryptochamp.io/
3 		hello@mycryptochamp.io
4 */
5 
6 pragma solidity 0.4.24;
7 
8 contract Controller{
9 	function getChampReward(uint _position) public view returns(uint);
10 	function changeChampsName(uint _champId, string _name, address _msgsender) external;
11 	function withdrawChamp(uint _id, address _msgsender) external;
12 	function attack(uint _champId, uint _targetId, address _msgsender) external;
13 	function transferToken(address _from, address _to, uint _id, bool _isTokenChamp) external;
14 	function cancelTokenSale(uint _id, address _msgsender, bool _isTokenChamp) public;
15 	function giveToken(address _to, uint _id, address _msgsender, bool _isTokenChamp) external;
16 	function setTokenForSale(uint _id, uint _price, address _msgsender, bool _isTokenChamp) external;
17 	function getTokenURIs(uint _id, bool _isTokenChamp) public pure returns(string);
18 	function takeOffItem(uint _champId, uint8 _type, address _msgsender) public;
19 	function putOn(uint _champId, uint _itemId, address _msgsender) external;
20 	function forgeItems(uint _parentItemID, uint _childItemID, address _msgsender) external;
21 }
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28   /**
29   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30   */
31   function sub(uint a, uint b) internal pure returns (uint) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   /**
37   * @dev Adds two numbers, throws on overflow.
38   */
39   function add(uint a, uint b) internal pure returns (uint) {
40     uint c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 /// @title MyCryptoChamp Core - Stores all of game data. Functions are stored in the replaceable contracts. This solution was required in order to avoid unexpected bugs and make game upgradeable.
47 /// @author Patrik Mojzis
48 contract MyCryptoChampCore {
49 
50     using SafeMath for uint;
51 
52     struct Champ {
53         uint id; //same as position in Champ[]
54         uint attackPower;
55         uint defencePower;
56         uint cooldownTime; //how long does it take to be able attack again
57         uint readyTime; //if is smaller than block.timestamp champ is ready to fight
58         uint winCount;
59         uint lossCount;
60         uint position; //subtract 1 and you get position in leaderboard[]
61         uint price; //sale price
62         uint withdrawCooldown; //if you one of the 800 best champs and withdrawCooldown is less as block.timestamp then you get ETH reward
63         uint eq_sword; 
64         uint eq_shield; 
65         uint eq_helmet; 
66         bool forSale; //is champ for sale?
67     }
68     
69     struct AddressInfo {
70         uint withdrawal;
71         uint champsCount;
72         uint itemsCount;
73         string name;
74     }
75 
76     //Item struct
77     struct Item {
78         uint id;
79         uint8 itemType; // 1 - Sword | 2 - Shield | 3 - Helmet
80         uint8 itemRarity; // 1 - Common | 2 - Uncommon | 3 - Rare | 4 - Epic | 5 - Legendery | 6 - Forged
81         uint attackPower;
82         uint defencePower;
83         uint cooldownReduction;
84         uint price;
85         uint onChampId; //can not be used to decide if item is on champ, because champ's id can be 0, 'bool onChamp' solves it.
86         bool onChamp; 
87         bool forSale; //is item for sale?
88     }
89     
90     Champ[] public champs;
91     Item[] public items;
92     mapping (uint => uint) public leaderboard;
93     mapping (address => bool) private trusted;
94     mapping (address => AddressInfo) public addressInfo;
95     mapping (bool => mapping(address => mapping (address => bool))) public tokenOperatorApprovals;
96     mapping (bool => mapping(uint => address)) public tokenApprovals;
97     mapping (bool => mapping(uint => address)) public tokenToOwner;
98     mapping (uint => string) public champToName;
99     mapping (bool => uint) public tokensForSaleCount;
100     uint public pendingWithdrawal = 0;
101     address private contractOwner;
102     Controller internal controller;
103 
104 
105     constructor () public 
106     {
107         trusted[msg.sender] = true;
108         contractOwner = msg.sender;
109     }
110     
111 
112     /*============== MODIFIERS ==============*/
113     modifier onlyTrusted(){
114         require(trusted[msg.sender]);
115         _;
116     }
117 
118     modifier isPaid(uint _price)
119     {
120         require(msg.value >= _price);
121         _;
122     }
123 
124     modifier onlyNotOwnerOfItem(uint _itemId) {
125         require(_itemId != 0);
126         require(msg.sender != tokenToOwner[false][_itemId]);
127         _;
128     }
129 
130     modifier isItemForSale(uint _id){
131         require(items[_id].forSale);
132         _;
133     }
134 
135     modifier onlyNotOwnerOfChamp(uint _champId) 
136     {
137         require(msg.sender != tokenToOwner[true][_champId]);
138         _;
139     }
140 
141     modifier isChampForSale(uint _id)
142     {
143         require(champs[_id].forSale);
144         _;
145     }
146 
147 
148     /*============== CONTROL COTRACT ==============*/
149     function loadController(address _address) external onlyTrusted {
150         controller = Controller(_address);
151     }
152 
153     
154     function setTrusted(address _address, bool _trusted) external onlyTrusted {
155         trusted[_address] = _trusted;
156     }
157     
158     function transferOwnership(address newOwner) public onlyTrusted {
159         require(newOwner != address(0));
160         contractOwner = newOwner;
161     }
162     
163 
164     /*============== PRIVATE FUNCTIONS ==============*/
165     function _addWithdrawal(address _address, uint _amount) private 
166     {
167         addressInfo[_address].withdrawal += _amount;
168         pendingWithdrawal += _amount;
169     }
170 
171     /// @notice Distribute input funds between contract owner and players
172     function _distributeNewSaleInput(address _affiliateAddress) private 
173     {
174         //contract owner
175         _addWithdrawal(contractOwner, ((msg.value / 100) * 60)); // 60%
176 
177         //affiliate
178         //checks if _affiliateAddress is set & if affiliate address is not buying player
179         if(_affiliateAddress != address(0) && _affiliateAddress != msg.sender){
180             _addWithdrawal(_affiliateAddress, ((msg.value / 100) * 25)); //provision is 25%
181             
182         }
183     }
184 
185     
186     /*============== ONLY TRUSTED ==============*/
187     function addWithdrawal(address _address, uint _amount) public onlyTrusted 
188     {
189         _addWithdrawal(_address, _amount);
190     }
191 
192     function clearTokenApproval(address _from, uint _tokenId, bool _isTokenChamp) public onlyTrusted
193     {
194         require(tokenToOwner[_isTokenChamp][_tokenId] == _from);
195         if (tokenApprovals[_isTokenChamp][_tokenId] != address(0)) {
196             tokenApprovals[_isTokenChamp][_tokenId] = address(0);
197         }
198     }
199 
200     function emergencyWithdraw() external onlyTrusted
201     {
202         contractOwner.transfer(address(this).balance);
203     }
204 
205     function setChampsName(uint _champId, string _name) public onlyTrusted 
206     {
207         champToName[_champId] = _name;
208     }
209 
210     function setLeaderboard(uint _x, uint _value) public onlyTrusted
211     {
212         leaderboard[_x] = _value;
213     }
214 
215     function setTokenApproval(uint _id, address _to, bool _isTokenChamp) public onlyTrusted
216     {
217         tokenApprovals[_isTokenChamp][_id] = _to;
218     }
219 
220     function setTokenOperatorApprovals(address _from, address _to, bool _approved, bool _isTokenChamp) public onlyTrusted
221     {
222         tokenOperatorApprovals[_isTokenChamp][_from][_to] = _approved;
223     }
224 
225     function setTokenToOwner(uint _id, address _owner, bool _isTokenChamp) public onlyTrusted
226     {
227         tokenToOwner[_isTokenChamp][_id] = _owner;
228     }
229 
230     function setTokensForSaleCount(uint _value, bool _isTokenChamp) public onlyTrusted 
231     {
232         tokensForSaleCount[_isTokenChamp] = _value;
233     }
234 
235     function transferToken(address _from, address _to, uint _id, bool _isTokenChamp) public onlyTrusted
236     {
237         controller.transferToken(_from, _to, _id, _isTokenChamp);
238     }
239 
240     function updateAddressInfo(address _address, uint _withdrawal, bool _updatePendingWithdrawal, uint _champsCount, bool _updateChampsCount, uint _itemsCount, bool _updateItemsCount, string _name, bool _updateName) public onlyTrusted {
241         AddressInfo storage ai = addressInfo[_address];
242         if(_updatePendingWithdrawal){ ai.withdrawal = _withdrawal; }
243         if(_updateChampsCount){ ai.champsCount = _champsCount; }
244         if(_updateItemsCount){ ai.itemsCount = _itemsCount; }
245         if(_updateName){ ai.name = _name; }
246     }
247 
248     function newChamp(
249         uint _attackPower,
250         uint _defencePower,
251         uint _cooldownTime,
252         uint _winCount,
253         uint _lossCount,
254         uint _position,
255         uint _price,
256         uint _eq_sword, 
257         uint _eq_shield, 
258         uint _eq_helmet, 
259         bool _forSale,
260         address _owner
261     ) public onlyTrusted returns (uint){
262 
263         Champ memory champ = Champ({
264             id: 0,
265             attackPower: 0, //CompilerError: Stack too deep, try removing local variables.
266             defencePower: _defencePower,
267             cooldownTime: _cooldownTime,
268             readyTime: 0,
269             winCount: _winCount,
270             lossCount: _lossCount,
271             position: _position,
272             price: _price,
273             withdrawCooldown: 0,
274             eq_sword: _eq_sword,
275             eq_shield: _eq_shield,
276             eq_helmet: _eq_helmet,
277             forSale: _forSale
278         });
279         champ.attackPower = _attackPower;
280 
281         uint id = champs.push(champ) - 1; 
282         champs[id].id = id; 
283         leaderboard[_position] = id;
284 
285         addressInfo[_owner].champsCount++;
286         tokenToOwner[true][id] = _owner;
287 
288         if(_forSale){
289             tokensForSaleCount[true]++;
290         }
291 
292         return id;
293     }
294 
295     function newItem(
296         uint8 _itemType,
297         uint8 _itemRarity,
298         uint _attackPower,
299         uint _defencePower,
300         uint _cooldownReduction,
301         uint _price,
302         uint _onChampId,
303         bool _onChamp,
304         bool _forSale,
305         address _owner
306     ) public onlyTrusted returns (uint)
307     { 
308         //create that struct
309         Item memory item = Item({
310             id: 0,
311             itemType: _itemType,
312             itemRarity: _itemRarity, 
313             attackPower: _attackPower,
314             defencePower: _defencePower,
315             cooldownReduction: _cooldownReduction,
316             price: _price,
317             onChampId: _onChampId,
318             onChamp: _onChamp, 
319             forSale: _forSale
320 
321         });
322 
323         uint id = items.push(item) - 1;
324         items[id].id = id; 
325 
326         addressInfo[_owner].itemsCount++;
327         tokenToOwner[false][id] = _owner;
328 
329         if(_forSale){
330             tokensForSaleCount[false]++;
331         }
332 
333         return id;
334     }
335 
336     function updateChamp(
337         uint _champId, 
338         uint _attackPower,
339         uint _defencePower,
340         uint _cooldownTime,
341         uint _readyTime,
342         uint _winCount,
343         uint _lossCount,
344         uint _position,
345         uint _price,
346         uint _withdrawCooldown,
347         uint _eq_sword, 
348         uint _eq_shield, 
349         uint _eq_helmet, 
350         bool _forSale
351     ) public onlyTrusted {
352         Champ storage champ = champs[_champId];
353         if(champ.attackPower != _attackPower){champ.attackPower = _attackPower;}
354         if(champ.defencePower != _defencePower){champ.defencePower = _defencePower;}
355         if(champ.cooldownTime != _cooldownTime){champ.cooldownTime = _cooldownTime;}
356         if(champ.readyTime != _readyTime){champ.readyTime = _readyTime;}
357         if(champ.winCount != _winCount){champ.winCount = _winCount;}
358         if(champ.lossCount != _lossCount){champ.lossCount = _lossCount;}
359         if(champ.position != _position){
360             champ.position = _position;
361             leaderboard[_position] = _champId;
362         }
363         if(champ.price != _price){champ.price = _price;}
364         if(champ.withdrawCooldown != _withdrawCooldown){champ.withdrawCooldown = _withdrawCooldown;}
365         if(champ.eq_sword != _eq_sword){champ.eq_sword = _eq_sword;}
366         if(champ.eq_shield != _eq_shield){champ.eq_shield = _eq_shield;}
367         if(champ.eq_helmet != _eq_helmet){champ.eq_helmet = _eq_helmet;}
368         if(champ.forSale != _forSale){ 
369             champ.forSale = _forSale; 
370             if(_forSale){
371                 tokensForSaleCount[true]++;
372             }else{
373                 tokensForSaleCount[true]--;
374             }
375         }
376     }
377 
378     function updateItem(
379         uint _id,
380         uint8 _itemType,
381         uint8 _itemRarity,
382         uint _attackPower,
383         uint _defencePower,
384         uint _cooldownReduction,
385         uint _price,
386         uint _onChampId,
387         bool _onChamp,
388         bool _forSale
389     ) public onlyTrusted
390     {
391         Item storage item = items[_id];
392         if(item.itemType != _itemType){item.itemType = _itemType;}
393         if(item.itemRarity != _itemRarity){item.itemRarity = _itemRarity;}
394         if(item.attackPower != _attackPower){item.attackPower = _attackPower;}
395         if(item.defencePower != _defencePower){item.defencePower = _defencePower;}
396         if(item.cooldownReduction != _cooldownReduction){item.cooldownReduction = _cooldownReduction;}
397         if(item.price != _price){item.price = _price;}
398         if(item.onChampId != _onChampId){item.onChampId = _onChampId;}
399         if(item.onChamp != _onChamp){item.onChamp = _onChamp;}
400         if(item.forSale != _forSale){
401             item.forSale = _forSale;
402             if(_forSale){
403                 tokensForSaleCount[false]++;
404             }else{
405                 tokensForSaleCount[false]--;
406             }
407         }
408     }
409 
410 
411     /*============== CALLABLE BY PLAYER ==============*/
412     function buyItem(uint _id, address _affiliateAddress) external payable 
413     onlyNotOwnerOfItem(_id) 
414     isItemForSale(_id)
415     isPaid(items[_id].price) 
416     {
417         if(tokenToOwner[false][_id] == address(this)){
418             _distributeNewSaleInput(_affiliateAddress);
419         }else{
420             _addWithdrawal(tokenToOwner[false][_id], msg.value);
421         }
422         controller.transferToken(tokenToOwner[false][_id], msg.sender, _id, false);
423     }
424 
425     function buyChamp(uint _id, address _affiliateAddress) external payable
426     onlyNotOwnerOfChamp(_id) 
427     isChampForSale(_id) 
428     isPaid(champs[_id].price) 
429     {
430         if(tokenToOwner[true][_id] == address(this)){
431             _distributeNewSaleInput(_affiliateAddress);
432         }else{
433             _addWithdrawal(tokenToOwner[true][_id], msg.value);
434         }
435         controller.transferToken(tokenToOwner[true][_id], msg.sender, _id, true);
436     }
437 
438     function changePlayersName(string _name) external {
439         addressInfo[msg.sender].name = _name;
440     }
441 
442     function withdrawToAddress(address _address) external 
443     {
444         address playerAddress = _address;
445         if(playerAddress == address(0)){ playerAddress = msg.sender; }
446         uint share = addressInfo[playerAddress].withdrawal; //gets pending funds
447         require(share > 0); //is it more than 0?
448 
449         addressInfo[playerAddress].withdrawal = 0; //set player's withdrawal pendings to 0 
450         pendingWithdrawal = pendingWithdrawal.sub(share); //subtract share from total pendings 
451         
452         playerAddress.transfer(share); //transfer
453     }
454 
455 
456     /*============== VIEW FUNCTIONS ==============*/
457     function getChampsByOwner(address _owner) external view returns(uint256[]) {
458         uint256[] memory result = new uint256[](addressInfo[_owner].champsCount);
459         uint256 counter = 0;
460         for (uint256 i = 0; i < champs.length; i++) {
461             if (tokenToOwner[true][i] == _owner) {
462                 result[counter] = i;
463                 counter++;
464             }
465         }
466         return result;
467     }
468 
469     function getTokensForSale(bool _isTokenChamp) view external returns(uint256[]){
470         uint256[] memory result = new uint256[](tokensForSaleCount[_isTokenChamp]);
471         if(tokensForSaleCount[_isTokenChamp] > 0){
472             uint256 counter = 0;
473             if(_isTokenChamp){
474                 for (uint256 i = 0; i < champs.length; i++) {
475                     if (champs[i].forSale == true) {
476                         result[counter]=i;
477                         counter++;
478                     }
479                 }
480             }else{
481                 for (uint256 n = 0; n < items.length; n++) {
482                     if (items[n].forSale == true) {
483                         result[counter]=n;
484                         counter++;
485                     }
486                 }
487             }
488         }
489         return result;
490     }
491 
492     function getChampStats(uint256 _champId) public view returns(uint256,uint256,uint256){
493         Champ storage champ = champs[_champId];
494         Item storage sword = items[champ.eq_sword];
495         Item storage shield = items[champ.eq_shield];
496         Item storage helmet = items[champ.eq_helmet];
497 
498         uint totalAttackPower = champ.attackPower + sword.attackPower + shield.attackPower + helmet.attackPower; //Gets champs AP
499         uint totalDefencePower = champ.defencePower + sword.defencePower + shield.defencePower + helmet.defencePower; //Gets champs  DP
500         uint totalCooldownReduction = sword.cooldownReduction + shield.cooldownReduction + helmet.cooldownReduction; //Gets  CR
501 
502         return (totalAttackPower, totalDefencePower, totalCooldownReduction);
503     }
504 
505     function getItemsByOwner(address _owner) external view returns(uint256[]) {
506         uint256[] memory result = new uint256[](addressInfo[_owner].itemsCount);
507         uint256 counter = 0;
508         for (uint256 i = 0; i < items.length; i++) {
509             if (tokenToOwner[false][i] == _owner) {
510                 result[counter] = i;
511                 counter++;
512             }
513         }
514         return result;
515     }
516 
517     function getTokenCount(bool _isTokenChamp) external view returns(uint)
518     {
519         if(_isTokenChamp){
520             return champs.length - addressInfo[address(0)].champsCount;
521         }else{
522             return items.length - 1 - addressInfo[address(0)].itemsCount;
523         }
524     }
525     
526     function getTokenURIs(uint _tokenId, bool _isTokenChamp) public view returns(string)
527     {
528         return controller.getTokenURIs(_tokenId,_isTokenChamp);
529     }
530 
531     function onlyApprovedOrOwnerOfToken(uint _id, address _msgsender, bool _isTokenChamp) external view returns(bool)
532     {
533         if(!_isTokenChamp){
534             require(_id != 0);
535         }
536         address owner = tokenToOwner[_isTokenChamp][_id];
537         return(_msgsender == owner || _msgsender == tokenApprovals[_isTokenChamp][_id] || tokenOperatorApprovals[_isTokenChamp][owner][_msgsender]);
538     }
539 
540 
541     /*============== DELEGATE ==============*/
542     function attack(uint _champId, uint _targetId) external{
543         controller.attack(_champId, _targetId, msg.sender);
544     }
545 
546     function cancelTokenSale(uint _id, bool _isTokenChamp) public{
547         controller.cancelTokenSale(_id, msg.sender, _isTokenChamp);
548     }
549 
550     function changeChampsName(uint _champId, string _name) external{
551         controller.changeChampsName(_champId, _name, msg.sender);
552     }
553 
554     function forgeItems(uint _parentItemID, uint _childItemID) external{
555         controller.forgeItems(_parentItemID, _childItemID, msg.sender);
556     }
557 
558     function giveToken(address _to, uint _champId, bool _isTokenChamp) external{
559         controller.giveToken(_to, _champId, msg.sender, _isTokenChamp);
560     }
561 
562     function setTokenForSale(uint _id, uint _price, bool _isTokenChamp) external{
563         controller.setTokenForSale(_id, _price, msg.sender, _isTokenChamp);
564     }
565 
566     function putOn(uint _champId, uint _itemId) external{
567         controller.putOn(_champId, _itemId, msg.sender);
568     }
569 
570     function takeOffItem(uint _champId, uint8 _type) public{
571         controller.takeOffItem(_champId, _type, msg.sender);
572     }
573 
574     function withdrawChamp(uint _id) external{
575         controller.withdrawChamp(_id, msg.sender); 
576     }
577 
578     function getChampReward(uint _position) public view returns(uint){
579         return controller.getChampReward(_position);
580     }
581 }