1 pragma solidity 0.4.20;
2 /**
3 * @notice TOKEN CONTRACT
4 * @dev ERC-20 Token Standard Compliant
5 * @author Fares A. Akel C. f.antonio.akel@gmail.com
6 */
7 
8 /**
9  * @title SafeMath by OpenZeppelin
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15         assert(b <= a);
16         return a - b;
17     }
18 
19     function add(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a + b;
21         assert(c >= a);
22         return c;
23     }
24 
25 }
26 
27 /**
28  * @title ERC20TokenInterface
29  * @dev Token contract interface for external use
30  */
31 contract ERC20TokenInterface {
32 
33     function balanceOf(address _owner) public constant returns (uint256 balance);
34     function transfer(address _to, uint256 _value) public returns (bool success);
35     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
36     function approve(address _spender, uint256 _value) public returns (bool success);
37     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
38 
39     }
40 
41 
42 /**
43 * @title ERC20Token
44 * @notice Token definition contract
45 */
46 contract ERC20Token is ERC20TokenInterface { //Standard definition of an ERC20Token
47     using SafeMath for uint256; //SafeMath is used for uint256 operations
48     mapping (address => uint256) balances; //A mapping of all balances per address
49     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
50     uint256 public totalSupply;
51     
52     /**
53     * @notice Get the balance of an _owner address.
54     * @param _owner The address to be query.
55     */
56     function balanceOf(address _owner) public constant returns (uint256 bal) {
57       return balances[_owner];
58     }
59 
60     /**
61     * @notice transfer _value tokens to address _to
62     * @param _to The address to transfer to.
63     * @param _value The amount to be transferred.
64     * @return success with boolean value true if done
65     */
66     function transfer(address _to, uint256 _value) public returns (bool success) {
67         require(_to != address(0)); //If you dont want that people destroy token
68         balances[msg.sender] = balances[msg.sender].sub(_value);
69         balances[_to] = balances[_to].add(_value);
70         Transfer(msg.sender, _to, _value);
71         return true;
72     }
73 
74     /**
75     * @notice Transfer _value tokens from address _from to address _to using allowance msg.sender allowance on _from
76     * @param _from The address where tokens comes.
77     * @param _to The address to transfer to.
78     * @param _value The amount to be transferred.
79     * @return success with boolean value true if done
80     */
81     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
82         require(_to != address(0)); //If you dont want that people destroy token
83         balances[_from] = balances[_from].sub(_value);
84         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
85         balances[_to] = balances[_to].add(_value);
86         Transfer(_from, _to, _value);
87         return true;
88     }
89 
90     /**
91     * @notice Assign allowance _value to _spender address to use the msg.sender balance
92     * @param _spender The address to be allowed to spend.
93     * @param _value The amount to be allowed.
94     * @return success with boolean value true
95     */
96     function approve(address _spender, uint256 _value) public returns (bool success) {
97         require((_value == 0) || (allowed[msg.sender][_spender] == 0)); //exploit mitigation
98         allowed[msg.sender][_spender] = _value;
99         Approval(msg.sender, _spender, _value);
100         return true;
101     }
102 
103     /**
104     * @notice Get the allowance of an specified address to use another address balance.
105     * @param _owner The address of the owner of the tokens.
106     * @param _spender The address of the allowed spender.
107     * @return remaining with the allowance value
108     */
109     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
110         return allowed[_owner][_spender];
111     }
112 
113     /**
114     * @dev Log Events
115     */
116     event Transfer(address indexed _from, address indexed _to, uint256 _value);
117     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
118 
119 }
120 
121 /**
122 * @title Asset
123 * @notice Token creation.
124 * @dev ERC20 Token
125 */
126 contract Asset is ERC20Token {
127     string public name;
128     uint8 public decimals;
129     string public symbol;
130     string public version = '1';
131     
132     /**
133     * @notice token constructor.
134     */
135     function Asset() public {
136 
137         name = 'Big Balls Token';
138         decimals = 18;
139         symbol = 'BBT';
140         totalSupply = 150000000 * 10 ** uint256(decimals); //Tokens initial supply;
141         balances[msg.sender] = totalSupply;
142         Transfer(0, this, totalSupply);
143         Transfer(this, msg.sender, balances[msg.sender]);
144         
145     }
146     
147     /**
148     * @notice this contract will revert on direct non-function calls
149     * @dev Function to handle callback calls
150     */
151     function() public {
152         revert();
153     }
154 
155 }