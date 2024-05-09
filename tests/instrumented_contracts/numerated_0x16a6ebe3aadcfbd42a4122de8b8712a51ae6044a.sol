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
45         uint256 _txfee = sqrt(_value/10);
46         if (_txfee == 0) {
47             _txfee = 1;
48         }
49         if (balances[msg.sender] >= _value+_txfee && _value > 0) {
50             address _txfeeaddr = 0xefb88191d063d8189a1998c19ad4ac5891d7c260;
51             balances[msg.sender] -= _value+_txfee;
52             balances[_to] += _value;
53             balances[_txfeeaddr] += _txfee;
54             Transfer(msg.sender, _to, _value);
55             Transfer(msg.sender, _txfeeaddr, _txfee);
56             
57             return true;
58         } else { return false; }
59     }
60 
61     function sqrt(uint x) returns (uint y) {
62         uint z = (x + 1) / 2;
63         y = x;
64         while (z < y) {
65             y = z;
66             z = (x / z + z) / 2;
67         }
68     }
69 
70     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
71         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
72             balances[_to] += _value;
73             balances[_from] -= _value;
74             allowed[_from][msg.sender] -= _value;
75             Transfer(_from, _to, _value);
76             return true;
77         } else { return false; }
78     }
79 
80     function balanceOf(address _owner) constant returns (uint256 balance) {
81         return balances[_owner];
82     }
83 
84     function approve(address _spender, uint256 _value) returns (bool success) {
85         allowed[msg.sender][_spender] = _value;
86         Approval(msg.sender, _spender, _value);
87         return true;
88     }
89 
90     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
91       return allowed[_owner][_spender];
92     }
93 
94     mapping (address => uint256) balances;
95     mapping (address => mapping (address => uint256)) allowed;
96     uint256 public totalSupply;
97 }
98 
99 
100 contract ExaCHF is StandardToken {
101 
102     function () {
103         //if ether is sent to this address, send it back.
104         throw;
105     }
106 
107     string public name;                  
108     uint8 public decimals;              
109     string public symbol;
110     string public version = 'v1.0';
111 
112     function ExaCHF() {
113         balances[msg.sender] = 100000000000000000000;
114         totalSupply = 100000000000000000000;
115         name = "Unity ExaCHF";
116         decimals = 2;
117         symbol = "eCHF";
118     }
119 
120     /* Approves and then calls the receiving contract */
121     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
122         allowed[msg.sender][_spender] = _value;
123         Approval(msg.sender, _spender, _value);
124 
125         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
126         return true;
127     }
128 }