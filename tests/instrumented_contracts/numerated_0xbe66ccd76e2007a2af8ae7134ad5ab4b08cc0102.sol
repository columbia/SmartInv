1 pragma solidity ^0.4.11;
2 
3 contract Owned {
4     address public owner;
5     modifier onlyOwner() {
6         require(msg.sender == owner);
7         _;
8     }
9     /*Set owner of the contract*/
10     function Owned() {
11         owner = msg.sender;
12     }
13     /*Accept a new owner*/
14     function changeOwner(address _newOwner) onlyOwner {
15         owner = _newOwner;
16     }
17 }
18 
19 contract safeMath {
20     function add(uint a, uint b) returns (uint) {
21         uint c = a + b;
22         assert(c >= a || c >= b);
23         return c;
24     }
25     
26     function sub(uint a, uint b) returns (uint) {
27         assert( b <= a);
28         return a - b;
29     }
30 }
31 
32 contract tokenRecipient { 
33   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
34 } 
35 
36 contract ERC20Token {
37     /* This is a slight change to the ERC20 base standard.
38     function totalSupply() constant returns (uint256 supply);
39     is replaced with:
40     uint256 public totalSupply;
41     This automatically creates a getter function for the totalSupply.
42     This is moved to the base contract since public getter functions are not
43     currently recognised as an implementation of the matching abstract
44     function by the compiler.
45     */
46     /// total amount of tokens
47     uint256 public totalSupply;
48 
49     /// @param _owner The address from which the balance will be retrieved
50     /// @return The balance
51     function balanceOf(address _owner) constant returns (uint256 balance);
52 
53     /// @notice send `_value` token to `_to` from `msg.sender`
54     /// @param _to The address of the recipient
55     /// @param _value The amount of token to be transferred
56     /// @return Whether the transfer was successful or not
57     function transfer(address _to, uint256 _value) returns (bool success);
58 
59     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
60     /// @param _from The address of the sender
61     /// @param _to The address of the recipient
62     /// @param _value The amount of token to be transferred
63     /// @return Whether the transfer was successful or not
64     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
65 
66     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
67     /// @param _spender The address of the account able to transfer the tokens
68     /// @param _value The amount of tokens to be approved for transfer
69     /// @return Whether the approval was successful or not
70     function approve(address _spender, uint256 _value) returns (bool success);
71 
72     /// @param _owner The address of the account owning tokens
73     /// @param _spender The address of the account able to transfer the tokens
74     /// @return Amount of remaining tokens allowed to spent
75     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
76 
77     event Transfer(address indexed _from, address indexed _to, uint256 _value);
78     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
79 }
80 
81 contract MCTContractToken is ERC20Token, Owned{
82 
83     /* Public variables of the token */
84     string  public standard = "Mammoth Casino Contract Token";
85     string  public name = "Mammoth Casino Token";
86     string  public symbol = "MCT";
87     uint8   public decimals = 0;
88     address public icoContractAddress;
89     uint256 public tokenFrozenUntilTime;
90     uint256 public blackListFreezeTime;
91     struct frozen {
92         bool accountFreeze;
93         uint256 freezeUntilTime;
94     }
95     
96     /* Variables of the token */
97     uint256 public totalSupply;
98     uint256 public totalRemainSupply;
99     uint256 public foundingTeamSupply;
100     uint256 public gameDeveloperSupply;
101     uint256 public communitySupply;
102     mapping (address => uint256) balances;
103     mapping (address => mapping (address => uint256)) allowances;
104     mapping (address => frozen) blackListFreezeTokenAccounts;
105     /* Events */
106     event mintToken(address indexed _to, uint256 _value);
107     event burnToken(address indexed _from, uint256 _value);
108     event frozenToken(uint256 _frozenUntilBlock, string _reason);
109     
110     /* Initializes contract and  sets restricted addresses */
111     function MCTContractToken(uint256 _totalSupply, address _icoAddress) {
112         owner = msg.sender;
113         totalSupply = _totalSupply;
114         totalRemainSupply = totalSupply;
115         foundingTeamSupply = totalSupply * 2 / 10;
116         gameDeveloperSupply = totalSupply * 1 / 10;
117         communitySupply = totalSupply * 1 / 10;
118         icoContractAddress = _icoAddress;
119         blackListFreezeTime = 12 hours;
120     }
121 
122     /* Returns total supply of issued tokens */
123     function mctTotalSupply() returns (uint256) {   
124         return totalSupply - totalRemainSupply;
125     }
126 
127     /* Returns balance of address */
128     function balanceOf(address _owner) constant returns (uint256 balance) {
129         return balances[_owner];
130     }
131 
132     /* Transfers tokens from your address to other */
133     function transfer(address _to, uint256 _value) returns (bool success) {
134         require (now > tokenFrozenUntilTime);    // Throw if token is frozen
135         require (now > blackListFreezeTokenAccounts[msg.sender].freezeUntilTime);             // Throw if recipient is frozen address
136         require (now > blackListFreezeTokenAccounts[_to].freezeUntilTime);                    // Throw if recipient is frozen address
137         require (balances[msg.sender] > _value);           // Throw if sender has insufficient balance
138         require (balances[_to] + _value > balances[_to]);  // Throw if owerflow detected
139         balances[msg.sender] -= _value;                     // Deduct senders balance
140         balances[_to] += _value;                            // Add recivers blaance 
141         Transfer(msg.sender, _to, _value);                  // Raise Transfer event
142         return true;
143     }
144 
145     /* Approve other address to spend tokens on your account */
146     function approve(address _spender, uint256 _value) returns (bool success) {
147         require (now > tokenFrozenUntilTime);               // Throw if token is frozen        
148         allowances[msg.sender][_spender] = _value;          // Set allowance         
149         Approval(msg.sender, _spender, _value);             // Raise Approval event         
150         return true;
151     }
152 
153     /* Approve and then communicate the approved contract in a single tx */ 
154     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {            
155         tokenRecipient spender = tokenRecipient(_spender);              // Cast spender to tokenRecipient contract         
156         approve(_spender, _value);                                      // Set approval to contract for _value         
157         spender.receiveApproval(msg.sender, _value, this, _extraData);  // Raise method on _spender contract         
158         return true;     
159     }     
160 
161     /* A contract attempts to get the coins */
162     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {      
163         require (now > tokenFrozenUntilTime);    // Throw if token is frozen
164         require (now > blackListFreezeTokenAccounts[_to].freezeUntilTime);                    // Throw if recipient is restricted address  
165         require (balances[_from] > _value);                // Throw if sender does not have enough balance     
166         require (balances[_to] + _value > balances[_to]);  // Throw if overflow detected    
167         require (_value > allowances[_from][msg.sender]);  // Throw if you do not have allowance       
168         balances[_from] -= _value;                          // Deduct senders balance    
169         balances[_to] += _value;                            // Add recipient blaance         
170         allowances[_from][msg.sender] -= _value;            // Deduct allowance for this address         
171         Transfer(_from, _to, _value);                       // Raise Transfer event
172         return true;     
173     }         
174 
175     /* Get the amount of allowed tokens to spend */     
176     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {         
177         return allowances[_owner][_spender];
178     }         
179 
180     /* Issue new tokens */     
181     function mintTokens(address _to, uint256 _amount) {         
182         require (msg.sender == icoContractAddress);             // Only ICO address can mint tokens        
183         require (now > blackListFreezeTokenAccounts[_to].freezeUntilTime);                        // Throw if user wants to send to restricted address       
184         require (balances[_to] + _amount > balances[_to]);      // Check for overflows
185         require (totalRemainSupply > _amount);
186         totalRemainSupply -= _amount;                           // Update total supply
187         balances[_to] += _amount;                               // Set minted coins to target
188         mintToken(_to, _amount);                                // Create Mint event       
189         Transfer(0x0, _to, _amount);                            // Create Transfer event from 0x
190     }     
191   
192     /* Destroy tokens from owners account */
193     function burnTokens(address _addr, uint256 _amount) onlyOwner {
194         require (balances[msg.sender] < _amount);               // Throw if you do not have enough balance
195         totalRemainSupply += _amount;                           // Deduct totalSupply
196         balances[_addr] -= _amount;                             // Destroy coins on senders wallet
197         burnToken(_addr, _amount);                              // Raise Burn event
198         Transfer(_addr, 0x0, _amount);                          // Raise transfer to 0x0
199     }
200     
201     /* Destroy tokens if MCT not sold out */
202     function burnLeftTokens() onlyOwner {
203         require (totalRemainSupply > 0);
204         totalRemainSupply = 0;
205     }
206     
207     /* Stops all token transfers in case of emergency */
208     function freezeTransfersUntil(uint256 _frozenUntilTime, string _freezeReason) onlyOwner {      
209         tokenFrozenUntilTime = _frozenUntilTime;
210         frozenToken(_frozenUntilTime, _freezeReason);
211     }
212     
213     /*Freeze player accounts for "blackListFreezeTime" */
214     function freezeAccounts(address _freezeAddress, bool _freeze) onlyOwner {
215         blackListFreezeTokenAccounts[_freezeAddress].accountFreeze = _freeze;
216         blackListFreezeTokenAccounts[_freezeAddress].freezeUntilTime = now + blackListFreezeTime;
217     }
218     
219     /*mint ICO Left Token*/
220     function mintUnICOLeftToken(address _foundingTeamAddr, address _gameDeveloperAddr, address _communityAddr) onlyOwner {
221         balances[_foundingTeamAddr] += foundingTeamSupply;           // Give balance to _foundingTeamAddr;
222         balances[_gameDeveloperAddr] += gameDeveloperSupply;         // Give balance to _gameDeveloperAddr;
223         balances[_communityAddr] += communitySupply;                 // Give balance to _communityAddr;
224         totalRemainSupply -= (foundingTeamSupply + gameDeveloperSupply + communitySupply);
225         mintToken(_foundingTeamAddr, foundingTeamSupply);            // Create Mint event       
226         mintToken(_gameDeveloperAddr, gameDeveloperSupply);          // Create Mint event 
227         mintToken(_communityAddr, communitySupply);                  // Create Mint event 
228     }
229     
230 }
231 
232 contract MCTContract {
233   function mintTokens(address _to, uint256 _amount);
234 }
235 
236 contract MCTCrowdsale is Owned, safeMath {
237     uint256 public tokenSupportLimit = 30000 ether;              
238     uint256 public tokenSupportSoftLimit = 20000 ether;          
239     uint256 constant etherChange = 10**18;                       
240     uint256 public crowdsaleTokenSupply;                         
241     uint256 public crowdsaleTokenMint;                                      
242     uint256 public crowdsaleStartDate;
243     uint256 public crowdsaleStopDate;
244     address public MCTTokenAddress;
245     address public multisigAddress;
246     uint256 private totalCrowdsaleEther;
247     uint256 public nextParticipantIndex;
248     bool    public crowdsaleContinue;
249     bool    public crowdsaleSuccess;
250     struct infoUsersBuy{
251         uint256 value;
252         uint256 token;
253     }
254     mapping (address => infoUsersBuy) public tokenUsersSave;
255     mapping (uint256 => address) public participantIndex;
256     MCTContract mctTokenContract;
257     
258     /*Get Ether while anyone send Ether to ico contract address*/
259     function () payable crowdsaleOpen {
260         // Throw if the value = 0 
261         require (msg.value != 0);
262         // Check if the sender is a new user 
263         if (tokenUsersSave[msg.sender].token == 0){          
264             // Add a new user to the participant index   
265             participantIndex[nextParticipantIndex] = msg.sender;             
266             nextParticipantIndex += 1;
267         }
268         uint256 priceAtNow = 0;
269         uint256 priceAtNowLimit = 0;
270         (priceAtNow, priceAtNowLimit) = priceAt(now);
271         require(msg.value >= priceAtNowLimit);
272         buyMCTTokenProxy(msg.sender, msg.value, priceAtNow);
273 
274     }
275     
276     /*Require crowdsale open*/
277     modifier crowdsaleOpen() {
278         require(crowdsaleContinue == true);
279         require(now >= crowdsaleStartDate);
280         require(now <= crowdsaleStopDate);
281         _;
282     }
283     
284     /*Initial MCT Crowdsale*/
285     function MCTCrowdsale(uint256 _crowdsaleStartDate,
286         uint256 _crowdsaleStopDate,
287         uint256 _totalTokenSupply
288         ) {
289             owner = msg.sender;
290             crowdsaleStartDate = _crowdsaleStartDate;
291             crowdsaleStopDate = _crowdsaleStopDate;
292             require(_totalTokenSupply != 0);
293             crowdsaleTokenSupply = _totalTokenSupply;
294             crowdsaleContinue=true;
295     }
296     
297     /*Get the  price according to the present time*/
298     function priceAt(uint256 _atTime) internal returns(uint256, uint256) {
299         if(_atTime < crowdsaleStartDate) {
300             return (0, 0);
301         }
302         else if(_atTime < (crowdsaleStartDate + 7 days)) {
303             return (30000, 20*10**18);
304         }
305         else if(_atTime < (crowdsaleStartDate + 16 days)) {
306             return (24000, 1*10**17);
307         }
308         else if(_atTime < (crowdsaleStartDate + 31 days)) {
309             return (20000, 1*10**17);
310         }
311         else {
312             return (0, 0);
313         }
314    }
315    
316     /*Buy MCT Token*/        
317     function buyMCTTokenProxy(address _msgSender, uint256 _msgValue, 
318         uint256 _priceAtNow)  internal crowdsaleOpen returns (bool) {
319         require(_msgSender != 0x0);
320         require(crowdsaleTokenMint <= crowdsaleTokenSupply);                    // Require token not sold out
321         uint256 tokenBuy = _msgValue * _priceAtNow / etherChange;               // Calculate the token  
322         if(tokenBuy > (crowdsaleTokenSupply - crowdsaleTokenMint)){             // Require tokenBuy less than crowdsale token left 
323             uint256 needRetreat = (tokenBuy - crowdsaleTokenSupply + crowdsaleTokenMint) * etherChange / _priceAtNow;
324             _msgSender.transfer(needRetreat);
325             _msgValue -= needRetreat;
326             tokenBuy = _msgValue * _priceAtNow / etherChange;
327         }
328         if(buyMCT(_msgSender, tokenBuy)) {                                      // Buy MCT Token
329             totalCrowdsaleEther += _msgValue;
330             tokenUsersSave[_msgSender].value += _msgValue;                      // Store each person's Ether
331             return true;
332         }
333         return false;
334     }
335     
336     /*Buy MCT Token*/
337     function buyMCT(address _sender, uint256 _tokenBuy) internal returns (bool) {
338         tokenUsersSave[_sender].token += _tokenBuy;
339         mctTokenContract.mintTokens(_sender, _tokenBuy);
340         crowdsaleTokenMint += _tokenBuy;
341         return true;
342     }
343     
344     /*Set final period of MCT crowdsale*/
345     function setFinalICOPeriod() onlyOwner {
346         require(now > crowdsaleStopDate);
347         crowdsaleContinue = false;
348         if(this.balance >= tokenSupportSoftLimit * 4 / 10){                     // if crowdsale ether more than 8000Ether, MCT crowdsale will be Success
349             crowdsaleSuccess = true;
350         }
351     }
352     
353     /* Set token contract where mints will be done (tokens will be issued)*/  
354     function setTokenContract(address _MCTContractAddress) onlyOwner {     
355         mctTokenContract = MCTContract(_MCTContractAddress);
356         MCTTokenAddress  = _MCTContractAddress;
357     }
358     
359     /*withdraw Ether to a multisig address*/
360     function withdraw(address _multisigAddress, uint256 _balance) onlyOwner {    
361         require(_multisigAddress != 0x0);
362         multisigAddress = _multisigAddress;
363         multisigAddress.transfer(_balance);
364     }  
365     
366     function crowdsaleEther() returns(uint256) {
367         return totalCrowdsaleEther;
368     }
369 }