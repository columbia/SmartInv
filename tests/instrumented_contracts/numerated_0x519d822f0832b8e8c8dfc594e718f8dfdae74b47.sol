1 pragma solidity ^0.4.24;
2 
3 contract ERC20 {
4     function totalSupply() public view returns (uint256);
5 
6     function balanceOf(address _who) public view returns (uint256);
7 
8     function allowance(address _owner, address _spender) public view returns (uint256);
9 
10     function transfer(address _to, uint256 _value) public returns (bool);
11 
12     function approve(address _spender, uint256 _value) public returns (bool);
13 
14     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
15 
16     event Transfer(
17         address indexed from,
18         address indexed to,
19         uint256 value
20     );
21 
22     event Approval(
23         address indexed owner,
24         address indexed spender,
25         uint256 value
26     );
27 }
28 
29 library SafeMath {
30 
31   /**
32   * @dev Multiplies two numbers, reverts on overflow.
33   */
34     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
36     // benefit is lost if 'b' is also tested.
37     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
38         if (_a == 0) {
39             return 0;
40         }
41 
42         uint256 c = _a * _b;
43         require(c / _a == _b, "SafeMath failure");
44 
45         return c;
46     }
47 
48   /**
49   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
50   */
51     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
52         require(_b > 0, "SafeMath failure"); // Solidity only automatically asserts when dividing by 0
53         uint256 c = _a / _b;
54         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
55 
56         return c;
57     }
58 
59   /**
60   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
61   */
62     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
63         require(_b <= _a, "SafeMath failure");
64         uint256 c = _a - _b;
65 
66         return c;
67     }
68 
69   /**
70   * @dev Adds two numbers, reverts on overflow.
71   */
72     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
73         uint256 c = _a + _b;
74         require(c >= _a, "SafeMath failure");
75 
76         return c;
77     }
78 
79   /**
80   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
81   * reverts when dividing by zero.
82   */
83     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84         require(b != 0, "SafeMath failure");
85         return a % b;
86     }
87 }
88 
89 
90 /**
91  * @title Ownable
92  * @dev The Ownable contract has an owner address, and provides basic authorization control
93  * functions, this simplifies the implementation of "user permissions".
94  */
95 contract Ownable {
96     address public owner;
97 
98 
99     event OwnershipRenounced(address indexed previousOwner);
100     event OwnershipTransferred(
101         address indexed previousOwner,
102         address indexed newOwner
103     );
104 
105 
106   /**
107    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
108    * account.
109    */
110     constructor() public {
111         owner = msg.sender;
112     }
113 
114   /**
115    * @dev Throws if called by any account other than the owner.
116    */
117     modifier onlyOwner() {
118         require(msg.sender == owner, "Permission denied");
119         _;
120     }
121 
122   /**
123    * @dev Allows the current owner to relinquish control of the contract.
124    * @notice Renouncing to ownership will leave the contract without an owner.
125    * It will not be possible to call the functions with the `onlyOwner`
126    * modifier anymore.
127    */
128     function renounceOwnership() public onlyOwner {
129         emit OwnershipRenounced(owner);
130         owner = address(0);
131     }
132 
133   /**
134    * @dev Allows the current owner to transfer control of the contract to a newOwner.
135    * @param _newOwner The address to transfer ownership to.
136    */
137     function transferOwnership(address _newOwner) public onlyOwner {
138         _transferOwnership(_newOwner);
139     }
140 
141   /**
142    * @dev Transfers control of the contract to a newOwner.
143    * @param _newOwner The address to transfer ownership to.
144    */
145     function _transferOwnership(address _newOwner) internal {
146         require(_newOwner != address(0), "Can't transfer to 0x0");
147         emit OwnershipTransferred(owner, _newOwner);
148         owner = _newOwner;
149     }
150 }
151 
152 contract IxoERC20Token is ERC20, Ownable {
153     using SafeMath for uint256;
154 
155     address public minter;
156 
157     event Mint(address indexed to, uint256 amount);
158 
159     mapping(address => uint256) balances;
160 
161     mapping (address => mapping (address => uint256)) internal allowed;
162 
163     string public name = "IXO Token"; 
164     string public symbol = "IXO";
165     uint public decimals = 8;
166     uint public CAP = 10000000000 * (10 ** decimals); // 10,000,000,000
167 
168     uint256 totalSupply_;
169 
170     modifier hasMintPermission() {
171         require(msg.sender == minter, "Permission denied");
172         _;
173     }
174 
175     /**
176     * @dev Changes the current minter to a newMinter.
177     * @param _newMinter The address to grant minting permission.
178     */
179     function setMinter(address _newMinter) public onlyOwner {
180         _setMinter(_newMinter);
181     }
182 
183     /**
184     * @dev Transfers control of minting tokens to a newMinter.
185     * @param _newMinter The address to transfer minting permission.
186     */
187     function _setMinter(address _newMinter) internal {
188         minter = _newMinter;
189     }
190 
191     /**
192     * @dev Function to mint tokens
193     * @param _to The address that will receive the minted tokens.
194     * @param _amount The amount of tokens to mint.
195     * @return A boolean that indicates if the operation was successful.
196     */
197     function mint(
198         address _to,
199         uint256 _amount
200         )
201     public hasMintPermission returns (bool)
202     {
203         require(totalSupply_.add(_amount) <= CAP, "Exceeds cap");
204 
205         totalSupply_ = totalSupply_.add(_amount);
206         balances[_to] = balances[_to].add(_amount);
207 
208         emit Mint(_to, _amount);
209         emit Transfer(address(0), _to, _amount);
210 				
211         return true;
212     }
213 
214   /**
215   * @dev Total number of tokens in existence
216   */
217     function totalSupply() public view returns (uint256) {
218         return totalSupply_;
219     }
220 
221   /**
222   * @dev Gets the balance of the specified address.
223   * @param _owner The address to query the the balance of.
224   * @return An uint256 representing the amount owned by the passed address.
225   */
226     function balanceOf(address _owner) public view returns (uint256) {
227         return balances[_owner];
228     }
229 
230   /**
231    * @dev Function to check the amount of tokens that an owner allowed to a spender.
232    * @param _owner address The address which owns the funds.
233    * @param _spender address The address which will spend the funds.
234    * @return A uint256 specifying the amount of tokens still available for the spender.
235    */
236     function allowance(
237         address _owner,
238         address _spender
239     )
240     public view returns (uint256)
241     {
242         return allowed[_owner][_spender];
243     }
244 
245   /**
246   * @dev Transfer token for a specified address
247   * @param _to The address to transfer to.
248   * @param _value The amount to be transferred.
249   */
250     function transfer(address _to, uint256 _value) public returns (bool) {
251         require(_value <= balances[msg.sender], "Not enough funds");
252         require(_to != address(0), "Can't transfer to 0x0");
253 
254         balances[msg.sender] = balances[msg.sender].sub(_value);
255         balances[_to] = balances[_to].add(_value);
256         emit Transfer(msg.sender, _to, _value);
257         return true;
258     }
259 
260   /**
261    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
262    * Beware that changing an allowance with this method brings the risk that someone may use both the old
263    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
264    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
265    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
266    * @param _spender The address which will spend the funds.
267    * @param _value The amount of tokens to be spent.
268    */
269     function approve(address _spender, uint256 _value) public returns (bool) {
270         allowed[msg.sender][_spender] = _value;
271         emit Approval(msg.sender, _spender, _value);
272         return true;
273     }
274 
275   /**
276    * @dev Transfer tokens from one address to another
277    * @param _from address The address which you want to send tokens from
278    * @param _to address The address which you want to transfer to
279    * @param _value uint256 the amount of tokens to be transferred
280    */
281     function transferFrom(
282         address _from,
283         address _to,
284         uint256 _value
285     )
286     public returns (bool)
287     {
288         require(_value <= balances[_from], "Not enough funds");
289         require(_value <= allowed[_from][msg.sender], "Not approved");
290         require(_to != address(0), "Can't transfer to 0x0");
291 
292         balances[_from] = balances[_from].sub(_value);
293         balances[_to] = balances[_to].add(_value);
294         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
295         emit Transfer(_from, _to, _value);
296         return true;
297     }
298 
299   /**
300    * @dev Increase the amount of tokens that an owner allowed to a spender.
301    * approve should be called when allowed[_spender] == 0. To increment
302    * allowed value is better to use this function to avoid 2 calls (and wait until
303    * the first transaction is mined)
304    * From MonolithDAO Token.sol
305    * @param _spender The address which will spend the funds.
306    * @param _addedValue The amount of tokens to increase the allowance by.
307    */
308     function increaseApproval(
309         address _spender,
310         uint256 _addedValue
311     )
312     public
313     returns (bool)
314     {
315         allowed[msg.sender][_spender] = (
316             allowed[msg.sender][_spender].add(_addedValue));
317         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
318         return true;
319     }
320 
321   /**
322    * @dev Decrease the amount of tokens that an owner allowed to a spender.
323    * approve should be called when allowed[_spender] == 0. To decrement
324    * allowed value is better to use this function to avoid 2 calls (and wait until
325    * the first transaction is mined)
326    * From MonolithDAO Token.sol
327    * @param _spender The address which will spend the funds.
328    * @param _subtractedValue The amount of tokens to decrease the allowance by.
329    */
330     function decreaseApproval(
331         address _spender,
332         uint256 _subtractedValue
333     )
334     public
335     returns (bool)
336     {
337         uint256 oldValue = allowed[msg.sender][_spender];
338         if (_subtractedValue >= oldValue) {
339             allowed[msg.sender][_spender] = 0;
340         } else {
341             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
342         }
343         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
344         return true;
345     }
346 
347 }