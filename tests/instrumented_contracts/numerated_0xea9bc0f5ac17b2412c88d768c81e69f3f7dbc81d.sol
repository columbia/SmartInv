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
49 contract Vegetoken is EIP20Interface {
50 
51     uint256 constant private MAX_UINT256 = 2**256 - 1;
52     mapping (address => uint256) public balances;
53     mapping (address => mapping (address => uint256)) public allowed;
54     /*
55     NOTE:
56     The following variables are OPTIONAL vanities. One does not have to include them.
57     They allow one to customise the token contract & in no way influences the core functionality.
58     Some wallets/interfaces might not even bother to look at this information.
59     */
60     string public name;                   //fancy name: eg Terence Ho
61     uint8 public decimals;                //How many decimals to show.
62     string public symbol;                 //An identifier: eg THWL
63 
64     function Vegetoken(
65         uint256 _initialAmount,
66         string _tokenName,
67         uint8 _decimalUnits,
68         string _tokenSymbol
69     ) public {
70         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
71         totalSupply = _initialAmount;                        // Update total supply
72         name = _tokenName;                                   // Set the name for display purposes
73         decimals = _decimalUnits;                            // Amount of decimals for display purposes
74         symbol = _tokenSymbol;                               // Set the symbol for display purposes
75     }
76 
77     function transfer(address _to, uint256 _value) public returns (bool success) {
78         require(balances[msg.sender] >= _value);
79         balances[msg.sender] -= _value;
80         balances[_to] += _value;
81         Transfer(msg.sender, _to, _value);
82         return true;
83     }
84 
85     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
86         uint256 allowance = allowed[_from][msg.sender];
87         require(balances[_from] >= _value && allowance >= _value);
88         balances[_to] += _value;
89         balances[_from] -= _value;
90         if (allowance < MAX_UINT256) {
91             allowed[_from][msg.sender] -= _value;
92         }
93         Transfer(_from, _to, _value);
94         return true;
95     }
96 
97     function balanceOf(address _owner) public view returns (uint256 balance) {
98         return balances[_owner];
99     }
100 
101     function approve(address _spender, uint256 _value) public returns (bool success) {
102         allowed[msg.sender][_spender] = _value;
103         Approval(msg.sender, _spender, _value);
104         return true;
105     }
106 
107     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
108         return allowed[_owner][_spender];
109     }   
110 }