1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
3 pragma solidity ^0.4.21;
4 
5 
6 contract EIP20Interface {
7 /* This is a slight change to the ERC20 base standard.
8 function totalSupply() constant returns (uint256 supply);
9 is replaced with:
10 uint256 public totalSupply;
11 This automatically creates a getter function for the totalSupply.
12 This is moved to the base contract since public getter functions are not
13 currently recognised as an implementation of the matching abstract
14 function by the compiler.
15 */
16 /// total amount of tokens
17 uint256 public totalSupply;
18 
19 /// @param _owner The address from which the balance will be retrieved
20 /// @return The balance
21 function balanceOf(address _owner) public view returns (uint256 balance);
22 
23 /// @notice send `_value` token to `_to` from `msg.sender`
24 /// @param _to The address of the recipient
25 /// @param _value The amount of token to be transferred
26 /// @return Whether the transfer was successful or not
27 function transfer(address _to, uint256 _value) public returns (bool success);
28 
29 /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
30 /// @param _from The address of the sender
31 /// @param _to The address of the recipient
32 /// @param _value The amount of token to be transferred
33 /// @return Whether the transfer was successful or not
34 function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
35 
36 /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
37 /// @param _spender The address of the account able to transfer the tokens
38 /// @param _value The amount of tokens to be approved for transfer
39 /// @return Whether the approval was successful or not
40 function approve(address _spender, uint256 _value) public returns (bool success);
41 
42 /// @param _owner The address of the account owning tokens
43 /// @param _spender The address of the account able to transfer the tokens
44 /// @return Amount of remaining tokens allowed to spent
45 function allowance(address _owner, address _spender) public view returns (uint256 remaining);
46 
47 // solhint-disable-next-line no-simple-event-func-name
48 event Transfer(address indexed _from, address indexed _to, uint256 _value);
49 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
50 }
51 
52 
53 
54 /*
55 Implements EIP20 token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
56 .*/
57 
58 
59 pragma solidity ^0.4.21;
60 
61 contract VisualFodderCoin is EIP20Interface {
62 
63     uint256 constant private MAX_UINT256 = 2**256 - 1;
64     mapping (address => uint256) public balances;
65     mapping (address => mapping (address => uint256)) public allowed;
66     /*
67     NOTE:
68     The following variables are OPTIONAL vanities. One does not have to include them.
69     They allow one to customise the token contract & in no way influences the core functionality.
70     Some wallets/interfaces might not even bother to look at this information.
71     */
72     string public name;                   //fancy name: eg Simon Bucks
73     uint8 public decimals;                //How many decimals to show.
74     string public symbol;                 //An identifier: eg SBX
75 
76     function VisualFodderCoin(
77         uint256 _initialAmount,
78         string _tokenName,
79         uint8 _decimalUnits,
80         string _tokenSymbol
81     ) public {
82         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
83         totalSupply = _initialAmount;                        // Update total supply
84         name = _tokenName;                                   // Set the name for display purposes
85         decimals = _decimalUnits;                            // Amount of decimals for display purposes
86         symbol = _tokenSymbol;                               // Set the symbol for display purposes
87     }
88 
89     function transfer(address _to, uint256 _value) public returns (bool success) {
90         require(balances[msg.sender] >= _value);
91         balances[msg.sender] -= _value;
92         balances[_to] += _value;
93         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
94         return true;
95     }
96 
97     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
98         uint256 allowance = allowed[_from][msg.sender];
99         require(balances[_from] >= _value && allowance >= _value);
100         balances[_to] += _value;
101         balances[_from] -= _value;
102         if (allowance < MAX_UINT256) {
103             allowed[_from][msg.sender] -= _value;
104         }
105         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
106         return true;
107     }
108 
109     function balanceOf(address _owner) public view returns (uint256 balance) {
110         return balances[_owner];
111     }
112 
113     function approve(address _spender, uint256 _value) public returns (bool success) {
114         allowed[msg.sender][_spender] = _value;
115         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
116         return true;
117     }
118 
119     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
120         return allowed[_owner][_spender];
121     }
122 }