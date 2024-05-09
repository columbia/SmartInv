1 // File: contracts/zeppelin/token/ERC20Basic.sol
2 
3 pragma solidity ^0.4.18;
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   uint256 public totalSupply;
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 // File: contracts/zeppelin/math/SafeMath.sol
19 
20 pragma solidity ^0.4.18;
21 
22 library SafeMath {
23   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24     if (a == 0) {
25       return 0;
26     }
27     uint256 c = a * b;
28     assert(c / a == b);
29     return c;
30   }
31 
32   function div(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a / b;
34     return c;
35   }
36 
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 // File: contracts/zeppelin/token/BasicToken.sol
50 
51 pragma solidity ^0.4.18;
52 
53 
54 
55 
56 /**
57  * @title Basic token
58  * @dev Basic version of StandardToken, with no allowances.
59  */
60 contract BasicToken is ERC20Basic {
61   using SafeMath for uint256;
62 
63   mapping(address => uint256) balances;
64 
65   /**
66   * @dev transfer token for a specified address
67   * @param _to The address to transfer to.
68   * @param _value The amount to be transferred.
69   */
70   function transfer(address _to, uint256 _value) public returns (bool) {
71     require(_to != address(0));
72     require(_value <= balances[msg.sender]);
73 
74     // SafeMath.sub will throw if there is not enough balance.
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   /**
82   * @dev Gets the balance of the specified address.
83   * @param _owner The address to query the the balance of.
84   * @return An uint256 representing the amount owned by the passed address.
85   */
86   function balanceOf(address _owner) public view returns (uint256 balance) {
87     return balances[_owner];
88   }
89 
90 }
91 
92 // File: contracts/zeppelin/token/ERC20.sol
93 
94 pragma solidity ^0.4.18;
95 
96 
97 
98 /**
99  * @title ERC20 interface
100  * @dev see https://github.com/ethereum/EIPs/issues/20
101  */
102 contract ERC20 is ERC20Basic {
103   function allowance(address owner, address spender) public view returns (uint256);
104   function transferFrom(address from, address to, uint256 value) public returns (bool);
105   function approve(address spender, uint256 value) public returns (bool);
106   event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 // File: contracts/zeppelin/token/StandardToken.sol
110 
111 pragma solidity ^0.4.18;
112 
113 
114 
115 
116 /**
117  * @title Standard ERC20 token
118  *
119  * @dev Implementation of the basic standard token.
120  * @dev https://github.com/ethereum/EIPs/issues/20
121  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
122  */
123 contract StandardToken is ERC20, BasicToken {
124   mapping (address => mapping (address => uint256)) internal allowed;
125 
126   /**
127    * @dev Transfer tokens from one address to another
128    * @param _from address The address which you want to send tokens from
129    * @param _to address The address which you want to transfer to
130    * @param _value uint256 the amount of tokens to be transferred
131    */
132   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[_from]);
135     require(_value <= allowed[_from][msg.sender]);
136 
137     balances[_from] = balances[_from].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
140     Transfer(_from, _to, _value);
141     return true;
142   }
143 
144   /**
145    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
146    *
147    * Beware that changing an allowance with this method brings the risk that someone may use both the old
148    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
149    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
150    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151    * @param _spender The address which will spend the funds.
152    * @param _value The amount of tokens to be spent.
153    */
154   function approve(address _spender, uint256 _value) public returns (bool) {
155     allowed[msg.sender][_spender] = _value;
156     Approval(msg.sender, _spender, _value);
157     return true;
158   }
159 
160   /**
161    * @dev Function to check the amount of tokens that an owner allowed to a spender.
162    * @param _owner address The address which owns the funds.
163    * @param _spender address The address which will spend the funds.
164    * @return A uint256 specifying the amount of tokens still available for the spender.
165    */
166   function allowance(address _owner, address _spender) public view returns (uint256) {
167     return allowed[_owner][_spender];
168   }
169 
170   /**
171    * approve should be called when allowed[_spender] == 0. To increment
172    * allowed value is better to use this function to avoid 2 calls (and wait until
173    * the first transaction is mined)
174    * From MonolithDAO Token.sol
175    */
176   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
177     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
178     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
179     return true;
180   }
181 
182   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
183     uint oldValue = allowed[msg.sender][_spender];
184     if (_subtractedValue > oldValue) {
185       allowed[msg.sender][_spender] = 0;
186     } else {
187       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
188     }
189     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190     return true;
191   }
192 
193 }
194 
195 // File: contracts/zeppelin/ownership/Ownable.sol
196 
197 pragma solidity ^0.4.18;
198 
199 
200 contract Ownable {
201   address public owner;
202 
203 
204   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
205 
206 
207   function Ownable() public {
208     owner = msg.sender;
209   }
210 
211 
212 
213   modifier onlyOwner() {
214     require(msg.sender == owner);
215     _;
216   }
217 
218 
219   function transferOwnership(address newOwner) public onlyOwner {
220     require(newOwner != address(0));
221     OwnershipTransferred(owner, newOwner);
222     owner = newOwner;
223   }
224 
225 }
226 
227 // File: contracts/zeppelin/lifecycle/Pausable.sol
228 
229 pragma solidity ^0.4.18;
230 
231 
232 contract Pausable is Ownable {
233   event PausePublic(bool newState);
234   event PauseOwnerAdmin(bool newState);
235 
236   bool public pausedPublic = true;
237   bool public pausedOwnerAdmin = false;
238 
239   address public admin;
240 
241   modifier whenNotPaused() {
242     if(pausedPublic) {
243       if(!pausedOwnerAdmin) {
244         require(msg.sender == admin || msg.sender == owner);
245       } else {
246         revert();
247       }
248     }
249     _;
250   }
251 
252   function pause(bool newPausedPublic, bool newPausedOwnerAdmin) onlyOwner public {
253     require(!(newPausedPublic == false && newPausedOwnerAdmin == true));
254 
255     pausedPublic = newPausedPublic;
256     pausedOwnerAdmin = newPausedOwnerAdmin;
257 
258     PausePublic(newPausedPublic);
259     PauseOwnerAdmin(newPausedOwnerAdmin);
260   }
261 }
262 
263 // File: contracts/zeppelin/token/PausableToken.sol
264 
265 pragma solidity ^0.4.18;
266 
267 
268 
269 /**
270  * @title Pausable token
271  *
272  * @dev StandardToken modified with pausable transfers.
273  **/
274 
275 contract PausableToken is StandardToken, Pausable {
276 
277   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
278     return super.transfer(_to, _value);
279   }
280 
281   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
282     return super.transferFrom(_from, _to, _value);
283   }
284 
285   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
286     return super.approve(_spender, _value);
287   }
288 
289   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
290     return super.increaseApproval(_spender, _addedValue);
291   }
292 
293   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
294     return super.decreaseApproval(_spender, _subtractedValue);
295   }
296 }
297 
298 // File: contracts/FinToken.sol
299 
300 pragma solidity ^0.4.18;
301 
302 
303 contract FinToken is PausableToken {
304 
305     string  public  constant name = "Fuel Injection Network";
306     string  public  constant symbol = "FIN";
307     uint8   public  constant decimals = 18;
308 
309     mapping(address => uint) approvedInvestorListWithDate;
310 
311     function FinToken( address _admin, uint256 _totalTokenAmount )
312     {
313         admin = _admin;
314 
315         totalSupply = _totalTokenAmount;
316         balances[msg.sender] = _totalTokenAmount;
317         Transfer(address(0x0), msg.sender, _totalTokenAmount);
318     }
319 
320     function getTime() public constant returns (uint) {
321         return now;
322     }
323 
324     function isUnlocked() internal view returns (bool) {
325         return getTime() >= getLockFundsReleaseTime(msg.sender);
326     }
327 
328     modifier validDestination( address to )
329     {
330         require(to != address(0x0));
331         require(to != address(this));
332         _;
333     }
334 
335     modifier onlyWhenUnlocked()
336     {
337         require(isUnlocked());            
338         _;
339     }
340 
341     function transfer(address _to, uint256 _value) onlyWhenUnlocked validDestination(_to) returns (bool)
342     {
343         return super.transfer(_to, _value);
344     }
345 
346     function transferFrom(address _from, address _to, uint256 _value) onlyWhenUnlocked validDestination(_to) returns (bool)
347     {
348         require(getTime() >= getLockFundsReleaseTime(_from));
349         return super.transferFrom(_from, _to, _value);
350     }
351 
352     function getLockFundsReleaseTime(address _addr) public view returns(uint) 
353     {
354         return approvedInvestorListWithDate[_addr];
355     }
356 
357     function setLockFunds(address[] newInvestorList, uint releaseTime) onlyOwner public 
358     {
359         require(releaseTime > getTime());
360         for (uint i = 0; i < newInvestorList.length; i++)
361         {
362             approvedInvestorListWithDate[newInvestorList[i]] = releaseTime;
363         }
364     }
365 
366     function removeLockFunds(address[] investorList) onlyOwner public 
367     {
368         for (uint i = 0; i < investorList.length; i++)
369         {
370             approvedInvestorListWithDate[investorList[i]] = 0;
371             delete(approvedInvestorListWithDate[investorList[i]]);
372         }
373     }
374 
375     function setLockFund(address newInvestor, uint releaseTime) onlyOwner public 
376     {
377         require(releaseTime > getTime());
378         approvedInvestorListWithDate[newInvestor] = releaseTime;
379     }
380 
381 
382     function removeLockFund(address investor) onlyOwner public 
383     {
384         approvedInvestorListWithDate[investor] = 0;
385         delete(approvedInvestorListWithDate[investor]);
386     }
387 
388 
389     event Burn(address indexed _burner, uint256 _value);
390 
391     function burn(uint256 _value) onlyOwner public returns (bool)
392     {
393         balances[msg.sender] = balances[msg.sender].sub(_value);
394         totalSupply = totalSupply.sub(_value);
395         Burn(msg.sender, _value);
396         Transfer(msg.sender, address(0x0), _value);
397         return true;
398     }
399 
400     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool)
401     {
402         assert( transferFrom( _from, msg.sender, _value ) );
403         return burn(_value);
404     }
405 
406     function emergencyERC20Drain( ERC20 token, uint256 amount ) onlyOwner {
407         token.transfer( owner, amount );
408     }
409 
410     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
411 
412     function changeAdmin(address newAdmin) onlyOwner {
413         AdminTransferred(admin, newAdmin);
414         admin = newAdmin;
415     }
416 
417     function () public payable 
418     {
419         revert();
420     }
421 }