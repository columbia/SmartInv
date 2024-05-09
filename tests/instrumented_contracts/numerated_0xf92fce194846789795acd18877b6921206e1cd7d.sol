1 pragma solidity 0.4.25;
2 /**
3 * PRIWGR TOKEN Contract
4 * ERC-20 Token Standard Compliant
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
26 
27 /**
28 * @title ERC20 Token minimal interface
29 */
30 contract token {
31 
32     function balanceOf(address _owner) public constant returns (uint256 balance);
33     //Since some tokens doesn't return a bool on transfer, this general interface
34     //doesn't include a return on the transfer fucntion to be widely compatible
35     function transfer(address _to, uint256 _value) public;
36 
37 }
38 
39 /**
40  * Token contract interface for external use
41  */
42 contract ERC20TokenInterface {
43 
44     function balanceOf(address _owner) public constant returns (uint256 value);
45     function transfer(address _to, uint256 _value) public returns (bool success);
46     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
47     function approve(address _spender, uint256 _value) public returns (bool success);
48     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
49 
50     }
51 
52 
53 /**
54 * @title Admin parameters
55 * @dev Define administration parameters for this contract
56 */
57 contract admined { //This token contract is administered
58     //The master address of the contract is called owner since etherscan
59     //uses this name to recognize the owner of the contract
60     address public owner; //Master address is public
61     mapping(address => uint256) public level; //Admin level
62     bool public lockSupply; //Mint and Burn Lock flag
63 
64     /**
65     * @dev Contract constructor
66     * define initial administrator
67     */
68     constructor() public {
69         owner = msg.sender; //Set initial owner to contract creator
70         level[msg.sender] = 2;
71         emit Owned(owner);
72     }
73 
74     modifier onlyAdmin(uint8 _level) { //A modifier to define admin-only functions
75         require(msg.sender == owner || level[msg.sender] >= _level);
76         _;
77     }
78 
79     modifier supplyLock() { //A modifier to lock mint and burn transactions
80         require(lockSupply == false);
81         _;
82     }
83 
84    /**
85     * @dev Function to set new owner address
86     * @param _newOwner The address to transfer administration to
87     */
88     function transferOwnership(address _newOwner) onlyAdmin(2) public { //owner can be transfered
89         require(_newOwner != address(0));
90         owner = _newOwner;
91         level[_newOwner] = 2;
92         emit TransferAdminship(owner);
93     }
94 
95     function setAdminLevel(address _target, uint8 _level) onlyAdmin(2) public {
96         level[_target] = _level;
97         emit AdminLevelSet(_target,_level);
98     }
99 
100    /**
101     * @dev Function to set mint and burn locks
102     * @param _set boolean flag (true | false)
103     */
104     function setSupplyLock(bool _set) onlyAdmin(2) public { //Only the admin can set a lock on supply
105         lockSupply = _set;
106         emit SetSupplyLock(_set);
107     }
108 
109     //All admin actions have a log for public review
110     event SetSupplyLock(bool _set);
111     event TransferAdminship(address newAdminister);
112     event Owned(address administer);
113     event AdminLevelSet(address _target,uint8 _level);
114 
115 }
116 
117 /**
118 * @title Token definition
119 * @dev Define token paramters including ERC20 ones
120 */
121 contract ERC20Token is ERC20TokenInterface, admined { //Standard definition of a ERC20Token
122     using SafeMath for uint256;
123     uint256 public totalSupply;
124     mapping (address => uint256) balances; //A mapping of all balances per address
125     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
126 
127     /**
128     * @dev Get the balance of an specified address.
129     * @param _owner The address to be query.
130     */
131     function balanceOf(address _owner) public constant returns (uint256 value) {
132         return balances[_owner];
133     }
134 
135     /**
136     * @dev transfer token to a specified address
137     * @param _to The address to transfer to.
138     * @param _value The amount to be transferred.
139     */
140     function transfer(address _to, uint256 _value) public returns (bool success) {
141         require(_to != address(0)); //If you dont want that people destroy token
142         balances[msg.sender] = balances[msg.sender].sub(_value);
143         balances[_to] = balances[_to].add(_value);
144         emit Transfer(msg.sender, _to, _value);
145         return true;
146     }
147 
148     /**
149     * @dev transfer token from an address to another specified address using allowance
150     * @param _from The address where token comes.
151     * @param _to The address to transfer to.
152     * @param _value The amount to be transferred.
153     */
154     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
155         require(_to != address(0)); //If you dont want that people destroy token
156         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
157         balances[_from] = balances[_from].sub(_value);
158         balances[_to] = balances[_to].add(_value);
159         emit Transfer(_from, _to, _value);
160         return true;
161     }
162 
163     /**
164     * @dev Assign allowance to an specified address to use the owner balance
165     * @param _spender The address to be allowed to spend.
166     * @param _value The amount to be allowed.
167     */
168     function approve(address _spender, uint256 _value) public returns (bool success) {
169         require((_value == 0) || (allowed[msg.sender][_spender] == 0)); //exploit mitigation
170         allowed[msg.sender][_spender] = _value;
171         emit Approval(msg.sender, _spender, _value);
172         return true;
173     }
174 
175     /**
176     * @dev Get the allowance of an specified address to use another address balance.
177     * @param _owner The address of the owner of the tokens.
178     * @param _spender The address of the allowed spender.
179     */
180     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
181         return allowed[_owner][_spender];
182     }
183 
184     /**
185     * @dev Burn tokens.
186     * @param _burnedAmount amount to burn.
187     */
188     function burnToken(uint256 _burnedAmount) onlyAdmin(2) supplyLock public {
189         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _burnedAmount);
190         totalSupply = SafeMath.sub(totalSupply, _burnedAmount);
191         emit Burned(msg.sender, _burnedAmount);
192     }
193 
194 
195     /**
196     * @dev Log Events
197     */
198     event Transfer(address indexed _from, address indexed _to, uint256 _value);
199     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
200     event Burned(address indexed _target, uint256 _value);
201 }
202 
203 /**
204 * @title Asset
205 * @dev Initial supply creation
206 */
207 contract Asset is ERC20Token {
208     string public name = 'Pri-Sale Wager Token';
209     uint8 public decimals = 18;
210     string public symbol = 'PRIWGR';
211     string public version = '1';
212 
213     constructor() public {
214         totalSupply = 10000000 * (10**uint256(decimals)); //initial token creation
215         balances[msg.sender] = totalSupply;
216         emit Transfer(address(0), msg.sender, balances[msg.sender]);
217     }
218 
219     /**
220     * @notice Function to claim ANY token stuck on contract accidentally
221     * In case of claim of stuck tokens please contact contract owners
222     */
223     function claimTokens(token _address, address _to) onlyAdmin(2) public{
224         require(_to != address(0));
225         uint256 remainder = _address.balanceOf(this); //Check remainder tokens
226         _address.transfer(_to,remainder); //Transfer tokens to creator
227     }
228 
229     /**
230     *@dev Function to handle callback calls
231     */
232     function() public {
233         revert();
234     }
235 
236 }