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
13     /// @param _to a set of address token to be transferred
14     /// @param _value a set of amount of token to be transferred
15     /// @return Whether the transfer was successful or not
16     function multiTransfer(address[] _to, uint256[] _value) returns (bool success) {}
17 
18     /// @notice send a set of token to different address  
19     /// @param _from The address of the sender
20     /// @param _to a set of address token to be transferred
21     /// @param _value a set of amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function multiTransferFrom(address _from, address[] _to, uint256[] _value) returns (bool success) {}
24 
25     /// @notice send `_value` token to `_to` from `msg.sender`
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transfer(address _to, uint256 _value) returns (bool success) {}
30 
31     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
32     /// @param _from The address of the sender
33     /// @param _to The address of the recipient
34     /// @param _value The amount of token to be transferred
35     /// @return Whether the transfer was successful or not
36     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
37 
38     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
39     /// @param _spender The address of the account able to transfer the tokens
40     /// @param _value The amount of wei to be approved for transfer
41     /// @return Whether the approval was successful or not
42     function approve(address _spender, uint256 _value) returns (bool success) {}
43 
44     /// @param _owner The address of the account owning tokens
45     /// @param _spender The address of the account able to transfer the tokens
46     /// @return Amount of remaining tokens allowed to spent
47     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
48 
49     event Transfer(address indexed _from, address indexed _to, uint256 _value);
50     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51     
52 }
53 
54 
55 
56 contract StandardToken is Token {    
57 
58     function multiTransfer(address[] _to, uint256[] _value) returns (bool success) {
59         if(_to.length <= 0 || _value.length <=0 || _to.length != _value.length){
60             return false;
61         }
62         for(uint i = 0; i < _to.length; i++) {
63             if(false == transfer(_to[i], _value[i]))
64                 return false;
65         }
66 
67         return true;
68     }
69 
70     function multiTransferFrom(address _from, address[] _to, uint256[] _value) returns (bool success) {
71         if(_to.length <= 0 || _value.length <=0 || _to.length != _value.length){
72             return false;
73         }
74         for(uint i = 0; i < _to.length; i++) {
75             if(false == transferFrom(_from, _to[i], _value[i]))
76                 return false;
77         }
78 
79         return true;
80     }
81 
82     function transfer(address _to, uint256 _value) returns (bool success) {
83         //Default assumes totalSupply can't be over max (2^256 - 1).
84         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
85         //Replace the if with this one instead.
86         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
87         //if (balances[msg.sender] >= _value && _value > 0) {
88             balances[msg.sender] -= _value;
89             balances[_to] += _value;
90             Transfer(msg.sender, _to, _value);
91             return true;
92         } else { return false; }
93     }
94 
95     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
96         //same as above. Replace this line with the following if you want to protect against wrapping uints.
97         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
98         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
99             balances[_to] += _value;
100             balances[_from] -= _value;
101             allowed[_from][msg.sender] -= _value;
102             Transfer(_from, _to, _value);
103             return true;
104         } else { return false; }
105     }
106 
107     function balanceOf(address _owner) constant returns (uint256 balance) {
108         return balances[_owner];
109     }
110 
111     function approve(address _spender, uint256 _value) returns (bool success) {
112         allowed[msg.sender][_spender] = _value;
113         Approval(msg.sender, _spender, _value);
114         return true;
115     }
116 
117     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
118       return allowed[_owner][_spender];
119     }
120 
121     mapping (address => uint256) balances;
122     mapping (address => mapping (address => uint256)) allowed;
123     uint256 public totalSupply;
124 }
125 
126 
127 //name this contract whatever you'd like
128 contract YYBToken is StandardToken {
129 
130     function () {
131         //if ether is sent to this address, send it back.
132         throw;
133     }
134 
135     /* Public variables of the token */
136 
137     /*
138     NOTE:
139     The following variables are OPTIONAL vanities. One does not have to include them.
140     They allow one to customise the token contract & in no way influences the core functionality.
141     Some wallets/interfaces might not even bother to look at this information.
142     */
143     string public name;                   //fancy name: eg Simon Bucks
144     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
145     string public symbol;                 //An identifier: eg SBX
146     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
147 
148 //
149 // CHANGE THESE VALUES FOR YOUR TOKEN
150 //
151 
152 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
153 
154     function YYBToken(
155         ) {
156         balances[msg.sender] = 30000000000000000000000000;               // Give the creator all initial tokens (100000 for example)
157         totalSupply = 30000000000000000000000000;                        // Update total supply (100000 for example)
158         name = "YYBCoin";                                   // Set the name for display purposes
159         decimals = 16;                            // Amount of decimals for display purposes
160         symbol = "YYB";                               // Set the symbol for display purposes
161     }
162 
163     /* Approves and then calls the receiving contract */
164     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
165         allowed[msg.sender][_spender] = _value;
166         Approval(msg.sender, _spender, _value);
167 
168         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
169         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
170         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
171         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
172         return true;
173     }
174 }