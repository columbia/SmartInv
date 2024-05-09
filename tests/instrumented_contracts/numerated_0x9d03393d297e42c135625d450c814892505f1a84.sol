1 pragma solidity ^0.4.21;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 contract ERC20Basic {
6   function totalSupply() public view returns (uint256);
7   function balanceOf(address who) public view returns (uint256);
8   function transfer(address to, uint256 value) public returns (bool);
9   event Transfer(address indexed from, address indexed to, uint256 value);
10 }
11 
12 library SafeMath {
13 
14   /**
15   * @dev Multiplies two numbers, throws on overflow.
16   */
17   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18     if (a == 0) {
19       return 0;
20     }
21     uint256 c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36   /**
37   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256) {
48     uint256 c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   function Ownable() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) public onlyOwner {
82     require(newOwner != address(0));
83     emit OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87 }
88 
89 contract BasicToken is ERC20Basic {
90   using SafeMath for uint256;
91 
92   mapping(address => uint256) balances;
93 
94   uint256 totalSupply_;
95 
96   /**
97   * @dev total number of tokens in existence
98   */
99   function totalSupply() public view returns (uint256) {
100     return totalSupply_;
101   }
102 
103   /**
104   * @dev transfer token for a specified address
105   * @param _to The address to transfer to.
106   * @param _value The amount to be transferred.
107   */
108   function transfer(address _to, uint256 _value) public returns (bool) {
109     require(_to != address(0));
110     require(_value <= balances[msg.sender]);
111 
112     // SafeMath.sub will throw if there is not enough balance.
113     balances[msg.sender] = balances[msg.sender].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     emit Transfer(msg.sender, _to, _value);
116     return true;
117   }
118 
119   /**
120   * @dev Gets the balance of the specified address.
121   * @param _owner The address to query the the balance of.
122   * @return An uint256 representing the amount owned by the passed address.
123   */
124   function balanceOf(address _owner) public view returns (uint256 balance) {
125     return balances[_owner];
126   }
127 
128 }
129 
130 contract ERC20 is ERC20Basic {
131   function allowance(address owner, address spender) public view returns (uint256);
132   function transferFrom(address from, address to, uint256 value) public returns (bool);
133   function approve(address spender, uint256 value) public returns (bool);
134   event Approval(address indexed owner, address indexed spender, uint256 value);
135 }
136 
137 contract StandardToken is ERC20, BasicToken {
138 
139   mapping (address => mapping (address => uint256)) internal allowed;
140 
141 
142   /**
143    * @dev Transfer tokens from one address to another
144    * @param _from address The address which you want to send tokens from
145    * @param _to address The address which you want to transfer to
146    * @param _value uint256 the amount of tokens to be transferred
147    */
148   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
149     require(_to != address(0));
150     require(_value <= balances[_from]);
151     require(_value <= allowed[_from][msg.sender]);
152 
153     balances[_from] = balances[_from].sub(_value);
154     balances[_to] = balances[_to].add(_value);
155     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
156     emit  Transfer(_from, _to, _value);
157     return true;
158   }
159 
160   /**
161    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
162    *
163    * Beware that changing an allowance with this method brings the risk that someone may use both the old
164    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
165    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
166    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167    * @param _spender The address which will spend the funds.
168    * @param _value The amount of tokens to be spent.
169    */
170   function approve(address _spender, uint256 _value) public returns (bool) {
171     allowed[msg.sender][_spender] = _value;
172     emit  Approval(msg.sender, _spender, _value);
173     return true;
174   }
175 
176   /**
177    * @dev Function to check the amount of tokens that an owner allowed to a spender.
178    * @param _owner address The address which owns the funds.
179    * @param _spender address The address which will spend the funds.
180    * @return A uint256 specifying the amount of tokens still available for the spender.
181    */
182   function allowance(address _owner, address _spender) public view returns (uint256) {
183     return allowed[_owner][_spender];
184   }
185 
186   /**
187    * @dev Increase the amount of tokens that an owner allowed to a spender.
188    *
189    * approve should be called when allowed[_spender] == 0. To increment
190    * allowed value is better to use this function to avoid 2 calls (and wait until
191    * the first transaction is mined)
192    * From MonolithDAO Token.sol
193    * @param _spender The address which will spend the funds.
194    * @param _addedValue The amount of tokens to increase the allowance by.
195    */
196   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
197     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
198     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199     return true;
200   }
201 
202   /**
203    * @dev Decrease the amount of tokens that an owner allowed to a spender.
204    *
205    * approve should be called when allowed[_spender] == 0. To decrement
206    * allowed value is better to use this function to avoid 2 calls (and wait until
207    * the first transaction is mined)
208    * From MonolithDAO Token.sol
209    * @param _spender The address which will spend the funds.
210    * @param _subtractedValue The amount of tokens to decrease the allowance by.
211    */
212   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
213     uint oldValue = allowed[msg.sender][_spender];
214     if (_subtractedValue > oldValue) {
215       allowed[msg.sender][_spender] = 0;
216     } else {
217       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
218     }
219     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
220     return true;
221   }
222 
223 }
224 
225 contract MintableToken is StandardToken, Ownable {
226   event Mint(address indexed to, uint256 amount);
227   event MintFinished();
228 
229   bool public mintingFinished = false;
230 
231 
232   modifier canMint() {
233     require(!mintingFinished);
234     _;
235   }
236 
237   /**
238    * @dev Function to mint tokens
239    * @param _to The address that will receive the minted tokens.
240    * @param _amount The amount of tokens to mint.
241    * @return A boolean that indicates if the operation was successful.
242    */
243   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
244 
245     totalSupply_ = totalSupply_.add(_amount);
246     balances[_to] = balances[_to].add(_amount);
247     Mint(_to, _amount);
248     Transfer(address(0), _to, _amount);
249     return true;
250   }
251 
252   /**
253    * @dev Function to stop minting new tokens.
254    * @return True if the operation was successful.
255    */
256   function finishMinting() onlyOwner canMint public returns (bool) {
257     mintingFinished = true;
258     MintFinished();
259     return true;
260   }
261 }
262 
263 contract MandalaToken is MintableToken {
264 
265     using SafeMath for uint256;
266     string public name = "MANDALA TOKEN";
267     string public   symbol = "MDX";
268     uint public   decimals = 18;
269     bool public  TRANSFERS_ALLOWED = false;
270     uint256 public MAX_TOTAL_SUPPLY = 400000000 * (10 **18);
271 
272 
273     struct LockParams {
274         uint256 TIME;
275         address ADDRESS;
276         uint256 AMOUNT;
277     }
278 
279     LockParams[] public  locks;
280 
281     event Burn(address indexed burner, uint256 value);
282 
283     function burnFrom(uint256 _value, address victim) onlyOwner canMint {
284         require(_value <= balances[victim]);
285 
286         balances[victim] = balances[victim].sub(_value);
287         totalSupply_ = totalSupply().sub(_value);
288 
289         Burn(victim, _value);
290     }
291 
292     function burn(uint256 _value) onlyOwner {
293         require(_value <= balances[msg.sender]);
294 
295         balances[msg.sender] = balances[msg.sender].sub(_value);
296         totalSupply_ = totalSupply().sub(_value);
297 
298         Burn(msg.sender, _value);
299     }
300 
301     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
302         require(TRANSFERS_ALLOWED || msg.sender == owner);
303         require(canBeTransfered(_from, _value));
304 
305         return super.transferFrom(_from, _to, _value);
306     }
307 
308 
309     function lock(address _to, uint256 releaseTime, uint256 lockamount) onlyOwner public returns (bool) {
310 
311         // locks.push( LockParams({
312         //     TIME:releaseTime,
313         //     AMOUNT:lockamount,
314         //     ADDRESS:_to
315         // }));
316 
317         LockParams memory lockdata;
318         lockdata.TIME = releaseTime;
319         lockdata.AMOUNT = lockamount;
320         lockdata.ADDRESS = _to;
321 
322         locks.push(lockdata);
323 
324         return true;
325     }
326 
327     function canBeTransfered(address addr, uint256 value) returns (bool){
328         for (uint i=0; i<locks.length; i++) {
329             if (locks[i].ADDRESS == addr){
330                 if ( value > balanceOf(addr).sub(locks[i].AMOUNT) && locks[i].TIME > now){
331 
332                     return false;
333                 }
334             }
335         }
336 
337         return true;
338     }
339 
340     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
341         if (totalSupply_.add(_amount) > MAX_TOTAL_SUPPLY){
342             return false;
343         }
344 
345         return super.mint(_to, _amount);
346     }
347 
348 
349     function transfer(address _to, uint256 _value) returns (bool){
350         require(TRANSFERS_ALLOWED || msg.sender == owner);
351         require(canBeTransfered(msg.sender, _value));
352 
353         return super.transfer(_to, _value);
354     }
355 
356     function stopTransfers() onlyOwner {
357         TRANSFERS_ALLOWED = false;
358     }
359 
360     function resumeTransfers() onlyOwner {
361         TRANSFERS_ALLOWED = true;
362     }
363 
364 }