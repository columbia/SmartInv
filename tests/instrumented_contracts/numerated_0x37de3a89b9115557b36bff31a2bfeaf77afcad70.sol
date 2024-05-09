1 pragma solidity ^0.4.18;
2 /**
3 * TOKEN Contract
4 * ERC-20 Token Standard Compliant
5 */
6 
7 /**
8  * @title SafeMath by OpenZeppelin
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14         assert(b <= a);
15         return a - b;
16     }
17 
18     function add(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a + b;
20         assert(c >= a);
21         return c;
22     }
23 
24 }
25 
26 /**
27  * Token contract interface for external use
28  */
29 contract ERC20TokenInterface {
30 
31     function balanceOf(address _owner) public view returns (uint256 balance);
32     function transfer(address _to, uint256 _value) public returns (bool success);
33     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
34     function approve(address _spender, uint256 _value) public returns (bool success);
35     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
36 
37     }
38 
39 /**
40 * @title Token definition
41 * @dev Define token paramters including ERC20 ones
42 */
43 contract ERC20Token is ERC20TokenInterface { //Standard definition of a ERC20Token
44     using SafeMath for uint256;
45     uint256 public totalSupply;
46     mapping (address => uint256) balances; //A mapping of all balances per address
47     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
48 
49     /**
50     * @dev Get the balance of an specified address.
51     * @param _owner The address to be query.
52     */
53     function balanceOf(address _owner) public view returns (uint256 balance) {
54       return balances[_owner];
55     }
56 
57     /**
58     * @dev transfer token to a specified address
59     * @param _to The address to transfer to.
60     * @param _value The amount to be transferred.
61     */
62     function transfer(address _to, uint256 _value) public returns (bool success) {
63         require(_to != address(0)); //If you dont want that people destroy token
64         balances[msg.sender] = balances[msg.sender].sub(_value);
65         balances[_to] = balances[_to].add(_value);
66         Transfer(msg.sender, _to, _value);
67         return true;
68     }
69 
70     /**
71     * @dev transfer token from an address to another specified address using allowance
72     * @param _from The address where token comes.
73     * @param _to The address to transfer to.
74     * @param _value The amount to be transferred.
75     */
76     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
77         require(_to != address(0)); //If you dont want that people destroy token
78         balances[_to] = balances[_to].add(_value);
79         balances[_from] = balances[_from].sub(_value);
80         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
81         Transfer(_from, _to, _value);
82         return true;
83     }
84 
85     /**
86     * @dev Assign allowance to an specified address to use the owner balance
87     * @param _spender The address to be allowed to spend.
88     * @param _value The amount to be allowed.
89     */
90     function approve(address _spender, uint256 _value) public returns (bool success) {
91         require(_value == 0 || allowed[msg.sender][_spender] == 0);
92         allowed[msg.sender][_spender] = _value;
93         Approval(msg.sender, _spender, _value);
94         return true;
95     }
96 
97     /**
98     * @dev Get the allowance of an specified address to use another address balance.
99     * @param _owner The address of the owner of the tokens.
100     * @param _spender The address of the allowed spender.
101     */
102     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
103         return allowed[_owner][_spender];
104     }
105 
106     /**
107     * @dev Burn token of sender address.
108     * @param _burnedAmount amount to burn including all decimals without decimal point.
109     */
110     function burnToken(uint256 _burnedAmount) public {
111         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _burnedAmount);
112         totalSupply = SafeMath.sub(totalSupply, _burnedAmount);
113         Burned(msg.sender, _burnedAmount);
114     }
115 
116     /**
117     * @dev Log Events
118     */
119     event Transfer(address indexed _from, address indexed _to, uint256 _value);
120     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
121     event Burned(address indexed _target, uint256 _value);
122 }
123 
124 /**
125 * @title Asset
126 * @dev Initial supply creation
127 */
128 contract Asset is ERC20Token {
129     string public name = 'Social Activity Token';
130     uint8 public decimals = 8;
131     string public symbol = 'SAT';
132     string public version = '1';
133 
134     function Asset() public {
135         totalSupply = 1000000000 * (10**uint256(decimals)); //1 billion initial token creation
136         balances[msg.sender] = totalSupply;
137         Transfer(0, this, totalSupply);
138         Transfer(this, msg.sender, balances[msg.sender]);
139     }
140     
141     /**
142     *@dev Function to handle callback calls
143     */
144     function() public {
145         revert();
146     }
147 
148 }