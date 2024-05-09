1 /*
2 Implements EIP20 token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
3 .*/
4 
5 
6 // Abstract contract for the full ERC 20 Token standard
7 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
8 pragma solidity ^0.4.21;
9 
10 
11 contract EIP20Interface {
12     /* This is a slight change to the ERC20 base standard.
13     function totalSupply() constant returns (uint256 supply);
14     is replaced with:
15     uint256 public totalSupply;
16     This automatically creates a getter function for the totalSupply.
17     This is moved to the base contract since public getter functions are not
18     currently recognised as an implementation of the matching abstract
19     function by the compiler.
20     */
21     /// total amount of tokens
22     uint256 public totalSupply;
23 
24     /// @param _owner The address from which the balance will be retrieved
25     /// @return The balance
26     function balanceOf(address _owner) public view returns (uint256 balance);
27 
28     /// @notice send `_value` token to `_to` from `msg.sender`
29     /// @param _to The address of the recipient
30     /// @param _value The amount of token to be transferred
31     /// @return Whether the transfer was successful or not
32     function transfer(address _to, uint256 _value) public returns (bool success);
33 
34     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
35     /// @param _from The address of the sender
36     /// @param _to The address of the recipient
37     /// @param _value The amount of token to be transferred
38     /// @return Whether the transfer was successful or not
39     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
40 
41     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
42     /// @param _spender The address of the account able to transfer the tokens
43     /// @param _value The amount of tokens to be approved for transfer
44     /// @return Whether the approval was successful or not
45     function approve(address _spender, uint256 _value) public returns (bool success);
46 
47     /// @param _owner The address of the account owning tokens
48     /// @param _spender The address of the account able to transfer the tokens
49     /// @return Amount of remaining tokens allowed to spent
50     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
51 
52     // solhint-disable-next-line no-simple-event-func-name
53     event Transfer(address indexed _from, address indexed _to, uint256 _value);
54     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
55 }
56 
57 
58 contract TheFtsToken is EIP20Interface {
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
69     string public name;                   //fancy name: eg Simon Bucks
70     uint8 public decimals;                //How many decimals to show.
71     string public symbol;                 //An identifier: eg SBX
72 
73     function TheFtsToken(
74         uint256 _initialAmount,
75         string _tokenName,
76         uint8 _decimalUnits,
77         string _tokenSymbol
78     ) public {
79         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
80         totalSupply = _initialAmount;                        // Update total supply
81         name = _tokenName;                                   // Set the name for display purposes
82         decimals = _decimalUnits;                            // Amount of decimals for display purposes
83         symbol = _tokenSymbol;                               // Set the symbol for display purposes
84     }
85 
86     function transfer(address _to, uint256 _value) public returns (bool success) {
87         require(balances[msg.sender] >= _value);
88         balances[msg.sender] -= _value;
89         balances[_to] += _value;
90         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
91         return true;
92     }
93 
94     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
95         uint256 allowance = allowed[_from][msg.sender];
96         require(balances[_from] >= _value && allowance >= _value);
97         balances[_to] += _value;
98         balances[_from] -= _value;
99         if (allowance < MAX_UINT256) {
100             allowed[_from][msg.sender] -= _value;
101         }
102         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
103         return true;
104     }
105 
106     function balanceOf(address _owner) public view returns (uint256 balance) {
107         return balances[_owner];
108     }
109 
110     function approve(address _spender, uint256 _value) public returns (bool success) {
111         allowed[msg.sender][_spender] = _value;
112         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
113         return true;
114     }
115 
116     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
117         return allowed[_owner][_spender];
118     }
119 }