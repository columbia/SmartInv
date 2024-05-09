1 pragma solidity ^0.4.20;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 /**
46  * @title Ownable
47  * @dev The Ownable contract has an owner address, and provides basic authorization control
48  * functions, this simplifies the implementation of "user permissions".
49  */
50 
51 /**
52  * Token contract interface for external use
53  */
54 contract ERC20TokenInterface {
55 
56     function balanceOf(address _owner) public constant returns (uint256 value);
57     function transfer(address _to, uint256 _value) public returns (bool success);
58     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
59     function approve(address _spender, uint256 _value) public returns (bool success);
60     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
61 
62     }
63 
64 
65 /**
66 * @title Admin parameters
67 * @dev Define administration parameters for this contract
68 */
69 contract admined { //This token contract is administered
70     address public admin; //Admin address is public
71     address public allowedAddress; //an address that can override lock condition
72 
73     /**
74     * @dev Contract constructor
75     * define initial administrator
76     */
77     function admined() internal {
78         admin = msg.sender; //Set initial admin to contract creator
79         Admined(admin);
80     }
81 
82    /**
83     * @dev Function to set an allowed address
84     * @param _to The address to give privileges.
85     */
86     function setAllowedAddress(address _to) onlyAdmin public {
87         allowedAddress = _to;
88         AllowedSet(_to);
89     }
90 
91     modifier onlyAdmin() { //A modifier to define admin-only functions
92         require(msg.sender == admin);
93         _;
94     }
95 
96     modifier crowdsaleonly() { //A modifier to lock transactions
97         require(allowedAddress == msg.sender);
98         _;
99     }
100 
101    /**
102     * @dev Function to set new admin address
103     * @param _newAdmin The address to transfer administration to
104     */
105     function transferAdminship(address _newAdmin) onlyAdmin public { //Admin can be transfered
106         require(_newAdmin != 0);
107         admin = _newAdmin;
108         TransferAdminship(admin);
109     }
110 
111 
112     //All admin actions have a log for public review
113     event AllowedSet(address _to);
114     event TransferAdminship(address newAdminister);
115     event Admined(address administer);
116 
117 }
118 
119 /**
120 * @title Token definition
121 * @dev Define token paramters including ERC20 ones
122 */
123 contract ERC20Token is ERC20TokenInterface, admined { //Standard definition of a ERC20Token
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
134     function balanceOf(address _owner) public constant returns (uint256 value) {
135         return balances[_owner];
136     }
137 
138     /**
139     * @dev transfer token to a specified address
140     * @param _to The address to transfer to.
141     * @param _value The amount to be transferred.
142     */
143     function transfer(address _to, uint256 _value)  public returns (bool success) {
144         require(_to != address(0)); //If you dont want that people destroy token
145         require(frozen[msg.sender]==false);
146         balances[msg.sender] = balances[msg.sender].sub(_value);
147         balances[_to] = balances[_to].add(_value);
148         Transfer(msg.sender, _to, _value);
149         return true;
150     }
151 
152     /**
153     * @dev transfer token from an address to another specified address using allowance
154     * @param _from The address where token comes.
155     * @param _to The address to transfer to.
156     * @param _value The amount to be transferred.
157     */
158     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success) {
159         require(_to != address(0)); //If you dont want that people destroy token
160         require(frozen[_from]==false);
161         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
162         balances[_from] = balances[_from].sub(_value);
163         balances[_to] = balances[_to].add(_value);
164         Transfer(_from, _to, _value);
165         return true;
166     }
167 
168     /**
169     * @dev Assign allowance to an specified address to use the owner balance
170     * @param _spender The address to be allowed to spend.
171     * @param _value The amount to be allowed.
172     */
173     function approve(address _spender, uint256 _value) public returns (bool success) {
174         require((_value == 0) || (allowed[msg.sender][_spender] == 0)); //exploit mitigation
175         allowed[msg.sender][_spender] = _value;
176         Approval(msg.sender, _spender, _value);
177         return true;
178     }
179 
180     /**
181     * @dev Get the allowance of an specified address to use another address balance.
182     * @param _owner The address of the owner of the tokens.
183     * @param _spender The address of the allowed spender.
184     */
185     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
186         return allowed[_owner][_spender];
187     }
188 
189     /**
190     * @dev Log Events
191     */
192     event Transfer(address indexed _from, address indexed _to, uint256 _value);
193     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
194 
195 }
196 
197 /**
198 * @title Asset
199 * @dev Initial supply creation
200 */
201 contract EKK is ERC20Token {
202 
203     string public name = 'EKK Token';
204     uint8 public decimals = 18;
205     string public symbol = 'EKK';
206     string public version = '1';
207     uint256 public totalSupply = 2000000000 * 10**uint256(decimals);      //initial token creation
208     uint256 public publicAllocation = 1000000000 * 10 ** uint(decimals);  // 50%  Token sales & Distribution
209     uint256 public growthReserve = 700000000 * 10 ** uint(decimals);      // 35%  Platform Growth Reserve
210     uint256 public marketingAllocation= 100000000 * 10 ** uint(decimals);  // 5%   Markting/Promotion
211     uint256 public teamAllocation = 160000000 *10 ** uint(decimals);      // 8%   Team
212     uint256 public advisorsAllocation = 40000000 * 10 ** uint(decimals);            // 2%   Advisors
213     //address public owner;
214     function EKK() public {
215 
216         balances[this] = totalSupply;
217 
218         Transfer(0, this, totalSupply);
219         Transfer(this, msg.sender, balances[msg.sender]);
220     }
221 
222     /**
223     *@dev Function to handle callback calls
224     */
225     function() public {
226         revert();
227     }
228 
229     /**
230     * @dev Get publicAllocation
231     */
232     function getPublicAllocation() public view returns (uint256 value) {
233         return publicAllocation;
234     }
235    /**
236     * @dev setOwner for EKKcrowdsale contract only
237     */
238     // function setOwner(address _owner) onlyAdmin public {
239     //   owner = _owner;
240     // }
241       /**
242  *  transfer, only can be called by crowdsale contract
243  */
244     function transferFromPublicAllocation(address _to, uint256 _value) crowdsaleonly public returns (bool success) {
245         // Prevent transfer to 0x0 address. Use burn() instead
246         require(_to != 0x0);
247         // Check if the sender has enough
248         require(balances[this] >= _value && publicAllocation >= _value);
249         // Check for overflows
250         require(balances[_to] + _value > balances[_to]);
251         // Save this for an assertion in the future
252         uint previousBalances = balances[this].add(balances[_to]);
253         // Subtract from the sender
254         balances[this] = balances[this].sub(_value);
255         publicAllocation = publicAllocation.sub(_value);
256         // Add the same to the recipient
257         balances[_to] = balances[_to].add(_value);
258         Transfer(this, _to, _value);
259         // Asserts are used to use static analysis to find bugs in your code. They should never fail
260         assert(balances[this] + balances[_to] == previousBalances);
261         return true;
262     }
263 
264     function growthReserveTokenSend(address to, uint256 _value) onlyAdmin public  {
265         uint256 value = _value * 10 ** uint(decimals);
266         require(to != 0x0 && growthReserve >= value);
267         balances[this] = balances[this].sub(value);
268         balances[to] = balances[to].add(value);
269         growthReserve = growthReserve.sub(value);
270         Transfer(this, to, value);
271     }
272 
273     function marketingAllocationTokenSend(address to, uint256 _value) onlyAdmin public  {
274         uint256 value = _value * 10 ** uint(decimals);
275         require(to != 0x0 && marketingAllocation >= value);
276         balances[this] = balances[this].sub(value);
277         balances[to] = balances[to].add(value);
278         marketingAllocation = marketingAllocation.sub(value);
279         Transfer(this, to, value);
280     }
281 
282     function teamAllocationTokenSend(address to, uint256 _value) onlyAdmin public  {
283         uint256 value = _value * 10 ** uint(decimals);
284         require(to != 0x0 && teamAllocation >= value);
285         balances[this] = balances[this].sub(value);
286         balances[to] = balances[to].add(value);
287         teamAllocation = teamAllocation.sub(value);
288         Transfer(this, to, value);
289     }
290 
291     function advisorsAllocationTokenSend(address to, uint256 _value) onlyAdmin public  {
292         uint256 value = _value * 10 ** uint(decimals);
293         require(to != 0x0 && advisorsAllocation >= value);
294         balances[this] = balances[this].sub(value);
295         balances[to] = balances[to].add(value);
296         advisorsAllocation = advisorsAllocation.sub(value);
297         Transfer(this, to, value);
298     }
299 
300     // unsold tokens back to Platform Growth Reserve
301     function transferToGrowthReserve() crowdsaleonly public  {
302         growthReserve = growthReserve.add(publicAllocation);
303         publicAllocation = 0;
304     }
305     //refund tokens after crowdsale
306     function refundTokens(address _sender) crowdsaleonly public {
307         growthReserve = growthReserve.add(balances[_sender]);
308         //balances[_sender] = 0;
309     }
310     
311 }