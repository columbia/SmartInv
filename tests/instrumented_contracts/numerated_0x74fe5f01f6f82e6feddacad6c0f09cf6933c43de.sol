1 pragma solidity ^0.4.16;
2 
3 // ERC Token Standard #20 Interface
4 // https://github.com/ethereum/EIPs/issues/20
5 contract TokenERC20 {
6     /* This is a slight change to the ERC20 base standard.
7     function totalSupply() constant returns (uint256 supply);
8     is replaced with:
9     uint256 public totalSupply;
10     This automatically creates a getter function for the totalSupply.
11     This is moved to the base contract since public getter functions are not
12     currently recognised as an implementation of the matching abstract
13     function by the compiler.
14     */
15     // total amount of tokens
16     uint256 public totalSupply;
17 
18 	// Send _value amount of tokens to address _to
19     /// @notice send `_value` token to `_to` from `msg.sender`
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transfer(address _to, uint256 _value) returns (bool success);
24 
25 	// Send _value amount of tokens from address _from to address _to
26     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
27     /// @param _from The address of the sender
28     /// @param _to The address of the recipient
29     /// @param _value The amount of token to be transferred
30     /// @return Whether the transfer was successful or not
31     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
32 
33 	// Allow _spender to withdraw from your account, multiple times, up to the _value amount.
34     // If this function is called again it overwrites the current allowance with _value.
35     // this function is required for some DEX functionality
36     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @param _value The amount of wei to be approved for transfer
39     /// @return Whether the approval was successful or not	
40     function approve(address _spender, uint256 _value) returns (bool success);
41 
42 	// Returns the amount which _spender is still allowed to withdraw from _owner
43     /// @param _owner The address of the account owning tokens
44     /// @param _spender The address of the account able to transfer the tokens
45     /// @return Amount of remaining tokens allowed to spent	
46     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
47 	
48 	
49 	// Get the account balance of another account with address _owner
50     /// @param _owner The address from which the balance will be retrieved
51     /// @return The balance
52 	function balanceOf(address _owner) constant returns (uint256 balance);
53 	
54 	 // Triggered when tokens are transferred.
55     /// @notice send `_value` token to `_to` from `msg.sender`
56     /// @param _to The address of the recipient
57     /// @param _value The amount of token to be transferred
58     /// @return Whether the transfer was successful or not   
59 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
60 	// Triggered whenever approve(address _spender, uint256 _value) is called.
61     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
62 }
63 
64 
65 interface TokenNotifier {
66     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
67 }
68 
69 /**
70  * @title SafeMath (from https://github.com/OpenZeppelin/zeppelin-solidity/blob/4d91118dd964618863395dcca25a50ff137bf5b6/contracts/math/SafeMath.sol)
71  * @dev Math operations with safety checks that throw on error
72  */
73 contract SafeMath {
74     function safeMul(uint256 a, uint256 b) internal constant returns (uint256) {
75         uint256 c = a * b;
76         assert(a == 0 || c / a == b);
77         return c;
78     }
79     function safeSub(uint256 a, uint256 b) internal constant returns (uint256) {
80         assert(b <= a);
81         return a - b;
82     }
83     function safeAdd(uint256 a, uint256 b) internal constant returns (uint256) {
84         uint256 c = a + b;
85         assert(c >= a);
86         return c;
87     }
88 }
89 
90 contract StandardToken is TokenERC20, SafeMath {
91 
92 	// Balances for each account
93     mapping (address => uint256) balances;
94     // Owner of account approves the transfer of an amount to another account
95 	mapping (address => mapping (address => uint256)) allowed;
96   
97 
98 	  // Transfer the balance from owner's account to another account
99     function transfer(address _to, uint256 _value) returns (bool success) {
100         require(balances[msg.sender] >= _value);
101 		balances[msg.sender] = safeSub(balances[msg.sender], _value);
102         balances[_to] = safeAdd(balances[_to], _value);
103         Transfer(msg.sender, _to, _value);
104         return true;
105     }
106 
107  	 // Send _value amount of tokens from address _from to address _to
108      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
109      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
110      // fees in sub-currencies; the command should fail unless the _from account has
111      // deliberately authorized the sender of the message via some mechanism; 
112     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
113 		uint256 allowance = allowed[_from][msg.sender];
114         require(balances[_from] >= _value && allowance >= _value);
115         balances[_to] = safeAdd(balances[_to], _value);
116         balances[_from] = safeSub(balances[_from], _value);
117         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
118         Transfer(_from, _to, _value);
119         return true;
120     }
121 
122     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
123     // If this function is called again it overwrites the current allowance with _value.
124     function approve(address _spender, uint256 _value) returns (bool success) {
125         allowed[msg.sender][_spender] = _value;
126         Approval(msg.sender, _spender, _value);
127         return true;
128     }
129 
130 	// Balance of a specific account
131     function balanceOf(address _owner) constant returns (uint256 balance) {
132         return balances[_owner];
133     }
134 
135 	// Returns the amount which _spender is still allowed to withdraw from _owner based on the approve function
136     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
137         return allowed[_owner][_spender];
138     }	
139 }
140 
141 //final implementation 
142 contract COGNXToken is StandardToken {
143     uint8 public constant decimals = 18;
144     string public constant name = 'COGNX';
145     string public constant symbol = 'COGNX';
146     string public constant version = '1.0.0';
147     uint256 public totalSupply = 15000000 * 10 ** uint256(decimals);
148 		
149 	//Constructor
150     function COGNXToken() public {
151         balances[msg.sender] = totalSupply;
152     }
153 
154 	 /* Approves and then calls the receiving contract */
155     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
156         allowed[msg.sender][_spender] = _value;
157         Approval(msg.sender, _spender, _value);
158 
159         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
160         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
161         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
162         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
163         return true;
164     }
165 
166 }