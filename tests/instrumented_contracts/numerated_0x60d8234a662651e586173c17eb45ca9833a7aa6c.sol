1 pragma solidity ^0.4.24;
2 
3 //
4 //                       .#########'
5 //                    .###############+
6 //                  ,####################
7 //                `#######################+
8 //               ;##########################
9 //              #############################.
10 //             ###############################,
11 //           +##################,    ###########`
12 //          .###################     .###########
13 //         ##############,          .###########+
14 //         #############`            .############`
15 //         ###########+                ############
16 //        ###########;                  ###########
17 //        ##########'                    ###########                                                                                      
18 //       '##########    '#.        `,     ##########                                                                                    
19 //       ##########    ####'      ####.   :#########;                                                                                   
20 //      `#########'   :#####;    ######    ##########                                                                                 
21 //      :#########    #######:  #######    :#########         
22 //      +#########    :#######.########     #########`       
23 //      #########;     ###############'     #########:       
24 //      #########       #############+      '########'        
25 //      #########        ############       :#########        
26 //      #########         ##########        ,#########        
27 //      #########         :########         ,#########        
28 //      #########        ,##########        ,#########        
29 //      #########       ,############       :########+        
30 //      #########      .#############+      '########'        
31 //      #########:    `###############'     #########,        
32 //      +########+    ;#######`;#######     #########         
33 //      ,#########    '######`  '######    :#########         
34 //       #########;   .#####`    '#####    ##########         
35 //       ##########    '###`      +###    :#########:         
36 //       ;#########+     `                ##########          
37 //        ##########,                    ###########          
38 //         ###########;                ############
39 //         +############             .############`
40 //          ###########+           ,#############;
41 //          `###########     ;++#################
42 //           :##########,    ###################
43 //            '###########.'###################
44 //             +##############################
45 //              '############################`
46 //               .##########################
47 //                 #######################:
48 //                   ###################+
49 //                     +##############:
50 //                        :#######+`
51 //
52 //
53 //
54 // Play0x.com (The ONLY gaming platform for all ERC20 Tokens)
55 // -------------------------------------------------------------------------------------------------------
56 // * Multiple types of game platforms
57 // * Build your own game zone - Not only playing games, but also allowing other players to join your game.
58 // * Support all ERC20 tokens.
59 //
60 //
61 //
62 // 0xC Token (Contract address : 0x60d8234a662651e586173c17eb45ca9833a7aa6c)
63 // -------------------------------------------------------------------------------------------------------
64 // * 0xC Token is an ERC20 Token specifically for digital entertainment.
65 // * No ICO and private sales,fair access.
66 // * There will be hundreds of games using 0xC as a game token.
67 // * Token holders can permanently get ETH's profit sharing.
68 //
69 
70 
71 /**
72 * @title SafeMath
73 * @dev Math operations with safety checks that throw on error
74 */
75 library SafeMath {
76 /**
77      * @dev Multiplies two unsigned integers, reverts on overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b);
89 
90         return c;
91     }
92 
93     /**
94      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
95      */
96     function div(uint256 a, uint256 b) internal pure returns (uint256) {
97         // Solidity only automatically asserts when dividing by 0
98         require(b > 0);
99         uint256 c = a / b;
100         assert(a == b * c + a % b); // There is no case in which this doesn't hold
101 
102         return c;
103     }
104 
105     /**
106      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
107      */
108     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109         require(b <= a);
110         uint256 c = a - b;
111 
112         return c;
113     }
114 
115     /**
116      * @dev Adds two unsigned integers, reverts on overflow.
117      */
118     function add(uint256 a, uint256 b) internal pure returns (uint256) {
119         uint256 c = a + b;
120         require(c >= a);
121 
122         return c;
123     }
124 
125     /**
126      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
127      * reverts when dividing by zero.
128      */
129     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
130         require(b != 0);
131         return a % b;
132     }
133 }
134 
135 
136 /**
137 * @title Ownable
138 * @dev The Ownable contract has an owner address, and provides basic authorization control 
139 * functions, this simplifies the implementation of "user permissions". 
140 */ 
141 contract Ownable {
142     address public owner;
143 
144 /** 
145 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
146 * account.
147 */
148     constructor() public {
149         owner = msg.sender;
150     }
151 
152     /**
153     * @dev Throws if called by any account other than the owner.
154     */
155     modifier onlyOwner() {
156         require(msg.sender == owner);
157         _;
158     }
159 
160     /**
161     * @dev Allows the current owner to transfer control of the contract to a newOwner.
162     * @param newOwner The address to transfer ownership to.
163     */
164     function transferOwnership(address newOwner) public onlyOwner {
165         if (newOwner != address(0)) {
166             owner = newOwner;
167         }
168     }
169 }
170 
171 
172 
173 /**
174 * @title Standard ERC20 token
175 *
176 * @dev Implementation of the basic standard token.
177 * @dev https://github.com/ethereum/EIPs/issues/20
178 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
179 */
180 contract StandardToken {
181 
182     mapping (address => mapping (address => uint256)) internal allowed;
183     using SafeMath for uint256;
184     uint256 public totalSupply;
185     event Transfer(address indexed from, address indexed to, uint256 value);
186     event Approval(address indexed owner, address indexed spender, uint256 value);
187     mapping(address => uint256) balances;
188     
189     /**
190     * @dev transfer token for a specified address
191     * @param _to The address to transfer to.
192     * @param _value The amount to be transferred.
193     */
194     function transfer(address _to, uint256 _value) public returns (bool) {
195         require(_to != address(0));
196         require(_value <= balances[msg.sender]);
197         require(balances[msg.sender] >= _value && balances[_to].add(_value) >= balances[_to]);
198 
199     
200         // SafeMath.sub will throw if there is not enough balance.
201         balances[msg.sender] = balances[msg.sender].sub(_value);
202         balances[_to] = balances[_to].add(_value);
203         emit Transfer(msg.sender, _to, _value);
204         return true;
205     }
206 
207     /**
208     * @dev Gets the balance of the specified address.
209     * @param _owner The address to query the the balance of. 
210     * @return An uint256 representing the amount owned by the passed address.
211     */
212     function balanceOf(address _owner) public constant returns (uint256 balance) {
213         return balances[_owner];
214     }
215     
216     /**
217     * @dev Transfer tokens from one address to another
218     * @param _from address The address which you want to send tokens from
219     * @param _to address The address which you want to transfer to
220     * @param _value uint256 the amout of tokens to be transfered
221     */
222     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
223     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
224     // require (_value <= _allowance);
225 
226         require(_to != address(0));
227         require(_value <= balances[_from]);
228         require(_value <= allowed[_from][msg.sender]);
229     
230         balances[_from] = balances[_from].sub(_value);
231         balances[_to] = balances[_to].add(_value);
232         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
233         emit Transfer(_from, _to, _value);
234         return true;
235     }       
236 
237     /**
238     * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
239     * @param _spender The address which will spend the funds.
240     * @param _value The amount of tokens to be spent.
241     */
242     function approve(address _spender, uint256 _value) public returns (bool) {
243 
244     // To change the approve amount you first have to reduce the addresses`
245     //  allowance to zero by calling `approve(_spender, 0)` if it is not
246     //  already 0 to mitigate the race condition described here:
247     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
248         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
249         allowed[msg.sender][_spender] = _value;
250         emit Approval(msg.sender, _spender, _value);
251         return true;
252     }
253 
254     /**
255     * @dev Function to check the amount of tokens that an owner allowed to a spender.
256     * @param _owner address The address which owns the funds.
257     * @param _spender address The address which will spend the funds.
258     * @return A uint256 specifing the amount of tokens still avaible for the spender.
259     */
260     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
261         return allowed[_owner][_spender];
262     }
263 }
264 
265 /*Token  Contract*/
266 contract Token0xC is StandardToken, Ownable {
267     using SafeMath for uint256;
268 
269     // Token Information
270     string  public constant name = "0xC";
271     string  public constant symbol = "0xC";
272     uint8   public constant decimals = 18;
273 
274     // Sale period1.
275     uint256 public startDate1;
276     uint256 public endDate1;
277     uint256 public rate1;
278     
279     // Sale period2.
280     uint256 public startDate2;
281     uint256 public endDate2;
282     uint256 public rate2;
283     
284     // Sale period3. 
285     uint256 public startDate3;
286     uint256 public endDate3;
287     uint256 public rate3;
288 
289     //2018 08 16
290     uint256 BaseTimestamp = 1534377600;
291     
292     //SaleCap
293     uint256 public dailyCap;
294     uint256 public saleCap;
295     uint256 public LastbetDay;
296     uint256 public LeftDailyCap;
297     uint256 public EtheLowLimit = 500000000000000000; //0.5 ether
298 
299     // Address Where Token are keep
300     address public tokenWallet;
301 
302     // Address where funds are collected.
303     address public fundWallet;
304 
305     // Event
306     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
307     event TransferToken(address indexed buyer, uint256 amount);
308 
309     // Modifiers
310     modifier uninitialized() {
311         require(tokenWallet == 0x0);
312         require(fundWallet == 0x0);
313         _;
314     }
315 
316     constructor() public {}
317     // Trigger with Transfer event
318     // Fallback function can be used to buy tokens
319     function () public payable {
320         buyTokens(msg.sender, msg.value);
321     }
322 
323     //Initial Contract
324     function initialize(address _tokenWallet, address _fundWallet, uint256 _start1, uint256 _end1,
325                          uint256 _dailyCap, uint256 _saleCap, uint256 _totalSupply) public
326                         onlyOwner uninitialized {
327         require(_start1 < _end1);
328         require(_tokenWallet != 0x0);
329         require(_fundWallet != 0x0);
330         require(_totalSupply >= _saleCap);
331 
332         startDate1 = _start1;
333         endDate1 = _end1;
334         saleCap = _saleCap;
335         dailyCap = _dailyCap;
336         tokenWallet = _tokenWallet;
337         fundWallet = _fundWallet;
338         totalSupply = _totalSupply;
339 
340         balances[tokenWallet] = saleCap;
341         balances[0xb1] = _totalSupply.sub(saleCap);
342     }
343 
344     //Set Sale Period
345     function setPeriod(uint256 period, uint256 _start, uint256 _end) public onlyOwner {
346         require(_end > _start);
347         if (period == 1) {
348             startDate1 = _start;
349             endDate1 = _end;
350         }else if (period == 2) {
351             require(_start > endDate1);
352             startDate2 = _start;
353             endDate2 = _end;
354         }else if (period == 3) {
355             require(_start > endDate2);
356             startDate3 = _start;
357             endDate3 = _end;      
358         }
359     }
360 
361     //Set Sale Period
362     function setPeriodRate(uint256 _period, uint256 _rate) public onlyOwner {
363         if (_period == 1) {
364            rate1 = _rate;
365         }else if (_period == 2) {
366             rate2 = _rate;
367         }else if (_period == 3) {
368             rate3 = _rate;
369         }
370     }
371 
372     // For transferToken
373     function transferToken(address _to, uint256 amount) public onlyOwner {
374         require(saleCap >= amount,' Not Enough' );
375         require(_to != address(0));
376         require(_to != tokenWallet);
377         require(amount <= balances[tokenWallet]);
378 
379         saleCap = saleCap.sub(amount);
380         // Transfer
381         balances[tokenWallet] = balances[tokenWallet].sub(amount);
382         balances[_to] = balances[_to].add(amount);
383         emit TransferToken(_to, amount);
384         emit Transfer(tokenWallet, _to, amount);
385     }
386 
387     function setDailyCap(uint256 _dailyCap) public onlyOwner{
388         dailyCap = _dailyCap;
389     }
390     
391     function setSaleLimit(uint256 _etherLimit) public onlyOwner{
392         EtheLowLimit = _etherLimit;
393     }
394 
395     //Set SaleCap
396     function setSaleCap(uint256 _saleCap) public onlyOwner {
397         require(balances[0xb1].add(balances[tokenWallet]).sub(_saleCap) >= 0);
398         uint256 amount = 0;
399         //Check SaleCap
400         if (balances[tokenWallet] > _saleCap) {
401             amount = balances[tokenWallet].sub(_saleCap);
402             balances[0xb1] = balances[0xb1].add(amount);
403         } else {
404             amount = _saleCap.sub(balances[tokenWallet]);
405             balances[0xb1] = balances[0xb1].sub(amount);
406         }
407         balances[tokenWallet] = _saleCap;
408         saleCap = _saleCap;
409     }
410 
411     //Calcute Bouns
412     function getBonusByTime() public constant returns (uint256) {
413         if (now < startDate1) {
414             return 0;
415         } else if (endDate1 > now && now > startDate1) {
416             return rate1;
417         } else if (endDate2 > now && now > startDate2) {
418             return rate2;
419         } else if (endDate3 > now && now > startDate3) {
420             return rate3;
421         } else {
422             return 0;
423         }
424     }
425 
426     //Stop Contract
427     function finalize() public onlyOwner {
428         require(!saleActive());
429 
430         // Transfer the rest of token to tokenWallet
431         balances[tokenWallet] = balances[tokenWallet].add(balances[0xb1]);
432         balances[0xb1] = 0;
433     }
434     
435     //Purge the time in the timestamp.
436     function DateConverter(uint256 ts) public view returns(uint256 currentDayWithoutTime){
437         uint256 dayInterval = ts.sub(BaseTimestamp);
438         uint256 dayCount = dayInterval.div(86400);
439         return BaseTimestamp.add(dayCount.mul(86400));
440     }
441     
442     //Check SaleActive
443     function saleActive() public constant returns (bool) {
444         return (
445             (now >= startDate1 &&
446                 now < endDate1 && saleCap > 0) ||
447             (now >= startDate2 &&
448                 now < endDate2 && saleCap > 0) ||
449             (now >= startDate3 &&
450                 now < endDate3 && saleCap > 0)
451                 );
452     }
453     
454     //Buy Token
455     function buyTokens(address sender, uint256 value) internal {
456         //Check Sale Status
457         require(saleActive());
458         
459         //Minum buying limit
460         require(value >= EtheLowLimit);
461         require(sender != tokenWallet);
462         
463         if(DateConverter(now) > LastbetDay )
464         {
465             LastbetDay = DateConverter(now);
466             LeftDailyCap = dailyCap;
467         }
468 
469         // Calculate token amount to be purchased
470         uint256 bonus = getBonusByTime();
471         
472         uint256 amount = value.mul(bonus);
473         
474         // We have enough token to sale
475         require(LeftDailyCap >= amount, "cap not enough");
476         require(balances[tokenWallet] >= amount);
477         
478         LeftDailyCap = LeftDailyCap.sub(amount);
479 
480         // Transfer
481         balances[tokenWallet] = balances[tokenWallet].sub(amount);
482         balances[sender] = balances[sender].add(amount);
483         emit TokenPurchase(sender, value, amount);
484         emit Transfer(tokenWallet, sender, amount);
485         
486         saleCap = saleCap.sub(amount);
487 
488         // Forward the fund to fund collection wallet.
489         fundWallet.transfer(msg.value);
490     }
491 }