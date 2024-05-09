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
62 // 0xC Token (Contract address : 0x4166afC352CdF27B73b25AB2FD7864B62577DD85)
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
297 
298     // Address Where Token are keep
299     address public tokenWallet ;
300 
301     // Address where funds are collected.
302     address public fundWallet ;
303 
304     // Event
305     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
306     event TransferToken(address indexed buyer, uint256 amount);
307 
308     // Modifiers
309     modifier uninitialized() {
310         require(tokenWallet == 0x0);
311         require(fundWallet == 0x0);
312         _;
313     }
314 
315     constructor() public {}
316     // Trigger with Transfer event
317     // Fallback function can be used to buy tokens
318     function () public payable {
319         buyTokens(msg.sender, msg.value);
320     }
321 
322     //Initial Contract
323     function initialize(address _tokenWallet, address _fundWallet, uint256 _start1, uint256 _end1,
324                          uint256 _dailyCap, uint256 _saleCap, uint256 _totalSupply) public
325                         onlyOwner uninitialized {
326         require(_start1 < _end1);
327         require(_tokenWallet != 0x0);
328         require(_fundWallet != 0x0);
329         require(_totalSupply >= _saleCap);
330 
331         startDate1 = _start1;
332         endDate1 = _end1;
333         saleCap = _saleCap;
334         dailyCap = _dailyCap;
335         tokenWallet = _tokenWallet;
336         fundWallet = _fundWallet;
337         totalSupply = _totalSupply;
338 
339         balances[tokenWallet] = saleCap;
340         balances[0xb1] = _totalSupply.sub(saleCap);
341     }
342 
343     //Set Sale Period
344     function setPeriod(uint256 period, uint256 _start, uint256 _end) public onlyOwner {
345         require(_end > _start);
346         if (period == 1) {
347             startDate1 = _start;
348             endDate1 = _end;
349         }else if (period == 2) {
350             require(_start > endDate1);
351             startDate2 = _start;
352             endDate2 = _end;
353         }else if (period == 3) {
354             require(_start > endDate2);
355             startDate3 = _start;
356             endDate3 = _end;      
357         }
358     }
359 
360     //Set Sale Period
361     function setPeriodRate(uint256 _period, uint256 _rate) public onlyOwner {
362         if (_period == 1) {
363            rate1 = _rate;
364         }else if (_period == 2) {
365             rate2 = _rate;
366         }else if (_period == 3) {
367             rate3 = _rate;
368         }
369     }
370 
371     // For transferToken
372     function transferToken(address _to, uint256 amount) public onlyOwner {
373         require(saleCap >= amount,' Not Enough' );
374         require(_to != address(0));
375         require(_to != tokenWallet);
376         require(amount <= balances[tokenWallet]);
377 
378         saleCap = saleCap.sub(amount);
379         // Transfer
380         balances[tokenWallet] = balances[tokenWallet].sub(amount);
381         balances[_to] = balances[_to].add(amount);
382         emit TransferToken(_to, amount);
383         emit Transfer(tokenWallet, _to, amount);
384     }
385 
386     function setDailyCap(uint256 _dailyCap) public onlyOwner{
387         dailyCap = _dailyCap;
388     }
389 
390     //Set SaleCap
391     function setSaleCap(uint256 _saleCap) public onlyOwner {
392         require(balances[0xb1].add(balances[tokenWallet]).sub(_saleCap) >= 0);
393         uint256 amount = 0;
394         //Check SaleCap
395         if (balances[tokenWallet] > _saleCap) {
396             amount = balances[tokenWallet].sub(_saleCap);
397             balances[0xb1] = balances[0xb1].add(amount);
398         } else {
399             amount = _saleCap.sub(balances[tokenWallet]);
400             balances[0xb1] = balances[0xb1].sub(amount);
401         }
402         balances[tokenWallet] = _saleCap;
403         saleCap = _saleCap;
404     }
405 
406     //Calcute Bouns
407     function getBonusByTime() public constant returns (uint256) {
408         if (now < startDate1) {
409             return 0;
410         } else if (endDate1 > now && now > startDate1) {
411             return rate1;
412         } else if (endDate2 > now && now > startDate2) {
413             return rate2;
414         } else if (endDate3 > now && now > startDate3) {
415             return rate3;
416         } else {
417             return 0;
418         }
419     }
420 
421     //Stop Contract
422     function finalize() public onlyOwner {
423         require(!saleActive());
424 
425         // Transfer the rest of token to tokenWallet
426         balances[tokenWallet] = balances[tokenWallet].add(balances[0xb1]);
427         balances[0xb1] = 0;
428     }
429     
430     //Purge the time in the timestamp.
431     function DateConverter(uint256 ts) public view returns(uint256 currentDayWithoutTime){
432         uint256 dayInterval = ts.sub(BaseTimestamp);
433         uint256 dayCount = dayInterval.div(86400);
434         return BaseTimestamp.add(dayCount.mul(86400));
435     }
436     
437     //Check SaleActive
438     function saleActive() public constant returns (bool) {
439         return (
440             (now >= startDate1 &&
441                 now < endDate1 && saleCap > 0) ||
442             (now >= startDate2 &&
443                 now < endDate2 && saleCap > 0) ||
444             (now >= startDate3 &&
445                 now < endDate3 && saleCap > 0)
446                 );
447     }
448     
449     //Buy Token
450     function buyTokens(address sender, uint256 value) internal {
451         //Check Sale Status
452         require(saleActive());
453         
454         //Minum buying limit
455         require(value >= 0.0001 ether);
456         require(sender != tokenWallet);
457         
458         if(DateConverter(now) > LastbetDay )
459         {
460             LastbetDay = DateConverter(now);
461             LeftDailyCap = dailyCap;
462         }
463 
464         // Calculate token amount to be purchased
465         uint256 bonus = getBonusByTime();
466         
467         uint256 amount = value.mul(bonus);
468         
469         // We have enough token to sale
470         require(LeftDailyCap >= amount, "cap not enough");
471         require(balances[tokenWallet] >= amount);
472         
473         LeftDailyCap = LeftDailyCap.sub(amount);
474 
475         // Transfer
476         balances[tokenWallet] = balances[tokenWallet].sub(amount);
477         balances[sender] = balances[sender].add(amount);
478         emit TokenPurchase(sender, value, amount);
479         emit Transfer(tokenWallet, sender, amount);
480         
481         saleCap = saleCap.sub(amount);
482 
483         // Forward the fund to fund collection wallet.
484         fundWallet.transfer(msg.value);
485     }
486 }