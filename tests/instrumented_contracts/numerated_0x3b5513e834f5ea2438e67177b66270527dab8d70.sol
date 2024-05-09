1 pragma solidity 0.4.24;
2 /**
3 * @title CNC Token Contract
4 * @dev ERC-20 Token Standar Compliant
5 */
6 
7 /**
8  * @title SafeMath by OpenZeppelin (partially)
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13     /**
14     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
15     */
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17         assert(b <= a);
18         return a - b;
19     }
20 
21     /**
22     * @dev Adds two numbers, throws on overflow.
23     */
24     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
25         c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 }
30 
31 /**
32 * @title ERC20 Token minimal interface for external tokens handle
33 */
34 contract token {
35     function balanceOf(address _owner) public constant returns (uint256 balance);
36     function transfer(address _to, uint256 _value) public returns (bool success);
37 }
38 
39 /**
40 * @title Admin parameters
41 * @dev Define administration parameters for this contract
42 */
43 contract admined { //This token contract is administered
44     address public admin; //Admin address is public
45 
46     /**
47     * @dev Contract constructor, define initial administrator
48     */
49     constructor() internal {
50         admin = msg.sender; //Set initial admin to contract creator
51         emit Admined(admin);
52     }
53 
54     modifier onlyAdmin() { //A modifier to define admin-only functions
55         require(msg.sender == admin);
56         _;
57     }
58 
59     /**
60     * @dev Function to set new admin address
61     * @param _newAdmin The address to transfer administration to
62     */
63     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
64         require(_newAdmin != address(0));
65         admin = _newAdmin;
66         emit TransferAdminship(admin);
67     }
68 
69 
70     //All admin actions have a log for public review
71     event TransferAdminship(address newAdminister);
72     event Admined(address administer);
73 
74 }
75 
76 /**
77  * @title ERC20TokenInterface
78  * @dev Token contract interface for external use
79  */
80 contract ERC20TokenInterface {
81     function balanceOf(address _owner) public view returns (uint256 balance);
82     function transfer(address _to, uint256 _value) public returns (bool success);
83     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
84     function approve(address _spender, uint256 _value) public returns (bool success);
85     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
86 }
87 
88 
89 /**
90 * @title ERC20Token
91 * @notice Token definition contract
92 */
93 contract ERC20Token is admined,ERC20TokenInterface { //Standard definition of an ERC20Token
94     using SafeMath for uint256;
95     uint256 public totalSupply;
96     mapping (address => uint256) balances; //A mapping of all balances per address
97     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
98     mapping (address => bool) frozen; //A mapping of all frozen status
99 
100     /**
101     * @dev Get the balance of an specified address.
102     * @param _owner The address to be query.
103     */
104     function balanceOf(address _owner) public constant returns (uint256 value) {
105         return balances[_owner];
106     }
107 
108     /**
109     * @dev transfer token to a specified address
110     * @param _to The address to transfer to.
111     * @param _value The amount to be transferred.
112     */
113     function transfer(address _to, uint256 _value) public returns (bool success) {
114         require(_to != address(0)); //If you dont want that people destroy token
115         require(frozen[msg.sender]==false);
116         balances[msg.sender] = balances[msg.sender].sub(_value);
117         balances[_to] = balances[_to].add(_value);
118         emit Transfer(msg.sender, _to, _value);
119         return true;
120     }
121 
122     /**
123     * @dev transfer token from an address to another specified address using allowance
124     * @param _from The address where token comes.
125     * @param _to The address to transfer to.
126     * @param _value The amount to be transferred.
127     */
128     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
129         require(_to != address(0)); //If you dont want that people destroy token
130         require(frozen[_from]==false);
131         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
132         balances[_from] = balances[_from].sub(_value);
133         balances[_to] = balances[_to].add(_value);
134         emit Transfer(_from, _to, _value);
135         return true;
136     }
137 
138     /**
139     * @dev Assign allowance to an specified address to use the owner balance
140     * @param _spender The address to be allowed to spend.
141     * @param _value The amount to be allowed.
142     */
143     function approve(address _spender, uint256 _value) public returns (bool success) {
144         require((_value == 0) || (allowed[msg.sender][_spender] == 0)); //exploit mitigation
145         allowed[msg.sender][_spender] = _value;
146         emit Approval(msg.sender, _spender, _value);
147         return true;
148     }
149 
150     /**
151     * @dev Get the allowance of an specified address to use another address balance.
152     * @param _owner The address of the owner of the tokens.
153     * @param _spender The address of the allowed spender.
154     */
155     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
156         return allowed[_owner][_spender];
157     }
158 
159     /**
160     * @dev Burn token of an specified address.
161     * @param _burnedAmount amount to burn.
162     */
163     function burnToken(uint256 _burnedAmount) onlyAdmin public {
164         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _burnedAmount);
165         totalSupply = SafeMath.sub(totalSupply, _burnedAmount);
166         emit Burned(msg.sender, _burnedAmount);
167     }
168 
169     /**
170     * @dev Frozen account.
171     * @param _target The address to being frozen.
172     * @param _flag The frozen status to set.
173     */
174     function setFrozen(address _target,bool _flag) onlyAdmin public {
175         frozen[_target]=_flag;
176         emit FrozenStatus(_target,_flag);
177     }
178 
179     /**
180     * @dev Special only admin function for batch tokens assignments.
181     * @param target Array of target addresses.
182     * @param amount Array of target values.
183     */
184     function batch(address[] target,uint256[] amount) onlyAdmin public { //It takes an array of addresses and an amount
185         require(target.length == amount.length); //data must be same size
186         uint256 size = target.length;
187         for (uint i=0; i<size; i++) { //It moves over the array
188             transfer(target[i],amount[i]); //Caller must hold needed tokens, if not it will revert
189         }
190     }
191 
192     /**
193     * @dev Log Events
194     */
195     event Transfer(address indexed _from, address indexed _to, uint256 _value);
196     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
197     event Burned(address indexed _target, uint256 _value);
198     event FrozenStatus(address _target,bool _flag);
199 
200 }
201 
202 /**
203 * @title CNC
204 * @notice CNC Token creation.
205 * @dev ERC20 Token compliant
206 */
207 contract CNC is ERC20Token {
208     string public name = 'Coinyspace';
209     uint8 public decimals = 18;
210     string public symbol = 'CNC';
211     string public version = '1';
212 
213     /**
214     * @notice token contructor.
215     */
216     constructor() public {
217         totalSupply = 1000000000 * 10 ** uint256(decimals); //1.000.000.000 tokens initial supply;
218         balances[msg.sender] = totalSupply;
219         emit Transfer(0, msg.sender, totalSupply);
220     }
221 
222     /**
223     * @notice Function to claim any token stuck on contract
224     */
225     function externalTokensRecovery(token _address) onlyAdmin public {
226         uint256 remainder = _address.balanceOf(this); //Check remainder tokens
227         _address.transfer(msg.sender,remainder); //Transfer tokens to admin
228     }
229 
230 
231     /**
232     * @notice this contract will revert on direct non-function calls, also it's not payable
233     * @dev Function to handle callback calls to contract
234     */
235     function() public {
236         revert();
237     }
238 
239 }