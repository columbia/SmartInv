1 pragma solidity ^0.4.20;
2 /**
3 * TOKEN Contract
4 * ERC-20 Token Standard Compliant
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
54     function admined() internal {
55         admin = msg.sender; //Set initial admin to contract creator
56         emit Admined(admin);
57     }
58 
59    /**
60     * @dev Function to set an allowed address
61     * @param _to The address to give privileges.
62     */
63     function setAllowedAddress(address _to) onlyAdmin public {
64         require(_to != address(0));
65         allowedAddress = _to;
66         emit AllowedSet(_to);
67     }
68 
69     modifier onlyAdmin() { //A modifier to define admin-only functions
70         require(msg.sender == admin);
71         _;
72     }
73 
74     modifier supplyLock() { //A modifier to lock mint and burn transactions
75         require(lockSupply == false);
76         _;
77     }
78 
79     modifier transferLock() { //A modifier to lock transactions
80         require(lockTransfer == false || allowedAddress == msg.sender);
81         _;
82     }
83 
84    /**
85     * @dev Function to set new admin address
86     * @param _newAdmin The address to transfer administration to
87     */
88     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
89         require(_newAdmin != address(0));
90         admin = _newAdmin;
91         emit TransferAdminship(admin);
92     }
93 
94    /**
95     * @dev Function to set mint and burn locks
96     * @param _set boolean flag (true | false)
97     */
98     function setSupplyLock(bool _set) onlyAdmin public { //Only the admin can set a lock on supply
99         lockSupply = _set;
100         emit SetSupplyLock(_set);
101     }
102 
103    /**
104     * @dev Function to set transfer lock
105     * @param _set boolean flag (true | false)
106     */
107     function setTransferLock(bool _set) onlyAdmin public { //Only the admin can set a lock on transfers
108         lockTransfer = _set;
109         emit SetTransferLock(_set);
110     }
111 
112     //All admin actions have a log for public review
113     event AllowedSet(address _to);
114     event SetSupplyLock(bool _set);
115     event SetTransferLock(bool _set);
116     event TransferAdminship(address newAdminister);
117     event Admined(address administer);
118 
119 }
120 
121 /**
122 * @title Token definition
123 * @dev Define token paramters including ERC20 ones
124 */
125 contract ERC20Token is ERC20TokenInterface, admined { //Standard definition of a ERC20Token
126     using SafeMath for uint256;
127     uint256 public totalSupply;
128     mapping (address => uint256) balances; //A mapping of all balances per address
129     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
130     mapping (address => bool) frozen; //A mapping of frozen accounts
131 
132     /**
133     * @dev Get the balance of an specified address.
134     * @param _owner The address to be query.
135     */
136     function balanceOf(address _owner) public constant returns (uint256 value) {
137         return balances[_owner];
138     }
139 
140     /**
141     * @dev transfer token to a specified address
142     * @param _to The address to transfer to.
143     * @param _value The amount to be transferred.
144     */
145     function transfer(address _to, uint256 _value) transferLock public returns (bool success) {
146         require(_to != address(0)); //If you dont want that people destroy token
147         require(frozen[msg.sender]==false);
148         balances[msg.sender] = balances[msg.sender].sub(_value);
149         balances[_to] = balances[_to].add(_value);
150         emit Transfer(msg.sender, _to, _value);
151         return true;
152     }
153 
154     /**
155     * @dev transfer token from an address to another specified address using allowance
156     * @param _from The address where token comes.
157     * @param _to The address to transfer to.
158     * @param _value The amount to be transferred.
159     */
160     function transferFrom(address _from, address _to, uint256 _value) transferLock public returns (bool success) {
161         require(_to != address(0)); //If you dont want that people destroy token
162         require(frozen[_from] == false);
163         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
164         balances[_from] = balances[_from].sub(_value);
165         balances[_to] = balances[_to].add(_value);
166         emit Transfer(_from, _to, _value);
167         return true;
168     }
169 
170     /**
171     * @dev Assign allowance to an specified address to use the owner balance
172     * @param _spender The address to be allowed to spend.
173     * @param _value The amount to be allowed.
174     */
175     function approve(address _spender, uint256 _value) public returns (bool success) {
176         require(_spender != address(0)); // must be valid address
177         require(_value > 0); // amount must be positive
178         allowed[msg.sender][_spender] = _value;
179         emit Approval(msg.sender, _spender, _value);
180         return true;
181     }
182 
183     /**
184     * @dev Get the allowance of an specified address to use another address balance.
185     * @param _owner The address of the owner of the tokens.
186     * @param _spender The address of the allowed spender.
187     */
188     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
189         return allowed[_owner][_spender];
190     }
191 
192     /**
193     * @dev Mint token to an specified address.
194     * @param _target The address of the receiver of the tokens.
195     * @param _mintedAmount amount to mint.
196     */
197     function mintToken(address _target, uint256 _mintedAmount) onlyAdmin supplyLock public {
198         balances[_target] = SafeMath.add(balances[_target], _mintedAmount);
199         totalSupply = SafeMath.add(totalSupply, _mintedAmount);
200         emit Transfer(0, this, _mintedAmount);
201         emit Transfer(this, _target, _mintedAmount);
202     }
203 
204     /**
205     * @dev Frozen account.
206     * @param _target The address to being frozen.
207     * @param _flag The status of the frozen
208     */
209     function setFrozen(address _target,bool _flag) onlyAdmin public {
210         frozen[_target]=_flag;
211         emit FrozenStatus(_target,_flag);
212     }
213 
214 
215     /**
216     * @dev Log Events
217     */
218     event Transfer(address indexed _from, address indexed _to, uint256 _value);
219     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
220     event FrozenStatus(address _target,bool _flag);
221 }
222 
223 /**
224 * @title Asset
225 * @dev Initial supply creation
226 */
227 contract NETR is ERC20Token {
228     string public name = 'NETTERIUM';
229     uint8 public decimals = 18;
230     string public symbol = 'NETR';
231     string public version = '2';
232 
233     function NETR() public {
234         totalSupply = 750000000 * (10**uint256(decimals)); //initial token creation
235         balances[msg.sender] = totalSupply;
236         setSupplyLock(true);
237 
238         emit Transfer(0, this, totalSupply);
239         emit Transfer(this, msg.sender, balances[msg.sender]);
240     }
241     
242     /**
243     *@dev Function to handle callback calls
244     */
245     function() public payable {
246         revert();
247     }
248 
249 }