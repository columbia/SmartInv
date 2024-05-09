1 pragma solidity ^0.4.23;
2 
3 contract ERC20Interface {
4     function totalSupply() public view returns (uint);
5     function balanceOf(address _owner) public view returns (uint balance);
6     function transfer(address _to, uint _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
8     function approve(address _spender, uint _value) public returns (bool success);
9     function allowance(address _owner, address _spender) public view returns (uint remaining);
10     event Transfer(address indexed _from, address indexed _to, uint _value);
11     event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 /**
15  * @title Ownable
16  * The Ownable contract has an owner address, and provides basic authorization control
17  * functions, this simplifies the implementation of "user permissions".
18  */
19 contract Ownable {
20     address public owner;
21 
22     // The Ownable constructor sets the original `owner` 
23     // of the contract to the sender account.
24     constructor()  public {
25         owner = msg.sender;
26     } 
27 
28     // Throw if called by any account other than the current owner
29     modifier onlyOwner {
30         require(msg.sender == owner);
31         _;
32     }
33 
34     // Allow the current owner to transfer control of the contract to a newOwner
35     function transferOwnership(address newOwner) public onlyOwner {
36         require(newOwner != address(0));
37         owner = newOwner;
38     }
39 }
40 
41 contract RAcoinToken is Ownable, ERC20Interface {
42     string public constant symbol = "RAC";
43     string public constant name = "RAcoinToken";
44     uint private _totalSupply;
45     uint public constant decimals = 18;
46     uint private unmintedTokens = 20000000000*uint(10)**decimals; 
47     
48     event Approval(address indexed owner, address indexed spender, uint value);
49     event Transfer(address indexed from, address indexed to, uint value);
50     
51     //Struct to hold lockup records
52     struct LockupRecord {
53         uint amount;
54         uint unlockTime;
55     }
56     
57     // Balances for each account
58     mapping(address => uint) balances;
59     
60     // Owner of account approves the transfer of an amount to another account
61     mapping(address => mapping (address => uint)) allowed; 
62     
63     // Balances for lockup accounts
64     mapping(address => LockupRecord)balancesLockup;
65 
66 
67 
68     /**
69      ====== JACKPOT IMPLEMENTATION ====== 
70      */
71 
72     // Percentage for jackpot reserving during tokens transfer, 1% is default
73     uint public reservingPercentage = 100;
74     
75     // Minimum allowed variable percentage for jackpot reserving during tokens transfer, 0.01% is default
76     uint public minAllowedReservingPercentage = 1;
77     
78     // Maximu, allowed variable percentage for jackpot reserving during tokens transfer, 10% is default
79     uint public maxAllowedReservingPercentage = 1000;
80     
81     // Minimum amount of jackpot, before reaching it jackpot cannot be distributed. 
82     // Default value is 100,000 RAC
83     uint public jackpotMinimumAmount = 100000 * uint(10)**decimals; 
84     
85     // reservingStep is used for calculating how many times a user will be added to jackpot participants list:
86     // times user will be added to jackpotParticipants list = transfer amount / reservingStep
87     // the more user transfer tokens using transferWithReserving function the more times he will be added and, 
88     // as a result, more chances to win the jackpot. Default value is 10,000 RAC
89     uint public reservingStep = 10000 * uint(10)**decimals; 
90     
91     // The seed is used each time Jackpot is distributing for generating a random number.
92     // First seed has some value, after the every turn of the jackpot distribution will be changed 
93     uint private seed = 1; // Default seed 
94     
95     // The maximum allowed times when jackpot amount and distribution time will be set by owner,
96     // Used only for token sale jackpot distribution 
97     int public maxAllowedManualDistribution = 111; 
98 
99     // Either or not clear the jackpot participants list after the Jackpot distribution
100     bool public clearJackpotParticipantsAfterDistribution = false;
101 
102     // Variable that holds last actual index of jackpotParticipants collection
103     uint private index = 0; 
104 
105     // The list with Jackpot participants. The more times address is in the list, the more chances to win the Jackpot
106     address[] private jackpotParticipants; 
107 
108     event SetReservingPercentage(uint _value);
109     event SetMinAllowedReservingPercentage(uint _value);
110     event SetMaxAllowedReservingPercentage(uint _value);
111     event SetReservingStep(uint _value);
112     event SetJackpotMinimumAmount(uint _value);
113     event AddAddressToJackpotParticipants(address indexed _sender, uint _times);
114     
115     //Setting the reservingPercentage value, allowed only for owner
116     function setReservingPercentage(uint _value) public onlyOwner returns (bool success) {
117         assert(_value > 0 && _value < 10000);
118         
119         reservingPercentage = _value;
120         emit SetReservingPercentage(_value);
121         return true;
122     }
123     
124     //Setting the minAllowedReservingPercentage value, allowed only for owner
125     function setMinAllowedReservingPercentage(uint _value) public onlyOwner returns (bool success) {
126         assert(_value > 0 && _value < 10000);
127         
128         minAllowedReservingPercentage = _value;
129         emit SetMinAllowedReservingPercentage(_value);
130         return true;
131     }
132     
133     //Setting the maxAllowedReservingPercentage value, allowed only for owner
134     function setMaxAllowedReservingPercentage(uint _value) public onlyOwner returns (bool success) {
135         assert(_value > 0 && _value < 10000);
136         
137         minAllowedReservingPercentage = _value;
138         emit SetMaxAllowedReservingPercentage(_value);
139         return true;
140     }
141     
142     //Setting the reservingStep value, allowed only for owner
143     function setReservingStep(uint _value) public onlyOwner returns (bool success) {
144         assert(_value > 0);
145         reservingStep = _value;
146         emit SetReservingStep(_value);
147         return true;
148     }
149     
150     //Setting the setJackpotMinimumAmount value, allowed only for owner
151     function setJackpotMinimumAmount(uint _value) public onlyOwner returns (bool success) {
152         jackpotMinimumAmount = _value;
153         emit SetJackpotMinimumAmount(_value);
154         return true;
155     }
156 
157     //Setting the clearJackpotParticipantsAfterDistribution value, allowed only for owner
158     function setPoliticsForJackpotParticipantsList(bool _clearAfterDistribution) public onlyOwner returns (bool success) {
159         clearJackpotParticipantsAfterDistribution = _clearAfterDistribution;
160         return true;
161     }
162     
163     // Empty the jackpot participants list
164     function clearJackpotParticipants() public onlyOwner returns (bool success) {
165         index = 0;
166         return true;
167     }
168     
169     // Using this function a user transfers tokens and participates in operating jackpot 
170     // User sets the total transfer amount that includes the Jackpot reserving deposit
171     function transferWithReserving(address _to, uint _totalTransfer) public returns (bool success) {
172         uint netTransfer = _totalTransfer * (10000 - reservingPercentage) / 10000; 
173         require(balances[msg.sender] >= _totalTransfer && (_totalTransfer > netTransfer));
174         
175         if (transferMain(msg.sender, _to, netTransfer) && (_totalTransfer >= reservingStep)) {
176             processJackpotDeposit(_totalTransfer, netTransfer, msg.sender);
177         }
178         return true;
179     }
180 
181     // Using this function a user transfers tokens and participates in operating jackpot 
182     // User sets the net value of transfer without the Jackpot reserving deposit amount 
183     function transferWithReservingNet(address _to, uint _netTransfer) public returns (bool success) {
184         uint totalTransfer = _netTransfer * (10000 + reservingPercentage) / 10000; 
185         require(balances[msg.sender] >= totalTransfer && (totalTransfer > _netTransfer));
186         
187         if (transferMain(msg.sender, _to, _netTransfer) && (totalTransfer >= reservingStep)) {
188             processJackpotDeposit(totalTransfer, _netTransfer, msg.sender);
189         }
190         return true;
191     }
192     
193     // Using this function a user transfers tokens and participates in operating jackpot 
194     // User sets the total transfer amount that includes the Jackpot reserving deposit and custom reserving percentage
195     function transferWithCustomReserving(address _to, uint _totalTransfer, uint _customReservingPercentage) public returns (bool success) {
196         require(_customReservingPercentage > minAllowedReservingPercentage && _customReservingPercentage < maxAllowedReservingPercentage);
197         uint netTransfer = _totalTransfer * (10000 - _customReservingPercentage) / 10000; 
198         require(balances[msg.sender] >= _totalTransfer && (_totalTransfer > netTransfer));
199         
200         if (transferMain(msg.sender, _to, netTransfer) && (_totalTransfer >= reservingStep)) {
201             processJackpotDeposit(_totalTransfer, netTransfer, msg.sender);
202         }
203         return true;
204     }
205     
206     // Using this function a user transfers tokens and participates in operating jackpot 
207     // User sets the net value of transfer without the Jackpot reserving deposit amount and custom reserving percentage
208     function transferWithCustomReservingNet(address _to, uint _netTransfer, uint _customReservingPercentage) public returns (bool success) {
209         require(_customReservingPercentage > minAllowedReservingPercentage && _customReservingPercentage < maxAllowedReservingPercentage);
210         uint totalTransfer = _netTransfer * (10000 + _customReservingPercentage) / 10000; 
211         require(balances[msg.sender] >= totalTransfer && (totalTransfer > _netTransfer));
212         
213         if (transferMain(msg.sender, _to, _netTransfer) && (totalTransfer >= reservingStep)) {
214             processJackpotDeposit(totalTransfer, _netTransfer, msg.sender);
215         }
216         return true;
217     }
218 
219     // Using this function a spender transfers tokens and make an owner of funds a participant of the operating Jackpot 
220     // User sets the total transfer amount that includes the Jackpot reserving deposit
221     function transferFromWithReserving(address _from, address _to, uint _totalTransfer) public returns (bool success) {
222         uint netTransfer = _totalTransfer * (10000 - reservingPercentage) / 10000; 
223         require(balances[_from] >= _totalTransfer && (_totalTransfer > netTransfer));
224         
225         if (transferFrom(_from, _to, netTransfer) && (_totalTransfer >= reservingStep)) {
226             processJackpotDeposit(_totalTransfer, netTransfer, _from);
227         }
228         return true;
229     }
230 
231     // Using this function a spender transfers tokens and make an owner of funds a participatants of the operating Jackpot 
232     // User set the net value of transfer without the Jackpot reserving deposit amount 
233     function transferFromWithReservingNet(address _from, address _to, uint _netTransfer) public returns (bool success) {
234         uint totalTransfer = _netTransfer * (10000 + reservingPercentage) / 10000; 
235         require(balances[_from] >= totalTransfer && (totalTransfer > _netTransfer));
236 
237         if (transferFrom(_from, _to, _netTransfer) && (totalTransfer >= reservingStep)) {
238             processJackpotDeposit(totalTransfer, _netTransfer, _from);
239         }
240         return true;
241     }
242 
243 
244     // Using this function a spender transfers tokens and make an owner of funds a participant of the operating Jackpot 
245     // User sets the total transfer amount that includes the Jackpot reserving deposit
246     function transferFromWithCustomReserving(address _from, address _to, uint _totalTransfer, uint _customReservingPercentage) public returns (bool success) {
247         require(_customReservingPercentage > minAllowedReservingPercentage && _customReservingPercentage < maxAllowedReservingPercentage);
248         uint netTransfer = _totalTransfer * (10000 - _customReservingPercentage) / 10000; 
249         require(balances[_from] >= _totalTransfer && (_totalTransfer > netTransfer));
250         
251         if (transferFrom(_from, _to, netTransfer) && (_totalTransfer >= reservingStep)) {
252             processJackpotDeposit(_totalTransfer, netTransfer, _from);
253         }
254         return true;
255     }
256 
257     // Using this function a spender transfers tokens and make an owner of funds a participatants of the operating Jackpot 
258     // User set the net value of transfer without the Jackpot reserving deposit amount and custom reserving percentage
259     function transferFromWithCustomReservingNet(address _from, address _to, uint _netTransfer, uint _customReservingPercentage) public returns (bool success) {
260         require(_customReservingPercentage > minAllowedReservingPercentage && _customReservingPercentage < maxAllowedReservingPercentage);
261         uint totalTransfer = _netTransfer * (10000 + _customReservingPercentage) / 10000; 
262         require(balances[_from] >= totalTransfer && (totalTransfer > _netTransfer));
263 
264         if (transferFrom(_from, _to, _netTransfer) && (totalTransfer >= reservingStep)) {
265             processJackpotDeposit(totalTransfer, _netTransfer, _from);
266         }
267         return true;
268     }
269     
270     // Withdraw deposit of Jackpot amount and add address to Jackpot Participants List according to transaction amount
271     function processJackpotDeposit(uint _totalTransfer, uint _netTransfer, address _participant) private returns (bool success) {
272         addAddressToJackpotParticipants(_participant, _totalTransfer);
273 
274         uint jackpotDeposit = _totalTransfer - _netTransfer;
275         balances[_participant] -= jackpotDeposit;
276         balances[0] += jackpotDeposit;
277 
278         emit Transfer(_participant, 0, jackpotDeposit);
279         return true;
280     }
281 
282     // Add address to Jackpot Participants List
283     function addAddressToJackpotParticipants(address _participant, uint _transactionAmount) private returns (bool success) {
284         uint timesToAdd = _transactionAmount / reservingStep;
285         
286         for (uint i = 0; i < timesToAdd; i++){
287             if(index == jackpotParticipants.length) {
288                 jackpotParticipants.length += 1;
289             }
290             jackpotParticipants[index++] = _participant;
291         }
292 
293         emit AddAddressToJackpotParticipants(_participant, timesToAdd);
294         return true;        
295     }
296     
297     // Distribute jackpot. For finding a winner we use random number that is produced by multiplying a previous seed  
298     // received from previous jackpot distribution and casted to uint last available block hash. 
299     // Remainder from the received random number and total number of participants will give an index of a winner in the Jackpot participants list
300     function distributeJackpot(uint _nextSeed) public onlyOwner returns (bool success) {
301         assert(balances[0] >= jackpotMinimumAmount);
302         assert(_nextSeed > 0);
303 
304         uint additionalSeed = uint(blockhash(block.number - 1));
305         uint rnd = 0;
306         
307         while(rnd < index) {
308             rnd += additionalSeed * seed;
309         }
310         
311         uint winner = rnd % index;
312         balances[jackpotParticipants[winner]] += balances[0];
313         emit Transfer(0, jackpotParticipants[winner], balances[0]);
314         balances[0] = 0;
315         seed = _nextSeed;
316 
317         if (clearJackpotParticipantsAfterDistribution) {
318             clearJackpotParticipants();
319         }
320         return true;
321     }
322 
323     // Distribute Token Sale Jackpot by minting token sale jackpot directly to 0x0 address and calling distributeJackpot function 
324     function distributeTokenSaleJackpot(uint _nextSeed, uint _amount) public onlyOwner returns (bool success) {
325         require (maxAllowedManualDistribution > 0);
326         if (mintTokens(0, _amount) && distributeJackpot(_nextSeed)) {
327             maxAllowedManualDistribution--;
328         }
329         return true;
330     }
331 
332 
333 
334     /** 
335      ====== ERC20 IMPLEMENTATION ====== 
336      */
337     
338     // Return total supply of tokens including locked-up funds and current Jackpot deposit
339     function totalSupply() public view returns (uint) {
340         return _totalSupply;
341     }
342 
343     // Get the balance of the specified address
344     function balanceOf(address _owner) public view returns (uint balance) {
345         return balances[_owner];
346     }
347 
348     // Transfer token to a specified address   
349     function transfer(address _to, uint _value) public returns (bool success) {
350         require(balances[msg.sender] >= _value);
351         return transferMain(msg.sender, _to, _value);
352     }
353 
354     // Transfer tokens from one address to another 
355     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
356         require(balances[_from] >= _value);
357         require(allowed[_from][msg.sender] >= _value);
358 
359         if (transferMain(_from, _to, _value)){
360             allowed[_from][msg.sender] -= _value;
361             return true;
362         } else {
363             return false;
364         }
365     }
366 
367     // Main transfer function. Checking of balances is made in calling function
368     function transferMain(address _from, address _to, uint _value) private returns (bool success) {
369         require(_to != address(0));
370         assert(balances[_to] + _value >= balances[_to]);
371         
372         balances[_from] -= _value;
373         balances[_to] += _value;
374         emit Transfer(_from, _to, _value);
375         return true;
376     }
377 
378     // Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
379     function approve(address _spender, uint _value) public returns (bool success) {
380         allowed[msg.sender][_spender] = _value;
381         emit Approval(msg.sender, _spender, _value);
382         return true;
383     }
384 
385     // Function to check the amount of tokens than an owner allowed to a spender
386     function allowance(address _owner, address _spender) public view returns (uint remaining) {
387         return allowed[_owner][_spender];
388     }
389     
390 
391 
392     /**
393      ====== LOCK-UP IMPLEMENTATION ====== 
394      */
395 
396     function unlockOwnFunds() public returns (bool success) {
397         return unlockFunds(msg.sender);
398     }
399 
400     function unlockSupervisedFunds(address _from) public onlyOwner returns (bool success) {
401         return unlockFunds(_from);
402     }
403     
404     function unlockFunds(address _owner) private returns (bool success) {
405         require(balancesLockup[_owner].unlockTime < now && balancesLockup[_owner].amount > 0);
406 
407         balances[_owner] += balancesLockup[_owner].amount;
408         emit Transfer(_owner, _owner, balancesLockup[_owner].amount);
409         balancesLockup[_owner].amount = 0;
410 
411         return true;
412     }
413 
414     function balanceOfLockup(address _owner) public view returns (uint balance, uint unlockTime) {
415         return (balancesLockup[_owner].amount, balancesLockup[_owner].unlockTime);
416     }
417 
418 
419 
420     /**
421      ====== TOKENS MINTING IMPLEMENTATION ====== 
422      */
423 
424     // Mint RAcoin tokens. No more than 20,000,000,000 RAC can be minted
425     function mintTokens(address _target, uint _mintedAmount) public onlyOwner returns (bool success) {
426         require(_mintedAmount <= unmintedTokens);
427         balances[_target] += _mintedAmount;
428         unmintedTokens -= _mintedAmount;
429         _totalSupply += _mintedAmount;
430         
431         emit Transfer(1, _target, _mintedAmount); 
432         return true;
433     }
434 
435     // Mint RAcoin locked-up tokens
436     // Using different types of minting functions has no effect on total limit of 20,000,000,000 RAC that can be created
437     function mintLockupTokens(address _target, uint _mintedAmount, uint _unlockTime) public onlyOwner returns (bool success) {
438         require(_mintedAmount <= unmintedTokens);
439 
440         balancesLockup[_target].amount += _mintedAmount;
441         balancesLockup[_target].unlockTime = _unlockTime;
442         unmintedTokens -= _mintedAmount;
443         _totalSupply += _mintedAmount;
444         
445         emit Transfer(1, _target, _mintedAmount); //TODO
446         return true;
447     }
448 
449     // Mint RAcoin tokens for token sale participants and add them to Jackpot list
450     // Using different types of minting functions has no effect on total limit of 20,000,000,000 RAC that can be created
451     function mintTokensWithIncludingInJackpot(address _target, uint _mintedAmount) public onlyOwner returns (bool success) {
452         require(maxAllowedManualDistribution > 0);
453         if (mintTokens(_target, _mintedAmount)) {
454             addAddressToJackpotParticipants(_target, _mintedAmount);
455         }
456         return true;
457     }
458 
459     // Mint RAcoin tokens and approve the passed address to spend the minted amount of tokens
460     // Using different types of minting functions has no effect on total limit of 20,000,000,000 RAC that can be created
461     function mintTokensWithApproval(address _target, uint _mintedAmount, address _spender) public onlyOwner returns (bool success) {
462         require(_mintedAmount <= unmintedTokens);
463         balances[_target] += _mintedAmount;
464         unmintedTokens -= _mintedAmount;
465         _totalSupply += _mintedAmount;
466         allowed[_target][_spender] += _mintedAmount;
467         
468         emit Transfer(1, _target, _mintedAmount);
469         return true;
470     }
471 
472     // After firing this function no more tokens can be created  
473     function stopTokenMinting() public onlyOwner returns (bool success) {
474         unmintedTokens = 0;
475         return true;
476     }
477 }