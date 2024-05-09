1 pragma solidity ^0.4.18;
2 
3 library SafeMath
4 {
5     function mul(uint256 a, uint256 b) internal pure
6         returns (uint256)
7     {
8         uint256 c = a * b;
9 
10         assert(a == 0 || c / a == b);
11 
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure
16         returns (uint256)
17     {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure
25         returns (uint256)
26     {
27         assert(b <= a);
28 
29         return a - b;
30     }
31 
32     function add(uint256 a, uint256 b) internal pure
33         returns (uint256)
34     {
35         uint256 c = a + b;
36 
37         assert(c >= a);
38 
39         return c;
40     }
41 }
42 
43 /**
44  * @title Ownable
45  * @dev The Ownable contract has an owner address, and provides basic authorization control
46  * functions, this simplifies the implementation of "user permissions".
47  */
48 contract Ownable
49 {
50     address public owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
56      * account.
57      */
58     function Ownable() public {
59         owner = msg.sender;
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         require(msg.sender == owner);
67         _;
68     }
69 
70     /**
71      * @dev Allows the current owner to transfer control of the contract to a newOwner.
72      * @param newOwner The address to transfer ownership to.
73      */
74     function transferOwnership(address newOwner) public onlyOwner {
75         require(newOwner != address(0));
76         emit OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78     }
79 }
80 
81 interface tokenRecipient
82 {
83     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
84 }
85 
86 contract TokenERC20 is Ownable
87 {
88     using SafeMath for uint;
89 
90     // Public variables of the token
91     string public name;
92     string public symbol;
93     uint256 public decimals = 18;
94     uint256 DEC = 10 ** uint256(decimals);
95     uint256 public totalSupply;
96     uint256 public avaliableSupply;
97     uint256 public buyPrice = 1000000000000000000 wei;
98 
99     // This creates an array with all balances
100     mapping (address => uint256) public balanceOf;
101     mapping (address => mapping (address => uint256)) public allowance;
102 
103     // This generates a public event on the blockchain that will notify clients
104     event Transfer(address indexed from, address indexed to, uint256 value);
105     event Burn(address indexed from, uint256 value);
106     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
107 
108     /**
109      * Constrctor function
110      *
111      * Initializes contract with initial supply tokens to the creator of the contract
112      */
113     function TokenERC20(
114         uint256 initialSupply,
115         string tokenName,
116         string tokenSymbol
117     ) public
118     {
119         totalSupply = initialSupply.mul(DEC);  // Update total supply with the decimal amount
120         balanceOf[this] = totalSupply;         // Give the creator all initial tokens
121         avaliableSupply = balanceOf[this];     // Show how much tokens on contract
122         name = tokenName;                      // Set the name for display purposes
123         symbol = tokenSymbol;                  // Set the symbol for display purposes
124     }
125 
126     /**
127      * Internal transfer, only can be called by this contract
128      *
129      * @param _from - address of the contract
130      * @param _to - address of the investor
131      * @param _value - tokens for the investor
132      */
133     function _transfer(address _from, address _to, uint256 _value) internal
134     {
135         // Prevent transfer to 0x0 address. Use burn() instead
136         require(_to != 0x0);
137         // Check if the sender has enough
138         require(balanceOf[_from] >= _value);
139         // Check for overflows
140         require(balanceOf[_to].add(_value) > balanceOf[_to]);
141         // Save this for an assertion in the future
142         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
143         // Subtract from the sender
144         balanceOf[_from] = balanceOf[_from].sub(_value);
145         // Add the same to the recipient
146         balanceOf[_to] = balanceOf[_to].add(_value);
147 
148         emit Transfer(_from, _to, _value);
149         // Asserts are used to use static analysis to find bugs in your code. They should never fail
150         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
151     }
152 
153     /**
154      * Transfer tokens
155      *
156      * Send `_value` tokens to `_to` from your account
157      *
158      * @param _to The address of the recipient
159      * @param _value the amount to send
160      */
161     function transfer(address _to, uint256 _value) public
162     {
163         _transfer(msg.sender, _to, _value);
164     }
165 
166     /**
167      * Transfer tokens from other address
168      *
169      * Send `_value` tokens to `_to` in behalf of `_from`
170      *
171      * @param _from The address of the sender
172      * @param _to The address of the recipient
173      * @param _value the amount to send
174      */
175     function transferFrom(address _from, address _to, uint256 _value) public
176         returns (bool success)
177     {
178         require(_value <= allowance[_from][msg.sender]);     // Check allowance
179 
180         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
181         _transfer(_from, _to, _value);
182 
183         return true;
184     }
185 
186     /**
187      * Set allowance for other address
188      *
189      * Allows `_spender` to spend no more than `_value` tokens in your behalf
190      *
191      * @param _spender The address authorized to spend
192      * @param _value the max amount they can spend
193      */
194     function approve(address _spender, uint256 _value) public
195         returns (bool success)
196     {
197         allowance[msg.sender][_spender] = _value;
198 
199         return true;
200     }
201 
202     /**
203      * Set allowance for other address and notify
204      *
205      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
206      *
207      * @param _spender The address authorized to spend
208      * @param _value the max amount they can spend
209      * @param _extraData some extra information to send to the approved contract
210      */
211     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public onlyOwner
212         returns (bool success)
213     {
214         tokenRecipient spender = tokenRecipient(_spender);
215 
216         if (approve(_spender, _value)) {
217             spender.receiveApproval(msg.sender, _value, this, _extraData);
218 
219             return true;
220         }
221     }
222 
223     /**
224      * approve should be called when allowed[_spender] == 0. To increment
225      * allowed value is better to use this function to avoid 2 calls (and wait until
226      * the first transaction is mined)
227      * From MonolithDAO Token.sol
228      */
229     function increaseApproval (address _spender, uint _addedValue) public
230         returns (bool success)
231     {
232         allowance[msg.sender][_spender] = allowance[msg.sender][_spender].add(_addedValue);
233 
234         emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
235 
236         return true;
237     }
238 
239     function decreaseApproval (address _spender, uint _subtractedValue) public
240         returns (bool success)
241     {
242         uint oldValue = allowance[msg.sender][_spender];
243 
244         if (_subtractedValue > oldValue) {
245             allowance[msg.sender][_spender] = 0;
246         } else {
247             allowance[msg.sender][_spender] = oldValue.sub(_subtractedValue);
248         }
249 
250         emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
251 
252         return true;
253     }
254 
255     /**
256      * Destroy tokens
257      *
258      * Remove `_value` tokens from the system irreversibly
259      *
260      * @param _value the amount of money to burn
261      */
262     function burn(uint256 _value) public onlyOwner
263         returns (bool success)
264     {
265         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
266 
267         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);  // Subtract from the sender
268         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
269         avaliableSupply = avaliableSupply.sub(_value);
270 
271         emit Burn(msg.sender, _value);
272 
273         return true;
274     }
275 
276     /**
277      * Destroy tokens from other account
278      *
279      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
280      *
281      * @param _from the address of the sender
282      * @param _value the amount of money to burn
283      */
284     function burnFrom(address _from, uint256 _value) public onlyOwner
285         returns (bool success)
286     {
287         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
288         require(_value <= allowance[_from][msg.sender]);    // Check allowance
289 
290         balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the targeted balance
291         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);    // Subtract from the sender's allowance
292         totalSupply = totalSupply.sub(_value);              // Update totalSupply
293         avaliableSupply = avaliableSupply.sub(_value);
294 
295         emit Burn(_from, _value);
296 
297         return true;
298     }
299 }
300 
301 
302 /**
303  * @title Eliptic curve signature operations
304  *
305  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
306  */
307 
308 library ECRecovery {
309 
310   /**
311    * @dev Recover signer address from a message by using his signature
312    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
313    * @param sig bytes signature, the signature is generated using web3.eth.sign()
314    */
315   function recover(bytes32 hash, bytes sig) public pure returns (address) {
316     bytes32 r;
317     bytes32 s;
318     uint8 v;
319 
320     //Check the signature length
321     if (sig.length != 65) {
322       return (address(0));
323     }
324 
325     // Divide the signature in r, s and v variables
326     assembly {
327       r := mload(add(sig, 32))
328       s := mload(add(sig, 64))
329       v := byte(0, mload(add(sig, 96)))
330     }
331 
332     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
333     if (v < 27) {
334       v += 27;
335     }
336 
337     // If the version is correct return the signer address
338     if (v != 27 && v != 28) {
339       return (address(0));
340     } else {
341       return ecrecover(hash, v, r, s);
342     }
343   }
344 
345 }
346 
347 contract StreamityTariff is Ownable {
348     using ECRecovery for bytes32;
349     
350     uint8 constant public EMPTY = 0x0;
351 
352     TokenERC20 public streamityContractAddress;
353 
354     mapping(bytes32 => Deal) public streamityTransfers;
355 
356     function StreamityTariff(address streamityContract) public {
357         require(streamityContract != 0x0);
358         streamityContractAddress = TokenERC20(streamityContract);
359     }
360 
361     struct Deal {
362         uint256 value;
363     }
364 
365     event BuyTariff(bytes32 _hashDeal);
366 
367     function payAltCoin(bytes32 _tradeID, uint256 _value, bytes _sign) 
368     external 
369     {
370         bytes32 _hashDeal = keccak256(_tradeID, _value);
371         verifyDeal(_hashDeal, _sign);
372         bool result = streamityContractAddress.transferFrom(msg.sender, address(this), _value);
373         require(result == true);
374         startDeal(_hashDeal, _value);
375     }
376 
377     function verifyDeal(bytes32 _hashDeal, bytes _sign) private view {
378         require(_hashDeal.recover(_sign) == owner);
379         require(streamityTransfers[_hashDeal].value == EMPTY); 
380     }
381 
382     function startDeal(bytes32 _hashDeal, uint256 _value) 
383     private returns(bytes32) 
384     {
385         Deal storage userDeals = streamityTransfers[_hashDeal];
386         userDeals.value = _value; 
387         emit BuyTariff(_hashDeal);
388         
389         return _hashDeal;
390     }
391 
392     function withdrawCommisionToAddressAltCoin(address _to, uint256 _amount) external onlyOwner {
393         streamityContractAddress.transfer(_to, _amount);
394     }
395 
396     function setStreamityContractAddress(address newAddress) 
397     external onlyOwner 
398     {
399         streamityContractAddress = TokenERC20(newAddress);
400     }
401 }