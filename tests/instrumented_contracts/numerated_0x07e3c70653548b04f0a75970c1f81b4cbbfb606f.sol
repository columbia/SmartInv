1 pragma solidity ^0.4.8;
2 
3 contract Token {
4     /// total amount of tokens
5     uint256 public totalSupply;
6 
7     /// @param _owner The address from which the balance will be retrieved
8     /// @return The balance
9     function balanceOf(address _owner) constant returns (uint256 balance);
10 
11     /// @notice send `_value` token to `_to` from `msg.sender`
12     /// @param _to The address of the recipient
13     /// @param _value The amount of token to be transferred
14     /// @return Whether the transfer was successful or not
15     function transfer(address _to, uint256 _value) returns (bool success);
16 
17     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
18     /// @param _from The address of the sender
19     /// @param _to The address of the recipient
20     /// @param _value The amount of token to be transferred
21     /// @return Whether the transfer was successful or not
22     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
23 
24     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
25     /// @param _spender The address of the account able to transfer the tokens
26     /// @param _value The amount of tokens to be approved for transfer
27     /// @return Whether the approval was successful or not
28     function approve(address _spender, uint256 _value) returns (bool success);
29 
30     /// @param _owner The address of the account owning tokens
31     /// @param _spender The address of the account able to transfer the tokens
32     /// @return Amount of remaining tokens allowed to spent
33     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
34 
35     event Transfer(address indexed _from, address indexed _to, uint256 _value);
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37 }
38 
39 contract StandardToken is Token {
40 
41     function transfer(address _to, uint256 _value) returns (bool success) {
42         require(balances[msg.sender] >= _value);
43         balances[msg.sender] -= _value;
44         balances[_to] += _value;
45         Transfer(msg.sender, _to, _value);
46         return true;
47     }
48 
49     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
50         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
51         balances[_to] += _value;
52         balances[_from] -= _value;
53         allowed[_from][msg.sender] -= _value;
54         Transfer(_from, _to, _value);
55         return true;
56     }
57 
58     function balanceOf(address _owner) constant returns (uint256 balance) {
59         return balances[_owner];
60     }
61 
62     function approve(address _spender, uint256 _value) returns (bool success) {
63         allowed[msg.sender][_spender] = _value;
64         Approval(msg.sender, _spender, _value);
65         return true;
66     }
67 
68     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
69       return allowed[_owner][_spender];
70     }
71 
72     mapping (address => uint256) balances;
73     mapping (address => mapping (address => uint256)) allowed;
74 }
75 
76 contract HumanStandardToken is StandardToken {
77 
78     /* Public variables of the token */
79 
80     string public name;                   //fancy name: eg Simon Bucks
81     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
82     string public symbol;                 //An identifier: eg SBX
83     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
84 
85     function HumanStandardToken(
86         uint256 _initialAmount,
87         string _tokenName,
88         uint8 _decimalUnits,
89         string _tokenSymbol
90         ) {
91         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
92         totalSupply = _initialAmount;                        // Update total supply
93         name = _tokenName;                                   // Set the name for display purposes
94         decimals = _decimalUnits;                            // Amount of decimals for display purposes
95         symbol = _tokenSymbol;                               // Set the symbol for display purposes
96     }
97 
98     /* Approves and then calls the receiving contract */
99     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
100         allowed[msg.sender][_spender] = _value;
101         Approval(msg.sender, _spender, _value);
102 
103         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
104         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
105         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
106         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
107         return true;
108     }
109 }
110 
111 // Creates 130,271,020.035721000000000000 Agrello Delta Tokens
112 contract Delta is HumanStandardToken(130271020035721000000000000, "Delta", 18, "DLT") {}