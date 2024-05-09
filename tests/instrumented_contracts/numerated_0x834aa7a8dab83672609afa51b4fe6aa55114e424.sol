1 pragma solidity ^0.4.18;
2 
3 /*
4 Implements EIP20 token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
5 .*/
6 
7 
8 // Abstract contract for the full ERC 20 Token standard
9 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
10 contract EIP20Interface {
11     /* This is a slight change to the ERC20 base standard.
12     function totalSupply() constant returns (uint256 supply);
13     is replaced with:
14     uint256 public totalSupply;
15     This automatically creates a getter function for the totalSupply.
16     This is moved to the base contract since public getter functions are not
17     currently recognised as an implementation of the matching abstract
18     function by the compiler.
19     */
20     /// total amount of tokens
21     uint256 public totalSupply;
22 
23     /// @param _owner The address from which the balance will be retrieved
24     /// @return The balance
25     function balanceOf(address _owner) public view returns (uint256 balance);
26 
27     /// @notice send `_value` token to `_to` from `msg.sender`
28     /// @param _to The address of the recipient
29     /// @param _value The amount of token to be transferred
30     /// @return Whether the transfer was successful or not
31     function transfer(address _to, uint256 _value) public returns (bool success);
32 
33     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
34     /// @param _from The address of the sender
35     /// @param _to The address of the recipient
36     /// @param _value The amount of token to be transferred
37     /// @return Whether the transfer was successful or not
38     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
39 
40     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
41     /// @param _spender The address of the account able to transfer the tokens
42     /// @param _value The amount of tokens to be approved for transfer
43     /// @return Whether the approval was successful or not
44     function approve(address _spender, uint256 _value) public returns (bool success);
45 
46     /// @param _owner The address of the account owning tokens
47     /// @param _spender The address of the account able to transfer the tokens
48     /// @return Amount of remaining tokens allowed to spent
49     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
50 
51     // solhint-disable-next-line no-simple-event-func-name
52     event Transfer(address indexed _from, address indexed _to, uint256 _value);
53     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
54 }
55 
56 
57 
58 contract Token is EIP20Interface {
59 
60     uint256 constant private MAX_UINT256 = 2**256 - 1;
61     mapping (address => uint256) public balances;
62     mapping (address => mapping (address => uint256)) public allowed;
63     /*
64     NOTE:
65     The following variables are OPTIONAL vanities. One does not have to include them.
66     They allow one to customise the token contract & in no way influences the core functionality.
67     Some wallets/interfaces might not even bother to look at this information.
68     */
69 
70     string public name;                   //fancy name: eg Simon Bucks
71     uint8 public decimals;                //How many decimals to show.
72     string public symbol;                 //An identifier: eg SBX
73 
74     function Token(
75          address _receivingAddress,
76          uint256 _initialAmount,
77          string _tokenName,
78          string _tokenSymbol,
79          uint8 _decimalUnits
80     ) public {
81         balances[_receivingAddress] = _initialAmount;               // Give the creator all initial tokens
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
92         Transfer(msg.sender, _to, _value);
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
104         Transfer(_from, _to, _value);
105         return true;
106     }
107 
108     function balanceOf(address _owner) public view returns (uint256 balance) {
109         return balances[_owner];
110     }
111 
112     function approve(address _spender, uint256 _value) public returns (bool success) {
113         allowed[msg.sender][_spender] = _value;
114         Approval(msg.sender, _spender, _value);
115         return true;
116     }
117 
118     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
119         return allowed[_owner][_spender];
120     }
121 }