1 pragma solidity ^0.4.4;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     uint256 public totalSupply;
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) public constant returns (uint256 balance);
11 
12     /// @notice send `_value` token to `_to` from `msg.sender`
13     /// @param _to The address of the recipient
14     /// @param _value The amount of token to be transferred
15     /// @return Whether the transfer was successful or not
16     function transfer(address _to, uint256 _value) public returns (bool success);
17 
18     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
19     /// @param _from The address of the sender
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
24 
25     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @param _value The amount of wei to be approved for transfer
28     /// @return Whether the approval was successful or not
29     function approve(address _spender, uint256 _value) public returns (bool success);
30 
31     /// @param _owner The address of the account owning tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @return Amount of remaining tokens allowed to spent
34     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
35 
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 }
39 
40 contract StandardToken is Token {
41 
42     function transfer(address _to, uint256 _value) public returns (bool success) {
43         if (balances[msg.sender] >= _value && _value > 0) {
44             balances[msg.sender] -= _value;
45             balances[_to] += _value;
46             Transfer(msg.sender, _to, _value);
47             return true;
48         } else { return false; }
49     }
50 
51     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
52         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
53             balances[_to] += _value;
54             balances[_from] -= _value;
55             allowed[_from][msg.sender] -= _value;
56             Transfer(_from, _to, _value);
57             return true;
58         } else { return false; }
59     }
60 
61     function balanceOf(address _owner) public constant returns (uint256 balance) {
62         return balances[_owner];
63     }
64 
65     function approve(address _spender, uint256 _value) public returns (bool success) {
66         allowed[msg.sender][_spender] = _value;
67         Approval(msg.sender, _spender, _value);
68         return true;
69     }
70 
71     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
72       return allowed[_owner][_spender];
73     }
74 
75     mapping (address => uint256) balances;
76     mapping (address => mapping (address => uint256)) allowed;
77     uint256 public totalSupply;
78 }
79 
80 contract WootradeNetwork is StandardToken {
81 
82     function () public {
83         revert();
84     }
85 
86     string public name;
87     uint8 public decimals;
88     string public symbol;
89     string public version;
90 
91     function WootradeNetwork(
92         uint256 _initialAmount,
93         string _tokenName,
94         uint8 _decimalUnits,
95         string _tokenSymbol
96         ) public {
97         balances[msg.sender] = _initialAmount;               
98         totalSupply = _initialAmount;                        
99         name = _tokenName;                                   
100         decimals = _decimalUnits;                            
101         symbol = _tokenSymbol;                               
102     }
103 
104     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
105         allowed[msg.sender][_spender] = _value;
106         Approval(msg.sender, _spender, _value);
107 
108         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
109         return true;
110     }
111 }