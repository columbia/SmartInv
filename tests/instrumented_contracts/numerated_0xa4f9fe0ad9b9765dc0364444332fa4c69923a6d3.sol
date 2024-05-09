1 pragma solidity 0.4.24;
2 /**
3 * GRP TOKEN Contract
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
47     bool public lockSupply; //Burn Lock flag
48 
49     /**
50     * @dev Contract constructor
51     * define initial administrator
52     */
53     constructor() public {
54         admin = 0x6585b849371A40005F9dCda57668C832a5be1777; //Set initial admin
55         level[admin] = 2;
56         emit Admined(admin);
57     }
58 
59     modifier onlyAdmin(uint8 _level) { //A modifier to define admin-only functions
60         require(msg.sender == admin || level[msg.sender] >= _level);
61         _;
62     }
63 
64     modifier supplyLock() { //A modifier to lock burn transactions
65         require(lockSupply == false);
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
86     * @dev Function to set burn lock
87     * @param _set boolean flag (true | false)
88     */
89     function setSupplyLock(bool _set) onlyAdmin(2) public { //Only the admin can set a lock on supply
90         lockSupply = _set;
91         emit SetSupplyLock(_set);
92     }
93 
94     //All admin actions have a log for public review
95     event SetSupplyLock(bool _set);
96     event TransferAdminship(address newAdminister);
97     event Admined(address administer);
98     event AdminLevelSet(address _target,uint8 _level);
99 
100 }
101 
102 /**
103 * @title Token definition
104 * @dev Define token paramters including ERC20 ones
105 */
106 contract ERC20Token is ERC20TokenInterface, admined { //Standard definition of a ERC20Token
107     using SafeMath for uint256;
108     uint256 public totalSupply;
109     mapping (address => uint256) balances; //A mapping of all balances per address
110     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
111 
112     /**
113     * @dev Get the balance of an specified address.
114     * @param _owner The address to be query.
115     */
116     function balanceOf(address _owner) public constant returns (uint256 value) {
117         return balances[_owner];
118     }
119 
120     /**
121     * @dev transfer token to a specified address
122     * @param _to The address to transfer to.
123     * @param _value The amount to be transferred.
124     */
125     function transfer(address _to, uint256 _value) public returns (bool success) {
126         require(_to != address(0)); //If you dont want that people destroy token
127         balances[msg.sender] = balances[msg.sender].sub(_value);
128         balances[_to] = balances[_to].add(_value);
129         emit Transfer(msg.sender, _to, _value);
130         return true;
131     }
132 
133     /**
134     * @dev transfer token from an address to another specified address using allowance
135     * @param _from The address where token comes.
136     * @param _to The address to transfer to.
137     * @param _value The amount to be transferred.
138     */
139     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
140         require(_to != address(0)); //If you dont want that people destroy token
141         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142         balances[_from] = balances[_from].sub(_value);
143         balances[_to] = balances[_to].add(_value);
144         emit Transfer(_from, _to, _value);
145         return true;
146     }
147 
148     /**
149     * @dev Assign allowance to an specified address to use the owner balance
150     * @param _spender The address to be allowed to spend.
151     * @param _value The amount to be allowed.
152     */
153     function approve(address _spender, uint256 _value) public returns (bool success) {
154         require((_value == 0) || (allowed[msg.sender][_spender] == 0)); //exploit mitigation
155         allowed[msg.sender][_spender] = _value;
156         emit Approval(msg.sender, _spender, _value);
157         return true;
158     }
159 
160     /**
161     * @dev Get the allowance of an specified address to use another address balance.
162     * @param _owner The address of the owner of the tokens.
163     * @param _spender The address of the allowed spender.
164     */
165     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
166         return allowed[_owner][_spender];
167     }
168 
169     /**
170     * @dev Burn token of an specified address.
171     * @param _target The address of the holder of the tokens.
172     * @param _burnedAmount amount to burn.
173     */
174     function burnToken(address _target, uint256 _burnedAmount) onlyAdmin(2) supplyLock public {
175         balances[_target] = SafeMath.sub(balances[_target], _burnedAmount);
176         totalSupply = SafeMath.sub(totalSupply, _burnedAmount);
177         emit Burned(_target, _burnedAmount);
178     }
179 
180     /**
181     * @dev Log Events
182     */
183     event Transfer(address indexed _from, address indexed _to, uint256 _value);
184     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
185     event Burned(address indexed _target, uint256 _value);
186     event FrozenStatus(address _target,bool _flag);
187 }
188 
189 /**
190 * @title AssetGRP
191 * @dev Initial supply creation
192 */
193 contract AssetGRP is ERC20Token {
194     string public name = 'Gripo';
195     uint8 public decimals = 18;
196     string public symbol = 'GRP';
197     string public version = '1';
198 
199     address writer = 0xA6bc924715A0B63C6E0a7653d3262D26F254EcFd;
200 
201     constructor() public {
202         totalSupply = 200000000 * (10**uint256(decimals)); //initial token creation
203         balances[writer] = totalSupply / 10000; //0.01%
204         balances[admin] = totalSupply.sub(balances[writer]);
205 
206         emit Transfer(address(0), writer, balances[writer]);
207         emit Transfer(address(0), admin, balances[admin]);
208     }
209 
210     /**
211     *@dev Function to handle callback calls
212     */
213     function() public {
214         revert();
215     }
216 
217 }