1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   /**
20   * @dev Integer division of two numbers, truncating the quotient.
21   */
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   /**
30   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31   */
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   /**
38   * @dev Adds two numbers, throws on overflow.
39   */
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 /**
48  * @title ERC20 interface
49  * @dev see https://github.com/ethereum/EIPs/issues/20
50  */
51 contract ERC20 {
52   function totalSupply() public view returns (uint256);
53   function balanceOf(address who) public view returns (uint256);
54   function transfer(address to, uint256 value) public returns (bool);
55   function allowance(address owner, address spender) public view returns (uint256);
56   function transferFrom(address from, address to, uint256 value) public returns (bool);
57   function approve(address spender, uint256 value) public returns (bool);
58   event Approval(address indexed owner, address indexed spender, uint256 value);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 /**
63  * @title MigrationAgent
64  * @dev Agent for migrate token
65  */
66 contract MigrationAgent {
67     function migrateFrom(address _from, uint256 _value) public;
68 }
69 
70 /**
71 * @title ForgeCDN
72 * @dev Contract to mint FORGE token.
73 */
74 contract ForgeCDN is ERC20{
75     using SafeMath for uint256;
76 
77     string public constant name = "ForgeCDN";
78     string public constant symbol = "FORGE";
79     uint8 public constant decimals = 18;
80 
81     event Transfer(address indexed from, address indexed to, uint256 value);
82     event Burn(address indexed burner, uint256 value);
83     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85     event Pause();
86     event Unpause();
87     event Migrate(address indexed _from, address indexed _to, uint256 _value);
88 
89     mapping (address => mapping (address => uint256)) internal allowed;
90     mapping(address => uint256) balances;
91     uint256 totalSupply_;
92     address public owner;
93     address public pendingOwner;
94     bool public paused = false;
95     address public migrationAgent;
96 
97     uint256 public constant INITIAL_SUPPLY = 61570000 * (10 ** uint256(decimals));
98 
99     function ForgeCDN() public {
100         owner = msg.sender;
101         totalSupply_ = INITIAL_SUPPLY;
102         balances[msg.sender] = INITIAL_SUPPLY;
103         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
104     }
105 
106     /**
107     * @dev Throws if called by any account other than the owner.
108     */
109     modifier onlyOwner() {
110         require(msg.sender == owner);
111         _;
112     }
113 
114     /**
115      * @dev Modifier throws if called by any account other than the pendingOwner.
116      */
117     modifier onlyPendingOwner() {
118         require(msg.sender == pendingOwner);
119         _;
120     }
121 
122     /**
123      * @dev Modifier to make a function callable only when the contract is not paused.
124      */
125     modifier whenNotPaused() {
126         require(!paused);
127         _;
128     }
129 
130     /**
131      * @dev Modifier to make a function callable only when the contract is paused.
132      */
133     modifier whenPaused() {
134         require(paused);
135         _;
136     }
137 
138     /**
139     * @dev Allows the current owner to transfer control of the contract to a newOwner.
140     * @param newOwner The address to transfer ownership to.
141     */
142     function transferOwnership(address newOwner) public onlyOwner {
143         require(newOwner != address(0));
144         pendingOwner = newOwner;
145     }
146 
147     /**
148      * @dev Allows the pendingOwner address to finalize the transfer.
149      */
150     function claimOwnership() onlyPendingOwner public {
151         emit OwnershipTransferred(owner, pendingOwner);
152         owner = pendingOwner;
153         pendingOwner = address(0);
154     }
155 
156     /**
157     * @dev total number of tokens in existence
158     */
159     function totalSupply() public view returns (uint256) {
160         return totalSupply_;
161     }
162 
163     /**
164     * @dev transfer token for a specified address
165     * @param _to The address to transfer to.
166     * @param _value The amount to be transferred.
167     */
168     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
169         require(_to != address(0));
170         require(_value <= balances[msg.sender]);
171 
172         // SafeMath.sub will throw if there is not enough balance.
173         balances[msg.sender] = balances[msg.sender].sub(_value);
174         balances[_to] = balances[_to].add(_value);
175         emit Transfer(msg.sender, _to, _value);
176         return true;
177     }
178 
179     /**
180     * @dev Transfer tokens from one address to another
181     * @param _from address The address which you want to send tokens from
182     * @param _to address The address which you want to transfer to
183     * @param _value uint256 the amount of tokens to be transferred
184     */
185     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
186         require(_to != address(0));
187         require(_value <= balances[_from]);
188         require(_value <= allowed[_from][msg.sender]);
189 
190         balances[_from] = balances[_from].sub(_value);
191         balances[_to] = balances[_to].add(_value);
192         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
193         emit Transfer(_from, _to, _value);
194         return true;
195     }
196 
197     /**
198     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
199     * @param _spender The address which will spend the funds.
200     * @param _value The amount of tokens to be spent.
201     */
202     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
203         allowed[msg.sender][_spender] = _value;
204         emit Approval(msg.sender, _spender, _value);
205         return true;
206     }
207 
208     /**
209     * @dev Function to check the amount of tokens that an owner allowed to a spender.
210     * @param _owner address The address which owns the funds.
211     * @param _spender address The address which will spend the funds.
212     * @return A uint256 specifying the amount of tokens still available for the spender.
213     */
214     function allowance(address _owner, address _spender) public view returns (uint256) {
215         return allowed[_owner][_spender];
216     }
217 
218     /**
219      * @dev Increase the amount of tokens that an owner allowed to a spender.
220      * @param _spender The address which will spend the funds.
221      * @param _addedValue The amount of tokens to increase the allowance by.
222      */
223     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool) {
224         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
225         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226         return true;
227     }
228 
229     /**
230      * @dev Decrease the amount of tokens that an owner allowed to a spender.
231      * @param _spender The address which will spend the funds.
232      * @param _subtractedValue The amount of tokens to decrease the allowance by.
233      */
234     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool) {
235         uint oldValue = allowed[msg.sender][_spender];
236         if (_subtractedValue > oldValue) {
237             allowed[msg.sender][_spender] = 0;
238         } else {
239             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240         }
241         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242         return true;
243     }
244 
245     /**
246     * @dev Gets the balance of the specified address.
247     * @param _owner The address to query the the balance of.
248     * @return An uint256 representing the amount owned by the passed address.
249     */
250     function balanceOf(address _owner) public view returns (uint256 balance) {
251         return balances[_owner];
252     }
253 
254     /**
255     * @dev Burns a specific amount of tokens.
256     * @param _value The amount of token to be burned.
257     */
258     function burn(uint256 _value) public onlyOwner {
259         require(_value <= balances[msg.sender]);
260         address burner = msg.sender;
261         balances[burner] = balances[burner].sub(_value);
262         totalSupply_ = totalSupply_.sub(_value);
263         emit Burn(burner, _value);
264     }
265 
266     /**
267      * @dev called by the owner to pause, triggers stopped state
268      */
269     function pause() onlyOwner whenNotPaused public {
270         paused = true;
271         emit Pause();
272     }
273 
274     /**
275      * @dev called by the owner to unpause, returns to normal state
276      */
277     function unpause() onlyOwner whenPaused public {
278         paused = false;
279         emit Unpause();
280     }
281 
282     /**
283      * @dev migrate tokens to the new token contract
284      */
285     function migrate() external {
286         require(migrationAgent != 0);
287         uint256 value = balanceOf(msg.sender);
288         balances[msg.sender] -= value;
289         totalSupply_ -= value;
290         MigrationAgent(migrationAgent).migrateFrom(msg.sender, value);
291         emit Migrate(msg.sender, migrationAgent, value);
292     }
293 
294     /**
295      * @dev set migration agent (new token address with MigrationAgent interface)
296      */
297     function setMigrationAgent(address _agent) external onlyOwner {
298         require(migrationAgent != 0);
299         migrationAgent = _agent;
300     }
301 }