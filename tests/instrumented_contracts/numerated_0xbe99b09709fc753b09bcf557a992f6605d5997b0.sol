1 pragma solidity ^0.4.18;
2 /**
3 * TOKEN Contract
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
28  * Token contract interface for external use
29  */
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
40 
41 /**
42 * @title Admin parameters
43 * @dev Define administration parameters for this contract
44 */
45 contract admined { //This token contract is administered
46     address public admin; //Admin address is public
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
73     modifier transferLock() { //A modifier to lock transactions
74         require(lockTransfer == false || allowedAddress == msg.sender);
75         _;
76     }
77 
78    /**
79     * @dev Function to set new admin address
80     * @param _newAdmin The address to transfer administration to
81     */
82     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
83         require(_newAdmin != 0);
84         admin = _newAdmin;
85         TransferAdminship(admin);
86     }
87 
88    /**
89     * @dev Function to set transfer lock
90     * @param _set boolean flag (true | false)
91     */
92     function setTransferLock(bool _set) onlyAdmin public { //Only the admin can set a lock on transfers
93         lockTransfer = _set;
94         SetTransferLock(_set);
95     }
96 
97     //All admin actions have a log for public review
98     event AllowedSet(address _to);
99     event SetTransferLock(bool _set);
100     event TransferAdminship(address newAdminister);
101     event Admined(address administer);
102 
103 }
104 
105 /**
106 * @title Token definition
107 * @dev Define token paramters including ERC20 ones
108 */
109 contract ERC20Token is ERC20TokenInterface, admined { //Standard definition of a ERC20Token
110     using SafeMath for uint256;
111     uint256 public totalSupply;
112     mapping (address => uint256) balances; //A mapping of all balances per address
113     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
114     mapping (address => bool) frozen; //A mapping of frozen accounts
115 
116     /**
117     * @dev Get the balance of an specified address.
118     * @param _owner The address to be query.
119     */
120     function balanceOf(address _owner) public constant returns (uint256 value) {
121       return balances[_owner];
122     }
123 
124     /**
125     * @dev transfer token to a specified address
126     * @param _to The address to transfer to.
127     * @param _value The amount to be transferred.
128     */
129     function transfer(address _to, uint256 _value) transferLock public returns (bool success) {
130         require(_to != address(0)); //If you dont want that people destroy token
131         require(frozen[msg.sender]==false);
132         balances[msg.sender] = balances[msg.sender].sub(_value);
133         balances[_to] = balances[_to].add(_value);
134         Transfer(msg.sender, _to, _value);
135         return true;
136     }
137 
138     /**
139     * @dev transfer token from an address to another specified address using allowance
140     * @param _from The address where token comes.
141     * @param _to The address to transfer to.
142     * @param _value The amount to be transferred.
143     */
144     function transferFrom(address _from, address _to, uint256 _value) transferLock public returns (bool success) {
145         require(_to != address(0)); //If you dont want that people destroy token
146         require(frozen[_from]==false);
147         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
148         balances[_from] = balances[_from].sub(_value);
149         balances[_to] = balances[_to].add(_value);
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
184     /**
185     * @dev Burn token of an specified address.
186     * @param _burnedAmount amount to burn.
187     */
188     function burnToken(uint256 _burnedAmount) onlyAdmin public {
189         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _burnedAmount);
190         totalSupply = SafeMath.sub(totalSupply, _burnedAmount);
191         Burned(msg.sender, _burnedAmount);
192     }
193 
194 
195     /**
196     * @dev Log Events
197     */
198     event Transfer(address indexed _from, address indexed _to, uint256 _value);
199     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
200     event Burned(address indexed _target, uint256 _value);
201     event FrozenStatus(address _target,bool _flag);
202 }
203 
204 /**
205 * @title Asset
206 * @dev Initial supply creation
207 */
208 contract Asset is ERC20Token {
209     string public name = 'SMARTRealty';
210     uint8 public decimals = 8;
211     string public symbol = 'RLTY';
212     string public version = '1'; 
213 
214     address DevExecutiveAdvisorTeams= 0xF9568bd772C9B517193275b3C2E0CDAd38E586bB;
215     address SMARTRealtyEconomy= 0x07ADB1D9399Bd1Fa4fD613D3179DFE883755Bb13;
216     address Marketing= 0xd35909DbeEb5255D65b1ea14602C7f00ce3872f6;
217     address SMARTMortgages= 0x9D2Fe4D5f1dc4FcA1f0Ea5f461C9fAA5D09b9CCE;
218     address Administer= 0x8Bb41848B6dD3D98b8849049b780dC3549568c89;
219     address Contractors= 0xC78DF195DE5717FB15FB3448D5C6893E8e7fB254;
220     address Legal= 0x4690678926BCf9B30985c06806d4568C0C498123;
221     address BountiesandGiveaways= 0x08AF803F0F90ccDBFCe046Bc113822cFf415e148;
222     address CharitableUse= 0x8661dFb67dE4E5569da9859f5CB4Aa676cd5F480;
223 
224 
225     function Asset() public {
226 
227         totalSupply = 500000000 * (10**uint256(decimals)); //initial token creation
228         Transfer(0, this, totalSupply);
229 
230         //20% Presale+20% ICO
231         balances[msg.sender] = 200000000 * (10**uint256(decimals));
232         Transfer(this, msg.sender, balances[msg.sender]);        
233 
234         //10%
235         balances[DevExecutiveAdvisorTeams] = 50000000 * (10**uint256(decimals));
236         Transfer(this, DevExecutiveAdvisorTeams, balances[DevExecutiveAdvisorTeams]);
237 
238         //10%
239         balances[SMARTRealtyEconomy] = 50000000 * (10**uint256(decimals));
240         Transfer(this, SMARTRealtyEconomy, balances[SMARTRealtyEconomy]);
241 
242         //10%
243         balances[Marketing] = 50000000 * (10**uint256(decimals));
244         Transfer(this, Marketing, balances[Marketing]);
245 
246         //10%
247         balances[SMARTMortgages] = 50000000 * (10**uint256(decimals));
248         Transfer(this, SMARTMortgages, balances[SMARTMortgages]);
249         
250         //5%
251         balances[Administer] = 25000000 * (10**uint256(decimals));
252         Transfer(this, Administer, balances[Administer]);
253 
254         //5%
255         balances[Contractors] = 25000000 * (10**uint256(decimals));
256         Transfer(this, Contractors, balances[Contractors]);
257 
258         //5%
259         balances[Legal] = 25000000 * (10**uint256(decimals));
260         Transfer(this, Legal, balances[Legal]);
261 
262         //4%
263         balances[BountiesandGiveaways] =  20000000 * (10**uint256(decimals));
264         Transfer(this, BountiesandGiveaways, balances[BountiesandGiveaways]);
265 
266         //1%
267         balances[CharitableUse] = 5000000  * (10**uint256(decimals));
268         Transfer(this, CharitableUse, balances[CharitableUse]);
269 
270     }
271     
272     /**
273     *@dev Function to handle callback calls
274     */
275     function() public {
276         revert();
277     }
278 
279 }