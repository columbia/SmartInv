1 /**
2  * Smart contract - piggy token.
3  * Tokens are fully compatible with the ERC20 standard.
4  */ 
5 
6 pragma solidity ^0.4.25;
7 
8 /**
9  * @title ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/20
11  */
12 interface IERC20 {
13   function totalSupply() external view returns (uint256);
14 
15   function balanceOf(address _who) external view returns (uint256);
16 
17   function allowance(address _owner, address _spender) external view returns (uint256);
18 
19   function transfer(address _to, uint256 _value) external returns (bool);
20 
21   function approve(address _spender, uint256 _value) external returns (bool);
22 
23   function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
24 
25   event Transfer(
26     address indexed from,
27     address indexed to,
28     uint256 value
29   );
30 
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 
39 /**
40  * @title SafeMath
41  * @dev Math operations with safety checks that revert on error
42  */
43 library SafeMath {
44 
45     /**
46     * @dev Multiplies two numbers, reverts on overflow.
47     */
48     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
49         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
50         // benefit is lost if 'b' is also tested.
51         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
52         if (_a == 0) {
53             return 0;
54         }
55 
56         uint256 c = _a * _b;
57         require(c / _a == _b,"Math error");
58 
59         return c;
60     }
61 
62     /**
63     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
64     */
65     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
66         require(_b > 0,"Math error"); // Solidity only automatically asserts when dividing by 0
67         uint256 c = _a / _b;
68         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
69 
70         return c;
71     }
72 
73     /**
74     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
75     */
76     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
77         require(_b <= _a,"Math error");
78         uint256 c = _a - _b;
79 
80         return c;
81     }
82 
83     /**
84     * @dev Adds two numbers, reverts on overflow.
85     */
86     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
87         uint256 c = _a + _b;
88         require(c >= _a,"Math error");
89 
90         return c;
91     }
92 
93     /**
94     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
95     * reverts when dividing by zero.
96     */
97     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
98         require(b != 0,"Math error");
99         return a % b;
100     }
101 }
102 
103 
104 /**
105  * @title Standard ERC20 token
106  * @dev Implementation of the basic standard token.
107  */
108 contract ERC20 is IERC20 {
109     using SafeMath for uint256;
110 
111     mapping (address => uint256) internal balances_;
112 
113     mapping (address => mapping (address => uint256)) private allowed_;
114 
115     uint256 private totalSupply_;
116 
117     /**
118     * @dev Total number of tokens in existence
119     */
120     function totalSupply() public view returns (uint256) {
121         return totalSupply_;
122     }
123 
124     /**
125     * @dev Gets the balance of the specified address.
126     * @param _owner The address to query the the balance of.
127     * @return An uint256 representing the amount owned by the passed address.
128     */
129     function balanceOf(address _owner) public view returns (uint256) {
130         return balances_[_owner];
131     }
132 
133   /**
134    * @dev Function to check the amount of tokens that an owner allowed to a spender.
135    * @param _owner address The address which owns the funds.
136    * @param _spender address The address which will spend the funds.
137    * @return A uint256 specifying the amount of tokens still available for the spender.
138    */
139     function allowance(
140         address _owner,
141         address _spender
142     )
143       public
144       view
145       returns (uint256)
146     {
147         return allowed_[_owner][_spender];
148     }
149 
150     /**
151     * @dev Transfer token for a specified address
152     * @param _to The address to transfer to.
153     * @param _value The amount to be transferred.
154     */
155     function transfer(address _to, uint256 _value) public returns (bool) {
156         require(_value <= balances_[msg.sender],"Invalid value");
157         require(_to != address(0),"Invalid address");
158 
159         balances_[msg.sender] = balances_[msg.sender].sub(_value);
160         balances_[_to] = balances_[_to].add(_value);
161         emit Transfer(msg.sender, _to, _value);
162         return true;
163     }
164 
165     /**
166     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167     * Beware that changing an allowance with this method brings the risk that someone may use both the old
168     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171     * @param _spender The address which will spend the funds.
172     * @param _value The amount of tokens to be spent.
173     */
174     function approve(address _spender, uint256 _value) public returns (bool) {
175         allowed_[msg.sender][_spender] = _value;
176         emit Approval(msg.sender, _spender, _value);
177         return true;
178     }
179 
180     /**
181     * @dev Transfer tokens from one address to another
182     * @param _from address The address which you want to send tokens from
183     * @param _to address The address which you want to transfer to
184     * @param _value uint256 the amount of tokens to be transferred
185     */
186     function transferFrom(
187         address _from,
188         address _to,
189         uint256 _value
190     )
191       public
192       returns (bool)
193     {
194         require(_value <= balances_[_from],"Value is more than balance");
195         require(_value <= allowed_[_from][msg.sender],"Value is more than alloved");
196         require(_to != address(0),"Invalid address");
197 
198         balances_[_from] = balances_[_from].sub(_value);
199         balances_[_to] = balances_[_to].add(_value);
200         allowed_[_from][msg.sender] = allowed_[_from][msg.sender].sub(_value);
201         emit Transfer(_from, _to, _value);
202         return true;
203     }
204 
205   /**
206    * @dev Increase the amount of tokens that an owner allowed to a spender.
207    * approve should be called when allowed_[_spender] == 0. To increment
208    * allowed value is better to use this function to avoid 2 calls (and wait until
209    * the first transaction is mined)
210    * From MonolithDAO Token.sol
211    * @param _spender The address which will spend the funds.
212    * @param _addedValue The amount of tokens to increase the allowance by.
213    */
214     function increaseApproval(
215         address _spender,
216         uint256 _addedValue
217     )
218       public
219       returns (bool)
220     {
221         allowed_[msg.sender][_spender] = (allowed_[msg.sender][_spender].add(_addedValue));
222         emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
223         return true;
224     }
225 
226     /**
227     * @dev Decrease the amount of tokens that an owner allowed to a spender.
228     * approve should be called when allowed_[_spender] == 0. To decrement
229     * allowed value is better to use this function to avoid 2 calls (and wait until
230     * the first transaction is mined)
231     * From MonolithDAO Token.sol
232     * @param _spender The address which will spend the funds.
233     * @param _subtractedValue The amount of tokens to decrease the allowance by.
234     */
235     function decreaseApproval(
236         address _spender,
237         uint256 _subtractedValue
238     )
239       public
240       returns (bool)
241     {
242         uint256 oldValue = allowed_[msg.sender][_spender];
243         if (_subtractedValue >= oldValue) {
244             allowed_[msg.sender][_spender] = 0;
245         } else {
246             allowed_[msg.sender][_spender] = oldValue.sub(_subtractedValue);
247         }
248         emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
249         return true;
250     }
251 
252     /**
253     * @dev Internal function that mints an amount of the token and assigns it to
254     * an account. This encapsulates the modification of balances such that the
255     * proper events are emitted.
256     * @param _account The account that will receive the created tokens.
257     * @param _amount The amount that will be created.
258     */
259     function _mint(address _account, uint256 _amount) internal returns (bool) {
260         require(_account != 0,"Invalid address");
261         totalSupply_ = totalSupply_.add(_amount);
262         balances_[_account] = balances_[_account].add(_amount);
263         emit Transfer(address(0), _account, _amount);
264         return true;
265     }
266 
267     /**
268     * @dev Internal function that burns an amount of the token of a given
269     * account.
270     * @param _account The account whose tokens will be burnt.
271     * @param _amount The amount that will be burnt.
272     */
273     function _burn(address _account, uint256 _amount) internal returns (bool) {
274         require(_account != 0,"Invalid address");
275         require(_amount <= balances_[_account],"Amount is more than balance");
276 
277         totalSupply_ = totalSupply_.sub(_amount);
278         balances_[_account] = balances_[_account].sub(_amount);
279         emit Transfer(_account, address(0), _amount);
280     }
281 
282 }
283 
284 
285 
286 /**
287  * @title Contract Piggytoken
288  * @dev ERC20 compatible token contract
289  */
290 contract PiggyToken is ERC20 {
291     string public constant name = "PiggyBank Token";
292     string public constant symbol = "Piggy";
293     uint32 public constant decimals = 18;
294     uint256 public INITIAL_SUPPLY = 0; // no tokens on start
295     address public piggyBankAddress;
296     
297 
298 
299     constructor(address _piggyBankAddress) public {
300         piggyBankAddress = _piggyBankAddress;
301     }
302 
303 
304     modifier onlyPiggyBank() {
305         require(msg.sender == piggyBankAddress,"Only PiggyBank contract can run this");
306         _;
307     }
308     
309     modifier validDestination( address to ) {
310         require(to != address(0x0),"Empty address");
311         require(to != address(this),"PiggyBank Token address");
312         _;
313     }
314     
315 
316     /**
317      * @dev Override for testing address destination
318      */
319     function transfer(address _to, uint256 _value) public validDestination(_to) returns (bool) {
320         return super.transfer(_to, _value);
321     }
322 
323     /**
324      * @dev Override for testing address destination
325      */
326     function transferFrom(address _from, address _to, uint256 _value) public validDestination(_to) returns (bool) {
327         return super.transferFrom(_from, _to, _value);
328     }
329     
330     /**
331      * @dev Override for running only from PiggyBank contract
332      */
333     function mint(address _to, uint256 _value) public onlyPiggyBank returns (bool) {
334         return super._mint(_to, _value);
335     }
336 
337     /**
338      * @dev Override for running only from PiggyBank contract
339      */
340     function burn(address _to, uint256 _value) public onlyPiggyBank returns (bool) {
341         return super._burn(_to, _value);
342     }
343 
344     function() external payable {
345         revert("The token contract don`t receive ether");
346     }  
347 }