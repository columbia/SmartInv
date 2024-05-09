1 /*
2 Implements EIP20 token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
3 .*/
4 
5 pragma solidity ^0.4.18;
6 
7 contract EIP20Interface {
8     /* This is a slight change to the ERC20 base standard.
9     function totalSupply() constant returns (uint256 supply);
10     is replaced with:
11     uint256 public totalSupply;
12     This automatically creates a getter function for the totalSupply.
13     This is moved to the base contract since public getter functions are not
14     currently recognised as an implementation of the matching abstract
15     function by the compiler.
16     */
17     /// total amount of tokens
18     uint256 public totalSupply;
19 
20     /// @param _owner The address from which the balance will be retrieved
21     /// @return The balance
22     function balanceOf(address _owner) public view returns (uint256 balance);
23 
24     /// @notice send `_value` token to `_to` from `msg.sender`
25     /// @param _to The address of the recipient
26     /// @param _value The amount of token to be transferred
27     /// @return Whether the transfer was successful or not
28     function transfer(address _to, uint256 _value) public returns (bool success);
29 
30     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
31     /// @param _from The address of the sender
32     /// @param _to The address of the recipient
33     /// @param _value The amount of token to be transferred
34     /// @return Whether the transfer was successful or not
35     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
36 
37     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
38     /// @param _spender The address of the account able to transfer the tokens
39     /// @param _value The amount of tokens to be approved for transfer
40     /// @return Whether the approval was successful or not
41     function approve(address _spender, uint256 _value) public returns (bool success);
42 
43     /// @param _owner The address of the account owning tokens
44     /// @param _spender The address of the account able to transfer the tokens
45     /// @return Amount of remaining tokens allowed to spent
46     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
47 
48     // solhint-disable-next-line no-simple-event-func-name  
49     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
50     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51 }
52 
53 contract Staro is EIP20Interface {
54 
55     uint256 constant private MAX_UINT256 = 2**256 - 1;
56     mapping (address => uint256) public balances;
57     mapping (address => mapping (address => uint256)) public allowed;
58     /*
59     NOTE:
60     The following variables are OPTIONAL vanities. One does not have to include them.
61     They allow one to customise the token contract & in no way influences the core functionality.
62     Some wallets/interfaces might not even bother to look at this information.
63     */
64     string public name;                   //fancy name: eg Roman
65     uint8 public decimals;                //How many decimals to show.
66     string public symbol;                 //An identifier: eg SBX
67 
68     function Staro(
69         uint256 _initialAmount,
70         string _tokenName,
71         uint8 _decimalUnits,
72         string _tokenSymbol
73     ) public {
74         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
75         totalSupply = _initialAmount;                        // Update total supply
76         name = _tokenName;                                   // Set the name for display purposes
77         decimals = _decimalUnits;                            // Amount of decimals for display purposes
78         symbol = _tokenSymbol;                               // Set the symbol for display purposes
79     }
80 
81     function transfer(address _to, uint256 _value) public returns (bool success) {
82         require(balances[msg.sender] >= _value);
83         balances[msg.sender] -= _value;
84         balances[_to] += _value;
85         Transfer(msg.sender, _to, _value);
86         return true;
87     }
88 
89     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
90         uint256 allowance = allowed[_from][msg.sender];
91         require(balances[_from] >= _value && allowance >= _value);
92         balances[_to] += _value;
93         balances[_from] -= _value;
94         if (allowance < MAX_UINT256) {
95             allowed[_from][msg.sender] -= _value;
96         }
97         Transfer(_from, _to, _value);
98         return true;
99     }
100 
101     function balanceOf(address _owner) public view returns (uint256 balance) {
102         return balances[_owner];
103     }
104 
105     function approve(address _spender, uint256 _value) public returns (bool success) {
106         allowed[msg.sender][_spender] = _value;
107         Approval(msg.sender, _spender, _value);
108         return true;
109     }
110 
111     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
112         return allowed[_owner][_spender];
113     }   
114 }