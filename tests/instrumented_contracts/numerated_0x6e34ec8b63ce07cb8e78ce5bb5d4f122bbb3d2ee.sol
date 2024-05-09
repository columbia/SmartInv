1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipRenounced(address indexed previousOwner);
8   event OwnershipTransferred(
9     address indexed previousOwner,
10     address indexed newOwner
11   );
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   constructor() public {
19     owner = msg.sender;
20   }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to relinquish control of the contract.
32    * @notice Renouncing to ownership will leave the contract without an owner.
33    * It will not be possible to call the functions with the `onlyOwner`
34    * modifier anymore.
35    */
36   function renounceOwnership() public onlyOwner {
37     emit OwnershipRenounced(owner);
38     owner = address(0);
39   }
40 
41   /**
42    * @dev Allows the current owner to transfer control of the contract to a newOwner.
43    * @param _newOwner The address to transfer ownership to.
44    */
45   function transferOwnership(address _newOwner) public onlyOwner {
46     _transferOwnership(_newOwner);
47   }
48 
49   /**
50    * @dev Transfers control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function _transferOwnership(address _newOwner) internal {
54     require(_newOwner != address(0));
55     emit OwnershipTransferred(owner, _newOwner);
56     owner = _newOwner;
57   }
58 }
59 library SafeMath {
60 
61   /**
62   * @dev Multiplies two numbers, reverts on overflow.
63   */
64   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
65     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
66     // benefit is lost if 'b' is also tested.
67     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
68     if (_a == 0) {
69       return 0;
70     }
71 
72     uint256 c = _a * _b;
73     require(c / _a == _b);
74 
75     return c;
76   }
77 
78   /**
79   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
80   */
81   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
82     require(_b > 0); // Solidity only automatically asserts when dividing by 0
83     uint256 c = _a / _b;
84     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
85 
86     return c;
87   }
88 
89   /**
90   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
91   */
92   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
93     require(_b <= _a);
94     uint256 c = _a - _b;
95 
96     return c;
97   }
98 
99   /**
100   * @dev Adds two numbers, reverts on overflow.
101   */
102   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
103     uint256 c = _a + _b;
104     require(c >= _a);
105 
106     return c;
107   }
108 
109   /**
110   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
111   * reverts when dividing by zero.
112   */
113   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
114     require(b != 0);
115     return a % b;
116   }
117 }
118 
119 
120 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
121 
122 contract TokenERC20 {
123 
124     
125     using SafeMath for uint256;
126 
127     // Public variables of the token
128     string public name;
129     string public symbol;
130     uint8 public decimals = 18;
131     // 18 decimals is the strongly suggested default, avoid changing it
132     uint256 public totalSupply;
133 
134     // This creates an array with all balances
135     mapping (address => uint256) public balanceOf;
136     mapping (address => mapping (address => uint256)) public allowance;
137 
138     // This generates a public event on the blockchain that will notify clients
139     event Transfer(address indexed from, address indexed to, uint256 value);
140     
141     // This generates a public event on the blockchain that will notify clients
142     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
143 
144     // This notifies clients about the amount burnt
145     event Burn(address indexed from, uint256 value);
146 
147     /**
148      * Constrctor function
149      *
150      * Initializes contract with initial supply tokens to the creator of the contract
151      */
152  constructor(
153         uint256 initialSupply,
154         string tokenName,
155         string tokenSymbol
156     ) public {
157         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
158         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
159         name = tokenName;                                   // Set the name for display purposes
160         symbol = tokenSymbol;                               // Set the symbol for display purposes
161     }
162 
163     /**
164      * Internal transfer, only can be called by this contract
165      */
166     function _transfer(address _from, address _to, uint _value) internal {
167         // Prevent transfer to 0x0 address. Use burn() instead
168         require(_to != 0x0);
169         // Check if the sender has enough
170         require(balanceOf[_from] >= _value);
171         // Check for overflows
172         require(balanceOf[_to].add(_value) > balanceOf[_to]);
173         // Save this for an assertion in the future
174         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
175         // Subtract from the sender
176         balanceOf[_from] = balanceOf[_from].sub(_value);
177         // Add the same to the recipient
178         balanceOf[_to] = balanceOf[_to].add(_value);
179         emit Transfer(_from, _to, _value);
180         // Asserts are used to use static analysis to find bugs in your code. They should never fail
181         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
182     }
183 
184     /**
185      * Transfer tokens
186      *
187      * Send `_value` tokens to `_to` from your account
188      *
189      * @param _to The address of the recipient
190      * @param _value the amount to send
191      */
192     function transfer(address _to, uint256 _value) public returns (bool success) {
193         _transfer(msg.sender, _to, _value);
194         return true;
195     }
196 
197     /**
198      * Transfer tokens from other address
199      *
200      * Send `_value` tokens to `_to` in behalf of `_from`
201      *
202      * @param _from The address of the sender
203      * @param _to The address of the recipient
204      * @param _value the amount to send
205      */
206     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
207         require(_value <= allowance[_from][msg.sender]);     // Check allowance
208         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
209         _transfer(_from, _to, _value);
210         return true;
211     }
212 
213     /**
214      * Set allowance for other address
215      *
216      * Allows `_spender` to spend no more than `_value` tokens in your behalf
217      *
218      * @param _spender The address authorized to spend
219      * @param _value the max amount they can spend
220      */
221     function approve(address _spender, uint256 _value) public
222         returns (bool success) {
223         allowance[msg.sender][_spender] = _value;
224         emit Approval(msg.sender, _spender, _value);
225         return true;
226     }
227 
228     /**
229      * Set allowance for other address and notify
230      *
231      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
232      *
233      * @param _spender The address authorized to spend
234      * @param _value the max amount they can spend
235      * @param _extraData some extra information to send to the approved contract
236      */
237     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
238         public
239         returns (bool success) {
240         tokenRecipient spender = tokenRecipient(_spender);
241         if (approve(_spender, _value)) {
242             spender.receiveApproval(msg.sender, _value, this, _extraData);
243             return true;
244         }
245     }
246 
247     /**
248      * Destroy tokens
249      *
250      * Remove `_value` tokens from the system irreversibly
251      *
252      * @param _value the amount of money to burn
253      */
254     function burn(uint256 _value) public returns (bool success) {
255         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
256         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
257         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
258         emit Burn(msg.sender, _value);
259         return true;
260     }
261 
262     /**
263      * Destroy tokens from other account
264      *
265      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
266      *
267      * @param _from the address of the sender
268      * @param _value the amount of money to burn
269      */
270     function burnFrom(address _from, uint256 _value) public returns (bool success) {
271         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
272         require(_value <= allowance[_from][msg.sender]);    // Check allowance
273         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
274         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
275         totalSupply = totalSupply.sub(_value);                              // Update totalSupply
276         emit Burn(_from, _value);
277         return true;
278     }
279 }