1 pragma solidity ^0.4.18;
2 
3 contract Token {
4     /// total amount of tokens
5     uint256 public totalSupply;
6 
7     /// @param _owner The address from which the balance will be retrieved
8     /// @return The balance
9     function balanceOf(address _owner) public constant returns (uint256 balance);
10 
11     /// @notice send `_value` token to `_to` from `msg.sender`
12     /// @param _to The address of the recipient
13     /// @param _value The amount of token to be transferred
14     /// @return Whether the transfer was successful or not
15     function transfer(address _to, uint256 _value)public  returns (bool success);
16 
17     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
18     /// @param _from The address of the sender
19     /// @param _to The address of the recipient
20     /// @param _value The amount of token to be transferred
21     /// @return Whether the transfer was successful or not
22     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
23 
24     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
25     /// @param _spender The address of the account able to transfer the tokens
26     /// @param _value The amount of tokens to be approved for transfer
27     /// @return Whether the approval was successful or not
28     function approve(address _spender, uint256 _value) public returns (bool success);
29 
30     /// @param _owner The address of the account owning tokens
31     /// @param _spender The address of the account able to transfer the tokens
32     /// @return Amount of remaining tokens allowed to spent
33     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
34 
35     event Transfer(address indexed _from, address indexed _to, uint256 _value);
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37 }
38 
39 contract StandardToken is Token {
40 
41     function transfer(address _to, uint256 _value) public returns (bool success) {
42         if (balances[msg.sender] >= _value && _value > 0) {
43             balances[msg.sender] -= _value;
44             balances[_to] += _value;
45             Transfer(msg.sender, _to, _value);
46             return true;
47         } else { return false; }
48     }
49 
50     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
51         //same as above. Replace this line with the following if you want to protect against wrapping uints.
52         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
53         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
54             balances[_to] += _value;
55             balances[_from] -= _value;
56             allowed[_from][msg.sender] -= _value;
57             Transfer(_from, _to, _value);
58             return true;
59         } else { return false; }
60     }
61 
62     function balanceOf(address _owner) public constant returns (uint256 balance) {
63         return balances[_owner];
64     }
65 
66     function approve(address _spender, uint256 _value) public returns (bool success) {
67         allowed[msg.sender][_spender] = _value;
68         Approval(msg.sender, _spender, _value);
69         return true;
70     }
71 
72     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
73       return allowed[_owner][_spender];
74     }
75 
76     mapping (address => uint256) balances;
77     mapping (address => mapping (address => uint256)) allowed;
78 }
79 
80 contract DLBToken is StandardToken {
81     string public name;                   
82     uint8 public decimals;                
83     string public symbol;                
84 
85     function DLBToken(
86         uint256 _initialAmount,
87         string _tokenName,
88         uint8 _decimalUnits,
89         string _tokenSymbol
90         ) public {
91         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
92         totalSupply = _initialAmount;                        // Update total supply
93         name = _tokenName;                                   // Set the name for display purposes
94         decimals = _decimalUnits;                            // Amount of decimals for display purposes
95         symbol = _tokenSymbol;                               // Set the symbol for display purposes
96     }	
97 
98     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
99         allowed[msg.sender][_spender] = _value;
100         Approval(msg.sender, _spender, _value);
101 
102         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { return false; }
103         return true;
104     }
105 }