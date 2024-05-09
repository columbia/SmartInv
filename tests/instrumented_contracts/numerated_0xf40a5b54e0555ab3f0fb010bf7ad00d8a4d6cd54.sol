1 pragma solidity >=0.4.22 <0.6.0;
2 	
3 
4 	contract owned {
5 	    address public owner;
6 	
7 
8 	    constructor() public {
9 	        owner = msg.sender;
10 	    }
11 	
12 
13 	    modifier onlyOwner {
14 	        require(msg.sender == owner);
15 	        _;
16 	    }
17 	
18 
19 	    function transferOwnership(address newOwner) onlyOwner public {
20 	        owner = newOwner;
21 	    }
22 	}
23 	
24 
25 	interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
26 	
27 
28 	}
29 	contract WSKY {
30 	    // Public variables of the token
31 	    string public name;
32 	    string public symbol;
33 	    uint8 public decimals = 18;
34 	    // 18 decimals is the strongly suggested default, avoid changing it
35 	    uint256 public totalSupply;
36 	
37 
38 	    // This creates an array with all balances
39 	    mapping (address => uint256) public balanceOf;
40 	    mapping (address => mapping (address => uint256)) public allowance;
41 	    mapping (address => bool) public frozenAccount;
42 	
43 
44 	    // This generates a public event on the blockchain that will notify clients
45 	    event Transfer(address indexed from, address indexed to, uint256 value);
46 	    
47 	    // This generates a public event on the blockchain that will notify clients
48 	    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
49 	
50 
51 	    // This notifies clients about the amount burnt
52 	    event Burn(address indexed from, uint256 value);
53 	
54 
55 	    /**
56 	     * Constructor function
57 	     *
58 	     * Initializes contract with initial supply tokens to the creator of the contract
59 	     */
60 	    constructor(
61 	
62 
63 	    ) public {
64 	        totalSupply = 100000000 * 10 ** uint256(18);  // Update total supply with the decimal amount
65 	        balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
66 	        name = "WSKY";                                       // Set the name for display purposes
67 	        symbol = "WSKY";                                   // Set the symbol for display purposes
68 	    }
69 	
70 
71 	    /**
72 	     * Internal transfer, only can be called by this contract
73 	     */
74 	    function _transfer(address _from, address _to, uint _value) internal {
75 	        // Prevent transfer to 0x0 address. Use burn() instead
76 	        require(_to != address(0x0));
77 	        // Check if the sender has enough
78 	        require(balanceOf[_from] >= _value);
79 	        // Check for overflows
80 	        require(balanceOf[_to] + _value > balanceOf[_to]);
81 	        // Save this for an assertion in the future
82 	        uint previousBalances = balanceOf[_from] + balanceOf[_to];
83 	        // Subtract from the sender
84 	        balanceOf[_from] -= _value;
85 	        // Add the same to the recipient
86 	        balanceOf[_to] += _value;
87 	        emit Transfer(_from, _to, _value);
88 	        // Asserts are used to use static analysis to find bugs in your code. They should never fail
89 	        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
90 	    }
91 	
92 
93 	    /**
94 	     * Transfer tokens
95 	     *
96 	     * Send `_value` tokens to `_to` from your account
97 	     *
98 	     * @param _to The address of the recipient
99 	     * @param _value the amount to send
100 	     */
101 	    function transfer(address _to, uint256 _value) public returns (bool success) {
102 	        _transfer(msg.sender, _to, _value);
103 	        return true;
104 	    }
105 	
106 
107 	    /**
108 	     * Transfer tokens from other address
109 	     *
110 	     * Send `_value` tokens to `_to` in behalf of `_from`
111 	     *
112 	     * @param _from The address of the sender
113 	     * @param _to The address of the recipient
114 	     * @param _value the amount to send
115 	     */
116 	    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
117 	        require(_value <= allowance[_from][msg.sender]);     // Check allowance
118 	        allowance[_from][msg.sender] -= _value;
119 	        _transfer(_from, _to, _value);
120 	        return true;
121 	    }
122 	
123 
124 	    /**
125 	     * Set allowance for other address
126 	     *
127 	     * Allows `_spender` to spend no more than `_value` tokens in your behalf
128 	     *
129 	     * @param _spender The address authorized to spend
130 	     * @param _value the max amount they can spend
131 	     */
132 	    function approve(address _spender, uint256 _value) public
133 	        returns (bool success) {
134 	        allowance[msg.sender][_spender] = _value;
135 	        emit Approval(msg.sender, _spender, _value);
136 	        return true;
137 	    }
138 	
139 
140 	    /**
141 	     * Set allowance for other address and notify
142 	     *
143 	     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
144 	     *
145 	     * @param _spender The address authorized to spend
146 	     * @param _value the max amount they can spend
147 	     * @param _extraData some extra information to send to the approved contract
148 	     */
149 	    function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
150 	        public
151 	        returns (bool success) {
152 	        tokenRecipient spender = tokenRecipient(_spender);
153 	        if (approve(_spender, _value)) {
154 	            spender.receiveApproval(msg.sender, _value, address(this), _extraData);
155 	            return true;
156 	        }
157 	    }
158 	
159 
160 	    /**
161 	     * Destroy tokens
162 	     *
163 	     * Remove `_value` tokens from the system irreversibly
164 	     *
165 	     * @param _value the amount of money to burn
166 	     */
167 	    function burn(uint256 _value) public returns (bool success) {
168 	        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
169 	        balanceOf[msg.sender] -= _value;            // Subtract from the sender
170 	        totalSupply -= _value;                      // Updates totalSupply
171 	        emit Burn(msg.sender, _value);
172 	        return true;
173 	    }
174 	
175 	    /**
176 	     * Destroy tokens from other account
177 	     *
178 	     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
179 	     *
180 	     * @param _from the address of the sender
181 	     * @param _value the amount of money to burn
182 	     */
183 	    function burnFrom(address _from, uint256 _value) public returns (bool success) {
184 	        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
185 	        require(_value <= allowance[_from][msg.sender]);    // Check allowance
186 	        balanceOf[_from] -= _value;                         // Subtract from the targeted balance
187 	        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
188 	        totalSupply -= _value;                              // Update totalSupply
189 	        emit Burn(_from, _value);
190 	        return true;
191 	    }
192 	}