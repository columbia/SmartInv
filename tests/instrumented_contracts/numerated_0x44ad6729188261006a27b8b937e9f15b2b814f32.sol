1 pragma solidity ^0.4.18;
2 
3 contract TokenContainer {
4     uint256 public totalSupply;
5 
6     /// @param _owner The address from which the balance will be retrieved
7     /// @return The balance
8     function balanceOf(address _owner) public view returns (uint256 balance);
9 
10     /// @notice send `_value` token to `_to` from `msg.sender`
11     /// @param _to The address of the recipient
12     /// @param _value The amount of token to be transferred
13     /// @return Whether the transfer was successful or not
14     function transfer(address _to, uint256 _value) public returns (bool success);
15 
16     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
17     /// @param _from The address of the sender
18     /// @param _to The address of the recipient
19     /// @param _value The amount of token to be transferred
20     /// @return Whether the transfer was successful or not
21     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
22 
23     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
24     /// @param _spender The address of the account able to transfer the tokens
25     /// @param _value The amount of tokens to be approved for transfer
26     /// @return Whether the approval was successful or not
27     function approve(address _spender, uint256 _value) public returns (bool success);
28 
29     /// @param _owner The address of the account owning tokens
30     /// @param _spender The address of the account able to transfer the tokens
31     /// @return Amount of remaining tokens allowed to spent
32     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
33 
34     // solhint-disable-next-line no-simple-event-func-name  
35     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37 }
38 
39 contract Stockfinex is TokenContainer {
40 
41     uint256 constant private MAX_UINT256 = 2**256 - 1;
42     mapping (address => uint256) public balances;
43     mapping (address => mapping (address => uint256)) public allowed;
44     /*
45     NOTE:
46     The following variables are OPTIONAL vanities. One does not have to include them.
47     They allow one to customise the token contract & in no way influences the core functionality.
48     Some wallets/interfaces might not even bother to look at this information.
49     */
50     string public name;                   //fancy name: eg Simon Bucks
51     uint8 public decimals;                //How many decimals to show.
52     string public symbol;                 //An identifier: eg SBX
53 
54     function Stockfinex(
55         uint256 _initialAmount,
56         string _tokenName,
57         uint8 _decimalUnits,
58         string _tokenSymbol
59     ) public {
60         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
61         totalSupply = _initialAmount;                        // Update total supply
62         name = _tokenName;                                   // Set the name for display purposes
63         decimals = _decimalUnits;                            // Amount of decimals for display purposes
64         symbol = _tokenSymbol;                               // Set the symbol for display purposes
65     }
66 
67     function transfer(address _to, uint256 _value) public returns (bool success) {
68         require(balances[msg.sender] >= _value);
69         balances[msg.sender] -= _value;
70         balances[_to] += _value;
71         Transfer(msg.sender, _to, _value);
72         return true;
73     }
74 
75     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
76         uint256 allowance = allowed[_from][msg.sender];
77         require(balances[_from] >= _value && allowance >= _value);
78         balances[_to] += _value;
79         balances[_from] -= _value;
80         if (allowance < MAX_UINT256) {
81             allowed[_from][msg.sender] -= _value;
82         }
83         Transfer(_from, _to, _value);
84         return true;
85     }
86 
87     function balanceOf(address _owner) public view returns (uint256 balance) {
88         return balances[_owner];
89     }
90 
91     function approve(address _spender, uint256 _value) public returns (bool success) {
92         allowed[msg.sender][_spender] = _value;
93         Approval(msg.sender, _spender, _value);
94         return true;
95     }
96 
97     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
98         return allowed[_owner][_spender];
99     }   
100 }