1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Owned contract with safe ownership pass.
5  *
6  * Note: all the non constant functions return false instead of throwing in case if state change
7  * didn't happen yet.
8  */
9 contract Owned {
10     /**
11      * Contract owner address
12      */
13     address public contractOwner;
14 
15     /**
16      * Contract owner address
17      */
18     address public pendingContractOwner;
19 
20     function Owned() {
21         contractOwner = msg.sender;
22     }
23 
24     /**
25     * @dev Owner check modifier
26     */
27     modifier onlyContractOwner() {
28         if (contractOwner == msg.sender) {
29             _;
30         }
31     }
32 
33     /**
34      * @dev Destroy contract and scrub a data
35      * @notice Only owner can call it
36      */
37     function destroy() onlyContractOwner {
38         suicide(msg.sender);
39     }
40 
41     /**
42      * Prepares ownership pass.
43      *
44      * Can only be called by current owner.
45      *
46      * @param _to address of the next owner. 0x0 is not allowed.
47      *
48      * @return success.
49      */
50     function changeContractOwnership(address _to) onlyContractOwner() returns(bool) {
51         if (_to  == 0x0) {
52             return false;
53         }
54 
55         pendingContractOwner = _to;
56         return true;
57     }
58 
59     /**
60      * Finalize ownership pass.
61      *
62      * Can only be called by pending owner.
63      *
64      * @return success.
65      */
66     function claimContractOwnership() returns(bool) {
67         if (pendingContractOwner != msg.sender) {
68             return false;
69         }
70 
71         contractOwner = pendingContractOwner;
72         delete pendingContractOwner;
73 
74         return true;
75     }
76 }
77 
78 contract ERC20Interface {
79     event Transfer(address indexed from, address indexed to, uint256 value);
80     event Approval(address indexed from, address indexed spender, uint256 value);
81     string public symbol;
82 
83     function totalSupply() constant returns (uint256 supply);
84     function balanceOf(address _owner) constant returns (uint256 balance);
85     function transfer(address _to, uint256 _value) returns (bool success);
86     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
87     function approve(address _spender, uint256 _value) returns (bool success);
88     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
89 }
90 
91 /**
92  * @title Generic owned destroyable contract
93  */
94 contract Object is Owned {
95     /**
96     *  Common result code. Means everything is fine.
97     */
98     uint constant OK = 1;
99     uint constant OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER = 8;
100 
101     function withdrawnTokens(address[] tokens, address _to) onlyContractOwner returns(uint) {
102         for(uint i=0;i<tokens.length;i++) {
103             address token = tokens[i];
104             uint balance = ERC20Interface(token).balanceOf(this);
105             if(balance != 0)
106                 ERC20Interface(token).transfer(_to,balance);
107         }
108         return OK;
109     }
110 
111     function checkOnlyContractOwner() internal constant returns(uint) {
112         if (contractOwner == msg.sender) {
113             return OK;
114         }
115 
116         return OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER;
117     }
118 }
119 
120 /**
121 * @title SafeMath
122 * @dev Math operations with safety checks that throw on error
123 */
124 library SafeMath {
125     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126         uint256 c = a * b;
127         assert(a == 0 || c / a == b);
128         return c;
129     }
130 
131     function div(uint256 a, uint256 b) internal pure returns (uint256) {
132         // assert(b > 0); // Solidity automatically throws when dividing by 0
133         uint256 c = a / b;
134         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
135         return c;
136     }
137 
138     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
139         assert(b <= a);
140         return a - b;
141     }
142 
143     function add(uint256 a, uint256 b) internal pure returns (uint256) {
144         uint256 c = a + b;
145         assert(c >= a);
146         return c;
147     }
148 }
149 
150 /// @title Provides possibility manage holders? country limits and limits for holders.
151 contract DataControllerInterface {
152 
153     /// @notice Checks user is holder.
154     /// @param _address - checking address.
155     /// @return `true` if _address is registered holder, `false` otherwise.
156     function isHolderAddress(address _address) public view returns (bool);
157 
158     function allowance(address _user) public view returns (uint);
159 
160     function changeAllowance(address _holder, uint _value) public returns (uint);
161 }
162 
163 /// @title ServiceController
164 ///
165 /// Base implementation
166 /// Serves for managing service instances
167 contract ServiceControllerInterface {
168 
169     /// @notice Check target address is service
170     /// @param _address target address
171     /// @return `true` when an address is a service, `false` otherwise
172     function isService(address _address) public view returns (bool);
173 }
174 
175 contract ATxAssetInterface {
176 
177     DataControllerInterface public dataController;
178     ServiceControllerInterface public serviceController;
179 
180     function __transferWithReference(address _to, uint _value, string _reference, address _sender) public returns (bool);
181     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public returns (bool);
182     function __approve(address _spender, uint _value, address _sender) public returns (bool);
183     function __process(bytes /*_data*/, address /*_sender*/) payable public {
184         revert();
185     }
186 }
187 
188 /// @title ServiceAllowance.
189 ///
190 /// Provides a way to delegate operation allowance decision to a service contract
191 contract ServiceAllowance {
192     function isTransferAllowed(address _from, address _to, address _sender, address _token, uint _value) public view returns (bool);
193 }
194 
195 
196 contract ERC20 {
197     event Transfer(address indexed from, address indexed to, uint256 value);
198     event Approval(address indexed from, address indexed spender, uint256 value);
199     string public symbol;
200 
201     function totalSupply() constant returns (uint256 supply);
202     function balanceOf(address _owner) constant returns (uint256 balance);
203     function transfer(address _to, uint256 _value) returns (bool success);
204     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
205     function approve(address _spender, uint256 _value) returns (bool success);
206     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
207 }
208 
209 
210 contract Platform {
211     mapping(bytes32 => address) public proxies;
212     function name(bytes32 _symbol) public view returns (string);
213     function setProxy(address _address, bytes32 _symbol) public returns (uint errorCode);
214     function isOwner(address _owner, bytes32 _symbol) public view returns (bool);
215     function totalSupply(bytes32 _symbol) public view returns (uint);
216     function balanceOf(address _holder, bytes32 _symbol) public view returns (uint);
217     function allowance(address _from, address _spender, bytes32 _symbol) public view returns (uint);
218     function baseUnit(bytes32 _symbol) public view returns (uint8);
219     function proxyTransferWithReference(address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public returns (uint errorCode);
220     function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public returns (uint errorCode);
221     function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) public returns (uint errorCode);
222     function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable) public returns (uint errorCode);
223     function reissueAsset(bytes32 _symbol, uint _value) public returns (uint errorCode);
224     function revokeAsset(bytes32 _symbol, uint _value) public returns (uint errorCode);
225     function isReissuable(bytes32 _symbol) public view returns (bool);
226     function changeOwnership(bytes32 _symbol, address _newOwner) public returns (uint errorCode);
227 }
228 
229 contract ATxAssetProxy is ERC20, Object, ServiceAllowance {
230 
231     using SafeMath for uint;
232 
233     /**
234      * Indicates an upgrade freeze-time start, and the next asset implementation contract.
235      */
236     event UpgradeProposal(address newVersion);
237 
238     // Current asset implementation contract address.
239     address latestVersion;
240 
241     // Assigned platform, immutable.
242     Platform public platform;
243 
244     // Assigned symbol, immutable.
245     bytes32 public smbl;
246 
247     // Assigned name, immutable.
248     string public name;
249 
250     /**
251      * Only platform is allowed to call.
252      */
253     modifier onlyPlatform() {
254         if (msg.sender == address(platform)) {
255             _;
256         }
257     }
258 
259     /**
260      * Only current asset owner is allowed to call.
261      */
262     modifier onlyAssetOwner() {
263         if (platform.isOwner(msg.sender, smbl)) {
264             _;
265         }
266     }
267 
268     /**
269      * Only asset implementation contract assigned to sender is allowed to call.
270      */
271     modifier onlyAccess(address _sender) {
272         if (getLatestVersion() == msg.sender) {
273             _;
274         }
275     }
276 
277     /**
278      * Resolves asset implementation contract for the caller and forwards there transaction data,
279      * along with the value. This allows for proxy interface growth.
280      */
281     function() public payable {
282         _getAsset().__process.value(msg.value)(msg.data, msg.sender);
283     }
284 
285     /**
286      * Sets platform address, assigns symbol and name.
287      *
288      * Can be set only once.
289      *
290      * @param _platform platform contract address.
291      * @param _symbol assigned symbol.
292      * @param _name assigned name.
293      *
294      * @return success.
295      */
296     function init(Platform _platform, string _symbol, string _name) public returns (bool) {
297         if (address(platform) != 0x0) {
298             return false;
299         }
300         platform = _platform;
301         symbol = _symbol;
302         smbl = stringToBytes32(_symbol);
303         name = _name;
304         return true;
305     }
306 
307     /**
308      * Returns asset total supply.
309      *
310      * @return asset total supply.
311      */
312     function totalSupply() public view returns (uint) {
313         return platform.totalSupply(smbl);
314     }
315 
316     /**
317      * Returns asset balance for a particular holder.
318      *
319      * @param _owner holder address.
320      *
321      * @return holder balance.
322      */
323     function balanceOf(address _owner) public view returns (uint) {
324         return platform.balanceOf(_owner, smbl);
325     }
326 
327     /**
328      * Returns asset allowance from one holder to another.
329      *
330      * @param _from holder that allowed spending.
331      * @param _spender holder that is allowed to spend.
332      *
333      * @return holder to spender allowance.
334      */
335     function allowance(address _from, address _spender) public view returns (uint) {
336         return platform.allowance(_from, _spender, smbl);
337     }
338 
339     /**
340      * Returns asset decimals.
341      *
342      * @return asset decimals.
343      */
344     function decimals() public view returns (uint8) {
345         return platform.baseUnit(smbl);
346     }
347 
348     /**
349      * Transfers asset balance from the caller to specified receiver.
350      *
351      * @param _to holder address to give to.
352      * @param _value amount to transfer.
353      *
354      * @return success.
355      */
356     function transfer(address _to, uint _value) public returns (bool) {
357         if (_to != 0x0) {
358             return _transferWithReference(_to, _value, "");
359         }
360         else {
361             return false;
362         }
363     }
364 
365     /**
366      * Transfers asset balance from the caller to specified receiver adding specified comment.
367      *
368      * @param _to holder address to give to.
369      * @param _value amount to transfer.
370      * @param _reference transfer comment to be included in a platform's Transfer event.
371      *
372      * @return success.
373      */
374     function transferWithReference(address _to, uint _value, string _reference) public returns (bool) {
375         if (_to != 0x0) {
376             return _transferWithReference(_to, _value, _reference);
377         }
378         else {
379             return false;
380         }
381     }
382 
383     /**
384      * Performs transfer call on the platform by the name of specified sender.
385      *
386      * Can only be called by asset implementation contract assigned to sender.
387      *
388      * @param _to holder address to give to.
389      * @param _value amount to transfer.
390      * @param _reference transfer comment to be included in a platform's Transfer event.
391      * @param _sender initial caller.
392      *
393      * @return success.
394      */
395     function __transferWithReference(address _to, uint _value, string _reference, address _sender) public onlyAccess(_sender) returns (bool) {
396         return platform.proxyTransferWithReference(_to, _value, smbl, _reference, _sender) == OK;
397     }
398 
399     /**
400      * Prforms allowance transfer of asset balance between holders.
401      *
402      * @param _from holder address to take from.
403      * @param _to holder address to give to.
404      * @param _value amount to transfer.
405      *
406      * @return success.
407      */
408     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
409         if (_to != 0x0) {
410             return _getAsset().__transferFromWithReference(_from, _to, _value, "", msg.sender);
411         }
412         else {
413             return false;
414         }
415     }
416 
417     /**
418      * Performs allowance transfer call on the platform by the name of specified sender.
419      *
420      * Can only be called by asset implementation contract assigned to sender.
421      *
422      * @param _from holder address to take from.
423      * @param _to holder address to give to.
424      * @param _value amount to transfer.
425      * @param _reference transfer comment to be included in a platform's Transfer event.
426      * @param _sender initial caller.
427      *
428      * @return success.
429      */
430     function __transferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public onlyAccess(_sender) returns (bool) {
431         return platform.proxyTransferFromWithReference(_from, _to, _value, smbl, _reference, _sender) == OK;
432     }
433 
434     /**
435      * Sets asset spending allowance for a specified spender.
436      *
437      * @param _spender holder address to set allowance to.
438      * @param _value amount to allow.
439      *
440      * @return success.
441      */
442     function approve(address _spender, uint _value) public returns (bool) {
443         if (_spender != 0x0) {
444             return _getAsset().__approve(_spender, _value, msg.sender);
445         }
446         else {
447             return false;
448         }
449     }
450 
451     /**
452      * Performs allowance setting call on the platform by the name of specified sender.
453      *
454      * Can only be called by asset implementation contract assigned to sender.
455      *
456      * @param _spender holder address to set allowance to.
457      * @param _value amount to allow.
458      * @param _sender initial caller.
459      *
460      * @return success.
461      */
462     function __approve(address _spender, uint _value, address _sender) public onlyAccess(_sender) returns (bool) {
463         return platform.proxyApprove(_spender, _value, smbl, _sender) == OK;
464     }
465 
466     /**
467      * Emits ERC20 Transfer event on this contract.
468      *
469      * Can only be, and, called by assigned platform when asset transfer happens.
470      */
471     function emitTransfer(address _from, address _to, uint _value) public onlyPlatform() {
472         Transfer(_from, _to, _value);
473     }
474 
475     /**
476      * Emits ERC20 Approval event on this contract.
477      *
478      * Can only be, and, called by assigned platform when asset allowance set happens.
479      */
480     function emitApprove(address _from, address _spender, uint _value) public onlyPlatform() {
481         Approval(_from, _spender, _value);
482     }
483 
484     /**
485      * Returns current asset implementation contract address.
486      *
487      * @return asset implementation contract address.
488      */
489     function getLatestVersion() public view returns (address) {
490         return latestVersion;
491     }
492 
493     /**
494      * Propose next asset implementation contract address.
495      *
496      * Can only be called by current asset owner.
497      *
498      * Note: freeze-time should not be applied for the initial setup.
499      *
500      * @param _newVersion asset implementation contract address.
501      *
502      * @return success.
503      */
504     function proposeUpgrade(address _newVersion) public onlyAssetOwner returns (bool) {
505         // New version address should be other than 0x0.
506         if (_newVersion == 0x0) {
507             return false;
508         }
509         
510         latestVersion = _newVersion;
511 
512         UpgradeProposal(_newVersion); 
513         return true;
514     }
515 
516     function isTransferAllowed(address, address, address, address, uint) public view returns (bool) {
517         return true;
518     }
519 
520     /**
521      * Returns asset implementation contract for current caller.
522      *
523      * @return asset implementation contract.
524      */
525     function _getAsset() internal view returns (ATxAssetInterface) {
526         return ATxAssetInterface(getLatestVersion());
527     }
528 
529     /**
530      * Resolves asset implementation contract for the caller and forwards there arguments along with
531      * the caller address.
532      *
533      * @return success.
534      */
535     function _transferWithReference(address _to, uint _value, string _reference) internal returns (bool) {
536         return _getAsset().__transferWithReference(_to, _value, _reference, msg.sender);
537     }
538 
539     function stringToBytes32(string memory source) private pure returns (bytes32 result) {
540         assembly {
541             result := mload(add(source, 32))
542         }
543     }
544 }