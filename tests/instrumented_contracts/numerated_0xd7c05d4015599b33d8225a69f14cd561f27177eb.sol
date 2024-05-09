1 pragma solidity ^0.4.25; /*
2 
3 ___________________________________________________________________
4   _      _                                        ______           
5   |  |  /          /                                /              
6 --|-/|-/-----__---/----__----__---_--_----__-------/-------__------
7   |/ |/    /___) /   /   ' /   ) / /  ) /___)     /      /   )     
8 __/__|____(___ _/___(___ _(___/_/_/__/_(___ _____/______(___/__o_o_
9 
10 
11  .----------------.  .----------------.  .----------------.  .----------------.  .-----------------.
12 | .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |
13 | |    _______   | || |  _________   | || |   _______    | || |  _________   | || | ____  _____  | |
14 | |   /  ___  |  | || | |_   ___  |  | || |  |  ___  |   | || | |_   ___  |  | || ||_   \|_   _| | |
15 | |  |  (__ \_|  | || |   | |_  \_|  | || |  |_/  / /    | || |   | |_  \_|  | || |  |   \ | |   | |
16 | |   '.___`-.   | || |   |  _|  _   | || |      / /     | || |   |  _|  _   | || |  | |\ \| |   | |
17 | |  |`\____) |  | || |  _| |___/ |  | || |     / /      | || |  _| |___/ |  | || | _| |_\   |_  | |
18 | |  |_______.'  | || | |_________|  | || |    /_/       | || | |_________|  | || ||_____|\____| | |
19 | |              | || |              | || |              | || |              | || |              | |
20 | '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |
21  '----------------'  '----------------'  '----------------'  '----------------'  '----------------' 
22 
23 
24 // ----------------------------------------------------------------------------
25 
26 // Name        : se7en
27 // Symbol      : S7N
28 // Copyright (c) 2018 XSe7en Social Media Inc. ( https://se7en.social )
29 // Contract written by EtherAuthority ( https://EtherAuthority.io )
30 // ----------------------------------------------------------------------------
31    
32 */ 
33 
34 //*******************************************************************//
35 //------------------------ SafeMath Library -------------------------//
36 //*******************************************************************//
37     /**
38      * @title SafeMath
39      * @dev Math operations with safety checks that throw on error
40      */
41     library SafeMath {
42       function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43         if (a == 0) {
44           return 0;
45         }
46         uint256 c = a * b;
47         assert(c / a == b);
48         return c;
49       }
50     
51       function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         // assert(b > 0); // Solidity automatically throws when dividing by 0
53         uint256 c = a / b;
54         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55         return c;
56       }
57     
58       function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         assert(b <= a);
60         return a - b;
61       }
62     
63       function add(uint256 a, uint256 b) internal pure returns (uint256) {
64         uint256 c = a + b;
65         assert(c >= a);
66         return c;
67       }
68     }
69 
70 
71 //*******************************************************************//
72 //------------------ Contract to Manage Ownership -------------------//
73 //*******************************************************************//
74     
75     contract owned {
76         address public owner;
77         
78          constructor () public {
79             owner = msg.sender;
80         }
81     
82         modifier onlyOwner {
83             require(msg.sender == owner);
84             _;
85         }
86     
87         function transferOwnership(address newOwner) onlyOwner public {
88             owner = newOwner;
89         }
90     }
91     
92     interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes  _extraData) external; }
93 
94 
95 //***************************************************************//
96 //------------------ ERC20 Standard Template -------------------//
97 //***************************************************************//
98     
99     contract TokenERC20 {
100         // Public variables of the token
101         using SafeMath for uint256;
102         string public name;
103         string public symbol;
104         uint8 public decimals = 18;
105         uint256 public totalSupply;
106         uint256 public reservedForICO;
107         bool public safeguard = false;  //putting safeguard on will halt all non-owner functions
108     
109         // This creates an array with all balances
110         mapping (address => uint256) public balanceOf;
111         mapping (address => mapping (address => uint256)) public allowance;
112     
113         // This generates a public event on the blockchain that will notify clients
114         event Transfer(address indexed from, address indexed to, uint256 value);
115     
116         // This notifies clients about the amount burnt
117         event Burn(address indexed from, uint256 value);
118     
119         /**
120          * Constructor function
121          *
122          * Initializes contract with initial supply tokens to the creator of the contract
123          */
124         constructor (
125             uint256 initialSupply,
126             uint256 allocatedForICO,
127             string memory tokenName,
128             string memory tokenSymbol
129         ) public {
130             totalSupply = initialSupply.mul(1 ether);   
131             reservedForICO = allocatedForICO.mul(1 ether);  
132             balanceOf[address(this)] = reservedForICO;      
133             balanceOf[msg.sender]=totalSupply.sub(reservedForICO); 
134             name = tokenName;                               
135             symbol = tokenSymbol;                           
136         }
137     
138         /**
139          * Internal transfer, can be called only by this contract
140          */
141         function _transfer(address _from, address _to, uint _value) internal {
142             require(!safeguard);
143             // Prevent transfer to 0x0 address. Use burn() instead
144             require(_to != address(0x0));
145             // Check if the sender has enough balance
146             require(balanceOf[_from] >= _value);
147             // Check for overflows
148             require(balanceOf[_to].add(_value) > balanceOf[_to]);
149             // Save this for an assertion in the future
150             uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
151             // Subtract from the sender
152             balanceOf[_from] = balanceOf[_from].sub(_value);
153             balanceOf[_to] = balanceOf[_to].add(_value);
154             emit Transfer(_from, _to, _value);
155             assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
156         }
157     
158         /**
159          * Transfer tokens
160          *
161          * Send `_value` tokens to `_to` from your account
162          *
163          * @param _to The address of the recipient
164          * @param _value the amount to send
165          */
166         function transfer(address _to, uint256 _value) public returns (bool success) {
167             _transfer(msg.sender, _to, _value);
168             return true;
169         }
170     
171         /**
172          * Transfer tokens from other address
173          *
174          * Send `_value` tokens to `_to` in behalf of `_from`
175          *
176          * @param _from The address of the sender
177          * @param _to The address of the recipient
178          * @param _value the amount to send
179          */
180         function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
181             require(!safeguard);
182             require(_value <= allowance[_from][msg.sender]);    
183             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
184             _transfer(_from, _to, _value);
185             return true;
186         }
187     
188         /**
189          * Set allowance for other address
190          *
191          * Allows `_spender` to spend no more than `_value` tokens in your behalf
192          *
193          * @param _spender The address authorized to spend
194          * @param _value the max amount they can spend
195          */
196         function approve(address _spender, uint256 _value) public
197             returns (bool success) {
198             require(!safeguard);
199             allowance[msg.sender][_spender] = _value;
200             return true;
201         }
202     
203         /**
204          * Set allowance for other address and notify
205          *
206          * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
207          *
208          * @param _spender The address authorized to spend
209          * @param _value the max amount they can spend
210          * @param _extraData some extra information to send to the approved contract
211          */
212         function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
213             public
214             returns (bool success) {
215             require(!safeguard);
216             tokenRecipient spender = tokenRecipient(_spender);
217             if (approve(_spender, _value)) {
218                 spender.receiveApproval(msg.sender, _value, address(this), _extraData);
219                 return true;
220             }
221         }
222     
223         /**
224          * Destroy tokens
225          *
226          * Remove `_value` tokens from the system irreversibly
227          *
228          * @param _value the amount of tokens to burn
229          */
230         function burn(uint256 _value) public returns (bool success) {
231             require(!safeguard);
232             require(balanceOf[msg.sender] >= _value);   
233             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            
234             totalSupply = totalSupply.sub(_value);                      
235             emit Burn(msg.sender, _value);
236             return true;
237         }
238     
239         /**
240          * Destroy tokens from other account
241          *
242          * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
243          *
244          * @param _from the address of the sender
245          * @param _value the amount of tokens to burn
246          */
247         function burnFrom(address _from, uint256 _value) public returns (bool success) {
248             require(!safeguard);
249             require(balanceOf[_from] >= _value);                
250             require(_value <= allowance[_from][msg.sender]);    
251             balanceOf[_from] = balanceOf[_from].sub(_value);                         
252             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             
253             totalSupply = totalSupply.sub(_value);                              
254             emit  Burn(_from, _value);
255             return true;
256         }
257         
258     }
259     
260 //************************************************************************//
261 //---------------------  SE7EN MAIN CODE STARTS HERE ---------------------//
262 //************************************************************************//
263     
264     contract se7en is owned, TokenERC20 {
265         
266         /*************************************/
267         /*  User whitelisting functionality  */
268         /*************************************/
269         bool public whitelistingStatus = false;
270         mapping (address => bool) public whitelisted;
271         
272         /**
273          * Change whitelisting status on or off
274          *
275          * When whitelisting is true, then crowdsale will only accept investors who are whitelisted.
276          */
277         function changeWhitelistingStatus() onlyOwner public{
278             if (whitelistingStatus == false){
279                 whitelistingStatus = true;
280             }
281             else{
282                 whitelistingStatus = false;    
283             }
284         }
285         
286         /**
287          * Whitelist any user address - only Owner can do this
288          *
289          * It will add user address to whitelisted mapping
290          */
291         function whitelistUser(address userAddress) onlyOwner public{
292             require(whitelistingStatus == true);
293             require(userAddress != address(0x0));
294             whitelisted[userAddress] = true;
295         }
296         
297         /**
298          * Whitelist Many user address at once - only Owner can do this
299          * maximum of 150 addresses to prevent block gas limit max-out and DoS attack
300          * this will add user address in whitelisted mapping
301          */
302         function whitelistManyUsers(address[] memory userAddresses) onlyOwner public{
303             require(whitelistingStatus == true);
304             uint256 addressCount = userAddresses.length;
305             require(addressCount <= 150);
306             for(uint256 i = 0; i < addressCount; i++){
307                 require(userAddresses[i] != address(0x0));
308                 whitelisted[userAddresses[i]] = true;
309             }
310         }
311         
312         
313         
314         /********************************/
315         /* Code for the ERC20 S7N Token */
316         /********************************/
317     
318         /* Public variables of the token */
319         string private tokenName = "se7en";
320         string private tokenSymbol = "S7N";
321         uint256 private initialSupply = 74243687134;
322         uint256 private allocatedForICO = 7424368713;
323         
324 
325         mapping (address => bool) public frozenAccount;
326         
327         event FrozenFunds(address target, bool frozen);
328     
329         constructor () TokenERC20(initialSupply, allocatedForICO, tokenName, tokenSymbol) public {}
330 
331         function _transfer(address _from, address _to, uint _value) internal {
332             require(!safeguard);
333             require (_to != address(0x0));                      
334             require (balanceOf[_from] >= _value);               
335             require (balanceOf[_to].add(_value) >= balanceOf[_to]); 
336             require(!frozenAccount[_from]);                     
337             require(!frozenAccount[_to]);                       
338             balanceOf[_from] = balanceOf[_from].sub(_value);   
339             balanceOf[_to] = balanceOf[_to].add(_value);        
340             emit Transfer(_from, _to, _value);
341         }
342         
343         /// @notice Create `mintedAmount` tokens and send it to `target`
344         /// @param target Address to receive the tokens
345         /// @param mintedAmount the amount of tokens it will receive
346         function mintToken(address target, uint256 mintedAmount) onlyOwner public {
347             balanceOf[target] = balanceOf[target].add(mintedAmount);
348             totalSupply = totalSupply.add(mintedAmount);
349             emit Transfer(address(0x0), address(this), mintedAmount);
350             emit Transfer(address(this), target, mintedAmount);
351         }
352 
353         /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
354         /// @param target Address to be frozen
355         /// @param freeze either to freeze it or not
356         function freezeAccount(address target, bool freeze) onlyOwner public {
357                 frozenAccount[target] = freeze;
358             emit  FrozenFunds(target, freeze);
359         }
360 
361         /******************************/
362         /* Code for the S7N Crowdsale */
363         /******************************/
364         
365         uint256 public datePreSale   = 1544943600 ;      // 16 Dec 2018 07:00:00 - GMT
366         uint256 public dateIcoPhase1 = 1546326000 ;      // 01 Jan 2019 07:00:00 - GMT
367         uint256 public dateIcoPhase2 = 1547622000 ;      // 16 Jan 2019 07:00:00 - GMT
368         uint256 public dateIcoPhase3 = 1549004400 ;      // 01 Feb 2019 07:00:00 - GMT
369         uint256 public dateIcoEnd    = 1551398399 ;      // 28 Feb 2019 23:59:59 - GMT
370         uint256 public exchangeRate  = 10000;             // 1 ETH = 10000 Tokens
371         uint256 public tokensSold    = 0;                // how many tokens sold through crowdsale              
372   
373         function () payable external {
374             require(!safeguard);
375             require(!frozenAccount[msg.sender]);
376             require(datePreSale < now && dateIcoEnd > now);
377             if(whitelistingStatus == true) { require(whitelisted[msg.sender]); }
378             if(datePreSale < now && dateIcoPhase1 > now){ require(msg.value >= (0.50 ether)); }
379             // calculate token amount to be sent
380             uint256 token = msg.value.mul(exchangeRate);                        
381             uint256 finalTokens = token.add(calculatePurchaseBonus(token));     
382             tokensSold = tokensSold.add(finalTokens);
383             _transfer(address(this), msg.sender, finalTokens);                  
384             forwardEherToOwner();                                               
385         }
386 
387 
388         function calculatePurchaseBonus(uint256 token) internal view returns(uint256){
389             if(datePreSale < now && now < dateIcoPhase1 ){
390                 return token.mul(50).div(100);  //50% bonus in pre sale
391             }
392             else if(dateIcoPhase1 < now && now < dateIcoPhase2 ){
393                 return token.mul(25).div(100);  //25% bonus in ICO phase 1
394             }
395             else if(dateIcoPhase2 < now && now < dateIcoPhase3 ){
396                 return token.mul(10).div(100);  //10% bonus in ICO phase 2
397             }
398             else if(dateIcoPhase3 < now && now < dateIcoEnd ){
399                 return token.mul(5).div(100);  //5% bonus in ICO phase 3
400             }
401             else{
402                 return 0;                      //NO BONUS
403             }
404         }
405 
406         function forwardEherToOwner() internal {
407             address(owner).transfer(msg.value); 
408         }
409 
410         function updateCrowdsale(uint256 datePreSaleNew, uint256 dateIcoPhase1New, uint256 dateIcoPhase2New, uint256 dateIcoPhase3New, uint256 dateIcoEndNew) onlyOwner public {
411             require(datePreSaleNew < dateIcoPhase1New && dateIcoPhase1New < dateIcoPhase2New);
412             require(dateIcoPhase2New < dateIcoPhase3New && dateIcoPhase3New < dateIcoEnd);
413             datePreSale   = datePreSaleNew;
414             dateIcoPhase1 = dateIcoPhase1New;
415             dateIcoPhase2 = dateIcoPhase2New;
416             dateIcoPhase3 = dateIcoPhase3New;
417             dateIcoEnd    = dateIcoEndNew;
418         }
419         
420 
421         function stopICO() onlyOwner public{
422             dateIcoEnd = 0;
423         }
424         
425 
426         function icoStatus() public view returns(string memory){
427             if(datePreSale > now ){
428                 return "Pre sale has not started yet";
429             }
430             else if(datePreSale < now && now < dateIcoPhase1){
431                 return "Pre sale is running";
432             }
433             else if(dateIcoPhase1 < now && now < dateIcoPhase2){
434                 return "ICO phase 1 is running";
435             }
436             else if(dateIcoPhase2 < now && now < dateIcoPhase3){
437                 return "ICO phase 2 is running";
438             }
439             else if(dateIcoPhase3 < now && now < dateIcoEnd){
440                 return "ICO phase 3 is running";
441             }
442             else{
443                 return "ICO is not active";
444             }
445         }
446         
447         function setICOExchangeRate(uint256 newExchangeRate) onlyOwner public {
448             exchangeRate=newExchangeRate;
449         }
450         
451         function manualWithdrawToken(uint256 _amount) onlyOwner public {
452             uint256 tokenAmount = _amount.mul(1 ether);
453             _transfer(address(this), msg.sender, tokenAmount);
454         }
455           
456         function manualWithdrawEther()onlyOwner public{
457             address(owner).transfer(address(this).balance);
458         }
459         
460         function destructContract()onlyOwner public{
461             selfdestruct(owner);
462         }
463         
464         /**
465          * Change safeguard status on or off
466          *
467          * When safeguard is true, all the non-owner functions are unavailable.
468          * When safeguard is false, all the functions will resume!
469          */
470         function changeSafeguardStatus() onlyOwner public{
471             if (safeguard == false){
472                 safeguard = true;
473             }
474             else{
475                 safeguard = false;    
476             }
477         }
478         
479         
480         /********************************/
481         /* Code for the Air drop of S7N */
482         /********************************/
483         
484         /**
485          * Run an Air-Drop
486          *
487          * It requires an array of all the addresses and amount of tokens to distribute
488          * It will only process first 150 recipients. That limit is fixed to prevent gas limit
489          */
490         function airdrop(address[] memory recipients,uint tokenAmount) public onlyOwner {
491             uint256 addressCount = recipients.length;
492             require(addressCount <= 150);
493             for(uint i = 0; i < addressCount; i++)
494             {
495                 
496                   _transfer(address(this), recipients[i], tokenAmount.mul(1 ether));
497             }
498         }
499 }