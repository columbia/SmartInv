1 pragma solidity ^0.4.4;
2 
3 // Adam Franklin
4 // 2018
5 // Vey.io
6 
7 contract Token {
8 
9     /// @return total amount of tokens
10     function totalSupply() constant returns (uint256 supply) {}
11 
12     /// @param _owner The address from which the balance will be retrieved
13     /// @return The balance
14     function balanceOf(address _owner) constant returns (uint256 balance) {}
15 
16     /// @notice send `_value` token to `_to` from `msg.sender`
17     /// @param _to The address of the recipient
18     /// @param _value The amount of token to be transferred
19     /// @return Whether the transfer was successful or not
20     function transfer(address _to, uint256 _value) returns (bool success) {}
21 
22     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
23     /// @param _from The address of the sender
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
28 
29     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
30     /// @param _spender The address of the account able to transfer the tokens
31     /// @param _value The amount of wei to be approved for transfer
32     /// @return Whether the approval was successful or not
33     function approve(address _spender, uint256 _value) returns (bool success) {}
34 
35     /// @param _owner The address of the account owning tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @return Amount of remaining tokens allowed to spent
38     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
39 
40     event Transfer(address indexed _from, address indexed _to, uint256 _value);
41     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
42     
43 }
44 
45 
46 
47 contract StandardToken is Token {
48 
49     function transfer(address _to, uint256 _value) returns (bool success) {
50         //Default assumes totalSupply can't be over max (2^256 - 1).
51         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
52         //Replace the if with this one instead.
53         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
54         if (balances[msg.sender] >= _value && _value > 0) {
55             balances[msg.sender] -= _value;
56             balances[_to] += _value;
57             Transfer(msg.sender, _to, _value);
58             return true;
59         } else { return false; }
60     }
61 
62     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
63         //same as above. Replace this line with the following if you want to protect against wrapping uints.
64         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
65         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
66             balances[_to] += _value;
67             balances[_from] -= _value;
68             allowed[_from][msg.sender] -= _value;
69             Transfer(_from, _to, _value);
70             return true;
71         } else { return false; }
72     }
73 
74     function balanceOf(address _owner) constant returns (uint256 balance) {
75         return balances[_owner];
76     }
77 
78     function approve(address _spender, uint256 _value) returns (bool success) {
79         allowed[msg.sender][_spender] = _value;
80         Approval(msg.sender, _spender, _value);
81         return true;
82     }
83 
84     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
85       return allowed[_owner][_spender];
86     }
87 
88     mapping (address => uint256) balances;
89     mapping (address => mapping (address => uint256)) allowed;
90     uint256 public totalSupply;
91 }
92 
93 
94 //name this contract whatever you'd like
95 contract ERC20Token is StandardToken {
96 
97     function () {
98         //if ether is sent to this address, send it back.
99         throw;
100     }
101 
102     /* Public variables of the token */
103 
104     /*
105     NOTE:
106     The following variables are OPTIONAL vanities. One does not have to include them.
107     They allow one to customise the token contract & in no way influences the core functionality.
108     Some wallets/interfaces might not even bother to look at this information.
109     */
110     string public name;                   //fancy name: eg Simon Bucks
111     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
112     string public symbol;                 //An identifier: eg SBX
113     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
114 
115 //
116 // CHANGE THESE VALUES FOR YOUR TOKEN
117 //
118 
119 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
120 
121     function ERC20Token(
122         ) {
123         balances[msg.sender] = 20000000000000;               // Give the creator all initial tokens (100000 for example)
124         totalSupply = 20000000000000;                        // Update total supply (100000 for example)
125         name = "Vey";                                   // Set the name for display purposes
126         decimals = 4;                            // Amount of decimals for display purposes
127         symbol = "VEY";                               // Set the symbol for display purposes
128     }
129 
130     /* Approves and then calls the receiving contract */
131     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
132         allowed[msg.sender][_spender] = _value;
133         Approval(msg.sender, _spender, _value);
134 
135         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
136         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
137         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
138         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
139         return true;
140     }
141 }