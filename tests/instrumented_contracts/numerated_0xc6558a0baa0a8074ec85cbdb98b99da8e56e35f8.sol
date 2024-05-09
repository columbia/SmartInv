1 pragma solidity ^0.4.24;
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
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipRenounced(address indexed previousOwner);
54   event OwnershipTransferred(
55     address indexed previousOwner,
56     address indexed newOwner
57   );
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   constructor() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   /**
77    * @dev Allows the current owner to relinquish control of the contract.
78    * @notice Renouncing to ownership will leave the contract without an owner.
79    * It will not be possible to call the functions with the `onlyOwner`
80    * modifier anymore.
81    */
82   function renounceOwnership() public onlyOwner {
83     emit OwnershipRenounced(owner);
84     owner = address(0);
85   }
86 
87   /**
88    * @dev Allows the current owner to transfer control of the contract to a newOwner.
89    * @param _newOwner The address to transfer ownership to.
90    */
91   function transferOwnership(address _newOwner) public onlyOwner {
92     _transferOwnership(_newOwner);
93   }
94 
95   /**
96    * @dev Transfers control of the contract to a newOwner.
97    * @param _newOwner The address to transfer ownership to.
98    */
99   function _transferOwnership(address _newOwner) internal {
100     require(_newOwner != address(0));
101     emit OwnershipTransferred(owner, _newOwner);
102     owner = _newOwner;
103   }
104 }
105 
106 
107 contract ERC20Basic {
108   function totalSupply() public view returns (uint256);
109   function balanceOf(address who) public view returns (uint256);
110   function transfer(address to, uint256 value) public returns (bool);
111   event Transfer(address indexed from, address indexed to, uint256 value);
112 }
113 
114 
115 contract BasicToken is ERC20Basic {
116   using SafeMath for uint256;
117 
118   mapping(address => uint256) balances;
119 
120   uint256 totalSupply_;
121 
122   mapping (address => bool) public frozenAccount;
123   event FrozenFunds(address target, bool frozen);
124   /**
125   * @dev Total number of tokens in existence
126   */
127   function totalSupply() public view returns (uint256) {
128     return totalSupply_;
129   }
130 
131   function transfer(address _to, uint256 _value) public returns (bool) {
132     require(!frozenAccount[msg.sender]);
133     require(_to != address(0));
134     require(_value <= balances[msg.sender]);
135 
136     balances[msg.sender] = balances[msg.sender].sub(_value);
137     balances[_to] = balances[_to].add(_value);
138     emit Transfer(msg.sender, _to, _value);
139     return true;
140   }
141 
142   function balanceOf(address _owner) public view returns (uint256) {
143     return balances[_owner];
144   }
145 
146 }
147 
148 contract ERC20 is ERC20Basic {
149   function allowance(address owner, address spender)
150     public view returns (uint256);
151 
152   function transferFrom(address from, address to, uint256 value)
153     public returns (bool);
154 
155   function approve(address spender, uint256 value) public returns (bool);
156   event Approval(
157     address indexed owner,
158     address indexed spender,
159     uint256 value
160   );
161 }
162 
163 
164 contract StandardToken is ERC20, BasicToken {
165 
166   mapping (address => mapping (address => uint256)) internal allowed;
167 
168   function transferFrom(
169     address _from,
170     address _to,
171     uint256 _value
172   )
173     public
174     returns (bool)
175   {
176     require(_to != address(0));
177     require(_value <= balances[_from]);
178     require(_value <= allowed[_from][msg.sender]);
179 
180     balances[_from] = balances[_from].sub(_value);
181     balances[_to] = balances[_to].add(_value);
182     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
183     emit Transfer(_from, _to, _value);
184     return true;
185   }
186 
187  
188   function approve(address _spender, uint256 _value) public returns (bool) {
189     allowed[msg.sender][_spender] = _value;
190     emit Approval(msg.sender, _spender, _value);
191     return true;
192   }
193 
194   function allowance(
195     address _owner,
196     address _spender
197    )
198     public
199     view
200     returns (uint256)
201   {
202     return allowed[_owner][_spender];
203   }
204 
205 
206   function increaseApproval(
207     address _spender,
208     uint256 _addedValue
209   )
210     public
211     returns (bool)
212   {
213     allowed[msg.sender][_spender] = (
214       allowed[msg.sender][_spender].add(_addedValue));
215     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219 
220   function decreaseApproval(
221     address _spender,
222     uint256 _subtractedValue
223   )
224     public
225     returns (bool)
226   {
227     uint256 oldValue = allowed[msg.sender][_spender];
228     if (_subtractedValue > oldValue) {
229       allowed[msg.sender][_spender] = 0;
230     } else {
231       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
232     }
233     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234     return true;
235   }
236 
237 }
238 
239 contract MintableToken is StandardToken, Ownable {
240   event Mint(address indexed to, uint256 amount);
241   event MintFinished();
242 
243   bool public mintingFinished = false;
244 
245 
246   modifier canMint() {
247     require(!mintingFinished);
248     _;
249   }
250 
251   modifier hasMintPermission() {
252     require(msg.sender == owner);
253     _;
254   }
255 
256 
257   function mint(
258     address _to,
259     uint256 _amount
260   )
261     hasMintPermission
262     canMint
263     public
264     returns (bool)
265   {
266     totalSupply_ = totalSupply_.add(_amount);
267     balances[_to] = balances[_to].add(_amount);
268     emit Mint(_to, _amount);
269     emit Transfer(address(0), _to, _amount);
270     return true;
271   }
272 
273   function finishMinting() onlyOwner canMint public returns (bool) {
274     mintingFinished = true;
275     emit MintFinished();
276     return true;
277   }
278 }
279 
280 
281 contract BiGeCoin is MintableToken  {
282     event Withdraw(address wallet, uint256 value);
283     
284     string public name = "BiGeCoin"; 
285     string public symbol = "BGC";
286     uint public decimals = 8;
287     uint public INITIAL_SUPPLY = 210000000 * (10 ** decimals);
288     
289     uint public sellPrice = 100000000000000000000000;
290     uint public buyPrice = 100000000000000000000000;
291 
292 
293     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
294         sellPrice = newSellPrice;
295         buyPrice = newBuyPrice;
296     }
297 
298 
299     function buySampleTokens(address _to) public payable returns(bool) {
300     	uint amount = msg.value;
301     	uint price = buyPrice;
302       address _from = address(this);
303     	uint _value = amount.div(price);
304       require(_value <= balances[_from]);
305       balances[_from] = balances[_from].sub(_value);
306       balances[_to] = balances[_to].add(_value);
307       emit Transfer(_from, _to, _value);
308       return true;
309     }
310       
311     function () public payable {
312         buySampleTokens(msg.sender);
313     }
314 
315     function sell(uint amount) public returns (uint revenue){
316         require(balances[msg.sender] >= amount);
317         require(address(this).balance >= amount.mul(sellPrice));
318         balances[this] = balances[this].add(amount);                        
319         balances[msg.sender] = balances[msg.sender].sub(amount);                  
320         revenue = amount.mul(sellPrice);
321         msg.sender.transfer(revenue);                    
322         emit Transfer(msg.sender, this, amount);               
323         return revenue;                                   
324     }
325 
326     function freezeAccount(address target, bool freeze) onlyOwner public {
327         frozenAccount[target] = freeze;
328         emit FrozenFunds(target, freeze);
329     }
330 
331     function withdraw() onlyOwner public {
332       msg.sender.transfer(address(this).balance);
333       emit Withdraw(msg.sender, address(this).balance);
334     }
335 
336   constructor() public {
337     totalSupply_ = INITIAL_SUPPLY;
338     balances[msg.sender] = INITIAL_SUPPLY;
339     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
340     }
341 }