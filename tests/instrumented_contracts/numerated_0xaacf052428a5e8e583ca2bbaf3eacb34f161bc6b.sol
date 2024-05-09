1 pragma solidity ^0.4.13;
2 
3 contract ERC20 {
4   uint public totalSupply;
5   function balanceOf(address who) constant returns (uint);
6   function allowance(address owner, address spender) constant returns (uint);
7 
8   function transfer(address to, uint value) returns (bool ok);
9   function transferFrom(address from, address to, uint value) returns (bool ok);
10   function approve(address spender, uint value) returns (bool ok);
11   event Transfer(address indexed from, address indexed to, uint value);
12   event Approval(address indexed owner, address indexed spender, uint value);
13 }
14 
15 contract SafeMath {
16   function safeMul(uint a, uint b) internal returns (uint) {
17     uint c = a * b;
18     assert(a == 0 || c / a == b);
19     return c;
20   }
21 
22   function safeDiv(uint a, uint b) internal returns (uint) {
23     assert(b > 0);
24     uint c = a / b;
25     assert(a == b * c + a % b);
26     return c;
27   }
28 
29   function safeSub(uint a, uint b) internal returns (uint) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   function safeAdd(uint a, uint b) internal returns (uint) {
35     uint c = a + b;
36     assert(c>=a && c>=b);
37     return c;
38   }
39 
40   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
41     return a >= b ? a : b;
42   }
43 
44   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
45     return a < b ? a : b;
46   }
47 
48   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
49     return a >= b ? a : b;
50   }
51 
52   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
53     return a < b ? a : b;
54   }
55 
56 }
57 
58 contract StandardToken is ERC20, SafeMath {
59 
60   event Minted(address receiver, uint amount);
61 
62   mapping(address => uint) balances;
63 
64   mapping (address => mapping (address => uint)) allowed;
65 
66   function isToken() public constant returns (bool weAre) {
67     return true;
68   }
69 
70   function transfer(address _to, uint _value) returns (bool success) {
71     balances[msg.sender] = safeSub(balances[msg.sender], _value);
72     balances[_to] = safeAdd(balances[_to], _value);
73     Transfer(msg.sender, _to, _value);
74     return true;
75   }
76 
77   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
78     uint _allowance = allowed[_from][msg.sender];
79 
80     balances[_to] = safeAdd(balances[_to], _value);
81     balances[_from] = safeSub(balances[_from], _value);
82     allowed[_from][msg.sender] = safeSub(_allowance, _value);
83     Transfer(_from, _to, _value);
84     return true;
85   }
86 
87   function balanceOf(address _owner) constant returns (uint balance) {
88     return balances[_owner];
89   }
90 
91   function approve(address _spender, uint _value) returns (bool success) {
92 
93    require((_value == 0) || (allowed[msg.sender][_spender] == 0));
94 
95     allowed[msg.sender][_spender] = _value;
96     Approval(msg.sender, _spender, _value);
97     return true;
98   }
99 
100   function allowance(address _owner, address _spender) constant returns (uint remaining) {
101     return allowed[_owner][_spender];
102   }
103 
104 }
105 
106 contract BitBeri is StandardToken {
107 
108     string public name = "BitBeri";
109     string public symbol = "BTB";
110     uint public decimals = 18;
111 
112     
113     bool public halted = false; 
114     bool public preTge = true; 
115     bool public stageOne = false; 
116     bool public stageTwo = false; 
117     bool public stageThree = false; 
118     bool public freeze = true; 
119 
120    
121     address public founder = 0x0;
122     address public owner = 0x0;
123 
124     uint public totalTokens = 100000000000000000000000000;
125     uint public team = 5000000000000000000000000;
126     uint public bounty = 5000000000000000000000000; 
127 
128     uint public preTgeCap = 2500000000000000000000000;
129     uint public tgeCap = 50000000000000000000000000; 
130 
131     uint public presaleTokenSupply = 0; 
132     uint public presaleEtherRaised = 0; 
133     uint public preTgeTokenSupply = 0; 
134 
135     event Buy(address indexed sender, uint eth, uint fbt);
136 
137     event TokensSent(address indexed to, uint256 value);
138     event ContributionReceived(address indexed to, uint256 value);
139     event Burn(address indexed from, uint256 value);
140 
141     function BitBeri(address _founder) payable {
142         owner = msg.sender;
143         founder = _founder;
144 
145         balances[founder] = team;
146         totalTokens = safeSub(totalTokens, team);
147         totalTokens = safeSub(totalTokens, bounty);
148         totalSupply = totalTokens;
149         balances[owner] = totalSupply;
150     }
151 
152    function buy() public payable returns(bool) {
153         require(!halted);
154         require(msg.value>0);
155         
156         uint256 weiAmount = msg.value;
157         uint256 tokens = safeDiv(safeMul(weiAmount,10**17),13892747985551);
158 
159         require(balances[owner]>tokens);
160 
161         if (stageThree) {
162 			preTge = false;
163 			stageOne = false;
164 			stageTwo = false;
165         }
166 		
167         if (stageTwo) {
168 			preTge = false;
169 			stageOne = false;
170             tokens = tokens + (tokens / 10);
171         }
172 		
173         if (stageOne) {
174 			preTge = false;
175             tokens = tokens + (tokens / 5);
176         }
177 		
178         if (preTge) {
179             tokens = tokens + (tokens / 2);
180         }
181 
182         if (preTge) {
183             require(safeAdd(presaleTokenSupply, tokens) < preTgeCap);
184         } else {
185             require(safeAdd(presaleTokenSupply, tokens) < safeSub(tgeCap, preTgeTokenSupply));
186         }
187 
188         founder.transfer(msg.value);
189 
190         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
191         balances[owner] = safeSub(balances[owner], tokens);
192 
193         if (preTge) {
194             preTgeTokenSupply  = safeAdd(preTgeTokenSupply, tokens);
195         }
196         presaleTokenSupply = safeAdd(presaleTokenSupply, tokens);
197         presaleEtherRaised = safeAdd(presaleEtherRaised, msg.value);
198 
199         Buy(msg.sender, msg.value, tokens);
200 
201         TokensSent(msg.sender, tokens);
202         ContributionReceived(msg.sender, msg.value);
203         Transfer(owner, msg.sender, tokens);
204 
205         return true;
206     }
207 
208     function PreTgeEnable() onlyOwner() {
209         preTge = true;
210     }
211 
212     function PreTgeDisable() onlyOwner() {
213         preTge = false;
214     }
215 
216     function StageOneEnable() onlyOwner() {
217         stageOne = true;
218     }
219 
220     function StageOneDisable() onlyOwner() {
221         stageOne = false;
222     }
223 	
224     function StageTwoEnable() onlyOwner() {
225         stageTwo = true;
226     }
227 
228     function StageTwoDisable() onlyOwner() {
229         stageTwo = false;
230     }
231 
232     function StageThreeEnable() onlyOwner() {
233         stageThree = true;
234     }
235 
236     function StageThreeDisable() onlyOwner() {
237         stageThree = false;
238     }
239 
240     function EventEmergencyStop() onlyOwner() {
241         halted = true;
242     }
243 
244     function EventEmergencyContinue() onlyOwner() {
245         halted = false;
246     }
247 
248     function sendTeamTokens(address _to, uint256 _value) onlyOwner() {
249         balances[founder] = safeSub(balances[founder], _value);
250         balances[_to] = safeAdd(balances[_to], _value);
251         TokensSent(_to, _value);
252         Transfer(owner, _to, _value);
253     }
254 
255     function sendBounty(address _to, uint256 _value) onlyOwner() {
256         bounty = safeSub(bounty, _value);
257         balances[_to] = safeAdd(balances[_to], _value);
258         TokensSent(_to, _value);
259         Transfer(owner, _to, _value);
260     }
261 
262     function sendSupplyTokens(address _to, uint256 _value) onlyOwner() {
263         balances[owner] = safeSub(balances[owner], _value);
264         balances[_to] = safeAdd(balances[_to], _value);
265         TokensSent(_to, _value);
266         Transfer(owner, _to, _value);
267     }
268 
269 
270     function transfer(address _to, uint256 _value) isAvailable() returns (bool success) {
271         return super.transfer(_to, _value);
272     }
273 
274     function transferFrom(address _from, address _to, uint256 _value) isAvailable() returns (bool success) {
275         return super.transferFrom(_from, _to, _value);
276     }
277 
278     function burnRemainingTokens() isAvailable() onlyOwner() {
279         Burn(owner, balances[owner]);
280         balances[owner] = 0;
281     }
282 
283     modifier onlyOwner() {
284         require(msg.sender == owner);
285         _;
286     }
287 
288     modifier isAvailable() {
289         require(!halted && !freeze);
290         _;
291     }
292 
293     function() payable {
294         buy();
295     }
296 
297     function freeze() onlyOwner() {
298          freeze = true;
299     }
300 
301     function unFreeze() onlyOwner() {
302          freeze = false;
303     }
304 
305     function changeOwner(address _to) onlyOwner() {
306         balances[_to] = balances[owner];
307         balances[owner] = 0;
308         owner = _to;
309     }
310 
311     function changeFounder(address _to) onlyOwner() {
312         balances[_to] = balances[founder];
313         balances[founder] = 0;
314         founder = _to;
315     }
316 }