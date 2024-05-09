1 pragma solidity 0.4.24;
2 /**
3 * @title Vivalid Token Contract
4 * @dev ViV is an ERC-20 Standar Compliant Token
5 * For more info https://vivalid.io
6 */
7 
8 /**
9  * @title SafeMath by OpenZeppelin (partially)
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14     /**
15     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
16     */
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     /**
23     * @dev Adds two numbers, throws on overflow.
24     */
25     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
26         c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 /**
33 * @title Admin parameters
34 * @dev Define administration parameters for this contract
35 */
36 contract admined { //This token contract is administered
37     address public admin; //Admin address is public
38     bool public lockSupply; //Burn Lock flag
39 
40     /**
41     * @dev Contract constructor
42     * define initial administrator
43     */
44     constructor() internal {
45         admin = msg.sender; //Set initial admin to contract creator
46         emit Admined(admin);
47     }
48 
49     modifier onlyAdmin() { //A modifier to define admin-only functions
50         require(msg.sender == admin);
51         _;
52     }
53 
54     modifier supplyLock() { //A modifier to lock mint and burn transactions
55         require(lockSupply == false);
56         _;
57     }
58 
59     /**
60     * @dev Function to set new admin address
61     * @param _newAdmin The address to transfer administration to
62     */
63     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
64         require(_newAdmin != 0);
65         admin = _newAdmin;
66         emit TransferAdminship(admin);
67     }
68 
69     /**
70     * @dev Function to set burn lock
71     * This function will be used after the burn process finish
72     */
73     function setSupplyLock(bool _flag) onlyAdmin public { //Only the admin can set a lock on supply
74         lockSupply = _flag;
75         emit SetSupplyLock(lockSupply);
76     }
77 
78     //All admin actions have a log for public review
79     event SetSupplyLock(bool _set);
80     event TransferAdminship(address newAdminister);
81     event Admined(address administer);
82 
83 }
84 
85 /**
86 * @title ERC20 interface
87 * @dev see https://github.com/ethereum/EIPs/issues/20
88 */
89 contract ERC20 {
90     function totalSupply() public view returns (uint256);
91     function balanceOf(address who) public view returns (uint256);
92     function transfer(address to, uint256 value) public returns (bool);
93     function allowance(address owner, address spender) public view returns (uint256);
94     function transferFrom(address from, address to, uint256 value) public returns (bool);
95     function approve(address spender, uint256 value) public returns (bool);
96     event Transfer(address indexed from, address indexed to, uint256 value);
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 
101 /**
102 * @title ERC20Token
103 * @notice Token definition contract
104 */
105 contract ERC20Token is admined, ERC20 { //Standar definition of an ERC20Token
106     using SafeMath for uint256; //SafeMath is used for uint256 operations
107     mapping (address => uint256) internal balances; //A mapping of all balances per address
108     mapping (address => mapping (address => uint256)) internal allowed; //A mapping of all allowances
109     uint256 internal totalSupply_;
110 
111     /**
112     * A mapping of frozen accounts and unfreeze dates
113     *
114     * In case your account balance is fronzen and you 
115     * think it's an error please contact the support team
116     *
117     * This function is only intended to lock specific wallets
118     * as explained on project white paper
119     */
120     mapping (address => bool) frozen;
121     mapping (address => uint256) unfreezeDate;
122 
123     /**
124     * @dev total number of tokens in existence
125     */
126     function totalSupply() public view returns (uint256) {
127         return totalSupply_;
128     }
129     
130     /**
131     * @notice Get the balance of an _who address.
132     * @param _who The address to be query.
133     */
134     function balanceOf(address _who) public view returns (uint256) {
135         return balances[_who];
136     }
137 
138     /**
139     * @notice transfer _value tokens to address _to
140     * @param _to The address to transfer to.
141     * @param _value The amount to be transferred.
142     * @return success with boolean value true if done
143     */
144     function transfer(address _to, uint256 _value) public returns (bool) {
145         require(_to != address(0)); //Invalid transfer
146         require(frozen[msg.sender]==false);
147         balances[msg.sender] = balances[msg.sender].sub(_value);
148         balances[_to] = balances[_to].add(_value);
149         emit Transfer(msg.sender, _to, _value);
150         return true;
151     }
152 
153     /**
154     * @notice Get the allowance of an specified address to use another address balance.
155     * @param _owner The address of the owner of the tokens.
156     * @param _spender The address of the allowed spender.
157     * @return remaining with the allowance value
158     */
159     function allowance(address _owner, address _spender) public view returns (uint256) {
160         return allowed[_owner][_spender];
161     }
162 
163     /**
164     * @notice Transfer _value tokens from address _from to address _to using allowance msg.sender allowance on _from
165     * @param _from The address where tokens comes.
166     * @param _to The address to transfer to.
167     * @param _value The amount to be transferred.
168     * @return success with boolean value true if done
169     */
170     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
171         require(_to != address(0)); //Invalid transfer
172         require(frozen[_from]==false);
173         balances[_from] = balances[_from].sub(_value);
174         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175         balances[_to] = balances[_to].add(_value);
176         emit Transfer(_from, _to, _value);
177         return true;
178     }
179 
180     /**
181     * @notice Assign allowance _value to _spender address to use the msg.sender balance
182     * @param _spender The address to be allowed to spend.
183     * @param _value The amount to be allowed.
184     * @return success with boolean value true
185     */
186     function approve(address _spender, uint256 _value) public returns (bool) {
187         require((_value == 0) || (allowed[msg.sender][_spender] == 0)); //exploit mitigation
188         allowed[msg.sender][_spender] = _value;
189         emit Approval(msg.sender, _spender, _value);
190         return true;
191     }
192 
193     /**
194     * @dev Burn token of an specified address.
195     * @param _burnedAmount amount to burn.
196     */
197     function burnToken(uint256 _burnedAmount) onlyAdmin supplyLock public {
198         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _burnedAmount);
199         totalSupply_ = SafeMath.sub(totalSupply_, _burnedAmount);
200         emit Burned(msg.sender, _burnedAmount);
201     }
202 
203     /**
204     * @dev Frozen account handler
205     * @param _target The address to being frozen.
206     * @param _flag The status of the frozen
207     * @param _timeInDays The amount of time the account becomes locked
208     */
209     function setFrozen(address _target,bool _flag,uint256 _timeInDays) public {
210         if(_flag == true){
211             require(msg.sender == admin); //Only admin
212             require(frozen[_target] == false); //Not already frozen
213             frozen[_target] = _flag;
214             unfreezeDate[_target] = now.add(_timeInDays * 1 days);
215 
216             emit FrozenStatus(_target,_flag,unfreezeDate[_target]);
217 
218         } else {
219             require(now >= unfreezeDate[_target]);
220             frozen[_target] = _flag;
221 
222             emit FrozenStatus(_target,_flag,unfreezeDate[_target]);
223         }
224     }
225 
226     event Burned(address indexed _target, uint256 _value);
227     event FrozenStatus(address indexed _target,bool _flag,uint256 _unfreezeDate);
228 
229 }
230 
231 /**
232 * @title AssetViV
233 * @notice ViV Token creation.
234 * @dev ERC20 Token compliant
235 */
236 contract AssetViV is ERC20Token {
237     string public name = 'VIVALID';
238     uint8 public decimals = 18;
239     string public symbol = 'ViV';
240     string public version = '1';
241 
242     /**
243     * @notice token contructor.
244     */
245     constructor() public {
246         totalSupply_ = 200000000 * 10 ** uint256(decimals); //Initial tokens supply 200M;
247         balances[msg.sender] = totalSupply_;
248         emit Transfer(0, this, totalSupply_);
249         emit Transfer(this, msg.sender, totalSupply_);       
250     }
251 
252     /**
253     * @notice Function to claim ANY token accidentally stuck on contract
254     * In case of claim of stuck tokens please contact contract owners
255     * Tokens to be claimed has to been strictly erc20 compliant
256     * We use the ERC20 interface declared before
257     */
258     function claimTokens(ERC20 _address, address _to) onlyAdmin public{
259         require(_to != address(0));
260         uint256 remainder = _address.balanceOf(this); //Check remainder tokens
261         _address.transfer(_to,remainder); //Transfer tokens to creator
262     }
263 
264     
265     /**
266     * @notice this contract will revert on direct non-function calls, also it's not payable
267     * @dev Function to handle callback calls to contract
268     */
269     function() public {
270         revert();
271     }
272 
273 }