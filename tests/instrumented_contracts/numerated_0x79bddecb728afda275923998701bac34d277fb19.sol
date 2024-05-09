1 //File: node_modules/giveth-liquidpledging/contracts/ILiquidPledgingPlugin.sol
2 pragma solidity ^0.4.11;
3 
4 /*
5     Copyright 2017, Jordi Baylina
6     Contributors: Adrià Massanet <adria@codecontext.io>, RJ Ewing, Griff
7     Green, Arthur Lunn
8 
9     This program is free software: you can redistribute it and/or modify
10     it under the terms of the GNU General Public License as published by
11     the Free Software Foundation, either version 3 of the License, or
12     (at your option) any later version.
13 
14     This program is distributed in the hope that it will be useful,
15     but WITHOUT ANY WARRANTY; without even the implied warranty of
16     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
17     GNU General Public License for more details.
18 
19     You should have received a copy of the GNU General Public License
20     along with this program.  If not, see <http://www.gnu.org/licenses/>.
21 */
22 
23 
24 /// @dev `ILiquidPledgingPlugin` is the basic interface for any
25 ///  liquid pledging plugin
26 contract ILiquidPledgingPlugin {
27 
28     /// @notice Plugins are used (much like web hooks) to initiate an action
29     ///  upon any donation, delegation, or transfer; this is an optional feature
30     ///  and allows for extreme customization of the contract. This function
31     ///  implements any action that should be initiated before a transfer.
32     /// @param pledgeManager The admin or current manager of the pledge
33     /// @param pledgeFrom This is the Id from which value will be transfered.
34     /// @param pledgeTo This is the Id that value will be transfered to.    
35     /// @param context The situation that is triggering the plugin:
36     ///  0 -> Plugin for the owner transferring pledge to another party
37     ///  1 -> Plugin for the first delegate transferring pledge to another party
38     ///  2 -> Plugin for the second delegate transferring pledge to another party
39     ///  ...
40     ///  255 -> Plugin for the intendedProject transferring pledge to another party
41     ///
42     ///  256 -> Plugin for the owner receiving pledge to another party
43     ///  257 -> Plugin for the first delegate receiving pledge to another party
44     ///  258 -> Plugin for the second delegate receiving pledge to another party
45     ///  ...
46     ///  511 -> Plugin for the intendedProject receiving pledge to another party
47     /// @param amount The amount of value that will be transfered.
48     function beforeTransfer(
49         uint64 pledgeManager,
50         uint64 pledgeFrom,
51         uint64 pledgeTo,
52         uint64 context,
53         uint amount ) returns (uint maxAllowed);
54 
55     /// @notice Plugins are used (much like web hooks) to initiate an action
56     ///  upon any donation, delegation, or transfer; this is an optional feature
57     ///  and allows for extreme customization of the contract. This function
58     ///  implements any action that should be initiated after a transfer.
59     /// @param pledgeManager The admin or current manager of the pledge
60     /// @param pledgeFrom This is the Id from which value will be transfered.
61     /// @param pledgeTo This is the Id that value will be transfered to.    
62     /// @param context The situation that is triggering the plugin:
63     ///  0 -> Plugin for the owner transferring pledge to another party
64     ///  1 -> Plugin for the first delegate transferring pledge to another party
65     ///  2 -> Plugin for the second delegate transferring pledge to another party
66     ///  ...
67     ///  255 -> Plugin for the intendedProject transferring pledge to another party
68     ///
69     ///  256 -> Plugin for the owner receiving pledge to another party
70     ///  257 -> Plugin for the first delegate receiving pledge to another party
71     ///  258 -> Plugin for the second delegate receiving pledge to another party
72     ///  ...
73     ///  511 -> Plugin for the intendedProject receiving pledge to another party
74     ///  @param amount The amount of value that will be transfered.
75     function afterTransfer(
76         uint64 pledgeManager,
77         uint64 pledgeFrom,
78         uint64 pledgeTo,
79         uint64 context,
80         uint amount
81     );
82 }
83 
84 //File: node_modules/giveth-common-contracts/contracts/Owned.sol
85 pragma solidity ^0.4.15;
86 
87 
88 /// @title Owned
89 /// @author Adrià Massanet <adria@codecontext.io>
90 /// @notice The Owned contract has an owner address, and provides basic 
91 ///  authorization control functions, this simplifies & the implementation of
92 ///  user permissions; this contract has three work flows for a change in
93 ///  ownership, the first requires the new owner to validate that they have the
94 ///  ability to accept ownership, the second allows the ownership to be
95 ///  directly transfered without requiring acceptance, and the third allows for
96 ///  the ownership to be removed to allow for decentralization 
97 contract Owned {
98 
99     address public owner;
100     address public newOwnerCandidate;
101 
102     event OwnershipRequested(address indexed by, address indexed to);
103     event OwnershipTransferred(address indexed from, address indexed to);
104     event OwnershipRemoved();
105 
106     /// @dev The constructor sets the `msg.sender` as the`owner` of the contract
107     function Owned() public {
108         owner = msg.sender;
109     }
110 
111     /// @dev `owner` is the only address that can call a function with this
112     /// modifier
113     modifier onlyOwner() {
114         require (msg.sender == owner);
115         _;
116     }
117     
118     /// @dev In this 1st option for ownership transfer `proposeOwnership()` must
119     ///  be called first by the current `owner` then `acceptOwnership()` must be
120     ///  called by the `newOwnerCandidate`
121     /// @notice `onlyOwner` Proposes to transfer control of the contract to a
122     ///  new owner
123     /// @param _newOwnerCandidate The address being proposed as the new owner
124     function proposeOwnership(address _newOwnerCandidate) public onlyOwner {
125         newOwnerCandidate = _newOwnerCandidate;
126         OwnershipRequested(msg.sender, newOwnerCandidate);
127     }
128 
129     /// @notice Can only be called by the `newOwnerCandidate`, accepts the
130     ///  transfer of ownership
131     function acceptOwnership() public {
132         require(msg.sender == newOwnerCandidate);
133 
134         address oldOwner = owner;
135         owner = newOwnerCandidate;
136         newOwnerCandidate = 0x0;
137 
138         OwnershipTransferred(oldOwner, owner);
139     }
140 
141     /// @dev In this 2nd option for ownership transfer `changeOwnership()` can
142     ///  be called and it will immediately assign ownership to the `newOwner`
143     /// @notice `owner` can step down and assign some other address to this role
144     /// @param _newOwner The address of the new owner
145     function changeOwnership(address _newOwner) public onlyOwner {
146         require(_newOwner != 0x0);
147 
148         address oldOwner = owner;
149         owner = _newOwner;
150         newOwnerCandidate = 0x0;
151 
152         OwnershipTransferred(oldOwner, owner);
153     }
154 
155     /// @dev In this 3rd option for ownership transfer `removeOwnership()` can
156     ///  be called and it will immediately assign ownership to the 0x0 address;
157     ///  it requires a 0xdece be input as a parameter to prevent accidental use
158     /// @notice Decentralizes the contract, this operation cannot be undone 
159     /// @param _dac `0xdac` has to be entered for this function to work
160     function removeOwnership(address _dac) public onlyOwner {
161         require(_dac == 0xdac);
162         owner = 0x0;
163         newOwnerCandidate = 0x0;
164         OwnershipRemoved();     
165     }
166 } 
167 
168 //File: node_modules/giveth-common-contracts/contracts/ERC20.sol
169 pragma solidity ^0.4.15;
170 
171 
172 /**
173  * @title ERC20
174  * @dev A standard interface for tokens.
175  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
176  */
177 contract ERC20 {
178   
179     /// @dev Returns the total token supply
180     function totalSupply() public constant returns (uint256 supply);
181 
182     /// @dev Returns the account balance of the account with address _owner
183     function balanceOf(address _owner) public constant returns (uint256 balance);
184 
185     /// @dev Transfers _value number of tokens to address _to
186     function transfer(address _to, uint256 _value) public returns (bool success);
187 
188     /// @dev Transfers _value number of tokens from address _from to address _to
189     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
190 
191     /// @dev Allows _spender to withdraw from the msg.sender's account up to the _value amount
192     function approve(address _spender, uint256 _value) public returns (bool success);
193 
194     /// @dev Returns the amount which _spender is still allowed to withdraw from _owner
195     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
196 
197     event Transfer(address indexed _from, address indexed _to, uint256 _value);
198     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
199 
200 }
201 
202 //File: node_modules/giveth-common-contracts/contracts/Escapable.sol
203 pragma solidity ^0.4.15;
204 /*
205     Copyright 2016, Jordi Baylina
206     Contributor: Adrià Massanet <adria@codecontext.io>
207 
208     This program is free software: you can redistribute it and/or modify
209     it under the terms of the GNU General Public License as published by
210     the Free Software Foundation, either version 3 of the License, or
211     (at your option) any later version.
212 
213     This program is distributed in the hope that it will be useful,
214     but WITHOUT ANY WARRANTY; without even the implied warranty of
215     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
216     GNU General Public License for more details.
217 
218     You should have received a copy of the GNU General Public License
219     along with this program.  If not, see <http://www.gnu.org/licenses/>.
220 */
221 
222 
223 
224 
225 
226 /// @dev `Escapable` is a base level contract built off of the `Owned`
227 ///  contract; it creates an escape hatch function that can be called in an
228 ///  emergency that will allow designated addresses to send any ether or tokens
229 ///  held in the contract to an `escapeHatchDestination` as long as they were
230 ///  not blacklisted
231 contract Escapable is Owned {
232     address public escapeHatchCaller;
233     address public escapeHatchDestination;
234     mapping (address=>bool) private escapeBlacklist; // Token contract addresses
235 
236     /// @notice The Constructor assigns the `escapeHatchDestination` and the
237     ///  `escapeHatchCaller`
238     /// @param _escapeHatchCaller The address of a trusted account or contract
239     ///  to call `escapeHatch()` to send the ether in this contract to the
240     ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller`
241     ///  cannot move funds out of `escapeHatchDestination`
242     /// @param _escapeHatchDestination The address of a safe location (usu a
243     ///  Multisig) to send the ether held in this contract; if a neutral address
244     ///  is required, the WHG Multisig is an option:
245     ///  0x8Ff920020c8AD673661c8117f2855C384758C572 
246     function Escapable(address _escapeHatchCaller, address _escapeHatchDestination) public {
247         escapeHatchCaller = _escapeHatchCaller;
248         escapeHatchDestination = _escapeHatchDestination;
249     }
250 
251     /// @dev The addresses preassigned as `escapeHatchCaller` or `owner`
252     ///  are the only addresses that can call a function with this modifier
253     modifier onlyEscapeHatchCallerOrOwner {
254         require ((msg.sender == escapeHatchCaller)||(msg.sender == owner));
255         _;
256     }
257 
258     /// @notice Creates the blacklist of tokens that are not able to be taken
259     ///  out of the contract; can only be done at the deployment, and the logic
260     ///  to add to the blacklist will be in the constructor of a child contract
261     /// @param _token the token contract address that is to be blacklisted 
262     function blacklistEscapeToken(address _token) internal {
263         escapeBlacklist[_token] = true;
264         EscapeHatchBlackistedToken(_token);
265     }
266 
267     /// @notice Checks to see if `_token` is in the blacklist of tokens
268     /// @param _token the token address being queried
269     /// @return False if `_token` is in the blacklist and can't be taken out of
270     ///  the contract via the `escapeHatch()`
271     function isTokenEscapable(address _token) constant public returns (bool) {
272         return !escapeBlacklist[_token];
273     }
274 
275     /// @notice The `escapeHatch()` should only be called as a last resort if a
276     /// security issue is uncovered or something unexpected happened
277     /// @param _token to transfer, use 0x0 for ether
278     function escapeHatch(address _token) public onlyEscapeHatchCallerOrOwner {   
279         require(escapeBlacklist[_token]==false);
280 
281         uint256 balance;
282 
283         /// @dev Logic for ether
284         if (_token == 0x0) {
285             balance = this.balance;
286             escapeHatchDestination.transfer(balance);
287             EscapeHatchCalled(_token, balance);
288             return;
289         }
290         /// @dev Logic for tokens
291         ERC20 token = ERC20(_token);
292         balance = token.balanceOf(this);
293         require(token.transfer(escapeHatchDestination, balance));
294         EscapeHatchCalled(_token, balance);
295     }
296 
297     /// @notice Changes the address assigned to call `escapeHatch()`
298     /// @param _newEscapeHatchCaller The address of a trusted account or
299     ///  contract to call `escapeHatch()` to send the value in this contract to
300     ///  the `escapeHatchDestination`; it would be ideal that `escapeHatchCaller`
301     ///  cannot move funds out of `escapeHatchDestination`
302     function changeHatchEscapeCaller(address _newEscapeHatchCaller) public onlyEscapeHatchCallerOrOwner {
303         escapeHatchCaller = _newEscapeHatchCaller;
304     }
305 
306     event EscapeHatchBlackistedToken(address token);
307     event EscapeHatchCalled(address token, uint amount);
308 }
309 
310 //File: node_modules/giveth-liquidpledging/contracts/LiquidPledgingBase.sol
311 pragma solidity ^0.4.11;
312 /*
313     Copyright 2017, Jordi Baylina
314     Contributors: Adrià Massanet <adria@codecontext.io>, RJ Ewing, Griff
315     Green, Arthur Lunn
316 
317     This program is free software: you can redistribute it and/or modify
318     it under the terms of the GNU General Public License as published by
319     the Free Software Foundation, either version 3 of the License, or
320     (at your option) any later version.
321 
322     This program is distributed in the hope that it will be useful,
323     but WITHOUT ANY WARRANTY; without even the implied warranty of
324     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
325     GNU General Public License for more details.
326 
327     You should have received a copy of the GNU General Public License
328     along with this program.  If not, see <http://www.gnu.org/licenses/>.
329 */
330 
331 
332 
333 
334 /// @dev This is an interface for `LPVault` which serves as a secure storage for
335 ///  the ETH that backs the Pledges, only after `LiquidPledging` authorizes
336 ///  payments can Pledges be converted for ETH
337 interface LPVault {
338     function authorizePayment(bytes32 _ref, address _dest, uint _amount);
339     function () payable;
340 }
341 
342 /// @dev `LiquidPledgingBase` is the base level contract used to carry out
343 ///  liquidPledging's most basic functions, mostly handling and searching the
344 ///  data structures
345 contract LiquidPledgingBase is Escapable {
346 
347     // Limits inserted to prevent large loops that could prevent canceling
348     uint constant MAX_DELEGATES = 10;
349     uint constant MAX_SUBPROJECT_LEVEL = 20;
350     uint constant MAX_INTERPROJECT_LEVEL = 20;
351 
352     enum PledgeAdminType { Giver, Delegate, Project }
353     enum PledgeState { Pledged, Paying, Paid }
354 
355     /// @dev This struct defines the details of a `PledgeAdmin` which are 
356     ///  commonly referenced by their index in the `admins` array
357     ///  and can own pledges and act as delegates
358     struct PledgeAdmin { 
359         PledgeAdminType adminType; // Giver, Delegate or Project
360         address addr; // Account or contract address for admin
361         string name;
362         string url;  // Can be IPFS hash
363         uint64 commitTime;  // In seconds, used for Givers' & Delegates' vetos
364         uint64 parentProject;  // Only for projects
365         bool canceled;      //Always false except for canceled projects
366 
367         /// @dev if the plugin is 0x0 then nothing happens, if its an address
368         // than that smart contract is called when appropriate
369         ILiquidPledgingPlugin plugin; 
370     }
371 
372     struct Pledge {
373         uint amount;
374         uint64 owner; // PledgeAdmin
375         uint64[] delegationChain; // List of delegates in order of authority
376         uint64 intendedProject; // Used when delegates are sending to projects
377         uint64 commitTime;  // When the intendedProject will become the owner  
378         uint64 oldPledge; // Points to the id that this Pledge was derived from
379         PledgeState pledgeState; //  Pledged, Paying, Paid
380     }
381 
382     Pledge[] pledges;
383     PledgeAdmin[] admins; //The list of pledgeAdmins 0 means there is no admin
384     LPVault public vault;
385 
386     /// @dev this mapping allows you to search for a specific pledge's 
387     ///  index number by the hash of that pledge
388     mapping (bytes32 => uint64) hPledge2idx;
389     mapping (bytes32 => bool) pluginWhitelist;
390     
391     bool public usePluginWhitelist = true;
392 
393 /////////////
394 // Modifiers
395 /////////////
396 
397 
398     /// @dev The `vault`is the only addresses that can call a function with this
399     ///  modifier
400     modifier onlyVault() {
401         require(msg.sender == address(vault));
402         _;
403     }
404 
405 
406 ///////////////
407 // Constructor
408 ///////////////
409 
410     /// @notice The Constructor creates `LiquidPledgingBase` on the blockchain
411     /// @param _vault The vault where the ETH backing the pledges is stored
412     function LiquidPledgingBase(
413         address _vault,
414         address _escapeHatchCaller,
415         address _escapeHatchDestination
416     ) Escapable(_escapeHatchCaller, _escapeHatchDestination) public {
417         admins.length = 1; // we reserve the 0 admin
418         pledges.length = 1; // we reserve the 0 pledge
419         vault = LPVault(_vault); // Assigns the specified vault
420     }
421 
422 
423 /////////////////////////
424 // PledgeAdmin functions
425 /////////////////////////
426 
427     /// @notice Creates a Giver Admin with the `msg.sender` as the Admin address
428     /// @param name The name used to identify the Giver
429     /// @param url The link to the Giver's profile often an IPFS hash
430     /// @param commitTime The length of time in seconds the Giver has to
431     ///   veto when the Giver's delegates Pledge funds to a project
432     /// @param plugin This is Giver's liquid pledge plugin allowing for 
433     ///  extended functionality
434     /// @return idGiver The id number used to reference this Admin
435     function addGiver(
436         string name,
437         string url,
438         uint64 commitTime,
439         ILiquidPledgingPlugin plugin
440     ) returns (uint64 idGiver) {
441 
442         require(isValidPlugin(plugin)); // Plugin check
443 
444         idGiver = uint64(admins.length);
445 
446         admins.push(PledgeAdmin(
447             PledgeAdminType.Giver,
448             msg.sender,
449             name,
450             url,
451             commitTime,
452             0,
453             false,
454             plugin));
455 
456         GiverAdded(idGiver);
457     }
458 
459     event GiverAdded(uint64 indexed idGiver);
460 
461     /// @notice Updates a Giver's info to change the address, name, url, or 
462     ///  commitTime, it cannot be used to change a plugin, and it must be called
463     ///  by the current address of the Giver
464     /// @param idGiver This is the Admin id number used to specify the Giver
465     /// @param newAddr The new address that represents this Giver
466     /// @param newName The new name used to identify the Giver
467     /// @param newUrl The new link to the Giver's profile often an IPFS hash
468     /// @param newCommitTime Sets the length of time in seconds the Giver has to
469     ///   veto when the Giver's delegates Pledge funds to a project
470     function updateGiver(
471         uint64 idGiver,
472         address newAddr,
473         string newName,
474         string newUrl,
475         uint64 newCommitTime)
476     {
477         PledgeAdmin storage giver = findAdmin(idGiver);
478         require(giver.adminType == PledgeAdminType.Giver); // Must be a Giver
479         require(giver.addr == msg.sender); // Current addr had to send this tx
480         giver.addr = newAddr;
481         giver.name = newName;
482         giver.url = newUrl;
483         giver.commitTime = newCommitTime;
484         GiverUpdated(idGiver);
485     }
486 
487     event GiverUpdated(uint64 indexed idGiver);
488 
489     /// @notice Creates a Delegate Admin with the `msg.sender` as the Admin addr
490     /// @param name The name used to identify the Delegate
491     /// @param url The link to the Delegate's profile often an IPFS hash
492     /// @param commitTime Sets the length of time in seconds that this delegate
493     ///  can be vetoed. Whenever this delegate is in a delegate chain the time
494     ///  allowed to veto any event must be greater than or equal to this time.
495     /// @param plugin This is Delegate's liquid pledge plugin allowing for 
496     ///  extended functionality
497     /// @return idxDelegate The id number used to reference this Delegate within
498     ///  the admins array
499     function addDelegate(
500         string name,
501         string url,
502         uint64 commitTime,
503         ILiquidPledgingPlugin plugin
504     ) returns (uint64 idDelegate) { 
505 
506         require(isValidPlugin(plugin)); // Plugin check
507 
508         idDelegate = uint64(admins.length);
509 
510         admins.push(PledgeAdmin(
511             PledgeAdminType.Delegate,
512             msg.sender,
513             name,
514             url,
515             commitTime,
516             0,
517             false,
518             plugin));
519 
520         DelegateAdded(idDelegate);
521     }
522 
523     event DelegateAdded(uint64 indexed idDelegate);
524 
525     /// @notice Updates a Delegate's info to change the address, name, url, or 
526     ///  commitTime, it cannot be used to change a plugin, and it must be called
527     ///  by the current address of the Delegate
528     /// @param idDelegate The Admin id number used to specify the Delegate
529     /// @param newAddr The new address that represents this Delegate
530     /// @param newName The new name used to identify the Delegate
531     /// @param newUrl The new link to the Delegate's profile often an IPFS hash
532     /// @param newCommitTime Sets the length of time in seconds that this 
533     ///  delegate can be vetoed. Whenever this delegate is in a delegate chain 
534     ///  the time allowed to veto any event must be greater than or equal to
535     ///  this time.
536     function updateDelegate(
537         uint64 idDelegate,
538         address newAddr,
539         string newName,
540         string newUrl,
541         uint64 newCommitTime) {
542         PledgeAdmin storage delegate = findAdmin(idDelegate);
543         require(delegate.adminType == PledgeAdminType.Delegate);
544         require(delegate.addr == msg.sender);// Current addr had to send this tx
545         delegate.addr = newAddr;
546         delegate.name = newName;
547         delegate.url = newUrl;
548         delegate.commitTime = newCommitTime;
549         DelegateUpdated(idDelegate);
550     }
551 
552     event DelegateUpdated(uint64 indexed idDelegate);
553 
554     /// @notice Creates a Project Admin with the `msg.sender` as the Admin addr
555     /// @param name The name used to identify the Project
556     /// @param url The link to the Project's profile often an IPFS hash
557     /// @param projectAdmin The address for the trusted project manager 
558     /// @param parentProject The Admin id number for the parent project or 0 if
559     ///  there is no parentProject
560     /// @param commitTime Sets the length of time in seconds the Project has to
561     ///   veto when the Project delegates to another Delegate and they pledge 
562     ///   those funds to a project
563     /// @param plugin This is Project's liquid pledge plugin allowing for 
564     ///  extended functionality
565     /// @return idProject The id number used to reference this Admin
566     function addProject(
567         string name,
568         string url,
569         address projectAdmin,
570         uint64 parentProject,
571         uint64 commitTime,
572         ILiquidPledgingPlugin plugin
573     ) returns (uint64 idProject) {
574         require(isValidPlugin(plugin));
575 
576         if (parentProject != 0) {
577             PledgeAdmin storage pa = findAdmin(parentProject);
578             require(pa.adminType == PledgeAdminType.Project);
579             require(getProjectLevel(pa) < MAX_SUBPROJECT_LEVEL);
580         }
581 
582         idProject = uint64(admins.length);
583 
584         admins.push(PledgeAdmin(
585             PledgeAdminType.Project,
586             projectAdmin,
587             name,
588             url,
589             commitTime,
590             parentProject,
591             false,
592             plugin));
593 
594 
595         ProjectAdded(idProject);
596     }
597 
598     event ProjectAdded(uint64 indexed idProject);
599 
600 
601     /// @notice Updates a Project's info to change the address, name, url, or 
602     ///  commitTime, it cannot be used to change a plugin or a parentProject,
603     ///  and it must be called by the current address of the Project
604     /// @param idProject The Admin id number used to specify the Project
605     /// @param newAddr The new address that represents this Project
606     /// @param newName The new name used to identify the Project
607     /// @param newUrl The new link to the Project's profile often an IPFS hash
608     /// @param newCommitTime Sets the length of time in seconds the Project has
609     ///  to veto when the Project delegates to a Delegate and they pledge those
610     ///  funds to a project
611     function updateProject(
612         uint64 idProject,
613         address newAddr,
614         string newName,
615         string newUrl,
616         uint64 newCommitTime)
617     {
618         PledgeAdmin storage project = findAdmin(idProject);
619         require(project.adminType == PledgeAdminType.Project);
620         require(project.addr == msg.sender);
621         project.addr = newAddr;
622         project.name = newName;
623         project.url = newUrl;
624         project.commitTime = newCommitTime;
625         ProjectUpdated(idProject);
626     }
627 
628     event ProjectUpdated(uint64 indexed idAdmin);
629 
630 
631 //////////
632 // Public constant functions
633 //////////
634 
635     /// @notice A constant getter that returns the total number of pledges
636     /// @return The total number of Pledges in the system
637     function numberOfPledges() constant returns (uint) {
638         return pledges.length - 1;
639     }
640 
641     /// @notice A getter that returns the details of the specified pledge
642     /// @param idPledge the id number of the pledge being queried
643     /// @return the amount, owner, the number of delegates (but not the actual
644     ///  delegates, the intendedProject (if any), the current commit time and
645     ///  the previous pledge this pledge was derived from
646     function getPledge(uint64 idPledge) constant returns(
647         uint amount,
648         uint64 owner,
649         uint64 nDelegates,
650         uint64 intendedProject,
651         uint64 commitTime,
652         uint64 oldPledge,
653         PledgeState pledgeState
654     ) {
655         Pledge storage p = findPledge(idPledge);
656         amount = p.amount;
657         owner = p.owner;
658         nDelegates = uint64(p.delegationChain.length);
659         intendedProject = p.intendedProject;
660         commitTime = p.commitTime;
661         oldPledge = p.oldPledge;
662         pledgeState = p.pledgeState;
663     }
664 
665     /// @notice Getter to find Delegate w/ the Pledge ID & the Delegate index
666     /// @param idPledge The id number representing the pledge being queried
667     /// @param idxDelegate The index number for the delegate in this Pledge 
668     function getPledgeDelegate(uint64 idPledge, uint idxDelegate) constant returns(
669         uint64 idDelegate,
670         address addr,
671         string name
672     ) {
673         Pledge storage p = findPledge(idPledge);
674         idDelegate = p.delegationChain[idxDelegate - 1];
675         PledgeAdmin storage delegate = findAdmin(idDelegate);
676         addr = delegate.addr;
677         name = delegate.name;
678     }
679 
680     /// @notice A constant getter used to check how many total Admins exist
681     /// @return The total number of admins (Givers, Delegates and Projects) .
682     function numberOfPledgeAdmins() constant returns(uint) {
683         return admins.length - 1;
684     }
685 
686     /// @notice A constant getter to check the details of a specified Admin  
687     /// @return addr Account or contract address for admin
688     /// @return name Name of the pledgeAdmin
689     /// @return url The link to the Project's profile often an IPFS hash
690     /// @return commitTime The length of time in seconds the Admin has to veto
691     ///   when the Admin delegates to a Delegate and that Delegate pledges those
692     ///   funds to a project
693     /// @return parentProject The Admin id number for the parent project or 0
694     ///  if there is no parentProject
695     /// @return canceled 0 for Delegates & Givers, true if a Project has been 
696     ///  canceled
697     /// @return plugin This is Project's liquidPledging plugin allowing for 
698     ///  extended functionality
699     function getPledgeAdmin(uint64 idAdmin) constant returns (
700         PledgeAdminType adminType,
701         address addr,
702         string name,
703         string url,
704         uint64 commitTime,
705         uint64 parentProject,
706         bool canceled,
707         address plugin)
708     {
709         PledgeAdmin storage m = findAdmin(idAdmin);
710         adminType = m.adminType;
711         addr = m.addr;
712         name = m.name;
713         url = m.url;
714         commitTime = m.commitTime;
715         parentProject = m.parentProject;
716         canceled = m.canceled;
717         plugin = address(m.plugin);
718     }
719 
720 ////////
721 // Private methods
722 ///////
723 
724     /// @notice This creates a Pledge with an initial amount of 0 if one is not
725     ///  created already; otherwise it finds the pledge with the specified
726     ///  attributes; all pledges technically exist, if the pledge hasn't been
727     ///  created in this system yet it simply isn't in the hash array
728     ///  hPledge2idx[] yet
729     /// @param owner The owner of the pledge being looked up
730     /// @param delegationChain The list of delegates in order of authority
731     /// @param intendedProject The project this pledge will Fund after the
732     ///  commitTime has passed
733     /// @param commitTime The length of time in seconds the Giver has to
734     ///   veto when the Giver's delegates Pledge funds to a project
735     /// @param oldPledge This value is used to store the pledge the current
736     ///  pledge was came from, and in the case a Project is canceled, the Pledge
737     ///  will revert back to it's previous state
738     /// @param state The pledge state: Pledged, Paying, or state
739     /// @return The hPledge2idx index number
740     function findOrCreatePledge(
741         uint64 owner,
742         uint64[] delegationChain,
743         uint64 intendedProject,
744         uint64 commitTime,
745         uint64 oldPledge,
746         PledgeState state
747         ) internal returns (uint64)
748     {
749         bytes32 hPledge = sha3(
750             owner, delegationChain, intendedProject, commitTime, oldPledge, state);
751         uint64 idx = hPledge2idx[hPledge];
752         if (idx > 0) return idx;
753         idx = uint64(pledges.length);
754         hPledge2idx[hPledge] = idx;
755         pledges.push(Pledge(
756             0, owner, delegationChain, intendedProject, commitTime, oldPledge, state));
757         return idx;
758     }
759 
760     /// @notice A getter to look up a Admin's details
761     /// @param idAdmin The id for the Admin to lookup
762     /// @return The PledgeAdmin struct for the specified Admin
763     function findAdmin(uint64 idAdmin) internal returns (PledgeAdmin storage) {
764         require(idAdmin < admins.length);
765         return admins[idAdmin];
766     }
767 
768     /// @notice A getter to look up a Pledge's details
769     /// @param idPledge The id for the Pledge to lookup
770     /// @return The PledgeA struct for the specified Pledge
771     function findPledge(uint64 idPledge) internal returns (Pledge storage) {
772         require(idPledge < pledges.length);
773         return pledges[idPledge];
774     }
775 
776     // a constant for when a delegate is requested that is not in the system
777     uint64 constant  NOTFOUND = 0xFFFFFFFFFFFFFFFF;
778 
779     /// @notice A getter that searches the delegationChain for the level of
780     ///  authority a specific delegate has within a Pledge
781     /// @param p The Pledge that will be searched
782     /// @param idDelegate The specified delegate that's searched for
783     /// @return If the delegate chain contains the delegate with the
784     ///  `admins` array index `idDelegate` this returns that delegates
785     ///  corresponding index in the delegationChain. Otherwise it returns
786     ///  the NOTFOUND constant
787     function getDelegateIdx(Pledge p, uint64 idDelegate) internal returns(uint64) {
788         for (uint i=0; i < p.delegationChain.length; i++) {
789             if (p.delegationChain[i] == idDelegate) return uint64(i);
790         }
791         return NOTFOUND;
792     }
793 
794     /// @notice A getter to find how many old "parent" pledges a specific Pledge
795     ///  had using a self-referential loop
796     /// @param p The Pledge being queried
797     /// @return The number of old "parent" pledges a specific Pledge had
798     function getPledgeLevel(Pledge p) internal returns(uint) {
799         if (p.oldPledge == 0) return 0;
800         Pledge storage oldN = findPledge(p.oldPledge);
801         return getPledgeLevel(oldN) + 1; // a loop lookup
802     }
803 
804     /// @notice A getter to find the longest commitTime out of the owner and all
805     ///  the delegates for a specified pledge
806     /// @param p The Pledge being queried
807     /// @return The maximum commitTime out of the owner and all the delegates
808     function maxCommitTime(Pledge p) internal returns(uint commitTime) {
809         PledgeAdmin storage m = findAdmin(p.owner);
810         commitTime = m.commitTime; // start with the owner's commitTime
811 
812         for (uint i=0; i<p.delegationChain.length; i++) {
813             m = findAdmin(p.delegationChain[i]);
814 
815             // If a delegate's commitTime is longer, make it the new commitTime
816             if (m.commitTime > commitTime) commitTime = m.commitTime;
817         }
818     }
819 
820     /// @notice A getter to find the level of authority a specific Project has
821     ///  using a self-referential loop
822     /// @param m The Project being queried
823     /// @return The level of authority a specific Project has
824     function getProjectLevel(PledgeAdmin m) internal returns(uint) {
825         assert(m.adminType == PledgeAdminType.Project);
826         if (m.parentProject == 0) return(1);
827         PledgeAdmin storage parentNM = findAdmin(m.parentProject);
828         return getProjectLevel(parentNM) + 1;
829     }
830 
831     /// @notice A getter to find if a specified Project has been canceled
832     /// @param projectId The Admin id number used to specify the Project
833     /// @return True if the Project has been canceled
834     function isProjectCanceled(uint64 projectId) constant returns (bool) {
835         PledgeAdmin storage m = findAdmin(projectId);
836         if (m.adminType == PledgeAdminType.Giver) return false;
837         assert(m.adminType == PledgeAdminType.Project);
838         if (m.canceled) return true;
839         if (m.parentProject == 0) return false;
840         return isProjectCanceled(m.parentProject);
841     }
842 
843     /// @notice A getter to find the oldest pledge that hasn't been canceled
844     /// @param idPledge The starting place to lookup the pledges 
845     /// @return The oldest idPledge that hasn't been canceled (DUH!)
846     function getOldestPledgeNotCanceled(uint64 idPledge
847         ) internal constant returns(uint64) {
848         if (idPledge == 0) return 0;
849         Pledge storage p = findPledge(idPledge);
850         PledgeAdmin storage admin = findAdmin(p.owner);
851         if (admin.adminType == PledgeAdminType.Giver) return idPledge;
852 
853         assert(admin.adminType == PledgeAdminType.Project);
854 
855         if (!isProjectCanceled(p.owner)) return idPledge;
856 
857         return getOldestPledgeNotCanceled(p.oldPledge);
858     }
859 
860     /// @notice A check to see if the msg.sender is the owner or the
861     ///  plugin contract for a specific Admin
862     /// @param m The Admin being checked
863     function checkAdminOwner(PledgeAdmin m) internal constant {
864         require((msg.sender == m.addr) || (msg.sender == address(m.plugin)));
865     }
866 ///////////////////////////
867 // Plugin Whitelist Methods
868 ///////////////////////////
869 
870     function addValidPlugin(bytes32 contractHash) external onlyOwner {
871         pluginWhitelist[contractHash] = true;
872     }
873 
874     function removeValidPlugin(bytes32 contractHash) external onlyOwner {
875         pluginWhitelist[contractHash] = false;
876     }
877 
878     function useWhitelist(bool useWhitelist) external onlyOwner {
879         usePluginWhitelist = useWhitelist;
880     }
881 
882     function isValidPlugin(address addr) public returns(bool) {
883         if (!usePluginWhitelist || addr == 0x0) return true;
884 
885         bytes32 contractHash = getCodeHash(addr);
886 
887         return pluginWhitelist[contractHash];
888     }
889 
890     function getCodeHash(address addr) public returns(bytes32) {
891         bytes memory o_code;
892         assembly {
893             // retrieve the size of the code, this needs assembly
894             let size := extcodesize(addr)
895             // allocate output byte array - this could also be done without assembly
896             // by using o_code = new bytes(size)
897             o_code := mload(0x40)
898             // new "memory end" including padding
899             mstore(0x40, add(o_code, and(add(add(size, 0x20), 0x1f), not(0x1f))))
900             // store length in memory
901             mstore(o_code, size)
902             // actually retrieve the code, this needs assembly
903             extcodecopy(addr, add(o_code, 0x20), 0, size)
904         }
905         return keccak256(o_code);
906     }
907 }
908 
909 //File: node_modules/giveth-liquidpledging/contracts/LiquidPledging.sol
910 pragma solidity ^0.4.11;
911 
912 /*
913     Copyright 2017, Jordi Baylina
914     Contributors: Adrià Massanet <adria@codecontext.io>, RJ Ewing, Griff
915     Green, Arthur Lunn
916 
917     This program is free software: you can redistribute it and/or modify
918     it under the terms of the GNU General Public License as published by
919     the Free Software Foundation, either version 3 of the License, or
920     (at your option) any later version.
921 
922     This program is distributed in the hope that it will be useful,
923     but WITHOUT ANY WARRANTY; without even the implied warranty of
924     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
925     GNU General Public License for more details.
926 
927     You should have received a copy of the GNU General Public License
928     along with this program.  If not, see <http://www.gnu.org/licenses/>.
929 */
930 
931 
932 
933 /// @dev `LiquidPleding` allows for liquid pledging through the use of
934 ///  internal id structures and delegate chaining. All basic operations for
935 ///  handling liquid pledging are supplied as well as plugin features
936 ///  to allow for expanded functionality.
937 contract LiquidPledging is LiquidPledgingBase {
938 
939 
940 //////
941 // Constructor
942 //////
943 
944     /// @notice Basic constructor for LiquidPleding, also calls the
945     ///  LiquidPledgingBase contract
946     /// @dev This constructor  also calls the constructor 
947     ///  for `LiquidPledgingBase`
948     /// @param _vault The vault where ETH backing this pledge is stored
949     function LiquidPledging(
950         address _vault,
951         address _escapeHatchCaller,
952         address _escapeHatchDestination
953     ) LiquidPledgingBase(_vault, _escapeHatchCaller, _escapeHatchDestination) {
954 
955     }
956 
957     /// @notice This is how value enters the system and how pledges are created;
958     ///  the ether is sent to the vault, an pledge for the Giver is created (or
959     ///  found), the amount of ETH donated in wei is added to the `amount` in
960     ///  the Giver's Pledge, and an LP transfer is done to the idReceiver for
961     ///  the full amount
962     /// @param idGiver The id of the Giver donating; if 0, a new id is created
963     /// @param idReceiver The Admin receiving the donation; can be any Admin:
964     ///  the Giver themselves, another Giver, a Delegate or a Project
965     function donate(uint64 idGiver, uint64 idReceiver) payable {
966         if (idGiver == 0) {
967 
968             // default to a 3 day (259200 seconds) commitTime
969             idGiver = addGiver("", "", 259200, ILiquidPledgingPlugin(0x0));
970         }
971 
972         PledgeAdmin storage sender = findAdmin(idGiver);
973         checkAdminOwner(sender);
974         require(sender.adminType == PledgeAdminType.Giver);
975         uint amount = msg.value;
976         require(amount > 0);
977         vault.transfer(amount); // Sends the `msg.value` (in wei) to the `vault`
978         uint64 idPledge = findOrCreatePledge(
979             idGiver,
980             new uint64[](0), // Creates empty array for delegationChain
981             0,
982             0,
983             0,
984             PledgeState.Pledged
985         );
986 
987 
988         Pledge storage nTo = findPledge(idPledge);
989         nTo.amount += amount;
990 
991         Transfer(0, idPledge, amount); // An event
992 
993         transfer(idGiver, idPledge, amount, idReceiver); // LP accounting
994     }
995 
996     /// @notice Transfers amounts between pledges for internal accounting 
997     /// @param idSender Id of the Admin that is transferring the amount from
998     ///  Pledge to Pledge; this admin must have permissions to move the value
999     /// @param idPledge Id of the pledge that's moving the value
1000     /// @param amount Quantity of ETH (in wei) that this pledge is transferring 
1001     ///  the authority to withdraw from the vault
1002     /// @param idReceiver Destination of the `amount`, can be a Giver/Project sending
1003     ///  to a Giver, a Delegate or a Project; a Delegate sending to another
1004     ///  Delegate, or a Delegate pre-commiting it to a Project 
1005     function transfer( 
1006         uint64 idSender,
1007         uint64 idPledge,
1008         uint amount,
1009         uint64 idReceiver
1010     ){
1011 
1012         idPledge = normalizePledge(idPledge);
1013 
1014         Pledge storage p = findPledge(idPledge);
1015         PledgeAdmin storage receiver = findAdmin(idReceiver);
1016         PledgeAdmin storage sender = findAdmin(idSender);
1017 
1018         checkAdminOwner(sender);
1019         require(p.pledgeState == PledgeState.Pledged);
1020 
1021         // If the sender is the owner of the Pledge
1022         if (p.owner == idSender) {
1023 
1024             if (receiver.adminType == PledgeAdminType.Giver) {
1025                 transferOwnershipToGiver(idPledge, amount, idReceiver);
1026             } else if (receiver.adminType == PledgeAdminType.Project) {
1027                 transferOwnershipToProject(idPledge, amount, idReceiver);
1028             } else if (receiver.adminType == PledgeAdminType.Delegate) {
1029 
1030                 uint recieverDIdx = getDelegateIdx(p, idReceiver);
1031                 if (p.intendedProject > 0 && recieverDIdx != NOTFOUND) {
1032                     // if there is an intendedProject and the receiver is in the delegationChain,
1033                     // then we want to preserve the delegationChain as this is a veto of the
1034                     // intendedProject by the owner
1035 
1036                     if (recieverDIdx == p.delegationChain.length - 1) {
1037                         uint64 toPledge = findOrCreatePledge(
1038                             p.owner,
1039                             p.delegationChain,
1040                             0,
1041                             0,
1042                             p.oldPledge,
1043                             PledgeState.Pledged);
1044                         doTransfer(idPledge, toPledge, amount);
1045                     } else {
1046                         undelegate(idPledge, amount, p.delegationChain.length - receiverDIdx - 1);
1047                     }
1048                 } else {
1049                     // owner is not vetoing an intendedProject and is transferring the pledge to a delegate,
1050                     // so we want to reset the delegationChain
1051                     idPledge = undelegate(
1052                         idPledge,
1053                         amount,
1054                         p.delegationChain.length
1055                     );
1056                     appendDelegate(idPledge, amount, idReceiver);
1057                 }
1058                 
1059             } else {
1060                 // This should never be reached as the reciever.adminType
1061                 // should always be either a Giver, Project, or Delegate
1062                 assert(false);
1063             }
1064             return;
1065         }
1066 
1067         // If the sender is a Delegate
1068         uint senderDIdx = getDelegateIdx(p, idSender);
1069         if (senderDIdx != NOTFOUND) {
1070 
1071             // And the receiver is another Giver
1072             if (receiver.adminType == PledgeAdminType.Giver) {
1073                 // Only transfer to the Giver who owns the pldege
1074                 assert(p.owner == idReceiver);
1075                 undelegate(idPledge, amount, p.delegationChain.length);
1076                 return;
1077             }
1078 
1079             // And the receiver is another Delegate
1080             if (receiver.adminType == PledgeAdminType.Delegate) {
1081                 uint receiverDIdx = getDelegateIdx(p, idReceiver);
1082 
1083                 // And not in the delegationChain
1084                 if (receiverDIdx == NOTFOUND) {
1085                     idPledge = undelegate(
1086                         idPledge,
1087                         amount,
1088                         p.delegationChain.length - senderDIdx - 1
1089                     );
1090                     appendDelegate(idPledge, amount, idReceiver);
1091 
1092                 // And part of the delegationChain and is after the sender, then
1093                 //  all of the other delegates after the sender are removed and
1094                 //  the receiver is appended at the end of the delegationChain
1095                 } else if (receiverDIdx > senderDIdx) {
1096                     idPledge = undelegate(
1097                         idPledge,
1098                         amount,
1099                         p.delegationChain.length - senderDIdx - 1
1100                     );
1101                     appendDelegate(idPledge, amount, idReceiver);
1102 
1103                 // And is already part of the delegate chain but is before the
1104                 //  sender, then the sender and all of the other delegates after
1105                 //  the RECEIVER are removed from the delegationChain 
1106                 } else if (receiverDIdx <= senderDIdx) {//TODO Check for Game Theory issues (from Arthur) this allows the sender to sort of go komakosi and remove himself and the delegates between himself and the receiver... should this authority be allowed? 
1107                     undelegate(
1108                         idPledge,
1109                         amount,
1110                         p.delegationChain.length - receiverDIdx - 1
1111                     );
1112                 }
1113                 return;
1114             }
1115 
1116             // And the receiver is a Project, all the delegates after the sender
1117             //  are removed and the amount is pre-committed to the project
1118             if (receiver.adminType == PledgeAdminType.Project) {
1119                 idPledge = undelegate(
1120                     idPledge,
1121                     amount,
1122                     p.delegationChain.length - senderDIdx - 1
1123                 );
1124                 proposeAssignProject(idPledge, amount, idReceiver);
1125                 return;
1126             }
1127         }
1128         assert(false);  // When the sender is not an owner or a delegate 
1129     }
1130 
1131     /// @notice Authorizes a payment be made from the `vault` can be used by the
1132     ///  Giver to veto a pre-committed donation from a Delegate to an
1133     ///  intendedProject
1134     /// @param idPledge Id of the pledge that is to be redeemed into ether
1135     /// @param amount Quantity of ether (in wei) to be authorized
1136     function withdraw(uint64 idPledge, uint amount) {
1137         idPledge = normalizePledge(idPledge); // Updates pledge info 
1138         Pledge storage p = findPledge(idPledge);
1139         require(p.pledgeState == PledgeState.Pledged);
1140         PledgeAdmin storage owner = findAdmin(p.owner);
1141         checkAdminOwner(owner);
1142 
1143         uint64 idNewPledge = findOrCreatePledge(
1144             p.owner,
1145             p.delegationChain,
1146             0,
1147             0,
1148             p.oldPledge,
1149             PledgeState.Paying
1150         );
1151 
1152         doTransfer(idPledge, idNewPledge, amount);
1153 
1154         vault.authorizePayment(bytes32(idNewPledge), owner.addr, amount);
1155     }
1156 
1157     /// @notice `onlyVault` Confirms a withdraw request changing the PledgeState
1158     ///  from Paying to Paid
1159     /// @param idPledge Id of the pledge that is to be withdrawn
1160     /// @param amount Quantity of ether (in wei) to be withdrawn
1161     function confirmPayment(uint64 idPledge, uint amount) onlyVault {
1162         Pledge storage p = findPledge(idPledge);
1163 
1164         require(p.pledgeState == PledgeState.Paying);
1165 
1166         uint64 idNewPledge = findOrCreatePledge(
1167             p.owner,
1168             p.delegationChain,
1169             0,
1170             0,
1171             p.oldPledge,
1172             PledgeState.Paid
1173         );
1174 
1175         doTransfer(idPledge, idNewPledge, amount);
1176     }
1177 
1178     /// @notice `onlyVault` Cancels a withdraw request, changing the PledgeState 
1179     ///  from Paying back to Pledged
1180     /// @param idPledge Id of the pledge that's withdraw is to be canceled
1181     /// @param amount Quantity of ether (in wei) to be canceled
1182     function cancelPayment(uint64 idPledge, uint amount) onlyVault {
1183         Pledge storage p = findPledge(idPledge);
1184 
1185         require(p.pledgeState == PledgeState.Paying); //TODO change to revert????????????????????????????
1186 
1187         // When a payment is canceled, never is assigned to a project.
1188         uint64 oldPledge = findOrCreatePledge(
1189             p.owner,
1190             p.delegationChain,
1191             0,
1192             0,
1193             p.oldPledge,
1194             PledgeState.Pledged
1195         );
1196 
1197         oldPledge = normalizePledge(oldPledge);
1198 
1199         doTransfer(idPledge, oldPledge, amount);
1200     }
1201 
1202     /// @notice Changes the `project.canceled` flag to `true`; cannot be undone
1203     /// @param idProject Id of the project that is to be canceled
1204     function cancelProject(uint64 idProject) { 
1205         PledgeAdmin storage project = findAdmin(idProject);
1206         checkAdminOwner(project);
1207         project.canceled = true;
1208 
1209         CancelProject(idProject);
1210     }
1211 
1212     /// @notice Transfers `amount` in `idPledge` back to the `oldPledge` that
1213     ///  that sent it there in the first place, a Ctrl-z 
1214     /// @param idPledge Id of the pledge that is to be canceled
1215     /// @param amount Quantity of ether (in wei) to be transfered to the 
1216     ///  `oldPledge`
1217     function cancelPledge(uint64 idPledge, uint amount) { 
1218         idPledge = normalizePledge(idPledge);
1219 
1220         Pledge storage p = findPledge(idPledge);
1221         require(p.oldPledge != 0);
1222 
1223         PledgeAdmin storage m = findAdmin(p.owner);
1224         checkAdminOwner(m);
1225 
1226         uint64 oldPledge = getOldestPledgeNotCanceled(p.oldPledge);
1227         doTransfer(idPledge, oldPledge, amount);
1228     }
1229 
1230 
1231 ////////
1232 // Multi pledge methods
1233 ////////
1234 
1235     // @dev This set of functions makes moving a lot of pledges around much more
1236     // efficient (saves gas) than calling these functions in series
1237     
1238     
1239     /// @dev Bitmask used for dividing pledge amounts in Multi pledge methods
1240     uint constant D64 = 0x10000000000000000;
1241 
1242     /// @notice Transfers multiple amounts within multiple Pledges in an
1243     ///  efficient single call 
1244     /// @param idSender Id of the Admin that is transferring the amounts from
1245     ///  all the Pledges; this admin must have permissions to move the value
1246     /// @param pledgesAmounts An array of Pledge amounts and the idPledges with 
1247     ///  which the amounts are associated; these are extrapolated using the D64
1248     ///  bitmask
1249     /// @param idReceiver Destination of the `pledesAmounts`, can be a Giver or 
1250     ///  Project sending to a Giver, a Delegate or a Project; a Delegate sending
1251     ///  to another Delegate, or a Delegate pre-commiting it to a Project 
1252     function mTransfer(
1253         uint64 idSender,
1254         uint[] pledgesAmounts,
1255         uint64 idReceiver
1256     ) {
1257         for (uint i = 0; i < pledgesAmounts.length; i++ ) {
1258             uint64 idPledge = uint64( pledgesAmounts[i] & (D64-1) );
1259             uint amount = pledgesAmounts[i] / D64;
1260 
1261             transfer(idSender, idPledge, amount, idReceiver);
1262         }
1263     }
1264 
1265     /// @notice Authorizes multiple amounts within multiple Pledges to be
1266     ///  withdrawn from the `vault` in an efficient single call 
1267     /// @param pledgesAmounts An array of Pledge amounts and the idPledges with 
1268     ///  which the amounts are associated; these are extrapolated using the D64
1269     ///  bitmask
1270     function mWithdraw(uint[] pledgesAmounts) {
1271         for (uint i = 0; i < pledgesAmounts.length; i++ ) {
1272             uint64 idPledge = uint64( pledgesAmounts[i] & (D64-1) );
1273             uint amount = pledgesAmounts[i] / D64;
1274 
1275             withdraw(idPledge, amount);
1276         }
1277     }
1278 
1279     /// @notice `mConfirmPayment` allows for multiple pledges to be confirmed
1280     ///  efficiently
1281     /// @param pledgesAmounts An array of pledge amounts and IDs which are extrapolated
1282     ///  using the D64 bitmask
1283     function mConfirmPayment(uint[] pledgesAmounts) {
1284         for (uint i = 0; i < pledgesAmounts.length; i++ ) {
1285             uint64 idPledge = uint64( pledgesAmounts[i] & (D64-1) );
1286             uint amount = pledgesAmounts[i] / D64;
1287 
1288             confirmPayment(idPledge, amount);
1289         }
1290     }
1291 
1292     /// @notice `mCancelPayment` allows for multiple pledges to be canceled
1293     ///  efficiently
1294     /// @param pledgesAmounts An array of pledge amounts and IDs which are extrapolated
1295     ///  using the D64 bitmask
1296     function mCancelPayment(uint[] pledgesAmounts) {
1297         for (uint i = 0; i < pledgesAmounts.length; i++ ) {
1298             uint64 idPledge = uint64( pledgesAmounts[i] & (D64-1) );
1299             uint amount = pledgesAmounts[i] / D64;
1300 
1301             cancelPayment(idPledge, amount);
1302         }
1303     }
1304 
1305     /// @notice `mNormalizePledge` allows for multiple pledges to be
1306     ///  normalized efficiently
1307     /// @param pledges An array of pledge IDs
1308     function mNormalizePledge(uint64[] pledges) {
1309         for (uint i = 0; i < pledges.length; i++ ) {
1310             normalizePledge( pledges[i] );
1311         }
1312     }
1313 
1314 ////////
1315 // Private methods
1316 ///////
1317 
1318     /// @notice `transferOwnershipToProject` allows for the transfer of
1319     ///  ownership to the project, but it can also be called by a project
1320     ///  to un-delegate everyone by setting one's own id for the idReceiver
1321     /// @param idPledge Id of the pledge to be transfered.
1322     /// @param amount Quantity of value that's being transfered
1323     /// @param idReceiver The new owner of the project (or self to un-delegate)
1324     function transferOwnershipToProject(
1325         uint64 idPledge,
1326         uint amount,
1327         uint64 idReceiver
1328     ) internal {
1329         Pledge storage p = findPledge(idPledge);
1330 
1331         // Ensure that the pledge is not already at max pledge depth
1332         // and the project has not been canceled
1333         require(getPledgeLevel(p) < MAX_INTERPROJECT_LEVEL);
1334         require(!isProjectCanceled(idReceiver));
1335 
1336         uint64 oldPledge = findOrCreatePledge(
1337             p.owner,
1338             p.delegationChain,
1339             0,
1340             0,
1341             p.oldPledge,
1342             PledgeState.Pledged
1343         );
1344         uint64 toPledge = findOrCreatePledge(
1345             idReceiver,                     // Set the new owner
1346             new uint64[](0),                // clear the delegation chain
1347             0,
1348             0,
1349             oldPledge,
1350             PledgeState.Pledged
1351         );
1352         doTransfer(idPledge, toPledge, amount);
1353     }   
1354 
1355 
1356     /// @notice `transferOwnershipToGiver` allows for the transfer of
1357     ///  value back to the Giver, value is placed in a pledged state
1358     ///  without being attached to a project, delegation chain, or time line.
1359     /// @param idPledge Id of the pledge to be transfered.
1360     /// @param amount Quantity of value that's being transfered
1361     /// @param idReceiver The new owner of the pledge
1362     function transferOwnershipToGiver(
1363         uint64 idPledge,
1364         uint amount,
1365         uint64 idReceiver
1366     ) internal {
1367         uint64 toPledge = findOrCreatePledge(
1368             idReceiver,
1369             new uint64[](0),
1370             0,
1371             0,
1372             0,
1373             PledgeState.Pledged
1374         );
1375         doTransfer(idPledge, toPledge, amount);
1376     }
1377 
1378     /// @notice `appendDelegate` allows for a delegate to be added onto the
1379     ///  end of the delegate chain for a given Pledge.
1380     /// @param idPledge Id of the pledge thats delegate chain will be modified.
1381     /// @param amount Quantity of value that's being chained.
1382     /// @param idReceiver The delegate to be added at the end of the chain
1383     function appendDelegate(
1384         uint64 idPledge,
1385         uint amount,
1386         uint64 idReceiver
1387     ) internal {
1388         Pledge storage p = findPledge(idPledge);
1389 
1390         require(p.delegationChain.length < MAX_DELEGATES);
1391         uint64[] memory newDelegationChain = new uint64[](
1392             p.delegationChain.length + 1
1393         );
1394         for (uint i = 0; i<p.delegationChain.length; i++) {
1395             newDelegationChain[i] = p.delegationChain[i];
1396         }
1397 
1398         // Make the last item in the array the idReceiver
1399         newDelegationChain[p.delegationChain.length] = idReceiver;
1400 
1401         uint64 toPledge = findOrCreatePledge(
1402             p.owner,
1403             newDelegationChain,
1404             0,
1405             0,
1406             p.oldPledge,
1407             PledgeState.Pledged
1408         );
1409         doTransfer(idPledge, toPledge, amount);
1410     }
1411 
1412     /// @notice `appendDelegate` allows for a delegate to be added onto the
1413     ///  end of the delegate chain for a given Pledge.
1414     /// @param idPledge Id of the pledge thats delegate chain will be modified.
1415     /// @param amount Quantity of value that's shifted from delegates.
1416     /// @param q Number (or depth) of delegates to remove
1417     /// @return toPledge The id for the pledge being adjusted or created
1418     function undelegate(
1419         uint64 idPledge,
1420         uint amount,
1421         uint q
1422     ) internal returns (uint64)
1423     {
1424         Pledge storage p = findPledge(idPledge);
1425         uint64[] memory newDelegationChain = new uint64[](
1426             p.delegationChain.length - q
1427         );
1428 
1429         for (uint i=0; i<p.delegationChain.length - q; i++) {
1430             newDelegationChain[i] = p.delegationChain[i];
1431         }
1432         uint64 toPledge = findOrCreatePledge(
1433             p.owner,
1434             newDelegationChain,
1435             0,
1436             0,
1437             p.oldPledge,
1438             PledgeState.Pledged
1439         );
1440         doTransfer(idPledge, toPledge, amount);
1441 
1442         return toPledge;
1443     }
1444 
1445     /// @notice `proposeAssignProject` proposes the assignment of a pledge
1446     ///  to a specific project.
1447     /// @dev This function should potentially be named more specifically.
1448     /// @param idPledge Id of the pledge that will be assigned.
1449     /// @param amount Quantity of value this pledge leader would be assigned.
1450     /// @param idReceiver The project this pledge will potentially 
1451     ///  be assigned to.
1452     function proposeAssignProject(
1453         uint64 idPledge,
1454         uint amount,
1455         uint64 idReceiver
1456     ) internal {
1457         Pledge storage p = findPledge(idPledge);
1458 
1459         require(getPledgeLevel(p) < MAX_INTERPROJECT_LEVEL);
1460         require(!isProjectCanceled(idReceiver));
1461 
1462         uint64 toPledge = findOrCreatePledge(
1463             p.owner,
1464             p.delegationChain,
1465             idReceiver,
1466             uint64(getTime() + maxCommitTime(p)),
1467             p.oldPledge,
1468             PledgeState.Pledged
1469         );
1470         doTransfer(idPledge, toPledge, amount);
1471     }
1472 
1473     /// @notice `doTransfer` is designed to allow for pledge amounts to be 
1474     ///  shifted around internally.
1475     /// @param from This is the Id from which value will be transfered.
1476     /// @param to This is the Id that value will be transfered to.
1477     /// @param _amount The amount of value that will be transfered.
1478     function doTransfer(uint64 from, uint64 to, uint _amount) internal {
1479         uint amount = callPlugins(true, from, to, _amount);
1480         if (from == to) { 
1481             return;
1482         }
1483         if (amount == 0) {
1484             return;
1485         }
1486         Pledge storage nFrom = findPledge(from);
1487         Pledge storage nTo = findPledge(to);
1488         require(nFrom.amount >= amount);
1489         nFrom.amount -= amount;
1490         nTo.amount += amount;
1491 
1492         Transfer(from, to, amount);
1493         callPlugins(false, from, to, amount);
1494     }
1495 
1496     /// @notice Only affects pledges with the Pledged PledgeState for 2 things:
1497     ///   #1: Checks if the pledge should be committed. This means that
1498     ///       if the pledge has an intendedProject and it is past the
1499     ///       commitTime, it changes the owner to be the proposed project
1500     ///       (The UI will have to read the commit time and manually do what
1501     ///       this function does to the pledge for the end user
1502     ///       at the expiration of the commitTime)
1503     ///
1504     ///   #2: Checks to make sure that if there has been a cancellation in the
1505     ///       chain of projects, the pledge's owner has been changed
1506     ///       appropriately.
1507     ///
1508     /// This function can be called by anybody at anytime on any pledge.
1509     ///  In general it can be called to force the calls of the affected 
1510     ///  plugins, which also need to be predicted by the UI
1511     /// @param idPledge This is the id of the pledge that will be normalized
1512     /// @return The normalized Pledge!
1513     function normalizePledge(uint64 idPledge) returns(uint64) {
1514 
1515         Pledge storage p = findPledge(idPledge);
1516 
1517         // Check to make sure this pledge hasn't already been used 
1518         // or is in the process of being used
1519         if (p.pledgeState != PledgeState.Pledged) {
1520             return idPledge;
1521         }
1522 
1523         // First send to a project if it's proposed and committed
1524         if ((p.intendedProject > 0) && ( getTime() > p.commitTime)) {
1525             uint64 oldPledge = findOrCreatePledge(
1526                 p.owner,
1527                 p.delegationChain,
1528                 0,
1529                 0,
1530                 p.oldPledge,
1531                 PledgeState.Pledged
1532             );
1533             uint64 toPledge = findOrCreatePledge(
1534                 p.intendedProject,
1535                 new uint64[](0),
1536                 0,
1537                 0,
1538                 oldPledge,
1539                 PledgeState.Pledged
1540             );
1541             doTransfer(idPledge, toPledge, p.amount);
1542             idPledge = toPledge;
1543             p = findPledge(idPledge);
1544         }
1545 
1546         toPledge = getOldestPledgeNotCanceled(idPledge);
1547         if (toPledge != idPledge) {
1548             doTransfer(idPledge, toPledge, p.amount);
1549         }
1550 
1551         return toPledge;
1552     }
1553 
1554 /////////////
1555 // Plugins
1556 /////////////
1557 
1558     /// @notice `callPlugin` is used to trigger the general functions in the
1559     ///  plugin for any actions needed before and after a transfer happens.
1560     ///  Specifically what this does in relation to the plugin is something
1561     ///  that largely depends on the functions of that plugin. This function
1562     ///  is generally called in pairs, once before, and once after a transfer.
1563     /// @param before This toggle determines whether the plugin call is occurring
1564     ///  before or after a transfer.
1565     /// @param adminId This should be the Id of the *trusted* individual
1566     ///  who has control over this plugin.
1567     /// @param fromPledge This is the Id from which value is being transfered.
1568     /// @param toPledge This is the Id that value is being transfered to.
1569     /// @param context The situation that is triggering the plugin. See plugin
1570     ///  for a full description of contexts.
1571     /// @param amount The amount of value that is being transfered.
1572     function callPlugin(
1573         bool before,
1574         uint64 adminId,
1575         uint64 fromPledge,
1576         uint64 toPledge,
1577         uint64 context,
1578         uint amount
1579     ) internal returns (uint allowedAmount) {
1580 
1581         uint newAmount;
1582         allowedAmount = amount;
1583         PledgeAdmin storage admin = findAdmin(adminId);
1584         // Checks admin has a plugin assigned and a non-zero amount is requested
1585         if ((address(admin.plugin) != 0) && (allowedAmount > 0)) {
1586             // There are two seperate functions called in the plugin.
1587             // One is called before the transfer and one after
1588             if (before) {
1589                 newAmount = admin.plugin.beforeTransfer(
1590                     adminId,
1591                     fromPledge,
1592                     toPledge,
1593                     context,
1594                     amount
1595                 );
1596                 require(newAmount <= allowedAmount);
1597                 allowedAmount = newAmount;
1598             } else {
1599                 admin.plugin.afterTransfer(
1600                     adminId,
1601                     fromPledge,
1602                     toPledge,
1603                     context,
1604                     amount
1605                 );
1606             }
1607         }
1608     }
1609 
1610     /// @notice `callPluginsPledge` is used to apply plugin calls to
1611     ///  the delegate chain and the intended project if there is one.
1612     ///  It does so in either a transferring or receiving context based
1613     ///  on the `idPledge` and  `fromPledge` parameters.
1614     /// @param before This toggle determines whether the plugin call is occuring
1615     ///  before or after a transfer.
1616     /// @param idPledge This is the Id of the pledge on which this plugin
1617     ///  is being called.
1618     /// @param fromPledge This is the Id from which value is being transfered.
1619     /// @param toPledge This is the Id that value is being transfered to.
1620     /// @param amount The amount of value that is being transfered.
1621     function callPluginsPledge(
1622         bool before,
1623         uint64 idPledge,
1624         uint64 fromPledge,
1625         uint64 toPledge,
1626         uint amount
1627     ) internal returns (uint allowedAmount) {
1628         // Determine if callPlugin is being applied in a receiving
1629         // or transferring context
1630         uint64 offset = idPledge == fromPledge ? 0 : 256;
1631         allowedAmount = amount;
1632         Pledge storage p = findPledge(idPledge);
1633 
1634         // Always call the plugin on the owner
1635         allowedAmount = callPlugin(
1636             before,
1637             p.owner,
1638             fromPledge,
1639             toPledge,
1640             offset,
1641             allowedAmount
1642         );
1643 
1644         // Apply call plugin to all delegates
1645         for (uint64 i=0; i<p.delegationChain.length; i++) {
1646             allowedAmount = callPlugin(
1647                 before,
1648                 p.delegationChain[i],
1649                 fromPledge,
1650                 toPledge,
1651                 offset + i+1,
1652                 allowedAmount
1653             );
1654         }
1655 
1656         // If there is an intended project also call the plugin in
1657         // either a transferring or receiving context based on offset
1658         // on the intended project
1659         if (p.intendedProject > 0) {
1660             allowedAmount = callPlugin(
1661                 before,
1662                 p.intendedProject,
1663                 fromPledge,
1664                 toPledge,
1665                 offset + 255,
1666                 allowedAmount
1667             );
1668         }
1669     }
1670 
1671 
1672     /// @notice `callPlugins` calls `callPluginsPledge` once for the transfer
1673     ///  context and once for the receiving context. The aggregated 
1674     ///  allowed amount is then returned.
1675     /// @param before This toggle determines whether the plugin call is occurring
1676     ///  before or after a transfer.
1677     /// @param fromPledge This is the Id from which value is being transferred.
1678     /// @param toPledge This is the Id that value is being transferred to.
1679     /// @param amount The amount of value that is being transferred.
1680     function callPlugins(
1681         bool before,
1682         uint64 fromPledge,
1683         uint64 toPledge,
1684         uint amount
1685     ) internal returns (uint allowedAmount) {
1686         allowedAmount = amount;
1687 
1688         // Call the pledges plugins in the transfer context
1689         allowedAmount = callPluginsPledge(
1690             before,
1691             fromPledge,
1692             fromPledge,
1693             toPledge,
1694             allowedAmount
1695         );
1696 
1697         // Call the pledges plugins in the receive context
1698         allowedAmount = callPluginsPledge(
1699             before,
1700             toPledge,
1701             fromPledge,
1702             toPledge,
1703             allowedAmount
1704         );
1705     }
1706 
1707 /////////////
1708 // Test functions
1709 /////////////
1710 
1711     /// @notice Basic helper function to return the current time
1712     function getTime() internal returns (uint) {
1713         return now;
1714     }
1715 
1716     // Event Delcerations
1717     event Transfer(uint64 indexed from, uint64 indexed to, uint amount);
1718     event CancelProject(uint64 indexed idProject);
1719 
1720 }
1721 
1722 //File: node_modules/minimetoken/contracts/Controlled.sol
1723 pragma solidity ^0.4.18;
1724 
1725 contract Controlled {
1726     /// @notice The address of the controller is the only address that can call
1727     ///  a function with this modifier
1728     modifier onlyController { require(msg.sender == controller); _; }
1729 
1730     address public controller;
1731 
1732     function Controlled() public { controller = msg.sender;}
1733 
1734     /// @notice Changes the controller of the contract
1735     /// @param _newController The new controller of the contract
1736     function changeController(address _newController) public onlyController {
1737         controller = _newController;
1738     }
1739 }
1740 
1741 //File: node_modules/minimetoken/contracts/TokenController.sol
1742 pragma solidity ^0.4.18;
1743 
1744 /// @dev The token controller contract must implement these functions
1745 contract TokenController {
1746     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
1747     /// @param _owner The address that sent the ether to create tokens
1748     /// @return True if the ether is accepted, false if it throws
1749     function proxyPayment(address _owner) public payable returns(bool);
1750 
1751     /// @notice Notifies the controller about a token transfer allowing the
1752     ///  controller to react if desired
1753     /// @param _from The origin of the transfer
1754     /// @param _to The destination of the transfer
1755     /// @param _amount The amount of the transfer
1756     /// @return False if the controller does not authorize the transfer
1757     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
1758 
1759     /// @notice Notifies the controller about an approval allowing the
1760     ///  controller to react if desired
1761     /// @param _owner The address that calls `approve()`
1762     /// @param _spender The spender in the `approve()` call
1763     /// @param _amount The amount in the `approve()` call
1764     /// @return False if the controller does not authorize the approval
1765     function onApprove(address _owner, address _spender, uint _amount) public
1766         returns(bool);
1767 }
1768 
1769 //File: node_modules/minimetoken/contracts/MiniMeToken.sol
1770 pragma solidity ^0.4.18;
1771 
1772 /*
1773     Copyright 2016, Jordi Baylina
1774 
1775     This program is free software: you can redistribute it and/or modify
1776     it under the terms of the GNU General Public License as published by
1777     the Free Software Foundation, either version 3 of the License, or
1778     (at your option) any later version.
1779 
1780     This program is distributed in the hope that it will be useful,
1781     but WITHOUT ANY WARRANTY; without even the implied warranty of
1782     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1783     GNU General Public License for more details.
1784 
1785     You should have received a copy of the GNU General Public License
1786     along with this program.  If not, see <http://www.gnu.org/licenses/>.
1787  */
1788 
1789 /// @title MiniMeToken Contract
1790 /// @author Jordi Baylina
1791 /// @dev This token contract's goal is to make it easy for anyone to clone this
1792 ///  token using the token distribution at a given block, this will allow DAO's
1793 ///  and DApps to upgrade their features in a decentralized manner without
1794 ///  affecting the original token
1795 /// @dev It is ERC20 compliant, but still needs to under go further testing.
1796 
1797 
1798 
1799 
1800 contract ApproveAndCallFallBack {
1801     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
1802 }
1803 
1804 /// @dev The actual token contract, the default controller is the msg.sender
1805 ///  that deploys the contract, so usually this token will be deployed by a
1806 ///  token controller contract, which Giveth will call a "Campaign"
1807 contract MiniMeToken is Controlled {
1808 
1809     string public name;                //The Token's name: e.g. DigixDAO Tokens
1810     uint8 public decimals;             //Number of decimals of the smallest unit
1811     string public symbol;              //An identifier: e.g. REP
1812     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
1813 
1814 
1815     /// @dev `Checkpoint` is the structure that attaches a block number to a
1816     ///  given value, the block number attached is the one that last changed the
1817     ///  value
1818     struct  Checkpoint {
1819 
1820         // `fromBlock` is the block number that the value was generated from
1821         uint128 fromBlock;
1822 
1823         // `value` is the amount of tokens at a specific block number
1824         uint128 value;
1825     }
1826 
1827     // `parentToken` is the Token address that was cloned to produce this token;
1828     //  it will be 0x0 for a token that was not cloned
1829     MiniMeToken public parentToken;
1830 
1831     // `parentSnapShotBlock` is the block number from the Parent Token that was
1832     //  used to determine the initial distribution of the Clone Token
1833     uint public parentSnapShotBlock;
1834 
1835     // `creationBlock` is the block number that the Clone Token was created
1836     uint public creationBlock;
1837 
1838     // `balances` is the map that tracks the balance of each address, in this
1839     //  contract when the balance changes the block number that the change
1840     //  occurred is also included in the map
1841     mapping (address => Checkpoint[]) balances;
1842 
1843     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
1844     mapping (address => mapping (address => uint256)) allowed;
1845 
1846     // Tracks the history of the `totalSupply` of the token
1847     Checkpoint[] totalSupplyHistory;
1848 
1849     // Flag that determines if the token is transferable or not.
1850     bool public transfersEnabled;
1851 
1852     // The factory used to create new clone tokens
1853     MiniMeTokenFactory public tokenFactory;
1854 
1855 ////////////////
1856 // Constructor
1857 ////////////////
1858 
1859     /// @notice Constructor to create a MiniMeToken
1860     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
1861     ///  will create the Clone token contracts, the token factory needs to be
1862     ///  deployed first
1863     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
1864     ///  new token
1865     /// @param _parentSnapShotBlock Block of the parent token that will
1866     ///  determine the initial distribution of the clone token, set to 0 if it
1867     ///  is a new token
1868     /// @param _tokenName Name of the new token
1869     /// @param _decimalUnits Number of decimals of the new token
1870     /// @param _tokenSymbol Token Symbol for the new token
1871     /// @param _transfersEnabled If true, tokens will be able to be transferred
1872     function MiniMeToken(
1873         address _tokenFactory,
1874         address _parentToken,
1875         uint _parentSnapShotBlock,
1876         string _tokenName,
1877         uint8 _decimalUnits,
1878         string _tokenSymbol,
1879         bool _transfersEnabled
1880     ) public {
1881         tokenFactory = MiniMeTokenFactory(_tokenFactory);
1882         name = _tokenName;                                 // Set the name
1883         decimals = _decimalUnits;                          // Set the decimals
1884         symbol = _tokenSymbol;                             // Set the symbol
1885         parentToken = MiniMeToken(_parentToken);
1886         parentSnapShotBlock = _parentSnapShotBlock;
1887         transfersEnabled = _transfersEnabled;
1888         creationBlock = block.number;
1889     }
1890 
1891 
1892 ///////////////////
1893 // ERC20 Methods
1894 ///////////////////
1895 
1896     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
1897     /// @param _to The address of the recipient
1898     /// @param _amount The amount of tokens to be transferred
1899     /// @return Whether the transfer was successful or not
1900     function transfer(address _to, uint256 _amount) public returns (bool success) {
1901         require(transfersEnabled);
1902         return doTransfer(msg.sender, _to, _amount);
1903     }
1904 
1905     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
1906     ///  is approved by `_from`
1907     /// @param _from The address holding the tokens being transferred
1908     /// @param _to The address of the recipient
1909     /// @param _amount The amount of tokens to be transferred
1910     /// @return True if the transfer was successful
1911     function transferFrom(address _from, address _to, uint256 _amount
1912     ) public returns (bool success) {
1913 
1914         // The controller of this contract can move tokens around at will,
1915         //  this is important to recognize! Confirm that you trust the
1916         //  controller of this contract, which in most situations should be
1917         //  another open source smart contract or 0x0
1918         if (msg.sender != controller) {
1919             require(transfersEnabled);
1920 
1921             // The standard ERC 20 transferFrom functionality
1922             if (allowed[_from][msg.sender] < _amount) return false;
1923             allowed[_from][msg.sender] -= _amount;
1924         }
1925         return doTransfer(_from, _to, _amount);
1926     }
1927 
1928     /// @dev This is the actual transfer function in the token contract, it can
1929     ///  only be called by other functions in this contract.
1930     /// @param _from The address holding the tokens being transferred
1931     /// @param _to The address of the recipient
1932     /// @param _amount The amount of tokens to be transferred
1933     /// @return True if the transfer was successful
1934     function doTransfer(address _from, address _to, uint _amount
1935     ) internal returns(bool) {
1936 
1937            if (_amount == 0) {
1938                return true;
1939            }
1940 
1941            require(parentSnapShotBlock < block.number);
1942 
1943            // Do not allow transfer to 0x0 or the token contract itself
1944            require((_to != 0) && (_to != address(this)));
1945 
1946            // If the amount being transfered is more than the balance of the
1947            //  account the transfer returns false
1948            var previousBalanceFrom = balanceOfAt(_from, block.number);
1949            if (previousBalanceFrom < _amount) {
1950                return false;
1951            }
1952 
1953            // Alerts the token controller of the transfer
1954            if (isContract(controller)) {
1955                require(TokenController(controller).onTransfer(_from, _to, _amount));
1956            }
1957 
1958            // First update the balance array with the new value for the address
1959            //  sending the tokens
1960            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
1961 
1962            // Then update the balance array with the new value for the address
1963            //  receiving the tokens
1964            var previousBalanceTo = balanceOfAt(_to, block.number);
1965            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
1966            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
1967 
1968            // An event to make the transfer easy to find on the blockchain
1969            Transfer(_from, _to, _amount);
1970 
1971            return true;
1972     }
1973 
1974     /// @param _owner The address that's balance is being requested
1975     /// @return The balance of `_owner` at the current block
1976     function balanceOf(address _owner) public constant returns (uint256 balance) {
1977         return balanceOfAt(_owner, block.number);
1978     }
1979 
1980     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
1981     ///  its behalf. This is a modified version of the ERC20 approve function
1982     ///  to be a little bit safer
1983     /// @param _spender The address of the account able to transfer the tokens
1984     /// @param _amount The amount of tokens to be approved for transfer
1985     /// @return True if the approval was successful
1986     function approve(address _spender, uint256 _amount) public returns (bool success) {
1987         require(transfersEnabled);
1988 
1989         // To change the approve amount you first have to reduce the addresses`
1990         //  allowance to zero by calling `approve(_spender,0)` if it is not
1991         //  already 0 to mitigate the race condition described here:
1992         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1993         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
1994 
1995         // Alerts the token controller of the approve function call
1996         if (isContract(controller)) {
1997             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
1998         }
1999 
2000         allowed[msg.sender][_spender] = _amount;
2001         Approval(msg.sender, _spender, _amount);
2002         return true;
2003     }
2004 
2005     /// @dev This function makes it easy to read the `allowed[]` map
2006     /// @param _owner The address of the account that owns the token
2007     /// @param _spender The address of the account able to transfer the tokens
2008     /// @return Amount of remaining tokens of _owner that _spender is allowed
2009     ///  to spend
2010     function allowance(address _owner, address _spender
2011     ) public constant returns (uint256 remaining) {
2012         return allowed[_owner][_spender];
2013     }
2014 
2015     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
2016     ///  its behalf, and then a function is triggered in the contract that is
2017     ///  being approved, `_spender`. This allows users to use their tokens to
2018     ///  interact with contracts in one function call instead of two
2019     /// @param _spender The address of the contract able to transfer the tokens
2020     /// @param _amount The amount of tokens to be approved for transfer
2021     /// @return True if the function call was successful
2022     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
2023     ) public returns (bool success) {
2024         require(approve(_spender, _amount));
2025 
2026         ApproveAndCallFallBack(_spender).receiveApproval(
2027             msg.sender,
2028             _amount,
2029             this,
2030             _extraData
2031         );
2032 
2033         return true;
2034     }
2035 
2036     /// @dev This function makes it easy to get the total number of tokens
2037     /// @return The total number of tokens
2038     function totalSupply() public constant returns (uint) {
2039         return totalSupplyAt(block.number);
2040     }
2041 
2042 
2043 ////////////////
2044 // Query balance and totalSupply in History
2045 ////////////////
2046 
2047     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
2048     /// @param _owner The address from which the balance will be retrieved
2049     /// @param _blockNumber The block number when the balance is queried
2050     /// @return The balance at `_blockNumber`
2051     function balanceOfAt(address _owner, uint _blockNumber) public constant
2052         returns (uint) {
2053 
2054         // These next few lines are used when the balance of the token is
2055         //  requested before a check point was ever created for this token, it
2056         //  requires that the `parentToken.balanceOfAt` be queried at the
2057         //  genesis block for that token as this contains initial balance of
2058         //  this token
2059         if ((balances[_owner].length == 0)
2060             || (balances[_owner][0].fromBlock > _blockNumber)) {
2061             if (address(parentToken) != 0) {
2062                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
2063             } else {
2064                 // Has no parent
2065                 return 0;
2066             }
2067 
2068         // This will return the expected balance during normal situations
2069         } else {
2070             return getValueAt(balances[_owner], _blockNumber);
2071         }
2072     }
2073 
2074     /// @notice Total amount of tokens at a specific `_blockNumber`.
2075     /// @param _blockNumber The block number when the totalSupply is queried
2076     /// @return The total amount of tokens at `_blockNumber`
2077     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
2078 
2079         // These next few lines are used when the totalSupply of the token is
2080         //  requested before a check point was ever created for this token, it
2081         //  requires that the `parentToken.totalSupplyAt` be queried at the
2082         //  genesis block for this token as that contains totalSupply of this
2083         //  token at this block number.
2084         if ((totalSupplyHistory.length == 0)
2085             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
2086             if (address(parentToken) != 0) {
2087                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
2088             } else {
2089                 return 0;
2090             }
2091 
2092         // This will return the expected totalSupply during normal situations
2093         } else {
2094             return getValueAt(totalSupplyHistory, _blockNumber);
2095         }
2096     }
2097 
2098 ////////////////
2099 // Clone Token Method
2100 ////////////////
2101 
2102     /// @notice Creates a new clone token with the initial distribution being
2103     ///  this token at `_snapshotBlock`
2104     /// @param _cloneTokenName Name of the clone token
2105     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
2106     /// @param _cloneTokenSymbol Symbol of the clone token
2107     /// @param _snapshotBlock Block when the distribution of the parent token is
2108     ///  copied to set the initial distribution of the new clone token;
2109     ///  if the block is zero than the actual block, the current block is used
2110     /// @param _transfersEnabled True if transfers are allowed in the clone
2111     /// @return The address of the new MiniMeToken Contract
2112     function createCloneToken(
2113         string _cloneTokenName,
2114         uint8 _cloneDecimalUnits,
2115         string _cloneTokenSymbol,
2116         uint _snapshotBlock,
2117         bool _transfersEnabled
2118         ) public returns(address) {
2119         if (_snapshotBlock == 0) _snapshotBlock = block.number;
2120         MiniMeToken cloneToken = tokenFactory.createCloneToken(
2121             this,
2122             _snapshotBlock,
2123             _cloneTokenName,
2124             _cloneDecimalUnits,
2125             _cloneTokenSymbol,
2126             _transfersEnabled
2127             );
2128 
2129         cloneToken.changeController(msg.sender);
2130 
2131         // An event to make the token easy to find on the blockchain
2132         NewCloneToken(address(cloneToken), _snapshotBlock);
2133         return address(cloneToken);
2134     }
2135 
2136 ////////////////
2137 // Generate and destroy tokens
2138 ////////////////
2139 
2140     /// @notice Generates `_amount` tokens that are assigned to `_owner`
2141     /// @param _owner The address that will be assigned the new tokens
2142     /// @param _amount The quantity of tokens generated
2143     /// @return True if the tokens are generated correctly
2144     function generateTokens(address _owner, uint _amount
2145     ) public onlyController returns (bool) {
2146         uint curTotalSupply = totalSupply();
2147         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
2148         uint previousBalanceTo = balanceOf(_owner);
2149         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
2150         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
2151         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
2152         Transfer(0, _owner, _amount);
2153         return true;
2154     }
2155 
2156 
2157     /// @notice Burns `_amount` tokens from `_owner`
2158     /// @param _owner The address that will lose the tokens
2159     /// @param _amount The quantity of tokens to burn
2160     /// @return True if the tokens are burned correctly
2161     function destroyTokens(address _owner, uint _amount
2162     ) onlyController public returns (bool) {
2163         uint curTotalSupply = totalSupply();
2164         require(curTotalSupply >= _amount);
2165         uint previousBalanceFrom = balanceOf(_owner);
2166         require(previousBalanceFrom >= _amount);
2167         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
2168         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
2169         Transfer(_owner, 0, _amount);
2170         return true;
2171     }
2172 
2173 ////////////////
2174 // Enable tokens transfers
2175 ////////////////
2176 
2177 
2178     /// @notice Enables token holders to transfer their tokens freely if true
2179     /// @param _transfersEnabled True if transfers are allowed in the clone
2180     function enableTransfers(bool _transfersEnabled) public onlyController {
2181         transfersEnabled = _transfersEnabled;
2182     }
2183 
2184 ////////////////
2185 // Internal helper functions to query and set a value in a snapshot array
2186 ////////////////
2187 
2188     /// @dev `getValueAt` retrieves the number of tokens at a given block number
2189     /// @param checkpoints The history of values being queried
2190     /// @param _block The block number to retrieve the value at
2191     /// @return The number of tokens being queried
2192     function getValueAt(Checkpoint[] storage checkpoints, uint _block
2193     ) constant internal returns (uint) {
2194         if (checkpoints.length == 0) return 0;
2195 
2196         // Shortcut for the actual value
2197         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
2198             return checkpoints[checkpoints.length-1].value;
2199         if (_block < checkpoints[0].fromBlock) return 0;
2200 
2201         // Binary search of the value in the array
2202         uint min = 0;
2203         uint max = checkpoints.length-1;
2204         while (max > min) {
2205             uint mid = (max + min + 1)/ 2;
2206             if (checkpoints[mid].fromBlock<=_block) {
2207                 min = mid;
2208             } else {
2209                 max = mid-1;
2210             }
2211         }
2212         return checkpoints[min].value;
2213     }
2214 
2215     /// @dev `updateValueAtNow` used to update the `balances` map and the
2216     ///  `totalSupplyHistory`
2217     /// @param checkpoints The history of data being updated
2218     /// @param _value The new number of tokens
2219     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
2220     ) internal  {
2221         if ((checkpoints.length == 0)
2222         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
2223                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
2224                newCheckPoint.fromBlock =  uint128(block.number);
2225                newCheckPoint.value = uint128(_value);
2226            } else {
2227                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
2228                oldCheckPoint.value = uint128(_value);
2229            }
2230     }
2231 
2232     /// @dev Internal function to determine if an address is a contract
2233     /// @param _addr The address being queried
2234     /// @return True if `_addr` is a contract
2235     function isContract(address _addr) constant internal returns(bool) {
2236         uint size;
2237         if (_addr == 0) return false;
2238         assembly {
2239             size := extcodesize(_addr)
2240         }
2241         return size>0;
2242     }
2243 
2244     /// @dev Helper function to return a min betwen the two uints
2245     function min(uint a, uint b) pure internal returns (uint) {
2246         return a < b ? a : b;
2247     }
2248 
2249     /// @notice The fallback function: If the contract's controller has not been
2250     ///  set to 0, then the `proxyPayment` method is called which relays the
2251     ///  ether and creates tokens as described in the token controller contract
2252     function () public payable {
2253         require(isContract(controller));
2254         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
2255     }
2256 
2257 //////////
2258 // Safety Methods
2259 //////////
2260 
2261     /// @notice This method can be used by the controller to extract mistakenly
2262     ///  sent tokens to this contract.
2263     /// @param _token The address of the token contract that you want to recover
2264     ///  set to 0 in case you want to extract ether.
2265     function claimTokens(address _token) public onlyController {
2266         if (_token == 0x0) {
2267             controller.transfer(this.balance);
2268             return;
2269         }
2270 
2271         MiniMeToken token = MiniMeToken(_token);
2272         uint balance = token.balanceOf(this);
2273         token.transfer(controller, balance);
2274         ClaimedTokens(_token, controller, balance);
2275     }
2276 
2277 ////////////////
2278 // Events
2279 ////////////////
2280     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
2281     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
2282     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
2283     event Approval(
2284         address indexed _owner,
2285         address indexed _spender,
2286         uint256 _amount
2287         );
2288 
2289 }
2290 
2291 
2292 ////////////////
2293 // MiniMeTokenFactory
2294 ////////////////
2295 
2296 /// @dev This contract is used to generate clone contracts from a contract.
2297 ///  In solidity this is the way to create a contract from a contract of the
2298 ///  same class
2299 contract MiniMeTokenFactory {
2300 
2301     /// @notice Update the DApp by creating a new token with new functionalities
2302     ///  the msg.sender becomes the controller of this clone token
2303     /// @param _parentToken Address of the token being cloned
2304     /// @param _snapshotBlock Block of the parent token that will
2305     ///  determine the initial distribution of the clone token
2306     /// @param _tokenName Name of the new token
2307     /// @param _decimalUnits Number of decimals of the new token
2308     /// @param _tokenSymbol Token Symbol for the new token
2309     /// @param _transfersEnabled If true, tokens will be able to be transferred
2310     /// @return The address of the new token contract
2311     function createCloneToken(
2312         address _parentToken,
2313         uint _snapshotBlock,
2314         string _tokenName,
2315         uint8 _decimalUnits,
2316         string _tokenSymbol,
2317         bool _transfersEnabled
2318     ) public returns (MiniMeToken) {
2319         MiniMeToken newToken = new MiniMeToken(
2320             this,
2321             _parentToken,
2322             _snapshotBlock,
2323             _tokenName,
2324             _decimalUnits,
2325             _tokenSymbol,
2326             _transfersEnabled
2327             );
2328 
2329         newToken.changeController(msg.sender);
2330         return newToken;
2331     }
2332 }
2333 
2334 //File: contracts/LPPDacs.sol
2335 pragma solidity ^0.4.17;
2336 
2337 /*
2338     Copyright 2017, RJ Ewing <perissology@protonmail.com>
2339 
2340     This program is free software: you can redistribute it and/or modify
2341     it under the terms of the GNU General Public License as published by
2342     the Free Software Foundation, either version 3 of the License, or
2343     (at your option) any later version.
2344 
2345     This program is distributed in the hope that it will be useful,
2346     but WITHOUT ANY WARRANTY; without even the implied warranty of
2347     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
2348     GNU General Public License for more details.
2349 
2350     You should have received a copy of the GNU General Public License
2351     along with this program.  If not, see <http://www.gnu.org/licenses/>.
2352 */
2353 
2354 
2355 
2356 
2357 
2358 
2359 contract LPPDacs is Escapable, TokenController {
2360     uint constant FROM_FIRST_DELEGATE = 1;
2361     uint constant TO_FIRST_DELEGATE = 257;
2362 
2363     LiquidPledging public liquidPledging;
2364 
2365     struct Dac {
2366         MiniMeToken token;
2367         address owner;
2368     }
2369 
2370     mapping (uint64 => Dac) dacs;
2371 
2372     event GenerateTokens(uint64 indexed idDelegate, address addr, uint amount);
2373     event DestroyTokens(uint64 indexed idDelegate, address addr, uint amount);
2374 
2375     //== constructor
2376 
2377     function LPPDacs(
2378         LiquidPledging _liquidPledging,
2379         address _escapeHatchCaller,
2380         address _escapeHatchDestination
2381     ) Escapable(_escapeHatchCaller, _escapeHatchDestination) public
2382     {
2383         liquidPledging = _liquidPledging;
2384     }
2385 
2386     //== external
2387 
2388     /// @dev this is called by liquidPledging before every transfer to and from
2389     ///      a pledgeAdmin that has this contract as its plugin
2390     /// @dev see ILiquidPledgingPlugin interface for details about context param
2391     function beforeTransfer(
2392         uint64 pledgeManager,
2393         uint64 pledgeFrom,
2394         uint64 pledgeTo,
2395         uint64 context,
2396         uint amount
2397     ) external returns (uint maxAllowed)
2398     {
2399         require(msg.sender == address(liquidPledging));
2400         return amount;
2401     }
2402 
2403     /// @dev this is called by liquidPledging after every transfer to and from
2404     ///      a pledgeAdmin that has this contract as its plugin
2405     /// @dev see ILiquidPledgingPlugin interface for details about context param
2406     function afterTransfer(
2407         uint64 pledgeManager,
2408         uint64 pledgeFrom,
2409         uint64 pledgeTo,
2410         uint64 context,
2411         uint amount
2412     ) external
2413     {
2414         require(msg.sender == address(liquidPledging));
2415         var (, toOwner, , toIntendedProject, , , toPledgeState ) = liquidPledging.getPledge(pledgeTo);
2416         var (, fromOwner, , , , , ) = liquidPledging.getPledge(pledgeFrom);
2417         var (toAdminType, toAddr, , , , , , ) = liquidPledging.getPledgeAdmin(toOwner);
2418         Dac storage d;
2419         uint64 idDelegate;
2420 
2421         // only issue tokens when pledge is committed to a project and a dac is the first delegate
2422         if (context == FROM_FIRST_DELEGATE &&
2423                 toIntendedProject == 0 &&
2424                 toAdminType == LiquidPledgingBase.PledgeAdminType.Project &&
2425                 toOwner != fromOwner &&
2426                 toPledgeState == LiquidPledgingBase.PledgeState.Pledged)
2427         {
2428             (idDelegate, , ) = liquidPledging.getPledgeDelegate(pledgeFrom, 1);
2429             d = dacs[idDelegate];
2430 
2431             require(address(d.token) != 0x0);
2432 
2433             var (, fromAddr , , , , , , ) = liquidPledging.getPledgeAdmin(fromOwner);
2434 
2435             d.token.generateTokens(fromAddr, amount);
2436             GenerateTokens(idDelegate, fromAddr, amount);
2437         }
2438 
2439         // if a committed project is canceled and the pledge is rolling back to a
2440         // dac, we need to burn the tokens that we're generated
2441         if ( (context == TO_FIRST_DELEGATE) &&
2442             liquidPledging.isProjectCanceled(fromOwner)) {
2443             (idDelegate, , ) = liquidPledging.getPledgeDelegate(pledgeTo, 1);
2444             d = dacs[idDelegate];
2445 
2446             require(address(d.token) != 0x0);
2447 
2448             if (d.token.balanceOf(toAddr) >= amount) {
2449                 d.token.destroyTokens(toAddr, amount);
2450                 DestroyTokens(fromOwner, toAddr, amount);
2451             }
2452         }
2453     }
2454 
2455     //== public
2456 
2457     function addDac(
2458         string name,
2459         string url,
2460         uint64 commitTime,
2461         string tokenName,
2462         string tokenSymbol
2463     ) public
2464     {
2465         uint64 idDelegate = liquidPledging.addDelegate(
2466             name,
2467             url,
2468             commitTime,
2469             ILiquidPledgingPlugin(this)
2470         );
2471 
2472         MiniMeTokenFactory tokenFactory = new MiniMeTokenFactory();
2473         MiniMeToken token = new MiniMeToken(tokenFactory, 0x0, 0, tokenName, 18, tokenSymbol, false);
2474 
2475         dacs[idDelegate] = Dac(token, msg.sender);
2476     }
2477 
2478     function addDac(
2479         string name,
2480         string url,
2481         uint64 commitTime,
2482         MiniMeToken token
2483     ) public
2484     {
2485         uint64 idDelegate = liquidPledging.addDelegate(
2486           name,
2487           url,
2488           commitTime,
2489           ILiquidPledgingPlugin(this)
2490         );
2491 
2492         dacs[idDelegate] = Dac(token, msg.sender);
2493     }
2494 
2495     function transfer(
2496         uint64 idDelegate,
2497         uint64 idPledge,
2498         uint amount,
2499         uint64 idReceiver
2500     ) public
2501     {
2502         Dac storage d = dacs[idDelegate];
2503         require(msg.sender == d.owner);
2504 
2505         liquidPledging.transfer(
2506             idDelegate,
2507             idPledge,
2508             amount,
2509             idReceiver
2510         );
2511     }
2512 
2513     function changeOwner(
2514         uint64 idDelegate,
2515         address newOwner
2516     ) public
2517     {
2518         Dac storage d = dacs[idDelegate];
2519         require(msg.sender == d.owner);
2520         d.owner = newOwner;
2521     }
2522 
2523     function updateDac(
2524         uint64 idDelegate,
2525         string newName,
2526         string newUrl,
2527         uint64 newCommitTime
2528     ) public
2529     {
2530         Dac storage d = dacs[idDelegate];
2531         require(msg.sender == d.owner);
2532 
2533         liquidPledging.updateDelegate(
2534             idDelegate,
2535             address(this),
2536             newName,
2537             newUrl,
2538             newCommitTime
2539         );
2540     }
2541 
2542     function getDac(uint64 idDelegate) public view returns (
2543         MiniMeToken token,
2544         address owner
2545     )
2546     {
2547         Dac storage d = dacs[idDelegate];
2548         token = d.token;
2549         owner = d.owner;
2550     }
2551 
2552     ////////////////
2553     // TokenController
2554     ////////////////
2555 
2556     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
2557     /// @param _owner The address that sent the ether to create tokens
2558     /// @return True if the ether is accepted, false if it throws
2559     function proxyPayment(address _owner) public payable returns(bool) {
2560         return false;
2561     }
2562 
2563     /// @notice Notifies the controller about a token transfer allowing the
2564     ///  controller to react if desired
2565     /// @param _from The origin of the transfer
2566     /// @param _to The destination of the transfer
2567     /// @param _amount The amount of the transfer
2568     /// @return False if the controller does not authorize the transfer
2569     function onTransfer(address _from, address _to, uint _amount) public returns(bool) {
2570         return false;
2571     }
2572 
2573     /// @notice Notifies the controller about an approval allowing the
2574     ///  controller to react if desired
2575     /// @param _owner The address that calls `approve()`
2576     /// @param _spender The spender in the `approve()` call
2577     /// @param _amount The amount in the `approve()` call
2578     /// @return False if the controller does not authorize the approval
2579     function onApprove(address _owner, address _spender, uint _amount) public returns(bool) {
2580         return false;
2581     }
2582 }