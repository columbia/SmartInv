1 // File: localhost/2key/ERC20/ERC20.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 contract ERC20 {
7     function totalSupply() public view returns (uint256);
8     function balanceOf(address _who) public view returns (uint256);
9     function transfer(address _to, uint256 _value) public returns (bool);
10     function allowance(address _ocwner, address _spender) public view returns (uint256);
11     function approve(address spender, uint tokens) public returns (bool success);
12     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
16 }
17 
18 // File: localhost/2key/libraries/SafeMath.sol
19 
20 pragma solidity ^0.4.24;
21 
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28 
29   /**
30   * @dev Multiplies two numbers, throws on overflow.
31   */
32   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
33     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
34     // benefit is lost if 'b' is also tested.
35     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36     if (_a == 0) {
37       return 0;
38     }
39 
40     c = _a * _b;
41     require(c / _a == _b);
42     return c;
43   }
44 
45   /**
46   * @dev Integer division of two numbers, truncating the quotient.
47   */
48   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
49     // assert(_b > 0); // Solidity automatically throws when dividing by 0
50     // uint256 c = _a / _b;
51     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
52     return _a / _b;
53   }
54 
55   /**
56   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57   */
58   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
59     require(_b <= _a);
60     return _a - _b;
61   }
62 
63   /**
64   * @dev Adds two numbers, throws on overflow.
65   */
66   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
67     c = _a + _b;
68     require(c >= _a);
69     return c;
70   }
71 }
72 
73 // File: localhost/2key/ERC20/StandardTokenModified.sol
74 
75 pragma solidity ^0.4.24;
76 
77 
78 
79 
80 /**
81  * @author Nikola Madjarevic added frozen transfer options
82  */
83 contract StandardTokenModified is ERC20 {
84 
85     using SafeMath for uint256;
86 
87     uint256 internal totalSupply_;
88     string public name;
89     string public symbol;
90     uint8 public decimals;
91     bool public transfersFrozen = false;
92 
93 
94     mapping (address => mapping (address => uint256)) internal allowed;
95     mapping(address => uint256) internal balances;
96 
97     modifier onlyIfNotFrozen {
98         require(transfersFrozen == false);
99         _;
100     }
101 
102     /**
103      * @dev Transfer tokens from one address to another
104      * @param _from address The address which you want to send tokens from
105      * @param _to address The address which you want to transfer to
106      * @param _value uint256 the amount of tokens to be transferred
107      */
108     function transferFrom(
109         address _from,
110         address _to,
111         uint256 _value
112     )
113     public
114     onlyIfNotFrozen
115     returns (bool)
116     {
117         require(_value <= balances[_from]);
118         require(_value <= allowed[_from][msg.sender]);
119         require(_to != address(0));
120 
121         balances[_from] = balances[_from].sub(_value);
122         balances[_to] = balances[_to].add(_value);
123         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
124         emit Transfer(_from, _to, _value);
125         return true;
126     }
127 
128     /**
129      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
130      * Beware that changing an allowance with this method brings the risk that someone may use both the old
131      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
132      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
133      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134      * @param _spender The address which will spend the funds.
135      * @param _value The amount of tokens to be spent.
136      */
137     function approve(address _spender, uint256 _value) public returns (bool) {
138         allowed[msg.sender][_spender] = _value;
139         emit Approval(msg.sender, _spender, _value);
140         return true;
141     }
142 
143     /**
144      * @dev Function to check the amount of tokens that an owner allowed to a spender.
145      * @param _owner address The address which owns the funds.
146      * @param _spender address The address which will spend the funds.
147      * @return A uint256 specifying the amount of tokens still available for the spender.
148      */
149     function allowance(
150         address _owner,
151         address _spender
152     )
153     public
154     view
155     returns (uint256)
156     {
157         return allowed[_owner][_spender];
158     }
159 
160     /**
161      * @dev Increase the amount of tokens that an owner allowed to a spender.
162      * approve should be called when allowed[_spender] == 0. To increment
163      * allowed value is better to use this function to avoid 2 calls (and wait until
164      * the first transaction is mined)
165      * From MonolithDAO Token.sol
166      * @param _spender The address which will spend the funds.
167      * @param _addedValue The amount of tokens to increase the allowance by.
168      */
169     function increaseApproval(
170         address _spender,
171         uint256 _addedValue
172     )
173     public
174     returns (bool)
175     {
176         allowed[msg.sender][_spender] = (
177         allowed[msg.sender][_spender].add(_addedValue));
178         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
179         return true;
180     }
181 
182     /**
183      * @dev Decrease the amount of tokens that an owner allowed to a spender.
184      * approve should be called when allowed[_spender] == 0. To decrement
185      * allowed value is better to use this function to avoid 2 calls (and wait until
186      * the first transaction is mined)
187      * From MonolithDAO Token.sol
188      * @param _spender The address which will spend the funds.
189      * @param _subtractedValue The amount of tokens to decrease the allowance by.
190      */
191     function decreaseApproval(
192         address _spender,
193         uint256 _subtractedValue
194     )
195     public
196     returns (bool)
197     {
198         uint256 oldValue = allowed[msg.sender][_spender];
199         if (_subtractedValue >= oldValue) {
200             allowed[msg.sender][_spender] = 0;
201         } else {
202             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
203         }
204         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
205         return true;
206     }
207 
208     /**
209     * @dev Total number of tokens in existence
210     */
211     function totalSupply() public view returns (uint256) {
212         return totalSupply_;
213     }
214 
215     /**
216     * @dev Transfer token for a specified address
217     * @param _to The address to transfer to.
218     * @param _value The amount to be transferred.
219     */
220     function transfer(address _to, uint256 _value) public onlyIfNotFrozen returns (bool) {
221         require(_value <= balances[msg.sender]);
222         require(_to != address(0));
223         balances[msg.sender] = balances[msg.sender].sub(_value);
224         balances[_to] = balances[_to].add(_value);
225         emit Transfer(msg.sender, _to, _value);
226         return true;
227     }
228 
229     /**
230     * @dev Gets the balance of the specified address.
231     * @param _owner The address to query the the balance of.
232     * @return An uint256 representing the amount owned by the passed address.
233     */
234     function balanceOf(address _owner) public view returns (uint256) {
235         return balances[_owner];
236     }
237 
238 
239 
240 }
241 
242 // File: localhost/2key/interfaces/ITwoKeySingletoneRegistryFetchAddress.sol
243 
244 pragma solidity ^0.4.24;
245 /**
246  * @author Nikola Madjarevic
247  * Created at 2/7/19
248  */
249 contract ITwoKeySingletoneRegistryFetchAddress {
250     function getContractProxyAddress(string _contractName) public view returns (address);
251     function getNonUpgradableContractAddress(string contractName) public view returns (address);
252     function getLatestCampaignApprovedVersion(string campaignType) public view returns (string);
253 }
254 
255 // File: localhost/2key/non-upgradable-singletons/TwoKeyEconomy.sol
256 
257 pragma solidity 0.4.24;
258 
259 
260 
261 
262 contract TwoKeyEconomy is StandardTokenModified {
263     string public name = 'TwoKeyEconomy';
264     string public symbol= '2KEY';
265     uint8 public decimals= 18;
266 
267     address public twoKeyAdmin;
268     address public twoKeySingletonRegistry;
269 
270     modifier onlyTwoKeyAdmin {
271         require(msg.sender == twoKeyAdmin);
272         _;
273     }
274 
275     constructor (
276         address _twoKeySingletonRegistry
277     )
278     public
279     {
280         twoKeySingletonRegistry = _twoKeySingletonRegistry;
281 
282         twoKeyAdmin = ITwoKeySingletoneRegistryFetchAddress(twoKeySingletonRegistry).
283             getContractProxyAddress("TwoKeyAdmin");
284 
285         address twoKeyUpgradableExchange = ITwoKeySingletoneRegistryFetchAddress(twoKeySingletonRegistry).
286             getContractProxyAddress("TwoKeyUpgradableExchange");
287         address twoKeyParticipationMiningPool = ITwoKeySingletoneRegistryFetchAddress(twoKeySingletonRegistry).
288             getContractProxyAddress("TwoKeyParticipationMiningPool");
289         address twoKeyNetworkGrowthFund = ITwoKeySingletoneRegistryFetchAddress(twoKeySingletonRegistry).
290             getContractProxyAddress("TwoKeyNetworkGrowthFund");
291         address twoKeyMPSNMiningPool = ITwoKeySingletoneRegistryFetchAddress(twoKeySingletonRegistry).
292             getContractProxyAddress("TwoKeyMPSNMiningPool");
293         address twoKeyTeamGrowthFund = ITwoKeySingletoneRegistryFetchAddress(twoKeySingletonRegistry).
294             getContractProxyAddress("TwoKeyTeamGrowthFund");
295 
296 
297         totalSupply_= 600000000000000000000000000; // 600M tokens total minted supply
298 
299         balances[twoKeyUpgradableExchange] = totalSupply_.mul(3).div(100);
300         emit Transfer(address(this), twoKeyUpgradableExchange, totalSupply_.mul(3).div(100));
301 
302         balances[twoKeyParticipationMiningPool] = totalSupply_.mul(20).div(100);
303         emit Transfer(address(this), twoKeyParticipationMiningPool, totalSupply_.mul(20).div(100));
304 
305         balances[twoKeyNetworkGrowthFund] = totalSupply_.mul(16).div(100);
306         emit Transfer(address(this), twoKeyNetworkGrowthFund, totalSupply_.mul(16).div(100));
307 
308         balances[twoKeyMPSNMiningPool] = totalSupply_.mul(10).div(100);
309         emit Transfer(address(this), twoKeyMPSNMiningPool, totalSupply_.mul(10).div(100));
310 
311         balances[twoKeyTeamGrowthFund] = totalSupply_.mul(4).div(100);
312         emit Transfer(address(this), twoKeyTeamGrowthFund, totalSupply_.mul(4).div(100));
313 
314         balances[twoKeyAdmin] = totalSupply_.mul(47).div(100);
315         emit Transfer(address(this), twoKeyAdmin, totalSupply_.mul(47).div(100));
316     }
317 
318 
319     /// @notice TwoKeyAdmin is available to freeze all transfers on ERC for some period of time
320     /// @dev in TwoKeyAdmin only Congress can call this
321     function freezeTransfers()
322     public
323     onlyTwoKeyAdmin
324     {
325         transfersFrozen = true;
326     }
327 
328     /// @notice TwoKeyAmin is available to unfreeze all transfers on ERC for some period of time
329     /// @dev in TwoKeyAdmin only Congress can call this
330     function unfreezeTransfers()
331     public
332     onlyTwoKeyAdmin
333     {
334         transfersFrozen = false;
335     }
336 
337 }