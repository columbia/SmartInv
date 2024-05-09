1 pragma solidity ^0.4.18;
2 /**
3 * Digital Safe Coin
4 * ERC-20 Token Standar Compliant
5 * @author Fares A. Akel C. f.antonio.akel@gmail.com
6 */
7 
8 /**
9  * @title SafeMath by OpenZeppelin
10  * @dev Math operations with safety checks that throw on error
11  */
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
26 /**
27  * Token contract interface for external use
28  */
29 contract ERC20TokenInterface {
30 
31     function balanceOf(address _owner) public constant returns (uint256 balance);
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
56         Admined(admin);
57     }
58 
59    /**
60     * @dev Function to set an allowed address
61     * @param _to The address to give privileges.
62     */
63     function setAllowedAddress(address _to) public {
64         allowedAddress = _to;
65         AllowedSet(_to);
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
88         admin = _newAdmin;
89         TransferAdminship(admin);
90     }
91 
92    /**
93     * @dev Function to set mint and burn locks
94     * @param _set boolean flag (true | false)
95     */
96     function setSupplyLock(bool _set) onlyAdmin public { //Only the admin can set a lock on supply
97         lockSupply = _set;
98         SetSupplyLock(_set);
99     }
100 
101    /**
102     * @dev Function to set transfer lock
103     * @param _set boolean flag (true | false)
104     */
105     function setTransferLock(bool _set) onlyAdmin public { //Only the admin can set a lock on transfers
106         lockTransfer = _set;
107         SetTransferLock(_set);
108     }
109 
110     //All admin actions have a log for public review
111     event AllowedSet(address _to);
112     event SetSupplyLock(bool _set);
113     event SetTransferLock(bool _set);
114     event TransferAdminship(address newAdminister);
115     event Admined(address administer);
116 
117 }
118 
119 /**
120 * @title Token definition
121 * @dev Define token paramters including ERC20 ones
122 */
123 contract ERC20Token is ERC20TokenInterface, admined { //Standar definition of a ERC20Token
124     using SafeMath for uint256;
125     uint256 public totalSupply;
126     mapping (address => uint256) balances; //A mapping of all balances per address
127     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
128     mapping (address => bool) frozen; //A mapping of frozen accounts
129 
130     /**
131     * @dev Get the balance of an specified address.
132     * @param _owner The address to be query.
133     */
134     function balanceOf(address _owner) public constant returns (uint256 balance) {
135       return balances[_owner];
136     }
137 
138     /**
139     * @dev transfer token to a specified address
140     * @param _to The address to transfer to.
141     * @param _value The amount to be transferred.
142     */
143     function transfer(address _to, uint256 _value) transferLock public returns (bool success) {
144         require(_to != address(0)); //If you dont want that people destroy token
145         require(balances[msg.sender] >= _value);
146         require(frozen[msg.sender]==false);
147         balances[msg.sender] = balances[msg.sender].sub(_value);
148         balances[_to] = balances[_to].add(_value);
149         Transfer(msg.sender, _to, _value);
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
161         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
162         require(frozen[_from]==false);
163         balances[_to] = balances[_to].add(_value);
164         balances[_from] = balances[_from].sub(_value);
165         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
166         Transfer(_from, _to, _value);
167         return true;
168     }
169 
170     /**
171     * @dev Assign allowance to an specified address to use the owner balance
172     * @param _spender The address to be allowed to spend.
173     * @param _value The amount to be allowed.
174     */
175     function approve(address _spender, uint256 _value) public returns (bool success) {
176       allowed[msg.sender][_spender] = _value;
177         Approval(msg.sender, _spender, _value);
178         return true;
179     }
180 
181     /**
182     * @dev Get the allowance of an specified address to use another address balance.
183     * @param _owner The address of the owner of the tokens.
184     * @param _spender The address of the allowed spender.
185     */
186     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
187     return allowed[_owner][_spender];
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
198         Transfer(0, this, _mintedAmount);
199         Transfer(this, _target, _mintedAmount);
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
210         Burned(_target, _burnedAmount);
211     }
212 
213     /**
214     * @dev Frozen account.
215     * @param _target The address to being frozen.
216     * @param _flag The status of the frozen
217     */
218     function setFrozen(address _target,bool _flag) onlyAdmin public {
219         frozen[_target]=_flag;
220         FrozenStatus(_target,_flag);
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
238     string public name = 'Digital Safe Coin';
239     uint8 public decimals = 1;
240     string public symbol = 'DSC';
241     string public version = '1';
242 
243     function Asset() public {
244 
245         totalSupply = 500000000 * (10**uint256(decimals));          //500 million initial token creation
246         //Initial Token Distribution
247         //Tokens to creator wallet - For distribution        
248         balances[msg.sender] = 300000000 * (10**uint256(decimals)); //60% for public distribution
249         //Tokens to reserve fund wallet
250         balances[0x9caC17210aAc675E39b7fd6B9182eF5eBe724EC8] = 100000000 * (10**uint256(decimals));//20% for reserve fund
251         //Tokens to team members
252         balances[0x3B41bFA39241CDF7afeF807087774e27fd01a1b2] = 50000000 * (10**uint256(decimals));//10% for team members
253         //Tokens for advisors and others ---------------------------------------------------------//10% For advisors and others* */
254         balances[0xBa52E579C7296A6B45D724CD8163966eEdC5997a] = 49500000 * (10**uint256(decimals));// |---> *9.9% for advisors----|
255         balances[0xFAB6368b0F7be60c573a6562d82469B5ED9e7eE6] = 500000 * (10**uint256(decimals));  // |---> *0.1% for contract writer
256         
257         Transfer(0, this, totalSupply);
258         Transfer(this, msg.sender, balances[msg.sender]);
259         Transfer(this, 0x9caC17210aAc675E39b7fd6B9182eF5eBe724EC8, balances[0x9caC17210aAc675E39b7fd6B9182eF5eBe724EC8]);
260         Transfer(this, 0x3B41bFA39241CDF7afeF807087774e27fd01a1b2, balances[0x3B41bFA39241CDF7afeF807087774e27fd01a1b2]);
261         Transfer(this, 0xBa52E579C7296A6B45D724CD8163966eEdC5997a, balances[0xBa52E579C7296A6B45D724CD8163966eEdC5997a]);
262         Transfer(this, 0xFAB6368b0F7be60c573a6562d82469B5ED9e7eE6, balances[0xFAB6368b0F7be60c573a6562d82469B5ED9e7eE6]);
263     }
264     
265     /**
266     *@dev Function to handle callback calls
267     */
268     function() public {
269         revert();
270     }
271 
272 }