1 pragma solidity ^0.4.21;
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
67 		allowed[msg.sender][_spender] = _value;
68 		emit Approval(msg.sender, _spender, _value);
69     }
70 
71     function allowance(address _owner, address _spender) public constant returns (uint) {
72         return allowed[_owner][_spender];
73     }
74 	
75     mapping (address => uint) balances;
76     mapping (address => mapping (address => uint)) allowed;
77     uint public totalSupply;
78 }
79 
80 contract UnboundedRegularToken is RegularToken {
81 
82     uint constant MAX_UINT = 2**256 - 1;
83     
84     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited amount.
85     /// @param _from Address to transfer from.
86     /// @param _to Address to transfer to.
87     /// @param _value Amount to transfer.
88     /// @return Success of transfer.
89     function transferFrom(address _from, address _to, uint _value)
90         public returns (bool)
91     {
92         uint allowance = allowed[_from][msg.sender];
93         if (balances[_from] >= _value
94             && allowance >= _value
95             && balances[_to] + _value >= balances[_to]
96         ) {
97             balances[_to] += _value;
98             balances[_from] -= _value;
99             if (allowance < MAX_UINT) {
100                 allowed[_from][msg.sender] -= _value;
101             }
102             emit Transfer(_from, _to, _value);
103             return true;
104         } else {
105             return false;
106         }
107     }
108 }
109 
110 contract ApprovalReceiver {
111     function receiveApproval(address _from, uint _value, address _tokenContract, bytes _extraData) public;
112 }
113 contract TransferReceiver {
114     function receiveTransfer(address _from, uint _value, address _tokenContract, bytes _extraData) public;
115 }
116 
117 contract DOGToken is UnboundedRegularToken {
118 
119     uint public totalSupply = 21*10**15;
120     uint8 constant public decimals = 8;
121     string constant public name = "DOG Token";
122     string constant public symbol = "DOG";
123 	address public owner;
124 	mapping (address => uint) public freezes;
125 
126 	/* This notifies clients about the amount burnt */
127     event Burn(address indexed from, uint value);
128 	
129 	/* This notifies clients about the amount frozen */
130     event Freeze(address indexed from, uint value);
131 	
132 	/* This notifies clients about the amount unfrozen */
133     event Unfreeze(address indexed from, uint value);
134 	
135     function DOGToken() public {
136         balances[msg.sender] = totalSupply;
137 		owner = msg.sender;
138         emit Transfer(address(0), msg.sender, totalSupply);
139     }
140 	
141 	function totalSupply() public constant returns (uint){
142 		return totalSupply;
143 	}
144     
145     function burn(uint _value) public returns (bool success) {
146 		if (balances[msg.sender] >= _value && totalSupply - _value <= totalSupply){
147 			balances[msg.sender] -= _value; 								// Subtract from the sender
148             totalSupply -= _value;
149 			emit Burn(msg.sender, _value);
150 			return true;
151 		}else {
152             return false;
153         }    
154     }
155 	
156 	function freeze(uint _value) public returns (bool success) {
157 		if (balances[msg.sender] >= _value &&
158 		freezes[msg.sender] + _value >= freezes[msg.sender]){
159 			balances[msg.sender] -= _value;   				// Subtract from the sender
160 			freezes[msg.sender] += _value;            		// Updates totalSupply
161 			emit Freeze(msg.sender, _value);
162 			return true;
163 		}else {
164             return false;
165         }  
166     }
167 	
168 	function unfreeze(uint _value) public returns (bool success) {
169         if (freezes[msg.sender] >= _value &&
170 		balances[msg.sender] + _value >= balances[msg.sender]){
171 			freezes[msg.sender] -= _value;
172 			balances[msg.sender] += _value;
173 			emit Unfreeze(msg.sender, _value);
174 			return true;
175 		}else {
176             return false;
177         } 
178     }
179 	
180 	function transferAndCall(address _to, uint _value, bytes _extraData) public returns (bool success) {
181 		if(transfer(_to,_value)){
182 			TransferReceiver(_to).receiveTransfer(msg.sender, _value, this, _extraData); 
183 			return true; 
184 		}
185 		else {
186             return false;
187         } 
188     }
189 	
190 	function approveAndCall(address _spender, uint _value, bytes _extraData) public returns (bool success) {
191 		if(approve(_spender,_value)){
192 			ApprovalReceiver(_spender).receiveApproval(msg.sender, _value, this, _extraData) ;
193 			return true; 
194 		}
195 		else {
196             return false;
197         }  
198     }
199 	
200 	// transfer balance to owner
201 	function withdrawEther(uint amount) public {
202 		if(msg.sender == owner){
203 			owner.transfer(amount);
204 		}
205 	}
206 	
207 	// can accept ether
208 	function() public payable {
209     }
210 }