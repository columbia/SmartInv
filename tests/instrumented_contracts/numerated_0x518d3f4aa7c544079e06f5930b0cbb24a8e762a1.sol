1 /**
2 *   Based on ConsenSys HumanStandardToken:
3 *   Licensed under the MIT: https://github.com/ConsenSys/Tokens/blob/master/LICENSE
4 */
5 
6 pragma solidity 0.4.19;
7 
8 contract Token {
9     /// total amount of tokens
10     uint256 public totalSupply;
11 
12     /// @param _owner The address from which the balance will be retrieved
13     /// @return The balance
14     function balanceOf(address _owner) public view returns (uint256 balance);
15 
16     /// @notice send `_value` token to `_to` from `msg.sender`
17     /// @param _to The address of the recipient
18     /// @param _value The amount of token to be transferred
19     /// @return Whether the transfer was successful or not
20     function transfer(address _to, uint256 _value) public returns (bool success);
21 
22     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
23     /// @param _from The address of the sender
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
28 
29     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
30     /// @param _spender The address of the account able to transfer the tokens
31     /// @param _value The amount of tokens to be approved for transfer
32     /// @return Whether the approval was successful or not
33     function approve(address _spender, uint256 _value) public returns (bool success);
34 
35     /// @param _owner The address of the account owning tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @return Amount of remaining tokens allowed to spent
38     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
39 
40     event Transfer(address indexed _from, address indexed _to, uint256 _value);
41     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
42 }
43 
44 contract StandardToken is Token {
45 
46     uint256 constant MAX_UINT256 = 2**256 - 1;
47 
48     function transfer(address _to, uint256 _value) public returns (bool success) {
49         //Default assumes totalSupply can't be over max (2^256 - 1).
50         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
51         //Replace the if with this one instead.
52         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
53         require(balances[msg.sender] >= _value);
54         balances[msg.sender] -= _value;
55         balances[_to] += _value;
56         Transfer(msg.sender, _to, _value);
57         return true;
58     }
59 
60     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
61         //same as above. Replace this line with the following if you want to protect against wrapping uints.
62         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
63         uint256 allowance = allowed[_from][msg.sender];
64         require(balances[_from] >= _value && allowance >= _value);
65         balances[_to] += _value;
66         balances[_from] -= _value;
67         if (allowance < MAX_UINT256) {
68             allowed[_from][msg.sender] -= _value;
69         }
70         Transfer(_from, _to, _value);
71         return true;
72     }
73 
74     function balanceOf(address _owner) view public returns (uint256 balance) {
75         return balances[_owner];
76     }
77 
78     function approve(address _spender, uint256 _value) public returns (bool success) {
79         allowed[msg.sender][_spender] = _value;
80         Approval(msg.sender, _spender, _value);
81         return true;
82     }
83 
84     function allowance(address _owner, address _spender)
85     view public returns (uint256 remaining) {
86       return allowed[_owner][_spender];
87     }
88 
89     mapping (address => uint256) balances;
90     mapping (address => mapping (address => uint256)) allowed;
91 }
92 
93 contract HumanStandardToken is StandardToken {
94 
95     /* Public variables of the token */
96 
97     /*
98     NOTE:
99     The following variables are OPTIONAL vanities. One does not have to include them.
100     They allow one to customise the token contract & in no way influences the core functionality.
101     Some wallets/interfaces might not even bother to look at this information.
102     */
103     string public name;                   //fancy name: eg Simon Bucks
104     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
105     string public symbol;                 //An identifier: eg SBX
106     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
107 
108      function HumanStandardToken(
109         uint256 _initialAmount,
110         string _tokenName,
111         uint8 _decimalUnits,
112         string _tokenSymbol
113         ) public {
114         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
115         totalSupply = _initialAmount;                        // Update total supply
116         name = _tokenName;                                   // Set the name for display purposes
117         decimals = _decimalUnits;                            // Amount of decimals for display purposes
118         symbol = _tokenSymbol;                               // Set the symbol for display purposes
119     }
120 
121     /* Approves and then calls the receiving contract */
122     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
123         allowed[msg.sender][_spender] = _value;
124         Approval(msg.sender, _spender, _value);
125 
126         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
127         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
128         //it is assumed when one does this that the call *should* succeed, otherwise one would use vanilla approve instead.
129         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
130         return true;
131     }
132 }