1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5     
6     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7         if (a == 0) {
8             return 0;
9         }
10         uint256 c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16 
17         uint256 c = a / b;
18 
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 
35 contract Ownable {
36   address public owner;
37 
38 
39   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46   function Ownable() public {
47     owner = msg.sender;
48   }
49 
50   function transferOwnership(address newOwner) public onlyOwner {
51     require(newOwner != address(0));
52     OwnershipTransferred(owner, newOwner);
53     owner = newOwner;
54   }
55 
56 }
57 
58 
59 contract ERC20Basic {
60   uint256 public totalSupply;
61   function balanceOf(address who) public view returns (uint256);
62   function transfer(address to, uint256 value) public returns (bool);
63   event Transfer(address indexed from, address indexed to, uint256 value);
64 }
65 
66 
67 contract BasicToken is ERC20Basic {
68   using SafeMath for uint256;
69 
70   mapping(address => uint256) balances;
71 
72   function transfer(address _to, uint256 _value) public returns (bool) {
73     require(_to != address(0));
74     require(_value <= balances[msg.sender]);
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   function balanceOf(address _owner) public view returns (uint256 balance) {
82     return balances[_owner];
83   }
84 
85 }
86 
87 
88 contract ERC20 is ERC20Basic {
89   function allowance(address owner, address spender) public view returns (uint256);
90   function transferFrom(address from, address to, uint256 value) public returns (bool);
91   function approve(address spender, uint256 value) public returns (bool);
92   event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 
96 contract StandardToken is ERC20, BasicToken {
97 
98     mapping (address => mapping (address => uint256)) internal allowed;
99 
100     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
101         require(_to != address(0));
102         require(_value <= balances[_from]);
103         require(_value <= allowed[_from][msg.sender]);
104         balances[_from] = balances[_from].sub(_value);
105         balances[_to] = balances[_to].add(_value);
106         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
107         Transfer(_from, _to, _value);
108         return true;
109     }
110 
111     function approve(address _spender, uint256 _value) public returns (bool) {
112         allowed[msg.sender][_spender] = _value;
113         Approval(msg.sender, _spender, _value);
114         return true;
115     }
116 
117     function allowance(address _owner, address _spender) public view returns (uint256) {
118         return allowed[_owner][_spender];
119     }
120 
121     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
122         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
123         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
124         return true;
125     }
126 
127     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
128         uint oldValue = allowed[msg.sender][_spender];
129         if (_subtractedValue > oldValue) {
130             allowed[msg.sender][_spender] = 0;
131         } else {
132             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
133         }
134         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
135         return true;
136     }
137 }
138 
139 
140 contract ReleasableToken is StandardToken, Ownable {
141 
142     address public releaseAgent;
143 
144     bool public released = false;
145 
146     event Released();
147 
148     event ReleaseAgentSet(address releaseAgent);
149 
150     event TransferAgentSet(address transferAgent, bool status);
151 
152     mapping (address => bool) public transferAgents;
153 
154     modifier canTransfer(address _sender) {
155         require(released || transferAgents[_sender]);
156         _;
157     }
158 
159     modifier inReleaseState(bool releaseState) {
160         require(releaseState == released);
161         _;
162     }
163 
164     modifier onlyReleaseAgent() {
165         require(msg.sender == releaseAgent);
166         _;
167     }
168 
169     function setReleaseAgent(address addr) public onlyOwner inReleaseState(false) {
170         ReleaseAgentSet(addr);
171         releaseAgent = addr;
172     }
173 
174     function setTransferAgent(address addr, bool state) public onlyOwner inReleaseState(false) {
175         TransferAgentSet(addr, state);
176         transferAgents[addr] = state;
177     }
178     
179     function releaseTokenTransfer() public onlyReleaseAgent {
180         Released();
181         released = true;
182     }
183 
184     function transfer(address _to, 
185                       uint _value) public canTransfer(msg.sender) returns (bool success) {
186         return super.transfer(_to, _value);
187     }
188 
189     function transferFrom(address _from, 
190                           address _to, 
191                           uint _value) public canTransfer(_from) returns (bool success) {
192         return super.transferFrom(_from, _to, _value);
193     }
194 }
195 
196 
197 contract TruMintableToken is ReleasableToken {
198     
199     using SafeMath for uint256;
200     using SafeMath for uint;
201 
202     bool public mintingFinished = false;
203 
204     bool public preSaleComplete = false;
205 
206     bool public saleComplete = false;
207 
208     event Minted(address indexed _to, uint256 _amount);
209 
210     event MintFinished(address indexed _executor);
211     
212     event PreSaleComplete(address indexed _executor);
213 
214     event SaleComplete(address indexed _executor);
215 
216     modifier canMint() {
217         require(!mintingFinished);
218         _;
219     }
220 
221     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
222         require(_amount > 0);
223         require(_to != address(0));
224         totalSupply = totalSupply.add(_amount);
225         balances[_to] = balances[_to].add(_amount);
226         Minted(_to, _amount);
227         Transfer(0x0, _to, _amount);
228         return true;
229     }
230 
231     function finishMinting(bool _presale, bool _sale) public onlyOwner returns (bool) {
232         require(_sale != _presale);
233         if (_presale == true) {
234             preSaleComplete = true;
235             PreSaleComplete(msg.sender);
236             return true;
237         }
238         require(preSaleComplete == true);
239         saleComplete = true;
240         SaleComplete(msg.sender);
241         mintingFinished = true;
242         MintFinished(msg.sender);
243         return true;
244     }
245 }
246 
247 
248 contract UpgradeAgent {
249     
250     uint public originalSupply;
251 
252     function isUpgradeAgent() public pure returns (bool) {
253         return true;
254     }
255 
256     function upgradeFrom(address _from, uint256 _value) public;
257 }
258 
259 
260 contract TruUpgradeableToken is StandardToken {
261 
262     using SafeMath for uint256;
263     using SafeMath for uint;
264 
265     address public upgradeMaster;
266 
267     UpgradeAgent public upgradeAgent;
268 
269     uint256 public totalUpgraded;
270 
271     bool private isUpgradeable = true;
272 
273     enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
274 
275     event Upgrade(address indexed from, 
276         address indexed to, 
277         uint256 upgradeValue);
278 
279     event UpgradeAgentSet(address indexed agent, 
280         address indexed executor);
281 
282     event NewUpgradedAmount(uint256 originalBalance, 
283         uint256 newBalance, 
284         address indexed executor);
285     
286     modifier onlyUpgradeMaster() {
287         require(msg.sender == upgradeMaster);
288         _;
289     }
290 
291     function TruUpgradeableToken(address _upgradeMaster) public {
292         require(_upgradeMaster != address(0));
293         upgradeMaster = _upgradeMaster;
294     }
295 
296     function upgrade(uint256 _value) public {
297         UpgradeState state = getUpgradeState();
298         require((state == UpgradeState.ReadyToUpgrade) || (state == UpgradeState.Upgrading));
299         require(_value > 0);
300         require(balances[msg.sender] >= _value);
301         uint256 upgradedAmount = totalUpgraded.add(_value);
302         uint256 senderBalance = balances[msg.sender];
303         uint256 newSenderBalance = senderBalance.sub(_value);      
304         uint256 newTotalSupply = totalSupply.sub(_value);
305         balances[msg.sender] = newSenderBalance;
306         totalSupply = newTotalSupply;        
307         NewUpgradedAmount(totalUpgraded, newTotalSupply, msg.sender);
308         totalUpgraded = upgradedAmount;
309         upgradeAgent.upgradeFrom(msg.sender, _value);
310         Upgrade(msg.sender, upgradeAgent, _value);
311     }
312 
313     function setUpgradeAgent(address _agent) public onlyUpgradeMaster {
314         require(_agent != address(0));
315         require(canUpgrade());
316         require(getUpgradeState() != UpgradeState.Upgrading);
317         UpgradeAgent newUAgent = UpgradeAgent(_agent);
318         require(newUAgent.isUpgradeAgent());
319         require(newUAgent.originalSupply() == totalSupply);
320         UpgradeAgentSet(upgradeAgent, msg.sender);
321         upgradeAgent = newUAgent;
322     }
323 
324     function getUpgradeState() public constant returns(UpgradeState) {
325         if (!canUpgrade())
326             return UpgradeState.NotAllowed;
327         else if (upgradeAgent == address(0))
328             return UpgradeState.WaitingForAgent;
329         else if (totalUpgraded == 0)
330             return UpgradeState.ReadyToUpgrade;
331         else 
332             return UpgradeState.Upgrading;
333     }
334 
335     function setUpgradeMaster(address _master) public onlyUpgradeMaster {
336         require(_master != address(0));
337         upgradeMaster = _master;
338     }
339 
340     function canUpgrade() public constant returns(bool) {
341         return isUpgradeable;
342     }
343 }
344 
345 
346 contract TruReputationToken is TruMintableToken, TruUpgradeableToken {
347 
348     using SafeMath for uint256;
349     using SafeMath for uint;
350 
351     uint8 public constant decimals = 18;
352 
353     string public constant name = "Tru Reputation Token";
354 
355     string public constant symbol = "TRU";
356 
357     address public execBoard = 0x0;
358 
359     event BoardAddressChanged(address indexed oldAddress, 
360         address indexed newAddress, 
361         address indexed executor);
362 
363     modifier onlyExecBoard() {
364         require(msg.sender == execBoard);
365         _;
366     }
367 
368     function TruReputationToken() public TruUpgradeableToken(msg.sender) {
369         execBoard = msg.sender;
370         BoardAddressChanged(0x0, msg.sender, msg.sender);
371     }
372     
373     function changeBoardAddress(address _newAddress) public onlyExecBoard {
374         require(_newAddress != address(0));
375         require(_newAddress != execBoard);
376         address oldAddress = execBoard;
377         execBoard = _newAddress;
378         BoardAddressChanged(oldAddress, _newAddress, msg.sender);
379     }
380 
381     function canUpgrade() public constant returns(bool) {
382         return released && super.canUpgrade();
383     }
384 
385     function setUpgradeMaster(address _master) public onlyOwner {
386         super.setUpgradeMaster(_master);
387     }
388 }