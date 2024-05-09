1 pragma solidity ^0.4.16;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
14     assert(b > 0);
15     uint256 c = a / b;
16     assert(a == b * c + a % b);
17     return c;
18   }
19 
20   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
26     uint256 c = a + b;
27     assert(c>=a && c>=b);
28     return c;
29   }
30 
31   function assert(bool assertion) internal {
32     if (!assertion) {
33       throw;
34     }
35   }
36 }
37 
38 contract owned {
39     address public owner;
40 
41     function owned() public {
42         owner = msg.sender;
43     }
44 
45     modifier onlyOwner {
46         require(msg.sender == owner);
47         _;
48     }
49 
50     function transferOwnership(address newOwner) onlyOwner public {
51         owner = newOwner;
52     }
53 }
54 
55 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
56 
57 contract TokenERC20 is owned, SafeMath {
58     // Public variables of the token
59     string public name;
60     string public symbol;
61     uint8 public decimals = 18;
62     // 18 decimals is the strongly suggested default, avoid changing it
63     uint256 public totalSupply;
64 
65     // This creates an array with all balances
66     mapping (address => uint256) public balanceOf;
67     mapping (address => mapping (address => uint256)) public allowance;
68 
69 	mapping (address => bool) public frozenAccount;
70 
71     /* This generates a public event on the blockchain that will notify clients */
72     event FrozenFunds(address target, bool frozen);
73 	
74     // This generates a public event on the blockchain that will notify clients
75     event Transfer(address indexed from, address indexed to, uint256 value);
76     
77     // This generates a public event on the blockchain that will notify clients
78     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
79 
80     // This notifies clients about the amount burnt
81     event Burn(address indexed from, uint256 value);
82 
83     /**
84      * Constrctor function
85      *
86      * Initializes contract with initial supply tokens to the creator of the contract
87      */
88     function TokenERC20(
89         uint256 initialSupply,
90         string tokenName,
91         string tokenSymbol
92     ) public {
93         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
94         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
95         name = tokenName;                                   // Set the name for display purposes
96         symbol = tokenSymbol;                               // Set the symbol for display purposes
97     }
98 
99     /**
100      * Transfer tokens
101      *
102      * Send `_value` tokens to `_to` from your account
103      *
104      * @param _to The address of the recipient
105      * @param _value the amount to send
106      */
107     function transfer(address _to, uint256 _value) public returns (bool success) {
108 		// Prevent transfer to 0x0 address. Use burn() instead
109         require(_to != 0x0);
110 		require(_value > 0);
111         // Check if the sender has enough
112         require(balanceOf[msg.sender] >= _value);
113         // Check for overflows
114         require(balanceOf[_to] + _value > balanceOf[_to]);
115 		// Check if sender is frozen
116 		require(!frozenAccount[msg.sender]);
117 		// Check if recipient is frozen
118         require(!frozenAccount[_to]);
119         // Subtract from the sender
120 		balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
121         // Add the same to the recipient
122         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
123         emit Transfer(msg.sender, _to, _value);
124         return true;
125     }
126 
127     /**
128      * Transfer tokens from other address
129      *
130      * Send `_value` tokens to `_to` in behalf of `_from`
131      *
132      * @param _from The address of the sender
133      * @param _to The address of the recipient
134      * @param _value the amount to send
135      */
136     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
137         // Prevent transfer to 0x0 address. Use burn() instead
138         require(_to != 0x0);
139 		require(_value > 0);
140         // Check if the sender has enough
141         require(balanceOf[_from] >= _value);
142         // Check for overflows
143         require(balanceOf[_to] + _value > balanceOf[_to]);
144 		// Check if sender is frozen
145 		require(!frozenAccount[_from]);
146 		// Check if recipient is frozen
147         require(!frozenAccount[_to]);
148 		// Check allowance
149 		require(_value <= allowance[_from][msg.sender]);
150 		// Subtract from the sender
151 		balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
152         // Add the same to the recipient
153         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
154 		
155         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender],_value);
156 		emit Transfer(_from, _to, _value);
157         return true;
158     }
159 
160     /**
161      * Set allowance for other address
162      *
163      * Allows `_spender` to spend no more than `_value` tokens in your behalf
164      *
165      * @param _spender The address authorized to spend
166      * @param _value the max amount they can spend
167      */
168     function approve(address _spender, uint256 _value) public
169         returns (bool success) {
170 		require(_value > 0);
171         allowance[msg.sender][_spender] = _value;
172         emit Approval(msg.sender, _spender, _value);
173         return true;
174     }
175 
176     /**
177      * Set allowance for other address and notify
178      *
179      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
180      *
181      * @param _spender The address authorized to spend
182      * @param _value the max amount they can spend
183      * @param _extraData some extra information to send to the approved contract
184      */
185     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
186         public
187         returns (bool success) {
188         tokenRecipient spender = tokenRecipient(_spender);
189         if (approve(_spender, _value)) {
190             spender.receiveApproval(msg.sender, _value, this, _extraData);
191             return true;
192         }
193     }
194 
195     /**
196      * Destroy tokens
197      *
198      * Remove `_value` tokens from the system irreversibly
199      *
200      * @param _value the amount of money to burn
201      */
202     function burn(uint256 _value) public returns (bool success) {
203         // Check if the sender has enough
204 		require(balanceOf[msg.sender] >= _value);   
205 		require(_value > 0);
206 		// Subtract from the sender
207         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
208         // Updates totalSupply
209 		totalSupply = SafeMath.safeSub(totalSupply, _value);
210         emit Burn(msg.sender, _value);
211         return true;
212     }
213 
214     /**
215      * Destroy tokens from other account
216      *
217      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
218      *
219      * @param _from the address of the sender
220      * @param _value the amount of money to burn
221      */
222     function burnFrom(address _from, uint256 _value) public returns (bool success) {
223         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
224         require(_value > 0);
225 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
226 		// Subtract from the targeted balance
227         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
228 		// Subtract from the sender's allowance
229         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
230         // Update totalSupply
231 		totalSupply = SafeMath.safeSub(totalSupply, _value);
232         emit Burn(_from, _value);
233         return true;
234     }
235 	
236 	/// @notice Create `mintedAmount` tokens and send it to `target`
237     /// @param target Address to receive the tokens
238     /// @param mintedAmount the amount of tokens it will receive
239     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
240         balanceOf[target] = SafeMath.safeAdd(balanceOf[target], mintedAmount);
241         totalSupply = SafeMath.safeAdd(totalSupply, mintedAmount);
242         emit Transfer(0, this, mintedAmount);
243         emit Transfer(this, target, mintedAmount);
244     }
245 
246     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
247     /// @param target Address to be frozen
248     /// @param freeze either to freeze it or not
249     function freezeAccount(address target, bool freeze) onlyOwner public {
250         frozenAccount[target] = freeze;
251         emit FrozenFunds(target, freeze);
252     }
253 }