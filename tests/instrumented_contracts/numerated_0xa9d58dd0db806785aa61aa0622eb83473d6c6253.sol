1 pragma solidity ^0.4.21;
2 
3 
4 contract EIP20Interface {
5     /* This is a slight change to the ERC20 base standard.
6     function totalSupply() constant returns (uint256 supply);
7     is replaced with:
8     uint256 public totalSupply;
9     This automatically creates a getter function for the totalSupply.
10     This is moved to the base contract since public getter functions are not
11     currently recognised as an implementation of the matching abstract
12     function by the compiler.
13     */
14     /// total amount of tokens
15     uint256 public totalSupply;
16 
17     /// @param _owner The address from which the balance will be retrieved
18     /// @return The balance
19     function balanceOf(address _owner) public view returns (uint256 balance);
20 
21     /// @notice send `_value` token to `_to` from `msg.sender`
22     /// @param _to The address of the recipient
23     /// @param _value The amount of token to be transferred
24     /// @return Whether the transfer was successful or not
25     function transfer(address _to, uint256 _value) public returns (bool success);
26 
27     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
28     /// @param _from The address of the sender
29     /// @param _to The address of the recipient
30     /// @param _value The amount of token to be transferred
31     /// @return Whether the transfer was successful or not
32     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
33 
34     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
35     /// @param _spender The address of the account able to transfer the tokens
36     /// @param _value The amount of tokens to be approved for transfer
37     /// @return Whether the approval was successful or not
38     function approve(address _spender, uint256 _value) public returns (bool success);
39 
40     /// @param _owner The address of the account owning tokens
41     /// @param _spender The address of the account able to transfer the tokens
42     /// @return Amount of remaining tokens allowed to spent
43     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
44 
45     // solhint-disable-next-line no-simple-event-func-name
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 
51 contract ETHC is EIP20Interface {
52 
53     uint256 constant private MAX_UINT256 = 2**256 - 1;
54     mapping (address => uint256) public balances;
55     mapping (address => mapping (address => uint256)) public allowed;
56 
57     string public name;                   
58     uint8 public decimals;                
59     string public symbol;                
60 
61     function ETHC(
62         uint256 _initialAmount,
63         string _tokenName,
64         uint8 _decimalUnits,
65         string _tokenSymbol
66     ) public {
67         balances[msg.sender] = _initialAmount;          
68         totalSupply = _initialAmount;
69         name = _tokenName;
70         decimals = _decimalUnits;
71         symbol = _tokenSymbol;
72     }
73 
74     function transfer(address _to, uint256 _value) public returns (bool success) {
75         require(balances[msg.sender] >= _value);
76         balances[msg.sender] -= _value;
77         balances[_to] += _value;
78         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
79         return true;
80     }
81 
82     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
83         uint256 allowance = allowed[_from][msg.sender];
84         require(balances[_from] >= _value && allowance >= _value);
85         balances[_to] += _value;
86         balances[_from] -= _value;
87         if (allowance < MAX_UINT256) {
88             allowed[_from][msg.sender] -= _value;
89         }
90         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
91         return true;
92     }
93 
94     function balanceOf(address _owner) public view returns (uint256 balance) {
95         return balances[_owner];
96     }
97 
98     function approve(address _spender, uint256 _value) public returns (bool success) {
99         allowed[msg.sender][_spender] = _value;
100         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
101         return true;
102     }
103 
104     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
105         return allowed[_owner][_spender];
106     }
107 }