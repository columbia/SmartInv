1 pragma solidity ^0.4.22;
2 
3 // ----------------------------------------------------------------------------
4 // ERC Token Standard #20 Interface
5 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
6 // ----------------------------------------------------------------------------
7 contract ERC20Interface {
8     function balanceOf(address tokenOwner) public constant returns (uint balance);
9     function allowance(address _owner, address _spender) public constant returns (uint remaining);
10     function transfer(address to, uint tokens) public returns (bool success);
11     function approve(address spender, uint tokens) public returns (bool success);
12     function transferFrom(address from, address to, uint256 _value) public returns (bool);
13 
14     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
15 }
16 // ----------------------------------------------------------------------------
17 // ERC Token Standard #223 Interface
18 // https://github.com/Dexaran/ERC223-token-standard/token/ERC223/ERC223_interface.sol
19 // ----------------------------------------------------------------------------
20 contract ERC223Interface {
21     uint public totalSupply;
22     function transfer(address to, uint value, bytes data) public returns (bool success);
23     event Transfer(address indexed from, address indexed to, uint value, bytes data);
24 }
25 /**
26  * @title Owned
27  * @dev To verify ownership
28  */
29 contract owned {
30     address public owner;
31 
32     function  owned() public {
33         owner = msg.sender;
34     }
35 
36     modifier onlyOwner {
37         require(msg.sender == owner);
38         _;
39     }
40 
41 }
42 /**
43  * As part of the ERC223 standard we need to call the fallback of the token
44  */
45 contract ContractReceiver {
46     struct TKN {
47         address sender;
48         uint value;
49         bytes data;
50         bytes4 sig;
51     }
52 
53     function tokenFallback(address _from, uint _value, bytes _data) public pure {
54         TKN memory tkn;
55         tkn.sender = _from;
56         tkn.value = _value;
57         tkn.data = _data;
58         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
59         tkn.sig = bytes4(u);
60 
61         /* tkn variable is analogue of msg variable of Ether transaction
62         *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
63         *  tkn.value the number of tokens that were sent   (analogue of msg.value)
64         *  tkn.data is data of token transaction   (analogue of msg.data)
65         *  tkn.sig is 4 bytes signature of function
66         *  if data of token transaction is a function execution
67         */
68     }
69 }
70 /**
71  * @title SafeMath
72  * @dev Math operations with safety checks that throw on error
73  */
74 
75 library SafeMath {
76     function mul(uint a, uint b) internal pure returns (uint) {
77         uint c = a * b;
78         assert(a == 0 || c / a == b);
79         return c;
80     }
81 
82     function div(uint a, uint b) internal pure returns (uint) {
83         // assert(b > 0); // Solidity automatically throws when dividing by 0
84         uint c = a / b;
85         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
86         return c;
87     }
88 
89     function sub(uint a, uint b) internal pure returns (uint) {
90         assert(b <= a);
91         return a - b;
92     }
93 
94     function add(uint a, uint b) internal pure returns (uint) {
95         uint c = a + b;
96         assert(c >= a);
97         return c;
98     }
99 }
100 contract TimeVaultInterface is ERC20Interface, ERC223Interface {
101     function timeVault(address who) public constant returns (uint);
102     function getNow() public constant returns (uint);
103     function transferByOwner(address to, uint _value, uint timevault) public returns (bool);
104 }
105 /**
106  * All meta information for the Token must be defined here so that it can be accessed from both sides of proxy
107  */
108 contract ELTTokenType {
109     uint public decimals;
110     uint public totalSupply;
111 
112     mapping(address => uint) balances;
113 
114     mapping(address => uint) timevault;
115     mapping(address => mapping(address => uint)) allowed;
116 
117     // Token release switch
118     bool public released;
119 
120     // The date before the release must be finalized (a unix timestamp)
121     uint public globalTimeVault;
122 
123     event Transfer(address indexed from, address indexed to, uint tokens);
124 }
125 
126 contract ERC20Token is ERC20Interface, ERC223Interface, ELTTokenType {
127     using SafeMath for uint;
128 
129     function transfer(address _to, uint _value) public returns (bool success) {
130         bytes memory empty;
131         return transfer(_to, _value, empty);
132     }
133 
134     // Function that is called when a user or another contract wants to transfer funds .
135     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
136 
137         if (isContract(_to)) {
138             return transferToContract(_to, _value, _data, false);
139         }
140         else {
141             return transferToAddress(_to, _value, _data, false);
142         }
143     }
144 
145     /**
146      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
147      *
148      */
149     function approve(address _spender, uint _value) public returns (bool) {
150         allowed[msg.sender][_spender] = _value;
151         emit Approval(msg.sender, _spender, _value);
152         return true;
153     }
154 
155     /**
156      * @dev Function to check the amount of tokens that an owner allowed to a spender.
157      * @param _owner address The address which owns the funds.
158      * @param _spender address The address which will spend the funds.
159      * @return A uint specifying the amount of tokens still available for the spender.
160      */
161     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
162         return allowed[_owner][_spender];
163     }
164 
165     /**
166     * @dev Gets the balance of the specified address.
167     * @param _owner The address to query the the balance of.
168     * @return An uint representing the amount owned by the passed address.
169     */
170     function balanceOf(address _owner) public constant returns (uint balance) {
171         return balances[_owner];
172     }
173 
174     function isContract(address _addr) private view returns (bool is_contract) {
175         uint length;
176         assembly
177         {
178         //retrieve the size of the code on target address, this needs assembly
179             length := extcodesize(_addr)
180         }
181         return (length > 0);
182     }
183 
184 
185     //function that is called when transaction target is an address
186     function transferToAddress(address _to, uint _value, bytes _data, bool withAllowance) private returns (bool success) {
187         transferIfRequirementsMet(msg.sender, _to, _value, withAllowance);
188         emit Transfer(msg.sender, _to, _value, _data);
189         return true;
190     }
191 
192     //function that is called when transaction target is a contract
193     function transferToContract(address _to, uint _value, bytes _data, bool withAllowance) private returns (bool success) {
194         transferIfRequirementsMet(msg.sender, _to, _value, withAllowance);
195         ContractReceiver receiver = ContractReceiver(_to);
196         receiver.tokenFallback(msg.sender, _value, _data);
197         emit Transfer(msg.sender, _to, _value, _data);
198         return true;
199     }
200 
201     // Function to verify that all the requirements to transfer are satisfied
202     // The destination is not the null address
203     // The tokens have been released for sale
204     // The sender's tokens are not locked in a timevault
205     function checkTransferRequirements(address _to, uint _value) private view {
206         require(_to != address(0));
207         require(released == true);
208         require(now > globalTimeVault);
209         if (timevault[msg.sender] != 0)
210         {
211             require(now > timevault[msg.sender]);
212         }
213         require(balanceOf(msg.sender) >= _value);
214     }
215 
216     // Do the transfer if the requirements are met
217     function transferIfRequirementsMet(address _from, address _to, uint _value, bool withAllowances) private {
218         checkTransferRequirements(_to, _value);
219         if ( withAllowances)
220         {
221             require (_value <= allowed[_from][msg.sender]);
222         }
223         balances[_from] = balances[msg.sender].sub(_value);
224         balances[_to] = balances[_to].add(_value);
225     }
226 
227     // Transfer from one address to another taking into account ERC223 condition to verify that the to address is a contract or not
228     function transferFrom(address from, address to, uint value) public returns (bool) {
229         bytes memory empty;
230         if (isContract(to)) {
231             return transferToContract(to, value, empty, true);
232         }
233         else {
234             return transferToAddress(to, value, empty, true);
235         }
236         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
237         return true;
238     }
239 }
240 contract TimeVaultToken is  owned, TimeVaultInterface, ERC20Token {
241 
242     function transferByOwner(address to, uint value, uint earliestReTransferTime) onlyOwner public returns (bool) {
243         transfer(to, value);
244         timevault[to] = earliestReTransferTime;
245         return true;
246     }
247 
248     function timeVault(address owner) public constant returns (uint earliestTransferTime) {
249         return timevault[owner];
250     }
251 
252     function getNow() public constant returns (uint blockchainTimeNow) {
253         return now;
254     }
255 
256 }
257 contract StandardToken is TimeVaultToken {
258     /**
259      * approve should be called when allowed[_spender] == 0. To increment
260      * allowed value is better to use this function to avoid 2 calls (and wait until
261      * the first transaction is mined)
262      * From MonolithDAO Token.sol
263      */
264     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
265         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
266         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
267         return true;
268     }
269 
270     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
271         uint oldValue = allowed[msg.sender][_spender];
272         if (_subtractedValue > oldValue) {
273             allowed[msg.sender][_spender] = 0;
274         } else {
275             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
276         }
277         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
278         return true;
279     }
280 
281 }
282 contract StandardTokenExt is StandardToken {
283 
284     /* Interface declaration */
285     function isToken() public pure returns (bool weAre) {
286         return true;
287     }
288 }
289 contract OwnershipTransferrable is TimeVaultToken {
290 
291     event OwnershipTransferred(address indexed _from, address indexed _to);
292 
293 
294     function transferOwnership(address newOwner) onlyOwner public {
295         transferByOwner(newOwner, balanceOf(newOwner), 0);
296         owner = newOwner;
297         emit OwnershipTransferred(msg.sender, newOwner);
298     }
299 
300 }
301 contract VersionedToken is owned {
302     address public upgradableContractAddress;
303 
304     /**
305      * Constructor:
306      *  initialVersion - the address of the initial version of the implementation for the contract
307      *
308      * Note that this implementation must be visible to the relay contact even though it will not be a subclass
309      * do this by importing the main contract that implements it.  If the code is not visible it will not
310      * always be accessible through the delegatecall() function.  And even if it is, it will take an unlimited amount
311      * of gas to process the call.
312      *
313      * In our case this it is ELTTokenImpl.sol
314      * e.g.
315      *    import "ELTToken.sol"
316      *
317      * Please note: IMPORTANT
318      * do not implement any function called "update()" otherwise it will break the Versioning system
319      */
320     function VersionedToken(address initialImplementation) public {
321         upgradableContractAddress = initialImplementation;
322     }
323 
324     /**
325      * update
326      * Call to upgrade the implementation version of this constract
327      *  newVersion: this is the address of the new implementation for the contract
328      */
329 
330     function upgradeToken(address newImplementation) onlyOwner public {
331         upgradableContractAddress = newImplementation;
332     }
333 
334     /**
335      * This is the fallback function that is called whenever a contract is called but can't find the called function.
336      * In this case we delegate the call to the implementing contract ELTTokenImpl
337      *
338      * Instead of using delegatecall() in Solidity we use the assembly because it allows us to return values to the caller
339      */
340     function() public {
341         address upgradableContractMem = upgradableContractAddress;
342         bytes memory functionCall = msg.data;
343 
344         assembly {
345         // Load the first 32 bytes of the functionCall bytes array which represents the size of the bytes array
346             let functionCallSize := mload(functionCall)
347 
348         // Calculate functionCallDataAddress which starts at the second 32 byte block in the functionCall bytes array
349             let functionCallDataAddress := add(functionCall, 0x20)
350 
351         // delegatecall(gasAllowed, callAddress, inMemAddress, inSizeBytes, outMemAddress, outSizeBytes) returns/pushes to stack (1 on success, 0 on failure)
352             let functionCallResult := delegatecall(gas, upgradableContractMem, functionCallDataAddress, functionCallSize, 0, 0)
353 
354             let freeMemAddress := mload(0x40)
355 
356             switch functionCallResult
357             case 0 {
358             // revert(fromMemAddress, sizeInBytes) ends execution and returns value
359                 revert(freeMemAddress, 0)
360             }
361             default {
362             // returndatacopy(toMemAddress, fromMemAddress, sizeInBytes)
363                 returndatacopy(freeMemAddress, 0x0, returndatasize)
364             // return(fromMemAddress, sizeInBytes)
365                 return (freeMemAddress, returndatasize)
366             }
367         }
368     }
369 }
370 contract ELTToken is VersionedToken, ELTTokenType {
371     string public name;
372     string public symbol;
373 
374     function ELTToken(address _tokenOwner, string _tokenName, string _tokenSymbol, uint _totalSupply, uint _decimals, uint _globalTimeVaultOpeningTime, address _initialImplementation) VersionedToken(_initialImplementation)  public {
375         name = _tokenName;
376         symbol = _tokenSymbol;
377         decimals = _decimals;
378         totalSupply = _totalSupply * 10 ** uint(decimals);
379         // Allocate initial balance to the owner
380         balances[_tokenOwner] = totalSupply;
381         emit Transfer(address(0), owner, totalSupply);
382         globalTimeVault = _globalTimeVaultOpeningTime;
383         released = false;
384 
385     }
386 }
387 contract ELTTokenImpl is StandardTokenExt {
388     /** Name and symbol were updated. */
389     event UpdatedTokenInformation(string newName, string newSymbol);
390 
391     string public name;
392     string public symbol;
393      bool private adminReturnStatus ;
394 
395     /**
396      * One way function to perform the final token release.
397      */
398     function releaseTokenTransfer(bool _value) onlyOwner public {
399         released = _value;
400     }
401 
402     function setGlobalTimeVault(uint _globalTimeVaultOpeningTime) onlyOwner public {
403         globalTimeVault = _globalTimeVaultOpeningTime;
404     }
405      function admin(string functionName, string p1, string p2, string p3) onlyOwner public returns (bool result) {
406         // Use parameters to remove warning
407         adminReturnStatus = (bytes(functionName).length + bytes(p1).length + bytes(p2).length + bytes(p3).length) != 0;
408 
409         return adminReturnStatus ;
410     }
411     /**
412      * Owner can update token information here.
413      *
414      * It is often useful to conceal the actual token association, until
415      * the token operations, like central issuance or reissuance have been completed.
416      * In this case the initial token can be supplied with empty name and symbol information.
417      *
418      * This function allows the token owner to rename the token after the operations
419      * have been completed and then point the audience to use the token contract.
420      */
421     function setTokenInformation(string _tokenName, string _tokenSymbol) onlyOwner public {
422         name = _tokenName;
423         symbol = _tokenSymbol;
424         emit UpdatedTokenInformation(name, symbol);
425     }
426 }