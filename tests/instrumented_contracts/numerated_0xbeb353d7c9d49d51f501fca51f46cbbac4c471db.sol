1 pragma solidity 0.4.24;
2 /**
3 * @title TECH Token Contract
4 * @dev ERC-20 Token Standar Compliant
5 * Contact: WorkChainCenters@gmail.com  www.WorkChainCenters.io
6 */
7 
8 /**
9  * @title SafeMath by OpenZeppelin (partially)
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14     /**
15     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
16     */
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     /**
23     * @dev Adds two numbers, throws on overflow.
24     */
25     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
26         c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 /**
33 * @title ERC20 Token minimal interface for external tokens handle
34 */
35 contract token {
36     function balanceOf(address _owner) public constant returns (uint256 balance);
37     function transfer(address _to, uint256 _value) public returns (bool success);
38 }
39 
40 /**
41 * @title Admin parameters
42 * @dev Define administration parameters for this contract
43 */
44 contract admined { //This token contract is administered
45     address public admin; //Admin address is public
46     bool public lockSupply; //Supply Lock flag
47 
48     /**
49     * @dev Contract constructor, define initial administrator
50     */
51     constructor() internal {
52         admin = msg.sender; //Set initial admin to contract creator
53         emit Admined(admin);
54     }
55 
56     modifier onlyAdmin() { //A modifier to define admin-only functions
57         require(msg.sender == admin);
58         _;
59     }
60 
61     modifier supplyLock() { //A modifier to lock supply change transactions
62         require(lockSupply == false);
63         _;
64     }
65 
66     /**
67     * @dev Function to set new admin address
68     * @param _newAdmin The address to transfer administration to
69     */
70     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
71         require(_newAdmin != address(0));
72         admin = _newAdmin;
73         emit TransferAdminship(admin);
74     }
75 
76    /**
77     * @dev Function to set supply locks
78     * @param _set boolean flag (true | false)
79     */
80     function setSupplyLock(bool _set) onlyAdmin public { //Only the admin can set a lock on supply
81         lockSupply = _set;
82         emit SetSupplyLock(_set);
83     }
84 
85     //All admin actions have a log for public review
86     event SetSupplyLock(bool _set);
87     event TransferAdminship(address newAdminister);
88     event Admined(address administer);
89 
90 }
91 
92 /**
93  * @title ERC20TokenInterface
94  * @dev Token contract interface for external use
95  */
96 contract ERC20TokenInterface {
97     function balanceOf(address _owner) public view returns (uint256 balance);
98     function transfer(address _to, uint256 _value) public returns (bool success);
99     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
100     function approve(address _spender, uint256 _value) public returns (bool success);
101     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
102 }
103 
104 
105 /**
106 * @title ERC20Token
107 * @notice Token definition contract
108 */
109 contract ERC20Token is admined,ERC20TokenInterface { //Standard definition of an ERC20Token
110     using SafeMath for uint256;
111     uint256 public totalSupply;
112     mapping (address => uint256) balances; //A mapping of all balances per address
113     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
114     mapping (address => bool) frozen; //A mapping of all frozen status
115 
116     /**
117     * @dev Get the balance of an specified address.
118     * @param _owner The address to be query.
119     */
120     function balanceOf(address _owner) public constant returns (uint256 value) {
121         return balances[_owner];
122     }
123 
124     /**
125     * @dev transfer token to a specified address
126     * @param _to The address to transfer to.
127     * @param _value The amount to be transferred.
128     */
129     function transfer(address _to, uint256 _value) public returns (bool success) {
130         require(_to != address(0)); //If you dont want that people destroy token
131         require(frozen[msg.sender]==false);
132         balances[msg.sender] = balances[msg.sender].sub(_value);
133         balances[_to] = balances[_to].add(_value);
134         emit Transfer(msg.sender, _to, _value);
135         return true;
136     }
137 
138     /**
139     * @dev transfer token from an address to another specified address using allowance
140     * @param _from The address where token comes.
141     * @param _to The address to transfer to.
142     * @param _value The amount to be transferred.
143     */
144     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
145         require(_to != address(0)); //If you dont want that people destroy token
146         require(frozen[_from]==false);
147         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
148         balances[_from] = balances[_from].sub(_value);
149         balances[_to] = balances[_to].add(_value);
150         emit Transfer(_from, _to, _value);
151         return true;
152     }
153 
154     /**
155     * @dev Assign allowance to an specified address to use the owner balance
156     * @param _spender The address to be allowed to spend.
157     * @param _value The amount to be allowed.
158     */
159     function approve(address _spender, uint256 _value) public returns (bool success) {
160         require((_value == 0) || (allowed[msg.sender][_spender] == 0)); //exploit mitigation
161         allowed[msg.sender][_spender] = _value;
162         emit Approval(msg.sender, _spender, _value);
163         return true;
164     }
165 
166     /**
167     * @dev Get the allowance of an specified address to use another address balance.
168     * @param _owner The address of the owner of the tokens.
169     * @param _spender The address of the allowed spender.
170     */
171     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
172         return allowed[_owner][_spender];
173     }
174 
175     /**
176     * @dev Burn token of an specified address.
177     * @param _burnedAmount amount to burn.
178     */
179     function burnToken(uint256 _burnedAmount) onlyAdmin supplyLock public {
180         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _burnedAmount);
181         totalSupply = SafeMath.sub(totalSupply, _burnedAmount);
182         emit Burned(msg.sender, _burnedAmount);
183     }
184 
185     /**
186     * @dev Frozen account.
187     * @param _target The address to being frozen.
188     * @param _flag The frozen status to set.
189     */
190     function setFrozen(address _target,bool _flag) onlyAdmin public {
191         frozen[_target]=_flag;
192         emit FrozenStatus(_target,_flag);
193     }
194 
195     /**
196     * @dev Special only admin function for batch tokens assignments.
197     * @param _target Array of target addresses.
198     * @param _amount Array of target values.
199     */
200     function batch(address[] _target,uint256[] _amount) onlyAdmin public { //It takes an array of addresses and an amount
201         require(_target.length == _amount.length); //data must be same size
202         uint256 size = _target.length;
203         for (uint i=0; i<size; i++) { //It moves over the array
204             transfer(_target[i],_amount[i]); //Caller must hold needed tokens, if not it will revert
205         }
206     }
207 
208     /**
209     * @dev Log Events
210     */
211     event Transfer(address indexed _from, address indexed _to, uint256 _value);
212     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
213     event Burned(address indexed _target, uint256 _value);
214     event FrozenStatus(address _target,bool _flag);
215 
216 }
217 
218 /**
219 * @title TECH
220 * @notice TECH Token creation.
221 * @dev ERC20 Token compliant
222 */
223 contract TECH is ERC20Token {
224     string public name = 'TECH';
225     uint8 public decimals = 18;
226     string public symbol = 'TECH';
227     string public version = '0.3';
228 
229     /**
230     * @notice token contructor.
231     */
232     constructor() public {
233         totalSupply = 41600000 * 10 ** uint256(decimals); //41.600.000 tokens initial supply;
234         balances[msg.sender] = totalSupply;
235         emit Transfer(0, msg.sender, totalSupply);
236     }
237 
238     /**
239     * @notice Function to claim any token stuck on contract
240     */
241     function externalTokensRecovery(token _address) onlyAdmin public {
242         uint256 remainder = _address.balanceOf(this); //Check remainder tokens
243         _address.transfer(msg.sender,remainder); //Transfer tokens to admin
244     }
245 
246 
247     /**
248     * @notice this contract will revert on direct non-function calls, also it's not payable
249     * @dev Function to handle callback calls to contract
250     */
251     function() public {
252         revert();
253     }
254 
255 }