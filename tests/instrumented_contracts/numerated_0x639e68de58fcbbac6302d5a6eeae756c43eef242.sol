1 pragma solidity 0.4.25;
2 
3 
4 contract Ownable {
5     address public owner;
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     /**
9      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
10      * account.
11      */
12     constructor () public {
13         owner = msg.sender;
14     }
15 
16     /**
17      * @dev Throws if called by any account other than the owner.
18      */
19     modifier onlyOwner() {
20         require(msg.sender == owner);
21         _;
22     }
23 
24     /**
25      * @dev Allows the current owner to transfer control of the contract to a newOwner.
26      * @param newOwner The address to transfer ownership to.
27      */
28     function transferOwnership(address newOwner) public onlyOwner {
29         require(newOwner != owner);
30         emit OwnershipTransferred(owner, newOwner);
31         owner = newOwner;
32     }
33 }
34 
35 /**
36 * @title -Name Filter- v0.1.9
37 */
38 library NameFilter {
39     /**
40      * @dev filters name strings
41      * -converts uppercase to lower case.
42      * -makes sure it does not start/end with a space
43      * -makes sure it does not contain multiple spaces in a row
44      * -restricts characters to A-Z, a-z, 0-9, and space.
45      * @return reprocessed string in bytes32 format
46      */
47     function nameFilter(string _input)
48     internal
49     pure
50     returns(bytes32)
51     {
52         bytes memory _temp = bytes(_input);
53         uint256 _length = _temp.length;
54 
55         //sorry limited to 32 characters
56         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
57         // make sure it doesnt start with or end with space
58         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
59 
60         // create a bool to track if we have a non number character
61         bool _hasNonNumber;
62 
63         // convert & check
64         for (uint256 i = 0; i < _length; i++)
65         {
66             // if its uppercase A-Z
67             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
68             {
69                 // convert to lower case a-z
70                 _temp[i] = byte(uint(_temp[i]) + 32);
71 
72                 // we have a non number
73                 if (_hasNonNumber == false)
74                     _hasNonNumber = true;
75             } else {
76                 require
77                 (
78                 // require character is a space
79                     _temp[i] == 0x20 ||
80                 // OR lowercase a-z
81                 (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
82                 // or 0-9
83                 (_temp[i] > 0x2f && _temp[i] < 0x3a),
84                     "string contains invalid characters"
85                 );
86                 // make sure theres not 2x spaces in a row
87                 if (_temp[i] == 0x20)
88                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
89 
90                 // see if we have a character other than a number
91                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
92                     _hasNonNumber = true;
93             }
94         }
95 
96         bytes32 _ret;
97         assembly {
98             _ret := mload(add(_temp, 32))
99         }
100         return (_ret);
101     }
102 }
103 
104 
105 /**
106  * Math operations with safety checks
107  */
108 /**
109  * @title SafeMath
110  * @dev Math operations with safety checks that revert on error
111  */
112 library SafeMath {
113 
114     /**
115     * @dev Multiplies two numbers, reverts on overflow.
116     */
117     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
118         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
119         // benefit is lost if 'b' is also tested.
120         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
121         if (a == 0) {
122             return 0;
123         }
124 
125         uint256 c = a * b;
126         require(c / a == b);
127 
128         return c;
129     }
130 
131     /**
132     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
133     */
134     function div(uint256 a, uint256 b) internal pure returns (uint256) {
135         require(b > 0); // Solidity only automatically asserts when dividing by 0
136         uint256 c = a / b;
137         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
138 
139         return c;
140     }
141 
142     /**
143     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
144     */
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         require(b <= a);
147         uint256 c = a - b;
148 
149         return c;
150     }
151 
152     /**
153     * @dev Adds two numbers, reverts on overflow.
154     */
155     function add(uint256 a, uint256 b) internal pure returns (uint256) {
156         uint256 c = a + b;
157         require(c >= a);
158 
159         return c;
160     }
161 
162     /**
163     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
164     * reverts when dividing by zero.
165     */
166     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
167         require(b != 0);
168         return a % b;
169     }
170 }
171 
172 contract CelebrityGame is Ownable {
173     using SafeMath for *;
174     using NameFilter for string;
175 
176     string constant public gameName = "Celebrity Game";
177 
178     // fired whenever a card is created
179     event LogNewCard(string name, uint256 id);
180     // fired whenever a player is registered
181     event LogNewPlayer(string name, uint256 id);
182 
183     //just for isStartEnable modifier
184     bool private isStart = false;
185     uint256 private roundId = 0;
186 
187     struct Card {
188         bytes32 name;           // card owner name
189         uint256 fame;           // The number of times CARDS were liked
190         uint256 fameValue;      // The charge for the current card to be liked once
191         uint256 notorious;      // The number of times CARDS were disliked
192         uint256 notoriousValue; // The charge for the current card to be disliked once
193     }
194 
195     struct CardForPlayer {
196         uint256 likeCount;      // The number of times the player likes it
197         uint256 dislikeCount;   // The number of times the player disliked it
198     }
199 
200     struct CardWinner {
201         bytes32  likeWinner;
202         bytes32  dislikeWinner;
203     }
204 
205     Card[] public cards;
206     bytes32[] public players;
207 
208     mapping (uint256 => mapping (uint256 => mapping ( uint256 => CardForPlayer))) public playerCard;      // returns cards of this player like or dislike by playerId and roundId and cardId
209     mapping (uint256 => mapping (uint256 => CardWinner)) public cardWinnerMap; // (roundId => (cardId => winner)) returns winner by roundId and cardId
210     mapping (uint256 => Card[]) public rounCardMap;                            // returns Card info by roundId
211 
212     mapping (bytes32 => uint256) private plyNameXId;                           // (playerName => Id) returns playerId by playerName
213     mapping (bytes32 => uint256) private cardNameXId;                          // (cardName => Id) returns cardId by cardName
214     mapping (bytes32 => bool) private cardIsReg;                               // (cardName => cardCount) returns cardCount by cardName，just for createCard function
215     mapping (bytes32 => bool) private playerIsReg;                             // (playerName => isRegister) returns registerInfo by playerName, just for registerPlayer funciton
216     mapping (uint256 => bool) private cardIdIsReg;                             // (cardId => card info) returns card info by cardId
217     mapping (uint256 => bool) private playerIdIsReg;                           // (playerId => id) returns player index of players by playerId
218     mapping (uint256 => uint256) private cardIdXSeq;
219     mapping (uint256 => uint256) private playerIdXSeq;
220 
221     /**
222 	 * @dev used to make sure no one can interact with contract until it has been started
223 	 */
224     modifier isStartEnable {
225         require(isStart == true);
226         _;
227     }
228 	/**
229 	 * the contract  precision is 1000
230 	 */
231     constructor() public {
232         string[8]  memory names= ["SatoshiNakamoto","CZ","HeYi","LiXiaolai","GuoHongcai","VitalikButerin","StarXu","ByteMaster"];
233         uint256[8] memory _ids = [uint256(183946248739),536269148721,762415028463,432184367532,398234673241,264398721023,464325189620,217546321806];
234         for (uint i = 0; i < 8; i++){
235              string  memory _nameString = names[i];
236              uint256 _id = _ids[i];
237              bytes32 _name = _nameString.nameFilter();
238              require(cardIsReg[_name] == false);
239              uint256 _seq = cards.push(Card(_name, 1, 1000, 1, 1000)) - 1;
240              cardIdXSeq[_id] = _seq;
241              cardNameXId[_name] = _id;
242              cardIsReg[_name] = true;
243             cardIdIsReg[_id] = true;
244         }
245 
246     }
247     /**
248 	 * @dev use this function to create card.
249 	 * - must pay some create fees.
250 	 * - name must be unique
251 	 * - max length of 32 characters long
252 	 * @param _nameString owner desired name for card
253 	 * @param _id card id
254 	 * (this might cost a lot of gas)
255 	 */
256     function createCard(string _nameString, uint256 _id) public onlyOwner() {
257         require(keccak256(abi.encodePacked(_name)) != keccak256(abi.encodePacked("")));
258 
259         bytes32 _name = _nameString.nameFilter();
260         require(cardIsReg[_name] == false);
261         uint256 _seq = cards.push(Card(_name, 1, 1000, 1, 1000)) - 1;
262         cardIdXSeq[_id] = _seq;
263         cardNameXId[_name] = _id;
264         cardIsReg[_name] = true;
265         cardIdIsReg[_id] = true;
266         emit LogNewCard(_nameString, _id);
267     }
268 
269     /**
270 	 * @dev use this function to register player.
271 	 * - must pay some register fees.
272 	 * - name must be unique
273 	 * - name cannot be null
274 	 * - max length of 32 characters long
275 	 * @param _nameString team desired name for player
276 	 * @param _id player id
277 	 * (this might cost a lot of gas)
278 	 */
279     function registerPlayer(string _nameString, uint256 _id)  external {
280         require(keccak256(abi.encodePacked(_name)) != keccak256(abi.encodePacked("")));
281 
282         bytes32 _name = _nameString.nameFilter();
283         require(playerIsReg[_name] == false);
284         uint256 _seq = players.push(_name) - 1;
285         playerIdXSeq[_id] = _seq;
286         plyNameXId[_name] = _id;
287         playerIsReg[_name] = true;
288         playerIdIsReg[_id] = true;
289 
290         emit LogNewPlayer(_nameString, _id);
291     }
292 
293     /**
294 	 * @dev this function for One player likes the CARD once.
295 	 * @param _cardId must be returned when creating CARD
296 	 * @param _playerId must be returned when registering player
297 	 * (this might cost a lot of gas)
298 	 */
299     function likeCelebrity(uint256 _cardId, uint256 _playerId) external isStartEnable {
300         require(cardIdIsReg[_cardId] == true, "sorry create this card first");
301         require(playerIdIsReg[_playerId] == true, "sorry register the player name first");
302 
303         Card storage queryCard = cards[cardIdXSeq[_cardId]];
304         queryCard.fame = queryCard.fame.add(1);
305         queryCard.fameValue = queryCard.fameValue.add(queryCard.fameValue / 100*1000);
306 
307         playerCard[_playerId][roundId][_cardId].likeCount == (playerCard[_playerId][roundId][_cardId].likeCount).add(1);
308         cardWinnerMap[roundId][_cardId].likeWinner = players[playerIdXSeq[_playerId]];
309     }
310 
311     /**
312 	 * @dev this function for One player dislikes the CARD once.
313 	 * @param _cardId must be returned when creating CARD
314 	 * @param _playerId must be created when registering player
315 	 * (this might cost a lot of gas)
316 	 */
317     function dislikeCelebrity(uint256 _cardId, uint256 _playerId) external isStartEnable {
318         require(cardIdIsReg[_cardId] == true, "sorry create this card first");
319         require(playerIdIsReg[_playerId] == true, "sorry register the player name first");
320 
321         Card storage queryCard = cards[cardIdXSeq[_cardId]];
322         queryCard.notorious = queryCard.notorious.add(1);
323         queryCard.notoriousValue = queryCard.notoriousValue.add(queryCard.notoriousValue / 100*1000);
324 
325         playerCard[_playerId][roundId][_cardId].dislikeCount == (playerCard[_playerId][roundId][_cardId].dislikeCount).add(1);
326         cardWinnerMap[roundId][_cardId].dislikeWinner = players[playerIdXSeq[_playerId]];
327     }
328 
329     /**
330 	 * @dev use this function to reset card properties.
331 	 * - must be called when game is not started by team.
332 	 * @param _id must be returned when creating CARD
333 	 * (this might cost a lot of gas)
334 	 */
335     function reset(uint256 _id) external onlyOwner() {
336         require(isStart == false);
337 
338         Card storage queryCard = cards[cardIdXSeq[_id]];
339         queryCard.fame = 1;
340         queryCard.fameValue = 1000;
341         queryCard.notorious = 1;
342         queryCard.notoriousValue = 1000;
343     }
344 
345     /**
346 	 * @dev use this function to start the game.
347 	 * - must be called by owner.
348 	 * (this might cost a lot of gas)
349 	 */
350     function gameStart() external onlyOwner() {
351         isStart = true;
352         roundId = roundId.add(1);
353     }
354 
355     /**
356 	 * @dev use this function to end the game. Just for emergency control by owner
357 	 * (this might cost a lot of gas)
358 	 */
359     function gameEnd() external onlyOwner() {
360         isStart = false;
361         rounCardMap[roundId] = cards;
362     }
363 
364     /**
365 	 * @dev use this function to get CARDS count
366 	 * @return Total all CARDS in the current game
367 	 */
368     function getCardsCount() public view returns(uint256) {
369         return cards.length;
370     }
371 
372     /**
373 	 * @dev use this function to get CARDS id by its name.
374 	 * @param _nameString must be created when creating CARD
375 	 * @return the card id
376 	 */
377     function getCardId(string _nameString) public view returns(uint256) {
378         bytes32 _name = _nameString.nameFilter();
379         require(cardIsReg[_name] == true, "sorry create this card first");
380         return cardNameXId[_name];
381     }
382 
383     /**
384 	 * @dev use this function to get player id by the name.
385 	 * @param _nameString must be created when creating CARD
386 	 * @return the player id
387 	 */
388     function getPlayerId(string _nameString) public view returns(uint256) {
389         bytes32 _name = _nameString.nameFilter();
390         require(playerIsReg[_name] == true, "sorry register the player name first");
391         return plyNameXId[_name];
392     }
393 
394     /**
395 	 * @dev use this function to get player bet count.
396 	 * @param _playerName must be created when registering player
397 	 * @param _roundId must be a game that has already started
398 	 * @param _cardName the player id must be created when creating CARD
399 	 * @return likeCount
400 	 * @return dislikeCount
401 	 */
402     function getPlayerBetCount(string _playerName, uint256 _roundId, string _cardName) public view returns(uint256 likeCount, uint256 dislikeCount) {
403         bytes32 _cardNameByte = _cardName.nameFilter();
404         require(cardIsReg[_cardNameByte] == false);
405 
406         bytes32 _playerNameByte = _playerName.nameFilter();
407         require(playerIsReg[_playerNameByte] == false);
408         return (playerCard[plyNameXId[_playerNameByte]][_roundId][cardNameXId[_cardNameByte]].likeCount, playerCard[plyNameXId[_playerNameByte]][_roundId][cardNameXId[_cardNameByte]].dislikeCount);
409     }
410 }