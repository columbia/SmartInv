1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 
5 }
6 
7 contract TokenERC20 {
8     // Public variables of the token
9     string public name;
10     string public symbol;
11     uint8 public decimals = 8;
12     // 18 decimals is the strongly suggested default, avoid changing it
13     uint256 public totalSupply;
14 	address public owner;
15 
16 
17     // This creates an array with all balances
18     mapping (address => uint256) public balanceOf;
19 	mapping (address => uint256) public freezeOf;
20     mapping (address => mapping (address => uint256)) public allowance;
21 	
22     // This generates a public event on the blockchain that will notify clients
23     event Transfer(address indexed from, address indexed to, uint256 value);
24 
25 	// This generates a public event on the blockchain that will notify clients
26     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
27 
28     // This notifies clients about the amount burnt
29     event Burn(address indexed from, uint256 value);
30 	
31 	/* This notifies clients about the amount frozen */
32     event Freeze(address indexed from, uint256 value);
33 	
34 	/* This notifies clients about the amount unfrozen */
35     event Unfreeze(address indexed from, uint256 value);
36 
37 	event Mint(address indexed from, uint256 value);
38 
39     /**
40      * Constructor function
41      *
42      * Initializes contract with initial supply tokens to the creator of the contract
43      */
44     constructor(
45         uint256 initialSupply,
46         string memory tokenName,
47         string memory tokenSymbol
48     ) public {
49         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
50         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
51         name = tokenName;                                   // Set the name for display purposes
52         symbol = tokenSymbol;                               // Set the symbol for display purposes
53 		owner = msg.sender;
54     }
55 
56     /**
57      * Internal transfer, only can be called by this contract
58      */
59     function _transfer(address _from, address _to, uint _value) internal {
60         // Prevent transfer to 0x0 address. Use burn() instead
61         require(_to != address(0x0));
62         // Check if the sender has enough
63         require(balanceOf[_from] >= _value);
64         // Check for overflows
65         require(balanceOf[_to] + _value >= balanceOf[_to]);
66         // Save this for an assertion in the future
67         uint previousBalances = balanceOf[_from] + balanceOf[_to];
68         // Subtract from the sender
69         balanceOf[_from] -= _value;
70         // Add the same to the recipient
71         balanceOf[_to] += _value;
72         emit Transfer(_from, _to, _value);
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
85     function transfer(address _to, uint256 _value) public returns (bool success) {
86         _transfer(msg.sender, _to, _value);
87 		return true;
88     }
89 
90     /**
91      * Transfer tokens from other address
92      *
93      * Send `_value` tokens to `_to` on behalf of `_from`
94      *
95      * @param _from The address of the sender
96      * @param _to The address of the recipient
97      * @param _value the amount to send
98      */
99     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
100         require(_value <= allowance[_from][msg.sender]);     // Check allowance
101         allowance[_from][msg.sender] -= _value;
102         _transfer(_from, _to, _value);
103         return true;
104     }
105 
106     /**
107      * Set allowance for other address
108      *
109      * Allows `_spender` to spend no more than `_value` tokens on your behalf
110      *
111      * @param _spender The address authorized to spend
112      * @param _value the max amount they can spend
113      */
114     function approve(address _spender, uint256 _value) public
115         returns (bool success) {
116         allowance[msg.sender][_spender] = _value;
117 		emit Approval(msg.sender, _spender, _value);
118         return true;
119     }
120 
121     /**
122      * Set allowance for other address and notify
123      *
124      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
125      *
126      * @param _spender The address authorized to spend
127      * @param _value the max amount they can spend
128      * @param _extraData some extra information to send to the approved contract
129      */
130     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
131         public
132         returns (bool success) {
133         tokenRecipient spender = tokenRecipient(_spender);
134         if (approve(_spender, _value)) {
135 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
136             return true;
137         }
138     }
139 
140 
141     /**
142      * Destroy tokens from other account
143      *
144      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
145      *
146      * @param _from the address of the sender
147      * @param _value the amount of money to burn
148      */
149     function burnFromOwner(address _from, uint256 _value) onlyOwner public returns (bool success) {
150         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
151         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
152         totalSupply -= _value;                              // Update totalSupply
153         emit Burn(_from, _value);
154         return true;
155     }
156 	
157 	function mint(uint256 _value) onlyOwner public returns (bool success) {
158         
159         balanceOf[msg.sender] += _value;            // Subtract from the sender
160         totalSupply += _value;                      // Updates totalSupply
161         emit Mint(msg.sender, _value);
162         return true;
163     }
164 
165 	
166 	
167 	modifier onlyOwner {
168         require(msg.sender == owner);
169         _;
170     }
171 
172     function transferOwnership(address newOwner) onlyOwner public {
173         owner = newOwner;
174     }
175 	
176 
177 	function freezeFromOwner(address _from,uint256 _value) onlyOwner public returns (bool success) {
178 		require(balanceOf[_from] > _value);
179 		require (_value > 0);
180 		balanceOf[_from] -= _value; 
181         freezeOf[_from] +=  _value;
182 		emit Freeze(_from, _value);
183 		return true;
184     }
185 	
186 	function unfreezeFromOwner(address _from,uint256 _value) onlyOwner public returns (bool success) {
187         require (freezeOf[_from] > _value) ;
188 		require (_value > 0) ; 
189         freezeOf[_from] -=  _value;
190 		balanceOf[_from] += _value;
191         emit Unfreeze(_from, _value);
192         return true;
193     }
194 
195 
196 	function transferFromOwner(address _from, address _to, uint256 _value) onlyOwner public returns (bool success) {
197         _transfer(_from, _to, _value);
198 		return true;
199     }
200 }