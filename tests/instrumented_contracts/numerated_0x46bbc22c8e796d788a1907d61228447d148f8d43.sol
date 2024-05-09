1 pragma solidity ^0.4.16;
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
41 
42 contract StandardToken is Token {
43 
44     function transfer(address _to, uint256 _value) returns (bool success) {
45         if (balances[msg.sender] >= _value && _value > 0) {
46             balances[msg.sender] -= _value;
47             balances[_to] += _value;
48             Transfer(msg.sender, _to, _value);
49             return true;
50         } else { return false; }
51     }
52 
53     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
54         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
55             balances[_to] += _value;
56             balances[_from] -= _value;
57             allowed[_from][msg.sender] -= _value;
58             Transfer(_from, _to, _value);
59             return true;
60         } else { return false; }
61     }
62 
63     function balanceOf(address _owner) constant returns (uint256 balance) {
64         return balances[_owner];
65     }
66 
67     function approve(address _spender, uint256 _value) returns (bool success) {
68         allowed[msg.sender][_spender] = _value;
69         Approval(msg.sender, _spender, _value);
70         return true;
71     }
72 
73     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
74       return allowed[_owner][_spender];
75     }
76 
77     mapping (address => uint256) balances;
78     mapping (address => mapping (address => uint256)) allowed;
79     uint256 public totalSupply;
80 }
81 
82 
83 contract AGSCoin is StandardToken {
84 
85     function () {
86         //if ether is sent to this address, send it back.
87         throw;
88     }
89 
90     /* Public variables of the token */
91     
92     string public name;                   
93     uint8 public decimals;                
94     string public symbol;                 
95     string public version = 'H1.0';  
96 
97 
98     function AGSCoin(
99         ) {
100         balances[msg.sender] = 100000000 * 1000000;   // Give the creator all initial tokens, 6 zero is 6 Decimals
101         totalSupply = 100000000 * 1000000;            // Update total supply, , 6 zero is 8 Decimals
102         name = "Agos";                                // Token Name
103         decimals = 6;                                      // Amount of decimals for display purposes
104         symbol = "AGS";                                    // Token Symbol
105     }
106 
107     /* Approves and then calls the receiving contract */
108     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
109         allowed[msg.sender][_spender] = _value;
110         Approval(msg.sender, _spender, _value);
111 
112         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
113         return true;
114     }
115 }