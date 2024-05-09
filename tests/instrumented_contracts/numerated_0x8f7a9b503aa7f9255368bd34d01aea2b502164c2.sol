1 pragma solidity ^0.4.18;
2 
3 // File: contracts/zeppelin/ownership/Ownable.sol
4 
5 contract Ownable {
6   address public owner;
7 
8 
9   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
10 
11 
12   function Ownable() public {
13     owner = msg.sender;
14   }
15 
16 
17 
18   modifier onlyOwner() {
19     require(msg.sender == owner);
20     _;
21   }
22 
23 
24   function transferOwnership(address newOwner) public onlyOwner {
25     require(newOwner != address(0));
26     OwnershipTransferred(owner, newOwner);
27     owner = newOwner;
28   }
29 
30 }
31 
32 // File: contracts/zeppelin/lifecycle/Pausable.sol
33 
34 // custom Pausable implementation for Bryllite
35 
36 
37 contract Pausable is Ownable {
38   event PausePublic(bool newState);
39   event PauseOwnerAdmin(bool newState);
40 
41   bool public pausedPublic = true;
42   bool public pausedOwnerAdmin = false;
43 
44   address public admin;
45 
46   modifier whenNotPaused() {
47     if(pausedPublic) {
48       if(!pausedOwnerAdmin) {
49         require(msg.sender == admin || msg.sender == owner);
50       } else {
51         revert();
52       }
53     }
54     _;
55   }
56 
57   function pause(bool newPausedPublic, bool newPausedOwnerAdmin) onlyOwner public {
58     require(!(newPausedPublic == false && newPausedOwnerAdmin == true));
59 
60     pausedPublic = newPausedPublic;
61     pausedOwnerAdmin = newPausedOwnerAdmin;
62 
63     PausePublic(newPausedPublic);
64     PauseOwnerAdmin(newPausedOwnerAdmin);
65   }
66 }
67 
68 // File: contracts/zeppelin/math/SafeMath.sol
69 
70 library SafeMath {
71   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72     if (a == 0) {
73       return 0;
74     }
75     uint256 c = a * b;
76     assert(c / a == b);
77     return c;
78   }
79 
80   function div(uint256 a, uint256 b) internal pure returns (uint256) {
81     uint256 c = a / b;
82     return c;
83   }
84 
85   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86     assert(b <= a);
87     return a - b;
88   }
89 
90   function add(uint256 a, uint256 b) internal pure returns (uint256) {
91     uint256 c = a + b;
92     assert(c >= a);
93     return c;
94   }
95 }
96 
97 // File: contracts/zeppelin/token/ERC20Basic.sol
98 
99 /**
100  * @title ERC20Basic
101  * @dev Simpler version of ERC20 interface
102  * @dev see https://github.com/ethereum/EIPs/issues/179
103  */
104 contract ERC20Basic {
105   uint256 public totalSupply;
106   function balanceOf(address who) public view returns (uint256);
107   function transfer(address to, uint256 value) public returns (bool);
108   event Transfer(address indexed from, address indexed to, uint256 value);
109 }
110 
111 // File: contracts/zeppelin/token/BasicToken.sol
112 
113 /**
114  * @title Basic token
115  * @dev Basic version of StandardToken, with no allowances.
116  */
117 contract BasicToken is ERC20Basic {
118   using SafeMath for uint256;
119 
120   mapping(address => uint256) balances;
121 
122   /**
123   * @dev transfer token for a specified address
124   * @param _to The address to transfer to.
125   * @param _value The amount to be transferred.
126   */
127   function transfer(address _to, uint256 _value) public returns (bool) {
128     require(_to != address(0));
129     require(_value <= balances[msg.sender]);
130 
131     // SafeMath.sub will throw if there is not enough balance.
132     balances[msg.sender] = balances[msg.sender].sub(_value);
133     balances[_to] = balances[_to].add(_value);
134     Transfer(msg.sender, _to, _value);
135     return true;
136   }
137 
138   /**
139   * @dev Gets the balance of the specified address.
140   * @param _owner The address to query the the balance of.
141   * @return An uint256 representing the amount owned by the passed address.
142   */
143   function balanceOf(address _owner) public view returns (uint256 balance) {
144     return balances[_owner];
145   }
146 
147 }
148 
149 // File: contracts/zeppelin/token/ERC20.sol
150 
151 /**
152  * @title ERC20 interface
153  * @dev see https://github.com/ethereum/EIPs/issues/20
154  */
155 contract ERC20 is ERC20Basic {
156   function allowance(address owner, address spender) public view returns (uint256);
157   function transferFrom(address from, address to, uint256 value) public returns (bool);
158   function approve(address spender, uint256 value) public returns (bool);
159   event Approval(address indexed owner, address indexed spender, uint256 value);
160 }
161 
162 // File: contracts/zeppelin/token/StandardToken.sol
163 
164 /**
165  * @title Standard ERC20 token
166  *
167  * @dev Implementation of the basic standard token.
168  * @dev https://github.com/ethereum/EIPs/issues/20
169  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
170  */
171 contract StandardToken is ERC20, BasicToken {
172   mapping (address => mapping (address => uint256)) internal allowed;
173 
174   /**
175    * @dev Transfer tokens from one address to another
176    * @param _from address The address which you want to send tokens from
177    * @param _to address The address which you want to transfer to
178    * @param _value uint256 the amount of tokens to be transferred
179    */
180   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
181     require(_to != address(0));
182     require(_value <= balances[_from]);
183     require(_value <= allowed[_from][msg.sender]);
184 
185     balances[_from] = balances[_from].sub(_value);
186     balances[_to] = balances[_to].add(_value);
187     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
188     Transfer(_from, _to, _value);
189     return true;
190   }
191 
192   /**
193    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
194    *
195    * Beware that changing an allowance with this method brings the risk that someone may use both the old
196    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
197    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
198    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199    * @param _spender The address which will spend the funds.
200    * @param _value The amount of tokens to be spent.
201    */
202   function approve(address _spender, uint256 _value) public returns (bool) {
203     allowed[msg.sender][_spender] = _value;
204     Approval(msg.sender, _spender, _value);
205     return true;
206   }
207 
208   /**
209    * @dev Function to check the amount of tokens that an owner allowed to a spender.
210    * @param _owner address The address which owns the funds.
211    * @param _spender address The address which will spend the funds.
212    * @return A uint256 specifying the amount of tokens still available for the spender.
213    */
214   function allowance(address _owner, address _spender) public view returns (uint256) {
215     return allowed[_owner][_spender];
216   }
217 
218   /**
219    * approve should be called when allowed[_spender] == 0. To increment
220    * allowed value is better to use this function to avoid 2 calls (and wait until
221    * the first transaction is mined)
222    * From MonolithDAO Token.sol
223    */
224   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
225     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
226     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
227     return true;
228   }
229 
230   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
231     uint oldValue = allowed[msg.sender][_spender];
232     if (_subtractedValue > oldValue) {
233       allowed[msg.sender][_spender] = 0;
234     } else {
235       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
236     }
237     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238     return true;
239   }
240 
241 }
242 
243 // File: contracts/zeppelin/token/PausableToken.sol
244 
245 /**
246  * @title Pausable token
247  *
248  * @dev StandardToken modified with pausable transfers.
249  **/
250 
251 contract PausableToken is StandardToken, Pausable {
252 
253   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
254     return super.transfer(_to, _value);
255   }
256 
257   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
258     return super.transferFrom(_from, _to, _value);
259   }
260 
261   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
262     return super.approve(_spender, _value);
263   }
264 
265   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
266     return super.increaseApproval(_spender, _addedValue);
267   }
268 
269   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
270     return super.decreaseApproval(_spender, _subtractedValue);
271   }
272 }
273 
274 // File: contracts/BrylliteToken.sol
275 
276 contract BrylliteToken is PausableToken {
277 
278     string  public  constant name = "Bryllite";
279     string  public  constant symbol = "BRC";
280     uint8   public  constant decimals = 18;
281 
282 
283 
284      // new feature, Lee
285     mapping(address => uint) approvedInvestorListWithDate;
286 
287     function BrylliteToken( address _admin, uint _totalTokenAmount ) 
288     {
289         admin = _admin;
290 
291         totalSupply = _totalTokenAmount;
292         balances[msg.sender] = _totalTokenAmount;
293         Transfer(address(0x0), msg.sender, _totalTokenAmount);
294     }
295 
296     function getTime() public constant returns (uint) {
297         return now;
298     }
299 
300 
301     function isUnlocked() internal view returns (bool) {
302         return getTime() >= getLockFundsReleaseTime(msg.sender);
303     }
304 
305     modifier validDestination( address to )
306     {
307         require(to != address(0x0));
308         require(to != address(this));
309         _;
310     }
311 
312     modifier onlyWhenUnlocked()
313     {
314         require(isUnlocked());            
315         _;
316     }
317 
318     function transfer(address _to, uint _value) onlyWhenUnlocked validDestination(_to) returns (bool) 
319     {
320         return super.transfer(_to, _value);
321     }
322 
323     function transferFrom(address _from, address _to, uint _value) onlyWhenUnlocked validDestination(_to) returns (bool) 
324     {
325         require(getTime() >= getLockFundsReleaseTime(_from));
326         return super.transferFrom(_from, _to, _value);
327     }
328 
329     function getLockFundsReleaseTime(address _addr) public view returns(uint) 
330     {
331         return approvedInvestorListWithDate[_addr];
332     }
333 
334     function setLockFunds(address[] newInvestorList, uint releaseTime) onlyOwner public 
335     {
336         require(releaseTime > getTime());
337         for (uint i = 0; i < newInvestorList.length; i++)
338         {
339             approvedInvestorListWithDate[newInvestorList[i]] = releaseTime;
340         }
341     }
342 
343     function removeLockFunds(address[] investorList) onlyOwner public 
344     {
345         for (uint i = 0; i < investorList.length; i++)
346         {
347             approvedInvestorListWithDate[investorList[i]] = 0;
348             delete(approvedInvestorListWithDate[investorList[i]]);
349         }
350     }
351 
352     function setLockFund(address newInvestor, uint releaseTime) onlyOwner public 
353     {
354         require(releaseTime > getTime());
355         approvedInvestorListWithDate[newInvestor] = releaseTime;
356     }
357 
358 
359     function removeLockFund(address investor) onlyOwner public 
360     {
361         approvedInvestorListWithDate[investor] = 0;
362         delete(approvedInvestorListWithDate[investor]);
363     }
364 
365     event Burn(address indexed _burner, uint _value);
366     function burn(uint _value) returns (bool)
367     {
368         balances[msg.sender] = balances[msg.sender].sub(_value);
369         totalSupply = totalSupply.sub(_value);
370         Burn(msg.sender, _value);
371         Transfer(msg.sender, address(0x0), _value);
372         return true;
373     }
374 
375     function burnFrom(address _from, uint256 _value) returns (bool) 
376     {
377         assert( transferFrom( _from, msg.sender, _value ) );
378         return burn(_value);
379     }
380 
381     function emergencyERC20Drain( ERC20 token, uint amount ) onlyOwner {
382         token.transfer( owner, amount );
383     }
384 
385     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
386 
387     function changeAdmin(address newAdmin) onlyOwner {
388         AdminTransferred(admin, newAdmin);
389         admin = newAdmin;
390     }
391 
392     function () public payable 
393     {
394         revert();
395     }
396 }