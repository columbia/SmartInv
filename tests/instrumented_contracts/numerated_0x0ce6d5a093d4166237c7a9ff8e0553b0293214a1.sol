1 pragma solidity ^0.4.21;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: contracts/BonusStrategy.sol
52 
53 contract BonusStrategy {
54     using SafeMath for uint;
55 
56     uint public defaultAmount = 1*10**18;
57     uint public limit = 300*1000*10**18; // 300.000  DCNT
58     uint public currentAmount = 0;
59     uint[] public startTimes;
60     uint[] public endTimes;
61     uint[] public amounts;
62 
63     constructor(
64         uint[] _startTimes,
65         uint[] _endTimes,
66         uint[] _amounts
67         ) public 
68     {
69         require(_startTimes.length == _endTimes.length && _endTimes.length == _amounts.length);
70         startTimes = _startTimes;
71         endTimes = _endTimes;
72         amounts = _amounts;
73     }
74 
75     function isStrategy() external pure returns (bool) {
76         return true;
77     }
78 
79     function getCurrentBonus() public view returns (uint bonus) {
80         if (currentAmount >= limit) {
81             currentAmount = currentAmount.add(defaultAmount);
82             return defaultAmount;
83         }
84         for (uint8 i = 0; i < amounts.length; i++) {
85             if (now >= startTimes[i] && now <= endTimes[i]) {
86                 bonus = amounts[i];
87                 currentAmount = currentAmount.add(bonus);
88                 return bonus;
89             }
90         }
91         currentAmount = currentAmount.add(defaultAmount);
92         return defaultAmount;
93     }
94 
95 }
96 
97 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
98 
99 /**
100  * @title ERC20Basic
101  * @dev Simpler version of ERC20 interface
102  * @dev see https://github.com/ethereum/EIPs/issues/179
103  */
104 contract ERC20Basic {
105   function totalSupply() public view returns (uint256);
106   function balanceOf(address who) public view returns (uint256);
107   function transfer(address to, uint256 value) public returns (bool);
108   event Transfer(address indexed from, address indexed to, uint256 value);
109 }
110 
111 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
112 
113 /**
114  * @title Basic token
115  * @dev Basic version of StandardToken, with no allowances.
116  */
117 contract BasicToken is ERC20Basic {
118   using SafeMath for uint256;
119 
120   mapping(address => uint256) balances;
121 
122   uint256 totalSupply_;
123 
124   /**
125   * @dev total number of tokens in existence
126   */
127   function totalSupply() public view returns (uint256) {
128     return totalSupply_;
129   }
130 
131   /**
132   * @dev transfer token for a specified address
133   * @param _to The address to transfer to.
134   * @param _value The amount to be transferred.
135   */
136   function transfer(address _to, uint256 _value) public returns (bool) {
137     require(_to != address(0));
138     require(_value <= balances[msg.sender]);
139 
140     balances[msg.sender] = balances[msg.sender].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     emit Transfer(msg.sender, _to, _value);
143     return true;
144   }
145 
146   /**
147   * @dev Gets the balance of the specified address.
148   * @param _owner The address to query the the balance of.
149   * @return An uint256 representing the amount owned by the passed address.
150   */
151   function balanceOf(address _owner) public view returns (uint256) {
152     return balances[_owner];
153   }
154 
155 }
156 
157 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
158 
159 /**
160  * @title Burnable Token
161  * @dev Token that can be irreversibly burned (destroyed).
162  */
163 contract BurnableToken is BasicToken {
164 
165   event Burn(address indexed burner, uint256 value);
166 
167   /**
168    * @dev Burns a specific amount of tokens.
169    * @param _value The amount of token to be burned.
170    */
171   function burn(uint256 _value) public {
172     _burn(msg.sender, _value);
173   }
174 
175   function _burn(address _who, uint256 _value) internal {
176     require(_value <= balances[_who]);
177     // no need to require value <= totalSupply, since that would imply the
178     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
179 
180     balances[_who] = balances[_who].sub(_value);
181     totalSupply_ = totalSupply_.sub(_value);
182     emit Burn(_who, _value);
183     emit Transfer(_who, address(0), _value);
184   }
185 }
186 
187 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
188 
189 /**
190  * @title ERC20 interface
191  * @dev see https://github.com/ethereum/EIPs/issues/20
192  */
193 contract ERC20 is ERC20Basic {
194   function allowance(address owner, address spender) public view returns (uint256);
195   function transferFrom(address from, address to, uint256 value) public returns (bool);
196   function approve(address spender, uint256 value) public returns (bool);
197   event Approval(address indexed owner, address indexed spender, uint256 value);
198 }
199 
200 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
201 
202 /**
203  * @title Standard ERC20 token
204  *
205  * @dev Implementation of the basic standard token.
206  * @dev https://github.com/ethereum/EIPs/issues/20
207  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
208  */
209 contract StandardToken is ERC20, BasicToken {
210 
211   mapping (address => mapping (address => uint256)) internal allowed;
212 
213 
214   /**
215    * @dev Transfer tokens from one address to another
216    * @param _from address The address which you want to send tokens from
217    * @param _to address The address which you want to transfer to
218    * @param _value uint256 the amount of tokens to be transferred
219    */
220   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
221     require(_to != address(0));
222     require(_value <= balances[_from]);
223     require(_value <= allowed[_from][msg.sender]);
224 
225     balances[_from] = balances[_from].sub(_value);
226     balances[_to] = balances[_to].add(_value);
227     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
228     emit Transfer(_from, _to, _value);
229     return true;
230   }
231 
232   /**
233    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
234    *
235    * Beware that changing an allowance with this method brings the risk that someone may use both the old
236    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
237    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
238    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
239    * @param _spender The address which will spend the funds.
240    * @param _value The amount of tokens to be spent.
241    */
242   function approve(address _spender, uint256 _value) public returns (bool) {
243     allowed[msg.sender][_spender] = _value;
244     emit Approval(msg.sender, _spender, _value);
245     return true;
246   }
247 
248   /**
249    * @dev Function to check the amount of tokens that an owner allowed to a spender.
250    * @param _owner address The address which owns the funds.
251    * @param _spender address The address which will spend the funds.
252    * @return A uint256 specifying the amount of tokens still available for the spender.
253    */
254   function allowance(address _owner, address _spender) public view returns (uint256) {
255     return allowed[_owner][_spender];
256   }
257 
258   /**
259    * @dev Increase the amount of tokens that an owner allowed to a spender.
260    *
261    * approve should be called when allowed[_spender] == 0. To increment
262    * allowed value is better to use this function to avoid 2 calls (and wait until
263    * the first transaction is mined)
264    * From MonolithDAO Token.sol
265    * @param _spender The address which will spend the funds.
266    * @param _addedValue The amount of tokens to increase the allowance by.
267    */
268   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
269     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
270     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
271     return true;
272   }
273 
274   /**
275    * @dev Decrease the amount of tokens that an owner allowed to a spender.
276    *
277    * approve should be called when allowed[_spender] == 0. To decrement
278    * allowed value is better to use this function to avoid 2 calls (and wait until
279    * the first transaction is mined)
280    * From MonolithDAO Token.sol
281    * @param _spender The address which will spend the funds.
282    * @param _subtractedValue The amount of tokens to decrease the allowance by.
283    */
284   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
285     uint oldValue = allowed[msg.sender][_spender];
286     if (_subtractedValue > oldValue) {
287       allowed[msg.sender][_spender] = 0;
288     } else {
289       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
290     }
291     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
292     return true;
293   }
294 
295 }
296 
297 // File: contracts/InfoBurnableToken.sol
298 
299 contract InfoBurnableToken is BurnableToken, StandardToken {
300     string message = "No sufficient funds";
301     address public manager;
302 
303     event NoFunds(address _who, string _message);
304 
305     modifier onlyManager() {
306         require(msg.sender == manager);
307         _;
308     }
309 
310     constructor(address _manager) public {
311         require(address(_manager) != 0);
312         manager = _manager;
313     }
314 
315     function burn(uint256 _value) public {
316         if (balances[msg.sender] < _value){
317             emit NoFunds(msg.sender, message);
318         }else {
319             _burn(msg.sender, _value);
320         }
321     }
322 
323     function burnPassportToken(address _from, uint256 _value) onlyManager public returns (bool) {
324         if (_value <= balances[_from]){
325             _burn(_from, _value);
326             return true;
327         }
328         emit NoFunds(_from, message);
329         return false;
330     }
331 
332     function transferManager(address _newManager) onlyManager public returns (bool) {
333         require(address(_newManager) != 0);
334         manager = _newManager;
335         return true;
336     }
337 
338 }
339 
340 // File: contracts/DecenturionToken.sol
341 
342 contract DecenturionToken is InfoBurnableToken {
343     using SafeMath for uint;
344 
345     string constant public name = "Decenturion Token";
346     string constant public symbol = "DCNT";
347     uint constant public decimals = 18;
348     uint constant public deployerAmount = 20 * (10 ** 6) * (10 ** decimals); // 20 000 000 DCNT
349     uint constant public managerAmount = 10 * (10 ** 6) * (10 ** decimals); // 10 000 000 DCNT
350 
351     constructor(address _manager) InfoBurnableToken(_manager) public {
352         totalSupply_ = 30 * (10 ** 6) * (10 ** decimals); // 30 000 000 DCNT
353         balances[msg.sender] = deployerAmount;
354         balances[manager] = managerAmount;
355     }
356 
357 }