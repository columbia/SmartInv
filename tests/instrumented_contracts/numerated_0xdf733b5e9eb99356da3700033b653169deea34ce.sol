1 pragma solidity ^0.4.16;
2 
3 contract ERC20Interface {
4     function totalSupply() 
5         public 
6         constant 
7         returns (uint256);
8 
9     function balanceOf(
10         address _address) 
11         public 
12         constant 
13         returns (uint256 balance);
14 
15     function allowance(
16         address _address, 
17         address _to)
18         public 
19         constant 
20         returns (uint256 remaining);
21 
22     function transfer(
23         address _to, 
24         uint256 _value) 
25         public 
26         returns (bool success);
27 
28     function approve(
29         address _to, 
30         uint256 _value) 
31         public 
32         returns (bool success);
33 
34     function transferFrom(
35         address _from, 
36         address _to, 
37         uint256 _value) 
38         public 
39         returns (bool success);
40 
41     event Transfer(
42         address indexed _from, 
43         address indexed _to, 
44         uint256 _value
45     );
46 
47     event Approval(
48         address indexed _from, 
49         address indexed _to, 
50         uint256 _value
51     );
52 }
53 
54 
55 contract Owned {
56     address owner;
57     address newOwner;
58     uint32 transferCount;    
59 
60     event TransferOwnership(
61         address indexed _from, 
62         address indexed _to
63     );
64 
65     constructor() public {
66         owner = msg.sender;
67         transferCount = 0;
68     }
69 
70     modifier onlyOwner {
71         require(msg.sender == owner);
72         _;
73     }
74 
75     function transferOwnership(
76         address _newOwner) 
77         public 
78         onlyOwner 
79     {
80         newOwner = _newOwner;
81     }
82 
83     function viewOwner()
84         public
85         view
86         returns (address)
87     {
88         return owner;
89     }
90 
91     function viewTransferCount()
92         public
93         view
94         onlyOwner
95         returns (uint32)
96     {
97         return transferCount;
98     }
99 
100     function isTransferPending() 
101         public
102         view
103         returns (bool) {
104         require(
105             msg.sender == owner || 
106             msg.sender == newOwner);
107         return newOwner != address(0);
108     }
109 
110     function acceptOwnership()
111          public 
112     {
113         require(msg.sender == newOwner);
114 
115         owner = newOwner;
116         newOwner = address(0);
117         transferCount++;
118 
119         emit TransferOwnership(
120             owner, 
121             newOwner
122         );
123     }
124 }
125 
126 library SafeMath {
127     function add(
128         uint256 a, 
129         uint256 b)
130         internal 
131         pure 
132         returns(uint256 c) 
133     {
134         c = a + b;
135         require(c >= a);
136     }
137 
138     function sub(
139         uint256 a, 
140         uint256 b)
141         internal 
142         pure 
143         returns(uint256 c) 
144     {
145         require(b <= a);
146         c = a - b;
147     }
148 
149     function mul(
150         uint256 a, 
151         uint256 b) 
152         internal 
153         pure 
154         returns(uint256 c) {
155         c = a * b;
156         require(a == 0 || c / a == b);
157     }
158 
159     function div(
160         uint256 a, 
161         uint256 b) 
162         internal 
163         pure 
164         returns(uint256 c) {
165         require(b > 0);
166         c = a / b;
167     }
168 }
169 
170 contract ApproveAndCallFallBack {
171     function receiveApproval(
172         address _from, 
173         uint256 _value, 
174         address token, 
175         bytes data) 
176         public
177         returns (bool success);
178 }
179 
180 contract Token is ERC20Interface, Owned {
181     using SafeMath for uint256;
182 
183     string public symbol;
184     string public name;
185     uint8 public decimals;
186     uint256 public totalSupply;
187 
188     mapping(address => uint256) balances;
189     mapping(address => mapping(address => uint256)) allowed;
190     mapping(address => uint256) incomes;
191     mapping(address => uint256) expenses; 
192 
193     constructor(
194         uint256 _totalSupply,
195         string _name,
196         string _symbol,
197         uint8 _decimals) 
198         public 
199     {
200         symbol = _symbol;
201         name = _name;
202         decimals = _decimals;
203         totalSupply = _totalSupply * 10**uint256(_decimals);
204         balances[owner] = totalSupply;
205 
206         emit Transfer(address(0), owner, totalSupply);
207     }
208 
209     function totalSupply()
210         public
211         constant
212         returns (uint256)
213     {
214         return totalSupply;
215     }
216 
217     function _transfer(
218         address _from, 
219         address _to, 
220         uint256 _value) 
221         internal 
222         returns (bool success)
223     {
224         require (_to != 0x0);
225         require (balances[_from] >= _value);
226 
227         balances[_from] = balances[_from].sub(_value);  
228         balances[_to] = balances[_to].add(_value);   
229 
230         incomes[_to] = incomes[_to].add(_value);
231         expenses[_from] = expenses[_from].add(_value);
232 
233         emit Transfer(_from, _to, _value);
234 
235         return true;
236     }
237 
238     function transfer(
239         address _to, 
240         uint256 _value) 
241         public 
242         returns (bool success) 
243     {
244         return _transfer(msg.sender, _to, _value);
245     }
246 
247     function approve(
248         address _spender, 
249         uint256 _value) 
250         public 
251         returns (bool success) 
252     {
253         require (_spender != 0x0);
254 
255         allowed[msg.sender][_spender] = _value;
256 
257         emit Approval(msg.sender, _spender, _value);
258 
259         return true;
260     }
261 
262     function transferFrom(
263         address _from, 
264         address _to, 
265         uint256 _value) 
266         public 
267         returns (bool success) 
268     {
269         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
270         return _transfer(_from, _to, _value);
271     }
272 
273     function balanceOf(
274         address _address) 
275         public 
276         constant 
277         returns (uint256 remaining) 
278     {
279         require(_address != 0x0);
280 
281         return balances[_address];
282     }
283 
284     function incomeOf(
285         address _address) 
286         public 
287         constant 
288         returns (uint256 income) 
289     {
290         require(_address != 0x0);
291 
292         return incomes[_address];
293     }
294 
295     function expenseOf(
296         address _address) 
297         public 
298         constant 
299         returns (uint256 expense) 
300     {
301         require(_address != 0x0);
302 
303         return expenses[_address];
304     }
305 
306     function allowance(
307         address _from, 
308         address _to) 
309         public 
310         constant 
311         returns (uint256 remaining) 
312     {
313         require(_from != 0x0);
314         require(_to != 0x0);
315         require(_from == msg.sender || _to == msg.sender);
316 
317         return allowed[_from][_to];
318     }
319 
320 
321     function approveAndCall(
322         address _spender, 
323         uint256 _value, 
324         bytes _data) 
325         public 
326         returns (bool success) 
327     {
328         if (approve(_spender, _value)) {
329             require(ApproveAndCallFallBack(_spender).receiveApproval(msg.sender, _value, this, _data) == true);
330             return true;
331         }
332         return false;
333     }
334 
335     function () public payable {
336         revert();
337     }
338 }