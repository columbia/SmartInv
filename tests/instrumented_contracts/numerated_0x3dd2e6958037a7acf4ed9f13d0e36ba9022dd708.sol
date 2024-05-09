1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/issues/20
3 pragma solidity ^0.4.18;
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
20     function balanceOf(address _owner) public view returns (uint256 balance);
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
44     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
45 
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 contract StandardToken is Token {
50 
51     uint256 constant MAX_UINT256 = 2**256 - 1;
52 
53     function transfer(address _to, uint256 _value) public returns (bool success) {
54         //Default assumes totalSupply can't be over max (2^256 - 1).
55         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
56         //Replace the if with this one instead.
57         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
58         require(balances[msg.sender] >= _value);
59         balances[msg.sender] -= _value;
60         balances[_to] += _value;
61         emit Transfer(msg.sender, _to, _value);
62         return true;
63     }
64 
65     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
66         //same as above. Replace this line with the following if you want to protect against wrapping uints.
67         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
68         uint256 allowance = allowed[_from][msg.sender];
69         require(balances[_from] >= _value && allowance >= _value);
70         balances[_to] += _value;
71         balances[_from] -= _value;
72         if (allowance < MAX_UINT256) {
73             allowed[_from][msg.sender] -= _value;
74         }
75         emit Transfer(_from, _to, _value);
76         return true;
77     }
78 
79     function balanceOf(address _owner) view public returns (uint256 balance) {
80         return balances[_owner];
81     }
82 
83     function approve(address _spender, uint256 _value) public returns (bool success) {
84         allowed[msg.sender][_spender] = _value;
85         emit Approval(msg.sender, _spender, _value);
86         return true;
87     }
88 
89     function allowance(address _owner, address _spender)
90     view public returns (uint256 remaining) {
91       return allowed[_owner][_spender];
92     }
93 
94     mapping (address => uint256) balances;
95     mapping (address => mapping (address => uint256)) allowed;
96 }
97 
98 contract HTCStandardToken is StandardToken {
99 
100     /* Public variables of the token */
101 
102     /*
103     NOTE:
104     The following variables are OPTIONAL vanities. One does not have to include them.
105     They allow one to customise the token contract & in no way influences the core functionality.
106     Some wallets/interfaces might not even bother to look at this information.
107     */
108     string public name;                   //fancy name: eg Simon Bucks
109     uint8 public decimals;                //How many decimals to show. 
110     string public symbol;                 //An identifier
111     string public version = 'F0.1';       // Just an arbitrary versioning scheme.
112 
113      constructor(
114         uint256 _initialAmount,
115         string _tokenName,
116         uint8 _decimalUnits,
117         string _tokenSymbol
118         ) public {
119         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
120         totalSupply = _initialAmount;                        // Update total supply
121         name = _tokenName;                                   // Set the name for display purposes
122         decimals = _decimalUnits;                            // Amount of decimals for display purposes
123         symbol = _tokenSymbol;                               // Set the symbol for display purposes
124     }
125 
126     /* Approves and then calls the receiving contract */
127     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
128         allowed[msg.sender][_spender] = _value;
129         emit Approval(msg.sender, _spender, _value);
130 
131         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
132         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
133         //it is assumed when one does this that the call *should* succeed, otherwise one would use vanilla approve instead.
134         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
135         return true;
136     }
137 }
138 // Creates 1,000,000,000.000000000000000000 HuiTong Coin (HTC) Tokens
139 contract HTC is HTCStandardToken(1000000000000000000000000000, "HuiTong Coin", 18, "HTC") {}