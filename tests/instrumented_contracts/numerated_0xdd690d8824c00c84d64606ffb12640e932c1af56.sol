1 pragma solidity 0.4.24;
2 /**
3 * TAVITT TOKEN Contract
4 * ERC-20 Token Standard Compliant
5 */
6 
7 /**
8  * @title SafeMath by OpenZeppelin
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
27  * Token contract interface for external use
28  */
29 contract ERC20TokenInterface {
30 
31     function balanceOf(address _owner) public constant returns (uint256 value);
32     function transfer(address _to, uint256 _value) public returns (bool success);
33     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
34     function approve(address _spender, uint256 _value) public returns (bool success);
35     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
36 
37     }
38 
39 
40 /**
41 * @title Admin parameters
42 * @dev Define administration parameters for this contract
43 */
44 contract admined { //This token contract is administered
45     address public admin; //Admin address is public
46     bool public lockSupply; //Mint and Burn Lock flag
47     bool public lockTransfer; //Transfer Lock flag
48     address public allowedAddress; //an address that can override lock condition
49 
50     /**
51     * @dev Contract constructor
52     * define initial administrator
53     */
54     constructor() internal {
55         admin = 0xE57f73F0D380e1698f59dc7270352724c1cc8306; //Set initial admin
56         emit Admined(admin);
57     }
58 
59    /**
60     * @dev Function to set an allowed address
61     * @param _to The address to give privileges.
62     */
63     function setAllowedAddress(address _to) onlyAdmin public {
64         allowedAddress = _to;
65         emit AllowedSet(_to);
66     }
67 
68     modifier onlyAdmin() { //A modifier to define admin-only functions
69         require(msg.sender == admin);
70         _;
71     }
72 
73     modifier supplyLock() { //A modifier to lock mint and burn transactions
74         require(lockSupply == false);
75         _;
76     }
77 
78     modifier transferLock() { //A modifier to lock transactions
79         require(lockTransfer == false || allowedAddress == msg.sender);
80         _;
81     }
82 
83    /**
84     * @dev Function to set new admin address
85     * @param _newAdmin The address to transfer administration to
86     */
87     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
88         require(_newAdmin != 0);
89         admin = _newAdmin;
90         emit TransferAdminship(admin);
91     }
92 
93    /**
94     * @dev Function to set mint and burn locks
95     * @param _set boolean flag (true | false)
96     */
97     function setSupplyLock(bool _set) onlyAdmin public { //Only the admin can set a lock on supply
98         lockSupply = _set;
99         emit SetSupplyLock(_set);
100     }
101 
102    /**
103     * @dev Function to set transfer lock
104     * @param _set boolean flag (true | false)
105     */
106     function setTransferLock(bool _set) onlyAdmin public { //Only the admin can set a lock on transfers
107         lockTransfer = _set;
108         emit SetTransferLock(_set);
109     }
110 
111     //All admin actions have a log for public review
112     event AllowedSet(address _to);
113     event SetSupplyLock(bool _set);
114     event SetTransferLock(bool _set);
115     event TransferAdminship(address newAdminister);
116     event Admined(address administer);
117 
118 }
119 
120 /**
121 * @title Token definition
122 * @dev Define token paramters including ERC20 ones
123 */
124 contract ERC20Token is ERC20TokenInterface, admined { //Standard definition of a ERC20Token
125     using SafeMath for uint256;
126     uint256 public totalSupply;
127     mapping (address => uint256) balances; //A mapping of all balances per address
128     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
129     mapping (address => bool) frozen; //A mapping of frozen accounts
130 
131     /**
132     * @dev Get the balance of an specified address.
133     * @param _owner The address to be query.
134     */
135     function balanceOf(address _owner) public constant returns (uint256 value) {
136         return balances[_owner];
137     }
138 
139     /**
140     * @dev transfer token to a specified address
141     * @param _to The address to transfer to.
142     * @param _value The amount to be transferred.
143     */
144     function transfer(address _to, uint256 _value) transferLock public returns (bool success) {
145         require(_to != address(0)); //If you dont want that people destroy token
146         require(frozen[msg.sender]==false);
147         balances[msg.sender] = balances[msg.sender].sub(_value);
148         balances[_to] = balances[_to].add(_value);
149         emit Transfer(msg.sender, _to, _value);
150         return true;
151     }
152 
153     /**
154     * @dev transfer token from an address to another specified address using allowance
155     * @param _from The address where token comes.
156     * @param _to The address to transfer to.
157     * @param _value The amount to be transferred.
158     */
159     function transferFrom(address _from, address _to, uint256 _value) transferLock public returns (bool success) {
160         require(_to != address(0)); //If you dont want that people destroy token
161         require(frozen[_from]==false);
162         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163         balances[_from] = balances[_from].sub(_value);
164         balances[_to] = balances[_to].add(_value);
165         emit Transfer(_from, _to, _value);
166         return true;
167     }
168 
169     /**
170     * @dev Assign allowance to an specified address to use the owner balance
171     * @param _spender The address to be allowed to spend.
172     * @param _value The amount to be allowed.
173     */
174     function approve(address _spender, uint256 _value) public returns (bool success) {
175         require((_value == 0) || (allowed[msg.sender][_spender] == 0)); //exploit mitigation
176         allowed[msg.sender][_spender] = _value;
177         emit Approval(msg.sender, _spender, _value);
178         return true;
179     }
180 
181     /**
182     * @dev Get the allowance of an specified address to use another address balance.
183     * @param _owner The address of the owner of the tokens.
184     * @param _spender The address of the allowed spender.
185     */
186     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
187         return allowed[_owner][_spender];
188     }
189 
190     /**
191     * @dev Mint token to an specified address.
192     * @param _target The address of the receiver of the tokens.
193     * @param _mintedAmount amount to mint.
194     */
195     function mintToken(address _target, uint256 _mintedAmount) onlyAdmin supplyLock public {
196         balances[_target] = SafeMath.add(balances[_target], _mintedAmount);
197         totalSupply = SafeMath.add(totalSupply, _mintedAmount);
198         emit Transfer(0, this, _mintedAmount);
199         emit Transfer(this, _target, _mintedAmount);
200     }
201 
202     /**
203     * @dev Burn token of an specified address.
204     * @param _target The address of the holder of the tokens.
205     * @param _burnedAmount amount to burn.
206     */
207     function burnToken(address _target, uint256 _burnedAmount) onlyAdmin supplyLock public {
208         balances[_target] = SafeMath.sub(balances[_target], _burnedAmount);
209         totalSupply = SafeMath.sub(totalSupply, _burnedAmount);
210         emit Burned(_target, _burnedAmount);
211     }
212 
213     /**
214     * @dev Frozen account.
215     * @param _target The address to being frozen.
216     * @param _flag The status of the frozen
217     */
218     function setFrozen(address _target,bool _flag) onlyAdmin public {
219         frozen[_target]=_flag;
220         emit FrozenStatus(_target,_flag);
221     }
222 
223 
224     /**
225     * @dev Log Events
226     */
227     event Transfer(address indexed _from, address indexed _to, uint256 _value);
228     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
229     event Burned(address indexed _target, uint256 _value);
230     event FrozenStatus(address _target,bool _flag);
231 }
232 
233 /**
234 * @title Asset
235 * @dev Initial supply creation
236 */
237 contract Asset is ERC20Token {
238     string public name = 'Tavittcoin';
239     uint8 public decimals = 8;
240     string public symbol = 'TAVITT';
241     string public version = '1';
242 
243     constructor() public {
244         totalSupply = 100000000 * (10**uint256(decimals)); //100,000,000 tokens initial token creation
245         balances[0xE57f73F0D380e1698f59dc7270352724c1cc8306] = totalSupply;
246         emit Transfer(address(0), 0xE57f73F0D380e1698f59dc7270352724c1cc8306, balances[0xE57f73F0D380e1698f59dc7270352724c1cc8306]);
247     }
248 
249     /**
250     *@dev Function to handle callback calls
251     */
252     function() public {
253         revert();
254     }
255 
256 }