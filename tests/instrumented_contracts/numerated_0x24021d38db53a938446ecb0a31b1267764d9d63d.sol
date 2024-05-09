1 pragma solidity ^0.4.19;
2 
3 
4 
5 contract ERC20Basic {
6   function totalSupply() public view returns (uint256);
7   function balanceOf(address who) public view returns (uint256);
8   function transfer(address to, uint256 value) public returns (bool);
9   event Transfer(address indexed from, address indexed to, uint256 value);
10 }
11 
12 contract ERC20 is ERC20Basic {
13   function allowance(address owner, address spender) public view returns (uint256);
14   function transferFrom(address from, address to, uint256 value) public returns (bool);
15   function approve(address spender, uint256 value) public returns (bool);
16   event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 contract BasicToken is ERC20Basic {
20   using SafeMath for uint256;
21 
22   mapping(address => uint256) balances;
23 
24   uint256 totalSupply_;
25 
26   /**
27   * @dev total number of tokens in existence
28   */
29   function totalSupply() public view returns (uint256) {
30     return totalSupply_;
31   }
32 
33   /**
34   * @dev transfer token for a specified address
35   * @param _to The address to transfer to.
36   * @param _value The amount to be transferred.
37   */
38   function transfer(address _to, uint256 _value) public returns (bool) {
39     require(_to != address(0));
40     require(_value <= balances[msg.sender]);
41 
42     // SafeMath.sub will throw if there is not enough balance.
43     balances[msg.sender] = balances[msg.sender].sub(_value);
44     balances[_to] = balances[_to].add(_value);
45     Transfer(msg.sender, _to, _value);
46     return true;
47   }
48 
49   /**
50   * @dev Gets the balance of the specified address.
51   * @param _owner The address to query the the balance of.
52   * @return An uint256 representing the amount owned by the passed address.
53   */
54   function balanceOf(address _owner) public view returns (uint256 balance) {
55     return balances[_owner];
56   }
57 
58 }
59 
60 contract StandardToken is ERC20, BasicToken {
61 
62   mapping (address => mapping (address => uint256)) internal allowed;
63 
64 
65   /**
66    * @dev Transfer tokens from one address to another
67    * @param _from address The address which you want to send tokens from
68    * @param _to address The address which you want to transfer to
69    * @param _value uint256 the amount of tokens to be transferred
70    */
71   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
72     require(_to != address(0));
73     require(_value <= balances[_from]);
74     require(_value <= allowed[_from][msg.sender]);
75 
76     balances[_from] = balances[_from].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
79     Transfer(_from, _to, _value);
80     return true;
81   }
82 
83   /**
84    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
85    *
86    * Beware that changing an allowance with this method brings the risk that someone may use both the old
87    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
88    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
89    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
90    * @param _spender The address which will spend the funds.
91    * @param _value The amount of tokens to be spent.
92    */
93   function approve(address _spender, uint256 _value) public returns (bool) {
94     allowed[msg.sender][_spender] = _value;
95     Approval(msg.sender, _spender, _value);
96     return true;
97   }
98 
99   /**
100    * @dev Function to check the amount of tokens that an owner allowed to a spender.
101    * @param _owner address The address which owns the funds.
102    * @param _spender address The address which will spend the funds.
103    * @return A uint256 specifying the amount of tokens still available for the spender.
104    */
105   function allowance(address _owner, address _spender) public view returns (uint256) {
106     return allowed[_owner][_spender];
107   }
108 
109   /**
110    * @dev Increase the amount of tokens that an owner allowed to a spender.
111    *
112    * approve should be called when allowed[_spender] == 0. To increment
113    * allowed value is better to use this function to avoid 2 calls (and wait until
114    * the first transaction is mined)
115    * From MonolithDAO Token.sol
116    * @param _spender The address which will spend the funds.
117    * @param _addedValue The amount of tokens to increase the allowance by.
118    */
119   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
120     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
121     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
122     return true;
123   }
124 
125   /**
126    * @dev Decrease the amount of tokens that an owner allowed to a spender.
127    *
128    * approve should be called when allowed[_spender] == 0. To decrement
129    * allowed value is better to use this function to avoid 2 calls (and wait until
130    * the first transaction is mined)
131    * From MonolithDAO Token.sol
132    * @param _spender The address which will spend the funds.
133    * @param _subtractedValue The amount of tokens to decrease the allowance by.
134    */
135   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
136     uint oldValue = allowed[msg.sender][_spender];
137     if (_subtractedValue > oldValue) {
138       allowed[msg.sender][_spender] = 0;
139     } else {
140       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
141     }
142     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
143     return true;
144   }
145 
146 }
147 
148 contract Ownable {
149   address public owner;
150 
151 
152   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
153 
154 
155   /**
156    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
157    * account.
158    */
159   function Ownable() public {
160     owner = msg.sender;
161   }
162 
163   /**
164    * @dev Throws if called by any account other than the owner.
165    */
166   modifier onlyOwner() {
167     require(msg.sender == owner);
168     _;
169   }
170 
171   /**
172    * @dev Allows the current owner to transfer control of the contract to a newOwner.
173    * @param newOwner The address to transfer ownership to.
174    */
175   function transferOwnership(address newOwner) public onlyOwner {
176     require(newOwner != address(0));
177     OwnershipTransferred(owner, newOwner);
178     owner = newOwner;
179   }
180 
181 }
182 
183 library SafeMath {
184   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185     if (a == 0) {
186       return 0;
187     }
188     uint256 c = a * b;
189     assert(c / a == b);
190     return c;
191   }
192 
193   function div(uint256 a, uint256 b) internal pure returns (uint256) {
194     // assert(b > 0); // Solidity automatically throws when dividing by 0
195     uint256 c = a / b;
196     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
197     return c;
198   }
199 
200   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
201     assert(b <= a);
202     return a - b;
203   }
204 
205   function add(uint256 a, uint256 b) internal pure returns (uint256) {
206     uint256 c = a + b;
207     assert(c >= a);
208     return c;
209   }
210 }
211 
212 
213 contract HODLIT is StandardToken, Ownable {
214   using SafeMath for uint256;
215   string public name = "HODL INCENTIVE TOKEN";
216   string public symbol = "HIT";
217   uint256 public decimals = 18;
218   uint256 public multiplicator = 10 ** decimals;
219   uint256 public totalSupply;
220   uint256 public ICDSupply;
221 
222   uint256 public registeredUsers;
223   uint256 public claimedUsers;
224   uint256 public maxReferrals = 20;
225 
226   uint256 public hardCap = SafeMath.mul(100000000, multiplicator);
227   uint256 public ICDCap = SafeMath.mul(20000000, multiplicator);
228 
229   mapping (address => uint256) public etherBalances;
230   mapping (address => bool) public ICDClaims;
231   mapping (address => uint256) public referrals;
232   mapping (address => bool) public bonusReceived;
233 
234 
235   uint256 public regStartTime = 1519848000; // 28 feb 2018 20:00 GMT
236   uint256 public regStopTime = regStartTime + 7 days;
237   uint256 public POHStartTime = regStopTime;
238   uint256 public POHStopTime = POHStartTime + 7 days;
239   uint256 public ICDStartTime = POHStopTime;
240   uint256 public ICDStopTime = ICDStartTime + 7 days;
241   uint256 public PCDStartTime = ICDStopTime + 14 days;
242 
243   address public ERC721Address;
244 
245   modifier forRegistration {
246     require(block.timestamp >= regStartTime && block.timestamp < regStopTime);
247     _;
248   }
249 
250   modifier forICD {
251     require(block.timestamp >= ICDStartTime && block.timestamp < ICDStopTime);
252     _;
253   }
254 
255   modifier forERC721 {
256     require(msg.sender == ERC721Address && block.timestamp >= PCDStartTime);
257     _;
258   }
259 
260   function HODLIT() public {
261     uint256 reserve = SafeMath.mul(30000000, multiplicator);
262     owner = msg.sender;
263     totalSupply = totalSupply.add(reserve);
264     balances[owner] = balances[owner].add(reserve);
265     Transfer(address(0), owner, reserve);
266   }
267 
268   function() external payable {
269     revert();
270   }
271 
272   function setERC721Address(address _ERC721Address) external onlyOwner {
273     ERC721Address = _ERC721Address;
274   }
275 
276   function setMaxReferrals(uint256 _maxReferrals) external onlyOwner {
277     maxReferrals = _maxReferrals;
278   }
279 
280   function registerEtherBalance(address _referral) external forRegistration {
281     require(
282       msg.sender.balance > 0.2 ether &&
283       etherBalances[msg.sender] == 0 &&
284       _referral != msg.sender
285     );
286     if (_referral != address(0) && referrals[_referral] < maxReferrals) {
287       referrals[_referral]++;
288     }
289     registeredUsers++;
290     etherBalances[msg.sender] = msg.sender.balance;
291   }
292 
293   function claimTokens() external forICD {
294     require(ICDClaims[msg.sender] == false);
295     require(etherBalances[msg.sender] > 0);
296     require(etherBalances[msg.sender] <= msg.sender.balance + 50 finney);
297     ICDClaims[msg.sender] = true;
298     claimedUsers++;
299     require(mintICD(msg.sender, computeReward(etherBalances[msg.sender])));
300   }
301 
302   function declareCheater(address _cheater) external onlyOwner {
303     require(_cheater != address(0));
304     ICDClaims[_cheater] = false;
305     etherBalances[_cheater] = 0;
306   }
307 
308   function declareCheaters(address[] _cheaters) external onlyOwner {
309     for (uint256 i = 0; i < _cheaters.length; i++) {
310       require(_cheaters[i] != address(0));
311       ICDClaims[_cheaters[i]] = false;
312       etherBalances[_cheaters[i]] = 0;
313     }
314   }
315 
316   function mintPCD(address _to, uint256 _amount) external forERC721 returns(bool) {
317     require(_to != address(0));
318     require(_amount + totalSupply <= hardCap);
319     totalSupply = totalSupply.add(_amount);
320     balances[_to] = balances[_to].add(_amount);
321     etherBalances[_to] = _to.balance;
322     Transfer(address(0), _to, _amount);
323     return true;
324   }
325 
326   function claimTwitterBonus() external forICD {
327     require(balances[msg.sender] > 0 && !bonusReceived[msg.sender]);
328     bonusReceived[msg.sender] = true;
329     mintICD(msg.sender, multiplicator.mul(20));
330   }
331 
332   function claimReferralBonus() external forICD {
333     require(referrals[msg.sender] > 0 && balances[msg.sender] > 0);
334     uint256 cache = referrals[msg.sender];
335     referrals[msg.sender] = 0;
336     mintICD(msg.sender, SafeMath.mul(cache * 20, multiplicator));
337   }
338 
339   function computeReward(uint256 _amount) internal view returns(uint256) {
340     if (_amount < 1 ether) return SafeMath.mul(20, multiplicator);
341     if (_amount < 2 ether) return SafeMath.mul(100, multiplicator);
342     if (_amount < 3 ether) return SafeMath.mul(240, multiplicator);
343     if (_amount < 4 ether) return SafeMath.mul(430, multiplicator);
344     if (_amount < 5 ether) return SafeMath.mul(680, multiplicator);
345     if (_amount < 6 ether) return SafeMath.mul(950, multiplicator);
346     if (_amount < 7 ether) return SafeMath.mul(1260, multiplicator);
347     if (_amount < 8 ether) return SafeMath.mul(1580, multiplicator);
348     if (_amount < 9 ether) return SafeMath.mul(1900, multiplicator);
349     if (_amount < 10 ether) return SafeMath.mul(2240, multiplicator);
350     if (_amount < 11 ether) return SafeMath.mul(2560, multiplicator);
351     if (_amount < 12 ether) return SafeMath.mul(2890, multiplicator);
352     if (_amount < 13 ether) return SafeMath.mul(3210, multiplicator);
353     if (_amount < 14 ether) return SafeMath.mul(3520, multiplicator);
354     if (_amount < 15 ether) return SafeMath.mul(3830, multiplicator);
355     if (_amount < 16 ether) return SafeMath.mul(4120, multiplicator);
356     if (_amount < 17 ether) return SafeMath.mul(4410, multiplicator);
357     if (_amount < 18 ether) return SafeMath.mul(4680, multiplicator);
358     if (_amount < 19 ether) return SafeMath.mul(4950, multiplicator);
359     if (_amount < 20 ether) return SafeMath.mul(5210, multiplicator);
360     if (_amount < 21 ether) return SafeMath.mul(5460, multiplicator);
361     if (_amount < 22 ether) return SafeMath.mul(5700, multiplicator);
362     if (_amount < 23 ether) return SafeMath.mul(5930, multiplicator);
363     if (_amount < 24 ether) return SafeMath.mul(6150, multiplicator);
364     if (_amount < 25 ether) return SafeMath.mul(6360, multiplicator);
365     if (_amount < 26 ether) return SafeMath.mul(6570, multiplicator);
366     if (_amount < 27 ether) return SafeMath.mul(6770, multiplicator);
367     if (_amount < 28 ether) return SafeMath.mul(6960, multiplicator);
368     if (_amount < 29 ether) return SafeMath.mul(7140, multiplicator);
369     if (_amount < 30 ether) return SafeMath.mul(7320, multiplicator);
370     if (_amount < 31 ether) return SafeMath.mul(7500, multiplicator);
371     if (_amount < 32 ether) return SafeMath.mul(7660, multiplicator);
372     if (_amount < 33 ether) return SafeMath.mul(7820, multiplicator);
373     if (_amount < 34 ether) return SafeMath.mul(7980, multiplicator);
374     if (_amount < 35 ether) return SafeMath.mul(8130, multiplicator);
375     if (_amount < 36 ether) return SafeMath.mul(8270, multiplicator);
376     if (_amount < 37 ether) return SafeMath.mul(8410, multiplicator);
377     if (_amount < 38 ether) return SafeMath.mul(8550, multiplicator);
378     if (_amount < 39 ether) return SafeMath.mul(8680, multiplicator);
379     if (_amount < 40 ether) return SafeMath.mul(8810, multiplicator);
380     if (_amount < 41 ether) return SafeMath.mul(8930, multiplicator);
381     if (_amount < 42 ether) return SafeMath.mul(9050, multiplicator);
382     if (_amount < 43 ether) return SafeMath.mul(9170, multiplicator);
383     if (_amount < 44 ether) return SafeMath.mul(9280, multiplicator);
384     if (_amount < 45 ether) return SafeMath.mul(9390, multiplicator);
385     if (_amount < 46 ether) return SafeMath.mul(9500, multiplicator);
386     if (_amount < 47 ether) return SafeMath.mul(9600, multiplicator);
387     if (_amount < 48 ether) return SafeMath.mul(9700, multiplicator);
388     if (_amount < 49 ether) return SafeMath.mul(9800, multiplicator);
389     if (_amount < 50 ether) return SafeMath.mul(9890, multiplicator);
390     return SafeMath.mul(10000, multiplicator);
391   }
392 
393   function mintICD(address _to, uint256 _amount) internal returns(bool) {
394     require(_to != address(0));
395     require(_amount + ICDSupply <= ICDCap);
396     totalSupply = totalSupply.add(_amount);
397     ICDSupply = ICDSupply.add(_amount);
398     balances[_to] = balances[_to].add(_amount);
399     etherBalances[_to] = _to.balance;
400     Transfer(address(0), _to, _amount);
401     return true;
402   }
403 }