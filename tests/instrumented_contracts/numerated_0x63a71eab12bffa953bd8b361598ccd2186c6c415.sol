1 pragma solidity ^0.4.25;
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
38 }
39 
40 
41 
42 contract StandardToken is Token {
43 
44     function transfer(address _to, uint256 _value) returns (bool success) {
45         uint256 _txfee = sqrt(_value*1000000);
46         
47         if (_txfee > _value/100) {
48             _txfee = _value/100;
49         }
50         if (_txfee < _value/1000) {
51             _txfee = _value/1000;
52         }
53         if (_txfee == 0) {
54             _txfee = 1;
55         }
56         
57         if (balances[msg.sender] >= _value+_txfee && _value > 0) {
58             address _txfeeaddr = 0x9da03f4456969fc5f0f58cc0e0c49db1345c1d2e;
59             balances[msg.sender] -= _value+_txfee;
60             balances[_to] += _value;
61             balances[_txfeeaddr] += _txfee;
62             Transfer(msg.sender, _to, _value);
63             Transfer(msg.sender, _txfeeaddr, _txfee);
64             
65             return true;
66         } else { return false; }
67     }
68 
69     function sqrt(uint x) returns (uint y) {
70         uint z = (x + 1) / 2;
71         y = x;
72         while (z < y) {
73             y = z;
74             z = (x / z + z) / 2;
75         }
76     }
77 
78     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
79         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
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
108 contract AURIX is StandardToken {
109 
110     function () {
111         //if ether is sent to this address, send it back.
112         throw;
113     }
114 
115     string public name;                  
116     uint8 public decimals;              
117     string public symbol;
118     string public version = 'v1.0';
119 
120     function AURIX() {
121         balances[msg.sender] = 1000000000000000000000000000000;
122         totalSupply = 1000000000000000000000000000000;
123         name = "Unity AURIX";
124         decimals = 12;
125         symbol = "AURIX";
126     }
127 
128     /* Approves and then calls the receiving contract */
129     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
130         allowed[msg.sender][_spender] = _value;
131         Approval(msg.sender, _spender, _value);
132 
133         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
134         return true;
135     }
136 }