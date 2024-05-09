1 pragma solidity ^0.4.11;
2 
3 
4 contract Controlled {
5     /// @notice The address of the controller is the only address that can call
6     ///  a function with this modifier
7     modifier onlyController { require(msg.sender == controller); _; }
8 
9     address public controller;
10 
11     function Controlled() public { controller = msg.sender;}
12 
13     /// @notice Changes the controller of the contract
14     /// @param _newController The new controller of the contract
15     function changeController(address _newController) onlyController public {
16         controller = _newController;
17     }
18 }
19 
20 
21 /// `Owned` is a base level contract that assigns an `owner` that can be later changed
22 contract Owned {
23     /// @dev `owner` is the only address that can call a function with this
24     /// modifier
25     modifier onlyOwner { require (msg.sender == owner); _; }
26 
27     address public owner;
28 
29     /// @notice The Constructor assigns the message sender to be `owner`
30     function Owned() { owner = msg.sender;}
31 
32     /// @notice `owner` can step down and assign some other address to this role
33     /// @param _newOwner The address of the new owner. 0x0 can be used to create
34     ///  an unowned neutral vault, however that cannot be undone
35     function changeOwner(address _newOwner)  onlyOwner {
36         owner = _newOwner;
37     }
38 }
39 
40 contract SafeMath {
41   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42     if (a == 0) {
43       return 0;
44     }
45     uint256 c = a * b;
46     assert(c / a == b);
47     return c;
48   }
49 
50   function div(uint256 a, uint256 b) internal pure returns (uint256) {
51     // assert(b > 0); // Solidity automatically throws when dividing by 0
52     uint256 c = a / b;
53     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54     return c;
55   }
56 
57   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58     assert(b <= a);
59     return a - b;
60   }
61 
62   function add(uint256 a, uint256 b) internal pure returns (uint256) {
63     uint256 c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 contract ERC20 {
70 
71   function balanceOf(address who) constant public returns (uint);
72   function allowance(address owner, address spender) constant public returns (uint);
73 
74   function transfer(address to, uint value) public returns (bool ok);
75   function transferFrom(address from, address to, uint value) public returns (bool ok);
76   function approve(address spender, uint value) public returns (bool ok);
77 
78   event Transfer(address indexed from, address indexed to, uint value);
79   event Approval(address indexed owner, address indexed spender, uint value);
80 
81 }
82 
83 
84 contract ControlledToken is ERC20, Controlled {
85 
86     uint256 constant MAX_UINT256 = 2**256 - 1;
87 
88     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
89 
90     /* Public variables of the token */
91 
92     /*
93     NOTE:
94     The following variables are OPTIONAL vanities. One does not have to include them.
95     They allow one to customise the token contract & in no way influences the core functionality.
96     Some wallets/interfaces might not even bother to look at this information.
97     */
98     string public name;                   //fancy name: eg Simon Bucks
99     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
100     string public symbol;                 //An identifier: eg SBX
101     string public version = '1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
102     uint256 public totalSupply;
103 
104     function ControlledToken(
105         uint256 _initialAmount,
106         string _tokenName,
107         uint8 _decimalUnits,
108         string _tokenSymbol
109         ) {
110         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
111         totalSupply = _initialAmount;                        // Update total supply
112         name = _tokenName;                                   // Set the name for display purposes
113         decimals = _decimalUnits;                            // Amount of decimals for display purposes
114         symbol = _tokenSymbol;                               // Set the symbol for display purposes
115     }
116 
117 
118     function transfer(address _to, uint256 _value) returns (bool success) {
119         //Default assumes totalSupply can't be over max (2^256 - 1).
120         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
121         //Replace the if with this one instead.
122         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
123         require(balances[msg.sender] >= _value);
124 
125         if (isContract(controller)) {
126             require(TokenController(controller).onTransfer(msg.sender, _to, _value));
127         }
128 
129         balances[msg.sender] -= _value;
130         balances[_to] += _value;
131         // Alerts the token controller of the transfer
132 
133         Transfer(msg.sender, _to, _value);
134         return true;
135     }
136 
137     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
138         //same as above. Replace this line with the following if you want to protect against wrapping uints.
139         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
140         uint256 allowance = allowed[_from][msg.sender];
141         require(balances[_from] >= _value && allowance >= _value);
142 
143         if (isContract(controller)) {
144             require(TokenController(controller).onTransfer(_from, _to, _value));
145         }
146 
147         balances[_to] += _value;
148         balances[_from] -= _value;
149         if (allowance < MAX_UINT256) {
150             allowed[_from][msg.sender] -= _value;
151         }
152         Transfer(_from, _to, _value);
153         return true;
154     }
155 
156     function balanceOf(address _owner) constant returns (uint256 balance) {
157         return balances[_owner];
158     }
159 
160     function approve(address _spender, uint256 _value) returns (bool success) {
161 
162         // Alerts the token controller of the approve function call
163         if (isContract(controller)) {
164             require(TokenController(controller).onApprove(msg.sender, _spender, _value));
165         }
166 
167         allowed[msg.sender][_spender] = _value;
168         Approval(msg.sender, _spender, _value);
169         return true;
170     }
171 
172     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
173       return allowed[_owner][_spender];
174     }
175 
176     ////////////////
177 // Generate and destroy tokens
178 ////////////////
179 
180     /// @notice Generates `_amount` tokens that are assigned to `_owner`
181     /// @param _owner The address that will be assigned the new tokens
182     /// @param _amount The quantity of tokens generated
183     /// @return True if the tokens are generated correctly
184     function generateTokens(address _owner, uint _amount ) onlyController returns (bool) {
185         uint curTotalSupply = totalSupply;
186         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
187         uint previousBalanceTo = balanceOf(_owner);
188         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
189         totalSupply = curTotalSupply + _amount;
190         balances[_owner]  = previousBalanceTo + _amount;
191         Transfer(0, _owner, _amount);
192         return true;
193     }
194 
195 
196     /// @notice Burns `_amount` tokens from `_owner`
197     /// @param _owner The address that will lose the tokens
198     /// @param _amount The quantity of tokens to burn
199     /// @return True if the tokens are burned correctly
200     function destroyTokens(address _owner, uint _amount
201     ) onlyController returns (bool) {
202         uint curTotalSupply = totalSupply;
203         require(curTotalSupply >= _amount);
204         uint previousBalanceFrom = balanceOf(_owner);
205         require(previousBalanceFrom >= _amount);
206         totalSupply = curTotalSupply - _amount;
207         balances[_owner] = previousBalanceFrom - _amount;
208         Transfer(_owner, 0, _amount);
209         return true;
210     }
211 
212     /// @notice The fallback function: If the contract's controller has not been
213     ///  set to 0, then the `proxyPayment` method is called which relays the
214     ///  ether and creates tokens as described in the token controller contract
215     function ()  payable {
216         require(isContract(controller));
217         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
218     }
219 
220     /// @dev Internal function to determine if an address is a contract
221     /// @param _addr The address being queried
222     /// @return True if `_addr` is a contract
223     function isContract(address _addr) constant internal returns(bool) {
224         uint size;
225         if (_addr == 0) return false;
226         assembly {
227             size := extcodesize(_addr)
228         }
229         return size>0;
230     }
231 
232     /// @notice This method can be used by the controller to extract mistakenly
233     ///  sent tokens to this contract.
234     /// @param _token The address of the token contract that you want to recover
235     ///  set to 0 in case you want to extract ether.
236     function claimTokens(address _token) onlyController {
237         if (_token == 0x0) {
238             controller.transfer(this.balance);
239             return;
240         }
241 
242         ControlledToken token = ControlledToken(_token);
243         uint balance = token.balanceOf(this);
244         token.transfer(controller, balance);
245         ClaimedTokens(_token, controller, balance);
246     }
247 
248 
249     mapping (address => uint256) balances;
250     mapping (address => mapping (address => uint256)) allowed;
251 
252 
253 }
254 
255 // Controller for Token interface
256 // Taken from https://github.com/Giveth/minime/blob/master/contracts/MiniMeToken.sol
257 
258 /// @dev The token controller contract must implement these functions
259 contract TokenController {
260     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
261     /// @param _owner The address that sent the ether to create tokens
262     /// @return True if the ether is accepted, false if it throws
263     function proxyPayment(address _owner) payable public returns(bool);
264 
265     /// @notice Notifies the controller about a token transfer allowing the
266     ///  controller to react if desired
267     /// @param _from The origin of the transfer
268     /// @param _to The destination of the transfer
269     /// @param _amount The amount of the transfer
270     /// @return False if the controller does not authorize the transfer
271     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
272 
273     /// @notice Notifies the controller about an approval allowing the
274     ///  controller to react if desired
275     /// @param _owner The address that calls `approve()`
276     /// @param _spender The spender in the `approve()` call
277     /// @param _amount The amount in the `approve()` call
278     /// @return False if the controller does not authorize the approval
279     function onApprove(address _owner, address _spender, uint _amount) public
280         returns(bool);
281 }
282 
283 
284 
285 
286 contract TokenSale is TokenController, Owned, SafeMath {
287 
288 
289     uint public startFundingTime;           // In UNIX Time Format
290     uint public endFundingTime;             // In UNIX Time Format
291 
292     uint public tokenCap;                   // Maximum amount of tokens to be distributed
293     uint public totalTokenCount;            // Actual amount of tokens distributed
294 
295     uint public totalCollected;             // In wei
296     ControlledToken public tokenContract;   // The new token for this TokenSale
297     address public vaultAddress;            // The address to hold the funds donated
298     bool public transfersAllowed;           // If the token transfers are allowed
299     uint256 public exchangeRate;            // USD/ETH rate * 100
300     uint public exchangeRateAt;             // Block number when exchange rate was set
301 
302     /// @notice 'TokenSale()' initiates the TokenSale by setting its funding
303     /// parameters
304     /// @dev There are several checks to make sure the parameters are acceptable
305     /// @param _startFundingTime The UNIX time that the TokenSale will be able to
306     /// start receiving funds
307     /// @param _endFundingTime The UNIX time that the TokenSale will stop being able
308     /// to receive funds
309     /// @param _tokenCap Maximum amount of tokens to be sold
310     /// @param _vaultAddress The address that will store the donated funds
311     /// @param _tokenAddress Address of the token contract this contract controls
312     /// @param _transfersAllowed if token transfers are allowed
313     /// @param _exchangeRate USD/ETH rate * 100
314     function TokenSale (
315         uint _startFundingTime,
316         uint _endFundingTime,
317         uint _tokenCap,
318         address _vaultAddress,
319         address _tokenAddress,
320         bool _transfersAllowed,
321         uint256 _exchangeRate
322     ) public {
323         require ((_endFundingTime >= now) &&           // Cannot end in the past
324             (_endFundingTime > _startFundingTime) &&
325             (_vaultAddress != 0));                    // To prevent burning ETH
326         startFundingTime = _startFundingTime;
327         endFundingTime = _endFundingTime;
328         tokenCap = _tokenCap;
329         tokenContract = ControlledToken(_tokenAddress);// The Deployed Token Contract
330         vaultAddress = _vaultAddress;
331         transfersAllowed = _transfersAllowed;
332         exchangeRate = _exchangeRate;
333         exchangeRateAt = block.number;
334     }
335 
336     /// @dev The fallback function is called when ether is sent to the contract, it
337     /// simply calls `doPayment()` with the address that sent the ether as the
338     /// `_owner`. Payable is a required solidity modifier for functions to receive
339     /// ether, without this modifier functions will throw if ether is sent to them
340     function ()  payable public {
341         doPayment(msg.sender);
342     }
343 
344 
345     /// @dev `doPayment()` is an internal function that sends the ether that this
346     ///  contract receives to the `vault` and creates tokens in the address of the
347     ///  `_owner` assuming the TokenSale is still accepting funds
348     /// @param _owner The address that will hold the newly created tokens
349 
350     function doPayment(address _owner) internal {
351 
352         // First check that the TokenSale is allowed to receive this donation
353         require ((now >= startFundingTime) &&
354             (now <= endFundingTime) &&
355             (tokenContract.controller() != 0) &&
356             (msg.value != 0) );
357 
358         uint256 tokensAmount = mul(msg.value, exchangeRate) / 100;
359 
360         require( totalTokenCount + tokensAmount <= tokenCap );
361 
362         //Track how much the TokenSale has collected
363         totalCollected += msg.value;
364 
365         //Send the ether to the vault
366         require (vaultAddress.call.gas(28000).value(msg.value)());
367 
368         // Creates an  amount of tokens base on ether sent and exchange rate. The new tokens are created
369         //  in the `_owner` address
370         require (tokenContract.generateTokens(_owner, tokensAmount));
371 
372         totalTokenCount += tokensAmount;
373 
374         return;
375     }
376 
377     function distributeTokens(address[] _owners, uint256[] _tokens) onlyOwner public {
378 
379         require( _owners.length == _tokens.length );
380         for(uint i=0;i<_owners.length;i++){
381             require (tokenContract.generateTokens(_owners[i], _tokens[i]));
382         }
383 
384     }
385 
386 
387     /// @notice `onlyOwner` changes the location that ether is sent
388     /// @param _newVaultAddress The address that will receive the ether sent to this token sale
389     function setVault(address _newVaultAddress) onlyOwner public{
390         vaultAddress = _newVaultAddress;
391     }
392 
393     /// @notice `onlyOwner` changes the setting to allow transfer tokens
394     /// @param _allow  allowing to transfer tokens
395     function setTransfersAllowed(bool _allow) onlyOwner public{
396         transfersAllowed = _allow;
397     }
398 
399     /// @notice `onlyOwner` changes the exchange rate of token to ETH
400     /// @param _exchangeRate USD/ETH rate * 100
401     function setExchangeRate(uint256 _exchangeRate) onlyOwner public{
402         exchangeRate = _exchangeRate;
403         exchangeRateAt = block.number;
404     }
405 
406     /// @notice `onlyOwner` changes the controller of the tokenContract
407     /// @param _newController - controller to be used with token
408     function changeController(address _newController) onlyOwner public {
409         tokenContract.changeController(_newController);
410     }
411 
412     /////////////////
413     // TokenController interface
414     /////////////////
415 
416     /// @notice `proxyPayment()` allows the caller to send ether to the TokenSale and
417     /// have the tokens created in an address of their choosing
418     /// @param _owner The address that will hold the newly created tokens
419 
420     function proxyPayment(address _owner) payable public returns(bool) {
421         doPayment(_owner);
422         return true;
423     }
424 
425 
426 
427     /// @notice Notifies the controller about a transfer, for this TokenSale all
428     ///  transfers are allowed by default and no extra notifications are needed
429     /// @param _from The origin of the transfer
430     /// @param _to The destination of the transfer
431     /// @param _amount The amount of the transfer
432     /// @return False if the controller does not authorize the transfer
433     function onTransfer(address _from, address _to, uint _amount) public returns(bool) {
434         return transfersAllowed;
435     }
436 
437     /// @notice Notifies the controller about an approval, for this TokenSale all
438     ///  approvals are allowed by default and no extra notifications are needed
439     /// @param _owner The address that calls `approve()`
440     /// @param _spender The spender in the `approve()` call
441     /// @param _amount The amount in the `approve()` call
442     /// @return False if the controller does not authorize the approval
443     function onApprove(address _owner, address _spender, uint _amount) public
444         returns(bool)
445     {
446         return transfersAllowed;
447     }
448 
449 
450 }