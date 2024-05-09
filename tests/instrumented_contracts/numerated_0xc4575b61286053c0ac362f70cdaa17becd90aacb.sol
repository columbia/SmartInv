1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath for performing valid mathematics.
5  */
6 library SafeMath {
7   function Mul (uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   function Div (uint256 a, uint256 b) internal pure returns (uint256) {
17     //assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function Sub (uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function Add (uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 /**
36  * Contract "Ownable"
37  * Purpose: Defines Owner for contract
38  * Status : Complete
39  * 
40  */
41 contract Ownable {
42 
43 	//owner variable to store contract owner account
44   address public owner;
45 
46   //Constructor for the contract to store owner's account on deployement
47   function Ownable() public {
48     owner = msg.sender;
49   }
50 
51   //modifier to check transaction initiator is only owner
52   modifier onlyOwner() {
53     require(msg.sender == owner);
54     _;
55   }
56 
57 }
58 
59 // ERC20 Interface
60 contract ERC20 {
61   uint256 public totalSupply;
62   function balanceOf(address who) public view returns (uint256);
63   function transfer(address to, uint256 value) public returns (bool);
64   function allowance(address owner, address spender) public view returns (uint256);
65   function transferFrom(address from, address to, uint256 value) public returns (bool);
66   function approve(address spender, uint256 value) public returns (bool);
67   event Approval(address indexed owner, address indexed spender, uint256 value);
68   event Transfer(address indexed from, address indexed to, uint256 value);
69 }
70 
71 /**
72  * @title GIZA to implement token
73  */
74 contract GIZAToken is ERC20, Ownable {
75 
76     using SafeMath for uint256;
77     //The name of the  token
78     bytes32 public name;
79     //The token symbol
80     bytes32 public symbol;
81     //The precision used in the calculations in contract
82     uint8 public decimals;   
83     //To denote the locking on transfer of tokens among token holders
84     bool public locked;
85 	// Founder address. Need to froze for 8 moths
86 	address public founder;
87 	// Team address. Need to froze for 8 moths
88 	address public team;
89 	// Start of Pre-ICO date
90 	uint256 public start;
91 	
92     //Mapping to relate number of  token to the account
93     mapping(address => uint256 ) balances;
94     //Mapping to relate owner and spender to the tokens allowed to transfer from owner
95     mapping(address => mapping(address => uint256)) allowed;
96 
97     event Burn(address indexed burner, uint indexed value);  
98 
99     /**
100     * @dev Constructor of GIZA
101     */
102     function GIZAToken(address _founder, address _team) public {
103 		require( _founder != address(0) && _team != address(0) );
104         /* Public variables of the token */
105         //The name of the  token
106         name = "GIZA Token";
107         //The token symbol
108         symbol = "GIZA";
109         //Number of zeroes to be treated as decimals
110         decimals = 18;       
111         //initial token supply 0
112         totalSupply = 368e23; // 36 800 000 tokens total
113         //Transfer of tokens is locked (not allowed) when contract is deployed
114         locked = true;
115 		// Save founder and team address
116 		founder = _founder;
117 		team = _team;
118 		balances[msg.sender] = totalSupply;
119 		start = 0;
120     }
121       
122 	function startNow() external onlyOwner {
123 		start = now;
124 	}
125 	  
126     //To handle ERC20 short address attack
127     modifier onlyPayloadSize(uint256 size) {
128        require(msg.data.length >= size + 4);
129        _;
130     }
131 
132     modifier onlyUnlocked() { 
133       require (!locked); 
134       _; 
135     }
136 	
137     modifier ifNotFroze() { 
138 		if ( 
139 		  (msg.sender == founder || msg.sender == team) && 
140 		  (start == 0 || now < (start + 80 days) ) ) revert();
141 		_;
142     }
143     
144     //To enable transfer of tokens
145     function unlockTransfer() external onlyOwner{
146       locked = false;
147     }
148 
149     /**
150     * @dev Check balance of given account address
151     *
152     * @param _owner The address account whose balance you want to know
153     * @return balance of the account
154     */
155     function balanceOf(address _owner) public view returns (uint256 _value){
156         return balances[_owner];
157     }
158 
159     /**
160     * @dev Transfer tokens to an address given by sender
161     *
162     * @param _to The address which you want to transfer to
163     * @param _value the amount of tokens to be transferred
164     * @return A bool if the transfer was a success or not
165     */
166     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) onlyUnlocked ifNotFroze public returns(bool _success) {
167         require( _to != address(0) );
168         if((balances[msg.sender] > _value) && _value > 0){
169 			balances[msg.sender] = balances[msg.sender].Sub(_value);
170 			balances[_to] = balances[_to].Add(_value);
171 			Transfer(msg.sender, _to, _value);
172 			return true;
173         }
174         else{
175             return false;
176         }
177     }
178 
179     /**
180     * @dev Transfer tokens from one address to another, for ERC20.
181     *
182     * @param _from The address which you want to send tokens from
183     * @param _to The address which you want to transfer to
184     * @param _value the amount of tokens to be transferred
185     * @return A bool if the transfer was a success or not
186     */
187     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) onlyUnlocked ifNotFroze public returns (bool success){
188         require( _to != address(0) && (_from != address(0)));
189         if((_value > 0)
190            && (allowed[_from][msg.sender] > _value )){
191             balances[_from] = balances[_from].Sub(_value);
192             balances[_to] = balances[_to].Add(_value);
193             allowed[_from][msg.sender] = allowed[_from][msg.sender].Sub(_value);
194             Transfer(_from, _to, _value);
195             return true;
196         }
197         else{
198             return false;
199         }
200     }
201 
202     /**
203     * @dev Function to check the amount of tokens that an owner has allowed a spender to recieve from owner.
204     *
205     * @param _owner address The address which owns the funds.
206     * @param _spender address The address which will spend the funds.
207     * @return A uint256 specifying the amount of tokens still available for the spender to spend.
208     */
209     function allowance(address _owner, address _spender) public view returns (uint256){
210         return allowed[_owner][_spender];
211     }
212 
213     /**
214     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
215     *
216     * @param _spender The address which will spend the funds.
217     * @param _value The amount of tokens to be spent.
218     */
219     function approve(address _spender, uint256 _value) public returns (bool){
220         if( (_value > 0) && (_spender != address(0)) && (balances[msg.sender] >= _value)){
221             allowed[msg.sender][_spender] = _value;
222             Approval(msg.sender, _spender, _value);
223             return true;
224         }
225         else{
226             return false;
227         }
228     }
229     
230     // Only owner can burn own tokens
231     function burn(uint _value) public onlyOwner {
232         require(_value > 0);
233         address burner = msg.sender;
234         balances[burner] = balances[burner].Sub(_value);
235         totalSupply = totalSupply.Sub(_value);
236         Burn(burner, _value);
237     }
238 
239 }
240 
241 contract Crowdsale is Ownable {
242     
243     using SafeMath for uint256;
244     GIZAToken token;
245     address public token_address;
246     address public owner;
247     address founder;
248     address team;
249     address multisig;
250     bool started = false;
251     //price of token against 1 ether
252     uint256 public dollarsForEther;
253     //No of days for which pre ico will be open
254     uint256 constant DURATION_PRE_ICO = 30;
255     uint256 startBlock = 0; // Start timestamp
256     uint256 tokensBought = 0; // Amount of bought tokens
257     uint256 totalRaisedEth = 0; // Total raised ETH
258 
259     uint256 constant MAX_TOKENS_FIRST_7_DAYS_PRE_ICO  = 11000000 * 1 ether; // 10 000 000 + 10%
260 	uint256 constant MAX_TOKENS_PRE_ICO    				    = 14850000 * 1 ether; // max 14 850 000 tokens
261     uint256 constant MAX_TOKENS_FIRST_5_DAYS_ICO        = 3850000 * 1 ether;   // 3 500 000 + 10%
262     uint256 constant MAX_TOKENS_FIRST_10_DAYS_ICO      	= 10725000 * 1 ether; // 9 750 000 + 10%
263     uint256 constant MAX_BOUNTY      	                			= 1390000 * 1 ether;
264     uint256 bountySent = 0;
265     enum CrowdsaleType { PreICO, ICO }
266     CrowdsaleType etype = CrowdsaleType.PreICO;
267     
268     
269     function Crowdsale(address _founder, address _team, address _multisig) public {
270         require(_founder != address(0) && _team != address(0) && _multisig != address(0));
271         owner = msg.sender;
272         team = _team;
273         multisig = _multisig;
274         founder = _founder;
275         token = new GIZAToken(_founder, _team);
276         token_address = address(token);
277     }
278     
279     modifier isStarted() {
280         require (started == true);
281         _;
282     }
283     
284     // Set current price of one Ether in dollars
285     function setDollarForOneEtherRate(uint256 _dollars) public onlyOwner {
286         dollarsForEther = _dollars;
287     }
288     
289     function sendBounty(address _to, uint256 _amount) public onlyOwner returns(bool){
290         require(_amount != 0 && _to != address(0));
291         token.unlockTransfer();
292         uint256 totalToSend = _amount.Mul(1 ether);
293         require(bountySent.Add(totalToSend) < MAX_BOUNTY);
294         if ( transferTokens(_to, totalToSend) ){
295                 bountySent = bountySent.Add(totalToSend);
296                 return true;
297         }else
298             return false;        
299     }
300     
301     function sendTokens(address _to, uint256 _amount) public onlyOwner returns(bool){
302         require(_amount != 0 && _to != address(0));
303         token.unlockTransfer();
304         return transferTokens(_to, _amount.Mul(1 ether));
305     } 
306   
307     //To start Pre ICO
308     function startPreICO(uint256 _dollarForOneEtherRate) public onlyOwner {
309         require(startBlock == 0 && _dollarForOneEtherRate > 0);
310         //Set block number to current block number
311         startBlock = now;
312         //to show pre Ico is running
313         etype = CrowdsaleType.PreICO;
314         started = true;
315         dollarsForEther = _dollarForOneEtherRate;
316         token.startNow();
317         token.unlockTransfer();
318     }
319 	
320 	// Finish pre ICO.
321 	function endPreICO() public onlyOwner {
322 		started = false;
323 	}
324   
325     //to start ICO
326     function startICO(uint256 _dollarForOneEtherRate) public onlyOwner{
327         //ico can be started only after the end of pre ico
328         require( startBlock != 0 && now > startBlock.Add(DURATION_PRE_ICO) );
329         startBlock = now;
330         //to show iCO IS running
331         etype = CrowdsaleType.ICO;
332         started = true;
333         dollarsForEther = _dollarForOneEtherRate;
334     }
335     
336     // Get current price of token on current time interval
337     function getCurrentTokenPriceInCents() public view returns(uint256){
338         require(startBlock != 0);
339         uint256 _day = (now - startBlock).Div(1 days);
340         // Pre-ICO
341         if (etype == CrowdsaleType.PreICO){
342             require(_day <= DURATION_PRE_ICO && tokensBought < MAX_TOKENS_PRE_ICO);
343             if (_day >= 0 && _day <= 7 && tokensBought < MAX_TOKENS_FIRST_7_DAYS_PRE_ICO)
344                 return 20; // $0.2
345 			else
346                 return 30; // $0.3
347         // ICO
348         } else {
349             if (_day >= 0 && _day <= 5 && tokensBought < MAX_TOKENS_FIRST_5_DAYS_ICO)
350                 return 60; // $0.6 
351             else if (_day > 5 && _day <= 10 && tokensBought < MAX_TOKENS_FIRST_10_DAYS_ICO)
352                 return 80; // $0.8 
353             else
354                 return 100; // $1 
355         }        
356     }
357     
358     // Calculate tokens to send
359     function calcTokensToSend(uint256 _value) internal view returns (uint256){
360         require (_value > 0);
361         
362         // Current token price in cents
363         uint256 currentTokenPrice = getCurrentTokenPriceInCents();
364         
365         // Calculate value in dollars*100
366         // _value in dollars * 100 
367         // Example: for $54.38 valueInDollars = 5438        
368         uint256 valueInDollars = _value.Mul(dollarsForEther).Div(10**16);
369         uint256 tokensToSend = valueInDollars.Div(currentTokenPrice);
370         
371         // Calculate bonus by purshase
372         uint8 bonusPercent = 0;
373         _value = _value.Div(1 ether).Mul(dollarsForEther);
374         if ( _value >= 35000 ){
375             bonusPercent = 10;
376         }else if ( _value >= 20000 ){
377             bonusPercent = 7;
378         }else if ( _value >= 10000 ){
379             bonusPercent = 5;
380         }
381         // Add bonus tokens
382         if (bonusPercent > 0) tokensToSend = tokensToSend.Add(tokensToSend.Div(100).Mul(bonusPercent));
383         
384         return tokensToSend;
385     }    
386 
387     // Transfer funds to owner
388     function forwardFunds(uint256 _value) internal {
389         multisig.transfer(_value);
390     }
391 
392     // transfer tokens
393     function transferTokens(address _to, uint256 _tokensToSend) internal returns(bool){
394         uint256 tot = _tokensToSend.Mul(1222).Div(8778); // 5.43 + 6.79 = 12.22, 10000 - 1222 = 8778 
395         uint256 tokensForTeam = tot.Mul(4443).Div(1e4);// 5.43% for Team (44,43% of (5.43 + 6.79) )
396         uint256 tokensForFounder = tot.Sub(tokensForTeam);// 6.79% for Founders
397         uint256 totalToSend = _tokensToSend.Add(tokensForFounder).Add(tokensForTeam);
398         if (token.balanceOf(this) >= totalToSend && 
399             token.transfer(_to, _tokensToSend) == true){
400                 token.transfer(founder, tokensForFounder);
401                 token.transfer(team, tokensForTeam);
402                 tokensBought = tokensBought.Add(totalToSend);
403                 return true;
404         }else
405             return false;
406     }
407 
408     function buyTokens(address _beneficiary) public isStarted payable {
409         require(_beneficiary != address(0) &&  msg.value != 0 );
410         uint256 tokensToSend = calcTokensToSend(msg.value);
411         tokensToSend = tokensToSend.Mul(1 ether);
412         
413         // Pre-ICO
414         if (etype == CrowdsaleType.PreICO){
415             require(tokensBought.Add(tokensToSend) < MAX_TOKENS_PRE_ICO);
416         }      
417         
418         if (!transferTokens(_beneficiary, tokensToSend)) revert();
419         totalRaisedEth = totalRaisedEth.Add( (msg.value).Div(1 ether) );
420         forwardFunds(msg.value);
421     }
422 
423     // Fallback function
424     function () public payable {
425         buyTokens(msg.sender);
426     }
427     
428     // Burn unsold tokens
429     function burnTokens() public onlyOwner {
430         token.burn( token.balanceOf(this) );
431         started = false;
432     }
433     
434     // destroy this contract
435     function kill() public onlyOwner{
436         selfdestruct(multisig);   
437     }
438 }