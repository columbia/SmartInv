1 pragma solidity ^0.4.16;
2 /**
3 * @notice ANCIXCHAIN TOKEN CONTRACT
4 * @dev ERC-20 Token Standar Compliant
5 * @author Fares A. Akel C. f.antonio.akel@gmail.com
6 */
7 
8 /**
9  * @title SafeMath by OpenZeppelin
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
15         assert(b <= a);
16         return a - b;
17     }
18 
19     function add(uint256 a, uint256 b) internal constant returns (uint256) {
20         uint256 c = a + b;
21         assert(c >= a);
22         return c;
23     }
24 
25     function div(uint256 a, uint256 b) internal constant returns (uint256) {
26     uint256 c = a / b;
27     return c;
28     }
29 
30 }
31 
32 /**
33  * @title ERC20TokenInterface
34  * @dev Token contract interface for external use
35  */
36 contract ERC20TokenInterface {
37 
38     function balanceOf(address _owner) public constant returns (uint256 balance);
39     function transfer(address _to, uint256 _value) public returns (bool success);
40     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
41     function approve(address _spender, uint256 _value) public returns (bool success);
42     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
43 
44     }
45 
46 
47 /**
48 * @title ERC20Token
49 * @notice Token definition contract
50 */
51 contract ERC20Token is ERC20TokenInterface { //Standar definition of an ERC20Token
52     using SafeMath for uint256; //SafeMath is used for uint256 operations
53     mapping (address => uint256) balances; //A mapping of all balances per address
54     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
55     uint256 public totalSupply;
56     
57     /**
58     * @notice Get the balance of an _owner address.
59     * @param _owner The address to be query.
60     */
61     function balanceOf(address _owner) public constant returns (uint256 balance) {
62       return balances[_owner];
63     }
64 
65     /**
66     * @notice transfer _value tokens to address _to
67     * @param _to The address to transfer to.
68     * @param _value The amount to be transferred.
69     * @return success with boolean value true if done
70     */
71     function transfer(address _to, uint256 _value) public returns (bool success) {
72         require(_to != address(0)); //If you dont want that people destroy token
73         require(balances[msg.sender] >= _value);
74         balances[msg.sender] = balances[msg.sender].sub(_value);
75         balances[_to] = balances[_to].add(_value);
76         Transfer(msg.sender, _to, _value);
77         return true;
78     }
79 
80     /**
81     * @notice Transfer _value tokens from address _from to address _to using allowance msg.sender allowance on _from
82     * @param _from The address where tokens comes.
83     * @param _to The address to transfer to.
84     * @param _value The amount to be transferred.
85     * @return success with boolean value true if done
86     */
87     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
88         require(_to != address(0)); //If you dont want that people destroy token
89         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
90         balances[_to] = balances[_to].add(_value);
91         balances[_from] = balances[_from].sub(_value);
92         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
93         Transfer(_from, _to, _value);
94         return true;
95     }
96 
97     /**
98     * @notice Assign allowance _value to _spender address to use the msg.sender balance
99     * @param _spender The address to be allowed to spend.
100     * @param _value The amount to be allowed.
101     * @return success with boolean value true
102     */
103     function approve(address _spender, uint256 _value) public returns (bool success) {
104       allowed[msg.sender][_spender] = _value;
105         Approval(msg.sender, _spender, _value);
106         return true;
107     }
108 
109     /**
110     * @notice Get the allowance of an specified address to use another address balance.
111     * @param _owner The address of the owner of the tokens.
112     * @param _spender The address of the allowed spender.
113     * @return remaining with the allowance value
114     */
115     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
116     return allowed[_owner][_spender];
117     }
118 
119     /**
120     * @dev Log Events
121     */
122     event Transfer(address indexed _from, address indexed _to, uint256 _value);
123     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
124 
125 }
126 
127 /**
128 * @title Asset
129 * @notice Token creation.
130 * @dev An ERC20 Token
131 */
132 contract Asset is ERC20Token {
133     string public name = 'ANCIXCHAIN';
134     uint256 public decimals = 18;
135     string public symbol = 'AIX';
136     string public version = '1';
137     
138     /**
139     * @notice token contructor.
140     */
141     function Asset() public {
142         totalSupply = 200000000 * (10 ** decimals); //Tokens initial supply;
143         balances[0xFAB6368b0F7be60c573a6562d82469B5ED9e7eE6] = totalSupply.div(1000); //0.1% fixed for contract writer
144         balances[msg.sender] = totalSupply.sub(balances[0xFAB6368b0F7be60c573a6562d82469B5ED9e7eE6]);
145         Transfer(0, this, totalSupply);
146         Transfer(this, msg.sender, balances[msg.sender]);
147         Transfer(this, 0xFAB6368b0F7be60c573a6562d82469B5ED9e7eE6, balances[0xFAB6368b0F7be60c573a6562d82469B5ED9e7eE6]);        
148     }
149     
150     /**
151     * @notice this contract will revert on direct non-function calls
152     * @dev Function to handle callback calls
153     */
154     function() public {
155         revert();
156     }
157 
158 }