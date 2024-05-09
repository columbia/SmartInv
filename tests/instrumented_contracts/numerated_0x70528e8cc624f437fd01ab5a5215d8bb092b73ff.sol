1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // 'World meds'  token contract
5 //
6 // Owner Address : 0xa03eaf0b2490f2b13efc772b8344d08b6a03e661
7 // Symbol      : wdmd
8 // Name        : World meds
9 // Total supply: 1000000000
10 // Decimals    : 18
11 // Website     : https://worldwidemeds.online
12 // Email       : info@worldwidemeds.online
13 // POWERED BY World Wide Meds.
14 
15 // (c) by Team @ World Wide Meds 2018.
16 // ----------------------------------------------------------------------------
17 
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22 */
23 
24 library SafeMath {
25     
26     /**
27     * @dev Multiplies two numbers, throws on overflow.
28     */
29     
30     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a * b;
32     assert(a == 0 || c / a == b);
33     return c;
34     }
35     
36     /**
37     * @dev Integer division of two numbers, truncating the quotient.
38     */
39     
40     function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return c;
45     }
46     
47      /**
48     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49     */
50     
51     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52     assert(b <= a);
53     return a - b;
54     }
55     
56     /**
57     * @dev Adds two numbers, throws on overflow.
58     */
59     
60     function add(uint256 a, uint256 b) internal pure returns (uint256) {
61         uint256 c = a + b;
62         assert(c >= a);
63         return c;
64     }
65 }
66 
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71 */
72 
73 contract owned {
74     address public owner;
75 
76     constructor () public {
77         owner = msg.sender;
78     }
79 
80     modifier onlyOwner {
81         require(msg.sender == owner);
82         _;
83     }
84     
85     /**
86    * @dev Allows the current owner to transfer control of the contract to a newOwner.
87    * @param newOwner The address to transfer ownership to.
88    */
89 
90     function transferOwnership(address newOwner) onlyOwner public {
91         owner = newOwner;
92     }
93 }
94 
95 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
96 
97 contract ERC20 is owned {
98     using SafeMath for uint;
99     // Public variables of the token
100     string public name = "World meds";
101     string public symbol = "wdmd";
102     uint8 public decimals = 18;
103     uint256 public totalSupply = 1000000000 * 10 ** uint256(decimals);
104     
105      /// contract that is allowed to create new tokens and allows unlift the transfer limits on this token
106      address public ICO_Contract;
107     // This creates an array with all balances
108     mapping (address => uint256) public balanceOf;
109     mapping (address => mapping (address => uint256)) public allowance;
110     mapping (address => bool) public frozenAccount;
111     
112    // This generates a public event on the blockchain that will notify clients
113     event Transfer(address indexed from, address indexed to, uint256 value);
114     
115     // This notifies clients about the amount burnt
116     event Burn(address indexed from, uint256 value);
117     
118     
119     /* This generates a public event on the blockchain that will notify clients */
120     event FrozenFunds(address target, bool frozen);
121     
122     /**
123      * Constrctor function
124      *
125      * Initializes contract with initial supply tokens to the creator of the contract
126      */
127     constructor () public {
128         balanceOf[owner] = totalSupply;
129     }
130     
131      /**
132      * Internal transfer, only can be called by this contract
133      */
134      
135      function _transfer(address _from, address _to, uint256 _value) internal {
136         // Prevent transfer to 0x0 address. Use burn() instead
137         require(_to != 0x0);
138         // Check if the sender has enough
139         require(balanceOf[_from] >= _value);
140         // Check for overflows
141         require(balanceOf[_to] + _value > balanceOf[_to]);
142         // Check if sender is frozen
143         require(!frozenAccount[_from]);
144         // Check if recipient is frozen
145         require(!frozenAccount[_to]);
146         // Save this for an assertion in the future
147         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
148         // Subtract from the sender
149         balanceOf[_from] -= _value;
150         // Add the same to the recipient
151         balanceOf[_to] += _value;
152         emit Transfer(_from, _to, _value);
153         // Asserts are used to use static analysis to find bugs in your code. They should never fail
154         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
155     }
156     
157      /**
158      * Transfer tokens
159      *
160      * Send `_value` tokens to `_to` from your account
161      *
162      * @param _to The address of the recipient
163      * @param _value the amount to send
164      */
165     function transfer(address _to, uint256 _value) public {
166         _transfer(msg.sender, _to, _value);
167     }
168     
169      /**
170      * Transfer tokens from other address
171      *
172      * Send `_value` tokens to `_to` in behalf of `_from`
173      *
174      * @param _from The address of the sender
175      * @param _to The address of the recipient
176      * @param _value the amount to send
177      */
178     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
179         require(_value <= allowance[_from][msg.sender]);     // Check allowance
180         allowance[_from][msg.sender] -= _value;
181         _transfer(_from, _to, _value);
182         return true;
183     }
184     
185      /**
186      * Set allowance for other address
187      *
188      * Allows `_spender` to spend no more than `_value` tokens in your behalf
189      *
190      * @param _spender The address authorized to spend
191      * @param _value the max amount they can spend
192      */
193     function approve(address _spender, uint256 _value) public
194         returns (bool success) {
195         allowance[msg.sender][_spender] = _value;
196         return true;
197     }
198     
199      /**
200      * Set allowance for other address and notify
201      *
202      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
203      *
204      * @param _spender The address authorized to spend
205      * @param _value the max amount they can spend
206      * @param _extraData some extra information to send to the approved contract
207      */
208     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
209         public
210         returns (bool success) {
211         tokenRecipient spender = tokenRecipient(_spender);
212         if (approve(_spender, _value)) {
213             spender.receiveApproval(msg.sender, _value, this, _extraData);
214             return true;
215         }
216     }
217     
218     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
219     /// @param target Address to be frozen
220     /// @param freeze either to freeze it or not
221     function freezeAccount(address target, bool freeze) onlyOwner public {
222         frozenAccount[target] = freeze;
223         emit FrozenFunds(target, freeze);
224     }
225     
226     /// @notice Create `mintedAmount` tokens and send it to `target`
227     /// @param target Address to receive the tokens
228     /// @param mintedAmount the amount of tokens it will receive
229     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
230         balanceOf[target] += mintedAmount;
231         totalSupply += mintedAmount;
232         emit Transfer(this, target, mintedAmount);
233     }
234     
235      /**
236      * Destroy tokens
237      *
238      * Remove `_value` tokens from the system irreversibly
239      *
240      * @param _value the amount of money to burn
241      */
242     function burn(uint256 _value) public returns (bool success) {
243         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
244         balanceOf[msg.sender] -= _value;            // Subtract from the sender
245         totalSupply -= _value;                      // Updates totalSupply
246         emit Burn(msg.sender, _value);
247         return true;
248     }
249     
250     /**
251      * Destroy tokens from other account
252      *
253      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
254      *
255      * @param _from the address of the sender
256      * @param _value the amount of money to burn
257      */
258     function burnFrom(address _from, uint256 _value) public returns (bool success) {
259         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
260         require(_value <= allowance[_from][msg.sender]);    // Check allowance
261         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
262         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
263         totalSupply -= _value;                              // Update totalSupply
264         emit Burn(_from, _value);
265         return true;
266     }
267     
268     /// @dev Set the ICO_Contract.
269     /// @param _ICO_Contract crowdsale contract address
270     function setICO_Contract(address _ICO_Contract) onlyOwner public {
271         ICO_Contract = _ICO_Contract;
272     }
273      
274 }