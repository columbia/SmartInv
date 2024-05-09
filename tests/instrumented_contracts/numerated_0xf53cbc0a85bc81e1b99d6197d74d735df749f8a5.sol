1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title ERC20
5  * @dev ERC20 interface
6  */
7 contract ERC20 {
8     function balanceOf(address who) public constant returns (uint256);
9     function transfer(address to, uint256 value) public returns (bool);
10     function allowance(address owner, address spender) public constant returns (uint256);
11     function transferFrom(address from, address to, uint256 value) public returns (bool);
12     function approve(address spender, uint256 value) public returns (bool);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 /// @dev Crowdsale interface for Etheal Normal Sale, functions needed from outside.
18 contract iEthealSale {
19     bool public paused;
20     uint256 public minContribution;
21     uint256 public whitelistThreshold;
22     mapping (address => uint256) public stakes;
23     function setPromoBonus(address _investor, uint256 _value) public;
24     function buyTokens(address _beneficiary) public payable;
25     function depositEth(address _beneficiary, uint256 _time, bytes _whitelistSign) public payable;
26     function depositOffchain(address _beneficiary, uint256 _amount, uint256 _time) public;
27     function hasEnded() public constant returns (bool);
28 }
29 
30 
31 /**
32  * @title Ownable
33  * @dev The Ownable contract has an owner address, and provides basic authorization control
34  * functions, this simplifies the implementation of "user permissions".
35  */
36 contract Ownable {
37   address public owner;
38 
39 
40   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42 
43   /**
44    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45    * account.
46    */
47   function Ownable() {
48     owner = msg.sender;
49   }
50 
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address newOwner) onlyOwner public {
66     require(newOwner != address(0));
67     OwnershipTransferred(owner, newOwner);
68     owner = newOwner;
69   }
70 
71 }
72 
73 
74 
75 
76 /**
77  * @title SafeMath
78  * @dev Math operations with safety checks that throw on error
79  */
80 library SafeMath {
81   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82     uint256 c = a * b;
83     assert(a == 0 || c / a == b);
84     return c;
85   }
86 
87   function div(uint256 a, uint256 b) internal pure returns (uint256) {
88     // assert(b > 0); // Solidity automatically throws when dividing by 0
89     uint256 c = a / b;
90     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91     return c;
92   }
93 
94   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
95     assert(b <= a);
96     return a - b;
97   }
98 
99   function add(uint256 a, uint256 b) internal pure returns (uint256) {
100     uint256 c = a + b;
101     assert(c >= a);
102     return c;
103   }
104 }
105 
106 
107 
108 
109 
110 
111 /**
112  * @title claim accidentally sent tokens
113  */
114 contract HasNoTokens is Ownable {
115     event ExtractedTokens(address indexed _token, address indexed _claimer, uint _amount);
116 
117     /// @notice This method can be used to extract mistakenly
118     ///  sent tokens to this contract.
119     /// @param _token The address of the token contract that you want to recover
120     ///  set to 0 in case you want to extract ether.
121     /// @param _claimer Address that tokens will be send to
122     function extractTokens(address _token, address _claimer) onlyOwner public {
123         if (_token == 0x0) {
124             _claimer.transfer(this.balance);
125             return;
126         }
127 
128         ERC20 token = ERC20(_token);
129         uint balance = token.balanceOf(this);
130         token.transfer(_claimer, balance);
131         ExtractedTokens(_token, _claimer, balance);
132     }
133 }
134 
135 
136 
137 
138 
139 
140 /**
141  * @title Eliptic curve signature operations
142  *
143  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
144  */
145 
146 library ECRecovery {
147 
148   /**
149    * @dev Recover signer address from a message by using his signature
150    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
151    * @param sig bytes signature, the signature is generated using web3.eth.sign()
152    */
153   function recover(bytes32 hash, bytes sig) public pure returns (address) {
154     bytes32 r;
155     bytes32 s;
156     uint8 v;
157 
158     //Check the signature length
159     if (sig.length != 65) {
160       return (address(0));
161     }
162 
163     // Divide the signature in r, s and v variables
164     assembly {
165       r := mload(add(sig, 32))
166       s := mload(add(sig, 64))
167       v := byte(0, mload(add(sig, 96)))
168     }
169 
170     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
171     if (v < 27) {
172       v += 27;
173     }
174 
175     // If the version is correct return the signer address
176     if (v != 27 && v != 28) {
177       return (address(0));
178     } else {
179       return ecrecover(hash, v, r, s);
180     }
181   }
182 
183 }
184 
185 /**
186  * @title EthealWhitelist
187  * @author thesved
188  * @notice EthealWhitelist contract which handles KYC
189  */
190 contract EthealWhitelist is Ownable {
191     using ECRecovery for bytes32;
192 
193     // signer address for offchain whitelist signing
194     address public signer;
195 
196     // storing whitelisted addresses
197     mapping(address => bool) public isWhitelisted;
198 
199     event WhitelistSet(address indexed _address, bool _state);
200 
201     ////////////////
202     // Constructor
203     ////////////////
204     function EthealWhitelist(address _signer) {
205         require(_signer != address(0));
206 
207         signer = _signer;
208     }
209 
210     /// @notice set signing address after deployment
211     function setSigner(address _signer) public onlyOwner {
212         require(_signer != address(0));
213 
214         signer = _signer;
215     }
216 
217     ////////////////
218     // Whitelisting: only owner
219     ////////////////
220 
221     /// @notice Set whitelist state for an address.
222     function setWhitelist(address _addr, bool _state) public onlyOwner {
223         require(_addr != address(0));
224         isWhitelisted[_addr] = _state;
225         WhitelistSet(_addr, _state);
226     }
227 
228     /// @notice Set whitelist state for multiple addresses
229     function setManyWhitelist(address[] _addr, bool _state) public onlyOwner {
230         for (uint256 i = 0; i < _addr.length; i++) {
231             setWhitelist(_addr[i], _state);
232         }
233     }
234 
235     /// @notice offchain whitelist check
236     function isOffchainWhitelisted(address _addr, bytes _sig) public view returns (bool) {
237         bytes32 hash = keccak256("\x19Ethereum Signed Message:\n20",_addr);
238         return hash.recover(_sig) == signer;
239     }
240 }
241 
242 
243 /**
244  * @title EthealDeposit
245  * @author thesved
246  * @dev This contract is used for storing funds while doing Whitelist
247  */
248 contract EthealDeposit is Ownable, HasNoTokens {
249     using SafeMath for uint256;
250 
251     // storing deposits: make sure they fit in 2 x 32 byte
252     struct Deposit {
253         uint256 amount;         // 32 byte
254         address beneficiary;    // 20 byte
255         uint64 time;            // 8 byte
256         bool cleared;           // 1 bit
257     }
258     uint256 public transactionCount;
259     uint256 public pendingCount;
260     mapping (uint256 => Deposit) public transactions;    // store transactions
261     mapping (address => uint256[]) public addressTransactions;  // store transaction ids for addresses
262     
263     // sale contract to which we forward funds
264     iEthealSale public sale;
265     EthealWhitelist public whitelist;
266 
267     event LogDeposited(address indexed beneficiary, uint256 weiAmount, uint256 id);
268     event LogRefunded(address indexed beneficiary, uint256 weiAmount, uint256 id);
269     event LogForwarded(address indexed beneficiary, uint256 weiAmount, uint256 id);
270 
271     ////////////////
272     // Constructor
273     ////////////////
274 
275     /// @notice Etheal deposit constructor
276     /// @param _sale address of sale contract
277     /// @param _whitelist address of whitelist contract
278     function EthealDeposit(address _sale, address _whitelist) {
279         require(_sale != address(0));
280         sale = iEthealSale(_sale);
281         whitelist = EthealWhitelist(_whitelist);
282     }
283 
284     /// @notice Set sale contract address
285     function setSale(address _sale) public onlyOwner {
286         sale = iEthealSale(_sale);
287     }
288 
289     /// @notice Set whitelist contract address
290     function setWhitelist(address _whitelist) public onlyOwner {
291         whitelist = EthealWhitelist(_whitelist);
292     }
293 
294     /// @dev Override HasNoTokens#extractTokens to not be able to extract tokens until saleEnd and everyone got their funds back
295     function extractTokens(address _token, address _claimer) public onlyOwner saleEnded {
296         require(pendingCount == 0);
297 
298         super.extractTokens(_token, _claimer);
299     }
300 
301 
302     ////////////////
303     // Deposit, forward, refund
304     ////////////////
305 
306     modifier whitelistSet() {
307         require(address(whitelist) != address(0));
308         _;
309     }
310 
311     modifier saleNotEnded() {
312         require(address(sale) != address(0) && !sale.hasEnded());
313         _;
314     }
315 
316     modifier saleNotPaused() {
317         require(address(sale) != address(0) && !sale.paused());
318         _;
319     }
320 
321     modifier saleEnded() {
322         require(address(sale) != address(0) && sale.hasEnded());
323         _;
324     }
325 
326     /// @notice payable fallback calls the deposit function
327     function() public payable {
328         deposit(msg.sender, "");
329     }
330 
331     /// @notice depositing for investor, return transaction Id
332     /// @param _investor address of investor
333     /// @param _whitelistSign offchain whitelist signiture for address, optional
334     function deposit(address _investor, bytes _whitelistSign) public payable whitelistSet saleNotEnded returns (uint256) {
335         require(_investor != address(0));
336         require(msg.value > 0);
337         require(msg.value >= sale.minContribution());
338 
339         uint256 transactionId = addTransaction(_investor, msg.value);
340 
341         // forward transaction automatically if whitelist is okay, so the transaction doesnt revert
342         if (whitelist.isWhitelisted(_investor) 
343             || whitelist.isOffchainWhitelisted(_investor, _whitelistSign) 
344             || sale.whitelistThreshold() >= sale.stakes(_investor).add(msg.value)
345         ) {
346             // only forward if sale is not paused
347             if (!sale.paused()) {
348                 forwardTransactionInternal(transactionId, _whitelistSign);
349             }
350         }
351 
352         return transactionId;
353     }
354 
355     /// @notice forwarding a transaction
356     function forwardTransaction(uint256 _id, bytes _whitelistSign) public whitelistSet saleNotEnded saleNotPaused {
357         require(forwardTransactionInternal(_id, _whitelistSign));
358     }
359 
360     /// @notice forwarding multiple transactions: check whitelist
361     function forwardManyTransaction(uint256[] _ids) public whitelistSet saleNotEnded saleNotPaused {
362         uint256 _threshold = sale.whitelistThreshold();
363 
364         for (uint256 i=0; i<_ids.length; i++) {
365             // only forward if it is within threshold or whitelisted, so the transaction doesnt revert
366             if ( whitelist.isWhitelisted(transactions[_ids[i]].beneficiary) 
367                 || _threshold >= sale.stakes(transactions[_ids[i]].beneficiary).add(transactions[_ids[i]].amount )
368             ) {
369                 forwardTransactionInternal(_ids[i],"");
370             }
371         }
372     }
373 
374     /// @notice forwarding transactions for an investor
375     function forwardInvestorTransaction(address _investor, bytes _whitelistSign) public whitelistSet saleNotEnded saleNotPaused {
376         bool _whitelisted = whitelist.isWhitelisted(_investor) || whitelist.isOffchainWhitelisted(_investor, _whitelistSign);
377         uint256 _amount = sale.stakes(_investor);
378         uint256 _threshold = sale.whitelistThreshold();
379 
380         for (uint256 i=0; i<addressTransactions[_investor].length; i++) {
381             _amount = _amount.add(transactions[ addressTransactions[_investor][i] ].amount);
382             // only forward if it is within threshold or whitelisted, so the transaction doesnt revert
383             if (_whitelisted || _threshold >= _amount) {
384                 forwardTransactionInternal(addressTransactions[_investor][i], _whitelistSign);
385             }
386         }
387     }
388 
389     /// @notice refunding a transaction
390     function refundTransaction(uint256 _id) public saleEnded {
391         require(refundTransactionInternal(_id));
392     }
393 
394     /// @notice refunding multiple transactions
395     function refundManyTransaction(uint256[] _ids) public saleEnded {
396         for (uint256 i=0; i<_ids.length; i++) {
397             refundTransactionInternal(_ids[i]);
398         }
399     }
400 
401     /// @notice refunding an investor
402     function refundInvestor(address _investor) public saleEnded {
403         for (uint256 i=0; i<addressTransactions[_investor].length; i++) {
404             refundTransactionInternal(addressTransactions[_investor][i]);
405         }
406     }
407 
408 
409     ////////////////
410     // Internal functions
411     ////////////////
412 
413     /// @notice add transaction and returns its id
414     function addTransaction(address _investor, uint256 _amount) internal returns (uint256) {
415         uint256 transactionId = transactionCount;
416 
417         // save transaction
418         transactions[transactionId] = Deposit({
419             amount: _amount,
420             beneficiary: _investor,
421             time: uint64(now),
422             cleared : false
423         });
424 
425         // save transactionId for investor address
426         addressTransactions[_investor].push(transactionId);
427 
428         transactionCount = transactionCount.add(1);
429         pendingCount = pendingCount.add(1);
430         LogDeposited(_investor, _amount, transactionId);
431 
432         return transactionId;
433     }
434 
435     /// @notice Forwarding a transaction, internal function, doesn't check sale status for speed up mass actions.
436     /// @return whether forward was successful or not
437     function forwardTransactionInternal(uint256 _id, bytes memory _whitelistSign) internal returns (bool) {
438         require(_id < transactionCount);
439 
440         // if already cleared then return false
441         if (transactions[_id].cleared) {
442             return false;
443         }
444 
445         // fixing bytes data to argument call data: data -> {data position}{data length}data
446         bytes memory _whitelistCall = bytesToArgument(_whitelistSign, 96);
447 
448         // forwarding transaction to sale contract
449         if (! sale.call.value(transactions[_id].amount)(bytes4(keccak256('depositEth(address,uint256,bytes)')), transactions[_id].beneficiary, uint256(transactions[_id].time), _whitelistCall) ) {
450             return false;
451         }
452         transactions[_id].cleared = true;
453 
454         pendingCount = pendingCount.sub(1);
455         LogForwarded(transactions[_id].beneficiary, transactions[_id].amount, _id);
456 
457         return true;
458     }
459 
460     /// @dev Fixing low level call for providing signature information: create proper padding for bytes information
461     function bytesToArgument(bytes memory _sign, uint256 _position) internal pure returns (bytes memory c) {
462         uint256 signLength = _sign.length;
463         uint256 totalLength = signLength.add(64);
464         uint256 loopMax = signLength.add(31).div(32);
465         assembly {
466             let m := mload(0x40)
467             mstore(m, totalLength)          // store the total length
468             mstore(add(m,32), _position)    // where does the data start
469             mstore(add(m,64), signLength)   // store the length of signature
470             for {  let i := 0 } lt(i, loopMax) { i := add(1, i) } { mstore(add(m, mul(32, add(3, i))), mload(add(_sign, mul(32, add(1, i))))) }
471             mstore(0x40, add(m, add(32, totalLength)))
472             c := m
473         }
474     }
475 
476     /// @notice Send back non-cleared transactions after sale is over, not checking status for speeding up mass actions
477     function refundTransactionInternal(uint256 _id) internal returns (bool) {
478         require(_id < transactionCount);
479 
480         // if already cleared then return false
481         if (transactions[_id].cleared) {
482             return false;
483         }
484 
485         // sending back funds
486         transactions[_id].cleared = true;
487         transactions[_id].beneficiary.transfer(transactions[_id].amount);
488 
489         pendingCount = pendingCount.sub(1);
490         LogRefunded(transactions[_id].beneficiary, transactions[_id].amount, _id);
491 
492         return true;
493     }
494 
495 
496     ////////////////
497     // External functions
498     ////////////////
499 
500     /// @notice gives back transaction ids based on filtering
501     function getTransactionIds(uint256 from, uint256 to, bool _cleared, bool _nonCleared) view external returns (uint256[] ids) {
502         uint256 i = 0;
503         uint256 results = 0;
504         uint256[] memory _ids = new uint256[](transactionCount);
505 
506         // search in contributors
507         for (i = 0; i < transactionCount; i++) {
508             if (_cleared && transactions[i].cleared || _nonCleared && !transactions[i].cleared) {
509                 _ids[results] = i;
510                 results++;
511             }
512         }
513 
514         ids = new uint256[](results);
515         for (i = from; i <= to && i < results; i++) {
516             ids[i] = _ids[i];
517         }
518 
519         return ids;
520     }
521 }