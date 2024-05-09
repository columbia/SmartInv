1 pragma solidity 0.4.24;
2 /**
3 * MTC TOKEN Contract
4 * ERC-20 Token Standard Compliant
5 * Mega Trade Club
6 */
7 
8 /**
9  * @title SafeMath by OpenZeppelin
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14   /**
15   * @dev Multiplies two numbers, throws on overflow.
16   */
17   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18     if (a == 0) {
19       return 0;
20     }
21     uint256 c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36   /**
37   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256) {
48     uint256 c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 /**
55  * Token contract interface for external use
56  */
57 contract ERC20TokenInterface {
58 
59     function balanceOf(address _owner) public constant returns (uint256 value);
60     function transfer(address _to, uint256 _value) public returns (bool success);
61     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
62     function approve(address _spender, uint256 _value) public returns (bool success);
63     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
64 
65     }
66 
67 
68 /**
69 * @title Admin parameters
70 * @dev Define administration parameters for this contract
71 */
72 contract admined { //This token contract is administered
73     address public admin; //Master address is public
74     mapping(address => uint256) public level; //Admin level
75 
76     /**
77     * @dev Contract constructor
78     * define initial administrator
79     */
80     constructor() public {
81         admin = msg.sender; //Set initial admin to contract creator
82         level[msg.sender] = 2;
83         emit Admined(admin);
84     }
85 
86     modifier onlyAdmin(uint8 _level) { //A modifier to define admin-only functions
87         require(msg.sender == admin || level[msg.sender] >= _level);
88         _;
89     }
90 
91    /**
92     * @dev Function to set new admin address
93     * @param _newAdmin The address to transfer administration to
94     */
95     function transferAdminship(address _newAdmin) onlyAdmin(2) public { //Admin can be transfered
96         require(_newAdmin != address(0));
97         admin = _newAdmin;
98         level[_newAdmin] = 2;
99         emit TransferAdminship(admin);
100     }
101 
102     function setAdminLevel(address _target, uint8 _level) onlyAdmin(2) public {
103         level[_target] = _level;
104         emit AdminLevelSet(_target,_level);
105     }
106 
107     //All admin actions have a log for public review
108     event TransferAdminship(address newAdminister);
109     event Admined(address administer);
110     event AdminLevelSet(address _target,uint8 _level);
111 
112 }
113 
114 /**
115 * @title Token definition
116 * @dev Define token paramters including ERC20 ones
117 */
118 contract ERC20Token is ERC20TokenInterface, admined { //Standard definition of a ERC20Token
119     using SafeMath for uint256;
120     uint256 public totalSupply;
121     mapping (address => uint256) balances; //A mapping of all balances per address
122     mapping (address => mapping (address => uint256)) allowed; //A mapping of all allowances
123 
124     /**
125     * @dev Get the balance of an specified address.
126     * @param _owner The address to be query.
127     */
128     function balanceOf(address _owner) public constant returns (uint256 value) {
129         return balances[_owner];
130     }
131 
132     /**
133     * @dev transfer token to a specified address
134     * @param _to The address to transfer to.
135     * @param _value The amount to be transferred.
136     */
137     function transfer(address _to, uint256 _value) public returns (bool success) {
138         require(_to != address(0)); //If you dont want that people destroy token
139         balances[msg.sender] = balances[msg.sender].sub(_value);
140         balances[_to] = balances[_to].add(_value);
141         emit Transfer(msg.sender, _to, _value);
142         return true;
143     }
144 
145     /**
146     * @dev transfer token from an address to another specified address using allowance
147     * @param _from The address where token comes.
148     * @param _to The address to transfer to.
149     * @param _value The amount to be transferred.
150     */
151     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
152         require(_to != address(0)); //If you dont want that people destroy token
153         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
154         balances[_from] = balances[_from].sub(_value);
155         balances[_to] = balances[_to].add(_value);
156         emit Transfer(_from, _to, _value);
157         return true;
158     }
159 
160     /**
161     * @dev Assign allowance to an specified address to use the owner balance
162     * @param _spender The address to be allowed to spend.
163     * @param _value The amount to be allowed.
164     */
165     function approve(address _spender, uint256 _value) public returns (bool success) {
166         require((_value == 0) || (allowed[msg.sender][_spender] == 0)); //exploit mitigation
167         allowed[msg.sender][_spender] = _value;
168         emit Approval(msg.sender, _spender, _value);
169         return true;
170     }
171 
172     /**
173     * @dev Get the allowance of an specified address to use another address balance.
174     * @param _owner The address of the owner of the tokens.
175     * @param _spender The address of the allowed spender.
176     */
177     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
178         return allowed[_owner][_spender];
179     }
180 
181     /**
182     * @dev Log Events
183     */
184     event Transfer(address indexed _from, address indexed _to, uint256 _value);
185     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
186 }
187 
188 /**
189 * @title 
190 * @dev Initial supply creation
191 */
192 contract AssetMTC is ERC20Token {
193     string public name = 'Mega Trade Club';
194     uint8 public decimals = 18;
195     string public symbol = 'MTC';
196     string public version = '1';
197 
198     constructor() public {
199         totalSupply = 20000000 * (10**uint256(decimals)); //initial token creation
200         balances[msg.sender] = totalSupply;
201         emit Transfer(address(0), msg.sender, balances[msg.sender]);
202     }
203 
204     function buy() public payable {
205 
206       require(msg.value >= 0.1 ether);
207 
208       uint256 tokenBought = msg.value.mul(10);
209 
210       require(this.transferFrom(admin, msg.sender, tokenBought));
211 
212     }
213 
214     function claimEth() onlyAdmin(2) public {
215 
216       admin.transfer(address(this).balance);
217 
218     }
219 
220     /**
221     *@dev Function to handle callback calls
222     */
223     function() public payable {
224         buy();
225     }
226 
227 }