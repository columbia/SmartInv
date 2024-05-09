1 pragma solidity ^0.4.4;
2 
3 contract AbstractToken {
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
41 contract StandardToken is AbstractToken {
42 
43     function transfer(address _to, uint256 _value) returns (bool success) {
44         //Default assumes totalSupply can't be over max (2^256 - 1).
45         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
46         //Replace the if with this one instead.
47         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
48         if (balances[msg.sender] >= _value && _value > 0) {
49             balances[msg.sender] -= _value;
50             balances[_to] += _value;
51             Transfer(msg.sender, _to, _value);
52             return true;
53         } else { return false; }
54     }
55 
56     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
57         //same as above. Replace this line with the following if you want to protect against wrapping uints.
58         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
59         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
60             balances[_to] += _value;
61             balances[_from] -= _value;
62             allowed[_from][msg.sender] -= _value;
63             Transfer(_from, _to, _value);
64             return true;
65         } else { return false; }
66     }
67 
68     function balanceOf(address _owner) constant returns (uint256 balance) {
69         return balances[_owner];
70     }
71 
72     function approve(address _spender, uint256 _value) returns (bool success) {
73         allowed[msg.sender][_spender] = _value;
74         Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
79       return allowed[_owner][_spender];
80     }
81 
82     mapping (address => uint256) balances;
83     mapping (address => mapping (address => uint256)) allowed;
84     uint256 public totalSupply;
85 }
86 
87 //name this contract whatever you'd like
88 contract WayBackToken is StandardToken {
89 
90     function () {
91         //if ether is sent to this address, send it back.
92         throw;
93     }
94 
95     /* Public variables of the token */
96 
97     /*
98     NOTE:
99     The following variables are OPTIONAL vanities. One does not have to include them.
100     They allow one to customise the token contract & in no way influences the core functionality.
101     Some wallets/interfaces might not even bother to look at this information.
102     */
103     string public name = 'WayBack Token';                   //fancy name: eg Simon Bucks
104     uint8 public decimals = 7;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
105     string public symbol = 'WBT';                 //An identifier: eg SBX
106     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
107 
108 //
109 // CHANGE THESE VALUES FOR YOUR TOKEN
110 //
111 
112 //make sure this function name matches the contract name above. So if you're token is called TutorialToken, make sure the //contract name above is also TutorialToken instead of ERC20Token
113 
114     function WayBackToken(
115         ) {
116         balances[msg.sender] = 100000000;               // Give the creator all initial tokens (100000 for example)
117         totalSupply = 100000000;                        // Update total supply (100000 for example)
118         name = 'WayBack Token';                                   // Set the name for display purposes
119         decimals = 7;                            // Amount of decimals for display purposes
120         symbol = "WBT";                               // Set the symbol for display purposes
121     }
122 
123     /* Approves and then calls the receiving contract */
124     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
125         allowed[msg.sender][_spender] = _value;
126         Approval(msg.sender, _spender, _value);
127 
128         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
129         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
130         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
131         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
132         return true;
133     }
134 }