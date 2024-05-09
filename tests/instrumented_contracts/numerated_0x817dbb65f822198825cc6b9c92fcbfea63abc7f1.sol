1 pragma solidity ^0.4.11;
2 
3 
4 contract ERC20 {
5 
6   function balanceOf(address who) constant public returns (uint);
7   function allowance(address owner, address spender) constant public returns (uint);
8 
9   function transfer(address to, uint value) public returns (bool ok);
10   function transferFrom(address from, address to, uint value) public returns (bool ok);
11   function approve(address spender, uint value) public returns (bool ok);
12 
13   event Transfer(address indexed from, address indexed to, uint value);
14   event Approval(address indexed owner, address indexed spender, uint value);
15 
16 }
17 
18 
19 
20 
21 
22 // Controller for Token interface
23 // Taken from https://github.com/Giveth/minime/blob/master/contracts/MiniMeToken.sol
24 
25 /// @dev The token controller contract must implement these functions
26 contract TokenController {
27     /// @notice Called when `_owner` sends ether to the Token contract
28     /// @param _owner The address that sent the ether to create tokens
29     /// @return True if the ether is accepted, false if it throws
30     function proxyPayment(address _owner) payable public returns(bool);
31 
32     /// @notice Notifies the controller about a token transfer allowing the
33     ///  controller to react if desired
34     /// @param _from The origin of the transfer
35     /// @param _to The destination of the transfer
36     /// @param _amount The amount of the transfer
37     /// @return False if the controller does not authorize the transfer
38     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
39 
40     /// @notice Notifies the controller about an approval allowing the
41     ///  controller to react if desired
42     /// @param _owner The address that calls `approve()`
43     /// @param _spender The spender in the `approve()` call
44     /// @param _amount The amount in the `approve()` call
45     /// @return False if the controller does not authorize the approval
46     function onApprove(address _owner, address _spender, uint _amount) public
47         returns(bool);
48 }
49 
50 
51 contract Controlled {
52     /// @notice The address of the controller is the only address that can call
53     ///  a function with this modifier
54     modifier onlyController { require(msg.sender == controller); _; }
55 
56     address public controller;
57 
58     function Controlled() public { controller = msg.sender;}
59 
60     /// @notice Changes the controller of the contract
61     /// @param _newController The new controller of the contract
62     function changeController(address _newController) onlyController public {
63         controller = _newController;
64     }
65 }
66 
67 
68 contract ControlledToken is ERC20, Controlled {
69 
70     uint256 constant MAX_UINT256 = 2**256 - 1;
71 
72     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
73 
74     /* Public variables of the token */
75 
76     /*
77     NOTE:
78     The following variables are OPTIONAL vanities. One does not have to include them.
79     They allow one to customise the token contract & in no way influences the core functionality.
80     Some wallets/interfaces might not even bother to look at this information.
81     */
82     string public name;                   //fancy name: eg Simon Bucks
83     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
84     string public symbol;                 //An identifier: eg SBX
85     string public version = '1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
86     uint256 public totalSupply;
87 
88     function ControlledToken(
89         uint256 _initialAmount,
90         string _tokenName,
91         uint8 _decimalUnits,
92         string _tokenSymbol
93         ) {
94         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
95         totalSupply = _initialAmount;                        // Update total supply
96         name = _tokenName;                                   // Set the name for display purposes
97         decimals = _decimalUnits;                            // Amount of decimals for display purposes
98         symbol = _tokenSymbol;                               // Set the symbol for display purposes
99     }
100 
101 
102     function transfer(address _to, uint256 _value) returns (bool success) {
103         //Default assumes totalSupply can't be over max (2^256 - 1).
104         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
105         //Replace the if with this one instead.
106         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
107         require(balances[msg.sender] >= _value);
108 
109         if (isContract(controller)) {
110             require(TokenController(controller).onTransfer(msg.sender, _to, _value));
111         }
112 
113         balances[msg.sender] -= _value;
114         balances[_to] += _value;
115         // Alerts the token controller of the transfer
116 
117         Transfer(msg.sender, _to, _value);
118         return true;
119     }
120 
121     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
122         //same as above. Replace this line with the following if you want to protect against wrapping uints.
123         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
124         uint256 allowance = allowed[_from][msg.sender];
125         require(balances[_from] >= _value && allowance >= _value);
126 
127         if (isContract(controller)) {
128             require(TokenController(controller).onTransfer(_from, _to, _value));
129         }
130 
131         balances[_to] += _value;
132         balances[_from] -= _value;
133         if (allowance < MAX_UINT256) {
134             allowed[_from][msg.sender] -= _value;
135         }
136         Transfer(_from, _to, _value);
137         return true;
138     }
139 
140     function balanceOf(address _owner) constant returns (uint256 balance) {
141         return balances[_owner];
142     }
143 
144     function approve(address _spender, uint256 _value) returns (bool success) {
145 
146         // Alerts the token controller of the approve function call
147         if (isContract(controller)) {
148             require(TokenController(controller).onApprove(msg.sender, _spender, _value));
149         }
150 
151         allowed[msg.sender][_spender] = _value;
152         Approval(msg.sender, _spender, _value);
153         return true;
154     }
155 
156     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
157       return allowed[_owner][_spender];
158     }
159 
160     ////////////////
161 // Generate and destroy tokens
162 ////////////////
163 
164     /// @notice Generates `_amount` tokens that are assigned to `_owner`
165     /// @param _owner The address that will be assigned the new tokens
166     /// @param _amount The quantity of tokens generated
167     /// @return True if the tokens are generated correctly
168     function generateTokens(address _owner, uint _amount ) onlyController returns (bool) {
169         uint curTotalSupply = totalSupply;
170         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
171         uint previousBalanceTo = balanceOf(_owner);
172         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
173         totalSupply = curTotalSupply + _amount;
174         balances[_owner]  = previousBalanceTo + _amount;
175         Transfer(0, _owner, _amount);
176         return true;
177     }
178 
179 
180     /// @notice Burns `_amount` tokens from `_owner`
181     /// @param _owner The address that will lose the tokens
182     /// @param _amount The quantity of tokens to burn
183     /// @return True if the tokens are burned correctly
184     function destroyTokens(address _owner, uint _amount
185     ) onlyController returns (bool) {
186         uint curTotalSupply = totalSupply;
187         require(curTotalSupply >= _amount);
188         uint previousBalanceFrom = balanceOf(_owner);
189         require(previousBalanceFrom >= _amount);
190         totalSupply = curTotalSupply - _amount;
191         balances[_owner] = previousBalanceFrom - _amount;
192         Transfer(_owner, 0, _amount);
193         return true;
194     }
195 
196     /// @notice The fallback function: If the contract's controller has not been
197     ///  set to 0, then the `proxyPayment` method is called which relays the
198     ///  ether and creates tokens as described in the token controller contract
199     function ()  payable {
200         require(isContract(controller));
201         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
202     }
203 
204     /// @dev Internal function to determine if an address is a contract
205     /// @param _addr The address being queried
206     /// @return True if `_addr` is a contract
207     function isContract(address _addr) constant internal returns(bool) {
208         uint size;
209         if (_addr == 0) return false;
210         assembly {
211             size := extcodesize(_addr)
212         }
213         return size>0;
214     }
215 
216     /// @notice This method can be used by the controller to extract mistakenly
217     ///  sent tokens to this contract.
218     /// @param _token The address of the token contract that you want to recover
219     ///  set to 0 in case you want to extract ether.
220     function claimTokens(address _token) onlyController {
221         if (_token == 0x0) {
222             controller.transfer(this.balance);
223             return;
224         }
225 
226         ControlledToken token = ControlledToken(_token);
227         uint balance = token.balanceOf(this);
228         token.transfer(controller, balance);
229         ClaimedTokens(_token, controller, balance);
230     }
231 
232 
233     mapping (address => uint256) balances;
234     mapping (address => mapping (address => uint256)) allowed;
235 
236 
237 }
238 
239 
240 
241 /// `Owned` is a base level contract that assigns an `owner` that can be later changed
242 contract Owned {
243     /// @dev `owner` is the only address that can call a function with this
244     /// modifier
245     modifier onlyOwner { require (msg.sender == owner); _; }
246 
247     address public owner;
248 
249     /// @notice The Constructor assigns the message sender to be `owner`
250     function Owned() { owner = msg.sender;}
251 
252     /// @notice `owner` can step down and assign some other address to this role
253     /// @param _newOwner The address of the new owner. 0x0 can be used to create
254     ///  an unowned neutral vault, however that cannot be undone
255     function changeOwner(address _newOwner)  onlyOwner {
256         owner = _newOwner;
257     }
258 }
259 
260 /**
261  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
262  * @title SafeMath
263  * @dev Math operations with safety checks that throw on error
264  *
265  */
266 contract SafeMath {
267   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
268     if (a == 0) {
269       return 0;
270     }
271     uint256 c = a * b;
272     assert(c / a == b);
273     return c;
274   }
275 
276   function div(uint256 a, uint256 b) internal pure returns (uint256) {
277     // assert(b > 0); // Solidity automatically throws when dividing by 0
278     uint256 c = a / b;
279     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
280     return c;
281   }
282 
283   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
284     assert(b <= a);
285     return a - b;
286   }
287 
288   function add(uint256 a, uint256 b) internal pure returns (uint256) {
289     uint256 c = a + b;
290     assert(c >= a);
291     return c;
292   }
293 }
294 
295 
296 contract TokenSaleAfterSplit is TokenController, Owned, SafeMath {
297 
298 
299     uint public startFundingTime;           // In UNIX Time Format
300     uint public endFundingTime;             // In UNIX Time Format
301 
302     uint public tokenCap;                   // Maximum amount of tokens to be distributed
303     uint public totalTokenCount;            // Actual amount of tokens distributed
304 
305     uint public totalCollected;             // In wei
306     ControlledToken public tokenContract;   // The new token for this TokenSale
307     address public vaultAddress;            // The address to hold the funds donated
308     bool public transfersAllowed;           // If the token transfers are allowed
309     uint256 public exchangeRate;            // USD/ETH rate * 100
310     uint public exchangeRateAt;             // Block number when exchange rate was set
311 
312     /// @notice 'TokenSale()' initiates the TokenSale by setting its funding
313     /// parameters
314     /// @dev There are several checks to make sure the parameters are acceptable
315     /// @param _startFundingTime The UNIX time that the TokenSale will be able to
316     /// start receiving funds
317     /// @param _endFundingTime The UNIX time that the TokenSale will stop being able
318     /// to receive funds
319     /// @param _tokenCap Maximum amount of tokens to be sold
320     /// @param _vaultAddress The address that will store the donated funds
321     /// @param _tokenAddress Address of the token contract this contract controls
322     /// @param _transfersAllowed if token transfers are allowed
323     /// @param _exchangeRate USD/ETH rate * 100
324     function TokenSaleAfterSplit (
325         uint _startFundingTime,
326         uint _endFundingTime,
327         uint _tokenCap,
328         address _vaultAddress,
329         address _tokenAddress,
330         bool _transfersAllowed,
331         uint256 _exchangeRate
332     ) public {
333         require ((_endFundingTime >= now) &&           // Cannot end in the past
334             (_endFundingTime > _startFundingTime) &&
335             (_vaultAddress != 0));                    // To prevent burning ETH
336         startFundingTime = _startFundingTime;
337         endFundingTime = _endFundingTime;
338         tokenCap = _tokenCap;
339         tokenContract = ControlledToken(_tokenAddress);// The Deployed Token Contract
340         vaultAddress = _vaultAddress;
341         transfersAllowed = _transfersAllowed;
342         exchangeRate = _exchangeRate;
343         exchangeRateAt = block.number;
344     }
345 
346     /// @dev The fallback function is called when ether is sent to the contract, it
347     /// simply calls `doPayment()` with the address that sent the ether as the
348     /// `_owner`. Payable is a required solidity modifier for functions to receive
349     /// ether, without this modifier functions will throw if ether is sent to them
350     function ()  payable public {
351         doPayment(msg.sender);
352     }
353 
354 
355     /// @dev `doPayment()` is an internal function that sends the ether that this
356     ///  contract receives to the `vault` and creates tokens in the address of the
357     ///  `_owner` assuming the TokenSale is still accepting funds
358     /// @param _owner The address that will hold the newly created tokens
359 
360     function doPayment(address _owner) internal {
361 
362         // First check that the TokenSale is allowed to receive this donation
363         require ((now >= startFundingTime) &&
364             (now <= endFundingTime) &&
365             (tokenContract.controller() != 0) &&
366             (msg.value != 0) );
367 
368         uint256 tokensAmount = mul(msg.value, exchangeRate);
369 
370         require( totalTokenCount + tokensAmount <= tokenCap );
371 
372         //Track how much the TokenSale has collected
373         totalCollected += msg.value;
374 
375         //Send the ether to the vault
376         require (vaultAddress.call.gas(28000).value(msg.value)());
377 
378         // Creates an  amount of tokens base on ether sent and exchange rate. The new tokens are created
379         //  in the `_owner` address
380         require (tokenContract.generateTokens(_owner, tokensAmount));
381 
382         totalTokenCount += tokensAmount;
383 
384         return;
385     }
386 
387     function distributeTokens(address[] _owners, uint256[] _tokens) onlyOwner public {
388 
389         require( _owners.length == _tokens.length );
390         for(uint i=0;i<_owners.length;i++){
391             require (tokenContract.generateTokens(_owners[i], _tokens[i]));
392         }
393 
394     }
395 
396 
397     /// @notice `onlyOwner` changes the location that ether is sent
398     /// @param _newVaultAddress The address that will receive the ether sent to this token sale
399     function setVault(address _newVaultAddress) onlyOwner public{
400         vaultAddress = _newVaultAddress;
401     }
402 
403     /// @notice `onlyOwner` changes the setting to allow transfer tokens
404     /// @param _allow  allowing to transfer tokens
405     function setTransfersAllowed(bool _allow) onlyOwner public{
406         transfersAllowed = _allow;
407     }
408 
409     /// @notice `onlyOwner` changes the exchange rate of token to ETH
410     /// @param _exchangeRate USD/ETH rate * 100
411     function setExchangeRate(uint256 _exchangeRate) onlyOwner public{
412         exchangeRate = _exchangeRate;
413         exchangeRateAt = block.number;
414     }
415 
416     /// @notice `onlyOwner` changes the controller of the tokenContract
417     /// @param _newController - controller to be used with token
418     function changeController(address _newController) onlyOwner public {
419         tokenContract.changeController(_newController);
420     }
421 
422     /////////////////
423     // TokenController interface
424     /////////////////
425 
426     /// @notice `proxyPayment()` allows the caller to send ether to the TokenSale and
427     /// have the tokens created in an address of their choosing
428     /// @param _owner The address that will hold the newly created tokens
429 
430     function proxyPayment(address _owner) payable public returns(bool) {
431         doPayment(_owner);
432         return true;
433     }
434 
435 
436 
437     /// @notice Notifies the controller about a transfer, for this TokenSale all
438     ///  transfers are allowed by default and no extra notifications are needed
439     /// @param _from The origin of the transfer
440     /// @param _to The destination of the transfer
441     /// @param _amount The amount of the transfer
442     /// @return False if the controller does not authorize the transfer
443     function onTransfer(address _from, address _to, uint _amount) public returns(bool) {
444         return transfersAllowed;
445     }
446 
447     /// @notice Notifies the controller about an approval, for this TokenSale all
448     ///  approvals are allowed by default and no extra notifications are needed
449     /// @param _owner The address that calls `approve()`
450     /// @param _spender The spender in the `approve()` call
451     /// @param _amount The amount in the `approve()` call
452     /// @return False if the controller does not authorize the approval
453     function onApprove(address _owner, address _spender, uint _amount) public
454         returns(bool)
455     {
456         return transfersAllowed;
457     }
458 
459 
460 }