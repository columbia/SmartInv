1 pragma solidity ^0.4.24;
2 
3 // File: zeppelin-solidity/contracts/ECRecovery.sol
4 
5 /**
6  * @title Eliptic curve signature operations
7  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
8  * TODO Remove this library once solidity supports passing a signature to ecrecover.
9  * See https://github.com/ethereum/solidity/issues/864
10  */
11 
12 library ECRecovery {
13 
14   /**
15    * @dev Recover signer address from a message by using their signature
16    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
17    * @param sig bytes signature, the signature is generated using web3.eth.sign()
18    */
19   function recover(bytes32 hash, bytes sig)
20     internal
21     pure
22     returns (address)
23   {
24     bytes32 r;
25     bytes32 s;
26     uint8 v;
27 
28     // Check the signature length
29     if (sig.length != 65) {
30       return (address(0));
31     }
32 
33     // Divide the signature in r, s and v variables
34     // ecrecover takes the signature parameters, and the only way to get them
35     // currently is to use assembly.
36     // solium-disable-next-line security/no-inline-assembly
37     assembly {
38       r := mload(add(sig, 32))
39       s := mload(add(sig, 64))
40       v := byte(0, mload(add(sig, 96)))
41     }
42 
43     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
44     if (v < 27) {
45       v += 27;
46     }
47 
48     // If the version is correct return the signer address
49     if (v != 27 && v != 28) {
50       return (address(0));
51     } else {
52       // solium-disable-next-line arg-overflow
53       return ecrecover(hash, v, r, s);
54     }
55   }
56 
57   /**
58    * toEthSignedMessageHash
59    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
60    * and hash the result
61    */
62   function toEthSignedMessageHash(bytes32 hash)
63     internal
64     pure
65     returns (bytes32)
66   {
67     // 32 is the length in bytes of hash,
68     // enforced by the type signature above
69     return keccak256(
70       abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
71     );
72   }
73 }
74 
75 // File: zeppelin-solidity/contracts/math/SafeMath.sol
76 
77 /**
78  * @title SafeMath
79  * @dev Math operations with safety checks that throw on error
80  */
81 library SafeMath {
82 
83   /**
84   * @dev Multiplies two numbers, throws on overflow.
85   */
86   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
87     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
88     // benefit is lost if 'b' is also tested.
89     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
90     if (a == 0) {
91       return 0;
92     }
93 
94     c = a * b;
95     assert(c / a == b);
96     return c;
97   }
98 
99   /**
100   * @dev Integer division of two numbers, truncating the quotient.
101   */
102   function div(uint256 a, uint256 b) internal pure returns (uint256) {
103     // assert(b > 0); // Solidity automatically throws when dividing by 0
104     // uint256 c = a / b;
105     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
106     return a / b;
107   }
108 
109   /**
110   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
111   */
112   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113     assert(b <= a);
114     return a - b;
115   }
116 
117   /**
118   * @dev Adds two numbers, throws on overflow.
119   */
120   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
121     c = a + b;
122     assert(c >= a);
123     return c;
124   }
125 }
126 
127 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
128 
129 /**
130  * @title Ownable
131  * @dev The Ownable contract has an owner address, and provides basic authorization control
132  * functions, this simplifies the implementation of "user permissions".
133  */
134 contract Ownable {
135   address public owner;
136 
137 
138   event OwnershipRenounced(address indexed previousOwner);
139   event OwnershipTransferred(
140     address indexed previousOwner,
141     address indexed newOwner
142   );
143 
144 
145   /**
146    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
147    * account.
148    */
149   constructor() public {
150     owner = msg.sender;
151   }
152 
153   /**
154    * @dev Throws if called by any account other than the owner.
155    */
156   modifier onlyOwner() {
157     require(msg.sender == owner);
158     _;
159   }
160 
161   /**
162    * @dev Allows the current owner to relinquish control of the contract.
163    * @notice Renouncing to ownership will leave the contract without an owner.
164    * It will not be possible to call the functions with the `onlyOwner`
165    * modifier anymore.
166    */
167   function renounceOwnership() public onlyOwner {
168     emit OwnershipRenounced(owner);
169     owner = address(0);
170   }
171 
172   /**
173    * @dev Allows the current owner to transfer control of the contract to a newOwner.
174    * @param _newOwner The address to transfer ownership to.
175    */
176   function transferOwnership(address _newOwner) public onlyOwner {
177     _transferOwnership(_newOwner);
178   }
179 
180   /**
181    * @dev Transfers control of the contract to a newOwner.
182    * @param _newOwner The address to transfer ownership to.
183    */
184   function _transferOwnership(address _newOwner) internal {
185     require(_newOwner != address(0));
186     emit OwnershipTransferred(owner, _newOwner);
187     owner = _newOwner;
188   }
189 }
190 
191 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
192 
193 /**
194  * @title ERC20Basic
195  * @dev Simpler version of ERC20 interface
196  * See https://github.com/ethereum/EIPs/issues/179
197  */
198 contract ERC20Basic {
199   function totalSupply() public view returns (uint256);
200   function balanceOf(address who) public view returns (uint256);
201   function transfer(address to, uint256 value) public returns (bool);
202   event Transfer(address indexed from, address indexed to, uint256 value);
203 }
204 
205 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
206 
207 /**
208  * @title ERC20 interface
209  * @dev see https://github.com/ethereum/EIPs/issues/20
210  */
211 contract ERC20 is ERC20Basic {
212   function allowance(address owner, address spender)
213     public view returns (uint256);
214 
215   function transferFrom(address from, address to, uint256 value)
216     public returns (bool);
217 
218   function approve(address spender, uint256 value) public returns (bool);
219   event Approval(
220     address indexed owner,
221     address indexed spender,
222     uint256 value
223   );
224 }
225 
226 // File: contracts/BookingPoC.sol
227 
228 /**
229  * @title BookingPoC
230  * @dev A contract to offer hotel rooms for booking, the payment can be done
231  * with ETH or Lif
232  */
233 contract BookingPoC is Ownable {
234 
235   using SafeMath for uint256;
236   using ECRecovery for bytes32;
237 
238   // The account that will sign the offers
239   address public offerSigner;
240 
241   // The time where no more bookings can be done
242   uint256 public endBookings;
243 
244   // A mapping of the rooms booked by night, it saves the guest address by
245   // room/night
246   // RoomType => Night => Room => Booking
247   struct Booking {
248     address guest;
249     bytes32 bookingHash;
250     uint256 payed;
251     bool isEther;
252   }
253   struct RoomType {
254     uint256 totalRooms;
255     mapping(uint256 => mapping(uint256 => Booking)) nights;
256   }
257   mapping(string => RoomType) rooms;
258 
259   // An array of the refund polices, it has to be ordered by beforeTime
260   struct Refund {
261     uint256 beforeTime;
262     uint8 dividedBy;
263   }
264   Refund[] public refunds;
265 
266   // The total amount of nights offered for booking
267   uint256 public totalNights;
268 
269   // The ERC20 lifToken that will be used for payment
270   ERC20 public lifToken;
271 
272   event BookingCanceled(
273     string roomType, uint256[] nights, uint256 room,
274     address newGuest, bytes32 bookingHash
275   );
276 
277   event BookingChanged(
278     string roomType, uint256[] nights, uint256 room,
279     address newGuest, bytes32 bookingHash
280   );
281 
282   event BookingDone(
283     string roomType, uint256[] nights, uint256 room,
284     address guest, bytes32 bookingHash
285   );
286 
287   event RoomsAdded(string roomType, uint256 newRooms);
288 
289   /**
290    * @dev Constructor
291    * @param _offerSigner Address of the account that will sign offers
292    * @param _lifToken Address of the Lif token contract
293    * @param _totalNights The max amount of nights to be booked
294    */
295   constructor(
296     address _offerSigner, address _lifToken,
297     uint256 _totalNights, uint256 _endBookings
298   ) public {
299     require(_offerSigner != address(0));
300     require(_lifToken != address(0));
301     require(_totalNights > 0);
302     require(_endBookings > now);
303     offerSigner = _offerSigner;
304     lifToken = ERC20(_lifToken);
305     totalNights = _totalNights;
306     endBookings = _endBookings;
307   }
308 
309   /**
310    * @dev Change the signer or lif token addresses, only called by owner
311    * @param _offerSigner Address of the account that will sign offers
312    * @param _lifToken Address of the Lif token contract
313    */
314   function edit(address _offerSigner, address _lifToken) onlyOwner public {
315     require(_offerSigner != address(0));
316     require(_lifToken != address(0));
317     offerSigner = _offerSigner;
318     lifToken = ERC20(_lifToken);
319   }
320 
321   /**
322    * @dev Add a refund policy
323    * @param _beforeTime The time before this refund can be executed
324    * @param _dividedBy The divisor of the payment value
325    */
326   function addRefund(uint256 _beforeTime, uint8 _dividedBy) onlyOwner public {
327     if (refunds.length > 0)
328       require(refunds[refunds.length-1].beforeTime > _beforeTime);
329     refunds.push(Refund(_beforeTime, _dividedBy));
330   }
331 
332   /**
333    * @dev Change a refund policy
334    * @param _beforeTime The time before this refund can be executed
335    * @param _dividedBy The divisor of the payment value
336    */
337   function changeRefund(
338     uint8 _refundIndex, uint256 _beforeTime, uint8 _dividedBy
339   ) onlyOwner public {
340     if (_refundIndex > 0)
341       require(refunds[_refundIndex-1].beforeTime > _beforeTime);
342     refunds[_refundIndex].beforeTime = _beforeTime;
343     refunds[_refundIndex].dividedBy = _dividedBy;
344   }
345 
346   /**
347    * @dev Increase the amount of rooms offered, only called by owner
348    * @param roomType The room type to be added
349    * @param amount The amount of rooms to be increased
350    */
351   function addRooms(string roomType, uint256 amount) onlyOwner public {
352     rooms[roomType].totalRooms = rooms[roomType].totalRooms.add(amount);
353     emit RoomsAdded(roomType, amount);
354   }
355 
356   /**
357    * @dev Book a room for a certain address, internal function
358    * @param roomType The room type to be booked
359    * @param _nights The nights that we want to book
360    * @param room The room that wants to be booked
361    * @param guest The address of the guest that will book the room
362    */
363   function bookRoom(
364     string roomType, uint256[] _nights, uint256 room,
365     address guest, bytes32 bookingHash, uint256 weiPerNight, bool isEther
366   ) internal {
367     for (uint i = 0; i < _nights.length; i ++) {
368       rooms[roomType].nights[_nights[i]][room].guest = guest;
369       rooms[roomType].nights[_nights[i]][room].bookingHash = bookingHash;
370       rooms[roomType].nights[_nights[i]][room].payed = weiPerNight;
371       rooms[roomType].nights[_nights[i]][room].isEther = isEther;
372     }
373     emit BookingDone(roomType, _nights, room, guest, bookingHash);
374   }
375 
376   event log(uint256 msg);
377 
378   /**
379    * @dev Cancel a booking
380    * @param roomType The room type to be booked
381    * @param _nights The nights that we want to book
382    * @param room The room that wants to be booked
383    */
384   function cancelBooking(
385     string roomType, uint256[] _nights,
386     uint256 room, bytes32 bookingHash, bool isEther
387   ) public {
388 
389     // Check the booking and delete it
390     uint256 totalPayed = 0;
391     for (uint i = 0; i < _nights.length; i ++) {
392       require(rooms[roomType].nights[_nights[i]][room].guest == msg.sender);
393       require(rooms[roomType].nights[_nights[i]][room].isEther == isEther);
394       require(rooms[roomType].nights[_nights[i]][room].bookingHash == bookingHash);
395       totalPayed = totalPayed.add(
396         rooms[roomType].nights[_nights[i]][room].payed
397       );
398       delete rooms[roomType].nights[_nights[i]][room];
399     }
400 
401     // Calculate refund amount
402     uint256 refundAmount = 0;
403     for (i = 0; i < refunds.length; i ++) {
404       if (now < endBookings.sub(refunds[i].beforeTime)){
405         refundAmount = totalPayed.div(refunds[i].dividedBy);
406         break;
407       }
408     }
409 
410     // Forward refund funds
411     if (isEther)
412       msg.sender.transfer(refundAmount);
413     else
414       lifToken.transfer(msg.sender, refundAmount);
415 
416     emit BookingCanceled(roomType, _nights, room, msg.sender, bookingHash);
417   }
418 
419   /**
420    * @dev Withdraw tokens and eth, only from owner contract
421    */
422   function withdraw() public onlyOwner {
423     require(now > endBookings);
424     lifToken.transfer(owner, lifToken.balanceOf(address(this)));
425     owner.transfer(address(this).balance);
426   }
427 
428   /**
429    * @dev Book a room paying with ETH
430    * @param pricePerNight The price per night in wei
431    * @param offerTimestamp The timestamp of when the offer ends
432    * @param offerSignature The signature provided by the offer signer
433    * @param roomType The room type that the guest wants to book
434    * @param _nights The nights that the guest wants to book
435    */
436   function bookWithEth(
437     uint256 pricePerNight,
438     uint256 offerTimestamp,
439     bytes offerSignature,
440     string roomType,
441     uint256[] _nights,
442     bytes32 bookingHash
443   ) public payable {
444     // Check that the offer is still valid
445     require(offerTimestamp < now);
446     require(now < endBookings);
447 
448     // Check the eth sent
449     require(pricePerNight.mul(_nights.length) <= msg.value);
450 
451     // Check if there is at least one room available
452     uint256 available = firstRoomAvailable(roomType, _nights);
453     require(available > 0);
454 
455     // Check the signer of the offer is the right address
456     bytes32 priceSigned = keccak256(abi.encodePacked(
457       roomType, pricePerNight, offerTimestamp, "eth", bookingHash
458     )).toEthSignedMessageHash();
459     require(offerSigner == priceSigned.recover(offerSignature));
460 
461     // Assign the available room to the guest
462     bookRoom(
463       roomType, _nights, available, msg.sender,
464       bookingHash, pricePerNight, true
465     );
466   }
467 
468   /**
469    * @dev Book a room paying with Lif
470    * @param pricePerNight The price per night in wei
471    * @param offerTimestamp The timestamp of when the offer ends
472    * @param offerSignature The signature provided by the offer signer
473    * @param roomType The room type that the guest wants to book
474    * @param _nights The nights that the guest wants to book
475    */
476   function bookWithLif(
477     uint256 pricePerNight,
478     uint256 offerTimestamp,
479     bytes offerSignature,
480     string roomType,
481     uint256[] _nights,
482     bytes32 bookingHash
483   ) public {
484     // Check that the offer is still valid
485     require(offerTimestamp < now);
486 
487     // Check the amount of lifTokens allowed to be spent by this contract
488     uint256 lifTokenAllowance = lifToken.allowance(msg.sender, address(this));
489     require(pricePerNight.mul(_nights.length) <= lifTokenAllowance);
490 
491     // Check if there is at least one room available
492     uint256 available = firstRoomAvailable(roomType, _nights);
493     require(available > 0);
494 
495     // Check the signer of the offer is the right address
496     bytes32 priceSigned = keccak256(abi.encodePacked(
497       roomType, pricePerNight, offerTimestamp, "lif", bookingHash
498     )).toEthSignedMessageHash();
499     require(offerSigner == priceSigned.recover(offerSignature));
500 
501     // Assign the available room to the guest
502     bookRoom(
503       roomType, _nights, available, msg.sender,
504       bookingHash, pricePerNight, false
505     );
506 
507     // Transfer the lifTokens to booking
508     lifToken.transferFrom(msg.sender, address(this), lifTokenAllowance);
509   }
510 
511   /**
512    * @dev Get the total rooms for a room type
513    * @param roomType The room type that wants to be booked
514    */
515   function totalRooms(string roomType) view public returns (uint256) {
516     return rooms[roomType].totalRooms;
517   }
518 
519   /**
520    * @dev Get a booking information
521    * @param roomType The room type
522    * @param room The room booked
523    * @param night The night of the booking
524    */
525   function getBooking(
526     string roomType, uint256 room, uint256 night
527   ) view public returns (address, uint256, bytes32, bool) {
528     return (
529       rooms[roomType].nights[night][room].guest,
530       rooms[roomType].nights[night][room].payed,
531       rooms[roomType].nights[night][room].bookingHash,
532       rooms[roomType].nights[night][room].isEther
533     );
534   }
535 
536   /**
537    * @dev Get the availability of a specific room
538    * @param roomType The room type that wants to be booked
539    * @param _nights The nights to check availability
540    * @param room The room that wants to be booked
541    * @return bool If the room is available or not
542    */
543   function roomAvailable(
544     string roomType, uint256[] _nights, uint256 room
545   ) view public returns (bool) {
546     require(room <= rooms[roomType].totalRooms);
547     for (uint i = 0; i < _nights.length; i ++) {
548       require(_nights[i] <= totalNights);
549       if (rooms[roomType].nights[_nights[i]][room].guest != address(0))
550         return false;
551       }
552     return true;
553   }
554 
555   /**
556    * @dev Get the available rooms for certain nights
557    * @param roomType The room type that wants to be booked
558    * @param _nights The nights to check availability
559    * @return uint256 Array of the rooms available for that nights
560    */
561   function roomsAvailable(
562     string roomType, uint256[] _nights
563   ) view public returns (uint256[]) {
564     require(_nights[i] <= totalNights);
565     uint256[] memory available = new uint256[](rooms[roomType].totalRooms);
566     for (uint z = 1; z <= rooms[roomType].totalRooms; z ++) {
567       available[z-1] = z;
568       for (uint i = 0; i < _nights.length; i ++)
569         if (rooms[roomType].nights[_nights[i]][z].guest != address(0)) {
570           available[z-1] = 0;
571           break;
572         }
573     }
574     return available;
575   }
576 
577   /**
578    * @dev Get the first available room for certain nights
579    * @param roomType The room type that wants to be booked
580    * @param _nights The nights to check availability
581    * @return uint256 The first available room
582    */
583   function firstRoomAvailable(
584     string roomType, uint256[] _nights
585   ) internal returns (uint256) {
586     require(_nights[i] <= totalNights);
587     uint256 available = 0;
588     bool isAvailable;
589     for (uint z = rooms[roomType].totalRooms; z >= 1 ; z --) {
590       isAvailable = true;
591       for (uint i = 0; i < _nights.length; i ++) {
592         if (rooms[roomType].nights[_nights[i]][z].guest != address(0))
593           isAvailable = false;
594           break;
595         }
596       if (isAvailable)
597         available = z;
598     }
599     return available;
600   }
601 
602 }