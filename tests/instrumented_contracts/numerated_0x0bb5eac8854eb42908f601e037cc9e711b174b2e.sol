1 pragma solidity ^0.4.18;
2 contract EIP20Interface {
3     /* This is a slight change to the ERC20 base standard.
4     function totalSupply() constant returns (uint256 supply);
5     is replaced with:
6     uint256 public totalSupply;
7     This automatically creates a getter function for the totalSupply.
8     This is moved to the base contract since public getter functions are not
9     currently recognised as an implementation of the matching abstract
10     function by the compiler.
11     */
12     /// total amount of tokens
13     uint256 public totalSupply;
14 
15     /// @param _owner The address from which the balance will be retrieved
16     /// @return The balance
17     function balanceOf(address _owner) public view returns (uint256 balance);
18 
19     /// @notice send `_value` token to `_to` from `msg.sender`
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transfer(address _to, uint256 _value) public returns (bool success);
24 
25     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
26     /// @param _from The address of the sender
27     /// @param _to The address of the recipient
28     /// @param _value The amount of token to be transferred
29     /// @return Whether the transfer was successful or not
30     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
31 
32     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
33     /// @param _spender The address of the account able to transfer the tokens
34     /// @param _value The amount of tokens to be approved for transfer
35     /// @return Whether the approval was successful or not
36     function approve(address _spender, uint256 _value) public returns (bool success);
37 
38     /// @param _owner The address of the account owning tokens
39     /// @param _spender The address of the account able to transfer the tokens
40     /// @return Amount of remaining tokens allowed to spent
41     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
42 
43     // solhint-disable-next-line no-simple-event-func-name  
44     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 }
47 
48 contract BMUS is EIP20Interface {
49 
50     uint256 constant private MAX_UINT256 = 2**256 - 1;
51     mapping (address => uint256) public balances;
52     mapping (address => mapping (address => uint256)) public allowed;
53     /*
54     NOTE:
55     The following variables are OPTIONAL vanities. One does not have to include them.
56     They allow one to customise the token contract & in no way influences the core functionality.
57     Some wallets/interfaces might not even bother to look at this information.
58     */
59     string public name;                   //fancy name: eg Simon Bucks
60     uint8 public decimals;                //How many decimals to show.
61     string public symbol;                 //An identifier: eg SBX
62 
63     function BMUS(
64         uint256 _initialAmount,
65         string _tokenName,
66         uint8 _decimalUnits,
67         string _tokenSymbol
68     ) public {
69         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
70         totalSupply = _initialAmount;                        // Update total supply
71         name = _tokenName;                                   // Set the name for display purposes
72         decimals = _decimalUnits;                            // Amount of decimals for display purposes
73         symbol = _tokenSymbol;                               // Set the symbol for display purposes
74     }
75 
76     function transfer(address _to, uint256 _value) public returns (bool success) {
77         require(balances[msg.sender] >= _value);
78         balances[msg.sender] -= _value;
79         balances[_to] += _value;
80         Transfer(msg.sender, _to, _value);
81         return true;
82     }
83 
84     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
85         uint256 allowance = allowed[_from][msg.sender];
86         require(balances[_from] >= _value && allowance >= _value);
87         balances[_to] += _value;
88         balances[_from] -= _value;
89         if (allowance < MAX_UINT256) {
90             allowed[_from][msg.sender] -= _value;
91         }
92         Transfer(_from, _to, _value);
93         return true;
94     }
95 
96     function balanceOf(address _owner) public view returns (uint256 balance) {
97         return balances[_owner];
98     }
99 
100     function approve(address _spender, uint256 _value) public returns (bool success) {
101         allowed[msg.sender][_spender] = _value;
102         Approval(msg.sender, _spender, _value);
103         return true;
104     }
105 
106     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
107         return allowed[_owner][_spender];
108     } 
109   
110 }