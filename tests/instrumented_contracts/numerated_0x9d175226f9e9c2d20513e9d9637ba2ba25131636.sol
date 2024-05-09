1 contract Disbursement {
2 
3     /*
4      *  Storage
5      */
6     address public owner;
7     address public receiver;
8     uint public disbursementPeriod;
9     uint public startDate;
10     uint public withdrawnTokens;
11     Token public token;
12 
13     /*
14      *  Modifiers
15      */
16     modifier isOwner() {
17         if (msg.sender != owner)
18             // Only owner is allowed to proceed
19             revert();
20         _;
21     }
22 
23     modifier isReceiver() {
24         if (msg.sender != receiver)
25             // Only receiver is allowed to proceed
26             revert();
27         _;
28     }
29 
30     modifier isSetUp() {
31         if (address(token) == 0)
32             // Contract is not set up
33             revert();
34         _;
35     }
36 
37     /*
38      *  Public functions
39      */
40     /// @dev Constructor function sets contract owner
41     /// @param _receiver Receiver of vested tokens
42     /// @param _disbursementPeriod Vesting period in seconds
43     /// @param _startDate Start date of disbursement period (cliff)
44     function Disbursement(address _receiver, uint _disbursementPeriod, uint _startDate)
45         public
46     {
47         if (_receiver == 0 || _disbursementPeriod == 0)
48             // Arguments are null
49             revert();
50         owner = msg.sender;
51         receiver = _receiver;
52         disbursementPeriod = _disbursementPeriod;
53         startDate = _startDate;
54         if (startDate == 0)
55             startDate = now;
56     }
57 
58     /// @dev Setup function sets external contracts' addresses
59     /// @param _token Token address
60     function setup(address _token)
61         public
62         isOwner
63     {
64         if (address(token) != 0 || address(_token) == 0)
65             // Setup was executed already or address is null
66             revert();
67         token = Token(_token);
68     }
69 
70     /// @dev Transfers tokens to a given address
71     /// @param _to Address of token receiver
72     /// @param _value Number of tokens to transfer
73     function withdraw(address _to, uint256 _value)
74         public
75         isReceiver
76         isSetUp
77     {
78         uint maxTokens = calcMaxWithdraw();
79         if (_value > maxTokens)
80             revert();
81         withdrawnTokens += _value;
82         token.transfer(_to, _value);
83     }
84 
85     /// @dev Calculates the maximum amount of vested tokens
86     /// @return Number of vested tokens to withdraw
87     function calcMaxWithdraw()
88         public
89         constant
90         returns (uint)
91     {
92         uint maxTokens = (token.balanceOf(this) + withdrawnTokens) * (now - startDate) / disbursementPeriod;
93         if (withdrawnTokens >= maxTokens || startDate > now)
94             return 0;
95         return maxTokens - withdrawnTokens;
96     }
97 }
98 
99 contract Token {
100     /* This is a slight change to the ERC20 base standard.
101     function totalSupply() constant returns (uint256 supply);
102     is replaced with:
103     uint256 public totalSupply;
104     This automatically creates a getter function for the totalSupply.
105     This is moved to the base contract since public getter functions are not
106     currently recognised as an implementation of the matching abstract
107     function by the compiler.
108     */
109     /// total amount of tokens
110     uint256 public totalSupply;
111 
112     /// @param _owner The address from which the balance will be retrieved
113     /// @return The balance
114     function balanceOf(address _owner) constant returns (uint256 balance);
115 
116     /// @notice send `_value` token to `_to` from `msg.sender`
117     /// @param _to The address of the recipient
118     /// @param _value The amount of token to be transferred
119     /// @return Whether the transfer was successful or not
120     function transfer(address _to, uint256 _value) returns (bool success);
121 
122     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
123     /// @param _from The address of the sender
124     /// @param _to The address of the recipient
125     /// @param _value The amount of token to be transferred
126     /// @return Whether the transfer was successful or not
127     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
128 
129     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
130     /// @param _spender The address of the account able to transfer the tokens
131     /// @param _value The amount of tokens to be approved for transfer
132     /// @return Whether the approval was successful or not
133     function approve(address _spender, uint256 _value) returns (bool success);
134 
135     /// @param _owner The address of the account owning tokens
136     /// @param _spender The address of the account able to transfer the tokens
137     /// @return Amount of remaining tokens allowed to spent
138     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
139 
140     event Transfer(address indexed _from, address indexed _to, uint256 _value);
141     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
142 }