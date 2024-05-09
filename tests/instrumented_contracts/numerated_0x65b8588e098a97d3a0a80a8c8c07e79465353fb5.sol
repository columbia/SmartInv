1 pragma solidity 0.5.6;
2 /**
3  * TOKEN Contract
4  * ERC-20 Token Standard Compliant
5  */
6 
7 /**
8  * @title SafeMath by OpenZeppelin
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
14         assert(b <= a);
15         return a - b;
16     }
17 
18     function add(uint256 a, uint256 b) internal pure returns(uint256) {
19         uint256 c = a + b;
20         assert(c >= a);
21         return c;
22     }
23 
24 }
25 
26 /**
27  * @title ERC20 Token minimal interface
28  */
29 interface extToken {
30 
31     function balanceOf(address _owner) external returns(uint256 balance);
32 
33     function transfer(address _to, uint256 _value) external returns(bool success);
34 
35 }
36 
37 /**
38  * Token contract declaration
39  */
40 contract ERC20TokenInterface {
41 
42     function balanceOf(address _owner) public view returns(uint256 value);
43 
44     function transfer(address _to, uint256 _value) public returns(bool success);
45 
46     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);
47 
48     function approve(address _spender, uint256 _value) public returns(bool success);
49 
50     function allowance(address _owner, address _spender) public view returns(uint256 remaining);
51 
52 }
53 
54 
55 /**
56  * @title Admin parameters
57  * @dev Define administration parameters for this contract
58  */
59 contract admined { //This token contract is administered
60     //The master address of the contract is called owner since etherscan
61     //uses this name to recognize the owner of the contract
62     address public owner; //Master address is public
63     mapping(address => uint256) public level; //Admin level
64     bool public lockSupply; //Burn Lock flag
65     bool public lockTransfer; //Transfer Lock flag
66     address public allowedAddress; //An address that can override lock condition
67 
68     /**
69      * @dev Contract constructor
70      * define initial administrator
71      */
72     constructor() public {
73         owner = 0xb4549c4CBbB5003beEb2b70098E6f5AD4CE4c2e6; //Set initial owner to contract creator
74         level[0xb4549c4CBbB5003beEb2b70098E6f5AD4CE4c2e6] = 2;
75         emit Owned(owner);
76     }
77 
78     /**
79      * @dev Function to set an allowed address
80      * @param _to The address to give privileges.
81      */
82     function setAllowedAddress(address _to) onlyAdmin(2) public {
83         allowedAddress = _to;
84         emit AllowedSet(_to);
85     }
86 
87     modifier onlyAdmin(uint8 _level) { //A modifier to define admin-only functions
88         require(msg.sender == owner || level[msg.sender] >= _level);
89         _;
90     }
91 
92     modifier supplyLock() { //A modifier to lock burn transactions
93         require(lockSupply == false);
94         _;
95     }
96 
97     modifier transferLock() { //A modifier to lock transactions
98         require(lockTransfer == false || allowedAddress == msg.sender);
99         _;
100     }
101 
102     /**
103      * @dev Function to set new owner address
104      * @param _newOwner The address to transfer administration to
105      */
106     function transferOwnership(address _newOwner) onlyAdmin(2) public { //owner can be transfered
107         require(_newOwner != address(0));
108         owner = _newOwner;
109         level[_newOwner] = 2;
110         emit TransferAdminship(owner);
111     }
112 
113     function setAdminLevel(address _target, uint8 _level) onlyAdmin(2) public {
114         level[_target] = _level;
115         emit AdminLevelSet(_target, _level);
116     }
117 
118     /**
119      * @dev Function to set burn locks
120      * @param _set boolean flag (true | false)
121      */
122     function setSupplyLock(bool _set) onlyAdmin(2) public { //Only the admin can set a lock on supply
123         lockSupply = _set;
124         emit SetSupplyLock(_set);
125     }
126 
127     /**
128      * @dev Function to set global transfer lock
129      * @param _set boolean flag (true | false)
130      */
131     function setTransferLock(bool _set) onlyAdmin(2) public { //Only the admin can set a lock on transfers
132         lockTransfer = _set;
133         emit SetTransferLock(_set);
134     }
135 
136     //All admin actions have a log for public review
137     event AllowedSet(address _to);
138     event SetSupplyLock(bool _set);
139     event SetTransferLock(bool _set);
140     event TransferAdminship(address newAdminister);
141     event Owned(address administer);
142     event AdminLevelSet(address _target, uint8 _level);
143 
144 }
145 
146 /**
147  * @title Token definition
148  * @dev Define token paramters including ERC20 ones
149  */
150 contract ERC20Token is ERC20TokenInterface, admined { //Standard definition of a ERC20Token
151     using SafeMath
152     for uint256;
153     uint256 public totalSupply;
154     mapping(address => uint256) balances; //A mapping of all balances per address
155     mapping(address => mapping(address => uint256)) allowed; //A mapping of all allowances
156     mapping(address => bool) frozen; //A mapping of frozen accounts
157 
158     /**
159      * @dev Get the balance of an specified address.
160      * @param _owner The address to be query.
161      */
162     function balanceOf(address _owner) public view returns(uint256 value) {
163         return balances[_owner];
164     }
165 
166     /**
167      * @dev transfer token to a specified address
168      * @param _to The address to transfer to.
169      * @param _value The amount to be transferred.
170      */
171     function transfer(address _to, uint256 _value) transferLock public returns(bool success) {
172         require(frozen[msg.sender] == false);
173         balances[msg.sender] = balances[msg.sender].sub(_value);
174         balances[_to] = balances[_to].add(_value);
175         emit Transfer(msg.sender, _to, _value);
176         return true;
177     }
178 
179     /**
180      * @dev transfer token from an address to another specified address using allowance
181      * @param _from The address where token comes.
182      * @param _to The address to transfer to.
183      * @param _value The amount to be transferred.
184      */
185     function transferFrom(address _from, address _to, uint256 _value) transferLock public returns(bool success) {
186         require(frozen[_from] == false);
187         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
188         balances[_from] = balances[_from].sub(_value);
189         balances[_to] = balances[_to].add(_value);
190         emit Transfer(_from, _to, _value);
191         return true;
192     }
193 
194     /**
195      * @dev Assign allowance to an specified address to use the owner balance
196      * @param _spender The address to be allowed to spend.
197      * @param _value The amount to be allowed.
198      */
199     function approve(address _spender, uint256 _value) public returns(bool success) {
200         allowed[msg.sender][_spender] = _value;
201         emit Approval(msg.sender, _spender, _value);
202         return true;
203     }
204 
205     /**
206      * @dev Get the allowance of an specified address to use another address balance.
207      * @param _owner The address of the owner of the tokens.
208      * @param _spender The address of the allowed spender.
209      */
210     function allowance(address _owner, address _spender) public view returns(uint256 remaining) {
211         return allowed[_owner][_spender];
212     }
213 
214     /**
215      * @dev Burn token of an specified address.
216      * @param _burnedAmount amount to burn.
217      */
218     function burnToken(uint256 _burnedAmount) onlyAdmin(2) supplyLock public {
219         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _burnedAmount);
220         totalSupply = SafeMath.sub(totalSupply, _burnedAmount);
221         emit Burned(msg.sender, _burnedAmount);
222     }
223 
224     /**
225      * @dev Frozen account.
226      * @param _target The address to being frozen.
227      * @param _flag The status of the frozen
228      */
229     function setFrozen(address _target, bool _flag) onlyAdmin(2) public {
230         frozen[_target] = _flag;
231         emit FrozenStatus(_target, _flag);
232     }
233 
234 
235     /**
236      * @dev Log Events
237      */
238     event Transfer(address indexed _from, address indexed _to, uint256 _value);
239     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
240     event Burned(address indexed _target, uint256 _value);
241     event FrozenStatus(address _target, bool _flag);
242 }
243 
244 /**
245  * @title Asset
246  * @dev Initial supply creation
247  */
248 contract Asset is ERC20Token {
249     string public name = 'ORIGIN Foundation Token';
250     uint8 public decimals = 18;
251     string public symbol = 'ORIGIN';
252     string public version = '1';
253 
254     constructor() public {
255         totalSupply = 100000000000 * (10 ** uint256(decimals)); //initial token creation
256         balances[0xb4549c4CBbB5003beEb2b70098E6f5AD4CE4c2e6] = totalSupply;
257         emit Transfer(address(0), 0xb4549c4CBbB5003beEb2b70098E6f5AD4CE4c2e6, balances[0xb4549c4CBbB5003beEb2b70098E6f5AD4CE4c2e6]);
258     }
259 
260     /**
261      * @notice Function to claim ANY token stuck on contract accidentally
262      * In case of claim of stuck tokens please contact contract owners
263      */
264     function claimExtTokens(extToken _address, address _to) onlyAdmin(2) public {
265         require(_to != address(0));
266         uint256 remainder = _address.balanceOf(address(this)); //Check remainder tokens
267         _address.transfer(_to, remainder); //Transfer tokens to creator
268     }
269 
270     /**
271      *@dev Function to handle callback calls
272      */
273     function () external {
274         revert();
275     }
276 
277 }