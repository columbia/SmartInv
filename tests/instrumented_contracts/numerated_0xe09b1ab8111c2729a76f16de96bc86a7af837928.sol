1 pragma solidity ^0.4.24;
2 
3 /* This is fiftyflip 
4 a simple yet elegant game contract 
5 that is connected to Proof of Community 
6 contract(0x1739e311ddBf1efdFbc39b74526Fd8b600755ADa).
7 
8 Greed serves no-one but the one, 
9 But charity is kind, suffereth not and envieth not. 
10 Charity is to give of oneself in the service of his fellow beings. 
11 
12 Play on Players. and Remember fifty feeds the multiudes and gives to the PoC community
13 Forever and ever. 
14 
15 
16 */
17 
18 
19 contract FiftyFlip {
20     uint constant DONATING_X = 20; // 2% kujira
21 
22     // Need to be discussed
23     uint constant JACKPOT_FEE = 10; // 1% jackpot
24     uint constant JACKPOT_MODULO = 1000; // 0.1% jackpotwin
25     uint constant DEV_FEE = 20; // 2% devfee
26     uint constant WIN_X = 1900; // 1.9x
27 
28     // There is minimum and maximum bets.
29     uint constant MIN_BET = 0.01 ether;
30     uint constant MAX_BET = 1 ether;
31 
32     uint constant BET_EXPIRATION_BLOCKS = 250;
33 
34     // owner and PoC contract address
35     address public owner;
36     address public autoPlayBot;
37     address public secretSigner;
38     address private whale;
39 
40     // Accumulated jackpot fund.
41     uint256 public jackpotSize;
42     uint256 public devFeeSize;
43 
44     // Funds that are locked in potentially winning bets.
45     uint256 public lockedInBets;
46     uint256 public totalAmountToWhale;
47 
48 
49     struct Bet {
50         // Wager amount in wei.
51         uint amount;
52         // Block number of placeBet tx.
53         uint256 blockNumber;
54         // Bit mask representing winning bet outcomes (see MAX_MASK_MODULO comment).
55         bool betMask;
56         // Address of a player, used to pay out winning bets.
57         address player;
58     }
59 
60     mapping (uint => Bet) bets;
61     mapping (address => uint) donateAmount;
62 
63     // events
64     event Wager(uint ticketID, uint betAmount, uint256 betBlockNumber, bool betMask, address betPlayer);
65     event Win(address winner, uint amount, uint ticketID, bool maskRes, uint jackpotRes);
66     event Lose(address loser, uint amount, uint ticketID, bool maskRes, uint jackpotRes);
67     event Refund(uint ticketID, uint256 amount, address requester);
68     event Donate(uint256 amount, address donator);
69     event FailedPayment(address paidUser, uint amount);
70     event Payment(address noPaidUser, uint amount);
71     event JackpotPayment(address player, uint ticketID, uint jackpotWin);
72 
73     // constructor
74     constructor (address whaleAddress, address autoPlayBotAddress, address secretSignerAddress) public {
75         owner = msg.sender;
76         autoPlayBot = autoPlayBotAddress;
77         whale = whaleAddress;
78         secretSigner = secretSignerAddress;
79         jackpotSize = 0;
80         devFeeSize = 0;
81         lockedInBets = 0;
82         totalAmountToWhale = 0;
83     }
84 
85     // modifiers
86     modifier onlyOwner() {
87         require (msg.sender == owner, "You are not the owner of this contract!");
88         _;
89     }    
90 
91     modifier onlyBot() {
92         require (msg.sender == autoPlayBot, "You are not the bot of this contract!");
93         _;
94     }
95     
96     modifier checkContractHealth() {
97         require (address(this).balance >= lockedInBets + jackpotSize + devFeeSize, "This contract doesn't have enough balance, it is stopped till someone donate to this game!");
98         _;
99     }
100 
101     // betMast:
102     // false is front, true is back
103 
104     function() public payable { }
105 
106 
107     function setBotAddress(address autoPlayBotAddress)
108     onlyOwner() 
109     external 
110     {
111         autoPlayBot = autoPlayBotAddress;
112     }
113 
114     function setSecretSigner(address _secretSigner)
115     onlyOwner()  
116     external
117     {
118         secretSigner = _secretSigner;
119     }
120 
121     // wager function
122     function wager(bool bMask, uint ticketID, uint ticketLastBlock, uint8 v, bytes32 r, bytes32 s)  
123     checkContractHealth()
124     external
125     payable { 
126         Bet storage bet = bets[ticketID];
127         uint amount = msg.value;
128         address player = msg.sender;
129         require (bet.player == address(0), "Ticket is not new one!");
130         require (amount >= MIN_BET, "Your bet is lower than minimum bet amount");
131         require (amount <= MAX_BET, "Your bet is higher than maximum bet amount");
132         require (getCollateralBalance() >= 2 * amount, "If we accept this, this contract will be in danger!");
133 
134         require (block.number <= ticketLastBlock, "Ticket has expired.");
135         bytes32 signatureHash = keccak256(abi.encodePacked('\x19Ethereum Signed Message:\n37', uint40(ticketLastBlock), ticketID));
136         require (secretSigner == ecrecover(signatureHash, v, r, s), "web3 vrs signature is not valid.");
137 
138         jackpotSize += amount * JACKPOT_FEE / 1000;
139         devFeeSize += amount * DEV_FEE / 1000;
140         lockedInBets += amount * WIN_X / 1000;
141 
142         uint donate_amount = amount * DONATING_X / 1000;
143         whale.call.value(donate_amount)(bytes4(keccak256("donate()")));
144         totalAmountToWhale += donate_amount;
145 
146         bet.amount = amount;
147         bet.blockNumber = block.number;
148         bet.betMask = bMask;
149         bet.player = player;
150 
151         emit Wager(ticketID, bet.amount, bet.blockNumber, bet.betMask, bet.player);
152     }
153 
154     // method to determine winners and losers
155     function play(uint ticketReveal)
156     checkContractHealth()
157     external
158     {
159         uint ticketID = uint(keccak256(abi.encodePacked(ticketReveal)));
160         Bet storage bet = bets[ticketID];
161         require (bet.player != address(0), "TicketID is not correct!");
162         require (bet.amount != 0, "Ticket is already used one!");
163         uint256 blockNumber = bet.blockNumber;
164         if(blockNumber < block.number && blockNumber >= block.number - BET_EXPIRATION_BLOCKS)
165         {
166             uint256 random = uint256(keccak256(abi.encodePacked(blockhash(blockNumber),  ticketReveal)));
167             bool maskRes = (random % 2) !=0;
168             uint jackpotRes = random % JACKPOT_MODULO;
169     
170             uint tossWinAmount = bet.amount * WIN_X / 1000;
171 
172             uint tossWin = 0;
173             uint jackpotWin = 0;
174             
175             if(bet.betMask == maskRes) {
176                 tossWin = tossWinAmount;
177             }
178             if(jackpotRes == 0) {
179                 jackpotWin = jackpotSize;
180                 jackpotSize = 0;
181             }
182             if (jackpotWin > 0) {
183                 emit JackpotPayment(bet.player, ticketID, jackpotWin);
184             }
185             if(tossWin + jackpotWin > 0)
186             {
187                 payout(bet.player, tossWin + jackpotWin, ticketID, maskRes, jackpotRes);
188             }
189             else 
190             {
191                 loseWager(bet.player, bet.amount, ticketID, maskRes, jackpotRes);
192             }
193             lockedInBets -= tossWinAmount;
194             bet.amount = 0;
195         }
196         else
197         {
198             revert();
199         }
200     }
201 
202     function donateForContractHealth()
203     external 
204     payable
205     {
206         donateAmount[msg.sender] += msg.value;
207         emit Donate(msg.value, msg.sender);
208     }
209 
210     function withdrawDonation(uint amount)
211     external 
212     {
213         require(donateAmount[msg.sender] >= amount, "You are going to withdraw more than you donated!");
214         
215         if (sendFunds(msg.sender, amount)){
216             donateAmount[msg.sender] -= amount;
217         }
218     }
219 
220     // method to refund
221     function refund(uint ticketID)
222     checkContractHealth()
223     external {
224         Bet storage bet = bets[ticketID];
225         
226         require (bet.amount != 0, "this ticket has no balance");
227         require (block.number > bet.blockNumber + BET_EXPIRATION_BLOCKS, "this ticket is expired.");
228         sendRefund(ticketID);
229     }
230 
231     // Funds withdrawl
232     function withdrawDevFee(address withdrawAddress, uint withdrawAmount)
233     onlyOwner()
234     checkContractHealth() 
235     external {
236         require (devFeeSize >= withdrawAmount, "You are trying to withdraw more amount than developer fee.");
237         require (withdrawAmount <= address(this).balance, "Contract balance is lower than withdrawAmount");
238         require (devFeeSize <= address(this).balance, "Not enough funds to withdraw.");
239         if (sendFunds(withdrawAddress, withdrawAmount)){
240             devFeeSize -= withdrawAmount;
241         }
242     }
243 
244     // Funds withdrawl
245     function withdrawBotFee(uint withdrawAmount)
246     onlyBot()
247     checkContractHealth() 
248     external {
249         require (devFeeSize >= withdrawAmount, "You are trying to withdraw more amount than developer fee.");
250         require (withdrawAmount <= address(this).balance, "Contract balance is lower than withdrawAmount");
251         require (devFeeSize <= address(this).balance, "Not enough funds to withdraw.");
252         if (sendFunds(autoPlayBot, withdrawAmount)){
253             devFeeSize -= withdrawAmount;
254         }
255     }
256 
257     // Get Bet Info from id
258     function getBetInfo(uint ticketID) 
259     constant
260     external 
261     returns (uint, uint256, bool, address){
262         Bet storage bet = bets[ticketID];
263         return (bet.amount, bet.blockNumber, bet.betMask, bet.player);
264     }
265 
266     // Get Bet Info from id
267     function getContractBalance() 
268     constant
269     external 
270     returns (uint){
271         return address(this).balance;
272     }
273 
274     // Get Collateral for Bet
275     function getCollateralBalance() 
276     constant
277     public 
278     returns (uint){
279         if (address(this).balance > lockedInBets + jackpotSize + devFeeSize)
280             return address(this).balance - lockedInBets - jackpotSize - devFeeSize;
281         return 0;
282     }
283 
284     // Contract may be destroyed only when there are no ongoing bets,
285     // either settled or refunded. All funds are transferred to contract owner.
286     function kill() external onlyOwner() {
287         require (lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
288         selfdestruct(owner);
289     }
290 
291     // Payout ETH to winner
292     function payout(address winner, uint ethToTransfer, uint ticketID, bool maskRes, uint jackpotRes) 
293     internal 
294     {        
295         winner.transfer(ethToTransfer);
296         emit Win(winner, ethToTransfer, ticketID, maskRes, jackpotRes);
297     }
298 
299     // sendRefund to requester
300     function sendRefund(uint ticketID) 
301     internal 
302     {
303         Bet storage bet = bets[ticketID];
304         address requester = bet.player;
305         uint256 ethToTransfer = bet.amount;        
306         requester.transfer(ethToTransfer);
307 
308         uint tossWinAmount = bet.amount * WIN_X / 1000;
309         lockedInBets -= tossWinAmount;
310 
311         bet.amount = 0;
312         emit Refund(ticketID, ethToTransfer, requester);
313     }
314 
315     // Helper routine to process the payment.
316     function sendFunds(address paidUser, uint amount) private returns (bool){
317         bool success = paidUser.send(amount);
318         if (success) {
319             emit Payment(paidUser, amount);
320         } else {
321             emit FailedPayment(paidUser, amount);
322         }
323         return success;
324     }
325     // Payout ETH to whale when player loses
326     function loseWager(address player, uint amount, uint ticketID, bool maskRes, uint jackpotRes) 
327     internal 
328     {
329         emit Lose(player, amount, ticketID, maskRes, jackpotRes);
330     }
331 
332     // bulk clean the storage.
333     function clearStorage(uint[] toCleanTicketIDs) external {
334         uint length = toCleanTicketIDs.length;
335 
336         for (uint i = 0; i < length; i++) {
337             clearProcessedBet(toCleanTicketIDs[i]);
338         }
339     }
340 
341     // Helper routine to move 'processed' bets into 'clean' state.
342     function clearProcessedBet(uint ticketID) private {
343         Bet storage bet = bets[ticketID];
344 
345         // Do not overwrite active bets with zeros; additionally prevent cleanup of bets
346         // for which ticketID signatures may have not expired yet (see whitepaper for details).
347         if (bet.amount != 0 || block.number <= bet.blockNumber + BET_EXPIRATION_BLOCKS) {
348             return;
349         }
350 
351         bet.blockNumber = 0;
352         bet.betMask = false;
353         bet.player = address(0);
354     }
355 
356     // A trap door for when someone sends tokens other than the intended ones so the overseers can decide where to send them.
357     function transferAnyERC20Token(address tokenAddress, address tokenOwner, uint tokens) 
358     public 
359     onlyOwner() 
360     returns (bool success) 
361     {
362         return ERC20Interface(tokenAddress).transfer(tokenOwner, tokens);
363     }
364 }
365 
366 //Define ERC20Interface.transfer, so PoCWHALE can transfer tokens accidently sent to it.
367 contract ERC20Interface 
368 {
369     function transfer(address to, uint256 tokens) public returns (bool success);
370 }