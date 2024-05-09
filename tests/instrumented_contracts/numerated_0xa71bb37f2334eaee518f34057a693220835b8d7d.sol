1 pragma solidity ^0.4.19;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 
6 contract EremitCash{
7 
8     // Public variables of the token
9     string public name;
10     string public symbol;
11     uint8 public decimals = 18;
12     // 18 decimals is the strongly suggested default, avoid changing it
13     uint256 public totalSupply;
14 	address public owner;
15 
16     // This creates an array with all balances
17     mapping (address => uint256) public balanceOf;
18     mapping (address => mapping (address => uint256)) public allowance;
19 	mapping (address => uint256) public freezeOf;
20 
21     // This generates a public event on the blockchain that will notify clients
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     
24     // This generates a public event on the blockchain that will notify clients
25     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
26 
27     // This notifies clients about the amount burnt
28     event Burn(address indexed from, uint256 value);
29 	
30 	/* This notifies clients about the amount frozen */
31     event Freeze(address indexed from, uint256 value);
32 	
33 	/* This notifies clients about the amount unfrozen */
34     event Unfreeze(address indexed from, uint256 value);
35 	
36 	event Mint(uint256 _value);
37 
38     /**
39      * Constructor function
40      *
41      * Initializes contract with initial supply tokens to the creator of the contract
42      */
43     constructor(
44         uint256 initialSupply,
45         string tokenName,
46         string tokenSymbol
47     ) public {
48         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
49         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
50         name = tokenName;                                   // Set the name for display purposes
51         symbol = tokenSymbol;                               // Set the symbol for display purposes
52 		owner = msg.sender;
53     }
54 	
55 	function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
56 		uint256 c = a * b;
57 		assert(a == 0 || c / a == b);
58 		return c;
59     }
60 
61     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
62 		assert(b > 0);
63 		uint256 c = a / b;
64 		assert(a == b * c + a % b);
65 		return c;
66     }
67 
68     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
69 		assert(b <= a);
70 		return a - b;
71    }
72 
73     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
74 		uint256 c = a + b;
75 		assert(c>=a && c>=b);
76 		return c;
77     }
78 
79     /**
80      * Internal transfer, only can be called by this contract
81      */
82     function _transfer(address _from, address _to, uint _value) internal {
83         // Prevent transfer to 0x0 address. Use burn() instead
84         require(_to != 0x0);
85         // Check if the sender has enough
86         require(balanceOf[_from] >= _value);
87         // Check for overflows
88         require(balanceOf[_to] + _value >= balanceOf[_to]);
89         // Save this for an assertion in the future
90         uint previousBalances = balanceOf[_from] + balanceOf[_to];
91         // Subtract from the sender
92         balanceOf[_from] -= _value;
93         // Add the same to the recipient
94         balanceOf[_to] += _value;
95         emit Transfer(_from, _to, _value);
96         // Asserts are used to use static analysis to find bugs in your code. They should never fail
97         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
98     }
99 
100     /**
101      * Transfer tokens
102      *
103      * Send `_value` tokens to `_to` from your account
104      *
105      * @param _to The address of the recipient
106      * @param _value the amount to send
107      */
108     function transfer(address _to, uint256 _value) public returns (bool success) {
109         _transfer(msg.sender, _to, _value);
110         return true;
111     }
112 
113     /**
114      * Transfer tokens from other address
115      *
116      * Send `_value` tokens to `_to` on behalf of `_from`
117      *
118      * @param _from The address of the sender
119      * @param _to The address of the recipient
120      * @param _value the amount to send
121      */
122     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
123         require(_value <= allowance[_from][msg.sender]);     // Check allowance
124         allowance[_from][msg.sender] -= _value;
125         _transfer(_from, _to, _value);
126         return true;
127     }
128 
129     /**
130      * Set allowance for other address
131      *
132      * Allows `_spender` to spend no more than `_value` tokens on your behalf
133      *
134      * @param _spender The address authorized to spend
135      * @param _value the max amount they can spend
136      */
137     function approve(address _spender, uint256 _value) public
138         returns (bool success) {
139         allowance[msg.sender][_spender] = _value;
140         emit Approval(msg.sender, _spender, _value);
141         return true;
142     }
143 
144     /**
145      * Set allowance for other address and notify
146      *
147      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
148      *
149      * @param _spender The address authorized to spend
150      * @param _value the max amount they can spend
151      * @param _extraData some extra information to send to the approved contract
152      */
153     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
154         public
155         returns (bool success) {
156         tokenRecipient spender = tokenRecipient(_spender);
157         if (approve(_spender, _value)) {
158             spender.receiveApproval(msg.sender, _value, this, _extraData);
159             return true;
160         }
161     }
162 
163     /**
164      * Destroy tokens
165      *
166      * Remove `_value` tokens from the system irreversibly
167      *
168      * @param _value the amount of money to burn
169      */
170     function burn(uint256 _value) public returns (bool success) {
171         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
172         balanceOf[msg.sender] -= _value;            // Subtract from the sender
173         totalSupply -= _value;                      // Updates totalSupply
174         emit Burn(msg.sender, _value);
175         return true;
176     }
177 	
178 	/**
179      * mint tokens
180      *
181      * add `_value` tokens from the system irreversibly
182      *
183      * @param _value the amount of money to mint
184      */
185     function mint(uint256 _value) public returns (bool success) {
186 		require((msg.sender == owner));             // Only the owner can do this
187         balanceOf[msg.sender] += _value;            // add coin for sender
188         totalSupply += _value;                      // Updates totalSupply
189         emit Mint(_value);
190         return true;
191     }
192 
193     /**
194      * Destroy tokens from other account
195      *
196      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
197      *
198      * @param _from the address of the sender
199      * @param _value the amount of money to burn
200      */
201     function burnFrom(address _from, uint256 _value) public returns (bool success) {
202         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
203         require(_value <= allowance[_from][msg.sender]);    // Check allowance
204         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
205         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
206         totalSupply -= _value;                              // Update totalSupply
207         emit Burn(_from, _value);
208         return true;
209     }
210 	
211 	function freeze(uint256 _value) public returns (bool success) {
212         require(balanceOf[msg.sender] >= _value);            // Check if the sender has enough
213 		require(_value > 0); 
214         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
215         freezeOf[msg.sender] = safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
216         emit Freeze(msg.sender, _value);
217         return true;
218     }
219 	
220 	function unfreeze(uint256 _value) public returns (bool success) {
221         require(freezeOf[msg.sender] >= _value);            // Check if the sender has enough
222 		require(_value > 0); 
223         freezeOf[msg.sender] = safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
224 		balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], _value);
225         emit Unfreeze(msg.sender, _value);
226         return true;
227     }
228 }