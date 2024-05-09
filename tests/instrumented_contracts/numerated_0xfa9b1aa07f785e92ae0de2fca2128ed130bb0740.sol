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
23 pragma solidity ^0.4.11;
24 
25 contract owned {
26 
27     address public owner;
28     address public candidate;
29 
30     function owned() public payable {
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
41         candidate = _owner;
42     }
43     
44     function confirmOwner() public {
45         require(candidate == msg.sender);
46         owner = candidate;
47         delete candidate;
48     }
49 }
50 
51 /**
52  * @title ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/20
54  */
55 contract ERC20 {
56     uint public totalSupply;
57     function balanceOf(address who) public constant returns (uint);
58     function transfer(address to, uint value) public;
59     function allowance(address owner, address spender) public constant returns (uint);
60     function transferFrom(address from, address to, uint value) public;
61     function approve(address spender, uint value) public;
62     event Approval(address indexed owner, address indexed spender, uint value);
63     event Transfer(address indexed from, address indexed to, uint value);
64 }
65 
66 contract BaseNeuroDAO {
67     struct SpecialTokenHolder {
68         uint limit;
69         bool isTeam;
70     }
71     mapping (address => SpecialTokenHolder) public specials;
72 
73     struct TokenHolder {
74         uint balance;
75         uint balanceBeforeUpdate;
76         uint balanceUpdateTime;
77     }
78     mapping (address => TokenHolder) public holders;
79 
80     function freezedBalanceOf(address _who) constant public returns(uint);
81 }
82 
83 contract ManualMigration is owned, ERC20, BaseNeuroDAO {
84 
85     uint    public freezedMoment;
86     address public original;
87 
88     modifier enabled {
89         require(original == 0);
90         _;
91     }
92     
93     function ManualMigration(address _original) payable public owned() {
94         original = _original;
95         totalSupply = ERC20(original).totalSupply();
96         holders[this].balance = ERC20(original).balanceOf(original);
97         holders[original].balance = totalSupply - holders[this].balance;
98         Transfer(this, original, holders[original].balance);
99     }
100 
101     function migrateManual(address _who) public onlyOwner {
102         require(original != 0);
103         require(holders[_who].balance == 0);
104         bool isTeam;
105         uint limit;
106         uint balance = BaseNeuroDAO(original).freezedBalanceOf(_who);
107         holders[_who].balance = balance;
108         (limit, isTeam) = BaseNeuroDAO(original).specials(_who);
109         specials[_who] = SpecialTokenHolder({limit: limit, isTeam: isTeam});
110         holders[original].balance -= balance;
111         Transfer(original, _who, balance);
112     }
113     
114     function migrateManual2(address [] _who, uint count) public onlyOwner {
115         for(uint i = 0; i < count; ++i) {
116             migrateManual(_who[i]);
117         }
118     }
119     
120     function sealManualMigration(bool force) public onlyOwner {
121         require(force || holders[original].balance == 0);
122         delete original;
123     }
124 
125     function beforeBalanceChanges(address _who) internal {
126         if (holders[_who].balanceUpdateTime <= freezedMoment) {
127             holders[_who].balanceUpdateTime = now;
128             holders[_who].balanceBeforeUpdate = holders[_who].balance;
129         }
130     }
131 }
132 
133 contract Token is ManualMigration {
134 
135     string  public standard    = 'Token 0.1';
136     string  public name        = 'NeuroDAO 3.0';
137     string  public symbol      = "NDAO";
138     uint8   public decimals    = 0;
139 
140     uint    public startTime;
141 
142     mapping (address => mapping (address => uint256)) public allowed;
143 
144     event Burned(address indexed owner, uint256 value);
145 
146     function Token(address _original, uint _startTime)
147         payable public ManualMigration(_original) {
148         startTime = _startTime;    
149     }
150 
151     function availableTokens(address _who) public constant returns (uint _avail) {
152         _avail = holders[_who].balance;
153         uint limit = specials[_who].limit;
154         if (limit != 0) {
155             uint blocked;
156             uint periods = firstYearPeriods();
157             if (specials[_who].isTeam) {
158                 if (periods != 0) {
159                     blocked = limit * (500 - periods) / 500;
160                 } else {
161                     periods = (now - startTime) / 1 years;
162                     ++periods;
163                     if (periods < 5) {
164                         blocked = limit * (100 - periods * 20) / 100;
165                     }
166                 }
167             } else {
168                 if (periods != 0) {
169                     blocked = limit * (100 - periods) / 100;
170                 }
171             }
172             if (_avail <= blocked) {
173                 _avail = 0;
174             } else {
175                 _avail -= blocked;
176             }
177         }
178     }
179     
180     function firstYearPeriods() internal constant returns (uint _periods) {
181         _periods = 0;
182         if (now < startTime + 1 years) {
183             uint8[12] memory logic = [1, 2, 3, 4, 4, 4, 5, 6, 7, 8, 9, 10];
184             _periods = logic[(now - startTime) / 28 days];
185         }
186     }
187 
188     function balanceOf(address _who) constant public returns (uint) {
189         return holders[_who].balance;
190     }
191 
192     function transfer(address _to, uint256 _value) public enabled {
193         require(availableTokens(msg.sender) >= _value);
194         require(holders[_to].balance + _value >= holders[_to].balance); // overflow
195         beforeBalanceChanges(msg.sender);
196         beforeBalanceChanges(_to);
197         holders[msg.sender].balance -= _value;
198         holders[_to].balance += _value;
199         Transfer(msg.sender, _to, _value);
200     }
201     
202     function transferFrom(address _from, address _to, uint256 _value) public enabled {
203         require(availableTokens(_from) >= _value);
204         require(holders[_to].balance + _value >= holders[_to].balance); // overflow
205         require(allowed[_from][msg.sender] >= _value);
206         beforeBalanceChanges(_from);
207         beforeBalanceChanges(_to);
208         holders[_from].balance -= _value;
209         holders[_to].balance += _value;
210         allowed[_from][msg.sender] -= _value;
211         Transfer(_from, _to, _value);
212     }
213 
214     function approve(address _spender, uint256 _value) public {
215         allowed[msg.sender][_spender] = _value;
216         Approval(msg.sender, _spender, _value);
217     }
218 
219     function allowance(address _owner, address _spender) public constant
220         returns (uint256 remaining) {
221         return allowed[_owner][_spender];
222     }
223     
224     function burn(uint256 _value) public enabled {
225         require(holders[msg.sender].balance >= _value);
226         beforeBalanceChanges(msg.sender);
227         holders[msg.sender].balance -= _value;
228         totalSupply -= _value;
229         Burned(msg.sender, _value);
230     }
231 }
232 
233 contract MigrationAgent {
234     function migrateFrom(address _from, uint256 _value) public;
235 }
236 
237 contract TokenMigration is Token {
238     
239     address public migrationAgent;
240     uint256 public totalMigrated;
241 
242     event Migrate(address indexed from, address indexed to, uint256 value);
243 
244     function TokenMigration(address _original, uint _startTime)
245         payable public Token(_original, _startTime) {}
246 
247     // Migrate _value of tokens to the new token contract
248     function migrate() external {
249         require(migrationAgent != 0);
250         uint value = holders[msg.sender].balance;
251         require(value != 0);
252         beforeBalanceChanges(msg.sender);
253         beforeBalanceChanges(this);
254         holders[msg.sender].balance -= value;
255         holders[this].balance += value;
256         totalMigrated += value;
257         MigrationAgent(migrationAgent).migrateFrom(msg.sender, value);
258         Transfer(msg.sender, this, value);
259         Migrate(msg.sender, migrationAgent, value);
260     }
261 
262     function setMigrationAgent(address _agent) external onlyOwner enabled {
263         require(migrationAgent == 0);
264         migrationAgent = _agent;
265     }
266 }
267 
268 contract NeuroDAO is TokenMigration {
269 
270     function NeuroDAO(address _original, uint _startTime)
271         payable public TokenMigration(_original, _startTime) {}
272     
273     function withdraw() public onlyOwner {
274         owner.transfer(this.balance);
275     }
276     
277     function freezeTheMoment() public onlyOwner {
278         freezedMoment = now;
279     }
280 
281     /** Get balance of _who for freezed moment
282      *  freezeTheMoment()
283      */
284     function freezedBalanceOf(address _who) constant public returns(uint) {
285         if (holders[_who].balanceUpdateTime <= freezedMoment) {
286             return holders[_who].balance;
287         } else {
288             return holders[_who].balanceBeforeUpdate;
289         }
290     }
291     
292     function killMe() public onlyOwner {
293         require(totalSupply == 0);
294         selfdestruct(owner);
295     }
296 
297     function mintTokens(uint _tokens, address _who, bool _isTeam) enabled public onlyOwner {
298         require(holders[this].balance > 0);
299         require(holders[msg.sender].balance + _tokens > holders[msg.sender].balance); // overflow
300         require(_tokens > 0);
301         beforeBalanceChanges(_who);
302         beforeBalanceChanges(this);
303         if (holders[_who].balance == 0) {
304             // set isTeam only once!
305             specials[_who].isTeam = _isTeam;
306         }
307         holders[_who].balance += _tokens;
308         specials[_who].limit += _tokens;
309         holders[this].balance -= _tokens;
310         Transfer(this, _who, _tokens);
311     }
312 }