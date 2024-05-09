1 pragma solidity ^0.4.2;
2 
3 // Abstract contract for the full ERC 20 Token standard
4 // https://github.com/ethereum/EIPs/issues/20
5 
6 contract Token {
7     /* This is a slight change to the ERC20 base standard.
8     function totalSupply() constant returns (uint256 supply);
9     is replaced with:
10     uint256 public totalSupply;
11     This automatically creates a getter function for the totalSupply.
12     This is moved to the base contract since public getter functions are not
13     currently recognised as an implementation of the matching abstract
14     function by the compiler.
15     */
16     /// total amount of tokens
17     uint256 public totalSupply;
18 
19     /// @param _owner The address from which the balance will be retrieved
20     /// @return The balance
21     function balanceOf(address _owner) constant returns (uint256 balance);
22 
23     /// @notice send `_value` token to `_to` from `msg.sender`
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transfer(address _to, uint256 _value) returns (bool success);
28 
29     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
30     /// @param _from The address of the sender
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
35 
36     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @param _value The amount of wei to be approved for transfer
39     /// @return Whether the approval was successful or not
40     function approve(address _spender, uint256 _value) returns (bool success);
41 
42     /// @param _owner The address of the account owning tokens
43     /// @param _spender The address of the account able to transfer the tokens
44     /// @return Amount of remaining tokens allowed to spent
45     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
46 
47     event Transfer(address indexed _from, address indexed _to, uint256 _value);
48     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
49 }
50 
51 
52 contract StandardToken is Token {
53 
54     function transfer(address _to, uint256 _value) returns (bool success) {
55         //Default assumes totalSupply can't be over max (2^256 - 1).
56         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
57         //Replace the if with this one instead.
58         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
59         if (balances[msg.sender] >= _value && _value > 0) {
60             balances[msg.sender] -= _value;
61             balances[_to] += _value;
62             Transfer(msg.sender, _to, _value);
63             return true;
64         } else { return false; }
65     }
66 
67     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
68         //same as above. Replace this line with the following if you want to protect against wrapping uints.
69         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
70         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
71             balances[_to] += _value;
72             balances[_from] -= _value;
73             allowed[_from][msg.sender] -= _value;
74             Transfer(_from, _to, _value);
75             return true;
76         } else { return false; }
77     }
78 
79     function balanceOf(address _owner) constant returns (uint256 balance) {
80         return balances[_owner];
81     }
82 
83     function approve(address _spender, uint256 _value) returns (bool success) {
84         allowed[msg.sender][_spender] = _value;
85         Approval(msg.sender, _spender, _value);
86         return true;
87     }
88 
89     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
90       return allowed[_owner][_spender];
91     }
92 
93     mapping (address => uint256) balances;
94     mapping (address => mapping (address => uint256)) allowed;
95 }
96 
97 
98 contract HumanStandardToken is StandardToken {
99 
100     function () {
101         //if ether is sent to this address, send it back.
102         throw;
103     }
104 
105     /* Public variables of the token */
106 
107     /*
108     NOTE:
109     The following variables are OPTIONAL vanities. One does not have to include them.
110     They allow one to customise the token contract & in no way influences the core functionality.
111     Some wallets/interfaces might not even bother to look at this information.
112     */
113     string public name;                   //fancy name: eg Simon Bucks
114     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
115     string public symbol;                 //An identifier: eg SBX
116     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
117 
118     function HumanStandardToken(
119         uint256 _initialAmount,
120         string _tokenName,
121         uint8 _decimalUnits,
122         string _tokenSymbol
123         ) {
124         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
125         totalSupply = _initialAmount;                        // Update total supply
126         name = _tokenName;                                   // Set the name for display purposes
127         decimals = _decimalUnits;                            // Amount of decimals for display purposes
128         symbol = _tokenSymbol;                               // Set the symbol for display purposes
129     }
130 
131     /* Approves and then calls the receiving contract */
132     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
133         allowed[msg.sender][_spender] = _value;
134         Approval(msg.sender, _spender, _value);
135 
136         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
137         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
138         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
139         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
140         return true;
141     }
142 }