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
18     /// @notice send `_value` token to `_to` from `msg.sender`
19     /// @param _to The address of the recipient
20     /// @param _value The amount of token to be transferred
21     /// @return Whether the transfer was successful or not
22     function transfer(address _to, uint256 _value) returns (bool success) {}
23 
24     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
25     /// @param _from The address of the sender
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
30 
31     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @param _value The amount of wei to be approved for transfer
34     /// @return Whether the approval was successful or not
35     function approve(address _spender, uint256 _value) returns (bool success) {}
36 
37     /// @param _owner The address of the account owning tokens
38     /// @param _spender The address of the account able to transfer the tokens
39     /// @return Amount of remaining tokens allowed to spent
40     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
41 
42     event Transfer(address indexed _from, address indexed _to, uint256 _value);
43     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44     
45 }
46 
47 
48 
49 contract StandardToken is Token {
50 
51     function multiTransfer(address[] _to, uint256[] _value) returns (bool success) {
52         if(_to.length <= 0 || _value.length <=0 || _to.length != _value.length){
53             return false;
54         }
55         for(uint i = 0; i < _to.length; i++) {
56             if(false == transfer(_to[i], _value[i]))
57                 return false;
58         }
59 
60         return true;
61     }
62 
63     function transfer(address _to, uint256 _value) returns (bool success) {
64         //Default assumes totalSupply can't be over max (2^256 - 1).
65         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
66         //Replace the if with this one instead.
67         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
68         //if (balances[msg.sender] >= _value && _value > 0) {
69             balances[msg.sender] -= _value;
70             balances[_to] += _value;
71             Transfer(msg.sender, _to, _value);
72             return true;
73         } else { return false; }
74     }
75 
76     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
77         //same as above. Replace this line with the following if you want to protect against wrapping uints.
78         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
79         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
80             balances[_to] += _value;
81             balances[_from] -= _value;
82             allowed[_from][msg.sender] -= _value;
83             Transfer(_from, _to, _value);
84             return true;
85         } else { return false; }
86     }
87 
88     function balanceOf(address _owner) constant returns (uint256 balance) {
89         return balances[_owner];
90     }
91 
92     function approve(address _spender, uint256 _value) returns (bool success) {
93         allowed[msg.sender][_spender] = _value;
94         Approval(msg.sender, _spender, _value);
95         return true;
96     }
97 
98     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
99       return allowed[_owner][_spender];
100     }
101 
102     mapping (address => uint256) balances;
103     mapping (address => mapping (address => uint256)) allowed;
104     uint256 public totalSupply;
105 }
106 
107 
108 //name this contract whatever you'd like
109 contract ERC20Token is StandardToken {
110 
111     function () {
112         //if ether is sent to this address, send it back.
113         throw;
114     }
115 
116     /* Public variables of the token */
117 
118     /*
119     NOTE:
120     The following variables are OPTIONAL vanities. One does not have to include them.
121     They allow one to customise the token contract & in no way influences the core functionality.
122     Some wallets/interfaces might not even bother to look at this information.
123     */
124     string public name;                   //fancy name: eg Simon Bucks
125     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
126     string public symbol;                 //An identifier: eg SBX
127     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
128 
129 //
130 // CHANGE THESE VALUES FOR YOUR TOKEN
131 //
132 
133 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
134 
135     function ERC20Token(
136         ) {
137         balances[msg.sender] = 20000000000000000000000000000;               // Give the creator all initial tokens (100000 for example)
138         totalSupply = 20000000000000000000000000000;                        // Update total supply (100000 for example)
139         name = "EPT";                                   // Set the name for display purposes
140         decimals = 18;                            // Amount of decimals for display purposes
141         symbol = "EPT";                               // Set the symbol for display purposes
142     }
143 
144     /* Approves and then calls the receiving contract */
145     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
146         allowed[msg.sender][_spender] = _value;
147         Approval(msg.sender, _spender, _value);
148 
149         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
150         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
151         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
152         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
153         return true;
154     }
155 }