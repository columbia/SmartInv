1 pragma solidity ^0.4.24;
2 
3 /**
4  ** OBC
5  ** OBC 201903
6  */
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14   /**
15   * @dev Multiplies two numbers, throws on overflow.
16   */
17   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18     if (a == 0) {
19       return 0;
20     }
21     uint256 c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a / b;
31     return c;
32   }
33 
34   /**
35   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 
51 }
52 
53 /**
54  * @title owned
55  * @dev The owned contract has an owner address, and provides basic authorization
56  *      control functions, this simplifies the implementation of "user permissions".
57  */
58 contract owned {
59     address public owner;
60     /**
61      * @dev The owned constructor sets the original `owner` of the contract to the sender
62      * account.
63      */
64     constructor() public {
65         owner = msg.sender;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner {
72         require(msg.sender == owner);
73         _;
74     }
75 
76     /**
77      * @dev Allows the current owner to transfer control of the contract to a newOwner.
78      */
79     function transferOwnership(address newOwner) onlyOwner public {
80         require(newOwner != address(0));
81         owner = newOwner;
82     }
83 }
84 
85 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
86 
87 contract TokenERC20 {
88     using SafeMath for uint;
89     // Public variables of the token
90     string public name = "organic block chain";
91     string public symbol = "OBC";
92     uint8 public decimals = 18;
93     // 18 decimals is the strongly suggested default, avoid changing it
94     uint256 public totalSupply = 3000000000 * 10 ** uint256(decimals);
95 
96     // This creates an array with all balances
97     mapping (address => uint256) public balanceOf;
98     mapping (address => mapping (address => uint256)) public allowance;
99 
100     // This generates a public event on the blockchain that will notify clients
101     event Transfer(address indexed from, address indexed to, uint256 value);
102     
103     // This generates a public event on the blockchain that will notify clients
104     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
105 
106     // This notifies clients about the amount burnt
107     event Burn(address indexed from, uint256 value);
108 
109     /**
110      * Constrctor function
111      *
112      * Initializes contract with initial supply tokens to the creator of the contract
113      */
114     constructor(
115         uint256 initialSupply,
116         string memory tokenName,
117         string memory tokenSymbol
118     ) public {
119         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
120         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
121         name = tokenName;                                   // Set the name for display purposes
122         symbol = tokenSymbol;                               // Set the symbol for display purposes
123     }
124 
125     /**
126      * Internal transfer, only can be called by this contract
127      */
128     function _transfer(address _from, address _to, uint _value) internal {
129         // Prevent transfer to 0x0 address. Use burn() instead
130         require(_to != address(0x0));
131         // Check if the sender has enough
132         require(balanceOf[_from] >= _value);
133         // Check for overflows
134         require(balanceOf[_to] + _value > balanceOf[_to]);
135         // Save this for an assertion in the future
136         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
137         // Subtract from the sender
138         balanceOf[_from] = balanceOf[_from].sub(_value);
139         // Add the same to the recipient
140         balanceOf[_to] = balanceOf[_to].add(_value);
141         emit Transfer(_from, _to, _value);
142         // Asserts are used to use static analysis to find bugs in your code. They should never fail
143         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
144     }
145 
146     /**
147      * Transfer tokens
148      *
149      * Send `_value` tokens to `_to` from your account
150      *
151      * @param _to The address of the recipient
152      * @param _value the amount to send
153      */
154     function transfer(address _to, uint256 _value) public returns (bool success) {
155         _transfer(msg.sender, _to, _value);
156         return true;
157     }
158 
159     /**
160      * Transfer tokens from other address
161      *
162      * Send `_value` tokens to `_to` in behalf of `_from`
163      *
164      * @param _from The address of the sender
165      * @param _to The address of the recipient
166      * @param _value the amount to send
167      */
168     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
169         require(_value <= allowance[_from][msg.sender]);     // Check allowance
170         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
171         _transfer(_from, _to, _value);
172         return true;
173     }
174 
175     /**
176      * Set allowance for other address
177      *
178      * Allows `_spender` to spend no more than `_value` tokens in your behalf
179      *
180      * @param _spender The address authorized to spend
181      * @param _value the max amount they can spend
182      */
183     function approve(address _spender, uint256 _value) public
184         returns (bool success) {
185         allowance[msg.sender][_spender] = _value;
186         emit Approval(msg.sender, _spender, _value);
187         return true;
188     }
189 
190     /**
191      * Set allowance for other address and notify
192      *
193      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
194      *
195      * @param _spender The address authorized to spend
196      * @param _value the max amount they can spend
197      * @param _extraData some extra information to send to the approved contract
198      */
199     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
200         public
201         returns (bool success) {
202         tokenRecipient spender = tokenRecipient(_spender);
203         if (approve(_spender, _value)) {
204             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
205             return true;
206         }
207     }
208 
209     /**
210      * Destroy tokens
211      *
212      * Remove `_value` tokens from the system irreversibly
213      *
214      * @param _value the amount of money to burn
215      */
216     function burn(uint256 _value) public returns (bool success) {
217         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
218         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
219         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
220         emit Burn(msg.sender, _value);
221         return true;
222     }
223 
224     /**
225      * Destroy tokens from other account
226      *
227      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
228      *
229      * @param _from the address of the sender
230      * @param _value the amount of money to burn
231      */
232     function burnFrom(address _from, uint256 _value) public returns (bool success) {
233         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
234         require(_value <= allowance[_from][msg.sender]);    // Check allowance
235         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
236         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
237         totalSupply = totalSupply.sub(_value);                              // Update totalSupply
238         emit Burn(_from, _value);
239         return true;
240     }
241 }
242 
243 /******************************************/
244 /*       ADVANCED TOKEN STARTS HERE       */
245 /******************************************/
246 
247 contract OBC is owned, TokenERC20 {
248     using SafeMath for uint;
249     uint256 public sellPrice;
250     uint256 public buyPrice;
251 
252     mapping (address => bool) public frozenAccount;
253 
254     /* This generates a public event on the blockchain that will notify clients */
255     event FrozenFunds(address target, bool frozen);
256 
257     /* Initializes contract with initial supply tokens to the creator of the contract */
258     constructor(
259         uint256 initialSupply,
260         string memory tokenName,
261         string memory tokenSymbol
262     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
263 
264     /* Internal transfer, only can be called by this contract */
265     function _transfer(address _from, address _to, uint _value) internal {
266         require (_to != address(0x0));                               // Prevent transfer to 0x0 address. Use burn() instead
267         require (balanceOf[_from] >= _value);               // Check if the sender has enough
268         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
269         require(!frozenAccount[_from]);                     // Check if sender is frozen
270         require(!frozenAccount[_to]);                       // Check if recipient is frozen
271         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
272         balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
273         emit Transfer(_from, _to, _value);
274     }
275 
276     /// @notice Create `mintedAmount` tokens and send it to `target`
277     /// @param target Address to receive the tokens
278     /// @param mintedAmount the amount of tokens it will receive
279     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
280         balanceOf[target] = balanceOf[target].add(mintedAmount);
281         totalSupply = totalSupply.add(mintedAmount);
282         emit Transfer(address(0), address(this), mintedAmount);
283         emit Transfer(address(this), target, mintedAmount);
284     }
285 
286     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
287     /// @param target Address to be frozen
288     /// @param freeze either to freeze it or not
289     function freezeAccount(address target, bool freeze) onlyOwner public {
290         frozenAccount[target] = freeze;
291         emit FrozenFunds(target, freeze);
292     }
293 
294     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
295     /// @param newSellPrice Price the users can sell to the contract
296     /// @param newBuyPrice Price users can buy from the contract
297     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
298         sellPrice = newSellPrice;
299         buyPrice = newBuyPrice;
300     }
301 
302     /// @notice Buy tokens from contract by sending ether
303     function buy() payable public {
304         uint amount = msg.value / buyPrice;                 // calculates the amount
305         _transfer(address(this), msg.sender, amount);       // makes the transfers
306     }
307 
308     /// @notice Sell `amount` tokens to contract
309     /// @param amount amount of tokens to be sold
310     function sell(uint256 amount) public {
311         address myAddress = address(this);
312         require(myAddress.balance >= amount * sellPrice);   // checks if the contract has enough ether to buy
313         _transfer(msg.sender, address(this), amount);       // makes the transfers
314         msg.sender.transfer(amount * sellPrice);            // sends ether to the seller. It's important to do this last to avoid recursion attacks
315     }
316 }