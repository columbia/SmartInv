1 pragma solidity 0.4.24;
2 /**
3 * @title Networth Token Contract
4 * @dev ERC-20 Token Standar Compliant
5 * Contact: networthlabs.com
6 * Airdrop service provided by f.antonio.akel@gmail.com
7 */
8 
9 /**
10  * @title SafeMath by OpenZeppelin (partially)
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14 
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19 
20     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
21         c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 
26     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a * b;
28         assert(a == 0 || c / a == b);
29         return c;
30     }
31 }
32 
33 /**
34 * @title ERC20 Token minimal interface for external tokens handle
35 */
36 contract token {
37     function balanceOf(address _owner) public constant returns (uint256 balance);
38     function transfer(address _to, uint256 _value) public returns (bool success);
39 }
40 
41 /**
42 * @title Admin parameters
43 * @dev Define administration parameters for this contract
44 */
45 contract admined { //This token contract is administered
46     address public admin; //Admin address is public
47     address public allowed; //Allowed address is public
48     bool public transferLock; //global transfer lock
49 
50     /**
51     * @dev Contract constructor, define initial administrator
52     */
53     constructor() internal {
54         admin = msg.sender; //Set initial admin to contract creator
55         emit Admined(admin);
56     }
57 
58     modifier onlyAdmin() { //A modifier to define admin-only functions
59         require(msg.sender == admin);
60         _;
61     }
62 
63     modifier onlyAllowed() { //A modifier to define allowed only function during transfer locks
64         require(msg.sender == admin || msg.sender == allowed || transferLock == false);
65         _;
66     }
67 
68     /**
69     * @dev Function to set new admin address
70     * @param _newAdmin The address to transfer administration to
71     */
72     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
73         require(_newAdmin != address(0));
74         admin = _newAdmin;
75         emit TransferAdminship(_newAdmin);
76     }
77 
78     /**
79     * @dev Function to set new allowed address
80     * @param _newAllowed The address to allow
81     */
82     function SetAllow(address _newAllowed) onlyAdmin public {
83         allowed = _newAllowed;
84         emit SetAllowed(_newAllowed);
85     }
86 
87    /**
88     * @dev Function to set transfer locks
89     * @param _set boolean flag (true | false)
90     */
91     function setTransferLock(bool _set) onlyAdmin public { //Only the admin can set a lock on transfers
92         transferLock = _set;
93         emit SetTransferLock(_set);
94     }
95 
96     //All admin actions have a log for public review
97     event SetTransferLock(bool _set);
98     event SetAllowed(address _allowed);
99     event TransferAdminship(address _newAdminister);
100     event Admined(address _administer);
101 
102 }
103 
104 /**
105  * @title ERC20TokenInterface
106  * @dev Token contract interface for external use
107  */
108 contract ERC20TokenInterface {
109     function balanceOf(address _owner) public view returns (uint256 balance);
110     function transfer(address _to, uint256 _value) public returns (bool success);
111     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
112     function approve(address _spender, uint256 _value) public returns (bool success);
113     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
114 }
115 
116 
117 /**
118 * @title ERC20Token
119 * @notice Token definition contract
120 */
121 contract ERC20Token is admined,ERC20TokenInterface { //Standard definition of an ERC20Token
122     using SafeMath for uint256;
123     uint256 public totalSupply;
124     mapping (address => uint256) balances; //A mapping of all balances per address
125     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
126     mapping (address => bool) frozen; //A mapping of all frozen status
127 
128     /**
129     * @dev Get the balance of an specified address.
130     * @param _owner The address to be query.
131     */
132     function balanceOf(address _owner) public constant returns (uint256 value) {
133         return balances[_owner];
134     }
135 
136     /**
137     * @dev transfer token to a specified address
138     * @param _to The address to transfer to.
139     * @param _value The amount to be transferred.
140     */
141     function transfer(address _to, uint256 _value) onlyAllowed public returns (bool success) {
142         require(_to != address(0)); //If you dont want that people destroy token
143         require(frozen[msg.sender]==false);
144         balances[msg.sender] = balances[msg.sender].sub(_value);
145         balances[_to] = balances[_to].add(_value);
146         emit Transfer(msg.sender, _to, _value);
147         return true;
148     }
149 
150     /**
151     * @dev transfer token from an address to another specified address using allowance
152     * @param _from The address where token comes.
153     * @param _to The address to transfer to.
154     * @param _value The amount to be transferred.
155     */
156     function transferFrom(address _from, address _to, uint256 _value) onlyAllowed public returns (bool success) {
157         require(_to != address(0)); //If you dont want that people destroy token
158         require(frozen[_from]==false);
159         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
160         balances[_from] = balances[_from].sub(_value);
161         balances[_to] = balances[_to].add(_value);
162         emit Transfer(_from, _to, _value);
163         return true;
164     }
165 
166     /**
167     * @dev Assign allowance to an specified address to use the owner balance
168     * @param _spender The address to be allowed to spend.
169     * @param _value The amount to be allowed.
170     */
171     function approve(address _spender, uint256 _value) public returns (bool success) {
172         require((_value == 0) || (allowed[msg.sender][_spender] == 0)); //exploit mitigation
173         allowed[msg.sender][_spender] = _value;
174         emit Approval(msg.sender, _spender, _value);
175         return true;
176     }
177 
178     /**
179     * @dev Get the allowance of an specified address to use another address balance.
180     * @param _owner The address of the owner of the tokens.
181     * @param _spender The address of the allowed spender.
182     */
183     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
184         return allowed[_owner][_spender];
185     }
186 
187     /**
188     * @dev Frozen account.
189     * @param _target The address to being frozen.
190     * @param _flag The frozen status to set.
191     */
192     function setFrozen(address _target,bool _flag) onlyAdmin public {
193         frozen[_target]=_flag;
194         emit FrozenStatus(_target,_flag);
195     }
196 
197     /**
198     * @dev Special only admin function for batch tokens assignments.
199     * @param _target Array of target addresses.
200     * @param _amount Targets value.
201     */
202     function batch(address[] _target,uint256 _amount) onlyAdmin public { //It takes an array of addresses and an amount
203         uint256 size = _target.length;
204         require( balances[msg.sender] >= size.mul(_amount));
205         balances[msg.sender] = balances[msg.sender].sub(size.mul(_amount));
206 
207         for (uint i=0; i<size; i++) { //It moves over the array
208             balances[_target[i]] = balances[_target[i]].add(_amount);
209             emit Transfer(msg.sender, _target[i], _amount);
210         }
211     }
212 
213     /**
214     * @dev Log Events
215     */
216     event Transfer(address indexed _from, address indexed _to, uint256 _value);
217     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
218     event FrozenStatus(address _target,bool _flag);
219 
220 }
221 
222 /**
223 * @title Networth
224 * @notice Networth Token creation.
225 * @dev ERC20 Token compliant
226 */
227 contract Networth is ERC20Token {
228     string public name = 'Networth';
229     uint8 public decimals = 18;
230     string public symbol = 'Googol';
231     string public version = '1';
232 
233     /**
234     * @notice token contructor.
235     */
236     constructor() public {
237         totalSupply = 250000000 * 10 ** uint256(decimals); //250.000.000 tokens initial supply;
238         balances[msg.sender] = totalSupply;
239         emit Transfer(0, msg.sender, totalSupply);
240     }
241 
242     /**
243     * @notice Function to claim any token stuck on contract
244     */
245     function externalTokensRecovery(token _address) onlyAdmin public {
246         uint256 remainder = _address.balanceOf(this); //Check remainder tokens
247         _address.transfer(msg.sender,remainder); //Transfer tokens to admin
248     }
249 
250 
251     /**
252     * @notice this contract will revert on direct non-function calls, also it's not payable
253     * @dev Function to handle callback calls to contract
254     */
255     function() public {
256         revert();
257     }
258 
259 }