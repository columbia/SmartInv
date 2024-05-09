1 // Pledge Mint contract by Culture Cubs
2 // pledgemint.io
3 
4 // SPDX-License-Identifier: MIT
5 
6 pragma solidity ^0.8.4;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 /**
29  * @dev Contract module which provides a basic access control mechanism, where
30  * there is an account (an owner) that can be granted exclusive access to
31  * specific functions.
32  *
33  * By default, the owner account will be the one that deploys the contract. This
34  * can later be changed with {transferOwnership}.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 abstract contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor() {
49         _transferOwnership(_msgSender());
50     }
51 
52     /**
53      * @dev Returns the address of the current owner.
54      */
55     function owner() public view virtual returns (address) {
56         return _owner;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(owner() == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     /**
68      * @dev Leaves the contract without owner. It will not be possible to call
69      * `onlyOwner` functions anymore. Can only be called by the current owner.
70      *
71      * NOTE: Renouncing ownership will leave the contract without an owner,
72      * thereby removing any functionality that is only available to the owner.
73      */
74     function renounceOwnership() public virtual onlyOwner {
75         _transferOwnership(address(0));
76     }
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Can only be called by the current owner.
81      */
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         _transferOwnership(newOwner);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Internal function without access restriction.
90      */
91     function _transferOwnership(address newOwner) internal virtual {
92         address oldOwner = _owner;
93         _owner = newOwner;
94         emit OwnershipTransferred(oldOwner, newOwner);
95     }
96 }
97 
98 /**
99  * @dev Contract module that helps prevent reentrant calls to a function.
100  *
101  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
102  * available, which can be applied to functions to make sure there are no nested
103  * (reentrant) calls to them.
104  *
105  * Note that because there is a single `nonReentrant` guard, functions marked as
106  * `nonReentrant` may not call one another. This can be worked around by making
107  * those functions `private`, and then adding `external` `nonReentrant` entry
108  * points to them.
109  *
110  * TIP: If you would like to learn more about reentrancy and alternative ways
111  * to protect against it, check out our blog post
112  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
113  */
114 abstract contract ReentrancyGuard {
115     // Booleans are more expensive than uint256 or any type that takes up a full
116     // word because each write operation emits an extra SLOAD to first read the
117     // slot's contents, replace the bits taken up by the boolean, and then write
118     // back. This is the compiler's defense against contract upgrades and
119     // pointer aliasing, and it cannot be disabled.
120 
121     // The values being non-zero value makes deployment a bit more expensive,
122     // but in exchange the refund on every call to nonReentrant will be lower in
123     // amount. Since refunds are capped to a percentage of the total
124     // transaction's gas, it is best to keep them low in cases like this one, to
125     // increase the likelihood of the full refund coming into effect.
126     uint256 private constant _NOT_ENTERED = 1;
127     uint256 private constant _ENTERED = 2;
128 
129     uint256 private _status;
130 
131     constructor() {
132         _status = _NOT_ENTERED;
133     }
134 
135     /**
136      * @dev Prevents a contract from calling itself, directly or indirectly.
137      * Calling a `nonReentrant` function from another `nonReentrant`
138      * function is not supported. It is possible to prevent this from happening
139      * by making the `nonReentrant` function external, and making it call a
140      * `private` function that does the actual work.
141      */
142     modifier nonReentrant() {
143         // On the first call to nonReentrant, _notEntered will be true
144         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
145 
146         // Any calls to nonReentrant after this point will fail
147         _status = _ENTERED;
148 
149         _;
150 
151         // By storing the original value once again, a refund is triggered (see
152         // https://eips.ethereum.org/EIPS/eip-2200)
153         _status = _NOT_ENTERED;
154     }
155 }
156 
157 interface IERC721Pledge {
158     function pledgeMint(address to, uint8 quantity)
159         external
160         payable;
161 }
162 
163 contract PledgeMint is Ownable, ReentrancyGuard {
164     // Phases allow to have different cohorts of pledgers, with different contracts, prices and limits.
165     struct PhaseConfig {
166         address admin;
167         IERC721Pledge mintContract;
168         uint256 mintPrice;
169         uint8 maxPerWallet;
170         // When locked, the contract on which the mint happens cannot ever be changed again
171         bool mintContractLocked;
172         // Can only be set to true if mint contract is locked, which is irreversible.
173         // Owner of the contract can still trigger refunds - but not access anyone's funds.
174         bool pledgesLocked;
175     }
176 
177 
178     mapping(uint16 => address[]) public pledgers;
179     mapping(uint16 => mapping(address => bool)) public allowlists;
180     mapping(uint16 => mapping(address => uint8)) public pledges;
181 
182     PhaseConfig[] public phases;
183 
184     modifier callerIsUser() {
185         require(tx.origin == msg.sender, "The caller is another contract");
186         _; 
187     }
188 
189     modifier onlyAdminOrOwner(uint16 phaseId) {
190         require(owner() == _msgSender() || phases[phaseId].admin == _msgSender(), "Ownable: caller is not the owner");
191         _;
192     }
193 
194     constructor() {}
195 
196     function addPhase(address admin, IERC721Pledge mintContract, uint256 mintPrice, uint8 maxPerWallet) external onlyOwner {
197         phases.push(PhaseConfig(admin, mintContract, mintPrice, maxPerWallet, false, false));
198     }
199 
200     function allowAddresses(uint16 phaseId, address[] calldata allowlist_) external onlyAdminOrOwner(phaseId) {
201         mapping(address => bool) storage _allowlist = allowlists[phaseId];
202         for (uint i=0; i < allowlist_.length; i++) {
203             _allowlist[allowlist_[i]] = true;
204         }
205     }
206 
207     function pledge(uint16 phaseId, uint8 number) external payable callerIsUser {
208         PhaseConfig memory phase = phases[phaseId];
209         require(number <= phase.maxPerWallet, "Cannot buy that many NFTs");
210         require(number > 0, "Need to buy at least one");
211         require(msg.value == phase.mintPrice * number, "Amount mismatch");
212         require(pledges[phaseId][msg.sender] == 0, "Already pledged");
213         pledgers[phaseId].push(msg.sender);
214         pledges[phaseId][msg.sender] = number;
215     }
216 
217     function unpledge(uint16 phaseId) external nonReentrant callerIsUser {
218         require(phases[phaseId].pledgesLocked == false, "Pledges are locked for this phase");
219 
220         uint nbPledged = pledges[phaseId][msg.sender];
221         require(nbPledged > 0, "Nothing pledged");
222         pledges[phaseId][msg.sender] = 0;
223 
224         (bool success, ) = msg.sender.call{value: phases[phaseId].mintPrice * nbPledged}("");
225         require(success, "Address: unable to send value, recipient may have reverted");
226     }
227 
228     function lockPhase(uint16 phaseId) external onlyAdminOrOwner(phaseId) {
229         require(phases[phaseId].mintContractLocked == true, "Cannot lock pledges without locking the mint contract");
230         phases[phaseId].pledgesLocked = true;
231     }
232 
233     function unlockPhase(uint16 phaseId) external onlyAdminOrOwner(phaseId) {
234         phases[phaseId].pledgesLocked = false;
235     }
236 
237     // mint for all participants
238     function mintPhase(uint16 phaseId) external onlyAdminOrOwner(phaseId) {
239         address[] memory _addresses = pledgers[phaseId];
240         _mintPhase(phaseId, _addresses, 0, _addresses.length);
241     }
242 
243     // mint for all participants, paginated
244     function mintPhase(uint16 phaseId, uint startIdx, uint length) external onlyAdminOrOwner(phaseId) {
245         address[] memory _addresses = pledgers[phaseId];
246         _mintPhase(phaseId, _addresses, startIdx, length);
247     }
248 
249     // mint for select participants
250     // internal function checks eligibility and pledged number.
251     function mintPhase(uint16 phaseId, address[] calldata selectPledgers) external onlyAdminOrOwner(phaseId) {
252         _mintPhase(phaseId, selectPledgers, 0, selectPledgers.length);
253     }
254 
255     function _mintPhase(uint16 phaseId, address[] memory addresses, uint startIdx, uint count) internal {
256         PhaseConfig memory _phase = phases[phaseId];
257         require(_phase.mintContractLocked == true, "Cannot launch the mint without locking the contract");
258         mapping(address => uint8) storage _pledges = pledges[phaseId];
259         mapping(address => bool) storage _allowlist = allowlists[phaseId];
260         for (uint i = startIdx; i < count; i++) {
261             address addy = addresses[i];
262             uint8 quantity = _pledges[addy];
263 
264             // Any address not allowed will have to withdraw their pledge manually. We skip them here.
265             if (_allowlist[addy] && quantity > 0) {
266                 _pledges[addy] = 0;
267                 _phase.mintContract.pledgeMint{ value: _phase.mintPrice * quantity }(addy, quantity);
268             }
269         }
270     }
271 
272     function refundPhase(uint16 phaseId) external onlyAdminOrOwner(phaseId) nonReentrant {
273         _refundPhase(phaseId);
274     }
275 
276     function refundAll() external onlyOwner nonReentrant {
277         for (uint8 i=0; i < phases.length; i++) {
278             _refundPhase(i);
279         }
280     }
281 
282     function refundPhasePledger(uint16 phaseId, address pledger) external onlyAdminOrOwner(phaseId) nonReentrant {
283         uint amount = pledges[phaseId][pledger] * phases[phaseId].mintPrice;
284         pledges[phaseId][pledger] = 0;
285         (bool success, ) = pledger.call{value: amount}("");
286         require(success, "Address: unable to send value, recipient may have reverted");
287     }
288 
289     function _refundPhase(uint16 phaseId) internal {
290         PhaseConfig memory _phase = phases[phaseId];
291         address[] storage _addresses = pledgers[phaseId];
292         for (uint8 i = 0; i < _addresses.length; i++) {
293             address addy = _addresses[i];
294             uint8 quantity = pledges[phaseId][addy];
295             pledges[phaseId][addy] = 0;
296             (bool success, ) = addy.call{value: _phase.mintPrice * quantity}("");
297             require(success, "Address: unable to send value, recipient may have reverted");
298         }
299     }
300 
301     function emergencyRefund(uint16 phaseId, uint startIdx, uint count) external onlyOwner {
302         PhaseConfig memory _phase = phases[phaseId];
303         for (uint i = startIdx; i < count; i++) {
304             address addy = pledgers[phaseId][i];
305             uint8 quantity = pledges[phaseId][addy];
306 
307             (bool success, ) = addy.call{value: _phase.mintPrice * quantity}("");
308             require(success, "Address: unable to send value, recipient may have reverted");
309         }
310     }
311 
312     function setMintContract(uint16 phaseId, IERC721Pledge mintContract_) external onlyOwner {
313         require(phases[phaseId].mintContractLocked != true, "Cannot change the contract anymore");
314         phases[phaseId].mintContract = mintContract_;
315     }
316 
317     // there is no unlock function. Once this is locked, funds pledged can only be used to mint on this contract, or refunded.
318     function lockMintContract(uint16 phaseId) external onlyOwner {
319         phases[phaseId].mintContractLocked = true;
320     }
321 }