1 pragma solidity 0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal constant returns (uint256) {
11         uint256 c = a / b;
12         return c;
13     }
14 
15     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19 
20     function add(uint256 a, uint256 b) internal constant returns (uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 
27 contract Ownable {
28     address public owner;
29     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31     function Ownable() public {
32         owner = msg.sender;
33     }
34 
35     modifier onlyOwner() {
36         require(msg.sender == owner);
37         _;
38     }
39 
40     function transferOwnership(address newOwner) onlyOwner public {
41         require(newOwner != address(0));
42         OwnershipTransferred(owner, newOwner);
43         owner = newOwner;
44     }
45 }
46 
47 contract ERC20 {
48     uint256 public totalSupply;
49     function balanceOf(address who) public constant returns (uint256);
50     function transfer(address to, uint256 value) public returns (bool);
51     event Transfer(address indexed from, address indexed to, uint256 value);
52 
53     function allowance(address owner, address spender) public constant returns (uint256);
54     function transferFrom(address from, address to, uint256 value) public returns (bool);
55     function approve(address spender, uint256 value) public returns (bool);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 contract StandardToken is ERC20 {
60     using SafeMath for uint256;
61 
62     mapping (address => uint256) balances;
63     mapping (address => mapping (address => uint256)) allowed;
64 
65     function transfer(address _to, uint256 _value) public returns (bool) {
66         require(_to != address(0));
67         require(_value > 0);
68 
69         balances[msg.sender] = balances[msg.sender].sub(_value);
70         balances[_to] = balances[_to].add(_value);
71         Transfer(msg.sender, _to, _value);
72         return true;
73     }
74 
75     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
76         require(_from != address(0));
77         require(_to != address(0));
78 
79         uint256 _allowance = allowed[_from][msg.sender];
80 
81         balances[_from] = balances[_from].sub(_value);
82         balances[_to] = balances[_to].add(_value);
83         allowed[_from][msg.sender] = _allowance.sub(_value);
84         Transfer(_from, _to, _value);
85         return true;
86     }
87 
88     function balanceOf(address _owner) public constant returns (uint256 balance) {
89         return balances[_owner];
90     }
91 
92     function approve(address _spender, uint256 _value) public returns (bool) {
93         allowed[msg.sender][_spender] = _value;
94         Approval(msg.sender, _spender, _value);
95         return true;
96     }
97 
98     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
99         return allowed[_owner][_spender];
100     }
101 }
102 
103 contract EIForceCoin is StandardToken, Ownable {
104 
105     string public name = " EIForceCoin ";
106     string public symbol = "EFT";
107     uint public decimals = 18;
108 
109     // The token allocation
110     uint public constant TOTAL_SUPPLY       = 1000000000e18;
111     uint public constant ALLOC_FOUNDER    =  1000000000e18; // 100%
112 
113 
114     // wallets
115     address public constant WALLET_FOUNDER    = 0x4aDE23e2dc751527b16289c18c7E26fE4dF7a4B7; 
116     
117     
118     // 2 groups of lockup
119     mapping(address => uint256) public jishis_locked; 
120     mapping(address => uint256) public simus_locked;
121     mapping(address => uint256) public jiedians_locked;
122     mapping(address => uint256) public dakehus_locked;
123 
124     // 2 types of releasing
125     mapping(address => uint256) public jishis_jishiDate;
126     mapping(address => uint256) public simus_simuDate;
127     mapping(address => uint256) public jiedians_jiedianDate;
128     mapping(address => uint256) public dakehus_dakehuDate;
129 
130     // MODIFIER
131 
132     // checks if the address can transfer certain amount of tokens
133     modifier canTransfer(address _sender, uint256 _value) {
134         require(_sender != address(0));
135 
136         uint256 remaining = balances[_sender].sub(_value);
137         uint256 totalLockAmt = 0;
138 
139         if (jishis_locked[_sender] > 0) {
140             totalLockAmt = totalLockAmt.add(getLockedAmount_jishis(_sender));
141         }
142 
143         if (simus_locked[_sender] > 0) {
144             totalLockAmt = totalLockAmt.add(getLockedAmount_simus(_sender));
145         }
146 
147   		if (simus_locked[_sender] > 0) {
148             totalLockAmt = totalLockAmt.add(getLockedAmount_jiedians(_sender));
149         }
150 
151  		 if (simus_locked[_sender] > 0) {
152             totalLockAmt = totalLockAmt.add(getLockedAmount_dakehus(_sender));
153         }
154         require(remaining >= totalLockAmt);
155 
156         _;
157     }
158 
159     // EVENTS
160     event UpdatedLockingState(string whom, address indexed to, uint256 value, uint256 date);
161 
162     // FUNCTIONS
163 
164     function EIForceCoin () public {
165         balances[msg.sender] = TOTAL_SUPPLY;
166         totalSupply = TOTAL_SUPPLY;
167 
168         // do the distribution of the token, in token transfer
169         transfer(WALLET_FOUNDER, ALLOC_FOUNDER);
170     }
171 	
172     // get jishis' locked amount of token
173     function getLockedAmount_jishis(address _jishi) 
174         public
175 		constant
176 		returns (uint256)
177 	{
178         uint256 jishiDate = jishis_jishiDate[_jishi];
179         uint256 lockedAmt = jishis_locked[_jishi];
180 
181         if (now <= jishiDate + (30 * 1 days)) {return lockedAmt;}
182         if (now <= jishiDate + (30 * 2 days)) {return lockedAmt.mul(4).div(5);}
183         if (now <= jishiDate + (30 * 3 days)) {return lockedAmt.mul(3).div(5);}
184         if (now <= jishiDate + (30 * 4 days)) {return lockedAmt.mul(2).div(5);}
185         if (now <= jishiDate + (30 * 5 days)) {return lockedAmt.mul(1).div(5);}
186      
187 	
188         return 0;
189     }
190 
191     // get simus' locked amount of token
192       function getLockedAmount_simus(address _simu)
193         public
194 		constant
195 		returns (uint256)
196 	{
197         uint256 simuDate = simus_simuDate[_simu];
198         uint256 lockedAmt = simus_locked[_simu];
199 
200         if (now <= simuDate + (30 * 1 days)) {return lockedAmt;}
201         if (now <= simuDate + (30 * 2 days)) {return lockedAmt.mul(9).div(10);}
202         if (now <= simuDate + (30 * 3 days)) {return lockedAmt.mul(8).div(10);}
203         if (now <= simuDate + (30 * 4 days)) {return lockedAmt.mul(7).div(10);}
204         if (now <= simuDate + (30 * 5 days)) {return lockedAmt.mul(6).div(10);}
205         if (now <= simuDate + (30 * 6 days)) {return lockedAmt.mul(5).div(10);}
206         if (now <= simuDate + (30 * 7 days)) {return lockedAmt.mul(4).div(10);}
207         if (now <= simuDate + (30 * 8 days)) {return lockedAmt.mul(3).div(10);}
208         if (now <= simuDate + (30 * 9 days)) {return lockedAmt.mul(2).div(10);}
209         if (now <= simuDate + (30 * 10 days)) {return lockedAmt.mul(1).div(10);}
210 	
211         return 0;
212     }
213 
214     function getLockedAmount_jiedians(address _jiedian)
215         public
216 		constant
217 		returns (uint256)
218 	{
219         uint256 jiedianDate = jiedians_jiedianDate[_jiedian];
220         uint256 lockedAmt = jiedians_locked[_jiedian];
221 
222         if (now <= jiedianDate + (30 * 1 days)) {return lockedAmt;}
223         if (now <= jiedianDate + (30 * 2 days)){return lockedAmt.mul(11).div(12);}
224         if (now <= jiedianDate + (30 * 3 days)) {return lockedAmt.mul(10).div(12);}
225         if (now <= jiedianDate + (30 * 4 days)) {return lockedAmt.mul(9).div(12);}
226         if (now <= jiedianDate + (30 * 5 days)) {return lockedAmt.mul(8).div(12);}
227         if (now <= jiedianDate + (30 * 6 days)) {return lockedAmt.mul(7).div(12);}
228         if (now <= jiedianDate + (30 * 7 days)) {return lockedAmt.mul(6).div(12);}
229         if (now <= jiedianDate + (30 * 8 days)) {return lockedAmt.mul(5).div(12);}
230         if (now <= jiedianDate + (30 * 9 days)) {return lockedAmt.mul(4).div(12);}
231         if (now <= jiedianDate + (30 * 10 days)) {return lockedAmt.mul(3).div(12);}
232         if (now <= jiedianDate + (30 * 11 days)) {return lockedAmt.mul(2).div(12);}
233         if (now <= jiedianDate + (30 * 12 days)) {return lockedAmt.mul(1).div(12);}
234 	
235         return 0;
236     }
237 
238     function getLockedAmount_dakehus(address _dakehu)
239         public
240 		constant
241 		returns (uint256)
242 	{
243         uint256 dakehuDate = dakehus_dakehuDate[_dakehu];
244         uint256 lockedAmt = dakehus_locked[_dakehu];
245 
246         if (now <= dakehuDate + (30 * 1 days)) {return lockedAmt;}
247         if (now <= dakehuDate + (30 * 2 days)) {return lockedAmt.mul(23).div(24);}
248         if (now <= dakehuDate + (30 * 3 days)) {return lockedAmt.mul(22).div(24);}
249         if (now <= dakehuDate + (30 * 4 days)) {return lockedAmt.mul(21).div(24);}
250         if (now <= dakehuDate + (30 * 5 days)) {return lockedAmt.mul(20).div(24);}
251         if (now <= dakehuDate + (30 * 6 days)) {return lockedAmt.mul(19).div(24);}
252         if (now <= dakehuDate + (30 * 7 days)) {return lockedAmt.mul(18).div(24);}
253         if (now <= dakehuDate + (30 * 8 days)) {return lockedAmt.mul(17).div(24);}
254         if (now <= dakehuDate + (30 * 9 days)) {return lockedAmt.mul(16).div(24);}
255         if (now <= dakehuDate + (30 * 10 days)) {return lockedAmt.mul(15).div(24);}
256         if (now <= dakehuDate + (30 * 11 days)) {return lockedAmt.mul(14).div(24);}
257         if (now <= dakehuDate + (30 * 12 days)) {return lockedAmt.mul(13).div(24);}
258         if (now <= dakehuDate + (30 * 13 days)) {return lockedAmt.mul(12).div(24);}
259         if (now <= dakehuDate + (30 * 14 days)) {return lockedAmt.mul(11).div(24);}
260         if (now <= dakehuDate + (30 * 15 days)) {return lockedAmt.mul(10).div(24);}
261         if (now <= dakehuDate + (30 * 16 days)) {return lockedAmt.mul(9).div(24);}
262         if (now <= dakehuDate + (30 * 17 days)) {return lockedAmt.mul(8).div(24);}
263         if (now <= dakehuDate + (30 * 18 days)) {return lockedAmt.mul(7).div(24);}
264         if (now <= dakehuDate + (30 * 19 days)) {return lockedAmt.mul(6).div(24);}
265         if (now <= dakehuDate + (30 * 20 days)) {return lockedAmt.mul(5).div(24);}
266         if (now <= dakehuDate + (30 * 21 days)) {return lockedAmt.mul(4).div(24);}
267         if (now <= dakehuDate + (30 * 22 days)) {return lockedAmt.mul(3).div(24);}
268         if (now <= dakehuDate + (30 * 23 days)) {return lockedAmt.mul(2).div(24);}
269         if (now <= dakehuDate + (30 * 24 days)) {return lockedAmt.mul(1).div(24);}
270 
271 	
272         return 0;
273     }
274 
275 
276     // set lockup for jishis 
277     function setLockup_jishis(address _jishi, uint256 _value, uint256 _jishiDate)
278         public
279         onlyOwner
280     {
281         require(_jishi != address(0));
282 
283         jishis_locked[_jishi] = _value;
284         jishis_jishiDate[_jishi] = _jishiDate;
285         UpdatedLockingState("jishi", _jishi, _value, _jishiDate);
286     }
287 
288     // set lockup for strategic simu
289     function setLockup_simus(address _simu, uint256 _value, uint256 _simuDate)
290         public
291         onlyOwner
292     {
293         require(_simu != address(0));
294 
295         simus_locked[_simu] = _value;
296         simus_simuDate[_simu] = _simuDate;
297         UpdatedLockingState("simu", _simu, _value, _simuDate);
298     }
299 
300     function setLockup_jiedians(address _jiedian, uint256 _value, uint256 _jiedianDate)
301         public
302         onlyOwner
303     {
304         require(_jiedian != address(0));
305 
306         jiedians_locked[_jiedian] = _value;
307         jiedians_jiedianDate[_jiedian] = _jiedianDate;
308         UpdatedLockingState("jiedian", _jiedian, _value, _jiedianDate);
309     }
310 
311     function setLockup_dakehus(address _dakehu, uint256 _value, uint256 _dakehuDate)
312         public
313         onlyOwner
314     {
315         require(_dakehu != address(0));
316 
317         dakehus_locked[_dakehu] = _value;
318         dakehus_dakehuDate[_dakehu] = _dakehuDate;
319         UpdatedLockingState("dakehu", _dakehu, _value, _dakehuDate);
320     }
321 
322 
323 	// Transfer amount of tokens from sender account to recipient.
324     function transfer(address _to, uint _value)
325         public
326         canTransfer(msg.sender, _value)
327 		returns (bool success)
328 	{
329         return super.transfer(_to, _value);
330     }
331 
332 	// Transfer amount of tokens from a specified address to a recipient.
333     function transferFrom(address _from, address _to, uint _value)
334         public
335         canTransfer(_from, _value)
336 		returns (bool success)
337 	{
338         return super.transferFrom(_from, _to, _value);
339     }
340 }