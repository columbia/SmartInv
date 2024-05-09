1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Owned contract with safe ownership pass.
6  *
7  * Note: all the non constant functions return false instead of throwing in case if state change
8  * didn't happen yet.
9  */
10 contract Owned {
11     /**
12      * Contract owner address
13      */
14     address public contractOwner;
15 
16     /**
17      * Contract owner address
18      */
19     address public pendingContractOwner;
20 
21     function Owned() {
22         contractOwner = msg.sender;
23     }
24 
25     /**
26     * @dev Owner check modifier
27     */
28     modifier onlyContractOwner() {
29         if (contractOwner == msg.sender) {
30             _;
31         }
32     }
33 
34     /**
35      * @dev Destroy contract and scrub a data
36      * @notice Only owner can call it
37      */
38     function destroy() onlyContractOwner {
39         suicide(msg.sender);
40     }
41 
42     /**
43      * Prepares ownership pass.
44      *
45      * Can only be called by current owner.
46      *
47      * @param _to address of the next owner. 0x0 is not allowed.
48      *
49      * @return success.
50      */
51     function changeContractOwnership(address _to) onlyContractOwner() returns(bool) {
52         if (_to  == 0x0) {
53             return false;
54         }
55 
56         pendingContractOwner = _to;
57         return true;
58     }
59 
60     /**
61      * Finalize ownership pass.
62      *
63      * Can only be called by pending owner.
64      *
65      * @return success.
66      */
67     function claimContractOwnership() returns(bool) {
68         if (pendingContractOwner != msg.sender) {
69             return false;
70         }
71 
72         contractOwner = pendingContractOwner;
73         delete pendingContractOwner;
74 
75         return true;
76     }
77 }
78 
79 contract ERC20Interface {
80     event Transfer(address indexed from, address indexed to, uint256 value);
81     event Approval(address indexed from, address indexed spender, uint256 value);
82     string public symbol;
83 
84     function totalSupply() constant returns (uint256 supply);
85     function balanceOf(address _owner) constant returns (uint256 balance);
86     function transfer(address _to, uint256 _value) returns (bool success);
87     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
88     function approve(address _spender, uint256 _value) returns (bool success);
89     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
90 }
91 
92 
93 /**
94  * @title Generic owned destroyable contract
95  */
96 contract Object is Owned {
97     /**
98     *  Common result code. Means everything is fine.
99     */
100     uint constant OK = 1;
101     uint constant OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER = 8;
102 
103     function withdrawnTokens(address[] tokens, address _to) onlyContractOwner returns(uint) {
104         for(uint i=0;i<tokens.length;i++) {
105             address token = tokens[i];
106             uint balance = ERC20Interface(token).balanceOf(this);
107             if(balance != 0)
108                 ERC20Interface(token).transfer(_to,balance);
109         }
110         return OK;
111     }
112 
113     function checkOnlyContractOwner() internal constant returns(uint) {
114         if (contractOwner == msg.sender) {
115             return OK;
116         }
117 
118         return OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER;
119     }
120 }
121 
122 
123 /**
124 * @title SafeMath
125 * @dev Math operations with safety checks that throw on error
126 */
127 library SafeMath {
128     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a * b;
130         assert(a == 0 || c / a == b);
131         return c;
132     }
133 
134     function div(uint256 a, uint256 b) internal pure returns (uint256) {
135         // assert(b > 0); // Solidity automatically throws when dividing by 0
136         uint256 c = a / b;
137         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
138         return c;
139     }
140 
141     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
142         assert(b <= a);
143         return a - b;
144     }
145 
146     function add(uint256 a, uint256 b) internal pure returns (uint256) {
147         uint256 c = a + b;
148         assert(c >= a);
149         return c;
150     }
151 }
152 
153 contract ERC20 {
154     event Transfer(address indexed from, address indexed to, uint256 value);
155     event Approval(address indexed from, address indexed spender, uint256 value);
156     string public symbol;
157 
158     function totalSupply() constant returns (uint256 supply);
159     function balanceOf(address _owner) constant returns (uint256 balance);
160     function transfer(address _to, uint256 _value) returns (bool success);
161     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
162     function approve(address _spender, uint256 _value) returns (bool success);
163     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
164 }
165 /// @title Provides possibility manage holders? country limits and limits for holders.
166 contract DataControllerInterface {
167 
168     /// @notice Checks user is holder.
169     /// @param _address - checking address.
170     /// @return `true` if _address is registered holder, `false` otherwise.
171     function isHolderAddress(address _address) public view returns (bool);
172 
173     function allowance(address _user) public view returns (uint);
174 
175     function changeAllowance(address _holder, uint _value) public returns (uint);
176 }
177 /// @title ServiceController
178 ///
179 /// Base implementation
180 /// Serves for managing service instances
181 contract ServiceControllerInterface {
182 
183     /// @notice Check target address is service
184     /// @param _address target address
185     /// @return `true` when an address is a service, `false` otherwise
186     function isService(address _address) public view returns (bool);
187 }
188 
189 
190 contract ATxAssetInterface {
191 
192     DataControllerInterface public dataController;
193     ServiceControllerInterface public serviceController;
194 
195     function __transferWithReference(address _to, uint _value, string _reference, address _sender) public returns (bool);
196     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public returns (bool);
197     function __approve(address _spender, uint _value, address _sender) public returns (bool);
198     function __process(bytes /*_data*/, address /*_sender*/) payable public {
199         revert();
200     }
201 }
202 /// @title ServiceAllowance.
203 ///
204 /// Provides a way to delegate operation allowance decision to a service contract
205 contract ServiceAllowance {
206     function isTransferAllowed(address _from, address _to, address _sender, address _token, uint _value) public view returns (bool);
207 }
208 contract Platform {
209     mapping(bytes32 => address) public proxies;
210     function name(bytes32 _symbol) public view returns (string);
211     function setProxy(address _address, bytes32 _symbol) public returns (uint errorCode);
212     function isOwner(address _owner, bytes32 _symbol) public view returns (bool);
213     function totalSupply(bytes32 _symbol) public view returns (uint);
214     function balanceOf(address _holder, bytes32 _symbol) public view returns (uint);
215     function allowance(address _from, address _spender, bytes32 _symbol) public view returns (uint);
216     function baseUnit(bytes32 _symbol) public view returns (uint8);
217     function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public returns (uint errorCode);
218     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public returns (uint errorCode);
219     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) public returns (uint errorCode);
220     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable) public returns (uint errorCode);
221     function reissueAsset(bytes32 _symbol, uint _value) public returns (uint errorCode);
222     function revokeAsset(bytes32 _symbol, uint _value) public returns (uint errorCode);
223     function isReissuable(bytes32 _symbol) public view returns (bool);
224     function changeOwnership(bytes32 _symbol, address _newOwner) public returns (uint errorCode);
225 }
226 
227 
228 contract ATxAssetProxy is ERC20, Object, ServiceAllowance {
229 
230     // Timespan for users to review the new implementation and make decision.
231     uint constant UPGRADE_FREEZE_TIME = 3 days;
232 
233     using SafeMath for uint;
234 
235     /**
236      * Indicates an upgrade freeze-time start, and the next asset implementation contract.
237      */
238     event UpgradeProposal(address newVersion);
239 
240     // Current asset implementation contract address.
241     address latestVersion;
242 
243     // Proposed next asset implementation contract address.
244     address pendingVersion;
245 
246     // Upgrade freeze-time start.
247     uint pendingVersionTimestamp;
248 
249     // Assigned platform, immutable.
250     Platform public platform;
251 
252     // Assigned symbol, immutable.
253     bytes32 public smbl;
254 
255     // Assigned name, immutable.
256     string public name;
257 
258     /**
259      * Only platform is allowed to call.
260      */
261     modifier onlyPlatform() {
262         if (msg.sender == address(platform)) {
263             _;
264         }
265     }
266 
267     /**
268      * Only current asset owner is allowed to call.
269      */
270     modifier onlyAssetOwner() {
271         if (platform.isOwner(msg.sender, smbl)) {
272             _;
273         }
274     }
275 
276     /**
277      * Only asset implementation contract assigned to sender is allowed to call.
278      */
279     modifier onlyAccess(address _sender) {
280         if (getLatestVersion() == msg.sender) {
281             _;
282         }
283     }
284 
285     /**
286      * Resolves asset implementation contract for the caller and forwards there transaction data,
287      * along with the value. This allows for proxy interface growth.
288      */
289     function() public payable {
290         _getAsset().__process.value(msg.value)(msg.data, msg.sender);
291     }
292 
293     /**
294      * Sets platform address, assigns symbol and name.
295      *
296      * Can be set only once.
297      *
298      * @param _platform platform contract address.
299      * @param _symbol assigned symbol.
300      * @param _name assigned name.
301      *
302      * @return success.
303      */
304     function init(Platform _platform, string _symbol, string _name) public returns (bool) {
305         if (address(platform) != 0x0) {
306             return false;
307         }
308         platform = _platform;
309         symbol = _symbol;
310         smbl = stringToBytes32(_symbol);
311         name = _name;
312         return true;
313     }
314 
315     /**
316      * Returns asset total supply.
317      *
318      * @return asset total supply.
319      */
320     function totalSupply() public view returns (uint) {
321         return platform.totalSupply(smbl);
322     }
323 
324     /**
325      * Returns asset balance for a particular holder.
326      *
327      * @param _owner holder address.
328      *
329      * @return holder balance.
330      */
331     function balanceOf(address _owner) public view returns (uint) {
332         return platform.balanceOf(_owner, smbl);
333     }
334 
335     /**
336      * Returns asset allowance from one holder to another.
337      *
338      * @param _from holder that allowed spending.
339      * @param _spender holder that is allowed to spend.
340      *
341      * @return holder to spender allowance.
342      */
343     function allowance(address _from, address _spender) public view returns (uint) {
344         return platform.allowance(_from, _spender, smbl);
345     }
346 
347     /**
348      * Returns asset decimals.
349      *
350      * @return asset decimals.
351      */
352     function decimals() public view returns (uint8) {
353         return platform.baseUnit(smbl);
354     }
355 
356     /**
357      * Transfers asset balance from the caller to specified receiver.
358      *
359      * @param _to holder address to give to.
360      * @param _value amount to transfer.
361      *
362      * @return success.
363      */
364     function transfer(address _to, uint _value) public returns (bool) {
365         if (_to != 0x0) {
366             return _transferWithReference(_to, _value, "");
367         }
368         else {
369             return false;
370         }
371     }
372 
373     /**
374      * Transfers asset balance from the caller to specified receiver adding specified comment.
375      *
376      * @param _to holder address to give to.
377      * @param _value amount to transfer.
378      * @param _reference transfer comment to be included in a platform's Transfer event.
379      *
380      * @return success.
381      */
382     function transferWithReference(address _to, uint _value, string _reference) public returns (bool) {
383         if (_to != 0x0) {
384             return _transferWithReference(_to, _value, _reference);
385         }
386         else {
387             return false;
388         }
389     }
390 
391     /**
392      * Performs transfer call on the platform by the name of specified sender.
393      *
394      * Can only be called by asset implementation contract assigned to sender.
395      *
396      * @param _to holder address to give to.
397      * @param _value amount to transfer.
398      * @param _reference transfer comment to be included in a platform's Transfer event.
399      * @param _sender initial caller.
400      *
401      * @return success.
402      */
403     function __transferWithReference(address _to, uint _value, string _reference, address _sender) public onlyAccess(_sender) returns (bool) {
404         return platform.proxyTransferWithReference(_to, _value, smbl, _reference, _sender) == OK;
405     }
406 
407     /**
408      * Prforms allowance transfer of asset balance between holders.
409      *
410      * @param _from holder address to take from.
411      * @param _to holder address to give to.
412      * @param _value amount to transfer.
413      *
414      * @return success.
415      */
416     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
417         if (_to != 0x0) {
418             return _getAsset().__transferFromWithReference(_from, _to, _value, "", msg.sender);
419         }
420         else {
421             return false;
422         }
423     }
424 
425     /**
426      * Performs allowance transfer call on the platform by the name of specified sender.
427      *
428      * Can only be called by asset implementation contract assigned to sender.
429      *
430      * @param _from holder address to take from.
431      * @param _to holder address to give to.
432      * @param _value amount to transfer.
433      * @param _reference transfer comment to be included in a platform's Transfer event.
434      * @param _sender initial caller.
435      *
436      * @return success.
437      */
438     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public onlyAccess(_sender) returns (bool) {
439         return platform.proxyTransferFromWithReference(_from, _to, _value, smbl, _reference, _sender) == OK;
440     }
441 
442     /**
443      * Sets asset spending allowance for a specified spender.
444      *
445      * @param _spender holder address to set allowance to.
446      * @param _value amount to allow.
447      *
448      * @return success.
449      */
450     function approve(address _spender, uint _value) public returns (bool) {
451         if (_spender != 0x0) {
452             return _getAsset().__approve(_spender, _value, msg.sender);
453         }
454         else {
455             return false;
456         }
457     }
458 
459     /**
460      * Performs allowance setting call on the platform by the name of specified sender.
461      *
462      * Can only be called by asset implementation contract assigned to sender.
463      *
464      * @param _spender holder address to set allowance to.
465      * @param _value amount to allow.
466      * @param _sender initial caller.
467      *
468      * @return success.
469      */
470     function __approve(address _spender, uint _value, address _sender) public onlyAccess(_sender) returns (bool) {
471         return platform.proxyApprove(_spender, _value, smbl, _sender) == OK;
472     }
473 
474     /**
475      * Emits ERC20 Transfer event on this contract.
476      *
477      * Can only be, and, called by assigned platform when asset transfer happens.
478      */
479     function emitTransfer(address _from, address _to, uint _value) public onlyPlatform() {
480         Transfer(_from, _to, _value);
481     }
482 
483     /**
484      * Emits ERC20 Approval event on this contract.
485      *
486      * Can only be, and, called by assigned platform when asset allowance set happens.
487      */
488     function emitApprove(address _from, address _spender, uint _value) public onlyPlatform() {
489         Approval(_from, _spender, _value);
490     }
491 
492     /**
493      * Returns current asset implementation contract address.
494      *
495      * @return asset implementation contract address.
496      */
497     function getLatestVersion() public view returns (address) {
498         return latestVersion;
499     }
500 
501     /**
502      * Returns proposed next asset implementation contract address.
503      *
504      * @return asset implementation contract address.
505      */
506     function getPendingVersion() public view returns (address) {
507         return pendingVersion;
508     }
509 
510     /**
511      * Returns upgrade freeze-time start.
512      *
513      * @return freeze-time start.
514      */
515     function getPendingVersionTimestamp() public view returns (uint) {
516         return pendingVersionTimestamp;
517     }
518 
519     /**
520      * Propose next asset implementation contract address.
521      *
522      * Can only be called by current asset owner.
523      *
524      * Note: freeze-time should not be applied for the initial setup.
525      *
526      * @param _newVersion asset implementation contract address.
527      *
528      * @return success.
529      */
530     function proposeUpgrade(address _newVersion) public onlyAssetOwner returns (bool) {
531         // Should not already be in the upgrading process.
532         if (pendingVersion != 0x0) {
533             return false;
534         }
535         // New version address should be other than 0x0.
536         if (_newVersion == 0x0) {
537             return false;
538         }
539         // Don't apply freeze-time for the initial setup.
540         if (latestVersion == 0x0) {
541             latestVersion = _newVersion;
542             return true;
543         }
544         pendingVersion = _newVersion;
545         pendingVersionTimestamp = now;
546         UpgradeProposal(_newVersion);
547         return true;
548     }
549 
550     /**
551      * Cancel the pending upgrade process.
552      *
553      * Can only be called by current asset owner.
554      *
555      * @return success.
556      */
557     function purgeUpgrade() public onlyAssetOwner returns (bool) {
558         if (pendingVersion == 0x0) {
559             return false;
560         }
561         delete pendingVersion;
562         delete pendingVersionTimestamp;
563         return true;
564     }
565 
566     /**
567      * Finalize an upgrade process setting new asset implementation contract address.
568      *
569      * Can only be called after an upgrade freeze-time.
570      *
571      * @return success.
572      */
573     function commitUpgrade() public returns (bool) {
574         if (pendingVersion == 0x0) {
575             return false;
576         }
577         if (pendingVersionTimestamp.add(UPGRADE_FREEZE_TIME) > now) {
578             return false;
579         }
580         latestVersion = pendingVersion;
581         delete pendingVersion;
582         delete pendingVersionTimestamp;
583         return true;
584     }
585 
586     function isTransferAllowed(address, address, address, address, uint) public view returns (bool) {
587         return true;
588     }
589 
590     /**
591      * Returns asset implementation contract for current caller.
592      *
593      * @return asset implementation contract.
594      */
595     function _getAsset() internal view returns (ATxAssetInterface) {
596         return ATxAssetInterface(getLatestVersion());
597     }
598 
599     /**
600      * Resolves asset implementation contract for the caller and forwards there arguments along with
601      * the caller address.
602      *
603      * @return success.
604      */
605     function _transferWithReference(address _to, uint _value, string _reference) internal returns (bool) {
606         return _getAsset().__transferWithReference(_to, _value, _reference, msg.sender);
607     }
608 
609     function stringToBytes32(string memory source) private pure returns (bytes32 result) {
610         assembly {
611             result := mload(add(source, 32))
612         }
613     }
614 }