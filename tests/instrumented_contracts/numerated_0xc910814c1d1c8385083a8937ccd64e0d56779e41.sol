1 pragma solidity ^0.4.24;
2 //
3 //                       .#########'
4 //                    .###############+
5 //                  ,####################
6 //                `#######################+
7 //               ;##########################
8 //              #############################.
9 //             ###############################,
10 //           +##################,    ###########`
11 //          .###################     .###########
12 //         ##############,          .###########+
13 //         #############`            .############`
14 //         ###########+                ############
15 //        ###########;                  ###########
16 //        ##########'                    ###########                                                                                      +000000.
17 //       '##########    '#.        `,     ##########                                                                                    `000000000'
18 //       ##########    ####'      ####.   :#########;                                                                                   #0000000000.
19 //      `#########'   :#####;    ######    ##########                                                                                  ;000#. `'000#
20 //      :#########    #######:  #######    :#########                                                                                  0000`    +000`
21 //      +#########    :#######.########     #########`        ............``                         ....`       .               `    .000;     .000'     `               `
22 //      #########;     ###############'     #########:        @@@@@@@@@@@@@@;  ;##                  .@@@@#      .@'             `#'   ;000.    .0000#     @#             +@`
23 //      #########       #############+      '########'        @+`````````.;@@, ;@#                  #@#.@@;     .@@;            @@@   +000    :00000#     #@#           #@@`
24 //      #########        ############       :#########        @+           `@+ ;@#                 ,@@` '@@      ,@@:          @@@    #000   ;0000000     `@@#         +@@`
25 //      #########         ##########        ,#########        @+            @@ ;@#                 @@+  `@@;      :@@:        @@@     #00#  '000+'000`     `@@+       #@@`
26 //      #########         :########         ,#########        @+            #@ ;@#                :@@    ;@@`      ;@@,     `#@#      #00# #000' '000`      `@@+     +@@.
27 //      #########        ,##########        ,#########        @+            #@ ;@#                @@' `.` @@'       +@@,    '@#       #00#0000;  +000`       .@@+   #@@`
28 //      #########       ,############       :########+        @+            @@ ;@#               :@@` #@+ ,@@`       +@@.    :        +000000,   #000         ,@@+ #@@`
29 //      #########      .#############+      '########'        @+           .@+ ;@#               @@;  `.`  #@+        #@@`            '00000`    #00#         `@@@ @@@
30 //      #########:    `###############'     #########,        @+     .''''+@@. ;@#              ;@@        .@@`        @@#            ;000#`    `000+        `@@@` .@@#
31 //      +########+    ;#######`;#######     #########         @+     ,@@@@@@:  ;@#             `@@:         #@#        .@@            .000;     ;000.       `@@@`   .@@@
32 //      ,#########    '######`  '######    :#########         @+               ;@#             '@#          `@@.       ,@@             0000.   .0000       `@@#      `@@#`
33 //       #########;   .#####`    '#####    ##########         @+               ;@#            `@@,           +@@       ,@@             :0000'`;0000;      `@@#        `@@#`
34 //       ##########    '###`      +###    :#########:         @+               ;@#            +@#            `@@.      ,@@              #000000000#      .@@#          `@@#`
35 //       ;#########+     `                ##########          @+               '@@@@@@@@@@@@@.@@.             '@@      ,@@               00000000#       @@#            `#@@
36 //        ##########,                    ###########                                                                                      +000000.
37 //         ###########;                ############
38 //         +############             .############`
39 //          ###########+           ,#############;
40 //          `###########     ;++#################
41 //           :##########,    ###################
42 //            '###########.'###################
43 //             +##############################
44 //              '############################`
45 //               .##########################
46 //                 #######################:
47 //                   ###################+
48 //                     +##############:
49 //                        :#######+`
50 //
51 //
52 //
53 // Play0x.com (The ONLY gaming platform for all ERC20 Tokens)
54 // -------------------------------------------------------------------------------------------------------
55 // * Multiple types of game platforms
56 // * Build your own game zone - Not only playing games, but also allowing other players to join your game.
57 // * Support all ERC20 tokens.
58 //
59 //
60 //
61 // 0xC Token (Contract address : 0x94070ec48208fe43779b45085e192a511a368d7c)
62 // -------------------------------------------------------------------------------------------------------
63 // * 0xC Token is an ERC20 Token specifically for digital entertainment.
64 // * No ICO and private sales,fair access.
65 // * There will be hundreds of games using 0xC as a game token.
66 // * Token holders can permanently get ETH's profit sharing.
67 //
68 
69 
70 /**
71 * @title SafeMath
72 * @dev Math operations with safety checks that throw on error
73 */
74 library SafeMath {
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         uint256 c = a * b;
77         assert(a == 0 || c / a == b);
78         return c;
79     }
80 
81     function div(uint256 a, uint256 b) internal pure returns (uint256) {
82         uint256 c = a / b;
83         return c;
84     }
85 
86     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87         assert(b <= a);
88         return a - b;
89     }
90 
91     function add(uint256 a, uint256 b) internal pure returns (uint256) {
92         uint256 c = a + b;
93         assert(c >= a);
94         return c;
95     }
96 }
97 
98 
99 /**
100 * @title Ownable
101 * @dev The Ownable contract has an owner address, and provides basic authorization control 
102 * functions, this simplifies the implementation of "user permissions". 
103 */ 
104 contract Ownable {
105     address public owner;
106 
107 /** 
108 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
109 * account.
110 */
111     constructor() public {
112         owner = msg.sender;
113     }
114 
115     /**
116     * @dev Throws if called by any account other than the owner.
117     */
118     modifier onlyOwner() {
119         require(msg.sender == owner);
120         _;
121     }
122 
123     /**
124     * @dev Allows the current owner to transfer control of the contract to a newOwner.
125     * @param newOwner The address to transfer ownership to.
126     */
127     function transferOwnership(address newOwner) public onlyOwner {
128         if (newOwner != address(0)) {
129             owner = newOwner;
130         }
131     }
132 }
133 
134 /**
135 * @title ERC20Basic
136 * @dev Simpler version of ERC20 interface
137 * @dev see https://github.com/ethereum/EIPs/issues/179
138 */
139 contract ERC20Basic {
140     uint256 public totalSupply;
141     function balanceOf(address who) public constant returns  (uint256);
142     function transfer(address to, uint256 value) public returns (bool);
143     event Transfer(address indexed from, address indexed to, uint256 value);
144 }
145 
146 /**
147 * @title Basic token
148 * @dev Basic version of StandardToken, with no allowances. 
149 */
150 contract BasicToken is ERC20Basic {
151   using SafeMath for uint256;
152 
153   mapping(address => uint256) balances;
154 
155     /**
156     * @dev transfer token for a specified address
157     * @param _to The address to transfer to.
158     * @param _value The amount to be transferred.
159     */
160     function transfer(address _to, uint256 _value) public returns (bool) {
161         balances[msg.sender] = balances[msg.sender].sub(_value);
162         balances[_to] = balances[_to].add(_value);
163         emit Transfer(msg.sender, _to, _value);
164         return true;
165     }
166 
167     /**
168     * @dev Gets the balance of the specified address.
169     * @param _owner The address to query the the balance of. 
170     * @return An uint256 representing the amount owned by the passed address.
171     */
172     function balanceOf(address _owner) public constant returns (uint256 balance) {
173         return balances[_owner];
174     }
175 }
176 
177 /**
178 * @title ERC20 interface
179 * @dev see https://github.com/ethereum/EIPs/issues/20
180 */
181 contract ERC20 is ERC20Basic {
182     function allowance(address owner, address spender) public constant returns (uint256);
183     function transferFrom(address from, address to, uint256 value) public returns (bool);
184     function approve(address spender, uint256 value) public returns (bool);
185     event Approval(address indexed owner, address indexed spender, uint256 value);
186 }
187 
188 /**
189 * @title Standard ERC20 token
190 *
191 * @dev Implementation of the basic standard token.
192 * @dev https://github.com/ethereum/EIPs/issues/20
193 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
194 */
195 contract StandardToken is ERC20, BasicToken {
196 
197     mapping (address => mapping (address => uint256)) internal allowed;
198 
199     /**
200     * @dev Transfer tokens from one address to another
201     * @param _from address The address which you want to send tokens from
202     * @param _to address The address which you want to transfer to
203     * @param _value uint256 the amout of tokens to be transfered
204     */
205     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
206     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
207     // require (_value <= _allowance);
208 
209         balances[_to] = balances[_to].add(_value);
210         balances[_from] = balances[_from].sub(_value);
211         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
212         emit Transfer(_from, _to, _value);
213         return true;
214     }       
215 
216     /**
217     * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
218     * @param _spender The address which will spend the funds.
219     * @param _value The amount of tokens to be spent.
220     */
221     function approve(address _spender, uint256 _value) public returns (bool) {
222 
223     // To change the approve amount you first have to reduce the addresses`
224     //  allowance to zero by calling `approve(_spender, 0)` if it is not
225     //  already 0 to mitigate the race condition described here:
226     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
227         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
228         allowed[msg.sender][_spender] = _value;
229         emit Approval(msg.sender, _spender, _value);
230         return true;
231     }
232 
233     /**
234     * @dev Function to check the amount of tokens that an owner allowed to a spender.
235     * @param _owner address The address which owns the funds.
236     * @param _spender address The address which will spend the funds.
237     * @return A uint256 specifing the amount of tokens still avaible for the spender.
238     */
239     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
240         return allowed[_owner][_spender];
241     }
242 }
243 
244 /*Token  Contract*/
245 contract Token0xC is StandardToken, Ownable {
246     using SafeMath for uint256;
247 
248     // Token Information
249     string  public constant name = "0xC";
250     string  public constant symbol = "0xC";
251     uint8   public constant decimals = 18;
252 
253     // Sale period1.
254     uint256 public startDate1;
255     uint256 public endDate1;
256     uint256 public rate1;
257     
258     // Sale period2.
259     uint256 public startDate2;
260     uint256 public endDate2;
261     uint256 public rate2;
262     
263     // Sale period3. 
264     uint256 public startDate3;
265     uint256 public endDate3;
266     uint256 public rate3;
267 
268     //2018 08 16
269     uint256 BaseTimestamp = 1534377600;
270     
271     //SaleCap
272     uint256 public dailyCap;
273     uint256 public saleCap;
274     uint256 public LastbetDay;
275     uint256 public LeftDailyCap;
276 
277     // Address Where Token are keep
278     address public tokenWallet ;
279 
280     // Address where funds are collected.
281     address public fundWallet ;
282 
283     // Event
284     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
285     event TransferToken(address indexed buyer, uint256 amount);
286 
287     // Modifiers
288     modifier uninitialized() {
289         require(tokenWallet == 0x0);
290         require(fundWallet == 0x0);
291         _;
292     }
293 
294     constructor() public {}
295     // Trigger with Transfer event
296     // Fallback function can be used to buy tokens
297     function () public payable {
298         buyTokens(msg.sender, msg.value);
299     }
300 
301     //Initial Contract
302     function initialize(address _tokenWallet, address _fundWallet, uint256 _start1, uint256 _end1,
303                         uint256 _saleCap, uint256 _dailyCap, uint256 _totalSupply) public
304                         onlyOwner uninitialized {
305         require(_start1 < _end1);
306         require(_tokenWallet != 0x0);
307         require(_fundWallet != 0x0);
308         require(_totalSupply >= _saleCap);
309 
310         startDate1 = _start1;
311         endDate1 = _end1;
312         saleCap = _saleCap;
313         dailyCap = _dailyCap;
314         tokenWallet = _tokenWallet;
315         fundWallet = _fundWallet;
316         totalSupply = _totalSupply;
317 
318         balances[tokenWallet] = saleCap;
319         balances[0xb1] = _totalSupply.sub(saleCap);
320     }
321 
322     //Set Sale Period
323     function setPeriod(uint period, uint256 _start, uint256 _end) public onlyOwner {
324         require(_end > _start);
325         if (period == 1) {
326             startDate1 = _start;
327             endDate1 = _end;
328         }else if (period == 2) {
329             require(_start > endDate1);
330             startDate2 = _start;
331             endDate2 = _end;
332         }else if (period == 3) {
333             require(_start > endDate2);
334             startDate3 = _start;
335             endDate3 = _end;      
336         }
337     }
338 
339     //Set Sale Period
340     function setPeriodRate(uint _period, uint256 _rate) public onlyOwner {
341         if (_period == 1) {
342            rate1 = _rate;
343         }else if (_period == 2) {
344             rate2 = _rate;
345         }else if (_period == 3) {
346             rate3 = _rate;
347         }
348     }
349 
350     // For transferToken
351     function transferToken(address buyer, uint256 amount) public onlyOwner {
352         require(saleCap >= amount,' Not Enough' );
353 
354         saleCap = saleCap - amount;
355         // Transfer
356         balances[tokenWallet] = balances[tokenWallet].sub(amount);
357         balances[buyer] = balances[buyer].add(amount);
358         emit TransferToken(buyer, amount);
359         emit Transfer(tokenWallet, buyer, amount);
360     }
361 
362     function setDailyCap(uint256 _dailyCap) public onlyOwner{
363         dailyCap = _dailyCap;
364     }
365 
366     //Set SaleCap
367     function setSaleCap(uint256 _saleCap) public onlyOwner {
368         require(balances[0xb1].add(balances[tokenWallet]).sub(_saleCap) > 0);
369         uint256 amount=0;
370         //Check SaleCap
371         if (balances[tokenWallet] > _saleCap) {
372             amount = balances[tokenWallet].sub(_saleCap);
373             balances[0xb1] = balances[0xb1].add(amount);
374         } else {
375             amount = _saleCap.sub(balances[tokenWallet]);
376             balances[0xb1] = balances[0xb1].sub(amount);
377         }
378         balances[tokenWallet] = _saleCap;
379         saleCap = _saleCap;
380     }
381 
382     //Calcute Bouns
383     function getBonusByTime() public constant returns (uint256) {
384         if (now < startDate1) {
385             return 0;
386         } else if (endDate1 > now && now > startDate1) {
387             return rate1;
388         } else if (endDate2 > now && now > startDate2) {
389             return rate2;
390         } else if (endDate3 > now && now > startDate3) {
391             return rate3;
392         } else {
393             return 0;
394         }
395     }
396 
397     //Stop Contract
398     function finalize() public onlyOwner {
399         require(!saleActive());
400 
401         // Transfer the rest of token to tokenWallet
402         balances[tokenWallet] = balances[tokenWallet].add(balances[0xb1]);
403         balances[0xb1] = 0;
404     }
405     
406     //Purge the time in the timestamp.
407     function DateConverter(uint256 ts) public view returns(uint256 currentDayWithoutTime){
408         uint256 dayInterval = ts - BaseTimestamp;
409         uint256 dayCount = dayInterval.div(86400);
410         return BaseTimestamp + dayCount * 86400;
411     }
412     
413     //Check SaleActive
414     function saleActive() public constant returns (bool) {
415         return (
416             (now >= startDate1 &&
417                 now < endDate1 && saleCap > 0) ||
418             (now >= startDate2 &&
419                 now < endDate2 && saleCap > 0) ||
420             (now >= startDate3 &&
421                 now < endDate3 && saleCap > 0)
422                 );
423     }
424     
425     //Buy Token
426     function buyTokens(address sender, uint256 value) internal {
427         //Check Sale Status
428         require(saleActive());
429         
430         //Minum buying limit
431         require(value >= 0.0001 ether);
432         
433         if(DateConverter(now) > LastbetDay )
434         {
435             LastbetDay = DateConverter(now);
436             LeftDailyCap = dailyCap;
437         }
438 
439         // Calculate token amount to be purchased
440         uint256 bonus = getBonusByTime();
441         
442         uint256 amount = value.mul(bonus);
443         
444         // We have enough token to sale
445         require(LeftDailyCap >= amount, "cap not enough");
446         require(balances[tokenWallet] >= amount);
447         
448         LeftDailyCap = LeftDailyCap - amount;
449 
450         // Transfer
451         balances[tokenWallet] = balances[tokenWallet].sub(amount);
452         balances[sender] = balances[sender].add(amount);
453         emit TokenPurchase(sender, value, amount);
454         emit Transfer(tokenWallet, sender, amount);
455         
456         saleCap = saleCap - amount;
457 
458         // Forward the fund to fund collection wallet.
459         fundWallet.transfer(msg.value);
460     }
461 }