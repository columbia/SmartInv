1 pragma solidity 0.4.21;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     /**
33     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56     function totalSupply() public view returns (uint256);
57     function balanceOf(address who) public view returns (uint256);
58     function transfer(address to, uint256 value) public returns (bool);
59     event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 contract BasicToken is ERC20Basic {
67     using SafeMath for uint256;
68 
69     mapping(address => uint256) balances;
70 
71     uint256 totalSupply_;
72 
73     /**
74     * @dev total number of tokens in existence
75     */
76     function totalSupply() public view returns (uint256) {
77         return totalSupply_;
78     }
79 
80     /**
81     * @dev transfer token for a specified address
82     * @param _to The address to transfer to.
83     * @param _value The amount to be transferred.
84     */
85     function transfer(address _to, uint256 _value) public returns (bool) {
86         require(_to != address(0));
87         require(_value <= balances[msg.sender]);
88 
89         // SafeMath.sub will throw if there is not enough balance.
90         balances[msg.sender] = balances[msg.sender].sub(_value);
91         balances[_to] = balances[_to].add(_value);
92         emit Transfer(msg.sender, _to, _value);
93         return true;
94     }
95 
96     /**
97     * @dev Gets the balance of the specified address.
98     * @param _owner The address to query the the balance of.
99     * @return An uint256 representing the amount owned by the passed address.
100     */
101     function balanceOf(address _owner) public view returns (uint256 balance) {
102         return balances[_owner];
103     }
104 }
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 is ERC20Basic {
111     function allowance(address owner, address spender) public view returns (uint256);
112     function transferFrom(address from, address to, uint256 value) public returns (bool);
113     function approve(address spender, uint256 value) public returns (bool);
114     event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 /**
118  * @title Standard ERC20 token
119  *
120  * @dev Implementation of the basic standard token.
121  * @dev https://github.com/ethereum/EIPs/issues/20
122  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
123  */
124 contract StandardToken is ERC20, BasicToken {
125 
126     mapping (address => mapping (address => uint256)) internal allowed;
127 
128     /**
129      * @dev Transfer tokens from one address to another
130      * @param _from address The address which you want to send tokens from
131      * @param _to address The address which you want to transfer to
132      * @param _value uint256 the amount of tokens to be transferred
133      */
134     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
135         require(_to != address(0));
136         require(_value <= balances[_from]);
137         require(_value <= allowed[_from][msg.sender]);
138 
139         balances[_from] = balances[_from].sub(_value);
140         balances[_to] = balances[_to].add(_value);
141         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142         emit Transfer(_from, _to, _value);
143         return true;
144     }
145 
146     /**
147      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148      *
149      * Beware that changing an allowance with this method brings the risk that someone may use both the old
150      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
151      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      * @param _spender The address which will spend the funds.
154      * @param _value The amount of tokens to be spent.
155      */
156     function approve(address _spender, uint256 _value) public returns (bool) {
157         allowed[msg.sender][_spender] = _value;
158         emit Approval(msg.sender, _spender, _value);
159         return true;
160     }
161 
162     /**
163      * @dev Function to check the amount of tokens that an owner allowed to a spender.
164      * @param _owner address The address which owns the funds.
165      * @param _spender address The address which will spend the funds.
166      * @return A uint256 specifying the amount of tokens still available for the spender.
167      */
168     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
169         return allowed[_owner][_spender];
170     }
171 
172     /**
173      * approve should be called when allowed[_spender] == 0. To increment
174      * allowed value is better to use this function to avoid 2 calls (and wait until
175      * the first transaction is mined)
176      * From MonolithDAO Token.sol
177      */
178     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
179         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
180         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
181         return true;
182     }
183 
184     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
185         uint oldValue = allowed[msg.sender][_spender];
186         if (_subtractedValue > oldValue) {
187             allowed[msg.sender][_spender] = 0;
188         } else {
189             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
190         }
191         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192         return true;
193     }
194 }
195 
196 /**
197  * @title SafeERC20
198  * @dev Wrappers around ERC20 operations that throw on failure.
199  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
200  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
201  */
202 library SafeERC20 {
203     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
204         assert(token.transfer(to, value));
205     }
206 
207     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
208         assert(token.transferFrom(from, to, value));
209     }
210 
211     function safeApprove(ERC20 token, address spender, uint256 value) internal {
212         assert(token.approve(spender, value));
213     }
214 }
215 
216 /**
217  * @title Burnable Token
218  * @dev Token that can be irreversibly burned (destroyed).
219  */
220 contract BurnableToken is StandardToken {
221 
222     event Burn(address indexed burner, uint256 value);
223 
224     /**
225      * @dev Burns a specific amount of tokens.
226      * @param _value The amount of token to be burned.
227      */
228     function burn(uint256 _value) public {
229         require(_value > 0);
230         require(_value <= balances[msg.sender]);
231         // no need to require value <= totalSupply, since that would imply the
232         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
233 
234         address burner = msg.sender;
235         balances[burner] = balances[burner].sub(_value);
236         totalSupply_ = totalSupply_.sub(_value);
237         emit Burn(burner, _value);
238     }
239 }
240 
241 contract Owned {
242     address public owner;
243 
244     function Owned() public {
245         owner = msg.sender;
246     }
247 
248     modifier onlyOwner {
249         require(msg.sender == owner);
250         _;
251     }
252 }
253 
254 contract LigerToken is BurnableToken {
255     string public constant name = "LIGER";
256     string public constant symbol = "LIC";
257     uint8 public constant decimals = 18;
258 
259     /// Maximum tokens to be allocated (2.7 billion LIC)
260     uint256 public constant HARD_CAP = 2700000000 * 10**uint256(decimals);
261 
262     /// The owner of this address will distribute the locked and vested tokens
263     address public ligerAdminAddress;
264 
265     /// This address holds the initial Liger Team tokens
266     address public teamTokensAddress;
267 
268     /// This address holds the Liger Advisors tokens
269     address public advisorsTokensAddress;
270 
271     /// This address is used to keep the tokens for sale
272     address public saleTokensAddress;
273 
274     /// This address is used to keep the Liger Bounty Tokens
275     address public bountyTokensAddress;
276 
277     /// Store the whitelisted addresses that the first exchange will use before listing
278     mapping(address => bool) public whitelisted;
279 
280     /// when the token is listed on an exchange, the trading will be opened
281     bool public tradingOpen = false;
282 
283     modifier onlyAdmin {
284         require(msg.sender == ligerAdminAddress);
285         _;
286     }
287 
288     function LigerToken(address _ligerAdminAddress, address _teamTokensAddress, address _advisorsTokensAddress,
289     address _saleTokensAddress, address _bountyTokensAddress) public {
290         require(_ligerAdminAddress != address(0));
291         require(_teamTokensAddress != address(0));
292         require(_advisorsTokensAddress != address(0));
293         require(_saleTokensAddress != address(0));
294         require(_bountyTokensAddress != address(0));
295 
296         ligerAdminAddress = _ligerAdminAddress;
297         teamTokensAddress = _teamTokensAddress;
298         advisorsTokensAddress = _advisorsTokensAddress;
299         saleTokensAddress = _saleTokensAddress;
300         bountyTokensAddress = _bountyTokensAddress;
301 
302         whitelisted[saleTokensAddress] = true;
303         whitelisted[bountyTokensAddress] = true;
304 
305         /// Maximum tokens to be allocated on the sale
306         /// 2.025 billion LIC
307         uint256 saleTokens = 2025000000 * 10**uint256(decimals);
308         totalSupply_ = saleTokens;
309         balances[saleTokensAddress] = saleTokens;
310 
311         /// Team tokens - 405 million LIC
312         uint256 teamTokens = 405000000 * 10**uint256(decimals);
313         totalSupply_ = totalSupply_.add(teamTokens);
314         balances[teamTokensAddress] = teamTokens;
315 
316         /// Advisors tokens - 135 million LIC
317         uint256 advisorsTokens = 135000000 * 10**uint256(decimals);
318         totalSupply_ = totalSupply_.add(advisorsTokens);
319         balances[advisorsTokensAddress] = advisorsTokens;
320 
321         /// Bounty tokens - 135 million LIC
322         uint256 bountyTokens = 135000000 * 10**uint256(decimals);
323         totalSupply_ = totalSupply_.add(bountyTokens);
324         balances[bountyTokensAddress] = bountyTokens;
325 
326         require(totalSupply_ <= HARD_CAP);
327     }
328 
329     /// @dev whitelist an address so it's able to transfer
330     /// before the overall trading is opened
331     function whitelist(address _address) external onlyAdmin {
332         whitelisted[_address] = true;
333     }
334 
335     /// @dev open the trading for everyone
336     function openTrading() external onlyAdmin {
337         tradingOpen = true;
338     }
339 
340     /// @dev Trading limited - requires the token sale to have closed
341     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
342         if(tradingOpen || whitelisted[msg.sender]) {
343             return super.transferFrom(_from, _to, _value);
344         }
345         return false;
346     }
347 
348     /// @dev Trading limited - requires the token sale to have closed
349     function transfer(address _to, uint256 _value) public returns (bool) {
350         if(tradingOpen || whitelisted[msg.sender]) {
351             return super.transfer(_to, _value);
352         }
353         return false;
354     }
355 }