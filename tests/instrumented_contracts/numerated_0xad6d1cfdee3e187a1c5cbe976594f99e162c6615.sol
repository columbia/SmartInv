1 pragma solidity ^0.4.18;
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
41 
42 contract KriptoNeed is EIP20Interface {
43 
44     uint256 constant private MAX_UINT256 = 2**256 - 1;
45     mapping (address => uint256) public balances;
46     mapping (address => mapping (address => uint256)) public allowed;
47 
48     string public name;                   //fancy name: eg Simon Bucks
49     uint8 public decimals;                //How many decimals to show.
50     string public symbol;                 //An identifier: eg SBX
51 
52     function KriptoNeed(
53         uint256 _initialAmount,
54         string _tokenName,
55         uint8 _decimalUnits,
56         string _tokenSymbol
57     ) public {
58         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
59         totalSupply = _initialAmount;                        // Update total supply
60         name = _tokenName;                                   // Set the name for display purposes
61         decimals = _decimalUnits;                            // Amount of decimals for display purposes
62         symbol = _tokenSymbol;                               // Set the symbol for display purposes
63     }
64 
65     function transfer(address _to, uint256 _value) public returns (bool success) {
66         require(balances[msg.sender] >= _value);
67         balances[msg.sender] -= _value;
68         balances[_to] += _value;
69         Transfer(msg.sender, _to, _value);
70         return true;
71     }
72 
73     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
74         uint256 allowance = allowed[_from][msg.sender];
75         require(balances[_from] >= _value && allowance >= _value);
76         balances[_to] += _value;
77         balances[_from] -= _value;
78         if (allowance < MAX_UINT256) {
79             allowed[_from][msg.sender] -= _value;
80         }
81         Transfer(_from, _to, _value);
82         return true;
83     }
84 
85     function balanceOf(address _owner) public view returns (uint256 balance) {
86         return balances[_owner];
87     }
88 
89     function approve(address _spender, uint256 _value) public returns (bool success) {
90         allowed[msg.sender][_spender] = _value;
91         Approval(msg.sender, _spender, _value);
92         return true;
93     }
94 
95     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
96         return allowed[_owner][_spender];
97     }   
98 }