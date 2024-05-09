1 pragma solidity ^0.4.4;
2 
3  
4 
5 //Buffer overflow implementation
6 
7 contract Math {
8 
9  
10 
11     function safeMul(uint a, uint b) internal returns (uint) {
12 
13         uint c = a * b;
14 
15         assert(a != 0 && b != 0 );
16 
17         return c;
18 
19     }
20 
21  
22 
23     function safeSub(uint a, uint b) internal returns (uint) {
24 
25         assert(b <= a);
26 
27         return a - b;
28 
29     }
30 
31  
32 
33     function safeAdd(uint a, uint b) internal returns (uint) {
34 
35         uint c = a + b;
36 
37         assert(b <= c && c >= a);
38 
39         return c;
40 
41    }
42 
43  
44 
45 }
46 
47  
48 
49 contract ERC20 {
50 
51  
52 
53     function transfer(address to, uint value) returns (bool success) {
54 
55         if (tokenOwned[msg.sender] >= value && tokenOwned[to] + value > tokenOwned[to]) {
56 
57             tokenOwned[msg.sender] -= value;
58 
59             tokenOwned[to] += value;
60 
61             Transfer(msg.sender, to, value);
62 
63             return true;
64 
65         } else { return false; }
66 
67     }
68 
69  
70 
71     function transferFrom(address from, address to, uint value) returns (bool success) {
72 
73         if (tokenOwned[from] >= value && allowed[from][msg.sender] >= value && tokenOwned[to] + value > tokenOwned[to]) {
74 
75             tokenOwned[to] += value;
76 
77             tokenOwned[from] -= value;
78 
79             allowed[from][msg.sender] -= value;
80 
81             Transfer(from, to, value);
82 
83             return true;
84 
85         } else { return false; }
86 
87     }
88 
89  
90 
91     function balanceOf(address owner) constant returns (uint balance) {
92 
93         return tokenOwned[owner];
94 
95     }
96 
97  
98 
99     function approve(address spender, uint value) returns (bool success) {
100 
101         allowed[msg.sender][spender] = value;
102 
103         Approval(msg.sender, spender, value);
104 
105         return true;
106 
107     }
108 
109  
110 
111     function allowance(address owner, address spender) constant returns (uint remaining) {
112 
113         return allowed[owner][spender];
114 
115     }
116 
117  
118 
119     event Transfer(address indexed from, address indexed to, uint value);
120 
121     event Approval(address indexed owner, address indexed spender, uint value);
122 
123  
124 
125     mapping(address => uint) internal tokenOwned; // Contract field for storing token balance owned by certain address
126 
127  
128 
129     mapping (address => mapping (address => uint)) allowed;
130 
131  
132 
133     uint public totalSupply;
134 
135  
136 
137     string public name = "BitMohar";
138 
139  
140 
141     string public symbol = "MOH";
142 
143  
144 
145     uint public decimals = 10;
146 
147  
148 
149 }
150 
151  
152 
153 //TokenDistibution contract inherits Math, ERC20 contracts, this class instatiates the token distribution process
154 
155 //This contract implements time windowed distribution of tokens, during each time window a slice of total token is distributed based emission curve
156 
157 //Once the uppercap of the slice of total tokens is reached, the contract no longer distributes the token.
158 
159 contract TokenDistribution is Math, ERC20 {
160 
161  
162 
163     //assigns owner to the contract & initilizes the number of tranches
164 
165     function TokenDistribution() {
166 
167         owner = msg.sender;
168 
169  
170 
171         totalSupply = 15000000000000000000; // Total supply of tokens with 10 decimal places
172 
173         startBlock = 4267514;
174 
175         emissionPerblock = 80; //considering 25 secs a block generation with 10 decimal places
176 
177         blocksPerYear = 10000000; //considering 25 secs a block
178 
179         preMined = 9000000000000000000;
180 
181         tokensMinted = 0;
182 
183         preMineDone = false;
184 
185  
186 
187     }
188 
189  
190 
191     function preMine() returns (bool z) {
192 
193         if(msg.sender == owner && !preMineDone) {
194 
195             tokenOwned[0x60212b87C6e106d3852890FE6e8d00db3D99d002] = 9000000000000000000;
196 
197             preMineDone = true;
198 
199             return true;
200 
201         } else {
202 
203             return false;
204 
205         }
206 
207     }
208 
209  
210 
211     function mine() returns (bool z) {
212 
213         uint blockTime = (((block.number - startBlock) / blocksPerYear) + 1);
214 
215         uint currentEmission = emissionPerblock / blockTime;
216 
217         uint emittedBlocks = startBlock;
218 
219         if(currentEmission != emissionPerblock) { //in case of halving and later time
220 
221             emittedBlocks = startBlock + (blocksPerYear * blockTime);
222 
223         }
224 
225         uint mined = 0;
226 
227         if(blockTime > 1) { //after halving
228 
229             uint prevMinted = 0;
230 
231             for (uint i = 1; i <= blockTime; i++) {
232 
233                 prevMinted += (blocksPerYear * (emissionPerblock / i));
234 
235             }
236 
237             prevMinted += (block.number - emittedBlocks) * currentEmission;
238 
239             mined = safeSub(prevMinted, tokensMinted);
240 
241         } else {
242 
243             mined = safeSub((block.number - emittedBlocks) * currentEmission, tokensMinted);
244 
245         }
246 
247  
248 
249         if(safeAdd(preMined, safeAdd(mined, tokensMinted)) > totalSupply) {
250 
251             return false;
252 
253         } else {
254 
255             tokenOwned[msg.sender] = safeAdd(tokenOwned[msg.sender], mined);
256 
257             tokensMinted = safeAdd(tokensMinted, mined);
258 
259             return true;
260 
261         }
262 
263     }
264 
265  
266 
267     function changeTotalSupply(uint _totalSupply) returns (bool x){
268 
269         if(msg.sender == owner){
270 
271             totalSupply = _totalSupply;
272 
273             return true;
274 
275         }else{
276 
277             return false;
278 
279         }
280 
281     }
282 
283  
284 
285     function additionalPreMine(uint _supply) returns (bool x){
286 
287         if(msg.sender == owner){
288 
289             tokenOwned[msg.sender] = safeAdd(tokenOwned[msg.sender], _supply);
290 
291             return true;
292 
293         }else{
294 
295             return false;
296 
297         }
298 
299     }
300 
301  
302 
303     address owner;
304 
305     mapping (address => uint) internal etherSent; // Contract field for storing how much Ether was sent from certain address
306 
307     uint startBlock;
308 
309     uint emissionPerblock; //considering 25 secs a block generation with 10 decimal places
310 
311     uint blocksPerYear; //considering 25 secs a block
312 
313     uint preMined;
314 
315     uint tokensMinted;
316 
317     bool preMineDone;
318 
319 }