1 pragma solidity ^0.5.8;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
12     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
13     // benefit is lost if 'b' is also tested.
14     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15     if (_a == 0) {
16       return 0;
17     }
18 
19     c = _a * _b;
20     assert(c / _a == _b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
28     // assert(_b > 0); // Solidity automatically throws when dividing by 0
29     // uint256 c = _a / _b;
30     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
31     return _a / _b;
32   }
33 
34   /**
35   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
38     assert(_b <= _a);
39     return _a - _b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
46     c = _a + _b;
47     assert(c >= _a);
48     return c;
49   }
50 }
51 
52 /**
53  * @title ERC20Basic
54  * @dev Simpler version of ERC20 interface
55  * See https://github.com/ethereum/EIPs/issues/179
56  */
57 contract ERC20Basic {
58   function totalSupply() public view returns (uint256);
59   function balanceOf(address _who) public view returns (uint256);
60   function transfer(address _to, uint256 _value) public returns (bool);
61   event Transfer(address indexed from, address indexed to, uint256 value);
62 }
63 
64 /**
65  * @title ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/20
67  */
68 contract ERC20 is ERC20Basic {
69   function allowance(address _owner, address _spender)
70     public view returns (uint256);
71 
72   function transferFrom(address _from, address _to, uint256 _value)
73     public returns (bool);
74 
75   function approve(address _spender, uint256 _value) public returns (bool);
76   event Approval(
77     address indexed owner,
78     address indexed spender,
79     uint256 value
80   );
81 }
82 
83 /**
84  * @title Basic token
85  * @dev Basic version of StandardToken, with no allowances.
86  */
87 contract BasicToken is ERC20Basic {
88   using SafeMath for uint256;
89 
90   mapping(address => uint256) internal balances;
91 
92   uint256 internal totalSupply_;
93 
94   /**
95   * @dev Total number of tokens in existence
96   */
97   function totalSupply() public view returns (uint256) {
98     return totalSupply_;
99   }
100 
101   /**
102   * @dev Transfer token for a specified address
103   * @param _to The address to transfer to.
104   * @param _value The amount to be transferred.
105   */
106   function transfer(address _to, uint256 _value) public returns (bool) {
107     require(_value <= balances[msg.sender]);
108     require(_to != address(0));
109 
110     balances[msg.sender] = balances[msg.sender].sub(_value);
111     balances[_to] = balances[_to].add(_value);
112     emit Transfer(msg.sender, _to, _value);
113     return true;
114   }
115 
116   /**
117   * @dev Gets the balance of the specified address.
118   * @param _owner The address to query the the balance of.
119   * @return An uint256 representing the amount owned by the passed address.
120   */
121   function balanceOf(address _owner) public view returns (uint256) {
122     return balances[_owner];
123   }
124 }
125 
126 /**
127  * @title Standard ERC20 token
128  *
129  * @dev Implementation of the basic standard token.
130  * https://github.com/ethereum/EIPs/issues/20
131  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
132  */
133 contract StandardToken is ERC20, BasicToken {
134   mapping (address => mapping (address => uint256)) internal allowed;
135 
136   /**
137    * @dev Transfer tokens from one address to another
138    * @param _from address The address which you want to send tokens from
139    * @param _to address The address which you want to transfer to
140    * @param _value uint256 the amount of tokens to be transferred
141    */
142   function transferFrom(
143     address _from,
144     address _to,
145     uint256 _value
146   )
147     public
148     returns (bool)
149   {
150     require(_value <= balances[_from]);
151     require(_value <= allowed[_from][msg.sender]);
152     require(_to != address(0));
153 
154     balances[_from] = balances[_from].sub(_value);
155     balances[_to] = balances[_to].add(_value);
156     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
157     emit Transfer(_from, _to, _value);
158     return true;
159   }
160 
161   /**
162    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
163    * Beware that changing an allowance with this method brings the risk that someone may use both the old
164    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
165    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
166    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167    * @param _spender The address which will spend the funds.
168    * @param _value The amount of tokens to be spent.
169    */
170   function approve(address _spender, uint256 _value) public returns (bool) {
171     allowed[msg.sender][_spender] = _value;
172     emit Approval(msg.sender, _spender, _value);
173     return true;
174   }
175 
176   /**
177    * @dev Function to check the amount of tokens that an owner allowed to a spender.
178    * @param _owner address The address which owns the funds.
179    * @param _spender address The address which will spend the funds.
180    * @return A uint256 specifying the amount of tokens still available for the spender.
181    */
182   function allowance(
183     address _owner,
184     address _spender
185    )
186     public
187     view
188     returns (uint256)
189   {
190     return allowed[_owner][_spender];
191   }
192 
193   /**
194    * @dev Increase the amount of tokens that an owner allowed to a spender.
195    * approve should be called when allowed[_spender] == 0. To increment
196    * allowed value is better to use this function to avoid 2 calls (and wait until
197    * the first transaction is mined)
198    * From MonolithDAO Token.sol
199    * @param _spender The address which will spend the funds.
200    * @param _addedValue The amount of tokens to increase the allowance by.
201    */
202   function increaseApproval(
203     address _spender,
204     uint256 _addedValue
205   )
206     public
207     returns (bool)
208   {
209     allowed[msg.sender][_spender] = (
210       allowed[msg.sender][_spender].add(_addedValue));
211     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
212     return true;
213   }
214 
215   /**
216    * @dev Decrease the amount of tokens that an owner allowed to a spender.
217    * approve should be called when allowed[_spender] == 0. To decrement
218    * allowed value is better to use this function to avoid 2 calls (and wait until
219    * the first transaction is mined)
220    * From MonolithDAO Token.sol
221    * @param _spender The address which will spend the funds.
222    * @param _subtractedValue The amount of tokens to decrease the allowance by.
223    */
224   function decreaseApproval(
225     address _spender,
226     uint256 _subtractedValue
227   )
228     public
229     returns (bool)
230   {
231     uint256 oldValue = allowed[msg.sender][_spender];
232     if (_subtractedValue >= oldValue) {
233       allowed[msg.sender][_spender] = 0;
234     } else {
235       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
236     }
237     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238     return true;
239   }
240 }
241 
242 /**
243  * @title Ownable
244  * @dev The Ownable contract has an owner address, and provides basic authorization control
245  * functions, this simplifies the implementation of "user permissions".
246  */
247 contract Ownable {
248   address public owner;
249 
250   event OwnershipRenounced(address indexed previousOwner);
251   event OwnershipTransferred(
252     address indexed previousOwner,
253     address indexed newOwner
254   );
255 
256   /**
257    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
258    * account.
259    */
260   constructor() public {
261     owner = msg.sender;
262   }
263 
264   /**
265    * @dev Throws if called by any account other than the owner.
266    */
267   modifier onlyOwner() {
268     require(msg.sender == owner);
269     _;
270   }
271 
272   /**
273    * @dev Allows the current owner to relinquish control of the contract.
274    * @notice Renouncing to ownership will leave the contract without an owner.
275    * It will not be possible to call the functions with the `onlyOwner`
276    * modifier anymore.
277    */
278   function renounceOwnership() public onlyOwner {
279     emit OwnershipRenounced(owner);
280     owner = address(0);
281   }
282 
283   /**
284    * @dev Allows the current owner to transfer control of the contract to a newOwner.
285    * @param _newOwner The address to transfer ownership to.
286    */
287   function transferOwnership(address _newOwner) public onlyOwner {
288     _transferOwnership(_newOwner);
289   }
290 
291   /**
292    * @dev Transfers control of the contract to a newOwner.
293    * @param _newOwner The address to transfer ownership to.
294    */
295   function _transferOwnership(address _newOwner) internal {
296     require(_newOwner != address(0));
297     emit OwnershipTransferred(owner, _newOwner);
298     owner = _newOwner;
299   }
300 }
301 
302 contract Gentrion is StandardToken, Ownable {
303   string public name;                   // Token Name
304   uint8 public decimals;                // How many decimals to show. To be standard complicant keep it 18
305   string public symbol;                 // An identifier: eg SBX, XPR etc..
306   string public version = 'H1.0';
307   
308   struct UserHistory{
309     address rUser;  //uint160 20byte
310     string word1;   //unlimited
311     string word2;   //unlimited
312   }
313 
314   mapping (uint256 => UserHistory) private hisList;
315   uint256 private hisCount;
316 
317   constructor() public {
318     // make the deployer rich
319     totalSupply_ = 3850000000 * 1 ether;
320     balances[msg.sender] = totalSupply_;
321     name = "Gentrion";                                      // Set the name for display purposes (CHANGE THIS)
322     decimals = 18;                                          // Amount of decimals for display purposes (CHANGE THIS)
323     symbol = "GENT";                                        // Set the symbol for display purposes (CHANGE THIS)
324   }
325 
326   function addTokenInfo (address _toAddress, string memory _word1, string memory _word2, uint256 amount) onlyOwner public {
327     if (transfer(_toAddress, amount)) {
328       hisList[hisCount] = UserHistory(_toAddress, _word1, _word2);
329       hisCount++;
330     }
331   }
332 
333   function getTokenInfo(uint256 _id) onlyOwner public view returns (address, string memory, string memory) {
334     return (hisList[_id].rUser, hisList[_id].word1,hisList[_id].word2);
335   }
336 
337   function getTokenInfoCount() onlyOwner public view returns (uint256) {
338     return hisCount;
339   }
340 }