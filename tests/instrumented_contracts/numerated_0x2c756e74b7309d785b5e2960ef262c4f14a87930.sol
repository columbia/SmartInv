1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 /**
21  * @title Pausable
22  * @dev Base contract which allows children to implement an emergency stop mechanism.
23  */
24 contract Pausable is owned {
25     event Pause();
26     event Unpause();
27 
28     bool public paused = false;
29 
30     /**
31      * @dev modifier to allow actions only when the contract IS paused
32      */
33     modifier whenNotPaused {
34         require(paused == false);
35         _;
36     }
37 
38     /**
39      * @dev modifier to allow actions only when the contract IS NOT paused
40      */
41     modifier whenPaused {
42         require(paused == true);
43         _;
44     }
45 
46     /**
47      * @dev called by the owner to pause, triggers stopped state
48      */
49     function pause() onlyOwner whenNotPaused public returns (bool) {
50         paused = true;
51         emit Pause();
52         return true;
53     }
54 
55     /**
56      * @dev called by the owner to unpause, returns to normal state
57      */
58     function unpause() onlyOwner whenPaused public returns (bool) {
59         paused = false;
60         emit Unpause();
61         return true;
62     }
63 }
64 
65 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
66 
67 contract StandardToken is Pausable {
68     // Variables of the token
69     string public name;
70     string public symbol;
71     uint8 public decimals = 0;
72     uint256 public totalSupply;
73     uint256 public currentSupply;
74     mapping (address => uint256) public balanceOf;
75     mapping (address => mapping (address => uint256)) public allowance;
76 
77 
78     // This generates a public event on the blockchain that will notify clients
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     // This generates a public event on the blockchain that will notify clients
82     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
83 
84     // This notifies clients about the amount burnt
85     event Burn(address indexed from, uint256 value);
86 
87     /**
88      * Constrctor function
89      * Initializes contract with initial supply tokens to the creator of the contract
90      */
91     constructor(
92         uint256 initialSupply,
93         uint256 maxSupply,
94         string tokenName,
95         string tokenSymbol
96     ) public {
97         currentSupply = initialSupply;  // Update total supply with the decimal amount
98         totalSupply = maxSupply;
99         balanceOf[msg.sender] = currentSupply;                    // Give the creator all initial tokens
100         name = tokenName;                                         // Set the name for display purposes
101         symbol = tokenSymbol;                                     // Set the symbol for display purposes
102     }
103 
104     /**
105      * Internal transfer, only can be called by this contract
106      */
107     function _transfer(address _from, address _to, uint _value) internal { 
108         require(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
109         require(balanceOf[_from] >= _value);               // Check if the sender has enough
110         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
111 
112         uint previousBalances = balanceOf[_from] + balanceOf[_to]; // Save this for an assertion in the future
113         balanceOf[_from] -= _value;                                // Subtract from the sender
114         balanceOf[_to] += _value;                                  // Add the same to the recipient
115         emit Transfer(_from, _to, _value);
116 
117         // Asserts are used to use static analysis to find bugs in your code. They should never fail
118         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
119     }
120 
121     /**
122      * Transfer tokens
123      * Send `_value` tokens to `_to` from your account
124      */
125     function transfer(address _to, uint256 _value) whenNotPaused public returns (bool success) {
126         _transfer(msg.sender, _to, _value);
127         return true;
128     }
129     
130     /**
131      * Transfer tokens from other address
132      * Send `_value` tokens to `_to` in behalf of `_from`
133      */
134     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool success) {
135         require(_value <= allowance[_from][msg.sender]);     // Check allowance
136         allowance[_from][msg.sender] -= _value;
137         _transfer(_from, _to, _value);
138         return true;
139     }
140 
141     /**
142      * Set allowance for other address
143      * Allows `_spender` to spend no more than `_value` tokens in your behalf
144      */
145     function approve(address _spender, uint256 _value) whenNotPaused public
146         returns (bool success) {
147         allowance[msg.sender][_spender] = _value;
148         emit Approval(msg.sender, _spender, _value);
149         return true;
150     }
151 
152     function Supplies() view public 
153         returns (uint256 total, uint256 current) {
154         return (totalSupply, currentSupply);
155     }
156 
157     // =========================
158     // ====== Unnecessary ======
159     // =========================
160     /**
161      * Set allowance for other address and notify
162      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
163      */
164     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
165         tokenRecipient spender = tokenRecipient(_spender);
166         if (approve(_spender, _value)) {
167             spender.receiveApproval(msg.sender, _value, this, _extraData);
168             return true;
169         }
170     }
171 
172     /**
173      * Destroy tokens
174      * Remove `_value` tokens from the system irreversibly
175      */
176     function burn(uint256 _value) public returns (bool success) {
177         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
178         balanceOf[msg.sender] -= _value;            // Subtract from the sender
179         currentSupply -= _value;                    // Updates currentSupply
180         emit Burn(msg.sender, _value);
181         return true;
182     }
183 
184     /**
185      * Destroy tokens from other account
186      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
187      */
188     function burnFrom(address _from, uint256 _value) public returns (bool success) {
189         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
190         require(_value <= allowance[_from][msg.sender]);    // Check allowance
191         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
192         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
193         currentSupply -= _value;                            // Update currentSupply
194         emit Burn(_from, _value);
195         return true;
196     }
197 }
198 
199 /******************************************/
200 /*       ADVANCED TOKEN STARTS HERE       */
201 /******************************************/
202 
203 contract AdvancedToken is owned, StandardToken {
204     
205     mapping (address => bool) public frozenAccount;
206 
207     /* Initializes contract with initial supply tokens to the creator of the contract */
208     constructor(
209         uint256 initialSupply,
210         uint256 maxSupply,
211         string tokenName,
212         string tokenSymbol
213     ) StandardToken(initialSupply, maxSupply, tokenName, tokenSymbol) public {}
214 
215     /// @notice Create `mintedAmount` tokens and send it to `target`
216     /// @param target Address to receive the tokens
217     /// @param mintedAmount the amount of tokens it will receive
218     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
219         require (totalSupply >= currentSupply + mintedAmount);
220         balanceOf[target] += mintedAmount;
221         currentSupply += mintedAmount;
222         emit Transfer(0, this, mintedAmount);
223         emit Transfer(this, target, mintedAmount);
224     }
225 
226     /* This generates a public event on the blockchain that will notify clients */
227     event FrozenFunds(address target, bool frozen);
228 
229     /* Internal transfer, only can be called by this contract */
230     function _transfer(address _from, address _to, uint _value) internal {
231         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
232         require (balanceOf[_from] >= _value);               // Check if the sender has enough
233         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
234         require(!frozenAccount[_from]);                     // Check if sender is frozen
235         require(!frozenAccount[_to]);                       // Check if recipient is frozen
236         balanceOf[_from] -= _value;                         // Subtract from the sender
237         balanceOf[_to] += _value;                           // Add the same to the recipient
238         emit Transfer(_from, _to, _value);
239     }
240 
241     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
242     /// @param target Address to be frozen
243     function freezeAccount(address target) onlyOwner public {
244         frozenAccount[target] = true;
245         emit FrozenFunds(target, true);
246     }
247 
248     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
249     /// @param target Address to be frozen
250     function unfreezeAccount(address target) onlyOwner public {
251         frozenAccount[target] = false;
252         emit FrozenFunds(target, false);
253     }
254 
255     function () payable public {
256     }
257 }