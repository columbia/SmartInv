1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 contract owned {
68     address public owner;
69 
70     constructor() public {
71         owner = msg.sender;
72     }
73 
74     modifier onlyOwner {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     function transferOwnership(address newOwner) onlyOwner public {
80         owner = newOwner;
81     }
82 }
83 
84 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
85 
86 contract TokenERC20 is owned{
87     using SafeMath for uint256;
88 
89     // Public variables of the token
90     string public name;
91     string public symbol;
92     uint8 public decimals = 18;
93     // 18 decimals is the strongly suggested default, avoid changing it
94     uint256 public totalSupply;
95     bool public released = true;
96 
97     // This creates an array with all balances
98     mapping (address => uint256) public balanceOf;
99     mapping (address => mapping (address => uint256)) public allowance;
100 
101     // This generates a public event on the blockchain that will notify clients
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 
104     // This generates a public event on the blockchain that will notify clients
105     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
106 
107     // This notifies clients about the amount burnt
108     event Burn(address indexed from, uint256 value);
109 
110     /**
111      * Constrctor function
112      *
113      * Initializes contract with initial supply tokens to the creator of the contract
114      */
115     constructor(
116         uint256 initialSupply,
117         string tokenName,
118         string tokenSymbol
119     ) public {
120         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
121         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
122         name = tokenName;                                   // Set the name for display purposes
123         symbol = tokenSymbol;                               // Set the symbol for display purposes
124     }
125 
126     function release() public onlyOwner{
127       require (owner == msg.sender);
128       released = !released;
129     }
130 
131     modifier onlyReleased() {
132       require(released);
133       _;
134     }
135 
136     /**
137      * Internal transfer, only can be called by this contract
138      */
139     function _transfer(address _from, address _to, uint _value) internal onlyReleased {
140         // Prevent transfer to 0x0 address. Use burn() instead
141         require(_to != 0x0);
142         // Check if the sender has enough
143         require(balanceOf[_from] >= _value);
144         // Check for overflows
145         require(balanceOf[_to] + _value > balanceOf[_to]);
146         // Save this for an assertion in the future
147         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
148         // Subtract from the sender
149         balanceOf[_from] = balanceOf[_from].sub(_value);
150         // Add the same to the recipient
151         balanceOf[_to] = balanceOf[_to].add(_value);
152         emit Transfer(_from, _to, _value);
153         // Asserts are used to use static analysis to find bugs in your code. They should never fail
154         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
155     }
156 
157     /**
158      * Transfer tokens
159      *
160      * Send `_value` tokens to `_to` from your account
161      *
162      * @param _to The address of the recipient
163      * @param _value the amount to send
164      */
165     function transfer(address _to, uint256 _value) public onlyReleased returns (bool success) {
166         _transfer(msg.sender, _to, _value);
167         return true;
168     }
169 
170     /**
171      * Transfer tokens from other address
172      *
173      * Send `_value` tokens to `_to` in behalf of `_from`
174      *
175      * @param _from The address of the sender
176      * @param _to The address of the recipient
177      * @param _value the amount to send
178      */
179     function transferFrom(address _from, address _to, uint256 _value) public onlyReleased returns (bool success) {
180         require(_value <= allowance[_from][msg.sender]);     // Check allowance
181 
182         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
183         _transfer(_from, _to, _value);
184         return true;
185     }
186 
187     /**
188      * Set allowance for other address
189      *
190      * Allows `_spender` to spend no more than `_value` tokens in your behalf
191      *
192      * @param _spender The address authorized to spend
193      * @param _value the max amount they can spend
194      */
195     function approve(address _spender, uint256 _value) public onlyReleased
196         returns (bool success) {
197         require(_spender != address(0));
198 
199         allowance[msg.sender][_spender] = _value;
200         emit Approval(msg.sender, _spender, _value);
201         return true;
202     }
203 
204     /**
205      * Set allowance for other address and notify
206      *
207      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
208      *
209      * @param _spender The address authorized to spend
210      * @param _value the max amount they can spend
211      * @param _extraData some extra information to send to the approved contract
212      */
213     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
214         public onlyReleased
215         returns (bool success) {
216         tokenRecipient spender = tokenRecipient(_spender);
217         if (approve(_spender, _value)) {
218             spender.receiveApproval(msg.sender, _value, this, _extraData);
219             return true;
220         }
221     }
222 
223     /**
224      * Destroy tokens
225      *
226      * Remove `_value` tokens from the system irreversibly
227      *
228      * @param _value the amount of money to burn
229      */
230     function burn(uint256 _value) public onlyReleased returns (bool success) {
231         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
232         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
233         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
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
246     function burnFrom(address _from, uint256 _value) public onlyReleased returns (bool success) {
247         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
248         require(_value <= allowance[_from][msg.sender]);    // Check allowance
249         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
250         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
251         totalSupply = totalSupply.sub(_value);                              // Update totalSupply
252         emit Burn(_from, _value);
253         return true;
254     }
255 }
256 
257 /******************************************/
258 /*       ADVANCED TOKEN STARTS HERE       */
259 /******************************************/
260 
261 contract MyAdvancedToken is owned, TokenERC20 {
262 
263     mapping (address => bool) public frozenAccount;
264 
265     /* This generates a public event on the blockchain that will notify clients */
266     event FrozenFunds(address target, bool frozen);
267 
268     /* Initializes contract with initial supply tokens to the creator of the contract */
269     constructor(
270         uint256 initialSupply,
271         string tokenName,
272         string tokenSymbol
273     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
274 
275       /* Internal transfer, only can be called by this contract */
276       function _transfer(address _from, address _to, uint _value) internal onlyReleased {
277         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
278         require (balanceOf[_from] >= _value);               // Check if the sender has enough
279         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
280         require(!frozenAccount[_from]);                     // Check if sender is frozen
281         require(!frozenAccount[_to]);                       // Check if recipient is frozen
282         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
283         balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
284         emit Transfer(_from, _to, _value);
285     }
286 
287     /// @notice Create `mintedAmount` tokens and send it to `target`
288     /// @param target Address to receive the tokens
289     /// @param mintedAmount the amount of tokens it will receive
290     /// mintedAmount 1000000000000000000 = 1.000000000000000000
291     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
292         require (mintedAmount > 0);
293         totalSupply = totalSupply.add(mintedAmount);
294         balanceOf[target] = balanceOf[target].add(mintedAmount);
295         emit Transfer(0, this, mintedAmount);
296         emit Transfer(this, target, mintedAmount);
297     }
298 
299     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
300     /// @param target Address to be frozen
301     /// @param freeze either to freeze it or not
302     function freezeAccount(address target, bool freeze) onlyOwner public {
303         frozenAccount[target] = freeze;
304         emit FrozenFunds(target, freeze);
305     }
306 
307 }