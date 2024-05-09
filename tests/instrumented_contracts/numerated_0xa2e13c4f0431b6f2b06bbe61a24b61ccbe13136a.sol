1 pragma solidity 0.4.25;
2 /**
3 * @notice VSTER TOKEN CONTRACT
4 * @dev ERC-20 Token Standar Compliant
5 */
6 
7 /**
8  * @title SafeMath by OpenZeppelin (partially)
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
27 * @title ERC20 Token minimal interface
28 */
29 contract token {
30 
31     function balanceOf(address _owner) public constant returns (uint256 balance);
32     function transfer(address _to, uint256 _value) public;
33 
34 }
35 
36 /**
37 * @title Admin parameters
38 * @dev Define administration parameters for this contract
39 */
40 contract admined { //This token contract is administered
41     address public owner; //owner address is public
42     bool public lockTransfer; //Transfer Lock flag
43     address public allowedAddress; //an address that can override lock condition
44 
45     /**
46     * @dev Contract constructor
47     * define initial owner
48     */
49     constructor() internal {
50         owner = msg.sender; //Set initial owner to contract creator
51         emit Admined(owner);
52     }
53 
54     modifier onlyAdmin() { //A modifier to define admin-only functions
55         require(msg.sender == owner);
56         _;
57     }
58 
59    /**
60     * @dev Function to set new admin address
61     * @param _newAdmin The address to transfer administration to
62     */
63     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
64         require(_newAdmin != 0);
65         owner = _newAdmin;
66         emit TransferAdminship(owner);
67     }
68 
69     event TransferAdminship(address newAdminister);
70     event Admined(address administer);
71 
72 }
73 
74 /**
75  * @title ERC20TokenInterface
76  * @dev Token contract interface for external use
77  */
78 contract ERC20TokenInterface {
79 
80     function balanceOf(address _owner) public constant returns (uint256 balance);
81     function transfer(address _to, uint256 _value) public returns (bool success);
82     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
83     function approve(address _spender, uint256 _value) public returns (bool success);
84     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
85 
86     }
87 
88 
89 /**
90 * @title ERC20Token
91 * @notice Token definition contract
92 */
93 contract ERC20Token is admined, ERC20TokenInterface { //Standar definition of an ERC20Token
94     using SafeMath for uint256; //SafeMath is used for uint256 operations
95     mapping (address => uint256) balances; //A mapping of all balances per address
96     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
97     mapping (address => bool) frozen; //A mapping of all frozen accounts
98     uint256 public totalSupply;
99 
100     /**
101     * @notice Get the balance of an _owner address.
102     * @param _owner The address to be query.
103     */
104     function balanceOf(address _owner) public constant returns (uint256 bal) {
105         return balances[_owner];
106     }
107 
108     /**
109     * @notice transfer _value tokens to address _to
110     * @param _to The address to transfer to.
111     * @param _value The amount to be transferred.
112     * @return success with boolean value true if done
113     */
114     function transfer(address _to, uint256 _value) public returns (bool success) {
115         require(frozen[msg.sender] == false);
116         require(_to != address(0)); //If you dont want that people destroy token
117         balances[msg.sender] = balances[msg.sender].sub(_value);
118         balances[_to] = balances[_to].add(_value);
119         emit Transfer(msg.sender, _to, _value);
120         return true;
121     }
122 
123     /**
124     * @notice Transfer _value tokens from address _from to address _to using allowance msg.sender allowance on _from
125     * @param _from The address where tokens comes.
126     * @param _to The address to transfer to.
127     * @param _value The amount to be transferred.
128     * @return success with boolean value true if done
129     */
130     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
131         require(frozen[_from] == false && frozen[msg.sender] == false);
132         require(_to != address(0)); //If you dont want that people destroy token
133         balances[_from] = balances[_from].sub(_value);
134         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
135         balances[_to] = balances[_to].add(_value);
136         emit Transfer(_from, _to, _value);
137         return true;
138     }
139 
140     /**
141     * @notice Assign allowance _value to _spender address to use the msg.sender balance
142     * @param _spender The address to be allowed to spend.
143     * @param _value The amount to be allowed.
144     * @return success with boolean value true
145     */
146     function approve(address _spender, uint256 _value) public returns (bool success) {
147         require((_value == 0) || (allowed[msg.sender][_spender] == 0)); //exploit mitigation
148         allowed[msg.sender][_spender] = _value;
149         emit Approval(msg.sender, _spender, _value);
150         return true;
151     }
152 
153     /**
154     * @notice Get the allowance of an specified address to use another address balance.
155     * @param _owner The address of the owner of the tokens.
156     * @param _spender The address of the allowed spender.
157     * @return remaining with the allowance value
158     */
159     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
160         return allowed[_owner][_spender];
161     }
162 
163     function setFrozen(address _owner, bool _flag) public onlyAdmin returns (bool success) {
164       frozen[_owner] = _flag;
165       emit Frozen(_owner,_flag);
166       return true;
167     }
168 
169     /**
170     * @dev Log Events
171     */
172     event Transfer(address indexed _from, address indexed _to, uint256 _value);
173     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
174     event Frozen(address indexed _owner, bool _flag);
175 
176 }
177 
178 /**
179 * @title Asset
180 * @dev Initial supply creation
181 */
182 contract Asset is ERC20Token {
183     string public name = 'VSTER';
184     uint8 public decimals = 18;
185     string public symbol = 'VAPP';
186     string public version = '1';
187 
188     constructor() public {
189         totalSupply = 50000000 * (10**uint256(decimals)); //initial token creation
190         balances[msg.sender] = totalSupply;
191         emit Transfer(address(0), msg.sender, balances[msg.sender]);
192     }
193 
194     /**
195     * @notice Function to claim ANY token stuck on contract accidentally
196     * In case of claim of stuck tokens please contact contract owners
197     */
198     function claimTokens(token _address, address _to) onlyAdmin public{
199         require(_to != address(0));
200         uint256 remainder = _address.balanceOf(this); //Check remainder tokens
201         _address.transfer(_to,remainder); //Transfer tokens to creator
202     }
203 
204 
205     /**
206     * @notice this contract will revert on direct non-function calls, also it's not payable
207     * @dev Function to handle callback calls to contract
208     */
209     function() public {
210         revert();
211     }
212 
213 }