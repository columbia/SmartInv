1 /*
2 Implements EIP20 token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
3 .*/
4 
5 
6 pragma solidity ^0.4.21;
7 
8 // Abstract contract for the full ERC 20 Token standard
9 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
10 pragma solidity ^0.4.21;
11 
12 
13 contract EIP20Interface {
14     /* This is a slight change to the ERC20 base standard.
15     function totalSupply() constant returns (uint256 supply);
16     is replaced with:
17     uint256 public totalSupply;
18     This automatically creates a getter function for the totalSupply.
19     This is moved to the base contract since public getter functions are not
20     currently recognised as an implementation of the matching abstract
21     function by the compiler.
22     */
23     /// total amount of tokens
24     uint256 public totalSupply;
25 
26     /// @param _owner The address from which the balance will be retrieved
27     /// @return The balance
28     function balanceOf(address _owner) public view returns (uint256 balance);
29 
30     /// @notice send `_value` token to `_to` from `msg.sender`
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transfer(address _to, uint256 _value) public returns (bool success);
35 
36     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
37     /// @param _from The address of the sender
38     /// @param _to The address of the recipient
39     /// @param _value The amount of token to be transferred
40     /// @return Whether the transfer was successful or not
41     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
42 
43     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
44     /// @param _spender The address of the account able to transfer the tokens
45     /// @param _value The amount of tokens to be approved for transfer
46     /// @return Whether the approval was successful or not
47     function approve(address _spender, uint256 _value) public returns (bool success);
48 
49     /// @param _owner The address of the account owning tokens
50     /// @param _spender The address of the account able to transfer the tokens
51     /// @return Amount of remaining tokens allowed to spent
52     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
53 
54     // solhint-disable-next-line no-simple-event-func-name
55     event Transfer(address indexed _from, address indexed _to, uint256 _value);
56     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
57 }
58 
59 contract Tachyon is EIP20Interface {
60 
61     uint256 constant private MAX_UINT256 = 2**256 - 1;
62     mapping (address => uint256) public balances;
63     mapping (address => mapping (address => uint256)) public allowed;
64    
65     string public name;                   
66     uint8 public decimals;            
67     string public symbol;                 
68 
69     function Tachyon(
70         uint256 _initialAmount,
71         string _tokenName,
72         uint8 _decimalUnits,
73         string _tokenSymbol
74     ) public {
75         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
76         totalSupply = _initialAmount;                        // Update total supply
77         name = _tokenName;                                   // Set the name for display purposes
78         decimals = _decimalUnits;                            // Amount of decimals for display purposes
79         symbol = _tokenSymbol;                               // Set the symbol for display purposes
80     }
81 
82     function transfer(address _to, uint256 _value) public returns (bool success) {
83         require(balances[msg.sender] >= _value);
84         balances[msg.sender] -= _value;
85         balances[_to] += _value;
86         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
87         return true;
88     }
89 
90     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
91         uint256 allowance = allowed[_from][msg.sender];
92         require(balances[_from] >= _value && allowance >= _value);
93         balances[_to] += _value;
94         balances[_from] -= _value;
95         if (allowance < MAX_UINT256) {
96             allowed[_from][msg.sender] -= _value;
97         }
98         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
99         return true;
100     }
101 
102     function balanceOf(address _owner) public view returns (uint256 balance) {
103         return balances[_owner];
104     }
105 
106     function approve(address _spender, uint256 _value) public returns (bool success) {
107         allowed[msg.sender][_spender] = _value;
108         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
109         return true;
110     }
111 
112     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
113         return allowed[_owner][_spender];
114     }
115 }