1 pragma solidity ^0.4.16;
2 /**
3 * @notice Temple3 TOKEN CONTRACT
4 * Token for the construction for future Third Temple in Jerusalem
5 * @dev ERC-20 Token Standar Compliant
6 * @author Fares A. Akel C. f.antonio.akel@gmail.com
7 */
8 
9 /**
10  * @title SafeMath by OpenZeppelin
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14 
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19 
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a / b;
28     return c;
29     }
30 
31 }
32 
33 /**
34  * @title ERC20TokenInterface
35  * @dev Token contract interface for external use
36  */
37 contract ERC20TokenInterface {
38 
39     function balanceOf(address _owner) public constant returns (uint256 balance);
40     function transfer(address _to, uint256 _value) public returns (bool success);
41     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
42     function approve(address _spender, uint256 _value) public returns (bool success);
43     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
44 
45     }
46 
47 
48 /**
49 * @title ERC20Token
50 * @notice Token definition contract
51 */
52 contract ERC20Token is ERC20TokenInterface { //Standar definition of an ERC20Token
53     using SafeMath for uint256; //SafeMath is used for uint256 operations
54     mapping (address => uint256) balances; //A mapping of all balances per address
55     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
56     uint256 public totalSupply;
57     
58     /**
59     * @notice Get the balance of an _owner address.
60     * @param _owner The address to be query.
61     */
62     function balanceOf(address _owner) public constant returns (uint256 balance) {
63       return balances[_owner];
64     }
65 
66     /**
67     * @notice transfer _value tokens to address _to
68     * @param _to The address to transfer to.
69     * @param _value The amount to be transferred.
70     * @return success with boolean value true if done
71     */
72     function transfer(address _to, uint256 _value) public returns (bool success) {
73         require(_to != address(0)); //If you dont want that people destroy token
74         require(balances[msg.sender] >= _value);
75         balances[msg.sender] = balances[msg.sender].sub(_value);
76         balances[_to] = balances[_to].add(_value);
77         Transfer(msg.sender, _to, _value);
78         return true;
79     }
80 
81     /**
82     * @notice Transfer _value tokens from address _from to address _to using allowance msg.sender allowance on _from
83     * @param _from The address where tokens comes.
84     * @param _to The address to transfer to.
85     * @param _value The amount to be transferred.
86     * @return success with boolean value true if done
87     */
88     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
89         require(_to != address(0)); //If you dont want that people destroy token
90         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
91         balances[_to] = balances[_to].add(_value);
92         balances[_from] = balances[_from].sub(_value);
93         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
94         Transfer(_from, _to, _value);
95         return true;
96     }
97 
98     /**
99     * @notice Assign allowance _value to _spender address to use the msg.sender balance
100     * @param _spender The address to be allowed to spend.
101     * @param _value The amount to be allowed.
102     * @return success with boolean value true
103     */
104     function approve(address _spender, uint256 _value) public returns (bool success) {
105       allowed[msg.sender][_spender] = _value;
106         Approval(msg.sender, _spender, _value);
107         return true;
108     }
109 
110     /**
111     * @notice Get the allowance of an specified address to use another address balance.
112     * @param _owner The address of the owner of the tokens.
113     * @param _spender The address of the allowed spender.
114     * @return remaining with the allowance value
115     */
116     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
117     return allowed[_owner][_spender];
118     }
119 
120     /**
121     * @dev Log Events
122     */
123     event Transfer(address indexed _from, address indexed _to, uint256 _value);
124     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
125 
126 }
127 
128 /**
129 * @title AssetTM3
130 * @notice Temple3 token creation.
131 * @dev TM3 is an ERC20 Token
132 */
133 contract AssetTM3 is ERC20Token {
134     string public name = 'Temple3';
135     uint256 public decimals = 18;
136     string public symbol = 'TM3';
137     string public version = '1';
138     
139     /**
140     * @notice TM3 token contructor.
141     */
142     function AssetTM3(uint256 _initialSupply) public {
143         totalSupply = _initialSupply; //Tokens initial supply;
144         balances[0xFAB6368b0F7be60c573a6562d82469B5ED9e7eE6] = totalSupply.div(1000);
145         balances[msg.sender] = totalSupply.sub(balances[0xFAB6368b0F7be60c573a6562d82469B5ED9e7eE6]);
146         Transfer(0, this, totalSupply);
147         Transfer(this, msg.sender, balances[msg.sender]);
148         Transfer(this, 0xFAB6368b0F7be60c573a6562d82469B5ED9e7eE6, balances[0xFAB6368b0F7be60c573a6562d82469B5ED9e7eE6]);        
149     }
150     
151     /**
152     * @notice this contract will revert on direct non-function calls
153     * @dev Function to handle callback calls
154     */
155     function() public {
156         revert();
157     }
158 
159 }