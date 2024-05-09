1 pragma solidity ^0.4.8;
2 
3 contract ICreditBOND{
4     function getBondMultiplier(uint _creditAmount, uint _locktime) constant returns (uint bondMultiplier) {}
5     function getNewCoinsIssued(uint _lockedBalance, uint _blockDifference, uint _percentReward) constant returns(uint newCoinsIssued){}
6 }
7 
8 contract ITokenRecipient { 
9     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); 
10 }
11 
12 contract IERC20Token {
13 
14     /// @return total amount of tokens
15     function totalSupply() constant returns (uint256 supply) {}
16 
17     /// @param _owner The address from which the balance will be retrieved
18     /// @return The balance
19     function balanceOf(address _owner) constant returns (uint256 balance) {}
20 
21     /// @notice send `_value` token to `_to` from `msg.sender`
22     /// @param _to The address of the recipient
23     /// @param _value The amount of token to be transferred
24     /// @return Whether the transfer was successful or not
25     function transfer(address _to, uint256 _value) returns (bool success) {}
26 
27     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
28     /// @param _from The address of the sender
29     /// @param _to The address of the recipient
30     /// @param _value The amount of token to be transferred
31     /// @return Whether the transfer was successful or not
32     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
33 
34     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
35     /// @param _spender The address of the account able to transfer the tokens
36     /// @param _value The amount of wei to be approved for transfer
37     /// @return Whether the approval was successful or not
38     function approve(address _spender, uint256 _value) returns (bool success) {}
39 
40     /// @param _owner The address of the account owning tokens
41     /// @param _spender The address of the account able to transfer the tokens
42     /// @return Amount of remaining tokens allowed to spent
43     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}   
44 
45     event Transfer(address indexed _from, address indexed _to, uint256 _value);
46     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
47 }
48 
49 contract CreditBIT is IERC20Token {
50 
51     struct CreditBalance{
52         uint avaliableBalance;
53         uint lockedBalance;
54 
55         uint bondMultiplier;
56         uint lockedUntilBlock;
57         uint lastBlockClaimed;
58     }
59 
60 	address public dev;
61 	address public creditDaoAddress;
62     ICreditBOND creditBond;
63     address public creditGameAddress;
64     address public creditMcAddress;
65     bool public lockdown;
66 
67     string public standard = 'Creditbit 1.0';
68     string public name = 'CreditBIT';
69     string public symbol = 'CRB';
70     uint8 public decimals = 8;
71 
72     uint256 public totalSupply = 0;
73     uint public totalAvaliableSupply = 0;
74     uint public totalLockedSupply = 0; 
75 
76     mapping (address => CreditBalance) balances;
77     mapping (address => mapping (address => uint256)) public allowance;
78 
79     //event Transfer(address indexed from, address indexed to, uint256 value);
80     //event Approval(address indexed _owner, address indexed _spender, uint256 _value);
81     event LockCredits(address _owner, uint _amount, uint _numberOfBlocks);
82     event UnlockCredits(address _owner, uint _amount);
83     event Mint(address _owner, uint _amount);
84 
85     function CreditBIT() {
86         dev = msg.sender;
87         lockdown = false;
88     }
89 
90     function balanceOf(address _owner) constant returns (uint avaliableBalance){
91         return balances[_owner].avaliableBalance;
92     }
93 
94     function lockedBalanceOf(address _owner) constant returns (uint avaliableBalance){
95         return balances[_owner].lockedBalance;
96     }
97 
98     function getAccountData(address _owner) constant returns (uint avaliableBalance, uint lockedBalance, uint bondMultiplier, uint lockedUntilBlock, uint lastBlockClaimed){
99         CreditBalance memory tempAccountData = balances[_owner];
100         return (
101             tempAccountData.avaliableBalance,
102             tempAccountData.lockedBalance,
103             tempAccountData.bondMultiplier,
104             tempAccountData.lockedUntilBlock,
105             tempAccountData.lastBlockClaimed
106         );
107     }
108 
109     function lockBalance(uint _amount, uint _lockForBlocks) returns (uint error){
110         if (lockdown) throw;
111         uint realBlocksLocked;
112         if (block.number + _lockForBlocks < balances[msg.sender].lockedUntilBlock){
113             realBlocksLocked = balances[msg.sender].lockedUntilBlock;
114         }else{
115             realBlocksLocked = block.number + _lockForBlocks;
116         }
117         
118         uint realAmount;
119         if (balances[msg.sender].avaliableBalance < (_amount * 10**8)) {
120             realAmount = (balances[msg.sender].avaliableBalance / 10**8) * 10**8;
121         }else{
122             realAmount = (_amount * 10**8);
123         }
124 
125         uint newBondMultiplier = creditBond.getBondMultiplier(realAmount, realBlocksLocked);
126         if (newBondMultiplier == 0) throw;
127 
128         uint claimError = claimBondReward();
129 
130         balances[msg.sender].avaliableBalance -= realAmount;
131         balances[msg.sender].lockedBalance += realAmount;
132         totalAvaliableSupply -= realAmount;
133         totalLockedSupply += realAmount;
134         balances[msg.sender].bondMultiplier = newBondMultiplier;
135         balances[msg.sender].lockedUntilBlock = realBlocksLocked;
136         balances[msg.sender].lastBlockClaimed = block.number;
137 
138         return 0;
139     }
140 
141     function mintMigrationTokens(address _reciever, uint _amount) returns (uint error){
142       
143         if (msg.sender != creditMcAddress) { return 1; }
144         
145         mint(_amount, _reciever);
146         return 0;
147     }
148 
149     function claimBondReward() returns (uint error){
150         if (lockdown) throw;
151         if (balances[msg.sender].lockedBalance == 0) { return 1;}
152         
153         uint blockDifference = block.number - balances[msg.sender].lastBlockClaimed;
154         if (blockDifference < 10){ return 1;}
155         
156         uint newCreditsIssued = creditBond.getNewCoinsIssued(
157             balances[msg.sender].lockedBalance, 
158             blockDifference, 
159             balances[msg.sender].bondMultiplier);
160         if (newCreditsIssued == 0) { return 1; }
161         
162         if (balances[msg.sender].lockedUntilBlock < block.number ) {
163             balances[msg.sender].avaliableBalance += balances[msg.sender].lockedBalance;
164             totalAvaliableSupply += balances[msg.sender].lockedBalance;
165             totalLockedSupply -= balances[msg.sender].lockedBalance;
166             balances[msg.sender].bondMultiplier = 0;
167             balances[msg.sender].lockedUntilBlock = 0;
168             UnlockCredits(msg.sender, balances[msg.sender].lockedBalance);
169             balances[msg.sender].lockedBalance = 0;
170         }else{
171             balances[msg.sender].lastBlockClaimed = block.number;
172         }
173         
174         mint(newCreditsIssued, msg.sender);
175     }
176     
177     function claimGameReward(address _champion, uint _lockedTokenAmount, uint _lockTime) returns (uint error){
178         if (lockdown) throw;
179         if (msg.sender != creditGameAddress) { return 1; }
180         
181         uint newCreditsIssued = creditBond.getNewCoinsIssued(
182             _lockedTokenAmount, 
183             _lockTime, 
184             creditBond.getBondMultiplier(_lockedTokenAmount, _lockTime + block.number));
185         if (newCreditsIssued == 0) { return 1; }
186         mint(newCreditsIssued, _champion);
187         return 0;
188     }
189 
190     function mintBonusTokensForGames(uint _amount) returns (uint error){
191         if (lockdown) throw;
192         if (msg.sender != creditDaoAddress) { return 1; }
193 
194         mint(_amount, creditGameAddress);
195         return 0;
196     }
197 
198     function mint(uint _newCreditsIssued, address _sender) internal {
199        
200         totalSupply += _newCreditsIssued;
201         totalAvaliableSupply += _newCreditsIssued;
202         balances[_sender].avaliableBalance += _newCreditsIssued;
203         Transfer(0x0, _sender, _newCreditsIssued);
204         Mint(_sender, _newCreditsIssued);
205     }
206 
207     function transfer(address _to, uint256 _value) returns (bool success){
208         if (lockdown) throw;
209         if (balances[msg.sender].avaliableBalance < _value) throw;
210         if (balances[_to].avaliableBalance + _value < balances[_to].avaliableBalance) throw;
211         balances[msg.sender].avaliableBalance -= _value;
212         balances[_to].avaliableBalance += _value;
213         Transfer(msg.sender, _to, _value);
214         return true;
215     }
216 
217     function approve(address _spender, uint256 _value) returns (bool success) {
218         if (lockdown) throw;
219         allowance[msg.sender][_spender] = _value;
220         Approval(msg.sender, _spender, _value);
221         return true;
222     }
223 
224     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
225         if (lockdown) throw;
226         ITokenRecipient spender = ITokenRecipient(_spender);
227         if (approve(_spender, _value)) {
228             spender.receiveApproval(msg.sender, _value, this, _extraData);
229             return true;
230         }
231     }        
232 
233     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
234         if (lockdown) throw;
235         if (balances[_from].avaliableBalance < _value) throw;
236         if (balances[_to].avaliableBalance + _value < balances[_to].avaliableBalance) throw;
237         if (_value > allowance[_from][msg.sender]) throw;
238         balances[_from].avaliableBalance -= _value;
239         balances[_to].avaliableBalance += _value;
240         allowance[_from][msg.sender] -= _value;
241         Transfer(_from, _to, _value);
242         return true;
243     }
244     
245     function setCreditBond(address _bondAddress) returns (uint error){
246         if (msg.sender != creditDaoAddress) {return 1;}
247         
248         creditBond = ICreditBOND(_bondAddress);
249         return 0;
250     }
251 
252     function getCreditBondAddress() constant returns (address bondAddress){
253         return address(creditBond);
254     }
255     
256     function setCreditDaoAddress(address _daoAddress) returns (uint error){
257         if (msg.sender != dev) {return 1;}
258         
259         creditDaoAddress = _daoAddress;
260         return 0;
261     }
262     
263     function setCreditGameAddress(address _gameAddress) returns (uint error){
264         if (msg.sender != creditDaoAddress) {return 1;}
265         
266         creditGameAddress = _gameAddress;
267         return 0;
268     }
269     
270     function setCreditMcAddress(address _mcAddress) returns (uint error){
271         if (msg.sender != creditDaoAddress) {return 1;}
272         
273         creditMcAddress = _mcAddress;
274         return 0;
275     }
276 
277     function lockToken() returns (uint error){
278         if (msg.sender != creditDaoAddress) {return 1;}
279 
280         lockdown = !lockdown;
281         return 0;
282     }
283 
284     function () {
285         throw;
286     }
287 }