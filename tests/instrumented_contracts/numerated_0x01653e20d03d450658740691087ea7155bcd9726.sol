1 pragma solidity ^0.4.24;
2 
3 interface F3DexternalSettingsInterface {
4     function getFastGap() external returns(uint256);
5     function getLongGap() external returns(uint256);
6     function getFastExtra() external returns(uint256);
7     function getLongExtra() external returns(uint256);
8 }
9 
10 interface FundForwarderInterface {
11     function deposit() external payable returns(bool);
12     function status() external view returns(address, address, bool);
13     function startMigration(address _newCorpBank) external returns(bool);
14     function cancelMigration() external returns(bool);
15     function finishMigration() external returns(bool);
16     function setup(address _firstCorpBank) external;
17 }
18 
19 interface FundInterfaceForForwarder {
20     function deposit(address _addr) external payable returns (bool);
21     function migrationReceiver_setup() external returns (bool);
22 }
23 
24 interface HourglassInterface {
25     function() payable external;
26     function buy(address _playerAddress) payable external returns(uint256);
27     function sell(uint256 _amountOfTokens) external;
28     function reinvest() external;
29     function withdraw() external;
30     function exit() external;
31     function dividendsOf(address _playerAddress) external view returns(uint256);
32     function balanceOf(address _playerAddress) external view returns(uint256);
33     function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
34     function stakingRequirement() external view returns(uint256);
35 }
36 
37 interface otherFoMo3D {
38     function potSwap() external payable;
39 }
40 
41 interface PlayerBookInterface {
42     function getPlayerID(address _addr) external returns (uint256);
43     function getPlayerName(uint256 _pID) external view returns (bytes32);
44     function getPlayerLAff(uint256 _pID) external view returns (uint256);
45     function getPlayerAddr(uint256 _pID) external view returns (address);
46     function getNameFee() external view returns (uint256);
47     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
48     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
49     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
50 }
51 
52 interface PlayerBookReceiverInterface {
53     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
54     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
55 }
56 
57 
58 interface TeamInterface {
59     function requiredSignatures() external view returns(uint256);
60     function requiredDevSignatures() external view returns(uint256);
61     function adminCount() external view returns(uint256);
62     function devCount() external view returns(uint256);
63     function adminName(address _who) external view returns(bytes32);
64     function isAdmin(address _who) external view returns(bool);
65     function isDev(address _who) external view returns(bool);
66 }
67 
68 //==============================================================================
69 //   __|_ _    __|_ _  .
70 //  _\ | | |_|(_ | _\  .
71 //==============================================================================
72 library F3Ddatasets {
73     //compressedData key
74     // [76-33][32][31][30][29][28-18][17][16-6][5-3][2][1][0]
75         // 0 - new player (bool)
76         // 1 - joined round (bool)
77         // 2 - new  leader (bool)
78         // 3-5 - air drop tracker (uint 0-999)
79         // 6-16 - round end time
80         // 17 - winnerTeam
81         // 18 - 28 timestamp 
82         // 29 - team
83         // 30 - 0 = reinvest (round), 1 = buy (round), 2 = buy (ico), 3 = reinvest (ico)
84         // 31 - airdrop happened bool
85         // 32 - airdrop tier 
86         // 33 - airdrop amount won
87     //compressedIDs key
88     // [77-52][51-26][25-0]
89         // 0-25 - pID 
90         // 26-51 - winPID
91         // 52-77 - rID
92     struct EventReturns {
93         uint256 compressedData;
94         uint256 compressedIDs;
95         address winnerAddr;         // winner address
96         bytes32 winnerName;         // winner name
97         uint256 amountWon;          // amount won
98         uint256 newPot;             // amount in new pot
99         uint256 P3DAmount;          // amount distributed to p3d
100         uint256 genAmount;          // amount distributed to gen
101         uint256 potAmount;          // amount added to pot
102     }
103     struct Player {
104         address addr;   // player address
105         bytes32 name;   // player name
106         uint256 win;    // winnings vault
107         uint256 gen;    // general vault
108         uint256 aff;    // affiliate vault
109         uint256 lrnd;   // last round played
110         uint256 laff;   // last affiliate id used
111     }
112     struct PlayerRounds {
113         uint256 eth;    // eth player has added to round (used for eth limiter)
114         uint256 keys;   // keys
115         uint256 mask;   // player mask 
116         uint256 ico;    // ICO phase investment
117     }
118     struct Round {
119         uint256 plyr;   // pID of player in lead， 幸运儿
120         uint256 team;   // tID of team in lead
121         uint256 end;    // time ends/ended
122         bool ended;     // has round end function been ran  这个开关值得研究下
123         uint256 strt;   // time round started
124         uint256 keys;   // keys
125         uint256 eth;    // total eth in
126         uint256 pot;    // eth to pot (during round) / final amount paid to winner (after round ends)
127         uint256 mask;   // global mask
128         uint256 ico;    // total eth sent in during ICO phase
129         uint256 icoGen; // total eth for gen during ICO phase
130         uint256 icoAvg; // average key price for ICO phase
131     }
132     
133     struct TeamFee {
134         uint256 gen;    // % of buy in thats paid to key holders of current round
135         uint256 p3d;    // % of buy in thats paid to p3d holders
136     }
137     struct PotSplit {
138         uint256 gen;    // % of pot thats paid to key holders of current round
139         uint256 p3d;    // % of pot thats paid to p3d holders
140     }
141 }
142 
143 /**
144  * @title SafeMath v0.1.9
145  * @dev Math operations with safety checks that throw on error
146  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
147  * - added sqrt
148  * - added sq
149  * - added pwr 
150  * - changed asserts to requires with error log outputs
151  * - removed div, its useless
152  */
153 library SafeMath {
154     
155     /**
156     * @dev Multiplies two numbers, throws on overflow.
157     */
158     function mul(uint256 a, uint256 b) 
159         internal 
160         pure 
161         returns (uint256 c) 
162     {
163         if (a == 0) {
164             return 0;
165         }
166         c = a * b;
167         require(c / a == b, "SafeMath mul failed");
168         return c;
169     }
170 
171     /**
172     * @dev Integer division of two numbers, truncating the quotient.
173     */
174     function div(uint256 a, uint256 b) internal pure returns (uint256) {
175         // assert(b > 0); // Solidity automatically throws when dividing by 0
176         uint256 c = a / b;
177         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
178         return c;
179     }
180     
181     /**
182     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
183     */
184     function sub(uint256 a, uint256 b)
185         internal
186         pure
187         returns (uint256) 
188     {
189         require(b <= a, "SafeMath sub failed");
190         return a - b;
191     }
192 
193     /**
194     * @dev Adds two numbers, throws on overflow.
195     */
196     function add(uint256 a, uint256 b)
197         internal
198         pure
199         returns (uint256 c) 
200     {
201         c = a + b;
202         require(c >= a, "SafeMath add failed");
203         return c;
204     }
205     
206     /**
207      * @dev gives square root of given x.
208      */
209     function sqrt(uint256 x)
210         internal
211         pure
212         returns (uint256 y) 
213     {
214         uint256 z = ((add(x,1)) / 2);
215         y = x;
216         while (z < y) 
217         {
218             y = z;
219             z = ((add((x / z),z)) / 2);
220         }
221     }
222     
223     /**
224      * @dev gives square. multiplies x by x
225      */
226     function sq(uint256 x)
227         internal
228         pure
229         returns (uint256)
230     {
231         return (mul(x,x));
232     }
233     
234     /**
235      * @dev x to the power of y 
236      */
237     function pwr(uint256 x, uint256 y)
238         internal 
239         pure 
240         returns (uint256)
241     {
242         if (x==0)
243             return (0);
244         else if (y==0)
245             return (1);
246         else 
247         {
248             uint256 z = x;
249             for (uint256 i=1; i < y; i++)
250                 z = mul(z,x);
251             return (z);
252         }
253     }
254 }
255 
256 library NameFilter {
257     /**
258      * @dev filters name strings
259      * -converts uppercase to lower case.  
260      * -makes sure it does not start/end with a space
261      * -makes sure it does not contain multiple spaces in a row
262      * -cannot be only numbers
263      * -cannot start with 0x 
264      * -restricts characters to A-Z, a-z, 0-9, and space.
265      * @return reprocessed string in bytes32 format
266      */
267     function nameFilter(string _input)
268         internal
269         pure
270         returns(bytes32)
271     {
272         bytes memory _temp = bytes(_input);
273         uint256 _length = _temp.length;
274         
275         //sorry limited to 32 characters
276         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
277         // make sure it doesnt start with or end with space
278         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
279         // make sure first two characters are not 0x
280         if (_temp[0] == 0x30)
281         {
282             require(_temp[1] != 0x78, "string cannot start with 0x");
283             require(_temp[1] != 0x58, "string cannot start with 0X");
284         }
285         
286         // create a bool to track if we have a non number character
287         bool _hasNonNumber;
288         
289         // convert & check
290         for (uint256 i = 0; i < _length; i++)
291         {
292             // if its uppercase A-Z
293             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
294             {
295                 // convert to lower case a-z
296                 _temp[i] = byte(uint(_temp[i]) + 32);
297                 
298                 // we have a non number
299                 if (_hasNonNumber == false)
300                     _hasNonNumber = true;
301             } else {
302                 require
303                 (
304                     // require character is a space
305                     _temp[i] == 0x20 || 
306                     // OR lowercase a-z
307                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
308                     // or 0-9
309                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
310                     "string contains invalid characters"
311                 );
312                 // make sure theres not 2x spaces in a row
313                 if (_temp[i] == 0x20)
314                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
315                 
316                 // see if we have a character other than a number
317                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
318                     _hasNonNumber = true;    
319             }
320         }
321         
322         require(_hasNonNumber == true, "string cannot be only numbers");
323         
324         bytes32 _ret;
325         assembly {
326             _ret := mload(add(_temp, 32))
327         }
328         return (_ret);
329     }
330 }
331 
332 /** @title -MSFun- v0.2.4
333  *  
334  *         ┌──────────────────────────────────────────────────────────────────────┐
335  *         │ MSFun, is an importable library that gives your contract the ability │
336  *         │ add multiSig requirement to functions.                               │
337  *         └──────────────────────────────────────────────────────────────────────┘
338  *                                ┌────────────────────┐
339  *                                │ Setup Instructions │
340  *                                └────────────────────┘
341  * (Step 1) import the library into your contract
342  * 
343  *    import "./MSFun.sol";
344  *
345  * (Step 2) set up the signature data for msFun
346  * 
347  *     MSFun.Data private msData;
348  *                                ┌────────────────────┐
349  *                                │ Usage Instructions │
350  *                                └────────────────────┘
351  * at the beginning of a function
352  * 
353  *     function functionName() 
354  *     {
355  *         if (MSFun.multiSig(msData, required signatures, "functionName") == true)
356  *         {
357  *             MSFun.deleteProposal(msData, "functionName");
358  * 
359  *             // put function body here 
360  *         }
361  *     }
362  *                           ┌────────────────────────────────┐
363  *                           │ Optional Wrappers For TeamJust │
364  *                           └────────────────────────────────┘
365  * multiSig wrapper function (cuts down on inputs, improves readability)
366  * this wrapper is HIGHLY recommended
367  * 
368  *     function multiSig(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamJust.requiredSignatures(), _whatFunction));}
369  *     function multiSigDev(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamJust.requiredDevSignatures(), _whatFunction));}
370  *
371  * wrapper for delete proposal (makes code cleaner)
372  *     
373  *     function deleteProposal(bytes32 _whatFunction) private {MSFun.deleteProposal(msData, _whatFunction);}
374  *                             ┌────────────────────────────┐
375  *                             │ Utility & Vanity Functions │
376  *                             └────────────────────────────┘
377  * delete any proposal is highly recommended.  without it, if an admin calls a multiSig
378  * function, with argument inputs that the other admins do not agree upon, the function
379  * can never be executed until the undesirable arguments are approved.
380  * 
381  *     function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}
382  * 
383  * for viewing who has signed a proposal & proposal data
384  *     
385  *     function checkData(bytes32 _whatFunction) onlyAdmins() public view returns(bytes32, uint256) {return(MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}
386  *
387  * lets you check address of up to 3 signers (address)
388  * 
389  *     function checkSignersByAddress(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyAdmins() public view returns(address, address, address) {return(MSFun.checkSigner(msData, _whatFunction, _signerA), MSFun.checkSigner(msData, _whatFunction, _signerB), MSFun.checkSigner(msData, _whatFunction, _signerC));}
390  *
391  * same as above but will return names in string format.
392  *
393  *     function checkSignersByName(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyAdmins() public view returns(bytes32, bytes32, bytes32) {return(TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerA)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerB)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerC)));}
394  *                             ┌──────────────────────────┐
395  *                             │ Functions In Depth Guide │
396  *                             └──────────────────────────┘
397  * In the following examples, the Data is the proposal set for this library.  And
398  * the bytes32 is the name of the function.
399  *
400  * MSFun.multiSig(Data, uint256, bytes32) - Manages creating/updating multiSig 
401  *      proposal for the function being called.  The uint256 is the required 
402  *      number of signatures needed before the multiSig will return true.  
403  *      Upon first call, multiSig will create a proposal and store the arguments 
404  *      passed with the function call as msgData.  Any admins trying to sign the 
405  *      function call will need to send the same argument values. Once required
406  *      number of signatures is reached this will return a bool of true.
407  * 
408  * MSFun.deleteProposal(Data, bytes32) - once multiSig unlocks the function body,
409  *      you will want to delete the proposal data.  This does that.
410  *
411  * MSFun.checkMsgData(Data, bytes32) - checks the message data for any given proposal 
412  * 
413  * MSFun.checkCount(Data, bytes32) - checks the number of admins that have signed
414  *      the proposal 
415  * 
416  * MSFun.checkSigners(data, bytes32, uint256) - checks the address of a given signer.
417  *      the uint256, is the log number of the signer (ie 1st signer, 2nd signer)
418  */
419 
420 library MSFun {
421     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
422     // DATA SETS
423     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
424     // contact data setup
425     struct Data 
426     {
427         mapping (bytes32 => ProposalData) proposal_;  
428     }
429     struct ProposalData 
430     {
431         // a hash of msg.data 
432         bytes32 msgData;
433         // number of signers
434         uint256 count;
435         // tracking of wither admins have signed
436         mapping (address => bool) admin;
437         // list of admins who have signed
438         mapping (uint256 => address) log;
439     }
440     
441     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
442     // MULTI SIG FUNCTIONS
443     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
444     function multiSig(Data storage self, uint256 _requiredSignatures, bytes32 _whatFunction)
445         internal
446         returns(bool) 
447     {
448         // our proposal key will be a hash of our function name + our contracts address 
449         // by adding our contracts address to this, we prevent anyone trying to circumvent
450         // the proposal's security via external calls.
451         bytes32 _whatProposal = whatProposal(_whatFunction);
452         
453         // this is just done to make the code more readable.  grabs the signature count
454         uint256 _currentCount = self.proposal_[_whatProposal].count;
455         
456         // store the address of the person sending the function call.  we use msg.sender 
457         // here as a layer of security.  in case someone imports our contract and tries to 
458         // circumvent function arguments.  still though, our contract that imports this
459         // library and calls multisig, needs to use onlyAdmin modifiers or anyone who
460         // calls the function will be a signer. 
461         address _whichAdmin = msg.sender;
462         
463         // prepare our msg data.  by storing this we are able to verify that all admins
464         // are approving the same argument input to be executed for the function.  we hash 
465         // it and store in bytes32 so its size is known and comparable
466         bytes32 _msgData = keccak256(msg.data);
467         
468         // check to see if this is a new execution of this proposal or not
469         if (_currentCount == 0)
470         {
471             // if it is, lets record the original signers data
472             self.proposal_[_whatProposal].msgData = _msgData;
473             
474             // record original senders signature
475             self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
476             
477             // update log (used to delete records later, and easy way to view signers)
478             // also useful if the calling function wants to give something to a 
479             // specific signer.  
480             self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
481             
482             // track number of signatures
483             self.proposal_[_whatProposal].count += 1;  
484             
485             // if we now have enough signatures to execute the function, lets
486             // return a bool of true.  we put this here in case the required signatures
487             // is set to 1.
488             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
489                 return(true);
490             }            
491         // if its not the first execution, lets make sure the msgData matches
492         } else if (self.proposal_[_whatProposal].msgData == _msgData) {
493             // msgData is a match
494             // make sure admin hasnt already signed
495             if (self.proposal_[_whatProposal].admin[_whichAdmin] == false) 
496             {
497                 // record their signature
498                 self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
499                 
500                 // update log (used to delete records later, and easy way to view signers)
501                 self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
502                 
503                 // track number of signatures
504                 self.proposal_[_whatProposal].count += 1;  
505             }
506             
507             // if we now have enough signatures to execute the function, lets
508             // return a bool of true.
509             // we put this here for a few reasons.  (1) in normal operation, if 
510             // that last recorded signature got us to our required signatures.  we 
511             // need to return bool of true.  (2) if we have a situation where the 
512             // required number of signatures was adjusted to at or lower than our current 
513             // signature count, by putting this here, an admin who has already signed,
514             // can call the function again to make it return a true bool.  but only if
515             // they submit the correct msg data
516             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
517                 return(true);
518             }
519         }
520     }
521     
522     
523     // deletes proposal signature data after successfully executing a multiSig function
524     function deleteProposal(Data storage self, bytes32 _whatFunction)
525         internal
526     {
527         //done for readability sake
528         bytes32 _whatProposal = whatProposal(_whatFunction);
529         address _whichAdmin;
530         
531         //delete the admins votes & log.   i know for loops are terrible.  but we have to do this 
532         //for our data stored in mappings.  simply deleting the proposal itself wouldn't accomplish this.
533         for (uint256 i=0; i < self.proposal_[_whatProposal].count; i++) {
534             _whichAdmin = self.proposal_[_whatProposal].log[i];
535             delete self.proposal_[_whatProposal].admin[_whichAdmin];
536             delete self.proposal_[_whatProposal].log[i];
537         }
538         //delete the rest of the data in the record
539         delete self.proposal_[_whatProposal];
540     }
541     
542     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
543     // HELPER FUNCTIONS
544     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
545 
546     function whatProposal(bytes32 _whatFunction)
547         private
548         view
549         returns(bytes32)
550     {
551         return(keccak256(abi.encodePacked(_whatFunction,this)));
552     }
553     
554     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
555     // VANITY FUNCTIONS
556     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
557     // returns a hashed version of msg.data sent by original signer for any given function
558     function checkMsgData (Data storage self, bytes32 _whatFunction)
559         internal
560         view
561         returns (bytes32 msg_data)
562     {
563         bytes32 _whatProposal = whatProposal(_whatFunction);
564         return (self.proposal_[_whatProposal].msgData);
565     }
566     
567     // returns number of signers for any given function
568     function checkCount (Data storage self, bytes32 _whatFunction)
569         internal
570         view
571         returns (uint256 signature_count)
572     {
573         bytes32 _whatProposal = whatProposal(_whatFunction);
574         return (self.proposal_[_whatProposal].count);
575     }
576     
577     // returns address of an admin who signed for any given function
578     function checkSigner (Data storage self, bytes32 _whatFunction, uint256 _signer)
579         internal
580         view
581         returns (address signer)
582     {
583         require(_signer > 0, "MSFun checkSigner failed - 0 not allowed");
584         bytes32 _whatProposal = whatProposal(_whatFunction);
585         return (self.proposal_[_whatProposal].log[_signer - 1]);
586     }
587 }
588 
589 
590 //==============================================================================
591 //  |  _      _ _ | _  .
592 //  |<(/_\/  (_(_||(_  .
593 //=======/======================================================================
594 library F3DKeysCalcLong {
595     using SafeMath for *;
596     /**
597      * @dev calculates number of keys received given X eth 
598      * @param _curEth current amount of eth in contract 
599      * @param _newEth eth being spent
600      * @return amount of ticket purchased
601      */
602     function keysRec(uint256 _curEth, uint256 _newEth)
603         internal
604         pure
605         returns (uint256)
606     {
607         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
608     }
609     
610     /**
611      * @dev calculates amount of eth received if you sold X keys 
612      * @param _curKeys current amount of keys that exist 
613      * @param _sellKeys amount of keys you wish to sell
614      * @return amount of eth received
615      */
616     function ethRec(uint256 _curKeys, uint256 _sellKeys)
617         internal
618         pure
619         returns (uint256)
620     {
621         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
622     }
623 
624     /**
625      * @dev calculates how many keys would exist with given an amount of eth
626      * @param _eth eth "in contract"
627      * @return number of keys that would exist
628      */
629     function keys(uint256 _eth) 
630         internal
631         pure
632         returns(uint256)
633     {
634         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
635     }
636     
637     /**
638      * @dev calculates how much eth would be in contract given a number of keys
639      * @param _keys number of keys "in contract" 
640      * @return eth that would exists
641      */
642     function eth(uint256 _keys) 
643         internal
644         pure
645         returns(uint256)  
646     {
647         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
648     }
649 }
650 
651 library UintCompressor {
652     using SafeMath for *;
653     
654     function insert(uint256 _var, uint256 _include, uint256 _start, uint256 _end)
655         internal
656         pure
657         returns(uint256)
658     {
659         // check conditions 
660         require(_end < 77 && _start < 77, "start/end must be less than 77");
661         require(_end >= _start, "end must be >= start");
662         
663         // format our start/end points
664         _end = exponent(_end).mul(10);
665         _start = exponent(_start);
666         
667         // check that the include data fits into its segment 
668         require(_include < (_end / _start));
669         
670         // build middle
671         if (_include > 0)
672             _include = _include.mul(_start);
673         
674         return((_var.sub((_var / _start).mul(_start))).add(_include).add((_var / _end).mul(_end)));
675     }
676     
677     function extract(uint256 _input, uint256 _start, uint256 _end)
678 	    internal
679 	    pure
680 	    returns(uint256)
681     {
682         // check conditions
683         require(_end < 77 && _start < 77, "start/end must be less than 77");
684         require(_end >= _start, "end must be >= start");
685         
686         // format our start/end points
687         _end = exponent(_end).mul(10);
688         _start = exponent(_start);
689         
690         // return requested section
691         return((((_input / _start).mul(_start)).sub((_input / _end).mul(_end))) / _start);
692     }
693     
694     function exponent(uint256 _position)
695         private
696         pure
697         returns(uint256)
698     {
699         return((10).pwr(_position));
700     }
701 }
702 
703 contract F3Devents {
704     // fired whenever a player registers a name
705     event onNewName
706     (
707         uint256 indexed playerID,
708         address indexed playerAddress,
709         bytes32 indexed playerName,
710         bool isNewPlayer,
711         uint256 affiliateID,
712         address affiliateAddress,
713         bytes32 affiliateName,
714         uint256 amountPaid,
715         uint256 timeStamp
716     );
717     
718     // fired at end of buy or reload
719     event onEndTx
720     (
721         uint256 compressedData,     
722         uint256 compressedIDs,      
723         bytes32 playerName,
724         address playerAddress,
725         uint256 ethIn,
726         uint256 keysBought,
727         address winnerAddr,
728         bytes32 winnerName,
729         uint256 amountWon,
730         uint256 newPot,
731         uint256 P3DAmount,
732         uint256 genAmount,
733         uint256 potAmount,
734         uint256 airDropPot
735     );
736     
737 	// fired whenever theres a withdraw
738     event onWithdraw
739     (
740         uint256 indexed playerID,
741         address playerAddress,
742         bytes32 playerName,
743         uint256 ethOut,
744         uint256 timeStamp
745     );
746     
747     // fired whenever a withdraw forces end round to be ran
748     event onWithdrawAndDistribute
749     (
750         address playerAddress,
751         bytes32 playerName,
752         uint256 ethOut,
753         uint256 compressedData,
754         uint256 compressedIDs,
755         address winnerAddr,
756         bytes32 winnerName,
757         uint256 amountWon,
758         uint256 newPot,
759         uint256 P3DAmount,
760         uint256 genAmount
761     );
762     
763     // (fomo3d long only) fired whenever a player tries a buy after round timer 
764     // hit zero, and causes end round to be ran.
765     event onBuyAndDistribute
766     (
767         address playerAddress,
768         bytes32 playerName,
769         uint256 ethIn,
770         uint256 compressedData,
771         uint256 compressedIDs,
772         address winnerAddr,
773         bytes32 winnerName,
774         uint256 amountWon,
775         uint256 newPot,
776         uint256 P3DAmount,
777         uint256 genAmount
778     );
779     
780     // (fomo3d long only) fired whenever a player tries a reload after round timer 
781     // hit zero, and causes end round to be ran.
782     event onReLoadAndDistribute
783     (
784         address playerAddress,
785         bytes32 playerName,
786         uint256 compressedData,
787         uint256 compressedIDs,
788         address winnerAddr,
789         bytes32 winnerName,
790         uint256 amountWon,
791         uint256 newPot,
792         uint256 P3DAmount,
793         uint256 genAmount
794     );
795     
796     // fired whenever an affiliate is paid
797     event onAffiliatePayout
798     (
799         uint256 indexed affiliateID,
800         address affiliateAddress,
801         bytes32 affiliateName,
802         uint256 indexed roundID,
803         uint256 indexed buyerID,
804         uint256 amount,
805         uint256 timeStamp
806     );
807     
808     // received pot swap deposit
809     event onPotSwapDeposit
810     (
811         uint256 roundID,
812         uint256 amountAddedToPot
813     );
814 }
815 
816 
817 contract FundForwarder {
818     string public name = "FundForwarder";
819     FundInterfaceForForwarder private currentCorpBank_;
820     address private newCorpBank_;
821     bool needsBank_ = true;
822     
823     constructor() 
824         public
825     {
826         //constructor does nothing.
827     }
828     
829     function()
830         public
831         payable
832     {
833         // done so that if any one tries to dump eth into this contract, we can
834         // just forward it to corp bank.
835         currentCorpBank_.deposit.value(address(this).balance)(address(currentCorpBank_));
836     }
837     
838     function deposit()
839         public 
840         payable
841         returns(bool)
842     {
843         require(msg.value > 0, "Forwarder Deposit failed - zero deposits not allowed");
844         require(needsBank_ == false, "Forwarder Deposit failed - no registered bank");
845         //wallet.transfer(toFund);
846         if (currentCorpBank_.deposit.value(msg.value)(msg.sender) == true)
847             return(true);
848         else
849             return(false);
850     }
851 //==============================================================================
852 //     _ _ . _  _ _ _|_. _  _   .
853 //    | | ||(_|| (_| | |(_)| |  .
854 //===========_|=================================================================    
855     function status()
856         public
857         view
858         returns(address, address, bool)
859     {
860         return(address(currentCorpBank_), address(newCorpBank_), needsBank_);
861     }
862 
863     function startMigration(address _newCorpBank)
864         external
865         returns(bool)
866     {
867         // make sure this is coming from current corp bank
868         require(msg.sender == address(currentCorpBank_), "Forwarder startMigration failed - msg.sender must be current corp bank");
869         
870         // communicate with the new corp bank and make sure it has the forwarder 
871         // registered 
872         if(FundInterfaceForForwarder(_newCorpBank).migrationReceiver_setup() == true)
873         {
874             // save our new corp bank address
875             newCorpBank_ = _newCorpBank;
876             return (true);
877         } else 
878             return (false);
879     }
880     
881     function cancelMigration()
882         external
883         returns(bool)
884     {
885         // make sure this is coming from the current corp bank (also lets us know 
886         // that current corp bank has not been killed)
887         require(msg.sender == address(currentCorpBank_), "Forwarder cancelMigration failed - msg.sender must be current corp bank");
888         
889         // erase stored new corp bank address;
890         newCorpBank_ = address(0x0);
891         
892         return (true);
893     }
894     
895     function finishMigration()
896         external
897         returns(bool)
898     {
899         // make sure its coming from new corp bank
900         require(msg.sender == newCorpBank_, "Forwarder finishMigration failed - msg.sender must be new corp bank");
901 
902         // update corp bank address        
903         currentCorpBank_ = (FundInterfaceForForwarder(newCorpBank_));
904         
905         // erase new corp bank address
906         newCorpBank_ = address(0x0);
907         
908         return (true);
909     }
910 //==============================================================================
911 //    . _ ._|_. _ |   _ _ _|_    _   .
912 //    || || | |(_||  _\(/_ | |_||_)  .  (this only runs once ever)
913 //==============================|===============================================
914     function setup(address _firstCorpBank)
915         external
916     {
917         require(needsBank_ == true, "Forwarder setup failed - corp bank already registered");
918         currentCorpBank_ = FundInterfaceForForwarder(_firstCorpBank);
919         needsBank_ = false;
920     }
921 }
922 
923 contract ModularLong is F3Devents {}
924 
925 
926 contract PlayerBook {
927     using NameFilter for string;
928     using SafeMath for uint256;
929 
930     address constant private DEV_1_ADDRESS = 0x7a9E13E044CB905957eA465488DabD5F5D34E2C4;
931     bytes32  constant private DEV_1_NAME = "master";
932 
933     
934     FundForwarderInterface constant private FundForwarderConst = FundForwarderInterface(0x5095072aEE46a39D0b3753184514ead86405780f);
935     TeamInterface constant private TeamJust = TeamInterface(0xf72848D3426d8dB71e52FAc6Df29585649bb7CBD);
936     
937     MSFun.Data private msData;
938 
939     function multiSigDev(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamJust.requiredDevSignatures(), _whatFunction));}
940     function deleteProposal(bytes32 _whatFunction) private {MSFun.deleteProposal(msData, _whatFunction);}
941     function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}
942     function checkData(bytes32 _whatFunction) onlyDevs() public view returns(bytes32, uint256) {return(MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}
943     function checkSignersByAddress(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyDevs() public view returns(address, address, address) {return(MSFun.checkSigner(msData, _whatFunction, _signerA), MSFun.checkSigner(msData, _whatFunction, _signerB), MSFun.checkSigner(msData, _whatFunction, _signerC));}
944     function checkSignersByName(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyDevs() public view returns(bytes32, bytes32, bytes32) {return(TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerA)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerB)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerC)));}
945 //==============================================================================
946 //     _| _ _|_ _    _ _ _|_    _   .
947 //    (_|(_| | (_|  _\(/_ | |_||_)  .
948 //=============================|================================================    
949     uint256 public registrationFee_ = 10 finney;            // price to register a name
950 
951     // game 需要实现PlayerBookReceiverInterface的接口
952     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
953     mapping(address => bytes32) public gameNames_;          // lookup a games name
954     mapping(address => uint256) public gameIDs_;            // lokup a games ID
955     uint256 public gID_;        // total number of games
956     uint256 public pID_;        // total number of players
957     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
958     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
959     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
960     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
961     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
962     struct Player {
963         address addr;
964         bytes32 name;
965         uint256 laff;
966         uint256 names;
967     }
968 //==============================================================================
969 //     _ _  _  __|_ _    __|_ _  _  .
970 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
971 //==============================================================================    
972     constructor()
973         public
974     {
975         // premine the dev names (sorry not sorry)
976         // No keys are purchased with this method, it's simply locking our addresses,
977         // PID's and names for referral codes.
978         plyr_[1].addr = DEV_1_ADDRESS;
979         plyr_[1].name = DEV_1_NAME;
980         plyr_[1].names = 1;
981         pIDxAddr_[DEV_1_ADDRESS] = 1;
982         pIDxName_[DEV_1_NAME] = 1;
983         plyrNames_[1][DEV_1_NAME] = true;
984         plyrNameList_[1][1] = DEV_1_NAME;
985         
986         pID_ = 1;
987     }
988 //==============================================================================
989 //     _ _  _  _|. |`. _  _ _  .
990 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
991 //==============================================================================    
992     /**
993      * @dev prevents contracts from interacting with fomo3d 
994      */
995     modifier isHuman() {
996         address _addr = msg.sender;
997         uint256 _codeLength;
998         
999         assembly {_codeLength := extcodesize(_addr)}
1000         require(_codeLength == 0, "sorry humans only");
1001         _;
1002     }
1003     
1004     modifier onlyDevs() 
1005     {
1006         require(TeamJust.isDev(msg.sender) == true, "msg sender is not a dev");
1007         _;
1008     }
1009     
1010     modifier isRegisteredGame()
1011     {
1012         require(gameIDs_[msg.sender] != 0);
1013         _;
1014     }
1015 //==============================================================================
1016 //     _    _  _ _|_ _  .
1017 //    (/_\/(/_| | | _\  .
1018 //==============================================================================    
1019     // fired whenever a player registers a name
1020     event onNewName
1021     (
1022         uint256 indexed playerID,
1023         address indexed playerAddress,
1024         bytes32 indexed playerName,
1025         bool isNewPlayer,
1026         uint256 affiliateID,
1027         address affiliateAddress,
1028         bytes32 affiliateName,
1029         uint256 amountPaid,
1030         uint256 timeStamp
1031     );
1032 //==============================================================================
1033 //     _  _ _|__|_ _  _ _  .
1034 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
1035 //=====_|=======================================================================
1036     function checkIfNameValid(string _nameStr)
1037         public
1038         view
1039         returns(bool)
1040     {
1041         bytes32 _name = _nameStr.nameFilter();
1042         if (pIDxName_[_name] == 0)
1043             return (true);
1044         else 
1045             return (false);
1046     }
1047 //==============================================================================
1048 //     _    |_ |. _   |`    _  __|_. _  _  _  .
1049 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
1050 //====|=========================================================================    
1051     /**
1052      * @dev registers a name.  UI will always display the last name you registered.
1053      * but you will still own all previously registered names to use as affiliate 
1054      * links.
1055      * - must pay a registration fee.
1056      * - name must be unique
1057      * - names will be converted to lowercase
1058      * - name cannot start or end with a space 
1059      * - cannot have more than 1 space in a row
1060      * - cannot be only numbers
1061      * - cannot start with 0x 
1062      * - name must be at least 1 char
1063      * - max length of 32 characters long
1064      * - allowed characters: a-z, 0-9, and space
1065      * -functionhash- 0x921dec21 (using ID for affiliate)
1066      * -functionhash- 0x3ddd4698 (using address for affiliate)
1067      * -functionhash- 0x685ffd83 (using name for affiliate)
1068      * @param _nameString players desired name
1069      * @param _affCode affiliate ID, address, or name of who refered you
1070      * @param _all set to true if you want this to push your info to all games 
1071      * (this might cost a lot of gas)
1072      */
1073     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
1074         isHuman()
1075         public
1076         payable 
1077     {
1078         // make sure name fees paid
1079         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
1080         
1081         // filter name + condition checks
1082         bytes32 _name = NameFilter.nameFilter(_nameString);
1083         
1084         // set up address 
1085         address _addr = msg.sender;
1086         
1087         // set up our tx event data and determine if player is new or not
1088         bool _isNewPlayer = determinePID(_addr);
1089         
1090         // fetch player id
1091         uint256 _pID = pIDxAddr_[_addr];
1092         
1093         // manage affiliate residuals
1094         // if no affiliate code was given, no new affiliate code was given, or the 
1095         // player tried to use their own pID as an affiliate code, lolz
1096         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
1097         {
1098             // update last affiliate 
1099             plyr_[_pID].laff = _affCode;
1100         } else if (_affCode == _pID) {
1101             _affCode = 0;
1102         }
1103         
1104         // register name 
1105         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
1106     }
1107     
1108     function registerNameXaddr(string _nameString, address _affCode, bool _all)
1109         isHuman()
1110         public
1111         payable 
1112     {
1113         // make sure name fees paid
1114         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
1115         
1116         // filter name + condition checks
1117         bytes32 _name = NameFilter.nameFilter(_nameString);
1118         
1119         // set up address 
1120         address _addr = msg.sender;
1121         
1122         // set up our tx event data and determine if player is new or not
1123         bool _isNewPlayer = determinePID(_addr);
1124         
1125         // fetch player id
1126         uint256 _pID = pIDxAddr_[_addr];
1127         
1128         // manage affiliate residuals
1129         // if no affiliate code was given or player tried to use their own, lolz
1130         uint256 _affID;
1131         if (_affCode != address(0) && _affCode != _addr)
1132         {
1133             // get affiliate ID from aff Code 
1134             _affID = pIDxAddr_[_affCode];
1135             
1136             // if affID is not the same as previously stored 
1137             if (_affID != plyr_[_pID].laff)
1138             {
1139                 // update last affiliate
1140                 plyr_[_pID].laff = _affID;
1141             }
1142         }
1143         
1144         // register name 
1145         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
1146     }
1147     
1148     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
1149         isHuman()
1150         public
1151         payable 
1152     {
1153         // make sure name fees paid
1154         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
1155         
1156         // filter name + condition checks
1157         bytes32 _name = NameFilter.nameFilter(_nameString);
1158         
1159         // set up address 
1160         address _addr = msg.sender;
1161         
1162         // set up our tx event data and determine if player is new or not
1163         bool _isNewPlayer = determinePID(_addr);
1164         
1165         // fetch player id
1166         uint256 _pID = pIDxAddr_[_addr];
1167         
1168         // manage affiliate residuals
1169         // if no affiliate code was given or player tried to use their own, lolz
1170         uint256 _affID;
1171         if (_affCode != "" && _affCode != _name)
1172         {
1173             // get affiliate ID from aff Code 
1174             _affID = pIDxName_[_affCode];
1175             
1176             // if affID is not the same as previously stored 
1177             if (_affID != plyr_[_pID].laff)
1178             {
1179                 // update last affiliate
1180                 plyr_[_pID].laff = _affID;
1181             }
1182         }
1183         
1184         // register name 
1185         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
1186     }
1187     
1188     /**
1189      * @dev players, if you registered a profile, before a game was released, or
1190      * set the all bool to false when you registered, use this function to push
1191      * your profile to a single game.  also, if you've  updated your name, you
1192      * can use this to push your name to games of your choosing.
1193      * -functionhash- 0x81c5b206
1194      * @param _gameID game id 
1195      */
1196     function addMeToGame(uint256 _gameID)
1197         isHuman()
1198         public
1199     {
1200         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
1201         address _addr = msg.sender;
1202         uint256 _pID = pIDxAddr_[_addr];
1203         require(_pID != 0, "hey there buddy, you dont even have an account");
1204         uint256 _totalNames = plyr_[_pID].names;
1205         
1206         // add players profile and most recent name
1207         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
1208         
1209         // add list of all names
1210         if (_totalNames > 1)
1211             for (uint256 ii = 1; ii <= _totalNames; ii++)
1212                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
1213     }
1214     
1215     /**
1216      * @dev players, use this to push your player profile to all registered games.
1217      * -functionhash- 0x0c6940ea
1218      */
1219     function addMeToAllGames()
1220         isHuman()
1221         public
1222     {
1223         address _addr = msg.sender;
1224         uint256 _pID = pIDxAddr_[_addr];
1225         require(_pID != 0, "hey there buddy, you dont even have an account");
1226         uint256 _laff = plyr_[_pID].laff;
1227         uint256 _totalNames = plyr_[_pID].names;
1228         bytes32 _name = plyr_[_pID].name;
1229         
1230         for (uint256 i = 1; i <= gID_; i++)
1231         {
1232             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
1233             if (_totalNames > 1)
1234                 for (uint256 ii = 1; ii <= _totalNames; ii++)
1235                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
1236         }
1237                 
1238     }
1239     
1240     /**
1241      * @dev players use this to change back to one of your old names.  tip, you'll
1242      * still need to push that info to existing games.
1243      * -functionhash- 0xb9291296
1244      * @param _nameString the name you want to use 
1245      */
1246     function useMyOldName(string _nameString)
1247         isHuman()
1248         public 
1249     {
1250         // filter name, and get pID
1251         bytes32 _name = _nameString.nameFilter();
1252         uint256 _pID = pIDxAddr_[msg.sender];
1253         
1254         // make sure they own the name 
1255         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
1256         
1257         // update their current name 
1258         plyr_[_pID].name = _name;
1259     }
1260     
1261 //==============================================================================
1262 //     _ _  _ _   | _  _ . _  .
1263 //    (_(_)| (/_  |(_)(_||(_  . 
1264 //=====================_|=======================================================    
1265     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
1266         private
1267     {
1268         // if names already has been used, require that current msg sender owns the name
1269         if (pIDxName_[_name] != 0)
1270             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
1271         
1272         // add name to player profile, registry, and name book
1273         plyr_[_pID].name = _name;
1274         pIDxName_[_name] = _pID;
1275         if (plyrNames_[_pID][_name] == false)
1276         {
1277             plyrNames_[_pID][_name] = true;
1278             plyr_[_pID].names++;
1279             plyrNameList_[_pID][plyr_[_pID].names] = _name;
1280         }
1281         
1282         // registration fee goes directly to community rewards
1283         FundForwarderConst.deposit.value(address(this).balance)();
1284         
1285         // push player info to games
1286         if (_all == true)
1287             for (uint256 i = 1; i <= gID_; i++)
1288                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
1289         
1290         // fire event
1291         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
1292     }
1293 //==============================================================================
1294 //    _|_ _  _ | _  .
1295 //     | (_)(_)|_\  .
1296 //==============================================================================    
1297     function determinePID(address _addr)
1298         private
1299         returns (bool)
1300     {
1301         if (pIDxAddr_[_addr] == 0)
1302         {
1303             pID_++;
1304             pIDxAddr_[_addr] = pID_;
1305             plyr_[pID_].addr = _addr;
1306             
1307             // set the new player bool to true
1308             return (true);
1309         } else {
1310             return (false);
1311         }
1312     }
1313 //==============================================================================
1314 //   _   _|_ _  _ _  _ |   _ _ || _  .
1315 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
1316 //==============================================================================
1317     function getPlayerID(address _addr)
1318         isRegisteredGame()
1319         external
1320         returns (uint256)
1321     {
1322         determinePID(_addr);
1323         return (pIDxAddr_[_addr]);
1324     }
1325     function getPlayerName(uint256 _pID)
1326         external
1327         view
1328         returns (bytes32)
1329     {
1330         return (plyr_[_pID].name);
1331     }
1332     function getPlayerLAff(uint256 _pID)
1333         external
1334         view
1335         returns (uint256)
1336     {
1337         return (plyr_[_pID].laff);
1338     }
1339     function getPlayerAddr(uint256 _pID)
1340         external
1341         view
1342         returns (address)
1343     {
1344         return (plyr_[_pID].addr);
1345     }
1346     function getNameFee()
1347         external
1348         view
1349         returns (uint256)
1350     {
1351         return(registrationFee_);
1352     }
1353     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
1354         isRegisteredGame()
1355         external
1356         payable
1357         returns(bool, uint256)
1358     {
1359         // make sure name fees paid
1360         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
1361         
1362         // set up our tx event data and determine if player is new or not
1363         bool _isNewPlayer = determinePID(_addr);
1364         
1365         // fetch player id
1366         uint256 _pID = pIDxAddr_[_addr];
1367         
1368         // manage affiliate residuals
1369         // if no affiliate code was given, no new affiliate code was given, or the 
1370         // player tried to use their own pID as an affiliate code, lolz
1371         uint256 _affID = _affCode;
1372         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
1373         {
1374             // update last affiliate 
1375             plyr_[_pID].laff = _affID;
1376         } else if (_affID == _pID) {
1377             _affID = 0;
1378         }
1379         
1380         // register name 
1381         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
1382         
1383         return(_isNewPlayer, _affID);
1384     }
1385     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
1386         isRegisteredGame()
1387         external
1388         payable
1389         returns(bool, uint256)
1390     {
1391         // make sure name fees paid
1392         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
1393         
1394         // set up our tx event data and determine if player is new or not
1395         bool _isNewPlayer = determinePID(_addr);
1396         
1397         // fetch player id
1398         uint256 _pID = pIDxAddr_[_addr];
1399         
1400         // manage affiliate residuals
1401         // if no affiliate code was given or player tried to use their own, lolz
1402         uint256 _affID;
1403         if (_affCode != address(0) && _affCode != _addr)
1404         {
1405             // get affiliate ID from aff Code 
1406             _affID = pIDxAddr_[_affCode];
1407             
1408             // if affID is not the same as previously stored 
1409             if (_affID != plyr_[_pID].laff)
1410             {
1411                 // update last affiliate
1412                 plyr_[_pID].laff = _affID;
1413             }
1414         }
1415         
1416         // register name 
1417         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
1418         
1419         return(_isNewPlayer, _affID);
1420     }
1421     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
1422         isRegisteredGame()
1423         external
1424         payable
1425         returns(bool, uint256)
1426     {
1427         // make sure name fees paid
1428         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
1429         
1430         // set up our tx event data and determine if player is new or not
1431         bool _isNewPlayer = determinePID(_addr);
1432         
1433         // fetch player id
1434         uint256 _pID = pIDxAddr_[_addr];
1435         
1436         // manage affiliate residuals
1437         // if no affiliate code was given or player tried to use their own, lolz
1438         uint256 _affID;
1439         if (_affCode != "" && _affCode != _name)
1440         {
1441             // get affiliate ID from aff Code 
1442             _affID = pIDxName_[_affCode];
1443             
1444             // if affID is not the same as previously stored 
1445             if (_affID != plyr_[_pID].laff)
1446             {
1447                 // update last affiliate
1448                 plyr_[_pID].laff = _affID;
1449             }
1450         }
1451         
1452         // register name 
1453         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
1454         
1455         return(_isNewPlayer, _affID);
1456     }
1457     
1458 //==============================================================================
1459 //   _ _ _|_    _   .
1460 //  _\(/_ | |_||_)  .
1461 //=============|================================================================
1462     function addGame(address _gameAddress, string _gameNameStr)
1463         onlyDevs()
1464         public
1465     {
1466         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
1467         
1468         if (multiSigDev("addGame") == true)
1469         {
1470             deleteProposal("addGame");
1471             gID_++;
1472             bytes32 _name = _gameNameStr.nameFilter();
1473             gameIDs_[_gameAddress] = gID_;
1474             gameNames_[_gameAddress] = _name;
1475             games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
1476         
1477             games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
1478             games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
1479             games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
1480             games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
1481         }
1482     }
1483     
1484     function setRegistrationFee(uint256 _fee)
1485         onlyDevs()
1486         public
1487     {
1488         if (multiSigDev("setRegistrationFee") == true)
1489         {deleteProposal("setRegistrationFee");
1490             registrationFee_ = _fee;
1491         }
1492     }
1493         
1494 }
1495 
1496 contract Team {
1497 
1498     // set dev1
1499     address constant private DEV_1_ADDRESS = 0x7a9E13E044CB905957eA465488DabD5F5D34E2C4;
1500     bytes32  constant private DEV_1_NAME = "master";
1501 
1502 
1503     FundForwarderInterface private FundForwarderTeam = FundForwarderInterface(0x0);
1504     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1505     // SET UP MSFun (note, check signers by name is modified from MSFun sdk)
1506     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1507     MSFun.Data private msData;
1508     function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}
1509     function checkData(bytes32 _whatFunction) onlyAdmins() public view returns(bytes32 message_data, uint256 signature_count) {return(MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}
1510     function checkSignersByName(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyAdmins() public view returns(bytes32, bytes32, bytes32) {return(this.adminName(MSFun.checkSigner(msData, _whatFunction, _signerA)), this.adminName(MSFun.checkSigner(msData, _whatFunction, _signerB)), this.adminName(MSFun.checkSigner(msData, _whatFunction, _signerC)));}
1511 
1512     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1513     // DATA SETUP
1514     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1515     struct Admin {
1516         bool isAdmin;
1517         bool isDev;
1518         bytes32 name;
1519     }
1520     mapping (address => Admin) admins_;
1521     
1522     uint256 adminCount_;
1523     uint256 devCount_;
1524     uint256 requiredSignatures_;
1525     uint256 requiredDevSignatures_;
1526     
1527     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1528     // CONSTRUCTOR
1529     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1530     constructor()
1531         public
1532     {
1533     
1534         admins_[DEV_1_ADDRESS] = Admin(true, true, DEV_1_NAME);
1535         
1536         adminCount_ = 1;
1537         devCount_ = 1;
1538         requiredSignatures_ = 1;
1539         requiredDevSignatures_ = 1;
1540     }
1541     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1542     // FALLBACK, SETUP, AND FORWARD
1543     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1544     // there should never be a balance in this contract.  but if someone
1545     // does stupidly send eth here for some reason.  we can forward it 
1546     // to jekyll island
1547     function ()
1548         public
1549         payable
1550     {
1551         FundForwarderTeam.deposit.value(address(this).balance)();
1552     }
1553     
1554     function setup(address _addr)
1555         onlyDevs()
1556         public
1557     {
1558         require( address(FundForwarderTeam) == address(0) );
1559         FundForwarderTeam = FundForwarderInterface(_addr);
1560     }    
1561     
1562     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1563     // MODIFIERS
1564     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1565     modifier onlyDevs()
1566     {
1567         require(admins_[msg.sender].isDev == true, "onlyDevs failed - msg.sender is not a dev");
1568         _;
1569     }
1570     
1571     modifier onlyAdmins()
1572     {
1573         require(admins_[msg.sender].isAdmin == true, "onlyAdmins failed - msg.sender is not an admin");
1574         _;
1575     }
1576 
1577     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1578     // DEV ONLY FUNCTIONS
1579     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1580     /**
1581     * @dev DEV - use this to add admins.  this is a dev only function.
1582     * @param _who - address of the admin you wish to add
1583     * @param _name - admins name
1584     * @param _isDev - is this admin also a dev?
1585     */
1586     function addAdmin(address _who, bytes32 _name, bool _isDev)
1587         public
1588         onlyDevs()
1589     {
1590         if (MSFun.multiSig(msData, requiredDevSignatures_, "addAdmin") == true) 
1591         {
1592             MSFun.deleteProposal(msData, "addAdmin");
1593             
1594             // must check this so we dont mess up admin count by adding someone
1595             // who is already an admin
1596             if (admins_[_who].isAdmin == false) 
1597             { 
1598                 
1599                 // set admins flag to true in admin mapping
1600                 admins_[_who].isAdmin = true;
1601         
1602                 // adjust admin count and required signatures
1603                 adminCount_ += 1;
1604                 requiredSignatures_ += 1;
1605             }
1606             
1607             // are we setting them as a dev?
1608             // by putting this outside the above if statement, we can upgrade existing
1609             // admins to devs.
1610             if (_isDev == true) 
1611             {
1612                 // bestow the honored dev status
1613                 admins_[_who].isDev = _isDev;
1614                 
1615                 // increase dev count and required dev signatures
1616                 devCount_ += 1;
1617                 requiredDevSignatures_ += 1;
1618             }
1619         }
1620         
1621         // by putting this outside the above multisig, we can allow easy name changes
1622         // without having to bother with multisig.  this will still create a proposal though
1623         // so use the deleteAnyProposal to delete it if you want to
1624         admins_[_who].name = _name;
1625     }
1626 
1627     /**
1628     * @dev DEV - use this to remove admins. this is a dev only function.
1629     * -requirements: never less than 1 admin
1630     *                never less than 1 dev
1631     *                never less admins than required signatures
1632     *                never less devs than required dev signatures
1633     * @param _who - address of the admin you wish to remove
1634     */
1635     function removeAdmin(address _who)
1636         public
1637         onlyDevs()
1638     {
1639         // we can put our requires outside the multisig, this will prevent
1640         // creating a proposal that would never pass checks anyway.
1641         require(adminCount_ > 1, "removeAdmin failed - cannot have less than 2 admins");
1642         require(adminCount_ >= requiredSignatures_, "removeAdmin failed - cannot have less admins than number of required signatures");
1643         if (admins_[_who].isDev == true)
1644         {
1645             require(devCount_ > 1, "removeAdmin failed - cannot have less than 2 devs");
1646             require(devCount_ >= requiredDevSignatures_, "removeAdmin failed - cannot have less devs than number of required dev signatures");
1647         }
1648         
1649         // checks passed
1650         if (MSFun.multiSig(msData, requiredDevSignatures_, "removeAdmin") == true) 
1651         {
1652             MSFun.deleteProposal(msData, "removeAdmin");
1653             
1654             // must check this so we dont mess up admin count by removing someone
1655             // who wasnt an admin to start with
1656             if (admins_[_who].isAdmin == true) {  
1657                 
1658                 //set admins flag to false in admin mapping
1659                 admins_[_who].isAdmin = false;
1660                 
1661                 //adjust admin count and required signatures
1662                 adminCount_ -= 1;
1663                 if (requiredSignatures_ > 1) 
1664                 {
1665                     requiredSignatures_ -= 1;
1666                 }
1667             }
1668             
1669             // were they also a dev?
1670             if (admins_[_who].isDev == true) {
1671                 
1672                 //set dev flag to false
1673                 admins_[_who].isDev = false;
1674                 
1675                 //adjust dev count and required dev signatures
1676                 devCount_ -= 1;
1677                 if (requiredDevSignatures_ > 1) 
1678                 {
1679                     requiredDevSignatures_ -= 1;
1680                 }
1681             }
1682         }
1683     }
1684 
1685     /**
1686     * @dev DEV - change the number of required signatures.  must be between
1687     * 1 and the number of admins.  this is a dev only function
1688     * @param _howMany - desired number of required signatures
1689     */
1690     function changeRequiredSignatures(uint256 _howMany)
1691         public
1692         onlyDevs()
1693     {  
1694         // make sure its between 1 and number of admins
1695         require(_howMany > 0 && _howMany <= adminCount_, "changeRequiredSignatures failed - must be between 1 and number of admins");
1696         
1697         if (MSFun.multiSig(msData, requiredDevSignatures_, "changeRequiredSignatures") == true) 
1698         {
1699             MSFun.deleteProposal(msData, "changeRequiredSignatures");
1700             
1701             // store new setting.
1702             requiredSignatures_ = _howMany;
1703         }
1704     }
1705     
1706     /**
1707     * @dev DEV - change the number of required dev signatures.  must be between
1708     * 1 and the number of devs.  this is a dev only function
1709     * @param _howMany - desired number of required dev signatures
1710     */
1711     function changeRequiredDevSignatures(uint256 _howMany)
1712         public
1713         onlyDevs()
1714     {  
1715         // make sure its between 1 and number of admins
1716         require(_howMany > 0 && _howMany <= devCount_, "changeRequiredDevSignatures failed - must be between 1 and number of devs");
1717         
1718         if (MSFun.multiSig(msData, requiredDevSignatures_, "changeRequiredDevSignatures") == true) 
1719         {
1720             MSFun.deleteProposal(msData, "changeRequiredDevSignatures");
1721             
1722             // store new setting.
1723             requiredDevSignatures_ = _howMany;
1724         }
1725     }
1726 
1727     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1728     // EXTERNAL FUNCTIONS 
1729     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1730     function requiredSignatures() external view returns(uint256) {return(requiredSignatures_);}
1731     function requiredDevSignatures() external view returns(uint256) {return(requiredDevSignatures_);}
1732     function adminCount() external view returns(uint256) {return(adminCount_);}
1733     function devCount() external view returns(uint256) {return(devCount_);}
1734     function adminName(address _who) external view returns(bytes32) {return(admins_[_who].name);}
1735     function isAdmin(address _who) external view returns(bool) {return(admins_[_who].isAdmin);}
1736     function isDev(address _who) external view returns(bool) {return(admins_[_who].isDev);}
1737 }
1738 
1739 
1740 contract FoMo3DlongUnlimited is ModularLong {
1741     using SafeMath for *;
1742     using NameFilter for string;
1743     using F3DKeysCalcLong for uint256;
1744 
1745     address constant private DEV_1_ADDRESS = 0x7a9E13E044CB905957eA465488DabD5F5D34E2C4;
1746 	
1747     otherFoMo3D private otherF3D_;
1748     FundForwarderInterface constant private FundForwarderMain = FundForwarderInterface(0x5095072aEE46a39D0b3753184514ead86405780f);
1749     PlayerBookInterface constant private PlayerBookMain = PlayerBookInterface(0xf72848D3426d8dB71e52FAc6Df29585649bb7CBD);
1750     
1751     bool public activated_ = false;
1752 //==============================================================================
1753 //     _ _  _  |`. _     _ _ |_ | _  _  .
1754 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
1755 //=================_|===========================================================
1756     string constant public name = "Fomo3D Long Unlimited";
1757     string constant public symbol = "F3DLong";
1758     uint256 private rndExtra_ =  10 minutes; //extSettings.getLongExtra();     // length of the very first ICO 
1759     uint256 private rndGap_ =   10 minutes; //extSettings.getLongGap();         // length of ICO phase, set to 1 year for EOS.
1760     uint256 constant private rndInit_ = 1 hours;                // round timer starts at this
1761     uint256 constant private rndInc_ = 0 seconds;              // every full key purchased adds this much to the timer
1762     uint256 constant private rndMax_ = 2 hours;                // max length a round timer can be
1763 //==============================================================================
1764 //     _| _ _|_ _    _ _ _|_    _   .
1765 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store game info that changes)
1766 //=============================|================================================
1767     uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
1768     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
1769     uint256 public rID_;    // round id number / total rounds that have happened
1770 //****************
1771 // PLAYER DATA 
1772 //****************
1773     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
1774     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
1775     mapping (uint256 => F3Ddatasets.Player) public plyr_;   // (pID => data) player data
1776     mapping (uint256 => mapping (uint256 => F3Ddatasets.PlayerRounds)) public plyrRnds_;    // (pID => rID => data) player round data by player id & round id
1777     //一个用户可以有多个名字
1778     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amongst any name you own)
1779 //****************
1780 // ROUND DATA 
1781 //****************
1782     mapping (uint256 => F3Ddatasets.Round) public round_;   // (rID => data) round data
1783     mapping (uint256 => mapping(uint256 => uint256)) public rndTmEth_;      // (rID => tID => data) eth in per team, by round id and team id
1784 // ****************
1785 // TEAM FEE DATA , Team的费用分配数据
1786 // ****************
1787     mapping (uint256 => F3Ddatasets.TeamFee) public fees_;          // (team => fees) fee distribution by team
1788     mapping (uint256 => F3Ddatasets.PotSplit) public potSplit_;     // (team => fees) pot split distribution by team
1789 //==============================================================================
1790 //     _ _  _  __|_ _    __|_ _  _  .
1791 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
1792 //==============================================================================
1793     constructor()
1794         public
1795     {        
1796         //Team allocation structures
1797         // 0 = whales
1798         // 1 = bears
1799         // 2 = sneks
1800         // 3 = bulls
1801 
1802 		//Team allocation percentages
1803         // (F3D, P3D) + (Pot , Referrals, Community)
1804         //     Referrals / Community rewards are mathematically designed to come from the winner's share of the pot.
1805         fees_[0] = F3Ddatasets.TeamFee(36,0);   //50% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
1806         fees_[1] = F3Ddatasets.TeamFee(43,0);   //43% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
1807         fees_[2] = F3Ddatasets.TeamFee(66,0);  //20% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
1808         fees_[3] = F3Ddatasets.TeamFee(51,0);   //35% to pot, 10% to aff, 2% to com, 1% to pot swap, 1% to air drop pot
1809         
1810         // how to split up the final pot based on which team was picked
1811         // (F3D, P3D)
1812         potSplit_[0] = F3Ddatasets.PotSplit(25,0);  //48% to winner, 25% to next round, 2% to com
1813         potSplit_[1] = F3Ddatasets.PotSplit(25,0);   //48% to winner, 25% to next round, 2% to com
1814         potSplit_[2] = F3Ddatasets.PotSplit(40,0);  //48% to winner, 10% to next round, 2% to com
1815         potSplit_[3] = F3Ddatasets.PotSplit(40,0);  //48% to winner, 10% to next round, 2% to com
1816     }
1817 //==============================================================================
1818 //     _ _  _  _|. |`. _  _ _  .
1819 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
1820 //==============================================================================
1821     /**
1822      * @dev used to make sure no one can interact with contract until it has 
1823      * been activated. 
1824      */
1825     modifier isActivated() {
1826         require(activated_ == true, "its not ready yet.  check ?eta in discord"); 
1827         _;
1828     }
1829     
1830     /**
1831      * @dev prevents contracts from interacting with fomo3d 
1832      */
1833     modifier isHuman() {
1834         address _addr = msg.sender;
1835         uint256 _codeLength;
1836         
1837         assembly {_codeLength := extcodesize(_addr)}
1838         require(_codeLength == 0, "sorry humans only");
1839         _;
1840     }
1841 
1842     /**
1843      * @dev sets boundaries for incoming tx 
1844      */
1845     modifier isWithinLimits(uint256 _eth) {
1846         require(_eth >= 1000000000, "pocket lint: not a valid currency");
1847         require(_eth <= 100000000000000000000000, "no vitalik, no");
1848         _;    
1849     }
1850     
1851 //==============================================================================
1852 //     _    |_ |. _   |`    _  __|_. _  _  _  .
1853 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
1854 //====|=========================================================================
1855     /**
1856      * @dev emergency buy uses last stored affiliate ID and team snek
1857      */
1858     function()
1859         isActivated()
1860         isHuman()
1861         isWithinLimits(msg.value)
1862         public
1863         payable
1864     {
1865         // set up our tx event data and determine if player is new or not
1866         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
1867             
1868         // fetch player id
1869         uint256 _pID = pIDxAddr_[msg.sender];
1870 
1871         // todo: 如果去为空怎么办？
1872         
1873         // buy core 
1874         buyCore(_pID, plyr_[_pID].laff, 2, _eventData_);
1875     }
1876     
1877     /**
1878      * @dev converts all incoming ethereum to keys.
1879      * -functionhash- 0x8f38f309 (using ID for affiliate)
1880      * -functionhash- 0x98a0871d (using address for affiliate)
1881      * -functionhash- 0xa65b37a1 (using name for affiliate)
1882      * @param _affCode the ID/address/name of the player who gets the affiliate fee
1883      * @param _team what team is the player playing for?
1884      */
1885     function buyXid(uint256 _affCode, uint256 _team)
1886         isActivated()
1887         isHuman()
1888         isWithinLimits(msg.value)
1889         public
1890         payable
1891     {
1892         // set up our tx event data and determine if player is new or not
1893         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
1894         
1895         // fetch player id
1896         uint256 _pID = pIDxAddr_[msg.sender];
1897         
1898         // manage affiliate residuals
1899         // if no affiliate code was given or player tried to use their own, lolz
1900         if (_affCode == 0 || _affCode == _pID)
1901         {
1902             // use last stored affiliate code 
1903             _affCode = plyr_[_pID].laff;
1904             
1905         // if affiliate code was given & its not the same as previously stored 
1906         } else if (_affCode != plyr_[_pID].laff) {
1907             // update last affiliate 
1908             plyr_[_pID].laff = _affCode;
1909         }
1910         
1911         // verify a valid team was selected
1912         _team = verifyTeam(_team);
1913         
1914         // buy core 
1915         buyCore(_pID, _affCode, _team, _eventData_);
1916     }
1917     
1918     function buyXaddr(address _affCode, uint256 _team)
1919         isActivated()
1920         isHuman()
1921         isWithinLimits(msg.value)
1922         public
1923         payable
1924     {
1925         // set up our tx event data and determine if player is new or not
1926         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
1927         
1928         // fetch player id
1929         uint256 _pID = pIDxAddr_[msg.sender];
1930         
1931         // manage affiliate residuals
1932         uint256 _affID;
1933         // if no affiliate code was given or player tried to use their own, lolz
1934         if (_affCode == address(0) || _affCode == msg.sender)
1935         {
1936             // use last stored affiliate code
1937             _affID = plyr_[_pID].laff;
1938         
1939         // if affiliate code was given    
1940         } else {
1941             // get affiliate ID from aff Code 
1942             _affID = pIDxAddr_[_affCode];
1943             
1944             // if affID is not the same as previously stored 
1945             if (_affID != plyr_[_pID].laff)
1946             {
1947                 // update last affiliate
1948                 plyr_[_pID].laff = _affID;
1949             }
1950         }
1951         
1952         // verify a valid team was selected
1953         _team = verifyTeam(_team);
1954         
1955         // buy core 
1956         buyCore(_pID, _affID, _team, _eventData_);
1957     }
1958     
1959     function buyXname(bytes32 _affCode, uint256 _team)
1960         isActivated()
1961         isHuman()
1962         isWithinLimits(msg.value)
1963         public
1964         payable
1965     {
1966         // set up our tx event data and determine if player is new or not
1967         F3Ddatasets.EventReturns memory _eventData_ = determinePID(_eventData_);
1968         
1969         // fetch player id
1970         uint256 _pID = pIDxAddr_[msg.sender];
1971         
1972         // manage affiliate residuals
1973         uint256 _affID;
1974         // if no affiliate code was given or player tried to use their own, lolz
1975         if (_affCode == '' || _affCode == plyr_[_pID].name)
1976         {
1977             // use last stored affiliate code
1978             _affID = plyr_[_pID].laff;
1979         
1980         // if affiliate code was given
1981         } else {
1982             // get affiliate ID from aff Code
1983             _affID = pIDxName_[_affCode];
1984             
1985             // if affID is not the same as previously stored
1986             if (_affID != plyr_[_pID].laff)
1987             {
1988                 // update last affiliate
1989                 plyr_[_pID].laff = _affID;
1990             }
1991         }
1992         
1993         // verify a valid team was selected
1994         _team = verifyTeam(_team);
1995         
1996         // buy core 
1997         buyCore(_pID, _affID, _team, _eventData_);
1998     }
1999     
2000     /**
2001      * @dev essentially the same as buy, but instead of you sending ether 
2002      * from your wallet, it uses your unwithdrawn earnings.
2003      * -functionhash- 0x349cdcac (using ID for affiliate)
2004      * -functionhash- 0x82bfc739 (using address for affiliate)
2005      * -functionhash- 0x079ce327 (using name for affiliate)
2006      * @param _affCode the ID/address/name of the player who gets the affiliate fee
2007      * @param _team what team is the player playing for?
2008      * @param _eth amount of earnings to use (remainder returned to gen vault)
2009      */
2010     function reLoadXid(uint256 _affCode, uint256 _team, uint256 _eth)
2011         isActivated()
2012         isHuman()
2013         isWithinLimits(_eth)
2014         public
2015     {
2016         // set up our tx event data
2017         F3Ddatasets.EventReturns memory _eventData_;
2018         
2019         // fetch player ID
2020         uint256 _pID = pIDxAddr_[msg.sender];
2021         
2022         // manage affiliate residuals
2023         // if no affiliate code was given or player tried to use their own, lolz
2024         if (_affCode == 0 || _affCode == _pID)
2025         {
2026             // use last stored affiliate code 
2027             _affCode = plyr_[_pID].laff;
2028             
2029         // if affiliate code was given & its not the same as previously stored 
2030         } else if (_affCode != plyr_[_pID].laff) {
2031             // update last affiliate 
2032             plyr_[_pID].laff = _affCode;
2033         }
2034 
2035         // verify a valid team was selected
2036         _team = verifyTeam(_team);
2037 
2038         // reload core
2039         reLoadCore(_pID, _affCode, _team, _eth, _eventData_);
2040     }
2041     
2042     function reLoadXaddr(address _affCode, uint256 _team, uint256 _eth)
2043         isActivated()
2044         isHuman()
2045         isWithinLimits(_eth)
2046         public
2047     {
2048         // set up our tx event data
2049         F3Ddatasets.EventReturns memory _eventData_;
2050         
2051         // fetch player ID
2052         uint256 _pID = pIDxAddr_[msg.sender];
2053         
2054         // manage affiliate residuals
2055         uint256 _affID;
2056         // if no affiliate code was given or player tried to use their own, lolz
2057         if (_affCode == address(0) || _affCode == msg.sender)
2058         {
2059             // use last stored affiliate code
2060             _affID = plyr_[_pID].laff;
2061         
2062         // if affiliate code was given    
2063         } else {
2064             // get affiliate ID from aff Code 
2065             _affID = pIDxAddr_[_affCode];
2066             
2067             // if affID is not the same as previously stored 
2068             if (_affID != plyr_[_pID].laff)
2069             {
2070                 // update last affiliate
2071                 plyr_[_pID].laff = _affID;
2072             }
2073         }
2074         
2075         // verify a valid team was selected
2076         _team = verifyTeam(_team);
2077         
2078         // reload core
2079         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
2080     }
2081     
2082     function reLoadXname(bytes32 _affCode, uint256 _team, uint256 _eth)
2083         isActivated()
2084         isHuman()
2085         isWithinLimits(_eth)
2086         public
2087     {
2088         // set up our tx event data
2089         F3Ddatasets.EventReturns memory _eventData_;
2090         
2091         // fetch player ID
2092         uint256 _pID = pIDxAddr_[msg.sender];
2093         
2094         // manage affiliate residuals
2095         uint256 _affID;
2096         // if no affiliate code was given or player tried to use their own, lolz
2097         if (_affCode == '' || _affCode == plyr_[_pID].name)
2098         {
2099             // use last stored affiliate code
2100             _affID = plyr_[_pID].laff;
2101         
2102         // if affiliate code was given
2103         } else {
2104             // get affiliate ID from aff Code
2105             _affID = pIDxName_[_affCode];
2106             
2107             // if affID is not the same as previously stored
2108             if (_affID != plyr_[_pID].laff)
2109             {
2110                 // update last affiliate
2111                 plyr_[_pID].laff = _affID;
2112             }
2113         }
2114         
2115         // verify a valid team was selected
2116         _team = verifyTeam(_team);
2117         
2118         // reload core
2119         reLoadCore(_pID, _affID, _team, _eth, _eventData_);
2120     }
2121 
2122     /**
2123      * @dev withdraws all of your earnings.
2124      * -functionhash- 0x3ccfd60b
2125      */
2126     function withdraw()
2127         isActivated()
2128         isHuman()
2129         public
2130     {
2131         // setup local rID 
2132         uint256 _rID = rID_;
2133         
2134         // grab time
2135         uint256 _now = now;
2136         
2137         // fetch player ID
2138         uint256 _pID = pIDxAddr_[msg.sender];
2139         
2140         // setup temp var for player eth
2141         uint256 _eth;
2142         
2143         // check to see if round has ended and no one has run round end yet
2144         if (_now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
2145         {
2146             // set up our tx event data
2147             F3Ddatasets.EventReturns memory _eventData_;
2148             
2149             // end the round (distributes pot)
2150 			round_[_rID].ended = true;
2151             _eventData_ = endRound(_eventData_);
2152             
2153 			// get their earnings
2154             _eth = withdrawEarnings(_pID);
2155             
2156             // gib moni
2157             if (_eth > 0)
2158                 plyr_[_pID].addr.transfer(_eth);    
2159             
2160             // build event data
2161             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
2162             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
2163             
2164             // fire withdraw and distribute event
2165             emit F3Devents.onWithdrawAndDistribute
2166             (
2167                 msg.sender, 
2168                 plyr_[_pID].name, 
2169                 _eth, 
2170                 _eventData_.compressedData, 
2171                 _eventData_.compressedIDs, 
2172                 _eventData_.winnerAddr, 
2173                 _eventData_.winnerName, 
2174                 _eventData_.amountWon, 
2175                 _eventData_.newPot, 
2176                 _eventData_.P3DAmount, 
2177                 _eventData_.genAmount
2178             );
2179             
2180         // in any other situation
2181         } else {
2182             // get their earnings
2183             _eth = withdrawEarnings(_pID);
2184             
2185             // gib moni
2186             if (_eth > 0)
2187                 plyr_[_pID].addr.transfer(_eth);
2188             
2189             // fire withdraw event
2190             emit F3Devents.onWithdraw(_pID, msg.sender, plyr_[_pID].name, _eth, _now);
2191         }
2192     }
2193     
2194     /**
2195      * @dev use these to register names.  they are just wrappers that will send the
2196      * registration requests to the PlayerBook contract.  So registering here is the 
2197      * same as registering there.  UI will always display the last name you registered.
2198      * but you will still own all previously registered names to use as affiliate 
2199      * links.
2200      * - must pay a registration fee.
2201      * - name must be unique
2202      * - names will be converted to lowercase
2203      * - name cannot start or end with a space 
2204      * - cannot have more than 1 space in a row
2205      * - cannot be only numbers
2206      * - cannot start with 0x 
2207      * - name must be at least 1 char
2208      * - max length of 32 characters long
2209      * - allowed characters: a-z, 0-9, and space
2210      * -functionhash- 0x921dec21 (using ID for affiliate)
2211      * -functionhash- 0x3ddd4698 (using address for affiliate)
2212      * -functionhash- 0x685ffd83 (using name for affiliate)
2213      * @param _nameString players desired name
2214      * @param _affCode affiliate ID, address, or name of who referred you
2215      * @param _all set to true if you want this to push your info to all games 
2216      * (this might cost a lot of gas)
2217      */
2218     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
2219         isHuman()
2220         public
2221         payable
2222     {
2223         bytes32 _name = _nameString.nameFilter();
2224         address _addr = msg.sender;
2225         uint256 _paid = msg.value;
2226         (bool _isNewPlayer, uint256 _affID) = PlayerBookMain.registerNameXIDFromDapp.value(_paid)(_addr, _name, _affCode, _all);
2227         
2228         uint256 _pID = pIDxAddr_[_addr];
2229         
2230         // fire event
2231         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
2232     }
2233     
2234     function registerNameXaddr(string _nameString, address _affCode, bool _all)
2235         isHuman()
2236         public
2237         payable
2238     {
2239         bytes32 _name = _nameString.nameFilter();
2240         address _addr = msg.sender;
2241         uint256 _paid = msg.value;
2242         (bool _isNewPlayer, uint256 _affID) = PlayerBookMain.registerNameXaddrFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
2243         
2244         uint256 _pID = pIDxAddr_[_addr];
2245         
2246         // fire event
2247         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
2248     }
2249     
2250     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
2251         isHuman()
2252         public
2253         payable
2254     {
2255         bytes32 _name = _nameString.nameFilter();
2256         address _addr = msg.sender;
2257         uint256 _paid = msg.value;
2258         (bool _isNewPlayer, uint256 _affID) = PlayerBookMain.registerNameXnameFromDapp.value(msg.value)(msg.sender, _name, _affCode, _all);
2259         
2260         uint256 _pID = pIDxAddr_[_addr];
2261         
2262         // fire event
2263         emit F3Devents.onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, _paid, now);
2264     }
2265 //==============================================================================
2266 //     _  _ _|__|_ _  _ _  .
2267 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
2268 //=====_|=======================================================================
2269     /**
2270      * @dev return the price buyer will pay for next 1 individual key.
2271      * -functionhash- 0x018a25e8
2272      * @return price for next key bought (in wei format)
2273      */
2274     function getBuyPrice()
2275         public 
2276         view 
2277         returns(uint256)
2278     {  
2279         // setup local rID
2280         uint256 _rID = rID_;
2281         
2282         // grab time
2283         uint256 _now = now;
2284         
2285         // are we in a round?
2286         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
2287             return ( (round_[_rID].keys.add(1000000000000000000)).ethRec(1000000000000000000) );
2288         else // rounds over.  need price for new round
2289             return ( 75000000000000 ); // init
2290     }
2291     
2292     /**
2293      * @dev returns time left.  dont spam this, you'll ddos yourself from your node 
2294      * provider
2295      * -functionhash- 0xc7e284b8
2296      * @return time left in seconds
2297      */
2298     function getTimeLeft()
2299         public
2300         view
2301         returns(uint256)
2302     {
2303         // setup local rID
2304         uint256 _rID = rID_;
2305         
2306         // grab time
2307         uint256 _now = now;
2308         
2309         if (_now < round_[_rID].end)
2310             if (_now > round_[_rID].strt + rndGap_)
2311                 return( (round_[_rID].end).sub(_now) );
2312             else
2313                 return( (round_[_rID].strt + rndGap_).sub(_now) );
2314         else
2315             return(0);
2316     }
2317     
2318     /**
2319      * @dev returns player earnings per vaults 
2320      * -functionhash- 0x63066434
2321      * @return winnings vault
2322      * @return general vault
2323      * @return affiliate vault
2324      */
2325     function getPlayerVaults(uint256 _pID)
2326         public
2327         view
2328         returns(uint256 ,uint256, uint256)
2329     {
2330         // setup local rID
2331         uint256 _rID = rID_;
2332         
2333         // if round has ended.  but round end has not been run (so contract has not distributed winnings)
2334         if (now > round_[_rID].end && round_[_rID].ended == false && round_[_rID].plyr != 0)
2335         {
2336             // if player is winner 
2337             if (round_[_rID].plyr == _pID)
2338             {
2339                 return
2340                 (
2341                     (plyr_[_pID].win).add( ((round_[_rID].pot).mul(48)) / 100 ),
2342                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)   ),
2343                     plyr_[_pID].aff
2344                 );
2345             // if player is not the winner
2346             } else {
2347                 return
2348                 (
2349                     plyr_[_pID].win,
2350                     (plyr_[_pID].gen).add(  getPlayerVaultsHelper(_pID, _rID).sub(plyrRnds_[_pID][_rID].mask)  ),
2351                     plyr_[_pID].aff
2352                 );
2353             }
2354             
2355         // if round is still going on, or round has ended and round end has been ran
2356         } else {
2357             return
2358             (
2359                 plyr_[_pID].win,
2360                 (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),
2361                 plyr_[_pID].aff
2362             );
2363         }
2364     }
2365     
2366     /**
2367      * solidity hates stack limits.  this lets us avoid that hate 
2368      */
2369     function getPlayerVaultsHelper(uint256 _pID, uint256 _rID)
2370         private
2371         view
2372         returns(uint256)
2373     {
2374         return(  ((((round_[_rID].mask).add(((((round_[_rID].pot).mul(potSplit_[round_[_rID].team].gen)) / 100).mul(1000000000000000000)) / (round_[_rID].keys))).mul(plyrRnds_[_pID][_rID].keys)) / 1000000000000000000)  );
2375     }
2376     
2377     /**
2378      * @dev returns all current round info needed for front end
2379      * -functionhash- 0x747dff42
2380      * @return eth invested during ICO phase
2381      * @return round id 
2382      * @return total keys for round 
2383      * @return time round ends
2384      * @return time round started
2385      * @return current pot 
2386      * @return current team ID & player ID in lead 
2387      * @return current player in leads address 
2388      * @return current player in leads name
2389      * @return whales eth in for round
2390      * @return bears eth in for round
2391      * @return sneks eth in for round
2392      * @return bulls eth in for round
2393      * @return airdrop tracker # & airdrop pot
2394      */
2395     function getCurrentRoundInfo()
2396         public
2397         view
2398         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, bytes32, uint256, uint256, uint256, uint256, uint256)
2399     {
2400         // setup local rID
2401         uint256 _rID = rID_;
2402         
2403         return
2404         (
2405             round_[_rID].ico,               //0
2406             _rID,                           //1
2407             round_[_rID].keys,              //2
2408             round_[_rID].end,               //3
2409             round_[_rID].strt,              //4
2410             round_[_rID].pot,               //5
2411             (round_[_rID].team + (round_[_rID].plyr * 10)),     //6
2412             plyr_[round_[_rID].plyr].addr,  //7
2413             plyr_[round_[_rID].plyr].name,  //8
2414             rndTmEth_[_rID][0],             //9
2415             rndTmEth_[_rID][1],             //10
2416             rndTmEth_[_rID][2],             //11
2417             rndTmEth_[_rID][3],             //12
2418             airDropTracker_ + (airDropPot_ * 1000)              //13
2419         );
2420     }
2421 
2422     /**
2423      * @dev returns player info based on address.  if no address is given, it will 
2424      * use msg.sender 
2425      * -functionhash- 0xee0b5d8b
2426      * @param _addr address of the player you want to lookup 
2427      * @return player ID 
2428      * @return player name
2429      * @return keys owned (current round)
2430      * @return winnings vault
2431      * @return general vault 
2432      * @return affiliate vault 
2433 	 * @return player round eth
2434      */
2435     function getPlayerInfoByAddress(address _addr)
2436         public 
2437         view 
2438         returns(uint256, bytes32, uint256, uint256, uint256, uint256, uint256)
2439     {
2440         // setup local rID
2441         uint256 _rID = rID_;
2442         
2443         if (_addr == address(0))
2444         {
2445             _addr == msg.sender;
2446         }
2447         uint256 _pID = pIDxAddr_[_addr];
2448         
2449         return
2450         (
2451             _pID,                               //0
2452             plyr_[_pID].name,                   //1
2453             plyrRnds_[_pID][_rID].keys,         //2
2454             plyr_[_pID].win,                    //3
2455             (plyr_[_pID].gen).add(calcUnMaskedEarnings(_pID, plyr_[_pID].lrnd)),       //4
2456             plyr_[_pID].aff,                    //5
2457             plyrRnds_[_pID][_rID].eth           //6
2458         );
2459     }
2460 
2461 //==============================================================================
2462 //     _ _  _ _   | _  _ . _  .
2463 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
2464 //=====================_|=======================================================
2465     /**
2466      * @dev logic runs whenever a buy order is executed.  determines how to handle 
2467      * incoming eth depending on if we are in an active round or not
2468      */
2469     function buyCore(uint256 _pID, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
2470         private
2471     {
2472         // setup local rID
2473         uint256 _rID = rID_;
2474         
2475         // grab time
2476         uint256 _now = now;
2477         
2478         // if round is active
2479         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
2480         {
2481             // call core 
2482             core(_rID, _pID, msg.value, _affID, _team, _eventData_);
2483         
2484         // if round is not active     
2485         } else {
2486             // check to see if end round needs to be ran
2487             if (_now > round_[_rID].end && round_[_rID].ended == false) 
2488             {
2489                 // end the round (distributes pot) & start new round
2490 			    round_[_rID].ended = true;
2491                 _eventData_ = endRound(_eventData_);
2492                 
2493                 // build event data
2494                 _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
2495                 _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
2496                 
2497                 // fire buy and distribute event 
2498                 emit F3Devents.onBuyAndDistribute
2499                 (
2500                     msg.sender, 
2501                     plyr_[_pID].name, 
2502                     msg.value, 
2503                     _eventData_.compressedData, 
2504                     _eventData_.compressedIDs, 
2505                     _eventData_.winnerAddr, 
2506                     _eventData_.winnerName, 
2507                     _eventData_.amountWon, 
2508                     _eventData_.newPot, 
2509                     _eventData_.P3DAmount, 
2510                     _eventData_.genAmount
2511                 );
2512             }
2513             
2514             // put eth in players vault 
2515             plyr_[_pID].gen = plyr_[_pID].gen.add(msg.value);
2516         }
2517     }
2518     
2519     /**
2520      * @dev logic runs whenever a reload order is executed.  determines how to handle 
2521      * incoming eth depending on if we are in an active round or not 
2522      */
2523     function reLoadCore(uint256 _pID, uint256 _affID, uint256 _team, uint256 _eth, F3Ddatasets.EventReturns memory _eventData_)
2524         private
2525     {
2526         // setup local rID
2527         uint256 _rID = rID_;
2528         
2529         // grab time
2530         uint256 _now = now;
2531         
2532         // if round is active
2533         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0))) 
2534         {
2535             // get earnings from all vaults and return unused to gen vault
2536             // because we use a custom safemath library.  this will throw if player 
2537             // tried to spend more eth than they have.
2538             plyr_[_pID].gen = withdrawEarnings(_pID).sub(_eth);
2539             
2540             // call core 
2541             core(_rID, _pID, _eth, _affID, _team, _eventData_);
2542         
2543         // if round is not active and end round needs to be ran   
2544         } else if (_now > round_[_rID].end && round_[_rID].ended == false) {
2545             // end the round (distributes pot) & start new round
2546             round_[_rID].ended = true;
2547             _eventData_ = endRound(_eventData_);
2548                 
2549             // build event data
2550             _eventData_.compressedData = _eventData_.compressedData + (_now * 1000000000000000000);
2551             _eventData_.compressedIDs = _eventData_.compressedIDs + _pID;
2552                 
2553             // fire buy and distribute event 
2554             emit F3Devents.onReLoadAndDistribute
2555             (
2556                 msg.sender, 
2557                 plyr_[_pID].name, 
2558                 _eventData_.compressedData, 
2559                 _eventData_.compressedIDs, 
2560                 _eventData_.winnerAddr, 
2561                 _eventData_.winnerName, 
2562                 _eventData_.amountWon, 
2563                 _eventData_.newPot, 
2564                 _eventData_.P3DAmount, 
2565                 _eventData_.genAmount
2566             );
2567         }
2568     }
2569     
2570     /**
2571      * @dev this is the core logic for any buy/reload that happens while a round 
2572      * is live.
2573      */
2574     function core(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
2575         private
2576     {
2577         // if player is new to round
2578         if (plyrRnds_[_pID][_rID].keys == 0)
2579             _eventData_ = managePlayer(_pID, _eventData_);
2580         
2581         // early round eth limiter 
2582         if (round_[_rID].eth < 100000000000000000000 && plyrRnds_[_pID][_rID].eth.add(_eth) > 1000000000000000000)
2583         {
2584             uint256 _availableLimit = (1000000000000000000).sub(plyrRnds_[_pID][_rID].eth);
2585             uint256 _refund = _eth.sub(_availableLimit);
2586             plyr_[_pID].gen = plyr_[_pID].gen.add(_refund);
2587             _eth = _availableLimit;
2588         }
2589         
2590         // if eth left is greater than min eth allowed (sorry no pocket lint)
2591         if (_eth > 1000000000) 
2592         {
2593             
2594             // mint the new keys
2595             uint256 _keys = (round_[_rID].eth).keysRec(_eth);
2596             
2597             // if they bought at least 1 whole key
2598             if (_keys >= 1000000000000000000)
2599             {
2600                 updateTimer(_keys, _rID);
2601 
2602                 // set new leaders
2603                 if (round_[_rID].plyr != _pID)
2604                     round_[_rID].plyr = _pID;  
2605                 if (round_[_rID].team != _team)
2606                     round_[_rID].team = _team; 
2607                 
2608                 // set the new leader bool to true
2609                 _eventData_.compressedData = _eventData_.compressedData + 100;
2610             }
2611             
2612             // manage airdrops
2613             if (_eth >= 100000000000000000)
2614             {
2615                 airDropTracker_++;
2616                 if (airdrop() == true)
2617                 {
2618                     // gib muni
2619                     uint256 _prize;
2620                     if (_eth >= 10000000000000000000)
2621                     {
2622                         // calculate prize and give it to winner
2623                         _prize = ((airDropPot_).mul(75)) / 100;
2624                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
2625                         
2626                         // adjust airDropPot 
2627                         airDropPot_ = (airDropPot_).sub(_prize);
2628                         
2629                         // let event know a tier 3 prize was won 
2630                         _eventData_.compressedData += 300000000000000000000000000000000;
2631                     } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
2632                         // calculate prize and give it to winner
2633                         _prize = ((airDropPot_).mul(50)) / 100;
2634                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
2635                         
2636                         // adjust airDropPot 
2637                         airDropPot_ = (airDropPot_).sub(_prize);
2638                         
2639                         // let event know a tier 2 prize was won 
2640                         _eventData_.compressedData += 200000000000000000000000000000000;
2641                     } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
2642                         // calculate prize and give it to winner
2643                         _prize = ((airDropPot_).mul(25)) / 100;
2644                         plyr_[_pID].win = (plyr_[_pID].win).add(_prize);
2645                         
2646                         // adjust airDropPot 
2647                         airDropPot_ = (airDropPot_).sub(_prize);
2648                         
2649                         // let event know a tier 3 prize was won 
2650                         _eventData_.compressedData += 300000000000000000000000000000000;
2651                     }
2652                     // set airdrop happened bool to true
2653                     _eventData_.compressedData += 10000000000000000000000000000000;
2654                     // let event know how much was won 
2655                     _eventData_.compressedData += _prize * 1000000000000000000000000000000000;
2656                     
2657                     // reset air drop tracker
2658                     airDropTracker_ = 0;
2659                 }
2660             }
2661     
2662             // store the air drop tracker number (number of buys since last airdrop)
2663             _eventData_.compressedData = _eventData_.compressedData + (airDropTracker_ * 1000);
2664             
2665             // update player 
2666             plyrRnds_[_pID][_rID].keys = _keys.add(plyrRnds_[_pID][_rID].keys);
2667             plyrRnds_[_pID][_rID].eth = _eth.add(plyrRnds_[_pID][_rID].eth);
2668             
2669             // update round
2670             round_[_rID].keys = _keys.add(round_[_rID].keys);
2671             round_[_rID].eth = _eth.add(round_[_rID].eth);
2672             rndTmEth_[_rID][_team] = _eth.add(rndTmEth_[_rID][_team]);
2673     
2674             // distribute eth, 分钱
2675             _eventData_ = distributeExternal(_rID, _pID, _eth, _affID, _team, _eventData_);
2676             _eventData_ = distributeInternal(_rID, _pID, _eth, _team, _keys, _eventData_);
2677             
2678             // call end tx function to fire end tx event.
2679             endTx(_pID, _team, _eth, _keys, _eventData_);
2680         }
2681     }
2682 //==============================================================================
2683 //     _ _ | _   | _ _|_ _  _ _  .
2684 //    (_(_||(_|_||(_| | (_)| _\  .
2685 //==============================================================================
2686     /**
2687      * @dev calculates unmasked earnings (just calculates, does not update mask)
2688      * @return earnings in wei format
2689      */
2690     function calcUnMaskedEarnings(uint256 _pID, uint256 _rIDlast)
2691         private
2692         view
2693         returns(uint256)
2694     {
2695         return(  (((round_[_rIDlast].mask).mul(plyrRnds_[_pID][_rIDlast].keys)) / (1000000000000000000)).sub(plyrRnds_[_pID][_rIDlast].mask)  );
2696     }
2697     
2698     /** 
2699      * @dev returns the amount of keys you would get given an amount of eth. 
2700      * -functionhash- 0xce89c80c
2701      * @param _rID round ID you want price for
2702      * @param _eth amount of eth sent in 
2703      * @return keys received 
2704      */
2705     function calcKeysReceived(uint256 _rID, uint256 _eth)
2706         public
2707         view
2708         returns(uint256)
2709     {
2710         // grab time
2711         uint256 _now = now;
2712         
2713         // are we in a round?
2714         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
2715             return ( (round_[_rID].eth).keysRec(_eth) );
2716         else // rounds over.  need keys for new round
2717             return ( (_eth).keys() );
2718     }
2719     
2720     /** 
2721      * @dev returns current eth price for X keys.  
2722      * -functionhash- 0xcf808000
2723      * @param _keys number of keys desired (in 18 decimal format)
2724      * @return amount of eth needed to send
2725      */
2726     function iWantXKeys(uint256 _keys)
2727         public
2728         view
2729         returns(uint256)
2730     {
2731         // setup local rID
2732         uint256 _rID = rID_;
2733         
2734         // grab time
2735         uint256 _now = now;
2736         
2737         // are we in a round?
2738         if (_now > round_[_rID].strt + rndGap_ && (_now <= round_[_rID].end || (_now > round_[_rID].end && round_[_rID].plyr == 0)))
2739             return ( (round_[_rID].keys.add(_keys)).ethRec(_keys) );
2740         else // rounds over.  need price for new round
2741             return ( (_keys).eth() );
2742     }
2743 //==============================================================================
2744 //    _|_ _  _ | _  .
2745 //     | (_)(_)|_\  .
2746 //==============================================================================
2747     /**
2748 	 * @dev receives name/player info from names contract 
2749      */
2750     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff)
2751         external
2752     {
2753         require (msg.sender == address(PlayerBookMain), "your not playerNames contract... hmmm..");
2754         if (pIDxAddr_[_addr] != _pID)
2755             pIDxAddr_[_addr] = _pID;
2756         if (pIDxName_[_name] != _pID)
2757             pIDxName_[_name] = _pID;
2758         if (plyr_[_pID].addr != _addr)
2759             plyr_[_pID].addr = _addr;
2760         if (plyr_[_pID].name != _name)
2761             plyr_[_pID].name = _name;
2762         if (plyr_[_pID].laff != _laff)
2763             plyr_[_pID].laff = _laff;
2764         if (plyrNames_[_pID][_name] == false)
2765             plyrNames_[_pID][_name] = true;
2766     }
2767     
2768     /**
2769      * @dev receives entire player name list 
2770      */
2771     function receivePlayerNameList(uint256 _pID, bytes32 _name)
2772         external
2773     {
2774         require (msg.sender == address(PlayerBookMain), "your not playerNames contract... hmmm..");
2775         if(plyrNames_[_pID][_name] == false)
2776             plyrNames_[_pID][_name] = true;
2777     }   
2778         
2779     /**
2780      * @dev gets existing or registers new pID.  use this when a player may be new
2781      * @return pID 
2782      */
2783     function determinePID(F3Ddatasets.EventReturns memory _eventData_)
2784         private
2785         returns (F3Ddatasets.EventReturns)
2786     {
2787         uint256 _pID = pIDxAddr_[msg.sender];
2788         // if player is new to this version of fomo3d
2789         if (_pID == 0)
2790         {
2791             // grab their player ID, name and last aff ID, from player names contract 
2792             _pID = PlayerBookMain.getPlayerID(msg.sender);
2793             bytes32 _name = PlayerBookMain.getPlayerName(_pID);
2794             uint256 _laff = PlayerBookMain.getPlayerLAff(_pID);
2795             
2796             // set up player account 
2797             pIDxAddr_[msg.sender] = _pID;
2798             plyr_[_pID].addr = msg.sender;
2799             
2800             if (_name != "")
2801             {
2802                 pIDxName_[_name] = _pID;
2803                 plyr_[_pID].name = _name;
2804                 plyrNames_[_pID][_name] = true;
2805             }
2806             
2807             if (_laff != 0 && _laff != _pID)
2808                 plyr_[_pID].laff = _laff;
2809             
2810             // set the new player bool to true
2811             _eventData_.compressedData = _eventData_.compressedData + 1;
2812         } 
2813         return (_eventData_);
2814     }
2815     
2816     /**
2817      * @dev checks to make sure user picked a valid team.  if not sets team 
2818      * to default (sneks)
2819      */
2820     function verifyTeam(uint256 _team)
2821         private
2822         pure
2823         returns (uint256)
2824     {
2825         if (_team < 0 || _team > 3)
2826             return(2);
2827         else
2828             return(_team);
2829     }
2830     
2831     /**
2832      * @dev decides if round end needs to be run & new round started.  and if 
2833      * player unmasked earnings from previously played rounds need to be moved.
2834      */
2835     function managePlayer(uint256 _pID, F3Ddatasets.EventReturns memory _eventData_)
2836         private
2837         returns (F3Ddatasets.EventReturns)
2838     {
2839         // if player has played a previous round, move their unmasked earnings
2840         // from that round to gen vault.
2841         if (plyr_[_pID].lrnd != 0)
2842             updateGenVault(_pID, plyr_[_pID].lrnd);
2843             
2844         // update player's last round played
2845         plyr_[_pID].lrnd = rID_;
2846             
2847         // set the joined round bool to true
2848         _eventData_.compressedData = _eventData_.compressedData + 10;
2849         
2850         return(_eventData_);
2851     }
2852     
2853     /**
2854      * @dev ends the round. manages paying out winner/splitting up pot
2855      */
2856     function endRound(F3Ddatasets.EventReturns memory _eventData_)
2857         private
2858         returns (F3Ddatasets.EventReturns)
2859     {
2860         // setup local rID
2861         uint256 _rID = rID_;
2862         
2863         // grab our winning player and team id's
2864         uint256 _winPID = round_[_rID].plyr;
2865         uint256 _winTID = round_[_rID].team;
2866         
2867         // grab our pot amount
2868         uint256 _pot = round_[_rID].pot;
2869         
2870         // calculate our winner share, community rewards, gen share, 
2871         // p3d share, and amount reserved for next pot 
2872         uint256 _win = (_pot.mul(48)) / 100;
2873         uint256 _com = (_pot / 50);
2874         uint256 _gen = (_pot.mul(potSplit_[_winTID].gen)) / 100;
2875         uint256 _p3d = (_pot.mul(potSplit_[_winTID].p3d)) / 100;
2876         uint256 _res = (((_pot.sub(_win)).sub(_com)).sub(_gen)).sub(_p3d);
2877         
2878         // calculate ppt for round mask
2879         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
2880         uint256 _dust = _gen.sub((_ppt.mul(round_[_rID].keys)) / 1000000000000000000);
2881         if (_dust > 0)
2882         {
2883             _gen = _gen.sub(_dust);
2884             _res = _res.add(_dust);
2885         }
2886         
2887         // pay our winner
2888         plyr_[_winPID].win = _win.add(plyr_[_winPID].win);
2889         
2890         // community rewards
2891         if (!address(FundForwarderMain).call.value(_com)(bytes4(keccak256("deposit()"))))
2892         {
2893             // This ensures Team Just cannot influence the outcome of FoMo3D with
2894             // bank migrations by breaking outgoing transactions.
2895             // Something we would never do. But that's not the point.
2896             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
2897             // highest belief that everything we create should be trustless.
2898             // Team JUST, The name you shouldn't have to trust.
2899             _p3d = _p3d.add(_com);
2900             _com = 0;
2901         }
2902         
2903         // distribute gen portion to key holders
2904         round_[_rID].mask = _ppt.add(round_[_rID].mask);
2905         
2906         // send share for p3d to divies
2907         if (_p3d > 0){
2908             //     Divies.deposit.value(_p3d)();
2909             FundForwarderMain.deposit.value(_p3d)();
2910         }
2911             
2912         // prepare event data
2913         _eventData_.compressedData = _eventData_.compressedData + (round_[_rID].end * 1000000);
2914         _eventData_.compressedIDs = _eventData_.compressedIDs + (_winPID * 100000000000000000000000000) + (_winTID * 100000000000000000);
2915         _eventData_.winnerAddr = plyr_[_winPID].addr;
2916         _eventData_.winnerName = plyr_[_winPID].name;
2917         _eventData_.amountWon = _win;
2918         _eventData_.genAmount = _gen;
2919         _eventData_.P3DAmount = _p3d;
2920         _eventData_.newPot = _res;
2921         
2922         // start next round
2923         rID_++;
2924         _rID++;
2925         round_[_rID].strt = now;
2926         round_[_rID].end = now.add(rndInit_).add(rndGap_);
2927         round_[_rID].pot = _res;
2928         
2929         return(_eventData_);
2930     }
2931     
2932     /**
2933      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
2934      */
2935     function updateGenVault(uint256 _pID, uint256 _rIDlast)
2936         private 
2937     {
2938         uint256 _earnings = calcUnMaskedEarnings(_pID, _rIDlast);
2939         if (_earnings > 0)
2940         {
2941             // put in gen vault
2942             plyr_[_pID].gen = _earnings.add(plyr_[_pID].gen);
2943             // zero out their earnings by updating mask
2944             plyrRnds_[_pID][_rIDlast].mask = _earnings.add(plyrRnds_[_pID][_rIDlast].mask);
2945         }
2946     }
2947     
2948     /**
2949      * @dev updates round timer based on number of whole keys bought.
2950      */
2951     function updateTimer(uint256 _keys, uint256 _rID)
2952         private
2953     {
2954         // grab time
2955         uint256 _now = now;
2956         
2957         // calculate time based on number of keys bought
2958         uint256 _newTime;
2959         if (_now > round_[_rID].end && round_[_rID].plyr == 0)
2960             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(_now);
2961         else
2962             _newTime = (((_keys) / (1000000000000000000)).mul(rndInc_)).add(round_[_rID].end);
2963         
2964         // compare to max and set new end time
2965         if (_newTime < (rndMax_).add(_now))
2966             round_[_rID].end = _newTime;
2967         else
2968             round_[_rID].end = rndMax_.add(_now);
2969     }
2970     
2971     /**
2972      * @dev generates a random number between 0-99 and checks to see if thats
2973      * resulted in an airdrop win
2974      * @return do we have a winner?
2975      */
2976     function airdrop()
2977         private 
2978         view 
2979         returns(bool)
2980     {
2981         uint256 seed = uint256(keccak256(abi.encodePacked(
2982             
2983             (block.timestamp).add
2984             (block.difficulty).add
2985             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
2986             (block.gaslimit).add
2987             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
2988             (block.number)
2989             
2990         )));
2991         if((seed - ((seed / 1000) * 1000)) < airDropTracker_)
2992             return(true);
2993         else
2994             return(false);
2995     }
2996 
2997     /**
2998      * @dev distributes eth based on fees to com, aff, and p3d
2999      */
3000     function distributeExternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _affID, uint256 _team, F3Ddatasets.EventReturns memory _eventData_)
3001         private
3002         returns(F3Ddatasets.EventReturns)
3003     {
3004         // pay 2% out to community rewards
3005         uint256 _com = _eth / 50;
3006         uint256 _p3d;
3007         if (!address(FundForwarderMain).call.value(_com)(bytes4(keccak256("deposit()"))))
3008         {
3009             // This ensures Team Just cannot influence the outcome of FoMo3D with
3010             // bank migrations by breaking outgoing transactions.
3011             // Something we would never do. But that's not the point.
3012             // We spent 2000$ in eth re-deploying just to patch this, we hold the 
3013             // highest belief that everything we create should be trustless.
3014             // Team JUST, The name you shouldn't have to trust.
3015             _p3d = _com;
3016             _com = 0;
3017         }
3018         
3019         // pay 1% out to FoMo3D short
3020         uint256 _long = _eth / 100;
3021         otherF3D_.potSwap.value(_long)();
3022         
3023         // distribute share to affiliate
3024         uint256 _aff = _eth / 10;
3025         
3026         // decide what to do with affiliate share of fees
3027         // affiliate must not be self, and must have a name registered
3028         if (_affID != _pID && plyr_[_affID].name != '') {
3029             plyr_[_affID].aff = _aff.add(plyr_[_affID].aff);
3030             emit F3Devents.onAffiliatePayout(_affID, plyr_[_affID].addr, plyr_[_affID].name, _rID, _pID, _aff, now);
3031         } else {
3032             _p3d = _aff;
3033         }
3034         
3035         // pay out p3d
3036         _p3d = _p3d.add((_eth.mul(fees_[_team].p3d)) / (100));
3037         if (_p3d > 0)
3038         {
3039             // deposit to divies contract
3040             // todo: 干掉
3041             // Divies.deposit.value(_p3d)();
3042             FundForwarderMain.deposit.value(_p3d)();
3043             // set up event data
3044             _eventData_.P3DAmount = _p3d.add(_eventData_.P3DAmount);
3045         }
3046         
3047         return(_eventData_);
3048     }
3049     
3050     function potSwap()
3051         external
3052         payable
3053     {
3054         // setup local rID
3055         uint256 _rID = rID_ + 1;
3056         
3057         round_[_rID].pot = round_[_rID].pot.add(msg.value);
3058         emit F3Devents.onPotSwapDeposit(_rID, msg.value);
3059     }
3060     
3061     /**
3062      * @dev distributes eth based on fees to gen and pot
3063      */
3064     function distributeInternal(uint256 _rID, uint256 _pID, uint256 _eth, uint256 _team, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
3065         private
3066         returns(F3Ddatasets.EventReturns)
3067     {
3068         // calculate gen share
3069         uint256 _gen = (_eth.mul(fees_[_team].gen)) / 100;
3070         
3071         // toss 1% into airdrop pot 
3072         uint256 _air = (_eth / 100);
3073         airDropPot_ = airDropPot_.add(_air);
3074         
3075         // update eth balance (eth = eth - (com share + pot swap share + aff share + p3d share + airdrop pot share))
3076         _eth = _eth.sub(((_eth.mul(14)) / 100).add((_eth.mul(fees_[_team].p3d)) / 100));
3077         
3078         // calculate pot 
3079         uint256 _pot = _eth.sub(_gen);
3080         
3081         // distribute gen share (thats what updateMasks() does) and adjust
3082         // balances for dust.
3083         uint256 _dust = updateMasks(_rID, _pID, _gen, _keys);
3084         if (_dust > 0)
3085             _gen = _gen.sub(_dust);
3086         
3087         // add eth to pot
3088         round_[_rID].pot = _pot.add(_dust).add(round_[_rID].pot);
3089         
3090         // set up event data
3091         _eventData_.genAmount = _gen.add(_eventData_.genAmount);
3092         _eventData_.potAmount = _pot;
3093         
3094         return(_eventData_);
3095     }
3096 
3097     /**
3098      * @dev updates masks for round and player when keys are bought
3099      * @return dust left over 
3100      */
3101     function updateMasks(uint256 _rID, uint256 _pID, uint256 _gen, uint256 _keys)
3102         private
3103         returns(uint256)
3104     {
3105         /* MASKING NOTES
3106             earnings masks are a tricky thing for people to wrap their minds around.
3107             the basic thing to understand here.  is were going to have a global
3108             tracker based on profit per share for each round, that increases in
3109             relevant proportion to the increase in share supply.
3110             
3111             the player will have an additional mask that basically says "based
3112             on the rounds mask, my shares, and how much i've already withdrawn,
3113             how much is still owed to me?"
3114         */
3115         
3116         // calc profit per key & round mask based on this buy:  (dust goes to pot)
3117         uint256 _ppt = (_gen.mul(1000000000000000000)) / (round_[_rID].keys);
3118         round_[_rID].mask = _ppt.add(round_[_rID].mask);
3119             
3120         // calculate player earning from their own buy (only based on the keys
3121         // they just bought).  & update player earnings mask
3122         uint256 _pearn = (_ppt.mul(_keys)) / (1000000000000000000);
3123         plyrRnds_[_pID][_rID].mask = (((round_[_rID].mask.mul(_keys)) / (1000000000000000000)).sub(_pearn)).add(plyrRnds_[_pID][_rID].mask);
3124         
3125         // calculate & return dust
3126         return(_gen.sub((_ppt.mul(round_[_rID].keys)) / (1000000000000000000)));
3127     }
3128     
3129     /**
3130      * @dev adds up unmasked earnings, & vault earnings, sets them all to 0
3131      * @return earnings in wei format
3132      */
3133     function withdrawEarnings(uint256 _pID)
3134         private
3135         returns(uint256)
3136     {
3137         // update gen vault
3138         updateGenVault(_pID, plyr_[_pID].lrnd);
3139         
3140         // from vaults 
3141         uint256 _earnings = (plyr_[_pID].win).add(plyr_[_pID].gen).add(plyr_[_pID].aff);
3142         if (_earnings > 0)
3143         {
3144             plyr_[_pID].win = 0;
3145             plyr_[_pID].gen = 0;
3146             plyr_[_pID].aff = 0;
3147         }
3148 
3149         return(_earnings);
3150     }
3151     
3152     /**
3153      * @dev prepares compression data and fires event for buy or reload tx's
3154      */
3155     function endTx(uint256 _pID, uint256 _team, uint256 _eth, uint256 _keys, F3Ddatasets.EventReturns memory _eventData_)
3156         private
3157     {
3158         _eventData_.compressedData = _eventData_.compressedData + (now * 1000000000000000000) + (_team * 100000000000000000000000000000);
3159         _eventData_.compressedIDs = _eventData_.compressedIDs + _pID + (rID_ * 10000000000000000000000000000000000000000000000000000);
3160         
3161         emit F3Devents.onEndTx
3162         (
3163             _eventData_.compressedData,
3164             _eventData_.compressedIDs,
3165             plyr_[_pID].name,
3166             msg.sender,
3167             _eth,
3168             _keys,
3169             _eventData_.winnerAddr,
3170             _eventData_.winnerName,
3171             _eventData_.amountWon,
3172             _eventData_.newPot,
3173             _eventData_.P3DAmount,
3174             _eventData_.genAmount,
3175             _eventData_.potAmount,
3176             airDropPot_
3177         );
3178     }
3179 //==============================================================================
3180 //    (~ _  _    _._|_    .
3181 //    _)(/_(_|_|| | | \/  .
3182 //====================/=========================================================
3183     /** upon contract deploy, it will be deactivated.  this is a one time
3184      * use function that will activate the contract.  we do this so devs 
3185      * have time to set things up on the web end                            **/
3186     
3187     function activate()
3188         public
3189     {
3190         // only team just can activate 
3191         require(
3192             msg.sender == DEV_1_ADDRESS, "only team just can activate"
3193         );
3194 
3195 		// make sure that its been linked.
3196         require(address(otherF3D_) != address(0), "must link to other FoMo3D first");
3197         
3198         // can only be ran once
3199         require(activated_ == false, "fomo3d already activated");
3200         
3201         // activate the contract 
3202         activated_ = true;
3203         
3204         // lets start first round
3205 		rID_ = 1;
3206         round_[1].strt = now + rndExtra_ - rndGap_;
3207         round_[1].end = now + rndInit_ + rndExtra_;
3208     }
3209     function setOtherFomo(address _otherF3D)
3210         public
3211     {
3212         // only team just can activate 
3213         require(
3214             msg.sender == DEV_1_ADDRESS, "only team just can set"
3215         );
3216 
3217         // make sure that it HASNT yet been linked.
3218         require(address(otherF3D_) == address(0), "silly dev, you already did that");
3219         
3220         // set up other fomo3d (fast or long) for pot swap
3221         otherF3D_ = otherFoMo3D(_otherF3D);
3222     }
3223 }