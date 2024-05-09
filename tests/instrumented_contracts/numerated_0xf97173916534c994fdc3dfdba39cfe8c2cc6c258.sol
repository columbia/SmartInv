1 pragma solidity ^0.4.21;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7 
8 	function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9 		uint256 c = a * b;
10 		require(a == 0 || c / a == b);
11 		return c;
12 	}
13 
14 	function div(uint256 a, uint256 b) internal constant returns (uint256) {
15 		uint256 c = a / b;
16 		return c;
17 	}
18 
19 	function sub(uint256 a, uint256 b) internal constant returns (uint256) {
20 		require(b <= a);
21 		return a - b;
22 	}
23 
24 	function add(uint256 a, uint256 b) internal constant returns (uint256) {
25 		uint256 c = a + b;
26 		require(c>=a && c>=b);
27 		return c;
28 	}
29 }
30 
31 contract UNBInterface {
32 
33 	/// total amount of tokens
34 	uint256 public totalSupply;
35 
36 	/// @notice send `_value` token to `_to` from `msg.sender`
37 	/// @param _to The address of the recipient
38 	/// @param _value The amount of token to be transferred
39 	/// @return Whether the transfer was successful or not
40 	function transfer(address _to, uint256 _value) public returns (bool success);
41 
42 	/// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
43 	/// @param _from The address of the sender
44 	/// @param _to The address of the recipient
45 	/// @param _value The amount of token to be transferred
46 	/// @return Whether the transfer was successful or not
47 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
48 
49 	/// @param _owner The address from which the balance will be retrieved
50 	/// @return The balance
51 	function balanceOf(address _owner) public view returns (uint256 balance);
52 
53 	/// @notice `msg.sender` approves `_spender` to spend `_value` tokens
54 	/// @param _spender The address of the account able to transfer the tokens
55 	/// @param _value The amount of tokens to be approved for transfer
56 	/// @return Whether the approval was successful or not
57 	function approve(address _spender, uint256 _value) public returns (bool success);
58 
59 	/// @param _owner The address of the account owning tokens
60 	/// @param _spender The address of the account able to transfer the tokens
61 	/// @return Amount of remaining tokens allowed to spent
62 	function allowance(address _owner, address _spender) public view returns (uint256 remaining);
63 
64 	// solhint-disable-next-line no-simple-event-func-name
65 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
66 
67 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
68 	
69 	/* This notifies clients about the amount burnt */
70     event Burn(address indexed from, uint256 value);
71 	
72 	/* This notifies clients about the amount frozen */
73     event Freeze(address indexed from, uint256 value);
74 	
75 	/* This notifies clients about the amount unfrozen */
76     event Unfreeze(address indexed from, uint256 value);
77 }
78 
79 contract UNB is UNBInterface {
80 
81 	using SafeMath for uint256;
82 
83     uint256 constant private MAX_UINT256 = 2**256 - 1;
84     
85     mapping (address => uint256) public balances;
86 	
87 	mapping (address => uint256) public freezes;
88     
89     mapping (address => mapping (address => uint256)) public allowed;
90 
91     /*
92     NOTE:
93     The following variables are OPTIONAL vanities. One does not have to include them.
94     They allow one to customise the token contract & in no way influences the core functionality.
95     Some wallets/
96     
97     
98      might not even bother to look at this information.
99     */
100     string public name;                   //fancy name: eg Simon Bucks
101     uint8 public decimals;                //How many decimals to show.
102     string public symbol;                 //An identifier: eg SBX
103 
104     function UNB (
105         uint256 _initialAmount,
106         string _tokenName,
107         uint8 _decimalUnits,
108         string _tokenSymbol
109     ) public {
110         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
111         totalSupply = _initialAmount;                        // Update total supply
112         name = _tokenName;                                   // Set the name for display purposes
113         decimals = _decimalUnits;                            // Amount of decimals for display purposes
114         symbol = _tokenSymbol;                               // Set the symbol for display purposes
115     }
116 
117     /// @notice send `_value` token to `_to` from `msg.sender`
118     /// @param _to The address of the recipient
119     /// @param _value The amount of token to be transferred
120     /// @return Whether the transfer was successful or not
121     function transfer(address _to, uint256 _value) public returns (bool success) {
122         require(_to != 0x0);
123         require(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]);
124         balances[msg.sender] -= _value;
125         balances[_to] += _value;
126         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
127         return true;
128     }
129 
130     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
131     /// @param _from The address of the sender
132     /// @param _to The address of the recipient
133     /// @param _value The amount of token to be transferred
134     /// @return Whether the transfer was successful or not
135     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
136         uint256 allowance = allowed[_from][msg.sender];
137         require(balances[_from] >= _value && allowance >= _value && balances[_to] + _value >= balances[_to]);
138         require(_to != 0x0);
139         balances[_to] += _value;
140         balances[_from] -= _value;
141         if (allowance < MAX_UINT256) {
142             allowed[_from][msg.sender] -= _value;
143         }
144         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
145         return true;
146     }
147 
148     /// @param _owner The address from which the balance will be retrieved
149     /// @return The balance
150     function balanceOf(address _owner) public view returns (uint256 balance) {
151         return balances[_owner];
152     }
153 
154     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
155     /// @param _spender The address of the account able to transfer the tokens
156     /// @param _value The amount of tokens to be approved for transfer
157     /// @return Whether the approval was successful or not
158     function approve(address _spender, uint256 _value) public returns (bool success) {
159         allowed[msg.sender][_spender] = _value;
160         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
161         return true;
162     }
163 
164     /// @param _owner The address of the account owning tokens
165     /// @param _spender The address of the account able to transfer the tokens
166     /// @return Amount of remaining tokens allowed to spent
167     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
168         return allowed[_owner][_spender];
169     }
170 	
171 	function burn(uint256 _value) public returns (bool success) {
172 		require(_value > 0); 
173         require(balances[msg.sender] >= _value);            // Check if the sender has enough
174         balances[msg.sender] = balances[msg.sender].sub(_value);                      // Subtract from the sender
175         totalSupply = totalSupply.sub(_value);                                // Updates totalSupply
176         emit Burn(msg.sender, _value);
177         return true;
178     }
179 	
180 	function freeze(uint256 _value) public returns (bool success) {
181 		require(_value > 0); 
182         require(balances[msg.sender] >= _value);            // Check if the sender has enough
183         balances[msg.sender] = balances[msg.sender].sub(_value);                      // Subtract from the sender
184         freezes[msg.sender] = freezes[msg.sender].add(_value);                                // Updates totalSupply
185         emit Freeze(msg.sender, _value);
186         return true;
187     }
188 	
189 	function unfreeze(uint256 _value) public returns (bool success) {
190 		require(_value > 0); 
191 		require(freezes[msg.sender] >= _value);// Check if the sender has enough
192         freezes[msg.sender] = freezes[msg.sender].sub(_value);                      // Subtract from the sender
193 		balances[msg.sender] = balances[msg.sender].add(_value);
194         emit Unfreeze(msg.sender, _value);
195         return true;
196     }
197 }