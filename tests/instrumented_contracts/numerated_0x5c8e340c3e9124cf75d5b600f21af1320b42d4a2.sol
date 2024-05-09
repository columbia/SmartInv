1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 contract BasicToken is ERC20Basic {
46   using SafeMath for uint256;
47 
48   mapping(address => uint256) balances;
49 
50   uint256 totalSupply_;
51 
52   /**
53   * @dev total number of tokens in existence
54   */
55   function totalSupply() public view returns (uint256) {
56     return totalSupply_;
57   }
58 
59   /**
60   * @dev transfer token for a specified address
61   * @param _to The address to transfer to.
62   * @param _value The amount to be transferred.
63   */
64   function transfer(address _to, uint256 _value) public returns (bool) {
65     require(_to != address(0));
66     require(_value <= balances[msg.sender]);
67 
68     // SafeMath.sub will throw if there is not enough balance.
69     balances[msg.sender] = balances[msg.sender].sub(_value);
70     balances[_to] = balances[_to].add(_value);
71     emit Transfer(msg.sender, _to, _value);
72     return true;
73   }
74 
75   /**
76   * @dev Gets the balance of the specified address.
77   * @param _owner The address to query the the balance of.
78   * @return An uint256 representing the amount owned by the passed address.
79   */
80   function balanceOf(address _owner) public view returns (uint256 balance) {
81     return balances[_owner];
82   }
83 
84 }
85 
86 contract Crowdsaled is Ownable {
87         address public crowdsaleContract = address(0);
88         function Crowdsaled() public {
89         }
90 
91         modifier onlyCrowdsale{
92           require(msg.sender == crowdsaleContract);
93           _;
94         }
95 
96         modifier onlyCrowdsaleOrOwner {
97           require((msg.sender == crowdsaleContract) || (msg.sender == owner));
98           _;
99         }
100 
101         function setCrowdsale(address crowdsale) public onlyOwner() {
102                 crowdsaleContract = crowdsale;
103         }
104 }
105 
106 library SafeMath {
107 
108   /**
109   * @dev Multiplies two numbers, throws on overflow.
110   */
111   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
112     if (a == 0) {
113       return 0;
114     }
115     uint256 c = a * b;
116     assert(c / a == b);
117     return c;
118   }
119 
120   /**
121   * @dev Integer division of two numbers, truncating the quotient.
122   */
123   function div(uint256 a, uint256 b) internal pure returns (uint256) {
124     // assert(b > 0); // Solidity automatically throws when dividing by 0
125     uint256 c = a / b;
126     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
127     return c;
128   }
129 
130   /**
131   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
132   */
133   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134     assert(b <= a);
135     return a - b;
136   }
137 
138   /**
139   * @dev Adds two numbers, throws on overflow.
140   */
141   function add(uint256 a, uint256 b) internal pure returns (uint256) {
142     uint256 c = a + b;
143     assert(c >= a);
144     return c;
145   }
146 }
147 
148 contract ERC20 is ERC20Basic {
149   function allowance(address owner, address spender) public view returns (uint256);
150   function transferFrom(address from, address to, uint256 value) public returns (bool);
151   function approve(address spender, uint256 value) public returns (bool);
152   event Approval(address indexed owner, address indexed spender, uint256 value);
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
243 contract LetItPlayTokenPromo is StandardToken, Ownable {
244         uint256 public totalSupply;
245         string public name;
246         string public symbol;
247         uint8 public decimals;
248 
249         bool public burned;
250 
251         uint256 private constant BALANCE = 50000000000;
252 
253         //initial coin distribution
254         function LetItPlayTokenPromo()
255          public {
256           name = "LetItPlay Bonus Token (letitplay.io)";
257           symbol = "PLAY Bonus";
258           decimals = 8;
259           totalSupply = 0;
260           burned = false;
261         }
262 
263         function drop(address[] holders) public onlyOwner {
264           uint256 count = holders.length;
265           for (uint256 i = 0; i < count; i++)
266             emit Transfer (address (0), holders[i], BALANCE);
267         }
268 
269         function balanceOf (address _owner) constant public returns (uint256 balance) {
270           if (!burned)
271             return BALANCE;
272           else
273             return 0;
274         }
275 
276         function kill () public onlyOwner {
277           selfdestruct (owner);
278         }
279 
280         function burn() public onlyOwner {
281             burned = true;
282         }
283 
284         function notifyBurn(address[] holders) public onlyOwner {
285           uint256 count = holders.length;
286           for (uint256 i = 0; i < count; i++)
287             emit Transfer (holders[i], address(0),  BALANCE);
288         }
289 
290         function transfer (address _to, uint256 _value) public returns (bool success){
291           revert();
292         }
293 
294         function transferFrom (address _from, address _to, uint256 _value) public
295         returns (bool success){
296           revert();
297         }
298 }