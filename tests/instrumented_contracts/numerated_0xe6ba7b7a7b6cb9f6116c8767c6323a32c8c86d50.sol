1 pragma solidity ^0.4.25;
2 
3 contract Token{
4     using SafeMath for *;
5     uint256 public totalSupply;
6     string public name;                 //name of token
7     string public symbol;               //symbol of token
8     uint256 public decimals;
9 
10     mapping (address => uint256) balances;
11     mapping (address => mapping (address => uint256)) allowed;
12 
13     function balanceOf(address _owner) public view returns (uint256 balance);
14     function transfer(address _to, uint256 _value) public returns (bool success);
15     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
16 
17     function approve(address _spender, uint256 _value) public returns (bool success);
18 
19     function allowance(address _owner, address _spender) public view returns
20     (uint256 remaining);
21 
22     event Transfer(address indexed _from, address indexed _to, uint256 _value);
23     event Approval(address indexed _owner, address indexed _spender, uint256  _value);
24 }
25 
26 contract owned {
27     address public owner;
28     bool public paused;
29 
30     constructor() public {
31         owner = msg.sender;
32     }
33 
34     modifier onlyOwner {
35         require(msg.sender == owner);
36         _;
37     }
38 
39     modifier normal {
40         require(!paused);
41         _;
42     }
43 
44     function upgradeOwner(address newOwner) onlyOwner public {
45         owner = newOwner;
46     }
47 
48     function setPaused(bool _paused) onlyOwner public {
49         paused = _paused;
50     }
51 }
52 
53 contract BonusState{
54     constructor(address _tokenAddress) public{
55         tokenAddress = _tokenAddress;
56         settlementTime = 10 days + now;
57     }
58 
59     //balance for bonus compute withdraw, when withdraw and balance is zero means
60     //1. no balance for owner
61     //2. nerver update state
62     //so when withdraw, check balance state, when state is zero, check token balance
63     mapping(address=>uint256) balanceState;
64     //state is true while withdrawed
65     mapping(address=>bool) withdrawState;
66     //computedTotalBalance means this amount has been locked for withdraw, so when computing lockBonus,base amount will exclude this amount
67     uint256 computedTotalBalance = 0;
68     //price for token holder use this to compute withdrawable bonus for unit amount(unit amount means one exclude decimals)
69     uint256 computedUnitPrice = 0;
70     //while times up, next transaction for contract will auto settle bonus
71     uint256 settlementTime = 0;
72 
73 
74     //token contract address, only contract can operate this state contract
75     address public tokenAddress;
76     modifier onlyToken {
77         require(msg.sender == tokenAddress);
78         _;
79     }
80 
81     function getSettlementTime() public view returns(uint256 _time){
82         return settlementTime;
83     }
84 
85     function setBalanceState(address _target,uint256 _amount) public onlyToken{
86         balanceState[_target] = _amount;
87     }
88 
89     function getBalanceState(address _target) public view returns (uint256 _balance) {
90         return balanceState[_target];
91     }
92 
93 
94     function setWithdrawState(address _target,bool _state) public onlyToken{
95         withdrawState[_target] = _state;
96     }
97 
98     function getWithdrawState(address _target) public view returns (bool _state) {
99         return withdrawState[_target];
100     }
101 
102 
103     function setComputedTotalBalance(uint256 _amount) public onlyToken{
104         computedTotalBalance = _amount;
105     }
106 
107     function setComputedUnitPrice(uint256 _amount) public onlyToken{
108         computedUnitPrice = _amount;
109     }
110 
111     function getComputedTotalBalance() public view returns(uint256){
112         return computedTotalBalance;
113     }
114 
115     function getComputedUnitPrice() public view returns(uint256){
116         return computedUnitPrice;
117     }
118 
119 }
120 
121 contract EssToken is Token,owned {
122 
123     //bonus state never change for withdraw;
124     address public bonusState_fixed;
125 
126     //bonus state change while balance modified by transfer
127     address public bonusState;
128 
129     //transfer eth to contract means incharge the bonus
130     function() public payable normal{
131         computeBonus(msg.value);
132     }
133     function incharge() public payable normal{
134         computeBonus(msg.value);
135     }
136 
137     uint256 public icoTotal;
138 
139     uint256 public airdropTotal;
140 
141     //empty token while deploy the contract, token will minted by ico or minted by owner after ico
142     constructor() public {
143         decimals = 18;
144         name = "Ether Sesame";
145         symbol = "ESS";
146         totalSupply = 100000000 * 10 ** decimals;
147         icoTotal = totalSupply * 30 / 100; //30% for ico
148         airdropTotal = totalSupply * 20 / 100;  //20% for airdrop
149         uint256 _initAmount = totalSupply - icoTotal - airdropTotal;
150         bonusState = new BonusState(address(this));
151         _mintToken(msg.sender,_initAmount);
152     }
153 
154     function transfer(address _to, uint256 _value) public normal returns (bool success) {
155         computeBonus(0);
156         _transfer(msg.sender, _to, _value);
157         return true;
158     }
159 
160     function transferFrom(address _from, address _to, uint256 _value) public normal returns
161     (bool success) {
162         computeBonus(0);
163         require(_value <= allowed[_from][msg.sender]);     // Check allowed
164         allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_value);
165         _transfer(_from, _to, _value);
166         return true;
167     }
168     function balanceOf(address _owner) public view returns (uint256 balance) {
169         return balances[_owner];
170     }
171 
172     function approve(address _spender, uint256 _value) public normal returns (bool success)
173     {
174         computeBonus(0);
175         allowed[tx.origin][_spender] = _value;
176         emit Approval(msg.sender, _spender, _value);
177         return true;
178     }
179 
180     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
181         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
182     }
183     //end for ERC20 Token standard
184 
185     function _transfer(address _from, address _to, uint _value) internal {
186         require(_to != 0x0);
187         // Check if the sender has enough
188         require(balances[_from] >= _value);
189         // Check for overflows
190         require(balances[_to] + _value > balances[_to]);
191         // Save this for an assertion in the future
192         uint previousBalances = balances[_from] + balances[_to];
193         // Subtract from the sender
194         balances[_from] -= _value;
195         // Add the same to the recipient
196         balances[_to] += _value;
197         emit Transfer(_from, _to, _value);
198         // Asserts are used to use static analysis to find bugs in your code. They should never fail
199         assert(balances[_from] + balances[_to] == previousBalances);
200 
201         //update bonus state when balance changed
202         BonusState(bonusState).setBalanceState(_from,balances[_from]);
203         BonusState(bonusState).setBalanceState(_to,balances[_to]);
204     }
205 
206     //mint token for ico purchase or airdrop
207     function _mintToken(address _target, uint256 _mintAmount) internal {
208         require(_mintAmount>0);
209         balances[this] = (balances[this]).add(_mintAmount);
210         //update bonus state when balance changed
211         BonusState(bonusState).setBalanceState(address(this),balances[this]);
212         _transfer(this,_target,_mintAmount);
213     }
214 
215     //check lockbonus for target
216     function lockedBonus(address _target) public view returns(uint256 bonus){
217         if(BonusState(bonusState).getSettlementTime()<=now)
218 	    {
219 	        return 0;
220 	    }
221 	    else{
222 	        uint256 _balance = balances[_target];
223             uint256 _fixedBonusTotal = lockBonusTotal();
224 
225             uint256 _unitPrice = ((address(this).balance).sub(_fixedBonusTotal)).div(totalSupply.div(10**decimals));
226             return _balance.mul(_unitPrice).div(10**decimals);
227 	    }
228     }
229 
230 	function lockBonusTotal() public view returns(uint256 bonus){
231 	    if(BonusState(bonusState).getSettlementTime()<=now)
232 	    {
233 	        return address(this).balance;
234 	    }
235 	    else{
236 	        uint256 _fixedBonusTotal = 0;
237             if(bonusState_fixed!=address(0x0))
238             {
239                 _fixedBonusTotal = BonusState(bonusState_fixed).getComputedTotalBalance();
240             }
241     		return _fixedBonusTotal;
242 	    }
243 	}
244 
245     function _withdrawableBonus(address _target) internal view returns(uint256 bonus){
246         uint256 _unitPrice;
247         uint256 _bonusBalance;
248         if(BonusState(bonusState).getSettlementTime()<=now){
249             _unitPrice = (address(this).balance).div(totalSupply.div(10**decimals));
250             _bonusBalance = balances[_target];
251             return _bonusBalance.mul(_unitPrice).div(10**decimals);
252         }
253         else{
254             if(bonusState_fixed==address(0x0))
255             {
256                 return 0;
257             }
258             else{
259                 bool _withdrawState = BonusState(bonusState_fixed).getWithdrawState(_target);
260         		//withdraw only once for each bonus compute
261         		if(_withdrawState)
262         			return 0;
263         		else
264         		{
265         			_unitPrice = BonusState(bonusState_fixed).getComputedUnitPrice();
266         			_bonusBalance = BonusState(bonusState_fixed).getBalanceState(_target);
267         			//when bonus balance is zero and withdraw state is false means possibly state never changed after last compute bonus
268         			//so try to check token balance,if balance has token means never change state
269         			if(_bonusBalance==0){
270         				_bonusBalance = balances[_target];
271         			}
272         			return _bonusBalance.mul(_unitPrice).div(10**decimals);
273         		}
274             }
275         }
276     }
277 
278     function withdrawableBonus(address _target)  public view returns(uint256 bonus){
279         return _withdrawableBonus(_target);
280     }
281 
282     //compute bonus for withdraw and reset bonus state
283     function computeBonus(uint256 _incharge) internal {
284         if(BonusState(bonusState).getSettlementTime()<=now){
285             BonusState(bonusState).setComputedTotalBalance((address(this).balance).sub(_incharge));
286             BonusState(bonusState).setComputedUnitPrice((address(this).balance).sub(_incharge).div(totalSupply.div(10**decimals)));
287             bonusState_fixed = bonusState; //set current bonus as fixed bonus state
288             bonusState = new BonusState(address(this)); //deploy a new bonus state contract
289         }
290     }
291 
292     function getSettlementTime() public view returns(uint256 _time){
293         return BonusState(bonusState).getSettlementTime();
294     }
295 
296     //withdraw the bonus
297     function withdraw() public normal{
298         computeBonus(0);
299         //calc the withdrawable amount
300         uint256 _bonusAmount = _withdrawableBonus(msg.sender);
301         msg.sender.transfer(_bonusAmount);
302 
303         //set withdraw state to true,means bonus has withdrawed
304         BonusState(bonusState_fixed).setWithdrawState(msg.sender,true);
305         uint256 _fixedBonusTotal = 0;
306         if(bonusState_fixed!=address(0x0))
307         {
308             _fixedBonusTotal = BonusState(bonusState_fixed).getComputedTotalBalance();
309         }
310         BonusState(bonusState_fixed).setComputedTotalBalance(_fixedBonusTotal.sub(_bonusAmount));
311     }
312 
313 }
314 
315 contract EtherSesame is EssToken{
316 
317     //about ico
318     uint256 public icoCount;
319 
320 
321     uint256 public beginTime;
322     uint256 public endTime;
323 
324     uint256 public offeredAmount;
325 
326     //the eth price(wei) of one ess(one ess means number exclude the decimals)
327     uint256 public icoPrice;
328 
329     function isOffering() public view returns(bool){
330         return beginTime>0&&now>beginTime&&now<endTime&&icoTotal>0;
331     }
332 
333     function startIco(uint256 _beginTime,uint256 _endTime,uint256 _icoPrice) public onlyOwner{
334         require(_beginTime>0&&_endTime>_beginTime&&_icoPrice>0);
335         beginTime  = _beginTime;
336         endTime  = _endTime;
337         icoPrice = _icoPrice;
338         icoCount++;
339     }
340 
341     function buy() public payable normal{
342         computeBonus(msg.value);
343         //ico activity is started and must buy one ess at least
344         require(isOffering()&&msg.value>=icoPrice);
345         uint256 _amount = (msg.value).div(icoPrice).mul(10**decimals);
346         offeredAmount = offeredAmount.add(_amount);  //increase the offeredAmount for this round
347         icoTotal = icoTotal.sub(_amount);
348         owner.transfer(msg.value);
349         _mintToken(msg.sender,_amount);
350     }
351     //end ico
352 
353     //about airdrop
354     //authed address for airdrop
355     address public airdropAuthAddress;
356     //update airdrop auth
357     function upgradeAirdropAuthAddress(address newAirdropAuthAddress) onlyOwner public {
358         airdropAuthAddress = newAirdropAuthAddress;
359     }
360     modifier airdropAuthed {
361         require(msg.sender == airdropAuthAddress);
362         _;
363     }
364 
365     //airdrop to player amount: (_ethPayment/_airdropPrice)
366     function airdrop(uint256 _airdropPrice,uint256 _ethPayment) public airdropAuthed normal returns(uint256){
367         computeBonus(0);
368         if(_airdropPrice>0&&_ethPayment/_airdropPrice>0&&airdropTotal>0){
369             uint256 _airdropAmount = _ethPayment.div(_airdropPrice);
370             if(_airdropAmount>=airdropTotal){
371                 _airdropAmount = airdropTotal;
372             }
373             if(_airdropAmount>0)
374             {
375                 _airdropAmount = _airdropAmount.mul(10 ** decimals);
376                 airdropTotal-=_airdropAmount;
377                 _mintToken(tx.origin,_airdropAmount);
378             }
379             return _airdropAmount;
380         }
381         else{
382             return 0;
383         }
384     }
385 }
386 
387 /**
388  * @title SafeMath
389  */
390 library SafeMath {
391 
392     /**
393     * @dev divide two numbers, throws on overflow.
394     */
395     function div(uint256 a, uint256 b)
396         internal
397         pure
398         returns (uint256 c)
399     {
400         require(b > 0);
401         c = a / b;
402         return c;
403     }
404 
405     /**
406     * @dev Multiplies two numbers, throws on overflow.
407     */
408     function mul(uint256 a, uint256 b)
409         internal
410         pure
411         returns (uint256 c)
412     {
413         if (a == 0) {
414             return 0;
415         }
416         c = a * b;
417         require(c / a == b);
418         return c;
419     }
420 
421     /**
422     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
423     */
424     function sub(uint256 a, uint256 b)
425         internal
426         pure
427         returns (uint256)
428     {
429         require(b <= a);
430         return a - b;
431     }
432 
433     /**
434     * @dev Adds two numbers, throws on overflow.
435     */
436     function add(uint256 a, uint256 b)
437         internal
438         pure
439         returns (uint256 c)
440     {
441         c = a + b;
442         require(c >= a);
443         return c;
444     }
445 
446 }