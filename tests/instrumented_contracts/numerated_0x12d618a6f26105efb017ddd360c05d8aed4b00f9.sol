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
72     // Percentage for jackpot reserving during tokens transfer
73     uint public reservingPercentage = 1;
74     
75     // Minimum amount of jackpot, before reaching it jackpot cannot be distributed. 
76     // Default value is 100,000 RAC
77     uint public jackpotMinimumAmount = 100000 * uint(10)**decimals; 
78     
79     // reservingStep is used for calculating how many times a user will be added to jackpot participants list:
80     // times user will be added to jackpotParticipants list = transfer amount / reservingStep
81     // the more user transfer tokens using transferWithReserving function the more times he will be added and, 
82     // as a result, more chances to win the jackpot. Default value is 10,000 RAC
83     uint public reservingStep = 10000 * uint(10)**decimals; 
84     
85     // The seed is used each time Jackpot is distributing for generating a random number.
86     // First seed has some value, after the every turn of the jackpot distribution will be changed 
87     uint private seed = 1; // Default seed 
88     
89     // The maximum allowed times when jackpot amount and distribution time will be set by owner,
90     // Used only for token sale jackpot distribution 
91     int public maxAllowedManualDistribution = 111; 
92 
93     // Either or not clear the jackpot participants list after the Jackpot distribution
94     bool public clearJackpotParticipantsAfterDistribution = false;
95 
96     // Variable that holds last actual index of jackpotParticipants collection
97     uint private index = 0; 
98 
99     // The list with Jackpot participants. The more times address is in the list, the more chances to win the Jackpot
100     address[] private jackpotParticipants; 
101 
102     event SetReservingPercentage(uint _value);
103     event SetReservingStep(uint _value);
104     event SetJackpotMinimumAmount(uint _value);
105     event AddAddressToJackpotParticipants(address indexed _sender, uint _times);
106     
107     //Setting the reservingPercentage value, allowed only for owner
108     function setReservingPercentage(uint _value) public onlyOwner returns (bool success) {
109         assert(_value > 0 && _value < 100);
110         
111         reservingPercentage = _value;
112         emit SetReservingPercentage(_value);
113         return true;
114     }
115     
116     //Setting the reservingStep value, allowed only for owner
117     function setReservingStep(uint _value) public onlyOwner returns (bool success) {
118         assert(_value > 0);
119         reservingStep = _value;
120         emit SetReservingStep(_value);
121         return true;
122     }
123     
124     //Setting the setJackpotMinimumAmount value, allowed only for owner
125     function setJackpotMinimumAmount(uint _value) public onlyOwner returns (bool success) {
126         jackpotMinimumAmount = _value;
127         emit SetJackpotMinimumAmount(_value);
128         return true;
129     }
130 
131     //Setting the clearJackpotParticipantsAfterDistribution value, allowed only for owner
132     function setPoliticsForJackpotParticipantsList(bool _clearAfterDistribution) public onlyOwner returns (bool success) {
133         clearJackpotParticipantsAfterDistribution = _clearAfterDistribution;
134         return true;
135     }
136     
137     // Empty the jackpot participants list
138     function clearJackpotParticipants() public onlyOwner returns (bool success) {
139         index = 0;
140         return true;
141     }
142     
143     // Using this function a user transfers tokens and participates in operating jackpot 
144     // User sets the total transfer amount that includes the Jackpot reserving deposit
145     function transferWithReserving(address _to, uint _totalTransfer) public returns (bool success) {
146         uint netTransfer = _totalTransfer * (100 - reservingPercentage) / 100; 
147         require(balances[msg.sender] >= _totalTransfer && (_totalTransfer > netTransfer));
148         
149         if (transferMain(msg.sender, _to, netTransfer) && (_totalTransfer >= reservingStep)) {
150             processJackpotDeposit(_totalTransfer, netTransfer, msg.sender);
151         }
152         return true;
153     }
154 
155     // Using this function a user transfers tokens and participates in operating jackpot 
156     // User sets the net value of transfer without the Jackpot reserving deposit amount 
157     function transferWithReservingNet(address _to, uint _netTransfer) public returns (bool success) {
158         uint totalTransfer = _netTransfer * (100 + reservingPercentage) / 100; 
159         require(balances[msg.sender] >= totalTransfer && (totalTransfer > _netTransfer));
160         
161         if (transferMain(msg.sender, _to, _netTransfer) && (totalTransfer >= reservingStep)) {
162             processJackpotDeposit(totalTransfer, _netTransfer, msg.sender);
163         }
164         return true;
165     }
166 
167     // Using this function a spender transfers tokens and make an owner of funds a participant of the operating Jackpot 
168     // User sets the total transfer amount that includes the Jackpot reserving deposit
169     function transferFromWithReserving(address _from, address _to, uint _totalTransfer) public returns (bool success) {
170         uint netTransfer = _totalTransfer * (100 - reservingPercentage) / 100; 
171         require(balances[_from] >= _totalTransfer && (_totalTransfer > netTransfer));
172         
173         if (transferFrom(_from, _to, netTransfer) && (_totalTransfer >= reservingStep)) {
174             processJackpotDeposit(_totalTransfer, netTransfer, _from);
175         }
176         return true;
177     }
178 
179     // Using this function a spender transfers tokens and make an owner of funds a participatants of the operating Jackpot 
180     // User set the net value of transfer without the Jackpot reserving deposit amount 
181     function transferFromWithReservingNet(address _from, address _to, uint _netTransfer) public returns (bool success) {
182         uint totalTransfer = _netTransfer * (100 + reservingPercentage) / 100; 
183         require(balances[_from] >= totalTransfer && (totalTransfer > _netTransfer));
184 
185         if (transferFrom(_from, _to, _netTransfer) && (totalTransfer >= reservingStep)) {
186             processJackpotDeposit(totalTransfer, _netTransfer, _from);
187         }
188         return true;
189     }
190 
191     // Withdraw deposit of Jackpot amount and add address to Jackpot Participants List according to transaction amount
192     function processJackpotDeposit(uint _totalTransfer, uint _netTransfer, address _participant) private returns (bool success) {
193         addAddressToJackpotParticipants(_participant, _totalTransfer);
194 
195         uint jackpotDeposit = _totalTransfer - _netTransfer;
196         balances[_participant] -= jackpotDeposit;
197         balances[0] += jackpotDeposit;
198 
199         emit Transfer(_participant, 0, jackpotDeposit);
200         return true;
201     }
202 
203     // Add address to Jackpot Participants List
204     function addAddressToJackpotParticipants(address _participant, uint _transactionAmount) private returns (bool success) {
205         uint timesToAdd = _transactionAmount / reservingStep;
206         
207         for (uint i = 0; i < timesToAdd; i++){
208             if(index == jackpotParticipants.length) {
209                 jackpotParticipants.length += 1;
210             }
211             jackpotParticipants[index++] = _participant;
212         }
213 
214         emit AddAddressToJackpotParticipants(_participant, timesToAdd);
215         return true;        
216     }
217     
218     // Distribute jackpot. For finding a winner we use random number that is produced by multiplying a previous seed  
219     // received from previous jackpot distribution and casted to uint last available block hash. 
220     // Remainder from the received random number and total number of participants will give an index of a winner in the Jackpot participants list
221     function distributeJackpot(uint _nextSeed) public onlyOwner returns (bool success) {
222         assert(balances[0] >= jackpotMinimumAmount);
223         assert(_nextSeed > 0);
224 
225         uint additionalSeed = uint(blockhash(block.number - 1));
226         uint rnd = 0;
227         
228         while(rnd < index) {
229             rnd += additionalSeed * seed;
230         }
231         
232         uint winner = rnd % index;
233         balances[jackpotParticipants[winner]] += balances[0];
234         emit Transfer(0, jackpotParticipants[winner], balances[0]);
235         balances[0] = 0;
236         seed = _nextSeed;
237 
238         if (clearJackpotParticipantsAfterDistribution) {
239             clearJackpotParticipants();
240         }
241         return true;
242     }
243 
244     // Distribute Token Sale Jackpot by minting token sale jackpot directly to 0x0 address and calling distributeJackpot function 
245     function distributeTokenSaleJackpot(uint _nextSeed, uint _amount) public onlyOwner returns (bool success) {
246         require (maxAllowedManualDistribution > 0);
247         if (mintTokens(0, _amount) && distributeJackpot(_nextSeed)) {
248             maxAllowedManualDistribution--;
249         }
250         return true;
251     }
252 
253 
254 
255     /** 
256      ====== ERC20 IMPLEMENTATION ====== 
257      */
258     
259     // Return total supply of tokens including locked-up funds and current Jackpot deposit
260     function totalSupply() public view returns (uint) {
261         return _totalSupply;
262     }
263 
264     // Get the balance of the specified address
265     function balanceOf(address _owner) public view returns (uint balance) {
266         return balances[_owner];
267     }
268 
269     // Transfer token to a specified address   
270     function transfer(address _to, uint _value) public returns (bool success) {
271         require(balances[msg.sender] >= _value);
272         return transferMain(msg.sender, _to, _value);
273     }
274 
275     // Transfer tokens from one address to another 
276     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
277         require(balances[_from] >= _value);
278         require(allowed[_from][msg.sender] >= _value);
279 
280         if (transferMain(_from, _to, _value)){
281             allowed[_from][msg.sender] -= _value;
282             return true;
283         } else {
284             return false;
285         }
286     }
287 
288     // Main transfer function. Checking of balances is made in calling function
289     function transferMain(address _from, address _to, uint _value) private returns (bool success) {
290         require(_to != address(0));
291         assert(balances[_to] + _value >= balances[_to]);
292         
293         balances[_from] -= _value;
294         balances[_to] += _value;
295         emit Transfer(_from, _to, _value);
296         return true;
297     }
298 
299     // Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
300     function approve(address _spender, uint _value) public returns (bool success) {
301         allowed[msg.sender][_spender] = _value;
302         emit Approval(msg.sender, _spender, _value);
303         return true;
304     }
305 
306     // Function to check the amount of tokens than an owner allowed to a spender
307     function allowance(address _owner, address _spender) public view returns (uint remaining) {
308         return allowed[_owner][_spender];
309     }
310     
311 
312 
313     /**
314      ====== LOCK-UP IMPLEMENTATION ====== 
315      */
316 
317     function unlockOwnFunds() public returns (bool success) {
318         return unlockFunds(msg.sender);
319     }
320 
321     function unlockSupervisedFunds(address _from) public onlyOwner returns (bool success) {
322         return unlockFunds(_from);
323     }
324     
325     function unlockFunds(address _owner) private returns (bool success) {
326         require(balancesLockup[_owner].unlockTime < now && balancesLockup[_owner].amount > 0);
327 
328         balances[_owner] += balancesLockup[_owner].amount;
329         emit Transfer(_owner, _owner, balancesLockup[_owner].amount);
330         balancesLockup[_owner].amount = 0;
331 
332         return true;
333     }
334 
335     function balanceOfLockup(address _owner) public view returns (uint balance, uint unlockTime) {
336         return (balancesLockup[_owner].amount, balancesLockup[_owner].unlockTime);
337     }
338 
339 
340 
341     /**
342      ====== TOKENS MINTING IMPLEMENTATION ====== 
343      */
344 
345     // Mint RAcoin tokens. No more than 20,000,000,000 RAC can be minted
346     function mintTokens(address _target, uint _mintedAmount) public onlyOwner returns (bool success) {
347         require(_mintedAmount <= unmintedTokens);
348         balances[_target] += _mintedAmount;
349         unmintedTokens -= _mintedAmount;
350         _totalSupply += _mintedAmount;
351         
352         emit Transfer(1, _target, _mintedAmount); 
353         return true;
354     }
355 
356     // Mint RAcoin locked-up tokens
357     // Using different types of minting functions has no effect on total limit of 20,000,000,000 RAC that can be created
358     function mintLockupTokens(address _target, uint _mintedAmount, uint _unlockTime) public onlyOwner returns (bool success) {
359         require(_mintedAmount <= unmintedTokens);
360 
361         balancesLockup[_target].amount += _mintedAmount;
362         balancesLockup[_target].unlockTime = _unlockTime;
363         unmintedTokens -= _mintedAmount;
364         _totalSupply += _mintedAmount;
365         
366         emit Transfer(1, _target, _mintedAmount); //TODO
367         return true;
368     }
369 
370     // Mint RAcoin tokens for token sale participants and add them to Jackpot list
371     // Using different types of minting functions has no effect on total limit of 20,000,000,000 RAC that can be created
372     function mintTokensWithIncludingInJackpot(address _target, uint _mintedAmount) public onlyOwner returns (bool success) {
373         require(maxAllowedManualDistribution > 0);
374         if (mintTokens(_target, _mintedAmount)) {
375             addAddressToJackpotParticipants(_target, _mintedAmount);
376         }
377         return true;
378     }
379 
380     // Mint RAcoin tokens and approve the passed address to spend the minted amount of tokens
381     // Using different types of minting functions has no effect on total limit of 20,000,000,000 RAC that can be created
382     function mintTokensWithApproval(address _target, uint _mintedAmount, address _spender) public onlyOwner returns (bool success) {
383         require(_mintedAmount <= unmintedTokens);
384         balances[_target] += _mintedAmount;
385         unmintedTokens -= _mintedAmount;
386         _totalSupply += _mintedAmount;
387         allowed[_target][_spender] += _mintedAmount;
388         
389         emit Transfer(1, _target, _mintedAmount);
390         return true;
391     }
392 
393     // After firing this function no more tokens can be created  
394     function stopTokenMinting() public onlyOwner returns (bool success) {
395         unmintedTokens = 0;
396         return true;
397     }
398 }