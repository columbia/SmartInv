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
13 
14 pragma solidity ^0.4.8;
15 
16 contract Token {
17     /* This is a slight change to the ERC20 base standard.
18     function totalSupply() constant returns (uint256 supply);
19     is replaced with:
20     uint256 public totalSupply;
21     This automatically creates a getter function for the totalSupply.
22     This is moved to the base contract since public getter functions are not
23     currently recognised as an implementation of the matching abstract
24     function by the compiler.
25     */
26     /// total amount of tokens
27     uint256 public totalSupply;
28 
29     /// @param _owner The address from which the balance will be retrieved
30     /// @return The balance
31     function balanceOf(address _owner) public view returns (uint256 balance);
32 
33     /// @notice send `_value` token to `_to` from `msg.sender`
34     /// @param _to The address of the recipient
35     /// @param _value The amount of token to be transferred
36     /// @return Whether the transfer was successful or not
37     function transfer(address _to, uint256 _value) public returns (bool success);
38 
39     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
40     /// @param _from The address of the sender
41     /// @param _to The address of the recipient
42     /// @param _value The amount of token to be transferred
43     /// @return Whether the transfer was successful or not
44     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
45 
46     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
47     /// @param _spender The address of the account able to transfer the tokens
48     /// @param _value The amount of tokens to be approved for transfer
49     /// @return Whether the approval was successful or not
50     function approve(address _spender, uint256 _value) public returns (bool success);
51 
52     /// @param _owner The address of the account owning tokens
53     /// @param _spender The address of the account able to transfer the tokens
54     /// @return Amount of remaining tokens allowed to spent
55     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
56 
57     event Transfer(address indexed _from, address indexed _to, uint256 _value);
58     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
59 }
60 
61 contract StandardToken is Token {
62 
63     uint256 constant MAX_UINT256 = 2**256 - 1;
64 
65     function transfer(address _to, uint256 _value) public returns (bool success) {
66         //Default assumes totalSupply can't be over max (2^256 - 1).
67         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
68         //Replace the if with this one instead.
69         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
70         require(balances[msg.sender] >= _value && _to != 0x0);
71         balances[msg.sender] -= _value;
72         balances[_to] += _value;
73         Transfer(msg.sender, _to, _value);
74         return true;
75     }
76 
77     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
78         //same as above. Replace this line with the following if you want to protect against wrapping uints.
79         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
80         uint256 allowance = allowed[_from][msg.sender];
81         require(balances[_from] >= _value && allowance >= _value && _to != 0x0);
82         balances[_to] += _value;
83         balances[_from] -= _value;
84         if (allowance < MAX_UINT256) {
85             allowed[_from][msg.sender] -= _value;
86         }
87         Transfer(_from, _to, _value);
88         return true;
89     }
90 
91     function balanceOf(address _owner) view public returns (uint256 balance) {
92         return balances[_owner];
93     }
94 
95     function approve(address _spender, uint256 _value) public returns (bool success) {
96         allowed[msg.sender][_spender] = _value;
97         Approval(msg.sender, _spender, _value);
98         return true;
99     }
100 
101     function allowance(address _owner, address _spender)
102     view public returns (uint256 remaining) 
103     {
104       return allowed[_owner][_spender];
105     }
106 
107     mapping (address => uint256) balances;
108     mapping (address => mapping (address => uint256)) allowed;
109 }
110 
111 
112 contract HumanStandardToken is StandardToken {
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
125     string public version = "H0.1";       //human 0.1 standard. Just an arbitrary versioning scheme.
126 
127      function HumanStandardToken(
128         uint256 _initialAmount,
129         string _tokenName,
130         uint8 _decimalUnits,
131         string _tokenSymbol
132         ) public 
133     {
134         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
135         totalSupply = _initialAmount;                        // Update total supply
136         name = _tokenName;                                   // Set the name for display purposes
137         decimals = _decimalUnits;                            // Amount of decimals for display purposes
138         symbol = _tokenSymbol;                               // Set the symbol for display purposes
139     }
140 
141     /* Approves and then calls the receiving contract */
142     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
143         allowed[msg.sender][_spender] = _value;
144         Approval(msg.sender, _spender, _value);
145 
146         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
147         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
148         //it is assumed when one does this that the call *should* succeed, otherwise one would use vanilla approve instead.
149         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
150         return true;
151     }
152 }