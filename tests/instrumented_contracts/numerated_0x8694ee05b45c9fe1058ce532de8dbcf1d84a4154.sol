1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
3 pragma solidity ^0.4.21;
4 
5 
6 contract EIP20Interface {
7     /* This is a slight change to the ERC20 base standard.
8     function totalSupply() constant returns (uint256 supply);
9     is replaced with:
10     uint256 public totalSupply;
11     This automatically creates a getter function for the totalSupply.
12     This is moved to the base contract since public getter functions are not
13     currently recognised as an implementation of the matching abstract
14     function by the compiler.
15     */
16     /// total amount of tokens
17     uint256 public totalSupply;
18 
19     /// @param _owner The address from which the balance will be retrieved
20     /// @return The balance
21     function balanceOf(address _owner) public view returns (uint256 balance);
22 
23     /// @notice send `_value` token to `_to` from `msg.sender`
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transfer(address _to, uint256 _value) public returns (bool success);
28 
29     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
30     /// @param _from The address of the sender
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
35 
36     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @param _value The amount of tokens to be approved for transfer
39     /// @return Whether the approval was successful or not
40     function approve(address _spender, uint256 _value) public returns (bool success);
41 
42     /// @param _owner The address of the account owning tokens
43     /// @param _spender The address of the account able to transfer the tokens
44     /// @return Amount of remaining tokens allowed to spent
45     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
46 
47     // solhint-disable-next-line no-simple-event-func-name
48     event Transfer(address indexed _from, address indexed _to, uint256 _value);
49     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
50 }
51 
52 /*
53 Implements EIP20 token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
54 .*/
55 
56 
57 pragma solidity ^0.4.21;
58 
59 
60 contract TreasureFinancialCoin is EIP20Interface {
61 
62     uint256 constant private MAX_UINT256 = 2**256 - 1;
63     mapping (address => uint256) public balances;
64     mapping (address => mapping (address => uint256)) public allowed;
65     /*
66     NOTE:
67     The following variables are OPTIONAL vanities. One does not have to include them.
68     They allow one to customise the token contract & in no way influences the core functionality.
69     Some wallets/interfaces might not even bother to look at this information.
70     */
71     string public name;                   //fancy name: eg Simon Bucks
72     uint8 public decimals;                //How many decimals to show.
73     string public symbol;                 //An identifier: eg SBX
74 
75     function TreasureFinancialCoin(
76         uint256 _initialAmount,
77         string _tokenName,
78         uint8 _decimalUnits,
79         string _tokenSymbol
80     ) public {
81         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
82         totalSupply = _initialAmount;                        // Update total supply
83         name = _tokenName;                                   // Set the name for display purposes
84         decimals = _decimalUnits;                            // Amount of decimals for display purposes
85         symbol = _tokenSymbol;                               // Set the symbol for display purposes
86     }
87 
88     function transfer(address _to, uint256 _value) public returns (bool success) {
89         require(balances[msg.sender] >= _value);
90         balances[msg.sender] -= _value;
91         balances[_to] += _value;
92         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
93         return true;
94     }
95 
96     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
97         uint256 allowance = allowed[_from][msg.sender];
98         require(balances[_from] >= _value && allowance >= _value);
99         balances[_to] += _value;
100         balances[_from] -= _value;
101         if (allowance < MAX_UINT256) {
102             allowed[_from][msg.sender] -= _value;
103         }
104         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
105         return true;
106     }
107 
108     function balanceOf(address _owner) public view returns (uint256 balance) {
109         return balances[_owner];
110     }
111 
112     function approve(address _spender, uint256 _value) public returns (bool success) {
113         allowed[msg.sender][_spender] = _value;
114         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
115         return true;
116     }
117 
118     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
119         return allowed[_owner][_spender];
120     }
121 }