1 pragma solidity ^0.5.8;
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
59 contract XDCToken is SafeMath {
60 	mapping (address => uint256) balances;
61 	address public owner = msg.sender;
62     string public name;
63     string public symbol;
64     uint8 public decimals = 18;
65 	// total amount of tokens
66     uint256 public totalSupply;
67     
68 	// `allowed` tracks any extra transfer rights as in all ERC20 tokens
69     mapping (address => mapping (address => uint256)) allowed;
70 
71     constructor() public {
72         uint256 initialSupply = 100000000;
73         
74         totalSupply = initialSupply * 10 ** uint256(decimals);
75         balances[owner] = totalSupply;
76         name = "XueDaoCoin";
77         symbol = "XDC";
78     }
79 	
80     /// @param _owner The address from which the balance will be retrieved
81     /// @return The balance
82     function balanceOf(address _owner) public view returns (uint256 balance) {
83 		 return balances[_owner];
84 	}
85 
86     /// @notice send `_value` token to `_to` from `msg.sender`
87     /// @param _to The address of the recipient
88     /// @param _value The amount of token to be transferred
89     /// @return Whether the transfer was successful or not
90     function transfer(address _to, uint256 _value) public returns (bool success) {
91 	    require(_value > 0 );                                          // Check send token value > 0;
92 		require(balances[msg.sender] >= _value);                       // Check if the sender has enough
93         require(balances[_to] + _value > balances[_to]);               // Check for overflows											
94     	balances[msg.sender] = safeSub(balances[msg.sender], _value);  // Subtract from the sender
95 		balances[_to]  = safeAdd(balances[_to], _value);               // Add the same to the recipient                       
96 	
97 		emit Transfer(msg.sender, _to, _value); 			       // Notify anyone listening that this transfer took place
98 		return true;      
99 	}
100 
101     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
102     /// @param _from The address of the sender
103     /// @param _to The address of the recipient
104     /// @param _value The amount of token to be transferred
105     /// @return Whether the transfer was successful or not
106     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
107 	  
108 	    require(balances[_from] >= _value);                 // Check if the sender has enough
109         require(balances[_to] + _value >= balances[_to]);   // Check for overflows
110         require(_value <= allowed[_from][msg.sender]);      // Check allowance
111         balances[_from] = safeSub(balances[_from], _value);  // Subtract from the sender
112         balances[_to] = safeAdd(balances[_to], _value);      // Add the same to the recipient
113        
114         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
115         
116         emit Transfer(_from, _to, _value);
117         return true;
118 	}
119 
120     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
121     /// @param _spender The address of the account able to transfer the tokens
122     /// @param _value The amount of tokens to be approved for transfer
123     /// @return Whether the approval was successful or not
124     function approve(address _spender, uint256 _value) public returns (bool success) {
125 		require(balances[msg.sender] >= _value);
126 		allowed[msg.sender][_spender] = _value;
127         emit Approval(msg.sender, _spender, _value);
128 		return true;
129 	
130 	}
131 	
132     /// @param _owner The address of the account owning tokens
133     /// @param _spender The address of the account able to transfer the tokens
134     /// @return Amount of remaining tokens allowed to spent
135     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
136         return allowed[_owner][_spender];
137 	}
138 	
139 	/* This unnamed function is called whenever someone tries to send ether to it */
140     function () external {
141         revert();     // Prevents accidental sending of ether
142     }
143 
144     event Transfer(address indexed _from, address indexed _to, uint256 _value);
145     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
146 }