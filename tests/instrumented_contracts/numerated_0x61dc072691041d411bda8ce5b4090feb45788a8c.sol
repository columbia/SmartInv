1 //File: node_modules/liquidpledging/contracts/ILiquidPledgingPlugin.sol
2 pragma solidity ^0.4.11;
3 
4 /*
5     Copyright 2017, Jordi Baylina
6     Contributor: Adrià Massanet <adria@codecontext.io>
7 
8     This program is free software: you can redistribute it and/or modify
9     it under the terms of the GNU General Public License as published by
10     the Free Software Foundation, either version 3 of the License, or
11     (at your option) any later version.
12 
13     This program is distributed in the hope that it will be useful,
14     but WITHOUT ANY WARRANTY; without even the implied warranty of
15     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
16     GNU General Public License for more details.
17 
18     You should have received a copy of the GNU General Public License
19     along with this program.  If not, see <http://www.gnu.org/licenses/>.
20 */
21 
22 
23 /// @dev `ILiquidPledgingPlugin` is the basic interface for any
24 ///  liquid pledging plugin
25 contract ILiquidPledgingPlugin {
26 
27     /// @notice Plugins are used (much like web hooks) to initiate an action
28     ///  upon any donation, delegation, or transfer; this is an optional feature
29     ///  and allows for extreme customization of the contract. This function
30     ///  implements any action that should be initiated before a transfer.
31     /// @param pledgeManager The admin or current manager of the pledge
32     /// @param pledgeFrom This is the Id from which value will be transfered.
33     /// @param pledgeTo This is the Id that value will be transfered to.    
34     /// @param context The situation that is triggering the plugin:
35     ///  0 -> Plugin for the owner transferring pledge to another party
36     ///  1 -> Plugin for the first delegate transferring pledge to another party
37     ///  2 -> Plugin for the second delegate transferring pledge to another party
38     ///  ...
39     ///  255 -> Plugin for the intendedProject transferring pledge to another party
40     ///
41     ///  256 -> Plugin for the owner receiving pledge to another party
42     ///  257 -> Plugin for the first delegate receiving pledge to another party
43     ///  258 -> Plugin for the second delegate receiving pledge to another party
44     ///  ...
45     ///  511 -> Plugin for the intendedProject receiving pledge to another party
46     /// @param amount The amount of value that will be transfered.
47     function beforeTransfer(
48         uint64 pledgeManager,
49         uint64 pledgeFrom,
50         uint64 pledgeTo,
51         uint64 context,
52         uint amount ) returns (uint maxAllowed);
53 
54     /// @notice Plugins are used (much like web hooks) to initiate an action
55     ///  upon any donation, delegation, or transfer; this is an optional feature
56     ///  and allows for extreme customization of the contract. This function
57     ///  implements any action that should be initiated after a transfer.
58     /// @param pledgeManager The admin or current manager of the pledge
59     /// @param pledgeFrom This is the Id from which value will be transfered.
60     /// @param pledgeTo This is the Id that value will be transfered to.    
61     /// @param context The situation that is triggering the plugin:
62     ///  0 -> Plugin for the owner transferring pledge to another party
63     ///  1 -> Plugin for the first delegate transferring pledge to another party
64     ///  2 -> Plugin for the second delegate transferring pledge to another party
65     ///  ...
66     ///  255 -> Plugin for the intendedProject transferring pledge to another party
67     ///
68     ///  256 -> Plugin for the owner receiving pledge to another party
69     ///  257 -> Plugin for the first delegate receiving pledge to another party
70     ///  258 -> Plugin for the second delegate receiving pledge to another party
71     ///  ...
72     ///  511 -> Plugin for the intendedProject receiving pledge to another party
73     ///  @param amount The amount of value that will be transfered.
74     function afterTransfer(
75         uint64 pledgeManager,
76         uint64 pledgeFrom,
77         uint64 pledgeTo,
78         uint64 context,
79         uint amount
80     );
81 }
82 
83 //File: node_modules/giveth-common-contracts/contracts/Owned.sol
84 pragma solidity ^0.4.15;
85 
86 
87 /// @title Owned
88 /// @author Adrià Massanet <adria@codecontext.io>
89 /// @notice The Owned contract has an owner address, and provides basic 
90 ///  authorization control functions, this simplifies & the implementation of
91 ///  user permissions; this contract has three work flows for a change in
92 ///  ownership, the first requires the new owner to validate that they have the
93 ///  ability to accept ownership, the second allows the ownership to be
94 ///  directly transfered without requiring acceptance, and the third allows for
95 ///  the ownership to be removed to allow for decentralization 
96 contract Owned {
97 
98     address public owner;
99     address public newOwnerCandidate;
100 
101     event OwnershipRequested(address indexed by, address indexed to);
102     event OwnershipTransferred(address indexed from, address indexed to);
103     event OwnershipRemoved();
104 
105     /// @dev The constructor sets the `msg.sender` as the`owner` of the contract
106     function Owned() public {
107         owner = msg.sender;
108     }
109 
110     /// @dev `owner` is the only address that can call a function with this
111     /// modifier
112     modifier onlyOwner() {
113         require (msg.sender == owner);
114         _;
115     }
116     
117     /// @dev In this 1st option for ownership transfer `proposeOwnership()` must
118     ///  be called first by the current `owner` then `acceptOwnership()` must be
119     ///  called by the `newOwnerCandidate`
120     /// @notice `onlyOwner` Proposes to transfer control of the contract to a
121     ///  new owner
122     /// @param _newOwnerCandidate The address being proposed as the new owner
123     function proposeOwnership(address _newOwnerCandidate) public onlyOwner {
124         newOwnerCandidate = _newOwnerCandidate;
125         OwnershipRequested(msg.sender, newOwnerCandidate);
126     }
127 
128     /// @notice Can only be called by the `newOwnerCandidate`, accepts the
129     ///  transfer of ownership
130     function acceptOwnership() public {
131         require(msg.sender == newOwnerCandidate);
132 
133         address oldOwner = owner;
134         owner = newOwnerCandidate;
135         newOwnerCandidate = 0x0;
136 
137         OwnershipTransferred(oldOwner, owner);
138     }
139 
140     /// @dev In this 2nd option for ownership transfer `changeOwnership()` can
141     ///  be called and it will immediately assign ownership to the `newOwner`
142     /// @notice `owner` can step down and assign some other address to this role
143     /// @param _newOwner The address of the new owner
144     function changeOwnership(address _newOwner) public onlyOwner {
145         require(_newOwner != 0x0);
146 
147         address oldOwner = owner;
148         owner = _newOwner;
149         newOwnerCandidate = 0x0;
150 
151         OwnershipTransferred(oldOwner, owner);
152     }
153 
154     /// @dev In this 3rd option for ownership transfer `removeOwnership()` can
155     ///  be called and it will immediately assign ownership to the 0x0 address;
156     ///  it requires a 0xdece be input as a parameter to prevent accidental use
157     /// @notice Decentralizes the contract, this operation cannot be undone 
158     /// @param _dac `0xdac` has to be entered for this function to work
159     function removeOwnership(address _dac) public onlyOwner {
160         require(_dac == 0xdac);
161         owner = 0x0;
162         newOwnerCandidate = 0x0;
163         OwnershipRemoved();     
164     }
165 } 
166 
167 //File: node_modules/giveth-common-contracts/contracts/ERC20.sol
168 pragma solidity ^0.4.15;
169 
170 
171 /**
172  * @title ERC20
173  * @dev A standard interface for tokens.
174  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
175  */
176 contract ERC20 {
177   
178     /// @dev Returns the total token supply
179     function totalSupply() public constant returns (uint256 supply);
180 
181     /// @dev Returns the account balance of the account with address _owner
182     function balanceOf(address _owner) public constant returns (uint256 balance);
183 
184     /// @dev Transfers _value number of tokens to address _to
185     function transfer(address _to, uint256 _value) public returns (bool success);
186 
187     /// @dev Transfers _value number of tokens from address _from to address _to
188     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
189 
190     /// @dev Allows _spender to withdraw from the msg.sender's account up to the _value amount
191     function approve(address _spender, uint256 _value) public returns (bool success);
192 
193     /// @dev Returns the amount which _spender is still allowed to withdraw from _owner
194     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
195 
196     event Transfer(address indexed _from, address indexed _to, uint256 _value);
197     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
198 
199 }
200 
201 //File: node_modules/giveth-common-contracts/contracts/Escapable.sol
202 pragma solidity ^0.4.15;
203 /*
204     Copyright 2016, Jordi Baylina
205     Contributor: Adrià Massanet <adria@codecontext.io>
206 
207     This program is free software: you can redistribute it and/or modify
208     it under the terms of the GNU General Public License as published by
209     the Free Software Foundation, either version 3 of the License, or
210     (at your option) any later version.
211 
212     This program is distributed in the hope that it will be useful,
213     but WITHOUT ANY WARRANTY; without even the implied warranty of
214     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
215     GNU General Public License for more details.
216 
217     You should have received a copy of the GNU General Public License
218     along with this program.  If not, see <http://www.gnu.org/licenses/>.
219 */
220 
221 
222 
223 
224 
225 /// @dev `Escapable` is a base level contract built off of the `Owned`
226 ///  contract; it creates an escape hatch function that can be called in an
227 ///  emergency that will allow designated addresses to send any ether or tokens
228 ///  held in the contract to an `escapeHatchDestination` as long as they were
229 ///  not blacklisted
230 contract Escapable is Owned {
231     address public escapeHatchCaller;
232     address public escapeHatchDestination;
233     mapping (address=>bool) private escapeBlacklist; // Token contract addresses
234 
235     /// @notice The Constructor assigns the `escapeHatchDestination` and the
236     ///  `escapeHatchCaller`
237     /// @param _escapeHatchCaller The address of a trusted account or contract
238     ///  to call `escapeHatch()` to send the ether in this contract to the
239     ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller`
240     ///  cannot move funds out of `escapeHatchDestination`
241     /// @param _escapeHatchDestination The address of a safe location (usu a
242     ///  Multisig) to send the ether held in this contract; if a neutral address
243     ///  is required, the WHG Multisig is an option:
244     ///  0x8Ff920020c8AD673661c8117f2855C384758C572 
245     function Escapable(address _escapeHatchCaller, address _escapeHatchDestination) public {
246         escapeHatchCaller = _escapeHatchCaller;
247         escapeHatchDestination = _escapeHatchDestination;
248     }
249 
250     /// @dev The addresses preassigned as `escapeHatchCaller` or `owner`
251     ///  are the only addresses that can call a function with this modifier
252     modifier onlyEscapeHatchCallerOrOwner {
253         require ((msg.sender == escapeHatchCaller)||(msg.sender == owner));
254         _;
255     }
256 
257     /// @notice Creates the blacklist of tokens that are not able to be taken
258     ///  out of the contract; can only be done at the deployment, and the logic
259     ///  to add to the blacklist will be in the constructor of a child contract
260     /// @param _token the token contract address that is to be blacklisted 
261     function blacklistEscapeToken(address _token) internal {
262         escapeBlacklist[_token] = true;
263         EscapeHatchBlackistedToken(_token);
264     }
265 
266     /// @notice Checks to see if `_token` is in the blacklist of tokens
267     /// @param _token the token address being queried
268     /// @return False if `_token` is in the blacklist and can't be taken out of
269     ///  the contract via the `escapeHatch()`
270     function isTokenEscapable(address _token) constant public returns (bool) {
271         return !escapeBlacklist[_token];
272     }
273 
274     /// @notice The `escapeHatch()` should only be called as a last resort if a
275     /// security issue is uncovered or something unexpected happened
276     /// @param _token to transfer, use 0x0 for ether
277     function escapeHatch(address _token) public onlyEscapeHatchCallerOrOwner {   
278         require(escapeBlacklist[_token]==false);
279 
280         uint256 balance;
281 
282         /// @dev Logic for ether
283         if (_token == 0x0) {
284             balance = this.balance;
285             escapeHatchDestination.transfer(balance);
286             EscapeHatchCalled(_token, balance);
287             return;
288         }
289         /// @dev Logic for tokens
290         ERC20 token = ERC20(_token);
291         balance = token.balanceOf(this);
292         require(token.transfer(escapeHatchDestination, balance));
293         EscapeHatchCalled(_token, balance);
294     }
295 
296     /// @notice Changes the address assigned to call `escapeHatch()`
297     /// @param _newEscapeHatchCaller The address of a trusted account or
298     ///  contract to call `escapeHatch()` to send the value in this contract to
299     ///  the `escapeHatchDestination`; it would be ideal that `escapeHatchCaller`
300     ///  cannot move funds out of `escapeHatchDestination`
301     function changeHatchEscapeCaller(address _newEscapeHatchCaller) public onlyEscapeHatchCallerOrOwner {
302         escapeHatchCaller = _newEscapeHatchCaller;
303     }
304 
305     event EscapeHatchBlackistedToken(address token);
306     event EscapeHatchCalled(address token, uint amount);
307 }
308 
309 //File: node_modules/liquidpledging/contracts/LiquidPledgingBase.sol
310 pragma solidity ^0.4.11;
311 /*
312     Copyright 2017, Jordi Baylina
313     Contributors: Adrià Massanet <adria@codecontext.io>, RJ Ewing, Griff
314     Green, Arthur Lunn
315 
316     This program is free software: you can redistribute it and/or modify
317     it under the terms of the GNU General Public License as published by
318     the Free Software Foundation, either version 3 of the License, or
319     (at your option) any later version.
320 
321     This program is distributed in the hope that it will be useful,
322     but WITHOUT ANY WARRANTY; without even the implied warranty of
323     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
324     GNU General Public License for more details.
325 
326     You should have received a copy of the GNU General Public License
327     along with this program.  If not, see <http://www.gnu.org/licenses/>.
328 */
329 
330 
331 
332 
333 /// @dev This is an interface for `LPVault` which serves as a secure storage for
334 ///  the ETH that backs the Pledges, only after `LiquidPledging` authorizes
335 ///  payments can Pledges be converted for ETH
336 interface LPVault {
337     function authorizePayment(bytes32 _ref, address _dest, uint _amount);
338     function () payable;
339 }
340 
341 /// @dev `LiquidPledgingBase` is the base level contract used to carry out
342 ///  liquidPledging's most basic functions, mostly handling and searching the
343 ///  data structures
344 contract LiquidPledgingBase is Escapable {
345 
346     // Limits inserted to prevent large loops that could prevent canceling
347     uint constant MAX_DELEGATES = 20;
348     uint constant MAX_SUBPROJECT_LEVEL = 20;
349     uint constant MAX_INTERPROJECT_LEVEL = 20;
350 
351     enum PledgeAdminType { Giver, Delegate, Project }
352     enum PledgeState { Pledged, Paying, Paid }
353 
354     /// @dev This struct defines the details of a `PledgeAdmin` which are 
355     ///  commonly referenced by their index in the `admins` array
356     ///  and can own pledges and act as delegates
357     struct PledgeAdmin { 
358         PledgeAdminType adminType; // Giver, Delegate or Project
359         address addr; // Account or contract address for admin
360         string name;
361         string url;  // Can be IPFS hash
362         uint64 commitTime;  // In seconds, used for Givers' & Delegates' vetos
363         uint64 parentProject;  // Only for projects
364         bool canceled;      //Always false except for canceled projects
365 
366         /// @dev if the plugin is 0x0 then nothing happens, if its an address
367         // than that smart contract is called when appropriate
368         ILiquidPledgingPlugin plugin; 
369     }
370 
371     struct Pledge {
372         uint amount;
373         uint64 owner; // PledgeAdmin
374         uint64[] delegationChain; // List of delegates in order of authority
375         uint64 intendedProject; // Used when delegates are sending to projects
376         uint64 commitTime;  // When the intendedProject will become the owner  
377         uint64 oldPledge; // Points to the id that this Pledge was derived from
378         PledgeState pledgeState; //  Pledged, Paying, Paid
379     }
380 
381     Pledge[] pledges;
382     PledgeAdmin[] admins; //The list of pledgeAdmins 0 means there is no admin
383     LPVault public vault;
384 
385     /// @dev this mapping allows you to search for a specific pledge's 
386     ///  index number by the hash of that pledge
387     mapping (bytes32 => uint64) hPledge2idx;
388     mapping (bytes32 => bool) pluginWhitelist;
389     
390     bool public usePluginWhitelist = true;
391 
392 /////////////
393 // Modifiers
394 /////////////
395 
396 
397     /// @dev The `vault`is the only addresses that can call a function with this
398     ///  modifier
399     modifier onlyVault() {
400         require(msg.sender == address(vault));
401         _;
402     }
403 
404 
405 ///////////////
406 // Constructor
407 ///////////////
408 
409     /// @notice The Constructor creates `LiquidPledgingBase` on the blockchain
410     /// @param _vault The vault where the ETH backing the pledges is stored
411     function LiquidPledgingBase(
412         address _vault,
413         address _escapeHatchCaller,
414         address _escapeHatchDestination
415     ) Escapable(_escapeHatchCaller, _escapeHatchDestination) public {
416         admins.length = 1; // we reserve the 0 admin
417         pledges.length = 1; // we reserve the 0 pledge
418         vault = LPVault(_vault); // Assigns the specified vault
419     }
420 
421 
422 /////////////////////////
423 // PledgeAdmin functions
424 /////////////////////////
425 
426     /// @notice Creates a Giver Admin with the `msg.sender` as the Admin address
427     /// @param name The name used to identify the Giver
428     /// @param url The link to the Giver's profile often an IPFS hash
429     /// @param commitTime The length of time in seconds the Giver has to
430     ///   veto when the Giver's delegates Pledge funds to a project
431     /// @param plugin This is Giver's liquid pledge plugin allowing for 
432     ///  extended functionality
433     /// @return idGiver The id number used to reference this Admin
434     function addGiver(
435         string name,
436         string url,
437         uint64 commitTime,
438         ILiquidPledgingPlugin plugin
439     ) returns (uint64 idGiver) {
440 
441         require(isValidPlugin(plugin)); // Plugin check
442 
443         idGiver = uint64(admins.length);
444 
445         admins.push(PledgeAdmin(
446             PledgeAdminType.Giver,
447             msg.sender,
448             name,
449             url,
450             commitTime,
451             0,
452             false,
453             plugin));
454 
455         GiverAdded(idGiver);
456     }
457 
458     event GiverAdded(uint64 indexed idGiver);
459 
460     /// @notice Updates a Giver's info to change the address, name, url, or 
461     ///  commitTime, it cannot be used to change a plugin, and it must be called
462     ///  by the current address of the Giver
463     /// @param idGiver This is the Admin id number used to specify the Giver
464     /// @param newAddr The new address that represents this Giver
465     /// @param newName The new name used to identify the Giver
466     /// @param newUrl The new link to the Giver's profile often an IPFS hash
467     /// @param newCommitTime Sets the length of time in seconds the Giver has to
468     ///   veto when the Giver's delegates Pledge funds to a project
469     function updateGiver(
470         uint64 idGiver,
471         address newAddr,
472         string newName,
473         string newUrl,
474         uint64 newCommitTime)
475     {
476         PledgeAdmin storage giver = findAdmin(idGiver);
477         require(giver.adminType == PledgeAdminType.Giver); // Must be a Giver
478         require(giver.addr == msg.sender); // Current addr had to send this tx
479         giver.addr = newAddr;
480         giver.name = newName;
481         giver.url = newUrl;
482         giver.commitTime = newCommitTime;
483         GiverUpdated(idGiver);
484     }
485 
486     event GiverUpdated(uint64 indexed idGiver);
487 
488     /// @notice Creates a Delegate Admin with the `msg.sender` as the Admin addr
489     /// @param name The name used to identify the Delegate
490     /// @param url The link to the Delegate's profile often an IPFS hash
491     /// @param commitTime Sets the length of time in seconds that this delegate
492     ///  can be vetoed. Whenever this delegate is in a delegate chain the time
493     ///  allowed to veto any event must be greater than or equal to this time.
494     /// @param plugin This is Delegate's liquid pledge plugin allowing for 
495     ///  extended functionality
496     /// @return idxDelegate The id number used to reference this Delegate within
497     ///  the admins array
498     function addDelegate(
499         string name,
500         string url,
501         uint64 commitTime,
502         ILiquidPledgingPlugin plugin
503     ) returns (uint64 idDelegate) { 
504 
505         require(isValidPlugin(plugin)); // Plugin check
506 
507         idDelegate = uint64(admins.length);
508 
509         admins.push(PledgeAdmin(
510             PledgeAdminType.Delegate,
511             msg.sender,
512             name,
513             url,
514             commitTime,
515             0,
516             false,
517             plugin));
518 
519         DelegateAdded(idDelegate);
520     }
521 
522     event DelegateAdded(uint64 indexed idDelegate);
523 
524     /// @notice Updates a Delegate's info to change the address, name, url, or 
525     ///  commitTime, it cannot be used to change a plugin, and it must be called
526     ///  by the current address of the Delegate
527     /// @param idDelegate The Admin id number used to specify the Delegate
528     /// @param newAddr The new address that represents this Delegate
529     /// @param newName The new name used to identify the Delegate
530     /// @param newUrl The new link to the Delegate's profile often an IPFS hash
531     /// @param newCommitTime Sets the length of time in seconds that this 
532     ///  delegate can be vetoed. Whenever this delegate is in a delegate chain 
533     ///  the time allowed to veto any event must be greater than or equal to
534     ///  this time.
535     function updateDelegate(
536         uint64 idDelegate,
537         address newAddr,
538         string newName,
539         string newUrl,
540         uint64 newCommitTime) {
541         PledgeAdmin storage delegate = findAdmin(idDelegate);
542         require(delegate.adminType == PledgeAdminType.Delegate);
543         require(delegate.addr == msg.sender);// Current addr had to send this tx
544         delegate.addr = newAddr;
545         delegate.name = newName;
546         delegate.url = newUrl;
547         delegate.commitTime = newCommitTime;
548         DelegateUpdated(idDelegate);
549     }
550 
551     event DelegateUpdated(uint64 indexed idDelegate);
552 
553     /// @notice Creates a Project Admin with the `msg.sender` as the Admin addr
554     /// @param name The name used to identify the Project
555     /// @param url The link to the Project's profile often an IPFS hash
556     /// @param projectAdmin The address for the trusted project manager 
557     /// @param parentProject The Admin id number for the parent project or 0 if
558     ///  there is no parentProject
559     /// @param commitTime Sets the length of time in seconds the Project has to
560     ///   veto when the Project delegates to another Delegate and they pledge 
561     ///   those funds to a project
562     /// @param plugin This is Project's liquid pledge plugin allowing for 
563     ///  extended functionality
564     /// @return idProject The id number used to reference this Admin
565     function addProject(
566         string name,
567         string url,
568         address projectAdmin,
569         uint64 parentProject,
570         uint64 commitTime,
571         ILiquidPledgingPlugin plugin
572     ) returns (uint64 idProject) {
573         require(isValidPlugin(plugin));
574 
575         if (parentProject != 0) {
576             PledgeAdmin storage pa = findAdmin(parentProject);
577             require(pa.adminType == PledgeAdminType.Project);
578             require(getProjectLevel(pa) < MAX_SUBPROJECT_LEVEL);
579         }
580 
581         idProject = uint64(admins.length);
582 
583         admins.push(PledgeAdmin(
584             PledgeAdminType.Project,
585             projectAdmin,
586             name,
587             url,
588             commitTime,
589             parentProject,
590             false,
591             plugin));
592 
593 
594         ProjectAdded(idProject);
595     }
596 
597     event ProjectAdded(uint64 indexed idProject);
598 
599 
600     /// @notice Updates a Project's info to change the address, name, url, or 
601     ///  commitTime, it cannot be used to change a plugin or a parentProject,
602     ///  and it must be called by the current address of the Project
603     /// @param idProject The Admin id number used to specify the Project
604     /// @param newAddr The new address that represents this Project
605     /// @param newName The new name used to identify the Project
606     /// @param newUrl The new link to the Project's profile often an IPFS hash
607     /// @param newCommitTime Sets the length of time in seconds the Project has
608     ///  to veto when the Project delegates to a Delegate and they pledge those
609     ///  funds to a project
610     function updateProject(
611         uint64 idProject,
612         address newAddr,
613         string newName,
614         string newUrl,
615         uint64 newCommitTime)
616     {
617         PledgeAdmin storage project = findAdmin(idProject);
618         require(project.adminType == PledgeAdminType.Project);
619         require(project.addr == msg.sender);
620         project.addr = newAddr;
621         project.name = newName;
622         project.url = newUrl;
623         project.commitTime = newCommitTime;
624         ProjectUpdated(idProject);
625     }
626 
627     event ProjectUpdated(uint64 indexed idAdmin);
628 
629 
630 //////////
631 // Public constant functions
632 //////////
633 
634     /// @notice A constant getter that returns the total number of pledges
635     /// @return The total number of Pledges in the system
636     function numberOfPledges() constant returns (uint) {
637         return pledges.length - 1;
638     }
639 
640     /// @notice A getter that returns the details of the specified pledge
641     /// @param idPledge the id number of the pledge being queried
642     /// @return the amount, owner, the number of delegates (but not the actual
643     ///  delegates, the intendedProject (if any), the current commit time and
644     ///  the previous pledge this pledge was derived from
645     function getPledge(uint64 idPledge) constant returns(
646         uint amount,
647         uint64 owner,
648         uint64 nDelegates,
649         uint64 intendedProject,
650         uint64 commitTime,
651         uint64 oldPledge,
652         PledgeState pledgeState
653     ) {
654         Pledge storage p = findPledge(idPledge);
655         amount = p.amount;
656         owner = p.owner;
657         nDelegates = uint64(p.delegationChain.length);
658         intendedProject = p.intendedProject;
659         commitTime = p.commitTime;
660         oldPledge = p.oldPledge;
661         pledgeState = p.pledgeState;
662     }
663 
664     /// @notice Getter to find Delegate w/ the Pledge ID & the Delegate index
665     /// @param idPledge The id number representing the pledge being queried
666     /// @param idxDelegate The index number for the delegate in this Pledge 
667     function getPledgeDelegate(uint64 idPledge, uint idxDelegate) constant returns(
668         uint64 idDelegate,
669         address addr,
670         string name
671     ) {
672         Pledge storage p = findPledge(idPledge);
673         idDelegate = p.delegationChain[idxDelegate - 1];
674         PledgeAdmin storage delegate = findAdmin(idDelegate);
675         addr = delegate.addr;
676         name = delegate.name;
677     }
678 
679     /// @notice A constant getter used to check how many total Admins exist
680     /// @return The total number of admins (Givers, Delegates and Projects) .
681     function numberOfPledgeAdmins() constant returns(uint) {
682         return admins.length - 1;
683     }
684 
685     /// @notice A constant getter to check the details of a specified Admin  
686     /// @return addr Account or contract address for admin
687     /// @return name Name of the pledgeAdmin
688     /// @return url The link to the Project's profile often an IPFS hash
689     /// @return commitTime The length of time in seconds the Admin has to veto
690     ///   when the Admin delegates to a Delegate and that Delegate pledges those
691     ///   funds to a project
692     /// @return parentProject The Admin id number for the parent project or 0
693     ///  if there is no parentProject
694     /// @return canceled 0 for Delegates & Givers, true if a Project has been 
695     ///  canceled
696     /// @return plugin This is Project's liquidPledging plugin allowing for 
697     ///  extended functionality
698     function getPledgeAdmin(uint64 idAdmin) constant returns (
699         PledgeAdminType adminType,
700         address addr,
701         string name,
702         string url,
703         uint64 commitTime,
704         uint64 parentProject,
705         bool canceled,
706         address plugin)
707     {
708         PledgeAdmin storage m = findAdmin(idAdmin);
709         adminType = m.adminType;
710         addr = m.addr;
711         name = m.name;
712         url = m.url;
713         commitTime = m.commitTime;
714         parentProject = m.parentProject;
715         canceled = m.canceled;
716         plugin = address(m.plugin);
717     }
718 
719 ////////
720 // Private methods
721 ///////
722 
723     /// @notice This creates a Pledge with an initial amount of 0 if one is not
724     ///  created already; otherwise it finds the pledge with the specified
725     ///  attributes; all pledges technically exist, if the pledge hasn't been
726     ///  created in this system yet it simply isn't in the hash array
727     ///  hPledge2idx[] yet
728     /// @param owner The owner of the pledge being looked up
729     /// @param delegationChain The list of delegates in order of authority
730     /// @param intendedProject The project this pledge will Fund after the
731     ///  commitTime has passed
732     /// @param commitTime The length of time in seconds the Giver has to
733     ///   veto when the Giver's delegates Pledge funds to a project
734     /// @param oldPledge This value is used to store the pledge the current
735     ///  pledge was came from, and in the case a Project is canceled, the Pledge
736     ///  will revert back to it's previous state
737     /// @param state The pledge state: Pledged, Paying, or state
738     /// @return The hPledge2idx index number
739     function findOrCreatePledge(
740         uint64 owner,
741         uint64[] delegationChain,
742         uint64 intendedProject,
743         uint64 commitTime,
744         uint64 oldPledge,
745         PledgeState state
746         ) internal returns (uint64)
747     {
748         bytes32 hPledge = sha3(
749             owner, delegationChain, intendedProject, commitTime, oldPledge, state);
750         uint64 idx = hPledge2idx[hPledge];
751         if (idx > 0) return idx;
752         idx = uint64(pledges.length);
753         hPledge2idx[hPledge] = idx;
754         pledges.push(Pledge(
755             0, owner, delegationChain, intendedProject, commitTime, oldPledge, state));
756         return idx;
757     }
758 
759     /// @notice A getter to look up a Admin's details
760     /// @param idAdmin The id for the Admin to lookup
761     /// @return The PledgeAdmin struct for the specified Admin
762     function findAdmin(uint64 idAdmin) internal returns (PledgeAdmin storage) {
763         require(idAdmin < admins.length);
764         return admins[idAdmin];
765     }
766 
767     /// @notice A getter to look up a Pledge's details
768     /// @param idPledge The id for the Pledge to lookup
769     /// @return The PledgeA struct for the specified Pledge
770     function findPledge(uint64 idPledge) internal returns (Pledge storage) {
771         require(idPledge < pledges.length);
772         return pledges[idPledge];
773     }
774 
775     // a constant for when a delegate is requested that is not in the system
776     uint64 constant  NOTFOUND = 0xFFFFFFFFFFFFFFFF;
777 
778     /// @notice A getter that searches the delegationChain for the level of
779     ///  authority a specific delegate has within a Pledge
780     /// @param p The Pledge that will be searched
781     /// @param idDelegate The specified delegate that's searched for
782     /// @return If the delegate chain contains the delegate with the
783     ///  `admins` array index `idDelegate` this returns that delegates
784     ///  corresponding index in the delegationChain. Otherwise it returns
785     ///  the NOTFOUND constant
786     function getDelegateIdx(Pledge p, uint64 idDelegate) internal returns(uint64) {
787         for (uint i=0; i < p.delegationChain.length; i++) {
788             if (p.delegationChain[i] == idDelegate) return uint64(i);
789         }
790         return NOTFOUND;
791     }
792 
793     /// @notice A getter to find how many old "parent" pledges a specific Pledge
794     ///  had using a self-referential loop
795     /// @param p The Pledge being queried
796     /// @return The number of old "parent" pledges a specific Pledge had
797     function getPledgeLevel(Pledge p) internal returns(uint) {
798         if (p.oldPledge == 0) return 0;
799         Pledge storage oldN = findPledge(p.oldPledge);
800         return getPledgeLevel(oldN) + 1; // a loop lookup
801     }
802 
803     /// @notice A getter to find the longest commitTime out of the owner and all
804     ///  the delegates for a specified pledge
805     /// @param p The Pledge being queried
806     /// @return The maximum commitTime out of the owner and all the delegates
807     function maxCommitTime(Pledge p) internal returns(uint commitTime) {
808         PledgeAdmin storage m = findAdmin(p.owner);
809         commitTime = m.commitTime; // start with the owner's commitTime
810 
811         for (uint i=0; i<p.delegationChain.length; i++) {
812             m = findAdmin(p.delegationChain[i]);
813 
814             // If a delegate's commitTime is longer, make it the new commitTime
815             if (m.commitTime > commitTime) commitTime = m.commitTime;
816         }
817     }
818 
819     /// @notice A getter to find the level of authority a specific Project has
820     ///  using a self-referential loop
821     /// @param m The Project being queried
822     /// @return The level of authority a specific Project has
823     function getProjectLevel(PledgeAdmin m) internal returns(uint) {
824         assert(m.adminType == PledgeAdminType.Project);
825         if (m.parentProject == 0) return(1);
826         PledgeAdmin storage parentNM = findAdmin(m.parentProject);
827         return getProjectLevel(parentNM) + 1;
828     }
829 
830     /// @notice A getter to find if a specified Project has been canceled
831     /// @param projectId The Admin id number used to specify the Project
832     /// @return True if the Project has been canceled
833     function isProjectCanceled(uint64 projectId) constant returns (bool) {
834         PledgeAdmin storage m = findAdmin(projectId);
835         if (m.adminType == PledgeAdminType.Giver) return false;
836         assert(m.adminType == PledgeAdminType.Project);
837         if (m.canceled) return true;
838         if (m.parentProject == 0) return false;
839         return isProjectCanceled(m.parentProject);
840     }
841 
842     /// @notice A getter to find the oldest pledge that hasn't been canceled
843     /// @param idPledge The starting place to lookup the pledges 
844     /// @return The oldest idPledge that hasn't been canceled (DUH!)
845     function getOldestPledgeNotCanceled(uint64 idPledge
846         ) internal constant returns(uint64) {
847         if (idPledge == 0) return 0;
848         Pledge storage p = findPledge(idPledge);
849         PledgeAdmin storage admin = findAdmin(p.owner);
850         if (admin.adminType == PledgeAdminType.Giver) return idPledge;
851 
852         assert(admin.adminType == PledgeAdminType.Project);
853 
854         if (!isProjectCanceled(p.owner)) return idPledge;
855 
856         return getOldestPledgeNotCanceled(p.oldPledge);
857     }
858 
859     /// @notice A check to see if the msg.sender is the owner or the
860     ///  plugin contract for a specific Admin
861     /// @param m The Admin being checked
862     function checkAdminOwner(PledgeAdmin m) internal constant {
863         require((msg.sender == m.addr) || (msg.sender == address(m.plugin)));
864     }
865 ///////////////////////////
866 // Plugin Whitelist Methods
867 ///////////////////////////
868 
869     function addValidPlugin(bytes32 contractHash) external onlyOwner {
870         pluginWhitelist[contractHash] = true;
871     }
872 
873     function removeValidPlugin(bytes32 contractHash) external onlyOwner {
874         pluginWhitelist[contractHash] = false;
875     }
876 
877     function useWhitelist(bool useWhitelist) external onlyOwner {
878         usePluginWhitelist = useWhitelist;
879     }
880 
881     function isValidPlugin(address addr) public returns(bool) {
882         if (!usePluginWhitelist || addr == 0x0) return true;
883 
884         bytes32 contractHash = getCodeHash(addr);
885 
886         return pluginWhitelist[contractHash];
887     }
888 
889     function getCodeHash(address addr) public returns(bytes32) {
890         bytes memory o_code;
891         assembly {
892             // retrieve the size of the code, this needs assembly
893             let size := extcodesize(addr)
894             // allocate output byte array - this could also be done without assembly
895             // by using o_code = new bytes(size)
896             o_code := mload(0x40)
897             // new "memory end" including padding
898             mstore(0x40, add(o_code, and(add(add(size, 0x20), 0x1f), not(0x1f))))
899             // store length in memory
900             mstore(o_code, size)
901             // actually retrieve the code, this needs assembly
902             extcodecopy(addr, add(o_code, 0x20), 0, size)
903         }
904         return keccak256(o_code);
905     }
906 }
907 
908 //File: node_modules/liquidpledging/contracts/LiquidPledging.sol
909 pragma solidity ^0.4.11;
910 
911 /*
912     Copyright 2017, Jordi Baylina
913     Contributor: Adrià Massanet <adria@codecontext.io>
914 
915     This program is free software: you can redistribute it and/or modify
916     it under the terms of the GNU General Public License as published by
917     the Free Software Foundation, either version 3 of the License, or
918     (at your option) any later version.
919 
920     This program is distributed in the hope that it will be useful,
921     but WITHOUT ANY WARRANTY; without even the implied warranty of
922     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
923     GNU General Public License for more details.
924 
925     You should have received a copy of the GNU General Public License
926     along with this program.  If not, see <http://www.gnu.org/licenses/>.
927 */
928 
929 // Contract Imports
930 
931 
932 /// @dev `LiquidPleding` allows for liquid pledging through the use of
933 ///  internal id structures and delegate chaining. All basic operations for
934 ///  handling liquid pledging are supplied as well as plugin features
935 ///  to allow for expanded functionality.
936 contract LiquidPledging is LiquidPledgingBase {
937 
938 
939 //////
940 // Constructor
941 //////
942 
943     /// @notice Basic constructor for LiquidPleding, also calls the
944     ///  LiquidPledgingBase contract
945     /// @dev This constructor  also calls the constructor 
946     ///  for `LiquidPledgingBase`
947     /// @param _vault The vault where ETH backing this pledge is stored
948     function LiquidPledging(
949         address _vault,
950         address _escapeHatchCaller,
951         address _escapeHatchDestination
952     ) LiquidPledgingBase(_vault, _escapeHatchCaller, _escapeHatchDestination) {
953 
954     }
955 
956     /// @notice This is how value enters into the system which creates pledges;
957     ///  the token of value goes into the vault and the amount in the pledge
958     ///  relevant to this Giver without delegates is increased, and a normal
959     ///  transfer is done to the idReceiver
960     /// @param idGiver Identifier of the giver thats donating.
961     /// @param idReceiver To whom it's transfered. Can be the same giver,
962     ///  another giver, a delegate or a project.
963     function donate(uint64 idGiver, uint64 idReceiver) payable {
964         if (idGiver == 0) {
965             // default to 3 day commitTime
966             idGiver = addGiver("", "", 259200, ILiquidPledgingPlugin(0x0));
967         }
968 
969         PledgeAdmin storage sender = findAdmin(idGiver);
970 
971         checkAdminOwner(sender);
972 
973         require(sender.adminType == PledgeAdminType.Giver);
974 
975         uint amount = msg.value;
976 
977         require(amount > 0);
978 
979         vault.transfer(amount); // transfers the baseToken to the Vault
980         uint64 idPledge = findOrCreatePledge(
981             idGiver,
982             new uint64[](0), //what is new?
983             0,
984             0,
985             0,
986             PledgeState.Pledged
987         );
988 
989 
990         Pledge storage nTo = findPledge(idPledge);
991         nTo.amount += amount;
992 
993         Transfer(0, idPledge, amount);
994 
995         transfer(idGiver, idPledge, amount, idReceiver);
996     }
997 
998 
999     /// @notice Moves value between pledges
1000     /// @param idSender ID of the giver, delegate or project admin that is 
1001     ///  transferring the funds from Pledge to Pledge; this admin must have 
1002     ///  permissions to move the value
1003     /// @param idPledge Id of the pledge that's moving the value
1004     /// @param amount Quantity of value that's being moved
1005     /// @param idReceiver Destination of the value, can be a giver sending to 
1006     ///  a giver or a delegate, a delegate to another delegate or a project 
1007     ///  to pre-commit it to that project if called from a delegate,
1008     ///  or to commit it to the project if called from the owner. 
1009     function transfer(
1010         uint64 idSender,
1011         uint64 idPledge,
1012         uint amount,
1013         uint64 idReceiver
1014     )
1015     {
1016 
1017         idPledge = normalizePledge(idPledge);
1018 
1019         Pledge storage p = findPledge(idPledge);
1020         PledgeAdmin storage receiver = findAdmin(idReceiver);
1021         PledgeAdmin storage sender = findAdmin(idSender);
1022 
1023         checkAdminOwner(sender);
1024         require(p.pledgeState == PledgeState.Pledged);
1025 
1026         // If the sender is the owner
1027         if (p.owner == idSender) {
1028             if (receiver.adminType == PledgeAdminType.Giver) {
1029                 transferOwnershipToGiver(idPledge, amount, idReceiver);
1030             } else if (receiver.adminType == PledgeAdminType.Project) {
1031                 transferOwnershipToProject(idPledge, amount, idReceiver);
1032             } else if (receiver.adminType == PledgeAdminType.Delegate) {
1033                 idPledge = undelegate(
1034                     idPledge,
1035                     amount,
1036                     p.delegationChain.length
1037                 );
1038                 appendDelegate(idPledge, amount, idReceiver);
1039             } else {
1040                 assert(false);
1041             }
1042             return;
1043         }
1044 
1045         // If the sender is a delegate
1046         uint senderDIdx = getDelegateIdx(p, idSender);
1047         if (senderDIdx != NOTFOUND) {
1048 
1049             // If the receiver is another giver
1050             if (receiver.adminType == PledgeAdminType.Giver) {
1051                 // Only accept to change to the original giver to
1052                 // remove all delegates
1053                 assert(p.owner == idReceiver);
1054                 undelegate(idPledge, amount, p.delegationChain.length);
1055                 return;
1056             }
1057 
1058             // If the receiver is another delegate
1059             if (receiver.adminType == PledgeAdminType.Delegate) {
1060                 uint receiverDIdx = getDelegateIdx(p, idReceiver);
1061 
1062                 // If the receiver is not in the delegate list
1063                 if (receiverDIdx == NOTFOUND) {
1064                     idPledge = undelegate(
1065                         idPledge,
1066                         amount,
1067                         p.delegationChain.length - senderDIdx - 1
1068                     );
1069                     appendDelegate(idPledge, amount, idReceiver);
1070 
1071                 // If the receiver is already part of the delegate chain and is
1072                 // after the sender, then all of the other delegates after the
1073                 // sender are removed and the receiver is appended at the
1074                 // end of the delegation chain
1075                 } else if (receiverDIdx > senderDIdx) {
1076                     idPledge = undelegate(
1077                         idPledge,
1078                         amount,
1079                         p.delegationChain.length - senderDIdx - 1
1080                     );
1081                     appendDelegate(idPledge, amount, idReceiver);
1082 
1083                 // If the receiver is already part of the delegate chain and is
1084                 // before the sender, then the sender and all of the other
1085                 // delegates after the RECEIVER are removed from the chain,
1086                 // this is interesting because the delegate is removed from the
1087                 // delegates that delegated to this delegate. Are there game theory
1088                 // issues? should this be allowed?
1089                 } else if (receiverDIdx <= senderDIdx) {
1090                     undelegate(
1091                         idPledge,
1092                         amount,
1093                         p.delegationChain.length - receiverDIdx - 1
1094                     );
1095                 }
1096                 return;
1097             }
1098 
1099             // If the delegate wants to support a project, they remove all
1100             // the delegates after them in the chain and choose a project
1101             if (receiver.adminType == PledgeAdminType.Project) {
1102                 idPledge = undelegate(
1103                     idPledge,
1104                     amount,
1105                     p.delegationChain.length - senderDIdx - 1
1106                 );
1107                 proposeAssignProject(idPledge, amount, idReceiver);
1108                 return;
1109             }
1110         }
1111         assert(false);  // It is not the owner nor any delegate.
1112     }
1113 
1114     /// @notice This method is used to withdraw value from the system.
1115     ///  This can be used by the givers withdraw any un-commited donations.
1116     /// @param idPledge Id of the pledge that wants to be withdrawn.
1117     /// @param amount Quantity of Ether that wants to be withdrawn.
1118     function withdraw(uint64 idPledge, uint amount) {
1119 
1120         idPledge = normalizePledge(idPledge);
1121 
1122         Pledge storage p = findPledge(idPledge);
1123 
1124         require(p.pledgeState == PledgeState.Pledged);
1125 
1126         PledgeAdmin storage owner = findAdmin(p.owner);
1127 
1128         checkAdminOwner(owner);
1129 
1130         uint64 idNewPledge = findOrCreatePledge(
1131             p.owner,
1132             p.delegationChain,
1133             0,
1134             0,
1135             p.oldPledge,
1136             PledgeState.Paying
1137         );
1138 
1139         doTransfer(idPledge, idNewPledge, amount);
1140 
1141         vault.authorizePayment(bytes32(idNewPledge), owner.addr, amount);
1142     }
1143 
1144     /// @notice Method called by the vault to confirm a payment.
1145     /// @param idPledge Id of the pledge that wants to be withdrawn.
1146     /// @param amount Quantity of Ether that wants to be withdrawn.
1147     function confirmPayment(uint64 idPledge, uint amount) onlyVault {
1148         Pledge storage p = findPledge(idPledge);
1149 
1150         require(p.pledgeState == PledgeState.Paying);
1151 
1152         uint64 idNewPledge = findOrCreatePledge(
1153             p.owner,
1154             p.delegationChain,
1155             0,
1156             0,
1157             p.oldPledge,
1158             PledgeState.Paid
1159         );
1160 
1161         doTransfer(idPledge, idNewPledge, amount);
1162     }
1163 
1164     /// @notice Method called by the vault to cancel a payment.
1165     /// @param idPledge Id of the pledge that wants to be canceled for withdraw.
1166     /// @param amount Quantity of Ether that wants to be rolled back.
1167     function cancelPayment(uint64 idPledge, uint amount) onlyVault {
1168         Pledge storage p = findPledge(idPledge);
1169 
1170         require(p.pledgeState == PledgeState.Paying); //TODO change to revert
1171 
1172         // When a payment is canceled, never is assigned to a project.
1173         uint64 oldPledge = findOrCreatePledge(
1174             p.owner,
1175             p.delegationChain,
1176             0,
1177             0,
1178             p.oldPledge,
1179             PledgeState.Pledged
1180         );
1181 
1182         oldPledge = normalizePledge(oldPledge);
1183 
1184         doTransfer(idPledge, oldPledge, amount);
1185     }
1186 
1187     /// @notice Method called to cancel this project.
1188     /// @param idProject Id of the projct that wants to be canceled.
1189     function cancelProject(uint64 idProject) {
1190         PledgeAdmin storage project = findAdmin(idProject);
1191         checkAdminOwner(project);
1192         project.canceled = true;
1193 
1194         CancelProject(idProject);
1195     }
1196 
1197     /// @notice Method called to cancel specific pledge.
1198     /// @param idPledge Id of the pledge that should be canceled.
1199     /// @param amount Quantity of Ether that wants to be rolled back.
1200     function cancelPledge(uint64 idPledge, uint amount) {
1201         idPledge = normalizePledge(idPledge);
1202 
1203         Pledge storage p = findPledge(idPledge);
1204         require(p.oldPledge != 0);
1205 
1206         PledgeAdmin storage m = findAdmin(p.owner);
1207         checkAdminOwner(m);
1208 
1209         uint64 oldPledge = getOldestPledgeNotCanceled(p.oldPledge);
1210         doTransfer(idPledge, oldPledge, amount);
1211     }
1212 
1213 
1214 ////////
1215 // Multi pledge methods
1216 ////////
1217 
1218     // @dev This set of functions makes moving a lot of pledges around much more
1219     // efficient (saves gas) than calling these functions in series
1220     
1221     
1222     /// Bit mask used for dividing pledge amounts in Multi pledge methods
1223     uint constant D64 = 0x10000000000000000;
1224 
1225     /// @notice `mTransfer` allows for multiple pledges to be transferred
1226     ///  efficiently
1227     /// @param idSender ID of the giver, delegate or project admin that is
1228     ///  transferring the funds from Pledge to Pledge. This admin must have 
1229     ///  permissions to move the value
1230     /// @param pledgesAmounts An array of pledge amounts and IDs which are extrapolated
1231     ///  using the D64 bitmask
1232     /// @param idReceiver Destination of the value, can be a giver sending
1233     ///  to a giver or a delegate or a delegate to another delegate or a
1234     ///  project to pre-commit it to that project
1235     function mTransfer(
1236         uint64 idSender,
1237         uint[] pledgesAmounts,
1238         uint64 idReceiver
1239     ) {
1240         for (uint i = 0; i < pledgesAmounts.length; i++ ) {
1241             uint64 idPledge = uint64( pledgesAmounts[i] & (D64-1) );
1242             uint amount = pledgesAmounts[i] / D64;
1243 
1244             transfer(idSender, idPledge, amount, idReceiver);
1245         }
1246     }
1247 
1248     /// @notice `mWithdraw` allows for multiple pledges to be
1249     ///  withdrawn efficiently
1250     /// @param pledgesAmounts An array of pledge amounts and IDs which are
1251     ///  extrapolated using the D64 bitmask
1252     function mWithdraw(uint[] pledgesAmounts) {
1253         for (uint i = 0; i < pledgesAmounts.length; i++ ) {
1254             uint64 idPledge = uint64( pledgesAmounts[i] & (D64-1) );
1255             uint amount = pledgesAmounts[i] / D64;
1256 
1257             withdraw(idPledge, amount);
1258         }
1259     }
1260 
1261     /// @notice `mConfirmPayment` allows for multiple pledges to be confirmed
1262     ///  efficiently
1263     /// @param pledgesAmounts An array of pledge amounts and IDs which are extrapolated
1264     ///  using the D64 bitmask
1265     function mConfirmPayment(uint[] pledgesAmounts) {
1266         for (uint i = 0; i < pledgesAmounts.length; i++ ) {
1267             uint64 idPledge = uint64( pledgesAmounts[i] & (D64-1) );
1268             uint amount = pledgesAmounts[i] / D64;
1269 
1270             confirmPayment(idPledge, amount);
1271         }
1272     }
1273 
1274     /// @notice `mCancelPayment` allows for multiple pledges to be canceled
1275     ///  efficiently
1276     /// @param pledgesAmounts An array of pledge amounts and IDs which are extrapolated
1277     ///  using the D64 bitmask
1278     function mCancelPayment(uint[] pledgesAmounts) {
1279         for (uint i = 0; i < pledgesAmounts.length; i++ ) {
1280             uint64 idPledge = uint64( pledgesAmounts[i] & (D64-1) );
1281             uint amount = pledgesAmounts[i] / D64;
1282 
1283             cancelPayment(idPledge, amount);
1284         }
1285     }
1286 
1287     /// @notice `mNormalizePledge` allows for multiple pledges to be
1288     ///  normalized efficiently
1289     /// @param pledges An array of pledge IDs
1290     function mNormalizePledge(uint64[] pledges) {
1291         for (uint i = 0; i < pledges.length; i++ ) {
1292             normalizePledge( pledges[i] );
1293         }
1294     }
1295 
1296 ////////
1297 // Private methods
1298 ///////
1299 
1300     /// @notice `transferOwnershipToProject` allows for the transfer of
1301     ///  ownership to the project, but it can also be called by a project
1302     ///  to un-delegate everyone by setting one's own id for the idReceiver
1303     /// @param idPledge Id of the pledge to be transfered.
1304     /// @param amount Quantity of value that's being transfered
1305     /// @param idReceiver The new owner of the project (or self to un-delegate)
1306     function transferOwnershipToProject(
1307         uint64 idPledge,
1308         uint amount,
1309         uint64 idReceiver
1310     ) internal {
1311         Pledge storage p = findPledge(idPledge);
1312 
1313         // Ensure that the pledge is not already at max pledge depth
1314         // and the project has not been canceled
1315         require(getPledgeLevel(p) < MAX_INTERPROJECT_LEVEL);
1316         require(!isProjectCanceled(idReceiver));
1317 
1318         uint64 oldPledge = findOrCreatePledge(
1319             p.owner,
1320             p.delegationChain,
1321             0,
1322             0,
1323             p.oldPledge,
1324             PledgeState.Pledged
1325         );
1326         uint64 toPledge = findOrCreatePledge(
1327             idReceiver,                     // Set the new owner
1328             new uint64[](0),                // clear the delegation chain
1329             0,
1330             0,
1331             oldPledge,
1332             PledgeState.Pledged
1333         );
1334         doTransfer(idPledge, toPledge, amount);
1335     }   
1336 
1337 
1338     /// @notice `transferOwnershipToGiver` allows for the transfer of
1339     ///  value back to the Giver, value is placed in a pledged state
1340     ///  without being attached to a project, delegation chain, or time line.
1341     /// @param idPledge Id of the pledge to be transfered.
1342     /// @param amount Quantity of value that's being transfered
1343     /// @param idReceiver The new owner of the pledge
1344     function transferOwnershipToGiver(
1345         uint64 idPledge,
1346         uint amount,
1347         uint64 idReceiver
1348     ) internal {
1349         uint64 toPledge = findOrCreatePledge(
1350             idReceiver,
1351             new uint64[](0),
1352             0,
1353             0,
1354             0,
1355             PledgeState.Pledged
1356         );
1357         doTransfer(idPledge, toPledge, amount);
1358     }
1359 
1360     /// @notice `appendDelegate` allows for a delegate to be added onto the
1361     ///  end of the delegate chain for a given Pledge.
1362     /// @param idPledge Id of the pledge thats delegate chain will be modified.
1363     /// @param amount Quantity of value that's being chained.
1364     /// @param idReceiver The delegate to be added at the end of the chain
1365     function appendDelegate(
1366         uint64 idPledge,
1367         uint amount,
1368         uint64 idReceiver
1369     ) internal {
1370         Pledge storage p = findPledge(idPledge);
1371 
1372         require(p.delegationChain.length < MAX_DELEGATES);
1373         uint64[] memory newDelegationChain = new uint64[](
1374             p.delegationChain.length + 1
1375         );
1376         for (uint i = 0; i<p.delegationChain.length; i++) {
1377             newDelegationChain[i] = p.delegationChain[i];
1378         }
1379 
1380         // Make the last item in the array the idReceiver
1381         newDelegationChain[p.delegationChain.length] = idReceiver;
1382 
1383         uint64 toPledge = findOrCreatePledge(
1384             p.owner,
1385             newDelegationChain,
1386             0,
1387             0,
1388             p.oldPledge,
1389             PledgeState.Pledged
1390         );
1391         doTransfer(idPledge, toPledge, amount);
1392     }
1393 
1394     /// @notice `appendDelegate` allows for a delegate to be added onto the
1395     ///  end of the delegate chain for a given Pledge.
1396     /// @param idPledge Id of the pledge thats delegate chain will be modified.
1397     /// @param amount Quantity of value that's shifted from delegates.
1398     /// @param q Number (or depth) to remove as delegates
1399     function undelegate(
1400         uint64 idPledge,
1401         uint amount,
1402         uint q
1403     ) internal returns (uint64){
1404         Pledge storage p = findPledge(idPledge);
1405         uint64[] memory newDelegationChain = new uint64[](
1406             p.delegationChain.length - q
1407         );
1408         for (uint i=0; i<p.delegationChain.length - q; i++) {
1409             newDelegationChain[i] = p.delegationChain[i];
1410         }
1411         uint64 toPledge = findOrCreatePledge(
1412             p.owner,
1413             newDelegationChain,
1414             0,
1415             0,
1416             p.oldPledge,
1417             PledgeState.Pledged
1418         );
1419         doTransfer(idPledge, toPledge, amount);
1420 
1421         return toPledge;
1422     }
1423 
1424     /// @notice `proposeAssignProject` proposes the assignment of a pledge
1425     ///  to a specific project.
1426     /// @dev This function should potentially be named more specifically.
1427     /// @param idPledge Id of the pledge that will be assigned.
1428     /// @param amount Quantity of value this pledge leader would be assigned.
1429     /// @param idReceiver The project this pledge will potentially 
1430     ///  be assigned to.
1431     function proposeAssignProject(
1432         uint64 idPledge,
1433         uint amount,
1434         uint64 idReceiver
1435     ) internal {
1436         Pledge storage p = findPledge(idPledge);
1437 
1438         require(getPledgeLevel(p) < MAX_INTERPROJECT_LEVEL);
1439         require(!isProjectCanceled(idReceiver));
1440 
1441         uint64 toPledge = findOrCreatePledge(
1442             p.owner,
1443             p.delegationChain,
1444             idReceiver,
1445             uint64(getTime() + maxCommitTime(p)),
1446             p.oldPledge,
1447             PledgeState.Pledged
1448         );
1449         doTransfer(idPledge, toPledge, amount);
1450     }
1451 
1452     /// @notice `doTransfer` is designed to allow for pledge amounts to be 
1453     ///  shifted around internally.
1454     /// @param from This is the Id from which value will be transfered.
1455     /// @param to This is the Id that value will be transfered to.
1456     /// @param _amount The amount of value that will be transfered.
1457     function doTransfer(uint64 from, uint64 to, uint _amount) internal {
1458         uint amount = callPlugins(true, from, to, _amount);
1459         if (from == to) { 
1460             return;
1461         }
1462         if (amount == 0) {
1463             return;
1464         }
1465         Pledge storage nFrom = findPledge(from);
1466         Pledge storage nTo = findPledge(to);
1467         require(nFrom.amount >= amount);
1468         nFrom.amount -= amount;
1469         nTo.amount += amount;
1470 
1471         Transfer(from, to, amount);
1472         callPlugins(false, from, to, amount);
1473     }
1474 
1475     /// @notice `normalizePledge` only affects pledges with the Pledged PledgeState
1476     /// and does 2 things:
1477     ///   #1: Checks if the pledge should be committed. This means that
1478     ///       if the pledge has an intendedProject and it is past the
1479     ///       commitTime, it changes the owner to be the proposed project
1480     ///       (The UI will have to read the commit time and manually do what
1481     ///       this function does to the pledge for the end user
1482     ///       at the expiration of the commitTime)
1483     ///
1484     ///   #2: Checks to make sure that if there has been a cancellation in the
1485     ///       chain of projects, the pledge's owner has been changed
1486     ///       appropriately.
1487     ///
1488     /// This function can be called by anybody at anytime on any pledge.
1489     /// In general it can be called to force the calls of the affected 
1490     /// plugins, which also need to be predicted by the UI
1491     /// @param idPledge This is the id of the pledge that will be normalized
1492     function normalizePledge(uint64 idPledge) returns(uint64) {
1493 
1494         Pledge storage p = findPledge(idPledge);
1495 
1496         // Check to make sure this pledge hasn't already been used 
1497         // or is in the process of being used
1498         if (p.pledgeState != PledgeState.Pledged) {
1499             return idPledge;
1500         }
1501 
1502         // First send to a project if it's proposed and committed
1503         if ((p.intendedProject > 0) && ( getTime() > p.commitTime)) {
1504             uint64 oldPledge = findOrCreatePledge(
1505                 p.owner,
1506                 p.delegationChain,
1507                 0,
1508                 0,
1509                 p.oldPledge,
1510                 PledgeState.Pledged
1511             );
1512             uint64 toPledge = findOrCreatePledge(
1513                 p.intendedProject,
1514                 new uint64[](0),
1515                 0,
1516                 0,
1517                 oldPledge,
1518                 PledgeState.Pledged
1519             );
1520             doTransfer(idPledge, toPledge, p.amount);
1521             idPledge = toPledge;
1522             p = findPledge(idPledge);
1523         }
1524 
1525         toPledge = getOldestPledgeNotCanceled(idPledge);
1526         if (toPledge != idPledge) {
1527             doTransfer(idPledge, toPledge, p.amount);
1528         }
1529 
1530         return toPledge;
1531     }
1532 
1533 /////////////
1534 // Plugins
1535 /////////////
1536 
1537     /// @notice `callPlugin` is used to trigger the general functions in the
1538     ///  plugin for any actions needed before and after a transfer happens.
1539     ///  Specifically what this does in relation to the plugin is something
1540     ///  that largely depends on the functions of that plugin. This function
1541     ///  is generally called in pairs, once before, and once after a transfer.
1542     /// @param before This toggle determines whether the plugin call is occurring
1543     ///  before or after a transfer.
1544     /// @param adminId This should be the Id of the *trusted* individual
1545     ///  who has control over this plugin.
1546     /// @param fromPledge This is the Id from which value is being transfered.
1547     /// @param toPledge This is the Id that value is being transfered to.
1548     /// @param context The situation that is triggering the plugin. See plugin
1549     ///  for a full description of contexts.
1550     /// @param amount The amount of value that is being transfered.
1551     function callPlugin(
1552         bool before,
1553         uint64 adminId,
1554         uint64 fromPledge,
1555         uint64 toPledge,
1556         uint64 context,
1557         uint amount
1558     ) internal returns (uint allowedAmount) {
1559 
1560         uint newAmount;
1561         allowedAmount = amount;
1562         PledgeAdmin storage admin = findAdmin(adminId);
1563         // Checks admin has a plugin assigned and a non-zero amount is requested
1564         if ((address(admin.plugin) != 0) && (allowedAmount > 0)) {
1565             // There are two seperate functions called in the plugin.
1566             // One is called before the transfer and one after
1567             if (before) {
1568                 newAmount = admin.plugin.beforeTransfer(
1569                     adminId,
1570                     fromPledge,
1571                     toPledge,
1572                     context,
1573                     amount
1574                 );
1575                 require(newAmount <= allowedAmount);
1576                 allowedAmount = newAmount;
1577             } else {
1578                 admin.plugin.afterTransfer(
1579                     adminId,
1580                     fromPledge,
1581                     toPledge,
1582                     context,
1583                     amount
1584                 );
1585             }
1586         }
1587     }
1588 
1589     /// @notice `callPluginsPledge` is used to apply plugin calls to
1590     ///  the delegate chain and the intended project if there is one.
1591     ///  It does so in either a transferring or receiving context based
1592     ///  on the `idPledge` and  `fromPledge` parameters.
1593     /// @param before This toggle determines whether the plugin call is occuring
1594     ///  before or after a transfer.
1595     /// @param idPledge This is the Id of the pledge on which this plugin
1596     ///  is being called.
1597     /// @param fromPledge This is the Id from which value is being transfered.
1598     /// @param toPledge This is the Id that value is being transfered to.
1599     /// @param amount The amount of value that is being transfered.
1600     function callPluginsPledge(
1601         bool before,
1602         uint64 idPledge,
1603         uint64 fromPledge,
1604         uint64 toPledge,
1605         uint amount
1606     ) internal returns (uint allowedAmount) {
1607         // Determine if callPlugin is being applied in a receiving
1608         // or transferring context
1609         uint64 offset = idPledge == fromPledge ? 0 : 256;
1610         allowedAmount = amount;
1611         Pledge storage p = findPledge(idPledge);
1612 
1613         // Always call the plugin on the owner
1614         allowedAmount = callPlugin(
1615             before,
1616             p.owner,
1617             fromPledge,
1618             toPledge,
1619             offset,
1620             allowedAmount
1621         );
1622 
1623         // Apply call plugin to all delegates
1624         for (uint64 i=0; i<p.delegationChain.length; i++) {
1625             allowedAmount = callPlugin(
1626                 before,
1627                 p.delegationChain[i],
1628                 fromPledge,
1629                 toPledge,
1630                 offset + i+1,
1631                 allowedAmount
1632             );
1633         }
1634 
1635         // If there is an intended project also call the plugin in
1636         // either a transferring or receiving context based on offset
1637         // on the intended project
1638         if (p.intendedProject > 0) {
1639             allowedAmount = callPlugin(
1640                 before,
1641                 p.intendedProject,
1642                 fromPledge,
1643                 toPledge,
1644                 offset + 255,
1645                 allowedAmount
1646             );
1647         }
1648     }
1649 
1650 
1651     /// @notice `callPlugins` calls `callPluginsPledge` once for the transfer
1652     ///  context and once for the receiving context. The aggregated 
1653     ///  allowed amount is then returned.
1654     /// @param before This toggle determines whether the plugin call is occurring
1655     ///  before or after a transfer.
1656     /// @param fromPledge This is the Id from which value is being transferred.
1657     /// @param toPledge This is the Id that value is being transferred to.
1658     /// @param amount The amount of value that is being transferred.
1659     function callPlugins(
1660         bool before,
1661         uint64 fromPledge,
1662         uint64 toPledge,
1663         uint amount
1664     ) internal returns (uint allowedAmount) {
1665         allowedAmount = amount;
1666 
1667         // Call the pledges plugins in the transfer context
1668         allowedAmount = callPluginsPledge(
1669             before,
1670             fromPledge,
1671             fromPledge,
1672             toPledge,
1673             allowedAmount
1674         );
1675 
1676         // Call the pledges plugins in the receive context
1677         allowedAmount = callPluginsPledge(
1678             before,
1679             toPledge,
1680             fromPledge,
1681             toPledge,
1682             allowedAmount
1683         );
1684     }
1685 
1686 /////////////
1687 // Test functions
1688 /////////////
1689 
1690     /// @notice Basic helper function to return the current time
1691     function getTime() internal returns (uint) {
1692         return now;
1693     }
1694 
1695     // Event Delcerations
1696     event Transfer(uint64 indexed from, uint64 indexed to, uint amount);
1697     event CancelProject(uint64 indexed idProject);
1698 
1699 }
1700 
1701 //File: contracts/LPPCappedMilestones.sol
1702 pragma solidity ^0.4.17;
1703 
1704 /*
1705     Copyright 2017, RJ Ewing <perissology@protonmail.com>
1706 
1707     This program is free software: you can redistribute it and/or modify
1708     it under the terms of the GNU General Public License as published by
1709     the Free Software Foundation, either version 3 of the License, or
1710     (at your option) any later version.
1711 
1712     This program is distributed in the hope that it will be useful,
1713     but WITHOUT ANY WARRANTY; without even the implied warranty of
1714     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1715     GNU General Public License for more details.
1716 
1717     You should have received a copy of the GNU General Public License
1718     along with this program.  If not, see <http://www.gnu.org/licenses/>.
1719 */
1720 
1721 
1722 
1723 
1724 
1725 contract LPPCappedMilestones is Escapable {
1726     uint constant TO_OWNER = 256;
1727     uint constant TO_INTENDEDPROJECT = 511;
1728 
1729     LiquidPledging public liquidPledging;
1730 
1731     struct Milestone {
1732         uint maxAmount;
1733         uint received;
1734         uint canCollect;
1735         address reviewer;
1736         address campaignReviewer;
1737         address recipient;
1738         bool accepted;
1739     }
1740 
1741     mapping (uint64 => Milestone) milestones;
1742 
1743 
1744     event MilestoneAccepted(uint64 indexed idProject);
1745     event PaymentCollected(uint64 indexed idProject);
1746 
1747     //== constructor
1748 
1749     function LPPCappedMilestones(
1750         LiquidPledging _liquidPledging,
1751         address _escapeHatchCaller,
1752         address _escapeHatchDestination
1753     ) Escapable(_escapeHatchCaller, _escapeHatchDestination) public
1754     {
1755         liquidPledging = _liquidPledging;
1756     }
1757 
1758     //== fallback
1759 
1760     function() payable {}
1761 
1762     //== external
1763 
1764     /// @dev this is called by liquidPledging before every transfer to and from
1765     ///      a pledgeAdmin that has this contract as its plugin
1766     /// @dev see ILiquidPledgingPlugin interface for details about context param
1767     function beforeTransfer(
1768         uint64 pledgeManager,
1769         uint64 pledgeFrom,
1770         uint64 pledgeTo,
1771         uint64 context,
1772         uint amount
1773     ) external returns (uint maxAllowed)
1774     {
1775         require(msg.sender == address(liquidPledging));
1776         var (, , , fromIntendedProject, , ,) = liquidPledging.getPledge(pledgeFrom);
1777         var (, toOwner, , toIntendedProject, , , toPledgeState) = liquidPledging.getPledge(pledgeTo);
1778         Milestone storage m;
1779 
1780         // if m is the intendedProject, make sure m is still accepting funds (not accepted or canceled)
1781         if (context == TO_INTENDEDPROJECT) {
1782             m = milestones[toIntendedProject];
1783             // don't need to check if canceled b/c lp does this
1784             if (m.accepted) {
1785                 return 0;
1786             }
1787         // if the pledge is being transferred to m and is in the Pledged state, make
1788         // sure m is still accepting funds (not accepted or canceled)
1789         } else if (context == TO_OWNER &&
1790             (fromIntendedProject != toOwner &&
1791                 toPledgeState == LiquidPledgingBase.PledgeState.Pledged)) {
1792             //TODO what if milestone isn't initialized? should we throw?
1793             // this can happen if someone adds a project through lp with this contracts address as the plugin
1794             // we can require(maxAmount > 0);
1795             // don't need to check if canceled b/c lp does this
1796             m = milestones[toOwner];
1797             if (m.accepted) {
1798                 return 0;
1799             }
1800         }
1801         return amount;
1802     }
1803 
1804     /// @dev this is called by liquidPledging after every transfer to and from
1805     ///      a pledgeAdmin that has this contract as its plugin
1806     /// @dev see ILiquidPledgingPlugin interface for details about context param
1807     function afterTransfer(
1808         uint64 pledgeManager,
1809         uint64 pledgeFrom,
1810         uint64 pledgeTo,
1811         uint64 context,
1812         uint amount
1813     ) external
1814     {
1815         require(msg.sender == address(liquidPledging));
1816 
1817         var (, fromOwner, , , , ,) = liquidPledging.getPledge(pledgeFrom);
1818         var (, toOwner, , , , , toPledgeState) = liquidPledging.getPledge(pledgeTo);
1819 
1820         if (context == TO_OWNER) {
1821             Milestone storage m;
1822 
1823             // If fromOwner != toOwner, the means that a pledge is being committed to
1824             // milestone m. We will accept any amount up to m.maxAmount, and return
1825             // the rest
1826             if (fromOwner != toOwner) {
1827                 m = milestones[toOwner];
1828                 uint returnFunds = 0;
1829 
1830                 m.received += amount;
1831                 // milestone is no longer accepting new funds
1832                 if (m.accepted) {
1833                     returnFunds = amount;
1834                 } else if (m.received > m.maxAmount) {
1835                     returnFunds = m.received - m.maxAmount;
1836                 }
1837 
1838                 // send any exceeding funds back
1839                 if (returnFunds > 0) {
1840                     m.received -= returnFunds;
1841                     liquidPledging.cancelPledge(pledgeTo, returnFunds);
1842                 }
1843             // if the pledge has been paid, then the vault should have transferred the
1844             // the funds to this contract. update the milestone with the amount the recipient
1845             // can collect. this is the amount of the paid pledge
1846             } else if (toPledgeState == LiquidPledgingBase.PledgeState.Paid) {
1847                 m = milestones[toOwner];
1848                 m.canCollect += amount;
1849             }
1850         }
1851     }
1852 
1853     //== public
1854 
1855     function addMilestone(
1856         string name,
1857         string url,
1858         uint _maxAmount,
1859         uint64 parentProject,
1860         address _recipient,
1861         address _reviewer,
1862         address _campaignReviewer
1863     ) public
1864     {
1865         uint64 idProject = liquidPledging.addProject(
1866             name,
1867             url,
1868             address(this),
1869             parentProject,
1870             uint64(0),
1871             ILiquidPledgingPlugin(this)
1872         );
1873 
1874         milestones[idProject] = Milestone(
1875             _maxAmount,
1876             0,
1877             0,
1878             _reviewer,
1879             _campaignReviewer,
1880             _recipient,
1881             false
1882         );
1883     }
1884 
1885     function acceptMilestone(uint64 idProject) public {
1886         bool isCanceled = liquidPledging.isProjectCanceled(idProject);
1887         require(!isCanceled);
1888 
1889         Milestone storage m = milestones[idProject];
1890         require(msg.sender == m.reviewer || msg.sender == m.campaignReviewer);
1891         require(!m.accepted);
1892 
1893         m.accepted = true;
1894         MilestoneAccepted(idProject);
1895     }
1896 
1897     function cancelMilestone(uint64 idProject) public {
1898         Milestone storage m = milestones[idProject];
1899         require(msg.sender == m.reviewer || msg.sender == m.campaignReviewer);
1900         require(!m.accepted);
1901 
1902         liquidPledging.cancelProject(idProject);
1903     }
1904 
1905     function withdraw(uint64 idProject, uint64 idPledge, uint amount) public {
1906         // we don't check if canceled here.
1907         // lp.withdraw will normalize the pledge & check if canceled
1908         Milestone storage m = milestones[idProject];
1909         require(msg.sender == m.recipient);
1910         require(m.accepted);
1911 
1912         liquidPledging.withdraw(idPledge, amount);
1913         collect(idProject);
1914     }
1915 
1916     /// Bit mask used for dividing pledge amounts in mWithdraw
1917     uint constant D64 = 0x10000000000000000;
1918 
1919     function mWithdraw(uint[] pledgesAmounts) public {
1920         uint64[] memory mIds = new uint64[](pledgesAmounts.length);
1921 
1922         for (uint i = 0; i < pledgesAmounts.length; i++ ) {
1923             uint64 idPledge = uint64(pledgesAmounts[i] & (D64-1));
1924             var (, idProject, , , , ,) = liquidPledging.getPledge(idPledge);
1925 
1926             mIds[i] = idProject;
1927             Milestone storage m = milestones[idProject];
1928             require(msg.sender == m.recipient);
1929             require(m.accepted);
1930         }
1931 
1932         liquidPledging.mWithdraw(pledgesAmounts);
1933 
1934         for (i = 0; i < mIds.length; i++ ) {
1935             collect(mIds[i]);
1936         }
1937     }
1938 
1939     function collect(uint64 idProject) public {
1940         Milestone storage m = milestones[idProject];
1941         require(msg.sender == m.recipient);
1942 
1943         if (m.canCollect > 0) {
1944             uint amount = m.canCollect;
1945             // TODO should this assert be removed?
1946             assert(this.balance >= amount);
1947             m.canCollect = 0;
1948             m.recipient.transfer(amount);
1949             PaymentCollected(idProject);
1950         }
1951     }
1952 
1953     function getMilestone(uint64 idProject) public view returns (
1954         uint maxAmount,
1955         uint received,
1956         uint canCollect,
1957         address reviewer,
1958         address campaignReviewer,
1959         address recipient,
1960         bool accepted
1961     ) {
1962         Milestone storage m = milestones[idProject];
1963         maxAmount = m.maxAmount;
1964         received = m.received;
1965         canCollect = m.canCollect;
1966         reviewer = m.reviewer;
1967         campaignReviewer = m.campaignReviewer;
1968         recipient = m.recipient;
1969         accepted = m.accepted;
1970     }
1971 }