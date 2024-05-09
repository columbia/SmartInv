1 pragma solidity ^0.4.8;
2 
3 contract Token {
4     /* This is a slight change to the ERC20 base standard.
5     function totalSupply() constant returns (uint256 supply);
6     is replaced with:
7     uint256 public totalSupply;
8     This automatically creates a getter function for the totalSupply.
9     This is moved to the base contract since public getter functions are not
10     currently recognised as an implementation of the matching abstract
11     function by the compiler.
12     */
13     /// total amount of tokens
14     uint256 public totalSupply;
15 
16     /// @param _owner The address from which the balance will be retrieved
17     /// @return The balance
18     function balanceOf(address _owner) public view returns (uint256 balance);
19 
20     /// @notice send `_value` token to `_to` from `msg.sender`
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transfer(address _to, uint256 _value) public returns (bool success);
25 
26     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
27     /// @param _from The address of the sender
28     /// @param _to The address of the recipient
29     /// @param _value The amount of token to be transferred
30     /// @return Whether the transfer was successful or not
31     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
32 
33     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
34     /// @param _spender The address of the account able to transfer the tokens
35     /// @param _value The amount of tokens to be approved for transfer
36     /// @return Whether the approval was successful or not
37     function approve(address _spender, uint256 _value) public returns (bool success);
38 
39     /// @param _owner The address of the account owning tokens
40     /// @param _spender The address of the account able to transfer the tokens
41     /// @return Amount of remaining tokens allowed to spent
42     function allowance(address _owner, address _spender) public returns (uint256 remaining);
43 
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 }
47 
48 /*
49 You should inherit from StandardToken or, for a token like you would want to
50 deploy in something like Mist, see HumanStandardToken.sol.
51 (This implements ONLY the standard functions and NOTHING else.
52 If you deploy this, you won't have anything useful.)
53 
54 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
55 .*/
56 
57 contract StandardToken is Token {
58 
59     uint256 constant MAX_UINT256 = 2**256 - 1;
60 
61     function transfer(address _to, uint256 _value) public returns (bool success) {
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
73     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
74         //same as above. Replace this line with the following if you want to protect against wrapping uints.
75         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
76         uint256 allowance = allowed[_from][msg.sender];
77         require(balances[_from] >= _value && allowance >= _value);
78         balances[_to] += _value;
79         balances[_from] -= _value;
80         if (allowance < MAX_UINT256) {
81             allowed[_from][msg.sender] -= _value;
82         }
83         Transfer(_from, _to, _value);
84         return true;
85     }
86 
87     function balanceOf(address _owner) public view returns (uint256 balance) {
88         return balances[_owner];
89     }
90 
91     function approve(address _spender, uint256 _value) public returns (bool success) {
92         allowed[msg.sender][_spender] = _value;
93         Approval(msg.sender, _spender, _value);
94         return true;
95     }
96 
97     function allowance(address _owner, address _spender) public returns (uint256 remaining) {
98         return allowed[_owner][_spender];
99     }
100 
101     mapping (address => uint256) balances;
102     mapping (address => mapping (address => uint256)) allowed;
103 }
104 
105 /*
106 This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
107 
108 In other words. This is intended for deployment in something like a Token Factory or Mist wallet, and then used by humans.
109 Imagine coins, currencies, shares, voting weight, etc.
110 Machine-based, rapid creation of many tokens would not necessarily need these extra features or will be minted in other manners.
111 
112 1) Initial Finite Supply (upon creation one specifies how much is minted).
113 2) In the absence of a token registry: Optional Decimal, Symbol & Name.
114 3) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.
115 
116 .*/
117 
118 contract HumanStandardToken is StandardToken {
119 
120     /* Public variables of the token */
121 
122     /*
123     NOTE:
124     The following variables are OPTIONAL vanities. One does not have to include them.
125     They allow one to customise the token contract & in no way influences the core functionality.
126     Some wallets/interfaces might not even bother to look at this information.
127     */
128     string public name;                   //fancy name: eg Simon Bucks
129     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
130     string public symbol;                 //An identifier: eg SBX
131     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
132 
133     function HumanStandardToken(
134         uint256 _initialAmount,
135         string _tokenName,
136         uint8 _decimalUnits,
137         string _tokenSymbol
138         ) public {
139             balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
140             totalSupply = _initialAmount;                        // Update total supply
141             name = _tokenName;                                   // Set the name for display purposes
142             decimals = _decimalUnits;                            // Amount of decimals for display purposes
143             symbol = _tokenSymbol;                               // Set the symbol for display purposes
144     }
145 
146     /* Approves and then calls the receiving contract */
147     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
148         allowed[msg.sender][_spender] = _value;
149         Approval(msg.sender, _spender, _value);
150 
151         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
152         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
153         //it is assumed when one does this that the call *should* succeed, otherwise one would use vanilla approve instead.
154         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
155         return true;
156     }
157 }