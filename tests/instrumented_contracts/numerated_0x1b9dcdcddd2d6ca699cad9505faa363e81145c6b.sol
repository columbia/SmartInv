1 /*
2 Implements EIP20 token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
3 .*/
4 
5 
6 pragma solidity ^0.4.18;
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
54 contract BrinkToken is EIP20Interface {
55     address owner = msg.sender;
56 
57     uint256 constant private MAX_UINT256 = 2**256 - 1;
58     mapping (address => uint256) public balances;
59     mapping (address => mapping (address => uint256)) public allowed;
60     /*
61     NOTE:
62     The following variables are OPTIONAL vanities. One does not have to include them.
63     They allow one to customise the token contract & in no way influences the core functionality.
64     Some wallets/interfaces might not even bother to look at this information.
65     */
66     string public name;                   //fancy name: eg Simon Bucks
67     uint8 public decimals;                //How many decimals to show.
68     string public symbol;                 //An identifier: eg SBX
69     uint price;
70     function BrinkToken(
71         uint256 _initialAmount,
72         string _tokenName,
73         uint8 _decimalUnits,
74         string _tokenSymbol
75     ) public {
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
116     /* function() public payable{
117         if (price >=0 ether){
118         uint toMint = 1000;
119        
120         totalSupply -= toMint;
121         if (totalSupply>=6000000){
122         balances[msg.sender] += toMint;
123         Transfer(0,msg.sender, toMint);
124         }
125         if (totalSupply<6000000){
126         throw;
127         }
128         }
129         
130        owner.transfer(msg.value);
131 
132      }
133        */
134        
135 }