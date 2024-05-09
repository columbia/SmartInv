1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() constant returns (uint256 supply) {}
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) constant returns (uint256 balance) {}
11 
12     /// @notice send a set of token to different address  
13     /// @param _t a set of address and amount of token to be transferred
14     /// @return Whether the transfer was successful or not
15     function multiTransfer(uint [2][] _t) returns (bool success) {}
16 
17     /// @notice send `_value` token to `_to` from `msg.sender`
18     /// @param _to The address of the recipient
19     /// @param _value The amount of token to be transferred
20     /// @return Whether the transfer was successful or not
21     function transfer(address _to, uint256 _value) returns (bool success) {}
22 
23     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
24     /// @param _from The address of the sender
25     /// @param _to The address of the recipient
26     /// @param _value The amount of token to be transferred
27     /// @return Whether the transfer was successful or not
28     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
29 
30     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
31     /// @param _spender The address of the account able to transfer the tokens
32     /// @param _value The amount of wei to be approved for transfer
33     /// @return Whether the approval was successful or not
34     function approve(address _spender, uint256 _value) returns (bool success) {}
35 
36     /// @param _owner The address of the account owning tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @return Amount of remaining tokens allowed to spent
39     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
40 
41     event Transfer(address indexed _from, address indexed _to, uint256 _value);
42     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43     
44 }
45 
46 
47 
48 contract StandardToken is Token {
49 
50     function multiTransfer(uint [2][] _t) returns (bool success) {
51         if(_t.length <= 0){
52             return false;
53         }
54         for(uint i = 0; i < _t.length; i++) {
55             if(false == transfer(address(_t[0][i]), uint256(_t[1][i])))
56                 return false;
57         }
58 
59         return true;
60     }
61 
62     function transfer(address _to, uint256 _value) returns (bool success) {
63         //Default assumes totalSupply can't be over max (2^256 - 1).
64         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
65         //Replace the if with this one instead.
66         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
67         //if (balances[msg.sender] >= _value && _value > 0) {
68             balances[msg.sender] -= _value;
69             balances[_to] += _value;
70             Transfer(msg.sender, _to, _value);
71             return true;
72         } else { return false; }
73     }
74 
75     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
76         //same as above. Replace this line with the following if you want to protect against wrapping uints.
77         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
78         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
79             balances[_to] += _value;
80             balances[_from] -= _value;
81             allowed[_from][msg.sender] -= _value;
82             Transfer(_from, _to, _value);
83             return true;
84         } else { return false; }
85     }
86 
87     function balanceOf(address _owner) constant returns (uint256 balance) {
88         return balances[_owner];
89     }
90 
91     function approve(address _spender, uint256 _value) returns (bool success) {
92         allowed[msg.sender][_spender] = _value;
93         Approval(msg.sender, _spender, _value);
94         return true;
95     }
96 
97     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
98       return allowed[_owner][_spender];
99     }
100 
101     mapping (address => uint256) balances;
102     mapping (address => mapping (address => uint256)) allowed;
103     uint256 public totalSupply;
104 }
105 
106 
107 //name this contract whatever you'd like
108 contract ERC20Token is StandardToken {
109 
110     function () {
111         //if ether is sent to this address, send it back.
112         throw;
113     }
114 
115     /* Public variables of the token */
116 
117     /*
118     NOTE:
119     The following variables are OPTIONAL vanities. One does not have to include them.
120     They allow one to customise the token contract & in no way influences the core functionality.
121     Some wallets/interfaces might not even bother to look at this information.
122     */
123     string public name;                   //fancy name: eg Simon Bucks
124     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
125     string public symbol;                 //An identifier: eg SBX
126     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
127 
128 //
129 // CHANGE THESE VALUES FOR YOUR TOKEN
130 //
131 
132 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
133 
134     function ERC20Token(
135         ) {
136         balances[msg.sender] = 3000000000000000000000000000;               // Give the creator all initial tokens (100000 for example)
137         totalSupply = 3000000000000000000000000000;                        // Update total supply (100000 for example)
138         name = "YYB";                                   // Set the name for display purposes
139         decimals = 18;                            // Amount of decimals for display purposes
140         symbol = "YYB";                               // Set the symbol for display purposes
141     }
142 
143     /* Approves and then calls the receiving contract */
144     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
145         allowed[msg.sender][_spender] = _value;
146         Approval(msg.sender, _spender, _value);
147 
148         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
149         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
150         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
151         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
152         return true;
153     }
154 }