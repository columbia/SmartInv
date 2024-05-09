1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal constant returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal constant returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39     address public owner;
40 
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44 
45     /**
46      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47      * account.
48      */
49     function Ownable() {
50         owner = msg.sender;
51     }
52 
53 
54     /**
55      * @dev Throws if called by any account other than the owner.
56      */
57     modifier onlyOwner() {
58         require(msg.sender == owner);
59         _;
60     }
61 
62 
63     /**
64      * @dev Allows the current owner to transfer control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function transferOwnership(address newOwner) onlyOwner public {
68         require(newOwner != address(0));
69         OwnershipTransferred(owner, newOwner);
70         owner = newOwner;
71     }
72 
73 }
74 
75 /**
76  * @title RefundVault
77  * @dev This contract is used for storing funds while a crowdsale
78  * is in progress. Supports refunding the money if crowdsale fails,
79  * and forwarding it if crowdsale is successful.
80  */
81 contract RefundVault is Ownable {
82     using SafeMath for uint256;
83 
84     enum State { Active, Refunding, Closed }
85 
86     mapping (address => uint256) public deposited;
87     address public wallet;
88     State public state;
89 
90     event Closed();
91     event RefundsEnabled();
92     event Refunded(address indexed beneficiary, uint256 weiAmount);
93 
94     function RefundVault(address _wallet) {
95         require(_wallet != 0x0);
96         wallet = _wallet;
97         state = State.Active;
98     }
99 
100     function deposit(address investor) onlyOwner public payable {
101         require(state == State.Active);
102         deposited[investor] = deposited[investor].add(msg.value);
103     }
104 
105     function close() onlyOwner public {
106         require(state == State.Active);
107         state = State.Closed;
108         Closed();
109         wallet.transfer(this.balance);
110     }
111 
112     function enableRefunds() onlyOwner public {
113         require(state == State.Active);
114         state = State.Refunding;
115         RefundsEnabled();
116     }
117 
118     function refund(address investor) public {
119         require(state == State.Refunding);
120         uint256 depositedValue = deposited[investor];
121         deposited[investor] = 0;
122         investor.transfer(depositedValue);
123         Refunded(investor, depositedValue);
124     }
125 }
126 
127 
128 /**
129  * @title ERC20Basic
130  * @dev Simpler version of ERC20 interface
131  * @dev see https://github.com/ethereum/EIPs/issues/179
132  */
133 contract ERC20Basic {
134     uint256 public totalSupply;
135     function balanceOf(address who) constant returns (uint256);
136     function transfer(address to, uint256 value) returns (bool);
137     event Transfer(address indexed from, address indexed to, uint256 value);
138 }
139 
140 
141 /**
142  * @title ERC20 interface
143  * @dev see https://github.com/ethereum/EIPs/issues/20
144  */
145 contract ERC20 is ERC20Basic {
146     function allowance(address owner, address spender) constant returns (uint256);
147     function transferFrom(address from, address to, uint256 value) returns (bool);
148     function approve(address spender, uint256 value) returns (bool);
149     event Approval(address indexed owner, address indexed spender, uint256 value);
150 }
151 
152 
153 /**
154  * @title Basic token
155  * @dev Basic version of StandardToken, with no allowances.
156  */
157 contract BasicToken is ERC20Basic {
158     using SafeMath for uint256;
159 
160     mapping(address => uint256) balances;
161 
162     /**
163     * @dev transfer token for a specified address
164     * @param _to The address to transfer to.
165     * @param _value The amount to be transferred.
166     */
167     function transfer(address _to, uint256 _value) returns (bool) {
168         balances[msg.sender] = balances[msg.sender].sub(_value);
169         balances[_to] = balances[_to].add(_value);
170         Transfer(msg.sender, _to, _value);
171         return true;
172     }
173 
174     /**
175     * @dev Gets the balance of the specified address.
176     * @param _owner The address to query the the balance of.
177     * @return An uint256 representing the amount owned by the passed address.
178     */
179     function balanceOf(address _owner) constant returns (uint256 balance) {
180         return balances[_owner];
181     }
182 
183 }
184 
185 /**
186  * @title Standard ERC20 token
187  *
188  * @dev Implementation of the basic standard token.
189  * @dev https://github.com/ethereum/EIPs/issues/20
190  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
191  */
192 contract StandardToken is ERC20, BasicToken {
193 
194     mapping (address => mapping (address => uint256)) internal allowed;
195 
196 
197     /**
198      * @dev Transfer tokens from one address to another
199      * @param _from address The address which you want to send tokens from
200      * @param _to address The address which you want to transfer to
201      * @param _value uint256 the amount of tokens to be transferred
202      */
203     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
204         require(_to != address(0));
205         require(_value <= balances[_from]);
206         require(_value <= allowed[_from][msg.sender]);
207 
208         balances[_from] = balances[_from].sub(_value);
209         balances[_to] = balances[_to].add(_value);
210         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
211         Transfer(_from, _to, _value);
212         return true;
213     }
214 
215     /**
216      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
217      *
218      * Beware that changing an allowance with this method brings the risk that someone may use both the old
219      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
220      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
221      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222      * @param _spender The address which will spend the funds.
223      * @param _value The amount of tokens to be spent.
224      */
225     function approve(address _spender, uint256 _value) public returns (bool) {
226         allowed[msg.sender][_spender] = _value;
227         Approval(msg.sender, _spender, _value);
228         return true;
229     }
230 
231     /**
232      * @dev Function to check the amount of tokens that an owner allowed to a spender.
233      * @param _owner address The address which owns the funds.
234      * @param _spender address The address which will spend the funds.
235      * @return A uint256 specifying the amount of tokens still available for the spender.
236      */
237     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
238         return allowed[_owner][_spender];
239     }
240 
241     /**
242      * approve should be called when allowed[_spender] == 0. To increment
243      * allowed value is better to use this function to avoid 2 calls (and wait until
244      * the first transaction is mined)
245      * From MonolithDAO Token.sol
246      */
247     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
248         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
249         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
250         return true;
251     }
252 
253     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
254         uint oldValue = allowed[msg.sender][_spender];
255         if (_subtractedValue > oldValue) {
256             allowed[msg.sender][_spender] = 0;
257         } else {
258             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
259         }
260         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
261         return true;
262     }
263 
264 }
265 
266 /**
267  * @title Mintable token
268  * @dev Simple ERC20 Token example, with mintable token creation
269  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
270  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
271  */
272 
273 contract MintableToken is StandardToken, Ownable {
274     event Mint(address indexed to, uint256 amount);
275     event MintFinished();
276 
277     bool public mintingFinished = false;
278 
279 
280     modifier canMint() {
281         require(!mintingFinished);
282         _;
283     }
284 
285     /**
286      * @dev Function to mint tokens
287      * @param _to The address that will receive the minted tokens.
288      * @param _amount The amount of tokens to mint.
289      * @return A boolean that indicates if the operation was successful.
290      */
291     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
292         totalSupply = totalSupply.add(_amount);
293         balances[_to] = balances[_to].add(_amount);
294         Mint(_to, _amount);
295         Transfer(0x0, _to, _amount);
296         return true;
297     }
298 
299     /**
300      * @dev Function to stop minting new tokens.
301      * @return True if the operation was successful.
302      */
303     function finishMinting() onlyOwner public returns (bool) {
304         mintingFinished = true;
305         MintFinished();
306         return true;
307     }
308 }
309 
310 // Standard token variables
311 contract TokenOfGratitude is MintableToken {
312     string constant public name = "Token Of Gratitude";
313     string constant public symbol = "ToG";
314     uint8 constant public decimals = 0;
315 
316     uint256 public expirationDate = 1672531199;
317     address public goldenTicketOwner;
318 
319     // Mappings for easier backchecking
320     mapping (address => uint) redeemed;
321 
322     // ToG redeem event with encrypted message (hopefully a contact info)
323     event tokenRedemption(address indexed supported, string message);
324 
325     // Golden ticket related events
326     event goldenTicketMoved(address indexed newOwner);
327     event goldenTicketUsed(address charlie, string message);
328 
329     function TokenOfGratitude() {
330         goldenTicketOwner = msg.sender;
331     }
332 
333     /**
334      * Function returning the current price of ToG
335      * @dev can be used prior to the donation as a constant function but it is mainly used in the noname function
336      * @param message should contain an encrypted contract info of the redeemer to setup a meeting
337      */
338     function redeem(string message) {
339 
340         // Check caller has a token
341         require (balances[msg.sender] >= 1);
342 
343         // Check tokens did not expire
344         require (now <= expirationDate);
345 
346         // Lock the token against further transfers
347         balances[msg.sender] -= 1;
348         redeemed[msg.sender] += 1;
349 
350         // Call out
351         tokenRedemption(msg.sender, message);
352     }
353 
354     /**
355      * Function using the Golden ticket - the current holder will be able to get the prize only based on the "goldenTicketUsed" event
356      * @dev First checks the GT owner, then fires the event and then changes the owner to null so GT can't be used again
357      * @param message should contain an encrypted contract info of the redeemer to claim the reward
358      */
359     function useGoldenTicket(string message){
360         require(msg.sender == goldenTicketOwner);
361         goldenTicketUsed(msg.sender, message);
362         goldenTicketOwner = 0x0;
363     }
364 
365     /**
366      * Function using the Golden ticket - the current holder will be able to get the prize only based on the "goldenTicketUsed" event
367      * @dev First checks the GT owner, then change the owner and fire an event about the ticket changing owner
368      * @dev The Golden ticket isn't a standard ERC20 token and therefore it needs special handling
369      * @param newOwner should be a valid address of the new owner
370      */
371     function giveGoldenTicket(address newOwner) {
372         require (msg.sender == goldenTicketOwner);
373         goldenTicketOwner = newOwner;
374         goldenTicketMoved(newOwner);
375     }
376 
377 }
378 
379 // <ORACLIZE_API>
380 /*
381 Copyright (c) 2015-2016 Oraclize SRL
382 Copyright (c) 2016 Oraclize LTD
383 
384 
385 
386 Permission is hereby granted, free of charge, to any person obtaining a copy
387 of this software and associated documentation files (the "Software"), to deal
388 in the Software without restriction, including without limitation the rights
389 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
390 copies of the Software, and to permit persons to whom the Software is
391 furnished to do so, subject to the following conditions:
392 
393 
394 
395 The above copyright notice and this permission notice shall be included in
396 all copies or substantial portions of the Software.
397 
398 
399 
400 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
401 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
402 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
403 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
404 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
405 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
406 THE SOFTWARE.
407 */
408 
409 pragma solidity ^0.4.0;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
410 
411 contract OraclizeI {
412     address public cbAddress;
413     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
414     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
415     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
416     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
417     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
418     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
419     function getPrice(string _datasource) returns (uint _dsprice);
420     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
421     function useCoupon(string _coupon);
422     function setProofType(byte _proofType);
423     function setConfig(bytes32 _config);
424     function setCustomGasPrice(uint _gasPrice);
425     function randomDS_getSessionPubKeyHash() returns(bytes32);
426 }
427 contract OraclizeAddrResolverI {
428     function getAddress() returns (address _addr);
429 }
430 contract usingOraclize {
431     uint constant day = 60*60*24;
432     uint constant week = 60*60*24*7;
433     uint constant month = 60*60*24*30;
434     byte constant proofType_NONE = 0x00;
435     byte constant proofType_TLSNotary = 0x10;
436     byte constant proofType_Android = 0x20;
437     byte constant proofType_Ledger = 0x30;
438     byte constant proofType_Native = 0xF0;
439     byte constant proofStorage_IPFS = 0x01;
440     uint8 constant networkID_auto = 0;
441     uint8 constant networkID_mainnet = 1;
442     uint8 constant networkID_testnet = 2;
443     uint8 constant networkID_morden = 2;
444     uint8 constant networkID_consensys = 161;
445 
446     OraclizeAddrResolverI OAR;
447 
448     OraclizeI oraclize;
449     modifier oraclizeAPI {
450         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
451         oraclize_setNetwork(networkID_auto);
452 
453         if(address(oraclize) != OAR.getAddress())
454         oraclize = OraclizeI(OAR.getAddress());
455 
456         _;
457     }
458     modifier coupon(string code){
459         oraclize = OraclizeI(OAR.getAddress());
460         oraclize.useCoupon(code);
461         _;
462     }
463 
464     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
465         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
466             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
467             oraclize_setNetworkName("eth_mainnet");
468             return true;
469         }
470         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
471             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
472             oraclize_setNetworkName("eth_ropsten3");
473             return true;
474         }
475         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
476             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
477             oraclize_setNetworkName("eth_kovan");
478             return true;
479         }
480         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
481             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
482             oraclize_setNetworkName("eth_rinkeby");
483             return true;
484         }
485         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
486             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
487             return true;
488         }
489         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
490             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
491             return true;
492         }
493         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
494             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
495             return true;
496         }
497         return false;
498     }
499 
500     function __callback(bytes32 myid, string result) {
501         __callback(myid, result, new bytes(0));
502     }
503     function __callback(bytes32 myid, string result, bytes proof) {
504     }
505 
506     function oraclize_useCoupon(string code) oraclizeAPI internal {
507         oraclize.useCoupon(code);
508     }
509 
510     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
511         return oraclize.getPrice(datasource);
512     }
513 
514     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
515         return oraclize.getPrice(datasource, gaslimit);
516     }
517 
518     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
519         uint price = oraclize.getPrice(datasource);
520         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
521         return oraclize.query.value(price)(0, datasource, arg);
522     }
523     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
524         uint price = oraclize.getPrice(datasource);
525         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
526         return oraclize.query.value(price)(timestamp, datasource, arg);
527     }
528     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
529         uint price = oraclize.getPrice(datasource, gaslimit);
530         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
531         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
532     }
533     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
534         uint price = oraclize.getPrice(datasource, gaslimit);
535         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
536         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
537     }
538     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
539         uint price = oraclize.getPrice(datasource);
540         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
541         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
542     }
543     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
544         uint price = oraclize.getPrice(datasource);
545         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
546         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
547     }
548     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
549         uint price = oraclize.getPrice(datasource, gaslimit);
550         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
551         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
552     }
553     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
554         uint price = oraclize.getPrice(datasource, gaslimit);
555         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
556         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
557     }
558     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
559         uint price = oraclize.getPrice(datasource);
560         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
561         bytes memory args = stra2cbor(argN);
562         return oraclize.queryN.value(price)(0, datasource, args);
563     }
564     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
565         uint price = oraclize.getPrice(datasource);
566         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
567         bytes memory args = stra2cbor(argN);
568         return oraclize.queryN.value(price)(timestamp, datasource, args);
569     }
570     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
571         uint price = oraclize.getPrice(datasource, gaslimit);
572         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
573         bytes memory args = stra2cbor(argN);
574         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
575     }
576     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
577         uint price = oraclize.getPrice(datasource, gaslimit);
578         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
579         bytes memory args = stra2cbor(argN);
580         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
581     }
582     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
583         string[] memory dynargs = new string[](1);
584         dynargs[0] = args[0];
585         return oraclize_query(datasource, dynargs);
586     }
587     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
588         string[] memory dynargs = new string[](1);
589         dynargs[0] = args[0];
590         return oraclize_query(timestamp, datasource, dynargs);
591     }
592     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
593         string[] memory dynargs = new string[](1);
594         dynargs[0] = args[0];
595         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
596     }
597     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
598         string[] memory dynargs = new string[](1);
599         dynargs[0] = args[0];
600         return oraclize_query(datasource, dynargs, gaslimit);
601     }
602 
603     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
604         string[] memory dynargs = new string[](2);
605         dynargs[0] = args[0];
606         dynargs[1] = args[1];
607         return oraclize_query(datasource, dynargs);
608     }
609     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
610         string[] memory dynargs = new string[](2);
611         dynargs[0] = args[0];
612         dynargs[1] = args[1];
613         return oraclize_query(timestamp, datasource, dynargs);
614     }
615     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
616         string[] memory dynargs = new string[](2);
617         dynargs[0] = args[0];
618         dynargs[1] = args[1];
619         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
620     }
621     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
622         string[] memory dynargs = new string[](2);
623         dynargs[0] = args[0];
624         dynargs[1] = args[1];
625         return oraclize_query(datasource, dynargs, gaslimit);
626     }
627     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
628         string[] memory dynargs = new string[](3);
629         dynargs[0] = args[0];
630         dynargs[1] = args[1];
631         dynargs[2] = args[2];
632         return oraclize_query(datasource, dynargs);
633     }
634     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
635         string[] memory dynargs = new string[](3);
636         dynargs[0] = args[0];
637         dynargs[1] = args[1];
638         dynargs[2] = args[2];
639         return oraclize_query(timestamp, datasource, dynargs);
640     }
641     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
642         string[] memory dynargs = new string[](3);
643         dynargs[0] = args[0];
644         dynargs[1] = args[1];
645         dynargs[2] = args[2];
646         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
647     }
648     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
649         string[] memory dynargs = new string[](3);
650         dynargs[0] = args[0];
651         dynargs[1] = args[1];
652         dynargs[2] = args[2];
653         return oraclize_query(datasource, dynargs, gaslimit);
654     }
655 
656     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
657         string[] memory dynargs = new string[](4);
658         dynargs[0] = args[0];
659         dynargs[1] = args[1];
660         dynargs[2] = args[2];
661         dynargs[3] = args[3];
662         return oraclize_query(datasource, dynargs);
663     }
664     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
665         string[] memory dynargs = new string[](4);
666         dynargs[0] = args[0];
667         dynargs[1] = args[1];
668         dynargs[2] = args[2];
669         dynargs[3] = args[3];
670         return oraclize_query(timestamp, datasource, dynargs);
671     }
672     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
673         string[] memory dynargs = new string[](4);
674         dynargs[0] = args[0];
675         dynargs[1] = args[1];
676         dynargs[2] = args[2];
677         dynargs[3] = args[3];
678         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
679     }
680     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
681         string[] memory dynargs = new string[](4);
682         dynargs[0] = args[0];
683         dynargs[1] = args[1];
684         dynargs[2] = args[2];
685         dynargs[3] = args[3];
686         return oraclize_query(datasource, dynargs, gaslimit);
687     }
688     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
689         string[] memory dynargs = new string[](5);
690         dynargs[0] = args[0];
691         dynargs[1] = args[1];
692         dynargs[2] = args[2];
693         dynargs[3] = args[3];
694         dynargs[4] = args[4];
695         return oraclize_query(datasource, dynargs);
696     }
697     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
698         string[] memory dynargs = new string[](5);
699         dynargs[0] = args[0];
700         dynargs[1] = args[1];
701         dynargs[2] = args[2];
702         dynargs[3] = args[3];
703         dynargs[4] = args[4];
704         return oraclize_query(timestamp, datasource, dynargs);
705     }
706     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
707         string[] memory dynargs = new string[](5);
708         dynargs[0] = args[0];
709         dynargs[1] = args[1];
710         dynargs[2] = args[2];
711         dynargs[3] = args[3];
712         dynargs[4] = args[4];
713         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
714     }
715     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
716         string[] memory dynargs = new string[](5);
717         dynargs[0] = args[0];
718         dynargs[1] = args[1];
719         dynargs[2] = args[2];
720         dynargs[3] = args[3];
721         dynargs[4] = args[4];
722         return oraclize_query(datasource, dynargs, gaslimit);
723     }
724     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
725         uint price = oraclize.getPrice(datasource);
726         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
727         bytes memory args = ba2cbor(argN);
728         return oraclize.queryN.value(price)(0, datasource, args);
729     }
730     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
731         uint price = oraclize.getPrice(datasource);
732         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
733         bytes memory args = ba2cbor(argN);
734         return oraclize.queryN.value(price)(timestamp, datasource, args);
735     }
736     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
737         uint price = oraclize.getPrice(datasource, gaslimit);
738         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
739         bytes memory args = ba2cbor(argN);
740         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
741     }
742     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
743         uint price = oraclize.getPrice(datasource, gaslimit);
744         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
745         bytes memory args = ba2cbor(argN);
746         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
747     }
748     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
749         bytes[] memory dynargs = new bytes[](1);
750         dynargs[0] = args[0];
751         return oraclize_query(datasource, dynargs);
752     }
753     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
754         bytes[] memory dynargs = new bytes[](1);
755         dynargs[0] = args[0];
756         return oraclize_query(timestamp, datasource, dynargs);
757     }
758     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
759         bytes[] memory dynargs = new bytes[](1);
760         dynargs[0] = args[0];
761         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
762     }
763     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
764         bytes[] memory dynargs = new bytes[](1);
765         dynargs[0] = args[0];
766         return oraclize_query(datasource, dynargs, gaslimit);
767     }
768 
769     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
770         bytes[] memory dynargs = new bytes[](2);
771         dynargs[0] = args[0];
772         dynargs[1] = args[1];
773         return oraclize_query(datasource, dynargs);
774     }
775     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
776         bytes[] memory dynargs = new bytes[](2);
777         dynargs[0] = args[0];
778         dynargs[1] = args[1];
779         return oraclize_query(timestamp, datasource, dynargs);
780     }
781     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
782         bytes[] memory dynargs = new bytes[](2);
783         dynargs[0] = args[0];
784         dynargs[1] = args[1];
785         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
786     }
787     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
788         bytes[] memory dynargs = new bytes[](2);
789         dynargs[0] = args[0];
790         dynargs[1] = args[1];
791         return oraclize_query(datasource, dynargs, gaslimit);
792     }
793     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
794         bytes[] memory dynargs = new bytes[](3);
795         dynargs[0] = args[0];
796         dynargs[1] = args[1];
797         dynargs[2] = args[2];
798         return oraclize_query(datasource, dynargs);
799     }
800     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
801         bytes[] memory dynargs = new bytes[](3);
802         dynargs[0] = args[0];
803         dynargs[1] = args[1];
804         dynargs[2] = args[2];
805         return oraclize_query(timestamp, datasource, dynargs);
806     }
807     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
808         bytes[] memory dynargs = new bytes[](3);
809         dynargs[0] = args[0];
810         dynargs[1] = args[1];
811         dynargs[2] = args[2];
812         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
813     }
814     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
815         bytes[] memory dynargs = new bytes[](3);
816         dynargs[0] = args[0];
817         dynargs[1] = args[1];
818         dynargs[2] = args[2];
819         return oraclize_query(datasource, dynargs, gaslimit);
820     }
821 
822     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
823         bytes[] memory dynargs = new bytes[](4);
824         dynargs[0] = args[0];
825         dynargs[1] = args[1];
826         dynargs[2] = args[2];
827         dynargs[3] = args[3];
828         return oraclize_query(datasource, dynargs);
829     }
830     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
831         bytes[] memory dynargs = new bytes[](4);
832         dynargs[0] = args[0];
833         dynargs[1] = args[1];
834         dynargs[2] = args[2];
835         dynargs[3] = args[3];
836         return oraclize_query(timestamp, datasource, dynargs);
837     }
838     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
839         bytes[] memory dynargs = new bytes[](4);
840         dynargs[0] = args[0];
841         dynargs[1] = args[1];
842         dynargs[2] = args[2];
843         dynargs[3] = args[3];
844         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
845     }
846     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
847         bytes[] memory dynargs = new bytes[](4);
848         dynargs[0] = args[0];
849         dynargs[1] = args[1];
850         dynargs[2] = args[2];
851         dynargs[3] = args[3];
852         return oraclize_query(datasource, dynargs, gaslimit);
853     }
854     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
855         bytes[] memory dynargs = new bytes[](5);
856         dynargs[0] = args[0];
857         dynargs[1] = args[1];
858         dynargs[2] = args[2];
859         dynargs[3] = args[3];
860         dynargs[4] = args[4];
861         return oraclize_query(datasource, dynargs);
862     }
863     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
864         bytes[] memory dynargs = new bytes[](5);
865         dynargs[0] = args[0];
866         dynargs[1] = args[1];
867         dynargs[2] = args[2];
868         dynargs[3] = args[3];
869         dynargs[4] = args[4];
870         return oraclize_query(timestamp, datasource, dynargs);
871     }
872     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
873         bytes[] memory dynargs = new bytes[](5);
874         dynargs[0] = args[0];
875         dynargs[1] = args[1];
876         dynargs[2] = args[2];
877         dynargs[3] = args[3];
878         dynargs[4] = args[4];
879         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
880     }
881     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
882         bytes[] memory dynargs = new bytes[](5);
883         dynargs[0] = args[0];
884         dynargs[1] = args[1];
885         dynargs[2] = args[2];
886         dynargs[3] = args[3];
887         dynargs[4] = args[4];
888         return oraclize_query(datasource, dynargs, gaslimit);
889     }
890 
891     function oraclize_cbAddress() oraclizeAPI internal returns (address){
892         return oraclize.cbAddress();
893     }
894     function oraclize_setProof(byte proofP) oraclizeAPI internal {
895         return oraclize.setProofType(proofP);
896     }
897     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
898         return oraclize.setCustomGasPrice(gasPrice);
899     }
900     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
901         return oraclize.setConfig(config);
902     }
903 
904     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
905         return oraclize.randomDS_getSessionPubKeyHash();
906     }
907 
908     function getCodeSize(address _addr) constant internal returns(uint _size) {
909         assembly {
910         _size := extcodesize(_addr)
911         }
912     }
913 
914     function parseAddr(string _a) internal returns (address){
915         bytes memory tmp = bytes(_a);
916         uint160 iaddr = 0;
917         uint160 b1;
918         uint160 b2;
919         for (uint i=2; i<2+2*20; i+=2){
920             iaddr *= 256;
921             b1 = uint160(tmp[i]);
922             b2 = uint160(tmp[i+1]);
923             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
924             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
925             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
926             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
927             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
928             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
929             iaddr += (b1*16+b2);
930         }
931         return address(iaddr);
932     }
933 
934     function strCompare(string _a, string _b) internal returns (int) {
935         bytes memory a = bytes(_a);
936         bytes memory b = bytes(_b);
937         uint minLength = a.length;
938         if (b.length < minLength) minLength = b.length;
939         for (uint i = 0; i < minLength; i ++)
940         if (a[i] < b[i])
941         return -1;
942         else if (a[i] > b[i])
943         return 1;
944         if (a.length < b.length)
945         return -1;
946         else if (a.length > b.length)
947         return 1;
948         else
949         return 0;
950     }
951 
952     function indexOf(string _haystack, string _needle) internal returns (int) {
953         bytes memory h = bytes(_haystack);
954         bytes memory n = bytes(_needle);
955         if(h.length < 1 || n.length < 1 || (n.length > h.length))
956         return -1;
957         else if(h.length > (2**128 -1))
958         return -1;
959         else
960         {
961             uint subindex = 0;
962             for (uint i = 0; i < h.length; i ++)
963             {
964                 if (h[i] == n[0])
965                 {
966                     subindex = 1;
967                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
968                     {
969                         subindex++;
970                     }
971                     if(subindex == n.length)
972                     return int(i);
973                 }
974             }
975             return -1;
976         }
977     }
978 
979     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
980         bytes memory _ba = bytes(_a);
981         bytes memory _bb = bytes(_b);
982         bytes memory _bc = bytes(_c);
983         bytes memory _bd = bytes(_d);
984         bytes memory _be = bytes(_e);
985         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
986         bytes memory babcde = bytes(abcde);
987         uint k = 0;
988         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
989         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
990         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
991         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
992         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
993         return string(babcde);
994     }
995 
996     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
997         return strConcat(_a, _b, _c, _d, "");
998     }
999 
1000     function strConcat(string _a, string _b, string _c) internal returns (string) {
1001         return strConcat(_a, _b, _c, "", "");
1002     }
1003 
1004     function strConcat(string _a, string _b) internal returns (string) {
1005         return strConcat(_a, _b, "", "", "");
1006     }
1007 
1008     // parseInt
1009     function parseInt(string _a) internal returns (uint) {
1010         return parseInt(_a, 0);
1011     }
1012 
1013     // parseInt(parseFloat*10^_b)
1014     function parseInt(string _a, uint _b) internal returns (uint) {
1015         bytes memory bresult = bytes(_a);
1016         uint mint = 0;
1017         bool decimals = false;
1018         for (uint i=0; i<bresult.length; i++){
1019             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
1020                 if (decimals){
1021                     if (_b == 0) break;
1022                     else _b--;
1023                 }
1024                 mint *= 10;
1025                 mint += uint(bresult[i]) - 48;
1026             } else if (bresult[i] == 46) decimals = true;
1027         }
1028         if (_b > 0) mint *= 10**_b;
1029         return mint;
1030     }
1031 
1032     function uint2str(uint i) internal returns (string){
1033         if (i == 0) return "0";
1034         uint j = i;
1035         uint len;
1036         while (j != 0){
1037             len++;
1038             j /= 10;
1039         }
1040         bytes memory bstr = new bytes(len);
1041         uint k = len - 1;
1042         while (i != 0){
1043             bstr[k--] = byte(48 + i % 10);
1044             i /= 10;
1045         }
1046         return string(bstr);
1047     }
1048 
1049     function stra2cbor(string[] arr) internal returns (bytes) {
1050         uint arrlen = arr.length;
1051 
1052         // get correct cbor output length
1053         uint outputlen = 0;
1054         bytes[] memory elemArray = new bytes[](arrlen);
1055         for (uint i = 0; i < arrlen; i++) {
1056             elemArray[i] = (bytes(arr[i]));
1057             outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
1058         }
1059         uint ctr = 0;
1060         uint cborlen = arrlen + 0x80;
1061         outputlen += byte(cborlen).length;
1062         bytes memory res = new bytes(outputlen);
1063 
1064         while (byte(cborlen).length > ctr) {
1065             res[ctr] = byte(cborlen)[ctr];
1066             ctr++;
1067         }
1068         for (i = 0; i < arrlen; i++) {
1069             res[ctr] = 0x5F;
1070             ctr++;
1071             for (uint x = 0; x < elemArray[i].length; x++) {
1072                 // if there's a bug with larger strings, this may be the culprit
1073                 if (x % 23 == 0) {
1074                     uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
1075                     elemcborlen += 0x40;
1076                     uint lctr = ctr;
1077                     while (byte(elemcborlen).length > ctr - lctr) {
1078                         res[ctr] = byte(elemcborlen)[ctr - lctr];
1079                         ctr++;
1080                     }
1081                 }
1082                 res[ctr] = elemArray[i][x];
1083                 ctr++;
1084             }
1085             res[ctr] = 0xFF;
1086             ctr++;
1087         }
1088         return res;
1089     }
1090 
1091     function ba2cbor(bytes[] arr) internal returns (bytes) {
1092         uint arrlen = arr.length;
1093 
1094         // get correct cbor output length
1095         uint outputlen = 0;
1096         bytes[] memory elemArray = new bytes[](arrlen);
1097         for (uint i = 0; i < arrlen; i++) {
1098             elemArray[i] = (bytes(arr[i]));
1099             outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
1100         }
1101         uint ctr = 0;
1102         uint cborlen = arrlen + 0x80;
1103         outputlen += byte(cborlen).length;
1104         bytes memory res = new bytes(outputlen);
1105 
1106         while (byte(cborlen).length > ctr) {
1107             res[ctr] = byte(cborlen)[ctr];
1108             ctr++;
1109         }
1110         for (i = 0; i < arrlen; i++) {
1111             res[ctr] = 0x5F;
1112             ctr++;
1113             for (uint x = 0; x < elemArray[i].length; x++) {
1114                 // if there's a bug with larger strings, this may be the culprit
1115                 if (x % 23 == 0) {
1116                     uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
1117                     elemcborlen += 0x40;
1118                     uint lctr = ctr;
1119                     while (byte(elemcborlen).length > ctr - lctr) {
1120                         res[ctr] = byte(elemcborlen)[ctr - lctr];
1121                         ctr++;
1122                     }
1123                 }
1124                 res[ctr] = elemArray[i][x];
1125                 ctr++;
1126             }
1127             res[ctr] = 0xFF;
1128             ctr++;
1129         }
1130         return res;
1131     }
1132 
1133 
1134     string oraclize_network_name;
1135     function oraclize_setNetworkName(string _network_name) internal {
1136         oraclize_network_name = _network_name;
1137     }
1138 
1139     function oraclize_getNetworkName() internal returns (string) {
1140         return oraclize_network_name;
1141     }
1142 
1143     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1144         if ((_nbytes == 0)||(_nbytes > 32)) throw;
1145         bytes memory nbytes = new bytes(1);
1146         nbytes[0] = byte(_nbytes);
1147         bytes memory unonce = new bytes(32);
1148         bytes memory sessionKeyHash = new bytes(32);
1149         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1150         assembly {
1151         mstore(unonce, 0x20)
1152         mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1153         mstore(sessionKeyHash, 0x20)
1154         mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1155         }
1156         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
1157         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
1158         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
1159         return queryId;
1160     }
1161 
1162     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1163         oraclize_randomDS_args[queryId] = commitment;
1164     }
1165 
1166     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1167     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1168 
1169     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1170         bool sigok;
1171         address signer;
1172 
1173         bytes32 sigr;
1174         bytes32 sigs;
1175 
1176         bytes memory sigr_ = new bytes(32);
1177         uint offset = 4+(uint(dersig[3]) - 0x20);
1178         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1179         bytes memory sigs_ = new bytes(32);
1180         offset += 32 + 2;
1181         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1182 
1183         assembly {
1184         sigr := mload(add(sigr_, 32))
1185         sigs := mload(add(sigs_, 32))
1186         }
1187 
1188 
1189         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1190         if (address(sha3(pubkey)) == signer) return true;
1191         else {
1192             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1193             return (address(sha3(pubkey)) == signer);
1194         }
1195     }
1196 
1197     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1198         bool sigok;
1199 
1200         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1201         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1202         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1203 
1204         bytes memory appkey1_pubkey = new bytes(64);
1205         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1206 
1207         bytes memory tosign2 = new bytes(1+65+32);
1208         tosign2[0] = 1; //role
1209         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1210         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1211         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1212         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1213 
1214         if (sigok == false) return false;
1215 
1216 
1217         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1218         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1219 
1220         bytes memory tosign3 = new bytes(1+65);
1221         tosign3[0] = 0xFE;
1222         copyBytes(proof, 3, 65, tosign3, 1);
1223 
1224         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1225         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1226 
1227         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1228 
1229         return sigok;
1230     }
1231 
1232     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1233         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1234         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1235 
1236         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1237         if (proofVerified == false) throw;
1238 
1239         _;
1240     }
1241 
1242     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1243         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1244         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1245 
1246         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1247         if (proofVerified == false) return 2;
1248 
1249         return 0;
1250     }
1251 
1252     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
1253         bool match_ = true;
1254 
1255         for (var i=0; i<prefix.length; i++){
1256             if (content[i] != prefix[i]) match_ = false;
1257         }
1258 
1259         return match_;
1260     }
1261 
1262     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1263         bool checkok;
1264 
1265 
1266         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1267         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1268         bytes memory keyhash = new bytes(32);
1269         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1270         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
1271         if (checkok == false) return false;
1272 
1273         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1274         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1275 
1276 
1277         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1278         checkok = matchBytes32Prefix(sha256(sig1), result);
1279         if (checkok == false) return false;
1280 
1281 
1282         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1283         // This is to verify that the computed args match with the ones specified in the query.
1284         bytes memory commitmentSlice1 = new bytes(8+1+32);
1285         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1286 
1287         bytes memory sessionPubkey = new bytes(64);
1288         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1289         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1290 
1291         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1292         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1293             delete oraclize_randomDS_args[queryId];
1294         } else return false;
1295 
1296 
1297         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1298         bytes memory tosign1 = new bytes(32+8+1+32);
1299         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1300         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
1301         if (checkok == false) return false;
1302 
1303         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1304         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1305             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1306         }
1307 
1308         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1309     }
1310 
1311 
1312     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1313     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1314         uint minLength = length + toOffset;
1315 
1316         if (to.length < minLength) {
1317             // Buffer too small
1318             throw; // Should be a better way?
1319         }
1320 
1321         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1322         uint i = 32 + fromOffset;
1323         uint j = 32 + toOffset;
1324 
1325         while (i < (32 + fromOffset + length)) {
1326             assembly {
1327             let tmp := mload(add(from, i))
1328             mstore(add(to, j), tmp)
1329             }
1330             i += 32;
1331             j += 32;
1332         }
1333 
1334         return to;
1335     }
1336 
1337     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1338     // Duplicate Solidity's ecrecover, but catching the CALL return value
1339     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1340         // We do our own memory management here. Solidity uses memory offset
1341         // 0x40 to store the current end of memory. We write past it (as
1342         // writes are memory extensions), but don't update the offset so
1343         // Solidity will reuse it. The memory used here is only needed for
1344         // this context.
1345 
1346         // FIXME: inline assembly can't access return values
1347         bool ret;
1348         address addr;
1349 
1350         assembly {
1351         let size := mload(0x40)
1352         mstore(size, hash)
1353         mstore(add(size, 32), v)
1354         mstore(add(size, 64), r)
1355         mstore(add(size, 96), s)
1356 
1357         // NOTE: we can reuse the request memory because we deal with
1358         //       the return code
1359         ret := call(3000, 1, 0, size, 128, size, 32)
1360         addr := mload(size)
1361         }
1362 
1363         return (ret, addr);
1364     }
1365 
1366     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1367     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1368         bytes32 r;
1369         bytes32 s;
1370         uint8 v;
1371 
1372         if (sig.length != 65)
1373         return (false, 0);
1374 
1375         // The signature format is a compact form of:
1376         //   {bytes32 r}{bytes32 s}{uint8 v}
1377         // Compact means, uint8 is not padded to 32 bytes.
1378         assembly {
1379         r := mload(add(sig, 32))
1380         s := mload(add(sig, 64))
1381 
1382         // Here we are loading the last 32 bytes. We exploit the fact that
1383         // 'mload' will pad with zeroes if we overread.
1384         // There is no 'mload8' to do this, but that would be nicer.
1385         v := byte(0, mload(add(sig, 96)))
1386 
1387         // Alternative solution:
1388         // 'byte' is not working due to the Solidity parser, so lets
1389         // use the second best option, 'and'
1390         // v := and(mload(add(sig, 65)), 255)
1391         }
1392 
1393         // albeit non-transactional signatures are not specified by the YP, one would expect it
1394         // to match the YP range of [27, 28]
1395         //
1396         // geth uses [0, 1] and some clients have followed. This might change, see:
1397         //  https://github.com/ethereum/go-ethereum/issues/2053
1398         if (v < 27)
1399         v += 27;
1400 
1401         if (v != 27 && v != 28)
1402         return (false, 0);
1403 
1404         return safer_ecrecover(hash, v, r, s);
1405     }
1406 
1407 }
1408 // </ORACLIZE_API>
1409 
1410 /**
1411  * @title Crowdsale
1412  * @dev Crowdsale is a base contract for managing a token crowdsale.
1413  * Crowdsales have a start and end timestamps, where investors can make
1414  * token purchases and the crowdsale will assign them tokens based
1415  * on a token per ETH rate. Funds collected are forwarded to a wallet
1416  * as they arrive.
1417  */
1418 contract Crowdsale {
1419     using SafeMath for uint256;
1420 
1421     // The token being sold
1422     TokenOfGratitude public token;
1423 
1424     // start and end timestamps where investments are allowed (both inclusive)
1425     uint256 public startTime;
1426     uint256 public endTime;
1427 
1428     // address where funds are collected
1429     //address public wallet; => funds are collected in this contract
1430 
1431     // amount of raised money in wei
1432     uint256 public weiRaised;
1433 
1434     /**
1435      * event for token purchase logging
1436      * @param purchaser who paid for the tokens
1437      * @param beneficiary who got the tokens
1438      * @param value weis paid for purchase
1439      * @param amount amount of tokens purchased
1440      */
1441     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
1442 
1443 
1444     function Crowdsale(uint256 _startTime, uint256 _endTime) {
1445         require(_startTime >= now);
1446         require(_endTime >= _startTime);
1447 
1448         token = createTokenContract();
1449         startTime = _startTime;
1450         endTime = _endTime;
1451     }
1452 
1453     // creates the token to be sold.
1454     // override this method to have crowdsale of a specific mintable token.
1455     function createTokenContract() internal returns (TokenOfGratitude) {
1456         return new TokenOfGratitude();
1457     }
1458     // fallback function can be used to buy tokens
1459     function () payable {
1460         buyTokens(msg.sender);
1461     }
1462 
1463     // low level token purchase function
1464     function buyTokens(address beneficiary) public payable {}
1465 
1466 
1467     // @return true if the transaction can buy tokens
1468     function validPurchase() internal constant returns (bool) {
1469         bool withinPeriod = now >= startTime && now <= endTime;
1470         bool nonZeroPurchase = msg.value != 0;
1471         return withinPeriod && nonZeroPurchase;
1472     }
1473 
1474     // @return true if crowdsale event has ended
1475     function hasEnded() public constant returns (bool) {
1476         return now > endTime;
1477     }
1478 
1479 
1480 }
1481 
1482 /**
1483  * @title FinalizableCrowdsale
1484  * @dev Extension of Crowdsale where an owner can do extra work
1485  * after finishing.
1486  */
1487 contract FinalizableCrowdsale is Crowdsale, Ownable {
1488     using SafeMath for uint256;
1489 
1490     bool public isFinalized = false;
1491 
1492     event Finalized();
1493 
1494     /**
1495      * @dev Must be called after crowdsale ends, to do some extra finalization
1496      * work. Calls the contract's finalization function.
1497      */
1498     function finalize() onlyOwner public {
1499         require(!isFinalized);
1500         require(hasEnded());
1501 
1502         finalization();
1503         Finalized();
1504 
1505         isFinalized = true;
1506     }
1507 
1508     /**
1509      * @dev Can be overridden to add finalization logic. The overriding function
1510      * should call super.finalization() to ensure the chain of finalization is
1511      * executed entirely.
1512      */
1513     function finalization() internal {
1514     }
1515 }
1516 
1517 /**
1518  * @title Token of Gratitude fundraiser
1519  */
1520 contract GratitudeCrowdsale is FinalizableCrowdsale, usingOraclize {
1521 
1522     // Utility variables
1523     uint256 public tokensLeft;
1524 
1525     // Defining helper variables to differentiate Oraclize queries
1526     bytes32 qID1;
1527     bytes32 qID2;
1528 
1529 
1530     // Rate related variables
1531     uint256 public rate;
1532     bool public hasRate;
1533     uint public rateAge;
1534 
1535     /*
1536      * Randomly chosen number for the meal invitation winner
1537      * @dev each supporter gets a nonce - the luckyNumber is randomly picked nonce by Oraclize
1538      * @dev then points to donorsList[luckyNumber] mapping to get the address of the winner
1539      */
1540     bool public hasRandom;
1541     uint256 luckyNumber;
1542 
1543     /*
1544      * Medicines sans frontiers (MSF) | Doctors without borders - the public donation address
1545      * @dev please check for due diligence:
1546      * @notice Link to English site: https://www.lekari-bez-hranic.cz/en/bank-details#cryptocurrencies
1547      * @notice Link to Czech site: https://www.lekari-bez-hranic.cz/bankovni-spojeni#kryptomeny
1548      * @notice Link to Etherscan: https://etherscan.io/address/0x249f02676d09a41938309447fda33fb533d91dfc
1549      */
1550     address constant public addressOfMSF = 0x249F02676D09A41938309447fdA33FB533d91DFC;
1551     address constant public communityAddress = 0x008e9392ef82edBA2c45f2B02B9A21ac6B599BCA;
1552 
1553 
1554     // Mapping of supporters for random selection
1555     uint256 public donors = 0;
1556     mapping (address => bool) donated;
1557     mapping (uint256 => address) donorsList;
1558 
1559 
1560     // Fundraising finalization events
1561     event finishFundraiser(uint raised);
1562     event fundsToMSF(uint value);
1563     event fundsToCommunity(uint value);
1564 
1565     // Special events for a very special golden ticket!
1566     event goldenTicketFound(address winner);
1567 
1568     // Oraclize related events
1569     event newOraclizeQuery(string description);
1570     event newRate(string price);
1571     event newRandom(string price);
1572 
1573     /**
1574      * Constructor
1575      * @dev Contract constructor
1576      * @param _startTime uint256 is a unix timestamp of when the fundraiser starts
1577      * @param _endTime uint256 is a unix timestamp of when the fundraiser ends
1578      */
1579     function GratitudeCrowdsale(uint256 _startTime, uint256 _endTime)
1580     FinalizableCrowdsale()
1581     Crowdsale(_startTime, _endTime)
1582     {
1583         owner = msg.sender;
1584         tokensLeft = 500;
1585     }
1586 
1587     /**
1588      * buyTokens override
1589      * @dev Implementation of the override to the buy in function for incoming ETH
1590      * @param beneficiary address of the participating party
1591      */
1592     function buyTokens(address beneficiary) public payable {
1593         require(beneficiary != 0x0);
1594         require(validPurchase());
1595 
1596         // Sign up first-time donors to the list + give them a nonce so they can win the golden ticket!
1597         if (!donated[beneficiary]) {
1598             donated[beneficiary] = true;
1599             donorsList[donors] = beneficiary;
1600             donors += 1;
1601         }
1602 
1603         // Check if there are still tokens left (otherwise skipped)
1604         if (tokensLeft > 0) {
1605 
1606             // See how many tokens can the donor get.
1607             uint256 toGet = howMany(msg.value);
1608 
1609             // If some, give the tokens to the donor.
1610             if (toGet > 0) {
1611                 token.mint(beneficiary,toGet);
1612                 TokenPurchase(msg.sender, beneficiary, msg.value, toGet);
1613             }
1614         }
1615 
1616         // update state
1617         weiRaised = weiRaised.add(msg.value);
1618     }
1619 
1620     /**
1621     * Recursive function that counts amount of tokens to assign (even if a contribution overflows certain price range)
1622     * @dev Recalculating tokens to receive based on teh currentPrice(2) function.
1623     * @dev Number of recursive entrances is equal to the number of price levels (not counting the initial call)
1624     * @return toGet - amount of tokens to receive from the particular price range
1625     */
1626     function howMany(uint256 _value) internal returns (uint256){
1627 
1628         // Check current price level
1629         var (price, canGet) =  currentPrice();
1630         uint256 toGet = _value.div(price);
1631 
1632         // Act based on amount of tokens to get
1633         if (canGet == 0) {
1634             toGet = 0;
1635         } else if (toGet > canGet) {
1636             tokensLeft -= canGet;
1637             toGet = canGet + howMany(_value - (canGet*price));
1638         } else {
1639             tokensLeft -= toGet;
1640         }
1641         return toGet;
1642     }
1643 
1644     /**
1645      * Function returning the current price of ToG and amount of tokens available at that price
1646      * @dev can be used prior to the donation as a constant function but it is mainly used in the noname function
1647      * @return price - current price range
1648      * @return maxAtPrice - maximal amount of tokens available at current price
1649      */
1650     function currentPrice() constant returns (uint256 price, uint256 maxAtPrice){
1651 
1652         if (tokensLeft > 400) {
1653             return (100 finney, tokensLeft - 400);
1654         } else if (tokensLeft > 300) {
1655             return (200 finney, tokensLeft - 300);
1656         } else if (tokensLeft > 200) {
1657             return (300 finney, tokensLeft - 200);
1658         } else if (tokensLeft > 100) {
1659             return (400 finney, tokensLeft - 100);
1660         } else {
1661             return (500 finney, tokensLeft);
1662         }
1663     }
1664 
1665     /**
1666      * The pre-finalization requirement - get ETHUSD rate
1667      * @dev initiates Oraclize call for ETHUSD rate
1668      * @param gasLimit uint256 setting gasLimit of the __callback tx from Oraclize
1669      */
1670     function loadRate(uint256 gasLimit) payable {
1671         // Owner check
1672         require(msg.sender == owner);
1673 
1674         // Make an Oraclize queriey for ETHUSD rate
1675         getRateUSD(gasLimit);
1676     }
1677 
1678     /**
1679      * The pre-finalization requirement - get Random number
1680      * @dev initiates Oraclize call for random number
1681      * @param gasLimit uint256 setting gasLimit of the __callback tx from Oraclize
1682      */
1683     function loadRandom(uint256 gasLimit) payable {
1684         // Owner check
1685         require(msg.sender == owner);
1686 
1687         // Make an Oraclize query for a random number
1688         getRandom(gasLimit);
1689     }
1690 
1691     /**
1692      * The finalization override - commented bellow
1693      */
1694     function finalization() internal {
1695         //Check if the crowdsale has ended
1696         require(hasEnded());
1697 
1698         // Check the rate was queried less then 1 hour ago
1699         require(hasRate);
1700         require((now - rateAge) <= 3600);
1701 
1702         // Check the random number was received
1703         require(hasRandom);
1704 
1705         // Assign GoldenTicket
1706         token.giveGoldenTicket(donorsList[luckyNumber]);
1707         goldenTicketFound(donorsList[luckyNumber]);
1708 
1709         // Calling checkResult from PriceChecker contract
1710         uint256 funding = checkResult();
1711         uint256 raisedWei = this.balance;
1712         uint256 charityShare;
1713         uint256 toCharity;
1714 
1715         // If goal isn't met => send everything to MSF
1716         if (funding < 10000) {
1717             addressOfMSF.transfer(raisedWei);
1718             fundsToMSF(toCharity);
1719         } else if (funding < 25000) {
1720 
1721             // If 2nd goal isn't met => send the rest above the 1st goal to MSF
1722             charityShare = toPercentage(funding, funding-10000);
1723             toCharity = fromPercentage(raisedWei, charityShare);
1724 
1725             // Donate to charity first
1726             addressOfMSF.transfer(toCharity);
1727             fundsToMSF(toCharity);
1728 
1729             // Send funds to community;
1730             communityAddress.transfer(raisedWei - toCharity);
1731             fundsToCommunity(raisedWei - toCharity);
1732         } else {
1733 
1734             // If 2nd goal is met => send the rest above the 2nd goal to MSF
1735             charityShare = toPercentage(funding, funding-25000);
1736             toCharity = fromPercentage(raisedWei, charityShare);
1737 
1738             // Donate to charity first
1739             addressOfMSF.transfer(toCharity);
1740             fundsToMSF(toCharity);
1741 
1742             // Send funds to community;
1743             communityAddress.transfer(raisedWei - toCharity);
1744             fundsToCommunity(raisedWei - toCharity);
1745         }
1746         token.finishMinting();
1747         super.finalization();
1748     }
1749 
1750     /**
1751      * @dev Checking results of the fundraiser in USD
1752      * @return rated - total funds raised converted to USD
1753      */
1754     function checkResult() internal returns (uint256){
1755         uint256 raised = this.balance;
1756         // convert wei => usd to perform checks
1757         uint256 rated = (raised.mul(rate)).div(10000000000000000000000);
1758         return rated;
1759     }
1760 
1761     /**
1762      * Helper function to get split funds between the community and charity I
1763      * @dev Counts percentage of the total funds that belongs to the charity
1764      * @param total funds raised in USD
1765      * @param part of the total funds raised that should go to the charity
1766      * @return percentage in full expressed as a natural number between 0 and 100
1767      */
1768     function toPercentage (uint256 total, uint256 part) internal returns (uint256) {
1769         return (part*100)/total;
1770     }
1771 
1772     /**
1773      * Helper function to get split funds between the community and charity II
1774      * @dev Counts the exact amount of Wei to get send to the charity
1775      * @param value of total funds raised in Wei
1776      * @param percentage to be used obtained from the toPercentage(2) function
1777      * @return amount of Wei to be send to the charity
1778      */
1779     function fromPercentage(uint256 value, uint256 percentage) internal returns (uint256) {
1780         return (value*percentage)/100;
1781     }
1782 
1783     // <DATA FEEDS USING ORACLIZE>
1784 
1785     /**
1786      * @dev Create the ETHUSD query to Kraken thorough Oraclize
1787      */
1788     function getRateUSD(uint256 _gasLimit) internal {
1789 
1790         //require(msg.sender == owner);
1791         oraclize_setProof(proofType_TLSNotary);
1792         if (oraclize.getPrice("URL") > this.balance) {
1793             newOraclizeQuery("Oraclize: Insufficient funds!");
1794         } else {
1795             newOraclizeQuery("Oraclize was asked for ETHUSD rate.");
1796             qID1 = oraclize_query("URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.p.1", _gasLimit);
1797         }
1798     }
1799 
1800     /**
1801      * @dev Create the random number query to Oraclize
1802      */
1803     function getRandom(uint256 _gasLimit) internal {
1804 
1805         //require (msg.sender == owner);
1806         oraclize_setProof(proofType_Ledger);
1807         if (oraclize.getPrice("random") > this.balance) {
1808             newOraclizeQuery("Oraclize: Insufficient funds!");
1809         } else {
1810             newOraclizeQuery("Oraclize was asked for a random number.");
1811 
1812             // Make query for 4 random bytes to potentially get a number between 0 and 4294967295.
1813             // The assumption is that there won't be more then 4294967295 participants.
1814             // This may potentially hurt your contract as the "random mod participants" result distribution is unequal.
1815             // There creates an incentive to join earlier to have an micro advantage.
1816             qID2 = oraclize_newRandomDSQuery(0, 4, _gasLimit);
1817         }
1818     }
1819 
1820     /**
1821      *Oraclize callback function awaiting for response from the queries
1822      * @dev uses qType to handle the last called query type
1823      * @dev different querytypes shouldn't be called before callback was received
1824      * @dev -> not implementing a query que as "owner" is the only party responsible for creating order
1825      */
1826     function __callback(bytes32 myid, string result, bytes proof) {
1827         require(msg.sender == oraclize_cbAddress());
1828 
1829         if (myid == qID1) {
1830             checkQueryA(myid, result, proof);
1831         } else if (myid == qID2) {
1832             checkQueryB(myid, result, proof);
1833         }
1834     }
1835 
1836     /**
1837      * A helper function to separate reaction to different Oraclize queries - ETHUSD rate
1838      * @dev reaction to ETHUSD rate oraclize callback - getRateUSD()
1839      * @dev sets global vars rate to the result and rateAge to current timeStamp
1840      * @param _myid 32 bytes identifying the query generated by Oraclize
1841      * @param _result string with query result by Oraclize
1842      * @param _proof byte array with the proof of source by Oraclize
1843      */
1844     function checkQueryA(bytes32 _myid, string _result, bytes _proof) internal {
1845         newRate(_result);
1846 
1847         // calling Oraclize string => uint256 converter for a number with 4 decimals
1848         rate = parseInt(_result,4);
1849         rateAge = now;
1850         hasRate = true;
1851     }
1852 
1853     /**
1854      * A helper function to separate reaction to different Oraclize queries - random number
1855      * @dev reaction to random number oraclize callback - getRandom(number of participants)
1856      * @dev sets global var luckyNumber to the result
1857      * @param _myid 32 bytes identifying the query generated by Oraclize
1858      * @param _result string with query result by Oraclize
1859      * @param _proof byte array with the proof of source by Oraclize
1860      */
1861     function checkQueryB(bytes32 _myid, string _result, bytes _proof) internal oraclize_randomDS_proofVerify(_myid, _result, _proof) {
1862         newRandom(_result);
1863 
1864         // Calling Oraclize string => uint converter
1865         uint256 someNumber = parseInt(string(bytes(_result)),0);
1866 
1867         // Getting a luckyNumber between 0 and the number of donors (Random-number modulo number of donors)
1868         luckyNumber = someNumber%donors;
1869         hasRandom = true;
1870     }
1871 
1872     //Adjusting the hasEnded function to a case where all tokens were sold
1873     function hasEnded() public constant returns (bool) {
1874         return ((now > endTime) || (tokensLeft <= 0)) ;
1875     }
1876 
1877 }