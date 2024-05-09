1 pragma solidity 0.4.19;
2 /**
3 * @title Cacao Shares TOKEN
4 * @dev ERC-20 Token Standard Compliant
5 * @notice Contact ico@cacaoshares.com
6 * @author Fares A. Akel C.
7 * ================================================
8 * CACAO SHARES IS A DIGITAL ASSET
9 * THAT ENABLES ANYONE TO OWN CACAO TREES
10 * OF THE CRIOLLO TYPE IN SUR DEL LAGO, VENEZUELA
11 * ================================================
12 */
13 
14 /**
15  * @title SafeMath by OpenZeppelin (partially)
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 
31 }
32 /**
33  * Token contract interface for external use
34  */
35 contract ERC20TokenInterface {
36 
37     function balanceOf(address _owner) public constant returns (uint256 value);
38     function transfer(address _to, uint256 _value) public returns (bool success);
39     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
40     function approve(address _spender, uint256 _value) public returns (bool success);
41     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
42 
43     }
44 
45 
46 /**
47 * @title Admin parameters
48 * @dev Define administration parameters for this contract
49 */
50 contract admined { //This token contract is administered
51     address public admin; //Admin address is public
52     bool public lockTransfer; //Transfer Lock flag
53     address public allowedAddress; //an address that can override lock condition
54 
55     /**
56     * @dev Contract constructor
57     * define initial administrator
58     */
59     function admined() internal {
60         admin = msg.sender; //Set initial admin to contract creator
61         allowedAddress = msg.sender; //Set initial allowed to contract creator
62         Admined(admin);
63         AllowedSet(allowedAddress);
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
77     * @dev Function to set an allowed address
78     * @param _to The address to give privileges.
79     */
80     function setAllowedAddress(address _to) onlyAdmin public {
81         allowedAddress = _to;
82         AllowedSet(_to);
83     }
84 
85    /**
86     * @dev Function to set new admin address
87     * @param _newAdmin The address to transfer administration to
88     */
89     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
90         require(_newAdmin != address(0)); //Prevent zero address transactions
91         admin = _newAdmin;
92         TransferAdminship(admin);
93     }
94 
95    /**
96     * @dev Function to unlock transfers
97     * @notice It's only possible to unlock the transfers
98     */
99     function setTransferLockFree() onlyAdmin public {
100         require(lockTransfer == true);// only if it's locked
101         lockTransfer = false;
102         SetTransferLock(lockTransfer);
103     }
104 
105     //All admin actions have a log for public review
106     event AllowedSet(address _to);
107     event SetTransferLock(bool _set);
108     event TransferAdminship(address newAdminister);
109     event Admined(address administer);
110 
111 }
112 
113 /**
114 * @title Token definition
115 * @dev Define token parameters including ERC20 ones
116 */
117 contract ERC20Token is ERC20TokenInterface, admined { //Standard definition of a ERC20Token
118     using SafeMath for uint256;
119     uint256 public totalSupply;
120     mapping (address => uint256) balances; //A mapping of all balances per address
121     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
122 
123     /**
124     * @dev Get the balance of an specified address.
125     * @param _owner The address to be query.
126     */
127     function balanceOf(address _owner) public constant returns (uint256 value) {
128       return balances[_owner];
129     }
130 
131     /**
132     * @dev transfer token to a specified address
133     * @param _to The address to transfer to.
134     * @param _value The amount to be transferred.
135     */
136     function transfer(address _to, uint256 _value) transferLock public returns (bool success) {
137         require(_to != address(0)); //Prevent zero address transactions
138         balances[msg.sender] = balances[msg.sender].sub(_value);
139         balances[_to] = balances[_to].add(_value);
140         Transfer(msg.sender, _to, _value);
141         return true;
142     }
143 
144     /**
145     * @dev transfer token from an address to another specified address using allowance
146     * @param _from The address where token comes.
147     * @param _to The address to transfer to.
148     * @param _value The amount to be transferred.
149     */
150     function transferFrom(address _from, address _to, uint256 _value) transferLock public returns (bool success) {
151         require(_to != address(0)); //Prevent zero address transactions
152         balances[_from] = balances[_from].sub(_value);
153         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
154         balances[_to] = balances[_to].add(_value);
155         Transfer(_from, _to, _value);
156         return true;
157     }
158 
159     /**
160     * @dev Assign allowance to an specified address to use the owner balance
161     * @param _spender The address to be allowed to spend.
162     * @param _value The amount to be allowed.
163     */
164     function approve(address _spender, uint256 _value) public returns (bool success) {
165         require(_value == 0 || allowed[msg.sender][_spender] == 0); //Mitigation to possible attack on approve and transferFrom functions
166         allowed[msg.sender][_spender] = _value;
167         Approval(msg.sender, _spender, _value);
168         return true;
169     }
170 
171     /**
172     * @dev Get the allowance of an specified address to use another address balance.
173     * @param _owner The address of the owner of the tokens.
174     * @param _spender The address of the allowed spender.
175     */
176     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
177         return allowed[_owner][_spender];
178     }
179 
180     /**
181     * @dev Log Events
182     */
183     event Transfer(address indexed _from, address indexed _to, uint256 _value);
184     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
185 }
186 
187 /**
188 * @title AssetCCS
189 * @dev Initial CCS supply creation
190 */
191 contract AssetCCS is ERC20Token {
192     
193     string public name = 'Cacao Shares';
194     uint8 public decimals = 18;
195     string public symbol = 'CCS';
196     string public version = '1';
197 
198     function AssetCCS() public {
199         
200         totalSupply = 100000000 * (10**uint256(decimals)); //100 million total token creation
201         balances[msg.sender] = totalSupply;
202 
203         /**
204         * This token is locked for transfers until the 90th day after ICO ending,
205         * the measure is globally applied, the only address able to transfer is the single
206         * allowed address. During ICO period, allowed address will be ICO address.
207         */
208         lockTransfer = true;
209         SetTransferLock(lockTransfer);
210 
211         Transfer(0, this, totalSupply);
212         Transfer(this, msg.sender, balances[msg.sender]);
213     
214     }
215     
216     /**
217     *@dev Function to handle callback calls
218     */
219     function() public {
220         revert();
221     }
222 }