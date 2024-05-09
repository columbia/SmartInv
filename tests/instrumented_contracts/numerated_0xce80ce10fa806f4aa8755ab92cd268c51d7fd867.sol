1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 // File: contracts/zeppelin/math/SafeMath.sol
17 
18 pragma solidity ^0.4.18;
19 
20 library SafeMath {
21   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22     if (a == 0) {
23       return 0;
24     }
25     uint256 c = a * b;
26     assert(c / a == b);
27     return c;
28   }
29 
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a / b;
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 // File: contracts/zeppelin/token/BasicToken.sol
48 
49 pragma solidity ^0.4.18;
50 
51 
52 
53 
54 /**
55  * @title Basic token
56  * @dev Basic version of StandardToken, with no allowances.
57  */
58 contract BasicToken is ERC20Basic {
59   using SafeMath for uint256;
60 
61   mapping(address => uint256) balances;
62 
63   /**
64   * @dev transfer token for a specified address
65   * @param _to The address to transfer to.
66   * @param _value The amount to be transferred.
67   */
68   function transfer(address _to, uint256 _value) public returns (bool) {
69     require(_to != address(0));
70     require(_value <= balances[msg.sender]);
71 
72     // SafeMath.sub will throw if there is not enough balance.
73     balances[msg.sender] = balances[msg.sender].sub(_value);
74     balances[_to] = balances[_to].add(_value);
75     Transfer(msg.sender, _to, _value);
76     return true;
77   }
78 
79   /**
80   * @dev Gets the balance of the specified address.
81   * @param _owner The address to query the the balance of.
82   * @return An uint256 representing the amount owned by the passed address.
83   */
84   function balanceOf(address _owner) public view returns (uint256 balance) {
85     return balances[_owner];
86   }
87 
88 }
89 
90 // File: contracts/zeppelin/token/ERC20.sol
91 
92 pragma solidity ^0.4.18;
93 
94 
95 
96 /**
97  * @title ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/20
99  */
100 contract ERC20 is ERC20Basic {
101   function allowance(address owner, address spender) public view returns (uint256);
102   function transferFrom(address from, address to, uint256 value) public returns (bool);
103   function approve(address spender, uint256 value) public returns (bool);
104   event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 // File: contracts/zeppelin/token/StandardToken.sol
108 
109 pragma solidity ^0.4.18;
110 
111 
112 
113 
114 /**
115  * @title Standard ERC20 token
116  *
117  * @dev Implementation of the basic standard token.
118  * @dev https://github.com/ethereum/EIPs/issues/20
119  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
120  */
121 contract StandardToken is ERC20, BasicToken {
122   mapping (address => mapping (address => uint256)) internal allowed;
123 
124   /**
125    * @dev Transfer tokens from one address to another
126    * @param _from address The address which you want to send tokens from
127    * @param _to address The address which you want to transfer to
128    * @param _value uint256 the amount of tokens to be transferred
129    */
130   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
131     require(_to != address(0));
132     require(_value <= balances[_from]);
133     require(_value <= allowed[_from][msg.sender]);
134 
135     balances[_from] = balances[_from].sub(_value);
136     balances[_to] = balances[_to].add(_value);
137     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
138     Transfer(_from, _to, _value);
139     return true;
140   }
141 
142   /**
143    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
144    *
145    * Beware that changing an allowance with this method brings the risk that someone may use both the old
146    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
147    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
148    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
149    * @param _spender The address which will spend the funds.
150    * @param _value The amount of tokens to be spent.
151    */
152   function approve(address _spender, uint256 _value) public returns (bool) {
153     allowed[msg.sender][_spender] = _value;
154     Approval(msg.sender, _spender, _value);
155     return true;
156   }
157 
158   /**
159    * @dev Function to check the amount of tokens that an owner allowed to a spender.
160    * @param _owner address The address which owns the funds.
161    * @param _spender address The address which will spend the funds.
162    * @return A uint256 specifying the amount of tokens still available for the spender.
163    */
164   function allowance(address _owner, address _spender) public view returns (uint256) {
165     return allowed[_owner][_spender];
166   }
167 
168   /**
169    * approve should be called when allowed[_spender] == 0. To increment
170    * allowed value is better to use this function to avoid 2 calls (and wait until
171    * the first transaction is mined)
172    * From MonolithDAO Token.sol
173    */
174   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
175     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
176     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177     return true;
178   }
179 
180   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
181     uint oldValue = allowed[msg.sender][_spender];
182     if (_subtractedValue > oldValue) {
183       allowed[msg.sender][_spender] = 0;
184     } else {
185       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
186     }
187     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188     return true;
189   }
190 
191 }
192 
193 // File: contracts/zeppelin/ownership/Ownable.sol
194 
195 pragma solidity ^0.4.18;
196 
197 
198 contract Ownable {
199   address public owner;
200 
201 
202   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
203 
204 
205   function Ownable() public {
206     owner = msg.sender;
207   }
208 
209 
210 
211   modifier onlyOwner() {
212     require(msg.sender == owner);
213     _;
214   }
215 
216 
217   function transferOwnership(address newOwner) public onlyOwner {
218     require(newOwner != address(0));
219     OwnershipTransferred(owner, newOwner);
220     owner = newOwner;
221   }
222 
223 }
224 
225 // File: contracts/zeppelin/lifecycle/Pausable.sol
226 
227 pragma solidity ^0.4.18;
228 
229 
230 contract Pausable is Ownable {
231   event PausePublic(bool newState);
232   event PauseOwnerAdmin(bool newState);
233 
234   bool public pausedPublic = true;
235   bool public pausedOwnerAdmin = false;
236 
237   address public admin;
238 
239   modifier whenNotPaused() {
240     if(pausedPublic) {
241       if(!pausedOwnerAdmin) {
242         require(msg.sender == admin || msg.sender == owner);
243       } else {
244         revert();
245       }
246     }
247     _;
248   }
249 
250   function pause(bool newPausedPublic, bool newPausedOwnerAdmin) onlyOwner public {
251     require(!(newPausedPublic == false && newPausedOwnerAdmin == true));
252 
253     pausedPublic = newPausedPublic;
254     pausedOwnerAdmin = newPausedOwnerAdmin;
255 
256     PausePublic(newPausedPublic);
257     PauseOwnerAdmin(newPausedOwnerAdmin);
258   }
259 }
260 
261 // File: contracts/zeppelin/token/PausableToken.sol
262 
263 pragma solidity ^0.4.18;
264 
265 
266 
267 /**
268  * @title Pausable token
269  *
270  * @dev StandardToken modified with pausable transfers.
271  **/
272 
273 contract PausableToken is StandardToken, Pausable {
274 
275   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
276     return super.transfer(_to, _value);
277   }
278 
279   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
280     return super.transferFrom(_from, _to, _value);
281   }
282 
283   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
284     return super.approve(_spender, _value);
285   }
286 
287   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
288     return super.increaseApproval(_spender, _addedValue);
289   }
290 
291   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
292     return super.decreaseApproval(_spender, _subtractedValue);
293   }
294 }
295 
296 // File: contracts/IdallToken.sol
297 
298 pragma solidity ^0.4.18;
299 
300 
301 contract IdallToken is PausableToken {
302 
303     string  public  constant name = "Idall";
304     string  public  constant symbol = "IDALL";
305     uint8   public  constant decimals = 5;
306 
307     mapping(address => uint) approvedInvestorListWithDate;
308 
309     function IdallToken( address _admin, uint256 _totalTokenAmount )
310     {
311         admin = _admin;
312 
313         totalSupply = _totalTokenAmount;
314         balances[msg.sender] = _totalTokenAmount;
315         Transfer(address(0x0), msg.sender, _totalTokenAmount);
316     }
317 
318     function getTime() public constant returns (uint) {
319         return now;
320     }
321 
322     function isUnlocked() internal view returns (bool) {
323         return getTime() >= getLockFundsReleaseTime(msg.sender);
324     }
325 
326     modifier validDestination( address to )
327     {
328         require(to != address(0x0));
329         require(to != address(this));
330         _;
331     }
332 
333     modifier onlyWhenUnlocked()
334     {
335         require(isUnlocked());            
336         _;
337     }
338 
339     function transfer(address _to, uint256 _value) onlyWhenUnlocked validDestination(_to) returns (bool)
340     {
341         return super.transfer(_to, _value);
342     }
343 
344     function transferFrom(address _from, address _to, uint256 _value) onlyWhenUnlocked validDestination(_to) returns (bool)
345     {
346         require(getTime() >= getLockFundsReleaseTime(_from));
347         return super.transferFrom(_from, _to, _value);
348     }
349 
350     function getLockFundsReleaseTime(address _addr) public view returns(uint) 
351     {
352         return approvedInvestorListWithDate[_addr];
353     }
354 
355     function setLockFunds(address[] newInvestorList, uint releaseTime) onlyOwner public 
356     {
357         require(releaseTime > getTime());
358         for (uint i = 0; i < newInvestorList.length; i++)
359         {
360             approvedInvestorListWithDate[newInvestorList[i]] = releaseTime;
361         }
362     }
363 
364     function removeLockFunds(address[] investorList) onlyOwner public 
365     {
366         for (uint i = 0; i < investorList.length; i++)
367         {
368             approvedInvestorListWithDate[investorList[i]] = 0;
369             delete(approvedInvestorListWithDate[investorList[i]]);
370         }
371     }
372 
373     function setLockFund(address newInvestor, uint releaseTime) onlyOwner public 
374     {
375         require(releaseTime > getTime());
376         approvedInvestorListWithDate[newInvestor] = releaseTime;
377     }
378 
379 
380     function removeLockFund(address investor) onlyOwner public 
381     {
382         approvedInvestorListWithDate[investor] = 0;
383         delete(approvedInvestorListWithDate[investor]);
384     }
385 
386 
387     event Burn(address indexed _burner, uint256 _value);
388 
389     function burn(uint256 _value) onlyOwner public returns (bool)
390     {
391         balances[msg.sender] = balances[msg.sender].sub(_value);
392         totalSupply = totalSupply.sub(_value);
393         Burn(msg.sender, _value);
394         Transfer(msg.sender, address(0x0), _value);
395         return true;
396     }
397 
398     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool)
399     {
400         assert( transferFrom( _from, msg.sender, _value ) );
401         return burn(_value);
402     }
403 
404     function emergencyERC20Drain( ERC20 token, uint256 amount ) onlyOwner {
405         token.transfer( owner, amount );
406     }
407 
408     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
409 
410     function changeAdmin(address newAdmin) onlyOwner {
411         AdminTransferred(admin, newAdmin);
412         admin = newAdmin;
413     }
414 
415     function () public payable 
416     {
417         revert();
418     }
419 }