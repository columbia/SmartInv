1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 interface TeamJustInterface {
6     function requiredSignatures() external view returns(uint256);
7     function requiredDevSignatures() external view returns(uint256);
8     function adminCount() external view returns(uint256);
9     function devCount() external view returns(uint256);
10     function adminName(address _who) external view returns(bytes32);
11     function isAdmin(address _who) external view returns(bool);
12     function isDev(address _who) external view returns(bool);
13 }
14 interface PlayerBookReceiverInterface {
15     function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
16     function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
17 }
18 
19 interface PlayerBookInterface {
20     function getPlayerID(address _addr) external returns (uint256);
21     function getPlayerName(uint256 _pID) external view returns (bytes32);
22     function getPlayerLAff(uint256 _pID) external view returns (uint256);
23     function getPlayerAddr(uint256 _pID) external view returns (address);
24     function getNameFee() external view returns (uint256);
25     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all) external payable returns(bool, uint256);
26     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all) external payable returns(bool, uint256);
27     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all) external payable returns(bool, uint256);
28     function isDev(address _who) external view returns(bool);
29 }
30 library SafeMath {
31     
32     /**
33     * @dev Multiplies two numbers, throws on overflow.
34     */
35     function mul(uint256 a, uint256 b) 
36         internal 
37         pure 
38         returns (uint256 c) 
39     {
40         if (a == 0) {
41             return 0;
42         }
43         c = a * b;
44         require(c / a == b, "SafeMath mul failed");
45         return c;
46     }
47 
48     /**
49     * @dev Integer division of two numbers, truncating the quotient.
50     */
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         // assert(b > 0); // Solidity automatically throws when dividing by 0
53         uint256 c = a / b;
54         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55         return c;
56     }
57     
58     /**
59     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
60     */
61     function sub(uint256 a, uint256 b)
62         internal
63         pure
64         returns (uint256) 
65     {
66         require(b <= a, "SafeMath sub failed");
67         return a - b;
68     }
69 
70     /**
71     * @dev Adds two numbers, throws on overflow.
72     */
73     function add(uint256 a, uint256 b)
74         internal
75         pure
76         returns (uint256 c) 
77     {
78         c = a + b;
79         require(c >= a, "SafeMath add failed");
80         return c;
81     }
82     
83     /**
84      * @dev gives square root of given x.
85      */
86     function sqrt(uint256 x)
87         internal
88         pure
89         returns (uint256 y) 
90     {
91         uint256 z = ((add(x,1)) / 2);
92         y = x;
93         while (z < y) 
94         {
95             y = z;
96             z = ((add((x / z),z)) / 2);
97         }
98     }
99     
100     /**
101      * @dev gives square. multiplies x by x
102      */
103     function sq(uint256 x)
104         internal
105         pure
106         returns (uint256)
107     {
108         return (mul(x,x));
109     }
110     
111     /**
112      * @dev x to the power of y 
113      */
114     function pwr(uint256 x, uint256 y)
115         internal 
116         pure 
117         returns (uint256)
118     {
119         if (x==0)
120             return (0);
121         else if (y==0)
122             return (1);
123         else 
124         {
125             uint256 z = x;
126             for (uint256 i=1; i < y; i++)
127                 z = mul(z,x);
128             return (z);
129         }
130     }
131 }
132 library NameFilter {
133     /**
134      * @dev filters name strings
135      * -converts uppercase to lower case.  
136      * -makes sure it does not start/end with a space
137      * -makes sure it does not contain multiple spaces in a row
138      * -cannot be only numbers
139      * -cannot start with 0x 
140      * -restricts characters to A-Z, a-z, 0-9, and space.
141      * @return reprocessed string in bytes32 format
142      */
143     function nameFilter(string _input)
144         internal
145         pure
146         returns(bytes32)
147     {
148         bytes memory _temp = bytes(_input);
149         uint256 _length = _temp.length;
150         
151         //sorry limited to 32 characters
152         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
153         // make sure it doesnt start with or end with space
154         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
155         // make sure first two characters are not 0x
156         if (_temp[0] == 0x30)
157         {
158             require(_temp[1] != 0x78, "string cannot start with 0x");
159             require(_temp[1] != 0x58, "string cannot start with 0X");
160         }
161         
162         // create a bool to track if we have a non number character
163         bool _hasNonNumber;
164         
165         // convert & check
166         for (uint256 i = 0; i < _length; i++)
167         {
168             // if its uppercase A-Z
169             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
170             {
171                 // convert to lower case a-z
172                 _temp[i] = byte(uint(_temp[i]) + 32);
173                 
174                 // we have a non number
175                 if (_hasNonNumber == false)
176                     _hasNonNumber = true;
177             } else {
178                 require
179                 (
180                     // require character is a space
181                     _temp[i] == 0x20 || 
182                     // OR lowercase a-z
183                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
184                     // or 0-9
185                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
186                     "string contains invalid characters"
187                 );
188                 // make sure theres not 2x spaces in a row
189                 if (_temp[i] == 0x20)
190                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
191                 
192                 // see if we have a character other than a number
193                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
194                     _hasNonNumber = true;    
195             }
196         }
197         
198         require(_hasNonNumber == true, "string cannot be only numbers");
199         
200         bytes32 _ret;
201         assembly {
202             _ret := mload(add(_temp, 32))
203         }
204         return (_ret);
205     }
206 }
207 library MSFun {
208     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
209     // DATA SETS
210     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
211     // contact data setup
212     struct Data 
213     {
214         mapping (bytes32 => ProposalData) proposal_;
215     }
216     struct ProposalData 
217     {
218         // a hash of msg.data 
219         bytes32 msgData;
220         // number of signers
221         uint256 count;
222         // tracking of wither admins have signed
223         mapping (address => bool) admin;
224         // list of admins who have signed
225         mapping (uint256 => address) log;
226     }
227     
228     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
229     // MULTI SIG FUNCTIONS
230     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
231     function multiSig(Data storage self, uint256 _requiredSignatures, bytes32 _whatFunction)
232         internal
233         returns(bool) 
234     {
235         // our proposal key will be a hash of our function name + our contracts address 
236         // by adding our contracts address to this, we prevent anyone trying to circumvent
237         // the proposal's security via external calls.
238         bytes32 _whatProposal = whatProposal(_whatFunction);
239         
240         // this is just done to make the code more readable.  grabs the signature count
241         uint256 _currentCount = self.proposal_[_whatProposal].count;
242         
243         // store the address of the person sending the function call.  we use msg.sender 
244         // here as a layer of security.  in case someone imports our contract and tries to 
245         // circumvent function arguments.  still though, our contract that imports this
246         // library and calls multisig, needs to use onlyAdmin modifiers or anyone who
247         // calls the function will be a signer. 
248         address _whichAdmin = msg.sender;
249         
250         // prepare our msg data.  by storing this we are able to verify that all admins
251         // are approving the same argument input to be executed for the function.  we hash 
252         // it and store in bytes32 so its size is known and comparable
253         bytes32 _msgData = keccak256(msg.data);
254         
255         // check to see if this is a new execution of this proposal or not
256         if (_currentCount == 0)
257         {
258             // if it is, lets record the original signers data
259             self.proposal_[_whatProposal].msgData = _msgData;
260             
261             // record original senders signature
262             self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
263             
264             // update log (used to delete records later, and easy way to view signers)
265             // also useful if the calling function wants to give something to a 
266             // specific signer.  
267             self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
268             
269             // track number of signatures
270             self.proposal_[_whatProposal].count += 1;  
271             
272             // if we now have enough signatures to execute the function, lets
273             // return a bool of true.  we put this here in case the required signatures
274             // is set to 1.
275             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
276                 return(true);
277             }            
278         // if its not the first execution, lets make sure the msgData matches
279         } else if (self.proposal_[_whatProposal].msgData == _msgData) {
280             // msgData is a match
281             // make sure admin hasnt already signed
282             if (self.proposal_[_whatProposal].admin[_whichAdmin] == false) 
283             {
284                 // record their signature
285                 self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
286                 
287                 // update log (used to delete records later, and easy way to view signers)
288                 self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
289                 
290                 // track number of signatures
291                 self.proposal_[_whatProposal].count += 1;  
292             }
293             
294             // if we now have enough signatures to execute the function, lets
295             // return a bool of true.
296             // we put this here for a few reasons.  (1) in normal operation, if 
297             // that last recorded signature got us to our required signatures.  we 
298             // need to return bool of true.  (2) if we have a situation where the 
299             // required number of signatures was adjusted to at or lower than our current 
300             // signature count, by putting this here, an admin who has already signed,
301             // can call the function again to make it return a true bool.  but only if
302             // they submit the correct msg data
303             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
304                 return(true);
305             }
306         }
307     }
308     
309     
310     // deletes proposal signature data after successfully executing a multiSig function
311     function deleteProposal(Data storage self, bytes32 _whatFunction)
312         internal
313     {
314         //done for readability sake
315         bytes32 _whatProposal = whatProposal(_whatFunction);
316         address _whichAdmin;
317         
318         //delete the admins votes & log.   i know for loops are terrible.  but we have to do this 
319         //for our data stored in mappings.  simply deleting the proposal itself wouldn't accomplish this.
320         for (uint256 i=0; i < self.proposal_[_whatProposal].count; i++) {
321             _whichAdmin = self.proposal_[_whatProposal].log[i];
322             delete self.proposal_[_whatProposal].admin[_whichAdmin];
323             delete self.proposal_[_whatProposal].log[i];
324         }
325         //delete the rest of the data in the record
326         delete self.proposal_[_whatProposal];
327     }
328     
329     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
330     // HELPER FUNCTIONS
331     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
332 
333     function whatProposal(bytes32 _whatFunction)
334         private
335         view
336         returns(bytes32)
337     {
338         return(keccak256(abi.encodePacked(_whatFunction,this)));
339     }
340     
341     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
342     // VANITY FUNCTIONS
343     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
344     // returns a hashed version of msg.data sent by original signer for any given function
345     function checkMsgData (Data storage self, bytes32 _whatFunction)
346         internal
347         view
348         returns (bytes32 msg_data)
349     {
350         bytes32 _whatProposal = whatProposal(_whatFunction);
351         return (self.proposal_[_whatProposal].msgData);
352     }
353     
354     // returns number of signers for any given function
355     function checkCount (Data storage self, bytes32 _whatFunction)
356         internal
357         view
358         returns (uint256 signature_count)
359     {
360         bytes32 _whatProposal = whatProposal(_whatFunction);
361         return (self.proposal_[_whatProposal].count);
362     }
363     
364     // returns address of an admin who signed for any given function
365     function checkSigner (Data storage self, bytes32 _whatFunction, uint256 _signer)
366         internal
367         view
368         returns (address signer)
369     {
370         require(_signer > 0, "MSFun checkSigner failed - 0 not allowed");
371         bytes32 _whatProposal = whatProposal(_whatFunction);
372         return (self.proposal_[_whatProposal].log[_signer - 1]);
373     }
374 }
375 contract TeamJust is TeamJustInterface {
376     address private Jekyll_Island_Inc;
377     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
378     // SET UP MSFun (note, check signers by name is modified from MSFun sdk)
379     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
380     MSFun.Data private msData;
381     function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}
382     function checkData(bytes32 _whatFunction) onlyAdmins() public view returns(bytes32 message_data, uint256 signature_count) {return(MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}
383     function checkSignersByName(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyAdmins() public view returns(bytes32, bytes32, bytes32) {return(this.adminName(MSFun.checkSigner(msData, _whatFunction, _signerA)), this.adminName(MSFun.checkSigner(msData, _whatFunction, _signerB)), this.adminName(MSFun.checkSigner(msData, _whatFunction, _signerC)));}
384 
385     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
386     // DATA SETUP
387     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
388     struct Admin {
389         bool isAdmin;
390         bool isDev;
391         bytes32 name;
392     }
393     mapping (address => Admin) admins_;
394     
395     uint256 adminCount_;
396     uint256 devCount_;
397     uint256 requiredSignatures_;
398     uint256 requiredDevSignatures_;
399     
400     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
401     // CONSTRUCTOR
402     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
403     constructor()
404         public
405     {
406         Jekyll_Island_Inc = msg.sender;
407         address inventor = 0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C;
408         address mantso   = 0x8b4DA1827932D71759687f925D17F81Fc94e3A9D;
409         address justo    = 0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53;
410         address sumpunk  = 0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C;
411 		address deployer = msg.sender;
412         
413         admins_[inventor] = Admin(true, true, "inventor");
414         admins_[mantso]   = Admin(true, true, "mantso");
415         admins_[justo]    = Admin(true, true, "justo");
416         admins_[sumpunk]  = Admin(true, true, "sumpunk");
417 		admins_[deployer] = Admin(true, true, "deployer");
418         
419         adminCount_ = 5;
420         devCount_ = 5;
421         requiredSignatures_ = 1;
422         requiredDevSignatures_ = 1;
423     }
424     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
425     // FALLBACK, SETUP, AND FORWARD
426     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
427     // there should never be a balance in this contract.  but if someone
428     // does stupidly send eth here for some reason.  we can forward it 
429     // to jekyll island
430     function ()
431         public
432         payable
433     {
434         Jekyll_Island_Inc.transfer(address(this).balance);
435     }
436 
437 
438     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
439     // MODIFIERS
440     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
441     modifier onlyDevs()
442     {
443         require(admins_[msg.sender].isDev == true, "onlyDevs failed - msg.sender is not a dev");
444         _;
445     }
446     
447     modifier onlyAdmins()
448     {
449         require(admins_[msg.sender].isAdmin == true, "onlyAdmins failed - msg.sender is not an admin");
450         _;
451     }
452 
453     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
454     // DEV ONLY FUNCTIONS
455     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
456     /**
457     * @dev DEV - use this to add admins.  this is a dev only function.
458     * @param _who - address of the admin you wish to add
459     * @param _name - admins name
460     * @param _isDev - is this admin also a dev?
461     */
462     function addAdmin(address _who, bytes32 _name, bool _isDev)
463         public
464         onlyDevs()
465     {
466         if (MSFun.multiSig(msData, requiredDevSignatures_, "addAdmin") == true) 
467         {
468             MSFun.deleteProposal(msData, "addAdmin");
469             
470             // must check this so we dont mess up admin count by adding someone
471             // who is already an admin
472             if (admins_[_who].isAdmin == false) 
473             { 
474                 
475                 // set admins flag to true in admin mapping
476                 admins_[_who].isAdmin = true;
477         
478                 // adjust admin count and required signatures
479                 adminCount_ += 1;
480                 requiredSignatures_ += 1;
481             }
482             
483             // are we setting them as a dev?
484             // by putting this outside the above if statement, we can upgrade existing
485             // admins to devs.
486             if (_isDev == true) 
487             {
488                 // bestow the honored dev status
489                 admins_[_who].isDev = _isDev;
490                 
491                 // increase dev count and required dev signatures
492                 devCount_ += 1;
493                 requiredDevSignatures_ += 1;
494             }
495         }
496         
497         // by putting this outside the above multisig, we can allow easy name changes
498         // without having to bother with multisig.  this will still create a proposal though
499         // so use the deleteAnyProposal to delete it if you want to
500         admins_[_who].name = _name;
501     }
502 
503     /**
504     * @dev DEV - use this to remove admins. this is a dev only function.
505     * -requirements: never less than 1 admin
506     *                never less than 1 dev
507     *                never less admins than required signatures
508     *                never less devs than required dev signatures
509     * @param _who - address of the admin you wish to remove
510     */
511     function removeAdmin(address _who)
512         public
513         onlyDevs()
514     {
515         // we can put our requires outside the multisig, this will prevent
516         // creating a proposal that would never pass checks anyway.
517         require(adminCount_ > 1, "removeAdmin failed - cannot have less than 2 admins");
518         require(adminCount_ >= requiredSignatures_, "removeAdmin failed - cannot have less admins than number of required signatures");
519         if (admins_[_who].isDev == true)
520         {
521             require(devCount_ > 1, "removeAdmin failed - cannot have less than 2 devs");
522             require(devCount_ >= requiredDevSignatures_, "removeAdmin failed - cannot have less devs than number of required dev signatures");
523         }
524         
525         // checks passed
526         if (MSFun.multiSig(msData, requiredDevSignatures_, "removeAdmin") == true) 
527         {
528             MSFun.deleteProposal(msData, "removeAdmin");
529             
530             // must check this so we dont mess up admin count by removing someone
531             // who wasnt an admin to start with
532             if (admins_[_who].isAdmin == true) {  
533                 
534                 //set admins flag to false in admin mapping
535                 admins_[_who].isAdmin = false;
536                 
537                 //adjust admin count and required signatures
538                 adminCount_ -= 1;
539                 if (requiredSignatures_ > 1) 
540                 {
541                     requiredSignatures_ -= 1;
542                 }
543             }
544             
545             // were they also a dev?
546             if (admins_[_who].isDev == true) {
547                 
548                 //set dev flag to false
549                 admins_[_who].isDev = false;
550                 
551                 //adjust dev count and required dev signatures
552                 devCount_ -= 1;
553                 if (requiredDevSignatures_ > 1) 
554                 {
555                     requiredDevSignatures_ -= 1;
556                 }
557             }
558         }
559     }
560 
561     /**
562     * @dev DEV - change the number of required signatures.  must be between
563     * 1 and the number of admins.  this is a dev only function
564     * @param _howMany - desired number of required signatures
565     */
566     function changeRequiredSignatures(uint256 _howMany)
567         public
568         onlyDevs()
569     {  
570         // make sure its between 1 and number of admins
571         require(_howMany > 0 && _howMany <= adminCount_, "changeRequiredSignatures failed - must be between 1 and number of admins");
572         
573         if (MSFun.multiSig(msData, requiredDevSignatures_, "changeRequiredSignatures") == true) 
574         {
575             MSFun.deleteProposal(msData, "changeRequiredSignatures");
576             
577             // store new setting.
578             requiredSignatures_ = _howMany;
579         }
580     }
581     
582     /**
583     * @dev DEV - change the number of required dev signatures.  must be between
584     * 1 and the number of devs.  this is a dev only function
585     * @param _howMany - desired number of required dev signatures
586     */
587     function changeRequiredDevSignatures(uint256 _howMany)
588         public
589         onlyDevs()
590     {  
591         // make sure its between 1 and number of admins
592         require(_howMany > 0 && _howMany <= devCount_, "changeRequiredDevSignatures failed - must be between 1 and number of devs");
593         
594         if (MSFun.multiSig(msData, requiredDevSignatures_, "changeRequiredDevSignatures") == true) 
595         {
596             MSFun.deleteProposal(msData, "changeRequiredDevSignatures");
597             
598             // store new setting.
599             requiredDevSignatures_ = _howMany;
600         }
601     }
602 
603     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
604     // EXTERNAL FUNCTIONS 
605     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
606     function requiredSignatures() external view returns(uint256) {return(requiredSignatures_);}
607     function requiredDevSignatures() external view returns(uint256) {return(requiredDevSignatures_);}
608     function adminCount() external view returns(uint256) {return(adminCount_);}
609     function devCount() external view returns(uint256) {return(devCount_);}
610     function adminName(address _who) external view returns(bytes32) {return(admins_[_who].name);}
611     function isAdmin(address _who) external view returns(bool) {return(admins_[_who].isAdmin);}
612     function isDev(address _who) external view returns(bool) {return(admins_[_who].isDev);}
613 }
614 contract PlayerBook is PlayerBookInterface {
615     using NameFilter for string;
616     using SafeMath for uint256;
617 
618     address private Jekyll_Island_Inc;
619     address public teamJust;// = new TeamJustInterface();
620 
621     MSFun.Data private msData;
622 
623     function multiSigDev(bytes32 _whatFunction) private returns (bool) {return (MSFun.multiSig(msData, TeamJustInterface(teamJust).requiredDevSignatures(), _whatFunction));}
624 
625     function deleteProposal(bytes32 _whatFunction) private {MSFun.deleteProposal(msData, _whatFunction);}
626 
627     function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}
628 
629     function checkData(bytes32 _whatFunction) onlyDevs() public view returns (bytes32, uint256) {return (MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}
630 
631     function checkSignersByAddress(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyDevs() public view returns (address, address, address) {return (MSFun.checkSigner(msData, _whatFunction, _signerA), MSFun.checkSigner(msData, _whatFunction, _signerB), MSFun.checkSigner(msData, _whatFunction, _signerC));}
632 
633     function checkSignersByName(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyDevs() public view returns (bytes32, bytes32, bytes32) {return (TeamJustInterface(teamJust).adminName(MSFun.checkSigner(msData, _whatFunction, _signerA)), TeamJustInterface(teamJust).adminName(MSFun.checkSigner(msData, _whatFunction, _signerB)), TeamJustInterface(teamJust).adminName(MSFun.checkSigner(msData, _whatFunction, _signerC)));}
634     //==============================================================================
635     //     _| _ _|_ _    _ _ _|_    _   .
636     //    (_|(_| | (_|  _\(/_ | |_||_)  .
637     //=============================|================================================
638     uint256 public registrationFee_ = 10 finney;            // price to register a name
639     mapping(uint256 => address) public games_;  // mapping of our game interfaces for sending your account info to games
640     mapping(address => bytes32) public gameNames_;          // lookup a games name
641     mapping(address => uint256) public gameIDs_;            // lokup a games ID
642     uint256 public gID_;        // total number of games
643     uint256 public pID_;        // total number of players
644     mapping(address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
645     mapping(bytes32 => uint256) public pIDxName_;          // (name => pID) returns player id by name
646     mapping(uint256 => Player) public plyr_;               // (pID => data) player data
647     mapping(uint256 => mapping(bytes32 => bool)) public plyrNames_; // (pID => name => bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
648     mapping(uint256 => mapping(uint256 => bytes32)) public plyrNameList_; // (pID => nameNum => name) list of names a player owns
649     struct Player {
650         address addr;
651         bytes32 name;
652         uint256 laff;
653         uint256 names;
654     }
655 
656     address public owner;
657 
658     function setTeam(address _teamJust) external {
659         require(msg.sender == owner, 'only dev!');
660         require(address(teamJust) == address(0), 'already set!');
661         teamJust = _teamJust;
662     }
663     //==============================================================================
664     //     _ _  _  __|_ _    __|_ _  _  .
665     //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
666     //==============================================================================
667     constructor()
668     public
669     {
670         owner = msg.sender;
671         // premine the dev names (sorry not sorry)
672         // No keys are purchased with this method, it's simply locking our addresses,
673         // PID's and names for referral codes.
674         plyr_[1].addr = msg.sender;
675         plyr_[1].name = "wq";
676         plyr_[1].names = 1;
677         pIDxAddr_[msg.sender] = 1;
678         pIDxName_["wq"] = 1;
679         plyrNames_[1]["wq"] = true;
680         plyrNameList_[1][1] = "wq";
681 
682         pID_ = 1;
683         Jekyll_Island_Inc = msg.sender;
684     }
685     //==============================================================================
686     //     _ _  _  _|. |`. _  _ _  .
687     //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
688     //==============================================================================
689     /**
690      * @dev prevents contracts from interacting with fomo3d 
691      */
692     modifier isHuman() {
693         address _addr = msg.sender;
694         uint256 _codeLength;
695 
696         assembly {_codeLength := extcodesize(_addr)}
697         require(_codeLength == 0, "sorry humans only");
698         _;
699     }
700 
701     modifier onlyDevs()
702     {
703         require(TeamJustInterface(teamJust).isDev(msg.sender) == true, "msg sender is not a dev");
704         _;
705     }
706 
707     modifier isRegisteredGame()
708     {
709         require(gameIDs_[msg.sender] != 0);
710         _;
711     }
712     //==============================================================================
713     //     _    _  _ _|_ _  .
714     //    (/_\/(/_| | | _\  .
715     //==============================================================================
716     // fired whenever a player registers a name
717     event onNewName
718     (
719         uint256 indexed playerID,
720         address indexed playerAddress,
721         bytes32 indexed playerName,
722         bool isNewPlayer,
723         uint256 affiliateID,
724         address affiliateAddress,
725         bytes32 affiliateName,
726         uint256 amountPaid,
727         uint256 timeStamp
728     );
729     //==============================================================================
730     //     _  _ _|__|_ _  _ _  .
731     //    (_|(/_ |  | (/_| _\  . (for UI & viewing things on etherscan)
732     //=====_|=======================================================================
733     function checkIfNameValid(string _nameStr)
734     public
735     view
736     returns (bool)
737     {
738         bytes32 _name = _nameStr.nameFilter();
739         if (pIDxName_[_name] == 0)
740             return (true);
741         else
742             return (false);
743     }
744     //==============================================================================
745     //     _    |_ |. _   |`    _  __|_. _  _  _  .
746     //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
747     //====|=========================================================================
748     /**
749      * @dev registers a name.  UI will always display the last name you registered.
750      * but you will still own all previously registered names to use as affiliate 
751      * links.
752      * - must pay a registration fee.
753      * - name must be unique
754      * - names will be converted to lowercase
755      * - name cannot start or end with a space 
756      * - cannot have more than 1 space in a row
757      * - cannot be only numbers
758      * - cannot start with 0x 
759      * - name must be at least 1 char
760      * - max length of 32 characters long
761      * - allowed characters: a-z, 0-9, and space
762      * -functionhash- 0x921dec21 (using ID for affiliate)
763      * -functionhash- 0x3ddd4698 (using address for affiliate)
764      * -functionhash- 0x685ffd83 (using name for affiliate)
765      * @param _nameString players desired name
766      * @param _affCode affiliate ID, address, or name of who refered you
767      * @param _all set to true if you want this to push your info to all games 
768      * (this might cost a lot of gas)
769      */
770     function registerNameXID(string _nameString, uint256 _affCode, bool _all)
771     isHuman()
772     public
773     payable
774     {
775         // make sure name fees paid
776         require(msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
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
791         // if no affiliate code was given, no new affiliate code was given, or the 
792         // player tried to use their own pID as an affiliate code, lolz
793         if (_affCode != 0 && _affCode != plyr_[_pID].laff && _affCode != _pID)
794         {
795             // update last affiliate 
796             plyr_[_pID].laff = _affCode;
797         } else if (_affCode == _pID) {
798             _affCode = 0;
799         }
800 
801         // register name 
802         registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
803     }
804 
805     function registerNameXaddr(string _nameString, address _affCode, bool _all)
806     isHuman()
807     public
808     payable
809     {
810         // make sure name fees paid
811         require(msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
812 
813         // filter name + condition checks
814         bytes32 _name = NameFilter.nameFilter(_nameString);
815 
816         // set up address 
817         address _addr = msg.sender;
818 
819         // set up our tx event data and determine if player is new or not
820         bool _isNewPlayer = determinePID(_addr);
821 
822         // fetch player id
823         uint256 _pID = pIDxAddr_[_addr];
824 
825         // manage affiliate residuals
826         // if no affiliate code was given or player tried to use their own, lolz
827         uint256 _affID;
828         if (_affCode != address(0) && _affCode != _addr)
829         {
830             // get affiliate ID from aff Code 
831             _affID = pIDxAddr_[_affCode];
832 
833             // if affID is not the same as previously stored 
834             if (_affID != plyr_[_pID].laff)
835             {
836                 // update last affiliate
837                 plyr_[_pID].laff = _affID;
838             }
839         }
840 
841         // register name 
842         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
843     }
844 
845     function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
846     isHuman()
847     public
848     payable
849     {
850         // make sure name fees paid
851         require(msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
852 
853         // filter name + condition checks
854         bytes32 _name = NameFilter.nameFilter(_nameString);
855 
856         // set up address 
857         address _addr = msg.sender;
858 
859         // set up our tx event data and determine if player is new or not
860         bool _isNewPlayer = determinePID(_addr);
861 
862         // fetch player id
863         uint256 _pID = pIDxAddr_[_addr];
864 
865         // manage affiliate residuals
866         // if no affiliate code was given or player tried to use their own, lolz
867         uint256 _affID;
868         if (_affCode != "" && _affCode != _name)
869         {
870             // get affiliate ID from aff Code 
871             _affID = pIDxName_[_affCode];
872 
873             // if affID is not the same as previously stored 
874             if (_affID != plyr_[_pID].laff)
875             {
876                 // update last affiliate
877                 plyr_[_pID].laff = _affID;
878             }
879         }
880 
881         // register name 
882         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
883     }
884 
885     /**
886      * @dev players, if you registered a profile, before a game was released, or
887      * set the all bool to false when you registered, use this function to push
888      * your profile to a single game.  also, if you've  updated your name, you
889      * can use this to push your name to games of your choosing.
890      * -functionhash- 0x81c5b206
891      * @param _gameID game id 
892      */
893     function addMeToGame(uint256 _gameID)
894     isHuman()
895     public
896     {
897         require(_gameID <= gID_, "silly player, that game doesn't exist yet");
898         address _addr = msg.sender;
899         uint256 _pID = pIDxAddr_[_addr];
900         require(_pID != 0, "hey there buddy, you dont even have an account");
901         uint256 _totalNames = plyr_[_pID].names;
902 
903         // add players profile and most recent name
904         PlayerBookReceiverInterface(games_[_gameID]).receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
905 
906         // add list of all names
907         if (_totalNames > 1)
908             for (uint256 ii = 1; ii <= _totalNames; ii++)
909                 PlayerBookReceiverInterface(games_[_gameID]).receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
910     }
911 
912     /**
913      * @dev players, use this to push your player profile to all registered games.
914      * -functionhash- 0x0c6940ea
915      */
916     function addMeToAllGames()
917     isHuman()
918     public
919     {
920         address _addr = msg.sender;
921         uint256 _pID = pIDxAddr_[_addr];
922         require(_pID != 0, "hey there buddy, you dont even have an account");
923         uint256 _laff = plyr_[_pID].laff;
924         uint256 _totalNames = plyr_[_pID].names;
925         bytes32 _name = plyr_[_pID].name;
926 
927         for (uint256 i = 1; i <= gID_; i++)
928         {
929             PlayerBookReceiverInterface(games_[i]).receivePlayerInfo(_pID, _addr, _name, _laff);
930             if (_totalNames > 1)
931                 for (uint256 ii = 1; ii <= _totalNames; ii++)
932                     PlayerBookReceiverInterface(games_[i]).receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
933         }
934 
935     }
936 
937     /**
938      * @dev players use this to change back to one of your old names.  tip, you'll
939      * still need to push that info to existing games.
940      * -functionhash- 0xb9291296
941      * @param _nameString the name you want to use 
942      */
943     function useMyOldName(string _nameString)
944     isHuman()
945     public
946     {
947         // filter name, and get pID
948         bytes32 _name = _nameString.nameFilter();
949         uint256 _pID = pIDxAddr_[msg.sender];
950 
951         // make sure they own the name 
952         require(plyrNames_[_pID][_name] == true, "umm... thats not a name you own");
953 
954         // update their current name 
955         plyr_[_pID].name = _name;
956     }
957 
958     //==============================================================================
959     //     _ _  _ _   | _  _ . _  .
960     //    (_(_)| (/_  |(_)(_||(_  .
961     //=====================_|=======================================================
962     function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
963     private
964     {
965         // if names already has been used, require that current msg sender owns the name
966         if (pIDxName_[_name] != 0)
967             require(plyrNames_[_pID][_name] == true, "sorry that names already taken");
968 
969         // add name to player profile, registry, and name book
970         plyr_[_pID].name = _name;
971         pIDxName_[_name] = _pID;
972         if (plyrNames_[_pID][_name] == false)
973         {
974             plyrNames_[_pID][_name] = true;
975             plyr_[_pID].names++;
976             plyrNameList_[_pID][plyr_[_pID].names] = _name;
977         }
978 
979         // registration fee goes directly to community rewards
980         Jekyll_Island_Inc.transfer(address(this).balance);
981 
982         // push player info to games
983         if (_all == true)
984             for (uint256 i = 1; i <= gID_; i++)
985                 PlayerBookReceiverInterface(games_[i]).receivePlayerInfo(_pID, _addr, _name, _affID);
986 
987         // fire event
988         emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
989     }
990     //==============================================================================
991     //    _|_ _  _ | _  .
992     //     | (_)(_)|_\  .
993     //==============================================================================
994     function determinePID(address _addr)
995     private
996     returns (bool)
997     {
998         if (pIDxAddr_[_addr] == 0)
999         {
1000             pID_++;
1001             pIDxAddr_[_addr] = pID_;
1002             plyr_[pID_].addr = _addr;
1003 
1004             // set the new player bool to true
1005             return (true);
1006         } else {
1007             return (false);
1008         }
1009     }
1010     //==============================================================================
1011     //   _   _|_ _  _ _  _ |   _ _ || _  .
1012     //  (/_>< | (/_| | |(_||  (_(_|||_\  .
1013     //==============================================================================
1014     function getPlayerID(address _addr)
1015     isRegisteredGame()
1016     external
1017     returns (uint256)
1018     {
1019         determinePID(_addr);
1020         return (pIDxAddr_[_addr]);
1021     }
1022 
1023     function getPlayerName(uint256 _pID)
1024     external
1025     view
1026     returns (bytes32)
1027     {
1028         return (plyr_[_pID].name);
1029     }
1030 
1031     function getPlayerLAff(uint256 _pID)
1032     external
1033     view
1034     returns (uint256)
1035     {
1036         return (plyr_[_pID].laff);
1037     }
1038 
1039     function getPlayerAddr(uint256 _pID)
1040     external
1041     view
1042     returns (address)
1043     {
1044         return (plyr_[_pID].addr);
1045     }
1046 
1047     function getNameFee()
1048     external
1049     view
1050     returns (uint256)
1051     {
1052         return (registrationFee_);
1053     }
1054 
1055     function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
1056     isRegisteredGame()
1057     external
1058     payable
1059     returns (bool, uint256)
1060     {
1061         // make sure name fees paid
1062         require(msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
1063 
1064         // set up our tx event data and determine if player is new or not
1065         bool _isNewPlayer = determinePID(_addr);
1066 
1067         // fetch player id
1068         uint256 _pID = pIDxAddr_[_addr];
1069 
1070         // manage affiliate residuals
1071         // if no affiliate code was given, no new affiliate code was given, or the 
1072         // player tried to use their own pID as an affiliate code, lolz
1073         uint256 _affID = _affCode;
1074         if (_affID != 0 && _affID != plyr_[_pID].laff && _affID != _pID)
1075         {
1076             // update last affiliate 
1077             plyr_[_pID].laff = _affID;
1078         } else if (_affID == _pID) {
1079             _affID = 0;
1080         }
1081 
1082         // register name 
1083         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
1084 
1085         return (_isNewPlayer, _affID);
1086     }
1087 
1088     function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
1089     isRegisteredGame()
1090     external
1091     payable
1092     returns (bool, uint256)
1093     {
1094         // make sure name fees paid
1095         require(msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
1096 
1097         // set up our tx event data and determine if player is new or not
1098         bool _isNewPlayer = determinePID(_addr);
1099 
1100         // fetch player id
1101         uint256 _pID = pIDxAddr_[_addr];
1102 
1103         // manage affiliate residuals
1104         // if no affiliate code was given or player tried to use their own, lolz
1105         uint256 _affID;
1106         if (_affCode != address(0) && _affCode != _addr)
1107         {
1108             // get affiliate ID from aff Code 
1109             _affID = pIDxAddr_[_affCode];
1110 
1111             // if affID is not the same as previously stored 
1112             if (_affID != plyr_[_pID].laff)
1113             {
1114                 // update last affiliate
1115                 plyr_[_pID].laff = _affID;
1116             }
1117         }
1118 
1119         // register name 
1120         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
1121 
1122         return (_isNewPlayer, _affID);
1123     }
1124 
1125     function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
1126     isRegisteredGame()
1127     external
1128     payable
1129     returns (bool, uint256)
1130     {
1131         // make sure name fees paid
1132         require(msg.value >= registrationFee_, "umm.....  you have to pay the name fee");
1133 
1134         // set up our tx event data and determine if player is new or not
1135         bool _isNewPlayer = determinePID(_addr);
1136 
1137         // fetch player id
1138         uint256 _pID = pIDxAddr_[_addr];
1139 
1140         // manage affiliate residuals
1141         // if no affiliate code was given or player tried to use their own, lolz
1142         uint256 _affID;
1143         if (_affCode != "" && _affCode != _name)
1144         {
1145             // get affiliate ID from aff Code 
1146             _affID = pIDxName_[_affCode];
1147 
1148             // if affID is not the same as previously stored 
1149             if (_affID != plyr_[_pID].laff)
1150             {
1151                 // update last affiliate
1152                 plyr_[_pID].laff = _affID;
1153             }
1154         }
1155 
1156         // register name 
1157         registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
1158 
1159         return (_isNewPlayer, _affID);
1160     }
1161 
1162     //==============================================================================
1163     //   _ _ _|_    _   .
1164     //  _\(/_ | |_||_)  .
1165     //=============|================================================================
1166     function addGame(address _gameAddress, bytes32 _gameNameStr)
1167     onlyDevs()
1168     external
1169     {
1170         require(gameIDs_[_gameAddress] == 0, "derp, that games already been registered");
1171 
1172         if (multiSigDev("addGame") == true)
1173         {deleteProposal("addGame");
1174             gID_++;
1175             bytes32 _name = _gameNameStr;
1176             gameIDs_[_gameAddress] = gID_;
1177             gameNames_[_gameAddress] = _name;
1178             games_[gID_] = _gameAddress;
1179 
1180 //            PlayerBookReceiverInterface(games_[gID_]).receivePlayerInfo(1, plyr_[1].addr, plyr_[1].name, 0);
1181 
1182         }
1183     }
1184 
1185     function setRegistrationFee(uint256 _fee)
1186     onlyDevs()
1187     public
1188     {
1189         if (multiSigDev("setRegistrationFee") == true)
1190         {deleteProposal("setRegistrationFee");
1191             registrationFee_ = _fee;
1192         }
1193     }
1194 
1195     function isDev(address _who) external view returns(bool) {return TeamJustInterface(teamJust).isDev(_who);}
1196 
1197 }