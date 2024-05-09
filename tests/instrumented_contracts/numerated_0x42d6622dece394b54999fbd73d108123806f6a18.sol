1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 pragma solidity 0.4.15;
4 
5 contract Token {
6     /* This is a slight change to the ERC20 base standard.
7     function totalSupply() constant returns (uint256 supply);
8     is replaced with:
9     uint256 public totalSupply;
10     This automatically creates a getter function for the totalSupply.
11     This is moved to the base contract since public getter functions are not
12     currently recognised as an implementation of the matching abstract
13     function by the compiler.
14     */
15     /// total amount of tokens
16     uint256 public totalSupply;
17 
18     /// @param _owner The address from which the balance will be retrieved
19     /// @return The balance
20     function balanceOf(address _owner) constant returns (uint256 balance);
21 
22     /// @notice send `_value` token to `_to` from `msg.sender`
23     /// @param _to The address of the recipient
24     /// @param _value The amount of token to be transferred
25     /// @return Whether the transfer was successful or not
26     function transfer(address _to, uint256 _value) returns (bool success);
27 
28     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
29     /// @param _from The address of the sender
30     /// @param _to The address of the recipient
31     /// @param _value The amount of token to be transferred
32     /// @return Whether the transfer was successful or not
33     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
34 
35     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @param _value The amount of tokens to be approved for transfer
38     /// @return Whether the approval was successful or not
39     function approve(address _spender, uint256 _value) returns (bool success);
40 
41     /// @param _owner The address of the account owning tokens
42     /// @param _spender The address of the account able to transfer the tokens
43     /// @return Amount of remaining tokens allowed to spent
44     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
45 
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 
51 /*
52 You should inherit from StandardToken or, for a token like you would want to
53 deploy in something like Mist, see HumanStandardToken.sol.
54 (This implements ONLY the standard functions and NOTHING else.
55 If you deploy this, you won't have anything useful.)
56 
57 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
58 .*/
59 contract StandardToken is Token {
60 
61     function transfer(address _to, uint256 _value) returns (bool success) {
62         //Default assumes totalSupply can't be over max (2^256 - 1).
63         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
64         //Replace the if with this one instead.
65         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
66         require(balances[msg.sender] >= _value);
67         balances[msg.sender] -= _value;
68         balances[_to] += _value;
69         Transfer(msg.sender, _to, _value);
70         return true;
71     }
72 
73     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
74         //same as above. Replace this line with the following if you want to protect against wrapping uints.
75         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
76         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
77         balances[_to] += _value;
78         balances[_from] -= _value;
79         allowed[_from][msg.sender] -= _value;
80         Transfer(_from, _to, _value);
81         return true;
82     }
83 
84     function balanceOf(address _owner) constant returns (uint256 balance) {
85         return balances[_owner];
86     }
87 
88     function approve(address _spender, uint256 _value) returns (bool success) {
89         allowed[msg.sender][_spender] = _value;
90         Approval(msg.sender, _spender, _value);
91         return true;
92     }
93 
94     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
95       return allowed[_owner][_spender];
96     }
97 
98     mapping (address => uint256) balances;
99     mapping (address => mapping (address => uint256)) allowed;
100 }
101 
102 /*
103 This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
104 
105 In other words. This is intended for deployment in something like a Token Factory or Mist wallet, and then used by humans.
106 Imagine coins, currencies, shares, voting weight, etc.
107 Machine-based, rapid creation of many tokens would not necessarily need these extra features or will be minted in other manners.
108 
109 1) Initial Finite Supply (upon creation one specifies how much is minted).
110 2) In the absence of a token registry: Optional Decimal, Symbol & Name.
111 3) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.
112 
113 .*/
114 contract HumanStandardToken is StandardToken {
115 
116     /* Public variables of the token */
117 
118     /*
119     NOTE:
120     The following variables are OPTIONAL vanities. One does not have to include them.
121     They allow one to customise the token contract & in no way influences the core functionality.
122     Some wallets/interfaces might not even bother to look at this information.
123     */
124     string public name;                   //fancy name: eg Simon Bucks
125     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
126     string public symbol;                 //An identifier: eg SBX
127     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
128 
129     function HumanStandardToken(
130         uint256 _initialAmount,
131         string _tokenName,
132         uint8 _decimalUnits,
133         string _tokenSymbol
134         ) {
135         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
136         totalSupply = _initialAmount;                        // Update total supply
137         name = _tokenName;                                   // Set the name for display purposes
138         decimals = _decimalUnits;                            // Amount of decimals for display purposes
139         symbol = _tokenSymbol;                               // Set the symbol for display purposes
140     }
141 
142     /* Approves and then calls the receiving contract */
143     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
144         allowed[msg.sender][_spender] = _value;
145         Approval(msg.sender, _spender, _value);
146 
147         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
148         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
149         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
150         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
151         return true;
152     }
153 }