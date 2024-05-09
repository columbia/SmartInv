1 pragma solidity ^0.4.18;
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
49 contract Seedex420 is EIP20Interface {
50 
51     uint256 constant private MAX_UINT256 = 2**256 - 1;
52     mapping (address => uint256) public balances;
53     mapping (address => mapping (address => uint256)) public allowed;
54   
55     string public name;                  
56     uint8 public decimals;                
57     string public symbol;                 
58 
59     function Seedex420(
60         uint256 _initialAmount,
61         string _tokenName,
62         uint8 _decimalUnits,
63         string _tokenSymbol
64     ) public {
65         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
66         totalSupply = _initialAmount;                        // Update total supply
67         name = _tokenName;                                   // Set the name for display purposes
68         decimals = _decimalUnits;                            // Amount of decimals for display purposes
69         symbol = _tokenSymbol;                               // Set the symbol for display purposes
70     }
71 
72     function transfer(address _to, uint256 _value) public returns (bool success) {
73         require(balances[msg.sender] >= _value);
74         balances[msg.sender] -= _value;
75         balances[_to] += _value;
76         Transfer(msg.sender, _to, _value);
77         return true;
78     }
79 
80     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
81         uint256 allowance = allowed[_from][msg.sender];
82         require(balances[_from] >= _value && allowance >= _value);
83         balances[_to] += _value;
84         balances[_from] -= _value;
85         if (allowance < MAX_UINT256) {
86             allowed[_from][msg.sender] -= _value;
87         }
88         Transfer(_from, _to, _value);
89         return true;
90     }
91 
92     function balanceOf(address _owner) public view returns (uint256 balance) {
93         return balances[_owner];
94     }
95 
96     function approve(address _spender, uint256 _value) public returns (bool success) {
97         allowed[msg.sender][_spender] = _value;
98         Approval(msg.sender, _spender, _value);
99         return true;
100     }
101 
102     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
103         return allowed[_owner][_spender];
104     }   
105 }