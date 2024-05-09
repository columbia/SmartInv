1 pragma solidity ^ 0.4 .11;
2 
3 
4 
5 contract tokenRecipient {
6 
7     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
8 
9 }
10 
11 
12 
13 
14 
15 contract ERC20 {
16 
17 
18 
19     function totalSupply() constant returns(uint _totalSupply);
20 
21 
22 
23     function balanceOf(address who) constant returns(uint256);
24 
25 
26 
27     function transfer(address to, uint value) returns(bool ok);
28 
29 
30 
31     function transferFrom(address from, address to, uint value) returns(bool ok);
32 
33 
34 
35     function approve(address spender, uint value) returns(bool ok);
36 
37 
38 
39     function allowance(address owner, address spender) constant returns(uint);
40 
41     event Transfer(address indexed from, address indexed to, uint value);
42 
43     event Approval(address indexed owner, address indexed spender, uint value);
44 
45 
46 
47 }
48 
49 
50 
51 
52 
53  
54 
55 contract BlockVentureCoin is ERC20 {
56 
57 
58 
59 
60 
61     string public standard = 'BVC 1.1';
62 
63     string public name;
64 
65     string public symbol;
66 
67     uint8 public decimals;
68 
69     uint256 public totalSupply;
70 
71     
72 
73     
74 
75     
76 
77    
78 
79     mapping( address => uint256) public balanceOf;
80 
81     mapping( uint => address) public accountIndex;
82 
83     uint accountCount;
84 
85     
86 
87     mapping(address => mapping(address => uint256)) public allowance;
88 
89    
90 
91     
92 
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95     event Approval(address indexed _owner, address indexed spender, uint value);
96 
97     event Message ( address a, uint256 amount );
98 
99     event Burn(address indexed from, uint256 value);
100 
101 
102 
103 
104 
105    
106 
107     
108 
109     function BlockVentureCoin() {
110 
111          
112 
113         uint supply = 10000000000000000; 
114 
115         appendTokenHolders( msg.sender );
116 
117         balanceOf[msg.sender] =  supply;
118 
119         totalSupply = supply; 
120 
121         name = "BlockVentureCoin"; 
122 
123         symbol = "BVC"; 
124 
125         decimals = 8; 
126 
127        
128 
129  
130 
131         
132 
133   
134 
135     }
136 
137     
138 
139   
140 
141   
142 
143     function balanceOf(address tokenHolder) constant returns(uint256) {
144 
145 
146 
147         return balanceOf[tokenHolder];
148 
149     }
150 
151 
152 
153     function totalSupply() constant returns(uint256) {
154 
155 
156 
157         return totalSupply;
158 
159     }
160 
161 
162 
163     function getAccountCount() constant returns(uint256) {
164 
165 
166 
167         return accountCount;
168 
169     }
170 
171 
172 
173     function getAddress(uint slot) constant returns(address) {
174 
175 
176 
177         return accountIndex[slot];
178 
179 
180 
181     }
182 
183 
184 
185     
186 
187     function appendTokenHolders(address tokenHolder) private {
188 
189 
190 
191         if (balanceOf[tokenHolder] == 0) {
192 
193           
194 
195             accountIndex[accountCount] = tokenHolder;
196 
197             accountCount++;
198 
199         }
200 
201 
202 
203     }
204 
205 
206 
207     
208 
209     function transfer(address _to, uint256 _value) returns(bool ok) {
210 
211         if (_to == 0x0) throw; 
212 
213         if (balanceOf[msg.sender] < _value) throw; 
214 
215         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
216 
217         
218 
219         appendTokenHolders(_to);
220 
221         balanceOf[msg.sender] -= _value; 
222 
223         balanceOf[_to] += _value; 
224 
225         Transfer(msg.sender, _to, _value); 
226 
227     
228 
229         
230 
231         return true;
232 
233     }
234 
235     
236 
237     function approve(address _spender, uint256 _value)
238 
239     returns(bool success) {
240 
241         allowance[msg.sender][_spender] = _value;
242 
243         Approval( msg.sender ,_spender, _value);
244 
245         return true;
246 
247     }
248 
249 
250 
251  
252 
253     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
254 
255     returns(bool success) {
256 
257         tokenRecipient spender = tokenRecipient(_spender);
258 
259         if (approve(_spender, _value)) {
260 
261             spender.receiveApproval(msg.sender, _value, this, _extraData);
262 
263             return true;
264 
265         }
266 
267     }
268 
269 
270 
271     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
272 
273         return allowance[_owner][_spender];
274 
275     }
276 
277 
278 
279  
280 
281     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
282 
283         if (_to == 0x0) throw;  
284 
285         if (balanceOf[_from] < _value) throw;  
286 
287         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  
288 
289         if (_value > allowance[_from][msg.sender]) throw; 
290 
291         appendTokenHolders(_to);
292 
293         balanceOf[_from] -= _value; 
294 
295         balanceOf[_to] += _value; 
296 
297         allowance[_from][msg.sender] -= _value;
298 
299         Transfer(_from, _to, _value);
300 
301        
302 
303         return true;
304 
305     }
306 
307   
308 
309     function burn(uint256 _value) returns(bool success) {
310 
311         if (balanceOf[msg.sender] < _value) throw; 
312 
313         balanceOf[msg.sender] -= _value; 
314 
315         totalSupply -= _value; 
316 
317         Burn(msg.sender, _value);
318 
319         return true;
320 
321     }
322 
323 
324 
325     function burnFrom(address _from, uint256 _value) returns(bool success) {
326 
327     
328 
329         if (balanceOf[_from] < _value) throw; 
330 
331         if (_value > allowance[_from][msg.sender]) throw; 
332 
333         allowance[_from][msg.sender] -= _value; 
334 
335         balanceOf[_from] -= _value; 
336 
337         totalSupply -= _value; 
338 
339         Burn(_from, _value);
340 
341         return true;
342 
343     }
344 
345     
346 
347   
348 
349  
350 
351     
352 
353 }