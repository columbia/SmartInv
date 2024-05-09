1 pragma solidity ^0.4.24;
2 
3 //    _____ _     _      _                _____           _    
4 //   / ____| |   (_)    | |              |  __ \         | |   
5 //  | |    | |__  _  ___| | _____ _ __   | |__) |_ _ _ __| | __
6 //  | |    | '_ \| |/ __| |/ / _ \ '_ \  |  ___/ _` | '__| |/ /
7 //  | |____| | | | | (__|   <  __/ | | | | |  | (_| | |  |   < 
8 //   \_____|_| |_|_|\___|_|\_\___|_| |_| |_|   \__,_|_|  |_|\_\
9 
10 // ------- What? ------- 
11 //A home for blockchain games.
12 
13 // ------- How? ------- 
14 //Buy CKN Token before playing any games.
15 //You can buy & sell CKN in this contract at anytime and anywhere.
16 //As the amount of ETH in the contract increases to 10,000, the dividend will gradually drop to 2%.
17 
18 //We got 4 phase in the Roadmap, will launch Plasma chain in the phase 2.
19 
20 // ------- How? ------- 
21 //10/2018 SIMPLE E-SPORT
22 //11/2018 SPORT PREDICTION
23 //02/2019 MOBILE GAME
24 //06/2019 MMORPG
25 
26 // ------- Who? ------- 
27 //Only 1/10 smarter than vitalik.
28 //admin@chickenpark.io
29 //Sometime we think plama is a Pseudo topic, but it's a only way to speed up the TPS.
30 //And Everybody will also trust the Node & Result.
31 
32 library SafeMath {
33     
34     /**
35     * @dev Multiplies two numbers, throws on overflow.
36     */
37     function mul(uint256 a, uint256 b) 
38         internal 
39         pure 
40         returns (uint256 c) 
41     {
42         if (a == 0) {
43             return 0;
44         }
45         c = a * b;
46         require(c / a == b, "SafeMath mul failed");
47         return c;
48     }
49 
50     /**
51     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
52     */
53     function sub(uint256 a, uint256 b)
54         internal
55         pure
56         returns (uint256) 
57     {
58         require(b <= a, "SafeMath sub failed");
59         return a - b;
60     }
61 
62     /**
63     * @dev Adds two numbers, throws on overflow.
64     */
65     function add(uint256 a, uint256 b)
66         internal
67         pure
68         returns (uint256 c) 
69     {
70         c = a + b;
71         require(c >= a, "SafeMath add failed");
72         return c;
73     }
74     
75     /**
76      * @dev gives square root of given x.
77      */
78     function sqrt(uint256 x)
79         internal
80         pure
81         returns (uint256 y) 
82     {
83         uint256 z = ((add(x,1)) / 2);
84         y = x;
85         while (z < y) 
86         {
87             y = z;
88             z = ((add((x / z),z)) / 2);
89         }
90     }
91     
92     /**
93      * @dev gives square. multiplies x by x
94      */
95     function sq(uint256 x)
96         internal
97         pure
98         returns (uint256)
99     {
100         return (mul(x,x));
101     }
102     
103     /**
104      * @dev x to the power of y 
105      */
106     function pwr(uint256 x, uint256 y)
107         internal 
108         pure 
109         returns (uint256)
110     {
111         if (x==0)
112             return (0);
113         else if (y==0)
114             return (1);
115         else 
116         {
117             uint256 z = x;
118             for (uint256 i=1; i < y; i++)
119                 z = mul(z,x);
120             return (z);
121         }
122     }   
123 }
124 
125 contract ERC223ReceivingContract { 
126 /**
127  * @dev Standard ERC223 function that will handle incoming token transfers.
128  *
129  * @param _from  Token sender address.
130  * @param _value Amount of tokens.
131  * @param _data  Transaction metadata.
132  */
133     function tokenFallback(address _from, uint _value, bytes _data)public;
134 }
135 
136 contract Owned {
137     address public owner;
138     address public newOwner;
139 
140     event OwnershipTransferred(address indexed _from, address indexed _to);
141 
142     constructor() public {
143         owner = msg.sender;
144     }
145 
146     modifier onlyOwner {
147         require(msg.sender == owner);
148         _;
149     }
150 
151     function transferOwnership(address _newOwner) public onlyOwner {
152         newOwner = _newOwner;
153     }
154     function acceptOwnership() public {
155         require(msg.sender == newOwner);
156         emit OwnershipTransferred(owner, newOwner);
157         owner = newOwner;
158         newOwner = address(0);
159     }
160 }
161 
162 contract ApproveAndCallFallBack {
163     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
164 }
165 
166 contract ChickenPark is Owned{
167 
168     using SafeMath for *;
169 
170     modifier notContract() {
171         require (msg.sender == tx.origin);
172         _;
173     }
174     
175     event Transfer(
176         address indexed from,
177         address indexed to,
178         uint tokens
179     );
180 
181     event Approval(
182         address indexed tokenOwner,
183         address indexed spender,
184         uint tokens
185     );
186 
187     event CKNPrice(
188         address indexed who,
189         uint prePrice,
190         uint afterPrice,
191         uint ethValue,
192         uint token,
193         uint timestamp,
194         string action
195     );
196     
197     event Withdraw(
198         address indexed who,
199         uint dividents
200     );
201 
202     /*=====================================
203     =            CONSTANTS                =
204     =====================================*/
205     uint8 constant public                decimals              = 18;
206     uint constant internal               tokenPriceInitial_    = 0.00001 ether;
207     uint constant internal               magnitude             = 2**64;
208 
209     /*================================
210     =          CONFIGURABLES         =
211     ================================*/
212     string public                        name               = "Chicken Park Coin";
213     string public                        symbol             = "CKN";
214 
215     /*================================
216     =            DATASETS            =
217     ================================*/
218 
219     // Tracks Token
220     mapping(address => uint) internal    balances;
221     mapping(address => mapping (address => uint))public allowed;
222 
223     // Payout tracking
224     mapping(address => uint)    public referralBalance_;
225     mapping(address => int256)  public payoutsTo_;
226     uint256 public profitPerShare_ = 0;
227     
228     // Token
229     uint internal tokenSupply = 0;
230 
231     // Sub Contract
232     address public marketAddress;
233     address public gameAddress;
234 
235     /*================================
236     =            FUNCTION            =
237     ================================*/
238 
239     constructor() public {
240 
241     }
242 
243     function totalSupply() public view returns (uint) {
244         return tokenSupply.sub(balances[address(0)]);
245     }
246 
247     // ------------------------------------------------------------------------
248     // Get the token balance for account `tokenOwner`  CKN
249     // ------------------------------------------------------------------------
250     function balanceOf(address tokenOwner) public view returns (uint balance) {
251         return balances[tokenOwner];
252     }
253 
254     // ------------------------------------------------------------------------
255     // Get the referral balance for account `tokenOwner`   ETH
256     // ------------------------------------------------------------------------
257     function referralBalanceOf(address tokenOwner) public view returns(uint){
258         return referralBalance_[tokenOwner];
259     }
260 
261     function setMarket(address add) public onlyOwner{
262         marketAddress = add;
263     }
264 
265     function setGame(address add) public onlyOwner{
266         gameAddress = add;
267     }
268 
269     // ------------------------------------------------------------------------
270     // ERC20 Basic Function: Transfer CKN Token
271     // ------------------------------------------------------------------------
272     function transfer(address to, uint tokens) public returns (bool success) {
273         require(balances[msg.sender] >= tokens);
274 
275         payoutsTo_[msg.sender] = payoutsTo_[msg.sender] - int(tokens.mul(profitPerShare_)/1e18);
276         payoutsTo_[to] = payoutsTo_[to] + int(tokens.mul(profitPerShare_)/1e18);
277         balances[msg.sender] = balances[msg.sender].sub(tokens);
278         balances[to] = balances[to].add(tokens);
279 
280         emit Transfer(msg.sender, to, tokens);
281         return true;
282     }
283 
284     function approve(address spender, uint tokens) public returns (bool success) {
285         allowed[msg.sender][spender] = tokens;
286         emit Approval(msg.sender, spender, tokens);
287         return true;
288     }
289 
290     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
291         require(tokens <= balances[from] &&  tokens <= allowed[from][msg.sender]);
292 
293         payoutsTo_[from] = payoutsTo_[from] - int(tokens.mul(profitPerShare_)/1e18);
294         payoutsTo_[to] = payoutsTo_[to] + int(tokens.mul(profitPerShare_)/1e18);
295         balances[from] = balances[from].sub(tokens);
296         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
297         balances[to] = balances[to].add(tokens);
298         emit Transfer(from, to, tokens);
299         return true;
300     }
301 
302     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
303         return allowed[tokenOwner][spender];
304     }
305 
306     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
307         allowed[msg.sender][spender] = tokens;
308         emit Approval(msg.sender, spender, tokens);
309         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
310         return true;
311     }
312 
313     // ------------------------------------------------------------------------
314     // Buy Chicken Park Coin, 1% for me, 1% for chicken market, 19.6 ~ 0% for dividents
315     // ------------------------------------------------------------------------
316     function buyChickenParkCoin(address referedAddress) notContract() public payable{
317         uint fee = msg.value.mul(2)/100;
318         owner.transfer(fee/2);
319 
320         marketAddress.transfer(fee/2);
321 
322         uint realBuy = msg.value.sub(fee).mul((1e20).sub(calculateDivi()))/1e20;
323         uint divMoney = msg.value.sub(realBuy).sub(fee);
324 
325         if(referedAddress != msg.sender && referedAddress != address(0)){
326             uint referralMoney = divMoney/10;
327             referralBalance_[referedAddress] = referralBalance_[referedAddress].add(referralMoney);
328             divMoney = divMoney.sub(referralMoney);
329         }
330 
331         uint tokenAdd = getBuy(realBuy);
332         uint price1 = getCKNPriceNow();
333 
334         tokenSupply = tokenSupply.add(tokenAdd);
335 
336         payoutsTo_[msg.sender] += (int256)(profitPerShare_.mul(tokenAdd)/1e18);
337         profitPerShare_ = profitPerShare_.add(divMoney.mul(1e18)/totalSupply());
338         balances[msg.sender] = balances[msg.sender].add(tokenAdd);
339 
340         uint price2 = getCKNPriceNow();
341 
342         emit CKNPrice(msg.sender,price1,price2,msg.value,tokenAdd,now,"BUY");
343     } 
344 
345     // ------------------------------------------------------------------------
346     // Sell Chicken Park Coin, 1% for me, 1% for chicken market, 19.6 ~ 0% for dividents
347     // ------------------------------------------------------------------------
348     function sellChickenParkCoin(uint tokenAnount) notContract() public {
349         uint tokenSub = tokenAnount;
350         uint sellEther = getSell(tokenSub);
351         uint price1 = getCKNPriceNow();
352 
353         payoutsTo_[msg.sender] = payoutsTo_[msg.sender] - int(tokenSub.mul(profitPerShare_)/1e18);
354         tokenSupply = tokenSupply.sub(tokenSub);
355 
356         balances[msg.sender] = balances[msg.sender].sub(tokenSub);
357         uint diviTo = sellEther.mul(calculateDivi())/1e20;
358 
359         if(totalSupply()>0){
360             profitPerShare_ = profitPerShare_.add(diviTo.mul(1e18)/totalSupply());
361         }else{
362             owner.transfer(diviTo); 
363         }
364 
365         owner.transfer(sellEther.mul(1)/100);
366         marketAddress.transfer(sellEther.mul(1)/100);
367 
368         msg.sender.transfer((sellEther.mul(98)/(100)).sub(diviTo));
369 
370         uint price2 = getCKNPriceNow();
371         emit CKNPrice(msg.sender,price1,price2,sellEther,tokenSub,now,"SELL");
372     }
373 
374     // ------------------------------------------------------------------------
375     // Withdraw your ETH dividents from Referral & CKN Dividents
376     // ------------------------------------------------------------------------
377     function withdraw() notContract() public {
378         require(myDividends(true)>0);
379 
380         uint dividents_ = uint(getDividents()).add(referralBalance_[msg.sender]);
381         payoutsTo_[msg.sender] = payoutsTo_[msg.sender] + int(getDividents());
382         referralBalance_[msg.sender] = 0;
383 
384         msg.sender.transfer(dividents_);
385         emit Withdraw(msg.sender, dividents_);
386     }
387     
388     // ------------------------------------------------------------------------
389     // ERC223 Transfer CKN Token With Data Function
390     // ------------------------------------------------------------------------
391     function transferTo (address _from, address _to, uint _amountOfTokens, bytes _data) public {
392         if (_from != msg.sender){
393             require(_amountOfTokens <= balances[_from] &&  _amountOfTokens <= allowed[_from][msg.sender]);
394         }
395         else{
396             require(_amountOfTokens <= balances[_from]);
397         }
398 
399         transferFromInternal(_from, _to, _amountOfTokens, _data);
400     }
401 
402     function transferFromInternal(address _from, address _toAddress, uint _amountOfTokens, bytes _data) internal
403     {
404         require(_toAddress != address(0x0));
405         address _customerAddress     = _from;
406         
407         if (_customerAddress != msg.sender){
408         // Update the allowed balance.
409         // Don't update this if we are transferring our own tokens (via transfer or buyAndTransfer)
410             allowed[_customerAddress][msg.sender] = allowed[_customerAddress][msg.sender].sub(_amountOfTokens);
411         }
412 
413         // Exchange tokens
414         balances[_customerAddress]    = balances[_customerAddress].sub(_amountOfTokens);
415         balances[_toAddress]          = balances[_toAddress].add(_amountOfTokens);
416 
417         // Update dividend trackers
418         payoutsTo_[_customerAddress] -= (int256)(profitPerShare_.mul(_amountOfTokens)/1e18);
419         payoutsTo_[_toAddress]       +=  (int256)(profitPerShare_.mul(_amountOfTokens)/1e18);
420 
421         uint length;
422 
423         assembly {
424             length := extcodesize(_toAddress)
425         }
426 
427         if (length > 0){
428         // its a contract
429         // note: at ethereum update ALL addresses are contracts
430             ERC223ReceivingContract receiver = ERC223ReceivingContract(_toAddress);
431             receiver.tokenFallback(_from, _amountOfTokens, _data);
432         }
433 
434         // Fire logging event.
435         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
436     }
437 
438     function getCKNPriceNow() public view returns(uint){
439         return (tokenPriceInitial_.mul(1e18+totalSupply()/100000000))/(1e18);
440     }
441 
442     function getBuy(uint eth) public view returns(uint){
443         return ((((1e36).add(totalSupply().sq()/1e16).add(totalSupply().mul(2).mul(1e10)).add(eth.mul(1e28).mul(2)/tokenPriceInitial_)).sqrt()).sub(1e18).sub(totalSupply()/1e8)).mul(1e8);
444     }
445 
446     function calculateDivi()public view returns(uint){
447         if(totalSupply() < 4e26){
448             uint diviRate = (20e18).sub(totalSupply().mul(5)/1e8);
449             return diviRate;
450         } else {
451             return 0;
452         }
453     }
454 
455     function getSell(uint token) public view returns(uint){
456         return tokenPriceInitial_.mul((1e18).add((totalSupply().sub(token/2))/100000000)).mul(token)/(1e36);
457     }
458 
459     function myDividends(bool _includeReferralBonus) public view returns(uint256)
460     {
461         address _customerAddress = msg.sender;
462         return _includeReferralBonus ? getDividents().add(referralBalance_[_customerAddress]) : getDividents() ;
463     }
464 
465     function getDividents() public view returns(uint){
466         require(int((balances[msg.sender].mul(profitPerShare_)/1e18))-(payoutsTo_[msg.sender])>=0);
467         return uint(int((balances[msg.sender].mul(profitPerShare_)/1e18))-(payoutsTo_[msg.sender]));
468     }
469 
470 }