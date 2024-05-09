1 pragma solidity 0.4.24;
2 /**
3 * AUIN TOKEN Contract
4 * ERC-20 Token Standard Compliant
5 * @author Fares A. Akel C. f.antonio.akel@gmail.com
6 */
7 
8 /**
9 * @title SafeMath by OpenZeppelin
10 * @dev Math operations with safety checks that throw on error
11 */
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
28 * Token contract interface for external use
29 */
30 contract ERC20TokenInterface {
31 
32     function balanceOf(address _owner) public constant returns (uint256 value);
33     function transfer(address _to, uint256 _value) public returns (bool success);
34     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
35     function approve(address _spender, uint256 _value) public returns (bool success);
36     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
37 
38     }
39 
40 /**
41 * @title Admin parameters
42 * @dev Define administration parameters for this contract
43 */
44 contract admined { //This token contract is administered
45     address public admin; //Master address is public
46     mapping(address => uint256) public level; //Admin level
47     bool public lockTransfer; //Transfer Lock flag
48 
49     /**
50     * @dev Contract constructor
51     * define initial administrator
52     */
53     constructor() public {
54         admin = 0x911A3D6d8bC8604b71892332Ca689347ac3fFFDE; //Set initial admin
55         level[admin] = 2;
56         emit Admined(admin);
57     }
58 
59     modifier onlyAdmin(uint8 _level) { //A modifier to define admin-only functions
60         require(msg.sender == admin || level[msg.sender] >= _level);
61         _;
62     }
63 
64     modifier transferLock() {
65         require(lockTransfer == false);
66         _;
67     }
68 
69    /**
70     * @dev Function to set new admin address
71     * @param _newAdmin The address to transfer administration to
72     */
73     function transferAdminship(address _newAdmin) onlyAdmin(2) public { //Admin can be transfered
74         require(_newAdmin != address(0));
75         admin = _newAdmin;
76         level[_newAdmin] = 2;
77         emit TransferAdminship(admin);
78     }
79 
80     function setAdminLevel(address _target, uint8 _level) onlyAdmin(2) public {
81         level[_target] = _level;
82         emit AdminLevelSet(_target,_level);
83     }
84 
85    /**
86     * @dev Function to set transfer lock
87     * @param _set boolean flag (true | false)
88     */
89     function setLockTransfer(bool _set) onlyAdmin(2) public { //Only the admin can set a lock
90 
91         lockTransfer = _set;
92         emit SetTransferLock(lockTransfer);
93     }
94 
95     //All admin actions have a log for public review
96     event SetTransferLock(bool _set);
97     event TransferAdminship(address newAdminister);
98     event Admined(address administer);
99     event AdminLevelSet(address _target,uint8 _level);
100 
101 }
102 
103 /**
104 * @title Token definition
105 * @dev Define token paramters including ERC20 ones
106 */
107 contract ERC20Token is ERC20TokenInterface, admined { //Standard definition of a ERC20Token
108     using SafeMath for uint256;
109     uint256 public totalSupply;
110     mapping (address => uint256) balances; //A mapping of all balances per address
111     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
112     mapping (address => bool) public frozen; //A mapping of frozen accounts
113 
114     /**
115     * @dev Get the balance of an specified address.
116     * @param _owner The address to be query.
117     */
118     function balanceOf(address _owner) public constant returns (uint256 value) {
119         return balances[_owner];
120     }
121 
122     /**
123     * @dev transfer token to a specified address
124     * @param _to The address to transfer to.
125     * @param _value The amount to be transferred.
126     */
127     function transfer(address _to, uint256 _value) public transferLock returns (bool success) {
128         require(_to != address(0)); //If you dont want that people destroy token
129         require(frozen[msg.sender]==false);
130         balances[msg.sender] = balances[msg.sender].sub(_value);
131         balances[_to] = balances[_to].add(_value);
132         emit Transfer(msg.sender, _to, _value);
133         return true;
134     }
135 
136     /**
137     * @dev transfer token from an address to another specified address using allowance
138     * @param _from The address where token comes.
139     * @param _to The address to transfer to.
140     * @param _value The amount to be transferred.
141     */
142     function transferFrom(address _from, address _to, uint256 _value) public transferLock returns (bool success) {
143         require(_to != address(0)); //If you dont want that people destroy token
144         require(frozen[_from]==false);
145         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
146         balances[_from] = balances[_from].sub(_value);
147         balances[_to] = balances[_to].add(_value);
148         emit Transfer(_from, _to, _value);
149         return true;
150     }
151 
152     /**
153     * @dev Assign allowance to an specified address to use the owner balance
154     * @param _spender The address to be allowed to spend.
155     * @param _value The amount to be allowed.
156     */
157     function approve(address _spender, uint256 _value) public returns (bool success) {
158         require((_value == 0) || (allowed[msg.sender][_spender] == 0)); //exploit mitigation
159         allowed[msg.sender][_spender] = _value;
160         emit Approval(msg.sender, _spender, _value);
161         return true;
162     }
163 
164     /**
165     * @dev Get the allowance of an specified address to use another address balance.
166     * @param _owner The address of the owner of the tokens.
167     * @param _spender The address of the allowed spender.
168     */
169     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
170         return allowed[_owner][_spender];
171     }
172 
173     /**
174     * @dev Frozen account.
175     * @param _target The address to being frozen.
176     * @param _flag The status of the frozen
177     */
178     function setFrozen(address _target,bool _flag) onlyAdmin(1) public {
179         frozen[_target]=_flag;
180         emit FrozenStatus(_target,_flag);
181     }
182 
183     /**
184     * @dev Log Events
185     */
186     event Transfer(address indexed _from, address indexed _to, uint256 _value);
187     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
188     event FrozenStatus(address _target,bool _flag);
189 }
190 
191 /**
192 * @title AssetAUIN
193 * @dev Initial supply creation
194 */
195 contract AssetAUIN is ERC20Token {
196     string public name = 'AUIN';
197     uint8 public decimals = 18;
198     string public symbol = 'AUIN';
199     string public version = '1';
200 
201     constructor() public {
202         totalSupply = 20000000 * (10**uint256(decimals)); //initial token creation
203         balances[admin] = totalSupply;
204 
205         emit Transfer(address(0), admin, balances[admin]);
206     }
207 
208     /**
209     * @notice Function to move any token stuck on contract
210     */
211     function externalTokensRecovery(ERC20TokenInterface _address) onlyAdmin(2) public{
212 
213         uint256 remainder = _address.balanceOf(this); //Check remainder tokens
214         _address.transfer(msg.sender,remainder); //Transfer tokens to admin
215 
216     }
217 
218     /**
219     *@dev Function to handle callback calls
220     */
221     function() public {
222         revert();
223     }
224 
225 }