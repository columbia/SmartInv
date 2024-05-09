1 pragma solidity ^0.4.24;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract Token{
6     /// total amount of tokens
7     uint256 public totalSupply;
8 
9     /// @param _owner The address from which the balance will be retrieved
10     /// @return The balance
11     function balanceOf(address _owner) public constant returns (uint256 balance);
12 
13     /// @notice send `_value` token to `_to` from `msg.sender`
14     /// @param _to The address of the recipient
15     /// @param _value The amount of token to be transferred
16     /// @return Whether the transfer was successful or not
17     function transfer(address _to, uint256 _value) public returns (bool success);
18 
19     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
20     /// @param _from The address of the sender
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
25 
26     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
27     /// @param _spender The address of the account able to transfer the tokens
28     /// @param _value The amount of wei to be approved for transfer
29     /// @return Whether the approval was successful or not
30     function approve(address _spender, uint256 _value) public returns (bool success);
31 
32     /// @param _owner The address of the account owning tokens
33     /// @param _spender The address of the account able to transfer the tokens
34     /// @return Amount of remaining tokens allowed to spent
35     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
36 
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38 
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40     
41     event Burn(address indexed _from, uint256 _value);
42 
43     event Freeze(address indexed _from, uint256 _value);
44     
45     event Unfreeze(address indexed _from, uint256 _value);
46 
47 }
48 
49 contract StandardToken is Token {
50 
51     mapping (address => uint256) balances;
52     mapping (address => uint256) freezes;
53     mapping (address => mapping (address => uint256)) allowed;
54 
55     function transfer(address _to, uint256 _value) public returns (bool success) {
56         require(balances[msg.sender] >= _value && _value > 0);
57         balances[msg.sender] -= _value;
58         balances[_to] += _value;
59         emit Transfer(msg.sender, _to, _value);
60         return true;
61     }
62     
63     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
64         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
65         balances[_to] += _value;
66         balances[_from] -= _value;
67         allowed[_from][msg.sender] -= _value;
68         emit Transfer(_from, _to, _value);
69         return true;
70     }
71 
72     function balanceOf(address _owner) public constant returns (uint256 balance) {
73         return balances[_owner];
74     }
75 
76     function approve(address _spender, uint256 _value) public returns (bool success){
77         allowed[msg.sender][_spender] = _value;
78         emit Approval(msg.sender, _spender, _value);
79         return true;
80     }
81 
82     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
83         return allowed[_owner][_spender];
84     }   
85 }
86 
87 contract XLTCoinToken is StandardToken { 
88 
89     string public name;
90     uint8 public decimals;
91     string public symbol;
92 
93     constructor(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol)  public{
94         totalSupply = _initialAmount * 10 ** uint256(_decimalUnits);
95         balances[msg.sender] = totalSupply;
96         name = _tokenName; 
97         decimals = _decimalUnits; 
98         symbol = _tokenSymbol;
99     }
100     
101     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
102         tokenRecipient spender = tokenRecipient(_spender);
103         if (approve(_spender, _value)) {
104             spender.receiveApproval(msg.sender, _value, this, _extraData);
105             return true;
106         }
107     }
108     
109     function burn(uint256 _value) public returns (bool success) {
110         require(balances[msg.sender] >= _value && _value > 0);
111         balances[msg.sender] -= _value;
112         totalSupply -= _value;
113         emit Burn(msg.sender, _value);
114         return true;
115     }
116 
117     function burnFrom(address _from, uint256 _value) public returns (bool success) {
118         require(balances[_from] >= _value && _value > 0);
119         require(allowed[_from][msg.sender] >= _value);
120         balances[_from] -= _value; 
121         allowed[_from][msg.sender] -= _value;
122         totalSupply -= _value;
123         emit Burn(_from, _value);
124         return true;
125     }
126 
127     function freeze(uint256 _value) public returns (bool success) {
128         require(balances[msg.sender] >= _value && _value > 0);
129         balances[msg.sender] = balances[msg.sender] - _value; 
130         freezes[msg.sender] = freezes[msg.sender] + _value;
131         emit Freeze(msg.sender, _value);
132         return true;
133     }
134     
135     function unfreeze(uint256 _value) public returns (bool success) {
136         require(freezes[msg.sender] >= _value && _value > 0);
137         freezes[msg.sender] = freezes[msg.sender] -  _value;
138         balances[msg.sender] = balances[msg.sender] + _value;
139         emit Unfreeze(msg.sender, _value);
140         return true;
141     }
142 }