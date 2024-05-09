1 pragma solidity 0.4.20;
2 
3 contract Owned {
4     address public owner;
5     address public pendingOwner;
6 
7     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9     function Owned() internal {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     function transferOwnership(address newOwner) public onlyOwner {
19         require(newOwner != address(0));
20         pendingOwner = newOwner;
21     }
22 
23     function acceptOwnership() public {
24         require(msg.sender == pendingOwner);
25         OwnershipTransferred(owner, pendingOwner);
26         owner = pendingOwner;
27         pendingOwner = address(0);
28     }
29 }
30 
31 // Support accounts using for change Ether price, manual migration and sending tokens during ICO, see endOfFreeze field
32 contract Support is Owned {
33     mapping (address => bool) public supportAccounts;
34 
35     event SupportAdded(address indexed _who);
36     event SupportRemoved(address indexed _who);
37 
38     modifier supportOrOwner {
39         require(msg.sender == owner || supportAccounts[msg.sender]);
40         _;
41     }
42 
43     function addSupport(address _who) public onlyOwner {
44         require(_who != address(0));
45         require(_who != owner);
46         require(!supportAccounts[_who]);
47         supportAccounts[_who] = true;
48         SupportAdded(_who);
49     }
50 
51     function removeSupport(address _who) public onlyOwner {
52         require(supportAccounts[_who]);
53         supportAccounts[_who] = false;
54         SupportRemoved(_who);
55     }
56 }
57 
58 // Math operations with safety checks that throw on error
59 library SafeMath {
60     // Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
61     function sub(uint a, uint b) internal pure returns (uint) {
62         assert(b <= a);
63         return a - b;
64     }
65 
66     // Adds two numbers, throws on overflow.
67     function add(uint a, uint b) internal pure returns (uint) {
68         uint c = a + b;
69         assert(c >= a);
70         return c;
71     }
72 }
73 
74 // ERC20 interface https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
75 contract ERC20 {
76     uint public totalSupply;
77     function balanceOf(address who) public constant returns (uint balance);
78     function allowance(address owner, address spender) public constant returns (uint remaining);
79     function transfer(address to, uint value) public returns (bool success);
80     function transferFrom(address from, address to, uint value) public returns (bool success);
81     function approve(address spender, uint value) public returns (bool success);
82 
83     event Transfer(address indexed from, address indexed to, uint value);
84     event Approval(address indexed owner, address indexed spender, uint value);
85 }
86 
87 // Interface for migration to a new contract address
88 contract MigrationAgent {
89     function migrateFrom(address _from, uint256 _value) public;
90 }
91 
92 contract AdvancedToken is ERC20, Support {
93     using SafeMath for uint;
94 
95     uint internal MAX_SUPPLY = 110000000 * 1 ether;
96     address public migrationAgent;
97 
98     mapping (address => uint) internal balances;
99 
100     enum State { Waiting, ICO, Running, Migration }
101     State public state = State.Waiting;
102 
103     event NewState(State state);
104     event Burn(address indexed from, uint256 value);
105 
106     /**
107      * The migration process to transfer tokens to the new token contract, when in the contract, a sufficiently large
108      * number of investors that the company can't cover a miner fees to transfer all tokens, this will
109      * be used in the following cases:
110      * 1. If a critical error is found in the contract
111      * 2. When will be released and approved a new standard for digital identification ERC-725 or similar
112      * @param _agent The new token contract
113      */
114     function setMigrationAgent(address _agent) public onlyOwner {
115         require(state == State.Running);
116         migrationAgent = _agent;
117     }
118 
119     // Called after setMigrationAgent function to make sure that a new contract address is valid
120     function startMigration() public onlyOwner {
121         require(migrationAgent != address(0));
122         require(state == State.Running);
123         state = State.Migration;
124         NewState(state);
125     }
126 
127     // Migration can be canceled if tokens have not yet been sent to the new contract
128     function cancelMigration() public onlyOwner {
129         require(state == State.Migration);
130         require(totalSupply == MAX_SUPPLY);
131         migrationAgent = address(0);
132         state = State.Running;
133         NewState(state);
134     }
135 
136     // Manual migration if someone has problems moving
137     function manualMigrate(address _who) public supportOrOwner {
138         require(state == State.Migration);
139         require(_who != address(this));
140         require(balances[_who] > 0);
141         uint value = balances[_who];
142         balances[_who] = balances[_who].sub(value);
143         totalSupply = totalSupply.sub(value);
144         Burn(_who, value);
145         MigrationAgent(migrationAgent).migrateFrom(_who, value);
146     }
147 
148     // Migrate the holder's tokens to a new contract and burn the holder's tokens on the current contract
149     function migrate() public {
150         require(state == State.Migration);
151         require(balances[msg.sender] > 0);
152         uint value = balances[msg.sender];
153         balances[msg.sender] = balances[msg.sender].sub(value);
154         totalSupply = totalSupply.sub(value);
155         Burn(msg.sender, value);
156         MigrationAgent(migrationAgent).migrateFrom(msg.sender, value);
157     }
158 
159     // The withdraw of Tokens from the contract after the end of ICO
160     function withdrawTokens(uint _value) public onlyOwner {
161         require(state == State.Running || state == State.Migration);
162         require(balances[address(this)] > 0 && balances[address(this)] >= _value);
163         balances[address(this)] = balances[address(this)].sub(_value);
164         balances[msg.sender] = balances[msg.sender].add(_value);
165         Transfer(address(this), msg.sender, _value);
166     }
167 
168     // The withdraw of Ether from the contract
169     function withdrawEther(uint256 _value) public onlyOwner {
170         require(this.balance >= _value);
171         owner.transfer(_value);
172     }
173 }
174 
175 contract Crowdsale is AdvancedToken {
176     uint internal endOfFreeze = 1522569600; // Sun, 01 Apr 2018 00:00:00 PST
177     uint private tokensForSalePhase2;
178     uint public tokensPerEther;
179 
180     address internal reserve = 0x4B046B05C29E535E152A3D9c8FB7540a8e15c7A6;
181 
182     function Crowdsale() internal {
183         assert(reserve != address(0));
184         tokensPerEther = 2000 * 1 ether; // Tokens ^ 18
185         totalSupply = MAX_SUPPLY;
186         uint MARKET_SHARE = 66000000 * 1 ether;
187         uint tokensSoldPhase1 = 11110257 * 1 ether;
188         tokensForSalePhase2 = MARKET_SHARE - tokensSoldPhase1;
189 
190         // Tokens for the Phase 2 are on the contract and not available to withdraw by owner during the ICO
191         balances[address(this)] = tokensForSalePhase2;
192         // Tokens for the Phase 1 are on the owner to distribution by manually processes
193         balances[owner] = totalSupply - tokensForSalePhase2;
194 
195         assert(balances[address(this)] + balances[owner] == MAX_SUPPLY);
196         Transfer(0, address(this), balances[address(this)]);
197         Transfer(0, owner, balances[owner]);
198     }
199 
200     // Setting the number of tokens to buy for 1 Ether, changes automatically by owner or support account
201     function setTokensPerEther(uint _tokens) public supportOrOwner {
202         require(state == State.ICO || state == State.Waiting);
203         require(_tokens > 100 ether); // Min 100 tokens ^ 18
204         tokensPerEther = _tokens;
205     }
206 
207     // The payable function to buy Skraps tokens
208     function () internal payable {
209         require(msg.sender != address(0));
210         require(state == State.ICO || state == State.Migration);
211         if (state == State.ICO) {
212             // The minimum ether to participate
213             require(msg.value >= 0.01 ether);
214             // Counting and sending tokens to the investor
215             uint _tokens = msg.value * tokensPerEther / 1 ether;
216             require(balances[address(this)] >= _tokens);
217             balances[address(this)] = balances[address(this)].sub(_tokens);
218             balances[msg.sender] = balances[msg.sender].add(_tokens);
219             Transfer(address(this), msg.sender, _tokens);
220 
221             // send 25% of ether received to reserve address
222             uint to_reserve = msg.value * 25 / 100;
223             reserve.transfer(to_reserve);
224         } else {
225             require(msg.value == 0);
226             migrate();
227         }
228     }
229 
230     // Start ISO manually because the block timestamp is not mean the current time
231     function startICO() public supportOrOwner {
232         require(state == State.Waiting);
233         state = State.ICO;
234         NewState(state);
235     }
236 
237     // Since a contracts can not call itself, we must manually close the ICO
238     function closeICO() public onlyOwner {
239         require(state == State.ICO);
240         state = State.Running;
241         NewState(state);
242     }
243 
244     // Anti-scam function, if the tokens are obtained by dishonest means, can be used only during ICO
245     function refundTokens(address _from, uint _value) public onlyOwner {
246         require(state == State.ICO);
247         require(balances[_from] >= _value);
248         balances[_from] = balances[_from].sub(_value);
249         balances[address(this)] = balances[address(this)].add(_value);
250         Transfer(_from, address(this), _value);
251     }
252 }
253 
254 /**
255  * Standard ERC20 implementation, see the interface above,
256  * with a small modification to block the transfer of tokens until a specific date, see endOfFreeze field
257  */
258 contract Skraps is Crowdsale {
259     using SafeMath for uint;
260 
261     string public name = "Skraps";
262     string public symbol = "SKRP";
263     uint8 public decimals = 18;
264 
265     mapping (address => mapping (address => uint)) private allowed;
266 
267     function balanceOf(address _who) public constant returns (uint) {
268         return balances[_who];
269     }
270 
271     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
272         return allowed[_owner][_spender];
273     }
274 
275     function transfer(address _to, uint _value) public returns (bool success) {
276         require(_to != address(0));
277         require(balances[msg.sender] >= _value);
278         require(now > endOfFreeze || msg.sender == owner || supportAccounts[msg.sender]);
279 
280         balances[msg.sender] = balances[msg.sender].sub(_value);
281         balances[_to] = balances[_to].add(_value);
282         Transfer(msg.sender, _to, _value);
283         return true;
284     }
285 
286     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
287         require(_to != address(0));
288         require(balances[_from] >= _value);
289         require(allowed[_from][msg.sender] >= _value);
290 
291         balances[_from] = balances[_from].sub(_value);
292         balances[_to] = balances[_to].add(_value);
293         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
294         Transfer(_from, _to, _value);
295         return true;
296     }
297 
298     function approve(address _spender, uint _value) public returns (bool success) {
299         require(balances[msg.sender] >= _value);
300         require(_spender != address(0));
301         require(now > endOfFreeze || msg.sender == owner || supportAccounts[msg.sender]);
302         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
303 
304         allowed[msg.sender][_spender] = _value;
305         Approval(msg.sender, _spender, _value);
306         return true;
307     }
308 }