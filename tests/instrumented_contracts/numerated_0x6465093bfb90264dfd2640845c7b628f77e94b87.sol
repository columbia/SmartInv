1 /*
2 Implements EIP20 token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
3 .*/
4 
5 
6 // Abstract contract for the full ERC 20 Token standard
7 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
8 pragma solidity ^0.4.18;
9 
10 
11 contract EIP20Interface {
12     /* This is a slight change to the ERC20 base standard.
13     function totalSupply() constant returns (uint256 supply);
14     is replaced with:
15     uint256 public totalSupply;
16     This automatically creates a getter function for the totalSupply.
17     This is moved to the base contract since public getter functions are not
18     currently recognised as an implementation of the matching abstract
19     function by the compiler.
20     */
21     /// total amount of tokens
22     uint256 public totalSupply;
23 
24     /// @param _owner The address from which the balance will be retrieved
25     /// @return The balance
26     function balanceOf(address _owner) public view returns (uint256 balance);
27 
28     /// @notice send `_value` token to `_to` from `msg.sender`
29     /// @param _to The address of the recipient
30     /// @param _value The amount of token to be transferred
31     /// @return Whether the transfer was successful or not
32     function transfer(address _to, uint256 _value) public returns (bool success);
33 
34     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
35     /// @param _from The address of the sender
36     /// @param _to The address of the recipient
37     /// @param _value The amount of token to be transferred
38     /// @return Whether the transfer was successful or not
39     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
40 
41     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
42     /// @param _spender The address of the account able to transfer the tokens
43     /// @param _value The amount of tokens to be approved for transfer
44     /// @return Whether the approval was successful or not
45     function approve(address _spender, uint256 _value) public returns (bool success);
46 
47     /// @param _owner The address of the account owning tokens
48     /// @param _spender The address of the account able to transfer the tokens
49     /// @return Amount of remaining tokens allowed to spent
50     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
51 
52     // solhint-disable-next-line no-simple-event-func-name  
53     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
54     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
55 }
56 
57 
58 
59 contract EIP20 is EIP20Interface {
60 
61     uint256 constant private MAX_UINT256 = 2**256 - 1;
62     mapping (address => uint256) public balances;
63     mapping (address => mapping (address => uint256)) public allowed;
64     /*
65     NOTE:
66     The following variables are OPTIONAL vanities. One does not have to include them.
67     They allow one to customise the token contract & in no way influences the core functionality.
68     Some wallets/interfaces might not even bother to look at this information.
69     */
70     string public name;                   //fancy name: eg Simon Bucks
71     uint8 public decimals;                //How many decimals to show.
72     string public symbol;                 //An identifier: eg SBX
73 
74     function EIP20(uint256 _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) public 
75     {
76         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
77         totalSupply = _initialAmount;                        // Update total supply
78         name = _tokenName;                                   // Set the name for display purposes
79         decimals = _decimalUnits;                            // Amount of decimals for display purposes
80         symbol = _tokenSymbol;                               // Set the symbol for display purposes
81     }
82 
83     function transfer(address _to, uint256 _value) public returns (bool success) {
84         require(balances[msg.sender] >= _value);
85         balances[msg.sender] -= _value;
86         balances[_to] += _value;
87         Transfer(msg.sender, _to, _value);
88         return true;
89     }
90 
91     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
92         uint256 allowance = allowed[_from][msg.sender];
93         require(balances[_from] >= _value && allowance >= _value);
94         balances[_to] += _value;
95         balances[_from] -= _value;
96         if (allowance < MAX_UINT256) {
97             allowed[_from][msg.sender] -= _value;
98         }
99         Transfer(_from, _to, _value);
100         return true;
101     }
102 
103     function balanceOf(address _owner) public view returns (uint256 balance) {
104         return balances[_owner];
105     }
106 
107     function approve(address _spender, uint256 _value) public returns (bool success) {
108         allowed[msg.sender][_spender] = _value;
109         Approval(msg.sender, _spender, _value);
110         return true;
111     }
112 
113     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
114         return allowed[_owner][_spender];
115     }   
116 }