1 pragma solidity ^0.4.11;
2 
3 contract SafeMathLib {
4 
5   function safeMul(uint a, uint b) returns (uint) {
6     uint c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function safeSub(uint a, uint b) returns (uint) {
12     assert(b <= a);
13     return a - b;
14   }
15 
16   function safeAdd(uint a, uint b) returns (uint) {
17     uint c = a + b;
18     assert(c>=a);
19     return c;
20   }
21 
22   function assert(bool assertion) private {
23     if (!assertion) throw;
24   }
25 }
26 
27 contract Ownable {
28   address public owner;
29 
30 
31   function Ownable() {
32     owner = msg.sender;
33   }
34 
35 
36   modifier onlyOwner() {
37     if (msg.sender != owner) {
38       throw;
39     }
40     _;
41   }
42 
43 
44   function transferOwnership(address newOwner) onlyOwner {
45     if (newOwner != address(0)) {
46       owner = newOwner;
47     }
48   }
49 
50 }
51 
52 
53 contract ERC20Basic {
54   uint public totalSupply;
55   function balanceOf(address who) constant returns (uint);
56   function transfer(address _to, uint _value) returns (bool success);
57   event Transfer(address indexed from, address indexed to, uint value);
58 }
59 
60 contract ERC20 is ERC20Basic {
61   function allowance(address owner, address spender) constant returns (uint);
62   function transferFrom(address _from, address _to, uint _value) returns (bool success);
63   function approve(address _spender, uint _value) returns (bool success);
64   event Approval(address indexed owner, address indexed spender, uint value);
65 }
66 
67 
68 
69 contract StandardToken is ERC20, SafeMathLib{
70   
71   event Minted(address receiver, uint amount);
72 
73   
74   mapping(address => uint) balances;
75 
76   
77   mapping (address => mapping (address => uint)) allowed;
78 
79   modifier onlyPayloadSize(uint size) {
80      if(msg.data.length != size + 4) {
81        throw;
82      }
83      _;
84   }
85 
86   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
87    
88    
89     balances[msg.sender] = safeSub(balances[msg.sender],_value);
90     balances[_to] = safeAdd(balances[_to],_value);
91     Transfer(msg.sender, _to, _value);
92     return true;
93   }
94 
95   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
96     uint _allowance = allowed[_from][msg.sender];
97 
98     balances[_to] = safeAdd(balances[_to],_value);
99     balances[_from] = safeSub(balances[_from],_value);
100     allowed[_from][msg.sender] = safeSub(_allowance,_value);
101     Transfer(_from, _to, _value);
102     return true;
103   }
104 
105   function balanceOf(address _owner) constant returns (uint balance) {
106     return balances[_owner];
107   }
108 
109   function approve(address _spender, uint _value) returns (bool success) {
110 
111     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
112 
113     allowed[msg.sender][_spender] = _value;
114     Approval(msg.sender, _spender, _value);
115     return true;
116   }
117 
118   function allowance(address _owner, address _spender) constant returns (uint remaining) {
119     return allowed[_owner][_spender];
120   }
121 
122  function addApproval(address _spender, uint _addedValue)
123   onlyPayloadSize(2 * 32)
124   returns (bool success) {
125       uint oldValue = allowed[msg.sender][_spender];
126       allowed[msg.sender][_spender] = safeAdd(oldValue,_addedValue);
127       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
128       return true;
129   }
130 
131   function subApproval(address _spender, uint _subtractedValue)
132   onlyPayloadSize(2 * 32)
133   returns (bool success) {
134 
135       uint oldVal = allowed[msg.sender][_spender];
136 
137       if (_subtractedValue > oldVal) {
138           allowed[msg.sender][_spender] = 0;
139       } else {
140           allowed[msg.sender][_spender] = safeSub(oldVal,_subtractedValue);
141       }
142       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
143       return true;
144   }
145 
146 }
147 
148 
149 
150 contract UpgradeAgent {
151 
152   uint public originalSupply;
153 
154   
155   function isUpgradeAgent() public constant returns (bool) {
156     return true;
157   }
158 
159   function upgradeFrom(address _from, uint256 _value) public;
160 
161 }
162 
163 
164 
165  contract UpgradeableToken is StandardToken {
166 
167   
168   address public upgradeMaster;
169 
170   
171   UpgradeAgent public upgradeAgent;
172 
173   
174   uint256 public totalUpgraded;
175 
176   
177   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
178 
179   
180   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
181 
182   
183   event UpgradeAgentSet(address agent);
184 
185   
186   function UpgradeableToken(address _upgradeMaster) {
187     upgradeMaster = _upgradeMaster;
188   }
189 
190   
191   function upgrade(uint256 value) public {
192 
193       UpgradeState state = getUpgradeState();
194       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
195         
196         throw;
197       }
198 
199       
200       if (value == 0) throw;
201 
202       balances[msg.sender] = safeSub(balances[msg.sender],value);
203 
204       
205       totalSupply = safeSub(totalSupply,value);
206       totalUpgraded = safeAdd(totalUpgraded,value);
207 
208       
209       upgradeAgent.upgradeFrom(msg.sender, value);
210       Upgrade(msg.sender, upgradeAgent, value);
211   }
212 
213  
214   function setUpgradeAgent(address agent) external {
215 
216       if(!canUpgrade()) {
217         
218         throw;
219       }
220 
221       if (agent == 0x0) throw;
222       
223       if (msg.sender != upgradeMaster) throw;
224       
225       if (getUpgradeState() == UpgradeState.Upgrading) throw;
226 
227       upgradeAgent = UpgradeAgent(agent);
228 
229       
230       if(!upgradeAgent.isUpgradeAgent()) throw;
231       
232       if (upgradeAgent.originalSupply() != totalSupply) throw;
233 
234       UpgradeAgentSet(upgradeAgent);
235   }
236 
237   function getUpgradeState() public constant returns(UpgradeState) {
238     if(!canUpgrade()) return UpgradeState.NotAllowed;
239     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
240     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
241     else return UpgradeState.Upgrading;
242   }
243 
244   
245   function setUpgradeMaster(address master) public {
246       if (master == 0x0) throw;
247       if (msg.sender != upgradeMaster) throw;
248       upgradeMaster = master;
249   }
250 
251   
252   function canUpgrade() public constant returns(bool) {
253      return true;
254   }
255 
256 }
257 
258 
259 contract ReleasableToken is ERC20, Ownable {
260 
261   
262   address public releaseAgent;
263 
264   
265   bool public released = false;
266 
267   
268   mapping (address => bool) public transferAgents;
269 
270 
271   modifier canTransfer(address _sender) {
272 
273     if(!released) {
274         if(!transferAgents[_sender]) {
275             throw;
276         }
277     }
278 
279     _;
280   }
281 
282 
283   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
284     releaseAgent = addr;
285   }
286 
287 
288   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
289     transferAgents[addr] = state;
290   }
291 
292 
293   function releaseTokenTransfer() public onlyReleaseAgent {
294     released = true;
295   }
296 
297   
298   modifier inReleaseState(bool releaseState) {
299     if(releaseState != released) {
300         throw;
301     }
302     _;
303   }
304 
305   
306   modifier onlyReleaseAgent() {
307     if(msg.sender != releaseAgent) {
308         throw;
309     }
310     _;
311   }
312 
313   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
314     
315    return super.transfer(_to, _value);
316   }
317 
318   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
319     
320     return super.transferFrom(_from, _to, _value);
321   }
322 
323 }
324 
325 contract MintableToken is StandardToken, Ownable {
326 
327   bool public mintingFinished = false;
328 
329   
330   mapping (address => bool) public mintAgents;
331 
332   event MintingAgentChanged(address addr, bool state  );
333 
334 
335   function mint(address receiver, uint amount) onlyMintAgent canMint public {
336     totalSupply = safeAdd(totalSupply,amount);
337     balances[receiver] = safeAdd(balances[receiver],amount);
338 
339 
340     Transfer(0, receiver, amount);
341   }
342 
343 
344   function setMintAgent(address addr, bool state) onlyOwner canMint public {
345     mintAgents[addr] = state;
346     MintingAgentChanged(addr, state);
347   }
348 
349   modifier onlyMintAgent() {
350     
351     if(!mintAgents[msg.sender]) {
352         throw;
353     }
354     _;
355   }
356 
357   
358   modifier canMint() {
359     if(mintingFinished) throw;
360     _;
361   }
362 }
363 
364 
365 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
366 
367   event UpdatedTokenInformation(string newName, string newSymbol);
368 
369   string public name;
370 
371   string public symbol;
372 
373   uint public decimals;
374 
375   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
376     UpgradeableToken(msg.sender) {
377 
378     owner = msg.sender;
379 
380     name = _name;
381     symbol = _symbol;
382 
383     totalSupply = _initialSupply;
384 
385     decimals = _decimals;
386 
387     
388     balances[owner] = totalSupply;
389 
390     if(totalSupply > 0) {
391       Minted(owner, totalSupply);
392     }
393 
394     
395     if(!_mintable) {
396       mintingFinished = true;
397       if(totalSupply == 0) {
398         throw; 
399       }
400     }
401   }
402 
403 
404   function releaseTokenTransfer() public onlyReleaseAgent {
405     mintingFinished = true;
406     super.releaseTokenTransfer();
407   }
408 
409 
410   function canUpgrade() public constant returns(bool) {
411     return released && super.canUpgrade();
412   }
413 
414 
415   function setTokenInformation(string _name, string _symbol) onlyOwner {
416     name = _name;
417     symbol = _symbol;
418 
419     UpdatedTokenInformation(name, symbol);
420   }
421 
422 }