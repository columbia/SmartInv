1 pragma solidity >=0.5.7 <0.6.0;
2 
3 /*
4 *  xEuro.sol
5 *  xEUR tokens smart contract
6 *  implements [ERC-20 Token Standard](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md)
7 *  ver. 1.0.0
8 *  2019-04-15
9 *  https://xeuro.online
10 *  https://etherscan.io/address/0xC31C61cf55fB5E646684AD8E8517793ec9A22c5e
11 *  deployed on block: 7571826
12 *  solc version :  0.5.7+commit.6da8b019
13 **/
14 
15 /**
16  * @title SafeMath
17  * @dev Unsigned math operations with safety checks that revert on error
18  */
19 library SafeMath {
20     /**
21      * @dev Multiplies two unsigned integers, reverts on overflow.
22      */
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
25         // benefit is lost if 'b' is also tested.
26         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
27         if (a == 0) {
28             return 0;
29         }
30         uint256 c = a * b;
31         require(c / a == b);
32         return c;
33     }
34 
35     /**
36      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
37      */
38     function div(uint256 a, uint256 b) internal pure returns (uint256) {
39         // Solidity only automatically asserts when dividing by 0
40         require(b > 0);
41         uint256 c = a / b;
42         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43         return c;
44     }
45 
46     /**
47      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
48      */
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         require(b <= a);
51         uint256 c = a - b;
52         return c;
53     }
54 
55     /**
56      * @dev Adds two unsigned integers, reverts on overflow.
57      */
58     function add(uint256 a, uint256 b) internal pure returns (uint256) {
59         uint256 c = a + b;
60         require(c >= a);
61         return c;
62     }
63 
64     /**
65      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
66      * reverts when dividing by zero.
67      */
68     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b != 0);
70         return a % b;
71     }
72 }
73 
74 /* "Interfaces" */
75 
76 // see: https://github.com/ethereum/EIPs/issues/677
77 contract tokenRecipient {
78     function tokenFallback(address _from, uint256 _value, bytes memory _extraData) public returns (bool);
79 }
80 
81 contract xEuro {
82 
83     // see: https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/BasicToken.sol
84     using SafeMath for uint256;
85 
86     /* --- ERC-20 variables ----- */
87 
88     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#name
89     // function name() constant returns (string name)
90     string public name = "xEuro";
91 
92     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#symbol
93     // function symbol() constant returns (string symbol)
94     string public symbol = "xEUR";
95 
96     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#decimals
97     // function decimals() constant returns (uint8 decimals)
98     uint8 public decimals = 0; // 1 token = €1, no smaller unit
99 
100     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#totalsupply
101     // function totalSupply() constant returns (uint256 totalSupply)
102     // we start with zero
103     uint256 public totalSupply = 0;
104 
105     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#balanceof
106     // function balanceOf(address _owner) constant returns (uint256 balance)
107     mapping(address => uint256) public balanceOf;
108 
109     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#allowance
110     // function allowance(address _owner, address _spender) constant returns (uint256 remaining)
111     mapping(address => mapping(address => uint256)) public allowance;
112 
113     /* --- administrative variables  */
114 
115     // admins
116     mapping(address => bool) public isAdmin;
117 
118     // addresses allowed to mint tokens:
119     mapping(address => bool) public canMint;
120 
121     // addresses allowed to transfer tokens from contract's own address:
122     mapping(address => bool) public canTransferFromContract;
123 
124     // addresses allowed to burn tokens (on contract's own address):
125     mapping(address => bool) public canBurn;
126 
127     /* ---------- Constructor */
128     // do not forget about:
129     // https://medium.com/@codetractio/a-look-into-paritys-multisig-wallet-bug-affecting-100-million-in-ether-and-tokens-356f5ba6e90a
130     constructor() public {// Constructor must be public or internal
131         isAdmin[msg.sender] = true;
132         canMint[msg.sender] = true;
133         canTransferFromContract[msg.sender] = true;
134         canBurn[msg.sender] = true;
135     }
136 
137     /* --- ERC-20 events */
138     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#events
139 
140     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transfer-1
141     event Transfer(address indexed from, address indexed to, uint256 value);
142 
143     /* --- Interaction with other contracts events */
144     event DataSentToAnotherContract(address indexed _from, address indexed _toContract, bytes _extraData);
145 
146     /* --- ERC-20 Functions */
147     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#methods
148 
149     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transfer
150     function transfer(address _to, uint256 _value) public returns (bool){
151         return transferFrom(msg.sender, _to, _value);
152     }
153 
154     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transferfrom
155     function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
156 
157         // Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event (ERC-20)
158         require(_value >= 0);
159 
160         // The function SHOULD throw unless the _from account has deliberately authorized the sender of the message via some mechanism
161         require(msg.sender == _from || _value <= allowance[_from][msg.sender] || (_from == address(this) && canTransferFromContract[msg.sender]));
162 
163         // check if _from account have required amount
164         require(_value <= balanceOf[_from]);
165 
166         if (_to == address(this)) {
167             // (!) only token holder can send tokens to smart contract to get fiat, not using allowance
168             require(_from == msg.sender);
169         }
170 
171         balanceOf[_from] = balanceOf[_from].sub(_value);
172         balanceOf[_to] = balanceOf[_to].add(_value);
173 
174         // If allowance used, change allowances correspondingly
175         if (_from != msg.sender && _from != address(this)) {
176             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
177         }
178 
179         if (_to == address(this) && _value > 0) {
180 
181             require(_value >= minExchangeAmount);
182 
183             tokensInEventsCounter++;
184             tokensInTransfer[tokensInEventsCounter].from = _from;
185             tokensInTransfer[tokensInEventsCounter].value = _value;
186             tokensInTransfer[tokensInEventsCounter].receivedOn = now;
187 
188             emit TokensIn(
189                 _from,
190                 _value,
191                 tokensInEventsCounter
192             );
193         }
194 
195         emit Transfer(_from, _to, _value);
196 
197         return true;
198     }
199 
200     /*  ---------- Interaction with other contracts  */
201 
202     /* https://github.com/ethereum/EIPs/issues/677
203     * transfer tokens with additional info to another smart contract, and calls its correspondent function
204     * @param address _to - another smart contract address
205     * @param uint256 _value - number of tokens
206     * @param bytes _extraData - data to send to another contract
207     * > this may be used to convert pre-ICO tokens to ICO tokens
208     */
209     function transferAndCall(address _to, uint256 _value, bytes memory _extraData) public returns (bool){
210 
211         tokenRecipient receiver = tokenRecipient(_to);
212 
213         if (transferFrom(msg.sender, _to, _value)) {
214 
215             if (receiver.tokenFallback(msg.sender, _value, _extraData)) {
216 
217                 emit DataSentToAnotherContract(msg.sender, _to, _extraData);
218 
219                 return true;
220 
221             }
222 
223         }
224         return false;
225     }
226 
227     // the same as above, but for all tokens on user account
228     // for example for converting ALL tokens of user account to another tokens
229     function transferAllAndCall(address _to, bytes memory _extraData) public returns (bool){
230         return transferAndCall(_to, balanceOf[msg.sender], _extraData);
231     }
232 
233     /* --- Administrative functions */
234 
235     /* --- isAdmin */
236     event AdminAdded(address indexed by, address indexed newAdmin);//
237     function addAdmin(address _newAdmin) public returns (bool){
238         require(isAdmin[msg.sender]);
239 
240         isAdmin[_newAdmin] = true;
241         emit AdminAdded(msg.sender, _newAdmin);
242         return true;
243     } //
244     event AdminRemoved(address indexed by, address indexed _oldAdmin);//
245     function removeAdmin(address _oldAdmin) public returns (bool){
246         require(isAdmin[msg.sender]);
247 
248         // prevents from deleting the last admin (can be multisig smart contract) by itself:
249         require(msg.sender != _oldAdmin);
250         isAdmin[_oldAdmin] = false;
251         emit AdminRemoved(msg.sender, _oldAdmin);
252         return true;
253     }
254 
255     uint256 minExchangeAmount = 12; // xEuro tokens
256     event minExchangeAmountChanged (address indexed by, uint256 from, uint256 to); //
257     function changeMinExchangeAmount(uint256 _minExchangeAmount) public returns (bool){
258         require(isAdmin[msg.sender]);
259 
260         uint256 from = minExchangeAmount;
261         minExchangeAmount = _minExchangeAmount;
262         emit minExchangeAmountChanged(msg.sender, from, minExchangeAmount);
263         return true;
264     }
265 
266     /* --- canMint */
267     event AddressAddedToCanMint(address indexed by, address indexed newAddress); //
268     function addToCanMint(address _newAddress) public returns (bool){
269         require(isAdmin[msg.sender]);
270 
271         canMint[_newAddress] = true;
272         emit AddressAddedToCanMint(msg.sender, _newAddress);
273         return true;
274     }//
275     event AddressRemovedFromCanMint(address indexed by, address indexed removedAddress);//
276     function removeFromCanMint(address _addressToRemove) public returns (bool){
277         require(isAdmin[msg.sender]);
278 
279         canMint[_addressToRemove] = false;
280         emit AddressRemovedFromCanMint(msg.sender, _addressToRemove);
281         return true;
282     }
283 
284     /* --- canTransferFromContract*/
285     event AddressAddedToCanTransferFromContract(address indexed by, address indexed newAddress); //
286     function addToCanTransferFromContract(address _newAddress) public returns (bool){
287         require(isAdmin[msg.sender]);
288 
289         canTransferFromContract[_newAddress] = true;
290         emit AddressAddedToCanTransferFromContract(msg.sender, _newAddress);
291         return true;
292     }//
293     event AddressRemovedFromCanTransferFromContract(address indexed by, address indexed removedAddress);//
294     function removeFromCanTransferFromContract(address _addressToRemove) public returns (bool){
295         require(isAdmin[msg.sender]);
296 
297         canTransferFromContract[_addressToRemove] = false;
298         emit AddressRemovedFromCanTransferFromContract(msg.sender, _addressToRemove);
299         return true;
300     }
301 
302     /* --- canBurn */
303     event AddressAddedToCanBurn(address indexed by, address indexed newAddress); //
304     function addToCanBurn(address _newAddress) public returns (bool){
305         require(isAdmin[msg.sender]);
306 
307         canBurn[_newAddress] = true;
308         emit AddressAddedToCanBurn(msg.sender, _newAddress);
309         return true;
310     }//
311     event AddressRemovedFromCanBurn(address indexed by, address indexed removedAddress);//
312     function removeFromCanBurn(address _addressToRemove) public returns (bool){
313         require(isAdmin[msg.sender]);
314 
315         canBurn[_addressToRemove] = false;
316         emit AddressRemovedFromCanBurn(msg.sender, _addressToRemove);
317         return true;
318     }
319 
320     /* ---------- Create and burn tokens  */
321 
322     /* -- Accounting: exchange fiat to tokens (fiat sent to our bank acc with eth acc in reference > tokens ) */
323     uint public mintTokensEventsCounter = 0;//
324     struct MintTokensEvent {
325         address mintedBy; //
326         uint256 fiatInPaymentId;
327         uint value;   //
328         uint on;    // UnixTime
329         uint currentTotalSupply;
330     } //
331     //  keep all fiat tx ids, to prevent minting tokens twice (or more times) for the same fiat tx
332     mapping(uint256 => bool) public fiatInPaymentIds;
333 
334     // here we can find a MintTokensEvent by fiatInPaymentId,
335     // so we now if tokens were minted for given incoming fiat payment
336     mapping(uint256 => MintTokensEvent) public fiatInPaymentsToMintTokensEvent;
337 
338     // here we store MintTokensEvent with its ordinal numbers
339     mapping(uint256 => MintTokensEvent) public mintTokensEvent; //
340     event TokensMinted(
341         address indexed by,
342         uint256 indexed fiatInPaymentId,
343         uint value,
344         uint currentTotalSupply,
345         uint indexed mintTokensEventsCounter
346     );
347 
348     // tokens should be minted to contracts own address, (!) after that tokens should be transferred using transferFrom
349     function mintTokens(uint256 value, uint256 fiatInPaymentId) public returns (bool){
350 
351         require(canMint[msg.sender]);
352 
353         // require that this fiatInPaymentId was not used before:
354         require(!fiatInPaymentIds[fiatInPaymentId]);
355 
356         require(value >= 0);
357         // <<< this is the moment when new tokens appear in the system
358         totalSupply = totalSupply.add(value);
359         // first token holder of fresh minted tokens is the contract itself
360         balanceOf[address(this)] = balanceOf[address(this)].add(value);
361 
362         mintTokensEventsCounter++;
363         mintTokensEvent[mintTokensEventsCounter].mintedBy = msg.sender;
364         mintTokensEvent[mintTokensEventsCounter].fiatInPaymentId = fiatInPaymentId;
365         mintTokensEvent[mintTokensEventsCounter].value = value;
366         mintTokensEvent[mintTokensEventsCounter].on = block.timestamp;
367         mintTokensEvent[mintTokensEventsCounter].currentTotalSupply = totalSupply;
368         //
369         fiatInPaymentsToMintTokensEvent[fiatInPaymentId] = mintTokensEvent[mintTokensEventsCounter];
370 
371         emit TokensMinted(msg.sender, fiatInPaymentId, value, totalSupply, mintTokensEventsCounter);
372 
373         fiatInPaymentIds[fiatInPaymentId] = true;
374 
375         return true;
376 
377     }
378 
379     // requires msg.sender be both 'canMint' and 'canTransferFromContract'
380     function mintAndTransfer(
381         uint256 _value,
382         uint256 fiatInPaymentId,
383         address _to
384     ) public returns (bool){
385 
386         if (mintTokens(_value, fiatInPaymentId) && transferFrom(address(this), _to, _value)) {
387             return true;
388         }
389         return false;
390     }
391 
392     /* -- Accounting: exchange tokens to fiat (tokens sent to contract owns address > fiat payment) */
393     uint public tokensInEventsCounter = 0;//
394     struct TokensInTransfer {// <<< used in 'transfer'
395         address from; //
396         uint value;   //
397         uint receivedOn; // UnixTime
398     } //
399     mapping(uint256 => TokensInTransfer) public tokensInTransfer; //
400     event TokensIn(
401         address indexed from,
402         uint256 value,
403         uint256 indexed tokensInEventsCounter
404     );//
405 
406     uint public burnTokensEventsCounter = 0;//
407     struct burnTokensEvent {
408         address by; //
409         uint256 value;   //
410         uint256 tokensInEventId;
411         uint256 fiatOutPaymentId;
412         uint256 burnedOn; // UnixTime
413         uint256 currentTotalSupply;
414     } //
415     mapping(uint => burnTokensEvent) public burnTokensEvents;
416 
417     // we count every fiat payment id used when burn tokens to prevent using it twice
418     mapping(uint256 => bool) public fiatOutPaymentIdsUsed; //
419 
420     event TokensBurned(
421         address indexed by,
422         uint256 value,
423         uint256 indexed tokensInEventId,
424         uint256 indexed fiatOutPaymentId,
425         uint burnedOn, // UnixTime
426         uint currentTotalSupply
427     );
428 
429     // (!) only contract's own tokens (balanceOf[this]) can be burned
430     function burnTokens(
431         uint256 value,
432         uint256 tokensInEventId,
433         uint256 fiatOutPaymentId
434     ) public returns (bool){
435 
436         require(canBurn[msg.sender]);
437 
438         require(value >= 0);
439         require(balanceOf[address(this)] >= value);
440 
441         // require(!tokensInEventIdsUsed[tokensInEventId]);
442         require(!fiatOutPaymentIdsUsed[fiatOutPaymentId]);
443 
444         balanceOf[address(this)] = balanceOf[address(this)].sub(value);
445         totalSupply = totalSupply.sub(value);
446 
447         burnTokensEventsCounter++;
448         burnTokensEvents[burnTokensEventsCounter].by = msg.sender;
449         burnTokensEvents[burnTokensEventsCounter].value = value;
450         burnTokensEvents[burnTokensEventsCounter].tokensInEventId = tokensInEventId;
451         burnTokensEvents[burnTokensEventsCounter].fiatOutPaymentId = fiatOutPaymentId;
452         burnTokensEvents[burnTokensEventsCounter].burnedOn = block.timestamp;
453         burnTokensEvents[burnTokensEventsCounter].currentTotalSupply = totalSupply;
454 
455         emit TokensBurned(msg.sender, value, tokensInEventId, fiatOutPaymentId, block.timestamp, totalSupply);
456 
457         fiatOutPaymentIdsUsed[fiatOutPaymentId];
458 
459         return true;
460     }
461 
462 }