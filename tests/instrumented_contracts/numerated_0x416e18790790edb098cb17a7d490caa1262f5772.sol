1 pragma solidity ^0.4.13;
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
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 contract ERC20Basic {
81   function totalSupply() public view returns (uint256);
82   function balanceOf(address who) public view returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 contract BasicToken is ERC20Basic {
88   using SafeMath for uint256;
89 
90   mapping(address => uint256) balances;
91 
92   uint256 totalSupply_;
93 
94   /**
95   * @dev total number of tokens in existence
96   */
97   function totalSupply() public view returns (uint256) {
98     return totalSupply_;
99   }
100 
101   /**
102   * @dev transfer token for a specified address
103   * @param _to The address to transfer to.
104   * @param _value The amount to be transferred.
105   */
106   function transfer(address _to, uint256 _value) public returns (bool) {
107     require(_to != address(0));
108     require(_value <= balances[msg.sender]);
109 
110     // SafeMath.sub will throw if there is not enough balance.
111     balances[msg.sender] = balances[msg.sender].sub(_value);
112     balances[_to] = balances[_to].add(_value);
113     Transfer(msg.sender, _to, _value);
114     return true;
115   }
116 
117   /**
118   * @dev Gets the balance of the specified address.
119   * @param _owner The address to query the the balance of.
120   * @return An uint256 representing the amount owned by the passed address.
121   */
122   function balanceOf(address _owner) public view returns (uint256 balance) {
123     return balances[_owner];
124   }
125 
126 }
127 
128 contract ERC20 is ERC20Basic {
129   function allowance(address owner, address spender) public view returns (uint256);
130   function transferFrom(address from, address to, uint256 value) public returns (bool);
131   function approve(address spender, uint256 value) public returns (bool);
132   event Approval(address indexed owner, address indexed spender, uint256 value);
133 }
134 
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amount of tokens to be transferred
145    */
146   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
147     require(_to != address(0));
148     require(_value <= balances[_from]);
149     require(_value <= allowed[_from][msg.sender]);
150 
151     balances[_from] = balances[_from].sub(_value);
152     balances[_to] = balances[_to].add(_value);
153     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
154     Transfer(_from, _to, _value);
155     return true;
156   }
157 
158   /**
159    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160    *
161    * Beware that changing an allowance with this method brings the risk that someone may use both the old
162    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
163    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
164    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165    * @param _spender The address which will spend the funds.
166    * @param _value The amount of tokens to be spent.
167    */
168   function approve(address _spender, uint256 _value) public returns (bool) {
169     allowed[msg.sender][_spender] = _value;
170     Approval(msg.sender, _spender, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Function to check the amount of tokens that an owner allowed to a spender.
176    * @param _owner address The address which owns the funds.
177    * @param _spender address The address which will spend the funds.
178    * @return A uint256 specifying the amount of tokens still available for the spender.
179    */
180   function allowance(address _owner, address _spender) public view returns (uint256) {
181     return allowed[_owner][_spender];
182   }
183 
184   /**
185    * @dev Increase the amount of tokens that an owner allowed to a spender.
186    *
187    * approve should be called when allowed[_spender] == 0. To increment
188    * allowed value is better to use this function to avoid 2 calls (and wait until
189    * the first transaction is mined)
190    * From MonolithDAO Token.sol
191    * @param _spender The address which will spend the funds.
192    * @param _addedValue The amount of tokens to increase the allowance by.
193    */
194   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
195     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
196     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197     return true;
198   }
199 
200   /**
201    * @dev Decrease the amount of tokens that an owner allowed to a spender.
202    *
203    * approve should be called when allowed[_spender] == 0. To decrement
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    * @param _spender The address which will spend the funds.
208    * @param _subtractedValue The amount of tokens to decrease the allowance by.
209    */
210   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
211     uint oldValue = allowed[msg.sender][_spender];
212     if (_subtractedValue > oldValue) {
213       allowed[msg.sender][_spender] = 0;
214     } else {
215       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
216     }
217     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221 }
222 
223 contract LoomTimeVault is Ownable {
224   // only after the release time the beficiary will be
225   // able to transfer the balance of the token
226   LoomToken public loomToken;
227 
228   // beneficiaries of tokens
229   mapping(address => uint256) public beneficiaries; // beneficiary => amount
230 
231   // timestamp when token release is enabled
232   uint256 public releaseTime;
233 
234   // events --------------------------------------------------------------------
235 
236   event BeneficiaryAdded(address _beneficiaryAddress, uint256 _amount);
237   event BeneficiaryWithdrawn(address _beneficiaryAddress, uint256 _amount);
238   event OwnerWithdrawn(address _ownerAddress, uint256 _amount);
239 
240   // modifiers -----------------------------------------------------------------
241 
242   modifier onlyAfterReleaseTime() {
243     require(now >= releaseTime);
244     _;
245   }
246 
247   // constructor function ------------------------------------------------------
248 
249   function LoomTimeVault(uint256 _releaseTime, address _loomTokenAddress) public {
250     require(_releaseTime > now);
251     require(_loomTokenAddress != address(0));
252 
253     owner = msg.sender;
254     releaseTime = _releaseTime;
255     loomToken = LoomToken(_loomTokenAddress);
256   }
257 
258   // external functions --------------------------------------------------------
259 
260   /**
261   * @dev the owner of the vault can add the beneficiary accounts
262   * @param _beneficiaryAddress address which will receive the benefit in the future
263   * @param _amount quantity of tokens to beneficiary receive
264   */
265   function addBeneficiary(address _beneficiaryAddress, uint256 _amount)
266     external
267     onlyOwner
268   {
269     require(_beneficiaryAddress != address(0));
270     require(_amount > 0);
271     require(_amount <= loomToken.balanceOf(this));
272 
273     beneficiaries[_beneficiaryAddress] = _amount;
274     BeneficiaryAdded(_beneficiaryAddress, _amount);
275   }
276 
277   /**
278   * @dev the beneficiary can withdraw the tokens from the vault after the time the
279   * releaseTime expired, the beneficiary will only receive the amount specified
280   */
281   function withdraw()
282     external
283     onlyAfterReleaseTime
284   {
285     uint256 amount = beneficiaries[msg.sender];
286     require(amount > 0);
287 
288     beneficiaries[msg.sender] = 0;
289 
290     assert(loomToken.transfer(msg.sender, amount));
291     BeneficiaryWithdrawn(msg.sender, amount);
292   }
293 
294   /**
295   * @dev the owner of the vault can withdraw the tokens from the vault after the time the
296   * releaseTime expire
297   */
298   function ownerWithdraw()
299     external
300     onlyOwner
301     onlyAfterReleaseTime
302   {
303     uint256 amount = loomToken.balanceOf(this);
304     require(amount > 0);
305 
306     assert(loomToken.transfer(msg.sender, amount));
307     OwnerWithdrawn(msg.sender, amount);
308   }
309 
310   /**
311   * @dev get how many tokens the beneficiary address has to withdraw after the release time
312   * expire
313   * @param _beneficiaryAddress address of the beneficiary to inspect
314   */
315   function beneficiaryAmount(address _beneficiaryAddress)
316     public
317     view
318     returns (uint256)
319   {
320     return beneficiaries[_beneficiaryAddress];
321   }
322 }
323 
324 contract LoomToken is StandardToken {
325   string public name    = "LoomToken";
326   string public symbol  = "LOOM";
327   uint8 public decimals = 18;
328 
329   // one billion in initial supply
330   uint256 public constant INITIAL_SUPPLY = 1000000000;
331 
332   function LoomToken() public {
333     totalSupply_ = INITIAL_SUPPLY * (10 ** uint256(decimals));
334     balances[msg.sender] = totalSupply_;
335   }
336 }