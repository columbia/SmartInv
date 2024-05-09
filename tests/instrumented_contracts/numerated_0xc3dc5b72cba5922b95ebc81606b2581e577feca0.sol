1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5         if (a == 0) {
6             return 0;
7         }
8         c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         return a / b;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
23         c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract Ownable {
30     address public owner;
31     address public newOwner;
32 
33     event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);
34 
35     constructor() public {
36         owner = msg.sender;
37         newOwner = address(0);
38     }
39 
40     modifier onlyOwner() {
41         require(msg.sender == owner, "msg.sender == owner");
42         _;
43     }
44 
45     function transferOwnership(address _newOwner) public onlyOwner {
46         require(address(0) != _newOwner, "address(0) != _newOwner");
47         newOwner = _newOwner;
48     }
49 
50     function acceptOwnership() public {
51         require(msg.sender == newOwner, "msg.sender == newOwner");
52         emit OwnershipTransferred(owner, msg.sender);
53         owner = msg.sender;
54         newOwner = address(0);
55     }
56 }
57 
58 contract Adminable is Ownable {
59     mapping(address => bool) public admins;
60 
61     modifier onlyAdmin() {
62         require(admins[msg.sender] && msg.sender != owner, "admins[msg.sender] && msg.sender != owner");
63         _;
64     }
65 
66     function setAdmin(address _admin, bool _authorization) public onlyOwner {
67         admins[_admin] = _authorization;
68     }
69  
70 }
71 
72 
73 contract Token {
74     function transfer(address _to, uint256 _value) public returns (bool success);
75     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success);
76     function approve(address _spender, uint256 _value) public returns (bool success);
77     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
78     uint8 public decimals;
79 }
80 
81 contract TokedoExchange is Ownable, Adminable {
82     using SafeMath for uint256;
83     
84     mapping (address => uint256) public invalidOrder;
85 
86     function invalidateOrdersBefore(address _user) public onlyAdmin {
87         require(now > invalidOrder[_user], "now > invalidOrder[_user]");
88         invalidOrder[_user] = now;
89     }
90 
91     mapping (address => mapping (address => uint256)) public tokens; //mapping of token addresses to mapping of account balances
92     
93 
94     mapping (address => uint256) public lastActiveTransaction; // time of last interaction with this contract
95     mapping (bytes32 => uint256) public orderFills; //balanceOf order filled
96     
97     address public feeAccount;
98     uint256 public inactivityReleasePeriod = 2 weeks;
99     
100     mapping (bytes32 => bool) public hashed; //hashes of: order already traded && funds already hashed && accounts updated
101 
102     
103     uint256 public constant maxFeeWithdrawal = 0.05 ether; // max fee rate applied = 5%
104     uint256 public constant maxFeeTrade = 0.10 ether; // max fee rate applied = 10%
105     
106     address public tokedoToken;
107     uint256 public tokedoTokenFeeDiscount;
108     
109     mapping (address => bool) public baseCurrency;
110     
111     constructor(address _feeAccount, address _tokedoToken, uint256 _tokedoTokenFeeDiscount) public {
112         feeAccount = _feeAccount;
113         tokedoToken = _tokedoToken;
114         tokedoTokenFeeDiscount = _tokedoTokenFeeDiscount;
115     }
116     
117     /***************************
118      * EDITABLE CONFINGURATION *
119      ***************************/
120     
121     function setInactivityReleasePeriod(uint256 _expiry) public onlyAdmin returns (bool success) {
122         require(_expiry < 26 weeks, "_expiry < 26 weeks");
123         inactivityReleasePeriod = _expiry;
124         return true;
125     }
126     
127     function setFeeAccount(address _newFeeAccount) public onlyOwner returns (bool success) {
128         feeAccount = _newFeeAccount;
129         success = true;
130     }
131     
132     function setTokedoToken(address _tokedoToken) public onlyOwner returns (bool success) {
133         tokedoToken = _tokedoToken;
134         success = true;
135     }
136     
137     function setTokedoTokenFeeDiscount(uint256 _tokedoTokenFeeDiscount) public onlyOwner returns (bool success) {
138         tokedoTokenFeeDiscount = _tokedoTokenFeeDiscount;
139         success = true;
140     }
141     
142     function setBaseCurrency (address _baseCurrency, bool _boolean) public onlyOwner returns (bool success) {
143         baseCurrency[_baseCurrency] = _boolean;
144         success = true;
145     }
146     
147     /***************************
148      * UPDATE ACCOUNT ACTIVITY *
149      ***************************/
150     function updateAccountActivity() public {
151         lastActiveTransaction[msg.sender] = now;
152     }
153      
154     function adminUpdateAccountActivity(address _user, uint256 _expiry, uint8 _v, bytes32 _r, bytes32 _s)
155     public onlyAdmin returns(bool success) {
156         require(now < _expiry, "should be: now < _expiry");
157         bytes32 hash = keccak256(abi.encodePacked(this, _user, _expiry));
158         require(!hashed[hash], "!hashed[hash]");
159         hashed[hash] = true;
160         
161         require(ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), _v, _r, _s) == _user,"invalid update account activity signature");
162        
163         lastActiveTransaction[_user] = now;
164         success = true;
165     }
166      
167     /*****************
168      * DEPOSIT TOKEN *
169      *****************/
170     event Deposit(address token, address user, uint256 amount, uint256 balance);
171     
172     function tokenFallback(address _from, uint256 _amount, bytes) public returns(bool) {
173         depositTokenFunction(msg.sender, _amount, _from);
174         return true;
175     }
176 
177     function receiveApproval(address _from, uint256 _amount, bytes) public returns(bool) {
178         transferFromAndDepositTokenFunction(msg.sender, _amount, _from, _from);
179         return true;
180     }
181     
182     function depositToken(address _token, uint256 _amount) public returns(bool) {
183         transferFromAndDepositTokenFunction(_token, _amount, msg.sender, msg.sender);
184         return true;
185     }
186     
187     function depositTokenFor(address _token, uint256 _amount, address _beneficiary) public returns(bool) {
188         transferFromAndDepositTokenFunction(_token, _amount, msg.sender, _beneficiary);
189         return true;
190     }
191 
192     function transferFromAndDepositTokenFunction (address _token, uint256 _amount, address _sender, address _beneficiary) private {
193         require(Token(_token).transferFrom(_sender, this, _amount), "Token(_token).transferFrom(_sender, this, _amount)");
194         depositTokenFunction(_token, _amount, _beneficiary);
195     }
196 
197     function depositTokenFunction(address _token, uint256 _amount, address _beneficiary) private {
198         tokens[_token][_beneficiary] = tokens[_token][_beneficiary].add(_amount);
199         
200         if(tx.origin == _beneficiary) lastActiveTransaction[tx.origin] = now;
201         
202         emit Deposit(_token, _beneficiary, _amount, tokens[_token][_beneficiary]);
203     }
204     
205     /*****************
206      * DEPOSIT ETHER *
207      *****************/
208 
209     function depositEther() public payable {
210         depositEtherFor(msg.sender);
211     }
212     
213     function depositEtherFor(address _beneficiary) public payable {
214         tokens[address(0)][_beneficiary] = tokens[address(0)][_beneficiary].add(msg.value);
215         
216         if(msg.sender == _beneficiary) lastActiveTransaction[msg.sender] = now;
217         
218         emit Deposit(address(0), _beneficiary, msg.value, tokens[address(0)][_beneficiary]);
219     }
220 
221     /************
222      * WITHDRAW *
223      ************/
224     event EmergencyWithdraw(address token, address user, uint256 amount, uint256 balance);
225 
226     function emergencyWithdraw(address _token, uint256 _amount) public returns (bool success) {
227         
228         require(now.sub(lastActiveTransaction[msg.sender]) > inactivityReleasePeriod, "now.sub(lastActiveTransaction[msg.sender]) > inactivityReleasePeriod");
229         require(tokens[_token][msg.sender] >= _amount, "not enough balance for withdrawal");
230         
231         tokens[_token][msg.sender] = tokens[_token][msg.sender].sub(_amount);
232         
233         if (_token == address(0)) {
234             require(msg.sender.send(_amount), "msg.sender.send(_amount)");
235         } else {
236             require(Token(_token).transfer(msg.sender, _amount), "Token(_token).transfer(msg.sender, _amount)");
237         }
238         
239         emit EmergencyWithdraw(_token, msg.sender, _amount, tokens[_token][msg.sender]);
240         success = true;
241     }
242 
243     event Withdraw(address token, address user, uint256 amount, uint256 balance);
244 
245     function adminWithdraw(address _token, uint256 _amount, address _user, uint256 _nonce, uint8 _v, bytes32[2] _rs, uint256[2] _fee) public onlyAdmin returns (bool success) {
246 
247          /*_fee
248                 [0] _feeWithdrawal
249                 [1] _payWithTokedo (yes is 1 - no is 0)
250             _rs
251                 [0] _r
252                 [1] _s
253          */ 
254         
255         
256         bytes32 hash = keccak256(abi.encodePacked(this, _fee[1], _token, _amount, _user, _nonce));
257         require(!hashed[hash], "!hashed[hash]");
258         hashed[hash] = true;
259         
260         require(ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), _v, _rs[0], _rs[1]) == _user, "invalid withdraw signature");
261         
262         require(tokens[_token][_user] >= _amount, "not enough balance for withdrawal");
263         
264         tokens[_token][_user] = tokens[_token][_user].sub(_amount);
265         
266         uint256 fee;
267         if (_fee[1] == 1) fee = toWei(_amount, _token).mul(_fee[0]) / 1 ether;
268         if (_fee[1] == 1 && tokens[tokedoToken][_user] >= fee) {
269             tokens[tokedoToken][feeAccount] = tokens[tokedoToken][feeAccount].add(fee);
270             tokens[tokedoToken][_user] = tokens[tokedoToken][_user].sub(fee);
271         } else {
272             if (_fee[0] > maxFeeWithdrawal) _fee[0] = maxFeeWithdrawal;
273             
274             fee = _fee[0].mul(_amount) / 1 ether;
275             tokens[_token][feeAccount] = tokens[_token][feeAccount].add(fee);
276             _amount = _amount.sub(fee);
277         }
278         
279         if (_token == address(0)) {
280             require(_user.send(_amount), "_user.send(_amount)");
281         } else {
282             require(Token(_token).transfer(_user, _amount), "Token(_token).transfer(_user, _amount)");
283         }
284         
285         lastActiveTransaction[_user] = now;
286         
287         emit Withdraw(_token, _user, _amount, tokens[_token][_user]);
288         success = true;
289   }
290 
291     function balanceOf(address _token, address _user) public view returns (uint256) {
292         return tokens[_token][_user];
293     }
294     
295     
296     /***************
297      * ADMIN TRADE *
298      ***************/
299     
300     function adminTrade(uint256[] _values, address[] _addresses, uint8[] _v, bytes32[] _rs) public onlyAdmin returns (bool success) {
301         /* amountSellTaker is in amountBuyMaker terms 
302          _values
303             [0] amountSellTaker
304             [1] tradeNonceTaker
305             [2] feeTake
306             [3] tokedoPrice
307             [4] feePayableTokedoTaker (yes is 1 - no is 0)
308             [5] feeMake
309             [i*5+6] amountBuyMaker
310             [i*5+7] amountSellMaker
311             [i*5+8] expiresMaker
312             [i*5+9] nonceMaker
313             [i*5+10] feePayableTokedoMaker (yes is 1 - no is 0)
314          _addresses
315             [0] tokenBuyAddress
316             [1] tokenSellAddress
317             [2] takerAddress
318             [i+3] makerAddress
319          _v
320             [0] vTaker
321             [i+1] vMaker
322          _rs
323             [0] rTaker
324             [1] sTaker
325             [i*2+2] rMaker
326             [i*2+3] sMaker
327          */ 
328          
329          
330         /**********************
331          * FEE SECURITY CHECK *
332          **********************/
333         
334         //if (feeTake > maxFeeTrade) feeTake = maxFeeTrade;    
335         if (_values[2] > maxFeeTrade) _values[2] = maxFeeTrade;    // set max fee take
336         
337         // if (feeMake > maxFeeTrade) feeMake = maxFeeTrade;    
338         if (_values[5] > maxFeeTrade) _values[5] = maxFeeTrade;    // set max fee make
339     
340         /********************************
341          * TAKER BEFORE SECURITY CHECK *
342          ********************************/
343         
344         //check if there are sufficient funds for TAKER: 
345         require(tokens[_addresses[0]][_addresses[2]] >= _values[0],
346                 "tokens[tokenBuyAddress][takerAddress] >= amountSellTaker");
347         
348         /**************
349          * LOOP LOGIC *
350          **************/
351         
352         bytes32[2] memory orderHash;
353         uint256[8] memory amount;
354         /*
355             orderHash
356                 [0] globalHash
357                 [1] makerHash
358             amount
359                 [0] totalBuyMakerAmount
360                 [1] appliedAmountSellTaker
361                 [2] remainingAmountSellTaker
362                  * [3] amountFeeMake
363                  * [4] amountFeeTake
364                  * [5] priceTrade
365                  * [6] feeTokedoMaker
366                  * [7] feeTokedoTaker
367                 
368         */
369         
370         // remainingAmountSellTaker = amountSellTaker
371         amount[2] = _values[0];
372         
373         for(uint256 i=0; i < (_values.length - 6) / 5; i++) {
374             
375             /************************
376              * MAKER SECURITY CHECK *
377              *************************/
378             
379             //required: nonceMaker is greater or egual makerAddress
380             require(_values[i*5+9] >= invalidOrder[_addresses[i+3]],
381                     "nonceMaker >= invalidOrder[makerAddress]" );
382             
383             // orderHash: ExchangeAddress, tokenBuyAddress, amountBuyMaker, tokenSellAddress, amountSellMaker, expiresMaker, nonceMaker, makerAddress, feePayableTokedoMaker
384             orderHash[1] =  keccak256(abi.encodePacked(abi.encodePacked(this, _addresses[0], _values[i*5+6], _addresses[1], _values[i*5+7], _values[i*5+8], _values[i*5+9], _addresses[i+3]), _values[i*5+10]));
385             
386             //globalHash = keccak256(abi.encodePacked(globalHash, makerHash));
387             orderHash[0] = keccak256(abi.encodePacked(orderHash[0], orderHash[1]));
388             
389             //required: the signer is the same address of makerAddress
390             require(_addresses[i+3] == ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", orderHash[1])), _v[i+1], _rs[i*2+2], _rs[i*2+3]),
391                     'makerAddress    == ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", makerHash  )), vMaker, rMaker   , sMaker   )');
392             
393             
394             /*****************
395              * GLOBAL AMOUNT *
396              *****************/
397             
398             //appliedAmountSellTaker = amountBuyMaker.sub(orderFilled)
399             amount[1] = _values[i*5+6].sub(orderFills[orderHash[1]]); 
400 
401             //if remainingAmountSellTaker < appliedAmountSellTaker
402             if (amount[2] < amount[1]) {
403                 //appliedAmountSellTaker = remainingAmountSellTaker
404                 amount[1] = amount[2]; 
405             }
406             
407             //remainingAmountSellTaker -= appliedAmountSellTaker
408             amount[2] = amount[2].sub(amount[1]); 
409             
410             //totalBuyMakerAmount += appliedAmountSellTaker
411             amount[0] = amount[0].add(amount[1]);
412             
413             
414             /******************************
415              * MAKER SECURITY CHECK FUNDS *
416              ******************************/
417             
418             //check if there are sufficient funds for MAKER: tokens[tokenSellAddress][makerAddress] >= amountSellMaker * appliedAmountSellTaker / amountBuyMaker
419             require(tokens[_addresses[1]][_addresses[i+3]] >= (_values[i*5+7].mul(amount[1]).div(_values[i*5+6])),
420                     "tokens[tokenSellAddress][makerAddress] >= (amountSellMaker.mul(appliedAmountSellTaker).div(amountBuyMaker))");
421             
422             
423             /*******************
424              * FEE COMPUTATION *
425              *******************/
426              
427             /* amount
428                  * [3] amountFeeMake
429                  * [4] amountFeeTake
430                  * [5] priceTrade
431                  * [6] feeTokedoMaker
432                  * [7] feeTokedoTaker
433             */
434             
435             //appliedAmountSellTaker = toWei(appliedAmountSellTaker, tokenBuyAddress);
436             amount[1] = toWei(amount[1], _addresses[0]);
437             
438             //amountSellMaker = toWei(amountSellMaker, tokenSellAddress);
439             _values[i*5+7] = toWei(_values[i*5+7], _addresses[1]);
440             
441             //amountBuyMaker = toWei(amountBuyMaker, tokenBuyAddress)
442             _values[i*5+6] = toWei(_values[i*5+6], _addresses[0]);
443             
444             //amountFeeMake = appliedAmountSellTaker.mul(feeMake).div(1e18)
445             amount[3] = amount[1].mul(_values[5]).div(1e18);
446             //amountFeeTake = amountSellMaker.mul(feeTake).mul(appliedAmountSellTaker).div(amountBuyMaker) / 1e18;
447             amount[4] = _values[i*5+7].mul(_values[2]).mul(amount[1]).div(_values[i*5+6]) / 1e18;
448             
449             //if (tokenBuyAddress == address(0) || (baseCurrency[tokenBuyAddress] && !(tokenSellAddress == address(0))) { 
450             if (_addresses[0] == address(0) || (baseCurrency[_addresses[0]] && !(_addresses[1] == address(0)))) { // maker sell order
451                 //amountBuyMaker is ETH or baseCurrency
452                 //amountSellMaker is TKN
453                 //amountFeeMake is ETH or baseCurrency
454                 //amountFeeTake is TKN
455                 
456                 //if (feePayableTokedoMaker == 1) feeTokedoMaker = amountFeeMake.mul(1e18).div(tokedoPrice).mul(tokedoTokenFeeDiscount).div(1e18);
457                 if (_values[i*5+10] == 1) amount[6] = amount[3].mul(1e18).div(_values[3]).mul(tokedoTokenFeeDiscount).div(1e18);
458                 
459                 //if (feePayableTokedoTaker == 1) 
460                 if (_values[4] == 1) {
461                     // priceTrade =  amountBuyMaker.mul(1e18).div(amountSellMaker)
462                     amount[5] = _values[i*5+6].mul(1e18).div(_values[i*5+7]); // price is ETH / TKN
463                     //feeTokedoTaker = amountFeeTake.mul(priceTrade).div(tokedoPrice).mul(tokedoTokenFeeDiscount).div(1e18);
464                     amount[7] = amount[4].mul(amount[5]).div(_values[3]).mul(tokedoTokenFeeDiscount).div(1e18);
465                 }
466                 
467                 //amountFeeTake = fromWei(amountFeeTake, tokenSellAddress);
468                 amount[4] = fromWei(amount[4], _addresses[1]);
469                 
470             } else { //maker buy order
471                 //amountBuyMaker is TKN
472                 //amountSellMaker is ETH or baseCurrency
473                 //amountFeeMake is TKN
474                 //amountFeeTake is ETH or baseCurrency
475 
476                 //if (feePayableTokedoTaker == 1) feeTokedoTaker = amountFeeTake.mul(1e18).div(tokedoPrice).mul(tokedoTokenFeeDiscount).div(1e18);
477                 if(_values[4] == 1) amount[7] = amount[4].mul(1e18).div(_values[3]).mul(tokedoTokenFeeDiscount).div(1e18);
478                 
479                 //if (feePayableTokedoMaker == 1)
480                 if (_values[i*5+10] == 1) {
481                     // priceTrade =  amountSellMaker.mul(1e18).div(amountBuyMaker)
482                     amount[5] = _values[i*5+7].mul(1e18).div(_values[i*5+6]); // price is ETH / TKN
483                 
484                     // feeTokedoMaker = amountFeeMake.mul(priceTrade).div(tokedoPrice).mul(tokedoTokenFeeDiscount).div(1e18);
485                     amount[6] = amount[3].mul(amount[5]).div(_values[3]).mul(tokedoTokenFeeDiscount).div(1e18);
486                 }
487                 
488                 //amountFeeMake = fromWei(amountFeeMake, tokenBuyAddress);
489                 amount[3] = fromWei(amount[3], _addresses[0]);
490                 
491             }
492             
493             //appliedAmountSellTaker = fromWei(appliedAmountSellTaker, tokenBuyAddress);
494             amount[1] = fromWei(amount[1], _addresses[0]);
495             
496             //amountSellMaker = fromWei(amountSellMaker, tokenSellAddress);
497             _values[i*5+7] = fromWei(_values[i*5+7], _addresses[1]);
498             
499             //amountBuyMaker = fromWei(amountBuyMaker, tokenBuyAddress)
500             _values[i*5+6] = fromWei(_values[i*5+6], _addresses[0]);
501             
502             
503             /**********************
504              * FEE BALANCE UPDATE *
505              **********************/
506             
507             //feePayableTokedoTaker == 1 && tokens[tokedoToken][takerAddress] >= feeTokedoTaker
508             if (_values[4] == 1 && tokens[tokedoToken][_addresses[2]] >= amount[7] ) {
509                 
510                 //tokens[tokedoToken][takerAddress]  = tokens[tokedoToken][takerAddress].sub(feeTokedoTaker);
511                 tokens[tokedoToken][_addresses[2]] = tokens[tokedoToken][_addresses[2]].sub(amount[7]);
512                 
513                 //tokens[tokedoToken][feeAccount] = tokens[tokedoToken][feeAccount].add(feeTokedoTaker);
514                 tokens[tokedoToken][feeAccount] = tokens[tokedoToken][feeAccount].add(amount[7]);
515                 
516                 //amountFeeTake = 0;
517                 amount[4] = 0;
518             } else {
519                 //tokens[tokenSellAddress][feeAccount] = tokens[tokenSellAddress][feeAccount].add(amountFeeTake);
520                 tokens[_addresses[1]][feeAccount] = tokens[_addresses[1]][feeAccount].add(amount[4]);
521             }
522             
523             //feePayableTokedoMaker == 1 && tokens[tokedoToken][makerAddress] >= feeTokedoMaker
524             if (_values[i*5+10] == 1 && tokens[tokedoToken][_addresses[i+3]] >= amount[6]) {
525                 
526                 //tokens[tokedoToken][makerAddress] = tokens[tokedoToken][makerAddress].sub(feeTokedoMaker);
527                 tokens[tokedoToken][_addresses[i+3]] = tokens[tokedoToken][_addresses[i+3]].sub(amount[6]);
528                 
529                 //tokens[tokedoToken][feeAccount] = tokens[tokedoToken][feeAccount].add(feeTokedoMaker);
530                 tokens[tokedoToken][feeAccount] = tokens[tokedoToken][feeAccount].add(amount[6]);
531                 
532                 //amountFeeMake = 0;
533                 amount[3] = 0;
534             } else {
535                 //tokens[tokenBuyAddress][feeAccount] = tokens[tokenBuyAddress][feeAccount].add(amountFeeMake);
536                 tokens[_addresses[0]][feeAccount] = tokens[_addresses[0]][feeAccount].add(amount[3]);
537             }
538             
539         
540             /******************
541              * BALANCE UPDATE *
542              ******************/
543             
544         //tokens[tokenBuyAddress][takerAddress] = tokens[tokenBuyAddress][takerAddress].sub(appliedAmountSellTaker);
545         tokens[_addresses[0]][_addresses[2]] = tokens[_addresses[0]][_addresses[2]].sub(amount[1]);
546             
547             //tokens[tokenBuyAddress][makerAddress] = tokens[tokenBuyAddress]][makerAddress].add(appliedAmountSellTaker.sub(amountFeeMake));
548             tokens[_addresses[0]][_addresses[i+3]] = tokens[_addresses[0]][_addresses[i+3]].add(amount[1].sub(amount[3]));
549             
550             
551             //tokens[tokenSellAddress][makerAddress] = tokens[tokenSellAddress][makerAddress].sub(amountSellMaker.mul(appliedAmountSellTaker).div(amountBuyMaker));
552             tokens[_addresses[1]][_addresses[i+3]] = tokens[_addresses[1]][_addresses[i+3]].sub(_values[i*5+7].mul(amount[1]).div(_values[i*5+6]));
553             
554         //tokens[tokenSellAddress][takerAddress] = tokens[tokenSellAddress][takerAddress].add(amountSellMaker.mul(appliedAmountSellTaker).div(amountBuyMaker).sub(amountFeeTake));
555         tokens[_addresses[1]][_addresses[2]] = tokens[_addresses[1]][_addresses[2]].add(_values[i*5+7].mul(amount[1]).div(_values[i*5+6]).sub(amount[4]));
556             
557             
558             /***********************
559              * UPDATE MAKER STATUS *
560              ***********************/
561                         
562             //orderFills[orderHash[1]] = orderFills[orderHash[1]].add(appliedAmountSellTaker);
563             orderFills[orderHash[1]] = orderFills[orderHash[1]].add(amount[1]);
564             
565             //lastActiveTransaction[makerAddress] = now;
566             lastActiveTransaction[_addresses[i+3]] = now; 
567             
568         }
569         
570         
571         /*******************************
572          * TAKER AFTER SECURITY CHECK *
573          *******************************/
574 
575         // tradeHash:                                   globalHash, amountSellTaker, takerAddress, tradeNonceTaker, feePayableTokedoTaker
576         bytes32 tradeHash = keccak256(abi.encodePacked(orderHash[0], _values[0], _addresses[2], _values[1], _values[4])); 
577         
578         //required: the signer is the same address of takerAddress
579         require(_addresses[2] == ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", tradeHash)), _v[0], _rs[0], _rs[1]), 
580                 'takerAddress  == ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", tradeHash)), vTaker, rTaker, sTaker)');
581         
582         //required: the same trade is not done
583         require(!hashed[tradeHash], "!hashed[tradeHash] ");
584         hashed[tradeHash] = true;
585         
586         //required: totalBuyMakerAmount == amountSellTaker
587         require(amount[0] == _values[0], "totalBuyMakerAmount == amountSellTaker");
588         
589         
590         /***********************
591          * UPDATE TAKER STATUS *
592          ***********************/
593         
594         //lastActiveTransaction[takerAddress] = now;
595         lastActiveTransaction[_addresses[2]] = now; 
596         
597         success = true;
598     }
599     function toWei(uint256 _number, address _token) internal view returns (uint256) {
600         if (_token == address(0)) return _number;
601         return _number.mul(1e18).div(10**uint256(Token(_token).decimals()));
602     }
603     function fromWei(uint256 _number, address _token) internal view returns (uint256) {
604         if (_token == address(0)) return _number;
605         return _number.mul(10**uint256(Token(_token).decimals())).div(1e18);
606     }
607 }