1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 pragma solidity ^0.4.24;
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
20     function balanceOf(address _owner) public constant returns (uint256 balance);
21 
22     /// @notice send `_value` token to `_to` from `msg.sender`
23     /// @param _to The address of the recipient
24     /// @param _value The amount of token to be transferred
25     /// @return Whether the transfer was successful or not
26     function transfer(address _to, uint256 _value) public returns (bool success);
27 
28     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
29     /// @param _from The address of the sender
30     /// @param _to The address of the recipient
31     /// @param _value The amount of token to be transferred
32     /// @return Whether the transfer was successful or not
33     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
34 
35     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @param _value The amount of tokens to be approved for transfer
38     /// @return Whether the approval was successful or not
39     function approve(address _spender, uint256 _value) public returns (bool success);
40 
41     /// @param _owner The address of the account owning tokens
42     /// @param _spender The address of the account able to transfer the tokens
43     /// @return Amount of remaining tokens allowed to spent
44     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
45 
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 /*
51 You should inherit from StandardToken or, for a token like you would want to
52 deploy in something like Mist, see HumanStandardToken.sol.
53 (This implements ONLY the standard functions and NOTHING else.
54 If you deploy this, you won't have anything useful.)
55 
56 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
57 .*/
58 
59 contract StandardToken is Token {
60 
61     function transfer(address _to, uint256 _value) public returns (bool success) {
62         //Default assumes totalSupply can't be over max (2^256 - 1).
63         if (balances[msg.sender] >= _value && _value > 0) {
64             balances[msg.sender] -= _value;
65             balances[_to] += _value;
66             emit Transfer(msg.sender, _to, _value);
67             return true;
68         } else { return false; }
69     }
70 
71     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
72         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
73             balances[_to] += _value;
74             balances[_from] -= _value;
75             allowed[_from][msg.sender] -= _value;
76             emit Transfer(_from, _to, _value);
77             return true;
78         } else { return false; }
79     }
80 
81     function balanceOf(address _owner) public constant returns (uint256 balance) {
82         return balances[_owner];
83     }
84 
85     function approve(address _spender, uint256 _value) public returns (bool success) {
86         allowed[msg.sender][_spender] = _value;
87         emit Approval(msg.sender, _spender, _value);
88         return true;
89     }
90 
91     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
92         return allowed[_owner][_spender];
93     }
94 
95     mapping (address => uint256) balances;
96     mapping (address => mapping (address => uint256)) allowed;
97 }
98 
99 contract SDAXToken is StandardToken {
100 
101     function () public {
102         //if ether is sent to this address, send it back.
103         revert();
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
114     string public name;                   //fancy name: eg SUNDAX TOKEN
115     string public symbol;                 //An identifier: eg SDAX
116     string public version = 'V0.1';       // 0.1 standard. Just an arbitrary versioning scheme.
117 
118     uint8 public constant decimals = 8;                              // Amount of decimals for display purposes
119     uint256 public constant PRECISION = (10 ** uint256(decimals));  // token's precision
120 
121     constructor(
122     uint256 _initialAmount,
123     string _tokenName,
124     string _tokenSymbol
125     ) public {
126         balances[msg.sender] = _initialAmount * PRECISION;   // Give the creator all initial tokens
127         totalSupply = _initialAmount * PRECISION;            // Update total supply
128         name = _tokenName;                                   // Set the name for display purposes
129         symbol = _tokenSymbol;                               // Set the symbol for display purposes
130     }
131 
132     function multisend(address[] dests, uint256[] values) public returns (uint256) {
133 
134         uint256 i = 0;
135         while (i < dests.length) {
136             require(balances[msg.sender] >= values[i]);
137             transfer(dests[i], values[i]);
138             i += 1;
139         }
140         return(i);
141     }
142 
143     /* Approves and then calls the receiving contract */
144     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
145         allowed[msg.sender][_spender] = _value;
146         emit Approval(msg.sender, _spender, _value);
147 
148         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
149         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
150         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
151         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
152         return true;
153     }
154 
155 }