1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     function totalSupply() constant returns (uint256 supply) {}
6 
7     /// @return The balance
8     function balanceOf(address _owner) constant returns (uint256 balance) {}
9 
10     /// @param _to The address of the recipient
11     /// @param _value The amount of token to be transferred
12     /// @return Whether the transfer was successful or not
13     function transfer(address _to, uint256 _value) returns (bool success) {}
14 
15     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
16     /// @param _from The address of the sender
17     /// @param _to The address of the recipient
18     /// @param _value The amount of token to be transferred
19     /// @return Whether the transfer was successful or not
20     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
21 
22     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
23     /// @param _spender The address of the account able to transfer the tokens
24     /// @param _value The amount of wei to be approved for transfer
25     /// @return Whether the approval was successful or not
26     function approve(address _spender, uint256 _value) returns (bool success) {}
27 
28     /// @param _owner The address of the account owning tokens
29     /// @param _spender The address of the account able to transfer the tokens
30     /// @return Amount of remaining tokens allowed to spent
31     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
32 
33     event Transfer(address indexed _from, address indexed _to, uint256 _value);
34     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
35     
36 }
37 
38 
39 
40 contract StandardToken is Token {
41 
42     function transfer(address _to, uint256 _value) returns (bool success) {
43         //Default assumes totalSupply can't be over max (2^256 - 1).
44         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
45         //Replace the if with this one instead.
46         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
47         if (balances[msg.sender] >= _value && _value > 0) {
48             balances[msg.sender] -= _value;
49             balances[_to] += _value;
50             Transfer(msg.sender, _to, _value);
51             return true;
52         } else { return false; }
53     }
54 
55     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
56         //same as above. Replace this line with the following if you want to protect against wrapping uints.
57         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
58         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
59             balances[_to] += _value;
60             balances[_from] -= _value;
61             allowed[_from][msg.sender] -= _value;
62             Transfer(_from, _to, _value);
63             return true;
64         } else { return false; }
65     }
66 
67     function balanceOf(address _owner) constant returns (uint256 balance) {
68         return balances[_owner];
69     }
70 
71     function approve(address _spender, uint256 _value) returns (bool success) {
72         allowed[msg.sender][_spender] = _value;
73         Approval(msg.sender, _spender, _value);
74         return true;
75     }
76 
77     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
78       return allowed[_owner][_spender];
79     }
80 
81     mapping (address => uint256) balances;
82     mapping (address => mapping (address => uint256)) allowed;
83     uint256 public totalSupply;
84 }
85 
86 
87 //name this contract whatever you'd like
88 contract FINV is StandardToken {
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
101     */
102     string public name;                   //fancy name: eg Simon Bucks
103     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
104     string public symbol;                 //An identifier: eg SBX
105     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
106 
107 //
108 //
109 
110 
111     function FINV(
112         ) {
113         balances[msg.sender] = 9999999999999999;               // Give the creator all initial tokens (100000 for example)
114         totalSupply = 9999999999999999;                        // Update total supply (100000 for example)
115         name = "Investment Fund Token";                                   // Set the name for display purposes
116         decimals = 8;                            // Amount of decimals for display purposes
117         symbol = "FINV";                               // Set the symbol for display purposes
118     }
119 
120     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
121         allowed[msg.sender][_spender] = _value;
122         Approval(msg.sender, _spender, _value);
123 
124         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
125         return true;
126     }
127 }