1 /**
2  * Reference Code
3  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/examples/SimpleToken.sol
4  */
5 
6 pragma solidity ^0.4.24;
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14   /**
15    * @dev Multiplies two numbers, throws on overflow.
16    */
17   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
18     if (a == 0) {
19       return 0;
20     }
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27    * @dev Integer division of two numbers, truncating the quotient.
28    */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38    */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45    * @dev Adds two numbers, throws on overflow.
46    */
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 /**
55  * @title ERC20
56  * @dev Standard ERC20 token interface
57  * @dev see https://github.com/ethereum/EIPs/issues/20
58  */
59 contract ERC20 {
60   function totalSupply() public view returns (uint256);
61   function balanceOf(address who) public view returns (uint256);
62   function transfer(address to, uint256 value) public returns (bool);
63   function transferFrom(address from, address to, uint256 value) public returns (bool);
64   function approve(address spender, uint256 value) public returns (bool);
65   function allowance(address owner, address spender) public view returns (uint256);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67   event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 /**
71  * @title Ownable
72  * @dev The Ownable contract has an owner address, and provides basic authorization control
73  * functions, this simplifies the implementation of "user permissions".
74  */
75 contract Ownable {
76   address public owner;
77 
78   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79 
80   /**
81    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
82    * account.
83    */
84   constructor() public {
85     owner = msg.sender;
86   }
87 
88   /**
89    * @dev Throws if called by any account other than the owner.
90    */
91   modifier onlyOwner() {
92     require(msg.sender == owner);
93     _;
94   }
95 
96   /**
97    * @dev Allows the current owner to transfer control of the contract to a newOwner.
98    * @param newOwner The address to transfer ownership to.
99    */
100   function transferOwnership(address newOwner) public onlyOwner {
101     require(newOwner != address(0));
102     emit OwnershipTransferred(owner, newOwner);
103     owner = newOwner;
104   }
105 }
106 
107 /**
108  * @title mameCoin
109  * @dev see https://mamecoin.jp/
110  */
111 contract mameCoin is ERC20, Ownable {
112   using SafeMath for uint256;
113 
114   mapping(address => uint256) balances;
115   mapping(address => mapping (address => uint256)) internal allowed;
116   mapping(address => uint256) internal lockups;
117 
118   string public constant name = "mameCoin";
119   string public constant symbol = "MAME";
120   uint8 public constant decimals = 8;
121   uint256 totalSupply_ = 25000000000 * (10 ** uint256(decimals));
122 
123   event Burn(address indexed to, uint256 amount);
124   event Refund(address indexed to, uint256 amount);
125   event Lockup(address indexed to, uint256 lockuptime);
126 
127   /**
128    * @dev Constructor that gives msg.sender all of existing tokens.
129    */
130   constructor() public {
131     balances[msg.sender] = totalSupply_;
132     emit Transfer(address(0), msg.sender, totalSupply_);
133   }
134 
135   /**
136    * @dev total number of tokens in existence
137    */
138   function totalSupply() public view returns (uint256) {
139     return totalSupply_;
140   }
141 
142   /**
143    * @dev Gets the balance of the specified address.
144    * @param _owner The address to query the the balance of.
145    * @return An uint256 representing the amount owned by the passed address.
146    */
147   function balanceOf(address _owner) public view returns (uint256) {
148     return balances[_owner];
149   }
150 
151   /**
152    * @dev transfer token for a specified address
153    * @param _to The address to transfer to.
154    * @param _amount The amount to be transferred.
155    */
156   function transfer(address _to, uint256 _amount) public returns (bool) {
157     require(_to != address(0));
158     require(_amount <= balances[msg.sender]);
159     require(block.timestamp > lockups[msg.sender]);
160     require(block.timestamp > lockups[_to]);
161 
162     balances[msg.sender] = balances[msg.sender].sub(_amount);
163     balances[_to] = balances[_to].add(_amount);
164     emit Transfer(msg.sender, _to, _amount);
165     return true;
166   }
167 
168   /**
169    * @dev Transfer tokens from one address to another
170    * @param _from address The address which you want to send tokens from
171    * @param _to address The address which you want to transfer to
172    * @param _amount uint256 the amount of tokens to be transferred
173    */
174   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool) {
175     require(_to != address(0));
176     require(_amount <= balances[_from]);
177     require(_amount <= allowed[_from][msg.sender]);
178     require(block.timestamp > lockups[_from]);
179     require(block.timestamp > lockups[_to]);
180 
181     balances[_from] = balances[_from].sub(_amount);
182     balances[_to] = balances[_to].add(_amount);
183     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
184     emit Transfer(_from, _to, _amount);
185     return true;
186   }
187 
188   /**
189    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
190    *
191    * Beware that changing an allowance with this method brings the risk that someone may use both the old
192    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
193    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
194    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195    * @param _spender The address which will spend the funds.
196    * @param _amount The amount of tokens to be spent.
197    */
198   function approve(address _spender, uint256 _amount) public returns (bool) {
199     allowed[msg.sender][_spender] = _amount;
200     emit Approval(msg.sender, _spender, _amount);
201     return true;
202   }
203 
204   /**
205    * @dev Function to check the amount of tokens that an owner allowed to a spender.
206    * @param _owner address The address which owns the funds.
207    * @param _spender address The address which will spend the funds.
208    * @return A uint256 specifying the amount of tokens still available for the spender.
209    */
210   function allowance(address _owner, address _spender) public view returns (uint256) {
211     return allowed[_owner][_spender];
212   }
213 
214   /**
215    * @dev Burns a specific amount of tokens.
216    * @param _to address The address which is burned.
217    * @param _amount The amount of token to be burned.
218    */
219   function burn(address _to, uint256 _amount) public onlyOwner {
220     require(_amount <= balances[_to]);
221     require(block.timestamp > lockups[_to]);
222     // no need to require value <= totalSupply, since that would imply the
223     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
224 
225     balances[_to] = balances[_to].sub(_amount);
226     totalSupply_ = totalSupply_.sub(_amount);
227     emit Burn(_to, _amount);
228     emit Transfer(_to, address(0), _amount);
229   }
230 
231   /**
232    * @dev Refund a specific amount of tokens.
233    * @param _to The address that will receive the refunded tokens.
234    * @param _amount The amount of tokens to refund.
235    */
236   function refund(address _to, uint256 _amount) public onlyOwner {
237     require(block.timestamp > lockups[_to]);
238     totalSupply_ = totalSupply_.add(_amount);
239     balances[_to] = balances[_to].add(_amount);
240     emit Refund(_to, _amount);
241     emit Transfer(address(0), _to, _amount);
242   }
243 
244   /**
245    * @dev Gets the lockuptime of the specified address.
246    * @param _owner The address to query the the lockup of.
247    * @return An uint256 unixstime the lockuptime which is locked until that time.
248    */
249   function lockupOf(address _owner) public view returns (uint256) {
250     return lockups[_owner];
251   }
252 
253   /**
254    * @dev Lockup a specific address until given time.
255    * @param _to address The address which is locked.
256    * @param _lockupTimeUntil The lockuptime which is locked until that time.
257    */
258   function lockup(address _to, uint256 _lockupTimeUntil) public onlyOwner {
259     require(lockups[_to] < _lockupTimeUntil);
260     lockups[_to] = _lockupTimeUntil;
261     emit Lockup(_to, _lockupTimeUntil);
262   }
263 
264   /**
265    * @dev airdrop tokens for a specified addresses
266    * @param _receivers The addresses to transfer to.
267    * @param _amount The amount to be transferred.
268    */
269   function airdrop(address[] _receivers, uint256 _amount) public returns (bool) {
270     require(block.timestamp > lockups[msg.sender]);
271     require(_receivers.length > 0);
272     require(_amount > 0);
273 
274     uint256 _total = 0;
275 
276     for (uint256 i = 0; i < _receivers.length; i++) {
277       require(_receivers[i] != address(0));
278       require(block.timestamp > lockups[_receivers[i]]);
279       _total = _total.add(_amount);
280     }
281 
282     require(_total <= balances[msg.sender]);
283 
284     balances[msg.sender] = balances[msg.sender].sub(_total);
285 
286     for (i = 0; i < _receivers.length; i++) {
287       balances[_receivers[i]] = balances[_receivers[i]].add(_amount);
288       emit Transfer(msg.sender, _receivers[i], _amount);
289     }
290 
291     return true;
292   }
293 
294   /**
295    * @dev distribute tokens for a specified addresses
296    * @param _receivers The addresses to transfer to.
297    * @param _amounts The amounts to be transferred.
298    */
299   function distribute(address[] _receivers, uint256[] _amounts) public returns (bool) {
300     require(block.timestamp > lockups[msg.sender]);
301     require(_receivers.length > 0);
302     require(_amounts.length > 0);
303     require(_receivers.length == _amounts.length);
304 
305     uint256 _total = 0;
306 
307     for (uint256 i = 0; i < _receivers.length; i++) {
308       require(_receivers[i] != address(0));
309       require(block.timestamp > lockups[_receivers[i]]);
310       require(_amounts[i] > 0);
311       _total = _total.add(_amounts[i]);
312     }
313 
314     require(_total <= balances[msg.sender]);
315 
316     balances[msg.sender] = balances[msg.sender].sub(_total);
317 
318     for (i = 0; i < _receivers.length; i++) {
319       balances[_receivers[i]] = balances[_receivers[i]].add(_amounts[i]);
320       emit Transfer(msg.sender, _receivers[i], _amounts[i]);
321     }
322 
323     return true;
324   }
325 }