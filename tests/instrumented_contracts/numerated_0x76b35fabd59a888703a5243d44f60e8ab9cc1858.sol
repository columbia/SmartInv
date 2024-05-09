1 /*
2 
3 
4  ad88888ba                                                   88          88
5 d8"     "8b                                            ,d    88          ""   ,d
6 Y8,                                                    88    88               88
7 `Y8aaaaa,   88,dPYba,,adPYba,  ,adPPYYba, 8b,dPPYba, MM88MMM 88,dPPYba,  88 MM88MMM 8b,dPPYba, ,adPPYYba,  ,adPPYb,d8  ,adPPYba,
8   `"""""8b, 88P'   "88"    "8a ""     `Y8 88P'   "Y8   88    88P'    "8a 88   88    88P'   "Y8 ""     `Y8 a8"    `Y88 a8P_____88
9         `8b 88      88      88 ,adPPPPP88 88           88    88       d8 88   88    88         ,adPPPPP88 8b       88 8PP"""""""
10 Y8a     a8P 88      88      88 88,    ,88 88           88,   88b,   ,a8" 88   88,   88         88,    ,88 "8a,   ,d88 "8b,   ,aa
11  "Y88888P"  88      88      88 `"8bbdP"Y8 88           "Y888 8Y"Ybbd8"'  88   "Y888 88         `"8bbdP"Y8  `"YbbdP"Y8  `"Ybbd8"'
12                                                                                                            aa,    ,88
13                                                                                                             "Y8bbdP"
14 
15 */
16 
17 pragma solidity ^0.5.16;
18 
19 library SafeMath {
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         require(c >= a, "SafeMath: addition overflow");
23 
24         return c;
25     }
26     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27         return sub(a, b, "SafeMath: subtraction overflow");
28     }
29     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
30         require(b <= a, errorMessage);
31         uint256 c = a - b;
32 
33         return c;
34     }
35     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36         if (a == 0) {
37             return 0;
38         }
39 
40         uint256 c = a * b;
41         require(c / a == b, "SafeMath: multiplication overflow");
42 
43         return c;
44     }
45     function div(uint256 a, uint256 b) internal pure returns (uint256) {
46         return div(a, b, "SafeMath: division by zero");
47     }
48     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b > 0, errorMessage);
50         uint256 c = a / b;
51 
52         return c;
53     }
54     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
55         return mod(a, b, "SafeMath: modulo by zero");
56     }
57     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b != 0, errorMessage);
59         return a % b;
60     }
61 }
62 
63 contract IERC20 {
64     /* This is a slight change to the ERC20 base standard.
65     function totalSupply() constant returns (uint256 supply);
66     is replaced with:
67     uint256 public totalSupply;
68     This automatically creates a getter function for the totalSupply.
69     This is moved to the base contract since public getter functions are not
70     currently recognised as an implementation of the matching abstract
71     function by the compiler.
72     */
73     /// total amount of tokens
74       function totalSupply() external view returns (uint256);
75 
76     /// @param _owner The address from which the balance will be retrieved
77     /// @return The balance
78     function balanceOf(address _owner) external view returns (uint256 balance);
79 
80     /// @notice send `_value` token to `_to` from `msg.sender`
81     /// @param _to The address of the recipient
82     /// @param _value The amount of token to be transferred
83     /// @return Whether the transfer was successful or not
84     function transfer(address _to, uint256 _value) external returns (bool success);
85 
86     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
87     /// @param _from The address of the sender
88     /// @param _to The address of the recipient
89     /// @param _value The amount of token to be transferred
90     /// @return Whether the transfer was successful or not
91     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
92 
93     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
94     /// @param _spender The address of the account able to transfer the tokens
95     /// @param _value The amount of tokens to be approved for transfer
96     /// @return Whether the approval was successful or not
97     function approve(address _spender, uint256 _value) external returns (bool success);
98 
99     /// @param _owner The address of the account owning tokens
100     /// @param _spender The address of the account able to transfer the tokens
101     /// @return Amount of remaining tokens allowed to spent
102     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
103 
104     // solhint-disable-next-line no-simple-event-func-name
105     event Transfer(address indexed _from, address indexed _to, uint256 _value);
106     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
107 }
108 
109 contract Smartbitrage is IERC20 {
110     using SafeMath for uint256;
111 
112     uint256 constant private MAX_UINT256 = 2**256 - 1;
113     mapping (address => uint256) public balances;
114     mapping (address => mapping (address => uint256)) public allowed;
115     string public name = 'Smartbitrage';
116     uint8 public decimals = 8;
117     string public symbol = 'SMB';
118     uint256 public totalSupply = 10000000000000000;
119 
120     constructor() public {
121         balances[msg.sender] = totalSupply;
122     }
123 
124     function transfer(address _to, uint256 _value) external returns (bool success) {
125         require(balances[msg.sender] >= _value);
126         balances[msg.sender] = balances[msg.sender].sub(_value);
127         balances[_to] = balances[_to].add(_value);
128         emit Transfer(msg.sender, _to, _value);
129         return true;
130     }
131 
132     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
133         uint256 allowance = allowed[_from][msg.sender];
134         require(balances[_from] >= _value && allowance >= _value);
135         balances[_to] = balances[_to].add(_value);
136         balances[_from] = balances[_from].sub(_value);
137         if (allowance < MAX_UINT256) {
138             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
139         }
140         emit Transfer(_from, _to, _value);
141         return true;
142     }
143 
144     function balanceOf(address _owner) external view returns (uint256 balance) {
145         return balances[_owner];
146     }
147 
148     function approve(address _spender, uint256 _value) external returns (bool success) {
149         allowed[msg.sender][_spender] = _value;
150         emit Approval(msg.sender, _spender, _value);
151         return true;
152     }
153 
154     function allowance(address _owner, address _spender) external view returns (uint256 remaining) {
155         return allowed[_owner][_spender];
156     }
157 }