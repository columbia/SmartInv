1 pragma solidity ^ 0.4.21;
2 
3 /**
4  *   @title SafeMath
5  *   @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns(uint256) {
15         assert(b > 0);
16         uint256 c = a / b;
17         assert(a == b * c + a % b);
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns(uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 contract ERC20 {
33     function balanceOf(address _owner) public constant returns(uint256);
34     function transfer(address _to, uint256 _value) public returns(bool);
35     function transferFrom(address _from, address _to, uint256 _value) public returns(bool);
36     function approve(address _spender, uint256 _value) public returns(bool);
37     function allowance(address _owner, address _spender) public constant returns(uint256);
38     mapping(address => uint256) balances;
39     mapping(address => mapping(address => uint256)) allowed;
40     event Transfer(address indexed _from, address indexed _to, uint256 _value);
41     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
42 }
43 
44 
45 /**
46  *   @dev GEXA token contract
47  */
48 contract GexaToken is ERC20 {
49     using SafeMath for uint256;
50     string public name = "GEXA TOKEN";
51     string public symbol = "GEXA";
52     uint256 public decimals = 18;
53     uint256 public totalSupply = 0;
54     uint256 public constant MAX_TOKENS = 200000000 * 1e18;
55     
56     
57 
58 
59     address public owner;
60     event Burn(address indexed from, uint256 value);
61 
62 
63 
64     // Allows execution by the owner only
65     modifier onlyOwner {
66         require(msg.sender == owner);
67         _;
68     }
69     
70     
71     
72     constructor () public {
73         owner = msg.sender;
74     }
75     
76 
77    /**
78     *   @dev Mint tokens
79     *   @param _investor     address the tokens will be issued to
80     *   @param _value        number of tokens
81     */
82     function mintTokens(address _investor, uint256 _value) external onlyOwner {
83         uint256 decvalue = _value.mul(1 ether);
84         require(_value > 0);
85         require(totalSupply.add(decvalue) <= MAX_TOKENS);
86         balances[_investor] = balances[_investor].add(decvalue);
87         totalSupply = totalSupply.add(decvalue);
88         emit Transfer(0x0, _investor, _value);
89     }
90 
91 
92 
93    /**
94     *   @dev Burn Tokens
95     *   @param _value        number of tokens to burn
96     */
97     function burnTokens(uint256 _value) external  {
98         require(balances[msg.sender] > 0);
99         require(_value > 0);
100         balances[msg.sender] = balances[msg.sender].sub(_value);
101         totalSupply = totalSupply.sub(_value);
102         emit Burn(msg.sender, _value);
103     }
104 
105    /**
106     *   @dev Get balance of investor
107     *   @param _owner        investor's address
108     *   @return              balance of investor
109     */
110     function balanceOf(address _owner) public constant returns(uint256) {
111       return balances[_owner];
112     }
113 
114    /**
115     *   @return true if the transfer was successful
116     */
117     function transfer(address _to, uint256 _amount) public returns(bool) {
118         require(_amount > 0);
119         balances[msg.sender] = balances[msg.sender].sub(_amount);
120         balances[_to] = balances[_to].add(_amount);
121         emit Transfer(msg.sender, _to, _amount);
122         return true;
123     }
124 
125    /**
126     *   @return true if the transfer was successful
127     */
128     function transferFrom(address _from, address _to, uint256 _amount) public returns(bool) {
129         require(_amount > 0);
130         require(_amount <= allowed[_from][msg.sender]);
131         require(_amount <= balances[_from]);
132         balances[_from] = balances[_from].sub(_amount);
133         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
134         balances[_to] = balances[_to].add(_amount);
135         emit Transfer(_from, _to, _amount);
136         return true;
137     }
138 
139    /**
140     *   @dev Allows another account/contract to spend some tokens on its behalf
141     *   throws on any error rather then return a false flag to minimize user errors
142     *
143     *   also, to minimize the risk of the approve/transferFrom attack vector
144     *   approve has to be called twice in 2 separate transactions - once to
145     *   change the allowance to 0 and secondly to change it to the new allowance
146     *   value
147     *
148     *   @param _spender      approved address
149     *   @param _amount       allowance amount
150     *
151     *   @return true if the approval was successful
152     */
153     function approve(address _spender, uint256 _amount) public returns(bool) {
154         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
155         allowed[msg.sender][_spender] = _amount;
156         emit Approval(msg.sender, _spender, _amount);
157         return true;
158     }
159 
160    /**
161     *   @dev Function to check the amount of tokens that an owner allowed to a spender.
162     *
163     *   @param _owner        the address which owns the funds
164     *   @param _spender      the address which will spend the funds
165     *
166     *   @return              the amount of tokens still avaible for the spender
167     */
168     function allowance(address _owner, address _spender) public constant returns(uint256) {
169         return allowed[_owner][_spender];
170     }
171 }