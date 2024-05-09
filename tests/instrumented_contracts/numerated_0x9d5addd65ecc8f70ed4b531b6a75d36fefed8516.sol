1 pragma solidity ^0.4.16;
2 /**
3 * @notice TOKEN CONTRACT
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
46 contract ERC20Token is ERC20TokenInterface { //Standar definition of an ERC20Token
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
68         require(balances[msg.sender] >= _value);
69         balances[msg.sender] = balances[msg.sender].sub(_value);
70         balances[_to] = balances[_to].add(_value);
71         Transfer(msg.sender, _to, _value);
72         return true;
73     }
74 
75     /**
76     * @notice Transfer _value tokens from address _from to address _to using allowance msg.sender allowance on _from
77     * @param _from The address where tokens comes.
78     * @param _to The address to transfer to.
79     * @param _value The amount to be transferred.
80     * @return success with boolean value true if done
81     */
82     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
83         require(_to != address(0)); //If you dont want that people destroy token
84         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
85         balances[_to] = balances[_to].add(_value);
86         balances[_from] = balances[_from].sub(_value);
87         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
88         Transfer(_from, _to, _value);
89         return true;
90     }
91 
92     /**
93     * @notice Assign allowance _value to _spender address to use the msg.sender balance
94     * @param _spender The address to be allowed to spend.
95     * @param _value The amount to be allowed.
96     * @return success with boolean value true
97     */
98     function approve(address _spender, uint256 _value) public returns (bool success) {
99       allowed[msg.sender][_spender] = _value;
100         Approval(msg.sender, _spender, _value);
101         return true;
102     }
103 
104     /**
105     * @notice Get the allowance of an specified address to use another address balance.
106     * @param _owner The address of the owner of the tokens.
107     * @param _spender The address of the allowed spender.
108     * @return remaining with the allowance value
109     */
110     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
111     return allowed[_owner][_spender];
112     }
113 
114     /**
115     * @dev Log Events
116     */
117     event Transfer(address indexed _from, address indexed _to, uint256 _value);
118     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
119 
120 }
121 
122 /**
123 * @title Asset
124 * @notice Token creation.
125 * @dev ERC20 Token
126 */
127 contract Asset is ERC20Token {
128     string public name = 'Digital Cloud Storage';
129     uint8 public decimals = 18;
130     string public symbol = 'DCST';
131     string public version = '1';
132     
133     /**
134     * @notice token contructor.
135     */
136     function Asset() public {
137 
138         totalSupply = 10000000 * (10 ** uint256(decimals)); //Token initial supply;
139         balances[msg.sender] = totalSupply;
140         Transfer(0, this, totalSupply);
141         Transfer(this, msg.sender, totalSupply);       
142     }
143     
144     /**
145     * @notice this contract will revert on direct non-function calls
146     * @dev Function to handle callback calls
147     */
148     function() public {
149         revert();
150     }
151 
152 }