1 pragma solidity ^0.5.11;
2 
3 contract SafeMath {
4     // Overflow protected math functions
5 
6     /**
7         @dev returns the sum of _x and _y, asserts if the calculation overflows
8 
9         @param _x   value 1
10         @param _y   value 2
11 
12         @return sum
13     */
14     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
15         uint256 z = _x + _y;
16         require(z >= _x);        //assert(z >= _x);
17         return z;
18     }
19 
20     /**
21         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
22 
23         @param _x   minuend
24         @param _y   subtrahend
25 
26         @return difference
27     */
28     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
29         require(_x >= _y);        //assert(_x >= _y);
30         return _x - _y;
31     }
32 
33     /**
34         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
35 
36         @param _x   factor 1
37         @param _y   factor 2
38 
39         @return product
40     */
41     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
42         uint256 z = _x * _y;
43         require(_x == 0 || z / _x == _y);        //assert(_x == 0 || z / _x == _y);
44         return z;
45     }
46 	
47 	function safeDiv(uint256 _x, uint256 _y)internal pure returns (uint256){
48 	    // assert(b > 0); // Solidity automatically throws when dividing by 0
49         // uint256 c = a / b;
50         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51         return _x / _y;
52 	}
53 	
54 	function ceilDiv(uint256 _x, uint256 _y)internal pure returns (uint256){
55 		return (_x + _y - 1) / _y;
56 	}
57 }
58 
59 contract SBToken is SafeMath {
60 	mapping (address => uint256) balances;
61 	address public owner;
62     string public name;
63     string public symbol;
64     uint8 public decimals = 18;
65 	
66 	// total amount of tokens
67     uint256 public totalSupply;
68     
69 	// `allowed` tracks any extra transfer rights as in all ERC20 tokens
70     mapping (address => mapping (address => uint256)) allowed;
71 
72     constructor() public {
73         uint256 initialSupply = 10000000000;
74         
75         owner = msg.sender;
76         totalSupply = initialSupply * 10 ** uint256(decimals);
77         balances[owner] = totalSupply;
78         name = "SBToken";
79         symbol = "SBC";
80     }
81 	
82     /// @param _owner The address from which the balance will be retrieved
83     /// @return The balance
84     function balanceOf(address _owner) public view returns (uint256 balance) {
85 		 return balances[_owner];
86 	}
87 
88     /// @notice send `_value` token to `_to` from `msg.sender`
89     /// @param _to The address of the recipient
90     /// @param _value The amount of token to be transferred
91     /// @return Whether the transfer was successful or not
92     function transfer(address _to, uint256 _value) public returns (bool success) {
93 	    require(_value > 0 );                                          // Check send token value > 0;
94 		require(balances[msg.sender] >= _value);                       // Check if the sender has enough
95         require(balances[_to] + _value > balances[_to]);               // Check for overflows											
96     	balances[msg.sender] = safeSub(balances[msg.sender], _value);  // Subtract from the sender
97 		balances[_to]  = safeAdd(balances[_to], _value);               // Add the same to the recipient                       
98 	    if(_to == address(0)) {
99 	        _burn(_to, _value);
100 	    }
101 	
102 		emit Transfer(msg.sender, _to, _value); 			       // Notify anyone listening that this transfer took place
103 		return true;      
104 	}
105 
106     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
107     /// @param _from The address of the sender
108     /// @param _to The address of the recipient
109     /// @param _value The amount of token to be transferred
110     /// @return Whether the transfer was successful or not
111     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
112 	  
113 	    require(balances[_from] >= _value);                 // Check if the sender has enough
114         require(balances[_to] + _value >= balances[_to]);   // Check for overflows
115         require(_value <= allowed[_from][msg.sender]);      // Check allowance
116         balances[_from] = safeSub(balances[_from], _value);  // Subtract from the sender
117         balances[_to] = safeAdd(balances[_to], _value);      // Add the same to the recipient
118        
119         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
120         
121         if(_to == address(0)) {
122 	        _burn(_to, _value);
123 	    }
124         
125         emit Transfer(_from, _to, _value);
126         return true;
127 	}
128 
129     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
130     /// @param _spender The address of the account able to transfer the tokens
131     /// @param _value The amount of tokens to be approved for transfer
132     /// @return Whether the approval was successful or not
133     function approve(address _spender, uint256 _value) public returns (bool success) {
134 		require(balances[msg.sender] >= _value);
135 		allowed[msg.sender][_spender] = _value;
136         emit Approval(msg.sender, _spender, _value);
137 		return true;
138 	
139 	}
140 	
141     /// @param _owner The address of the account owning tokens
142     /// @param _spender The address of the account able to transfer the tokens
143     /// @return Amount of remaining tokens allowed to spent
144     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
145         return allowed[_owner][_spender];
146 	}
147 	
148    /// @param _account must be the zero address and must have at least `amount` tokens
149    /// @param _value The amount of tokens to been burned
150     function _burn(address _account, uint256 _value) internal {
151         require(_account == address(0), "ERC20: burn to the zero address");
152         totalSupply =  safeSub(totalSupply, _value);
153     }
154 	
155 	/* This unnamed function is called whenever someone tries to send ether to it */
156     function () external {
157         revert();     // Prevents accidental sending of ether
158     }
159 
160     event Transfer(address indexed _from, address indexed _to, uint256 _value);
161     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
162 }