1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
3 pragma solidity ^0.4.18;
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
47     /// @param _value Then number of tokens to burn
48     /// @return Whether the burn was successful or not
49     function burn(uint256 _value) public returns (bool success);
50 
51     // solhint-disable-next-line no-simple-event-func-name  
52     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
53     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
54     event Burn(address indexed burner, uint256 value);
55 }
56 
57 /*
58 Implements EIP20 token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
59 .*/
60 
61 
62 contract EIP20 is EIP20Interface {
63 
64     uint256 constant private MAX_UINT256 = 2**256 - 1;
65     mapping (address => uint256) public balances;
66     mapping (address => mapping (address => uint256)) public allowed;
67     /*
68     NOTE:
69     The following variables are OPTIONAL vanities. One does not have to include them.
70     They allow one to customise the token contract & in no way influences the core functionality.
71     Some wallets/interfaces might not even bother to look at this information.
72     */
73     string public name;                   //fancy name: eg Simon Bucks
74     uint8 public decimals;                //How many decimals to show.
75     string public symbol;                 //An identifier: eg SBX
76     address public owner;                 //owner
77 
78     function EIP20(
79         uint256 _initialAmount,
80         string _tokenName,
81         uint8 _decimalUnits,
82         string _tokenSymbol
83     ) public {
84         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
85         totalSupply = _initialAmount;                        // Update total supply
86         name = _tokenName;                                   // Set the name for display purposes
87         decimals = _decimalUnits;                            // Amount of decimals for display purposes
88         symbol = _tokenSymbol;                               // Set the symbol for display purposes
89         owner = msg.sender;
90     }
91 
92     function transfer(address _to, uint256 _value) public returns (bool success) {
93         require(balances[msg.sender] >= _value);
94         balances[msg.sender] -= _value;
95         balances[_to] += _value;
96         Transfer(msg.sender, _to, _value);
97         return true;
98     }
99 
100     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
101         uint256 allowance = allowed[_from][msg.sender];
102         require(balances[_from] >= _value && allowance >= _value);
103         balances[_to] += _value;
104         balances[_from] -= _value;
105         if (allowance < MAX_UINT256) {
106             allowed[_from][msg.sender] -= _value;
107         }
108         Transfer(_from, _to, _value);
109         return true;
110     }
111 
112     function balanceOf(address _owner) public view returns (uint256 balance) {
113         return balances[_owner];
114     }
115 
116     function approve(address _spender, uint256 _value) public returns (bool success) {
117         allowed[msg.sender][_spender] = _value;
118         Approval(msg.sender, _spender, _value);
119         return true;
120     }
121 
122     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
123         return allowed[_owner][_spender];
124     }
125 
126     function burn(uint256 _value) public returns (bool success) {
127         require(_value > 0);
128         require(_value <= balances[msg.sender]);
129         require(owner == msg.sender);
130 
131         balances[msg.sender] -= _value;
132         totalSupply -= _value;
133 
134         Burn(msg.sender, _value);
135         Transfer(msg.sender, address(0), _value);
136         return true;
137     }
138 }
139 
140 contract KKKKCOIN is EIP20(1290000000, "KKKKCOIN", 2, "KKKK") {}