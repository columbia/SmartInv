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
41     event Freeze(address indexed _from, uint256 _value);
42 	
43     event Unfreeze(address indexed _from, uint256 _value);
44 
45 }
46 
47 contract StandardToken is Token {
48 
49     mapping (address => uint256) balances;
50     mapping (address => uint256) freezes;
51     mapping (address => mapping (address => uint256)) allowed;
52 
53     function transfer(address _to, uint256 _value) public returns (bool success) {
54         require(balances[msg.sender] >= _value && _value > 0);
55         balances[msg.sender] -= _value;
56         balances[_to] += _value;
57         emit Transfer(msg.sender, _to, _value);
58         return true;
59     }
60     
61     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
62         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
63         balances[_to] += _value;
64         balances[_from] -= _value;
65         allowed[_from][msg.sender] -= _value;
66         emit Transfer(_from, _to, _value);
67         return true;
68     }
69 
70     function balanceOf(address _owner) public constant returns (uint256 balance) {
71         return balances[_owner];
72     }
73 
74     function approve(address _spender, uint256 _value) public returns (bool success){
75         allowed[msg.sender][_spender] = _value;
76         emit Approval(msg.sender, _spender, _value);
77         return true;
78     }
79 
80     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
81         return allowed[_owner][_spender];
82     }   
83 }
84 
85 contract GBPCoinToken is StandardToken { 
86 
87     string public name;
88     uint8 public decimals;
89     string public symbol;
90 
91     constructor(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol)  public{
92         totalSupply = _initialAmount * 10 ** uint256(_decimalUnits);
93         balances[msg.sender] = totalSupply;
94         name = _tokenName; 
95         decimals = _decimalUnits; 
96         symbol = _tokenSymbol;
97     }
98     
99     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
100         tokenRecipient spender = tokenRecipient(_spender);
101         if (approve(_spender, _value)) {
102             spender.receiveApproval(msg.sender, _value, this, _extraData);
103             return true;
104         }
105     }
106     
107     function freeze(uint256 _value) public returns (bool success) {
108         require(balances[msg.sender] >= _value && _value > 0);
109         balances[msg.sender] = balances[msg.sender] - _value; 
110         freezes[msg.sender] = freezes[msg.sender] + _value;
111         emit Freeze(msg.sender, _value);
112         return true;
113     }
114 	
115     function unfreeze(uint256 _value) public returns (bool success) {
116         require(freezes[msg.sender] >= _value && _value > 0);
117         freezes[msg.sender] = freezes[msg.sender] -  _value;
118 	balances[msg.sender] = balances[msg.sender] + _value;
119         emit Unfreeze(msg.sender, _value);
120         return true;
121     }
122 }