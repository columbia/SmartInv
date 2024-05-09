1 pragma solidity ^0.4.19;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() public constant returns (uint supply);
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) public constant returns (uint balance);
11 
12     /// @notice send `_value` token to `_to` from `msg.sender`
13     /// @param _to The address of the recipient
14     /// @param _value The amount of token to be transferred
15     /// @return Whether the transfer was successful or not
16     function transfer(address _to, uint _value) public returns (bool success);
17 
18     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
19     /// @param _from The address of the sender
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
24 
25     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @param _value The amount of wei to be approved for transfer
28     /// @return Whether the approval was successful or not
29     function approve(address _spender, uint _value) public returns (bool success);
30 
31     /// @param _owner The address of the account owning tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @return Amount of remaining tokens allowed to spent
34     function allowance(address _owner, address _spender) public constant returns (uint remaining);
35 
36     event Transfer(address indexed _from, address indexed _to, uint _value);
37     event Approval(address indexed _owner, address indexed _spender, uint _value);
38 }
39 
40 contract RegularToken is Token {
41 
42     function transfer(address _to, uint _value) public returns (bool) {
43         //Default assumes totalSupply can't be over max (2^256 - 1).
44         if (balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
45             balances[msg.sender] -= _value;
46             balances[_to] += _value;
47             emit Transfer(msg.sender, _to, _value);
48             return true;
49         } else { return false; }
50     }
51 
52     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
53         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
54             balances[_to] += _value;
55             balances[_from] -= _value;
56             allowed[_from][msg.sender] -= _value;
57             emit Transfer(_from, _to, _value);
58             return true;
59         } else { return false; }
60     }
61 
62     function balanceOf(address _owner) public constant returns (uint)  {
63         return balances[_owner];
64     }
65 
66     function approve(address _spender, uint _value) public returns (bool) {
67 		if (_value >= 0){
68 		    allowed[msg.sender][_spender] = _value;
69 			emit Approval(msg.sender, _spender, _value);
70 			return true;
71 		} else { return false; }
72     }
73 
74     function allowance(address _owner, address _spender) public constant returns (uint) {
75         return allowed[_owner][_spender];
76     }
77 	
78     mapping (address => uint) balances;
79     mapping (address => mapping (address => uint)) allowed;
80     uint public totalSupply;
81 }
82 
83 contract UnboundedRegularToken is RegularToken {
84 
85     uint constant MAX_UINT = 2**256 - 1;
86     
87     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited amount.
88     /// @param _from Address to transfer from.
89     /// @param _to Address to transfer to.
90     /// @param _value Amount to transfer.
91     /// @return Success of transfer.
92     function transferFrom(address _from, address _to, uint _value)
93         public returns (bool)
94     {
95         uint allowance = allowed[_from][msg.sender];
96         if (balances[_from] >= _value
97             && allowance >= _value
98             && balances[_to] + _value >= balances[_to]
99         ) {
100             balances[_to] += _value;
101             balances[_from] -= _value;
102             if (allowance < MAX_UINT) {
103                 allowed[_from][msg.sender] -= _value;
104             }
105             emit Transfer(_from, _to, _value);
106             return true;
107         } else {
108             return false;
109         }
110     }
111 }
112 
113 contract BYToken is UnboundedRegularToken {
114 
115     uint public totalSupply = 5*10**10;
116     uint8 constant public decimals = 2;
117     string constant public name = "BYB Token";
118     string constant public symbol = "BY2";
119 	address public owner;
120 	mapping (address => uint) public freezes;
121 
122 	/* This notifies clients about the amount burnt */
123     event Burn(address indexed from, uint value);
124 	
125 	/* This notifies clients about the amount frozen */
126     event Freeze(address indexed from, uint value);
127 	
128 	/* This notifies clients about the amount unfrozen */
129     event Unfreeze(address indexed from, uint value);
130 	
131     function BYToken() public {
132         balances[msg.sender] = totalSupply;
133 		owner = msg.sender;
134         emit Transfer(address(0), msg.sender, totalSupply);
135     }
136 	
137 	function totalSupply() public constant returns (uint){
138 		return totalSupply;
139 	}
140     
141     function burn(uint _value) public returns (bool success) {
142 		if (balances[msg.sender] >= _value && totalSupply - _value <= totalSupply){
143 			balances[msg.sender] -= _value; 								// Subtract from the sender
144             totalSupply -= _value;
145 			emit Burn(msg.sender, _value);
146 			return true;
147 		}else {
148             return false;
149         }    
150     }
151 	
152 	function freeze(uint _value) public returns (bool success) {
153 		if (balances[msg.sender] >= _value &&
154 		freezes[msg.sender] + _value >= freezes[msg.sender]){
155 			balances[msg.sender] -= _value;   				// Subtract from the sender
156 			freezes[msg.sender] += _value;            		// Updates totalSupply
157 			emit Freeze(msg.sender, _value);
158 			return true;
159 		}else {
160             return false;
161         }  
162     }
163 	
164 	function unfreeze(uint _value) public returns (bool success) {
165         if (freezes[msg.sender] >= _value &&
166 		balances[msg.sender] + _value >= balances[msg.sender]){
167 			freezes[msg.sender] -= _value;
168 			balances[msg.sender] += _value;
169 			emit Unfreeze(msg.sender, _value);
170 			return true;
171 		}else {
172             return false;
173         } 
174     }
175 	
176 	function transferAndCall(address _to, uint _value, bytes _extraData) public returns (bool success) {
177 		if(transfer(_to,_value)){
178 			if(_to.call(bytes4(bytes32(keccak256("receiveTransfer(address,uint,address,bytes)"))), msg.sender, _value, this, _extraData)) { return true; }
179 		}
180 		else {
181             return false;
182         } 
183     }
184 	
185 	function approveAndCall(address _spender, uint _value, bytes _extraData) public returns (bool success) {
186 		if(approve(_spender,_value)){
187 			if(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint,address,bytes)"))), msg.sender, _value, this, _extraData)) { return true; }
188 		}
189 		else {
190             return false;
191         } 
192     }
193 	
194 	// transfer balance to owner
195 	function withdrawEther(uint amount) public {
196 		if(msg.sender == owner){
197 			owner.transfer(amount);
198 		}
199 	}
200 	
201 	// can accept ether
202 	function() public payable {
203     }
204 }