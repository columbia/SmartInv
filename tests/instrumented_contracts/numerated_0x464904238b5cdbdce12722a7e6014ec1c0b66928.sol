1 pragma solidity ^0.4.24;
2 /* -Team Just- v0.2.5
3  * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
4  *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
5  *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
6  *                                  _____                      _____
7  *                                 (, /     /)       /) /)    (, /      /)          /)
8  *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
9  *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
10  *          ┴ ┴                /   /          .-/ _____   (__ /                               
11  *                            (__ /          (_/ (, /                                      /)™ 
12  *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
13  * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
14  * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
15  * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
16  *              JJJJJJJJJJUUUUUUUU     UUUUUUUU  SSSSSSSSSSSSSSSTTTTTTTTTTTTTTTTTTTTTTT
17  *==============J:::::::::U::::::U=====U::::::USS:::::::::::::::T:::::::::::::::::::::T======*
18  *              J:::::::::U::::::U     U::::::S:::::SSSSSS::::::T:::::::::::::::::::::T
19  *              JJ:::::::JUU:::::U     U:::::US:::::S     SSSSSST:::::TT:::::::TT:::::T
20  *                J:::::J  U:::::U     U:::::US:::::S           TTTTTT  T:::::T  TTTTTT
21  *                J::_________ : ________::::US::_::S     ____    ____  T:::::T
22  *                J:|  _   _  |:|_   __  |:::U S/ \:SSSS |_   \  /   _| T:::::T
23  *                J:|_/:| |U\_|::D| |_ \_|:::U / _ \::::SSS|   \/   |   T:::::T
24  *                J:::::| |U:::::D|  _| _::::U/ ___ \::::::| |\  /| |   T:::::T
25  *    JJJJJJJ     J::::_| |_:::::_| |__/ |::_/ /   \ \_SS _| |_\/_| |_  T:::::T
26  *    J:::::J     J:::|_____|:::|________|:|____| |____| |_____||_____| T:::::T
27  *    J::::::J   J::::::J  U::::::U   U::::::U            S:::::S       T:::::T
28  *    J:::::::JJJ:::::::J  U:::::::UUU:::::::USSSSSSS     S:::::S     TT:::::::TT
29  *     JJ:::::::::::::JJ    UU:::::::::::::UU S::::::SSSSSS:::::S     T:::::::::T
30  *=======JJ:::::::::JJ========UU:::::::::UU===S:::::::::::::::SS======T:::::::::T============*
31  *         JJJJJJJJJ            UUUUUUUUU      SSSSSSSSSSSSSSS        TTTTTTTTTTT
32  * 
33  * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
34  * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
35  * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
36  *
37  *         ┌──────────────────────────────────────────────────────────────────────┐
38  *         │ Que up intensely spectacular intro music...  In walks, Team Just.    │
39  *         │                         Everyone goes crazy.                         │
40  *         │ This is a companion to MSFun.  It's a central database of Devs and   │
41  *         │ Admin's that we can import to any dapp to allow them management      │
42  *         │ permissions.                                                         │
43  *         └──────────────────────────────────────────────────────────────────────┘
44  *                                ┌────────────────────┐
45  *                                │ Setup Instructions │
46  *                                └────────────────────┘
47  * (Step 1) import this contracts interface into your contract
48  * 
49  *    import "./TeamJustInterface.sol";
50  *
51  * (Step 2) set up the interface to point to the TeamJust contract
52  * 
53  *    TeamJustInterface constant TeamJust = TeamJustInterface(0x464904238b5CdBdCE12722A7E6014EC1C0B66928);
54  *
55  *    modifier onlyAdmins() {require(TeamJust.isAdmin(msg.sender) == true, "onlyAdmins failed - msg.sender is not an admin"); _;}
56  *    modifier onlyDevs() {require(TeamJust.isDev(msg.sender) == true, "onlyDevs failed - msg.sender is not a dev"); _;}
57  *                                ┌────────────────────┐
58  *                                │ Usage Instructions │
59  *                                └────────────────────┘
60  * use onlyAdmins() and onlyDevs() modifiers as you normally would on any function
61  * you wish to restrict to admins/devs registered with this contract.
62  * 
63  * to get required signatures for admins or devs
64  *       uint256 x = TeamJust.requiredSignatures();
65  *       uint256 x = TeamJust.requiredDevSignatures();
66  * 
67  * to get admin count or dev count 
68  *       uint256 x = TeamJust.adminCount();
69  *       uint256 x = TeamJust.devCount();
70  * 
71  * to get the name of an admin (in bytes32 format)
72  *       bytes32 x = TeamJust.adminName(address);
73  */
74 
75 interface JIincForwarderInterface {
76     function deposit() external payable returns(bool);
77     function status() external view returns(address, address, bool);
78     function startMigration(address _newCorpBank) external returns(bool);
79     function cancelMigration() external returns(bool);
80     function finishMigration() external returns(bool);
81     function setup(address _firstCorpBank) external;
82 }
83 
84 contract TeamJust {
85     JIincForwarderInterface private Jekyll_Island_Inc = JIincForwarderInterface(0x0);
86     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
87     // SET UP MSFun (note, check signers by name is modified from MSFun sdk)
88     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
89     MSFun.Data private msData;
90     function deleteAnyProposal(bytes32 _whatFunction) onlyDevs() public {MSFun.deleteProposal(msData, _whatFunction);}
91     function checkData(bytes32 _whatFunction) onlyAdmins() public view returns(bytes32 message_data, uint256 signature_count) {return(MSFun.checkMsgData(msData, _whatFunction), MSFun.checkCount(msData, _whatFunction));}
92     function checkSignersByName(bytes32 _whatFunction, uint256 _signerA, uint256 _signerB, uint256 _signerC) onlyAdmins() public view returns(bytes32, bytes32, bytes32) {return(this.adminName(MSFun.checkSigner(msData, _whatFunction, _signerA)), this.adminName(MSFun.checkSigner(msData, _whatFunction, _signerB)), this.adminName(MSFun.checkSigner(msData, _whatFunction, _signerC)));}
93 
94     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
95     // DATA SETUP
96     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
97     struct Admin {
98         bool isAdmin;
99         bool isDev;
100         bytes32 name;
101     }
102     mapping (address => Admin) admins_;
103     
104     uint256 adminCount_;
105     uint256 devCount_;
106     uint256 requiredSignatures_;
107     uint256 requiredDevSignatures_;
108     
109     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
110     // CONSTRUCTOR
111     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
112     constructor()
113         public
114     {
115         address inventor = 0x18E90Fc6F70344f53EBd4f6070bf6Aa23e2D748C;
116         address mantso   = 0x8b4DA1827932D71759687f925D17F81Fc94e3A9D;
117         address justo    = 0x8e0d985f3Ec1857BEc39B76aAabDEa6B31B67d53;
118         address sumpunk  = 0x7ac74Fcc1a71b106F12c55ee8F802C9F672Ce40C;
119 		address deployer = 0xF39e044e1AB204460e06E87c6dca2c6319fC69E3;
120         
121         admins_[inventor] = Admin(true, true, "inventor");
122         admins_[mantso]   = Admin(true, true, "mantso");
123         admins_[justo]    = Admin(true, true, "justo");
124         admins_[sumpunk]  = Admin(true, true, "sumpunk");
125 		admins_[deployer] = Admin(true, true, "deployer");
126         
127         adminCount_ = 5;
128         devCount_ = 5;
129         requiredSignatures_ = 1;
130         requiredDevSignatures_ = 1;
131     }
132     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
133     // FALLBACK, SETUP, AND FORWARD
134     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
135     // there should never be a balance in this contract.  but if someone
136     // does stupidly send eth here for some reason.  we can forward it 
137     // to jekyll island
138     function ()
139         public
140         payable
141     {
142         Jekyll_Island_Inc.deposit.value(address(this).balance)();
143     }
144     
145     function setup(address _addr)
146         onlyDevs()
147         public
148     {
149         require( address(Jekyll_Island_Inc) == address(0) );
150         Jekyll_Island_Inc = JIincForwarderInterface(_addr);
151     }    
152     
153     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
154     // MODIFIERS
155     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
156     modifier onlyDevs()
157     {
158         require(admins_[msg.sender].isDev == true, "onlyDevs failed - msg.sender is not a dev");
159         _;
160     }
161     
162     modifier onlyAdmins()
163     {
164         require(admins_[msg.sender].isAdmin == true, "onlyAdmins failed - msg.sender is not an admin");
165         _;
166     }
167 
168     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
169     // DEV ONLY FUNCTIONS
170     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
171     /**
172     * @dev DEV - use this to add admins.  this is a dev only function.
173     * @param _who - address of the admin you wish to add
174     * @param _name - admins name
175     * @param _isDev - is this admin also a dev?
176     */
177     function addAdmin(address _who, bytes32 _name, bool _isDev)
178         public
179         onlyDevs()
180     {
181         if (MSFun.multiSig(msData, requiredDevSignatures_, "addAdmin") == true) 
182         {
183             MSFun.deleteProposal(msData, "addAdmin");
184             
185             // must check this so we dont mess up admin count by adding someone
186             // who is already an admin
187             if (admins_[_who].isAdmin == false) 
188             { 
189                 
190                 // set admins flag to true in admin mapping
191                 admins_[_who].isAdmin = true;
192         
193                 // adjust admin count and required signatures
194                 adminCount_ += 1;
195                 requiredSignatures_ += 1;
196             }
197             
198             // are we setting them as a dev?
199             // by putting this outside the above if statement, we can upgrade existing
200             // admins to devs.
201             if (_isDev == true) 
202             {
203                 // bestow the honored dev status
204                 admins_[_who].isDev = _isDev;
205                 
206                 // increase dev count and required dev signatures
207                 devCount_ += 1;
208                 requiredDevSignatures_ += 1;
209             }
210         }
211         
212         // by putting this outside the above multisig, we can allow easy name changes
213         // without having to bother with multisig.  this will still create a proposal though
214         // so use the deleteAnyProposal to delete it if you want to
215         admins_[_who].name = _name;
216     }
217 
218     /**
219     * @dev DEV - use this to remove admins. this is a dev only function.
220     * -requirements: never less than 1 admin
221     *                never less than 1 dev
222     *                never less admins than required signatures
223     *                never less devs than required dev signatures
224     * @param _who - address of the admin you wish to remove
225     */
226     function removeAdmin(address _who)
227         public
228         onlyDevs()
229     {
230         // we can put our requires outside the multisig, this will prevent
231         // creating a proposal that would never pass checks anyway.
232         require(adminCount_ > 1, "removeAdmin failed - cannot have less than 2 admins");
233         require(adminCount_ >= requiredSignatures_, "removeAdmin failed - cannot have less admins than number of required signatures");
234         if (admins_[_who].isDev == true)
235         {
236             require(devCount_ > 1, "removeAdmin failed - cannot have less than 2 devs");
237             require(devCount_ >= requiredDevSignatures_, "removeAdmin failed - cannot have less devs than number of required dev signatures");
238         }
239         
240         // checks passed
241         if (MSFun.multiSig(msData, requiredDevSignatures_, "removeAdmin") == true) 
242         {
243             MSFun.deleteProposal(msData, "removeAdmin");
244             
245             // must check this so we dont mess up admin count by removing someone
246             // who wasnt an admin to start with
247             if (admins_[_who].isAdmin == true) {  
248                 
249                 //set admins flag to false in admin mapping
250                 admins_[_who].isAdmin = false;
251                 
252                 //adjust admin count and required signatures
253                 adminCount_ -= 1;
254                 if (requiredSignatures_ > 1) 
255                 {
256                     requiredSignatures_ -= 1;
257                 }
258             }
259             
260             // were they also a dev?
261             if (admins_[_who].isDev == true) {
262                 
263                 //set dev flag to false
264                 admins_[_who].isDev = false;
265                 
266                 //adjust dev count and required dev signatures
267                 devCount_ -= 1;
268                 if (requiredDevSignatures_ > 1) 
269                 {
270                     requiredDevSignatures_ -= 1;
271                 }
272             }
273         }
274     }
275 
276     /**
277     * @dev DEV - change the number of required signatures.  must be between
278     * 1 and the number of admins.  this is a dev only function
279     * @param _howMany - desired number of required signatures
280     */
281     function changeRequiredSignatures(uint256 _howMany)
282         public
283         onlyDevs()
284     {  
285         // make sure its between 1 and number of admins
286         require(_howMany > 0 && _howMany <= adminCount_, "changeRequiredSignatures failed - must be between 1 and number of admins");
287         
288         if (MSFun.multiSig(msData, requiredDevSignatures_, "changeRequiredSignatures") == true) 
289         {
290             MSFun.deleteProposal(msData, "changeRequiredSignatures");
291             
292             // store new setting.
293             requiredSignatures_ = _howMany;
294         }
295     }
296     
297     /**
298     * @dev DEV - change the number of required dev signatures.  must be between
299     * 1 and the number of devs.  this is a dev only function
300     * @param _howMany - desired number of required dev signatures
301     */
302     function changeRequiredDevSignatures(uint256 _howMany)
303         public
304         onlyDevs()
305     {  
306         // make sure its between 1 and number of admins
307         require(_howMany > 0 && _howMany <= devCount_, "changeRequiredDevSignatures failed - must be between 1 and number of devs");
308         
309         if (MSFun.multiSig(msData, requiredDevSignatures_, "changeRequiredDevSignatures") == true) 
310         {
311             MSFun.deleteProposal(msData, "changeRequiredDevSignatures");
312             
313             // store new setting.
314             requiredDevSignatures_ = _howMany;
315         }
316     }
317 
318     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
319     // EXTERNAL FUNCTIONS 
320     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
321     function requiredSignatures() external view returns(uint256) {return(requiredSignatures_);}
322     function requiredDevSignatures() external view returns(uint256) {return(requiredDevSignatures_);}
323     function adminCount() external view returns(uint256) {return(adminCount_);}
324     function devCount() external view returns(uint256) {return(devCount_);}
325     function adminName(address _who) external view returns(bytes32) {return(admins_[_who].name);}
326     function isAdmin(address _who) external view returns(bool) {return(admins_[_who].isAdmin);}
327     function isDev(address _who) external view returns(bool) {return(admins_[_who].isDev);}
328 }
329 
330 library MSFun {
331     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
332     // DATA SETS
333     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
334     // contact data setup
335     struct Data 
336     {
337         mapping (bytes32 => ProposalData) proposal_;
338     }
339     struct ProposalData 
340     {
341         // a hash of msg.data 
342         bytes32 msgData;
343         // number of signers
344         uint256 count;
345         // tracking of wither admins have signed
346         mapping (address => bool) admin;
347         // list of admins who have signed
348         mapping (uint256 => address) log;
349     }
350     
351     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
352     // MULTI SIG FUNCTIONS
353     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
354     function multiSig(Data storage self, uint256 _requiredSignatures, bytes32 _whatFunction)
355         internal
356         returns(bool) 
357     {
358         // our proposal key will be a hash of our function name + our contracts address 
359         // by adding our contracts address to this, we prevent anyone trying to circumvent
360         // the proposal's security via external calls.
361         bytes32 _whatProposal = whatProposal(_whatFunction);
362         
363         // this is just done to make the code more readable.  grabs the signature count
364         uint256 _currentCount = self.proposal_[_whatProposal].count;
365         
366         // store the address of the person sending the function call.  we use msg.sender 
367         // here as a layer of security.  in case someone imports our contract and tries to 
368         // circumvent function arguments.  still though, our contract that imports this
369         // library and calls multisig, needs to use onlyAdmin modifiers or anyone who
370         // calls the function will be a signer. 
371         address _whichAdmin = msg.sender;
372         
373         // prepare our msg data.  by storing this we are able to verify that all admins
374         // are approving the same argument input to be executed for the function.  we hash 
375         // it and store in bytes32 so its size is known and comparable
376         bytes32 _msgData = keccak256(msg.data);
377         
378         // check to see if this is a new execution of this proposal or not
379         if (_currentCount == 0)
380         {
381             // if it is, lets record the original signers data
382             self.proposal_[_whatProposal].msgData = _msgData;
383             
384             // record original senders signature
385             self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
386             
387             // update log (used to delete records later, and easy way to view signers)
388             // also useful if the calling function wants to give something to a 
389             // specific signer.  
390             self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
391             
392             // track number of signatures
393             self.proposal_[_whatProposal].count += 1;  
394             
395             // if we now have enough signatures to execute the function, lets
396             // return a bool of true.  we put this here in case the required signatures
397             // is set to 1.
398             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
399                 return(true);
400             }            
401         // if its not the first execution, lets make sure the msgData matches
402         } else if (self.proposal_[_whatProposal].msgData == _msgData) {
403             // msgData is a match
404             // make sure admin hasnt already signed
405             if (self.proposal_[_whatProposal].admin[_whichAdmin] == false) 
406             {
407                 // record their signature
408                 self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
409                 
410                 // update log (used to delete records later, and easy way to view signers)
411                 self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
412                 
413                 // track number of signatures
414                 self.proposal_[_whatProposal].count += 1;  
415             }
416             
417             // if we now have enough signatures to execute the function, lets
418             // return a bool of true.
419             // we put this here for a few reasons.  (1) in normal operation, if 
420             // that last recorded signature got us to our required signatures.  we 
421             // need to return bool of true.  (2) if we have a situation where the 
422             // required number of signatures was adjusted to at or lower than our current 
423             // signature count, by putting this here, an admin who has already signed,
424             // can call the function again to make it return a true bool.  but only if
425             // they submit the correct msg data
426             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
427                 return(true);
428             }
429         }
430     }
431     
432     
433     // deletes proposal signature data after successfully executing a multiSig function
434     function deleteProposal(Data storage self, bytes32 _whatFunction)
435         internal
436     {
437         //done for readability sake
438         bytes32 _whatProposal = whatProposal(_whatFunction);
439         address _whichAdmin;
440         
441         //delete the admins votes & log.   i know for loops are terrible.  but we have to do this 
442         //for our data stored in mappings.  simply deleting the proposal itself wouldn't accomplish this.
443         for (uint256 i=0; i < self.proposal_[_whatProposal].count; i++) {
444             _whichAdmin = self.proposal_[_whatProposal].log[i];
445             delete self.proposal_[_whatProposal].admin[_whichAdmin];
446             delete self.proposal_[_whatProposal].log[i];
447         }
448         //delete the rest of the data in the record
449         delete self.proposal_[_whatProposal];
450     }
451     
452     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
453     // HELPER FUNCTIONS
454     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
455 
456     function whatProposal(bytes32 _whatFunction)
457         private
458         view
459         returns(bytes32)
460     {
461         return(keccak256(abi.encodePacked(_whatFunction,this)));
462     }
463     
464     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
465     // VANITY FUNCTIONS
466     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
467     // returns a hashed version of msg.data sent by original signer for any given function
468     function checkMsgData (Data storage self, bytes32 _whatFunction)
469         internal
470         view
471         returns (bytes32 msg_data)
472     {
473         bytes32 _whatProposal = whatProposal(_whatFunction);
474         return (self.proposal_[_whatProposal].msgData);
475     }
476     
477     // returns number of signers for any given function
478     function checkCount (Data storage self, bytes32 _whatFunction)
479         internal
480         view
481         returns (uint256 signature_count)
482     {
483         bytes32 _whatProposal = whatProposal(_whatFunction);
484         return (self.proposal_[_whatProposal].count);
485     }
486     
487     // returns address of an admin who signed for any given function
488     function checkSigner (Data storage self, bytes32 _whatFunction, uint256 _signer)
489         internal
490         view
491         returns (address signer)
492     {
493         require(_signer > 0, "MSFun checkSigner failed - 0 not allowed");
494         bytes32 _whatProposal = whatProposal(_whatFunction);
495         return (self.proposal_[_whatProposal].log[_signer - 1]);
496     }
497 }