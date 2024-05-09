1 contract ERC20Token {
2     uint256 public totalSupply;
3 
4     /// @param _owner The address from which the balance will be retrieved
5     /// @return The balance
6     function balanceOf(address _owner) public view returns (uint256 balance);
7 
8     /// @notice send `_value` token to `_to` from `msg.sender`
9     /// @param _to The address of the recipient
10     /// @param _value The amount of token to be transferred
11     /// @return Whether the transfer was successful or not
12     function transfer(address _to, uint256 _value) public returns (bool success);
13 
14     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
15     /// @param _from The address of the sender
16     /// @param _to The address of the recipient
17     /// @param _value The amount of token to be transferred
18     /// @return Whether the transfer was successful or not
19     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
20 
21     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
22     /// @param _spender The address of the account able to transfer the tokens
23     /// @param _value The amount of tokens to be approved for transfer
24     /// @return Whether the approval was successful or not
25     function approve(address _spender, uint256 _value) public returns (bool success);
26 
27     /// @param _owner The address of the account owning tokens
28     /// @param _spender The address of the account able to transfer the tokens
29     /// @return Amount of remaining tokens allowed to spent
30     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
31 
32     event Transfer(address indexed _from, address indexed _to, uint256 _value);
33     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 }
35 
36 library SafeMathLib {
37     //
38     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39         if (a == 0) {
40             return 0;
41         }
42         uint256 c = a * b;
43         assert(c / a == b);
44         return c;
45     }
46 
47     //
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         assert(b > 0 && a > 0);
50         // Solidity automatically throws when dividing by 0
51         uint256 c = a / b;
52         return c;
53     }
54 
55     //
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57         assert(b <= a);
58         return a - b;
59     }
60 
61     //
62     function add(uint256 a, uint256 b) internal pure returns (uint256) {
63         uint256 c = a + b;
64         assert(c >= a && c >= b);
65         return c;
66     }
67 }
68 
69 contract StandardToken is ERC20Token {
70     using SafeMathLib for uint;
71 
72     mapping(address => uint256) balances;
73     mapping(address => mapping(address => uint256)) allowed;
74 
75     //
76     event Transfer(address indexed from, address indexed to, uint256 value);
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 
79     //
80     function transfer(address _to, uint256 _value) public returns (bool success) {
81         require(_value > 0 && balances[msg.sender] >= _value);
82 
83         balances[msg.sender] = balances[msg.sender].sub(_value);
84         balances[_to] = balances[_to].add(_value);
85         Transfer(msg.sender, _to, _value);
86         return true;
87     }
88 
89     //
90     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
91         require(_value > 0 && balances[_from] >= _value);
92         require(allowed[_from][msg.sender] >= _value);
93 
94         balances[_to] = balances[_to].add(_value);
95         balances[_from] = balances[_from].sub(_value);
96         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
97         Transfer(_from, _to, _value);
98         return true;
99     }
100 
101     //
102     function balanceOf(address _owner) public constant returns (uint256 balance) {
103         return balances[_owner];
104     }
105 
106     function approve(address _spender, uint256 _value) public returns (bool success) {
107         allowed[msg.sender][_spender] = _value;
108         Approval(msg.sender, _spender, _value);
109         return true;
110     }
111 
112     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
113         return allowed[_owner][_spender];
114     }
115 }
116 
117 contract IRobo is StandardToken {
118     using SafeMathLib for uint256;
119 
120     string public name = "IRobo Chain";
121     string public symbol = "IRB";
122     uint256 public decimals = 18;
123     uint256 public INITIAL_SUPPLY = (21) * (10 ** 8) * (10 ** 18);//21
124 
125     function IRobo(){
126         totalSupply = INITIAL_SUPPLY;
127         balances[msg.sender] = totalSupply;
128 
129     }
130 
131 }