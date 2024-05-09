1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract BasicToken is ERC20Basic {
11   using SafeMath for uint256;
12 
13   mapping(address => uint256) balances;
14 
15   uint256 totalSupply_;
16 
17   /**
18   * @dev total number of tokens in existence
19   */
20   function totalSupply() public view returns (uint256) {
21     return totalSupply_;
22   }
23 
24   /**
25   * @dev transfer token for a specified address
26   * @param _to The address to transfer to.
27   * @param _value The amount to be transferred.
28   */
29   function transfer(address _to, uint256 _value) public returns (bool) {
30     require(_to != address(0));
31     require(_value <= balances[msg.sender]);
32 
33     // SafeMath.sub will throw if there is not enough balance.
34     balances[msg.sender] = balances[msg.sender].sub(_value);
35     balances[_to] = balances[_to].add(_value);
36     emit Transfer(msg.sender, _to, _value);
37     return true;
38   }
39 
40   /**
41   * @dev Gets the balance of the specified address.
42   * @param _owner The address to query the the balance of.
43   * @return An uint256 representing the amount owned by the passed address.
44   */
45   function balanceOf(address _owner) public view returns (uint256 balance) {
46     return balances[_owner];
47   }
48 
49 }
50 
51 contract ERC20 is ERC20Basic {
52   function allowance(address owner, address spender) public view returns (uint256);
53   function transferFrom(address from, address to, uint256 value) public returns (bool);
54   function approve(address spender, uint256 value) public returns (bool);
55   event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 library SafeMath {
59 
60   /**
61   * @dev Multiplies two numbers, throws on overflow.
62   */
63   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64     if (a == 0) {
65       return 0;
66     }
67     uint256 c = a * b;
68     assert(c / a == b);
69     return c;
70   }
71 
72   /**
73   * @dev Integer division of two numbers, truncating the quotient.
74   */
75   function div(uint256 a, uint256 b) internal pure returns (uint256) {
76     // assert(b > 0); // Solidity automatically throws when dividing by 0
77     uint256 c = a / b;
78     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
79     return c;
80   }
81 
82   /**
83   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
84   */
85   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86     assert(b <= a);
87     return a - b;
88   }
89 
90   /**
91   * @dev Adds two numbers, throws on overflow.
92   */
93   function add(uint256 a, uint256 b) internal pure returns (uint256) {
94     uint256 c = a + b;
95     assert(c >= a);
96     return c;
97   }
98 }
99 
100 contract Ownable {
101   address public owner;
102 
103 
104   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
105 
106 
107   /**
108    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
109    * account.
110    */
111   function Ownable() public {
112     owner = msg.sender;
113   }
114 
115   /**
116    * @dev Throws if called by any account other than the owner.
117    */
118   modifier onlyOwner() {
119     require(msg.sender == owner);
120     _;
121   }
122 
123   /**
124    * @dev Allows the current owner to transfer control of the contract to a newOwner.
125    * @param newOwner The address to transfer ownership to.
126    */
127   function transferOwnership(address newOwner) public onlyOwner {
128     require(newOwner != address(0));
129     emit OwnershipTransferred(owner, newOwner);
130     owner = newOwner;
131   }
132 
133 }
134 
135 contract Crowdsaled is Ownable {
136         address public crowdsaleContract = address(0);
137         function Crowdsaled() public {
138         }
139 
140         modifier onlyCrowdsale{
141           require(msg.sender == crowdsaleContract);
142           _;
143         }
144 
145         modifier onlyCrowdsaleOrOwner {
146           require((msg.sender == crowdsaleContract) || (msg.sender == owner));
147           _;
148         }
149 
150         function setCrowdsale(address crowdsale) public onlyOwner() {
151                 crowdsaleContract = crowdsale;
152         }
153 }
154 
155 contract StandardToken is ERC20, BasicToken {
156 
157   mapping (address => mapping (address => uint256)) internal allowed;
158 
159 
160   /**
161    * @dev Transfer tokens from one address to another
162    * @param _from address The address which you want to send tokens from
163    * @param _to address The address which you want to transfer to
164    * @param _value uint256 the amount of tokens to be transferred
165    */
166   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
167     require(_to != address(0));
168     require(_value <= balances[_from]);
169     require(_value <= allowed[_from][msg.sender]);
170 
171     balances[_from] = balances[_from].sub(_value);
172     balances[_to] = balances[_to].add(_value);
173     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
174     emit Transfer(_from, _to, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
180    *
181    * Beware that changing an allowance with this method brings the risk that someone may use both the old
182    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
183    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
184    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185    * @param _spender The address which will spend the funds.
186    * @param _value The amount of tokens to be spent.
187    */
188   function approve(address _spender, uint256 _value) public returns (bool) {
189     allowed[msg.sender][_spender] = _value;
190     emit Approval(msg.sender, _spender, _value);
191     return true;
192   }
193 
194   /**
195    * @dev Function to check the amount of tokens that an owner allowed to a spender.
196    * @param _owner address The address which owns the funds.
197    * @param _spender address The address which will spend the funds.
198    * @return A uint256 specifying the amount of tokens still available for the spender.
199    */
200   function allowance(address _owner, address _spender) public view returns (uint256) {
201     return allowed[_owner][_spender];
202   }
203 
204   /**
205    * @dev Increase the amount of tokens that an owner allowed to a spender.
206    *
207    * approve should be called when allowed[_spender] == 0. To increment
208    * allowed value is better to use this function to avoid 2 calls (and wait until
209    * the first transaction is mined)
210    * From MonolithDAO Token.sol
211    * @param _spender The address which will spend the funds.
212    * @param _addedValue The amount of tokens to increase the allowance by.
213    */
214   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
215     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
216     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220   /**
221    * @dev Decrease the amount of tokens that an owner allowed to a spender.
222    *
223    * approve should be called when allowed[_spender] == 0. To decrement
224    * allowed value is better to use this function to avoid 2 calls (and wait until
225    * the first transaction is mined)
226    * From MonolithDAO Token.sol
227    * @param _spender The address which will spend the funds.
228    * @param _subtractedValue The amount of tokens to decrease the allowance by.
229    */
230   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
231     uint oldValue = allowed[msg.sender][_spender];
232     if (_subtractedValue > oldValue) {
233       allowed[msg.sender][_spender] = 0;
234     } else {
235       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
236     }
237     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238     return true;
239   }
240 
241 }
242 
243 contract LetItPlayToken is Crowdsaled, StandardToken {
244         uint256 public totalSupply;
245         string public name;
246         string public symbol;
247         uint8 public decimals;
248 
249         address public forSale;
250         address public preSale;
251         address public ecoSystemFund;
252         address public founders;
253         address public team;
254         address public advisers;
255         address public bounty;
256         address public eosShareDrop;
257 
258         bool releasedForTransfer;
259 
260         uint256 private shift;
261 
262         //initial coin distribution
263         function LetItPlayToken(
264             address _forSale,
265             address _ecoSystemFund,
266             address _founders,
267             address _team,
268             address _advisers,
269             address _bounty,
270             address _preSale,
271             address _eosShareDrop
272           ) public {
273           name = "LetItPlay Token";
274           symbol = "PLAY";
275           decimals = 8;
276           shift = uint256(10)**decimals;
277           totalSupply = 1000000000 * shift;
278           forSale = _forSale;
279           ecoSystemFund = _ecoSystemFund;
280           founders = _founders;
281           team = _team;
282           advisers = _advisers;
283           bounty = _bounty;
284           eosShareDrop = _eosShareDrop;
285           preSale = _preSale;
286 
287           balances[forSale] = totalSupply * 59 / 100;
288           balances[ecoSystemFund] = totalSupply * 15 / 100;
289           balances[founders] = totalSupply * 15 / 100;
290           balances[team] = totalSupply * 5 / 100;
291           balances[advisers] = totalSupply * 3 / 100;
292           balances[bounty] = totalSupply * 1 / 100;
293           balances[preSale] = totalSupply * 1 / 100;
294           balances[eosShareDrop] = totalSupply * 1 / 100;
295         }
296 
297         function transferByOwner(address from, address to, uint256 value) public onlyOwner {
298           require(balances[from] >= value);
299           balances[from] = balances[from].sub(value);
300           balances[to] = balances[to].add(value);
301           emit Transfer(from, to, value);
302         }
303 
304         //can be called by crowdsale before token release, control over forSale portion of token supply
305         function transferByCrowdsale(address to, uint256 value) public onlyCrowdsale {
306           require(balances[forSale] >= value);
307           balances[forSale] = balances[forSale].sub(value);
308           balances[to] = balances[to].add(value);
309           emit Transfer(forSale, to, value);
310         }
311 
312         //can be called by crowdsale before token release, allowences is respected here
313         function transferFromByCrowdsale(address _from, address _to, uint256 _value) public onlyCrowdsale returns (bool) {
314             return super.transferFrom(_from, _to, _value);
315         }
316 
317         //after the call token is available for exchange
318         function releaseForTransfer() public onlyCrowdsaleOrOwner {
319           require(!releasedForTransfer);
320           releasedForTransfer = true;
321         }
322 
323         //forbid transfer before release
324         function transfer(address _to, uint256 _value) public returns (bool) {
325           require(releasedForTransfer);
326           return super.transfer(_to, _value);
327         }
328 
329         //forbid transfer before release
330         function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
331            require(releasedForTransfer);
332            return super.transferFrom(_from, _to, _value);
333         }
334 
335         function burn(uint256 value) public  onlyOwner {
336             require(value <= balances[msg.sender]);
337             balances[msg.sender] = balances[msg.sender].sub(value);
338             balances[address(0)] = balances[address(0)].add(value);
339             emit Transfer(msg.sender, address(0), value);
340         }
341 }