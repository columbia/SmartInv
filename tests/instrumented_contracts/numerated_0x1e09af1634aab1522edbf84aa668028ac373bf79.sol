1 pragma solidity ^0.4.24;
2 
3 // File: contracts/interface/JIincForwarderInterface.sol
4 
5 interface JIincForwarderInterface {
6     function deposit() external payable returns(bool);
7     function status() external view returns(address, address, bool);
8     function startMigration(address _newCorpBank) external returns(bool);
9     function cancelMigration() external returns(bool);
10     function finishMigration() external returns(bool);
11     function setup(address _firstCorpBank) external;
12 }
13 
14 // File: contracts/interface/PlayerBookReceiverInterface.sol
15 
16 interface PlayerBookReceiverInterface {
17     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
18     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
19 }
20 
21 // File: contracts/interface/TeamJustInterface.sol
22 
23 interface TeamJustInterface {
24     function requiredSignatures() external view returns(uint256);
25     function requiredDevSignatures() external view returns(uint256);
26     function adminCount() external view returns(uint256);
27     function devCount() external view returns(uint256);
28     function adminName(address _who) external view returns(bytes32);
29     function isAdmin(address _who) external view returns(bool);
30     function isDev(address _who) external view returns(bool);
31 }
32 
33 // File: contracts/library/MSFun.sol
34 
35 /** @title -MSFun- v0.2.4
36  * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
37  *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
38  *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
39  *                                  _____                      _____
40  *                                 (, /     /)       /) /)    (, /      /)          /)
41  *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
42  *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
43  *          ┴ ┴                /   /          .-/ _____   (__ /                               
44  *                            (__ /          (_/ (, /                                      /)™ 
45  *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
46  * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
47  * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
48  * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
49  *  _           _             _  _  _  _             _  _  _  _  _                                      
50  *=(_) _     _ (_)==========_(_)(_)(_)(_)_==========(_)(_)(_)(_)(_)================================*
51  * (_)(_)   (_)(_)         (_)          (_)         (_)       _         _    _  _  _  _                 
52  * (_) (_)_(_) (_)         (_)_  _  _  _            (_) _  _ (_)       (_)  (_)(_)(_)(_)_               
53  * (_)   (_)   (_)           (_)(_)(_)(_)_          (_)(_)(_)(_)       (_)  (_)        (_)              
54  * (_)         (_)  _  _    _           (_)  _  _   (_)      (_)       (_)  (_)        (_)  _  _        
55  *=(_)=========(_)=(_)(_)==(_)_  _  _  _(_)=(_)(_)==(_)======(_)_  _  _(_)_ (_)========(_)=(_)(_)==*
56  * (_)         (_) (_)(_)    (_)(_)(_)(_)   (_)(_)  (_)        (_)(_)(_) (_)(_)        (_) (_)(_)
57  *
58  * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
59  * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
60  * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
61  *  
62  *         ┌──────────────────────────────────────────────────────────────────────┐
63 
64  *         │ add multiSig requirement to functions.                               │
65  *         └──────────────────────────────────────────────────────────────────────┘
66  *                                ┌────────────────────┐
67  *                                │ Setup Instructions │
68  *                                └────────────────────┘
69 
70  * 
71 
72  *
73  * (Step 2) set up the signature data for msFun
74  * 
75  *     MSFun.Data private msData;
76  *                                ┌────────────────────┐
77  *                                │ Usage Instructions │
78  *                                └────────────────────┘
79  * at the beginning of a function
80  * 
81  *     function functionName() 
82  *     {
83  *         if (MSFun.multiSig(msData, required signatures, "functionName") == true)
84  *         {
85  *             MSFun.deleteProposal(msData, "functionName");
86  * 
87  *             // put function body here 
88  *         }
89  *     }
90  *                           ┌────────────────────────────────┐
91  *                           │ Optional Wrappers For TeamJust │
92  *                           └────────────────────────────────┘
93  * multiSig wrapper function (cuts down on inputs, improves readability)
94  * this wrapper is HIGHLY recommended
95  * 
96  *     function multiSig(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamJust.requiredSignatures(), _whatFunction));}
97  *     function multiSigDev(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamJust.requiredDevSignatures(), _whatFunction));}
98  *
99  * wrapper for delete proposal (makes code cleaner)
100  *     
101  *     function deleteProposal(bytes32 _whatFunction) private {MSFun.deleteProposal(msData, _whatFunction);}
102  *                             ┌────────────────────────────┐
103  *                             │ Utility & Vanity Functions │
104  *                             └────────────────────────────┘
105  * delete any proposal is highly recommended.  without it, if an admin calls a multiSig
106  * function, with argument inputs that the other admins do not agree upon, the function
107  * can never be executed until the undesirable arguments are approved.
108  * 
109  *     function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}
110  * 
111  * for viewing who has signed a proposal & proposal data
112  *     
113  *     function checkData(bytes32 _whatFunction) onlyAdmins() public view returns(bytes32, uint256) {return(MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}
114  *
115  * lets you check address of up to 3 signers (address)
116  * 
117  *     function checkSignersByAddress(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyAdmins() public view returns(address, address, address) {return(MSFun.checkSigner(msData, _whatFunction, _signerA), MSFun.checkSigner(msData, _whatFunction, _signerB), MSFun.checkSigner(msData, _whatFunction, _signerC));}
118  *
119  * same as above but will return names in string format.
120  *
121  *     function checkSignersByName(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyAdmins() public view returns(bytes32, bytes32, bytes32) {return(TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerA)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerB)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerC)));}
122  *                             ┌──────────────────────────┐
123  *                             │ Functions In Depth Guide │
124  *                             └──────────────────────────┘
125  * In the following examples, the Data is the proposal set for this library.  And
126  * the bytes32 is the name of the function.
127  *
128  * MSFun.multiSig(Data, uint256, bytes32) - Manages creating/updating multiSig 
129  *      proposal for the function being called.  The uint256 is the required 
130  *      number of signatures needed before the multiSig will return true.  
131  *      Upon first call, multiSig will create a proposal and store the arguments 
132  *      passed with the function call as msgData.  Any admins trying to sign the 
133  *      function call will need to send the same argument values. Once required
134  *      number of signatures is reached this will return a bool of true.
135  * 
136  * MSFun.deleteProposal(Data, bytes32) - once multiSig unlocks the function body,
137  *      you will want to delete the proposal data.  This does that.
138  *
139  * MSFun.checkMsgData(Data, bytes32) - checks the message data for any given proposal 
140  * 
141  * MSFun.checkCount(Data, bytes32) - checks the number of admins that have signed
142  *      the proposal 
143  * 
144  * MSFun.checkSigners(data, bytes32, uint256) - checks the address of a given signer.
145  *      the uint256, is the log number of the signer (ie 1st signer, 2nd signer)
146  */
147 
148 library MSFun {
149     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
150     // DATA SETS
151     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
152     // contact data setup
153     struct Data 
154     {
155         mapping (bytes32 => ProposalData) proposal_;
156     }
157     struct ProposalData 
158     {
159         // a hash of msg.data 
160         bytes32 msgData;
161         // number of signers
162         uint256 count;
163         // tracking of wither admins have signed
164         mapping (address => bool) admin;
165         // list of admins who have signed
166         mapping (uint256 => address) log;
167     }
168     
169     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
170     // MULTI SIG FUNCTIONS
171     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
172     function multiSig(Data storage self, uint256 _requiredSignatures, bytes32 _whatFunction)
173         internal
174         returns(bool) 
175     {
176         // our proposal key will be a hash of our function name + our contracts address 
177         // by adding our contracts address to this, we prevent anyone trying to circumvent
178         // the proposal's security via external calls.
179         bytes32 _whatProposal = whatProposal(_whatFunction);
180         
181         // this is just done to make the code more readable.  grabs the signature count
182         uint256 _currentCount = self.proposal_[_whatProposal].count;
183         
184         // store the address of the person sending the function call.  we use msg.sender 
185 
186 
187         // library and calls multisig, needs to use onlyAdmin modifiers or anyone who
188         // calls the function will be a signer. 
189         address _whichAdmin = msg.sender;
190         
191         // prepare our msg data.  by storing this we are able to verify that all admins
192         // are approving the same argument input to be executed for the function.  we hash 
193         // it and store in bytes32 so its size is known and comparable
194         bytes32 _msgData = keccak256(msg.data);
195         
196         // check to see if this is a new execution of this proposal or not
197         if (_currentCount == 0)
198         {
199             // if it is, lets record the original signers data
200             self.proposal_[_whatProposal].msgData = _msgData;
201             
202             // record original senders signature
203             self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
204             
205             // update log (used to delete records later, and easy way to view signers)
206             // also useful if the calling function wants to give something to a 
207             // specific signer.  
208             self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
209             
210             // track number of signatures
211             self.proposal_[_whatProposal].count += 1;  
212             
213             // if we now have enough signatures to execute the function, lets
214             // return a bool of true.  we put this here in case the required signatures
215             // is set to 1.
216             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
217                 return(true);
218             }            
219         // if its not the first execution, lets make sure the msgData matches
220         } else if (self.proposal_[_whatProposal].msgData == _msgData) {
221             // msgData is a match
222             // make sure admin hasnt already signed
223             if (self.proposal_[_whatProposal].admin[_whichAdmin] == false) 
224             {
225                 // record their signature
226                 self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
227                 
228                 // update log (used to delete records later, and easy way to view signers)
229                 self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
230                 
231                 // track number of signatures
232                 self.proposal_[_whatProposal].count += 1;  
233             }
234             
235             // if we now have enough signatures to execute the function, lets
236             // return a bool of true.
237             // we put this here for a few reasons.  (1) in normal operation, if 
238             // that last recorded signature got us to our required signatures.  we 
239             // need to return bool of true.  (2) if we have a situation where the 
240             // required number of signatures was adjusted to at or lower than our current 
241             // signature count, by putting this here, an admin who has already signed,
242             // can call the function again to make it return a true bool.  but only if
243             // they submit the correct msg data
244             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
245                 return(true);
246             }
247         }
248     }
249     
250     
251     // deletes proposal signature data after successfully executing a multiSig function
252     function deleteProposal(Data storage self, bytes32 _whatFunction)
253         internal
254     {
255         //done for readability sake
256         bytes32 _whatProposal = whatProposal(_whatFunction);
257         address _whichAdmin;
258         
259         //delete the admins votes & log.   i know for loops are terrible.  but we have to do this 
260         //for our data stored in mappings.  simply deleting the proposal itself wouldn't accomplish this.
261         for (uint256 i=0; i < self.proposal_[_whatProposal].count; i++) {
262             _whichAdmin = self.proposal_[_whatProposal].log[i];
263             delete self.proposal_[_whatProposal].admin[_whichAdmin];
264             delete self.proposal_[_whatProposal].log[i];
265         }
266         //delete the rest of the data in the record
267         delete self.proposal_[_whatProposal];
268     }
269     
270     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
271     // HELPER FUNCTIONS
272     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
273 
274     function whatProposal(bytes32 _whatFunction)
275         private
276         view
277         returns(bytes32)
278     {
279         return(keccak256(abi.encodePacked(_whatFunction,this)));
280     }
281     
282     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
283     // VANITY FUNCTIONS
284     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
285     // returns a hashed version of msg.data sent by original signer for any given function
286     function checkMsgData (Data storage self, bytes32 _whatFunction)
287         internal
288         view
289         returns (bytes32 msg_data)
290     {
291         bytes32 _whatProposal = whatProposal(_whatFunction);
292         return (self.proposal_[_whatProposal].msgData);
293     }
294     
295     // returns number of signers for any given function
296     function checkCount (Data storage self, bytes32 _whatFunction)
297         internal
298         view
299         returns (uint256 signature_count)
300     {
301         bytes32 _whatProposal = whatProposal(_whatFunction);
302         return (self.proposal_[_whatProposal].count);
303     }
304     
305     // returns address of an admin who signed for any given function
306     function checkSigner (Data storage self, bytes32 _whatFunction, uint256 _signer)
307         internal
308         view
309         returns (address signer)
310     {
311         require(_signer > 0, "MSFun checkSigner failed - 0 not allowed");
312         bytes32 _whatProposal = whatProposal(_whatFunction);
313         return (self.proposal_[_whatProposal].log[_signer - 1]);
314     }
315 }
316 
317 // File: contracts/library/NameFilter.sol
318 
319 /**
320 * @title -Name Filter- v0.1.9
321 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
322 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
323 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
324 *                                  _____                      _____
325 *                                 (, /     /)       /) /)    (, /      /)          /)
326 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
327 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
328 *          ┴ ┴                /   /          .-/ _____   (__ /                               
329 *                            (__ /          (_/ (, /                                      /)™ 
330 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
331 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
332 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
333 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
334 *              _       __    _      ____      ____  _   _    _____  ____  ___  
335 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
336 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
337 *
338 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
339 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
340 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
341 */
342 
343 library NameFilter {
344     /**
345      * @dev filters name strings
346      * -converts uppercase to lower case.  
347      * -makes sure it does not start/end with a space
348      * -makes sure it does not contain multiple spaces in a row
349      * -cannot be only numbers
350      * -cannot start with 0x 
351      * -restricts characters to A-Z, a-z, 0-9, and space.
352      * @return reprocessed string in bytes32 format
353      */
354     function nameFilter(string _input)
355         internal
356         pure
357         returns(bytes32)
358     {
359         bytes memory _temp = bytes(_input);
360         uint256 _length = _temp.length;
361         
362         //sorry limited to 32 characters
363         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
364         // make sure it doesnt start with or end with space
365         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
366         // make sure first two characters are not 0x
367         if (_temp[0] == 0x30)
368         {
369             require(_temp[1] != 0x78, "string cannot start with 0x");
370             require(_temp[1] != 0x58, "string cannot start with 0X");
371         }
372         
373         // create a bool to track if we have a non number character
374         bool _hasNonNumber;
375         
376         // convert & check
377         for (uint256 i = 0; i < _length; i++)
378         {
379             // if its uppercase A-Z
380             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
381             {
382                 // convert to lower case a-z
383                 _temp[i] = byte(uint(_temp[i]) + 32);
384                 
385                 // we have a non number
386                 if (_hasNonNumber == false)
387                     _hasNonNumber = true;
388             } else {
389                 require
390                 (
391                     // require character is a space
392                     _temp[i] == 0x20 || 
393                     // OR lowercase a-z
394                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
395                     // or 0-9
396                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
397                     "string contains invalid characters"
398                 );
399                 // make sure theres not 2x spaces in a row
400                 if (_temp[i] == 0x20)
401                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
402                 
403                 // see if we have a character other than a number
404                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
405                     _hasNonNumber = true;    
406             }
407         }
408         
409         require(_hasNonNumber == true, "string cannot be only numbers");
410         
411         bytes32 _ret;
412         assembly {
413             _ret := mload(add(_temp, 32))
414         }
415         return (_ret);
416     }
417 }
418 
419 // File: contracts/library/SafeMath.sol
420 
421 /**
422  * @title SafeMath v0.1.9
423  * @dev Math operations with safety checks that throw on error
424  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
425  * - added sqrt
426  * - added sq
427  * - added pwr 
428  * - changed asserts to requires with error log outputs
429  * - removed div, its useless
430  */
431 library SafeMath {
432     
433     /**
434     * @dev Multiplies two numbers, throws on overflow.
435     */
436     function mul(uint256 a, uint256 b) 
437         internal 
438         pure 
439         returns (uint256 c) 
440     {
441         if (a == 0) {
442             return 0;
443         }
444         c = a * b;
445         require(c / a == b, "SafeMath mul failed");
446         return c;
447     }
448 
449     /**
450     * @dev Integer division of two numbers, truncating the quotient.
451     */
452     function div(uint256 a, uint256 b) internal pure returns (uint256) {
453         // assert(b > 0); // Solidity automatically throws when dividing by 0
454         uint256 c = a / b;
455         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
456         return c;
457     }
458     
459     /**
460     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
461     */
462     function sub(uint256 a, uint256 b)
463         internal
464         pure
465         returns (uint256) 
466     {
467         require(b <= a, "SafeMath sub failed");
468         return a - b;
469     }
470 
471     /**
472     * @dev Adds two numbers, throws on overflow.
473     */
474     function add(uint256 a, uint256 b)
475         internal
476         pure
477         returns (uint256 c) 
478     {
479         c = a + b;
480         require(c >= a, "SafeMath add failed");
481         return c;
482     }
483     
484     /**
485      * @dev gives square root of given x.
486      */
487     function sqrt(uint256 x)
488         internal
489         pure
490         returns (uint256 y) 
491     {
492         uint256 z = ((add(x,1)) / 2);
493         y = x;
494         while (z < y) 
495         {
496             y = z;
497             z = ((add((x / z),z)) / 2);
498         }
499     }
500     
501     /**
502      * @dev gives square. multiplies x by x
503      */
504     function sq(uint256 x)
505         internal
506         pure
507         returns (uint256)
508     {
509         return (mul(x,x));
510     }
511     
512     /**
513      * @dev x to the power of y 
514      */
515     function pwr(uint256 x, uint256 y)
516         internal 
517         pure 
518         returns (uint256)
519     {
520         if (x==0)
521             return (0);
522         else if (y==0)
523             return (1);
524         else 
525         {
526             uint256 z = x;
527             for (uint256 i=1; i < y; i++)
528                 z = mul(z,x);
529             return (z);
530         }
531     }
532 }
533 
534 // File: contracts/PlayerBook.sol
535 
536 /*
537  * -PlayerBook - v0.3.14
538  * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
539  *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
540  *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
541  *                                  _____                      _____
542  *                                 (, /     /)       /) /)    (, /      /)          /)
543  *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
544  *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
545  *          ┴ ┴                /   /          .-/ _____   (__ /
546  *                            (__ /          (_/ (, /                                      /)™
547  *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
548  * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
549  * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
550  * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
551  *     ______   _                                 ______                 _          
552  *====(_____ \=| |===============================(____  \===============| |=============*
553  *     _____) )| |  _____  _   _  _____   ____    ____)  )  ___    ___  | |  _
554  *    |  ____/ | | (____ || | | || ___ | / ___)  |  __  (  / _ \  / _ \ | |_/ )
555  *    | |      | | / ___ || |_| || ____|| |      | |__)  )| |_| || |_| ||  _ (
556  *====|_|=======\_)\_____|=\__  ||_____)|_|======|______/==\___/==\___/=|_|=\_)=========*
557  *                        (____/
558  * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐                       
559  * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │                      
560  * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘    
561  */
562 
563 
564 
565 
566 
567 
568 
569 
570 
571 
572 
573 contract PlayerBook {
574     using NameFilter for string;
575     using SafeMath for uint256;
576     
577     //TODO:
578     
579     address public affWallet = 0x4BBd45F22aAae700F612E2e3365d2bc017B19EEC;
580     //for super player
581     uint256[] public superPlayers_;
582 //==============================================================================
583 //     _| _ _|_ _    _ _ _|_    _   .
584 //    (_|(_| | (_|  _\(/_ | |_||_)  .
585 //=============================|================================================    
586     uint256 public registrationFee_ = 0.2 ether;            // price to register a name
587     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
588     mapping(address => bytes32) public gameNames_;          // lookup a games name
589     mapping(address => uint256) public gameIDs_;            // lokup a games ID
590     uint256 public gID_;        // total number of games
591     uint256 public pID_;        // total number of players
592     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
593     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
594     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
595     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
596     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
597     struct Player {
598         address addr;
599         bytes32 name;
600         uint256 laff;
601         uint256 names;
602     }
603 
604 //==============================================================================
605 //     _ _  _  __|_ _    __|_ _  _  .
606 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
607 //==============================================================================    
608     constructor()
609         public
610     {
611         // premine the dev names (sorry not sorry)
612         // No keys are purchased with this method, it's simply locking our addresses,
613         // PID's and names for referral codes.
614         //TODO:
615         addSuperPlayer(0x7a9f5d9f4BdCf4C2Aa93e929d823FCFBD1fa19D0,"go");
616         addSuperPlayer(0x4BBd45F22aAae700F612E2e3365d2bc017B19EEC,"to");
617         addSuperPlayer(0x00904cF2F74Aba6Df6A60E089CDF9b7b155BAf6c,"just");
618     }
619 
620     function addSuperPlayer(address _addr, bytes32 _name)
621         private
622     {        
623         pID_++;
624 
625         plyr_[pID_].addr = _addr;
626         plyr_[pID_].name = _name;
627         plyr_[pID_].names = 1;
628         pIDxAddr_[_addr] = 1;
629         pIDxName_[_name] = pID_;
630         plyrNames_[pID_][_name] = true;
631         plyrNameList_[pID_][1] = _name;
632 
633         superPlayers_.push(pID_);      
634     }
635 
636 //==============================================================================
637 //     _ _  _  _|. |`. _  _ _  .
638 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
639 //==============================================================================    
640     /**
641      * @dev prevents contracts from interacting with fomo3d 
642      */
643     modifier isHuman() {
644         address _addr = msg.sender;
645         uint256 _codeLength;
646         
647         assembly {_codeLength := extcodesize(_addr)}
648         require(_codeLength == 0, "sorry humans only");
649         _;
650     }
651     
652     modifier onlyDevs() {
653         //TODO:
654         require(
655             msg.sender == 0x00904cF2F74Aba6Df6A60E089CDF9b7b155BAf6c ||
656             msg.sender == 0x00b0Beac53077938634A63306b2c801169b18464,
657             "only team just can activate"
658         );
659         _;
660     }
661     
662     modifier isRegisteredGame()
663     {
664         require(gameIDs_[msg.sender] != 0);
665         _;
666     }
667 //==============================================================================
668 //     _    _  _ _|_ _  .
669 //    (/_\/(/_| | | _\  .
670 //==============================================================================    
671     // fired whenever a player registers a name
672     event onNewName
673     (
674         uint256 indexed playerID,
675         address indexed playerAddress,
676         bytes32 indexed playerName,
677         bool isNewPlayer,
678         uint256 affiliateID,
679         address affiliateAddress,
680         bytes32 affiliateName,
681         uint256 amountPaid,
682         uint256 timeStamp
683     );
684 //==============================================================================
685 //     _  _ _|__|_ _  _ _  .
686 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
687 //=====_|=======================================================================
688     function checkIfNameValid(string _nameStr)
689         public
690         view
691         returns(bool)
692     {
693         bytes32 _name = _nameStr.nameFilter();
694         if (pIDxName_[_name] == 0)
695             return (true);
696         else 
697             return (false);
698     }
699 //==============================================================================
700 //     _    |_ |. _   |`    _  __|_. _  _  _  .
701 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
702 //====|=========================================================================    
703     /**
704      * @dev registers a name.  UI will always display the last name you registered.
705      * but you will still own all previously registered names to use as affiliate 
706      * links.
707      * - must pay a registration fee.
708      * - name must be unique
709      * - names will be converted to lowercase
710      * - name cannot start or end with a space 
711      * - cannot have more than 1 space in a row
712      * - cannot be only numbers
713      * - cannot start with 0x 
714      * - name must be at least 1 char
715      * - max length of 32 characters long
716      * - allowed characters: a-z, 0-9, and space
717      * -functionhash- 0x921dec21 (using ID for affiliate)
718      * -functionhash- 0x3ddd4698 (using address for affiliate)
719      * -functionhash- 0x685ffd83 (using name for affiliate)
720      * @param _nameString players desired name
721      * @param _affCode affiliate ID, address, or name of who refered you
722      * @param _all set to true if you want this to push your info to all games 
723      * (this might cost a lot of gas)
724      */
725     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
726         isHuman()
727         public
728         payable 
729     {
730         // make sure name fees paid
731         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
732         
733         // filter name + condition checks
734         bytes32 _name = NameFilter.nameFilter(_nameString);
735         
736         // set up address 
737         address _addr = msg.sender;
738         
739         // set up our tx event data and determine if player is new or not
740         bool _isNewPlayer = determinePID(_addr);
741         
742         // fetch player id
743         uint256 _pID = pIDxAddr_[_addr];
744         
745         // manage affiliate residuals
746         // if no affiliate code was given, no new affiliate code was given, or the 
747         // player tried to use their own pID as an affiliate code, lolz
748         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
749         {
750             // update last affiliate 
751             plyr_[_pID].laff = _affCode;
752         } else if (_affCode == _pID) {
753             _affCode = 0;
754         }
755         
756         // register name 
757         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
758     }
759     
760     function registerNameXaddr(string _nameString, address _affCode, bool _all)
761         isHuman()
762         public
763         payable 
764     {
765         // make sure name fees paid
766         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
767         
768         // filter name + condition checks
769         bytes32 _name = NameFilter.nameFilter(_nameString);
770         
771         // set up address 
772         address _addr = msg.sender;
773         
774         // set up our tx event data and determine if player is new or not
775         bool _isNewPlayer = determinePID(_addr);
776         
777         // fetch player id
778         uint256 _pID = pIDxAddr_[_addr];
779         
780         // manage affiliate residuals
781         // if no affiliate code was given or player tried to use their own, lolz
782         uint256 _affID;
783         if (_affCode != address(0) && _affCode != _addr)
784         {
785             // get affiliate ID from aff Code 
786             _affID = pIDxAddr_[_affCode];
787             
788             // if affID is not the same as previously stored 
789             if (_affID != plyr_[_pID].laff)
790             {
791                 // update last affiliate
792                 plyr_[_pID].laff = _affID;
793             }
794         }
795         
796         // register name 
797         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
798     }
799     
800     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
801         isHuman()
802         public
803         payable 
804     {
805         // make sure name fees paid
806         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
807         
808         // filter name + condition checks
809         bytes32 _name = NameFilter.nameFilter(_nameString);
810         
811         // set up address 
812         address _addr = msg.sender;
813         
814         // set up our tx event data and determine if player is new or not
815         bool _isNewPlayer = determinePID(_addr);
816         
817         // fetch player id
818         uint256 _pID = pIDxAddr_[_addr];
819         
820         // manage affiliate residuals
821         // if no affiliate code was given or player tried to use their own, lolz
822         uint256 _affID;
823         if (_affCode != "" && _affCode != _name)
824         {
825             // get affiliate ID from aff Code 
826             _affID = pIDxName_[_affCode];
827             
828             // if affID is not the same as previously stored 
829             if (_affID != plyr_[_pID].laff)
830             {
831                 // update last affiliate
832                 plyr_[_pID].laff = _affID;
833             }
834         }
835         
836         // register name 
837         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
838     }
839     
840     /**
841      * @dev players, if you registered a profile, before a game was released, or
842      * set the all bool to false when you registered, use this function to push
843      * your profile to a single game.  also, if you've  updated your name, you
844      * can use this to push your name to games of your choosing.
845      * -functionhash- 0x81c5b206
846      * @param _gameID game id 
847      */
848     function addMeToGame(uint256 _gameID)
849         isHuman()
850         public
851     {
852         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
853         address _addr = msg.sender;
854         uint256 _pID = pIDxAddr_[_addr];
855         require(_pID != 0, "hey there buddy, you dont even have an account");
856         uint256 _totalNames = plyr_[_pID].names;
857         
858         // add players profile and most recent name
859         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
860         
861         // add list of all names
862         if (_totalNames > 1)
863             for (uint256 ii = 1; ii <= _totalNames; ii++)
864                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
865     }
866     
867     /**
868      * @dev players, use this to push your player profile to all registered games.
869      * -functionhash- 0x0c6940ea
870      */
871     function addMeToAllGames()
872         isHuman()
873         public
874     {
875         address _addr = msg.sender;
876         uint256 _pID = pIDxAddr_[_addr];
877         require(_pID != 0, "hey there buddy, you dont even have an account");
878         uint256 _laff = plyr_[_pID].laff;
879         uint256 _totalNames = plyr_[_pID].names;
880         bytes32 _name = plyr_[_pID].name;
881         
882         for (uint256 i = 1; i <= gID_; i++)
883         {
884             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
885             if (_totalNames > 1)
886                 for (uint256 ii = 1; ii <= _totalNames; ii++)
887                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
888         }
889                 
890     }
891     
892     /**
893      * @dev players use this to change back to one of your old names.  tip, you'll
894      * still need to push that info to existing games.
895      * -functionhash- 0xb9291296
896      * @param _nameString the name you want to use 
897      */
898     function useMyOldName(string _nameString)
899         isHuman()
900         public 
901     {
902         // filter name, and get pID
903         bytes32 _name = _nameString.nameFilter();
904         uint256 _pID = pIDxAddr_[msg.sender];
905         
906         // make sure they own the name 
907         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
908         
909         // update their current name 
910         plyr_[_pID].name = _name;
911     }
912     
913 //==============================================================================
914 //     _ _  _ _   | _  _ . _  .
915 //    (_(_)| (/_  |(_)(_||(_  . 
916 //=====================_|=======================================================    
917     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
918         private
919     {
920         // if names already has been used, require that current msg sender owns the name
921         if (pIDxName_[_name] != 0)
922             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
923         
924         // add name to player profile, registry, and name book
925         plyr_[_pID].name = _name;
926         pIDxName_[_name] = _pID;
927         if (plyrNames_[_pID][_name] == false)
928         {
929             plyrNames_[_pID][_name] = true;
930             plyr_[_pID].names++;
931             plyrNameList_[_pID][plyr_[_pID].names] = _name;
932         }
933         
934         // registration fee goes directly to community rewards
935         //Jekyll_Island_Inc.deposit.value(address(this).balance)();
936         affWallet.transfer(address(this).balance);
937         // push player info to games
938         if (_all == true)
939             for (uint256 i = 1; i <= gID_; i++)
940                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
941         
942         // fire event
943         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
944     }
945 //==============================================================================
946 //    _|_ _  _ | _  .
947 //     | (_)(_)|_\  .
948 //==============================================================================    
949     function determinePID(address _addr)
950         private
951         returns (bool)
952     {
953         if (pIDxAddr_[_addr] == 0)
954         {
955             pID_++;
956             pIDxAddr_[_addr] = pID_;
957             plyr_[pID_].addr = _addr;
958             
959             // set the new player bool to true
960             return (true);
961         } else {
962             return (false);
963         }
964     }
965 //==============================================================================
966 //   _   _|_ _  _ _  _ |   _ _ || _  .
967 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
968 //==============================================================================
969     function getPlayerID(address _addr)
970         isRegisteredGame()
971         external
972         returns (uint256)
973     {
974         determinePID(_addr);
975         return (pIDxAddr_[_addr]);
976     }
977     function getPlayerName(uint256 _pID)
978         external
979         view
980         returns (bytes32)
981     {
982         return (plyr_[_pID].name);
983     }
984     function getPlayerLAff(uint256 _pID)
985         external
986         view
987         returns (uint256)
988     {
989         return (plyr_[_pID].laff);
990     }
991     function getPlayerAddr(uint256 _pID)
992         external
993         view
994         returns (address)
995     {
996         return (plyr_[_pID].addr);
997     }
998     function getNameFee()
999         external
1000         view
1001         returns (uint256)
1002     {
1003         return(registrationFee_);
1004     }
1005     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
1006         isRegisteredGame()
1007         external
1008         payable
1009         returns(bool, uint256)
1010     {
1011         // make sure name fees paid
1012         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
1013         
1014         // set up our tx event data and determine if player is new or not
1015         bool _isNewPlayer = determinePID(_addr);
1016         
1017         // fetch player id
1018         uint256 _pID = pIDxAddr_[_addr];
1019         
1020         // manage affiliate residuals
1021         // if no affiliate code was given, no new affiliate code was given, or the 
1022         // player tried to use their own pID as an affiliate code, lolz
1023         uint256 _affID = _affCode;
1024         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
1025         {
1026             // update last affiliate 
1027             plyr_[_pID].laff = _affID;
1028         } else if (_affID == _pID) {
1029             _affID = 0;
1030         }
1031         
1032         // register name 
1033         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
1034         
1035         return(_isNewPlayer, _affID);
1036     }
1037     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
1038         isRegisteredGame()
1039         external
1040         payable
1041         returns(bool, uint256)
1042     {
1043         // make sure name fees paid
1044         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
1045         
1046         // set up our tx event data and determine if player is new or not
1047         bool _isNewPlayer = determinePID(_addr);
1048         
1049         // fetch player id
1050         uint256 _pID = pIDxAddr_[_addr];
1051         
1052         // manage affiliate residuals
1053         // if no affiliate code was given or player tried to use their own, lolz
1054         uint256 _affID;
1055         if (_affCode != address(0) && _affCode != _addr)
1056         {
1057             // get affiliate ID from aff Code 
1058             _affID = pIDxAddr_[_affCode];
1059             
1060             // if affID is not the same as previously stored 
1061             if (_affID != plyr_[_pID].laff)
1062             {
1063                 // update last affiliate
1064                 plyr_[_pID].laff = _affID;
1065             }
1066         }
1067         
1068         // register name 
1069         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
1070         
1071         return(_isNewPlayer, _affID);
1072     }
1073     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
1074         isRegisteredGame()
1075         external
1076         payable
1077         returns(bool, uint256)
1078     {
1079         // make sure name fees paid
1080         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
1081         
1082         // set up our tx event data and determine if player is new or not
1083         bool _isNewPlayer = determinePID(_addr);
1084         
1085         // fetch player id
1086         uint256 _pID = pIDxAddr_[_addr];
1087         
1088         // manage affiliate residuals
1089         // if no affiliate code was given or player tried to use their own, lolz
1090         uint256 _affID;
1091         if (_affCode != "" && _affCode != _name)
1092         {
1093             // get affiliate ID from aff Code 
1094             _affID = pIDxName_[_affCode];
1095             
1096             // if affID is not the same as previously stored 
1097             if (_affID != plyr_[_pID].laff)
1098             {
1099                 // update last affiliate
1100                 plyr_[_pID].laff = _affID;
1101             }
1102         }
1103         
1104         // register name 
1105         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
1106         
1107         return(_isNewPlayer, _affID);
1108     }
1109     
1110 //==============================================================================
1111 //   _ _ _|_    _   .
1112 //  _\(/_ | |_||_)  .
1113 //=============|================================================================
1114     function addGame(address _gameAddress, string _gameNameStr)
1115         onlyDevs()
1116         public
1117     {
1118         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
1119  
1120         gID_++;
1121         bytes32 _name = _gameNameStr.nameFilter();
1122         gameIDs_[_gameAddress] = gID_;
1123         gameNames_[_gameAddress] = _name;
1124         games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
1125 
1126         for(uint8 i=0; i<superPlayers_.length; i++){
1127             uint256 pid =superPlayers_[i];
1128             if( pid > 0 ){
1129                 games_[gID_].receivePlayerInfo(pid, plyr_[pid].addr, plyr_[pid].name, 0);
1130             }
1131         }        
1132     }
1133     
1134     function setRegistrationFee(uint256 _fee)
1135         onlyDevs()
1136         public
1137     {
1138 
1139         registrationFee_ = _fee;
1140         
1141     }
1142         
1143 }