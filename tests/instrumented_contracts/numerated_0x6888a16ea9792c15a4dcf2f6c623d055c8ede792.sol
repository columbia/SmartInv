1 pragma solidity ^0.4.15;
2 
3 /**
4   * Math operations with safety checks
5   */
6 library SafeMath {
7     function safeMul(uint a, uint b) internal returns (uint) {
8         uint c = a * b;
9         assert(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function safeDiv(uint a, uint b) internal returns (uint) {
14         assert(b > 0);
15         uint c = a / b;
16         assert(a == b * c + a % b);
17         return c;
18     }
19 
20     function safeSub(uint a, uint b) internal returns (uint) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function safeAdd(uint a, uint b) internal returns (uint) {
26         uint c = a + b;
27         assert(c>=a && c>=b);
28         return c;
29     }
30 
31     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
32         return a >= b ? a : b;
33     }
34 
35     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
36         return a < b ? a : b;
37     }
38 
39     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
40         return a >= b ? a : b;
41     }
42 
43     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
44         return a < b ? a : b;
45     }
46 }
47 
48 
49 /*
50   * ERC20 interface
51   * see https://github.com/ethereum/EIPs/issues/20
52   */
53 contract ERC20 {
54     uint public totalSupply;
55     function balanceOf(address who) constant returns (uint);
56     function allowance(address owner, address spender) constant returns (uint);
57 
58     function transfer(address to, uint value) returns (bool ok);
59     function transferFrom(address from, address to, uint value) returns (bool ok);
60     function approve(address spender, uint value) returns (bool ok);
61     event Transfer(address indexed from, address indexed to, uint value);
62     event Approval(address indexed owner, address indexed spender, uint value);
63 }
64 
65 
66 
67 /**
68   * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
69   *
70   * Based on code by FirstBlood:
71   * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
72   */
73 contract StandardToken is ERC20
74 {
75     using SafeMath for uint;
76 
77     mapping(address => uint) balances;
78     mapping(address => mapping (address => uint)) allowed;
79 
80     // Interface marker
81     bool public constant isToken = true;
82 
83     /**
84       * Fix for the ERC20 short address attack
85       *
86       * http://vessenes.com/the-erc20-short-address-attack-explained/
87       */
88     modifier onlyPayloadSize(uint size) {
89         require(msg.data.length == size + 4);
90         _;
91     }
92 
93     function transfer(address _to, uint _value)
94         onlyPayloadSize(2 * 32)
95         returns (bool success)
96     {
97         balances[msg.sender] = balances[msg.sender].safeSub(_value);
98         balances[_to] = balances[_to].safeAdd(_value);
99 
100         Transfer(msg.sender, _to, _value);
101         return true;
102     }
103 
104     function transferFrom(address from, address to, uint value)
105         returns (bool success)
106     {
107         uint _allowance = allowed[from][msg.sender];
108 
109         // Check is not needed because _allowance.safeSub(value) will throw if this condition is not met
110         // if (value > _allowance) throw;
111 
112         balances[to] = balances[to].safeAdd(value);
113         balances[from] = balances[from].safeSub(value);
114         allowed[from][msg.sender] = _allowance.safeSub(value);
115 
116         Transfer(from, to, value);
117         return true;
118     }
119 
120     function balanceOf(address account)
121         constant
122         returns (uint balance)
123     {
124         return balances[account];
125     }
126 
127     function approve(address spender, uint value)
128         returns (bool success)
129     {
130         // To change the approve amount you first have to reduce the addresses`
131         //  allowance to zero by calling `approve(spender, 0)` if it is not
132         //  already 0 to mitigate the race condition described here:
133         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134         if ((value != 0) && (allowed[msg.sender][spender] != 0)) throw;
135 
136         allowed[msg.sender][spender] = value;
137 
138         Approval(msg.sender, spender, value);
139         return true;
140     }
141 
142     function allowance(address account, address spender)
143         constant
144         returns (uint remaining)
145     {
146         return allowed[account][spender];
147     }
148 }
149 
150 
151 
152 /**
153   * Upgrade target interface inspired by Lunyr.
154   *
155   * Upgrade agent transfers tokens to a new contract.
156   * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
157   */
158 contract UpgradeTarget
159 {
160     uint public originalSupply;
161 
162     /** Interface marker */
163     function isUpgradeTarget() public constant returns (bool) {
164         return true;
165     }
166 
167     function upgradeFrom(address _from, uint256 _value) public;
168 }
169 
170 
171 /**
172   * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
173   *
174   * First envisioned by Golem and Lunyr projects.
175   */
176 contract UpgradeableToken is StandardToken
177 {
178     /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
179     address public upgradeMaster;
180 
181     /** The next contract where the tokens will be migrated. */
182     UpgradeTarget public upgradeTarget;
183 
184     /** How many tokens we have upgraded by now. */
185     uint256 public totalUpgraded;
186 
187     /**
188       * Upgrade states.
189       *
190       * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
191       * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
192       * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
193       * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
194       *
195       */
196     enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
197 
198     /**
199       * Somebody has upgraded some of his tokens.
200       */
201     event LogUpgrade(address indexed _from, address indexed _to, uint256 _value);
202 
203     /**
204       * New upgrade agent available.
205       */
206     event LogSetUpgradeTarget(address agent);
207 
208     /**
209       * Do not allow construction without upgrade master set.
210       */
211     function UpgradeableToken(address _upgradeMaster) {
212         upgradeMaster = _upgradeMaster;
213     }
214 
215     /**
216       * Allow the token holder to upgrade some of their tokens to a new contract.
217       */
218     function upgrade(uint256 value) public {
219         UpgradeState state = getUpgradeState();
220         require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);
221 
222         // Validate input value.
223         require(value > 0);
224 
225         balances[msg.sender] = balances[msg.sender].safeSub(value);
226 
227         // Take tokens out from circulation
228         totalSupply   = totalSupply.safeSub(value);
229         totalUpgraded = totalUpgraded.safeAdd(value);
230 
231         // Upgrade agent reissues the tokens
232         upgradeTarget.upgradeFrom(msg.sender, value);
233         LogUpgrade(msg.sender, upgradeTarget, value);
234     }
235 
236     /**
237       * Set an upgrade targget that handles the process of letting users opt-in to the new token contract.
238       */
239     function setUpgradeTarget(address target) external {
240         require(canUpgrade());
241         require(target != 0x0);
242         require(msg.sender == upgradeMaster); // Only a master can designate the next target
243         require(getUpgradeState() != UpgradeState.Upgrading); // Upgrade has already begun
244 
245         upgradeTarget = UpgradeTarget(target);
246 
247         require(upgradeTarget.isUpgradeTarget()); // Bad interface
248         require(upgradeTarget.originalSupply() == totalSupply); // Make sure that token supplies match in source and target
249 
250         LogSetUpgradeTarget(upgradeTarget);
251     }
252 
253     /**
254       * Get the state of the token upgrade.
255       */
256     function getUpgradeState() public constant returns (UpgradeState) {
257         if (!canUpgrade()) return UpgradeState.NotAllowed;
258         else if (address(upgradeTarget) == 0x00) return UpgradeState.WaitingForAgent;
259         else if (totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
260         else return UpgradeState.Upgrading;
261     }
262 
263     /**
264       * Change the upgrade master.
265       *
266       * This allows us to set a new owner for the upgrade mechanism.
267       */
268     function setUpgradeMaster(address master) public {
269         require(master != 0x0);
270         require(msg.sender == upgradeMaster);
271 
272         upgradeMaster = master;
273     }
274 
275     /**
276       * Child contract can enable to provide the condition when the upgrade can begun.
277       */
278     function canUpgrade() public constant returns (bool) {
279         return true;
280     }
281 }
282 
283 contract MintableToken is StandardToken
284 {
285     address public mintMaster;
286 
287     event LogMintTokens(address recipient, uint amount, uint newBalance, uint totalSupply);
288     event LogUnmintTokens(address hodler, uint amount, uint newBalance, uint totalSupply);
289     event LogSetMintMaster(address oldMintMaster, address newMintMaster);
290 
291     function MintableToken(address _mintMaster) {
292         mintMaster = _mintMaster;
293     }
294 
295     function setMintMaster(address newMintMaster)
296         returns (bool ok)
297     {
298         require(msg.sender == mintMaster);
299 
300         address oldMintMaster = mintMaster;
301         mintMaster = newMintMaster;
302 
303         LogSetMintMaster(oldMintMaster, mintMaster);
304         return true;
305     }
306 
307     function mintTokens(address recipient, uint amount)
308         returns (bool ok)
309     {
310         require(msg.sender == mintMaster);
311         require(amount > 0);
312 
313         balances[recipient] = balances[recipient].safeAdd(amount);
314         totalSupply = totalSupply.safeAdd(amount);
315 
316         LogMintTokens(recipient, amount, balances[recipient], totalSupply);
317         Transfer(address(0), recipient, amount);
318         return true;
319     }
320 
321     function unmintTokens(address hodler, uint amount)
322         returns (bool ok)
323     {
324         require(msg.sender == mintMaster);
325         require(amount > 0);
326         require(balances[hodler] >= amount);
327 
328         balances[hodler] = balances[hodler].safeSub(amount);
329         totalSupply = totalSupply.safeSub(amount);
330 
331         LogUnmintTokens(hodler, amount, balances[hodler], totalSupply);
332         Transfer(hodler, address(0), amount);
333         return true;
334     }
335 }
336 
337 
338 contract SigToken is UpgradeableToken, MintableToken
339 {
340     string public name = "Signals";
341     string public symbol = "SIG";
342     uint8 public decimals = 18;
343 
344     address public crowdsaleContract;
345     bool public crowdsaleCompleted;
346 
347     function SigToken()
348         UpgradeableToken(msg.sender)
349         MintableToken(msg.sender)
350     {
351         crowdsaleContract = msg.sender;
352         totalSupply = 0; // we mint during the crowdsale, so totalSupply must start at 0
353     }
354 
355     function transfer(address _to, uint _value)
356         returns (bool success)
357     {
358         require(crowdsaleCompleted);
359         return StandardToken.transfer(_to, _value);
360     }
361 
362     function transferFrom(address from, address to, uint value)
363         returns (bool success)
364     {
365         require(crowdsaleCompleted);
366         return StandardToken.transferFrom(from, to, value);
367     }
368 
369     function approve(address spender, uint value)
370         returns (bool success)
371     {
372         require(crowdsaleCompleted);
373         return StandardToken.approve(spender, value);
374     }
375 
376     // This is called to unlock tokens once the crowdsale (and subsequent audit + legal process) are
377     // completed.  We don't want people buying tokens during the sale and then immediately starting
378     // to trade them.  See Crowdsale::finalizeCrowdsale().
379     function setCrowdsaleCompleted() {
380         require(msg.sender == crowdsaleContract);
381         require(crowdsaleCompleted == false);
382 
383         crowdsaleCompleted = true;
384     }
385 
386     /**
387      * ERC20 approveAndCall extension
388      *
389      * Approves and then calls the receiving contract
390      */
391     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
392         public
393         returns (bool success)
394     {
395         require(crowdsaleCompleted);
396 
397         allowed[msg.sender][_spender] = _value;
398         Approval(msg.sender, _spender, _value);
399 
400         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
401         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
402         //it is assumed when one does this that the call *should* succeed, otherwise one would use vanilla approve instead.
403         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
404         return true;
405     }
406 }