1 pragma solidity ^0.4.24;
2 
3 interface token {
4     function transfer(address receiver, uint amount) external returns (bool);
5     function balanceOf(address who) external returns (uint256);
6 }
7 
8 interface AddressRegistry {
9     function getAddr(string AddrName) external returns(address);
10 }
11 
12 contract Registry {
13     address public RegistryAddress;
14     modifier onlyAdmin() {
15         require(msg.sender == getAddress("admin"));
16         _;
17     }
18     function getAddress(string AddressName) internal view returns(address) {
19         AddressRegistry aRegistry = AddressRegistry(RegistryAddress);
20         address realAddress = aRegistry.getAddr(AddressName);
21         require(realAddress != address(0));
22         return realAddress;
23     }
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31 
32     /**
33     * @dev Multiplies two numbers, throws on overflow.
34     */
35     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36         if (a == 0) {
37             return 0;
38         }
39         uint256 c = a * b;
40         assert(c / a == b);
41         return c;
42     }
43 
44     /**
45     * @dev Integer division of two numbers, truncating the quotient.
46     */
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         // assert(b > 0); // Solidity automatically throws when dividing by 0
49         uint256 c = a / b;
50         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51         return c;
52     }
53 
54     /**
55     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
56     */
57     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58         assert(b <= a);
59         return a - b;
60     }
61 
62     /**
63     * @dev Adds two numbers, throws on overflow.
64     */
65     function add(uint256 a, uint256 b) internal pure returns (uint256) {
66         uint256 c = a + b;
67         assert(c >= a);
68         return c;
69     }
70 }
71 
72 /**
73  * @title ERC20Basic
74  * @dev Simpler version of ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/179
76  */
77 contract ERC20Basic {
78     function totalSupply() public view returns (uint256);
79     function balanceOf(address who) public view returns (uint256);
80     function transfer(address to, uint256 value) public returns (bool);
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 }
83 
84 /**
85  * @title ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/20
87  */
88 contract ERC20 is ERC20Basic {
89     function allowance(address owner, address spender) public view returns (uint256);
90     function transferFrom(address from, address to, uint256 value) public returns (bool);
91     function approve(address spender, uint256 value) public returns (bool);
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 /**
96  * @title Basic token
97  * @dev Basic version of StandardToken, with no allowances.
98  */
99 contract BasicToken is ERC20Basic {
100     using SafeMath for uint256;
101 
102     mapping(address => uint256) balances;
103 
104     uint256 totalSupply_;
105 
106     /**
107         *  @dev total number of tokens in existence
108         */
109     function totalSupply() public view returns (uint256) {
110         return totalSupply_;
111     }
112 
113     /**
114         * @dev transfer token for a specified address
115         * @param _to The address to transfer to.
116         * @param _value The amount to be transferred.
117         */
118     function transfer(address _to, uint256 _value) public returns (bool) {
119         require(_to != address(0));
120         require(_value <= balances[msg.sender]);
121 
122         // SafeMath.sub will throw if there is not enough balance.
123         balances[msg.sender] = balances[msg.sender].sub(_value);
124         balances[_to] = balances[_to].add(_value);
125         emit Transfer(msg.sender, _to, _value);
126         return true;
127     }
128 
129     /**
130     * @dev Gets the balance of the specified address.
131     * @param _owner The address to query the the balance of.
132     * @return An uint256 representing the amount owned by the passed address.
133     */
134     function balanceOf(address _owner) public view returns (uint256 balance) {
135         return balances[_owner];
136     }
137 
138 }
139 
140 
141 /**
142  * @title Burnable Token
143  * @dev Token that can be irreversibly burned (destroyed).
144  */
145 contract BurnableToken is BasicToken {
146 
147     event Burn(address indexed burner, uint256 value);
148 
149     /**
150     * @dev Burns a specific amount of tokens.
151     * @param _value The amount of token to be burned.
152     */
153     function burn(uint256 _value) public {
154         require(_value <= balances[msg.sender]);
155         // no need to require value <= totalSupply, since that would imply the
156         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
157 
158         address burner = msg.sender;
159         balances[burner] = balances[burner].sub(_value);
160         totalSupply_ = totalSupply_.sub(_value);
161         emit Burn(burner, _value);
162     }
163 }
164 
165 /**
166  * @title Standard ERC20 token
167  *
168  * @dev Implementation of the basic standard token.
169  * @dev https://github.com/ethereum/EIPs/issues/20
170  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
171  */
172 contract StandardToken is ERC20, BasicToken, BurnableToken {
173 
174     mapping (address => mapping (address => uint256)) internal allowed;
175 
176 
177     /**
178     * @dev Transfer tokens from one address to another
179     * @param _from address The address which you want to send tokens from
180     * @param _to address The address which you want to transfer to
181     * @param _value uint256 the amount of tokens to be transferred
182     */
183     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
184         require(_to != address(0));
185         require(_value <= balances[_from]);
186         require(_value <= allowed[_from][msg.sender]);
187 
188         balances[_from] = balances[_from].sub(_value);
189         balances[_to] = balances[_to].add(_value);
190         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
191         emit Transfer(_from, _to, _value);
192         return true;
193     }
194 
195     /**
196     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
197     *
198     * Beware that changing an allowance with this method brings the risk that someone may use both the old
199     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
200     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
201     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
202     * @param _spender The address which will spend the funds.
203     * @param _value The amount of tokens to be spent.
204     */
205     function approve(address _spender, uint256 _value) public returns (bool) {
206         allowed[msg.sender][_spender] = _value;
207         emit Approval(msg.sender, _spender, _value);
208         return true;
209     }
210 
211     /**
212     * @dev Function to check the amount of tokens that an owner allowed to a spender.
213     * @param _owner address The address which owns the funds.
214     * @param _spender address The address which will spend the funds.
215     * @return A uint256 specifying the amount of tokens still available for the spender.
216     */
217     function allowance(address _owner, address _spender) public view returns (uint256) {
218         return allowed[_owner][_spender];
219     }
220 
221     /**
222     * @dev Increase the amount of tokens that an owner allowed to a spender.
223     *
224     * approve should be called when allowed[_spender] == 0. To increment
225     * allowed value is better to use this function to avoid 2 calls (and wait until
226     * the first transaction is mined)
227     * From MonolithDAO Token.sol
228     * @param _spender The address which will spend the funds.
229     * @param _addedValue The amount of tokens to increase the allowance by.
230     */
231     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
232         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
233         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234         return true;
235     }
236 
237     /**
238     * @dev Decrease the amount of tokens that an owner allowed to a spender.
239     *
240     * approve should be called when allowed[_spender] == 0. To decrement
241     * allowed value is better to use this function to avoid 2 calls (and wait until
242     * the first transaction is mined)
243     * From MonolithDAO Token.sol
244     * @param _spender The address which will spend the funds.
245     * @param _subtractedValue The amount of tokens to decrease the allowance by.
246     */
247     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
248         uint oldValue = allowed[msg.sender][_spender];
249         if (_subtractedValue > oldValue) {
250             allowed[msg.sender][_spender] = 0;
251         } else {
252             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
253         }
254         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255         return true;
256     }
257 
258 }
259 
260 /**
261  * @title Pausable
262  * @dev Base contract which allows children to implement an emergency stop mechanism.
263  */
264 contract Pausable is Registry {
265     event Pause();
266     event Unpause();
267 
268     bool public paused = false;
269 
270     /**
271     * @dev Modifier to make a function callable only when the contract is not paused.
272     */
273     modifier whenNotPaused() {
274         require(!paused);
275         _;
276     }
277 
278     /**
279     * @dev Modifier to make a function callable only when the contract is paused.
280     */
281     modifier whenPaused() {
282         require(paused);
283         _;
284     }
285 
286     /**
287     * @dev called by the owner to pause, triggers stopped state
288     */
289     function pause() onlyAdmin whenNotPaused public {
290         paused = true;
291         emit Pause();
292     }
293 
294     /**
295     * @dev called by the owner to unpause, returns to normal state
296     */
297     function unpause() onlyAdmin whenPaused public {
298         paused = false;
299         emit Unpause();
300     }
301 }
302 
303 /**
304  * @title Pausable token
305  * @dev StandardToken modified with pausable transfers.
306  **/
307 contract PausableToken is StandardToken, Pausable {
308 
309     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
310         return super.transfer(_to, _value);
311     }
312 
313     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
314         return super.transferFrom(_from, _to, _value);
315     }
316 
317     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
318         return super.approve(_spender, _value);
319     }
320 
321     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
322         return super.increaseApproval(_spender, _addedValue);
323     }
324 
325     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
326         return super.decreaseApproval(_spender, _subtractedValue);
327     }
328 }
329 
330 contract MoatUnit is PausableToken {
331 
332     constructor(address rAddress) public {
333         RegistryAddress = rAddress;
334     }
335 
336     string public constant name = "MoatUnit";
337     string public constant symbol = "MTUv2";
338     uint8 public constant decimals = 0;
339 
340     function MintToken(uint NoOfMTU) onlyAdmin public {
341         totalSupply_ = totalSupply_.add(NoOfMTU);
342         address fundAddress = getAddress("fund");
343         balances[fundAddress] = balances[fundAddress].add(NoOfMTU);
344         emit Transfer(0, fundAddress, NoOfMTU);
345     }
346 
347     function SendERC20ToAsset(address tokenAddress) onlyAdmin public {
348         token tokenFunctions = token(tokenAddress);
349         uint256 tokenBal = tokenFunctions.balanceOf(address(this));
350         tokenFunctions.transfer(getAddress("asset"), tokenBal);
351     }
352 
353 }