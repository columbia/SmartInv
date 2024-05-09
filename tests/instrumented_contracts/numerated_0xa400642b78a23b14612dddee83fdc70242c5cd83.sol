1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (_a == 0) {
13       return 0;
14     }
15 
16     c = _a * _b;
17     assert(c / _a == _b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
25     // assert(_b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = _a / _b;
27     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
28     return _a / _b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     assert(_b <= _a);
36     return _a - _b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
43     c = _a + _b;
44     assert(c >= _a);
45     return c;
46   }
47 }
48 
49 
50 contract CreatorBridgeCoin {
51   using SafeMath for uint256;
52     
53   address public owner;
54   uint256 internal totalSupply_;
55   uint256 public cap;
56   bool public mintingFinished = false;
57   bool public paused = false;
58   mapping(address => uint256) internal balances;
59   mapping (address => mapping (address => uint256)) internal allowed;
60   
61   event Burn(address indexed burner, uint256 value);
62   event Approval(
63     address indexed owner,
64     address indexed spender,
65     uint256 value
66   );
67   event Transfer(address indexed from, address indexed to, uint256 value);
68   event OwnershipRenounced(address indexed previousOwner);
69   event OwnershipTransferred(
70     address indexed previousOwner,
71     address indexed newOwner
72   );    
73   event Mint(address indexed to, uint256 amount);
74   event MintFinished();
75   event Pause();
76   event Unpause();
77 
78 
79   /**
80   * @dev Total number of tokens in existence
81   */
82   function totalSupply() public view returns (uint256) {
83     return totalSupply_;
84   }
85   
86   function balanceOf(address _owner) public view returns (uint256) {
87     return balances[_owner];
88   }
89 
90   /**
91    * @dev Function to check the amount of tokens that an owner allowed to a spender.
92    * @param _owner address The address which owns the funds.
93    * @param _spender address The address which will spend the funds.
94    * @return A uint256 specifying the amount of tokens still available for the spender.
95    */
96   function allowance(
97     address _owner,
98     address _spender
99    )
100     public
101     view
102     returns (uint256)
103   {
104     return allowed[_owner][_spender];
105   }
106     
107   /**
108    * @dev Throws if called by any account other than the owner.
109    */
110   modifier onlyOwner() {
111     require(msg.sender == owner);
112     _;
113   }
114 
115   /**
116    * @dev Allows the current owner to relinquish control of the contract.
117    * @notice Renouncing to ownership will leave the contract without an owner.
118    * It will not be possible to call the functions with the `onlyOwner`
119    * modifier anymore.
120    */
121   function renounceOwnership() public onlyOwner {
122     emit OwnershipRenounced(owner);
123     owner = address(0);
124   }
125 
126   /**
127    * @dev Allows the current owner to transfer control of the contract to a newOwner.
128    * @param _newOwner The address to transfer ownership to.
129    */
130   function transferOwnership(address _newOwner) public onlyOwner {
131     _transferOwnership(_newOwner);
132   }
133 
134   /**
135    * @dev Transfers control of the contract to a newOwner.
136    * @param _newOwner The address to transfer ownership to.
137    */
138   function _transferOwnership(address _newOwner) internal {
139     require(_newOwner != address(0));
140     emit OwnershipTransferred(owner, _newOwner);
141     owner = _newOwner;
142   }
143 
144   modifier canMint() {
145     require(!mintingFinished);
146     _;
147   }
148 
149   modifier hasMintPermission() {
150     require(msg.sender == owner);
151     _;
152   }
153 
154   /**
155    * @dev Function to stop minting new tokens.
156    * @return True if the operation was successful.
157    */
158   function finishMinting() public onlyOwner canMint returns (bool) {
159     mintingFinished = true;
160     emit MintFinished();
161     return true;
162   }
163 
164   /**
165    * @dev Function to mint tokens
166    * @param _to The address that will receive the minted tokens.
167    * @param _amount The amount of tokens to mint.
168    * @return A boolean that indicates if the operation was successful.
169    */
170   function mint(
171     address _to,
172     uint256 _amount
173   )
174     public
175     hasMintPermission
176     canMint
177     returns (bool)
178   {
179     require(totalSupply_.add(_amount) <= cap);
180     totalSupply_ = totalSupply_.add(_amount);
181     balances[_to] = balances[_to].add(_amount);
182     emit Mint(_to, _amount);
183     emit Transfer(address(0), _to, _amount);
184     return true;
185   }
186 
187   /**
188    * @dev Modifier to make a function callable only when the contract is not paused.
189    */
190   modifier whenNotPaused() {
191     require(!paused);
192     _;
193   }
194 
195   /**
196    * @dev Modifier to make a function callable only when the contract is paused.
197    */
198   modifier whenPaused() {
199     require(paused);
200     _;
201   }
202 
203   /**
204    * @dev called by the owner to pause, triggers stopped state
205    */
206   function pause() public onlyOwner whenNotPaused {
207     paused = true;
208     emit Pause();
209   }
210 
211   /**
212    * @dev called by the owner to unpause, returns to normal state
213    */
214   function unpause() public onlyOwner whenPaused {
215     paused = false;
216     emit Unpause();
217   }
218     
219   function transfer(
220     address _to,
221     uint256 _value
222   )
223     public
224     whenNotPaused
225     returns (bool)
226   {
227     require(_value <= balances[msg.sender]);
228     require(_to != address(0));
229 
230     balances[msg.sender] = balances[msg.sender].sub(_value);
231     balances[_to] = balances[_to].add(_value);
232     emit Transfer(msg.sender, _to, _value);
233     return true;
234   }
235 
236   function transferFrom(
237     address _from,
238     address _to,
239     uint256 _value
240   )
241     public
242     whenNotPaused
243     returns (bool)
244   {
245     require(_value <= balances[_from]);
246     require(_value <= allowed[_from][msg.sender]);
247     require(_to != address(0));
248 
249     balances[_from] = balances[_from].sub(_value);
250     balances[_to] = balances[_to].add(_value);
251     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
252     emit Transfer(_from, _to, _value);
253     return true;
254   }
255 
256   function approve(
257     address _spender,
258     uint256 _value
259   )
260     public
261     whenNotPaused
262     returns (bool)
263   {
264     allowed[msg.sender][_spender] = _value;
265     emit Approval(msg.sender, _spender, _value);
266     return true;
267   }
268 
269   function increaseApproval(
270     address _spender,
271     uint _addedValue
272   )
273     public
274     whenNotPaused
275     returns (bool success)
276   {
277     allowed[msg.sender][_spender] = (
278     allowed[msg.sender][_spender].add(_addedValue));
279     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280     return true;
281   }
282 
283   function decreaseApproval(
284     address _spender,
285     uint _subtractedValue
286   )
287     public
288     whenNotPaused
289     returns (bool success)
290   {
291     uint256 oldValue = allowed[msg.sender][_spender];
292     if (_subtractedValue >= oldValue) {
293       allowed[msg.sender][_spender] = 0;
294     } else {
295       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
296     }
297     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
298     return true;
299   }
300 
301   /**
302    * @dev Burns a specific amount of tokens.
303    * @param _value The amount of token to be burned.
304    */
305   function burn(uint256 _value) public {
306     _burn(msg.sender, _value);
307   }
308 
309   function _burn(address _who, uint256 _value) internal {
310     require(_value <= balances[_who]);
311     // no need to require value <= totalSupply, since that would imply the
312     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
313 
314     balances[_who] = balances[_who].sub(_value);
315     totalSupply_ = totalSupply_.sub(_value);
316     emit Burn(_who, _value);
317     emit Transfer(_who, address(0), _value);
318   }
319     
320     string public name = "CreatorBridge coin";
321     string public symbol = "CB";
322     uint256 public decimals = 18;
323     constructor(uint256 _cap) public {
324         require(_cap > 0);
325         cap = _cap;
326         owner = msg.sender;
327     }
328 }