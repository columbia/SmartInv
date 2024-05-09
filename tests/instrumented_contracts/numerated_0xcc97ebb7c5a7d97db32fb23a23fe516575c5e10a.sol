1 /*
2 This file is part of the NeuroDAO Contract.
3 
4 The NeuroDAO Contract is free software: you can redistribute it and/or
5 modify it under the terms of the GNU lesser General Public License as published
6 by the Free Software Foundation, either version 3 of the License, or
7 (at your option) any later version.
8 
9 The NeuroDAO Contract is distributed in the hope that it will be useful,
10 but WITHOUT ANY WARRANTY; without even the implied warranty of
11 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
12 GNU lesser General Public License for more details.
13 
14 You should have received a copy of the GNU lesser General Public License
15 along with the NeuroDAO Contract. If not, see <http://www.gnu.org/licenses/>.
16 
17 @author Ilya Svirin <i.svirin@nordavind.ru>
18 
19 IF YOU ARE ENJOYED IT DONATE TO 0x3Ad38D1060d1c350aF29685B2b8Ec3eDE527452B ! :)
20 */
21 
22 
23 pragma solidity ^0.4.0;
24 
25 contract owned {
26 
27     address public owner;
28     address public newOwner;
29 
30     function owned() payable {
31         owner = msg.sender;
32     }
33     
34     modifier onlyOwner {
35         require(owner == msg.sender);
36         _;
37     }
38 
39     function changeOwner(address _owner) onlyOwner public {
40         require(_owner != 0);
41         newOwner = _owner;
42     }
43     
44     function confirmOwner() public {
45         require(newOwner == msg.sender);
46         owner = newOwner;
47         delete newOwner;
48     }
49 }
50 
51 /**
52  * @title ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/20
54  */
55 contract ERC20 {
56     uint public totalSupply;
57     function balanceOf(address who) constant returns (uint);
58     function transfer(address to, uint value);
59     function allowance(address owner, address spender) constant returns (uint);
60     function transferFrom(address from, address to, uint value);
61     function approve(address spender, uint value);
62     event Approval(address indexed owner, address indexed spender, uint value);
63     event Transfer(address indexed from, address indexed to, uint value);
64 }
65 
66 contract ManualMigration is owned, ERC20 {
67 
68     uint    public freezedMoment;
69     address public original;
70 
71     modifier enabled {
72         require(original == 0);
73         _;
74     }
75     
76     struct SpecialTokenHolder {
77         uint limit;
78         bool isTeam;
79     }
80     mapping (address => SpecialTokenHolder) public specials;
81 
82     struct TokenHolder {
83         uint balance;
84         uint balanceBeforeUpdate;
85         uint balanceUpdateTime;
86     }
87     mapping (address => TokenHolder) public holders;
88 
89     function ManualMigration(address _original) payable owned() {
90         original = _original;
91         totalSupply = ERC20(original).totalSupply();
92         holders[this].balance = ERC20(original).balanceOf(original);
93         holders[original].balance = totalSupply - holders[this].balance;
94         Transfer(this, original, holders[original].balance);
95     }
96 
97     function migrateManual(address _who, bool _isTeam) onlyOwner {
98         require(original != 0);
99         require(holders[_who].balance == 0);
100         uint balance = ERC20(original).balanceOf(_who);
101         holders[_who].balance = balance;
102         specials[_who] = SpecialTokenHolder({limit: balance, isTeam:_isTeam});
103         holders[original].balance -= balance;
104         Transfer(original, _who, balance);
105     }
106     
107     function sealManualMigration(bool force) onlyOwner {
108         require(force || holders[original].balance == 0);
109         delete original;
110     }
111 
112     function beforeBalanceChanges(address _who) internal {
113         if (holders[_who].balanceUpdateTime <= freezedMoment) {
114             holders[_who].balanceUpdateTime = now;
115             holders[_who].balanceBeforeUpdate = holders[_who].balance;
116         }
117     }
118 }
119 
120 contract Crowdsale is ManualMigration {
121     
122     function Crowdsale(address _original) payable ManualMigration(_original) {}
123 
124     function () payable enabled {
125         require(holders[this].balance > 0);
126         uint256 tokens = 5000 * msg.value / 1000000000000000000;
127         if (tokens > holders[this].balance) {
128             tokens = holders[this].balance;
129             uint valueWei = tokens * 1000000000000000000 / 5000;
130             msg.sender.transfer(msg.value - valueWei);
131         }
132         require(holders[msg.sender].balance + tokens > holders[msg.sender].balance); // overflow
133         require(tokens > 0);
134         beforeBalanceChanges(msg.sender);
135         beforeBalanceChanges(this);
136         holders[msg.sender].balance += tokens;
137         specials[msg.sender].limit += tokens;
138         holders[this].balance -= tokens;
139         Transfer(this, msg.sender, tokens);
140     }
141 }
142 
143 contract Token is Crowdsale {
144 
145     string  public standard    = 'Token 0.1';
146     string  public name        = 'NeuroDAO';
147     string  public symbol      = "NDAO";
148     uint8   public decimals    = 0;
149 
150     uint    public startTime;
151 
152     mapping (address => mapping (address => uint256)) public allowed;
153 
154     event Burned(address indexed owner, uint256 value);
155 
156     function Token(address _original, uint _startTime)
157         payable Crowdsale(_original) {
158         startTime = _startTime;    
159     }
160 
161     function availableTokens(address _who) public constant returns (uint _avail) {
162         _avail = holders[_who].balance;
163         uint limit = specials[_who].limit;
164         if (limit != 0) {
165             uint blocked;
166             uint periods = firstYearPeriods();
167             if (specials[_who].isTeam) {
168                 if (periods != 0) {
169                     blocked = limit * (500 - periods) / 500;
170                 } else {
171                     periods = (now - startTime) / 1 years;
172                     ++periods;
173                     if (periods < 5) {
174                         blocked = limit * (100 - periods * 20) / 100;
175                     }
176                 }
177             } else {
178                 if (periods != 0) {
179                     blocked = limit * (100 - periods) / 100;
180                 }
181             }
182             _avail -= blocked;
183         }
184     }
185     
186     function firstYearPeriods() internal constant returns (uint _periods) {
187         _periods = 0;
188         if (now < startTime + 1 years) {
189             uint8[12] memory logic = [1, 2, 3, 4, 4, 4, 5, 6, 7, 8, 9, 10];
190             _periods = logic[(now - startTime) / 28 days];
191         }
192     }
193 
194     function balanceOf(address _who) constant public returns (uint) {
195         return holders[_who].balance;
196     }
197 
198     function transfer(address _to, uint256 _value) public enabled {
199         require(availableTokens(msg.sender) >= _value);
200         require(holders[_to].balance + _value >= holders[_to].balance); // overflow
201         beforeBalanceChanges(msg.sender);
202         beforeBalanceChanges(_to);
203         holders[msg.sender].balance -= _value;
204         holders[_to].balance += _value;
205         Transfer(msg.sender, _to, _value);
206     }
207     
208     function transferFrom(address _from, address _to, uint256 _value) public enabled {
209         require(availableTokens(_from) >= _value);
210         require(holders[_to].balance + _value >= holders[_to].balance); // overflow
211         require(allowed[_from][msg.sender] >= _value);
212         beforeBalanceChanges(_from);
213         beforeBalanceChanges(_to);
214         holders[_from].balance -= _value;
215         holders[_to].balance += _value;
216         allowed[_from][msg.sender] -= _value;
217         Transfer(_from, _to, _value);
218     }
219 
220     function approve(address _spender, uint256 _value) public {
221         allowed[msg.sender][_spender] = _value;
222         Approval(msg.sender, _spender, _value);
223     }
224 
225     function allowance(address _owner, address _spender) public constant
226         returns (uint256 remaining) {
227         return allowed[_owner][_spender];
228     }
229     
230     function burn(uint256 _value) public enabled {
231         require(holders[msg.sender].balance >= _value);
232         beforeBalanceChanges(msg.sender);
233         holders[msg.sender].balance -= _value;
234         totalSupply -= _value;
235         Burned(msg.sender, _value);
236     }
237 }
238 
239 contract MigrationAgent {
240     function migrateFrom(address _from, uint256 _value);
241 }
242 
243 contract TokenMigration is Token {
244     
245     address public migrationAgent;
246     uint256 public totalMigrated;
247 
248     event Migrate(address indexed from, address indexed to, uint256 value);
249 
250     function TokenMigration(address _original, uint _startTime)
251         payable Token(_original, _startTime) {}
252 
253     // Migrate _value of tokens to the new token contract
254     function migrate() external {
255         require(migrationAgent != 0);
256         uint value = holders[msg.sender].balance;
257         require(value != 0);
258         beforeBalanceChanges(msg.sender);
259         beforeBalanceChanges(this);
260         holders[msg.sender].balance -= value;
261         holders[this].balance += value;
262         totalMigrated += value;
263         MigrationAgent(migrationAgent).migrateFrom(msg.sender, value);
264         Transfer(msg.sender, this, value);
265         Migrate(msg.sender, migrationAgent, value);
266     }
267 
268     function setMigrationAgent(address _agent) external onlyOwner enabled {
269         require(migrationAgent == 0);
270         migrationAgent = _agent;
271     }
272 }
273 
274 contract NeuroDAO is TokenMigration {
275 
276     function NeuroDAO(address _original, uint _startTime)
277         payable TokenMigration(_original, _startTime) {}
278     
279     function withdraw() public onlyOwner {
280         owner.transfer(this.balance);
281     }
282     
283     function freezeTheMoment() public onlyOwner {
284         freezedMoment = now;
285     }
286 
287     /** Get balance of _who for freezed moment
288      *  freezeTheMoment()
289      */
290     function freezedBalanceOf(address _who) constant public returns(uint) {
291         if (holders[_who].balanceUpdateTime <= freezedMoment) {
292             return holders[_who].balance;
293         } else {
294             return holders[_who].balanceBeforeUpdate;
295         }
296     }
297     
298     function killMe() public onlyOwner {
299         require(totalSupply == 0);
300         selfdestruct(owner);
301     }
302 }
303 
304 contract Adapter is owned {
305     
306     address public neuroDAO;
307     address public erc20contract;
308     address public masterHolder;
309     
310     mapping (address => bool) public alreadyUsed;
311     
312     function Adapter(address _neuroDAO, address _erc20contract, address _masterHolder)
313         payable owned() {
314         neuroDAO = _neuroDAO;
315         erc20contract = _erc20contract;
316         masterHolder = _masterHolder;
317     }
318     
319     function killMe() public onlyOwner {
320         selfdestruct(owner);
321     }
322  
323     /**
324      * Move tokens int erc20contract to NDAO tokens holder
325      * 
326      * # Freeze balances in NeuroDAO smartcontract by calling freezeTheMoment() function.
327      * # Allow transferFrom masterHolder in ERC20 smartcontract by calling approve() function
328      *   from masterHolder address, gives this contract address as spender parameter.
329      * # ERC20 smartcontract must have enougth tokens on masterHolder balance.
330      */
331     function giveMeTokens() public {
332         require(!alreadyUsed[msg.sender]);
333         uint balance = NeuroDAO(neuroDAO).freezedBalanceOf(msg.sender);
334         ERC20(erc20contract).transferFrom(masterHolder, msg.sender, balance);
335         alreadyUsed[msg.sender] = true;
336     }
337 }