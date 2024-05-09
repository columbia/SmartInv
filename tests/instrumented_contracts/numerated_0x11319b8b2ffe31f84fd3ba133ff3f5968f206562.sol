1 pragma solidity ^0.4.21;
2 
3 contract EIP20Interface {
4 
5     /// total amount of tokens
6     uint256 public totalSupply;
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) public view returns (uint256 balance);
11 
12     /// @notice send `_value` token to `_to` from `msg.sender`
13     /// @param _to The address of the recipient
14     /// @param _value The amount of token to be transferred
15     /// @return Whether the transfer was successful or not
16     function transfer(address _to, uint256 _value) public returns (bool success);
17 
18     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
19     /// @param _from The address of the sender
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
24 
25     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @param _value The amount of tokens to be approved for transfer
28     /// @return Whether the approval was successful or not
29     function approve(address _spender, uint256 _value) public returns (bool success);
30 
31     /// @param _owner The address of the account owning tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @return Amount of remaining tokens allowed to spent
34     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
35 
36     // solhint-disable-next-line no-simple-event-func-name
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 }
40 
41 contract CorporateNews is EIP20Interface {
42 
43     uint256 constant private MAX_UINT256 = 2**256 - 1;
44     mapping (address => uint256) public balances;
45     mapping (address => mapping (address => uint256)) public allowed;
46 
47     string public name;                   //fancy name: eg Simon Bucks
48     uint8 public decimals;                //How many decimals to show.
49     string public symbol;                 //An identifier: eg SBX
50 
51     function CorporateNews(
52         uint256 _initialAmount,
53         string _tokenName,
54         uint8 _decimalUnits,
55         string _tokenSymbol
56     ) public {
57         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
58         totalSupply = _initialAmount;                        // Update total supply
59         name = _tokenName;                                   // Set the name for display purposes
60         decimals = _decimalUnits;                            // Amount of decimals for display purposes
61         symbol = _tokenSymbol;                               // Set the symbol for display purposes
62     }
63 
64     function transfer(address _to, uint256 _value) public returns (bool success) {
65         require(balances[msg.sender] >= _value);
66         balances[msg.sender] -= _value;
67         balances[_to] += _value;
68         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
69         return true;
70     }
71 
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
73         uint256 allowance = allowed[_from][msg.sender];
74         require(balances[_from] >= _value && allowance >= _value);
75         balances[_to] += _value;
76         balances[_from] -= _value;
77         if (allowance < MAX_UINT256) {
78             allowed[_from][msg.sender] -= _value;
79         }
80         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
81         return true;
82     }
83 
84     function balanceOf(address _owner) public view returns (uint256 balance) {
85         return balances[_owner];
86     }
87 
88     function approve(address _spender, uint256 _value) public returns (bool success) {
89         allowed[msg.sender][_spender] = _value;
90         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
91         return true;
92     }
93 
94     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
95         return allowed[_owner][_spender];
96     }
97 }