1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 
55 /**
56  * @title ERC20Basic
57  * @dev Simpler version of ERC20 interface
58  * @dev see https://github.com/ethereum/EIPs/issues/179
59  */
60 contract ERC20Basic {
61   function totalSupply() public view returns (uint256);
62   function balanceOf(address who) public view returns (uint256);
63   function transfer(address to, uint256 value) public returns (bool);
64   event Transfer(address indexed from, address indexed to, uint256 value);
65 }
66 
67 
68 /**
69  * @title ERC20 interface
70  * @dev see https://github.com/ethereum/EIPs/issues/20
71  */
72 contract ERC20 is ERC20Basic {
73   function allowance(address owner, address spender)
74     public view returns (uint256);
75 
76   function transferFrom(address from, address to, uint256 value)
77     public returns (bool);
78 
79   function approve(address spender, uint256 value) public returns (bool);
80   event Approval(
81     address indexed owner,
82     address indexed spender,
83     uint256 value
84   );
85 }
86 
87 
88 /**
89  * @title Basic token
90  * @dev Basic version of StandardToken, with no allowances.
91  */
92 contract BasicToken is ERC20Basic {
93   using SafeMath for uint256;
94 
95   mapping(address => uint256) balances;
96 
97   uint256 totalSupply_;
98 
99   /**
100   * @dev total number of tokens in existence
101   */
102   function totalSupply() public view returns (uint256) {
103     return totalSupply_;
104   }
105 
106   /**
107   * @dev transfer token for a specified address
108   * @param _to The address to transfer to.
109   * @param _value The amount to be transferred.
110   */
111   function transfer(address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113     require(_value <= balances[msg.sender]);
114 
115     balances[msg.sender] = balances[msg.sender].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     emit Transfer(msg.sender, _to, _value);
118     return true;
119   }
120 
121   /**
122   * @dev Gets the balance of the specified address.
123   * @param _owner The address to query the the balance of.
124   * @return An uint256 representing the amount owned by the passed address.
125   */
126   function balanceOf(address _owner) public view returns (uint256) {
127     return balances[_owner];
128   }
129 
130 }
131 
132 /**
133  * @title Standard ERC20 token
134  *
135  * @dev Implementation of the basic standard token.
136  * @dev https://github.com/ethereum/EIPs/issues/20
137  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
138  */
139 contract StandardToken is ERC20, BasicToken {
140 
141   mapping (address => mapping (address => uint256)) internal allowed;
142 
143 
144   /**
145    * @dev Transfer tokens from one address to another
146    * @param _from address The address which you want to send tokens from
147    * @param _to address The address which you want to transfer to
148    * @param _value uint256 the amount of tokens to be transferred
149    */
150   function transferFrom(
151     address _from,
152     address _to,
153     uint256 _value
154   )
155     public
156     returns (bool)
157   {
158     require(_to != address(0));
159     require(_value <= balances[_from]);
160     require(_value <= allowed[_from][msg.sender]);
161 
162     balances[_from] = balances[_from].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
165     emit Transfer(_from, _to, _value);
166     return true;
167   }
168 
169   /**
170    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
171    *
172    * Beware that changing an allowance with this method brings the risk that someone may use both the old
173    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
174    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
175    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176    * @param _spender The address which will spend the funds.
177    * @param _value The amount of tokens to be spent.
178    */
179   function approve(address _spender, uint256 _value) public returns (bool) {
180     allowed[msg.sender][_spender] = _value;
181     emit Approval(msg.sender, _spender, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Function to check the amount of tokens that an owner allowed to a spender.
187    * @param _owner address The address which owns the funds.
188    * @param _spender address The address which will spend the funds.
189    * @return A uint256 specifying the amount of tokens still available for the spender.
190    */
191   function allowance(
192     address _owner,
193     address _spender
194    )
195     public
196     view
197     returns (uint256)
198   {
199     return allowed[_owner][_spender];
200   }
201 
202   /**
203    * @dev Increase the amount of tokens that an owner allowed to a spender.
204    *
205    * approve should be called when allowed[_spender] == 0. To increment
206    * allowed value is better to use this function to avoid 2 calls (and wait until
207    * the first transaction is mined)
208    * From MonolithDAO Token.sol
209    * @param _spender The address which will spend the funds.
210    * @param _addedValue The amount of tokens to increase the allowance by.
211    */
212   function increaseApproval(
213     address _spender,
214     uint _addedValue
215   )
216     public
217     returns (bool)
218   {
219     allowed[msg.sender][_spender] = (
220       allowed[msg.sender][_spender].add(_addedValue));
221     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225   /**
226    * @dev Decrease the amount of tokens that an owner allowed to a spender.
227    *
228    * approve should be called when allowed[_spender] == 0. To decrement
229    * allowed value is better to use this function to avoid 2 calls (and wait until
230    * the first transaction is mined)
231    * From MonolithDAO Token.sol
232    * @param _spender The address which will spend the funds.
233    * @param _subtractedValue The amount of tokens to decrease the allowance by.
234    */
235   function decreaseApproval(
236     address _spender,
237     uint _subtractedValue
238   )
239     public
240     returns (bool)
241   {
242     uint oldValue = allowed[msg.sender][_spender];
243     if (_subtractedValue > oldValue) {
244       allowed[msg.sender][_spender] = 0;
245     } else {
246       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
247     }
248     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249     return true;
250   }
251 
252 }
253 
254 
255 contract HadePayToken is StandardToken {
256 
257     using SafeMath for uint256;
258 
259     /**********************************
260      *  Events
261      */
262     event Mint(address indexed to, uint256 amount);
263     event Burn(address indexed burner, uint256 value);
264     event ChangeOwnerAddress(uint256  blockTimeStamp, address indexed ownerAddress);
265     event ChangeServerAddress(uint256  blockTimeStamp, address indexed serverAddress);
266 
267     /**********************************
268      *  Storage
269      */
270 
271     // name of the token
272     string public name = "HadePay";
273     string public symbol = "HPAY";
274 
275     // token supply and precision
276     uint8 public decimals = 18;
277     uint256 public totalSupply = 75000000 * 10**18;
278 
279     // important addresses
280     address public hPayMultiSig;
281     address public serverAddress;
282 
283     /**********************************
284      *  Constructor
285      */
286     constructor(address _hPayMultiSig) public {
287 
288         hPayMultiSig = _hPayMultiSig;
289         balances[_hPayMultiSig] = totalSupply;
290     }
291 
292     /**********************************
293      *  Fallback
294      */
295     function() public {
296         revert();
297     }
298 
299     /**********************************
300      *  Modifiers
301      */
302     modifier nonZeroAddress(address _to) {
303         require(_to != 0x0);
304         _;
305     }
306 
307     modifier onlyOwner() {
308         require(msg.sender == hPayMultiSig);
309         _;
310     }
311 
312     /**********************************
313      *  Owner Functions
314      */
315      // @title mint sends new coin to the specificed recepiant
316      // @param _to is the recepiant the new coins
317      // @param _value is the number of coins to mint
318      function mint(address _to, uint256 _value) external onlyOwner {
319 
320          require(_to != address(0));
321          require(_value > 0);
322          totalSupply.add(_value);
323          balances[_to].add(_value);
324          emit Mint(_to, _value);
325          emit Transfer(address(0), _to, _value);
326      }
327 
328      // @title burn allows the administrator to burn their own tokens
329      // @param _value is the number of tokens to burn
330      // @dev note that admin can only burn their own tokens
331      function burn(uint256 _value) external onlyOwner {
332 
333          require(_value > 0 && balances[msg.sender] >= _value);
334          totalSupply.sub(_value);
335          balances[msg.sender].sub(_value);
336          emit Burn(msg.sender, _value);
337      }
338 
339      // @title changeAdminAddress allows to update the owner wallet
340      // @param _newAddress is the address of the new admin wallet
341      // @dev only callable by current owner
342      function setOwnerAddress(address _newAddress)
343 
344      external
345      onlyOwner
346      nonZeroAddress(_newAddress)
347      {
348          hPayMultiSig = _newAddress;
349          emit ChangeOwnerAddress(now, hPayMultiSig);
350      }
351 
352      function setServerAddress(address _newAddress)
353 
354      external
355      onlyOwner
356      nonZeroAddress(_newAddress)
357      {
358          serverAddress = _newAddress;
359          emit ChangeServerAddress(now, serverAddress);
360      }
361 
362      function getOwnerAddress() external view returns (address) {
363          return hPayMultiSig;
364      }
365 
366      function getServerAddress() external view returns (address) {
367          return serverAddress;
368      }
369 }