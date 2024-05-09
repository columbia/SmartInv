1 pragma solidity ^0.4.21;
2 
3 contract EIP20Interface {
4     /* This is a slight change to the ERC20 base standard.
5     function totalSupply() constant returns (uint256 supply);
6     is replaced with:
7     uint256 public totalSupply;
8     This automatically creates a getter function for the totalSupply.
9     This is moved to the base contract since public getter functions are not
10     currently recognised as an implementation of the matching abstract
11     function by the compiler.
12     */
13     /// total amount of tokens
14     uint256 public totalSupply;
15 
16     /// @param _owner The address from which the balance will be retrieved
17     /// @return The balance
18     function balanceOf(address _owner) public view returns (uint256 balance);
19 
20     /// @notice send `_value` token to `_to` from `msg.sender`
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transfer(address _to, uint256 _value) public returns (bool success);
25 
26     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
27     /// @param _from The address of the sender
28     /// @param _to The address of the recipient
29     /// @param _value The amount of token to be transferred
30     /// @return Whether the transfer was successful or not
31     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
32 
33     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
34     /// @param _spender The address of the account able to transfer the tokens
35     /// @param _value The amount of tokens to be approved for transfer
36     /// @return Whether the approval was successful or not
37     function approve(address _spender, uint256 _value) public returns (bool success);
38 
39     /// @param _owner The address of the account owning tokens
40     /// @param _spender The address of the account able to transfer the tokens
41     /// @return Amount of remaining tokens allowed to spent
42     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
43 
44     // solhint-disable-next-line no-simple-event-func-name
45     event Transfer(address indexed _from, address indexed _to, uint256 _value);
46     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
47 }
48 
49 
50 contract TokenAire is EIP20Interface {
51 
52     uint256 constant private MAX_UINT256 = 2**256 - 1;
53     mapping (address => uint256) public balances;
54     mapping (address => mapping (address => uint256)) public allowed;
55     address public owner;
56     string public name;
57     uint8 public decimals;
58     string public symbol;
59     uint price = 0.0003000300030003 ether;
60 
61     function TokenAire(
62       uint256 _initialAmount,
63       string _tokenName,                                  // Set the name for display purposes
64       uint8 _decimalUnits,                            // Amount of decimals for display purposes
65       string _tokenSymbol
66       ) public {
67         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
68         totalSupply = _initialAmount;                        // Update total supply
69         name = _tokenName;                                   // Set the name for display purposes
70         decimals = _decimalUnits;                            // Amount of decimals for display purposes
71         symbol = _tokenSymbol;                               // Set the symbol for display purposes
72         owner = msg.sender;
73       }
74 
75 
76     function transfer(address _to, uint256 _value) public returns (bool success) {
77         require(balances[msg.sender] >= _value);
78         balances[msg.sender] -= _value;
79         balances[_to] += _value;
80         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
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
102         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
103         return true;
104     }
105 
106     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
107         return allowed[_owner][_spender];
108     }
109     function() public payable{
110       uint toMint = msg.value/price;
111       totalSupply += toMint;
112       balances[msg.sender]+=toMint;
113       Transfer(0, msg.sender, toMint);
114       owner.transfer(msg.value);
115 
116     }
117 
118   }