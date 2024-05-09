1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 contract Owned {
37     address public owner;
38 
39     function Owned() public {
40         owner = msg.sender;
41     }
42 
43     modifier onlyOwner {
44         require(msg.sender == owner);
45         _;
46     }
47 }
48 
49 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
50 
51 contract ERC20Interface {
52       // Get the total token supply
53       function totalSupply() constant returns (uint256 _totalSupply);
54    
55      // Get the account balance of another account with address _owner
56      function balanceOf(address _owner) constant returns (uint256 balance);
57   
58      // Send _value amount of tokens to address _to
59     function transfer(address _to, uint256 _value) returns (bool success);
60   
61     // Send _value amount of tokens from address _from to address _to
62      function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
63   
64      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
65      // If this function is called again it overwrites the current allowance with _value.
66      // this function is required for some DEX functionality
67      function approve(address _spender, uint256 _value) returns (bool success);
68   
69      // Returns the amount which _spender is still allowed to withdraw from _owner
70      function allowance(address _owner, address _spender) constant returns (uint256 remaining);
71   
72      // Triggered when tokens are transferred.
73      event Transfer(address indexed _from, address indexed _to, uint256 _value);
74 
75      // Triggered whenever approve(address _spender, uint256 _value) is called.
76      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
77 }
78 
79 contract TokenERC20 is Owned,ERC20Interface {
80     using SafeMath for uint256;
81 
82     // Public variables of the token
83     string public name = "BITFINCOIN";
84     string public symbol = "BIC";
85     uint8 public decimals = 18;
86     // 18 decimals is the strongly suggested default, avoid changing it
87     uint256 public totalSupply = 0;
88     uint256 public totalSold;
89 
90     // This creates an array with all balances
91     mapping (address => uint256) public balanceOf;
92     mapping (address => mapping (address => uint256)) public allowance;
93 
94     // This generates a public event on the blockchain that will notify clients
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     // This notifies clients about the amount burnt
98     event Burn(address indexed from, uint256 value);
99 
100     event ContractFrozen(bool status);
101 
102     // defaults, 1 ether = 500 tokens
103     uint256 public rate = 125;
104     
105     // true if contract is block for transaction
106     bool public isContractFrozen = false;
107 
108     // minimal ether value that this contact accept
109     // default 0.0001Ether = 0.0001 * 10^18 wei
110     uint256 public minAcceptEther = 100000000000000; // 0.0001 ether = 10^14 wei
111     
112     function TokenERC20() public {
113         //name = "Bitfincoin";
114         //symbol = "BIC";
115         //decimals = 18;
116         //totalSupply = 39000000000000000000000000; // 39M * 10^18
117         //totalSold = 0;
118         //rate = 125;
119         //minAcceptEther = 100000000000000; // 0.0001 ether = 10^14 wei
120 
121         // grant all totalSupply tokens to owner
122         //balanceOf[msg.sender] = totalSupply;
123     }
124 
125     function createTokens() internal {
126         require(msg.value >= minAcceptEther);
127         require(totalSupply > 0);
128 
129         // send back tokens to sender balance base on rate
130         uint256 tokens = msg.value.mul(rate);
131         require(tokens <= totalSupply);
132 
133         balanceOf[msg.sender] = balanceOf[msg.sender].add(tokens);
134         balanceOf[owner] = balanceOf[owner].sub(tokens);
135 
136         totalSupply = totalSupply.sub(tokens);
137         totalSold = totalSold.add(tokens);
138         // send ether to owner address
139         owner.transfer(msg.value);
140         Transfer(owner, msg.sender, tokens);
141     }
142     /**
143      * Internal transfer, only can be called by this contract
144      */
145     function _transfer(address _from, address _to, uint _value) internal {
146         // Prevent transfer to 0x0 address. Use burn() instead
147         require(_to != 0x0);
148         // Check if the sender has enough
149         require(balanceOf[_from] >= _value);
150         // Check if contract is frozen
151         require(!isContractFrozen);
152         // Subtract from the sender
153         balanceOf[_from] = balanceOf[_from].sub(_value);
154         // Add the same to the recipient
155         balanceOf[_to] = balanceOf[_to].add(_value);
156         Transfer(_from, _to, _value);
157     }
158 
159     /**
160      * Transfer tokens
161      *
162      * Send `_value` tokens to `_to` from your account
163      *
164      * @param _to The address of the recipient
165      * @param _value the amount to send
166      */
167     function transfer(address _to, uint256 _value) public returns (bool success) {
168         _transfer(msg.sender, _to, _value);
169         return true;
170     }
171 
172     /**
173      * Transfer tokens from other address
174      *
175      * Send `_value` tokens to `_to` in behalf of `_from`
176      *
177      * @param _from The address of the sender
178      * @param _to The address of the recipient
179      * @param _value the amount to send
180      */
181     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
182         require(_value <= allowance[_from][msg.sender]);     // Check allowance
183         _transfer(_from, _to, _value);
184         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
185         return true;
186     }
187 
188     /**
189      * Set allowance for other address
190      *
191      * Allows `_spender` to spend no more than `_value` tokens in your behalf
192      *
193      * @param _spender The address authorized to spend
194      * @param _value the max amount they can spend
195      */
196     function approve(address _spender, uint256 _value) public returns (bool success) {
197         // To change the approve amount you first have to reduce the addresses`
198         //  allowance to zero by calling `approve(_spender,0)` if it is not
199         //  already 0 to mitigate the race condition described here:
200         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201         require((_value == 0) || (allowance[msg.sender][_spender] == 0));
202 
203         allowance[msg.sender][_spender] = _value;
204         Approval(msg.sender, _spender, _value);
205         return true;
206     }
207 
208     /**
209      * Set allowance for other address and notify
210      *
211      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
212      *
213      * @param _spender The address authorized to spend
214      * @param _value the max amount they can spend
215      * @param _extraData some extra information to send to the approved contract
216      */
217     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
218         tokenRecipient spender = tokenRecipient(_spender);
219         if (approve(_spender, _value)) {
220             spender.receiveApproval(msg.sender, _value, this, _extraData);
221             return true;
222         }
223     }
224 
225     /**
226      * Get allowance
227      */
228     function allowance(address _from, address _to) public constant returns (uint256) {
229         return allowance[_from][_to];
230     }
231 
232     /**
233      * Destroy tokens
234      *
235      * Remove `_value` tokens from the system irreversibly
236      *
237      * @param _value the amount of money to burn
238      */
239     function burn(uint256 _value) public returns (bool success) {
240         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
241         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
242         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
243         Burn(msg.sender, _value);
244         return true;
245     }
246 
247     /**
248      * Destroy tokens from other account
249      *
250      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
251      *
252      * @param _from the address of the sender
253      * @param _value the amount of money to burn
254      */
255     function burnFrom(address _from, uint256 _value) public returns (bool success) {
256         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
257         require(_value <= allowance[_from][msg.sender]);    // Check allowance
258         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
259         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
260         totalSupply = totalSupply.sub(_value);                              // Update totalSupply
261         Burn(_from, _value);
262         return true;
263     }
264 
265     /** Set contract frozen status */
266     function setContractFrozen(bool status) onlyOwner public {
267         isContractFrozen = status;
268         ContractFrozen(status);
269     }
270 
271     /** Get account balance (number of tokens the account hold)*/
272     function balanceOf(address _owner) public constant returns (uint256 balance) {
273         return balanceOf[_owner];
274     }
275 
276     /**  Get the total token supply */
277     function totalSupply() public constant returns (uint256 _totalSupply) {
278         return totalSupply;
279     }
280 
281     /** Set token name */
282     function setName(string _name) onlyOwner public {
283         name = _name;
284     }
285 
286     /** Set token symbol */
287     function setSymbol(string _symbol) onlyOwner public {
288         symbol = _symbol;
289     }
290 
291     /** Set token rate */
292     function setRate(uint256 _rate) onlyOwner public {
293         rate = _rate;
294     }
295     
296     /** Set minimum accept ether */
297     function setMinAcceptEther(uint256 _acceptEther) onlyOwner public {
298         minAcceptEther = _acceptEther;
299     }
300 
301     /** Set total supply */
302     function setTotalSupply(uint256 _totalSupply) onlyOwner public {
303         totalSupply = _totalSupply * 10 ** uint256(decimals);
304         balanceOf[owner] = totalSupply;
305         Transfer(0, this, totalSupply);
306         Transfer(this, owner, totalSupply);
307     }
308 
309     /** Transfer ownership and transfer account balance */
310     function transferOwnership(address newOwner) onlyOwner public {
311         require(newOwner != address(0));
312         require(owner != newOwner);
313         balanceOf[newOwner] = balanceOf[newOwner].add(balanceOf[owner]);
314         Transfer(owner, newOwner, balanceOf[owner]);
315         balanceOf[owner] = 0;
316         owner = newOwner;
317     }
318 }
319 
320 contract BICToken is TokenERC20 {
321 
322 	bool public isOpenForSale = false;
323 
324     mapping (address => bool) public frozenAccount;
325 
326     /* This generates a public event on the blockchain that will notify clients */
327     event FrozenFunds(address target, bool frozen);
328 
329     /**
330      * Fallback funtion will be call when someone send ether to this contract
331      */
332     function () public payable {
333 		require(isOpenForSale);
334         require(!isContractFrozen);
335         createTokens();
336     }
337 
338     /* Initializes contract with initial supply tokens to the creator of the contract */
339     function BICToken() TokenERC20() public {
340     }
341 
342     /* Internal transfer, only can be called by this contract */
343     function _transfer(address _from, address _to, uint _value) internal {
344         require(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
345         require(balanceOf[_from] >= _value);               // Check if the sender has enough
346         require(!frozenAccount[_from]);                     // Check if sender is frozen
347         require(!frozenAccount[_to]);                       // Check if recipient is frozen
348         require(!isContractFrozen);                         // Check if contract is frozen
349         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
350         balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
351         Transfer(_from, _to, _value);
352     }
353 
354     /// @notice Create `mintedAmount` tokens and send it to `target`
355     /// @param target Address to receive the tokens
356     /// @param mintedAmount the amount of tokens it will receive
357     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
358         uint256 amount = mintedAmount * 10 ** uint256(decimals);
359         balanceOf[target] = balanceOf[target].add(amount);
360         totalSupply = totalSupply.add(amount);
361         Transfer(0, this, amount);
362         Transfer(this, target, amount);
363     }
364 
365     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
366     /// @param target Address to be frozen
367     /// @param freeze either to freeze it or not
368     function freezeAccount(address target, bool freeze) onlyOwner public {
369         frozenAccount[target] = freeze;
370         FrozenFunds(target, freeze);
371     }
372 
373 	/// @notice Sets openned for sale status
374 	function setOpenForSale(bool status) onlyOwner public {
375 		isOpenForSale = status;
376 	}
377 }