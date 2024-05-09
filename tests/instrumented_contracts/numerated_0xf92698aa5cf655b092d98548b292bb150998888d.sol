1 /**
2  *  NotaryPlatformToken.sol v1.0.1
3  * 
4  *  Bilal Arif - https://twitter.com/furusiyya_
5  *  Notary Platform
6  */
7 
8 pragma solidity ^0.4.16;
9 
10 library SafeMath {
11     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
12         uint256 c = a * b;
13         assert(a == 0 || c / a == b);
14         return c;
15     }
16     
17     function div(uint256 a, uint256 b) internal constant returns (uint256) {
18         uint256 c = a / b;
19         return c;
20     }
21     
22     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26     
27     function add(uint256 a, uint256 b) internal constant returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 contract Ownable {
34      /*
35       @title Ownable
36       @dev The Ownable contract has an owner address, and provides basic authorization control
37       functions, this simplifies the implementation of "user permissions".
38     */
39 
40   address public owner;
41 
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   function Ownable(address _owner){
49     owner = _owner;
50   }
51 
52   /**
53    * @dev Allows the current owner to transfer control of the contract to a newOwner.
54    * @param newOwner The address to transfer ownership to.
55    */
56   function transferOwnership(address newOwner) onlyOwner public {
57     require(newOwner != address(0));
58     OwnershipTransferred(owner, newOwner);
59     owner = newOwner;
60   }
61   
62   /**
63    * @dev Throws if called by any account other than the owner.
64    */
65   modifier onlyOwner() {
66     require(msg.sender == owner);
67     _;
68   }
69 
70 }
71 contract ReentrancyGuard {
72 
73   /**
74    * @dev We use a single lock for the whole contract.
75    */
76   bool private rentrancy_lock = false;
77 
78   /**
79    * @dev Prevents a contract from calling itself, directly or indirectly.
80    * @notice If you mark a function `nonReentrant`, you should also
81    * mark it `external`. Calling one nonReentrant function from
82    * another is not supported. Instead, you can implement a
83    * `private` function doing the actual work, and a `external`
84    * wrapper marked as `nonReentrant`.
85    */
86   modifier nonReentrant() {
87     require(!rentrancy_lock);
88     rentrancy_lock = true;
89     _;
90     rentrancy_lock = false;
91   }
92 
93 }
94 contract Pausable is Ownable {
95   
96   event Pause(bool indexed state);
97 
98   bool private paused = false;
99 
100   /**
101    * @dev Modifier to make a function callable only when the contract is not paused.
102    */
103   modifier whenNotPaused() {
104     require(!paused);
105     _;
106   }
107 
108   /**
109    * @dev Modifier to make a function callable only when the contract is paused.
110    */
111   modifier whenPaused() {
112     require(paused);
113     _;
114   }
115 
116   /**
117    * @dev return the current state of contract
118    */
119   function Paused() external constant returns(bool){ return paused; }
120 
121   /**
122    * @dev called by the owner to pause or unpause, triggers stopped state
123    * on first call and returns to normal state on second call
124    */
125   function tweakState() external onlyOwner {
126     paused = !paused;
127     Pause(paused);
128   }
129 
130 }
131 contract Allocations{
132 
133 	// timestamp when token release is enabled
134   	uint256 private releaseTime;
135 
136 	mapping (address => uint256) private allocations;
137 
138 	function Allocations(){
139 		releaseTime = now + 198 days;
140 		allocate();
141 	}
142 
143 	/**
144 	 * @notice NTRY Token distribution between team members.
145 	 */
146     function allocate() private {
147       allocations[0xab1cb1740344A9280dC502F3B8545248Dc3045eA] = 4000000 * 1 ether;
148       allocations[0x330709A59Ab2D1E1105683F92c1EE8143955a357] = 4000000 * 1 ether;
149       allocations[0xAa0887fc6e8896C4A80Ca3368CFd56D203dB39db] = 3000000 * 1 ether;
150       allocations[0x1fbA1d22435DD3E7Fa5ba4b449CC550a933E72b3] = 200000 * 1 ether;
151       allocations[0xC9d5E2c7e40373ae576a38cD7e62E223C95aBFD4] = 200000 * 1 ether;
152       allocations[0xabc0B64a38DE4b767313268F0db54F4cf8816D9C] = 220000 * 1 ether;
153       allocations[0x5d85bCDe5060C5Bd00DBeDF5E07F43CE3Ccade6f] = 50000 * 1 ether;
154       allocations[0xecb1b0231CBC0B04015F9e5132C62465C128B578] = 500000 * 1 ether;
155       allocations[0xFF22FA2B3e5E21817b02a45Ba693B7aC01485a9C] = 2955000 * 1 ether;
156     }
157 
158 	/**
159 	 * @notice Transfers tokens held by timelock to beneficiary.
160 	 */
161 	function release() internal returns (uint256 amount){
162 		amount = allocations[msg.sender];
163 		allocations[msg.sender] = 0;
164 		return amount;
165 	}
166 
167 	/**
168   	 * @dev returns releaseTime
169   	 */
170 	function RealeaseTime() external constant returns(uint256){ return releaseTime; }
171 
172     modifier timeLock() { 
173 		require(now >= releaseTime);
174 		_; 
175 	}
176 
177 	modifier isTeamMember() { 
178 		require(allocations[msg.sender] >= 10000 * 1 ether); 
179 		_; 
180 	}
181 
182 }
183 
184 contract NotaryPlatformToken is Pausable, Allocations, ReentrancyGuard{
185 
186   using SafeMath for uint256;
187 
188   string constant public name = "Notary Platform Token";
189   string constant public symbol = "NTRY";
190   uint8 constant public decimals = 18;
191   uint256 public totalSupply = 150000000 * 1 ether;
192   string constant version = "v1.0.1";
193 
194   mapping(address => uint256) private balances;
195   mapping (address => mapping (address => uint256)) private allowed;
196 
197   event Approval(address indexed owner, address indexed spender, uint256 value);
198   event Transfer(address indexed from, address indexed to, uint256 value);
199 
200   function NotaryPlatformToken() Ownable(0x1538EF80213cde339A333Ee420a85c21905b1b2D){
201     // Allocate initial balance to the owner //
202     balances[0x244092a2FECFC48259cf810b63BA3B3c0B811DCe] = 134875000 * 1 ether;
203     require(ICOParticipants(0x244092a2FECFC48259cf810b63BA3B3c0B811DCe));
204   }
205 
206 
207   /** Externals **/
208 
209   /**
210   * @dev transfer token for a specified address
211   * @param _to The address to transfer to.
212   * @param _value The amount to be transferred.
213   */
214   function transfer(address _to, uint256 _value) external whenNotPaused onlyPayloadSize(2 * 32) returns (bool) {
215     require(_to != address(0));
216     balances[msg.sender] = balances[msg.sender].sub(_value);
217     balances[_to] = balances[_to].add(_value);
218     Transfer(msg.sender, _to, _value);
219     return true;
220   }
221 
222   /**
223   * @dev Gets the balance of the specified address.
224   * @param _owner The address to query the the balance of.
225   * @return An uint256 representing the amount owned by the passed address.
226   */
227   function balanceOf(address _owner) external constant returns (uint256 balance) {
228     return balances[_owner];
229   }
230 
231   /**
232    * @dev Transfer tokens from one address to another
233    * @param _from address The address which you want to send tokens from
234    * @param _to address The address which you want to transfer to
235    * @param _value uint256 the amount of tokens to be transferred
236    */
237   function transferFrom(address _from, address _to, uint256 _value) external whenNotPaused returns (bool) {
238     require(_to != address(0));
239 
240     uint256 _allowance = allowed[_from][msg.sender];
241 
242     balances[_from] = balances[_from].sub(_value);
243     balances[_to] = balances[_to].add(_value);
244     allowed[_from][msg.sender] = _allowance.sub(_value);
245     Transfer(_from, _to, _value);
246     return true;
247   }
248 
249   /**
250    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
251    *
252    * Beware that changing an allowance with this method brings the risk that someone may use both the old
253    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
254    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
255    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
256    * @param _spender The address which will spend the funds.
257    * @param _value The amount of tokens to be spent.
258    */
259   function approve(address _spender, uint256 _value) external whenNotPaused returns (bool) {
260     allowed[msg.sender][_spender] = _value;
261     Approval(msg.sender, _spender, _value);
262     return true;
263   }
264 
265   /**
266    * @dev Function to check the amount of tokens that an owner allowed to a spender.
267    * @param _owner address The address which owns the funds.
268    * @param _spender address The address which will spend the funds.
269    * @return A uint256 specifying the amount of tokens still available for the spender.
270    */
271   function allowance(address _owner, address _spender) external constant returns (uint256 remaining) {
272     return allowed[_owner][_spender];
273   }
274 
275   /**
276    * approve should be called when allowed[_spender] == 0. To increment
277    * allowed value is better to use this function to avoid 2 calls (and wait until
278    * the first transaction is mined)
279    * From MonolithDAO Token.sol
280    */
281   function increaseApproval (address _spender, uint _addedValue) external whenNotPaused returns (bool success) {
282     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
283     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
284     return true;
285   }
286 
287   function decreaseApproval (address _spender, uint _subtractedValue) external whenNotPaused returns (bool success) {
288     uint oldValue = allowed[msg.sender][_spender];
289     if (_subtractedValue > oldValue) {
290       allowed[msg.sender][_spender] = 0;
291     } else {
292       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
293     }
294     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
295     return true;
296   }
297 
298   /**
299   * @notice Transfers tokens held by timelock to beneficiary.
300   */
301   function claim() external whenNotPaused nonReentrant timeLock isTeamMember {
302     balances[msg.sender] = balances[msg.sender].add(release());
303   }
304 
305   /**
306    *                  ========== Token migration support ========
307    */
308   uint256 public totalMigrated;
309   bool private upgrading = false;
310   MigrationAgent private agent;
311   event Migrate(address indexed _from, address indexed _to, uint256 _value);
312   event Upgrading(bool status);
313 
314   function migrationAgent() external constant returns(address){ return agent; }
315   function upgradingEnabled()  external constant returns(bool){ return upgrading; }
316 
317   /**
318    * @notice Migrate tokens to the new token contract.
319    * @dev Required state: Operational Migration
320    * @param _value The amount of token to be migrated
321    */
322   function migrate(uint256 _value) external nonReentrant isUpgrading {
323     require(_value > 0);
324     require(_value <= balances[msg.sender]);
325     require(agent.isMigrationAgent());
326 
327     balances[msg.sender] = balances[msg.sender].sub(_value);
328     totalSupply = totalSupply.sub(_value);
329     totalMigrated = totalMigrated.add(_value);
330     
331     if(!agent.migrateFrom(msg.sender, _value)){
332       revert();
333     }
334     Migrate(msg.sender, agent, _value);
335   }
336 
337   /**
338    * @notice Set address of migration target contract and enable migration
339    * process.
340    * @param _agent The address of the MigrationAgent contract
341    */
342   function setMigrationAgent(address _agent) external isUpgrading onlyOwner {
343     require(_agent != 0x00);
344     agent = MigrationAgent(_agent);
345     if(!agent.isMigrationAgent()){
346       revert();
347     }
348     
349     if(agent.originalSupply() != totalSupply){
350       revert();
351     }
352   }
353 
354   /**
355    * @notice Enable upgrading to allow tokens migration to new contract
356    * process.
357    */
358   function tweakUpgrading() external onlyOwner{
359       upgrading = !upgrading;
360       Upgrading(upgrading);
361   }
362 
363 
364   /** Interface marker */
365   function isTokenContract() external constant returns (bool) {
366     return true;
367   }
368 
369   modifier isUpgrading() { 
370     require(upgrading); 
371     _; 
372   }
373 
374 
375   /**
376    * Fix for the ERC20 short address attack
377    *
378    * http://vessenes.com/the-erc20-short-address-attack-explained/
379    */
380   modifier onlyPayloadSize(uint size) {
381      require(msg.data.length == size + 4);
382      _;
383   }
384 
385   function () {
386     //if ether is sent to this address, send it back.
387     revert();
388   }
389   
390   
391 
392    function ICOParticipants(address _supplyOwner) private returns(bool){
393         /**
394          * Adresses who participated in first day of ICO and got first version of
395          * token. They will automatically get this latest version of token.
396          * ICO Contract: https://etherscan.io/address/0x34a3deb32b4705018f1e543a5867cf01aff3f15b
397          * Latest transaction hash: https://etherscan.io/tx/0x1d179fb045a86eed7a78e2e247c0822fc43f1a163f893996f88fdccd455d515b
398         */
399         balances[0xd0780ab2aa7309e139a1513c49fb2127ddc30d3d] = 15765750000000000000000;
400         balances[0x196a484db36d2f2049559551c182209143db4606] = 2866500000000000000000;
401         balances[0x36cfb5a6be6b130cfceb934d3ca72c1d72c3a7d8] = 28665000000000000000000;
402         balances[0x21c4ff1738940b3a4216d686f2e63c8dbcb7dc44] = 2866500000000000000000;
403         balances[0xd1f3a1a16f4ab35e5e795ce3f49ee2dff2dd683b] = 1433250000000000000000;
404         balances[0xd45bf2debd1c4196158dcb177d1ae910949dc00a] = 5733000000000000000000;
405         balances[0xdc5984a2673c46b68036076026810ffdffb695b8] = 1433250000000000000000;
406         balances[0x6ee541808c463116a82d76649da0502935fa8d08] = 57330000000000000000000;
407         balances[0xde3270049c833ff2a52f18c7718227eb36a92323] = 4948241046840000000000;
408         balances[0x51a51933721e4ada68f8c0c36ca6e37914a8c609] = 17199000000000000000000;
409         balances[0x737069e6f9f02062f4d651c5c8c03d50f6fc99c6] = 2866500000000000000000;
410         balances[0xa6a14a81ec752e0ed5391a22818f44aa240ffbb1] = 2149875000000000000000;
411         balances[0xeac8483261078517528de64956dbd405f631265c] = 11466000000000000000000;
412         balances[0x7736154662ba56c57b2be628fe0e44a609d33dfb] = 2866500000000000000000;
413         balances[0xc1c113c60ebf7d92a3d78ff7122435a1e307ce05] = 5733000000000000000000;
414         balances[0xfffdfaef43029d6c749ceff04f65187bd50a5311] = 2293200000000000000000;
415         balances[0x8854f86f4fbd88c4f16c4f3d5a5500de6d082adc] = 2866500000000000000000;
416         balances[0x26c32811447c8d0878b2dae7f4538ae32de82d57] = 2436525000000000000000;
417         balances[0xe752737dd519715ab0fa9538949d7f9249c7c168] = 2149875000000000000000;
418         balances[0x01ed3975993c8bebff2fb6a7472679c6f7b408fb] = 11466000000000000000000;
419         balances[0x7924c67c07376cf7c4473d27bee92fe82dfd26c5] = 11466000000000000000000;
420         balances[0xf360b24a530d29c96a26c2e34c0dabcab12639f4] = 8599500000000000000000;
421         balances[0x6a7f63709422a986a953904c64f10d945c8afba1] = 2866500000000000000000;
422         balances[0xa68b4208e0b7aacef5e7cf8d6691d5b973bad119] = 2149875000000000000000;
423         balances[0xb9bd4f154bb5f2be5e7db0357c54720c7f35405d] = 2149875000000000000000;
424         balances[0x6723f81cdc9a5d5ef2fe1bfbedb4f83bd017d3dc] = 5446350000000000000000;
425         balances[0x8f066f3d9f75789d9f126fdd7cfbcc38a768985d] = 146737500000000000000000;
426         balances[0xf49c6e7e36a714bbc162e31ca23a04e44dcaf567] = 25769835000000000000000;
427         balances[0x1538ef80213cde339a333ee420a85c21905b1b2d] = 2730000000000000000000;
428         balances[0x81a837cc83b55a67351c1070920f061dda307348] = 25511850000000000000000;
429         balances[_supplyOwner] -= 417961751000000000000000;
430         return true;
431  	}
432 
433 }
434 
435 /// @title Migration Agent interface
436 contract MigrationAgent {
437 
438   uint256 public originalSupply;
439   
440   function migrateFrom(address _from, uint256 _value) external returns(bool);
441   
442   /** Interface marker */
443   function isMigrationAgent() external constant returns (bool) {
444     return true;
445   }
446 }