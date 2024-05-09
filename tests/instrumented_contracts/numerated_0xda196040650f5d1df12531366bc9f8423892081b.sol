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
93     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
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
106 contract ALLM is StandardToken {
107 
108     string public name = "ALLM";
109     string public symbol = "ALLM";
110     uint public decimals = 0;
111 
112     bool public halted = false; 
113     bool public preTge = true; 
114     bool public stageOne = false; 
115     bool public stageTwo = false;
116     bool public stageThree = false; 
117     bool public freeze = true;
118 
119     address public founder = 0xD5aD179bD7255C115Bc0Ad89D916B1FBE612975e;
120     address public owner = 0x5CE414D388cA7404a6cA6c5c2704a3a6Aa5F4a79;
121 
122     uint public totalTokens = 7000000000;
123     uint public team = 1000000000;
124     uint public bounty = 1000000000;
125 
126     uint public preTgeCap = 510000; 
127     uint public tgeCap = 5100000;
128 
129     uint public presaleTokenSupply = 0; 
130     uint public presaleEtherRaised = 0; 
131     uint public preTgeTokenSupply = 0; 
132 
133     event Buy(address indexed sender, uint eth, uint fbt);
134 
135     event TokensSent(address indexed to, uint256 value);
136     event ContributionReceived(address indexed to, uint256 value);
137     event Burn(address indexed from, uint256 value);
138 
139     function ALLM(address _founder) payable {
140         owner = msg.sender;
141         founder = _founder;
142 
143         balances[founder] = team;
144         totalTokens = safeSub(totalTokens, team);
145         totalTokens = safeSub(totalTokens, bounty);
146         totalSupply = totalTokens;
147         balances[owner] = totalSupply;
148     }
149 
150     function price() constant returns (uint){
151         return 40 szabo;
152     }
153 
154 
155     function buy() public payable returns(bool) {
156         require(!halted);
157         require(msg.value>0);
158 
159         uint tokens = msg.value / price();
160 
161         require(balances[owner]>tokens);
162 
163         if (stageThree) {
164 			preTge = false;
165 			stageOne = false;
166 			stageTwo = false;
167         }
168 		
169         if (stageTwo) {
170 			preTge = false;
171 			stageOne = false;
172             tokens = tokens + (tokens / 10);
173         }
174 		
175         if (stageOne) {
176 			preTge = false;
177             tokens = tokens + (tokens / 5);
178         }
179 		
180         if (preTge) {
181             tokens = tokens + (tokens / 2);
182         }
183 
184         if (preTge) {
185             require(safeAdd(presaleTokenSupply, tokens) < preTgeCap);
186         } else {
187             require(safeAdd(presaleTokenSupply, tokens) < safeSub(tgeCap, preTgeTokenSupply));
188         }
189 
190         founder.transfer(msg.value);
191 
192         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
193         balances[owner] = safeSub(balances[owner], tokens);
194 
195         if (preTge) {
196             preTgeTokenSupply  = safeAdd(preTgeTokenSupply, tokens);
197         }
198         presaleTokenSupply = safeAdd(presaleTokenSupply, tokens);
199         presaleEtherRaised = safeAdd(presaleEtherRaised, msg.value);
200 
201         Buy(msg.sender, msg.value, tokens);
202 
203         TokensSent(msg.sender, tokens);
204         ContributionReceived(msg.sender, msg.value);
205         Transfer(owner, msg.sender, tokens);
206 
207         return true;
208     }
209 
210     function PreTgeEnable() onlyOwner() {
211         preTge = true;
212     }
213 
214     function PreTgeDisable() onlyOwner() {
215         preTge = false;
216     }
217 
218     function StageOneEnable() onlyOwner() {
219         stageOne = true;
220     }
221 
222     function StageOneDisable() onlyOwner() {
223         stageOne = false;
224     }
225 	
226     function StageTwoEnable() onlyOwner() {
227         stageTwo = true;
228     }
229 
230     function StageTwoDisable() onlyOwner() {
231         stageTwo = false;
232     }
233 
234     function StageThreeEnable() onlyOwner() {
235         stageThree = true;
236     }
237 
238     function StageThreeDisable() onlyOwner() {
239         stageThree = false;
240     }
241 
242     function EventEmergencyStop() onlyOwner() {
243         halted = true;
244     }
245 
246     function EventEmergencyContinue() onlyOwner() {
247         halted = false;
248     }
249 
250     function sendTeamTokens(address _to, uint256 _value) onlyOwner() {
251         balances[founder] = safeSub(balances[founder], _value);
252         balances[_to] = safeAdd(balances[_to], _value);
253         TokensSent(_to, _value);
254         Transfer(owner, _to, _value);
255     }
256 
257     function sendBounty(address _to, uint256 _value) onlyOwner() {
258         bounty = safeSub(bounty, _value);
259         balances[_to] = safeAdd(balances[_to], _value);
260         TokensSent(_to, _value);
261         Transfer(owner, _to, _value);
262     }
263 
264 
265     function sendSupplyTokens(address _to, uint256 _value) onlyOwner() {
266         balances[owner] = safeSub(balances[owner], _value);
267         balances[_to] = safeAdd(balances[_to], _value);
268         TokensSent(_to, _value);
269         Transfer(owner, _to, _value);
270     }
271 
272     function transfer(address _to, uint256 _value) isAvailable() returns (bool success) {
273         return super.transfer(_to, _value);
274     }
275 
276     function transferFrom(address _from, address _to, uint256 _value) isAvailable() returns (bool success) {
277         return super.transferFrom(_from, _to, _value);
278     }
279 
280     function burnRemainingTokens() isAvailable() onlyOwner() {
281         Burn(owner, balances[owner]);
282         balances[owner] = 0;
283     }
284 
285     modifier onlyOwner() {
286         require(msg.sender == owner);
287         _;
288     }
289 
290     modifier isAvailable() {
291         require(!halted && !freeze);
292         _;
293     }
294 
295     function() payable {
296         buy();
297     }
298 
299     function freeze() onlyOwner() {
300          freeze = true;
301     }
302 
303      function unFreeze() onlyOwner() {
304          freeze = false;
305      }
306 
307     function changeOwner(address _to) onlyOwner() {
308         balances[_to] = balances[owner];
309         balances[owner] = 0;
310         owner = _to;
311     }
312 
313     function changeFounder(address _to) onlyOwner() {
314         balances[_to] = balances[founder];
315         balances[founder] = 0;
316         founder = _to;
317     }
318 }