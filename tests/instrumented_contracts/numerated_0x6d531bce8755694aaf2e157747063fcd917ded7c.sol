1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) public constant returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 
46 contract BasicToken is ERC20Basic {
47   using SafeMath for uint256;
48 
49   mapping(address => uint256) balances;
50 
51   /**
52   * @dev transfer token for a specified address
53   * @param _to The address to transfer to.
54   * @param _value The amount to be transferred.
55   */
56   function transfer(address _to, uint256 _value) public returns (bool) {
57     require(_to != address(0));
58 
59     // SafeMath.sub will throw if there is not enough balance.
60     balances[msg.sender] = balances[msg.sender].sub(_value);
61     balances[_to] = balances[_to].add(_value);
62     emit Transfer(msg.sender, _to, _value);
63     return true;
64   }
65 
66   /**
67   * @dev Gets the balance of the specified address.
68   * @param _owner The address to query the the balance of.
69   * @return An uint256 representing the amount owned by the passed address.
70   */
71   function balanceOf(address _owner) public constant returns (uint256 balance) {
72     return balances[_owner];
73   }
74 
75 }
76 
77 
78 /**
79  * @title ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/20
81  */
82 contract ERC20 is ERC20Basic {
83   function allowance(address owner, address spender) public constant returns (uint256);
84   function transferFrom(address from, address to, uint256 value) public returns (bool);
85   function approve(address spender, uint256 value) public returns (bool);
86   event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 /**
90  * @title Ownable
91  * @dev The Ownable contract has an owner address, and provides basic authorization control
92  * functions, this simplifies the implementation of "user permissions".
93  */
94 contract Ownable {
95   address public owner;
96 
97 
98   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
99 
100 
101   /**
102    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
103    * account.
104    */
105   constructor() public {
106     owner = msg.sender;
107   }
108 
109 
110   /**
111    * @dev Throws if called by any account other than the owner.
112    */
113   modifier onlyOwner() {
114     require(msg.sender == owner);
115     _;
116   }
117 
118 
119   /**
120    * @dev Allows the current owner to transfer control of the contract to a newOwner.
121    * @param newOwner The address to transfer ownership to.
122    */
123   function transferOwnership(address newOwner) onlyOwner public {
124     require(newOwner != address(0));
125     emit OwnershipTransferred(owner, newOwner);
126     owner = newOwner;
127   }
128 
129 }
130 
131 /**
132  * @title Standard ERC20 token
133  *
134  * @dev Implementation of the basic standard token.
135  * @dev https://github.com/ethereum/EIPs/issues/20
136  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
137  */
138 contract StandardToken is ERC20, BasicToken {
139 
140   mapping (address => mapping (address => uint256)) allowed;
141 
142 
143   /**
144    * @dev Transfer tokens from one address to another
145    * @param _from address The address which you want to send tokens from
146    * @param _to address The address which you want to transfer to
147    * @param _value uint256 the amount of tokens to be transferred
148    */
149   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
150     require(_to != address(0));
151 
152     uint256 _allowance = allowed[_from][msg.sender];
153 
154     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
155     // require (_value <= _allowance);
156 
157     balances[_from] = balances[_from].sub(_value);
158     balances[_to] = balances[_to].add(_value);
159     allowed[_from][msg.sender] = _allowance.sub(_value);
160     emit Transfer(_from, _to, _value);
161     return true;
162   }
163 
164   /**
165    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
166    *
167    * Beware that changing an allowance with this method brings the risk that someone may use both the old
168    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171    * @param _spender The address which will spend the funds.
172    * @param _value The amount of tokens to be spent.
173    */
174   function approve(address _spender, uint256 _value) public returns (bool) {
175     allowed[msg.sender][_spender] = _value;
176     emit Approval(msg.sender, _spender, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Function to check the amount of tokens that an owner allowed to a spender.
182    * @param _owner address The address which owns the funds.
183    * @param _spender address The address which will spend the funds.
184    * @return A uint256 specifying the amount of tokens still available for the spender.
185    */
186   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
187     return allowed[_owner][_spender];
188   }
189 
190   /**
191    * approve should be called when allowed[_spender] == 0. To increment
192    * allowed value is better to use this function to avoid 2 calls (and wait until
193    * the first transaction is mined)
194    * From MonolithDAO Token.sol
195    */
196   function increaseApproval (address _spender, uint _addedValue) public 
197     returns (bool success) {
198     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
199     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
200     return true;
201   }
202 
203   function decreaseApproval (address _spender, uint _subtractedValue) public 
204     returns (bool success) {
205     uint oldValue = allowed[msg.sender][_spender];
206     if (_subtractedValue > oldValue) {
207       allowed[msg.sender][_spender] = 0;
208     } else {
209       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
210     }
211     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
212     return true;
213   }
214 
215 }
216 
217 
218 contract liyk002Token is StandardToken, Ownable{
219     
220     string public version = "v1.0";
221     string public name = "liyk002Token";
222     string public symbol = "lyk2";
223     string public website = "https://www.liyk002Token.com";
224     uint8 public  decimals = 18;
225 
226     mapping(address=>uint256)  lockedBalance;
227     mapping(address=>uint)     timeRelease; 
228     
229     uint256 internal constant INITIAL_SUPPLY = 100 * (10**8) * (10**18);
230     
231     //address public developer;
232     //uint256 internal crowdsaleAvaible;
233 
234 
235     event Burn(address indexed burner, uint256 value);
236     event Lock(address indexed locker, uint256 value, uint releaseTime);
237     event UnLock(address indexed unlocker, uint256 value);
238     
239 
240     // constructor
241     constructor() public { 
242         address onwer = msg.sender;
243         balances[onwer] = INITIAL_SUPPLY;
244         totalSupply = INITIAL_SUPPLY;
245     }
246 
247     //balance of locked
248     function lockedOf(address _owner) public constant returns (uint256 balance) {
249         return lockedBalance[_owner];
250     }
251 
252     //release time of locked
253     function unlockTimeOf(address _owner) public constant returns (uint timelimit) {
254         return timeRelease[_owner];
255     }
256 
257 
258     // transfer to and lock it
259     function transferAndLock(address _to, uint256 _value, uint _releaseTime) public returns (bool success) {
260         require(_to != 0x0);
261         require(_value <= balances[msg.sender]);
262         require(_value > 0);
263         require(_releaseTime > now && _releaseTime <= now + 60*60*24*365*5);
264 
265         // SafeMath.sub will throw if there is not enough balance.
266         balances[msg.sender] = balances[msg.sender].sub(_value);
267        
268         //if preLock can release 
269         uint preRelease = timeRelease[_to];
270         if (preRelease <= now && preRelease != 0x0) {
271             balances[_to] = balances[_to].add(lockedBalance[_to]);
272             lockedBalance[_to] = 0;
273         }
274 
275         lockedBalance[_to] = lockedBalance[_to].add(_value);
276         timeRelease[_to] =  _releaseTime >= timeRelease[_to] ? _releaseTime : timeRelease[_to]; 
277         emit Transfer(msg.sender, _to, _value);
278         emit Lock(_to, _value, _releaseTime);
279         return true;
280     }
281 
282 
283    /**
284    * @notice Transfers tokens held by lock.
285    */
286    function unlock() public  payable returns (bool success) {
287         uint256 amount = lockedBalance[msg.sender];
288         require(amount > 0);
289         require(now >= timeRelease[msg.sender]);
290 
291         balances[msg.sender] = balances[msg.sender].add(amount);
292         lockedBalance[msg.sender] = 0;
293         timeRelease[msg.sender] = 0;
294 
295         emit Transfer(0x0, msg.sender, amount);
296         emit UnLock(msg.sender, amount);
297 
298         return true;
299 
300     }
301 
302 
303     /**
304      * @dev Burns a specific amount of tokens.
305      * @param _value The amount of token to be burned.
306      */
307     function burn(uint256 _value) public returns (bool success) {
308         require(_value > 0);
309         require(_value <= balances[msg.sender]);
310     
311         address burner = msg.sender;
312         balances[burner] = balances[burner].sub(_value);
313         totalSupply = totalSupply.sub(_value);
314         emit Burn(burner, _value);
315         return true;
316     }
317 
318     
319 
320 
321 }