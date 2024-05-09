1 pragma solidity ^0.4.19;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract BIBRToken {
6 
7     // Public variables of the token
8     string public name;
9     string public symbol;
10     uint8 public decimals = 18;
11     // 18 decimals is the strongly suggested default, avoid changing it
12     uint256 public totalSupply;
13 	address public owner;
14 
15     // This creates an array with all balances
16     mapping (address => uint256) public balanceOf;
17     mapping (address => mapping (address => uint256)) public allowance;
18 	mapping (address => uint256) public freezeOf;
19 
20     // This generates a public event on the blockchain that will notify clients
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     
23     // This generates a public event on the blockchain that will notify clients
24     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
25 
26     // This notifies clients about the amount burnt
27     event Burn(address indexed from, uint256 value);
28 	
29 	/* This notifies clients about the amount frozen */
30     event Freeze(address indexed from, uint256 value);
31 	
32 	/* This notifies clients about the amount unfrozen */
33     event Unfreeze(address indexed from, uint256 value);
34 	
35 	event Mint(uint256 _value);
36 
37     /**
38      * Constructor function
39      *
40      * Initializes contract with initial supply tokens to the creator of the contract
41      */
42     constructor(
43         uint256 initialSupply,
44         string tokenName,
45         string tokenSymbol
46     ) public {
47         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
48         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
49         name = tokenName;                                   // Set the name for display purposes
50         symbol = tokenSymbol;                               // Set the symbol for display purposes
51 		owner = msg.sender;
52     }
53 	
54 	function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
55 		uint256 c = a * b;
56 		assert(a == 0 || c / a == b);
57 		return c;
58     }
59 
60     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
61 		assert(b > 0);
62 		uint256 c = a / b;
63 		assert(a == b * c + a % b);
64 		return c;
65     }
66 
67     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
68 		assert(b <= a);
69 		return a - b;
70    }
71 
72     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
73 		uint256 c = a + b;
74 		assert(c>=a && c>=b);
75 		return c;
76     }
77 
78     /**
79      * Internal transfer, only can be called by this contract
80      */
81     function _transfer(address _from, address _to, uint _value) internal {
82         // Prevent transfer to 0x0 address. Use burn() instead
83         require(_to != 0x0);
84         // Check if the sender has enough
85         require(balanceOf[_from] >= _value);
86         // Check for overflows
87         require(balanceOf[_to] + _value >= balanceOf[_to]);
88         // Save this for an assertion in the future
89         uint previousBalances = balanceOf[_from] + balanceOf[_to];
90         // Subtract from the sender
91         balanceOf[_from] -= _value;
92         // Add the same to the recipient
93         balanceOf[_to] += _value;
94         emit Transfer(_from, _to, _value);
95         // Asserts are used to use static analysis to find bugs in your code. They should never fail
96         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
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
108         _transfer(msg.sender, _to, _value);
109         return true;
110     }
111 
112     /**
113      * Transfer tokens from other address
114      *
115      * Send `_value` tokens to `_to` on behalf of `_from`
116      *
117      * @param _from The address of the sender
118      * @param _to The address of the recipient
119      * @param _value the amount to send
120      */
121     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
122         require(_value <= allowance[_from][msg.sender]);     // Check allowance
123         allowance[_from][msg.sender] -= _value;
124         _transfer(_from, _to, _value);
125         return true;
126     }
127 
128     /**
129      * Set allowance for other address
130      *
131      * Allows `_spender` to spend no more than `_value` tokens on your behalf
132      *
133      * @param _spender The address authorized to spend
134      * @param _value the max amount they can spend
135      */
136     function approve(address _spender, uint256 _value) public
137         returns (bool success) {
138         allowance[msg.sender][_spender] = _value;
139         emit Approval(msg.sender, _spender, _value);
140         return true;
141     }
142 
143     /**
144      * Set allowance for other address and notify
145      *
146      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
147      *
148      * @param _spender The address authorized to spend
149      * @param _value the max amount they can spend
150      * @param _extraData some extra information to send to the approved contract
151      */
152     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
153         public
154         returns (bool success) {
155         tokenRecipient spender = tokenRecipient(_spender);
156         if (approve(_spender, _value)) {
157             spender.receiveApproval(msg.sender, _value, this, _extraData);
158             return true;
159         }
160     }
161 
162     /**
163      * Destroy tokens
164      *
165      * Remove `_value` tokens from the system irreversibly
166      *
167      * @param _value the amount of money to burn
168      */
169     function burn(uint256 _value) public returns (bool success) {
170         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
171         balanceOf[msg.sender] -= _value;            // Subtract from the sender
172         totalSupply -= _value;                      // Updates totalSupply
173         emit Burn(msg.sender, _value);
174         return true;
175     }
176 	
177 	/**
178      * mint tokens
179      *
180      * add `_value` tokens from the system irreversibly
181      *
182      * @param _value the amount of money to mint
183      */
184     function mint(uint256 _value) public returns (bool success) {
185 		require((msg.sender == owner));             // Only the owner can do this
186         balanceOf[msg.sender] += _value;            // add coin for sender
187         totalSupply += _value;                      // Updates totalSupply
188         emit Mint(_value);
189         return true;
190     }
191 
192     /**
193      * Destroy tokens from other account
194      *
195      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
196      *
197      * @param _from the address of the sender
198      * @param _value the amount of money to burn
199      */
200     function burnFrom(address _from, uint256 _value) public returns (bool success) {
201         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
202         require(_value <= allowance[_from][msg.sender]);    // Check allowance
203         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
204         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
205         totalSupply -= _value;                              // Update totalSupply
206         emit Burn(_from, _value);
207         return true;
208     }
209 	
210 	function freeze(uint256 _value) public returns (bool success) {
211         require(balanceOf[msg.sender] >= _value);            // Check if the sender has enough
212 		require(_value > 0); 
213         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
214         freezeOf[msg.sender] = safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
215         emit Freeze(msg.sender, _value);
216         return true;
217     }
218 	
219 	function unfreeze(uint256 _value) public returns (bool success) {
220         require(freezeOf[msg.sender] >= _value);            // Check if the sender has enough
221 		require(_value > 0); 
222         freezeOf[msg.sender] = safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
223 		balanceOf[msg.sender] = safeAdd(balanceOf[msg.sender], _value);
224         emit Unfreeze(msg.sender, _value);
225         return true;
226     }
227 	
228     function setName (string _value) public returns (bool success) {
229         require(msg.sender == owner);
230         name = _value;
231         return true;
232     }
233 	
234 	 function setSymbol (string _value) public returns (bool success) {
235         require(msg.sender == owner);
236         symbol = _value;
237         return true;
238     }
239 	
240 }