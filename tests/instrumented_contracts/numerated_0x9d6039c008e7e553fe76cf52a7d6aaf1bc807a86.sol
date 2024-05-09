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
42         //Default assumes totalSupply can't be over max (2^256 - 1).
43         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
44         //Replace the if with this one instead.
45         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
46         require(balances[msg.sender] >= _value);
47         balances[msg.sender] -= _value;
48         balances[_to] += _value;
49         Transfer(msg.sender, _to, _value);
50         return true;
51     }
52 
53     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
54         //same as above. Replace this line with the following if you want to protect against wrapping uints.
55         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
56         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
57         balances[_to] += _value;
58         balances[_from] -= _value;
59         allowed[_from][msg.sender] -= _value;
60         Transfer(_from, _to, _value);
61         return true;
62     }
63 
64     function balanceOf(address _owner) constant returns (uint256 balance) {
65         return balances[_owner];
66     }
67 
68     function approve(address _spender, uint256 _value) returns (bool success) {
69         allowed[msg.sender][_spender] = _value;
70         Approval(msg.sender, _spender, _value);
71         return true;
72     }
73 
74     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
75       return allowed[_owner][_spender];
76     }
77 
78     mapping (address => uint256) balances;
79     mapping (address => mapping (address => uint256)) allowed;
80 }
81 
82 contract HumanStandardToken is StandardToken {
83 
84     /* Public variables of the token */
85 
86     string public name;                   //fancy name: eg Simon Bucks
87     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
88     string public symbol;                 //An identifier: eg SBX
89     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
90 
91     function HumanStandardToken(
92         uint256 _initialAmount,
93         string _tokenName,
94         uint8 _decimalUnits,
95         string _tokenSymbol
96         ) {
97         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
98         totalSupply = _initialAmount;                        // Update total supply
99         name = _tokenName;                                   // Set the name for display purposes
100         decimals = _decimalUnits;                            // Amount of decimals for display purposes
101         symbol = _tokenSymbol;                               // Set the symbol for display purposes
102     }
103 
104     /* Approves and then calls the receiving contract */
105     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
106         allowed[msg.sender][_spender] = _value;
107         Approval(msg.sender, _spender, _value);
108 
109         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
110         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
111         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
112         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
113         return true;
114     }
115 }
116 
117 // Creates 160,000,000.000000000000000000 TokenCCC17 Tokens
118 contract TokenCCC17 is HumanStandardToken(160000000000000000000000000, "TokenCCC17", 18, "CCC17") {}