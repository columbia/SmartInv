1 pragma solidity ^0.4.26;
2 contract Token {
3 
4     /// @return total amount of tokens
5     function totalSupply() constant returns (uint256 supply) {}
6 
7     /// @param _owner The address from which the balance will be retrieved
8     /// @return The balance
9     function balanceOf(address _owner) constant returns (uint256 balance) {}
10 
11     /// @notice send `_value` token to `_to` from `msg.sender`
12     /// @param _to The address of the recipient
13     /// @param _value The amount of token to be transferred
14     /// @return Whether the transfer was successful or not
15     function transfer(address _to, uint256 _value) returns (bool success) {}
16 
17     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
18     /// @param _from The address of the sender
19     /// @param _to The address of the recipient
20     /// @param _value The amount of token to be transferred
21     /// @return Whether the transfer was successful or not
22     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
23 
24     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
25     /// @param _spender The address of the account able to transfer the tokens
26     /// @param _value The amount of wei to be approved for transfer
27     /// @return Whether the approval was successful or not
28     function approve(address _spender, uint256 _value) returns (bool success) {}
29 
30     /// @param _owner The address of the account owning tokens
31     /// @param _spender The address of the account able to transfer the tokens
32     /// @return Amount of remaining tokens allowed to spent
33     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
34 
35     event Transfer(address indexed _from, address indexed _to, uint256 _value);
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37     
38 }
39 
40 
41 
42 contract StandardToken is Token {
43 
44     function transfer(address _to, uint256 _value) returns (bool success) {
45         //Default assumes totalSupply can't be over max (2^256 - 1).
46         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
47         //Replace the if with this one instead.
48         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
49         if (balances[msg.sender] >= _value && _value > 0) {
50             balances[msg.sender] -= _value;
51             balances[_to] += _value;
52             Transfer(msg.sender, _to, _value);
53             return true;
54         } else { return false; }
55     }
56 
57     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
58         //same as above. Replace this line with the following if you want to protect against wrapping uints.
59         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
60         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
61             balances[_to] += _value;
62             balances[_from] -= _value;
63             allowed[_from][msg.sender] -= _value;
64             Transfer(_from, _to, _value);
65             return true;
66         } else { return false; }
67     }
68 
69     function balanceOf(address _owner) constant returns (uint256 balance) {
70         return balances[_owner];
71     }
72 
73     function approve(address _spender, uint256 _value) returns (bool success) {
74         allowed[msg.sender][_spender] = _value;
75         Approval(msg.sender, _spender, _value);
76         return true;
77     }
78 
79     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
80       return allowed[_owner][_spender];
81     }
82 
83     mapping (address => uint256) balances;
84     mapping (address => mapping (address => uint256)) allowed;
85     uint256 public totalSupply;
86 }
87 
88 
89 //name this contract whatever you'd like
90 contract ATTToken is StandardToken {
91 
92     function () {
93         //if ether is sent to this address, send it back.
94         throw;
95     }
96 
97     /* Public variables of the token */
98 
99     /*
100     NOTE:
101     The following variables are OPTIONAL vanities. One does not have to include them.
102     They allow one to customise the token contract & in no way influences the core functionality.
103     Some wallets/interfaces might not even bother to look at this information.
104     */
105     string public name;                   //fancy name: eg Simon Bucks
106     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
107     string public symbol;                 //An identifier: eg SBX
108     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
109 
110 //
111 // CHANGE THESE VALUES FOR YOUR TOKEN
112 //
113 
114 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
115 
116     function ATTToken(
117         ) {
118         balances[msg.sender] = 3000000000000000000000000000;               // Give the creator all initial tokens (100000 for example)
119         totalSupply = 3000000000000000000000000000;                        // Update total supply (100000 for example)
120         name = "Agreement of Telecom Technosphere";                                   // Set the name for display purposes
121         decimals = 18;                            // Amount of decimals for display purposes
122         symbol = "ATT";                               // Set the symbol for display purposes
123     }
124 
125     /* Approves and then calls the receiving contract */
126     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
127         allowed[msg.sender][_spender] = _value;
128         Approval(msg.sender, _spender, _value);
129 
130         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
131         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
132         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
133         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
134         return true;
135     }
136 }