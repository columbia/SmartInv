1 pragma solidity ^0.4.21;
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
36 contract owned {
37 
38     address public owner;
39 
40     function owned() public {
41         owner = msg.sender;
42     }
43 
44     modifier onlyOwner {
45         require(msg.sender == owner);
46         _;
47     }
48 
49     function transferOwnership(address newOwner) onlyOwner public {
50         owner = newOwner;
51     }
52 }
53 
54 /**
55  * @title Pausable
56  * @dev Base contract which allows children to implement an emergency stop mechanism.
57  */
58 contract Pausable is owned {
59   event Pause();
60   event Unpause();
61 
62   bool public paused = false;
63 
64 
65   /**
66    * @dev modifier to allow actions only when the contract IS paused
67    */
68   modifier whenNotPaused() {
69     require(false == paused);
70     _;
71   }
72 
73   /**
74    * @dev modifier to allow actions only when the contract IS NOT paused
75    */
76   modifier whenPaused {
77     require(true == paused);
78     _;
79   }
80 
81   /**
82    * @dev called by the owner to pause, triggers stopped state
83    */
84   function pause() onlyOwner whenNotPaused public returns (bool) {
85     paused = true;
86     emit Pause();
87     return true;
88   }
89 
90   /**
91    * @dev called by the owner to unpause, returns to normal state
92    */
93   function unpause() onlyOwner whenPaused public returns (bool) {
94     paused = false;
95     emit Unpause();
96     return true;
97   }
98 }
99 
100 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
101 
102 contract CustomToken is Pausable{
103     using SafeMath for uint256;
104     
105     // Public variables of the token
106     string public name;
107     string public symbol;
108     uint8 public decimals;
109     
110     // 18 decimals is the strongly suggested default, avoid changing it
111     uint256 public totalSupply;
112 
113     // This creates an array with all balances
114     mapping (address => uint256) public balanceOf;
115 
116     // This generates a public event on the blockchain that will notify clients
117     event Transfer(address indexed from, address indexed to, uint256 value);
118 
119     /**
120      * Constrctor function
121      *
122      * Initializes contract with initial supply tokens to the creator of the contract
123      */
124     function CustomToken (
125         string tokenName,
126         string tokenSymbol
127     ) public {
128         decimals = 18;
129         name = tokenName;                                           // Set the name for display purposes
130         symbol = tokenSymbol;                                       // Set the symbol for display purposes
131     }
132     
133     /**
134      * Transfer tokens
135      *
136      * Send `_value` tokens to `_to` from your account
137      *
138      * @param _to The address of the recipient
139      * @param _value the amount to send
140      */
141     function transfer(address _to, uint256 _value) whenNotPaused public {
142         _transfer(msg.sender, _to, _value);
143     }
144 
145     /**
146      * Internal transfer, only can be called by this contract
147      */
148     function _transfer(address _from, address _to, uint _value) internal {
149         // Prevent transfer to 0x0 address. Use burn() instead
150         require(_to != 0x0);
151         // Check if the sender has enough
152         require(balanceOf[_from] >= _value);
153         // Check for overflows
154         require(balanceOf[_to].add(_value) > balanceOf[_to]);
155         // Save this for an assertion in the future
156         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
157         // Subtract from the sender
158         balanceOf[_from] = balanceOf[_from].sub(_value);
159         // Add the same to the recipient
160         balanceOf[_to] = balanceOf[_to].add(_value);
161         emit Transfer(_from, _to, _value);
162         // Asserts are used to use static analysis to find bugs in your code. They should never fail
163         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
164     }
165 }
166 
167 /******************************************/
168 /*       ADVANCED TOKEN STARTS HERE       */
169 /******************************************/
170 
171 contract GMCToken is CustomToken {
172     string tokenName        = "GMCToken";        // Set the name for display purposes
173     string tokenSymbol      = "GMC";             // Set the symbol for display purposes
174         
175     mapping (address => bool) public frozenAccount;
176 
177     /* This generates a public event on the blockchain that will notify clients */
178     event FrozenFunds(address target, bool frozen);
179     // This notifies clients about the amount burnt
180     event Burn(address indexed from, uint256 value);
181 
182     /* Initializes contract with initial supply tokens to the creator of the contract */
183     function GMCToken() CustomToken(tokenName, tokenSymbol) public {}
184 
185     /* Internal transfer, only can be called by this contract */
186     function _transfer(address _from, address _to, uint _value) internal {
187         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
188         require (balanceOf[_from] >= _value);               // Check if the sender has enough
189         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
190         require(!frozenAccount[_from]);                     // Check if sender is frozen
191         require(!frozenAccount[_to]);                       // Check if recipient is frozen
192         balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the sender
193         balanceOf[_to] = balanceOf[_to].add(_value);        // Add the same to the recipient
194         emit Transfer(_from, _to, _value);
195     }
196     
197     /// @notice Create `mintedAmount` tokens and send it to `msg.sender`
198     /// @param mintedAmount the amount of tokens it will receive
199     function mintToken(uint256 mintedAmount) onlyOwner public {
200         uint256 mintSupply = mintedAmount.mul(10 ** uint256(decimals));
201         balanceOf[msg.sender] = balanceOf[msg.sender].add(mintSupply);
202         totalSupply = totalSupply.add(mintSupply);
203         emit Transfer(0, this, mintSupply);
204         emit Transfer(this, msg.sender, mintSupply);
205     }
206 
207     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
208     /// @param target Address to be frozen
209     /// @param freeze either to freeze it or not
210     function freezeAccount(address target, bool freeze) onlyOwner public {
211         frozenAccount[target] = freeze;
212         emit FrozenFunds(target, freeze);
213     }
214     
215     /**
216      * Destroy tokens
217      *
218      * Remove `_value` tokens from the system irreversibly
219      *
220      * @param _value the amount of money to burn
221      */
222     function burn(uint256 _value) onlyOwner public returns (bool success) {
223         require(balanceOf[msg.sender] >= _value);                       // Check if the sender has enough
224         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);      // Subtract from the sender
225         totalSupply = totalSupply.sub(_value);                          // Updates totalSupply
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
238     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
239         require(balanceOf[_from] >= _value);                    // Check if the targeted balance is enough
240         balanceOf[_from] = balanceOf[_from].sub(_value);        // Subtract from the targeted balance
241         totalSupply = totalSupply.sub(_value);                  // Update totalSupply
242         emit Burn(_from, _value);
243         return true;
244     }
245 }