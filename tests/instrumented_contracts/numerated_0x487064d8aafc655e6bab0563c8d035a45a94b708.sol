1 pragma solidity ^0.4.11;
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
33 
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40   uint256 public totalSupply;
41   function balanceOf(address who) public constant returns (uint256);
42   function transfer(address to, uint256 value)public  returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 
47 /**
48  * @title ERC20 interface
49  * @dev see https://github.com/ethereum/EIPs/issues/20
50  */
51 contract ERC20 is ERC20Basic {
52   function allowance(address owner, address spender)public constant returns (uint256);
53   function transferFrom(address from, address to, uint256 value)public  returns (bool);
54   function approve(address spender, uint256 value)public returns (bool);
55   event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 
59 /**
60  * @title Basic token
61  * @dev Basic version of StandardToken, with no allowances.
62  */
63 contract BasicToken is ERC20Basic {
64   using SafeMath for uint256;
65 
66   mapping(address => uint256) balances;
67 
68   /**
69   * @dev transfer token for a specified address
70   * @param _to The address to transfer to.
71   * @param _value The amount to be transferred.
72   */
73   function transfer(address _to, uint256 _value) public returns (bool) {
74     balances[msg.sender] = balances[msg.sender].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     emit Transfer(msg.sender, _to, _value);
77     return true;
78   }
79 
80   /**
81   * @dev Gets the balance of the specified address.
82   * @param _owner The address to query the the balance of.
83   * @return An uint256 representing the amount owned by the passed address.
84   */
85   function balanceOf(address _owner) public constant returns (uint256 balance) {
86     return balances[_owner];
87   }
88 
89 }
90 
91 /**
92  * @title Ownable
93  * @dev The Ownable contract has an owner address, and provides basic authorization control
94  * functions, this simplifies the implementation of "user permissions".
95  */
96 contract Ownable {
97   address public owner;
98 
99 
100   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
101 
102 
103   /**
104    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
105    * account.
106    */
107   constructor() public {
108     owner = msg.sender;
109   }
110 
111 
112   /**
113    * @dev Throws if called by any account other than the owner.
114    */
115   modifier onlyOwner() {
116     require(msg.sender == owner);
117     _;
118   }
119 
120 
121   /**
122    * @dev Allows the current owner to transfer control of the contract to a newOwner.
123    * @param newOwner The address to transfer ownership to.
124    */
125   function transferOwnership(address newOwner) public onlyOwner {
126     require(newOwner != address(0));
127     emit OwnershipTransferred(owner, newOwner);
128     owner = newOwner;
129   }
130 
131 }
132 /**
133  * @title Pausable
134  * @dev Base contract which allows children to implement an emergency stop mechanism.
135  */
136 contract Pausable is Ownable {
137   event Pause();
138   event Unpause();
139 
140   bool public paused = false;
141 
142 
143   /**
144    * @dev modifier to allow actions only when the contract IS paused
145    */
146   modifier whenNotPaused() {
147     require(!paused);
148     _;
149   }
150 
151   /**
152    * @dev modifier to allow actions only when the contract IS NOT paused
153    */
154   modifier whenPaused {
155     require(paused);
156     _;
157   }
158 
159   /**
160    * @dev called by the owner to pause, triggers stopped state
161    */
162   function pause() public onlyOwner whenNotPaused returns (bool) {
163     paused = true;
164     emit Pause();
165     return true;
166   }
167 
168   /**
169    * @dev called by the owner to unpause, returns to normal state
170    */
171   function unpause()public onlyOwner whenPaused returns (bool) {
172     paused = false;
173     emit Unpause();
174     return true;
175   }
176 }
177 /**
178  * @title Standard ERC20 token
179  *
180  * @dev Implementation of the basic standard token.
181  * @dev https://github.com/ethereum/EIPs/issues/20
182  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
183  */
184 contract StandardToken is ERC20, BasicToken {
185 
186   mapping (address => mapping (address => uint256)) allowed;
187 
188 
189   /**
190    * @dev Transfer tokens from one address to another
191    * @param _from address The address which you want to send tokens from
192    * @param _to address The address which you want to transfer to
193    * @param _value uint256 the amout of tokens to be transfered
194    */
195   function transferFrom(address _from, address _to, uint256 _value)public returns (bool) {
196     var _allowance = allowed[_from][msg.sender];
197 
198     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
199     // require (_value <= _allowance);
200 
201     balances[_to] = balances[_to].add(_value);
202     balances[_from] = balances[_from].sub(_value);
203     allowed[_from][msg.sender] = _allowance.sub(_value);
204     emit Transfer(_from, _to, _value);
205     return true;
206   }
207 
208   /**
209    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
210    * @param _spender The address which will spend the funds.
211    * @param _value The amount of tokens to be spent.
212    */
213   function approve(address _spender, uint256 _value)public returns (bool) {
214 
215     // To change the approve amount you first have to reduce the addresses`
216     //  allowance to zero by calling `approve(_spender, 0)` if it is not
217     //  already 0 to mitigate the race condition described here:
218     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
219     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
220 
221     allowed[msg.sender][_spender] = _value;
222     emit Approval(msg.sender, _spender, _value);
223     return true;
224   }
225 
226   /**
227    * @dev Function to check the amount of tokens that an owner allowed to a spender.
228    * @param _owner address The address which owns the funds.
229    * @param _spender address The address which will spend the funds.
230    * @return A uint256 specifing the amount of tokens still avaible for the spender.
231    */
232   function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {
233     return allowed[_owner][_spender];
234   }
235 
236 }
237 
238 /**
239  * @title LK Token
240  * @dev LK is PausableToken
241  */
242 contract LKToken is StandardToken, Pausable {
243 
244   string public constant name = "莱克币";
245   string public constant symbol = "LK";
246   uint256 public constant decimals = 18;
247   
248   // lock
249   struct LockToken{
250       uint256 amount;
251       uint32  time;
252   }
253   struct LockTokenSet{
254       LockToken[] lockList;
255   }
256   mapping ( address => LockTokenSet ) addressTimeLock;
257   mapping ( address => bool ) lockAdminList;
258   event TransferWithLockEvt(address indexed from, address indexed to, uint256 value,uint32 lockTime );
259   /**
260     * @dev Creates a new MPKToken instance
261     */
262   constructor() public {
263     totalSupply = 100 * (10 ** 8) * (10 ** 18);
264     balances[msg.sender] = totalSupply;
265     balances[0xE300410c27C7ce3C61B2F054171ad26F4099EAa6] = totalSupply;
266     setLockAdmin(0xE300410c27C7ce3C61B2F054171ad26F4099EAa6,true);
267 	emit Transfer(0, 0xE300410c27C7ce3C61B2F054171ad26F4099EAa6, totalSupply );
268   }
269   
270   function transfer(address _to, uint256 _value)public whenNotPaused returns (bool) {
271     assert ( balances[msg.sender].sub( getLockAmount( msg.sender ) ) >= _value );
272     return super.transfer(_to, _value);
273   }
274 
275   function transferFrom(address _from, address _to, uint256 _value)public whenNotPaused returns (bool) {
276     assert ( balances[_from].sub( getLockAmount( msg.sender ) ) >= _value );
277     return super.transferFrom(_from, _to, _value);
278   }
279   function getLockAmount( address myaddress ) public view returns ( uint256 lockSum ) {
280         uint256 lockAmount = 0;
281         for( uint32 i = 0; i < addressTimeLock[myaddress].lockList.length; i ++ ){
282             if( addressTimeLock[myaddress].lockList[i].time > now ){
283                 lockAmount += addressTimeLock[myaddress].lockList[i].amount;
284             }
285         }
286         return lockAmount;
287   }
288   
289   function getLockListLen( address myaddress ) public view returns ( uint256 lockAmount  ){
290       return addressTimeLock[myaddress].lockList.length;
291   }
292   
293   function getLockByIdx( address myaddress,uint32 idx ) public view returns ( uint256 lockAmount, uint32 lockTime ){
294       if( idx >= addressTimeLock[myaddress].lockList.length ){
295         return (0,0);          
296       }
297       lockAmount = addressTimeLock[myaddress].lockList[idx].amount;
298       lockTime = addressTimeLock[myaddress].lockList[idx].time;
299       return ( lockAmount,lockTime );
300   }
301   
302   function transferWithLock( address _to, uint256 _value,uint32 _lockTime )public whenNotPaused {
303       assert( lockAdminList[msg.sender] == true  );
304       assert( _lockTime > now  );
305       transfer( _to, _value );
306       bool needNewLock = true;
307       for( uint32 i = 0 ; i< addressTimeLock[_to].lockList.length; i ++ ){
308           if( addressTimeLock[_to].lockList[i].time < now ){
309               addressTimeLock[_to].lockList[i].time = _lockTime;
310               addressTimeLock[_to].lockList[i].amount = _value;
311               emit TransferWithLockEvt( msg.sender,_to,_value,_lockTime );
312               needNewLock = false;
313               break;
314           }
315       }
316       if( needNewLock == true ){
317           // add a lock
318           addressTimeLock[_to].lockList.length ++ ;
319           addressTimeLock[_to].lockList[(addressTimeLock[_to].lockList.length-1)].time = _lockTime;
320           addressTimeLock[_to].lockList[(addressTimeLock[_to].lockList.length-1)].amount = _value;
321           emit TransferWithLockEvt( msg.sender,_to,_value,_lockTime);
322       }
323   }
324   function setLockAdmin(address _to,bool canUse)public onlyOwner{
325       assert( lockAdminList[_to] != canUse );
326       lockAdminList[_to] = canUse;
327   }
328   function canUseLock()  public view returns (bool){
329       return lockAdminList[msg.sender];
330   }
331 
332 }