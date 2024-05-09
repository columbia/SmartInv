1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public constant returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() {
35     owner = msg.sender;
36   }
37 
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) onlyOwner public {
53     require(newOwner != address(0));
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 
60 
61 
62 
63 
64 
65 
66 
67 
68 
69 
70 
71 
72 
73 /**
74  * @title Basic token
75  * @dev Basic version of StandardToken, with no allowances.
76  */
77 contract BasicToken is ERC20Basic {
78   using SafeMath for uint256;
79 
80   mapping(address => uint256) balances;
81 
82   /**
83   * @dev transfer token for a specified address
84   * @param _to The address to transfer to.
85   * @param _value The amount to be transferred.
86   */
87   function transfer(address _to, uint256 _value) public returns (bool) {
88     require(_to != address(0));
89     require(_value <= balances[msg.sender]);
90 
91     // SafeMath.sub will throw if there is not enough balance.
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) public constant returns (uint256 balance) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 
110 
111 
112 
113 
114 
115 /**
116  * @title ERC20 interface
117  * @dev see https://github.com/ethereum/EIPs/issues/20
118  */
119 contract ERC20 is ERC20Basic {
120   function allowance(address owner, address spender) public constant returns (uint256);
121   function transferFrom(address from, address to, uint256 value) public returns (bool);
122   function approve(address spender, uint256 value) public returns (bool);
123   event Approval(address indexed owner, address indexed spender, uint256 value);
124 }
125 
126 
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * @dev https://github.com/ethereum/EIPs/issues/20
133  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amount of tokens to be transferred
145    */
146   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
147     require(_to != address(0));
148     require(_value <= balances[_from]);
149     require(_value <= allowed[_from][msg.sender]);
150 
151     balances[_from] = balances[_from].sub(_value);
152     balances[_to] = balances[_to].add(_value);
153     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
154     Transfer(_from, _to, _value);
155     return true;
156   }
157 
158   /**
159    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160    *
161    * Beware that changing an allowance with this method brings the risk that someone may use both the old
162    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
163    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
164    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165    * @param _spender The address which will spend the funds.
166    * @param _value The amount of tokens to be spent.
167    */
168   function approve(address _spender, uint256 _value) public returns (bool) {
169     allowed[msg.sender][_spender] = _value;
170     Approval(msg.sender, _spender, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Function to check the amount of tokens that an owner allowed to a spender.
176    * @param _owner address The address which owns the funds.
177    * @param _spender address The address which will spend the funds.
178    * @return A uint256 specifying the amount of tokens still available for the spender.
179    */
180   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
181     return allowed[_owner][_spender];
182   }
183 
184   /**
185    * approve should be called when allowed[_spender] == 0. To increment
186    * allowed value is better to use this function to avoid 2 calls (and wait until
187    * the first transaction is mined)
188    * From MonolithDAO Token.sol
189    */
190   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
191     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
192     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
193     return true;
194   }
195 
196   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
197     uint oldValue = allowed[msg.sender][_spender];
198     if (_subtractedValue > oldValue) {
199       allowed[msg.sender][_spender] = 0;
200     } else {
201       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
202     }
203     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
204     return true;
205   }
206 
207 }
208 
209 
210 
211 
212 /**
213  * @title SafeMath
214  * @dev Math operations with safety checks that throw on error
215  */
216 library SafeMath {
217   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
218     uint256 c = a * b;
219     assert(a == 0 || c / a == b);
220     return c;
221   }
222 
223   function div(uint256 a, uint256 b) internal constant returns (uint256) {
224     // assert(b > 0); // Solidity automatically throws when dividing by 0
225     uint256 c = a / b;
226     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
227     return c;
228   }
229 
230   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
231     assert(b <= a);
232     return a - b;
233   }
234 
235   function add(uint256 a, uint256 b) internal constant returns (uint256) {
236     uint256 c = a + b;
237     assert(c >= a);
238     return c;
239   }
240 }
241 
242 
243 
244 contract NoteToken is StandardToken, Ownable {
245     using SafeMath for uint256;
246 
247     string public constant NAME = "Note Token";
248     string public constant SYMBOL = "NOTE";
249     uint256 public tokensLeft;
250     uint256 public endTime;
251     address compositionAddress;
252 
253     modifier beforeEndTime() {
254         require(now < endTime);
255         _;
256     }
257 
258     modifier afterEndTime() {
259         require(now > endTime);
260         _;
261     }
262     event TokensBought(uint256 _num, uint256 _tokensLeft);
263     event TokensReturned(uint256 _num, uint256 _tokensLeft);
264 
265     function NoteToken(uint256 _endTime) public {
266         totalSupply = 5000;
267         tokensLeft = totalSupply;
268 
269         endTime = _endTime;
270     }
271 
272     function purchaseNotes(uint256 _numNotes) beforeEndTime() external payable {
273         require(_numNotes <= 100);
274         require(_numNotes <= tokensLeft);
275         require(_numNotes == (msg.value / 0.001 ether));
276 
277         balances[msg.sender] = balances[msg.sender].add(_numNotes);
278         tokensLeft = tokensLeft.sub(_numNotes);
279 
280         emit TokensBought(_numNotes, tokensLeft);
281     }
282 
283     function returnNotes(uint256 _numNotes) beforeEndTime() external {
284         require(_numNotes <= balances[msg.sender]);
285         
286         uint256 refund = _numNotes * 0.001 ether;
287         balances[msg.sender] = balances[msg.sender].sub(_numNotes);
288         tokensLeft = tokensLeft.add(_numNotes);
289         msg.sender.transfer(refund);
290         emit TokensReturned(_numNotes, tokensLeft);
291     }
292 
293     function setCompositionAddress(address _compositionAddress) onlyOwner() external {
294         require(compositionAddress == address(0));
295 
296         compositionAddress = _compositionAddress;
297     }
298 
299     function transferToComposition(address _from, uint256 _value) beforeEndTime() public returns (bool) {
300         require(msg.sender == compositionAddress);
301         require(_value <= balances[_from]);
302 
303         balances[_from] = balances[_from].sub(_value);
304         balances[compositionAddress] = balances[compositionAddress].add(_value);
305         Transfer(_from, compositionAddress, _value);
306         return true;
307     }
308 
309     function end() afterEndTime() external {
310         selfdestruct(compositionAddress);
311     }
312 }
313 
314 
315 contract CompositionPart {
316     //note struct, holds pitch and place
317     struct noteId {
318         uint256 pitch;
319         uint256 place;
320     }
321 
322     //token contract
323     NoteToken notes;
324 
325     //2d graph of notes and places, represents midi values 0-127 and position,
326     bool[1000][128] composition;
327     //2d graph representing who owns a placed note
328     address[1000][128] composers;
329     
330     //time when composing freezes
331     uint endTime;
332 
333     //keeps track of notes placed by an address
334     mapping (address => noteId[]) ownedNotes;
335 
336     modifier beforeEndTime() {
337         require(now < endTime);
338         _;
339     }
340 
341     modifier afterEndTime() {
342         require(now > endTime);
343         _;
344     }
345 
346     modifier placeValidNotes(uint[] _pitches, uint[] _places, uint256 _numNotes) {
347         require(_pitches.length == _places.length);
348         require(_pitches.length <= 10);
349         require(_pitches.length == _numNotes);
350 
351         for (uint256 i = 0; i < _pitches.length; i++) {
352             if (_pitches[i] > 127 || _places[i] > 999) {
353                 revert();
354             } else if (composition[_pitches[i]][_places[i]]) {
355                 revert();
356             } 
357         }
358         _;
359     }
360 
361     modifier removeValidNotes(uint[] _pitches, uint[] _places, uint256 _numNotes) {
362         require(_pitches.length == _places.length);
363         require(_pitches.length <= 10);
364         require(_pitches.length == _numNotes);
365 
366         for (uint256 i = 0; i < _pitches.length; i++) {
367             if (_pitches[i] > 127 || _places[i] > 999) {
368                 revert();
369             } else if (composers[_pitches[i]][_places[i]] != msg.sender) {
370                 revert();
371             }
372         }
373         _;
374     }
375 
376     event NotePlaced(address composer, uint pitch, uint place);
377     event NoteRemoved(address composer, uint pitch, uint place);
378 
379     //constructor
380     function CompositionPart(uint _endTime, address _noteToken) public {
381         endTime = _endTime;
382         notes = NoteToken(_noteToken);
383     }
384 
385     //places up to 10 valid notes in the composition
386     function placeNotes(uint256[] _pitches, uint256[] _places, uint256 _numNotes) beforeEndTime() placeValidNotes(_pitches, _places, _numNotes) external {
387         require(notes.transferToComposition(msg.sender, _numNotes));
388 
389         for (uint256 i = 0; i < _pitches.length; i++) {
390             noteId memory note;
391             note.pitch = _pitches[i];
392             note.place = _places[i];
393 
394             ownedNotes[msg.sender].push(note);
395 
396             composition[_pitches[i]][_places[i]] = true;
397             composers[_pitches[i]][_places[i]] = msg.sender;
398 
399             emit NotePlaced(msg.sender, _pitches[i], _places[i]);
400         }
401     }
402 
403     //removes up to 10 owned notes from composition
404     function removeNotes(uint256[] _pitches, uint256[] _places, uint256 _numNotes) beforeEndTime() removeValidNotes(_pitches, _places, _numNotes) external {
405         for (uint256 i = 0; i < _pitches.length; i++) {
406             uint256 pitch = _pitches[i];
407             uint256 place = _places[i];
408             composition[pitch][place] = false;
409             composers[pitch][place] = 0x0;
410 
411             removeOwnedNote(msg.sender, pitch, place);
412 
413             emit NoteRemoved(msg.sender, pitch, place);
414         }
415 
416         require(notes.transfer(msg.sender, _numNotes));
417     }
418 
419     //internal function to remove notes from ownedNotes array
420     function removeOwnedNote(address sender, uint256 _pitch, uint256 _place) internal {
421         uint256 length = ownedNotes[sender].length;
422 
423         for (uint256 i = 0; i < length; i++) {
424             if (ownedNotes[sender][i].pitch == _pitch && ownedNotes[sender][i].place == _place) {
425                 ownedNotes[sender][i] = ownedNotes[sender][length-1];
426                 delete ownedNotes[sender][length-1];
427                 ownedNotes[sender].length = (length - 1);
428                 break;
429             }
430         }
431     }
432 
433     //gets a line in the composition for viewing purposes and to prevent having to get the whole composition at once
434     function getNoteLine(uint _pitch) external view returns (bool[1000], address[1000]) {
435         bool[1000] memory _pitches = composition[_pitch];
436         address[1000] memory _composers = composers[_pitch];
437 
438         return (_pitches, _composers);
439     }
440 
441     //returns whether or note a note exists at a pitch and place
442     function getNote(uint _pitch, uint _place) external view returns (bool) {
443         bool _note = composition[_pitch][_place];
444         return _note; 
445     }
446 
447     //returns note owner
448     function getNoteOwner(uint _pitch, uint _place) external view returns (address) {
449         return composers[_pitch][_place];
450     }
451 
452     //returns notes placed by sender
453     function getPlacedNotes() external view returns (uint[], uint[]) {
454         uint length = ownedNotes[msg.sender].length;
455 
456         uint[] memory pitches = new uint[](length);
457         uint[] memory places = new uint[](length);
458         
459         for (uint i = 0; i < ownedNotes[msg.sender].length; i++) {
460             pitches[i] = ownedNotes[msg.sender][i].pitch;
461             places[i] = ownedNotes[msg.sender][i].place;
462         }
463 
464         return (pitches, places);
465     }
466 
467     function () external {
468         revert();
469     }
470 }