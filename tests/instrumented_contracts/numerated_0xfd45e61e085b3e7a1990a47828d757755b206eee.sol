1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal constant returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal constant returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 /**
32  * @title ERC20Basic
33  * @dev Simpler version of ERC20 interface
34  * @dev see https://github.com/ethereum/EIPs/issues/179
35  */
36 contract ERC20Basic {
37   uint256 public totalSupply;
38   function balanceOf(address who) public constant returns (uint256);
39   function transfer(address to, uint256 value) public returns (bool);
40   event Transfer(address indexed from, address indexed to, uint256 value);
41 }
42 
43 
44 contract BasicToken is ERC20Basic {
45   using SafeMath for uint256;
46 
47   mapping(address => uint256) balances;
48 
49   /**
50   * @dev transfer token for a specified address
51   * @param _to The address to transfer to.
52   * @param _value The amount to be transferred.
53   */
54   function transfer(address _to, uint256 _value) public returns (bool) {
55     require(_to != address(0));
56 
57     // SafeMath.sub will throw if there is not enough balance.
58     balances[msg.sender] = balances[msg.sender].sub(_value);
59     balances[_to] = balances[_to].add(_value);
60     Transfer(msg.sender, _to, _value);
61     return true;
62   }
63 
64   /**
65   * @dev Gets the balance of the specified address.
66   * @param _owner The address to query the the balance of.
67   * @return An uint256 representing the amount owned by the passed address.
68   */
69   function balanceOf(address _owner) public constant returns (uint256 balance) {
70     return balances[_owner];
71   }
72 
73 }
74 
75 
76 /**
77  * @title ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/20
79  */
80 contract ERC20 is ERC20Basic {
81   function allowance(address owner, address spender) public constant returns (uint256);
82   function transferFrom(address from, address to, uint256 value) public returns (bool);
83   function approve(address spender, uint256 value) public returns (bool);
84   event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 /**
88  * @title Ownable
89  * @dev The Ownable contract has an owner address, and provides basic authorization control
90  * functions, this simplifies the implementation of "user permissions".
91  */
92 contract Ownable {
93   address public owner;
94 
95 
96   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
97 
98 
99   /**
100    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
101    * account.
102    */
103   function Ownable() {
104     owner = msg.sender;
105   }
106 
107 
108   /**
109    * @dev Throws if called by any account other than the owner.
110    */
111   modifier onlyOwner() {
112     require(msg.sender == owner);
113     _;
114   }
115 
116 
117   /**
118    * @dev Allows the current owner to transfer control of the contract to a newOwner.
119    * @param newOwner The address to transfer ownership to.
120    */
121   function transferOwnership(address newOwner) onlyOwner public {
122     require(newOwner != address(0));
123     OwnershipTransferred(owner, newOwner);
124     owner = newOwner;
125   }
126 
127 }
128 
129 /**
130  * @title Standard ERC20 token
131  *
132  * @dev Implementation of the basic standard token.
133  * @dev https://github.com/ethereum/EIPs/issues/20
134  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
135  */
136 contract StandardToken is ERC20, BasicToken {
137 
138   mapping (address => mapping (address => uint256)) allowed;
139 
140 
141   /**
142    * @dev Transfer tokens from one address to another
143    * @param _from address The address which you want to send tokens from
144    * @param _to address The address which you want to transfer to
145    * @param _value uint256 the amount of tokens to be transferred
146    */
147   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
148     require(_to != address(0));
149 
150     uint256 _allowance = allowed[_from][msg.sender];
151 
152     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
153     // require (_value <= _allowance);
154 
155     balances[_from] = balances[_from].sub(_value);
156     balances[_to] = balances[_to].add(_value);
157     allowed[_from][msg.sender] = _allowance.sub(_value);
158     Transfer(_from, _to, _value);
159     return true;
160   }
161 
162   /**
163    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
164    *
165    * Beware that changing an allowance with this method brings the risk that someone may use both the old
166    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
167    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
168    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169    * @param _spender The address which will spend the funds.
170    * @param _value The amount of tokens to be spent.
171    */
172   function approve(address _spender, uint256 _value) public returns (bool) {
173     allowed[msg.sender][_spender] = _value;
174     Approval(msg.sender, _spender, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Function to check the amount of tokens that an owner allowed to a spender.
180    * @param _owner address The address which owns the funds.
181    * @param _spender address The address which will spend the funds.
182    * @return A uint256 specifying the amount of tokens still available for the spender.
183    */
184   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
185     return allowed[_owner][_spender];
186   }
187 
188   /**
189    * approve should be called when allowed[_spender] == 0. To increment
190    * allowed value is better to use this function to avoid 2 calls (and wait until
191    * the first transaction is mined)
192    * From MonolithDAO Token.sol
193    */
194   function increaseApproval (address _spender, uint _addedValue)
195     returns (bool success) {
196     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
197     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
198     return true;
199   }
200 
201   function decreaseApproval (address _spender, uint _subtractedValue)
202     returns (bool success) {
203     uint oldValue = allowed[msg.sender][_spender];
204     if (_subtractedValue > oldValue) {
205       allowed[msg.sender][_spender] = 0;
206     } else {
207       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
208     }
209     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
210     return true;
211   }
212 
213 }
214 
215 
216 contract CoinParkToken is StandardToken, Ownable{
217     
218     string public version = "v2.0";
219     string public name = "CoinPark Token (www.coinpark.com)";
220     string public symbol = "CP";
221     string public website = "https://www.coinpark.com";
222     uint8 public  decimals = 18;
223 
224     mapping(address=>uint256)  lockedBalance;
225     mapping(address=>uint)     timeRelease; 
226     
227     uint256 internal constant INITIAL_SUPPLY = 100 * (10**8) * (10**18);
228     
229     //address public developer;
230     //uint256 internal crowdsaleAvaible;
231 
232 
233     event Burn(address indexed burner, uint256 value);
234     event Lock(address indexed locker, uint256 value, uint releaseTime);
235     event UnLock(address indexed unlocker, uint256 value);
236     
237 
238     // constructor
239     function CoinParkToken() { 
240         address onwer = msg.sender;
241         balances[onwer] = INITIAL_SUPPLY;
242         totalSupply = INITIAL_SUPPLY;
243     }
244 
245     //balance of locked
246     function lockedOf(address _owner) public constant returns (uint256 balance) {
247         return lockedBalance[_owner];
248     }
249 
250     //release time of locked
251     function unlockTimeOf(address _owner) public constant returns (uint timelimit) {
252         return timeRelease[_owner];
253     }
254 
255 
256     // transfer to and lock it
257     function transferAndLock(address _to, uint256 _value, uint _releaseTime) public returns (bool success) {
258         require(_to != 0x0);
259         require(_value <= balances[msg.sender]);
260         require(_value > 0);
261         require(_releaseTime > now && _releaseTime <= now + 60*60*24*365*5);
262 
263         // SafeMath.sub will throw if there is not enough balance.
264         balances[msg.sender] = balances[msg.sender].sub(_value);
265        
266         //if preLock can release 
267         uint preRelease = timeRelease[_to];
268         if (preRelease <= now && preRelease != 0x0) {
269             balances[_to] = balances[_to].add(lockedBalance[_to]);
270             lockedBalance[_to] = 0;
271         }
272 
273         lockedBalance[_to] = lockedBalance[_to].add(_value);
274         timeRelease[_to] =  _releaseTime >= timeRelease[_to] ? _releaseTime : timeRelease[_to]; 
275         Transfer(msg.sender, _to, _value);
276         Lock(_to, _value, _releaseTime);
277         return true;
278     }
279 
280 
281    /**
282    * @notice Transfers tokens held by lock.
283    */
284    function unlock() public constant returns (bool success){
285         uint256 amount = lockedBalance[msg.sender];
286         require(amount > 0);
287         require(now >= timeRelease[msg.sender]);
288 
289         balances[msg.sender] = balances[msg.sender].add(amount);
290         lockedBalance[msg.sender] = 0;
291         timeRelease[msg.sender] = 0;
292 
293         Transfer(0x0, msg.sender, amount);
294         UnLock(msg.sender, amount);
295 
296         return true;
297 
298     }
299 
300 
301     /**
302      * @dev Burns a specific amount of tokens.
303      * @param _value The amount of token to be burned.
304      */
305     function burn(uint256 _value) public returns (bool success) {
306         require(_value > 0);
307         require(_value <= balances[msg.sender]);
308     
309         address burner = msg.sender;
310         balances[burner] = balances[burner].sub(_value);
311         totalSupply = totalSupply.sub(_value);
312         Burn(burner, _value);
313         return true;
314     }
315 
316     
317 
318 
319 }