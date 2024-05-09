1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     uint256 public totalSupply;
10     function balanceOf(address who) public view returns (uint256);
11     function transfer(address to, uint256 value) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21         if (a == 0) {
22             return 0;
23         }
24         uint256 c = a * b;
25         assert(c / a == b);
26         return c;
27     }
28 
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // assert(b > 0); // Solidity automatically throws when dividing by 0
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return c;
34     }
35 
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         assert(c >= a);
44         return c;
45     }
46     
47      function percent(uint256 a,uint256 b) internal  pure returns (uint256){
48       return mul(div(a,uint256(100)),b);
49     }
50   
51     function power(uint256 a,uint256 b) internal pure returns (uint256){
52       return mul(a,10**b);
53     }
54 }
55 
56 
57 /**
58  * @title Basic token
59  * @dev Basic version of StandardToken, with no allowances.
60  */
61 contract BasicToken is ERC20Basic {
62     using SafeMath for uint256;
63 
64     mapping(address => uint256) balances;
65 
66     /**
67     * @dev transfer token for a specified address
68     * @param _to The address to transfer to.
69     * @param _value The amount to be transferred.
70     */
71     function transfer(address _to, uint256 _value) public returns (bool) {
72         require(_to != address(0));
73         require(_value <= balances[msg.sender]);
74 
75         // SafeMath.sub will throw if there is not enough balance.
76         balances[msg.sender] = balances[msg.sender].sub(_value);
77         balances[_to] = balances[_to].add(_value);
78         Transfer(msg.sender, _to, _value);
79         return true;
80     }
81 
82     /**
83     * @dev Gets the balance of the specified address.
84     * @param _owner The address to query the the balance of.
85     * @return An uint256 representing the amount owned by the passed address.
86     */
87     function balanceOf(address _owner) public view returns (uint256 balance) {
88         return balances[_owner];
89     }
90 
91 }
92 
93 /**
94  * @title ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/20
96  */
97 contract ERC20 is ERC20Basic {
98     function allowance(address owner, address spender) public view returns (uint256);
99     function transferFrom(address from, address to, uint256 value) public returns (bool);
100     function approve(address spender, uint256 value) public returns (bool);
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 
105 /**
106  * @title Standard ERC20 token
107  *
108  * @dev Implementation of the basic standard token.
109  * @dev https://github.com/ethereum/EIPs/issues/20
110  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
111  */
112 contract StandardToken is ERC20, BasicToken {
113 
114     mapping (address => mapping (address => uint256)) internal allowed;
115 
116 
117     /**
118      * @dev Transfer tokens from one address to another
119      * @param _from address The address which you want to send tokens from
120      * @param _to address The address which you want to transfer to
121      * @param _value uint256 the amount of tokens to be transferred
122      */
123     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
124         require(_to != address(0));
125         require(_value <= balances[_from]);
126         require(_value <= allowed[_from][msg.sender]);
127 
128         balances[_from] = balances[_from].sub(_value);
129         balances[_to] = balances[_to].add(_value);
130         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
131         Transfer(_from, _to, _value);
132         return true;
133     }
134 
135     /**
136      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
137      *
138      * Beware that changing an allowance with this method brings the risk that someone may use both the old
139      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
140      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
141      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
142      * @param _spender The address which will spend the funds.
143      * @param _value The amount of tokens to be spent.
144      */
145     function approve(address _spender, uint256 _value) public returns (bool) {
146         allowed[msg.sender][_spender] = _value;
147         Approval(msg.sender, _spender, _value);
148         return true;
149     }
150 
151     /**
152      * @dev Function to check the amount of tokens that an owner allowed to a spender.
153      * @param _owner address The address which owns the funds.
154      * @param _spender address The address which will spend the funds.
155      * @return A uint256 specifying the amount of tokens still available for the spender.
156      */
157     function allowance(address _owner, address _spender) public view returns (uint256) {
158         return allowed[_owner][_spender];
159     }
160 
161     /**
162      * @dev Increase the amount of tokens that an owner allowed to a spender.
163      *
164      * approve should be called when allowed[_spender] == 0. To increment
165      * allowed value is better to use this function to avoid 2 calls (and wait until
166      * the first transaction is mined)
167      * From MonolithDAO Token.sol
168      * @param _spender The address which will spend the funds.
169      * @param _addedValue The amount of tokens to increase the allowance by.
170      */
171     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
172         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
173         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174         return true;
175     }
176 
177     /**
178      * @dev Decrease the amount of tokens that an owner allowed to a spender.
179      *
180      * approve should be called when allowed[_spender] == 0. To decrement
181      * allowed value is better to use this function to avoid 2 calls (and wait until
182      * the first transaction is mined)
183      * From MonolithDAO Token.sol
184      * @param _spender The address which will spend the funds.
185      * @param _subtractedValue The amount of tokens to decrease the allowance by.
186      */
187     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
188         uint oldValue = allowed[msg.sender][_spender];
189         if (_subtractedValue > oldValue) {
190             allowed[msg.sender][_spender] = 0;
191         } else {
192             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
193         }
194         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195         return true;
196     }
197 
198 }
199 
200 contract RDOToken is StandardToken {
201     string public name = "RDO";
202     string public symbol = "RDO";
203     uint256 public decimals = 8;
204     address owner;
205     address crowdsale;
206     
207     event Burn(address indexed burner, uint256 value);
208 
209     function RDOToken() public {
210         owner=msg.sender;
211         uint256 initialTotalSupply=1000000000;
212         totalSupply=initialTotalSupply.power(decimals);
213         balances[msg.sender]=totalSupply;
214         
215         crowdsale=new RDOCrowdsale(this,msg.sender);
216         allocate(crowdsale,75); 
217         allocate(0x523f6034c79915cE9AacD06867721D444c45a6a5,12); 
218         allocate(0x50d0a8eDe1548E87E5f8103b89626bC9C76fe2f8,7); 
219         allocate(0xD8889ff86b9454559979Aa20bb3b41527AE4b74b,3); 
220         allocate(0x5F900841910baaC70e8b736632600c409Af05bf8,3); 
221         
222     }
223 
224     /**
225      * @dev Burns a specific amount of tokens.
226      * @param _value The amount of token to be burned.
227      */
228     function burn(uint256 _value) public {
229         require(_value <= balances[msg.sender]);
230         // no need to require value <= totalSupply, since that would imply the
231         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
232 
233         address burner = msg.sender;
234         balances[burner] = balances[burner].sub(_value);
235         totalSupply = totalSupply.sub(_value);
236         Burn(burner, _value);
237     }
238 
239 
240     function allocate(address _address,uint256 percent) private{
241         uint256 bal=totalSupply.percent(percent);
242         transfer(_address,bal);
243     }
244     /**
245      * @dev Throws if called by any account other than the owner.
246      */
247     modifier onlyOwner() {
248         require(msg.sender==owner);
249         _;
250     }
251     
252     function stopCrowdfunding() onlyOwner public {
253         if(crowdsale!=0x0){
254             RDOCrowdsale(crowdsale).stopCrowdsale();
255             crowdsale=0x0;
256         }
257     }
258     
259     function getCrowdsaleAddress() constant public returns(address){
260         return crowdsale;
261     }
262 }
263 
264 /**
265  * @title RPOCrowdsale
266  * @dev RPOCrowdsale is a contract for managing a token crowdsale for RPO project.
267  * Crowdsale have 9 phases with start and end timestamps, where investors can make
268  * token purchases and the crowdsale will assign them tokens based
269  * on a token per ETH rate and bonuses. Collected funds are forwarded to a wallet
270  * as they arrive.
271  */
272 contract RDOCrowdsale {
273     using SafeMath for uint256;
274 
275     // The token being sold
276     RDOToken public token;
277 
278     // External wallet where funds get forwarded
279     address public wallet;
280 
281     // Crowdsale administrator
282     address public owners;
283 
284     
285     // price per 1 RDO
286     uint256 public price=0.55 finney;
287 
288     // Phases list, see schedule in constructor
289     mapping (uint => Phase) phases;
290 
291     // The total number of phases (0...9)
292     uint public totalPhases = 9;
293 
294     // Description for each phase
295     struct Phase {
296         uint256 startTime;
297         uint256 endTime;
298         uint256 bonusPercent;
299     }
300 
301     // Bonus based on value
302     BonusValue[] bonusValue;
303 
304     struct BonusValue{
305         uint256 minimum;
306         uint256 maximum;
307         uint256 bonus;
308     }
309     
310     // Minimum Deposit in eth
311     uint256 public constant minContribution = 100 finney;
312 
313 
314     // Amount of raised Ethers (in wei).
315     uint256 public weiRaised;
316 
317     /**
318      * event for token purchase logging
319      * @param purchaser who paid for the tokens
320      * @param beneficiary who got the tokens
321      * @param value weis paid for purchase
322      * @param bonusPercent free tokens percantage for the phase
323      * @param amount amount of tokens purchased
324      */
325     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 bonusPercent, uint256 amount);
326 
327     // event for wallet update
328     event WalletSet(address indexed wallet);
329 
330     function RDOCrowdsale(address _tokenAddress, address _wallet) public {
331         require(_tokenAddress != address(0));
332         token = RDOToken(_tokenAddress);
333         wallet = _wallet;
334         owners=msg.sender;
335         
336         /*
337         ICO SCHEDULE
338         Bonus        
339         40%     1 round
340         30%     2 round
341         25%     3 round
342         20%     4 round
343         15%     5 round
344         10%     6 round
345         7%      7 round
346         5%      8 round
347         3%      9 round
348         */
349         
350         fillPhase(0,40,25 days);
351         fillPhase(1,30,15 days);
352         fillPhase(2,25,15 days);
353         fillPhase(3,20,15 days);
354         fillPhase(4,15,15 days);
355         fillPhase(5,10,15 days);
356         fillPhase(6,7,15 days);
357         fillPhase(7,5,15 days);
358         fillPhase(8,3,15 days);
359         
360         // Fill bonus based on value
361         bonusValue.push(BonusValue({
362             minimum:5 ether,
363             maximum:25 ether,
364             bonus:5
365         }));
366         bonusValue.push(BonusValue({
367             minimum:26 ether,
368             maximum:100 ether,
369             bonus:8
370         }));
371         bonusValue.push(BonusValue({
372             minimum:101 ether,
373             maximum:100000 ether,
374             bonus:10
375         }));
376     }
377     
378     function fillPhase(uint8 index,uint256 bonus,uint256 delay) private{
379         phases[index].bonusPercent=bonus;
380         if(index==0){
381             phases[index].startTime = now;
382         }
383         else{
384             phases[index].startTime = phases[index-1].endTime;
385         }
386         phases[index].endTime = phases[index].startTime+delay;
387     }
388 
389     // fallback function can be used to buy tokens
390     function () external payable {
391         buyTokens(msg.sender);
392     }
393 
394     // low level token purchase function
395     function buyTokens(address beneficiary) public payable {
396         require(beneficiary != address(0));
397         require(msg.value != 0);
398 
399         uint256 currentBonusPercent = getBonusPercent(now);
400         uint256 weiAmount = msg.value;
401         uint256 volumeBonus=getVolumeBonus(weiAmount);
402         
403         require(weiAmount>=minContribution);
404 
405         // calculate token amount to be created
406         uint256 tokens = calculateTokenAmount(weiAmount, currentBonusPercent,volumeBonus);
407 
408         // update state
409         weiRaised = weiRaised.add(weiAmount);
410 
411         token.transfer(beneficiary, tokens);
412         TokenPurchase(msg.sender, beneficiary, weiAmount, currentBonusPercent, tokens);
413 
414         forwardFunds();
415     }
416 
417     function getVolumeBonus(uint256 _wei) private view returns(uint256){
418         for(uint256 i=0;i<bonusValue.length;++i){
419             if(_wei>bonusValue[i].minimum && _wei<bonusValue[i].maximum){
420                 return bonusValue[i].bonus;
421             }
422         }
423         return 0;
424     }
425     
426     // If phase exists return corresponding bonus for the given date
427     // else return 0 (percent)
428     function getBonusPercent(uint256 datetime) private view returns (uint256) {
429         for (uint i = 0; i < totalPhases; i++) {
430             if (datetime >= phases[i].startTime && datetime <= phases[i].endTime) {
431                 return phases[i].bonusPercent;
432             }
433         }
434         return 0;
435     }
436 
437     /**
438      * @dev Throws if called by any account other than the owner.
439      */
440     modifier onlyOwner() {
441         require(owners==msg.sender);
442         _;
443     }
444 
445     // calculates how much tokens will beneficiary get
446     // for given amount of wei
447     function calculateTokenAmount(uint256 _weiDeposit, uint256 _bonusTokensPercent,uint256 _volumeBonus) private view returns (uint256) {
448         uint256 mainTokens = _weiDeposit.div(price);
449         uint256 bonusTokens = mainTokens.percent(_bonusTokensPercent);
450         uint256 volumeBonus=mainTokens.percent(_volumeBonus);
451         return mainTokens.add(bonusTokens).add(volumeBonus);
452     }
453 
454     // send ether to the fund collection wallet
455     // override to create custom fund forwarding mechanisms
456     function forwardFunds() internal {
457         wallet.transfer(msg.value);
458     }
459 
460     function stopCrowdsale() public {
461         token.burn(token.balanceOf(this));
462         selfdestruct(wallet);
463     }
464     
465     function getCurrentBonus() public constant returns(uint256){
466         return getBonusPercent(now);
467     }
468     
469     function calculateEstimateToken(uint256 _wei) public constant returns(uint256){
470         uint256 timeBonus=getCurrentBonus();
471         uint256 volumeBonus=getVolumeBonus(_wei);
472         return calculateTokenAmount(_wei,timeBonus,volumeBonus);
473     }
474 }