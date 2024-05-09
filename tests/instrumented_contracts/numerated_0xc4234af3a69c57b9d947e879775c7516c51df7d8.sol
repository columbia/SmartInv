1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, reverts on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (a == 0) {
13       return 0;
14     }
15 
16     uint256 c = a * b;
17     require(c / a == b);
18 
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     require(b > 0); // Solidity only automatically asserts when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 
30     return c;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     require(b <= a);
38     uint256 c = a - b;
39 
40     return c;
41   }
42 
43   /**
44   * @dev Adds two numbers, reverts on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256) {
47     uint256 c = a + b;
48     require(c >= a);
49 
50     return c;
51   }
52 
53   /**
54   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
55   * reverts when dividing by zero.
56   */
57   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58     require(b != 0);
59     return a % b;
60   }
61 }
62 
63 
64 /**
65  * @title ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/20
67  */
68 interface IERC20 {
69   function totalSupply() external view returns (uint256);
70 
71   function balanceOf(address who) external view returns (uint256);
72 
73   function allowance(address owner, address spender)
74     external view returns (uint256);
75 
76   function transfer(address to, uint256 value) external returns (bool);
77 
78   function approve(address spender, uint256 value)
79     external returns (bool);
80 
81   function transferFrom(address from, address to, uint256 value)
82     external returns (bool);
83 
84   event Transfer(
85     address indexed from,
86     address indexed to,
87     uint256 value
88   );
89 
90   event Approval(
91     address indexed owner,
92     address indexed spender,
93     uint256 value
94   );
95 }
96 
97 contract Owned {
98   address owner;
99   constructor () public {
100     owner = msg.sender;
101   }
102 
103   modifier onlyOwner {
104     require(msg.sender == owner,"Only owner can do it.");
105     _;
106   }
107 }
108 
109 /**
110  * @title Standard ERC20 token
111  *
112  * @dev Implementation of the basic standard token.
113  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
114  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
115  */
116 contract HuaLiTestToken is IERC20 , Owned{
117 
118   string public constant name = "HuaLiTestToken";
119   string public constant symbol = "HHLCTest";
120   uint8 public constant decimals = 18;
121 
122   uint256 private constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));
123 
124   using SafeMath for uint256;
125 
126   mapping (address => uint256) private _balances;
127 
128   mapping (address => mapping (address => uint256)) private _allowed;
129 
130   uint256 private _totalSupply;
131 
132   
133   mapping(address => uint256) balances;
134   uint256[] public releaseTimeLines=[1539515876,1539516176,1539516476,1539516776,1539517076,1539517376,1539517676,1539517976,1539518276,1539518576,1539518876,1539519176,1539519476,1539519776,1539520076,1539520376,1539520676,1539520976,1539521276,1539521576,1539521876,1539522176,1539522476,1539522776];
135     
136   struct Role {
137     address roleAddress;
138     uint256 amount;
139     uint256 firstRate;
140     uint256 round;
141     uint256 rate;
142   }
143    
144   mapping (address => mapping (uint256 => Role)) public mapRoles;
145   mapping (address => address) private lockList;
146   
147   event Lock(address from, uint256 value, uint256 lockAmount , uint256 balance);
148   
149   constructor() public {
150     _mint(msg.sender, INITIAL_SUPPLY);
151   }
152 
153   /**
154   * @dev Total number of tokens in existence
155   */
156   function totalSupply() public view returns (uint256) {
157     return _totalSupply;
158   }
159 
160   /**
161   * @dev Gets the balance of the specified address.
162   * @param owner The address to query the balance of.
163   * @return An uint256 representing the amount owned by the passed address.
164   */
165   function balanceOf(address owner) public view returns (uint256) {
166     return _balances[owner];
167   }
168 
169   /**
170    * @dev Function to check the amount of tokens that an owner allowed to a spender.
171    * @param owner address The address which owns the funds.
172    * @param spender address The address which will spend the funds.
173    * @return A uint256 specifying the amount of tokens still available for the spender.
174    */
175   function allowance(
176     address owner,
177     address spender
178    )
179     public
180     view
181     returns (uint256)
182   {
183     return _allowed[owner][spender];
184   }
185 
186   /**
187   * @dev Transfer token for a specified address
188   * @param to The address to transfer to.
189   * @param value The amount to be transferred.
190   */
191   function transfer(address to, uint256 value) public returns (bool) {
192     if(_canTransfer(msg.sender,value)){ 
193       _transfer(msg.sender, to, value);
194       return true;
195     } else {
196       emit Lock(msg.sender,value,getLockAmount(msg.sender),balanceOf(msg.sender));
197       return false;
198     }
199   }
200 
201   /**
202    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
203    * Beware that changing an allowance with this method brings the risk that someone may use both the old
204    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
205    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
206    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
207    * @param spender The address which will spend the funds.
208    * @param value The amount of tokens to be spent.
209    */
210   function approve(address spender, uint256 value) public returns (bool) {
211     require(spender != address(0));
212 
213     _allowed[msg.sender][spender] = value;
214     emit Approval(msg.sender, spender, value);
215     return true;
216   }
217 
218   /**
219    * @dev Transfer tokens from one address to another
220    * @param from address The address which you want to send tokens from
221    * @param to address The address which you want to transfer to
222    * @param value uint256 the amount of tokens to be transferred
223    */
224   function transferFrom(
225     address from,
226     address to,
227     uint256 value
228   )
229     public
230     returns (bool)
231   {
232     require(value <= _allowed[from][msg.sender]);
233     
234     if (_canTransfer(from, value)) {
235         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
236         _transfer(from, to, value);
237         return true;
238     } else {
239         emit Lock(from,value,getLockAmount(from),balanceOf(from));
240         return false;
241     }
242   }
243 
244   /**
245    * @dev Increase the amount of tokens that an owner allowed to a spender.
246    * approve should be called when allowed_[_spender] == 0. To increment
247    * allowed value is better to use this function to avoid 2 calls (and wait until
248    * the first transaction is mined)
249    * From MonolithDAO Token.sol
250    * @param spender The address which will spend the funds.
251    * @param addedValue The amount of tokens to increase the allowance by.
252    */
253   function increaseAllowance(
254     address spender,
255     uint256 addedValue
256   )
257     public
258     returns (bool)
259   {
260     require(spender != address(0));
261 
262     _allowed[msg.sender][spender] = (
263       _allowed[msg.sender][spender].add(addedValue));
264     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
265     return true;
266   }
267 
268   /**
269    * @dev Decrease the amount of tokens that an owner allowed to a spender.
270    * approve should be called when allowed_[_spender] == 0. To decrement
271    * allowed value is better to use this function to avoid 2 calls (and wait until
272    * the first transaction is mined)
273    * From MonolithDAO Token.sol
274    * @param spender The address which will spend the funds.
275    * @param subtractedValue The amount of tokens to decrease the allowance by.
276    */
277   function decreaseAllowance(
278     address spender,
279     uint256 subtractedValue
280   )
281     public
282     returns (bool)
283   {
284     require(spender != address(0));
285 
286     _allowed[msg.sender][spender] = (
287       _allowed[msg.sender][spender].sub(subtractedValue));
288     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
289     return true;
290   }
291 
292   /**
293   * @dev Transfer token for a specified addresses
294   * @param from The address to transfer from.
295   * @param to The address to transfer to.
296   * @param value The amount to be transferred.
297   */
298   function _transfer(address from, address to, uint256 value) internal {
299     require(value <= _balances[from]);
300     require(to != address(0));
301     
302     _balances[from] = _balances[from].sub(value);
303     _balances[to] = _balances[to].add(value);
304     emit Transfer(from, to, value);
305     
306   }
307 
308   /**
309    * @dev Internal function that mints an amount of the token and assigns it to
310    * an account. This encapsulates the modification of balances such that the
311    * proper events are emitted.
312    * @param account The account that will receive the created tokens.
313    * @param value The amount that will be created.
314    */
315   function _mint(address account, uint256 value) internal {
316     require(account != 0);
317     _totalSupply = _totalSupply.add(value);
318     _balances[account] = _balances[account].add(value);
319     emit Transfer(address(0), account, value);
320   }
321   
322   function setTimeLine(uint256[] timeLine) onlyOwner public {
323     releaseTimeLines = timeLine;
324   }
325   
326   /**
327    * @dev getRoleReleaseSeting
328    * @param roleType 1:Seed 2:Angel 3:PE 4:AirDrop
329    */
330   function getRoleReleaseSeting(uint256 roleType) pure public returns (uint256,uint256,uint256) {
331     if(roleType == 1){
332       return (50,1,10);
333     }else if(roleType == 2){
334       return (30,1,10);
335     }else if(roleType == 3){
336       return (40,3,20);
337     }else if(roleType == 4){
338       return (5,1,5);
339     }else {
340       return (0,0,0);
341     }
342   }
343   
344   function addLockUser(address roleAddress,uint256 amount,uint256 roleType) onlyOwner public {
345     (uint256 firstRate, uint256 round, uint256 rate) = getRoleReleaseSeting(roleType);
346     mapRoles[roleAddress][roleType] = Role(roleAddress,amount,firstRate,round,rate);
347     lockList[roleAddress] = roleAddress;
348   }
349   
350   function addLockUsers(address[] roleAddress,uint256[] amounts,uint256 roleType) onlyOwner public {
351     for(uint i= 0;i<roleAddress.length;i++){
352       addLockUser(roleAddress[i],amounts[i],roleType);
353     }
354   }
355   
356   function removeLockUser(address roleAddress,uint256 role) onlyOwner public {
357     mapRoles[roleAddress][role] = Role(0x0,0,0,0,0);
358     lockList[roleAddress] = 0x0;
359   }
360   
361   function getRound() constant public returns (uint) {
362     for(uint i= 0;i<releaseTimeLines.length;i++){
363       if(now<releaseTimeLines[i]){
364         if(i>0){
365           return i-1;
366         }else{
367           return 0;
368         }
369       }
370     }
371   }
372    
373   function isUserInLockList(address from) constant public returns (bool) {
374     if(lockList[from]==0x0){
375       return false;
376     } else {
377       return true;
378     }
379   }
380   
381   function _canTransfer(address from,uint256 _amount) private returns (bool) {
382     if(!isUserInLockList(from)){
383       return true;
384     }
385     if((balanceOf(from))<=0){
386       return true;
387     }
388     uint256 _lock = getLockAmount(from);
389     if(_lock<=0){
390       lockList[from] = 0x0;
391     }
392     if((balanceOf(from).sub(_amount))<_lock){
393       return false;
394     }
395     return true;
396   }
397   
398   function getLockAmount(address from) constant public returns (uint256) {
399     uint256 _lock = 0;
400     for(uint i= 1;i<=4;i++){
401       if(mapRoles[from][i].roleAddress != 0x0){
402         _lock = _lock.add(getLockAmountByRoleType(from,i));
403       }
404     }
405     return _lock;
406   }
407   
408   function getLockAmountByRoleType(address from,uint roleType) constant public returns (uint256) {
409     uint256 _rount = getRound();
410     uint256 round = 0;
411     if(_rount>0){
412       round = _rount.div(mapRoles[from][roleType].round);
413     }
414     if(mapRoles[from][roleType].firstRate.add(round.mul(mapRoles[from][roleType].rate))>=100){
415       return 0;
416     }
417     uint256 firstAmount = mapRoles[from][roleType].amount.mul(mapRoles[from][roleType].firstRate).div(100);
418     uint256 rountAmount = 0;
419     if(round>0){
420       rountAmount = mapRoles[from][roleType].amount.mul(mapRoles[from][roleType].rate.mul(round)).div(100);
421     }
422     return mapRoles[from][roleType].amount.sub(firstAmount.add(rountAmount));
423   }
424     
425 }