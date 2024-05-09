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
504 // File: contracts\interface\PlayerBookReceiverInterface.sol
505 
506 interface PlayerBookReceiverInterface {
507     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
508     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
509 }
510 
511 // File: contracts\interface\PlayerBookInterface.sol
512 
513 interface PlayerBookInterface {
514     function getPlayerID(address _addr) external returns (uint256);
515     function getPlayerName(uint256 _pID) external view returns (bytes32);
516     function getPlayerLAff(uint256 _pID) external view returns (uint256);
517     function getPlayerAddr(uint256 _pID) external view returns (address);
518     function getNameFee() external view returns (uint256);
519     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
520     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
521     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
522 }
523 
524 // File: contracts\PlayerBook.sol
525 
526 contract PlayerBook is PlayerBookInterface {
527     using NameFilter for string;
528     using SafeMath for uint256;
529 
530     //TODO: 收取购买推荐资格费用账号
531     address public affWallet = 0xed68B3eD49571F1884cf2b5824656DdE35cdf54D;
532 
533 
534 
535     //==============================================================================
536     //     _| _ _|_ _    _ _ _|_    _   .
537     //    (_|(_| | (_|  _\(/_ | |_||_)  .
538     //=============================|================================================
539     uint256 public registrationFee_ = 20 finney;            // 购买推荐资格的费用
540 
541     mapping(uint256 => PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
542     mapping(address => bytes32) public gameNames_;          // lookup a games name
543     mapping(address => uint256) public gameIDs_;            // lokup a games ID
544     uint256 public gID_;        // 游戏的局数
545     uint256 public pID_;        // 合约总共的会员数目
546     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) 根据会员的钱包地址查询id
547     mapping (bytes32 => uint256) public pIDxName_;          // (name => pID) 根据会员的名字查询id
548     mapping (uint256 => Player) public plyr_;               // (pID => data) 会员数据库
549     mapping (uint256 => mapping (bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
550     mapping (uint256 => mapping (uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
551 
552 
553     struct Player {
554         address addr; //会员的地址
555         bytes32 name; //会员的名字
556         uint256 laff; //会员最后一次的推荐人
557         uint256 names; //会员姓名列表 可以删掉TODO
558         bool    isAgent; //是否成为代理
559         bool    isHasRec; //是否有推荐资格
560     }
561 //==============================================================================
562 //     _ _  _  __|_ _    __|_ _  _  .
563 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
564 //==============================================================================
565     constructor()
566         public
567     {
568 
569         plyr_[1].addr = 0xe4b3a6f1556aec6de2a7c8accdfb288d2bfb3371;
570         plyr_[1].name = "system";
571         plyr_[1].names = 1;
572         pIDxAddr_[0xe4b3a6f1556aec6de2a7c8accdfb288d2bfb3371] = 1;
573         pIDxName_["system"] = 1;
574         plyrNames_[1]["system"] = true;
575         plyrNameList_[1][1] = "system";
576 
577         pID_ = 1;
578     }
579 //==============================================================================
580 //     _ _  _  _|. |`. _  _ _  .
581 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
582 //==============================================================================
583     /**
584      * @dev prevents contracts from interacting with fomo3d
585      */
586     modifier isHuman() {
587         address _addr = msg.sender;
588         uint256 _codeLength;
589 
590         assembly {_codeLength := extcodesize(_addr)}
591         require(_codeLength == 0, "sorry humans only");
592         _;
593     }
594 
595     modifier onlyDevs() {
596         //TODO:
597         require(
598             msg.sender == 0x2191eF87E392377ec08E7c08Eb105Ef5448eCED5 ||
599             msg.sender == 0xE003d8A487ef29668d034f73F3155E78247b89cb,
600             "only team just can activate"
601         );
602         _;
603     }
604 
605     modifier isRegisteredGame()
606     {
607         require(gameIDs_[msg.sender] != 0);
608         _;
609     }
610 //==============================================================================
611 //     _    _  _ _|_ _  .
612 //    (/_\/(/_| | | _\  .
613 //==============================================================================
614     // fired whenever a player registers a name
615     event onNewName
616     (
617         uint256 indexed playerID,
618         address indexed playerAddress,
619         bytes32 indexed playerName,
620         bool isNewPlayer,
621         uint256 affiliateID,
622         address affiliateAddress,
623         bytes32 affiliateName,
624         uint256 amountPaid,
625         uint256 timeStamp
626     );
627 //==============================================================================
628 //     _  _ _|__|_ _  _ _  .
629 //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
630 //=====_|=======================================================================
631     function checkIfNameValid(string _nameStr)
632         public
633         view
634         returns(bool)
635     {
636         bytes32 _name = _nameStr.nameFilter();
637         if (pIDxName_[_name] == 0)
638             return (true);
639         else
640             return (false);
641     }
642 //==============================================================================
643 //     _    |_ |. _   |`    _  __|_. _  _  _  .
644 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
645 //====|=========================================================================
646 
647      /**
648      * @param _nameString players desired name
649      * @param _affCode affiliate ID, address, or name of who refered you
650      * @param _all set to true if you want this to push your info to all games
651      * (this might cost a lot of gas)
652      */
653     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
654         isHuman()
655         public
656         payable
657     {
658         // make sure name fees paid
659         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
660 
661         // filter name + condition checks
662         bytes32 _name = NameFilter.nameFilter(_nameString);
663 
664         // set up address
665         address _addr = msg.sender;
666 
667         // set up our tx event data and determine if player is new or not
668         bool _isNewPlayer = determinePID(_addr);
669 
670         // fetch player id
671         uint256 _pID = pIDxAddr_[_addr];
672 
673         // manage affiliate residuals
674         // if no affiliate code was given, no new affiliate code was given, or the
675         // player tried to use their own pID as an affiliate code, lolz
676         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID)
677         {
678             // update last affiliate
679             plyr_[_pID].laff = _affCode;
680         } else if (_affCode == _pID) {
681             _affCode = 0;
682         }
683 
684         // register name
685         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
686     }
687 
688     function registerNameXaddr(string _nameString, address _affCode, bool _all)
689         isHuman()
690         public
691         payable
692     {
693         // make sure name fees paid
694         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
695 
696         // filter name + condition checks
697         bytes32 _name = NameFilter.nameFilter(_nameString);
698 
699         // set up address
700         address _addr = msg.sender;
701 
702         // set up our tx event data and determine if player is new or not
703         bool _isNewPlayer = determinePID(_addr);
704 
705         // fetch player id
706         uint256 _pID = pIDxAddr_[_addr];
707 
708         // manage affiliate residuals
709         // if no affiliate code was given or player tried to use their own, lolz
710         uint256 _affID;
711         if (_affCode != address(0) && _affCode != _addr)
712         {
713             // get affiliate ID from aff Code
714             _affID = pIDxAddr_[_affCode];
715 
716             // if affID is not the same as previously stored
717             if (_affID != plyr_[_pID].laff)
718             {
719                 // update last affiliate
720                 plyr_[_pID].laff = _affID;
721             }
722         }
723 
724         // register name
725         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
726     }
727 
728     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
729         isHuman()
730         public
731         payable
732     {
733         // make sure name fees paid
734         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
735 
736         // filter name + condition checks
737         bytes32 _name = NameFilter.nameFilter(_nameString);
738 
739         // set up address
740         address _addr = msg.sender;
741 
742         // set up our tx event data and determine if player is new or not
743         bool _isNewPlayer = determinePID(_addr);
744 
745         // fetch player id
746         uint256 _pID = pIDxAddr_[_addr];
747 
748         // manage affiliate residuals
749         // if no affiliate code was given or player tried to use their own, lolz
750         uint256 _affID;
751         if (_affCode != "" && _affCode != _name)
752         {
753             // get affiliate ID from aff Code
754             _affID = pIDxName_[_affCode];
755 
756             // if affID is not the same as previously stored
757             if (_affID != plyr_[_pID].laff)
758             {
759                 // update last affiliate
760                 plyr_[_pID].laff = _affID;
761             }
762         }
763 
764         // register name
765         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
766     }
767 
768     /**
769      * @dev players, if you registered a profile, before a game was released, or
770      * set the all bool to false when you registered, use this function to push
771      * your profile to a single game.  also, if you've  updated your name, you
772      * can use this to push your name to games of your choosing.
773      * -functionhash- 0x81c5b206
774      * @param _gameID game id
775      */
776     function addMeToGame(uint256 _gameID)
777         isHuman()
778         public
779     {
780         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
781         address _addr = msg.sender;
782         uint256 _pID = pIDxAddr_[_addr];
783         require(_pID != 0, "hey there buddy, you dont even have an account");
784         uint256 _totalNames = plyr_[_pID].names;
785 
786         // add players profile and most recent name
787         games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
788 
789         // add list of all names
790         if (_totalNames > 1)
791             for (uint256 ii = 1; ii <= _totalNames; ii++)
792                 games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
793     }
794 
795     /**
796      * @dev players, use this to push your player profile to all registered games.
797      * -functionhash- 0x0c6940ea
798      */
799     function addMeToAllGames()
800         isHuman()
801         public
802     {
803         address _addr = msg.sender;
804         uint256 _pID = pIDxAddr_[_addr];
805         require(_pID != 0, "hey there buddy, you dont even have an account");
806         uint256 _laff = plyr_[_pID].laff;
807         uint256 _totalNames = plyr_[_pID].names;
808         bytes32 _name = plyr_[_pID].name;
809 
810         for (uint256 i = 1; i <= gID_; i++)
811         {
812             games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
813             if (_totalNames > 1)
814                 for (uint256 ii = 1; ii <= _totalNames; ii++)
815                     games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
816         }
817 
818     }
819 
820     /**
821      * @dev players use this to change back to one of your old names.  tip, you'll
822      * still need to push that info to existing games.
823      * -functionhash- 0xb9291296
824      * @param _nameString the name you want to use
825      */
826     function useMyOldName(string _nameString)
827         isHuman()
828         public
829     {
830         // filter name, and get pID
831         bytes32 _name = _nameString.nameFilter();
832         uint256 _pID = pIDxAddr_[msg.sender];
833 
834         // make sure they own the name
835         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
836 
837         // update their current name
838         plyr_[_pID].name = _name;
839     }
840 
841 //==============================================================================
842 //     _ _  _ _   | _  _ . _  .
843 //    (_(_)| (/_  |(_)(_||(_  .
844 //=====================_|=======================================================
845     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
846         private
847     {
848         // if names already has been used, require that current msg sender owns the name
849         if (pIDxName_[_name] != 0)
850             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
851 
852         // add name to player profile, registry, and name book
853         plyr_[_pID].name = _name;
854         pIDxName_[_name] = _pID;
855         if (plyrNames_[_pID][_name] == false)
856         {
857             plyrNames_[_pID][_name] = true;
858             plyr_[_pID].names++;
859             plyrNameList_[_pID][plyr_[_pID].names] = _name;
860         }
861 
862         // registration fee goes directly to community rewards
863         //Jekyll_Island_Inc.deposit.value(address(this).balance)();
864         affWallet.transfer(address(this).balance);
865         // push player info to games
866         if (_all == true)
867             for (uint256 i = 1; i <= gID_; i++)
868                 games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
869 
870         // fire event
871         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
872     }
873 //==============================================================================
874 //    _|_ _  _ | _  .
875 //     | (_)(_)|_\  .
876 //==============================================================================
877     function determinePID(address _addr)
878         private
879         returns (bool)
880     {
881         if (pIDxAddr_[_addr] == 0)
882         {
883             pID_++;
884             pIDxAddr_[_addr] = pID_;
885             plyr_[pID_].addr = _addr;
886 
887             // set the new player bool to true
888             return (true);
889         } else {
890             return (false);
891         }
892     }
893 //==============================================================================
894 //   _   _|_ _  _ _  _ |   _ _ || _  .
895 //  (/_>< | (/_| | |(_||  (_(_|||_\  .
896 //==============================================================================
897     function getPlayerID(address _addr)
898         isRegisteredGame()
899         external
900         returns (uint256)
901     {
902         determinePID(_addr);
903         return (pIDxAddr_[_addr]);
904     }
905     function getPlayerName(uint256 _pID)
906         external
907         view
908         returns (bytes32)
909     {
910         return (plyr_[_pID].name);
911     }
912     function getPlayerLAff(uint256 _pID)
913         external
914         view
915         returns (uint256)
916     {
917         return (plyr_[_pID].laff);
918     }
919     function getPlayerAddr(uint256 _pID)
920         external
921         view
922         returns (address)
923     {
924         return (plyr_[_pID].addr);
925     }
926     function getNameFee()
927         external
928         view
929         returns (uint256)
930     {
931         return(registrationFee_);
932     }
933 
934     function registerAgent()
935         external
936         payable
937     {
938 
939 
940     }
941 
942     /**
943      *
944      * 购买推荐资格
945      *
946      */
947     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
948         isRegisteredGame()
949         external
950         payable
951         returns(bool, uint256)
952     {
953         // make sure name fees paid
954         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
955 
956         // set up our tx event data and determine if player is new or not
957         bool _isNewPlayer = determinePID(_addr);
958 
959         // fetch player id
960         uint256 _pID = pIDxAddr_[_addr];
961 
962         // manage affiliate residuals
963         // if no affiliate code was given, no new affiliate code was given, or the
964         // player tried to use their own pID as an affiliate code, lolz
965         if (plyr_[_pID].laff == 0) {
966             if(_affCode != 0 && _affCode != _pID && plyr_[_affCode].name != ""){
967                 plyr_[_pID].laff = _affCode;
968             }else{
969                 plyr_[_pID].laff = 1;
970             }
971         }
972 
973         // register name
974         registerNameCore(_pID, _addr, plyr_[_pID].laff, _name, _isNewPlayer, _all);
975 
976         return(_isNewPlayer, plyr_[_pID].laff);
977     }
978     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
979         isRegisteredGame()
980         external
981         payable
982         returns(bool, uint256)
983     {
984         // make sure name fees paid
985         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
986 
987         // set up our tx event data and determine if player is new or not
988         bool _isNewPlayer = determinePID(_addr);
989 
990         // fetch player id
991         uint256 _pID = pIDxAddr_[_addr];
992 
993         // manage affiliate residuals
994         // if no affiliate code was given or player tried to use their own, lolz
995         if (plyr_[_pID].laff == 0) {
996             if (_affCode != address(0) && _affCode != msg.sender && plyr_[pIDxAddr_[_affCode]].name != "") {
997                 plyr_[_pID].laff = pIDxAddr_[_affCode];
998             }else{
999                 plyr_[_pID].laff = 1;
1000             }
1001         }
1002 
1003         // register name
1004         registerNameCore(_pID, _addr, plyr_[_pID].laff, _name, _isNewPlayer, _all);
1005 
1006         return(_isNewPlayer, plyr_[_pID].laff);
1007     }
1008     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
1009         isRegisteredGame()
1010         external
1011         payable
1012         returns(bool, uint256)
1013     {
1014         // make sure name fees paid
1015         require (msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
1016 
1017         // set up our tx event data and determine if player is new or not
1018         bool _isNewPlayer = determinePID(_addr);
1019 
1020         // fetch player id
1021         uint256 _pID = pIDxAddr_[_addr];
1022 
1023         // manage affiliate residuals
1024         // if no affiliate code was given or player tried to use their own, lolz
1025         if (plyr_[_pID].laff == 0) {
1026             if (_affCode != "" && _affCode != _name) {
1027                 plyr_[_pID].laff = pIDxName_[_affCode];
1028             }else{
1029                 plyr_[_pID].laff = 1;
1030             }
1031         }
1032 
1033         // register name
1034         registerNameCore(_pID, _addr, plyr_[_pID].laff, _name, _isNewPlayer, _all);
1035 
1036         return(_isNewPlayer, plyr_[_pID].laff);
1037     }
1038 
1039 //==============================================================================
1040 //   _ _ _|_    _   .
1041 //  _\(/_ | |_||_)  .
1042 //=============|================================================================
1043     function addGame(address _gameAddress, string _gameNameStr)
1044         onlyDevs()
1045         public
1046     {
1047         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
1048 
1049         gID_++;
1050         bytes32 _name = _gameNameStr.nameFilter();
1051         gameIDs_[_gameAddress] = gID_;
1052         gameNames_[_gameAddress] = _name;
1053         games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
1054 
1055         games_[gID_].receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
1056 
1057     }
1058 
1059     function setRegistrationFee(uint256 _fee)
1060         onlyDevs()
1061         public
1062     {
1063 
1064         registrationFee_ = _fee;
1065 
1066     }
1067 
1068 }