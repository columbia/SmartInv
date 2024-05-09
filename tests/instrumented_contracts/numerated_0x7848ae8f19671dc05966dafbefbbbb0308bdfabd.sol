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
12     /// @notice send `_value` token to `_to` from `msg.sender`
13     /// @param _to The address of the recipient
14     /// @param _value The amount of token to be transferred
15     /// @return Whether the transfer was successful or not
16     function transfer(address _to, uint256 _value) returns (bool success) {}
17 
18     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
19     /// @param _from The address of the sender
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
24 
25     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @param _value The amount of wei to be approved for transfer
28     /// @return Whether the approval was successful or not
29     function approve(address _spender, uint256 _value) returns (bool success) {}
30 
31     /// @param _owner The address of the account owning tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @return Amount of remaining tokens allowed to spent
34     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
35 
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 
39 }
40 
41 contract StandardToken is Token {
42 
43     function transfer(address _to, uint256 _value) returns (bool success) {
44         //Default assumes totalSupply can't be over max (2^256 - 1).
45         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
46         //Replace the if with this one instead.
47         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
48 
49         //require Wednesday(3)
50         uint8 dayOfWeek = uint8((now / 86400 + 4) % 7);
51         require(dayOfWeek == 3);
52 
53         if (balances[msg.sender] >= _value && _value > 0) {
54             balances[msg.sender] -= _value;
55             balances[_to] += _value;
56             Transfer(msg.sender, _to, _value);
57             return true;
58         } else {return false;}
59     }
60 
61     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
62         //same as above. Replace this line with the following if you want to protect against wrapping uints.
63         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
64 
65         //require Wednesday(3)
66         uint8 dayOfWeek = uint8((now / 86400 + 4) % 7);
67         require(dayOfWeek == 3);
68 
69         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
70             balances[_to] += _value;
71             balances[_from] -= _value;
72             allowed[_from][msg.sender] -= _value;
73             Transfer(_from, _to, _value);
74             return true;
75         } else {return false;}
76     }
77 
78     function balanceOf(address _owner) constant returns (uint256 balance) {
79         return balances[_owner];
80     }
81 
82     function approve(address _spender, uint256 _value) returns (bool success) {
83         allowed[msg.sender][_spender] = _value;
84         Approval(msg.sender, _spender, _value);
85         return true;
86     }
87 
88     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
89         return allowed[_owner][_spender];
90     }
91 
92     mapping(address => uint256) balances;
93     mapping(address => mapping(address => uint256)) allowed;
94     uint256 public totalSupply;
95 }
96 
97 
98 //name this contract whatever you'd like
99 contract WednesdayCoin is StandardToken {
100 
101     function() {
102         //if ether is sent to this address, send it back.
103         throw;
104     }
105 
106     /* Public variables of the token */
107 
108     /*
109     NOTE:
110     The following variables are OPTIONAL vanities. One does not have to include them.
111     They allow one to customise the token contract & in no way influences the core functionality.
112     Some wallets/interfaces might not even bother to look at this information.
113     */
114     string public name;                   //fancy name: eg Simon Bucks
115     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
116     string public symbol;                 //An identifier: eg SBX
117     string public version = 'WED2.0';       //WED 0.1 standard. Just an arbitrary versioning scheme.
118 
119     function WednesdayCoin() {
120         balances[msg.sender] = 21000000000000000000000000000;
121         // Give the creator all initial tokens (100000 for example)
122         totalSupply = 21000000000000000000000000000;
123         // Update total supply (100000 for example)
124         name = "Wednesday Coin";
125         // Set the name for display purposes
126         decimals = 18;
127         // Amount of decimals for display purposes
128         symbol = "WED";
129         // Set the symbol for display purposes
130     }
131 
132     /* Approves and then calls the receiving contract */
133     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
134         allowed[msg.sender][_spender] = _value;
135         Approval(msg.sender, _spender, _value);
136 
137         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
138         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
139         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
140         if (!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) {throw;}
141         return true;
142     }
143 }