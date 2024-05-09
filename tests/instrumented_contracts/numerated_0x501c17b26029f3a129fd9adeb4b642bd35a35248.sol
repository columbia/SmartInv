1 pragma solidity ^0.4.18;
2 
3 /** SafeMath libs are inspired by:
4   *  https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
5   * There is debate as to whether this lib should use assert or require:
6   *  https://github.com/OpenZeppelin/zeppelin-solidity/issues/565
7 
8   * `require` is used in these libraries for the following reasons:
9   *   - overflows should not be checked in contract function bodies; DRY
10   *   - "valid" user input can cause overflows, which should not assert()
11   */
12 library SafeMath {
13   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14     require(b <= a);
15     return a - b;
16   }
17 
18   function add(uint256 a, uint256 b) internal pure returns (uint256) {
19     uint256 c = a + b;
20     require(c >= a);
21     return c;
22   }
23 }
24 
25 library SafeMath64 {
26   function sub(uint64 a, uint64 b) internal pure returns (uint64) {
27     require(b <= a);
28     return a - b;
29   }
30 
31   function add(uint64 a, uint64 b) internal pure returns (uint64) {
32     uint64 c = a + b;
33     require(c >= a);
34     return c;
35   }
36 }
37 
38 
39 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
40 contract Ownable {
41   address public owner;
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45   function Ownable() public {
46     owner = msg.sender;
47   }
48 
49   modifier onlyOwner() {
50     require(msg.sender == owner);
51     _;
52   }
53 
54   function transferOwnership(address newOwner) public onlyOwner {
55     require(newOwner != address(0));
56     OwnershipTransferred(owner, newOwner);
57     owner = newOwner;
58   }
59 }
60 
61 
62 // https://github.com/ethereum/EIPs/issues/179
63 contract ERC20Basic {
64   uint256 public totalSupply;
65   function balanceOf(address who) public view returns (uint256);
66   function transfer(address to, uint256 value) public returns (bool);
67   event Transfer(address indexed from, address indexed to, uint256 value);
68 }
69 
70 
71 // https://github.com/ethereum/EIPs/issues/20
72 contract ERC20 is ERC20Basic {
73   function allowance(address owner, address spender) public view returns (uint256);
74   function transferFrom(address from, address to, uint256 value) public returns (bool);
75   function approve(address spender, uint256 value) public returns (bool);
76   event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 
80 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/DetailedERC20.sol
81 contract DetailedERC20 is ERC20 {
82   string public name;
83   string public symbol;
84   uint8 public decimals;
85 
86   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
87     name = _name;
88     symbol = _symbol;
89     decimals = _decimals;
90   }
91 }
92 
93 
94 /** SolClub has the following properties:
95   *
96   * Member Creation:
97   * - Self-registration
98   *   - Owner signs hash(address, username, endowment), and sends to member
99   *   - Member registers with username, endowment, and signature to create new account.
100   * - Mod creates new member.
101   * - Members are first eligible to withdraw dividends for the period after account creation.
102   *
103   * Karma/Token Rules:
104   * - Karma is created by initial member creation endowment.
105   * - Karma can also be minted by mod into an existing account.
106   * - Karma can only be transferred to existing account holder.
107   * - Karma implements the ERC20 token interface.
108   *
109   * Dividends:
110   * - each member can withdraw a dividend once per month.
111   * - dividend is total contract value minus owner cut at end of the month, divided by total number of members at end of month.
112   * - owner cut is determined at beginning of new period.
113   * - member has 1 month to withdraw their dividend from the previous month.
114   * - if member does not withdraw their dividend, their share will be given to owner.
115   * - mod can place a member on a 1 month "timeout", whereby they won't be eligible for a dividend.
116 
117   * Eg: 10 eth is sent to the contract in January, owner cut is 30%. 
118   * There are 70 token holders on Jan 31. At any time in February, each token holder can withdraw .1 eth for their January 
119   * dividend (unless they were given a "timeout" in January).
120   */
121 contract SolClub is Ownable, DetailedERC20("SolClub", "SOL", 0) {
122   // SafeMath libs are responsible for checking overflow.
123   using SafeMath for uint256;
124   using SafeMath64 for uint64;
125 
126   struct Member {
127     bytes20 username;
128     uint64 karma; 
129     uint16 canWithdrawPeriod;
130     uint16 birthPeriod;
131   }
132 
133   // Manage members.
134   mapping(address => Member) public members;
135   mapping(bytes20 => address) public usernames;
136 
137   // Manage dividend payments.
138   uint256 public epoch; // Timestamp at start of new period.
139   uint256 dividendPool; // Total amount of dividends to pay out for last period.
140   uint256 public dividend; // Per-member share of last period's dividend.
141   uint256 public ownerCut; // Percentage, in basis points, of owner cut of this period's payments.
142   uint64 public numMembers; // Number of members created before this period.
143   uint64 public newMembers; // Number of members created during this period.
144   uint16 public currentPeriod = 1;
145 
146   address public moderator;
147 
148   mapping(address => mapping (address => uint256)) internal allowed;
149 
150   event Mint(address indexed to, uint256 amount);
151   event PeriodEnd(uint16 period, uint256 amount, uint64 members);
152   event Payment(address indexed from, uint256 amount);
153   event Withdrawal(address indexed to, uint16 indexed period, uint256 amount);
154   event NewMember(address indexed addr, bytes20 username, uint64 endowment);
155   event RemovedMember(address indexed addr, bytes20 username, uint64 karma, bytes32 reason);
156 
157   modifier onlyMod() {
158     require(msg.sender == moderator);
159     _;
160   }
161 
162   function SolClub() public {
163     epoch = now;
164     moderator = msg.sender;
165   }
166 
167   function() payable public {
168     Payment(msg.sender, msg.value);
169   }
170 
171   /** 
172    * Owner Functions 
173    */
174 
175   function setMod(address _newMod) public onlyOwner {
176     moderator = _newMod;
177   }
178 
179   // Owner should call this on twice a month.
180   // _ownerCut is new owner cut for new period.
181   function newPeriod(uint256 _ownerCut) public onlyOwner {
182     require(now >= epoch + 15 days);
183     require(_ownerCut <= 10000);
184 
185     uint256 unclaimedDividend = dividendPool;
186     uint256 ownerRake = (address(this).balance-unclaimedDividend) * ownerCut / 10000;
187 
188     dividendPool = address(this).balance - unclaimedDividend - ownerRake;
189 
190     // Calculate dividend.
191     uint64 existingMembers = numMembers;
192     if (existingMembers == 0) {
193       dividend = 0;
194     } else {
195       dividend = dividendPool / existingMembers;
196     }
197 
198     numMembers = numMembers.add(newMembers);
199     newMembers = 0;
200     currentPeriod++;
201     epoch = now;
202     ownerCut = _ownerCut;
203 
204     msg.sender.transfer(ownerRake + unclaimedDividend);
205     PeriodEnd(currentPeriod-1, this.balance, existingMembers);
206   }
207 
208   // Places member is a "banished" state whereby they are no longer a member,
209   // but their username remains active (preventing re-registration)
210   function removeMember(address _addr, bytes32 _reason) public onlyOwner {
211     require(members[_addr].birthPeriod != 0);
212     Member memory m = members[_addr];
213 
214     totalSupply = totalSupply.sub(m.karma);
215     if (m.birthPeriod == currentPeriod) {
216       newMembers--;
217     } else {
218       numMembers--;
219     }
220 
221     // "Burns" username, so user can't recreate.
222     usernames[m.username] = address(0x1);
223 
224     delete members[_addr];
225     RemovedMember(_addr, m.username, m.karma, _reason);
226   }
227 
228   // Place a username back into circulation for re-registration.
229   function deleteUsername(bytes20 _username) public onlyOwner {
230     require(usernames[_username] == address(0x1));
231     delete usernames[_username];
232   }
233 
234   /**
235     * Mod Functions
236     */
237 
238   function createMember(address _addr, bytes20 _username, uint64 _amount) public onlyMod {
239     newMember(_addr, _username, _amount);
240   }
241 
242   // Send karma to existing account.
243   function mint(address _addr, uint64 _amount) public onlyMod {
244     require(members[_addr].canWithdrawPeriod != 0);
245 
246     members[_addr].karma = members[_addr].karma.add(_amount);
247     totalSupply = totalSupply.add(_amount);
248     Mint(_addr, _amount);
249   }
250 
251   // If a member has been bad, they won't be able to receive a dividend :(
252   function timeout(address _addr) public onlyMod {
253     require(members[_addr].canWithdrawPeriod != 0);
254 
255     members[_addr].canWithdrawPeriod = currentPeriod + 1;
256   }
257 
258   /**
259     * Member Functions
260     */
261 
262   // Owner will sign hash(address, username, amount), and address owner uses this 
263   // signature to register their account.
264   function register(bytes20 _username, uint64 _endowment, bytes _sig) public {
265     require(recover(keccak256(msg.sender, _username, _endowment), _sig) == owner);
266     newMember(msg.sender, _username, _endowment);
267   }
268 
269   // Member can withdraw their share of donations from the previous month.
270   function withdraw() public {
271     require(members[msg.sender].canWithdrawPeriod != 0);
272     require(members[msg.sender].canWithdrawPeriod < currentPeriod);
273 
274     members[msg.sender].canWithdrawPeriod = currentPeriod;
275     dividendPool -= dividend;
276     msg.sender.transfer(dividend);
277     Withdrawal(msg.sender, currentPeriod-1, dividend);
278   }
279 
280   /**
281     * ERC20 Functions
282     */
283 
284   function balanceOf(address _owner) public view returns (uint256 balance) {
285     return members[_owner].karma;
286   }
287 
288   // Contrary to most ERC20 implementations, require that recipient is existing member.
289   function transfer(address _to, uint256 _value) public returns (bool) {
290     require(members[_to].canWithdrawPeriod != 0);
291     require(_value <= members[msg.sender].karma);
292 
293     // Type assertion to uint64 is safe because we require that _value is < uint64 above.
294     members[msg.sender].karma = members[msg.sender].karma.sub(uint64(_value));
295     members[_to].karma = members[_to].karma.add(uint64(_value));
296     Transfer(msg.sender, _to, _value);
297     return true;
298   }
299 
300   function allowance(address _owner, address _spender) public view returns (uint256) {
301     return allowed[_owner][_spender];
302   }
303 
304   function approve(address _spender, uint256 _value) public returns (bool) {
305     allowed[msg.sender][_spender] = _value;
306     Approval(msg.sender, _spender, _value);
307     return true;
308   }
309 
310   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
311     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
312     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
313     return true;
314   }
315 
316   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
317     uint oldValue = allowed[msg.sender][_spender];
318     if (_subtractedValue > oldValue) {
319       allowed[msg.sender][_spender] = 0;
320     } else {
321       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
322     }
323     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
324     return true;
325   }
326 
327   // Contrary to most ERC20 implementations, require that recipient is existing member.
328   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
329     require(members[_to].canWithdrawPeriod != 0);
330     require(_value <= members[_from].karma);
331     require(_value <= allowed[_from][msg.sender]);
332 
333     members[_from].karma = members[_from].karma.sub(uint64(_value));
334     members[_to].karma = members[_to].karma.add(uint64(_value));
335     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
336     Transfer(_from, _to, _value);
337     return true;
338   }
339 
340   /**
341     * Private Functions
342     */
343 
344   // Ensures that username isn't taken, and account doesn't already exist for
345   // member's address.
346   function newMember(address _addr, bytes20 _username, uint64 _endowment) private {
347     require(usernames[_username] == address(0));
348     require(members[_addr].canWithdrawPeriod == 0);
349 
350     members[_addr].canWithdrawPeriod = currentPeriod + 1;
351     members[_addr].birthPeriod = currentPeriod;
352     members[_addr].karma = _endowment;
353     members[_addr].username = _username;
354     usernames[_username] = _addr;
355 
356     newMembers = newMembers.add(1);
357     totalSupply = totalSupply.add(_endowment);
358     NewMember(_addr, _username, _endowment);
359   }
360 
361   // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/ECRecovery.sol
362   function recover(bytes32 hash, bytes sig) internal pure returns (address) {
363     bytes32 r;
364     bytes32 s;
365     uint8 v;
366 
367     //Check the signature length
368     if (sig.length != 65) {
369       return (address(0));
370     }
371 
372     // Divide the signature in r, s and v variables
373     assembly {
374       r := mload(add(sig, 32))
375       s := mload(add(sig, 64))
376       v := byte(0, mload(add(sig, 96)))
377     }
378 
379     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
380     if (v < 27) {
381       v += 27;
382     }
383 
384     // If the version is correct return the signer address
385     if (v != 27 && v != 28) {
386       return (address(0));
387     } else {
388       return ecrecover(hash, v, r, s);
389     }
390   }
391 }