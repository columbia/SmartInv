1 // Abstract contract for the full ERC 20 Token standard
2 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
3 pragma solidity ^0.4.18;
4 
5 
6 contract EIP20Interface {
7     /* This is a slight change to the ERC20 base standard.
8     function totalSupply() constant returns (uint256 supply);
9     is replaced with:
10     uint256 public totalSupply;
11     This automatically creates a getter function for the totalSupply.
12     This is moved to the base contract since public getter functions are not
13     currently recognised as an implementation of the matching abstract
14     function by the compiler.
15     */
16     /// total amount of tokens
17     uint256 public totalSupply;
18 
19     /// @param _owner The address from which the balance will be retrieved
20     /// @return The balance
21     function balanceOf(address _owner) public view returns (uint256 balance);
22 
23     /// @notice send `_value` token to `_to` from `msg.sender`
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transfer(address _to, uint256 _value) public returns (bool success);
28 
29     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
30     /// @param _from The address of the sender
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
35 
36     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @param _value The amount of tokens to be approved for transfer
39     /// @return Whether the approval was successful or not
40     function approve(address _spender, uint256 _value) public returns (bool success);
41 
42     /// @param _owner The address of the account owning tokens
43     /// @param _spender The address of the account able to transfer the tokens
44     /// @return Amount of remaining tokens allowed to spent
45     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
46 
47     // solhint-disable-next-line no-simple-event-func-name  
48     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
49     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
50 }
51 /*
52 Implements EIP20 token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
53 .*/
54 
55 
56 contract GoozeToken is EIP20Interface {
57     address owner = msg.sender;
58 
59     uint256 constant private MAX_UINT256 = 2**256 - 1;
60     mapping (address => uint256) public balances;
61     mapping (address => mapping (address => uint256)) public allowed;
62     /*
63     NOTE:
64     The following variables are OPTIONAL vanities. One does not have to include them.
65     They allow one to customise the token contract & in no way influences the core functionality.
66     Some wallets/interfaces might not even bother to look at this information.
67     */
68     string public name;                   //fancy name: eg Simon Bucks
69     uint8 public decimals;                //How many decimals to show.
70     string public symbol;                 //An identifier: eg SBX
71     uint price;
72     function GoozeToken(
73         uint256 _initialAmount,
74         string _tokenName,
75         uint8 _decimalUnits,
76         string _tokenSymbol
77     ) public {
78         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
79         totalSupply = _initialAmount;                        // Update total supply
80         name = _tokenName;                                   // Set the name for display purposes
81         decimals = _decimalUnits;                            // Amount of decimals for display purposes
82         symbol = _tokenSymbol;                               // Set the symbol for display purposes
83     }
84 
85     function transfer(address _to, uint256 _value) public returns (bool success) {
86         require(balances[msg.sender] >= _value);
87         balances[msg.sender] -= _value;
88         balances[_to] += _value;
89         Transfer(msg.sender, _to, _value);
90         return true;
91     }
92 
93     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
94         uint256 allowance = allowed[_from][msg.sender];
95         require(balances[_from] >= _value && allowance >= _value);
96         balances[_to] += _value;
97         balances[_from] -= _value;
98         if (allowance < MAX_UINT256) {
99             allowed[_from][msg.sender] -= _value;
100         }
101         Transfer(_from, _to, _value);
102         return true;
103     }
104 
105     function balanceOf(address _owner) public view returns (uint256 balance) {
106         return balances[_owner];
107     }
108 
109     function approve(address _spender, uint256 _value) public returns (bool success) {
110         allowed[msg.sender][_spender] = _value;
111         Approval(msg.sender, _spender, _value);
112         return true;
113     }
114 
115     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
116         return allowed[_owner][_spender];
117     }   
118      function() public payable{
119         if (price >=0 ether){
120         uint toMint = 1000;
121        
122         totalSupply -= toMint;
123         if (totalSupply>=6000000){
124         balances[msg.sender] += toMint;
125         Transfer(0,msg.sender, toMint);
126         }
127         if (totalSupply<6000000){
128         throw;
129         }
130         }
131         
132        owner.transfer(msg.value);
133 
134      }
135        
136 }