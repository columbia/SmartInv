1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6 */
7 
8 library SafeMath {
9     
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a * b;
16     assert(a == 0 || c / a == b);
17     return c;
18     }
19     
20     /**
21     * @dev Integer division of two numbers, truncating the quotient.
22     */
23     
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a / b;
26     return c;
27     }
28     
29      /**
30     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31     */
32     
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36     }
37     
38     /**
39     * @dev Adds two numbers, throws on overflow.
40     */
41     
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53 */
54 
55 contract owned {
56     address public owner;
57 
58     constructor () public {
59         owner = msg.sender;
60     }
61 
62     modifier onlyOwner {
63         require(msg.sender == owner);
64         _;
65     }
66     
67     /**
68    * @dev Allows the current owner to transfer control of the contract to a newOwner.
69    * @param newOwner The address to transfer ownership to.
70    */
71 
72     function transferOwnership(address newOwner) onlyOwner public {
73         owner = newOwner;
74     }
75 }
76 
77 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
78 
79 contract TST_ERC20 is owned {
80     using SafeMath for uint;
81     // Public variables of the token
82     string public name = "TRIPSIA";
83     string public symbol = "TST";
84     uint8 public decimals = 18;
85     uint256 public totalSupply = 8000000000 * 10 ** uint256(decimals);
86     // 1 TST = 20 KRW
87     uint256 public TokenPerKRWBuy = 20;
88 
89 
90     /* Nonces of transfers performed */
91     mapping(bytes32 => bool) transactionHashes;
92    
93     // This creates an array with all balances
94     mapping (address => uint256) public balanceOf;
95     mapping (address => mapping (address => uint256)) public allowance;
96     mapping (address => bool) public frozenAccount;
97  
98    // This generates a public event on the blockchain that will notify clients
99     event Transfer(address indexed from, address indexed to, uint256 value);
100     
101     // This notifies clients about the amount burnt
102     event Burn(address indexed from, uint256 value);
103     
104     /// This notifies clients about the new Buy price
105     event BuyRateChanged(uint256 oldValue, uint256 newValue);
106     
107     /* This generates a public event on the blockchain that will notify clients */
108     event FrozenFunds(address target, bool frozen);
109     
110     /**
111      * Constrctor function
112      *
113      * Initializes contract with initial supply tokens to the creator of the contract
114      */
115     constructor () public {
116         balanceOf[owner] = totalSupply;
117     }
118     
119      /**
120      * Internal transfer, only can be called by this contract
121      */
122      
123      function _transfer(address _from, address _to, uint256 _value) internal {
124         // Prevent transfer to 0x0 address. Use burn() instead
125         require(_to != 0x0);
126         // Check if the sender has enough
127         require(balanceOf[_from] >= _value);
128         // Check for overflows
129         require(balanceOf[_to] + _value > balanceOf[_to]);
130         // Check if sender is frozen
131         require(!frozenAccount[_from]);
132         // Check if recipient is frozen
133         require(!frozenAccount[_to]);
134         // Save this for an assertion in the future
135         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
136         // Subtract from the sender
137         balanceOf[_from] -= _value;
138         // Add the same to the recipient
139         balanceOf[_to] += _value;
140         emit Transfer(_from, _to, _value);
141         // Asserts are used to use static analysis to find bugs in your code. They should never fail
142         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
143     }
144     
145      /**
146      * Transfer tokens
147      *
148      * Send `_value` tokens to `_to` from your account
149      *
150      * @param _to The address of the recipient
151      * @param _value the amount to send
152      */
153     function transfer(address _to, uint256 _value) public {
154         _transfer(msg.sender, _to, _value);
155     }
156     
157      /**
158      * Transfer tokens from other address
159      *
160      * Send `_value` tokens to `_to` in behalf of `_from`
161      *
162      * @param _from The address of the sender
163      * @param _to The address of the recipient
164      * @param _value the amount to send
165      */
166     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
167         require(_value <= allowance[_from][msg.sender]);     // Check allowance
168         allowance[_from][msg.sender] -= _value;
169         _transfer(_from, _to, _value);
170         return true;
171     }
172     
173      /**
174      * Set allowance for other address
175      *
176      * Allows `_spender` to spend no more than `_value` tokens in your behalf
177      *
178      * @param _spender The address authorized to spend
179      * @param _value the max amount they can spend
180      */
181     function approve(address _spender, uint256 _value) public
182         returns (bool success) {
183         allowance[msg.sender][_spender] = _value;
184         return true;
185     }
186     
187      /**
188      * Set allowance for other address and notify
189      *
190      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
191      *
192      * @param _spender The address authorized to spend
193      * @param _value the max amount they can spend
194      * @param _extraData some extra information to send to the approved contract
195      */
196     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
197         public
198         returns (bool success) {
199         tokenRecipient spender = tokenRecipient(_spender);
200         if (approve(_spender, _value)) {
201             spender.receiveApproval(msg.sender, _value, this, _extraData);
202             return true;
203         }
204     }
205     
206     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
207     /// @param target Address to be frozen
208     /// @param freeze either to freeze it or not
209     function freezeAccount(address target, bool freeze) onlyOwner public {
210         frozenAccount[target] = freeze;
211         emit FrozenFunds(target, freeze);
212     }
213     
214     /// @notice Create `mintedAmount` tokens and send it to `target`
215     /// @param target Address to receive the tokens
216     /// @param mintedAmount the amount of tokens it will receive
217     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
218         balanceOf[target] += mintedAmount;
219         totalSupply += mintedAmount;
220         emit Transfer(this, target, mintedAmount);
221     }
222     
223      /**
224      * Destroy tokens
225      *
226      * Remove `_value` tokens from the system irreversibly
227      *
228      * @param _value the amount of money to burn
229      */
230     function burn(uint256 _value) onlyOwner public returns (bool success) {
231         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
232         balanceOf[msg.sender] -= _value;            // Subtract from the sender
233         totalSupply -= _value;                      // Updates totalSupply
234         emit Burn(msg.sender, _value);
235         return true;
236     }
237     
238     /**
239      * Destroy tokens from other account
240      *
241      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
242      *
243      * @param _from the address of the sender
244      * @param _value the amount of money to burn
245      */
246     function burnFrom(address _from, uint256 _value) public returns (bool success) {
247         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
248         require(_value <= allowance[_from][msg.sender]);    // Check allowance
249         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
250         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
251         totalSupply -= _value;                              // Update totalSupply
252         emit Burn(_from, _value);
253         return true;
254     }
255     
256      /**
257      * Set price function for Buy
258      *
259      * @param value the amount new Buy Price
260      */
261     
262     function setBuyRate(uint256 value) onlyOwner public {
263         require(value > 0);
264         emit BuyRateChanged(TokenPerKRWBuy, value);
265         TokenPerKRWBuy = value;
266     }
267     
268     
269     /**
270     *  function for Buy Token
271     */
272     
273     function buyTST(address owner,uint tstCount, uint256 nonce, uint8 v, bytes32 r, bytes32 s) payable public returns (uint amount){
274           require(msg.value > 0);
275           
276           bytes32 hashedTx = keccak256(abi.encodePacked('transferPreSigned', owner, tstCount,nonce));
277           require(transactionHashes[hashedTx] == false, 'transaction hash is already used');
278           address from = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hashedTx)),v,r,s);
279           require(from == owner, 'Invalid _from address');
280 	
281           amount = tstCount;
282           balanceOf[this] -= amount;                        
283           balanceOf[msg.sender] += amount; 
284           transactionHashes[hashedTx] = true;
285           emit Transfer(this, from ,amount);
286           return amount;
287     }
288     
289     
290     /**
291     * Deposit Ether in owner account, requires method is "payable"
292     */
293     
294     function deposit() public payable  {
295        
296     }
297     
298     /**
299     *@notice Withdraw for Ether
300     */
301      function withdraw(uint withdrawAmount) onlyOwner public  {
302           if (withdrawAmount <= address(this).balance) {
303             owner.transfer(withdrawAmount);
304         }
305         
306      }
307     
308     function () public payable {
309         revert();
310     }
311      
312 }