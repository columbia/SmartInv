1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint a, uint b) internal pure returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13  
14   function div(uint a, uint b) internal pure returns (uint) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20  
21   function sub(uint a, uint b) internal pure returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25  
26   function add(uint a, uint b) internal pure returns (uint) {
27     uint c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract ERC20 {
34     /// @return total amount of tokens
35     uint public totalSupply;
36 
37     /// @param _owner The address from which the balance will be retrieved
38     /// @return The balance
39     function balanceOf(address _owner) public constant returns (uint balance);
40 
41     /// @notice send `_value` token to `_to` from `msg.sender`
42     /// @param _to The address of the recipient
43     /// @param _value The amount of token to be transferred
44     /// @return Whether the transfer was successful or not
45     function transfer(address _to, uint _value) public returns (bool success);
46 
47     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
48     /// @param _from The address of the sender
49     /// @param _to The address of the recipient
50     /// @param _value The amount of token to be transferred
51     /// @return Whether the transfer was successful or not
52     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
53 
54     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
55     /// @param _spender The address of the account able to transfer the tokens
56     /// @param _value The amount of wei to be approved for transfer
57     /// @return Whether the approval was successful or not
58     function approve(address _spender, uint _value) public returns (bool success);
59 
60     /// @param _owner The address of the account owning tokens
61     /// @param _spender The address of the account able to transfer the tokens
62     /// @return Amount of remaining tokens allowed to spent
63     function allowance(address _owner, address _spender) public view returns (uint remaining);
64 
65     event Transfer(address indexed _from, address indexed _to, uint _value);
66     event Approval(address indexed _owner, address indexed _spender, uint _value);
67 }
68 
69 contract BDToken is ERC20 {
70     using SafeMath for uint;
71 	
72     uint constant private MAX_UINT256 = 2**256 - 1;
73 	uint8 constant public decimals = 18;
74     string public name;
75     string public symbol;
76 	address public owner;
77 	// True if transfers are allowed
78 	bool public transferable = true;
79     /* This creates an array with all balances */
80 	mapping (address => uint) freezes;
81     mapping (address => uint) balances;
82     mapping (address => mapping (address => uint)) allowed;
83 
84     modifier onlyOwner {
85         require(msg.sender == owner);//"Only owner can call this function."
86         _;
87     }
88 	
89 	modifier canTransfer() {
90 		require(transferable == true);
91 		_;
92 	}
93 	
94     /* This notifies clients about the amount burnt */
95     event Burn(address indexed from, uint value);
96 	/* This notifies clients about the amount frozen */
97     event Freeze(address indexed from, uint value);
98 	/* This notifies clients about the amount unfrozen */
99     event Unfreeze(address indexed from, uint value);
100 
101     /* Initializes contract with initial supply tokens to the creator of the contract */
102     function BDToken() public {
103 		totalSupply = 100*10**26; // Update total supply with the decimal amount
104 		name = "BaoDe Token";
105 		symbol = "BDT";
106 		balances[msg.sender] = totalSupply; // Give the creator all initial tokens
107 		owner = msg.sender;
108 		emit Transfer(address(0), msg.sender, totalSupply);
109     }
110 
111     /* Send coins */
112     function transfer(address _to, uint _value) public canTransfer returns (bool success) {
113 		require(_to != address(0));// Prevent transfer to 0x0 address.
114 		require(_value > 0);
115         require(balances[msg.sender] >= _value); // Check if the sender has enough
116         require(balances[_to] + _value >= balances[_to]); // Check for overflows
117 		
118 		balances[msg.sender] = balances[msg.sender].sub(_value); // Subtract from the sender
119         balances[_to] = balances[_to].add(_value);  // Add the same to the recipient
120         emit Transfer(msg.sender, _to, _value);   // Notify anyone listening that this transfer took place
121 		return true;
122     }
123 
124 	/* A contract attempts to get the coins */
125     function transferFrom(address _from, address _to, uint _value) public canTransfer returns (bool success) {
126         uint allowance = allowed[_from][msg.sender];
127 		require(_to != address(0));// Prevent transfer to 0x0 address.
128 		require(_value > 0);
129 		require(balances[_from] >= _value); // Check if the sender has enough
130 		require(allowance >= _value); // Check allowance
131         require(balances[_to] + _value >= balances[_to]); // Check for overflows     
132         
133         balances[_from] = balances[_from].sub(_value);      // Subtract from the sender
134         balances[_to] = balances[_to].add(_value);          // Add the same to the recipient
135 		if (allowance < MAX_UINT256) {
136 			allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
137 		}
138         emit Transfer(_from, _to, _value);
139         return true;
140     }
141 	
142     /* Allow another contract to spend some tokens in your behalf */
143     function approve(address _spender, uint _value) public canTransfer returns (bool success) {
144 		require(_value >= 0);
145         allowed[msg.sender][_spender] = _value;
146         emit Approval(msg.sender, _spender, _value);
147         return true;
148     }
149     
150 	function balanceOf(address _owner) public view returns (uint balance) {
151         return balances[_owner];
152     }
153 
154 	function allowance(address _owner, address _spender) public view returns (uint remaining) {
155         return allowed[_owner][_spender];
156     }
157 	
158 	function freezeOf(address _owner) public view returns (uint freeze) {
159         return freezes[_owner];
160     }
161 	
162     function burn(uint _value) public canTransfer returns (bool success) {
163 		require(balances[msg.sender] >= _value); // Check if the sender has enough
164 		require(_value > 0);
165         balances[msg.sender] = balances[msg.sender].sub(_value);  // Subtract from the sender
166         totalSupply = totalSupply.sub(_value);                    // Updates totalSupply
167         emit Burn(msg.sender, _value);
168         return true;
169     }
170 	
171 	function freeze(uint _value) public canTransfer returns (bool success) {
172 		require(balances[msg.sender] >= _value); // Check if the sender has enough
173 		require(_value > 0);
174 		require(freezes[msg.sender] + _value >= freezes[msg.sender]); // Check for overflows
175 		
176         balances[msg.sender] = balances[msg.sender].sub(_value);  // Subtract from the sender
177         freezes[msg.sender] = freezes[msg.sender].add(_value);  
178         emit Freeze(msg.sender, _value);
179         return true;
180     }
181 	
182 	function unfreeze(uint _value) public canTransfer returns (bool success) {
183 		require(freezes[msg.sender] >= _value);  // Check if the sender has enough          
184 		require(_value > 0);
185 		require(balances[msg.sender] + _value >= balances[msg.sender]); // Check for overflows
186 		
187         freezes[msg.sender] = freezes[msg.sender].sub(_value);  // Subtract from the sender
188 		balances[msg.sender] = balances[msg.sender].add(_value);
189         emit Unfreeze(msg.sender, _value);
190         return true;
191     }
192 	
193 	/**
194 	* @dev Transfer tokens to multiple addresses
195 	* @param _addresses The addresses that will receieve tokens
196 	* @param _amounts The quantity of tokens that will be transferred
197 	* @return True if the tokens are transferred correctly
198 	*/
199 	function transferForMultiAddresses(address[] _addresses, uint[] _amounts) public canTransfer returns (bool) {
200 		for (uint i = 0; i < _addresses.length; i++) {
201 		  require(_addresses[i] != address(0)); // Prevent transfer to 0x0 address.
202 		  require(_amounts[i] > 0);
203 		  require(balances[msg.sender] >= _amounts[i]); // Check if the sender has enough
204           require(balances[_addresses[i]] + _amounts[i] >= balances[_addresses[i]]); // Check for overflows
205 
206 		  // SafeMath.sub will throw if there is not enough balance.
207 		  balances[msg.sender] = balances[msg.sender].sub(_amounts[i]);
208 		  balances[_addresses[i]] = balances[_addresses[i]].add(_amounts[i]);
209 		  emit Transfer(msg.sender, _addresses[i], _amounts[i]);
210 		}
211 		return true;
212 	}
213 	
214 	function stop() public onlyOwner {
215         transferable = false;
216     }
217 
218     function start() public onlyOwner {
219         transferable = true;
220     }
221 	
222 	function transferOwnership(address newOwner) public onlyOwner {
223 		owner = newOwner;
224 	}
225 	
226 	// transfer balance to owner
227 	function withdrawEther(uint amount) public onlyOwner {
228 		require(amount > 0);
229 		owner.transfer(amount);
230 	}
231 	
232 	// can accept ether
233 	function() public payable {
234     }
235 	
236 }