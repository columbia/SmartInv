1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (a == 0) {
13       return 0;
14     }
15 
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract ERC20Basic {
50   function totalSupply() public view returns (uint256);
51   function balanceOf(address who) public view returns (uint256);
52   function transfer(address to, uint256 value) public returns (bool);
53   event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 
56 contract BasicToken is ERC20Basic {
57   using SafeMath for uint256;
58 
59   mapping(address => uint256) balances;
60 
61   uint256 totalSupply_;
62 
63   /**
64   * @dev total number of tokens in existence
65   */
66   function totalSupply() public view returns (uint256) {
67     return totalSupply_;
68   }
69 
70   /**
71   * @dev transfer token for a specified address
72   * @param _to The address to transfer to.
73   * @param _value The amount to be transferred.
74   */
75   function transfer(address _to, uint256 _value) public returns (bool) {
76     require(_to != address(0));
77     require(_value <= balances[msg.sender]);
78 
79     balances[msg.sender] = balances[msg.sender].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     emit Transfer(msg.sender, _to, _value);
82     return true;
83   }
84 
85   /**
86   * @dev Gets the balance of the specified address.
87   * @param _owner The address to query the the balance of.
88   * @return An uint256 representing the amount owned by the passed address.
89   */
90   function balanceOf(address _owner) public view returns (uint256) {
91     return balances[_owner];
92   }
93 
94 }
95 
96 contract BurnableToken is BasicToken {
97 
98   event Burn(address indexed burner, uint256 value);
99 
100   /**
101    * @dev Burns a specific amount of tokens.
102    * @param _value The amount of token to be burned.
103    */
104   function burn(uint256 _value) public {
105     _burn(msg.sender, _value);
106   }
107 
108   function _burn(address _who, uint256 _value) internal {
109     require(_value <= balances[_who]);
110     // no need to require value <= totalSupply, since that would imply the
111     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
112 
113     balances[_who] = balances[_who].sub(_value);
114     totalSupply_ = totalSupply_.sub(_value);
115     emit Burn(_who, _value);
116     emit Transfer(_who, address(0), _value);
117   }
118 }
119 
120 contract Ownable {
121   address public owner;
122 
123 
124   event OwnershipRenounced(address indexed previousOwner);
125   event OwnershipTransferred(
126     address indexed previousOwner,
127     address indexed newOwner
128   );
129 
130 
131   /**
132    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
133    * account.
134    */
135   constructor() public {
136     owner = msg.sender;
137   }
138 
139   /**
140    * @dev Throws if called by any account other than the owner.
141    */
142   modifier onlyOwner() {
143     require(msg.sender == owner);
144     _;
145   }
146 
147   /**
148    * @dev Allows the current owner to relinquish control of the contract.
149    */
150   function renounceOwnership() public onlyOwner {
151     emit OwnershipRenounced(owner);
152     owner = address(0);
153   }
154 
155   /**
156    * @dev Allows the current owner to transfer control of the contract to a newOwner.
157    * @param _newOwner The address to transfer ownership to.
158    */
159   function transferOwnership(address _newOwner) public onlyOwner {
160     _transferOwnership(_newOwner);
161   }
162 
163   /**
164    * @dev Transfers control of the contract to a newOwner.
165    * @param _newOwner The address to transfer ownership to.
166    */
167   function _transferOwnership(address _newOwner) internal {
168     require(_newOwner != address(0));
169     emit OwnershipTransferred(owner, _newOwner);
170     owner = _newOwner;
171   }
172 }
173 
174 contract ERC20 is ERC20Basic {
175   function allowance(address owner, address spender)
176     public view returns (uint256);
177 
178   function transferFrom(address from, address to, uint256 value)
179     public returns (bool);
180 
181   function approve(address spender, uint256 value) public returns (bool);
182   event Approval(
183     address indexed owner,
184     address indexed spender,
185     uint256 value
186   );
187 }
188 
189 contract StandardToken is ERC20, BasicToken {
190 
191   mapping (address => mapping (address => uint256)) internal allowed;
192 
193 
194   /**
195    * @dev Transfer tokens from one address to another
196    * @param _from address The address which you want to send tokens from
197    * @param _to address The address which you want to transfer to
198    * @param _value uint256 the amount of tokens to be transferred
199    */
200   function transferFrom(
201     address _from,
202     address _to,
203     uint256 _value
204   )
205     public
206     returns (bool)
207   {
208     require(_to != address(0));
209     require(_value <= balances[_from]);
210     require(_value <= allowed[_from][msg.sender]);
211 
212     balances[_from] = balances[_from].sub(_value);
213     balances[_to] = balances[_to].add(_value);
214     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
215     emit Transfer(_from, _to, _value);
216     return true;
217   }
218 
219   /**
220    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
221    *
222    * Beware that changing an allowance with this method brings the risk that someone may use both the old
223    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
224    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
225    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
226    * @param _spender The address which will spend the funds.
227    * @param _value The amount of tokens to be spent.
228    */
229   function approve(address _spender, uint256 _value) public returns (bool) {
230     allowed[msg.sender][_spender] = _value;
231     emit Approval(msg.sender, _spender, _value);
232     return true;
233   }
234 
235   /**
236    * @dev Function to check the amount of tokens that an owner allowed to a spender.
237    * @param _owner address The address which owns the funds.
238    * @param _spender address The address which will spend the funds.
239    * @return A uint256 specifying the amount of tokens still available for the spender.
240    */
241   function allowance(
242     address _owner,
243     address _spender
244    )
245     public
246     view
247     returns (uint256)
248   {
249     return allowed[_owner][_spender];
250   }
251 
252   /**
253    * @dev Increase the amount of tokens that an owner allowed to a spender.
254    *
255    * approve should be called when allowed[_spender] == 0. To increment
256    * allowed value is better to use this function to avoid 2 calls (and wait until
257    * the first transaction is mined)
258    * From MonolithDAO Token.sol
259    * @param _spender The address which will spend the funds.
260    * @param _addedValue The amount of tokens to increase the allowance by.
261    */
262   function increaseApproval(
263     address _spender,
264     uint _addedValue
265   )
266     public
267     returns (bool)
268   {
269     allowed[msg.sender][_spender] = (
270       allowed[msg.sender][_spender].add(_addedValue));
271     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272     return true;
273   }
274 
275   /**
276    * @dev Decrease the amount of tokens that an owner allowed to a spender.
277    *
278    * approve should be called when allowed[_spender] == 0. To decrement
279    * allowed value is better to use this function to avoid 2 calls (and wait until
280    * the first transaction is mined)
281    * From MonolithDAO Token.sol
282    * @param _spender The address which will spend the funds.
283    * @param _subtractedValue The amount of tokens to decrease the allowance by.
284    */
285   function decreaseApproval(
286     address _spender,
287     uint _subtractedValue
288   )
289     public
290     returns (bool)
291   {
292     uint oldValue = allowed[msg.sender][_spender];
293     if (_subtractedValue > oldValue) {
294       allowed[msg.sender][_spender] = 0;
295     } else {
296       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
297     }
298     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
299     return true;
300   }
301 
302 }
303 
304 contract DetailedERC20 is ERC20 {
305   string public name;
306   string public symbol;
307   uint8 public decimals;
308 
309   constructor(string _name, string _symbol, uint8 _decimals) public {
310     name = _name;
311     symbol = _symbol;
312     decimals = _decimals;
313   }
314 }
315 
316 contract CryptonityToken is DetailedERC20, BurnableToken, StandardToken, Ownable {
317 
318   string public constant name = "Cryptonity"; // solium-disable-line uppercase
319   string public constant symbol = "XNY"; // solium-disable-line uppercase
320   uint8 public constant decimals = 18; // solium-disable-line uppercase
321 
322   uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals)); // solium-disable-line max-len
323 
324   /**
325   * @dev Constructor that gives msg.sender all of existing tokens.
326   */
327   constructor() DetailedERC20(name, symbol, decimals) public {
328     totalSupply_ = INITIAL_SUPPLY;
329     balances[msg.sender] = INITIAL_SUPPLY;
330     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
331   }
332 
333   /**
334   * @dev burns the provided the _value, can be used only by the owner of the contract.
335   * @param _value The value of the tokens to be burnt.
336   */
337   function burn(uint256 _value) public onlyOwner {
338     super.burn(_value);
339   }
340 
341 }