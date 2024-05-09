1 /**
2  *Submitted for verification at Etherscan.io on 2019-07-01
3 */
4 
5 pragma solidity ^0.4.18;
6 
7 contract Token {
8     /// total amount of tokens
9     uint256 public totalSupply;
10 
11     /// @param _owner The address from which the balance will be retrieved
12     /// @return The balance
13     function balanceOf(address _owner) public constant returns (uint256 balance);
14 
15     /// @notice send `_value` token to `_to` from `msg.sender`
16     /// @param _to The address of the recipient
17     /// @param _value The amount of token to be transferred
18     /// @return Whether the transfer was successful or not
19     function transfer(address _to, uint256 _value)public  returns (bool success);
20 
21     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
22     /// @param _from The address of the sender
23     /// @param _to The address of the recipient
24     /// @param _value The amount of token to be transferred
25     /// @return Whether the transfer was successful or not
26     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
27 
28     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
29     /// @param _spender The address of the account able to transfer the tokens
30     /// @param _value The amount of tokens to be approved for transfer
31     /// @return Whether the approval was successful or not
32     function approve(address _spender, uint256 _value) public returns (bool success);
33 
34     /// @param _owner The address of the account owning tokens
35     /// @param _spender The address of the account able to transfer the tokens
36     /// @return Amount of remaining tokens allowed to spent
37     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
38 
39     event Transfer(address indexed _from, address indexed _to, uint256 _value);
40     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
41 }
42 
43 contract StandardToken is Token {
44 
45     function transfer(address _to, uint256 _value) public returns (bool success) {
46         if (balances[msg.sender] >= _value && _value > 0) {
47             balances[msg.sender] -= _value;
48             balances[_to] += _value;
49             Transfer(msg.sender, _to, _value);
50             return true;
51         } else { return false; }
52     }
53 
54     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
55         //same as above. Replace this line with the following if you want to protect against wrapping uints.
56         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
57         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
58             balances[_to] += _value;
59             balances[_from] -= _value;
60             allowed[_from][msg.sender] -= _value;
61             Transfer(_from, _to, _value);
62             return true;
63         } else { return false; }
64     }
65 
66     function balanceOf(address _owner) public constant returns (uint256 balance) {
67         return balances[_owner];
68     }
69 
70     function approve(address _spender, uint256 _value) public returns (bool success) {
71         allowed[msg.sender][_spender] = _value;
72         Approval(msg.sender, _spender, _value);
73         return true;
74     }
75 
76     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
77       return allowed[_owner][_spender];
78     }
79 
80     mapping (address => uint256) balances;
81     mapping (address => mapping (address => uint256)) allowed;
82 }
83 
84 contract TCSToken is StandardToken {
85     string public name;                   
86     uint8 public decimals;                
87     string public symbol;                
88 
89     function TCSToken(
90         uint256 _initialAmount,
91         string _tokenName,
92         uint8 _decimalUnits,
93         string _tokenSymbol
94         ) public {
95         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
96         totalSupply = _initialAmount;                        // Update total supply
97         name = _tokenName;                                   // Set the name for display purposes
98         decimals = _decimalUnits;                            // Amount of decimals for display purposes
99         symbol = _tokenSymbol;                               // Set the symbol for display purposes
100     }	
101 
102     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
103         allowed[msg.sender][_spender] = _value;
104         Approval(msg.sender, _spender, _value);
105 
106         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { return false; }
107         return true;
108     }
109 }