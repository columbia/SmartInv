1 pragma solidity ^0.4.18;
2 /**
3 * TOKEN Contract
4 */
5 
6 /**
7  * @title SafeMath by OpenZeppelin
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         assert(b <= a);
14         return a - b;
15     }
16 
17     function add(uint256 a, uint256 b) internal pure returns (uint256) {
18         uint256 c = a + b;
19         assert(c >= a);
20         return c;
21     }
22 
23 }
24 
25 /**
26  * Token contract interface for external use
27  */
28 contract ERC20TokenInterface {
29 
30     function balanceOf(address _owner) public constant returns (uint256 balance);
31     function transfer(address _to, uint256 _value) public returns (bool success);
32     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
33     function approve(address _spender, uint256 _value) public returns (bool success);
34     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
35 
36     }
37 
38 
39 /**
40 * @title Admin parameters
41 * @dev Define administration parameters for this contract
42 */
43 contract admined { //This token contract is administered
44     address public admin; //Admin address is public
45     bool public lockTransfer; //Transfer Lock flag
46     address public allowedAddress; //an address that can override lock condition
47 
48     /**
49     * @dev Contract constructor
50     * define initial administrator
51     */
52     function admined() internal {
53         admin = msg.sender; //Set initial admin to contract creator
54         Admined(admin);
55     }
56 
57    /**
58     * @dev Function to set an allowed address
59     * @param _to The address to give privileges.
60     */
61     function setAllowedAddress(address _to) public {
62         allowedAddress = _to;
63         AllowedSet(_to);
64     }
65 
66     modifier onlyAdmin() { //A modifier to define admin-only functions
67         require(msg.sender == admin);
68         _;
69     }
70 
71     modifier transferLock() { //A modifier to lock transactions
72         require(lockTransfer == false || allowedAddress == msg.sender);
73         _;
74     }
75 
76    /**
77     * @dev Function to set new admin address
78     * @param _newAdmin The address to transfer administration to
79     */
80     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
81         admin = _newAdmin;
82         TransferAdminship(admin);
83     }
84 
85 
86    /**
87     * @dev Function to set transfer lock
88     * @param _set boolean flag (true | false)
89     */
90     function setTransferLock(bool _set) onlyAdmin public { //Only the admin can set a lock on transfers
91         lockTransfer = _set;
92         SetTransferLock(_set);
93     }
94 
95     //All admin actions have a log for public review
96     event AllowedSet(address _to);
97     event SetTransferLock(bool _set);
98     event TransferAdminship(address newAdminister);
99     event Admined(address administer);
100 
101 }
102 
103 /**
104 * @title Token definition
105 * @dev Define token paramters including ERC20 ones
106 */
107 contract ERC20Token is ERC20TokenInterface, admined { //Standar definition of a ERC20Token
108     using SafeMath for uint256;
109     uint256 public totalSupply;
110     mapping (address => uint256) balances; //A mapping of all balances per address
111     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
112     mapping (address => bool) frozen; //A mapping of frozen accounts
113 
114     /**
115     * @dev Get the balance of an specified address.
116     * @param _owner The address to be query.
117     */
118     function balanceOf(address _owner) public constant returns (uint256 balance) {
119       return balances[_owner];
120     }
121 
122     /**
123     * @dev transfer token to a specified address
124     * @param _to The address to transfer to.
125     * @param _value The amount to be transferred.
126     */
127     function transfer(address _to, uint256 _value) transferLock public returns (bool success) {
128         require(_to != address(0)); //If you dont want that people destroy token
129         require(balances[msg.sender] >= _value);
130         require(frozen[msg.sender]==false);
131         balances[msg.sender] = balances[msg.sender].sub(_value);
132         balances[_to] = balances[_to].add(_value);
133         Transfer(msg.sender, _to, _value);
134         return true;
135     }
136 
137     /**
138     * @dev transfer token from an address to another specified address using allowance
139     * @param _from The address where token comes.
140     * @param _to The address to transfer to.
141     * @param _value The amount to be transferred.
142     */
143     function transferFrom(address _from, address _to, uint256 _value) transferLock public returns (bool success) {
144         require(_to != address(0)); //If you dont want that people destroy token
145         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
146         require(frozen[_from]==false);
147         balances[_to] = balances[_to].add(_value);
148         balances[_from] = balances[_from].sub(_value);
149         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
150         Transfer(_from, _to, _value);
151         return true;
152     }
153 
154     /**
155     * @dev Assign allowance to an specified address to use the owner balance
156     * @param _spender The address to be allowed to spend.
157     * @param _value The amount to be allowed.
158     */
159     function approve(address _spender, uint256 _value) public returns (bool success) {
160       allowed[msg.sender][_spender] = _value;
161         Approval(msg.sender, _spender, _value);
162         return true;
163     }
164 
165     /**
166     * @dev Get the allowance of an specified address to use another address balance.
167     * @param _owner The address of the owner of the tokens.
168     * @param _spender The address of the allowed spender.
169     */
170     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
171     return allowed[_owner][_spender];
172     }
173 
174     /**
175     * @dev Frozen account.
176     * @param _target The address to being frozen.
177     * @param _flag The status of the frozen
178     */
179     function setFrozen(address _target,bool _flag) onlyAdmin public {
180         frozen[_target]=_flag;
181         FrozenStatus(_target,_flag);
182     }
183 
184 
185     /**
186     * @dev Log Events
187     */
188     event Transfer(address indexed _from, address indexed _to, uint256 _value);
189     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
190     event FrozenStatus(address _target,bool _flag);
191 }
192 
193 /**
194 * @title Asset
195 * @dev Initial supply creation
196 */
197 contract Asset is ERC20Token {
198     string public name = 'EasyExchanger token';
199     uint8 public decimals = 18;
200     string public symbol = 'ECE';
201     string public version = '1';
202 
203     function Asset() public {
204         totalSupply = 300000000 * (10**uint256(decimals)); //300 million initial token creation
205         balances[0x6c372aa5eda3858f12a5b59825bfdacb59e9f6fe] = totalSupply - (300000 * (10**uint256(decimals)));
206         balances[0x9656e8520C1cc10721963F2E974761cf76Af81d8] = 300000 * (10**uint256(decimals)); //0.1% for contract writer
207     }
208     
209     /**
210     *@dev Function to handle callback calls
211     */
212     function() public {
213         revert();
214     }
215 
216 }