1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipRenounced(address indexed previousOwner);
8   event OwnershipTransferred(
9     address indexed previousOwner,
10     address indexed newOwner
11   );
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   constructor() public {
19     owner = msg.sender;
20   }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to relinquish control of the contract.
32    */
33   function renounceOwnership() public onlyOwner {
34     emit OwnershipRenounced(owner);
35     owner = address(0);
36   }
37 
38   /**
39    * @dev Allows the current owner to transfer control of the contract to a newOwner.
40    * @param _newOwner The address to transfer ownership to.
41    */
42   function transferOwnership(address _newOwner) public onlyOwner {
43     _transferOwnership(_newOwner);
44   }
45 
46   /**
47    * @dev Transfers control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function _transferOwnership(address _newOwner) internal {
51     require(_newOwner != address(0));
52     emit OwnershipTransferred(owner, _newOwner);
53     owner = _newOwner;
54   }
55 }
56 
57 contract ERC20Basic {
58   function totalSupply() public view returns (uint256);
59   function balanceOf(address who) public view returns (uint256);
60   function transfer(address to, uint256 value) public returns (bool);
61   event Transfer(address indexed from, address indexed to, uint256 value);
62 }
63 
64 contract ERC20 is ERC20Basic {
65   function allowance(address owner, address spender)
66     public view returns (uint256);
67 
68   function transferFrom(address from, address to, uint256 value)
69     public returns (bool);
70 
71   function approve(address spender, uint256 value) public returns (bool);
72   event Approval(
73     address indexed owner,
74     address indexed spender,
75     uint256 value
76   );
77 }
78 
79 library SafeMath {
80 
81   /**
82   * @dev Multiplies two numbers, throws on overflow.
83   */
84   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
85     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
86     // benefit is lost if 'b' is also tested.
87     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
88     if (a == 0) {
89       return 0;
90     }
91 
92     c = a * b;
93     assert(c / a == b);
94     return c;
95   }
96 
97   /**
98   * @dev Integer division of two numbers, truncating the quotient.
99   */
100   function div(uint256 a, uint256 b) internal pure returns (uint256) {
101     // assert(b > 0); // Solidity automatically throws when dividing by 0
102     // uint256 c = a / b;
103     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
104     return a / b;
105   }
106 
107   /**
108   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
109   */
110   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
111     assert(b <= a);
112     return a - b;
113   }
114 
115   /**
116   * @dev Adds two numbers, throws on overflow.
117   */
118   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
119     c = a + b;
120     assert(c >= a);
121     return c;
122   }
123 }
124 
125 contract BasicToken is ERC20Basic {
126   using SafeMath for uint256;
127 
128   mapping(address => uint256) balances;
129 
130   uint256 totalSupply_;
131 
132   /**
133   * @dev total number of tokens in existence
134   */
135   function totalSupply() public view returns (uint256) {
136     return totalSupply_;
137   }
138 
139   /**
140   * @dev transfer token for a specified address
141   * @param _to The address to transfer to.
142   * @param _value The amount to be transferred.
143   */
144   function transfer(address _to, uint256 _value) public returns (bool) {
145     require(_to != address(0));
146     require(_value <= balances[msg.sender]);
147 
148     balances[msg.sender] = balances[msg.sender].sub(_value);
149     balances[_to] = balances[_to].add(_value);
150     emit Transfer(msg.sender, _to, _value);
151     return true;
152   }
153 
154   /**
155   * @dev Gets the balance of the specified address.
156   * @param _owner The address to query the the balance of.
157   * @return An uint256 representing the amount owned by the passed address.
158   */
159   function balanceOf(address _owner) public view returns (uint256) {
160     return balances[_owner];
161   }
162 
163 }
164 
165 contract StandardToken is ERC20, BasicToken {
166 
167   mapping (address => mapping (address => uint256)) internal allowed;
168 
169 
170   /**
171    * @dev Transfer tokens from one address to another
172    * @param _from address The address which you want to send tokens from
173    * @param _to address The address which you want to transfer to
174    * @param _value uint256 the amount of tokens to be transferred
175    */
176   function transferFrom(
177     address _from,
178     address _to,
179     uint256 _value
180   )
181     public
182     returns (bool)
183   {
184     require(_to != address(0));
185     require(_value <= balances[_from]);
186     require(_value <= allowed[_from][msg.sender]);
187 
188     balances[_from] = balances[_from].sub(_value);
189     balances[_to] = balances[_to].add(_value);
190     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
191     emit Transfer(_from, _to, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
197    *
198    * Beware that changing an allowance with this method brings the risk that someone may use both the old
199    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
200    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
201    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
202    * @param _spender The address which will spend the funds.
203    * @param _value The amount of tokens to be spent.
204    */
205   function approve(address _spender, uint256 _value) public returns (bool) {
206     allowed[msg.sender][_spender] = _value;
207     emit Approval(msg.sender, _spender, _value);
208     return true;
209   }
210 
211   /**
212    * @dev Function to check the amount of tokens that an owner allowed to a spender.
213    * @param _owner address The address which owns the funds.
214    * @param _spender address The address which will spend the funds.
215    * @return A uint256 specifying the amount of tokens still available for the spender.
216    */
217   function allowance(
218     address _owner,
219     address _spender
220    )
221     public
222     view
223     returns (uint256)
224   {
225     return allowed[_owner][_spender];
226   }
227 
228   /**
229    * @dev Increase the amount of tokens that an owner allowed to a spender.
230    *
231    * approve should be called when allowed[_spender] == 0. To increment
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _addedValue The amount of tokens to increase the allowance by.
237    */
238   function increaseApproval(
239     address _spender,
240     uint _addedValue
241   )
242     public
243     returns (bool)
244   {
245     allowed[msg.sender][_spender] = (
246       allowed[msg.sender][_spender].add(_addedValue));
247     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248     return true;
249   }
250 
251   /**
252    * @dev Decrease the amount of tokens that an owner allowed to a spender.
253    *
254    * approve should be called when allowed[_spender] == 0. To decrement
255    * allowed value is better to use this function to avoid 2 calls (and wait until
256    * the first transaction is mined)
257    * From MonolithDAO Token.sol
258    * @param _spender The address which will spend the funds.
259    * @param _subtractedValue The amount of tokens to decrease the allowance by.
260    */
261   function decreaseApproval(
262     address _spender,
263     uint _subtractedValue
264   )
265     public
266     returns (bool)
267   {
268     uint oldValue = allowed[msg.sender][_spender];
269     if (_subtractedValue > oldValue) {
270       allowed[msg.sender][_spender] = 0;
271     } else {
272       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
273     }
274     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
275     return true;
276   }
277 
278 }
279 
280 contract ArtBlockchainToken is StandardToken, Ownable {
281     string public name = "Art Blockchain Token";
282     string public symbol = "ARTCN";
283     uint public decimals = 18;
284     uint internal INITIAL_SUPPLY = (10 ** 9) * (10 ** decimals);
285 
286     mapping(address => uint256) private userLockedTokens;
287     event Freeze(address indexed account, uint256 value);
288     event UnFreeze(address indexed account, uint256 value);
289 
290 
291     constructor(address _addressFounder) public {
292         totalSupply_ = INITIAL_SUPPLY;
293         balances[_addressFounder] = INITIAL_SUPPLY;
294         emit Transfer(0x0, _addressFounder, INITIAL_SUPPLY);
295     }
296 
297     function balance(address _owner) internal view returns (uint256 token) {
298         return balances[_owner].sub(userLockedTokens[_owner]);
299     }
300 
301     function lockedTokens(address _owner) public view returns (uint256 token) {
302         return userLockedTokens[_owner];
303     }
304 
305 	function freezeAccount(address _userAddress, uint256 _amount) onlyOwner public returns (bool success) {
306         require(balance(_userAddress) >= _amount);
307         userLockedTokens[_userAddress] = userLockedTokens[_userAddress].add(_amount);
308         emit Freeze(_userAddress, _amount);
309         return true;
310     }
311 
312     function unfreezeAccount(address _userAddress, uint256 _amount) onlyOwner public returns (bool success) {
313         require(userLockedTokens[_userAddress] >= _amount);
314         userLockedTokens[_userAddress] = userLockedTokens[_userAddress].sub(_amount);
315         emit UnFreeze(_userAddress, _amount);
316         return true;
317     }
318 
319      function transfer(address _to, uint256 _value)  public returns (bool success) {
320         require(balance(msg.sender) >= _value);
321         return super.transfer(_to, _value);
322     }
323 
324     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
325         require(balance(_from) >= _value);
326         return super.transferFrom(_from, _to, _value);
327     }
328 
329 
330 }