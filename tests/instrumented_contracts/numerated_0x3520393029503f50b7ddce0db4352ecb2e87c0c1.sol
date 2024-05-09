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
77     //function status() external view returns(address, address, bool);
78     //function startMigration(address _newCorpBank) external returns(bool);
79     //function cancelMigration() external returns(bool);
80     //function finishMigration() external returns(bool);
81     //function setup(address _firstCorpBank) external;
82 }
83 
84 contract TeamJust {
85     JIincForwarderInterface private Jekyll_Island_Inc = JIincForwarderInterface(0xe5f55d966ef9b4d541b286dd5237209d7de9959f);
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
115        // address inventor = 0xDDeD7B59cfF636B9b8d1C7e072817cd75Fa08767;
116        // address mantso   = 0xc974884d397c31cbf2c064d28b22583cbd087204;
117       //  address justo    = 0x6c4575b6283445e5b2e4f46ea706f86ebfbdd1e9;
118       //  address sumpunk  = 0xcae6db99b3eadc9c9ea4a9515c8ddd26894eccdd;
119         address deployer = 0x24e0162606d558ac113722adc6597b434089adb7;
120         
121       //  admins_[inventor] = Admin(true, true, "inventor");
122       //  admins_[mantso]   = Admin(true, true, "mantso");
123       //  admins_[justo]    = Admin(true, true, "justo");
124       //  admins_[sumpunk]  = Admin(true, true, "sumpunk");
125         admins_[deployer] = Admin(true, true, "deployer");
126         
127         adminCount_ = 1;
128         devCount_ = 1;
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
149         Jekyll_Island_Inc = JIincForwarderInterface(_addr);
150     }    
151     
152     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
153     // MODIFIERS
154     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
155     modifier onlyDevs()
156     {
157         require(admins_[msg.sender].isDev == true, "onlyDevs failed - msg.sender is not a dev");
158         _;
159     }
160     
161     modifier onlyAdmins()
162     {
163         require(admins_[msg.sender].isAdmin == true, "onlyAdmins failed - msg.sender is not an admin");
164         _;
165     }
166 
167     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
168     // DEV ONLY FUNCTIONS
169     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
170     /**
171     * @dev DEV - use this to add admins.  this is a dev only function.
172     * @param _who - address of the admin you wish to add
173     * @param _name - admins name
174     * @param _isDev - is this admin also a dev?
175     */
176     function addAdmin(address _who, bytes32 _name, bool _isDev)
177         public
178         onlyDevs()
179     {
180         if (MSFun.multiSig(msData, requiredDevSignatures_, "addAdmin") == true) 
181         {
182             MSFun.deleteProposal(msData, "addAdmin");
183             
184             // must check this so we dont mess up admin count by adding someone
185             // who is already an admin
186             if (admins_[_who].isAdmin == false) 
187             { 
188                 
189                 // set admins flag to true in admin mapping
190                 admins_[_who].isAdmin = true;
191         
192                 // adjust admin count and required signatures
193                 adminCount_ += 1;
194                 requiredSignatures_ += 1;
195             }
196             
197             // are we setting them as a dev?
198             // by putting this outside the above if statement, we can upgrade existing
199             // admins to devs.
200             if (_isDev == true) 
201             {
202                 // bestow the honored dev status
203                 admins_[_who].isDev = _isDev;
204                 
205                 // increase dev count and required dev signatures
206                 devCount_ += 1;
207                 requiredDevSignatures_ += 1;
208             }
209         }
210         
211         // by putting this outside the above multisig, we can allow easy name changes
212         // without having to bother with multisig.  this will still create a proposal though
213         // so use the deleteAnyProposal to delete it if you want to
214         admins_[_who].name = _name;
215     }
216 
217     /**
218     * @dev DEV - use this to remove admins. this is a dev only function.
219     * -requirements: never less than 1 admin
220     *                never less than 1 dev
221     *                never less admins than required signatures
222     *                never less devs than required dev signatures
223     * @param _who - address of the admin you wish to remove
224     */
225     function removeAdmin(address _who)
226         public
227         onlyDevs()
228     {
229         // we can put our requires outside the multisig, this will prevent
230         // creating a proposal that would never pass checks anyway.
231         require(adminCount_ > 1, "removeAdmin failed - cannot have less than 2 admins");
232         require(adminCount_ >= requiredSignatures_, "removeAdmin failed - cannot have less admins than number of required signatures");
233         if (admins_[_who].isDev == true)
234         {
235             require(devCount_ > 1, "removeAdmin failed - cannot have less than 2 devs");
236             require(devCount_ >= requiredDevSignatures_, "removeAdmin failed - cannot have less devs than number of required dev signatures");
237         }
238         
239         // checks passed
240         if (MSFun.multiSig(msData, requiredDevSignatures_, "removeAdmin") == true) 
241         {
242             MSFun.deleteProposal(msData, "removeAdmin");
243             
244             // must check this so we dont mess up admin count by removing someone
245             // who wasnt an admin to start with
246             if (admins_[_who].isAdmin == true) {  
247                 
248                 //set admins flag to false in admin mapping
249                 admins_[_who].isAdmin = false;
250                 
251                 //adjust admin count and required signatures
252                 adminCount_ -= 1;
253                 if (requiredSignatures_ > 1) 
254                 {
255                     requiredSignatures_ -= 1;
256                 }
257             }
258             
259             // were they also a dev?
260             if (admins_[_who].isDev == true) {
261                 
262                 //set dev flag to false
263                 admins_[_who].isDev = false;
264                 
265                 //adjust dev count and required dev signatures
266                 devCount_ -= 1;
267                 if (requiredDevSignatures_ > 1) 
268                 {
269                     requiredDevSignatures_ -= 1;
270                 }
271             }
272         }
273     }
274 
275     /**
276     * @dev DEV - change the number of required signatures.  must be between
277     * 1 and the number of admins.  this is a dev only function
278     * @param _howMany - desired number of required signatures
279     */
280     function changeRequiredSignatures(uint256 _howMany)
281         public
282         onlyDevs()
283     {  
284         // make sure its between 1 and number of admins
285         require(_howMany > 0 && _howMany <= adminCount_, "changeRequiredSignatures failed - must be between 1 and number of admins");
286         
287         if (MSFun.multiSig(msData, requiredDevSignatures_, "changeRequiredSignatures") == true) 
288         {
289             MSFun.deleteProposal(msData, "changeRequiredSignatures");
290             
291             // store new setting.
292             requiredSignatures_ = _howMany;
293         }
294     }
295     
296     /**
297     * @dev DEV - change the number of required dev signatures.  must be between
298     * 1 and the number of devs.  this is a dev only function
299     * @param _howMany - desired number of required dev signatures
300     */
301     function changeRequiredDevSignatures(uint256 _howMany)
302         public
303         onlyDevs()
304     {  
305         // make sure its between 1 and number of admins
306         require(_howMany > 0 && _howMany <= devCount_, "changeRequiredDevSignatures failed - must be between 1 and number of devs");
307         
308         if (MSFun.multiSig(msData, requiredDevSignatures_, "changeRequiredDevSignatures") == true) 
309         {
310             MSFun.deleteProposal(msData, "changeRequiredDevSignatures");
311             
312             // store new setting.
313             requiredDevSignatures_ = _howMany;
314         }
315     }
316 
317     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
318     // EXTERNAL FUNCTIONS 
319     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
320     function requiredSignatures() external view returns(uint256) {return(requiredSignatures_);}
321     function requiredDevSignatures() external view returns(uint256) {return(requiredDevSignatures_);}
322     function adminCount() external view returns(uint256) {return(adminCount_);}
323     function devCount() external view returns(uint256) {return(devCount_);}
324     function adminName(address _who) external view returns(bytes32) {return(admins_[_who].name);}
325     function isAdmin(address _who) external view returns(bool) {return(admins_[_who].isAdmin);}
326     function isDev(address _who) external view returns(bool) {return(admins_[_who].isDev);}
327 }
328 
329 library MSFun {
330     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
331     // DATA SETS
332     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
333     // contact data setup
334     struct Data 
335     {
336         mapping (bytes32 => ProposalData) proposal_;
337     }
338     struct ProposalData 
339     {
340         // a hash of msg.data 
341         bytes32 msgData;
342         // number of signers
343         uint256 count;
344         // tracking of wither admins have signed
345         mapping (address => bool) admin;
346         // list of admins who have signed
347         mapping (uint256 => address) log;
348     }
349     
350     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
351     // MULTI SIG FUNCTIONS
352     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
353     function multiSig(Data storage self, uint256 _requiredSignatures, bytes32 _whatFunction)
354         internal
355         returns(bool) 
356     {
357         // our proposal key will be a hash of our function name + our contracts address 
358         // by adding our contracts address to this, we prevent anyone trying to circumvent
359         // the proposal's security via external calls.
360         bytes32 _whatProposal = whatProposal(_whatFunction);
361         
362         // this is just done to make the code more readable.  grabs the signature count
363         uint256 _currentCount = self.proposal_[_whatProposal].count;
364         
365         // store the address of the person sending the function call.  we use msg.sender 
366         // here as a layer of security.  in case someone imports our contract and tries to 
367         // circumvent function arguments.  still though, our contract that imports this
368         // library and calls multisig, needs to use onlyAdmin modifiers or anyone who
369         // calls the function will be a signer. 
370         address _whichAdmin = msg.sender;
371         
372         // prepare our msg data.  by storing this we are able to verify that all admins
373         // are approving the same argument input to be executed for the function.  we hash 
374         // it and store in bytes32 so its size is known and comparable
375         bytes32 _msgData = keccak256(msg.data);
376         
377         // check to see if this is a new execution of this proposal or not
378         if (_currentCount == 0)
379         {
380             // if it is, lets record the original signers data
381             self.proposal_[_whatProposal].msgData = _msgData;
382             
383             // record original senders signature
384             self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
385             
386             // update log (used to delete records later, and easy way to view signers)
387             // also useful if the calling function wants to give something to a 
388             // specific signer.  
389             self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
390             
391             // track number of signatures
392             self.proposal_[_whatProposal].count += 1;  
393             
394             // if we now have enough signatures to execute the function, lets
395             // return a bool of true.  we put this here in case the required signatures
396             // is set to 1.
397             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
398                 return(true);
399             }            
400         // if its not the first execution, lets make sure the msgData matches
401         } else if (self.proposal_[_whatProposal].msgData == _msgData) {
402             // msgData is a match
403             // make sure admin hasnt already signed
404             if (self.proposal_[_whatProposal].admin[_whichAdmin] == false) 
405             {
406                 // record their signature
407                 self.proposal_[_whatProposal].admin[_whichAdmin] = true;        
408                 
409                 // update log (used to delete records later, and easy way to view signers)
410                 self.proposal_[_whatProposal].log[_currentCount] = _whichAdmin;  
411                 
412                 // track number of signatures
413                 self.proposal_[_whatProposal].count += 1;  
414             }
415             
416             // if we now have enough signatures to execute the function, lets
417             // return a bool of true.
418             // we put this here for a few reasons.  (1) in normal operation, if 
419             // that last recorded signature got us to our required signatures.  we 
420             // need to return bool of true.  (2) if we have a situation where the 
421             // required number of signatures was adjusted to at or lower than our current 
422             // signature count, by putting this here, an admin who has already signed,
423             // can call the function again to make it return a true bool.  but only if
424             // they submit the correct msg data
425             if (self.proposal_[_whatProposal].count == _requiredSignatures) {
426                 return(true);
427             }
428         }
429     }
430     
431     
432     // deletes proposal signature data after successfully executing a multiSig function
433     function deleteProposal(Data storage self, bytes32 _whatFunction)
434         internal
435     {
436         //done for readability sake
437         bytes32 _whatProposal = whatProposal(_whatFunction);
438         address _whichAdmin;
439         
440         //delete the admins votes & log.   i know for loops are terrible.  but we have to do this 
441         //for our data stored in mappings.  simply deleting the proposal itself wouldn't accomplish this.
442         for (uint256 i=0; i < self.proposal_[_whatProposal].count; i++) {
443             _whichAdmin = self.proposal_[_whatProposal].log[i];
444             delete self.proposal_[_whatProposal].admin[_whichAdmin];
445             delete self.proposal_[_whatProposal].log[i];
446         }
447         //delete the rest of the data in the record
448         delete self.proposal_[_whatProposal];
449     }
450     
451     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
452     // HELPER FUNCTIONS
453     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
454 
455     function whatProposal(bytes32 _whatFunction)
456         private
457         view
458         returns(bytes32)
459     {
460         return(keccak256(abi.encodePacked(_whatFunction,this)));
461     }
462     
463     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
464     // VANITY FUNCTIONS
465     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
466     // returns a hashed version of msg.data sent by original signer for any given function
467     function checkMsgData (Data storage self, bytes32 _whatFunction)
468         internal
469         view
470         returns (bytes32 msg_data)
471     {
472         bytes32 _whatProposal = whatProposal(_whatFunction);
473         return (self.proposal_[_whatProposal].msgData);
474     }
475     
476     // returns number of signers for any given function
477     function checkCount (Data storage self, bytes32 _whatFunction)
478         internal
479         view
480         returns (uint256 signature_count)
481     {
482         bytes32 _whatProposal = whatProposal(_whatFunction);
483         return (self.proposal_[_whatProposal].count);
484     }
485     
486     // returns address of an admin who signed for any given function
487     function checkSigner (Data storage self, bytes32 _whatFunction, uint256 _signer)
488         internal
489         view
490         returns (address signer)
491     {
492         require(_signer > 0, "MSFun checkSigner failed - 0 not allowed");
493         bytes32 _whatProposal = whatProposal(_whatFunction);
494         return (self.proposal_[_whatProposal].log[_signer - 1]);
495     }
496 }