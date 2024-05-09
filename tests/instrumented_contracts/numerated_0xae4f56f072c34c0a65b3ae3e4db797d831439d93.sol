1 pragma solidity ^0.4.11;
2 
3 contract ERC20Basic {
4     uint256 public totalSupply;
5     function balanceOf(address who) constant returns (uint256);
6     function transfer(address to, uint256 value) returns (bool success);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 
11 contract ERC20 is ERC20Basic {
12     function allowance(address owner, address spender) constant returns (uint256);
13     function transferFrom(address from, address to, uint256 value) returns (bool success);
14     function approve(address spender, uint256 value) returns (bool success);
15     event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 contract SafeMath {
19     function safeMul(uint a, uint b) internal returns (uint) {
20         uint c = a * b;
21         assert(a == 0 || c / a == b);
22         return c;
23     }
24 
25     function safeDiv(uint a, uint b) internal returns (uint) {
26         assert(b > 0);
27         uint c = a / b;
28         assert(a == b * c + a % b);
29         return c;
30     }
31 
32     function safeSub(uint a, uint b) internal returns (uint) {
33         assert(b <= a);
34         return a - b;
35     }
36 
37     function safeAdd(uint a, uint b) internal returns (uint) {
38         uint c = a + b;
39         assert(c>=a && c>=b);
40         return c;
41     }
42 
43     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
44         return a >= b ? a : b;
45     }
46 
47     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
48         return a < b ? a : b;
49     }
50 
51     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
52         return a >= b ? a : b;
53     }
54 
55     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
56         return a < b ? a : b;
57     }
58 
59 }
60 
61 
62 contract Ownable {
63     address public owner;
64     address public newOwner;
65 
66     event OwnershipTransferred(address indexed _from, address indexed _to);
67 
68     modifier onlyOwner() {
69         require(msg.sender == owner);
70         _;
71     }
72 
73     function Ownable() {
74         owner = msg.sender;
75     }
76 
77     /// @notice Transfer ownership from `owner` to `newOwner`
78     /// @param _newOwner The new contract owner
79     function transferOwnership(address _newOwner) onlyOwner {
80         if (_newOwner != address(0)) {
81             newOwner = _newOwner;
82         }
83     }
84 
85     /// @notice accept ownership of the contract
86     function acceptOwnership() {
87         require(msg.sender == newOwner);
88         OwnershipTransferred(owner, newOwner);
89         owner = newOwner;
90     }
91 
92 }
93 
94 contract Administrable is Ownable {
95 
96     event AdminstratorAdded(address adminAddress);
97     event AdminstratorRemoved(address adminAddress);
98 
99     mapping (address => bool) public administrators;
100 
101     modifier onlyAdministrator() {
102         require(administrators[msg.sender] || owner == msg.sender); // owner is an admin by default
103         _;
104     }
105 
106     /// @notice Add an administrator
107     /// @param _adminAddress The new administrator address
108     function addAdministrators(address _adminAddress) onlyOwner {
109         administrators[_adminAddress] = true;
110         AdminstratorAdded(_adminAddress);
111     }
112 
113     /// @notice Remove an administrator
114     /// @param _adminAddress The administrator address to remove
115     function removeAdministrators(address _adminAddress) onlyOwner {
116         delete administrators[_adminAddress];
117         AdminstratorRemoved(_adminAddress);
118     }
119 }
120 
121 /// @title Gimli Token Contract.
122 contract GimliToken is ERC20, SafeMath, Ownable {
123 
124 
125     /*************************
126     **** Global variables ****
127     *************************/
128 
129     uint8 public constant decimals = 8;
130     string public constant name = "Gimli Token";
131     string public constant symbol = "GIM";
132     string public constant version = 'v1';
133 
134     /// total amount of tokens
135     uint256 public constant UNIT = 10**uint256(decimals);
136     uint256 constant MILLION_GML = 10**6 * UNIT; // can't use `safeMul` with constant
137     /// Should include CROWDSALE_AMOUNT and VESTING_X_AMOUNT
138     uint256 public constant TOTAL_SUPPLY = 150 * MILLION_GML; // can't use `safeMul` with constant;
139 
140     /// balances indexed by address
141     mapping (address => uint256) balances;
142 
143     /// allowances indexed by owner and spender
144     mapping (address => mapping (address => uint256)) allowed;
145 
146     bool public transferable = false;
147 
148     /*********************
149     **** Transactions ****
150     *********************/
151 
152 
153     /// @notice send `_value` token to `_to` from `msg.sender`
154     /// @param _to The address of the recipient
155     /// @param _value The amount of token to be transferred
156     /// @return Whether the transfer was successful or not
157     function transfer(address _to, uint256 _value) returns (bool success) {
158         require(transferable);
159 
160         require(balances[msg.sender] >= _value && _value >=0);
161 
162 
163         balances[msg.sender] = safeSub(balances[msg.sender], _value);
164         balances[_to] = safeAdd(balances[_to], _value);
165         Transfer(msg.sender, _to, _value);
166 
167         return true;
168     }
169 
170     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
171     /// @param _from The address of the sender
172     /// @param _to The address of the recipient
173     /// @param _value The amount of token to be transferred
174     /// @return Whether the transfer was successful or not
175     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
176         require(transferable);
177 
178         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value >= 0);
179 
180         balances[_from] = safeSub(balances[_from], _value);
181         balances[_to] = safeAdd(balances[_to], _value);
182         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
183         Transfer(_from, _to, _value);
184 
185         return true;
186     }
187 
188     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
189     /// @param _spender The address of the account able to transfer the tokens
190     /// @param _value The amount of tokens to be approved for transfer
191     /// @return Whether the approval was successful or not
192     function approve(address _spender, uint256 _value) returns (bool success) {
193         // To change the approve amount you first have to reduce the addresses`
194         //  allowance to zero by calling `approve(_spender, 0)` if it is not
195         //  already 0 to mitigate the race condition described here:
196         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
197         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
198 
199         allowed[msg.sender][_spender] = _value;
200         Approval(msg.sender, _spender, _value);
201         return true;
202     }
203 
204     /****************
205     **** Getters ****
206     ****************/
207 
208     /// @notice Get balance of an address
209     /// @param _owner The address from which the balance will be retrieved
210     /// @return The balance
211     function balanceOf(address _owner) constant returns (uint256 balance) {
212         return balances[_owner];
213     }
214 
215     /// @notice Get tokens allowed to spent by `_spender`
216     /// @param _owner The address of the account owning tokens
217     /// @param _spender The address of the account able to transfer the tokens
218     /// @return Amount of remaining tokens allowed to spent
219     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
220         return allowed[_owner][_spender];
221     }
222 
223 }
224 
225 /// @title Gimli Crowdsale Contract.
226 contract GimliCrowdsale is SafeMath, GimliToken {
227 
228     address public constant MULTISIG_WALLET_ADDRESS = 0xc79ab28c5c03f1e7fbef056167364e6782f9ff4f;
229     address public constant LOCKED_ADDRESS = 0xABcdEFABcdEFabcdEfAbCdefabcdeFABcDEFabCD;
230 
231     // crowdsale
232     uint256 public constant CROWDSALE_AMOUNT = 80 * MILLION_GML; // Should not include vested amount
233     uint256 public constant START_DATE = 1505736000; //  (epoch timestamp)
234     uint256 public constant END_DATE = 1508500800; // TODO (epoch timestamp)
235     uint256 public constant CROWDSALE_PRICE = 700; // 700 GML / ETH
236     uint256 public constant VESTING_1_AMOUNT = 10 * MILLION_GML; // GIM reserve fund
237     uint256 public constant VESTING_1_DATE = 1537272000; // TODO (epoch timestamp)
238     uint256 public constant VESTING_2_AMOUNT = 30 * MILLION_GML; // Team
239     uint256 public constant VESTING_2_DATE = 1568808000; // TODO (epoch timestamp)
240     bool public vesting1Withdrawn = false;
241     bool public vesting2Withdrawn = false;
242     bool public crowdsaleCanceled = false;
243     uint256 public soldAmount; // GIM
244     uint256 public paidAmount; // ETH
245 
246     /// @notice `msg.sender` invest `msg.value`
247     function() payable {
248         require(!crowdsaleCanceled);
249 
250         require(msg.value > 0);
251         // check date
252         require(block.timestamp >= START_DATE && block.timestamp <= END_DATE);
253 
254         // calculate and check quantity
255         uint256 quantity = safeDiv(safeMul(msg.value, CROWDSALE_PRICE), 10**(18-uint256(decimals)));
256         require(safeSub(balances[this], quantity) >= 0);
257 
258         require(MULTISIG_WALLET_ADDRESS.send(msg.value));
259 
260         // update balances
261         balances[this] = safeSub(balances[this], quantity);
262         balances[msg.sender] = safeAdd(balances[msg.sender], quantity);
263         soldAmount = safeAdd(soldAmount, quantity);
264         paidAmount = safeAdd(paidAmount, msg.value);
265 
266         Transfer(this, msg.sender, quantity);
267     }
268 
269     /// @notice returns non-sold tokens to owner
270     function  closeCrowdsale() onlyOwner {
271         // check if closable
272         require(block.timestamp > END_DATE || crowdsaleCanceled || balances[this] == 0);
273 
274         // enable token transfer
275         transferable = true;
276 
277         // update balances
278         if (balances[this] > 0) {
279             uint256 amount = balances[this];
280             balances[MULTISIG_WALLET_ADDRESS] = safeAdd(balances[MULTISIG_WALLET_ADDRESS], amount);
281             balances[this] = 0;
282             Transfer(this, MULTISIG_WALLET_ADDRESS, amount);
283         }
284     }
285 
286     /// @notice Terminate the crowdsale before END_DATE
287     function cancelCrowdsale() onlyOwner {
288         crowdsaleCanceled = true;
289     }
290 
291     /// @notice Pre-allocate tokens to advisor or partner
292     /// @param _to The pre-allocation destination
293     /// @param _value The amount of token to be allocated
294     /// @param _price ETH paid for these tokens
295     function preAllocate(address _to, uint256 _value, uint256 _price) onlyOwner {
296         require(block.timestamp < START_DATE);
297 
298         balances[this] = safeSub(balances[this], _value);
299         balances[_to] = safeAdd(balances[_to], _value);
300         soldAmount = safeAdd(soldAmount, _value);
301         paidAmount = safeAdd(paidAmount, _price);
302 
303         Transfer(this, _to, _value);
304     }
305 
306     /// @notice Send vested amount to _destination
307     /// @param _destination The address of the recipient
308     /// @return Whether the release was successful or not
309     function releaseVesting(address _destination) onlyOwner returns (bool success) {
310         if (block.timestamp > VESTING_1_DATE && vesting1Withdrawn == false) {
311             balances[LOCKED_ADDRESS] = safeSub(balances[LOCKED_ADDRESS], VESTING_1_AMOUNT);
312             balances[_destination] = safeAdd(balances[_destination], VESTING_1_AMOUNT);
313             vesting1Withdrawn = true;
314             Transfer(LOCKED_ADDRESS, _destination, VESTING_1_AMOUNT);
315             return true;
316         }
317         if (block.timestamp > VESTING_2_DATE && vesting2Withdrawn == false) {
318             balances[LOCKED_ADDRESS] = safeSub(balances[LOCKED_ADDRESS], VESTING_2_AMOUNT);
319             balances[_destination] = safeAdd(balances[_destination], VESTING_2_AMOUNT);
320             vesting2Withdrawn = true;
321             Transfer(LOCKED_ADDRESS, _destination, VESTING_2_AMOUNT);
322             return true;
323         }
324         return false;
325     }
326 
327     /// @notice transfer out any accidentally sent ERC20 tokens
328     /// @param tokenAddress Address of the ERC20 contract
329     /// @param amount The amount of token to be transfered
330     function transferOtherERC20Token(address tokenAddress, uint256 amount)
331       onlyOwner returns (bool success)
332     {
333         // can't be used for GIM token
334         require(tokenAddress != address(this) || transferable);
335         return ERC20(tokenAddress).transfer(owner, amount);
336     }
337 }
338 
339 /// @title Main Gimli contract.
340 contract Gimli is GimliCrowdsale, Administrable {
341 
342     address public streamerContract;
343     uint256 public streamerContractMaxAmount;
344 
345     event StreamerContractChanged(address newContractAddress, uint256 newMaxAmount);
346 
347     /// @notice Gimli Contract constructor. `msg.sender` is the owner.
348     function Gimli() {
349         // Give the multisig wallet initial tokens
350         balances[MULTISIG_WALLET_ADDRESS] = safeAdd(balances[MULTISIG_WALLET_ADDRESS], TOTAL_SUPPLY - CROWDSALE_AMOUNT - VESTING_1_AMOUNT - VESTING_2_AMOUNT);
351         // Give the contract crowdsale amount
352         balances[this] = CROWDSALE_AMOUNT;
353         // Locked address
354         balances[LOCKED_ADDRESS] = VESTING_1_AMOUNT + VESTING_2_AMOUNT;
355         // For ERC20 compatibility
356         totalSupply = TOTAL_SUPPLY;
357     }
358 
359     /// @notice authorize an address to transfer GIM on behalf an user
360     /// @param _contractAddress Address of GimliStreamer contract
361     /// @param _maxAmount The maximum amount that can be transfered by the contract
362     function setStreamerContract(
363         address _contractAddress,
364         uint256 _maxAmount) onlyAdministrator
365     {
366         // To change the maximum amount you first have to reduce it to 0`
367         require(_maxAmount == 0 || streamerContractMaxAmount == 0);
368 
369         streamerContract = _contractAddress;
370         streamerContractMaxAmount = _maxAmount;
371 
372         StreamerContractChanged(streamerContract, streamerContractMaxAmount);
373     }
374 
375     /// @notice Called by a Gimli contract to transfer GIM
376     /// @param _from The address of the sender
377     /// @param _to The address of the recipient
378     /// @param _amount The amount of token to be transferred
379     /// @return Whether the transfer was successful or not
380     function transferGIM(address _from, address _to, uint256 _amount) returns (bool success) {
381         require(msg.sender == streamerContract);
382         require(tx.origin == _from);
383         require(_amount <= streamerContractMaxAmount);
384 
385         if (balances[_from] < _amount || _amount <= 0)
386             return false;
387 
388         balances[_from] = safeSub(balances[_from], _amount);
389         balances[_to] = safeAdd(balances[_to], _amount);
390 
391         Transfer(_from, _to, _amount);
392 
393         return true;
394     }
395 
396 
397 
398 }