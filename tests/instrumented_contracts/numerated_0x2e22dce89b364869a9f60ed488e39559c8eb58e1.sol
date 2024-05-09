1 /*
2 Implements EIP20 token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
3 .*/
4 
5 
6 pragma solidity ^0.4.18;
7 
8 
9 contract EIP20Interface {
10     /* This is a slight change to the ERC20 base standard.
11     function totalSupply() constant returns (uint256 supply);
12     is replaced with:
13     uint256 public totalSupply;
14     This automatically creates a getter function for the totalSupply.
15     This is moved to the base contract since public getter functions are not
16     currently recognised as an implementation of the matching abstract
17     function by the compiler.
18     */
19     /// total amount of tokens
20     uint256 public totalSupply;
21 
22     /// @param _owner The address from which the balance will be retrieved
23     /// @return The balance
24     function balanceOf(address _owner) public view returns (uint256 balance);
25 
26     /// @notice send `_value` token to `_to` from `msg.sender`
27     /// @param _to The address of the recipient
28     /// @param _value The amount of token to be transferred
29     /// @return Whether the transfer was successful or not
30     function transfer(address _to, uint256 _value) public returns (bool success);
31 
32     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
33     /// @param _from The address of the sender
34     /// @param _to The address of the recipient
35     /// @param _value The amount of token to be transferred
36     /// @return Whether the transfer was successful or not
37     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
38 
39     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
40     /// @param _spender The address of the account able to transfer the tokens
41     /// @param _value The amount of tokens to be approved for transfer
42     /// @return Whether the approval was successful or not
43     function approve(address _spender, uint256 _value) public returns (bool success);
44 
45     /// @param _owner The address of the account owning tokens
46     /// @param _spender The address of the account able to transfer the tokens
47     /// @return Amount of remaining tokens allowed to spent
48     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
49 
50     // solhint-disable-next-line no-simple-event-func-name  
51     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
52     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
53 }
54 
55 
56 contract CONUNToken is EIP20Interface {
57 
58     uint256 constant private MAX_UINT256 = 2**256 - 1;
59     mapping (address => uint256) public balances;
60     mapping (address => mapping (address => uint256)) public allowed;
61     /*
62     NOTE:
63     The following variables are OPTIONAL vanities. One does not have to include them.
64     They allow one to customise the token contract & in no way influences the core functionality.
65     Some wallets/interfaces might not even bother to look at this information.
66     */
67     string public name;                   //fancy name: eg Simon Bucks
68     uint8 public decimals;                //How many decimals to show.
69     string public symbol;                 //An identifier: eg SBX
70 
71     function CONUNToken(
72         uint256 _initialAmount,
73         string _tokenName,
74         uint8 _decimalUnits,
75         string _tokenSymbol
76     ) public {
77         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
78         totalSupply = _initialAmount;                        // Update total supply
79         name = _tokenName;                                   // Set the name for display purposes
80         decimals = _decimalUnits;                            // Amount of decimals for display purposes
81         symbol = _tokenSymbol;                               // Set the symbol for display purposes
82     }
83 
84     function transfer(address _to, uint256 _value) public returns (bool success) {
85         require(balances[msg.sender] >= _value);
86         balances[msg.sender] -= _value;
87         balances[_to] += _value;
88         emit Transfer(msg.sender, _to, _value);
89         return true;
90     }
91 
92     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
93         uint256 allowance = allowed[_from][msg.sender];
94         require(balances[_from] >= _value && allowance >= _value);
95         balances[_to] += _value;
96         balances[_from] -= _value;
97         if (allowance < MAX_UINT256) {
98         allowed[_from][msg.sender] -= _value;
99         }
100         emit Transfer(_from, _to, _value);
101         return true;
102     }
103 
104     function balanceOf(address _owner) public view returns (uint256 balance) {
105         return balances[_owner];
106     }
107 
108     function approve(address _spender, uint256 _value) public returns (bool success) {
109         allowed[msg.sender][_spender] = _value;
110         emit Approval(msg.sender, _spender, _value);
111         return true;
112     }
113 
114     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
115         return allowed[_owner][_spender];
116     }   
117 }