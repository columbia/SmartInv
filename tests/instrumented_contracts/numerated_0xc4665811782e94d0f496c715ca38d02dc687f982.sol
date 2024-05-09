1 pragma solidity ^0.4.24;
2 
3 // File: contracts/library/SafeMath.sol
4 
5 /**
6  * @title SafeMath v0.1.9
7  * @dev Math operations with safety checks that throw on error
8  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
9  * - added sqrt
10  * - added sq
11  * - added pwr 
12  * - changed asserts to requires with error log outputs
13  * - removed div, its useless
14  */
15 library SafeMath {
16     
17     /**
18     * @dev Multiplies two numbers, throws on overflow.
19     */
20     function mul(uint256 a, uint256 b) 
21         internal 
22         pure 
23         returns (uint256 c) 
24     {
25         if (a == 0) {
26             return 0;
27         }
28         c = a * b;
29         require(c / a == b, "SafeMath mul failed");
30         return c;
31     }
32 
33     /**
34     * @dev Integer division of two numbers, truncating the quotient.
35     */
36     function div(uint256 a, uint256 b) internal pure returns (uint256) {
37         // assert(b > 0); // Solidity automatically throws when dividing by 0
38         uint256 c = a / b;
39         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40         return c;
41     }
42     
43     /**
44     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45     */
46     function sub(uint256 a, uint256 b)
47         internal
48         pure
49         returns (uint256) 
50     {
51         require(b <= a, "SafeMath sub failed");
52         return a - b;
53     }
54 
55     /**
56     * @dev Adds two numbers, throws on overflow.
57     */
58     function add(uint256 a, uint256 b)
59         internal
60         pure
61         returns (uint256 c) 
62     {
63         c = a + b;
64         require(c >= a, "SafeMath add failed");
65         return c;
66     }
67     
68     /**
69      * @dev gives square root of given x.
70      */
71     function sqrt(uint256 x)
72         internal
73         pure
74         returns (uint256 y) 
75     {
76         uint256 z = ((add(x,1)) / 2);
77         y = x;
78         while (z < y) 
79         {
80             y = z;
81             z = ((add((x / z),z)) / 2);
82         }
83     }
84     
85     /**
86      * @dev gives square. multiplies x by x
87      */
88     function sq(uint256 x)
89         internal
90         pure
91         returns (uint256)
92     {
93         return (mul(x,x));
94     }
95     
96     /**
97      * @dev x to the power of y 
98      */
99     function pwr(uint256 x, uint256 y)
100         internal 
101         pure 
102         returns (uint256)
103     {
104         if (x==0)
105             return (0);
106         else if (y==0)
107             return (1);
108         else 
109         {
110             uint256 z = x;
111             for (uint256 i=1; i < y; i++)
112                 z = mul(z,x);
113             return (z);
114         }
115     }
116 }
117 
118 // File: contracts/library/NameFilter.sol
119 
120 library NameFilter {
121     /**
122      * @dev filters name strings
123      * -converts uppercase to lower case.  
124      * -makes sure it does not start/end with a space
125      * -makes sure it does not contain multiple spaces in a row
126      * -cannot be only numbers
127      * -cannot start with 0x 
128      * -restricts characters to A-Z, a-z, 0-9, and space.
129      * @return reprocessed string in bytes32 format
130      */
131     function nameFilter(string _input)
132         internal
133         pure
134         returns(bytes32)
135     {
136         bytes memory _temp = bytes(_input);
137         uint256 _length = _temp.length;
138         
139         //sorry limited to 32 characters
140         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
141         // make sure it doesnt start with or end with space
142         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
143         // make sure first two characters are not 0x
144         if (_temp[0] == 0x30)
145         {
146             require(_temp[1] != 0x78, "string cannot start with 0x");
147             require(_temp[1] != 0x58, "string cannot start with 0X");
148         }
149         
150         // create a bool to track if we have a non number character
151         bool _hasNonNumber;
152         
153         // convert & check
154         for (uint256 i = 0; i < _length; i++)
155         {
156             // if its uppercase A-Z
157             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
158             {
159                 // convert to lower case a-z
160                 _temp[i] = byte(uint(_temp[i]) + 32);
161                 
162                 // we have a non number
163                 if (_hasNonNumber == false)
164                     _hasNonNumber = true;
165             } else {
166                 require
167                 (
168                     // require character is a space
169                     _temp[i] == 0x20 || 
170                     // OR lowercase a-z
171                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
172                     // or 0-9
173                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
174                     "string contains invalid characters"
175                 );
176                 // make sure theres not 2x spaces in a row
177                 if (_temp[i] == 0x20)
178                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
179                 
180                 // see if we have a character other than a number
181                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
182                     _hasNonNumber = true;    
183             }
184         }
185         
186         require(_hasNonNumber == true, "string cannot be only numbers");
187         
188         bytes32 _ret;
189         assembly {
190             _ret := mload(add(_temp, 32))
191         }
192         return (_ret);
193     }
194 }
195 
196 // File: contracts/library/MSFun.sol
197 
198 /** @title -MSFun- v0.2.4
199  * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
200  *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
201  *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
202  *                                  _____                      _____
203  *                                 (, /     /)       /) /)    (, /      /)          /)
204  *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
205  *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
206  *          ┴ ┴                /   /          .-/ _____   (__ /                               
207  *                            (__ /          (_/ (, /                                      /)™ 
208  *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
209  * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
210  * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
211  * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
212  *  _           _             _  _  _  _             _  _  _  _  _                                      
213  *=(_) _     _ (_)==========_(_)(_)(_)(_)_==========(_)(_)(_)(_)(_)================================*
214  * (_)(_)   (_)(_)         (_)          (_)         (_)       _         _    _  _  _  _                 
215  * (_) (_)_(_) (_)         (_)_  _  _  _            (_) _  _ (_)       (_)  (_)(_)(_)(_)_               
216  * (_)   (_)   (_)           (_)(_)(_)(_)_          (_)(_)(_)(_)       (_)  (_)        (_)              
217  * (_)         (_)  _  _    _           (_)  _  _   (_)      (_)       (_)  (_)        (_)  _  _        
218  *=(_)=========(_)=(_)(_)==(_)_  _  _  _(_)=(_)(_)==(_)======(_)_  _  _(_)_ (_)========(_)=(_)(_)==*
219  * (_)         (_) (_)(_)    (_)(_)(_)(_)   (_)(_)  (_)        (_)(_)(_) (_)(_)        (_) (_)(_)
220  *
221  * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
222  * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
223  * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
224  *  
225  *         ┌──────────────────────────────────────────────────────────────────────┐
226  *         │ MSFun, is an importable library that gives your contract the ability │
227  *         │ add multiSig requirement to functions.                               │
228  *         └──────────────────────────────────────────────────────────────────────┘
229  *                                ┌────────────────────┐
230  *                                │ Setup Instructions │
231  *                                └────────────────────┘
232  * (Step 1) import the library into your contract
233  * 
234  *    import "./MSFun.sol";
235  *
236  * (Step 2) set up the signature data for msFun
237  * 
238  *     MSFun.Data private msData;
239  *                                ┌────────────────────┐
240  *                                │ Usage Instructions │
241  *                                └────────────────────┘
242  * at the beginning of a function
243  * 
244  *     function functionName() 
245  *     {
246  *         if (MSFun.multiSig(msData, required signatures, "functionName") == true)
247  *         {
248  *             MSFun.deleteProposal(msData, "functionName");
249  * 
250  *             // put function body here 
251  *         }
252  *     }
253  *                           ┌────────────────────────────────┐
254  *                           │ Optional Wrappers For TeamJust │
255  *                           └────────────────────────────────┘
256  * multiSig wrapper function (cuts down on inputs, improves readability)
257  * this wrapper is HIGHLY recommended
258  * 
259  *     function multiSig(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamJust.requiredSignatures(), _whatFunction));}
260  *     function multiSigDev(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamJust.requiredDevSignatures(), _whatFunction));}
261  *
262  * wrapper for delete proposal (makes code cleaner)
263  *     
264  *     function deleteProposal(bytes32 _whatFunction) private {MSFun.deleteProposal(msData, _whatFunction);}
265  *                             ┌────────────────────────────┐
266  *                             │ Utility & Vanity Functions │
267  *                             └────────────────────────────┘
268  * delete any proposal is highly recommended.  without it, if an admin calls a multiSig
269  * function, with argument inputs that the other admins do not agree upon, the function
270  * can never be executed until the undesirable arguments are approved.
271  * 
272  *     function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}
273  * 
274  * for viewing who has signed a proposal & proposal data
275  *     
276  *     function checkData(bytes32 _whatFunction) onlyAdmins() public view returns(bytes32, uint256) {return(MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}
277  *
278  * lets you check address of up to 3 signers (address)
279  * 
280  *     function checkSignersByAddress(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyAdmins() public view returns(address, address, address) {return(MSFun.checkSigner(msData, _whatFunction, _signerA), MSFun.checkSigner(msData, _whatFunction, _signerB), MSFun.checkSigner(msData, _whatFunction, _signerC));}
281  *
282  * same as above but will return names in string format.
283  *
284  *     function checkSignersByName(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyAdmins() public view returns(bytes32, bytes32, bytes32) {return(TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerA)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerB)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerC)));}
285  *                             ┌──────────────────────────┐
286  *                             │ Functions In Depth Guide │
287  *                             └──────────────────────────┘
288  * In the following examples, the Data is the proposal set for this library.  And
289  * the bytes32 is the name of the function.
290  *
291  * MSFun.multiSig(Data, uint256, bytes32) - Manages creating/updating multiSig 
292  *      proposal for the function being called.  The uint256 is the required 
293  *      number of signatures needed before the multiSig will return true.  
294  *      Upon first call, multiSig will create a proposal and store the arguments 
295  *      passed with the function call as msgData.  Any admins trying to sign the 
296  *      function call will need to send the same argument values. Once required
297  *      number of signatures is reached this will return a bool of true.
298  * 
299  * MSFun.deleteProposal(Data, bytes32) - once multiSig unlocks the function body,
300  *      you will want to delete the proposal data.  This does that.
301  *
302  * MSFun.checkMsgData(Data, bytes32) - checks the message data for any given proposal 
303  * 
304  * MSFun.checkCount(Data, bytes32) - checks the number of admins that have signed
305  *      the proposal 
306  * 
307  * MSFun.checkSigners(data, bytes32, uint256) - checks the address of a given signer.
308  *      the uint256, is the log number of the signer (ie 1st signer, 2nd signer)
309  */
310 
311 library MSFun {
312     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
313     // DATA SETS
314     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
315     // contact data setup
316     struct Data 
317     {
318         mapping (bytes32 => ProposalData) proposal_;
319     }
320     struct ProposalData 
321     {
322         // a hash of msg.data 
323         bytes32 msgData;
324         // number of signers
325         uint256 count;
326         // tracking of wither admins have signed
327         mapping (address => bool) admin;
328         // list of admins who have signed
329         mapping (uint256 => address) log;
330     }
331     
332     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
333     // MULTI SIG FUNCTIONS
334     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
335     function multiSig(Data storage self, uint256 _requiredSignatures, bytes32 _whatFunction)
336         internal
337         returns(bool) 
338     {
339         // our proposal key will be a hash of our function name + our contracts address 
340         // by adding our contracts address to this, we prevent anyone trying to circumvent
341         // the proposal's security via external calls.
342         bytes32 _whatProposal = whatProposal(_whatFunction);
343         
344         // this is just done to make the code more readable.  grabs the signature count
345         uint256 _currentCount = self.proposal_[_whatProposal].count;
346         
347         // store the address of the person sending the function call.  we use msg.sender 
348         // here as a layer of security.  in case someone imports our contract and tries to 
349         // circumvent function arguments.  still though, our contract that imports this
350         // library and calls multisig, needs to use onlyAdmin modifiers or anyone who
351         // calls the function will be a signer. 
352         address _whichAdmin = msg.sender;
353         
354         // prepare our msg data.  by storing this we are able to verify that all admins
355         // are approving the same argument input to be executed for the function.  we hash 
356         // it and store in bytes32 so its size is known and comparable
357         bytes32 _msgData = keccak256(msg.data);
358         
359         // check to see if this is a new execution of this proposal or not
360         if (_currentCount == 0)
361         {
362             // if it is, lets record the original signers data
363             self.proposal_[_whatProposal].msgData = _msgData;
364             
365             // record original senders signature
366             self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
367             
368             // update log (used to delete records later, and easy way to view signers)
369             // also useful if the calling function wants to give something to a 
370             // specific signer.  
371             self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
372             
373             // track number of signatures
374             self.proposal_[_whatProposal].count += 1;  
375             
376             // if we now have enough signatures to execute the function, lets
377             // return a bool of true.  we put this here in case the required signatures
378             // is set to 1.
379             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
380                 return(true);
381             }            
382         // if its not the first execution, lets make sure the msgData matches
383         } else if (self.proposal_[_whatProposal].msgData == _msgData) {
384             // msgData is a match
385             // make sure admin hasnt already signed
386             if (self.proposal_[_whatProposal].admin[_whichAdmin] == false) 
387             {
388                 // record their signature
389                 self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
390                 
391                 // update log (used to delete records later, and easy way to view signers)
392                 self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
393                 
394                 // track number of signatures
395                 self.proposal_[_whatProposal].count += 1;  
396             }
397             
398             // if we now have enough signatures to execute the function, lets
399             // return a bool of true.
400             // we put this here for a few reasons.  (1) in normal operation, if 
401             // that last recorded signature got us to our required signatures.  we 
402             // need to return bool of true.  (2) if we have a situation where the 
403             // required number of signatures was adjusted to at or lower than our current 
404             // signature count, by putting this here, an admin who has already signed,
405             // can call the function again to make it return a true bool.  but only if
406             // they submit the correct msg data
407             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
408                 return(true);
409             }
410         }
411     }
412     
413     
414     // deletes proposal signature data after successfully executing a multiSig function
415     function deleteProposal(Data storage self, bytes32 _whatFunction)
416         internal
417     {
418         //done for readability sake
419         bytes32 _whatProposal = whatProposal(_whatFunction);
420         address _whichAdmin;
421         
422         //delete the admins votes & log.   i know for loops are terrible.  but we have to do this 
423         //for our data stored in mappings.  simply deleting the proposal itself wouldn't accomplish this.
424         for (uint256 i=0; i < self.proposal_[_whatProposal].count; i++) {
425             _whichAdmin = self.proposal_[_whatProposal].log[i];
426             delete self.proposal_[_whatProposal].admin[_whichAdmin];
427             delete self.proposal_[_whatProposal].log[i];
428         }
429         //delete the rest of the data in the record
430         delete self.proposal_[_whatProposal];
431     }
432     
433     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
434     // HELPER FUNCTIONS
435     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
436 
437     function whatProposal(bytes32 _whatFunction)
438         private
439         view
440         returns(bytes32)
441     {
442         return(keccak256(abi.encodePacked(_whatFunction,this)));
443     }
444     
445     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
446     // VANITY FUNCTIONS
447     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
448     // returns a hashed version of msg.data sent by original signer for any given function
449     function checkMsgData (Data storage self, bytes32 _whatFunction)
450         internal
451         view
452         returns (bytes32 msg_data)
453     {
454         bytes32 _whatProposal = whatProposal(_whatFunction);
455         return (self.proposal_[_whatProposal].msgData);
456     }
457     
458     // returns number of signers for any given function
459     function checkCount (Data storage self, bytes32 _whatFunction)
460         internal
461         view
462         returns (uint256 signature_count)
463     {
464         bytes32 _whatProposal = whatProposal(_whatFunction);
465         return (self.proposal_[_whatProposal].count);
466     }
467     
468     // returns address of an admin who signed for any given function
469     function checkSigner (Data storage self, bytes32 _whatFunction, uint256 _signer)
470         internal
471         view
472         returns (address signer)
473     {
474         require(_signer > 0, "MSFun checkSigner failed - 0 not allowed");
475         bytes32 _whatProposal = whatProposal(_whatFunction);
476         return (self.proposal_[_whatProposal].log[_signer - 1]);
477     }
478 }
479 
480 // File: contracts/interface/PlayerBookReceiverInterface.sol
481 
482 interface PlayerBookReceiverInterface {
483     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff, uint8 _level) external;
484     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
485 }
486 
487 // File: contracts/PlayerBook.sol
488 
489 /*
490  * -PlayerBook - v-x
491  *     ______   _                                 ______                 _          
492  *====(_____ \=| |===============================(____  \===============| |=============*
493  *     _____) )| |  _____  _   _  _____   ____    ____)  )  ___    ___  | |  _
494  *    |  ____/ | | (____ || | | || ___ | / ___)  |  __  (  / _ \  / _ \ | |_/ )
495  *    | |      | | / ___ || |_| || ____|| |      | |__)  )| |_| || |_| ||  _ (
496  *====|_|=======\_)\_____|=\__  ||_____)|_|======|______/==\___/==\___/=|_|=\_)=========*
497  *                        (____/
498  * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐                       
499  * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │          │
500  * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘    
501  */
502 
503 
504 
505 
506 
507 
508 contract PlayerBook {
509     using NameFilter for string;
510     using SafeMath for uint256;
511 
512     address private Community_Wallet1 = 0x00839c9d56F48E17d410E94309C91B9639D48242;
513     address private Community_Wallet2 = 0x53bB6E7654155b8bdb5C4c6e41C9f47Cd8Ed1814;
514     
515     MSFun.Data private msData;
516     function deleteProposal(bytes32 _whatFunction) private {MSFun.deleteProposal(msData, _whatFunction);}
517     function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}
518     function checkData(bytes32 _whatFunction) onlyDevs() public view returns(bytes32, uint256) {return(MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}
519     function checkSignersByAddress(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyDevs() public view returns(address, address, address) {return(MSFun.checkSigner(msData, _whatFunction, _signerA), MSFun.checkSigner(msData, _whatFunction, _signerB), MSFun.checkSigner(msData, _whatFunction, _signerC));}
520 //==============================================================================
521 //     _| _ _|_ _    _ _ _|_    _   .
522 //    (_|(_| | (_|  _\(/_ | |_||_)  .
523 //=============================|================================================    
524     uint256 public registrationFee_ = 10 finney;            // price to register a name
525     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
526     mapping(address => bytes32) public gameNames_;          // lookup a games name
527     mapping(address => uint256) public gameIDs_;            // lokup a games ID
528     uint256 public gID_;        // total number of games
529     uint256 public pID_;        // total number of players
530     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
531     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
532     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
533     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
534     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
535     struct Player {
536         address addr;
537         bytes32 name;
538         uint256 laff;
539         uint256 names;
540         uint256 rreward;
541         //for rank board
542         uint256 cost; //everyone charges per round
543         uint32 round; //rank round number for players
544         uint8 level;
545     }
546 
547     event eveSuperPlayer(bytes32 _name, uint256 _pid, address _addr, uint8 _level);
548     event eveResolve(uint256 _startBlockNumber, uint32 _roundNumber);
549     event eveUpdate(uint256 _pID, uint32 _roundNumber, uint256 _roundCost, uint256 _cost);
550     event eveDeposit(address _from, uint256 _value, uint256 _balance );
551     event eveReward(uint256 _pID, uint256 _have, uint256 _reward, uint256 _vault, uint256 _allcost, uint256 _lastRefrralsVault );
552     event eveWithdraw(uint256 _pID, address _addr, uint256 _reward, uint256 _balance );
553     event eveSetAffID(uint256 _pID, address _addr, uint256 _laff, address _affAddr );
554 
555 
556     mapping (uint8 => uint256) public levelValue_;
557 
558     //for super player
559     uint256[] public superPlayers_;
560 
561     //rank board data
562     uint256[] public rankPlayers_;
563     uint256[] public rankCost_;    
564 
565     //the eth of refrerrals
566     uint256 public referralsVault_;
567     //the last rank round refrefrrals
568     uint256 public lastRefrralsVault_;
569 
570     //time per round, the ethernum generate one block per 15 seconds, it will generate 24*60*60/15 blocks  per 24h
571     uint256 constant public roundBlockCount_ = 5760;
572     //the start block numnber when the rank board had been activted for first time
573     uint256 public startBlockNumber_;
574 
575     //rank top 10
576     uint8 constant public rankNumbers_ = 10;
577     //current round number
578     uint32 public roundNumber_;
579 
580     
581 
582 
583 //==============================================================================
584 //     _ _  _  __|_ _    __|_ _  _  .
585 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
586 //==============================================================================
587 
588     constructor()
589         public
590     {
591         levelValue_[3] = 0.003 ether;
592         levelValue_[2] = 0.3 ether;
593         levelValue_[1] = 1.5 ether;
594 
595         // premine the dev names (sorry not sorry)
596         // No keys are purchased with this method, it's simply locking our addresses,
597         // PID's and names for referral codes.
598 
599         pID_ = 0;
600         rankPlayers_.length = rankNumbers_;
601         rankCost_.length = rankNumbers_;
602         roundNumber_ = 0;
603         startBlockNumber_ = block.number;
604         referralsVault_ = 0;
605         lastRefrralsVault_ =0;
606 
607         
608         addSuperPlayer(0x008d20ea31021bb4C93F3051aD7763523BBb0481,"main",1);
609         addSuperPlayer(0x00De30E1A0E82750ea1f96f6D27e112f5c8A352D,"go",1);
610 
611         //
612         addSuperPlayer(0x26042eb2f06D419093313ae2486fb40167Ba349C,"jack",1);
613         addSuperPlayer(0x8d60d529c435e2A4c67FD233c49C3F174AfC72A8,"leon",1);
614         addSuperPlayer(0xF9f24b9a5FcFf3542Ae3361c394AD951a8C0B3e1,"zuopiezi",1);
615         addSuperPlayer(0x9ca974f2c49d68bd5958978e81151e6831290f57,"cowkeys",1);
616         addSuperPlayer(0xf22978ed49631b68409a16afa8e123674115011e,"vulcan",1);
617         addSuperPlayer(0x00b22a1D6CFF93831Cf2842993eFBB2181ad78de,"neo",1);
618         //
619         addSuperPlayer(0x10a04F6b13E95Bf8cC82187536b87A8646f1Bd9d,"mydream",1);
620 
621         //
622         addSuperPlayer(0xce7aed496f69e2afdb99979952d9be8a38ad941d,"uking",1);
623         addSuperPlayer(0x43fbedf2b2620ccfbd33d5c735b12066ff2fcdc1,"agg",1);
624 
625     }
626 //==============================================================================
627 //     _ _  _  _|. |`. _  _ _  .
628 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
629 //==============================================================================    
630     /**
631      * @dev prevents contracts from interacting with fomo3d 
632      */
633     modifier isHuman() {
634         address _addr = msg.sender;
635         uint256 _codeLength;
636         
637         assembly {_codeLength := extcodesize(_addr)}
638         require(_codeLength == 0, "sorry humans only");
639         _;
640     }
641 
642     // only player with reward
643     modifier onlyHaveReward() {
644         require(myReward() > 0);
645         _;
646     }
647 
648     // check address
649     modifier validAddress( address addr ) {
650         require(addr != address(0x0));
651         _;
652     }
653 
654     //devs check    
655     modifier onlyDevs(){
656         require(
657             //msg.sender == 0x00D8E8CCb4A29625D299798036825f3fa349f2b4 ||//for test
658             msg.sender == 0x00A32C09c8962AEc444ABde1991469eD0a9ccAf7 ||
659             msg.sender == 0x00aBBff93b10Ece374B14abb70c4e588BA1F799F,
660             "only dev"
661         );
662         _;
663     }
664 
665     //level check
666     modifier isLevel(uint8 _level) {
667         require(_level >= 0 && _level <= 3, "invalid level");
668         require(msg.value >= levelValue_[_level], "sorry request price less than affiliate level");
669         _;
670     }
671     
672     modifier isRegisteredGame()
673     {
674         require(gameIDs_[msg.sender] != 0);
675         _;
676     }
677 //==============================================================================
678 //     _    _  _ _|_ _  .
679 //    (/_\/(/_| | | _\  .
680 //==============================================================================    
681     // fired whenever a player registers a name
682     event onNewName
683     (
684         uint256 indexed playerID,
685         address indexed playerAddress,
686         bytes32 indexed playerName,
687         bool isNewPlayer,
688         uint256 affiliateID,
689         address affiliateAddress,
690         bytes32 affiliateName,
691         uint256 amountPaid,
692         uint256 timeStamp
693     );
694 
695 
696 //==============================================================================
697 //   _ _ _|_    _   .
698 //  _\(/_ | |_||_)  .
699 //=============|================================================================
700     function addSuperPlayer(address _addr, bytes32 _name, uint8 _level)
701         private
702     {        
703         pID_++;
704 
705         plyr_[pID_].addr = _addr;
706         plyr_[pID_].name = _name;
707         plyr_[pID_].names = 1;
708         plyr_[pID_].level = _level;
709         pIDxAddr_[_addr] = pID_;
710         pIDxName_[_name] = pID_;
711         plyrNames_[pID_][_name] = true;
712         plyrNameList_[pID_][1] = _name;
713 
714         superPlayers_.push(pID_);
715 
716         //fire event
717         emit eveSuperPlayer(_name,pID_,_addr,_level);        
718     }
719     
720     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
721     // BALANCE
722     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
723     function balances()
724         public
725         view
726         returns(uint256)
727     {
728         return (address(this).balance);
729     }
730     
731     
732     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
733     // DEPOSIT
734     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
735     function deposit()
736         validAddress(msg.sender)
737         external
738         payable
739         returns (bool)
740     {
741         if(msg.value>0){
742             referralsVault_ += msg.value;
743 
744             emit eveDeposit(msg.sender, msg.value, address(this).balance);
745 
746             return true;
747         }
748         return false;
749     }
750 
751     function updateRankBoard(uint256 _pID,uint256 _cost)
752         isRegisteredGame()
753         validAddress(msg.sender)    
754         external
755     {
756         uint256 _affID = plyr_[_pID].laff;
757         if(_affID<=0){
758             return ;
759         }
760 
761         if(_cost<=0){
762             return ;
763         }
764         //just for level 3 player
765         if(plyr_[_affID].level != 3){
766             return ;
767         }
768 
769         uint256 _affReward = _cost.mul(5)/100;
770 
771         //calc round charge
772         if(  plyr_[_affID].round == roundNumber_ ){
773             //same round
774             plyr_[_affID].cost += _affReward;
775         }
776         else{
777             //diffrent round
778             plyr_[_affID].cost = _affReward;
779             plyr_[_affID].round = roundNumber_;
780         }
781         //check board players
782         bool inBoard = false;
783         for( uint8 i=0; i<rankNumbers_; i++ ){
784             if(  _affID == rankPlayers_[i] ){
785                 //update
786                 inBoard = true;
787                 rankCost_[i] = plyr_[_affID].cost;
788                 break;
789             }
790         }
791         if( inBoard == false ){
792             //find the min charge  player
793             uint256 minCost = plyr_[_affID].cost;
794             uint8 minIndex = rankNumbers_;
795             for( uint8  k=0; k<rankNumbers_; k++){
796                 if( rankCost_[k] < minCost){
797                     minIndex = k;
798                     minCost = rankCost_[k];
799                 }            
800             }
801             if( minIndex != rankNumbers_ ){
802                 //replace
803                 rankPlayers_[minIndex] =  _affID;
804                 rankCost_[minIndex] = plyr_[_affID].cost;
805             }
806         }
807 
808         emit eveUpdate( _affID,roundNumber_,plyr_[_affID].cost,_cost);
809 
810     }
811 
812     //
813     function resolveRankBoard() 
814         //isRegisteredGame()
815         validAddress(msg.sender) 
816         external
817     {
818         uint256 deltaBlockCount = block.number - startBlockNumber_;
819         if( deltaBlockCount < roundBlockCount_ ){
820             return;
821         }
822         //update start block number
823         startBlockNumber_ = block.number;
824         //
825         emit eveResolve(startBlockNumber_,roundNumber_);
826 	   
827         roundNumber_++;
828         //reward
829         uint256 allCost = 0;
830         for( uint8 k=0; k<rankNumbers_; k++){
831             allCost += rankCost_[k];
832         }
833 
834         if( allCost > 0 ){
835             uint256 reward = 0;
836             uint256 roundVault = referralsVault_.sub(lastRefrralsVault_);
837             for( uint8 m=0; m<rankNumbers_; m++){                
838                 uint256 pid = rankPlayers_[m];
839                 if( pid>0 ){
840                     reward = (roundVault.mul(8)/10).mul(rankCost_[m])/allCost;
841                     lastRefrralsVault_ += reward;
842                     plyr_[pid].rreward += reward;
843                     emit eveReward(rankPlayers_[m],plyr_[pid].rreward, reward,referralsVault_,allCost, lastRefrralsVault_);
844                 }    
845             }
846         }
847         
848         //reset rank data
849         rankPlayers_.length=0;
850         rankCost_.length=0;
851 
852         rankPlayers_.length=10;
853         rankCost_.length=10;
854     }
855     
856     /**
857      * Withdraws all of the callers earnings.
858      */
859     function myReward()
860         public
861         view
862         returns(uint256)
863     {
864         uint256 pid = pIDxAddr_[msg.sender];
865         return plyr_[pid].rreward;
866     }
867 
868     function withdraw()
869         onlyHaveReward()
870         isHuman()
871         public
872     {
873         address addr = msg.sender;
874         uint256 pid = pIDxAddr_[addr];
875         uint256 reward = plyr_[pid].rreward;
876         
877         //reset
878         plyr_[pid].rreward = 0;
879 
880         //get reward
881         addr.transfer(reward);
882         
883         // fire event
884         emit eveWithdraw(pIDxAddr_[addr], addr, reward, balances());
885     }
886 //==============================================================================
887 //     _  _ _|__|_ _  _ _  .
888 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
889 //=====_|=======================================================================
890     function checkIfNameValid(string _nameStr)
891         public
892         view
893         returns(bool)
894     {
895         bytes32 _name = _nameStr.nameFilter();
896         if (pIDxName_[_name] == 0)
897             return (true);
898         else 
899             return (false);
900     }
901 //==============================================================================
902 //     _    |_ |. _   |`    _  __|_. _  _  _  .
903 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
904 //====|=========================================================================    
905     /**
906      * @dev registers a name.  UI will always display the last name you registered.
907      * but you will still own all previously registered names to use as affiliate 
908      * links.
909      * - must pay a registration fee.
910      * - name must be unique
911      * - names will be converted to lowercase
912      * - name cannot start or end with a space 
913      * - cannot have more than 1 space in a row
914      * - cannot be only numbers
915      * - cannot start with 0x 
916      * - name must be at least 1 char
917      * - max length of 32 characters long
918      * - allowed characters: a-z, 0-9, and space
919      * -functionhash- 0x921dec21 (using ID for affiliate)
920      * -functionhash- 0x3ddd4698 (using address for affiliate)
921      * -functionhash- 0x685ffd83 (using name for affiliate)
922      * @param _nameString players desired name
923      * @param _affCode affiliate ID, address, or name of who refered you
924      * @param _all set to true if you want this to push your info to all games 
925      * (this might cost a lot of gas)
926      */
927     function registerNameXID(string _nameString, uint256 _affCode, bool _all, uint8 _level)
928         isHuman()
929         isLevel(_level)
930         public
931         payable 
932     {
933         // make sure name fees paid
934         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
935         
936         // filter name + condition checks
937         bytes32 _name = NameFilter.nameFilter(_nameString);
938         
939         // set up address 
940         address _addr = msg.sender;
941         
942         // set up our tx event data and determine if player is new or not
943         bool _isNewPlayer = determinePID(_addr);
944         
945         // fetch player id
946         uint256 _pID = pIDxAddr_[_addr];
947         
948         // manage affiliate residuals
949         // if no affiliate code was given, no new affiliate code was given, or the 
950         // player tried to use their own pID as an affiliate code, lolz
951         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
952         {
953             // update last affiliate 
954             plyr_[_pID].laff = _affCode;
955         } else if (_affCode == _pID) {
956             _affCode = 0;
957         }
958         
959         // register name 
960 
961         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all, _level);
962     }
963     
964     function registerNameXaddr(string _nameString, address _affCode, bool _all, uint8 _level)
965         isHuman()
966         isLevel(_level)
967         public
968         payable 
969     {
970         // make sure name fees paid
971         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
972         
973         // filter name + condition checks
974         bytes32 _name = NameFilter.nameFilter(_nameString);
975         
976         // set up address 
977         address _addr = msg.sender;
978         
979         // set up our tx event data and determine if player is new or not
980         bool _isNewPlayer = determinePID(_addr);
981         
982         // fetch player id
983         uint256 _pID = pIDxAddr_[_addr];
984         
985         // manage affiliate residuals
986         // if no affiliate code was given or player tried to use their own, lolz
987         uint256 _affID;
988         if (_affCode != address(0) && _affCode != _addr)
989         {
990             // get affiliate ID from aff Code 
991             _affID = pIDxAddr_[_affCode];
992             
993             // if affID is not the same as previously stored 
994             if (_affID != plyr_[_pID].laff)
995             {
996                 // update last affiliate
997                 plyr_[_pID].laff = _affID;
998             }
999         }
1000 
1001         // register name 
1002         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all, _level);
1003     }
1004     
1005     function registerNameXname(string _nameString, bytes32 _affCode, bool _all, uint8 _level)
1006         isHuman()
1007         isLevel(_level)
1008         public
1009         payable 
1010     {
1011         // make sure name fees paid
1012         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
1013         
1014         // filter name + condition checks
1015         bytes32 _name = NameFilter.nameFilter(_nameString);
1016         
1017         // set up address 
1018         address _addr = msg.sender;
1019         
1020         // set up our tx event data and determine if player is new or not
1021         bool _isNewPlayer = determinePID(_addr);
1022         
1023         // fetch player id
1024         uint256 _pID = pIDxAddr_[_addr];
1025         
1026         // manage affiliate residuals
1027         // if no affiliate code was given or player tried to use their own, lolz
1028         uint256 _affID;
1029         if (_affCode != "" && _affCode != _name)
1030         {
1031             // get affiliate ID from aff Code 
1032             _affID = pIDxName_[_affCode];
1033             
1034             // if affID is not the same as previously stored 
1035             if (_affID != plyr_[_pID].laff)
1036             {
1037                 // update last affiliate
1038                 plyr_[_pID].laff = _affID;
1039             }
1040         }
1041         
1042         // register name 
1043         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all, _level);
1044     }
1045     
1046     /**
1047      * @dev players, if you registered a profile, before a game was released, or
1048      * set the all bool to false when you registered, use this function to push
1049      * your profile to a single game.  also, if you've  updated your name, you
1050      * can use this to push your name to games of your choosing.
1051      * -functionhash- 0x81c5b206
1052      * @param _gameID game id 
1053      */
1054     function addMeToGame(uint256 _gameID)
1055         isHuman()
1056         public
1057     {
1058         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
1059         address _addr = msg.sender;
1060         uint256 _pID = pIDxAddr_[_addr];
1061         require(_pID != 0, "hey there buddy, you dont even have an account");
1062         uint256 _totalNames = plyr_[_pID].names;
1063         
1064         // add players profile and most recent name
1065         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff, 0);
1066         
1067         // add list of all names
1068         if (_totalNames > 1)
1069             for (uint256 ii = 1; ii <= _totalNames; ii++)
1070                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
1071     }
1072     
1073     /**
1074      * @dev players, use this to push your player profile to all registered games.
1075      * -functionhash- 0x0c6940ea
1076      */
1077     function addMeToAllGames()
1078         isHuman()
1079         public
1080     {
1081         address _addr = msg.sender;
1082         uint256 _pID = pIDxAddr_[_addr];
1083         require(_pID != 0, "hey there buddy, you dont even have an account");
1084         uint256 _laff = plyr_[_pID].laff;
1085         uint256 _totalNames = plyr_[_pID].names;
1086         bytes32 _name = plyr_[_pID].name;
1087         
1088         for (uint256 i = 1; i <= gID_; i++)
1089         {
1090             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff, 0);
1091             if (_totalNames > 1)
1092                 for (uint256 ii = 1; ii <= _totalNames; ii++)
1093                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
1094         }
1095                 
1096     }
1097     
1098     /**
1099      * @dev players use this to change back to one of your old names.  tip, you'll
1100      * still need to push that info to existing games.
1101      * -functionhash- 0xb9291296
1102      * @param _nameString the name you want to use 
1103      */
1104     function useMyOldName(string _nameString)
1105         isHuman()
1106         public 
1107     {
1108         // filter name, and get pID
1109         bytes32 _name = _nameString.nameFilter();
1110         uint256 _pID = pIDxAddr_[msg.sender];
1111         
1112         // make sure they own the name 
1113         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
1114         
1115         // update their current name 
1116         plyr_[_pID].name = _name;
1117     }
1118     
1119 //==============================================================================
1120 //     _ _  _ _   | _  _ . _  .
1121 //    (_(_)| (/_  |(_)(_||(_  . 
1122 //=====================_|=======================================================    
1123     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all, uint8 _level)
1124         private
1125     {
1126         // if names already has been used, require that current msg sender owns the name
1127         if( pIDxName_[_name] == _pID && _pID !=0 ){
1128             //level up must keep old name!
1129             if (_level >= plyr_[_pID].level ) {
1130                 require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
1131             }
1132         }
1133         else if (pIDxName_[_name] != 0){
1134             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
1135         }
1136         // add name to player profile, registry, and name book
1137         plyr_[_pID].name = _name;
1138         plyr_[_pID].level = _level;
1139 
1140         pIDxName_[_name] = _pID;
1141         if (plyrNames_[_pID][_name] == false)
1142         {
1143             plyrNames_[_pID][_name] = true;
1144             plyr_[_pID].names++;
1145             plyrNameList_[_pID][plyr_[_pID].names] = _name;
1146         }
1147 
1148         // registration fee goes directly to community rewards
1149         Community_Wallet1.transfer(msg.value / 2);
1150         Community_Wallet2.transfer(msg.value / 2);
1151         
1152         // push player info to games
1153         if (_all == true)
1154             for (uint256 i = 1; i <= gID_; i++)
1155                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID, _level);
1156         
1157         // fire event
1158         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
1159     }
1160 //==============================================================================
1161 //    _|_ _  _ | _  .
1162 //     | (_)(_)|_\  .
1163 //==============================================================================    
1164     function determinePID(address _addr)
1165         private
1166         returns (bool)
1167     {
1168         if (pIDxAddr_[_addr] == 0)
1169         {
1170             pID_++;
1171             pIDxAddr_[_addr] = pID_;
1172             plyr_[pID_].addr = _addr;
1173             
1174             // set the new player bool to true
1175             return (true);
1176         } else {
1177             return (false);
1178         }
1179     }
1180 //==============================================================================
1181 //   _   _|_ _  _ _  _ |   _ _ || _  .
1182 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
1183 //==============================================================================
1184     function getPlayerID(address _addr)
1185         isRegisteredGame()
1186         external
1187         returns (uint256)
1188     {
1189         determinePID(_addr);
1190         return (pIDxAddr_[_addr]);
1191     }
1192     function getPlayerName(uint256 _pID)
1193         external
1194         view
1195         returns (bytes32)
1196     {
1197         return (plyr_[_pID].name);
1198     }
1199     function getPlayerLAff(uint256 _pID)
1200         external
1201         view
1202         returns (uint256)
1203     {
1204         return (plyr_[_pID].laff);
1205     }
1206     function getPlayerAddr(uint256 _pID)
1207         external
1208         view
1209         returns (address)
1210     {
1211         return (plyr_[_pID].addr);
1212     }
1213     function getPlayerLevel(uint256 _pID)
1214         external
1215         view
1216         returns (uint8)
1217     {
1218         return (plyr_[_pID].level);
1219     }
1220     function getNameFee()
1221         external
1222         view
1223         returns (uint256)
1224     {
1225         return(registrationFee_);
1226     }
1227 
1228     function setPlayerAffID(uint256 _pID,uint256 _laff)
1229         isRegisteredGame()
1230         external
1231     {
1232         plyr_[_pID].laff = _laff;
1233 
1234         emit eveSetAffID(_pID, plyr_[_pID].addr, _laff, plyr_[_laff].addr);
1235     }
1236 
1237     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all, uint8 _level)
1238         isRegisteredGame()
1239         isLevel(_level)
1240         external
1241         payable
1242         returns(bool, uint256)
1243     {
1244         // make sure name fees paid //TODO 已经通过 islevel
1245         //require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
1246         
1247         // set up our tx event data and determine if player is new or not
1248         bool _isNewPlayer = determinePID(_addr);
1249         
1250         // fetch player id
1251         uint256 _pID = pIDxAddr_[_addr];
1252         
1253         // manage affiliate residuals
1254         // if no affiliate code was given, no new affiliate code was given, or the 
1255         // player tried to use their own pID as an affiliate code, lolz
1256         uint256 _affID = _affCode;
1257         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
1258         {
1259             // update last affiliate
1260             if (plyr_[_pID].laff == 0)
1261                 plyr_[_pID].laff = _affID;
1262         } else if (_affID == _pID) {
1263             _affID = 0;
1264         }
1265 
1266         // register name 
1267         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all, _level);
1268         
1269         return(_isNewPlayer, _affID);
1270     }
1271     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all, uint8 _level)
1272         isRegisteredGame()
1273         isLevel(_level)
1274         external
1275         payable
1276         returns(bool, uint256)
1277     {
1278         // make sure name fees paid //TODO 已经通过 islevel
1279         //require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
1280         
1281         // set up our tx event data and determine if player is new or not
1282         bool _isNewPlayer = determinePID(_addr);
1283         
1284         // fetch player id
1285         uint256 _pID = pIDxAddr_[_addr];
1286         
1287         // manage affiliate residuals
1288         // if no affiliate code was given or player tried to use their own, lolz
1289         uint256 _affID;
1290         if (_affCode != address(0) && _affCode != _addr)
1291         {
1292             // get affiliate ID from aff Code 
1293             _affID = pIDxAddr_[_affCode];
1294             
1295             // if affID is not the same as previously stored 
1296             if (_affID != plyr_[_pID].laff)
1297             {
1298                 // update last affiliate
1299                 if (plyr_[_pID].laff == 0)
1300                     plyr_[_pID].laff = _affID;
1301             }
1302         }
1303 
1304         // register name 
1305         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all, _level);
1306         
1307         return(_isNewPlayer, _affID);
1308     }
1309     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all, uint8 _level)
1310         isRegisteredGame()
1311         isLevel(_level)
1312         external
1313         payable
1314         returns(bool, uint256)
1315     {
1316         // make sure name fees paid //TODO 已经通过 islevel
1317         //require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
1318         
1319         // set up our tx event data and determine if player is new or not
1320         bool _isNewPlayer = determinePID(_addr);
1321         
1322         // fetch player id
1323         uint256 _pID = pIDxAddr_[_addr];
1324         
1325         // manage affiliate residuals
1326         // if no affiliate code was given or player tried to use their own, lolz
1327         uint256 _affID;
1328         if (_affCode != "" && _affCode != _name)
1329         {
1330             // get affiliate ID from aff Code 
1331             _affID = pIDxName_[_affCode];
1332             
1333             // if affID is not the same as previously stored 
1334             if (_affID != plyr_[_pID].laff)
1335             {
1336                 // update last affiliate
1337                 if (plyr_[_pID].laff == 0)
1338                     plyr_[_pID].laff = _affID;
1339             }
1340         }
1341        
1342         // register name 
1343         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all, _level);
1344         
1345         return(_isNewPlayer, _affID);
1346     }
1347     
1348 //==============================================================================
1349 //   _ _ _|_    _   .
1350 //  _\(/_ | |_||_)  .
1351 //=============|================================================================
1352     function addGame(address _gameAddress, string _gameNameStr)
1353         onlyDevs()
1354         public
1355     {
1356         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
1357 
1358 
1359         deleteProposal("addGame");
1360         gID_++;
1361         bytes32 _name = _gameNameStr.nameFilter();
1362         gameIDs_[_gameAddress] = gID_;
1363         gameNames_[_gameAddress] = _name;
1364         games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
1365 
1366         for(uint8 i=0; i<superPlayers_.length; i++){
1367             uint256 pid =superPlayers_[i];
1368             if( pid > 0 ){
1369                 games_[gID_].receivePlayerInfo(pid, plyr_[pid].addr, plyr_[pid].name, 0, plyr_[pid].level);
1370             }
1371         }
1372 
1373     }
1374     
1375     function setRegistrationFee(uint256 _fee)
1376         onlyDevs()
1377         public
1378     {
1379         deleteProposal("setRegistrationFee");
1380         registrationFee_ = _fee;
1381     }
1382 }