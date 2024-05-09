1 pragma solidity ^0.4.21;
2 
3 contract REDChainInterface {
4     /// total amount of tokens
5     uint256 public totalSupply;
6 
7     /// @notice send `_value` token to `_to` from `msg.sender`
8     /// @param _to The address of the recipient
9     /// @param _value The amount of token to be transferred
10     /// @return Whether the transfer was successful or not
11     function transfer(address _to, uint256 _value) public returns (bool success);
12 
13     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
14     /// @param _from The address of the sender
15     /// @param _to The address of the recipient
16     /// @param _value The amount of token to be transferred
17     /// @return Whether the transfer was successful or not
18     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
19 
20     /// @param _owner The address from which the balance will be retrieved
21     /// @return The balance
22     function balanceOf(address _owner) public view returns (uint256 balance);
23 
24     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
25     /// @param _spender The address of the account able to transfer the tokens
26     /// @param _value The amount of tokens to be approved for transfer
27     /// @return Whether the approval was successful or not
28     function approve(address _spender, uint256 _value) public returns (bool success);
29 
30     /// @param _owner The address of the account owning tokens
31     /// @param _spender The address of the account able to transfer the tokens
32     /// @return Amount of remaining tokens allowed to spent
33     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
34 
35     /// solhint-disable-next-line no-simple-event-func-name
36     event Transfer(address indexed _from, address indexed _to, uint256 _value);
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 }
39 
40 contract REDChain is REDChainInterface {
41 
42     uint256 constant private MAX_UINT256 = 2**256 - 1;
43     
44     mapping (address => uint256) public balances;
45     
46     mapping (address => mapping (address => uint256)) public allowed;
47 
48     /*
49     NOTE:
50     The following variables are OPTIONAL vanities. One does not have to include them.
51     They allow one to customise the token contract & in no way influences the core functionality.
52     Some wallets/
53     
54     
55      might not even bother to look at this information.
56     */
57     string public name;                   //fancy name: eg Simon Bucks
58     uint8 public decimals;                //How many decimals to show.
59     string public symbol;                 //An identifier: eg SBX
60 
61     function REDChain (
62         uint256 _initialAmount,
63         string _tokenName,
64         uint8 _decimalUnits,
65         string _tokenSymbol
66     ) public {
67         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
68         totalSupply = _initialAmount;                        // Update total supply
69         name = _tokenName;                                   // Set the name for display purposes
70         decimals = _decimalUnits;                            // Amount of decimals for display purposes
71         symbol = _tokenSymbol;                               // Set the symbol for display purposes
72     }
73 
74     /// @notice send `_value` token to `_to` from `msg.sender`
75     /// @param _to The address of the recipient
76     /// @param _value The amount of token to be transferred
77     /// @return Whether the transfer was successful or not
78     function transfer(address _to, uint256 _value) public returns (bool success) {
79         require(_to != 0x0);
80         require(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]);
81         balances[msg.sender] -= _value;
82         balances[_to] += _value;
83         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
84         return true;
85     }
86 
87     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
88     /// @param _from The address of the sender
89     /// @param _to The address of the recipient
90     /// @param _value The amount of token to be transferred
91     /// @return Whether the transfer was successful or not
92     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
93         uint256 allowance = allowed[_from][msg.sender];
94         require(balances[_from] >= _value && allowance >= _value && balances[_to] + _value >= balances[_to]);
95         require(_to != 0x0);
96         balances[_to] += _value;
97         balances[_from] -= _value;
98         if (allowance < MAX_UINT256) {
99             allowed[_from][msg.sender] -= _value;
100         }
101         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
102         return true;
103     }
104 
105     /// @param _owner The address from which the balance will be retrieved
106     /// @return The balance
107     function balanceOf(address _owner) public view returns (uint256 balance) {
108         return balances[_owner];
109     }
110 
111     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
112     /// @param _spender The address of the account able to transfer the tokens
113     /// @param _value The amount of tokens to be approved for transfer
114     /// @return Whether the approval was successful or not
115     function approve(address _spender, uint256 _value) public returns (bool success) {
116         allowed[msg.sender][_spender] = _value;
117         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
118         return true;
119     }
120 
121     /// @param _owner The address of the account owning tokens
122     /// @param _spender The address of the account able to transfer the tokens
123     /// @return Amount of remaining tokens allowed to spent
124     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
125         return allowed[_owner][_spender];
126     }
127 }