1 pragma solidity ^0.4.18;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() constant returns (uint256 supply) {}
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) constant returns (uint256 balance) {}
11 
12     /// @notice send `_value` token to `_to` from `msg.sender`
13     /// @param _to The address of the recipient
14     /// @param _value The amount of tovimken to be transferred
15     /// @return Whether the transfer was successful or not
16     function transfer(address _to, uint256 _value) returns (bool success) {}
17 
18     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
19     /// @param _from The address of the sender
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
24 
25     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @param _value The amount of wei to be approved for transfer
28     /// @return Whether the approval was successful or not
29     function approve(address _spender, uint256 _value) returns (bool success) {}
30 
31     /// @param _owner The address of the account owning tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @return Amount of remaining tokens allowed to spent
34     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
35 
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 }
39 
40 
41 /*
42 This implements ONLY the standard functions and NOTHING else.
43 For a token like you would want to deploy in something like Mist, see HumanStandardToken.sol.
44 
45 If you deploy this, you won't have anything useful.
46 
47 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
48 .*/
49 
50 contract StandardToken is Token {
51 
52     function transfer(address _to, uint256 _value) returns (bool success) {
53         //Default assumes totalSupply can't be over max (2^256 - 1).
54         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
55         //Replace the if with this one instead.
56         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
57         if (balances[msg.sender] >= _value && _value > 0) {
58             balances[msg.sender] -= _value;
59             balances[_to] += _value;
60             Transfer(msg.sender, _to, _value);
61             return true;
62         } else { return false; }
63     }
64 
65     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
66         //same as above. Replace this line with the following if you want to protect against wrapping uints.
67         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
68         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
69             balances[_to] += _value;
70             balances[_from] -= _value;
71             allowed[_from][msg.sender] -= _value;
72             Transfer(_from, _to, _value);
73             return true;
74         } else { return false; }
75     }
76 
77     function balanceOf(address _owner) constant returns (uint256 balance) {
78         return balances[_owner];
79     }
80 
81     function approve(address _spender, uint256 _value) returns (bool success) {
82         allowed[msg.sender][_spender] = _value;
83         Approval(msg.sender, _spender, _value);
84         return true;
85     }
86 
87     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
88       return allowed[_owner][_spender];
89     }
90 
91     mapping (address => uint256) balances;
92     mapping (address => mapping (address => uint256)) allowed;
93     uint256 public totalSupply;
94 }
95 
96 /*
97 This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
98 
99 In other words. This is intended for deployment in something like a Token Factory or Mist wallet, and then used by humans.
100 Imagine coins, currencies, shares, voting weight, etc.
101 Machine-based, rapid creation of many tokens would not necessarily need these extra features or will be minted in other manners.
102 
103 1) Initial Finite Supply (upon creation one specifies how much is minted).
104 2) In the absence of a token registry: Optional Decimal, Symbol & Name.
105 3) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.
106 
107 .*/
108 
109 contract HumanStandardToken is StandardToken {
110 
111     function () {
112         //if ether is sent to this address, send it back.
113         throw;
114     }
115 
116     /* Public variables of the token */
117 
118     /*
119     NOTE:
120     The following variables are OPTIONAL vanities. One does not have to include them.
121     They allow one to customise the token contract & in no way influences the core functionality.
122     Some wallets/interfaces might not even bother to look at this information.
123     */
124     string public name;                   //fancy name: eg Simon Bucks
125     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
126     string public symbol;                 //An identifier: eg SBX
127     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
128 
129     function HumanStandardToken(
130         uint256 _initialAmount,
131         string _tokenName,
132         uint8 _decimalUnits,
133         string _tokenSymbol
134         ) {
135         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
136         totalSupply = _initialAmount;                        // Update total supply
137         name = _tokenName;                                   // Set the name for display purposes
138         decimals = _decimalUnits;                            // Amount of decimals for display purposes
139         symbol = _tokenSymbol;                               // Set the symbol for display purposes
140     }
141 
142     /* Approves and then calls the receiving contract */
143     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
144         allowed[msg.sender][_spender] = _value;
145         Approval(msg.sender, _spender, _value);
146         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
147         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
148         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
149         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
150         
151         return true;
152     }
153 
154 }
155 
156 /**
157  * @title ERC20Basic
158  * @dev Simpler version of ERC20 interface
159  * @dev see https://github.com/ethereum/EIPs/issues/179
160  */
161 contract ERC20Basic {
162   uint256 public totalSupply;
163   function balanceOf(address who) public view returns (uint256);
164   function transfer(address to, uint256 value) public returns (bool);
165   event Transfer(address indexed from, address indexed to, uint256 value);
166 }
167 
168 /**
169  * @title ERC20 interface
170  * @dev see https://github.com/ethereum/EIPs/issues/20
171  */
172 contract ERC20 is ERC20Basic {
173   function allowance(address owner, address spender) public view returns (uint256);
174   function transferFrom(address from, address to, uint256 value) public returns (bool);
175   function approve(address spender, uint256 value) public returns (bool);
176   event Approval(address indexed owner, address indexed spender, uint256 value);
177 }
178 
179 /**
180  * @title SafeMath
181  * @dev Math operations with safety checks that throw on error
182  */
183 library SafeMath {
184   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185     if (a == 0) {
186       return 0;
187     }
188     uint256 c = a * b;
189     assert(c / a == b);
190     return c;
191   }
192 
193   function div(uint256 a, uint256 b) internal pure returns (uint256) {
194     // assert(b > 0); // Solidity automatically throws when dividing by 0
195     uint256 c = a / b;
196     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
197     return c;
198   }
199 
200   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
201     assert(b <= a);
202     return a - b;
203   }
204 
205   function add(uint256 a, uint256 b) internal pure returns (uint256) {
206     uint256 c = a + b;
207     assert(c >= a);
208     return c;
209   }
210 }
211 
212 /**
213  * @title Ownable
214  * @dev The Ownable contract has an owner address, and provides basic authorization control
215  * functions, this simplifies the implementation of "user permissions".
216  */
217 contract Ownable {
218   address public owner;
219 
220 
221   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
222 
223 
224   /**
225    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
226    * account.
227    */
228   function Ownable() public {
229     owner = msg.sender;
230   }
231 
232 
233   /**
234    * @dev Throws if called by any account other than the owner.
235    */
236   modifier onlyOwner() {
237     require(msg.sender == owner);
238     _;
239   }
240 
241 
242   /**
243    * @dev Allows the current owner to transfer control of the contract to a newOwner.
244    * @param newOwner The address to transfer ownership to.
245    */
246   function transferOwnership(address newOwner) public onlyOwner {
247     require(newOwner != address(0));
248     OwnershipTransferred(owner, newOwner);
249     owner = newOwner;
250   }
251 
252 }
253 
254 /// @title Token Swap Contract for Neverdie
255 /// @author Julia Altenried, Yuriy Kashnikov
256 contract TokenSwap is Ownable {
257 
258     /* neverdie token contract address and its instance, can be set by owner only */
259     HumanStandardToken public ndc;
260     /* neverdie token contract address and its instance, can be set by owner only */
261     HumanStandardToken public tpt;
262     /* signer address, verified in 'swap' method, can be set by owner only */
263     address public neverdieSigner;
264     /* minimal amount for swap, the amount passed to 'swap method can't be smaller
265        than this value, can be set by owner only */
266     uint256 public minSwapAmount = 40;
267 
268     event Swap(
269         address indexed to,
270         address indexed PTaddress,
271         uint256 rate,
272         uint256 amount,
273         uint256 ptAmount
274     );
275 
276     event BuyNDC(
277         address indexed to,
278         uint256 NDCprice,
279         uint256 value,
280         uint256 amount
281     );
282 
283     event BuyTPT(
284         address indexed to,
285         uint256 TPTprice,
286         uint256 value,
287         uint256 amount
288     );
289 
290     /// @dev handy constructor to initialize TokenSwap with a set of proper parameters
291     /// NOTE: min swap amount is left with default value, set it manually if needed
292     /// @param _teleportContractAddress Teleport token address 
293     /// @param _neverdieContractAddress Neverdie token address
294     /// @param _signer signer address, verified further in swap functions
295     function TokenSwap(address _teleportContractAddress, address _neverdieContractAddress, address _signer) public {
296         tpt = HumanStandardToken(_teleportContractAddress);
297         ndc = HumanStandardToken(_neverdieContractAddress);
298         neverdieSigner = _signer;
299     }
300 
301     function setTeleportContractAddress(address _to) external onlyOwner {
302         tpt = HumanStandardToken(_to);
303     }
304 
305     function setNeverdieContractAddress(address _to) external onlyOwner {
306         ndc = HumanStandardToken(_to);
307     }
308 
309     function setNeverdieSignerAddress(address _to) external onlyOwner {
310         neverdieSigner = _to;
311     }
312 
313     function setMinSwapAmount(uint256 _amount) external onlyOwner {
314         minSwapAmount = _amount;
315     }
316 
317     /// @dev receiveApproval calls function encoded as extra data
318     /// @param _sender token sender
319     /// @param _value value allowed to be spent
320     /// @param _tokenContract callee, should be equal to neverdieContractAddress
321     /// @param _extraData  this should be a well formed calldata with function signature preceding which is used to call, for example, 'swap' method
322     function receiveApproval(address _sender, uint256 _value, address _tokenContract, bytes _extraData) external {
323         require(_tokenContract == address(ndc));
324         assert(this.call(_extraData));
325     }
326 
327     
328 
329     /// @dev One-way swapFor function, swaps NDC for purchasable token for a given spender
330     /// @param _spender account that wants to swap NDC for purchasable token 
331     /// @param _rate current NDC to purchasable token rate, i.e. that the returned amount 
332     ///              of purchasable tokens equals to (_amount * _rate) / 1000
333     /// @param _PTaddress the address of the purchasable token  
334     /// @param _amount amount of NDC being offered
335     /// @param _expiration expiration timestamp 
336     /// @param _v ECDCA signature
337     /// @param _r ECDSA signature
338     /// @param _s ECDSA signature
339     function swapFor(address _spender,
340                      uint256 _rate,
341                      address _PTaddress,
342                      uint256 _amount,
343                      uint256 _expiration,
344                      uint8 _v,
345                      bytes32 _r,
346                      bytes32 _s) public {
347 
348         // Check if the signature did not expire yet by inspecting the timestamp
349         require(_expiration >= block.timestamp);
350 
351         // Check if the signature is coming from the neverdie signer address
352         address signer = ecrecover(keccak256(_spender, _rate, _PTaddress, _amount, _expiration), _v, _r, _s);
353         require(signer == neverdieSigner);
354 
355         // Check if the amount of NDC is higher than the minimum amount 
356         require(_amount >= minSwapAmount);
357        
358         // Check that we hold enough tokens
359         HumanStandardToken ptoken = HumanStandardToken(_PTaddress);
360         uint256 ptAmount;
361         uint8 decimals = ptoken.decimals();
362         if (decimals <= 18) {
363           ptAmount = SafeMath.div(SafeMath.div(SafeMath.mul(_amount, _rate), 1000), 10**(uint256(18 - decimals)));
364         } else {
365           ptAmount = SafeMath.div(SafeMath.mul(SafeMath.mul(_amount, _rate), 10**(uint256(decimals - 18))), 1000);
366         }
367 
368         assert(ndc.transferFrom(_spender, this, _amount) && ptoken.transfer(_spender, ptAmount));
369 
370         // Emit Swap event
371         Swap(_spender, _PTaddress, _rate, _amount, ptAmount);
372     }
373 
374     /// @dev One-way swap function, swaps NDC to purchasable tokens
375     /// @param _rate current NDC to purchasable token rate, i.e. that the returned amount of purchasable tokens equals to _amount * _rate 
376     /// @param _PTaddress the address of the purchasable token  
377     /// @param _amount amount of NDC being offered
378     /// @param _expiration expiration timestamp 
379     /// @param _v ECDCA signature
380     /// @param _r ECDSA signature
381     /// @param _s ECDSA signature
382     function swap(uint256 _rate,
383                   address _PTaddress,
384                   uint256 _amount,
385                   uint256 _expiration,
386                   uint8 _v,
387                   bytes32 _r,
388                   bytes32 _s) external {
389         swapFor(msg.sender, _rate, _PTaddress, _amount, _expiration, _v, _r, _s);
390     }
391 
392     /// @dev buy NDC with ether
393     /// @param _NDCprice NDC price in Wei
394     /// @param _expiration expiration timestamp
395     /// @param _v ECDCA signature
396     /// @param _r ECDSA signature
397     /// @param _s ECDSA signature
398     function buyNDC(uint256 _NDCprice,
399                     uint256 _expiration,
400                     uint8 _v,
401                     bytes32 _r,
402                     bytes32 _s
403                    ) payable external {
404         // Check if the signature did not expire yet by inspecting the timestamp
405         require(_expiration >= block.timestamp);
406 
407         // Check if the signature is coming from the neverdie address
408         address signer = ecrecover(keccak256(_NDCprice, _expiration), _v, _r, _s);
409         require(signer == neverdieSigner);
410 
411         uint256 a = SafeMath.div(SafeMath.mul(msg.value, 10**18), _NDCprice);
412         assert(ndc.transfer(msg.sender, a));
413 
414         // Emit BuyNDC event
415         BuyNDC(msg.sender, _NDCprice, msg.value, a);
416     }
417 
418     /// @dev buy TPT with ether
419     /// @param _TPTprice TPT price in Wei
420     /// @param _expiration expiration timestamp
421     /// @param _v ECDCA signature
422     /// @param _r ECDSA signature
423     /// @param _s ECDSA signature
424     function buyTPT(uint256 _TPTprice,
425                     uint256 _expiration,
426                     uint8 _v,
427                     bytes32 _r,
428                     bytes32 _s
429                    ) payable external {
430         // Check if the signature did not expire yet by inspecting the timestamp
431         require(_expiration >= block.timestamp);
432 
433         // Check if the signature is coming from the neverdie address
434         address signer = ecrecover(keccak256(_TPTprice, _expiration), _v, _r, _s);
435         require(signer == neverdieSigner);
436 
437         uint256 a = SafeMath.div(SafeMath.mul(msg.value, 10**18), _TPTprice);
438         assert(tpt.transfer(msg.sender, a));
439 
440         // Emit BuyNDC event
441         BuyTPT(msg.sender, _TPTprice, msg.value, a);
442     }
443 
444     /// @dev fallback function to reject any ether coming directly to the contract
445     function () payable public { 
446         revert(); 
447     }
448 
449     /// @dev withdraw all ether
450     function withdrawEther() external onlyOwner {
451         owner.transfer(this.balance);
452     }
453 
454     /// @dev withdraw token
455     /// @param _tokenContract any kind of ERC20 token to withdraw from
456     function withdraw(address _tokenContract) external onlyOwner {
457         ERC20 token = ERC20(_tokenContract);
458         uint256 balance = token.balanceOf(this);
459         assert(token.transfer(owner, balance));
460     }
461 
462     /// @dev kill contract, but before transfer all TPT, NDC tokens and ether to owner
463     function kill() onlyOwner public {
464         uint256 allNDC = ndc.balanceOf(this);
465         uint256 allTPT = tpt.balanceOf(this);
466         assert(ndc.transfer(owner, allNDC) && tpt.transfer(owner, allTPT));
467         selfdestruct(owner);
468     }
469 
470 }