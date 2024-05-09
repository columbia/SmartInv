1 pragma solidity ^0.4.18;
2 
3 /* import "./EIP20Interface.sol"; */
4 
5 
6 contract TokenContainer {
7     uint256 public totalSupply;
8 
9     /// @param _owner The address from which the balance will be retrieved
10     /// @return The balance
11     function balanceOf(address _owner) public view returns (uint256 balance);
12 
13     /// @notice send `_value` token to `_to` from `msg.sender`
14     /// @param _to The address of the recipient
15     /// @param _value The amount of token to be transferred
16     /// @return Whether the transfer was successful or not
17     function transfer(address _to, uint256 _value) public returns (bool success);
18 
19     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
20     /// @param _from The address of the sender
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
25 
26     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
27     /// @param _spender The address of the account able to transfer the tokens
28     /// @param _value The amount of tokens to be approved for transfer
29     /// @return Whether the approval was successful or not
30     function approve(address _spender, uint256 _value) public returns (bool success);
31 
32     /// @param _owner The address of the account owning tokens
33     /// @param _spender The address of the account able to transfer the tokens
34     /// @return Amount of remaining tokens allowed to spent
35     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
36 
37     // solhint-disable-next-line no-simple-event-func-name  
38     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 }
41 
42 contract ShellToken is TokenContainer {
43 
44     uint256 constant private MAX_UINT256 = 2**256 - 1;
45     mapping (address => uint256) public balances;
46     mapping (address => mapping (address => uint256)) public allowed;
47     /*
48     NOTE:
49     The following variables are OPTIONAL vanities. One does not have to include them.
50     They allow one to customise the token contract & in no way influences the core functionality.
51     Some wallets/interfaces might not even bother to look at this information.
52     */
53     string public name;                   //fancy name: eg Simon Bucks
54     uint8 public decimals;                //How many decimals to show.
55     string public symbol;                 //An identifier: eg SBX
56 
57     function ShellToken(
58         uint256 _initialAmount,
59         string _tokenName,
60         uint8 _decimalUnits,
61         string _tokenSymbol
62     ) public {
63         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
64         totalSupply = _initialAmount;                        // Update total supply
65         name = _tokenName;                                   // Set the name for display purposes
66         decimals = _decimalUnits;                            // Amount of decimals for display purposes
67         symbol = _tokenSymbol;                               // Set the symbol for display purposes
68     }
69 
70     function transfer(address _to, uint256 _value) public returns (bool success) {
71         require(balances[msg.sender] >= _value);
72         balances[msg.sender] -= _value;
73         balances[_to] += _value;
74         Transfer(msg.sender, _to, _value);
75         return true;
76     }
77 
78     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
79         uint256 allowance = allowed[_from][msg.sender];
80         require(balances[_from] >= _value && allowance >= _value);
81         balances[_to] += _value;
82         balances[_from] -= _value;
83         if (allowance < MAX_UINT256) {
84             allowed[_from][msg.sender] -= _value;
85         }
86         Transfer(_from, _to, _value);
87         return true;
88     }
89 
90     function balanceOf(address _owner) public view returns (uint256 balance) {
91         return balances[_owner];
92     }
93 
94     function approve(address _spender, uint256 _value) public returns (bool success) {
95         allowed[msg.sender][_spender] = _value;
96         Approval(msg.sender, _spender, _value);
97         return true;
98     }
99 
100     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
101         return allowed[_owner][_spender];
102     }   
103 }