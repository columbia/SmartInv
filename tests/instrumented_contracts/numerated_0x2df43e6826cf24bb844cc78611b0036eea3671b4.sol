1 contract IERC20Token {
2     function totalSupply() constant returns (uint256 supply) {}
3     function balanceOf(address _owner) constant returns (uint256 balance) {}
4     function transfer(address _to, uint256 _value) returns (bool success) {}
5     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
6     function approve(address _spender, uint256 _value) returns (bool success) {}
7     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
8 
9     event Transfer(address indexed _from, address indexed _to, uint256 _value);
10     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
11 }
12 contract IKYC {
13     function getKycLevel(address _clientAddress) constant returns (uint level){}
14     function getIsCompany(address _clientAddress) constant returns (bool state){}
15 }
16 contract IToken {
17     function totalSupply() constant returns (uint256 supply) {}
18     function balanceOf(address _owner) constant returns (uint256 balance) {}
19     function transferViaProxy(address _from, address _to, uint _value) returns (uint error) {}
20     function transferFromViaProxy(address _source, address _from, address _to, uint256 _amount) returns (uint error) {}
21     function approveFromProxy(address _source, address _spender, uint256 _value) returns (uint error) {}
22     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
23     function issueNewCoins(address _destination, uint _amount) returns (uint error){}
24     function issueNewHeldCoins(address _destination, uint _amount){}
25     function destroyOldCoins(address _destination, uint _amount) returns (uint error) {}
26     function takeTokensForBacking(address _destination, uint _amount){}
27 }
28 contract ITokenRecipient {
29 	function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
30 }
31 
32 contract CreationContract{
33 
34     address public curator;
35     address public dev;
36     IToken tokenContract;
37 
38     function CreationContract(){
39         dev = msg.sender;
40     }
41 
42     function create(address _destination, uint _amount){
43         if (msg.sender != curator) throw;
44 
45         tokenContract.issueNewCoins(_destination, _amount);
46     }
47     
48     function createHeld(address _destination, uint _amount){
49          if (msg.sender != curator) throw;
50          
51          tokenContract.issueNewHeldCoins(_destination, _amount);
52     }
53 
54     function setCreationCurator(address _curatorAdress){
55         if (msg.sender != dev) throw;
56 
57         curator = _curatorAdress;
58     }
59 
60     function setTokenContract(address _contractAddress){
61         if (msg.sender != curator) throw;
62 
63         tokenContract = IToken(_contractAddress);
64     }
65 
66     function killContract(){
67         if (msg.sender != dev) throw;
68 
69         selfdestruct(dev);
70     }
71 
72     function tokenAddress() constant returns (address tokenAddress){
73         return address(tokenContract);
74     }
75 }
76 
77 contract DestructionContract{
78 
79     address public curator;
80     address public dev;
81     IToken tokenContract;
82 
83     function DestructionContract(){
84         dev = msg.sender;
85     }
86 
87     function destroy(uint _amount){
88         if (msg.sender != curator) throw;
89 
90         tokenContract.destroyOldCoins(msg.sender, _amount);
91     }
92 
93     function setDestructionCurator(address _curatorAdress){
94         if (msg.sender != dev) throw;
95 
96         curator = _curatorAdress;
97     }
98 
99     function setTokenContract(address _contractAddress){
100         if (msg.sender != curator) throw;
101 
102         tokenContract = IToken(_contractAddress);
103     }
104 
105     function killContract(){
106         if (msg.sender != dev) throw;
107 
108         selfdestruct(dev);
109     }
110 
111     function tokenAddress() constant returns (address tokenAddress){
112         return address(tokenContract);
113     }
114 }
115 
116 
117 contract SpaceCoin is IERC20Token{
118 
119   struct account{
120     uint avaliableBalance;
121     uint heldBalance;
122     uint amountToClaim;
123     uint lastClaimed;
124   }
125 
126     //
127     /* Variables */
128     //
129 
130     address public dev;
131     address public curator;
132     address public creationAddress;
133     address public destructionAddress;
134     uint256 public totalSupply = 0;
135     uint256 public totalHeldSupply = 0;
136     bool public lockdown = false;
137     uint public blocksPerMonth;
138     uint public defaultClaimPercentage;
139     uint public claimTreshold;
140 
141     string public name = 'SpaceCoin';
142     string public symbol = 'SCT';
143     uint8 public decimals = 8;
144 
145     mapping (address => account) accounts;
146     mapping (address => mapping (address => uint256)) allowed;
147 
148     //
149     /* Events */
150     //
151 
152     event TokensClaimed(address _destination, uint _amount);
153     event Create(address _destination, uint _amount);
154     event CreateHeld(address _destination, uint _amount);
155     event Destroy(address _destination, uint _amount);
156 
157     //
158     /* Constructor */
159     //
160 
161     function SpaceCoin() {
162         dev = msg.sender;
163         lastBlockClaimed = block.number;
164     }
165 
166     //
167     /* Token related methods */
168     //
169 
170     function balanceOf(address _owner) constant returns (uint256 balance) {
171         return accounts[_owner].avaliableBalance;
172     }
173     
174     function heldBalanceOf(address _owner) constant returns (uint256 balance) {
175         return accounts[_owner].heldBalance;
176     }
177 
178     function transfer(address _to, uint256 _amount) returns (bool success) {
179         if(accounts[msg.sender].avaliableBalance < _amount) throw;
180         if(accounts[_to].avaliableBalance + _amount <= accounts[_to].avaliableBalance) throw;
181         if(lockdown) throw;
182 
183         accounts[msg.sender].avaliableBalance -= _amount;
184         accounts[_to].avaliableBalance += _amount;
185         Transfer(msg.sender, _to, _amount);
186         return true;
187     }
188 
189     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
190         if(accounts[_from].avaliableBalance < _amount) throw;
191         if(accounts[_to].avaliableBalance + _amount <= accounts[_to].avaliableBalance) throw;
192         if(_amount > allowed[_from][msg.sender]) throw;
193         if(lockdown) throw;
194 
195         accounts[_from].avaliableBalance -= _amount;
196         accounts[_to].avaliableBalance += _amount;
197         allowed[_from][msg.sender] -= _amount;
198         Transfer(_from, _to, _amount);
199         return true;
200     }
201 
202     function approve(address _spender, uint256 _value) returns (bool success) {
203         allowed[msg.sender][_spender] = _value;
204         Approval(msg.sender, _spender, _value);
205         return true;
206     }
207 
208     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
209       return allowed[_owner][_spender];
210     }
211 
212     function claimHeldBalance(){
213       if (accounts[msg.sender].heldBalance == 0) throw;
214       if (accounts[msg.sender].lastClaimed + blocksPerMonth >= block.number) throw; 
215 
216       uint valueToClaim = 0;
217       if (accounts[msg.sender].amountToClaim == 0){
218           valueToClaim = (accounts[msg.sender].heldBalance * defaultClaimPercentage) / 100;
219           if (valueToClaim == 0) throw;
220       }else{
221           if (accounts[msg.sender].amountToClaim <= accounts[msg.sender].heldBalance){
222               valueToClaim = accounts[msg.sender].amountToClaim;
223           }else{
224               valueToClaim = accounts[msg.sender].heldBalance;
225           }
226       }
227       
228       if (accounts[msg.sender].heldBalance < claimTreshold){
229           valueToClaim = accounts[msg.sender].heldBalance; 
230       }
231 
232       totalSupply += valueToClaim;
233       totalHeldSupply -= valueToClaim;
234       accounts[msg.sender].avaliableBalance += valueToClaim;
235       accounts[msg.sender].heldBalance -= valueToClaim;
236       accounts[msg.sender].lastClaimed = block.number;
237       accounts[msg.sender].amountToClaim = 0;
238       TokensClaimed(msg.sender, valueToClaim);
239       Create(msg.sender, valueToClaim);
240       Transfer(0x0, msg.sender, valueToClaim);
241     }
242 
243     function issueNewCoins(address _destination, uint _amount){
244         if (msg.sender != creationAddress) throw;
245         if(accounts[_destination].avaliableBalance + _amount < accounts[_destination].avaliableBalance) throw;
246         if(totalSupply + _amount < totalSupply) throw;
247 
248         totalSupply += _amount;
249         accounts[_destination].avaliableBalance += _amount;
250         Create(_destination, _amount);
251         Transfer(0x0, _destination, _amount);
252     }
253 
254     function issueNewHeldCoins(address _destination, uint _amount){
255       if (msg.sender != creationAddress) throw;
256       if(accounts[_destination].heldBalance + _amount < accounts[_destination].heldBalance) throw;
257       if(totalSupply + totalHeldSupply + _amount < totalSupply + totalHeldSupply) throw;
258 
259       if(accounts[_destination].lastClaimed == 0){
260           accounts[_destination].lastClaimed = block.number;
261       }  
262       totalHeldSupply += _amount;
263       accounts[_destination].heldBalance += _amount;
264       CreateHeld(_destination, _amount);
265 
266     }
267 
268     function destroyOldCoins(address _destination, uint _amount){
269         if (msg.sender != destructionAddress) throw;
270         if (accounts[_destination].avaliableBalance < _amount) throw;
271 
272         totalSupply -= _amount;
273         accounts[_destination].avaliableBalance -= _amount;
274         Destroy(_destination, _amount);
275         Transfer(_destination, 0x0, _amount);
276     }
277 
278     function fillHeldData(address[] _accounts, uint[] _amountsToClaim){
279         if (msg.sender != curator) throw;
280         if (_accounts.length != _amountsToClaim.length) throw;
281 
282         for (uint cnt = 0; cnt < _accounts.length; cnt++){
283           accounts[_accounts[cnt]].amountToClaim = _amountsToClaim[cnt];
284         }
285     }
286 
287     function setTokenCurator(address _curatorAddress){
288         if( msg.sender != dev) throw;
289 
290         curator = _curatorAddress;
291     }
292 
293     function setCreationAddress(address _contractAddress){
294         if (msg.sender != curator) throw;
295 
296         creationAddress = _contractAddress;
297     }
298 
299     function setDestructionAddress(address _contractAddress){
300         if (msg.sender != curator) throw;
301 
302         destructionAddress = _contractAddress;
303     }
304 
305     function setBlocksPerMonth(uint _blocks){
306         if (msg.sender != curator) throw;
307 
308         blocksPerMonth = _blocks;
309     }
310 
311     function setDefaultClaimPercentage(uint _percentage){
312         if (msg.sender != curator) throw;
313         if (_percentage > 100) throw;
314 
315         defaultClaimPercentage = _percentage;
316     }
317 
318     function emergencyLock(){
319         if (msg.sender != curator && msg.sender != dev) throw;
320 
321         lockdown = !lockdown;
322     }
323 
324     function killContract(){
325         if (msg.sender != dev) throw;
326 
327         selfdestruct(dev);
328     }
329 
330     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
331         allowed[msg.sender][_spender] = _value;
332         ITokenRecipient spender = ITokenRecipient(_spender);
333         spender.receiveApproval(msg.sender, _value, this, _extraData);
334         return true;
335     }
336 
337     uint public blockReward;
338     uint public lastBlockClaimed;
339 
340     function getMiningReward() {
341         require(msg.sender == block.coinbase);
342         uint amount = (block.number - lastBlockClaimed) * blockReward;
343         if(accounts[msg.sender].avaliableBalance + amount < accounts[msg.sender].avaliableBalance) throw;
344         if(totalSupply + amount < totalSupply) throw;
345 
346         totalSupply += amount;
347         accounts[msg.sender].avaliableBalance += amount;
348         Create(msg.sender, amount);
349         Transfer(0x0, msg.sender, amount);
350 
351         lastBlockClaimed = block.number;
352     }
353 
354     function setBlockReward(uint _blockReward){
355         if (msg.sender != curator) throw;
356 
357         blockReward = _blockReward;
358     }
359     
360     function setClaimTreshold(uint _claimTreshold){
361         if (msg.sender != curator) throw;
362 
363         claimTreshold = _claimTreshold;
364     }
365     
366 }