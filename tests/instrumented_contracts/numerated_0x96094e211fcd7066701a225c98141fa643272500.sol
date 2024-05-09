1 pragma solidity 0.4.25;
2 /**
3 * XYZBuys TOKEN Contract
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
27 * @title ERC20 Token minimal interface
28 */
29 contract token {
30 
31     function balanceOf(address _owner) public view returns (uint256 balance);
32     //Since some tokens doesn't return a bool on transfer, this general interface
33     //doesn't include a return on the transfer fucntion to be widely compatible
34     function transfer(address _to, uint256 _value) public;
35 
36 }
37 
38 /**
39  * Token contract interface for external use
40  */
41 contract ERC20TokenInterface {
42 
43     function balanceOf(address _owner) public view returns (uint256 value);
44     function transfer(address _to, uint256 _value) public returns (bool success);
45     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
46     function approve(address _spender, uint256 _value) public returns (bool success);
47     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
48 
49     }
50 
51 
52 /**
53 * @title Admin parameters
54 * @dev Define administration parameters for this contract
55 */
56 contract admined { //This token contract is administered
57     //The master address of the contract is called owner since etherscan
58     //uses this name to recognize the owner of the contract
59     address public owner; //Master address is public
60     mapping(address => uint256) public level; //Admin level
61     bool public lockSupply; //Mint and Burn Lock flag
62     bool public lockTransfer; //Transfer Lock flag
63     address public allowedAddress; //an address that can override lock condition
64 
65     /**
66     * @dev Contract constructor
67     * define initial administrator
68     */
69     constructor() public {
70         owner = 0xA555C90fAaCa8659F1D8EF64281fECBF3Ea3c9af; //Set initial owner to contract creator
71         level[owner] = 2;
72         emit Owned(owner);
73     }
74 
75    /**
76     * @dev Function to set an allowed address
77     * @param _to The address to give privileges.
78     */
79     function setAllowedAddress(address _to) onlyAdmin(2) public {
80         allowedAddress = _to;
81         emit AllowedSet(_to);
82     }
83 
84     modifier onlyAdmin(uint8 _level) { //A modifier to define admin-only functions
85         require(msg.sender == owner || level[msg.sender] >= _level);
86         _;
87     }
88 
89     modifier supplyLock() { //A modifier to lock mint and burn transactions
90         require(lockSupply == false);
91         _;
92     }
93 
94     modifier transferLock() { //A modifier to lock transactions
95         require(lockTransfer == false || allowedAddress == msg.sender);
96         _;
97     }
98 
99    /**
100     * @dev Function to set new owner address
101     * @param _newOwner The address to transfer administration to
102     */
103     function transferOwnership(address _newOwner) onlyAdmin(2) public { //owner can be transfered
104         require(_newOwner != address(0));
105         owner = _newOwner;
106         level[_newOwner] = 2;
107         emit TransferAdminship(owner);
108     }
109 
110     function setAdminLevel(address _target, uint8 _level) onlyAdmin(2) public {
111         level[_target] = _level;
112         emit AdminLevelSet(_target,_level);
113     }
114 
115    /**
116     * @dev Function to set mint and burn locks
117     * @param _set boolean flag (true | false)
118     */
119     function setSupplyLock(bool _set) onlyAdmin(2) public { //Only the admin can set a lock on supply
120         lockSupply = _set;
121         emit SetSupplyLock(_set);
122     }
123 
124    /**
125     * @dev Function to set transfer lock
126     * @param _set boolean flag (true | false)
127     */
128     function setTransferLock(bool _set) onlyAdmin(2) public { //Only the admin can set a lock on transfers
129         lockTransfer = _set;
130         emit SetTransferLock(_set);
131     }
132 
133     //All admin actions have a log for public review
134     event AllowedSet(address _to);
135     event SetSupplyLock(bool _set);
136     event SetTransferLock(bool _set);
137     event TransferAdminship(address newAdminister);
138     event Owned(address administer);
139     event AdminLevelSet(address _target,uint8 _level);
140 
141 }
142 
143 /**
144 * @title Token definition
145 * @dev Define token paramters including ERC20 ones
146 */
147 contract ERC20Token is ERC20TokenInterface, admined { //Standard definition of a ERC20Token
148     using SafeMath for uint256;
149     uint256 public totalSupply;
150     mapping (address => uint256) balances; //A mapping of all balances per address
151     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
152     mapping (address => bool) frozen; //A mapping of frozen accounts
153 
154     /**
155     * @dev Get the balance of an specified address.
156     * @param _owner The address to be query.
157     */
158     function balanceOf(address _owner) public view returns (uint256 value) {
159         return balances[_owner];
160     }
161 
162     /**
163     * @dev transfer token to a specified address
164     * @param _to The address to transfer to.
165     * @param _value The amount to be transferred.
166     */
167     function transfer(address _to, uint256 _value) transferLock public returns (bool success) {
168         require(_to != address(0)); //If you dont want that people destroy token
169         require(frozen[msg.sender]==false);
170         balances[msg.sender] = balances[msg.sender].sub(_value);
171         balances[_to] = balances[_to].add(_value);
172         emit Transfer(msg.sender, _to, _value);
173         return true;
174     }
175 
176     /**
177     * @dev transfer token from an address to another specified address using allowance
178     * @param _from The address where token comes.
179     * @param _to The address to transfer to.
180     * @param _value The amount to be transferred.
181     */
182     function transferFrom(address _from, address _to, uint256 _value) transferLock public returns (bool success) {
183         require(_to != address(0)); //If you dont want that people destroy token
184         require(frozen[_from]==false);
185         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
186         balances[_from] = balances[_from].sub(_value);
187         balances[_to] = balances[_to].add(_value);
188         emit Transfer(_from, _to, _value);
189         return true;
190     }
191 
192     /**
193     * @dev Assign allowance to an specified address to use the owner balance
194     * @param _spender The address to be allowed to spend.
195     * @param _value The amount to be allowed.
196     */
197     function approve(address _spender, uint256 _value) public returns (bool success) {
198         require((_value == 0) || (allowed[msg.sender][_spender] == 0)); //exploit mitigation
199         allowed[msg.sender][_spender] = _value;
200         emit Approval(msg.sender, _spender, _value);
201         return true;
202     }
203 
204     /**
205     * @dev Get the allowance of an specified address to use another address balance.
206     * @param _owner The address of the owner of the tokens.
207     * @param _spender The address of the allowed spender.
208     */
209     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
210         return allowed[_owner][_spender];
211     }
212 
213     /**
214     * @dev Mint token to an specified address.
215     * @param _target The address of the receiver of the tokens.
216     * @param _mintedAmount amount to mint.
217     */
218     function mintToken(address _target, uint256 _mintedAmount) onlyAdmin(2) supplyLock public {
219         balances[_target] = SafeMath.add(balances[_target], _mintedAmount);
220         totalSupply = SafeMath.add(totalSupply, _mintedAmount);
221         emit Transfer(address(0), address(this), _mintedAmount);
222         emit Transfer(address(this), _target, _mintedAmount);
223     }
224 
225     /**
226     * @dev Burn tokens.
227     * @param _burnedAmount amount to burn.
228     */
229     function burnToken(uint256 _burnedAmount) onlyAdmin(2) supplyLock public {
230         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _burnedAmount);
231         totalSupply = SafeMath.sub(totalSupply, _burnedAmount);
232         emit Burned(msg.sender, _burnedAmount);
233     }
234 
235     /**
236     * @dev Frozen account.
237     * @param _target The address to being frozen.
238     * @param _flag The status of the frozen
239     */
240     function setFrozen(address _target,bool _flag) onlyAdmin(2) public {
241         frozen[_target]=_flag;
242         emit FrozenStatus(_target,_flag);
243     }
244 
245 
246     /**
247     * @dev Log Events
248     */
249     event Transfer(address indexed _from, address indexed _to, uint256 _value);
250     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
251     event Burned(address indexed _target, uint256 _value);
252     event FrozenStatus(address _target,bool _flag);
253 }
254 
255 /**
256 * @title Asset
257 * @dev Initial supply creation
258 */
259 contract Asset is ERC20Token {
260     string public name = 'XYZBuys';
261     uint8 public decimals = 18;
262     string public symbol = 'XYZB';
263     string public version = '1';
264 
265     constructor() public {
266         totalSupply = 1000000000 * (10**uint256(decimals)); //initial token creation
267         balances[owner] = totalSupply;
268         emit Transfer(address(0), owner, balances[owner]);
269     }
270 
271     /**
272     * @notice Function to claim ANY token stuck on contract accidentally
273     * In case of claim of stuck tokens please contact contract owners
274     */
275     function claimTokens(token _address, address _to) onlyAdmin(2) public{
276         require(_to != address(0));
277         uint256 remainder = _address.balanceOf(address(this)); //Check remainder tokens
278         _address.transfer(_to,remainder); //Transfer tokens to creator
279     }
280 
281     /**
282     *@dev Function to handle callback calls
283     */
284     function() external {
285         revert();
286     }
287 
288 }