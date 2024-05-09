1 pragma solidity ^0.4.18;
2 
3 pragma solidity ^0.4.18;
4 
5 contract Token {
6 
7     /// @return total amount of tokens
8     function totalSupply() public constant returns (uint256 supply) {}
9 
10     /// @param _owner The address from which the balance will be retrieved
11     /// @return The balance
12     function balanceOf(address _owner) public constant returns (uint256 balance) {}
13 
14     /// @notice send `_value` token to `_to` from `msg.sender`
15     /// @param _to The address of the recipient
16     /// @param _value The amount of token to be transferred
17     /// @return Whether the transfer was successful or not
18     function transfer(address _to, uint256 _value) public returns (bool success) {}
19 
20     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
21     /// @param _from The address of the sender
22     /// @param _to The address of the recipient
23     /// @param _value The amount of token to be transferred
24     /// @return Whether the transfer was successful or not
25     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
26 
27     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
28     /// @param _spender The address of the account able to transfer the tokens
29     /// @param _value The amount of wei to be approved for transfer
30     /// @return Whether the approval was successful or not
31     function approve(address _spender, uint256 _value) public returns (bool success) {}
32 
33     /// @param _owner The address of the account owning tokens
34     /// @param _spender The address of the account able to transfer the tokens
35     /// @return Amount of remaining tokens allowed to spent
36     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {}
37 
38     event Transfer(address indexed _from, address indexed _to, uint256 _value);
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 }
41 
42 
43 /*
44 This implements ONLY the standard functions and NOTHING else.
45 For a token like you would want to deploy in something like Mist, see HumanStandardToken.sol.
46 
47 If you deploy this, you won't have anything useful.
48 
49 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
50 .*/
51 
52 contract StandardToken is Token {
53 
54     mapping (address => uint256) balances;
55     mapping (address => mapping (address => uint256)) allowed;
56     uint256 public totalSupply;
57 }
58 
59 /*
60 This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
61 
62 In other words. This is intended for deployment in something like a Token Factory or Mist wallet, and then used by humans.
63 Imagine coins, currencies, shares, voting weight, etc.
64 Machine-based, rapid creation of many tokens would not necessarily need these extra features or will be minted in other manners.
65 
66 1) Initial Finite Supply (upon creation one specifies how much is minted).
67 2) In the absence of a token registry: Optional Decimal, Symbol & Name.
68 3) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.
69 
70 .*/
71 
72 contract HumanStandardToken is StandardToken {
73 
74     //What is this function?
75     function () {
76         //if ether is sent to this address, send it back.
77         throw;
78     }
79 
80     /* Public variables of the token */
81 
82     /*
83     NOTE:
84     The following variables are OPTIONAL vanities. One does not have to include them.
85     They allow one to customise the token contract & in no way influences the core functionality.
86     Some wallets/interfaces might not even bother to look at this information.
87     */
88     string public name;                   //fancy name: eg Simon Bucks
89     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
90     string public symbol;                 //An identifier: eg SBX
91     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
92 
93     function HumanStandardToken(
94         uint256 _initialAmount,
95         string _tokenName,
96         uint8 _decimalUnits,
97         string _tokenSymbol
98         ) public {
99         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
100         totalSupply = _initialAmount;                        // Update total supply
101         name = _tokenName;                                   // Set the name for display purposes
102         decimals = _decimalUnits;                            // Amount of decimals for display purposes
103         symbol = _tokenSymbol;                               // Set the symbol for display purposes
104     }
105 
106 
107 }
108 /**
109  * @title ERC20Basic
110  * @dev Simpler version of ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/179
112  */
113 contract ERC20Basic {
114   function totalSupply() public view returns (uint256);
115   function balanceOf(address who) public view returns (uint256);
116   function transfer(address to, uint256 value) public returns (bool);
117   event Transfer(address indexed from, address indexed to, uint256 value);
118 }
119 
120 /**
121  * @title ERC20 interface
122  * @dev see https://github.com/ethereum/EIPs/issues/20
123  */
124 contract ERC20 is ERC20Basic {
125   function allowance(address owner, address spender) public view returns (uint256);
126   function transferFrom(address from, address to, uint256 value) public returns (bool);
127   function approve(address spender, uint256 value) public returns (bool);
128   event Approval(address indexed owner, address indexed spender, uint256 value);
129 }
130 
131 /**
132  * @title SafeMath
133  * @dev Math operations with safety checks that throw on error
134  */
135 library SafeMath {
136 
137   /**
138   * @dev Multiplies two numbers, throws on overflow.
139   */
140   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
141     if (a == 0) {
142       return 0;
143     }
144     uint256 c = a * b;
145     assert(c / a == b);
146     return c;
147   }
148 
149   /**
150   * @dev Integer division of two numbers, truncating the quotient.
151   */
152   function div(uint256 a, uint256 b) internal pure returns (uint256) {
153     // assert(b > 0); // Solidity automatically throws when dividing by 0
154     // uint256 c = a / b;
155     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
156     return a / b;
157   }
158 
159   /**
160   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
161   */
162   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
163     assert(b <= a);
164     return a - b;
165   }
166 
167   /**
168   * @dev Adds two numbers, throws on overflow.
169   */
170   function add(uint256 a, uint256 b) internal pure returns (uint256) {
171     uint256 c = a + b;
172     assert(c >= a);
173     return c;
174   }
175 }
176 
177 /**
178  * @title Ownable
179  * @dev The Ownable contract has an owner address, and provides basic authorization control
180  * functions, this simplifies the implementation of "user permissions".
181  */
182 contract Ownable {
183   address public owner;
184 
185 
186   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
187 
188 
189   /**
190    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
191    * account.
192    */
193   function Ownable() public {
194     owner = msg.sender;
195   }
196 
197   /**
198    * @dev Throws if called by any account other than the owner.
199    */
200   modifier onlyOwner() {
201     require(msg.sender == owner);
202     _;
203   }
204 
205   /**
206    * @dev Allows the current owner to transfer control of the contract to a newOwner.
207    * @param newOwner The address to transfer ownership to.
208    */
209   function transferOwnership(address newOwner) public onlyOwner {
210     require(newOwner != address(0));
211     emit OwnershipTransferred(owner, newOwner);
212     owner = newOwner;
213   }
214 
215 }
216 
217 /// @title Token Swap Contract for Neverdie
218 /// @author Julia Altenried, Yuriy Kashnikov
219 contract TokenSwap is Ownable {
220 
221     /* neverdie token contract address and its instance, can be set by owner only */
222     HumanStandardToken ndc;
223     /* neverdie token contract address and its instance, can be set by owner only */
224     HumanStandardToken tpt;
225     /* signer address, verified in 'swap' method, can be set by owner only */
226     address neverdieSigner;
227     /* minimal amount for swap, the amount passed to 'swap method can't be smaller
228        than this value, can be set by owner only */
229     uint256 minSwapAmount = 40;
230 
231     event Swap(
232         address indexed to,
233         address indexed PTaddress,
234         uint256 rate,
235         uint256 amount,
236         uint256 ptAmount
237     );
238 
239     event BuyNDC(
240         address indexed to,
241         uint256 NDCprice,
242         uint256 value,
243         uint256 amount
244     );
245 
246     event BuyTPT(
247         address indexed to,
248         uint256 TPTprice,
249         uint256 value,
250         uint256 amount
251     );
252 
253     /// @dev handy constructor to initialize TokenSwap with a set of proper parameters
254     /// NOTE: min swap amount is left with default value, set it manually if needed
255     /// @param _teleportContractAddress Teleport token address 
256     /// @param _neverdieContractAddress Neverdie token address
257     /// @param _signer signer address, verified further in swap functions
258     function TokenSwap(address _teleportContractAddress, address _neverdieContractAddress, address _signer) public {
259         tpt = HumanStandardToken(_teleportContractAddress);
260         ndc = HumanStandardToken(_neverdieContractAddress);
261         neverdieSigner = _signer;
262     }
263 
264     function setTeleportContractAddress(address _to) external onlyOwner {
265         tpt = HumanStandardToken(_to);
266     }
267 
268     function setNeverdieContractAddress(address _to) external onlyOwner {
269         ndc = HumanStandardToken(_to);
270     }
271 
272     function setNeverdieSignerAddress(address _to) external onlyOwner {
273         neverdieSigner = _to;
274     }
275 
276     function setMinSwapAmount(uint256 _amount) external onlyOwner {
277         minSwapAmount = _amount;
278     }
279 
280     /// @dev receiveApproval calls function encoded as extra data
281     /// @param _sender token sender
282     /// @param _value value allowed to be spent
283     /// @param _tokenContract callee, should be equal to neverdieContractAddress
284     /// @param _extraData  this should be a well formed calldata with function signature preceding which is used to call, for example, 'swap' method
285     function receiveApproval(address _sender, uint256 _value, address _tokenContract, bytes _extraData) external {
286         require(_tokenContract == address(ndc));
287         assert(this.call(_extraData));
288     }
289 
290     
291 
292     /// @dev One-way swapFor function, swaps NDC for purchasable token for a given spender
293     /// @param _spender account that wants to swap NDC for purchasable token 
294     /// @param _rate current NDC to purchasable token rate, i.e. that the returned amount 
295     ///              of purchasable tokens equals to (_amount * _rate) / 1000
296     /// @param _PTaddress the address of the purchasable token  
297     /// @param _amount amount of NDC being offered
298     /// @param _expiration expiration timestamp 
299     /// @param _v ECDCA signature
300     /// @param _r ECDSA signature
301     /// @param _s ECDSA signature
302     function swapFor(address _spender,
303                      uint256 _rate,
304                      address _PTaddress,
305                      uint256 _amount,
306                      uint256 _expiration,
307                      uint8 _v,
308                      bytes32 _r,
309                      bytes32 _s) public {
310 
311         // Check if the signature did not expire yet by inspecting the timestamp
312         require(_expiration >= block.timestamp);
313 
314         // Check if the signature is coming from the neverdie signer address
315         address signer = ecrecover(keccak256(_spender, _rate, _PTaddress, _amount, _expiration), _v, _r, _s);
316         require(signer == neverdieSigner);
317 
318         // Check if the amount of NDC is higher than the minimum amount 
319         require(_amount >= minSwapAmount);
320        
321         // Check that we hold enough tokens
322         HumanStandardToken ptoken = HumanStandardToken(_PTaddress);
323         uint256 ptAmount;
324         uint8 decimals = ptoken.decimals();
325         if (decimals <= 18) {
326           ptAmount = SafeMath.div(SafeMath.div(SafeMath.mul(_amount, _rate), 1000), 10**(uint256(18 - decimals)));
327         } else {
328           ptAmount = SafeMath.div(SafeMath.mul(SafeMath.mul(_amount, _rate), 10**(uint256(decimals - 18))), 1000);
329         }
330 
331         assert(ndc.transferFrom(_spender, this, _amount) && ptoken.transfer(_spender, ptAmount));
332 
333         // Emit Swap event
334         Swap(_spender, _PTaddress, _rate, _amount, ptAmount);
335     }
336 
337     /// @dev One-way swap function, swaps NDC to purchasable tokens
338     /// @param _rate current NDC to purchasable token rate, i.e. that the returned amount of purchasable tokens equals to _amount * _rate 
339     /// @param _PTaddress the address of the purchasable token  
340     /// @param _amount amount of NDC being offered
341     /// @param _expiration expiration timestamp 
342     /// @param _v ECDCA signature
343     /// @param _r ECDSA signature
344     /// @param _s ECDSA signature
345     function swap(uint256 _rate,
346                   address _PTaddress,
347                   uint256 _amount,
348                   uint256 _expiration,
349                   uint8 _v,
350                   bytes32 _r,
351                   bytes32 _s) external {
352         swapFor(msg.sender, _rate, _PTaddress, _amount, _expiration, _v, _r, _s);
353     }
354 
355     /// @dev buy NDC with ether
356     /// @param _NDCprice NDC price in Wei
357     /// @param _expiration expiration timestamp
358     /// @param _v ECDCA signature
359     /// @param _r ECDSA signature
360     /// @param _s ECDSA signature
361     function buyNDC(uint256 _NDCprice,
362                     uint256 _expiration,
363                     uint8 _v,
364                     bytes32 _r,
365                     bytes32 _s
366                    ) payable external {
367         // Check if the signature did not expire yet by inspecting the timestamp
368         require(_expiration >= block.timestamp);
369 
370         // Check if the signature is coming from the neverdie address
371         address signer = ecrecover(keccak256(_NDCprice, _expiration), _v, _r, _s);
372         require(signer == neverdieSigner);
373 
374         uint256 a = SafeMath.div(msg.value, _NDCprice);
375         assert(ndc.transfer(msg.sender, a));
376 
377         // Emit BuyNDC event
378         BuyNDC(msg.sender, _NDCprice, msg.value, a);
379     }
380 
381     /// @dev buy TPT with ether
382     /// @param _TPTprice TPT price in Wei
383     /// @param _expiration expiration timestamp
384     /// @param _v ECDCA signature
385     /// @param _r ECDSA signature
386     /// @param _s ECDSA signature
387     function buyTPT(uint256 _TPTprice,
388                     uint256 _expiration,
389                     uint8 _v,
390                     bytes32 _r,
391                     bytes32 _s
392                    ) payable external {
393         // Check if the signature did not expire yet by inspecting the timestamp
394         require(_expiration >= block.timestamp);
395 
396         // Check if the signature is coming from the neverdie address
397         address signer = ecrecover(keccak256(_TPTprice, _expiration), _v, _r, _s);
398         require(signer == neverdieSigner);
399 
400         uint256 a = SafeMath.div(msg.value, _TPTprice);
401         assert(tpt.transfer(msg.sender, a));
402 
403         // Emit BuyNDC event
404         BuyTPT(msg.sender, _TPTprice, msg.value, a);
405     }
406 
407     /// @dev fallback function to reject any ether coming directly to the contract
408     function () payable public { 
409         revert(); 
410     }
411 
412     /// @dev withdraw all ether
413     function withdrawEther() external onlyOwner {
414         owner.transfer(this.balance);
415     }
416 
417     /// @dev withdraw token
418     /// @param _tokenContract any kind of ERC20 token to withdraw from
419     function withdraw(address _tokenContract) external onlyOwner {
420         ERC20 token = ERC20(_tokenContract);
421         uint256 balance = token.balanceOf(this);
422         assert(token.transfer(owner, balance));
423     }
424 
425     /// @dev kill contract, but before transfer all TPT, NDC tokens and ether to owner
426     function kill() onlyOwner public {
427         uint256 allNDC = ndc.balanceOf(this);
428         uint256 allTPT = tpt.balanceOf(this);
429         assert(ndc.transfer(owner, allNDC) && tpt.transfer(owner, allTPT));
430         selfdestruct(owner);
431     }
432 
433 }