1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     require(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     require(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     require(c >= a);
28     return c;
29   }
30 }
31 
32 contract EIP20Interface {
33     /* This is a slight change to the ERC20 base standard.
34     function totalSupply() constant returns (uint256 supply);
35     is replaced with:
36     uint256 public totalSupply;
37     This automatically creates a getter function for the totalSupply.
38     This is moved to the base contract since public getter functions are not
39     currently recognised as an implementation of the matching abstract
40     function by the compiler.
41     */
42     /// total amount of tokens
43     uint256 public totalSupply;
44 
45     /// @param _owner The address from which the balance will be retrieved
46     /// @return The balance
47     function balanceOf(address _owner) public view returns (uint256 balance);
48 
49     /// @notice send `_value` token to `_to` from `msg.sender`
50     /// @param _to The address of the recipient
51     /// @param _value The amount of token to be transferred
52     /// @return Whether the transfer was successful or not
53     function transfer(address _to, uint256 _value) public returns (bool success);
54 
55     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
56     /// @param _from The address of the sender
57     /// @param _to The address of the recipient
58     /// @param _value The amount of token to be transferred
59     /// @return Whether the transfer was successful or not
60     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
61 
62     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
63     /// @param _spender The address of the account able to transfer the tokens
64     /// @param _value The amount of tokens to be approved for transfer
65     /// @return Whether the approval was successful or not
66     function approve(address _spender, uint256 _value) public returns (bool success);
67 
68     /// @param _owner The address of the account owning tokens
69     /// @param _spender The address of the account able to transfer the tokens
70     /// @return Amount of remaining tokens allowed to spent
71     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
72 
73     // solhint-disable-next-line no-simple-event-func-name  
74     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
75     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
76 }
77 
78 contract KismetPanda is EIP20Interface {
79     
80     using SafeMath for uint256;
81 
82     uint256 constant private MAX_UINT256 = 2**256 - 1;
83     mapping (address => uint256) public balances;
84     mapping (address => mapping (address => uint256)) public allowed;
85     /*
86     NOTE:
87     The following variables are OPTIONAL vanities. One does not have to include them.
88     They allow one to customise the token contract & in no way influences the core functionality.
89     Some wallets/interfaces might not even bother to look at this information.
90     */
91     string public name;                   //fancy name: eg Simon Bucks
92     uint8 public decimals;                //How many decimals to show.
93     string public symbol;                 //An identifier: eg SBX
94 
95     function KismetPanda(
96         uint256 _initialAmount,
97         string _tokenName,
98         uint8 _decimalUnits,
99         string _tokenSymbol
100     ) public {
101         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
102         totalSupply = _initialAmount;                        // Update total supply
103         name = _tokenName;                                   // Set the name for display purposes
104         decimals = _decimalUnits;                            // Amount of decimals for display purposes
105         symbol = _tokenSymbol;                               // Set the symbol for display purposes
106     }
107 
108     function transfer(address _to, uint256 _value) public returns (bool success) {
109         require(balances[msg.sender] >= _value);
110         balances[msg.sender] -= _value;
111         balances[_to] += _value;
112         Transfer(msg.sender, _to, _value);
113         return true;
114     }
115 
116     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
117         uint256 allowance = allowed[_from][msg.sender];
118         require(balances[_from] >= _value && allowance >= _value);
119         balances[_to] += _value;
120         balances[_from] -= _value;
121         if (allowance < MAX_UINT256) {
122             allowed[_from][msg.sender] -= _value;
123         }
124         Transfer(_from, _to, _value);
125         return true;
126     }
127 
128     function balanceOf(address _owner) public view returns (uint256 balance) {
129         return balances[_owner];
130     }
131 
132     function approve(address _spender, uint256 _value) public returns (bool success) {
133         allowed[msg.sender][_spender] = _value;
134         Approval(msg.sender, _spender, _value);
135         return true;
136     }
137 
138     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
139         return allowed[_owner][_spender];
140     }   
141 }