1 pragma solidity ^0.4.25;
2 
3 /*
4 * https://12hourauction.github.io
5 */
6 // THT Token Owners 10% (instantly)
7 // Referral 10% (can withdraw instantly)
8 // Key holders’ dividend: 30% (instantly? Till the end?)
9 // Marketing: 5%
10 // Final pot: 30%
11 // Next pot: 15%
12 // Total: 100%
13 
14 library SafeMath {
15 
16     /**
17     * @dev Multiplies two numbers, throws on overflow.
18     */
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         if (a == 0) {
21             return 0;
22         }
23         uint256 c = a * b;
24         assert(c / a == b);
25         return c;
26     }
27 
28     /**
29     * @dev Integer division of two numbers, truncating the quotient.
30     */
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         // assert(b > 0); // Solidity automatically throws when dividing by 0
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35         return c;
36     }
37 
38     /**
39     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40     */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         assert(b <= a);
43         return a - b;
44     }
45 
46     /**
47     * @dev Adds two numbers, throws on overflow.
48     */
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         assert(c >= a);
52         return c;
53     }
54 
55     function min(uint256 a, uint256 b) internal pure returns (uint256) {
56         return a < b ? a : b;
57     }
58 }
59 interface TwelveHourTokenInterface {
60      function fallback() external payable; 
61      function buy(address _referredBy) external payable returns (uint256);
62      function exit() external;
63 }
64 
65 contract TwelveHourAuction {
66 
67     bool init = false;
68     using SafeMath for uint256;
69     
70     address owner;
71     uint256 public round     = 0;
72     uint256 public nextPot   = 0;
73     uint256 public profitTHT = 0;
74     // setting percent twelve hour auction
75     uint256 constant private THT_TOKEN_OWNERS     = 10;
76     uint256 constant private KEY_HOLDERS_DIVIDEND = 30;
77     uint256 constant private REFERRAL             = 10;
78     uint256 constant private FINAL_POT            = 30;
79     // uint256 constant private NEXT_POT             = 15;
80     uint256 constant private MARKETING            = 5;
81 
82     uint256 constant private MAGINITUDE           = 2 ** 64;
83     uint256 constant private HALF_TIME            = 12 hours;
84     uint256 constant private KEY_PRICE_DEFAULT    = 0.005 ether;
85     uint256 constant private VERIFY_REFERRAL_PRICE= 0.01 ether;
86     // uint256 public stakingRequirement = 2 ether;
87     address public twelveHourTokenAddress;
88     TwelveHourTokenInterface public TwelveHourToken; 
89 
90     /** 
91     * @dev game information
92     */
93     mapping(uint256 => Game) public games;
94     // bonus info
95     mapping(address => Player) public players;
96 
97     mapping(address => bool) public referrals;
98 
99     address[10] public teamMarketing;
100 
101     struct Game {
102         uint256 round;
103         uint256 finalPot;
104         uint256 profitPerShare;
105         address keyHolder;
106         uint256 keyLevel;
107         uint256 endTime;
108         bool ended; 
109     }
110     // distribute gen portion to key holders
111     struct Player {
112       uint256 curentRound;
113       uint256 lastRound;
114       uint256 bonus;
115       uint256 keys; // total key in round
116       uint256 dividends;
117       uint256 referrals;
118       int256 payouts;
119     }
120     event Buy(uint256 round, address buyer, uint256 amount, uint256 keyLevel);
121     event EndRound(uint256 round, uint256 finalPot, address keyHolder, uint256 keyLevel, uint256 endTime);
122     event Withdraw(address player, uint256 amount);
123     event WithdrawReferral(address player, uint256 amount);
124     modifier onlyOwner() 
125     {
126       require(msg.sender == owner);
127       _;
128     }
129     modifier disableContract()
130     {
131       require(tx.origin == msg.sender);
132       _;
133     }
134     constructor() public 
135     {
136       owner = msg.sender;
137       // setting default team marketing
138       for (uint256 idx = 0; idx < 10; idx++) {
139         teamMarketing[idx] = owner;
140       }
141     }
142     function () public payable
143     {
144         if (msg.sender != twelveHourTokenAddress) buy(0x0);
145     }
146     /**
147     * @dev set TwelveHourToken contract
148     * @param _addr TwelveHourToken address
149     */
150     function setTwelveHourToken(address _addr) public onlyOwner
151     {
152       twelveHourTokenAddress = _addr;
153       TwelveHourToken = TwelveHourTokenInterface(twelveHourTokenAddress);  
154     }
155     function setTeamMaketing(address _addr, uint256 _idx) public onlyOwner
156     {
157       teamMarketing[_idx] = _addr;
158     }
159     function verifyReferrals() public payable disableContract
160     {
161       require(msg.value >= VERIFY_REFERRAL_PRICE);
162       referrals[msg.sender] = true;
163       owner.transfer(msg.value);
164     }
165     // --------------------------------------------------------------------------
166     // SETUP GAME
167     // --------------------------------------------------------------------------
168     function startGame() public onlyOwner
169     {
170       require(init == false);
171       init = true;
172       games[round].ended = true;
173       startRound();
174     }
175     function startRound() private
176     {
177       require(games[round].ended == true);
178        
179       round = round + 1;
180       uint256 endTime = now + HALF_TIME;
181  
182       games[round] = Game(round, nextPot, 0, 0x0, 1, endTime, false);
183       nextPot = 0;
184     }
185     function endRound() private disableContract
186     {
187       require(games[round].ended == false && games[round].endTime <= now);
188 
189       Game storage g = games[round];
190       address keyHolder = g.keyHolder;
191       g.ended = true;
192       players[keyHolder].bonus += g.finalPot;
193       startRound();
194 
195       // uint256 round, uint256 finalPot, address keyHolder, uint256 keyLevel, uint256 endTime
196 
197       emit EndRound(g.round, g.finalPot, g.keyHolder, g.keyLevel, g.endTime);
198     }
199     // ------------------------------------------------------------------------------
200     // BUY KEY
201     // ------------------------------------------------------------------------------
202     function buy(address _referral) public payable disableContract
203     {
204       require(init == true);
205       require(games[round].ended == false);
206       require(msg.sender != _referral);
207 
208       if (games[round].endTime <= now) endRound();
209       Game storage g   = games[round];
210 
211       uint256 keyPrice       = SafeMath.mul(g.keyLevel, KEY_PRICE_DEFAULT);
212       uint256 repay          = SafeMath.sub(msg.value, keyPrice); 
213       //
214       uint256 _referralBonus = SafeMath.div(SafeMath.mul(keyPrice, REFERRAL), 100);
215       uint256 _profitTHT     = SafeMath.div(SafeMath.mul(keyPrice, THT_TOKEN_OWNERS), 100);
216       uint256 _dividends     = SafeMath.div(SafeMath.mul(keyPrice, KEY_HOLDERS_DIVIDEND), 100);
217       uint256 _marketingFee  = SafeMath.div(SafeMath.mul(keyPrice, MARKETING), 100);
218       uint256 _finalPot      = SafeMath.div(SafeMath.mul(keyPrice, FINAL_POT), 100); 
219       uint256 _nextPot       = keyPrice - (_referralBonus + _profitTHT + _dividends + _marketingFee + _finalPot);
220       if (msg.value < keyPrice) revert();
221       if (repay > 0) msg.sender.transfer(repay); // repay to player
222       if (_referral != 0x0 && referrals[_referral] == true) players[_referral].referrals += _referralBonus;
223       else owner.transfer(_referralBonus);
224 
225       uint256 _fee = _dividends * MAGINITUDE;
226       nextPot = SafeMath.add(nextPot, _nextPot);
227       profitTHT = SafeMath.add(profitTHT, _profitTHT);
228 
229       if (g.keyLevel > 1) {            
230         g.profitPerShare += (_dividends * MAGINITUDE / g.keyLevel);
231         _fee = _fee - (_fee - (1 * (_dividends * MAGINITUDE / g.keyLevel)));
232       }
233       int256 _updatedPayouts = (int256) (g.profitPerShare * 1 - _fee);
234       updatePlayer(msg.sender, _updatedPayouts);
235       // update game
236       updateGame(_finalPot);
237 
238       sendToTeamMaketing(_marketingFee);
239 
240       sendProfitTTH();
241       
242       emit Buy(round, msg.sender, keyPrice, games[round].keyLevel);
243     }
244     function withdraw() public disableContract
245 
246     {
247       if (games[round].ended == false && games[round].endTime <= now) endRound();
248       
249       if (games[players[msg.sender].curentRound].ended == true) updatePlayerEndRound(msg.sender);
250 
251       Player storage p = players[msg.sender];
252       uint256 _dividends = calculateDividends(msg.sender, p.curentRound);
253       uint256 balance    = SafeMath.add(p.bonus, _dividends);
254       balance = SafeMath.add(balance, p.dividends);
255 
256       require(balance > 0);
257       if (address(this).balance >= balance) {
258         p.bonus = 0;
259         p.dividends = 0;
260         if (p.curentRound == round) p.payouts += (int256) (_dividends * MAGINITUDE);
261         msg.sender.transfer(balance);
262         emit Withdraw(msg.sender, balance);
263       }
264     }
265     function withdrawReferral() public disableContract
266     {
267       Player storage p = players[msg.sender];
268       uint256 balance = p.referrals;
269 
270       require(balance > 0);
271       if (address(this).balance >= balance) {
272         p.referrals = 0;
273         msg.sender.transfer(balance);
274         emit WithdrawReferral(msg.sender, balance);
275       }
276     }
277     function myDividends(address _addr) 
278     public 
279     view
280     returns(
281       uint256 _dividends // bonus + dividends
282     ) {
283       Player memory p = players[_addr];
284       Game memory g = games[p.curentRound];
285       _dividends = p.bonus + p.dividends;
286       _dividends+= calculateDividends(_addr, p.curentRound);
287       if (
288         g.ended == false &&
289         g.endTime <= now &&
290         g.keyHolder == _addr 
291         ) {
292         _dividends += games[p.curentRound].finalPot;
293       } 
294     }
295     function getData(address _addr) 
296     public 
297     view
298     returns(
299       uint256 _round,
300       uint256 _finalPot,
301       uint256 _endTime,
302       uint256 _keyLevel,
303       uint256 _keyPrice,
304       address _keyHolder,
305       bool _ended,
306       // player info
307       uint256 _playerDividends,
308       uint256 _playerReferrals
309     ) {
310       _round = round;
311       Game memory g = games[_round];
312       _finalPot = g.finalPot;
313       _endTime  = g.endTime;
314       _keyLevel = g.keyLevel;
315       _keyPrice = _keyLevel * KEY_PRICE_DEFAULT;
316       _keyHolder= g.keyHolder;
317       _ended    = g.ended;
318       // player
319       _playerReferrals = players[_addr].referrals;
320       _playerDividends = myDividends(_addr);
321     } 
322     function calculateDividends(address _addr, uint256 _round) public view returns(uint256 _devidends)
323     {
324       Game memory g   = games[_round];
325       Player memory p = players[_addr];
326       if (p.curentRound == _round && p.lastRound < _round && _round != 0 ) 
327         _devidends = (uint256) ((int256) (g.profitPerShare * p.keys) - p.payouts) / MAGINITUDE;
328     }
329     function totalEthereumBalance() public view returns (uint256) {
330         return address(this).balance;
331     }
332 
333     // ---------------------------------------------------------------------------------------------
334     // INTERNAL FUNCTION
335     // ---------------------------------------------------------------------------------------------
336 
337     function updatePlayer(address _addr, int256 _updatedPayouts) private
338     {
339       Player storage p = players[_addr];
340       if (games[p.curentRound].ended == true) updatePlayerEndRound(_addr);
341       if (p.curentRound != round) p.curentRound = round;
342       p.keys       += 1;
343       p.payouts    += (int256)(_updatedPayouts); 
344     }
345     function updatePlayerEndRound(address _addr) private
346     {
347       Player storage p = players[_addr];
348 
349       uint256 dividends = calculateDividends(_addr, p.curentRound);
350       p.dividends       = SafeMath.add(p.dividends, dividends);
351       p.lastRound       = p.curentRound;
352       p.keys            = 0;
353       p.payouts         = 0;
354     }
355     function updateGame(uint256 _finalPot) private 
356     {
357       Game storage g   = games[round];
358       // Final pot: 30%
359       g.finalPot = SafeMath.add(g.finalPot, _finalPot);
360       // update key holder
361       g.keyHolder = msg.sender;
362       // reset end time game
363       uint256 endTime = now + HALF_TIME;
364       endTime = endTime - 10 * g.keyLevel;
365       if (endTime <= now) endTime = now;
366       g.endTime = endTime;
367       // update key level
368       g.keyLevel += 1;
369     }
370     function sendToTeamMaketing(uint256 _marketingFee) private
371     {
372       // price * maketing / 100 * 10 /100 = price * maketing * 10 / 10000
373       uint256 profit = SafeMath.div(SafeMath.mul(_marketingFee, 10), 100);
374       for (uint256 idx = 0; idx < 10; idx++) {
375         teamMarketing[idx].transfer(profit);
376       }
377     }
378     function sendProfitTTH() private
379     {
380         uint256 balanceContract = totalEthereumBalance();
381         buyTHT(calEthSendToTHT(profitTHT));
382         exitTHT();
383         uint256 currentBalanceContract = totalEthereumBalance();
384         uint256 ethSendToTHT = SafeMath.sub(balanceContract, currentBalanceContract);
385         if (ethSendToTHT > profitTHT) {
386           // reset profit THT
387           profitTHT = 0;
388           nextPot = SafeMath.sub(nextPot, SafeMath.sub(ethSendToTHT, profitTHT));
389         } else {
390           profitTHT = SafeMath.sub(profitTHT, ethSendToTHT);
391         }
392     }
393     /**
394     * @dev calculate dividend eth for THT owner
395     * @param _eth value want share
396     * value = _eth * 100 / 64
397     */
398     function calEthSendToTHT(uint256 _eth) private pure returns(uint256 _value)
399     {
400       _value = SafeMath.div(SafeMath.mul(_eth, 100), 64);
401     }
402     // conect to tht contract
403     function buyTHT(uint256 _value) private
404     {
405       TwelveHourToken.fallback.value(_value)();
406     }
407     function exitTHT() private
408     {
409       TwelveHourToken.exit();
410     }
411     
412 }