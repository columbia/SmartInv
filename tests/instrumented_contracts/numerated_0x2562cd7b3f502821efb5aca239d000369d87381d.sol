1 contract Token {
2 
3     /// @return total amount of tokens
4     function totalSupply() constant returns (uint256 supply) {}
5 
6     /// @param _owner The address from which the balance will be retrieved
7     /// @return The balance
8     function balanceOf(address _owner) constant returns (uint256 balance) {}
9 
10     /// @notice send `_value` token to `_to` from `msg.sender`
11     /// @param _to The address of the recipient
12     /// @param _value The amount of token to be transferred
13     /// @return Whether the transfer was successful or not
14     function transfer(address _to, uint256 _value) returns (bool success) {}
15 
16     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
17     /// @param _from The address of the sender
18     /// @param _to The address of the recipient
19     /// @param _value The amount of token to be transferred
20     /// @return Whether the transfer was successful or not
21     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
22 
23     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
24     /// @param _spender The address of the account able to transfer the tokens
25     /// @param _value The amount of wei to be approved for transfer
26     /// @return Whether the approval was successful or not
27     function approve(address _spender, uint256 _value) returns (bool success) {}
28 
29     /// @param _owner The address of the account owning tokens
30     /// @param _spender The address of the account able to transfer the tokens
31     /// @return Amount of remaining tokens allowed to spent
32     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
33 
34     event Transfer(address indexed _from, address indexed _to, uint256 _value);
35     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36 }
37 
38 
39 /*
40 This implements ONLY the standard functions and NOTHING else.
41 For a token like you would want to deploy in something like Mist, see MaiaToken.sol.
42 
43 If you deploy this, you won't have anything useful.
44 
45 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
46 .*/
47 
48 contract StandardToken is Token {
49 
50     function transfer(address _to, uint256 _value) returns (bool success) {
51         //Default assumes totalSupply can't be over max (2^256 - 1).
52         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
53         //Replace the if with this one instead.
54         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
55         if (balances[msg.sender] >= _value && _value > 0) {
56             balances[msg.sender] -= _value;
57             balances[_to] += _value;
58             Transfer(msg.sender, _to, _value);
59             return true;
60         } else { return false; }
61     }
62 
63     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
64         //same as above. Replace this line with the following if you want to protect against wrapping uints.
65         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
66         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
67             balances[_to] += _value;
68             balances[_from] -= _value;
69             allowed[_from][msg.sender] -= _value;
70             Transfer(_from, _to, _value);
71             return true;
72         } else { return false; }
73     }
74 
75     function balanceOf(address _owner) constant returns (uint256 balance) {
76         return balances[_owner];
77     }
78 
79     function approve(address _spender, uint256 _value) returns (bool success) {
80         allowed[msg.sender][_spender] = _value;
81         Approval(msg.sender, _spender, _value);
82         return true;
83     }
84 
85     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
86       return allowed[_owner][_spender];
87     }
88 
89     mapping (address => uint256) balances;
90     mapping (address => mapping (address => uint256)) allowed;
91     uint256 public totalSupply;
92 }
93 
94 /*
95 This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
96 
97 In other words. This is intended for deployment in something like a Token Factory or Mist wallet, and then used by humans.
98 Imagine coins, currencies, shares, voting weight, etc.
99 Machine-based, rapid creation of many tokens would not necessarily need these extra features or will be minted in other manners.
100 
101 1) Initial Finite Supply (upon creation one specifies how much is minted).
102 2) In the absence of a token registry: Optional Decimal, Symbol & Name.
103 3) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.
104 
105 .*/
106 
107 contract MaiaToken is StandardToken {
108 
109     function () {
110         //if ether is sent to this address, send it back.
111         throw;
112     }
113 
114     /* Public variables of the token */
115 
116     /*
117     NOTE:
118     The following variables are OPTIONAL vanities. One does not have to include them.
119     They allow one to customise the token contract & in no way influences the core functionality.
120     Some wallets/interfaces might not even bother to look at this information.
121     */
122     string public name;                   //fancy name: eg Simon Bucks
123     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
124     string public symbol;                 //An identifier: eg SBX
125     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
126 
127     function MaiaToken(
128         uint256 _initialAmount,
129         string _tokenName,
130         uint8 _decimalUnits,
131         string _tokenSymbol
132         ) {
133         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
134         totalSupply = _initialAmount;                        // Update total supply
135         name = _tokenName;                                   // Set the name for display purposes
136         decimals = _decimalUnits;                            // Amount of decimals for display purposes
137         symbol = _tokenSymbol;                               // Set the symbol for display purposes
138     }
139 
140     /* Approves and then calls the receiving contract */
141     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
142         allowed[msg.sender][_spender] = _value;
143         Approval(msg.sender, _spender, _value);
144 
145         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
146         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
147         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
148         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
149         return true;
150     }
151 }