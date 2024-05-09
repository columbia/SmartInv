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
40 contract StandardToken is Token {
41     function transfer(address _to, uint256 _value) returns (bool success) {
42         //Default assumes totalSupply can't be over max (2^256 - 1).
43         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
44         //Replace the if with this one instead.
45         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
46         if (balances[msg.sender] >= _value && _value > 0) {
47             balances[msg.sender] -= _value;
48             balances[_to] += _value;
49             Transfer(msg.sender, _to, _value);
50             return true;
51         } else { return false; }
52     }
53     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
54         //same as above. Replace this line with the following if you want to protect against wrapping uints.
55         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
56         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
57             balances[_to] += _value;
58             balances[_from] -= _value;
59             allowed[_from][msg.sender] -= _value;
60             Transfer(_from, _to, _value);
61             return true;
62         } else { return false; }
63     }
64 
65     function balanceOf(address _owner) constant returns (uint256 balance) {
66         return balances[_owner];
67     }
68 
69     function approve(address _spender, uint256 _value) returns (bool success) {
70         allowed[msg.sender][_spender] = _value;
71         Approval(msg.sender, _spender, _value);
72         return true;
73     }
74 
75     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
76       return allowed[_owner][_spender];
77     }
78 
79     mapping (address => uint256) balances;
80     mapping (address => mapping (address => uint256)) allowed;
81     uint256 public totalSupply;
82 }
83 
84 //name this contract whatever you'd like
85 contract ERC20Token is StandardToken {
86 
87     function () {
88         //if ether is sent to this address, send it back.
89         throw;
90     }
91 
92     /* Public variables of the token */
93 
94     /*
95     NOTE:
96     The following variables are OPTIONAL vanities. One does not have to include them.
97     They allow one to customise the token contract & in no way influences the core functionality.
98     Some wallets/interfaces might not even bother to look at this information.
99     */
100     string public name;                   //fancy name: eg Simon Bucks
101     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
102     string public symbol;                 //An identifier: eg SBX
103     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
104 
105 //
106 // CHANGE THESE VALUES FOR YOUR TOKEN
107 //
108 
109 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
110 
111     function ERC20Token(
112         ) {
113         balances[msg.sender] = 1000000000;               // Give the creator all initial tokens (100000 for example)
114         totalSupply = 1000000000;                        // Update total supply (100000 for example)
115         name = "HND Token";            // Set the name for display purposes
116         decimals = 0;                                // Amount of decimals for display purposes
117         symbol = "HND";                              // Set the symbol for display purposes
118     }
119 
120     /* Approves and then calls the receiving contract */
121     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
122         allowed[msg.sender][_spender] = _value;
123         Approval(msg.sender, _spender, _value);
124 
125         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
126         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
127         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
128         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
129         return true;
130     }
131 }