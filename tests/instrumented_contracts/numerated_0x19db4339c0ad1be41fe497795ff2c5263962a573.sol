1 pragma solidity ^0.4.24;
2 
3 // File: contracts\library\SafeMath.sol
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
118 // File: contracts\library\NameFilter.sol
119 
120 /**
121 * @title -Name Filter- v0.1.9
122 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
123 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
124 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
125 *                                  _____                      _____
126 *                                 (, /     /)       /) /)    (, /      /)          /)
127 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
128 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
129 *          ┴ ┴                /   /          .-/ _____   (__ /                               
130 *                            (__ /          (_/ (, /                                      /)™ 
131 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
132 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
133 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
134 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
135 *              _       __    _      ____      ____  _   _    _____  ____  ___  
136 *=============| |\ |  / /\  | |\/| | |_ =====| |_  | | | |    | |  | |_  | |_)==============*
137 *=============|_| \| /_/--\ |_|  | |_|__=====|_|   |_| |_|__  |_|  |_|__ |_| \==============*
138 *
139 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
140 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
141 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
142 */
143 
144 library NameFilter {
145     /**
146      * @dev filters name strings
147      * -converts uppercase to lower case.  
148      * -makes sure it does not start/end with a space
149      * -makes sure it does not contain multiple spaces in a row
150      * -cannot be only numbers
151      * -cannot start with 0x 
152      * -restricts characters to A-Z, a-z, 0-9, and space.
153      * @return reprocessed string in bytes32 format
154      */
155     function nameFilter(string _input)
156         internal
157         pure
158         returns(bytes32)
159     {
160         bytes memory _temp = bytes(_input);
161         uint256 _length = _temp.length;
162         
163         //sorry limited to 32 characters
164         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
165         // make sure it doesnt start with or end with space
166         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
167         // make sure first two characters are not 0x
168         if (_temp[0] == 0x30)
169         {
170             require(_temp[1] != 0x78, "string cannot start with 0x");
171             require(_temp[1] != 0x58, "string cannot start with 0X");
172         }
173         
174         // create a bool to track if we have a non number character
175         bool _hasNonNumber;
176         
177         // convert & check
178         for (uint256 i = 0; i < _length; i++)
179         {
180             // if its uppercase A-Z
181             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
182             {
183                 // convert to lower case a-z
184                 _temp[i] = byte(uint(_temp[i]) + 32);
185                 
186                 // we have a non number
187                 if (_hasNonNumber == false)
188                     _hasNonNumber = true;
189             } else {
190                 require
191                 (
192                     // require character is a space
193                     _temp[i] == 0x20 || 
194                     // OR lowercase a-z
195                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
196                     // or 0-9
197                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
198                     "string contains invalid characters"
199                 );
200                 // make sure theres not 2x spaces in a row
201                 if (_temp[i] == 0x20)
202                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
203                 
204                 // see if we have a character other than a number
205                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
206                     _hasNonNumber = true;    
207             }
208         }
209         
210         require(_hasNonNumber == true, "string cannot be only numbers");
211         
212         bytes32 _ret;
213         assembly {
214             _ret := mload(add(_temp, 32))
215         }
216         return (_ret);
217     }
218 }
219 
220 // File: contracts\library\MSFun.sol
221 
222 /** @title -MSFun- v0.2.4
223  * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
224  *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
225  *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
226  *                                  _____                      _____
227  *                                 (, /     /)       /) /)    (, /      /)          /)
228  *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
229  *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
230  *          ┴ ┴                /   /          .-/ _____   (__ /                               
231  *                            (__ /          (_/ (, /                                      /)™ 
232  *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
233  * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
234  * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
235  * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
236  *  _           _             _  _  _  _             _  _  _  _  _                                      
237  *=(_) _     _ (_)==========_(_)(_)(_)(_)_==========(_)(_)(_)(_)(_)================================*
238  * (_)(_)   (_)(_)         (_)          (_)         (_)       _         _    _  _  _  _                 
239  * (_) (_)_(_) (_)         (_)_  _  _  _            (_) _  _ (_)       (_)  (_)(_)(_)(_)_               
240  * (_)   (_)   (_)           (_)(_)(_)(_)_          (_)(_)(_)(_)       (_)  (_)        (_)              
241  * (_)         (_)  _  _    _           (_)  _  _   (_)      (_)       (_)  (_)        (_)  _  _        
242  *=(_)=========(_)=(_)(_)==(_)_  _  _  _(_)=(_)(_)==(_)======(_)_  _  _(_)_ (_)========(_)=(_)(_)==*
243  * (_)         (_) (_)(_)    (_)(_)(_)(_)   (_)(_)  (_)        (_)(_)(_) (_)(_)        (_) (_)(_)
244  *
245  * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
246  * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
247  * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
248  *  
249  *         ┌──────────────────────────────────────────────────────────────────────┐
250  *         │ MSFun, is an importable library that gives your contract the ability │
251  *         │ add multiSig requirement to functions.                               │
252  *         └──────────────────────────────────────────────────────────────────────┘
253  *                                ┌────────────────────┐
254  *                                │ Setup Instructions │
255  *                                └────────────────────┘
256  * (Step 1) import the library into your contract
257  * 
258  *    import "./MSFun.sol";
259  *
260  * (Step 2) set up the signature data for msFun
261  * 
262  *     MSFun.Data private msData;
263  *                                ┌────────────────────┐
264  *                                │ Usage Instructions │
265  *                                └────────────────────┘
266  * at the beginning of a function
267  * 
268  *     function functionName() 
269  *     {
270  *         if (MSFun.multiSig(msData, required signatures, "functionName") == true)
271  *         {
272  *             MSFun.deleteProposal(msData, "functionName");
273  * 
274  *             // put function body here 
275  *         }
276  *     }
277  *                           ┌────────────────────────────────┐
278  *                           │ Optional Wrappers For TeamJust │
279  *                           └────────────────────────────────┘
280  * multiSig wrapper function (cuts down on inputs, improves readability)
281  * this wrapper is HIGHLY recommended
282  * 
283  *     function multiSig(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamJust.requiredSignatures(), _whatFunction));}
284  *     function multiSigDev(bytes32 _whatFunction) private returns (bool) {return(MSFun.multiSig(msData, TeamJust.requiredDevSignatures(), _whatFunction));}
285  *
286  * wrapper for delete proposal (makes code cleaner)
287  *     
288  *     function deleteProposal(bytes32 _whatFunction) private {MSFun.deleteProposal(msData, _whatFunction);}
289  *                             ┌────────────────────────────┐
290  *                             │ Utility & Vanity Functions │
291  *                             └────────────────────────────┘
292  * delete any proposal is highly recommended.  without it, if an admin calls a multiSig
293  * function, with argument inputs that the other admins do not agree upon, the function
294  * can never be executed until the undesirable arguments are approved.
295  * 
296  *     function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}
297  * 
298  * for viewing who has signed a proposal & proposal data
299  *     
300  *     function checkData(bytes32 _whatFunction) onlyAdmins() public view returns(bytes32, uint256) {return(MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}
301  *
302  * lets you check address of up to 3 signers (address)
303  * 
304  *     function checkSignersByAddress(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyAdmins() public view returns(address, address, address) {return(MSFun.checkSigner(msData, _whatFunction, _signerA), MSFun.checkSigner(msData, _whatFunction, _signerB), MSFun.checkSigner(msData, _whatFunction, _signerC));}
305  *
306  * same as above but will return names in string format.
307  *
308  *     function checkSignersByName(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyAdmins() public view returns(bytes32, bytes32, bytes32) {return(TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerA)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerB)), TeamJust.adminName(MSFun.checkSigner(msData, _whatFunction, _signerC)));}
309  *                             ┌──────────────────────────┐
310  *                             │ Functions In Depth Guide │
311  *                             └──────────────────────────┘
312  * In the following examples, the Data is the proposal set for this library.  And
313  * the bytes32 is the name of the function.
314  *
315  * MSFun.multiSig(Data, uint256, bytes32) - Manages creating/updating multiSig 
316  *      proposal for the function being called.  The uint256 is the required 
317  *      number of signatures needed before the multiSig will return true.  
318  *      Upon first call, multiSig will create a proposal and store the arguments 
319  *      passed with the function call as msgData.  Any admins trying to sign the 
320  *      function call will need to send the same argument values. Once required
321  *      number of signatures is reached this will return a bool of true.
322  * 
323  * MSFun.deleteProposal(Data, bytes32) - once multiSig unlocks the function body,
324  *      you will want to delete the proposal data.  This does that.
325  *
326  * MSFun.checkMsgData(Data, bytes32) - checks the message data for any given proposal 
327  * 
328  * MSFun.checkCount(Data, bytes32) - checks the number of admins that have signed
329  *      the proposal 
330  * 
331  * MSFun.checkSigners(data, bytes32, uint256) - checks the address of a given signer.
332  *      the uint256, is the log number of the signer (ie 1st signer, 2nd signer)
333  */
334 
335 library MSFun {
336     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
337     // DATA SETS
338     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
339     // contact data setup
340     struct Data 
341     {
342         mapping (bytes32 => ProposalData) proposal_;
343     }
344     struct ProposalData 
345     {
346         // a hash of msg.data 
347         bytes32 msgData;
348         // number of signers
349         uint256 count;
350         // tracking of wither admins have signed
351         mapping (address => bool) admin;
352         // list of admins who have signed
353         mapping (uint256 => address) log;
354     }
355     
356     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
357     // MULTI SIG FUNCTIONS
358     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
359     function multiSig(Data storage self, uint256 _requiredSignatures, bytes32 _whatFunction)
360         internal
361         returns(bool) 
362     {
363         // our proposal key will be a hash of our function name + our contracts address 
364         // by adding our contracts address to this, we prevent anyone trying to circumvent
365         // the proposal's security via external calls.
366         bytes32 _whatProposal = whatProposal(_whatFunction);
367         
368         // this is just done to make the code more readable.  grabs the signature count
369         uint256 _currentCount = self.proposal_[_whatProposal].count;
370         
371         // store the address of the person sending the function call.  we use msg.sender 
372         // here as a layer of security.  in case someone imports our contract and tries to 
373         // circumvent function arguments.  still though, our contract that imports this
374         // library and calls multisig, needs to use onlyAdmin modifiers or anyone who
375         // calls the function will be a signer. 
376         address _whichAdmin = msg.sender;
377         
378         // prepare our msg data.  by storing this we are able to verify that all admins
379         // are approving the same argument input to be executed for the function.  we hash 
380         // it and store in bytes32 so its size is known and comparable
381         bytes32 _msgData = keccak256(msg.data);
382         
383         // check to see if this is a new execution of this proposal or not
384         if (_currentCount == 0)
385         {
386             // if it is, lets record the original signers data
387             self.proposal_[_whatProposal].msgData = _msgData;
388             
389             // record original senders signature
390             self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
391             
392             // update log (used to delete records later, and easy way to view signers)
393             // also useful if the calling function wants to give something to a 
394             // specific signer.  
395             self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
396             
397             // track number of signatures
398             self.proposal_[_whatProposal].count += 1;  
399             
400             // if we now have enough signatures to execute the function, lets
401             // return a bool of true.  we put this here in case the required signatures
402             // is set to 1.
403             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
404                 return(true);
405             }            
406         // if its not the first execution, lets make sure the msgData matches
407         } else if (self.proposal_[_whatProposal].msgData == _msgData) {
408             // msgData is a match
409             // make sure admin hasnt already signed
410             if (self.proposal_[_whatProposal].admin[_whichAdmin] == false) 
411             {
412                 // record their signature
413                 self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
414                 
415                 // update log (used to delete records later, and easy way to view signers)
416                 self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
417                 
418                 // track number of signatures
419                 self.proposal_[_whatProposal].count += 1;  
420             }
421             
422             // if we now have enough signatures to execute the function, lets
423             // return a bool of true.
424             // we put this here for a few reasons.  (1) in normal operation, if 
425             // that last recorded signature got us to our required signatures.  we 
426             // need to return bool of true.  (2) if we have a situation where the 
427             // required number of signatures was adjusted to at or lower than our current 
428             // signature count, by putting this here, an admin who has already signed,
429             // can call the function again to make it return a true bool.  but only if
430             // they submit the correct msg data
431             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
432                 return(true);
433             }
434         }
435     }
436     
437     
438     // deletes proposal signature data after successfully executing a multiSig function
439     function deleteProposal(Data storage self, bytes32 _whatFunction)
440         internal
441     {
442         //done for readability sake
443         bytes32 _whatProposal = whatProposal(_whatFunction);
444         address _whichAdmin;
445         
446         //delete the admins votes & log.   i know for loops are terrible.  but we have to do this 
447         //for our data stored in mappings.  simply deleting the proposal itself wouldn't accomplish this.
448         for (uint256 i=0; i < self.proposal_[_whatProposal].count; i++) {
449             _whichAdmin = self.proposal_[_whatProposal].log[i];
450             delete self.proposal_[_whatProposal].admin[_whichAdmin];
451             delete self.proposal_[_whatProposal].log[i];
452         }
453         //delete the rest of the data in the record
454         delete self.proposal_[_whatProposal];
455     }
456     
457     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
458     // HELPER FUNCTIONS
459     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
460 
461     function whatProposal(bytes32 _whatFunction)
462         private
463         view
464         returns(bytes32)
465     {
466         return(keccak256(abi.encodePacked(_whatFunction,this)));
467     }
468     
469     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
470     // VANITY FUNCTIONS
471     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
472     // returns a hashed version of msg.data sent by original signer for any given function
473     function checkMsgData (Data storage self, bytes32 _whatFunction)
474         internal
475         view
476         returns (bytes32 msg_data)
477     {
478         bytes32 _whatProposal = whatProposal(_whatFunction);
479         return (self.proposal_[_whatProposal].msgData);
480     }
481     
482     // returns number of signers for any given function
483     function checkCount (Data storage self, bytes32 _whatFunction)
484         internal
485         view
486         returns (uint256 signature_count)
487     {
488         bytes32 _whatProposal = whatProposal(_whatFunction);
489         return (self.proposal_[_whatProposal].count);
490     }
491     
492     // returns address of an admin who signed for any given function
493     function checkSigner (Data storage self, bytes32 _whatFunction, uint256 _signer)
494         internal
495         view
496         returns (address signer)
497     {
498         require(_signer > 0, "MSFun checkSigner failed - 0 not allowed");
499         bytes32 _whatProposal = whatProposal(_whatFunction);
500         return (self.proposal_[_whatProposal].log[_signer - 1]);
501     }
502 }
503 
504 // File: contracts\interface\TeamJustInterface.sol
505 
506 interface TeamJustInterface {
507     function requiredSignatures() external view returns(uint256);
508     function requiredDevSignatures() external view returns(uint256);
509     function adminCount() external view returns(uint256);
510     function devCount() external view returns(uint256);
511     function adminName(address _who) external view returns(bytes32);
512     function isAdmin(address _who) external view returns(bool);
513     function isDev(address _who) external view returns(bool);
514 }
515 
516 // File: contracts\interface\JIincForwarderInterface.sol
517 
518 interface JIincForwarderInterface {
519     function deposit() external payable returns(bool);
520     function status() external view returns(address, address, bool);
521     function startMigration(address _newCorpBank) external returns(bool);
522     function cancelMigration() external returns(bool);
523     function finishMigration() external returns(bool);
524     function setup(address _firstCorpBank) external;
525 }
526 
527 // File: contracts\interface\PlayerBookReceiverInterface.sol
528 
529 interface PlayerBookReceiverInterface {
530     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
531     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
532 }
533 
534 // File: contracts\PlayerBook.sol
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
571 contract PlayerBook {
572     using NameFilter for string;
573     using SafeMath for uint256;
574     
575     //TODO:
576     
577     address public affWallet = 0xeCd0D41045030e974C7b94a1C5CcB334D2E6a755;
578 //==============================================================================
579 //     _| _ _|_ _    _ _ _|_    _   .
580 //    (_|(_| | (_|  _\(/_ | |_||_)  .
581 //=============================|================================================    
582     uint256 public registrationFee_ = 10 finney;            // price to register a name
583     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
584     mapping(address => bytes32) public gameNames_;          // lookup a games name
585     mapping(address => uint256) public gameIDs_;            // lokup a games ID
586     uint256 public gID_;        // total number of games
587     uint256 public pID_;        // total number of players
588     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
589     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
590     mapping (uint256 => Player) public plyr_;               // (pID => data) player data
591     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
592     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
593     struct Player {
594         address addr;
595         bytes32 name;
596         uint256 laff;
597         uint256 names;
598     }
599 //==============================================================================
600 //     _ _  _  __|_ _    __|_ _  _  .
601 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
602 //==============================================================================    
603     constructor()
604         public
605     {
606         // premine the dev names (sorry not sorry)
607         // No keys are purchased with this method, it's simply locking our addresses,
608         // PID's and names for referral codes.
609         //TODO:
610 
611         plyr_[1].addr = 0x326d8d593195a3153f6d55d7791c10af9bcef597;
612         plyr_[1].name = "justo";
613         plyr_[1].names = 1;
614         pIDxAddr_[0x326d8d593195a3153f6d55d7791c10af9bcef597] = 1;
615         pIDxName_["justo"] = 1;
616         plyrNames_[1]["justo"] = true;
617         plyrNameList_[1][1] = "justo";
618         
619         plyr_[2].addr = 0x15B474F7DE7157FA0dB9FaaA8b82761E78E804B9;
620         plyr_[2].name = "mantso";
621         plyr_[2].names = 1;
622         pIDxAddr_[0x15B474F7DE7157FA0dB9FaaA8b82761E78E804B9] = 2;
623         pIDxName_["mantso"] = 2;
624         plyrNames_[2]["mantso"] = true;
625         plyrNameList_[2][1] = "mantso";
626         
627         plyr_[3].addr = 0xD3d96E74aFAE57B5191DC44Bdb08b037355523Ba;
628         plyr_[3].name = "sumpunk";
629         plyr_[3].names = 1;
630         pIDxAddr_[0xD3d96E74aFAE57B5191DC44Bdb08b037355523Ba] = 3;
631         pIDxName_["sumpunk"] = 3;
632         plyrNames_[3]["sumpunk"] = true;
633         plyrNameList_[3][1] = "sumpunk";
634         
635     
636         plyr_[4].addr = 0x0c2d482FBc1da4DaCf3CD05b6A5955De1A296fa8;
637         plyr_[4].name = "wang";
638         plyr_[4].names = 1;
639         pIDxAddr_[0x0c2d482FBc1da4DaCf3CD05b6A5955De1A296fa8] = 4;
640         pIDxName_["wang"] = 4;
641         plyrNames_[4]["wang"] = true;
642         plyrNameList_[4][1] = "wang";
643         
644         pID_ = 4;
645     }
646 //==============================================================================
647 //     _ _  _  _|. |`. _  _ _  .
648 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
649 //==============================================================================    
650     /**
651      * @dev prevents contracts from interacting with fomo3d 
652      */
653     modifier isHuman() {
654         address _addr = msg.sender;
655         uint256 _codeLength;
656         
657         assembly {_codeLength := extcodesize(_addr)}
658         require(_codeLength == 0, "sorry humans only");
659         _;
660     }
661     
662     modifier onlyDevs() {
663         //TODO:
664         require(
665             msg.sender == 0xE9675cdAf47bab3Eef5B1f1c2b7f8d41cDcf9b29 ||
666             msg.sender == 0x01910b43311806Ed713bdbB08113f2153769fFC1 ,
667             "only team just can activate"
668         );
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
694 //==============================================================================
695 //     _  _ _|__|_ _  _ _  .
696 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
697 //=====_|=======================================================================
698     function checkIfNameValid(string _nameStr)
699         public
700         view
701         returns(bool)
702     {
703         bytes32 _name = _nameStr.nameFilter();
704         if (pIDxName_[_name] == 0)
705             return (true);
706         else 
707             return (false);
708     }
709 //==============================================================================
710 //     _    |_ |. _   |`    _  __|_. _  _  _  .
711 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
712 //====|=========================================================================    
713     /**
714      * @dev registers a name.  UI will always display the last name you registered.
715      * but you will still own all previously registered names to use as affiliate 
716      * links.
717      * - must pay a registration fee.
718      * - name must be unique
719      * - names will be converted to lowercase
720      * - name cannot start or end with a space 
721      * - cannot have more than 1 space in a row
722      * - cannot be only numbers
723      * - cannot start with 0x 
724      * - name must be at least 1 char
725      * - max length of 32 characters long
726      * - allowed characters: a-z, 0-9, and space
727      * -functionhash- 0x921dec21 (using ID for affiliate)
728      * -functionhash- 0x3ddd4698 (using address for affiliate)
729      * -functionhash- 0x685ffd83 (using name for affiliate)
730      * @param _nameString players desired name
731      * @param _affCode affiliate ID, address, or name of who refered you
732      * @param _all set to true if you want this to push your info to all games 
733      * (this might cost a lot of gas)
734      */
735     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
736         isHuman()
737         public
738         payable 
739     {
740         // make sure name fees paid
741         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
742         
743         // filter name + condition checks
744         bytes32 _name = NameFilter.nameFilter(_nameString);
745         
746         // set up address 
747         address _addr = msg.sender;
748         
749         // set up our tx event data and determine if player is new or not
750         bool _isNewPlayer = determinePID(_addr);
751         
752         // fetch player id
753         uint256 _pID = pIDxAddr_[_addr];
754         
755         // manage affiliate residuals
756         // if no affiliate code was given, no new affiliate code was given, or the 
757         // player tried to use their own pID as an affiliate code, lolz
758         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID) 
759         {
760             // update last affiliate 
761             plyr_[_pID].laff = _affCode;
762         } else if (_affCode == _pID) {
763             _affCode = 0;
764         }
765         
766         // register name 
767         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
768     }
769     
770     function registerNameXaddr(string _nameString, address _affCode, bool _all)
771         isHuman()
772         public
773         payable 
774     {
775         // make sure name fees paid
776         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
777         
778         // filter name + condition checks
779         bytes32 _name = NameFilter.nameFilter(_nameString);
780         
781         // set up address 
782         address _addr = msg.sender;
783         
784         // set up our tx event data and determine if player is new or not
785         bool _isNewPlayer = determinePID(_addr);
786         
787         // fetch player id
788         uint256 _pID = pIDxAddr_[_addr];
789         
790         // manage affiliate residuals
791         // if no affiliate code was given or player tried to use their own, lolz
792         uint256 _affID;
793         if (_affCode != address(0) && _affCode != _addr)
794         {
795             // get affiliate ID from aff Code 
796             _affID = pIDxAddr_[_affCode];
797             
798             // if affID is not the same as previously stored 
799             if (_affID != plyr_[_pID].laff)
800             {
801                 // update last affiliate
802                 plyr_[_pID].laff = _affID;
803             }
804         }
805         
806         // register name 
807         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
808     }
809     
810     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
811         isHuman()
812         public
813         payable 
814     {
815         // make sure name fees paid
816         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
817         
818         // filter name + condition checks
819         bytes32 _name = NameFilter.nameFilter(_nameString);
820         
821         // set up address 
822         address _addr = msg.sender;
823         
824         // set up our tx event data and determine if player is new or not
825         bool _isNewPlayer = determinePID(_addr);
826         
827         // fetch player id
828         uint256 _pID = pIDxAddr_[_addr];
829         
830         // manage affiliate residuals
831         // if no affiliate code was given or player tried to use their own, lolz
832         uint256 _affID;
833         if (_affCode != "" && _affCode != _name)
834         {
835             // get affiliate ID from aff Code 
836             _affID = pIDxName_[_affCode];
837             
838             // if affID is not the same as previously stored 
839             if (_affID != plyr_[_pID].laff)
840             {
841                 // update last affiliate
842                 plyr_[_pID].laff = _affID;
843             }
844         }
845         
846         // register name 
847         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
848     }
849     
850     /**
851      * @dev players, if you registered a profile, before a game was released, or
852      * set the all bool to false when you registered, use this function to push
853      * your profile to a single game.  also, if you've  updated your name, you
854      * can use this to push your name to games of your choosing.
855      * -functionhash- 0x81c5b206
856      * @param _gameID game id 
857      */
858     function addMeToGame(uint256 _gameID)
859         isHuman()
860         public
861     {
862         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
863         address _addr = msg.sender;
864         uint256 _pID = pIDxAddr_[_addr];
865         require(_pID != 0, "hey there buddy, you dont even have an account");
866         uint256 _totalNames = plyr_[_pID].names;
867         
868         // add players profile and most recent name
869         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
870         
871         // add list of all names
872         if (_totalNames > 1)
873             for (uint256 ii = 1; ii <= _totalNames; ii++)
874                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
875     }
876     
877     /**
878      * @dev players, use this to push your player profile to all registered games.
879      * -functionhash- 0x0c6940ea
880      */
881     function addMeToAllGames()
882         isHuman()
883         public
884     {
885         address _addr = msg.sender;
886         uint256 _pID = pIDxAddr_[_addr];
887         require(_pID != 0, "hey there buddy, you dont even have an account");
888         uint256 _laff = plyr_[_pID].laff;
889         uint256 _totalNames = plyr_[_pID].names;
890         bytes32 _name = plyr_[_pID].name;
891         
892         for (uint256 i = 1; i <= gID_; i++)
893         {
894             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
895             if (_totalNames > 1)
896                 for (uint256 ii = 1; ii <= _totalNames; ii++)
897                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
898         }
899                 
900     }
901     
902     /**
903      * @dev players use this to change back to one of your old names.  tip, you'll
904      * still need to push that info to existing games.
905      * -functionhash- 0xb9291296
906      * @param _nameString the name you want to use 
907      */
908     function useMyOldName(string _nameString)
909         isHuman()
910         public 
911     {
912         // filter name, and get pID
913         bytes32 _name = _nameString.nameFilter();
914         uint256 _pID = pIDxAddr_[msg.sender];
915         
916         // make sure they own the name 
917         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
918         
919         // update their current name 
920         plyr_[_pID].name = _name;
921     }
922     
923 //==============================================================================
924 //     _ _  _ _   | _  _ . _  .
925 //    (_(_)| (/_  |(_)(_||(_  . 
926 //=====================_|=======================================================    
927     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
928         private
929     {
930         // if names already has been used, require that current msg sender owns the name
931         if (pIDxName_[_name] != 0)
932             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
933         
934         // add name to player profile, registry, and name book
935         plyr_[_pID].name = _name;
936         pIDxName_[_name] = _pID;
937         if (plyrNames_[_pID][_name] == false)
938         {
939             plyrNames_[_pID][_name] = true;
940             plyr_[_pID].names++;
941             plyrNameList_[_pID][plyr_[_pID].names] = _name;
942         }
943         
944         // registration fee goes directly to community rewards
945         //Jekyll_Island_Inc.deposit.value(address(this).balance)();
946         affWallet.transfer(address(this).balance);
947         // push player info to games
948         if (_all == true)
949             for (uint256 i = 1; i <= gID_; i++)
950                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
951         
952         // fire event
953         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
954     }
955 //==============================================================================
956 //    _|_ _  _ | _  .
957 //     | (_)(_)|_\  .
958 //==============================================================================    
959     function determinePID(address _addr)
960         private
961         returns (bool)
962     {
963         if (pIDxAddr_[_addr] == 0)
964         {
965             pID_++;
966             pIDxAddr_[_addr] = pID_;
967             plyr_[pID_].addr = _addr;
968             
969             // set the new player bool to true
970             return (true);
971         } else {
972             return (false);
973         }
974     }
975 //==============================================================================
976 //   _   _|_ _  _ _  _ |   _ _ || _  .
977 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
978 //==============================================================================
979     function getPlayerID(address _addr)
980         isRegisteredGame()
981         external
982         returns (uint256)
983     {
984         determinePID(_addr);
985         return (pIDxAddr_[_addr]);
986     }
987     function getPlayerName(uint256 _pID)
988         external
989         view
990         returns (bytes32)
991     {
992         return (plyr_[_pID].name);
993     }
994     function getPlayerLAff(uint256 _pID)
995         external
996         view
997         returns (uint256)
998     {
999         return (plyr_[_pID].laff);
1000     }
1001     function getPlayerAddr(uint256 _pID)
1002         external
1003         view
1004         returns (address)
1005     {
1006         return (plyr_[_pID].addr);
1007     }
1008     function getNameFee()
1009         external
1010         view
1011         returns (uint256)
1012     {
1013         return(registrationFee_);
1014     }
1015     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
1016         isRegisteredGame()
1017         external
1018         payable
1019         returns(bool, uint256)
1020     {
1021         // make sure name fees paid
1022         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
1023         
1024         // set up our tx event data and determine if player is new or not
1025         bool _isNewPlayer = determinePID(_addr);
1026         
1027         // fetch player id
1028         uint256 _pID = pIDxAddr_[_addr];
1029         
1030         // manage affiliate residuals
1031         // if no affiliate code was given, no new affiliate code was given, or the 
1032         // player tried to use their own pID as an affiliate code, lolz
1033         uint256 _affID = _affCode;
1034         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID) 
1035         {
1036             // update last affiliate 
1037             plyr_[_pID].laff = _affID;
1038         } else if (_affID == _pID) {
1039             _affID = 0;
1040         }
1041         
1042         // register name 
1043         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
1044         
1045         return(_isNewPlayer, _affID);
1046     }
1047     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
1048         isRegisteredGame()
1049         external
1050         payable
1051         returns(bool, uint256)
1052     {
1053         // make sure name fees paid
1054         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
1055         
1056         // set up our tx event data and determine if player is new or not
1057         bool _isNewPlayer = determinePID(_addr);
1058         
1059         // fetch player id
1060         uint256 _pID = pIDxAddr_[_addr];
1061         
1062         // manage affiliate residuals
1063         // if no affiliate code was given or player tried to use their own, lolz
1064         uint256 _affID;
1065         if (_affCode != address(0) && _affCode != _addr)
1066         {
1067             // get affiliate ID from aff Code 
1068             _affID = pIDxAddr_[_affCode];
1069             
1070             // if affID is not the same as previously stored 
1071             if (_affID != plyr_[_pID].laff)
1072             {
1073                 // update last affiliate
1074                 plyr_[_pID].laff = _affID;
1075             }
1076         }
1077         
1078         // register name 
1079         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
1080         
1081         return(_isNewPlayer, _affID);
1082     }
1083     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
1084         isRegisteredGame()
1085         external
1086         payable
1087         returns(bool, uint256)
1088     {
1089         // make sure name fees paid
1090         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
1091         
1092         // set up our tx event data and determine if player is new or not
1093         bool _isNewPlayer = determinePID(_addr);
1094         
1095         // fetch player id
1096         uint256 _pID = pIDxAddr_[_addr];
1097         
1098         // manage affiliate residuals
1099         // if no affiliate code was given or player tried to use their own, lolz
1100         uint256 _affID;
1101         if (_affCode != "" && _affCode != _name)
1102         {
1103             // get affiliate ID from aff Code 
1104             _affID = pIDxName_[_affCode];
1105             
1106             // if affID is not the same as previously stored 
1107             if (_affID != plyr_[_pID].laff)
1108             {
1109                 // update last affiliate
1110                 plyr_[_pID].laff = _affID;
1111             }
1112         }
1113         
1114         // register name 
1115         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
1116         
1117         return(_isNewPlayer, _affID);
1118     }
1119     
1120 //==============================================================================
1121 //   _ _ _|_    _   .
1122 //  _\(/_ | |_||_)  .
1123 //=============|================================================================
1124     function addGame(address _gameAddress, string _gameNameStr)
1125         onlyDevs()
1126         public
1127     {
1128         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
1129  
1130         gID_++;
1131         bytes32 _name = _gameNameStr.nameFilter();
1132         gameIDs_[_gameAddress] = gID_;
1133         gameNames_[_gameAddress] = _name;
1134         games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
1135     
1136         games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
1137         games_[gID_].receivePlayerInfo(2, plyr_[2].addr, plyr_[2].name, 0);
1138         games_[gID_].receivePlayerInfo(3, plyr_[3].addr, plyr_[3].name, 0);
1139         games_[gID_].receivePlayerInfo(4, plyr_[4].addr, plyr_[4].name, 0);
1140         
1141     }
1142     
1143     function setRegistrationFee(uint256 _fee)
1144         onlyDevs()
1145         public
1146     {
1147 
1148         registrationFee_ = _fee;
1149         
1150     }
1151         
1152 }