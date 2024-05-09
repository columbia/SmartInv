1 // 0.4.18+commit.9cf6e910.Emscripten.clang
2 pragma solidity ^0.4.4;
3 
4 contract Token {
5 
6     /// @return total amount of tokens
7     function totalSupply() constant returns (uint256 supply) {}
8 
9     /// @param _owner The address from which the balance will be retrieved
10     /// @return The balance
11     function balanceOf(address _owner) constant returns (uint256 balance) {}
12 
13     /// @notice send `_value` token to `_to` from `msg.sender`
14     /// @param _to The address of the recipient
15     /// @param _value The amount of token to be transferred
16     /// @return Whether the transfer was successful or not
17     function transfer(address _to, uint256 _value) returns (bool success) {}
18 
19     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
20     /// @param _from The address of the sender
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
25 
26     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
27     /// @param _spender The address of the account able to transfer the tokens
28     /// @param _value The amount of wei to be approved for transfer
29     /// @return Whether the approval was successful or not
30     function approve(address _spender, uint256 _value) returns (bool success) {}
31 
32     /// @param _owner The address of the account owning tokens
33     /// @param _spender The address of the account able to transfer the tokens
34     /// @return Amount of remaining tokens allowed to spent
35     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
36 
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39     
40 }
41 
42 
43 
44 contract StandardToken is Token {
45 
46     function transfer(address _to, uint256 _value) returns (bool success) {
47         //Default assumes totalSupply can't be over max (2^256 - 1).
48         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
49         //Replace the if with this one instead.
50         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
51         if (balances[msg.sender] >= _value && _value > 0) {
52             balances[msg.sender] -= _value;
53             balances[_to] += _value;
54             Transfer(msg.sender, _to, _value);
55             return true;
56         } else { return false; }
57     }
58 
59     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
60         //same as above. Replace this line with the following if you want to protect against wrapping uints.
61         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
62         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
63             balances[_to] += _value;
64             balances[_from] -= _value;
65             allowed[_from][msg.sender] -= _value;
66             Transfer(_from, _to, _value);
67             return true;
68         } else { return false; }
69     }
70 
71     function balanceOf(address _owner) constant returns (uint256 balance) {
72         return balances[_owner];
73     }
74 
75     function approve(address _spender, uint256 _value) returns (bool success) {
76         allowed[msg.sender][_spender] = _value;
77         Approval(msg.sender, _spender, _value);
78         return true;
79     }
80 
81     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
82       return allowed[_owner][_spender];
83     }
84 
85     mapping (address => uint256) balances;
86     mapping (address => mapping (address => uint256)) allowed;
87     uint256 public totalSupply;
88 }
89 
90 
91 //name this contract whatever you'd like
92 contract MDPToken is StandardToken {
93 
94     function () {
95         //if ether is sent to this address, send it back.
96         throw;
97     }
98 
99     /* Public variables of the token */
100 
101     /*
102     NOTE:
103     The following variables are OPTIONAL vanities. One does not have to include them.
104     They allow one to customise the token contract & in no way influences the core functionality.
105     Some wallets/interfaces might not even bother to look at this information.
106     */
107     string public name;                   //fancy name: eg Simon Bucks
108     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
109     string public symbol;                 //An identifier: eg SBX
110     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
111 
112 //
113 // CHANGE THESE VALUES FOR YOUR TOKEN
114 //
115 
116 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of MDPToken
117 
118     function MDPToken(
119         ) {
120         totalSupply = 6600000000000000;                        // Update total supply (100000 for example)
121         balances[msg.sender] = totalSupply;                    // Give the creator all initial tokens (100000 for example)
122 		name = "MDP Token";                                   // Set the name for display purposes
123         decimals = 7;                            // Amount of decimals for display purposes
124         symbol = "MDP";                               // Set the symbol for display purposes
125     }
126 
127     /* Approves and then calls the receiving contract */
128     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
129         allowed[msg.sender][_spender] = _value;
130         Approval(msg.sender, _spender, _value);
131 
132         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
133         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
134         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
135         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
136         return true;
137 	}
138 }