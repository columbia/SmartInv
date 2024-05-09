1 pragma solidity ^ 0.4 .11;
2 
3 contract SafeMath {
4     function safeMul(uint a, uint b) internal returns(uint) {
5         uint c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function safeDiv(uint a, uint b) internal returns(uint) {
11         assert(b > 0);
12         uint c = a / b;
13         assert(a == b * c + a % b);
14         return c;
15     }
16 
17     function safeSub(uint a, uint b) internal returns(uint) {
18         assert(b <= a);
19         return a - b;
20     }
21     
22     function safeAdd(uint a, uint b) internal returns(uint) {
23         uint c = a + b;
24         assert(c >= a && c >= b);
25         return c;
26     }
27 
28 }
29 
30 contract ERC20 {
31     uint public totalSupply;
32 
33     function balanceOf(address who) constant returns(uint);
34 
35     function allowance(address owner, address spender) constant returns(uint);
36 
37     function transfer(address to, uint value) returns(bool ok);
38 
39     function transferFrom(address from, address to, uint value) returns(bool ok);
40 
41     function approve(address spender, uint value) returns(bool ok);
42 
43     event Transfer(address indexed from, address indexed to, uint value);
44     event Approval(address indexed owner, address indexed spender, uint value);
45 }
46 
47 
48 contract Ownable {
49     address public owner;
50 
51     function Ownable() {
52         owner = msg.sender;
53     }
54 
55     function transferOwnership(address newOwner) onlyOwner {
56         if (newOwner != address(0)) owner = newOwner;
57     }
58 
59     function kill() {
60         if (msg.sender == owner) selfdestruct(owner);
61     }
62 
63     modifier onlyOwner() {
64         if (msg.sender == owner)
65         _;
66     }
67 }
68 
69 contract Pausable is Ownable {
70     bool public stopped;
71 
72     modifier stopInEmergency {
73         if (stopped) {
74             revert();
75         }
76         _;
77     }
78 
79     modifier onlyInEmergency {
80         if (!stopped) {
81             revert();
82         }
83         _;
84     }
85 
86     // Called by the owner in emergency, triggers stopped state
87     function emergencyStop() external onlyOwner {
88         stopped = true;
89     }
90 
91     // Called by the owner to end of emergency, returns to normal state
92     function release() external onlyOwner onlyInEmergency {
93         stopped = false;
94     }
95 }
96 
97 
98 
99 // Base contract supporting async send for pull payments.
100 // Inherit from this contract and use asyncSend instead of send.
101 contract PullPayment {
102     mapping(address => uint) public payments;
103 
104     event RefundETH(address to, uint value);
105 
106     // Store sent amount as credit to be pulled, called by payer
107     function asyncSend(address dest, uint amount) internal {
108         payments[dest] += amount;
109     }
110     
111     // Withdraw accumulated balance, called by payee
112     function withdrawPayments() internal returns (bool) {
113         address payee = msg.sender;
114         uint payment = payments[payee];
115 
116         if (payment == 0) {
117             revert();
118         }
119 
120         if (this.balance < payment) {
121             revert();
122         }
123 
124         payments[payee] = 0;
125 
126         if (!payee.send(payment)) {
127             revert();
128         }
129         RefundETH(payee, payment);
130         return true;
131     }
132 }
133 
134 
135 // Crowdsale Smart Contract
136 // This smart contract collects ETH and in return sends GXC tokens to the Backers
137 contract Crowdsale is SafeMath, Pausable, PullPayment {
138 
139     struct Backer {
140         uint weiReceived; // amount of ETH contributed
141         uint GXCSent; // amount of tokens  sent        
142     }
143 
144     GXC public gxc; // DMINI contract reference   
145     address public multisigETH; // Multisig contract that will receive the ETH    
146     address public team; // Address at which the team GXC will be sent   
147     uint public ETHReceived; // Number of ETH received
148     uint public GXCSentToETH; // Number of GXC sent to ETH contributors
149     uint public startBlock; // Crowdsale start block
150     uint public endBlock; // Crowdsale end block
151     uint public maxCap; // Maximum number of GXC to sell
152     uint public minCap; // Minimum number of ETH to raise
153     uint public minInvestETH; // Minimum amount to invest
154     bool public crowdsaleClosed; // Is crowdsale still on going
155     uint public tokenPriceWei;
156     uint GXCReservedForPresale ;  
157     
158 
159     
160     uint multiplier = 10000000000; // to provide 10 decimal values
161     // Looping through Backer
162     mapping(address => Backer) public backers; //backer list
163     address[] public backersIndex ;   // to be able to itarate through backers when distributing the tokens. 
164 
165 
166     // @notice to verify if action is not performed out of the campaing range
167     modifier respectTimeFrame() {
168         if ((block.number < startBlock) || (block.number > endBlock)) revert();
169         _;
170     }
171 
172     modifier minCapNotReached() {
173         if (GXCSentToETH >= minCap) revert();
174         _;
175     }
176 
177     // Events
178     event ReceivedETH(address backer, uint amount, uint tokenAmount);
179 
180     // Crowdsale  {constructor}
181     // @notice fired when contract is crated. Initilizes all constnat variables.
182     function Crowdsale() {
183     
184         multisigETH = 0x62739Ec09cdD8FAe2f7b976f8C11DbE338DF8750; 
185         team = 0x62739Ec09cdD8FAe2f7b976f8C11DbE338DF8750;                    
186         GXCSentToETH = 487000 * multiplier;               
187         minInvestETH = 100000000000000000 ; // 0.1 eth
188         startBlock = 0; // ICO start block
189         endBlock = 0; // ICO end block            
190         maxCap = 8250000 * multiplier;
191         // Price is 0.001 eth                         
192         tokenPriceWei = 3004447000000000;
193                         
194         minCap = 500000 * multiplier;
195     }
196 
197     // @notice Specify address of token contract
198     // @param _GXCAddress {address} address of GXC token contrac
199     // @return res {bool}
200     function updateTokenAddress(GXC _GXCAddress) public onlyOwner() returns(bool res) {
201         gxc = _GXCAddress;  
202         return true;    
203     }
204 
205     // @notice modify this address should this be needed. 
206     function updateTeamAddress(address _teamAddress) public onlyOwner returns(bool){
207         team = _teamAddress;
208         return true; 
209     }
210 
211     // @notice return number of contributors
212     // @return  {uint} number of contributors
213     function numberOfBackers()constant returns (uint){
214         return backersIndex.length;
215     }
216 
217     // {fallback function}
218     // @notice It will call internal function which handels allocation of Ether and calculates GXC tokens.
219     function () payable {         
220         handleETH(msg.sender);
221     }
222 
223     // @notice It will be called by owner to start the sale   
224     function start(uint _block) onlyOwner() {
225         startBlock = block.number;
226         endBlock = startBlock + _block; //TODO: Replace _block with 40320 for 7 days
227         // 1 week in blocks = 40320 (4 * 60 * 24 * 7)
228         // enable this for live assuming each bloc takes 15 sec .
229         crowdsaleClosed = false;
230     }
231 
232     // @notice It will be called by fallback function whenever ether is sent to it
233     // @param  _backer {address} address of beneficiary
234     // @return res {bool} true if transaction was successful
235     function handleETH(address _backer) internal stopInEmergency respectTimeFrame returns(bool res) {
236 
237         if (msg.value < minInvestETH) revert(); // stop when required minimum is not sent
238 
239         uint GXCToSend = (msg.value * multiplier)/ tokenPriceWei ; // calculate number of tokens
240 
241         // Ensure that max cap hasn't been reached
242         if (safeAdd(GXCSentToETH, GXCToSend) > maxCap) revert();
243 
244         Backer storage backer = backers[_backer];
245 
246          if ( backer.weiReceived  == 0)
247              backersIndex.push(_backer);
248 
249         if (!gxc.transfer(_backer, GXCToSend)) revert(); // Transfer GXC tokens
250         backer.GXCSent = safeAdd(backer.GXCSent, GXCToSend);
251         backer.weiReceived = safeAdd(backer.weiReceived, msg.value);
252         ETHReceived = safeAdd(ETHReceived, msg.value); // Update the total Ether recived
253         GXCSentToETH = safeAdd(GXCSentToETH, GXCToSend);
254         ReceivedETH(_backer, msg.value, GXCToSend); // Register event
255         return true;
256     }
257 
258 
259     // @notice This function will finalize the sale.
260     // It will only execute if predetermined sale time passed or all tokens are sold.
261     function finalize() onlyOwner() {
262 
263         if (crowdsaleClosed) revert();
264         
265         uint daysToRefund = 4*60*24*10;  //10 days        
266 
267         if (block.number < endBlock && GXCSentToETH < maxCap -100 ) revert();  // -100 is used to allow closing of the campaing when contribution is near 
268                                                                                  // finished as exact amount of maxCap might be not feasible e.g. you can't easily buy few tokens. 
269                                                                                  // when min contribution is 0.1 Eth.  
270 
271         if (GXCSentToETH < minCap && block.number < safeAdd(endBlock , daysToRefund)) revert();   
272 
273        
274         if (GXCSentToETH > minCap) {
275             if (!multisigETH.send(this.balance)) revert();  // transfer balance to multisig wallet
276             if (!gxc.transfer(team,  gxc.balanceOf(this))) revert(); // transfer tokens to admin account or multisig wallet                                
277             gxc.unlock();    // release lock from transfering tokens. 
278         }
279         else{
280             if (!gxc.burn(this, gxc.balanceOf(this))) revert();  // burn all the tokens remaining in the contract                       
281         }
282 
283         crowdsaleClosed = true;
284         
285     }
286 
287  
288 
289   
290     // @notice Failsafe drain
291     function drain() onlyOwner(){
292         if (!owner.send(this.balance)) revert();
293     }
294 
295     // @notice Failsafe transfer tokens for the team to given account 
296     function transferDevTokens(address _devAddress) onlyOwner returns(bool){
297         if (!gxc.transfer(_devAddress,  gxc.balanceOf(this))) 
298             revert(); 
299         return true;
300 
301     }    
302 
303 
304     // @notice Prepare refund of the backer if minimum is not reached
305     // burn the tokens
306     function prepareRefund()  minCapNotReached internal returns (bool){
307         uint value = backers[msg.sender].GXCSent;
308 
309         if (value == 0) revert();           
310         if (!gxc.burn(msg.sender, value)) revert();
311         uint ETHToSend = backers[msg.sender].weiReceived;
312         backers[msg.sender].weiReceived = 0;
313         backers[msg.sender].GXCSent = 0;
314         if (ETHToSend > 0) {
315             asyncSend(msg.sender, ETHToSend);
316             return true;
317         }else
318             return false;
319         
320     }
321 
322     // @notice refund the backer
323     function refund() public returns (bool){
324 
325         if (!prepareRefund()) revert();
326         if (!withdrawPayments()) revert();
327         return true;
328 
329     }
330 
331  
332 }
333 
334 // The GXC token
335 contract GXC is ERC20, SafeMath, Ownable {
336     // Public variables of the token
337     string public name;
338     string public symbol;
339     uint8 public decimals; // How many decimals to show.
340     string public version = 'v0.1';
341     uint public initialSupply;
342     uint public totalSupply;
343     bool public locked;
344     address public crowdSaleAddress;
345     uint multiplier = 10000000000;        
346     
347     uint256 public totalMigrated;
348 
349     mapping(address => uint) balances;
350     mapping(address => mapping(address => uint)) allowed;
351     
352 
353     // Lock transfer during the ICO
354     modifier onlyUnlocked() {
355         if (msg.sender != crowdSaleAddress && locked && msg.sender != owner) revert();
356         _;
357     }
358 
359     modifier onlyAuthorized() {
360         if ( msg.sender != crowdSaleAddress && msg.sender != owner) revert();
361         _;
362     }
363 
364     // The GXC Token constructor
365     function GXC(address _crowdSaleAddress) {        
366         locked = true;  // Lock the transfer of tokens during the crowdsale
367         initialSupply = 10000000 * multiplier;
368         totalSupply = initialSupply;
369         name = 'GXC'; // Set the name for display purposes
370         symbol = 'GXC'; // Set the symbol for display purposes
371         decimals = 10; // Amount of decimals for display purposes
372         crowdSaleAddress = _crowdSaleAddress;               
373         balances[crowdSaleAddress] = totalSupply;       
374     }
375 
376 
377     function restCrowdSaleAddress(address _newCrowdSaleAddress) onlyAuthorized() {
378             crowdSaleAddress = _newCrowdSaleAddress;
379     }
380 
381     
382 
383     function unlock() onlyAuthorized {
384         locked = false;
385     }
386 
387       function lock() onlyAuthorized {
388         locked = true;
389     }
390 
391     function burn( address _member, uint256 _value) onlyAuthorized returns(bool) {
392         balances[_member] = safeSub(balances[_member], _value);
393         totalSupply = safeSub(totalSupply, _value);
394         Transfer(_member, 0x0, _value);
395         return true;
396     }
397 
398     function transfer(address _to, uint _value) onlyUnlocked returns(bool) {
399         balances[msg.sender] = safeSub(balances[msg.sender], _value);
400         balances[_to] = safeAdd(balances[_to], _value);
401         Transfer(msg.sender, _to, _value);
402         return true;
403     }
404 
405     /* A contract attempts to get the coins */
406     function transferFrom(address _from, address _to, uint256 _value) onlyUnlocked returns(bool success) {
407         if (balances[_from] < _value) revert(); // Check if the sender has enough
408         if (_value > allowed[_from][msg.sender]) revert(); // Check allowance
409         balances[_from] = safeSub(balances[_from], _value); // Subtract from the sender
410         balances[_to] = safeAdd(balances[_to], _value); // Add the same to the recipient
411         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
412         Transfer(_from, _to, _value);
413         return true;
414     }
415 
416     function balanceOf(address _owner) constant returns(uint balance) {
417         return balances[_owner];
418     }
419 
420     function approve(address _spender, uint _value) returns(bool) {
421         allowed[msg.sender][_spender] = _value;
422         Approval(msg.sender, _spender, _value);
423         return true;
424     }
425 
426 
427     function allowance(address _owner, address _spender) constant returns(uint remaining) {
428         return allowed[_owner][_spender];
429     }
430 }