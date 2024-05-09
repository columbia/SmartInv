1 library SafeMath {
2   function mul(uint256 a, uint256 b) pure internal  returns (uint256) {
3     uint256 c = a * b;
4     assert(a == 0 || c / a == b);
5     return c;
6   }
7 
8   function div(uint256 a, uint256 b) pure internal  returns (uint256) {
9     // assert(b > 0); // Solidity automatically throws when dividing by 0
10     uint256 c = a / b;
11     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) pure internal  returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) pure internal  returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract Token {
28     /* This is a slight change to the ERC20 base standard.
29     function totalSupply() constant returns (uint256 supply);
30     is replaced with:
31     uint256 public totalSupply;
32     This automatically creates a getter function for the totalSupply.
33     This is moved to the base contract since public getter functions are not
34     currently recognised as an implementation of the matching abstract
35     function by the compiler.
36     */
37     /// total amount of tokens
38     uint256 public totalSupply;
39     address public sale;
40     bool public transfersAllowed;
41     
42     /// @param _owner The address from which the balance will be retrieved
43     /// @return The balance
44     function balanceOf(address _owner) constant public returns (uint256 balance);
45 
46     /// @notice send `_value` token to `_to` from `msg.sender`
47     /// @param _to The address of the recipient
48     /// @param _value The amount of token to be transferred
49     /// @return Whether the transfer was successful or not
50     function transfer(address _to, uint256 _value) public returns (bool success);
51 
52     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
53     /// @param _from The address of the sender
54     /// @param _to The address of the recipient
55     /// @param _value The amount of token to be transferred
56     /// @return Whether the transfer was successful or not
57     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
58 
59     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
60     /// @param _spender The address of the account able to transfer the tokens
61     /// @param _value The amount of tokens to be approved for transfer
62     /// @return Whether the approval was successful or not
63     function approve(address _spender, uint256 _value) public returns (bool success);
64 
65     /// @param _owner The address of the account owning tokens
66     /// @param _spender The address of the account able to transfer the tokens
67     /// @return Amount of remaining tokens allowed to spent
68     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
69 
70     event Transfer(address indexed _from, address indexed _to, uint256 _value);
71     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
72 }
73 
74 contract Disbursement {
75 
76     /*
77      *  Storage
78      */
79     address public owner;
80     address public receiver;
81     uint public disbursementPeriod;
82     uint public startDate;
83     uint public withdrawnTokens;
84     Token public token;
85 
86     /*
87      *  Modifiers
88      */
89     modifier isOwner() {
90         if (msg.sender != owner)
91             // Only owner is allowed to proceed
92             revert();
93         _;
94     }
95 
96     modifier isReceiver() {
97         if (msg.sender != receiver)
98             // Only receiver is allowed to proceed
99             revert();
100         _;
101     }
102 
103     modifier isSetUp() {
104         if (address(token) == 0)
105             // Contract is not set up
106             revert();
107         _;
108     }
109 
110     /*
111      *  Public functions
112      */
113     /// @dev Constructor function sets contract owner
114     /// @param _receiver Receiver of vested tokens
115     /// @param _disbursementPeriod Vesting period in seconds
116     /// @param _startDate Start date of disbursement period (cliff)
117     function Disbursement(address _receiver, uint _disbursementPeriod, uint _startDate)
118         public
119     {
120         if (_receiver == 0 || _disbursementPeriod == 0)
121             // Arguments are null
122             revert();
123         owner = msg.sender;
124         receiver = _receiver;
125         disbursementPeriod = _disbursementPeriod;
126         startDate = _startDate;
127         if (startDate == 0)
128             startDate = now;
129     }
130 
131     /// @dev Setup function sets external contracts' addresses
132     /// @param _token Token address
133     function setup(Token _token)
134         public
135         isOwner
136     {
137         if (address(token) != 0 || address(_token) == 0)
138             // Setup was executed already or address is null
139             revert();
140         token = _token;
141     }
142 
143     /// @dev Transfers tokens to a given address
144     /// @param _to Address of token receiver
145     /// @param _value Number of tokens to transfer
146     function withdraw(address _to, uint256 _value)
147         public
148         isReceiver
149         isSetUp
150     {
151         uint maxTokens = calcMaxWithdraw();
152         if (_value > maxTokens)
153             revert();
154         withdrawnTokens = SafeMath.add(withdrawnTokens, _value);
155         token.transfer(_to, _value);
156     }
157 
158     /// @dev Calculates the maximum amount of vested tokens
159     /// @return Number of vested tokens to withdraw
160     function calcMaxWithdraw()
161         public
162         constant
163         returns (uint)
164     {
165         uint maxTokens = SafeMath.mul(SafeMath.add(token.balanceOf(this), withdrawnTokens), SafeMath.sub(now,startDate)) / disbursementPeriod;
166         //uint maxTokens = (token.balanceOf(this) + withdrawnTokens) * (now - startDate) / disbursementPeriod;
167         if (withdrawnTokens >= maxTokens || startDate > now)
168             return 0;
169         if (SafeMath.sub(maxTokens, withdrawnTokens) > token.totalSupply())
170             return token.totalSupply();
171         return SafeMath.sub(maxTokens, withdrawnTokens);
172     }
173 }