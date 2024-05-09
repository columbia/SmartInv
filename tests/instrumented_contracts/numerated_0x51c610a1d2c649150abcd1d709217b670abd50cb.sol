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
79 contract TST_ERC is owned {
80     using SafeMath for uint;
81     // Public variables of the token
82     string public name = "TRIPSIA blockchain based payment";
83     string public symbol = "TST";
84     uint8 public decimals = 0;
85     uint256 public totalSupply = 1 * 10 ** uint256(decimals);
86 
87    
88     // This creates an array with all balances
89     mapping (address => uint256) public balanceOf;
90     mapping (address => mapping (address => uint256)) public allowance;
91     mapping (address => bool) public frozenAccount;
92     
93    // This generates a public event on the blockchain that will notify clients
94     event Transfer(address indexed from, address indexed to, uint256 value);
95     
96     // This notifies clients about the amount burnt
97     event Burn(address indexed from, uint256 value);
98     
99     /* This generates a public event on the blockchain that will notify clients */
100     event FrozenFunds(address target, bool frozen);
101     
102     /**
103      * Constrctor function
104      *
105      * Initializes contract with initial supply tokens to the creator of the contract
106      */
107     constructor () public {
108         balanceOf[owner] = totalSupply;
109     }
110     
111      /**
112      * Internal transfer, only can be called by this contract
113      */
114      
115      function _transfer(address _from, address _to, uint256 _value) internal {
116         // Prevent transfer to 0x0 address. Use burn() instead
117         require(_to != 0x0);
118         // Check if the sender has enough
119         require(balanceOf[_from] >= _value);
120         // Check for overflows
121         require(balanceOf[_to] + _value > balanceOf[_to]);
122         // Check if sender is frozen
123         require(!frozenAccount[_from]);
124         // Check if recipient is frozen
125         require(!frozenAccount[_to]);
126         // Save this for an assertion in the future
127         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
128         // Subtract from the sender
129         balanceOf[_from] -= _value;
130         // Add the same to the recipient
131         balanceOf[_to] += _value;
132         emit Transfer(_from, _to, _value);
133         // Asserts are used to use static analysis to find bugs in your code. They should never fail
134         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
135     }
136     
137      /**
138      * Transfer tokens
139      *
140      * Send `_value` tokens to `_to` from your account
141      *
142      * @param _to The address of the recipient
143      * @param _value the amount to send
144      */
145     function transfer(address _to, uint256 _value) public {
146         _transfer(msg.sender, _to, _value);
147     }
148     
149      /**
150      * Transfer tokens from other address
151      *
152      * Send `_value` tokens to `_to` in behalf of `_from`
153      *
154      * @param _from The address of the sender
155      * @param _to The address of the recipient
156      * @param _value the amount to send
157      */
158     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
159         require(_value <= allowance[_from][msg.sender]);     // Check allowance
160         allowance[_from][msg.sender] -= _value;
161         _transfer(_from, _to, _value);
162         return true;
163     }
164     
165      /**
166      * Set allowance for other address
167      *
168      * Allows `_spender` to spend no more than `_value` tokens in your behalf
169      *
170      * @param _spender The address authorized to spend
171      * @param _value the max amount they can spend
172      */
173     function approve(address _spender, uint256 _value) public
174         returns (bool success) {
175         allowance[msg.sender][_spender] = _value;
176         return true;
177     }
178     
179      /**
180      * Set allowance for other address and notify
181      *
182      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
183      *
184      * @param _spender The address authorized to spend
185      * @param _value the max amount they can spend
186      * @param _extraData some extra information to send to the approved contract
187      */
188     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
189         public
190         returns (bool success) {
191         tokenRecipient spender = tokenRecipient(_spender);
192         if (approve(_spender, _value)) {
193             spender.receiveApproval(msg.sender, _value, this, _extraData);
194             return true;
195         }
196     }
197     
198     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
199     /// @param target Address to be frozen
200     /// @param freeze either to freeze it or not
201     function freezeAccount(address target, bool freeze) onlyOwner public {
202         frozenAccount[target] = freeze;
203         emit FrozenFunds(target, freeze);
204     }
205     
206     /// @notice Create `mintedAmount` tokens and send it to `target`
207     /// @param target Address to receive the tokens
208     /// @param mintedAmount the amount of tokens it will receive
209     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
210         balanceOf[target] += mintedAmount;
211         totalSupply += mintedAmount;
212         emit Transfer(this, target, mintedAmount);
213     }
214     
215      /**
216      * Destroy tokens
217      *
218      * Remove `_value` tokens from the system irreversibly
219      *
220      * @param _value the amount of money to burn
221      */
222     function burn(uint256 _value) public returns (bool success) {
223         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
224         balanceOf[msg.sender] -= _value;            // Subtract from the sender
225         totalSupply -= _value;                      // Updates totalSupply
226         emit Burn(msg.sender, _value);
227         return true;
228     }
229     
230     /**
231      * Destroy tokens from other account
232      *
233      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
234      *
235      * @param _from the address of the sender
236      * @param _value the amount of money to burn
237      */
238     function burnFrom(address _from, uint256 _value) public returns (bool success) {
239         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
240         require(_value <= allowance[_from][msg.sender]);    // Check allowance
241         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
242         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
243         totalSupply -= _value;                              // Update totalSupply
244         emit Burn(_from, _value);
245         return true;
246     }
247 
248 
249     /**
250     *@notice Withdraw for Ether
251     */
252      function withdraw(uint withdrawAmount) onlyOwner public  {
253           if (withdrawAmount <= address(this).balance) {
254             owner.transfer(withdrawAmount);
255         }
256         
257      }
258     
259     function () public payable {
260        
261     }
262      
263 }