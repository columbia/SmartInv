1 pragma solidity 0.4.19;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * @title ERC20Basic
45  * @dev Simpler version of ERC20 interface
46  * @dev see https://github.com/ethereum/EIPs/issues/179
47  */
48 contract ERC20Basic {
49   function totalSupply() public view returns (uint256);
50   function balanceOf(address who) public view returns (uint256);
51   function transfer(address to, uint256 value) public returns (bool);
52   event Transfer(address indexed from, address indexed to, uint256 value);
53 }
54 
55 /**
56  * @title ERC20 interface
57  * @dev see https://github.com/ethereum/EIPs/issues/20
58  */
59 contract ERC20 is ERC20Basic {
60   function allowance(address owner, address spender) public view returns (uint256);
61   function transferFrom(address from, address to, uint256 value) public returns (bool);
62   function approve(address spender, uint256 value) public returns (bool);
63   event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 /**
67  * @title SafeMath
68  * @dev Math operations with safety checks that throw on error
69  */
70 library SafeMath {
71     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72         if (a == 0) {
73             return 0;
74         }
75         uint256 c = a * b;
76         require(c / a == b);
77         return c;
78     }
79 
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         require(b <= a);
82         return a - b;
83     }
84 
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         require(c >= a);
88         return c;
89     }
90 }
91 
92 /**
93  * @title Migratable
94  * @dev an interface for joyso to migrate to the new version
95  */
96 contract Migratable {
97     function migrate(address user, uint256 amount, address tokenAddr) external payable returns (bool);
98 }
99 
100 /**
101  * @title JoysoDataDecoder
102  * @author Will, Emn178
103  * @notice decode the joyso compressed data
104  */
105 contract JoysoDataDecoder {
106     function decodeOrderUserId(uint256 data) internal pure returns (uint256) {
107         return data & 0x00000000000000000000000000000000000000000000000000000000ffffffff;
108     }
109 
110     function retrieveV(uint256 data) internal pure returns (uint256) {
111         // [24..24] v 0:27 1:28
112         return data & 0x000000000000000000000000f000000000000000000000000000000000000000 == 0 ? 27 : 28;
113     }
114 }
115 
116 
117 /**
118  * @title Joyso
119  * @notice joyso main contract
120  * @author Will, Emn178
121  */
122 contract Joyso is Ownable, JoysoDataDecoder {
123     using SafeMath for uint256;
124 
125     uint256 private constant USER_MASK = 0x00000000000000000000000000000000000000000000000000000000ffffffff;
126     uint256 private constant PAYMENT_METHOD_MASK = 0x00000000000000000000000f0000000000000000000000000000000000000000;
127     uint256 private constant WITHDRAW_TOKEN_MASK = 0x0000000000000000000000000000000000000000000000000000ffff00000000;
128     uint256 private constant V_MASK = 0x000000000000000000000000f000000000000000000000000000000000000000;
129     uint256 private constant TOKEN_SELL_MASK = 0x000000000000000000000000000000000000000000000000ffff000000000000;
130     uint256 private constant TOKEN_BUY_MASK = 0x0000000000000000000000000000000000000000000000000000ffff00000000;
131     uint256 private constant SIGN_MASK = 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
132     uint256 private constant MATCH_SIGN_MASK = 0xfffffffffffffffffffffff00000000000000000000000000000000000000000;
133     uint256 private constant TOKEN_JOY_PRICE_MASK = 0x0000000000000000000000000fffffffffffffffffffffff0000000000000000;
134     uint256 private constant JOY_PRICE_MASK = 0x0000000000000000fffffff00000000000000000000000000000000000000000;
135     uint256 private constant IS_BUY_MASK = 0x00000000000000000000000f0000000000000000000000000000000000000000;
136     uint256 private constant TAKER_FEE_MASK = 0x00000000ffff0000000000000000000000000000000000000000000000000000;
137     uint256 private constant MAKER_FEE_MASK = 0x000000000000ffff000000000000000000000000000000000000000000000000;
138 
139     uint256 private constant PAY_BY_TOKEN = 0x0000000000000000000000020000000000000000000000000000000000000000;
140     uint256 private constant PAY_BY_JOY = 0x0000000000000000000000010000000000000000000000000000000000000000;
141     uint256 private constant ORDER_ISBUY = 0x0000000000000000000000010000000000000000000000000000000000000000;
142 
143     mapping (address => mapping (address => uint256)) private balances;
144     mapping (address => uint256) public userLock;
145     mapping (address => uint256) public userNonce;
146     mapping (bytes32 => uint256) public orderFills;
147     mapping (bytes32 => bool) public usedHash;
148     mapping (address => bool) public isAdmin;
149     mapping (uint256 => address) public tokenId2Address;
150     mapping (uint256 => address) public userId2Address;
151     mapping (address => uint256) public userAddress2Id;
152     mapping (address => uint256) public tokenAddress2Id;
153 
154     address public joysoWallet;
155     address public joyToken;
156     uint256 public lockPeriod = 30 days;
157     uint256 public userCount;
158     bool public tradeEventEnabled = true;
159 
160     modifier onlyAdmin {
161         require(msg.sender == owner || isAdmin[msg.sender]);
162         _;
163     }
164 
165     //events
166     event Deposit(address token, address user, uint256 amount, uint256 balance);
167     event Withdraw(address token, address user, uint256 amount, uint256 balance);
168     event NewUser(address user, uint256 id);
169     event Lock(address user, uint256 timeLock);
170 
171     // for debug
172     event TradeSuccess(address user, uint256 baseAmount, uint256 tokenAmount, bool isBuy, uint256 fee);
173 
174     function Joyso(address _joysoWallet, address _joyToken) public {
175         joysoWallet = _joysoWallet;
176         addUser(_joysoWallet);
177         joyToken = _joyToken;
178         tokenAddress2Id[joyToken] = 1;
179         tokenAddress2Id[0] = 0; // ether address is Id 0
180         tokenId2Address[0] = 0;
181         tokenId2Address[1] = joyToken;
182     }
183 
184     /**
185      * @notice deposit token into the contract
186      * @notice Be sure to Approve the contract to move your erc20 token
187      * @param token The address of deposited token
188      * @param amount The amount of token to deposit
189      */
190     function depositToken(address token, uint256 amount) external {
191         require(amount > 0);
192         require(tokenAddress2Id[token] != 0);
193         addUser(msg.sender);
194         require(ERC20(token).transferFrom(msg.sender, this, amount));
195         balances[token][msg.sender] = balances[token][msg.sender].add(amount);
196         Deposit(
197             token,
198             msg.sender,
199             amount,
200             balances[token][msg.sender]
201         );
202     }
203 
204     /**
205      * @notice deposit Ether into the contract
206      */
207     function depositEther() external payable {
208         require(msg.value > 0);
209         addUser(msg.sender);
210         balances[0][msg.sender] = balances[0][msg.sender].add(msg.value);
211         Deposit(
212             0,
213             msg.sender,
214             msg.value,
215             balances[0][msg.sender]
216         );
217     }
218 
219     /**
220      * @notice withdraw funds directly from contract
221      * @notice must claim by lockme first, after a period of time it would be valid
222      * @param token The address of withdrawed token, using address(0) to withdraw Ether
223      * @param amount The amount of token to withdraw
224      */
225     function withdraw(address token, uint256 amount) external {
226         require(amount > 0);
227         require(getTime() > userLock[msg.sender] && userLock[msg.sender] != 0);
228         balances[token][msg.sender] = balances[token][msg.sender].sub(amount);
229         if (token == 0) {
230             msg.sender.transfer(amount);
231         } else {
232             require(ERC20(token).transfer(msg.sender, amount));
233         }
234         Withdraw(
235             token,
236             msg.sender,
237             amount,
238             balances[token][msg.sender]
239         );
240     }
241 
242     /**
243      * @notice This function is used to claim to withdraw the funds
244      * @notice The matching server will automaticlly remove all un-touched orders
245      * @notice After a period of time, the claimed user can withdraw funds directly from contract without admins involved.
246      */
247     function lockMe() external {
248         require(userAddress2Id[msg.sender] != 0);
249         userLock[msg.sender] = getTime() + lockPeriod;
250         Lock(msg.sender, userLock[msg.sender]);
251     }
252 
253     /**
254      * @notice This function is used to revoke the claim of lockMe
255      */
256     function unlockMe() external {
257         require(userAddress2Id[msg.sender] != 0);
258         userLock[msg.sender] = 0;
259         Lock(msg.sender, 0);
260     }
261 
262     /**
263      * @notice set tradeEventEnabled, only owner
264      * @param enabled Set tradeEventEnabled if enabled
265      */
266     function setTradeEventEnabled(bool enabled) external onlyOwner {
267         tradeEventEnabled = enabled;
268     }
269 
270     /**
271      * @notice add/remove a address to admin list, only owner
272      * @param admin The address of the admin
273      * @param isAdd Set the address's status in admin list
274      */
275     function addToAdmin(address admin, bool isAdd) external onlyOwner {
276         isAdmin[admin] = isAdd;
277     }
278 
279     /**
280      * @notice collect the fee to owner's address, only owner
281      */
282     function collectFee(address token) external onlyOwner {
283         uint256 amount = balances[token][joysoWallet];
284         require(amount > 0);
285         balances[token][joysoWallet] = 0;
286         if (token == 0) {
287             msg.sender.transfer(amount);
288         } else {
289             require(ERC20(token).transfer(msg.sender, amount));
290         }
291         Withdraw(
292             token,
293             joysoWallet,
294             amount,
295             0
296         );
297     }
298 
299     /**
300      * @notice change lock period, only owner
301      * @dev can change from 1 days to 30 days, initial is 30 days
302      */
303     function changeLockPeriod(uint256 periodInDays) external onlyOwner {
304         require(periodInDays <= 30 && periodInDays >= 1);
305         lockPeriod = periodInDays * 1 days;
306     }
307 
308     /**
309      * @notice add a new token into the token list, only admins
310      * @dev index 0 & 1 are saved for Ether and JOY
311      * @dev both index & token can not be redundant, and no removed mathod
312      * @param tokenAddress token's address
313      * @param index chosen index of the token
314      */
315     function registerToken(address tokenAddress, uint256 index) external onlyAdmin {
316         require(index > 1);
317         require(tokenAddress2Id[tokenAddress] == 0);
318         require(tokenId2Address[index] == 0);
319         tokenAddress2Id[tokenAddress] = index;
320         tokenId2Address[index] = tokenAddress;
321     }
322 
323     /**
324      * @notice withdraw with admins involved, only admin
325      * @param inputs array of inputs, must have 5 elements
326      * @dev inputs encoding please reference github wiki
327      */
328     function withdrawByAdmin_Unau(uint256[] inputs) external onlyAdmin {
329         uint256 amount = inputs[0];
330         uint256 gasFee = inputs[1];
331         uint256 data = inputs[2];
332         uint256 paymentMethod = data & PAYMENT_METHOD_MASK;
333         address token = tokenId2Address[(data & WITHDRAW_TOKEN_MASK) >> 32];
334         address user = userId2Address[data & USER_MASK];
335         bytes32 hash = keccak256(
336             this,
337             amount,
338             gasFee,
339             data & SIGN_MASK | uint256(token)
340         );
341         require(!usedHash[hash]);
342         require(
343             verify(
344                 hash,
345                 user,
346                 uint8(data & V_MASK == 0 ? 27 : 28),
347                 bytes32(inputs[3]),
348                 bytes32(inputs[4])
349             )
350         );
351 
352         address gasToken = 0;
353         if (paymentMethod == PAY_BY_JOY) { // pay fee by JOY
354             gasToken = joyToken;
355         } else if (paymentMethod == PAY_BY_TOKEN) { // pay fee by tx token
356             gasToken = token;
357         }
358 
359         if (gasToken == token) { // pay by ether or token
360             balances[token][user] = balances[token][user].sub(amount.add(gasFee));
361         } else {
362             balances[token][user] = balances[token][user].sub(amount);
363             balances[gasToken][user] = balances[gasToken][user].sub(gasFee);
364         }
365         balances[gasToken][joysoWallet] = balances[gasToken][joysoWallet].add(gasFee);
366 
367         usedHash[hash] = true;
368 
369         if (token == 0) {
370             user.transfer(amount);
371         } else {
372             require(ERC20(token).transfer(user, amount));
373         }
374     }
375 
376     /**
377      * @notice match orders with admins involved, only admin
378      * @param inputs Array of input orders, each order have 6 elements. Inputs must conatin at least 2 orders.
379      * @dev inputs encoding please reference github wiki
380      */
381     function matchByAdmin_TwH36(uint256[] inputs) external onlyAdmin {
382         uint256 data = inputs[3];
383         address user = userId2Address[data & USER_MASK];
384         // check taker order nonce
385         require(data >> 224 > userNonce[user]);
386         address token;
387         bool isBuy;
388         (token, isBuy) = decodeOrderTokenAndIsBuy(data);
389         bytes32 orderHash = keccak256(
390             this,
391             inputs[0],
392             inputs[1],
393             inputs[2],
394             data & MATCH_SIGN_MASK | (isBuy ? ORDER_ISBUY : 0) | uint256(token)
395         );
396         require(
397             verify(
398                 orderHash,
399                 user,
400                 uint8(data & V_MASK == 0 ? 27 : 28),
401                 bytes32(inputs[4]),
402                 bytes32(inputs[5])
403             )
404         );
405 
406         uint256 tokenExecute = isBuy ? inputs[1] : inputs[0]; // taker order token execute
407         tokenExecute = tokenExecute.sub(orderFills[orderHash]);
408         require(tokenExecute != 0); // the taker order should remain something to trade
409         uint256 etherExecute = 0;  // taker order ether execute
410 
411         isBuy = !isBuy;
412         for (uint256 i = 6; i < inputs.length; i += 6) {
413             //check price, maker price should lower than taker price
414             require(tokenExecute > 0 && inputs[1].mul(inputs[i + 1]) <= inputs[0].mul(inputs[i]));
415 
416             data = inputs[i + 3];
417             user = userId2Address[data & USER_MASK];
418             // check maker order nonce
419             require(data >> 224 > userNonce[user]);
420             bytes32 makerOrderHash = keccak256(
421                 this,
422                 inputs[i],
423                 inputs[i + 1],
424                 inputs[i + 2],
425                 data & MATCH_SIGN_MASK | (isBuy ? ORDER_ISBUY : 0) | uint256(token)
426             );
427             require(
428                 verify(
429                     makerOrderHash,
430                     user,
431                     uint8(data & V_MASK == 0 ? 27 : 28),
432                     bytes32(inputs[i + 4]),
433                     bytes32(inputs[i + 5])
434                 )
435             );
436             (tokenExecute, etherExecute) = internalTrade(
437                 inputs[i],
438                 inputs[i + 1],
439                 inputs[i + 2],
440                 data,
441                 tokenExecute,
442                 etherExecute,
443                 isBuy,
444                 token,
445                 0,
446                 makerOrderHash
447             );
448         }
449 
450         isBuy = !isBuy;
451         tokenExecute = isBuy ? inputs[1].sub(tokenExecute) : inputs[0].sub(tokenExecute);
452         tokenExecute = tokenExecute.sub(orderFills[orderHash]);
453         processTakerOrder(inputs[2], inputs[3], tokenExecute, etherExecute, isBuy, token, 0, orderHash);
454     }
455 
456     /**
457      * @notice match token orders with admins involved, only admin
458      * @param inputs Array of input orders, each order have 6 elements. Inputs must conatin at least 2 orders.
459      * @dev inputs encoding please reference github wiki
460      */
461     function matchTokenOrderByAdmin_k44j(uint256[] inputs) external onlyAdmin {
462         address user = userId2Address[decodeOrderUserId(inputs[3])];
463         // check taker order nonce
464         require(inputs[3] >> 224 > userNonce[user]);
465         address token;
466         address base;
467         bool isBuy;
468         (token, base, isBuy) = decodeTokenOrderTokenAndIsBuy(inputs[3]);
469         bytes32 orderHash = getTokenOrderDataHash(inputs, 0, inputs[3], token, base);
470         require(
471             verify(
472                 orderHash,
473                 user,
474                 uint8(retrieveV(inputs[3])),
475                 bytes32(inputs[4]),
476                 bytes32(inputs[5])
477             )
478         );
479         uint256 tokenExecute = isBuy ? inputs[1] : inputs[0]; // taker order token execute
480         tokenExecute = tokenExecute.sub(orderFills[orderHash]);
481         require(tokenExecute != 0); // the taker order should remain something to trade
482         uint256 baseExecute = 0;  // taker order ether execute
483 
484         isBuy = !isBuy;
485         for (uint256 i = 6; i < inputs.length; i += 6) {
486             //check price, taker price should better than maker price
487             require(tokenExecute > 0 && inputs[1].mul(inputs[i + 1]) <= inputs[0].mul(inputs[i]));
488 
489             user = userId2Address[decodeOrderUserId(inputs[i + 3])];
490             // check maker order nonce
491             require(inputs[i + 3] >> 224 > userNonce[user]);
492             bytes32 makerOrderHash = getTokenOrderDataHash(inputs, i, inputs[i + 3], token, base);
493             require(
494                 verify(
495                     makerOrderHash,
496                     user,
497                     uint8(retrieveV(inputs[i + 3])),
498                     bytes32(inputs[i + 4]),
499                     bytes32(inputs[i + 5])
500                 )
501             );
502             (tokenExecute, baseExecute) = internalTrade(
503                 inputs[i],
504                 inputs[i + 1],
505                 inputs[i + 2],
506                 inputs[i + 3],
507                 tokenExecute,
508                 baseExecute,
509                 isBuy,
510                 token,
511                 base,
512                 makerOrderHash
513             );
514         }
515 
516         isBuy = !isBuy;
517         tokenExecute = isBuy ? inputs[1].sub(tokenExecute) : inputs[0].sub(tokenExecute);
518         tokenExecute = tokenExecute.sub(orderFills[orderHash]);
519         processTakerOrder(inputs[2], inputs[3], tokenExecute, baseExecute, isBuy, token, base, orderHash);
520     }
521 
522     /**
523      * @notice update user on-chain nonce with admins involved, only admin
524      * @param inputs Array of input data, must have 4 elements.
525      * @dev inputs encoding please reference github wiki
526      */
527     function cancelByAdmin(uint256[] inputs) external onlyAdmin {
528         uint256 data = inputs[1];
529         uint256 nonce = data >> 224;
530         address user = userId2Address[data & USER_MASK];
531         require(nonce > userNonce[user]);
532         uint256 gasFee = inputs[0];
533         require(
534             verify(
535                 keccak256(this, gasFee, data & SIGN_MASK),
536                 user,
537                 uint8(retrieveV(data)),
538                 bytes32(inputs[2]),
539                 bytes32(inputs[3])
540             )
541         );
542 
543         // update balance
544         address gasToken = 0;
545         if (data & PAYMENT_METHOD_MASK == PAY_BY_JOY) {
546             gasToken = joyToken;
547         }
548         require(balances[gasToken][user] >= gasFee);
549         balances[gasToken][user] = balances[gasToken][user].sub(gasFee);
550         balances[gasToken][joysoWallet] = balances[gasToken][joysoWallet].add(gasFee);
551 
552         // update user nonce
553         userNonce[user] = nonce;
554     }
555 
556     /**
557      * @notice batch send the current balance to the new version contract
558      * @param inputs Array of input data
559      * @dev inputs encoding please reference github wiki
560      */
561     function migrateByAdmin_DQV(uint256[] inputs) external onlyAdmin {
562         uint256 data = inputs[2];
563         address token = tokenId2Address[(data & WITHDRAW_TOKEN_MASK) >> 32];
564         address newContract = address(inputs[0]);
565         for (uint256 i = 1; i < inputs.length; i += 4) {
566             uint256 gasFee = inputs[i];
567             data = inputs[i + 1];
568             address user = userId2Address[data & USER_MASK];
569             bytes32 hash = keccak256(
570                 this,
571                 gasFee,
572                 data & SIGN_MASK | uint256(token),
573                 newContract
574             );
575             require(
576                 verify(
577                     hash,
578                     user,
579                     uint8(data & V_MASK == 0 ? 27 : 28),
580                     bytes32(inputs[i + 2]),
581                     bytes32(inputs[i + 3])
582                 )
583             );
584             if (gasFee > 0) {
585                 uint256 paymentMethod = data & PAYMENT_METHOD_MASK;
586                 if (paymentMethod == PAY_BY_JOY) {
587                     balances[joyToken][user] = balances[joyToken][user].sub(gasFee);
588                     balances[joyToken][joysoWallet] = balances[joyToken][joysoWallet].add(gasFee);
589                 } else if (paymentMethod == PAY_BY_TOKEN) {
590                     balances[token][user] = balances[token][user].sub(gasFee);
591                     balances[token][joysoWallet] = balances[token][joysoWallet].add(gasFee);
592                 } else {
593                     balances[0][user] = balances[0][user].sub(gasFee);
594                     balances[0][joysoWallet] = balances[0][joysoWallet].add(gasFee);
595                 }
596             }
597             uint256 amount = balances[token][user];
598             balances[token][user] = 0;
599             if (token == 0) {
600                 Migratable(newContract).migrate.value(amount)(user, amount, token);
601             } else {
602                 ERC20(token).approve(newContract, amount);
603                 Migratable(newContract).migrate(user, amount, token);
604             }
605         }
606     }
607 
608     /**
609      * @notice transfer token from admin to users
610      * @param token address of token
611      * @param account receiver's address
612      * @param amount amount to transfer
613      */
614     function transferForAdmin(address token, address account, uint256 amount) onlyAdmin external {
615         require(tokenAddress2Id[token] != 0);
616         require(userAddress2Id[msg.sender] != 0);
617         addUser(account);
618         balances[token][msg.sender] = balances[token][msg.sender].sub(amount);
619         balances[token][account] = balances[token][account].add(amount);
620     }
621 
622     /**
623      * @notice get balance information
624      * @param token address of token
625      * @param account address of user
626      */
627     function getBalance(address token, address account) external view returns (uint256) {
628         return balances[token][account];
629     }
630 
631     /**
632      * @dev get tokenId and check the order is a buy order or not, internal
633      *      tokenId take 4 bytes
634      *      isBuy is true means this order is buying token
635      */
636     function decodeOrderTokenAndIsBuy(uint256 data) internal view returns (address token, bool isBuy) {
637         uint256 tokenId = (data & TOKEN_SELL_MASK) >> 48;
638         if (tokenId == 0) {
639             token = tokenId2Address[(data & TOKEN_BUY_MASK) >> 32];
640             isBuy = true;
641         } else {
642             token = tokenId2Address[tokenId];
643         }
644     }
645 
646     /**
647      * @dev decode token oreder data, internal
648      */
649     function decodeTokenOrderTokenAndIsBuy(uint256 data) internal view returns (address token, address base, bool isBuy) {
650         isBuy = data & IS_BUY_MASK == ORDER_ISBUY;
651         if (isBuy) {
652             token = tokenId2Address[(data & TOKEN_BUY_MASK) >> 32];
653             base = tokenId2Address[(data & TOKEN_SELL_MASK) >> 48];
654         } else {
655             token = tokenId2Address[(data & TOKEN_SELL_MASK) >> 48];
656             base = tokenId2Address[(data & TOKEN_BUY_MASK) >> 32];
657         }
658     }
659 
660     function getTime() internal view returns (uint256) {
661         return now;
662     }
663 
664     /**
665      * @dev get token order's hash for user to sign, internal
666      * @param inputs forword tokenOrderMatch's input to this function
667      * @param offset offset of the order in inputs
668      */
669     function getTokenOrderDataHash(uint256[] inputs, uint256 offset, uint256 data, address token, address base) internal view returns (bytes32) {
670         return keccak256(
671             this,
672             inputs[offset],
673             inputs[offset + 1],
674             inputs[offset + 2],
675             data & SIGN_MASK | uint256(token),
676             base,
677             (data & TOKEN_JOY_PRICE_MASK) >> 64
678         );
679     }
680 
681     /**
682      * @dev check if the provided signature is valid, internal
683      * @param hash signed information
684      * @param sender signer address
685      * @param v sig_v
686      * @param r sig_r
687      * @param s sig_s
688      */
689     function verify(bytes32 hash, address sender, uint8 v, bytes32 r, bytes32 s) internal pure returns (bool) {
690         return ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) == sender;
691     }
692 
693     /**
694      * @dev give a new user an id, intrnal
695      */
696     function addUser(address _address) internal {
697         if (userAddress2Id[_address] != 0) {
698             return;
699         }
700         userCount += 1;
701         userAddress2Id[_address] = userCount;
702         userId2Address[userCount] = _address;
703         NewUser(_address, userCount);
704     }
705 
706     function processTakerOrder(
707         uint256 gasFee,
708         uint256 data,
709         uint256 tokenExecute,
710         uint256 baseExecute,
711         bool isBuy,
712         address token,
713         address base,
714         bytes32 orderHash
715     )
716         internal
717     {
718         uint256 fee = calculateFee(gasFee, data, baseExecute, orderHash, true, base == 0);
719         updateUserBalance(data, isBuy, baseExecute, tokenExecute, fee, token, base);
720         orderFills[orderHash] = orderFills[orderHash].add(tokenExecute);
721         if (tradeEventEnabled) {
722             TradeSuccess(userId2Address[data & USER_MASK], baseExecute, tokenExecute, isBuy, fee);
723         }
724     }
725 
726     function internalTrade(
727         uint256 amountSell,
728         uint256 amountBuy,
729         uint256 gasFee,
730         uint256 data,
731         uint256 _remainingToken,
732         uint256 _baseExecute,
733         bool isBuy,
734         address token,
735         address base,
736         bytes32 orderHash
737     )
738         internal returns (uint256 remainingToken, uint256 baseExecute)
739     {
740         uint256 tokenGet = calculateTokenGet(amountSell, amountBuy, _remainingToken, isBuy, orderHash);
741         uint256 baseGet = calculateBaseGet(amountSell, amountBuy, isBuy, tokenGet);
742         uint256 fee = calculateFee(gasFee, data, baseGet, orderHash, false, base == 0);
743         updateUserBalance(data, isBuy, baseGet, tokenGet, fee, token, base);
744         orderFills[orderHash] = orderFills[orderHash].add(tokenGet);
745         remainingToken = _remainingToken.sub(tokenGet);
746         baseExecute = _baseExecute.add(baseGet);
747         if (tradeEventEnabled) {
748             TradeSuccess(
749                 userId2Address[data & USER_MASK],
750                 baseGet,
751                 tokenGet,
752                 isBuy,
753                 fee
754             );
755         }
756     }
757 
758     function updateUserBalance(
759         uint256 data,
760         bool isBuy,
761         uint256 baseGet,
762         uint256 tokenGet,
763         uint256 fee,
764         address token,
765         address base
766     )
767         internal
768     {
769         address user = userId2Address[data & USER_MASK];
770         uint256 baseFee = fee;
771         uint256 joyFee = 0;
772         if ((base == 0 ? (data & JOY_PRICE_MASK) >> 164 : (data & TOKEN_JOY_PRICE_MASK) >> 64) != 0) {
773             joyFee = fee;
774             baseFee = 0;
775         }
776 
777         if (isBuy) { // buy token, sell ether
778             balances[base][user] = balances[base][user].sub(baseGet).sub(baseFee);
779             balances[token][user] = balances[token][user].add(tokenGet);
780         } else {
781             balances[base][user] = balances[base][user].add(baseGet).sub(baseFee);
782             balances[token][user] = balances[token][user].sub(tokenGet);
783         }
784 
785         if (joyFee != 0) {
786             balances[joyToken][user] = balances[joyToken][user].sub(joyFee);
787             balances[joyToken][joysoWallet] = balances[joyToken][joysoWallet].add(joyFee);
788         } else {
789             balances[base][joysoWallet] = balances[base][joysoWallet].add(baseFee);
790         }
791     }
792 
793     function calculateFee(
794         uint256 gasFee,
795         uint256 data,
796         uint256 baseGet,
797         bytes32 orderHash,
798         bool isTaker,
799         bool isEthOrder
800     )
801         internal view returns (uint256)
802     {
803         uint256 fee = orderFills[orderHash] == 0 ? gasFee : 0;
804         uint256 txFee = baseGet.mul(isTaker ? (data & TAKER_FEE_MASK) >> 208 : (data & MAKER_FEE_MASK) >> 192) / 10000;
805         uint256 joyPrice = isEthOrder ? (data & JOY_PRICE_MASK) >> 164 : (data & TOKEN_JOY_PRICE_MASK) >> 64;
806         if (joyPrice != 0) {
807             txFee = isEthOrder ? txFee / (10 ** 5) / joyPrice : txFee * (10 ** 12) / joyPrice;
808         }
809         return fee.add(txFee);
810     }
811 
812     function calculateBaseGet(
813         uint256 amountSell,
814         uint256 amountBuy,
815         bool isBuy,
816         uint256 tokenGet
817     )
818         internal pure returns (uint256)
819     {
820         return isBuy ? tokenGet.mul(amountSell) / amountBuy : tokenGet.mul(amountBuy) / amountSell;
821     }
822 
823     function calculateTokenGet(
824         uint256 amountSell,
825         uint256 amountBuy,
826         uint256 remainingToken,
827         bool isBuy,
828         bytes32 orderHash
829     )
830         internal view returns (uint256)
831     {
832         uint256 makerRemainingToken = isBuy ? amountBuy : amountSell;
833         makerRemainingToken = makerRemainingToken.sub(orderFills[orderHash]);
834         require(makerRemainingToken > 0); // the maker order should remain something to trade
835         return makerRemainingToken >= remainingToken ? remainingToken : makerRemainingToken;
836     }
837 }