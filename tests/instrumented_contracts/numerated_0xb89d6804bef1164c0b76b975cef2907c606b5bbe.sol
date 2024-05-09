1 /*
2 Implements EIP20 token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
3 .*/
4 
5 
6 pragma solidity ^0.4.21;
7 
8 contract EIP20Interface {
9     /* This is a slight change to the ERC20 base standard.
10     function totalSupply() constant returns (uint256 supply);
11     is replaced with:
12     uint256 public totalSupply;
13     This automatically creates a getter function for the totalSupply.
14     This is moved to the base contract since public getter functions are not
15     currently recognised as an implementation of the matching abstract
16     function by the compiler.
17     */
18     /// total amount of tokens
19     uint256 public totalSupply;
20 
21     /// @param _owner The address from which the balance will be retrieved
22     /// @return The balance
23     function balanceOf(address _owner) public view returns (uint256 balance);
24 
25     /// @notice send `_value` token to `_to` from `msg.sender`
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transfer(address _to, uint256 _value) public returns (bool success);
30 
31     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
32     /// @param _from The address of the sender
33     /// @param _to The address of the recipient
34     /// @param _value The amount of token to be transferred
35     /// @return Whether the transfer was successful or not
36     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
37 
38     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
39     /// @param _spender The address of the account able to transfer the tokens
40     /// @param _value The amount of tokens to be approved for transfer
41     /// @return Whether the approval was successful or not
42     function approve(address _spender, uint256 _value) public returns (bool success);
43 
44     /// @param _owner The address of the account owning tokens
45     /// @param _spender The address of the account able to transfer the tokens
46     /// @return Amount of remaining tokens allowed to spent
47     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
48 
49     // solhint-disable-next-line no-simple-event-func-name
50     event Transfer(address indexed _from, address indexed _to, uint256 _value);
51     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
52 }
53 
54 
55 contract ControlledChaosCoin is EIP20Interface {
56 
57     uint256 constant private MAX_UINT256 = 2**256 - 1;
58     mapping (address => uint256) public balances;
59     mapping (address => mapping (address => uint256)) public allowed;
60 
61     string public name;
62     uint8 public decimals;
63     string public symbol;
64 
65     function ControlledChaosCoin(
66         uint256 _initialAmount,
67         string _tokenName,
68         uint8 _decimalUnits,
69         string _tokenSymbol
70     ) public {
71         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
72         totalSupply = _initialAmount;                        // Update total supply
73         name = _tokenName;                                   // Set the name for display purposes
74         decimals = _decimalUnits;                            // Amount of decimals for display purposes
75         symbol = _tokenSymbol;                               // Set the symbol for display purposes
76     }
77 
78     function transfer(address _to, uint256 _value) public returns (bool success) {
79         require(balances[msg.sender] >= _value);
80         balances[msg.sender] -= _value;
81         balances[_to] += _value;
82         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
83         return true;
84     }
85 
86     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
87         uint256 allowance = allowed[_from][msg.sender];
88         require(balances[_from] >= _value && allowance >= _value);
89         balances[_to] += _value;
90         balances[_from] -= _value;
91         if (allowance < MAX_UINT256) {
92             allowed[_from][msg.sender] -= _value;
93         }
94         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
95         return true;
96     }
97 
98     function balanceOf(address _owner) public view returns (uint256 balance) {
99         return balances[_owner];
100     }
101 
102     function approve(address _spender, uint256 _value) public returns (bool success) {
103         allowed[msg.sender][_spender] = _value;
104         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
105         return true;
106     }
107 
108     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
109         return allowed[_owner][_spender];
110     }
111 }