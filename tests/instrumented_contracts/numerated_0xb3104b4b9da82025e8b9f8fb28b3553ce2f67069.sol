1 /**
2  * @title ERC20Basic
3  * @dev Simpler version of ERC20 interface
4  * @dev see https://github.com/ethereum/EIPs/issues/179
5  */
6 contract ERC20Basic {
7   uint256 public totalSupply;
8   function balanceOf(address who) public constant returns (uint256);
9   function transfer(address to, uint256 value) public returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 /**
13  * @title ERC20 interface
14  * @dev see https://github.com/ethereum/EIPs/issues/20
15  */
16 contract ERC20 is ERC20Basic {
17   function allowance(address owner, address spender) public constant returns (uint256);
18   function transferFrom(address from, address to, uint256 value) public returns (bool);
19   function approve(address spender, uint256 value) public returns (bool);
20   event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 /**
24  * @title Basic token
25  * @dev Basic version of StandardToken, with no allowances.
26  */
27 contract BasicToken is ERC20Basic {
28   using SafeMath for uint256;
29 
30   mapping(address => uint256) balances;
31 
32   /**
33   * @dev transfer token for a specified address
34   * @param _to The address to transfer to.
35   * @param _value The amount to be transferred.
36   */
37   function transfer(address _to, uint256 _value) public returns (bool) {
38     require(_to != address(0));
39 
40     // SafeMath.sub will throw if there is not enough balance.
41     balances[msg.sender] = balances[msg.sender].sub(_value);
42     balances[_to] = balances[_to].add(_value);
43     Transfer(msg.sender, _to, _value);
44     return true;
45   }
46 
47   /**
48   * @dev Gets the balance of the specified address.
49   * @param _owner The address to query the the balance of.
50   * @return An uint256 representing the amount owned by the passed address.
51   */
52   function balanceOf(address _owner) public constant returns (uint256 balance) {
53     return balances[_owner];
54   }
55 
56 }
57 
58 /**
59  * @title Standard ERC20 token
60  *
61  * @dev Implementation of the basic standard token.
62  * @dev https://github.com/ethereum/EIPs/issues/20
63  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
64  */
65 contract StandardToken is ERC20, BasicToken {
66 
67   mapping (address => mapping (address => uint256)) allowed;
68 
69 
70   /**
71    * @dev Transfer tokens from one address to another
72    * @param _from address The address which you want to send tokens from
73    * @param _to address The address which you want to transfer to
74    * @param _value uint256 the amount of tokens to be transferred
75    */
76   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
77     require(_to != address(0));
78 
79     uint256 _allowance = allowed[_from][msg.sender];
80 
81     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
82     // require (_value <= _allowance);
83 
84     balances[_from] = balances[_from].sub(_value);
85     balances[_to] = balances[_to].add(_value);
86     allowed[_from][msg.sender] = _allowance.sub(_value);
87     Transfer(_from, _to, _value);
88     return true;
89   }
90 
91   /**
92    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
93    *
94    * Beware that changing an allowance with this method brings the risk that someone may use both the old
95    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
96    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
97    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
98    * @param _spender The address which will spend the funds.
99    * @param _value The amount of tokens to be spent.
100    */
101   function approve(address _spender, uint256 _value) public returns (bool) {
102     allowed[msg.sender][_spender] = _value;
103     Approval(msg.sender, _spender, _value);
104     return true;
105   }
106 
107   /**
108    * @dev Function to check the amount of tokens that an owner allowed to a spender.
109    * @param _owner address The address which owns the funds.
110    * @param _spender address The address which will spend the funds.
111    * @return A uint256 specifying the amount of tokens still available for the spender.
112    */
113   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
114     return allowed[_owner][_spender];
115   }
116 
117   /**
118    * approve should be called when allowed[_spender] == 0. To increment
119    * allowed value is better to use this function to avoid 2 calls (and wait until
120    * the first transaction is mined)
121    * From MonolithDAO Token.sol
122    */
123   function increaseApproval (address _spender, uint _addedValue)
124     returns (bool success) {
125     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
126     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
127     return true;
128   }
129 
130   function decreaseApproval (address _spender, uint _subtractedValue)
131     returns (bool success) {
132     uint oldValue = allowed[msg.sender][_spender];
133     if (_subtractedValue > oldValue) {
134       allowed[msg.sender][_spender] = 0;
135     } else {
136       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
137     }
138     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
139     return true;
140   }
141 
142 }
143 
144 
145 
146 /**
147  * @title Ownable
148  * @dev The Ownable contract has an owner address, and provides basic authorization control
149  * functions, this simplifies the implementation of "user permissions".
150  */
151 contract Ownable {
152   address public owner;
153 
154 
155   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
156 
157 
158   /**
159    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
160    * account.
161    */
162   function Ownable() {
163     owner = msg.sender;
164   }
165 
166 
167   /**
168    * @dev Throws if called by any account other than the owner.
169    */
170   modifier onlyOwner() {
171     require(msg.sender == owner);
172     _;
173   }
174 
175 
176   /**
177    * @dev Allows the current owner to transfer control of the contract to a newOwner.
178    * @param newOwner The address to transfer ownership to.
179    */
180   function transferOwnership(address newOwner) onlyOwner public {
181     require(newOwner != address(0));
182     OwnershipTransferred(owner, newOwner);
183     owner = newOwner;
184   }
185 
186 }
187 
188 library SafeMath {
189   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
190     uint256 c = a * b;
191     assert(a == 0 || c / a == b);
192     return c;
193   }
194 
195   function div(uint256 a, uint256 b) internal constant returns (uint256) {
196     // assert(b > 0); // Solidity automatically throws when dividing by 0
197     uint256 c = a / b;
198     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
199     return c;
200   }
201 
202   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
203     assert(b <= a);
204     return a - b;
205   }
206 
207   function add(uint256 a, uint256 b) internal constant returns (uint256) {
208     uint256 c = a + b;
209     assert(c >= a);
210     return c;
211   }
212 }
213 
214 
215 // This is just a contract of a BIX Token.
216 // It is a ERC20 token
217 contract BIXToken is StandardToken, Ownable{
218     
219     string public version = "1.0";
220     string public name = "BIX Token";
221     string public symbol = "BIX";
222     uint8 public  decimals = 18;
223 
224     mapping(address=>uint256)  lockedBalance;
225     mapping(address=>uint)     timeRelease; 
226     
227     uint256 internal constant INITIAL_SUPPLY = 500 * (10**6) * (10 **18);
228     uint256 internal constant DEVELOPER_RESERVED = 175 * (10**6) * (10**18);
229 
230     //address public developer;
231     //uint256 internal crowdsaleAvaible;
232 
233 
234     event Burn(address indexed burner, uint256 value);
235     event Lock(address indexed locker, uint256 value, uint releaseTime);
236     event UnLock(address indexed unlocker, uint256 value);
237     
238 
239     // constructor
240     function BIXToken(address _developer) { 
241         balances[_developer] = DEVELOPER_RESERVED;
242         totalSupply = DEVELOPER_RESERVED;
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
316     // 
317     function isSoleout() public constant returns (bool) {
318         return (totalSupply >= INITIAL_SUPPLY);
319     }
320 
321 
322     modifier canMint() {
323         require(!isSoleout());
324         _;
325     } 
326     
327     /**
328    * @dev Function to mint tokens
329    * @param _to The address that will receive the minted tokens.
330    * @param _amount The amount of tokens to mint.
331    * @return A boolean that indicates if the operation was successful.
332    */
333     function mintBIX(address _to, uint256 _amount, uint256 _lockAmount, uint _releaseTime) onlyOwner canMint public returns (bool) {
334         totalSupply = totalSupply.add(_amount);
335         balances[_to] = balances[_to].add(_amount);
336 
337         if (_lockAmount > 0) {
338             totalSupply = totalSupply.add(_lockAmount);
339             lockedBalance[_to] = lockedBalance[_to].add(_lockAmount);
340             timeRelease[_to] =  _releaseTime >= timeRelease[_to] ? _releaseTime : timeRelease[_to];            
341             Lock(_to, _lockAmount, _releaseTime);
342         }
343 
344         Transfer(0x0, _to, _amount);
345         return true;
346     }
347 }