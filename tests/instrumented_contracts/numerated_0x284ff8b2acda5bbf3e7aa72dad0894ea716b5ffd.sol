1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
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
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract TokenERC20 is owned{
23     // Public variables of the token
24     string public name = "GoodLuck";
25     string public symbol = "GLK" ;
26     uint8 public decimals = 18;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply=210000000 * 10 ** uint256(decimals);
29 
30     // This creates an array with all balances
31     mapping (address => uint256) public balanceOf;
32 	mapping (address => uint256) public freezeOf;
33     mapping (address => mapping (address => uint256)) public allowance;
34 	bool public paused = false;
35     // This generates a public event on the blockchain that will notify clients
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 
38     // This notifies clients about the amount burnt
39     event Burn(address indexed from, uint256 value);
40 	
41 	// This notifies clients about the amount seo
42     event Seo(address indexed from, uint256 value);
43 
44     /**
45      * Constrctor function
46      *
47      * Initializes contract with initial supply tokens to the creator of the contract
48      */
49     function TokenERC20() public {
50         totalSupply = uint256(totalSupply);  // Update total supply with the decimal amount
51         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
52         name = string(name);                                   // Set the name for display purposes
53         symbol = string(symbol);                               // Set the symbol for display purposes
54     }
55 
56     /**
57      * Internal transfer, only can be called by this contract
58      */
59     function _transfer(address _from, address _to, uint _value) internal {
60         // Prevent transfer to 0x0 address. Use burn() instead
61         require(_to != 0x0);
62         // Check if the sender has enough
63         require(balanceOf[_from] >= _value);
64         // Check for overflows
65         require(balanceOf[_to] + _value > balanceOf[_to]);
66         // Save this for an assertion in the future
67         uint previousBalances = balanceOf[_from] + balanceOf[_to];
68         // Subtract from the sender
69         balanceOf[_from] -= _value;
70         // Add the same to the recipient
71         balanceOf[_to] += _value;
72         Transfer(_from, _to, _value);
73         // Asserts are used to use static analysis to find bugs in your code. They should never fail
74         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
75     }
76 
77     /**
78      * Transfer tokens
79      *
80      * Send `_value` tokens to `_to` from your account
81      *
82      * @param _to The address of the recipient
83      * @param _value the amount to send
84      */
85     function transfer(address _to, uint256 _value) isRunning public {
86         _transfer(msg.sender, _to, _value);
87     }
88 
89     /**
90      * Transfer tokens from other address
91      *
92      * Send `_value` tokens to `_to` in behalf of `_from`
93      *
94      * @param _from The address of the sender
95      * @param _to The address of the recipient
96      * @param _value the amount to send
97      */
98     function transferFrom(address _from, address _to, uint256 _value) isRunning public returns (bool success) {
99         require(_value <= allowance[_from][msg.sender]);     // Check allowance
100         allowance[_from][msg.sender] -= _value;
101         _transfer(_from, _to, _value);
102         return true;
103     }
104 
105     /**
106      * Set allowance for other address
107      *
108      * Allows `_spender` to spend no more than `_value` tokens in your behalf
109      *
110      * @param _spender The address authorized to spend
111      * @param _value the max amount they can spend
112      */
113     function approve(address _spender, uint256 _value) isRunning public
114         returns (bool success) {
115         allowance[msg.sender][_spender] = _value;
116         return true;
117     }
118 
119     /**
120      * Set allowance for other address and notify
121      *
122      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
123      *
124      * @param _spender The address authorized to spend
125      * @param _value the max amount they can spend
126      * @param _extraData some extra information to send to the approved contract
127      */
128     function approveAndCall(address _spender, uint256 _value, bytes _extraData) isRunning
129         public
130         returns (bool success) {
131         tokenRecipient spender = tokenRecipient(_spender);
132         if (approve(_spender, _value)) {
133             spender.receiveApproval(msg.sender, _value, this, _extraData);
134             return true;
135         }
136     }
137 
138     /**
139      * Destroy tokens
140      *
141      * Remove `_value` tokens from the system irreversibly
142      *
143      * @param _value the amount of money to burn
144      */
145     function burn(uint256 _value) isRunning public returns (bool success) {
146         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
147         balanceOf[msg.sender] -= _value;            // Subtract from the sender
148         totalSupply -= _value;                      // Updates totalSupply
149         Burn(msg.sender, _value);
150         return true;
151     }
152 	
153 	
154 	/**
155      * Seo tokens
156      *
157      * Add `_value` tokens to the system irreversibly
158      *
159      * @param _value the amount of money to seo
160      */
161     function seo(uint256 _value) isRunning onlyOwner public returns (bool success) {
162         balanceOf[msg.sender] += _value;            // Subtract from the sender
163         totalSupply += _value;                      // Updates totalSupply
164         Seo(msg.sender, _value);
165         return true;
166     }
167 	
168 	
169 
170     /**
171      * Destroy tokens from other account
172      *
173      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
174      *
175      * @param _from the address of the sender
176      * @param _value the amount of money to burn
177      */
178     function burnFrom(address _from, uint256 _value) isRunning public returns (bool success) {
179         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
180         require(_value <= allowance[_from][msg.sender]);    // Check allowance
181         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
182         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
183         totalSupply -= _value;                              // Update totalSupply
184         Burn(_from, _value);
185         return true;
186     }
187 	
188 	function pause() onlyOwner public {
189         paused = true;
190     }
191 
192     function unpause() onlyOwner public {
193         paused = false;
194     }
195 	
196 	modifier isRunning {
197         assert (!paused);
198         _;
199     }
200 }
201 
202 /******************************************/
203 /*       ADVANCED TOKEN STARTS HERE       */
204 /******************************************/
205 
206 contract MyAdvancedToken is owned, TokenERC20 {
207 
208 
209     mapping (address => bool) public frozenAccount;
210 
211     /* This generates a public event on the blockchain that will notify clients */
212     event FrozenFunds(address target, bool frozen);
213 	/* This notifies clients about the amount frozen */
214     event Freeze(address indexed from, uint256 value);
215 	/* This notifies clients about the amount unfrozen */
216     event Unfreeze(address indexed from, uint256 value);
217 	
218     /* Initializes contract with initial supply tokens to the creator of the contract */
219     function MyAdvancedToken() TokenERC20() public {}
220 
221     /* Internal transfer, only can be called by this contract */
222     function _transfer(address _from, address _to, uint _value) internal {
223         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
224         require (balanceOf[_from] >= _value);               // Check if the sender has enough
225         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
226         require(!frozenAccount[_from]);                     // Check if sender is frozen
227         require(!frozenAccount[_to]);                       // Check if recipient is frozen
228         balanceOf[_from] -= _value;                         // Subtract from the sender
229         balanceOf[_to] += _value;                           // Add the same to the recipient
230         Transfer(_from, _to, _value);
231     }
232 
233 
234     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
235     /// @param target Address to be frozen
236     /// @param freeze either to freeze it or not
237     function freezeAccount(address target, bool freeze) isRunning onlyOwner public {
238         frozenAccount[target] = freeze;
239         FrozenFunds(target, freeze);
240     }
241 	
242 	function freeze(address _target,uint256 _value) isRunning onlyOwner public returns (bool success) {
243         require (balanceOf[_target] >= _value);            // Check if the sender has enough
244 		require (_value > 0); 
245         balanceOf[_target] -= _value;                      // Subtract from the sender
246         freezeOf[_target] += _value;                                // Updates totalSupply
247         Freeze(_target, _value);
248         return true;
249     }
250 	
251 	function unfreeze(address _target,uint256 _value) isRunning onlyOwner public returns (bool success) {
252         require (freezeOf[_target] >= _value);            // Check if the sender has enough
253 		require (_value > 0); 
254         freezeOf[_target]-= _value;                      // Subtract from the sender
255 		balanceOf[_target]+=  _value;
256         Unfreeze(_target, _value);
257         return true;
258     }
259 	
260 }