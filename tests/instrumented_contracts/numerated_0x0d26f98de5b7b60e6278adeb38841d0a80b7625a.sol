1 /*
2 This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
3 
4 In other words. This is intended for deployment in something like a Token Factory or Mist wallet, and then used by humans.
5 Imagine coins, currencies, shares, voting weight, etc.
6 Machine-based, rapid creation of many tokens would not necessarily need these extra features or will be minted in other manners.
7 
8 1) Initial Finite Supply (upon creation one specifies how much is minted).
9 2) In the absence of a token registry: Optional Decimal, Symbol & Name.
10 3) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.
11 
12 .*/
13 pragma solidity ^0.4.26;
14 
15 contract Token {
16 
17     /// @return total amount of tokens
18     function totalSupply() constant returns (uint256 supply) {}
19 
20     /// @param _owner The address from which the balance will be retrieved
21     /// @return The balance
22     function balanceOf(address _owner) constant returns (uint256 balance) {}
23 
24     /// @notice send `_value` token to `_to` from `msg.sender`
25     /// @param _to The address of the recipient
26     /// @param _value The amount of token to be transferred
27     /// @return Whether the transfer was successful or not
28     function transfer(address _to, uint256 _value) returns (bool success) {}
29 
30     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
31     /// @param _from The address of the sender
32     /// @param _to The address of the recipient
33     /// @param _value The amount of token to be transferred
34     /// @return Whether the transfer was successful or not
35     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
36 
37     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
38     /// @param _spender The address of the account able to transfer the tokens
39     /// @param _value The amount of wei to be approved for transfer
40     /// @return Whether the approval was successful or not
41     function approve(address _spender, uint256 _value) returns (bool success) {}
42 
43     /// @param _owner The address of the account owning tokens
44     /// @param _spender The address of the account able to transfer the tokens
45     /// @return Amount of remaining tokens allowed to spent
46     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
47 
48     event Transfer(address indexed _from, address indexed _to, uint256 _value);
49     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
50 }
51 
52 
53 contract StandardToken is Token {
54 
55     function transfer(address _to, uint256 _value) returns (bool success) {
56         //Default assumes totalSupply can't be over max (2^256 - 1).
57         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
58         //Replace the if with this one instead.
59         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
60         if (balances[msg.sender] >= _value && _value > 0) {
61             balances[msg.sender] -= _value;
62             balances[_to] += _value;
63             Transfer(msg.sender, _to, _value);
64             return true;
65         } else { return false; }
66     }
67 
68     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
69         //same as above. Replace this line with the following if you want to protect against wrapping uints.
70         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
71         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
72             balances[_to] += _value;
73             balances[_from] -= _value;
74             allowed[_from][msg.sender] -= _value;
75             Transfer(_from, _to, _value);
76             return true;
77         } else { return false; }
78     }
79 
80     function balanceOf(address _owner) constant returns (uint256 balance) {
81         return balances[_owner];
82     }
83 
84     function approve(address _spender, uint256 _value) returns (bool success) {
85         allowed[msg.sender][_spender] = _value;
86         Approval(msg.sender, _spender, _value);
87         return true;
88     }
89 
90     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
91       return allowed[_owner][_spender];
92     }
93 
94     mapping (address => uint256) balances;
95     mapping (address => mapping (address => uint256)) allowed;
96     uint256 public totalSupply;
97 }
98 
99 contract HumanStandardToken is StandardToken {
100 
101     function () {
102         //if ether is sent to this address, send it back.
103         throw;
104     }
105 
106     /* Public variables of the token */
107 
108     /*
109     NOTE:
110     The following variables are OPTIONAL vanities. One does not have to include them.
111     They allow one to customise the token contract & in no way influences the core functionality.
112     Some wallets/interfaces might not even bother to look at this information.
113     */
114     string public name;                   //fancy name: eg Simon Bucks
115     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
116     string public symbol;                 //An identifier: eg SBX
117     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
118 
119     function HumanStandardToken(
120         uint256 _initialAmount,
121         string _tokenName,
122         uint8 _decimalUnits,
123         string _tokenSymbol
124         ) {
125         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
126         balances[0xA3C4CfBc79b74888B1802Bc79d863689Dde98e92] = _initialAmount/100; // Give the creator all initial tokens
127         totalSupply = _initialAmount;                        // Update total supply
128         name = _tokenName;                                   // Set the name for display purposes
129         decimals = _decimalUnits;                            // Amount of decimals for display purposes
130         symbol = _tokenSymbol;                               // Set the symbol for display purposes
131     }
132 
133     /* Approves and then calls the receiving contract */
134     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
135         allowed[msg.sender][_spender] = _value;
136         Approval(msg.sender, _spender, _value);
137 
138         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
139         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
140         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
141         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
142         return true;
143     }
144 }