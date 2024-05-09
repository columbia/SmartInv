1 pragma solidity ^0.5.1;
2 
3 library SafeMath {
4   
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9 
10         uint256 c = a * b;
11         require(c / a == b);
12 
13         return c;
14     }
15 
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         require(b > 0);
19         uint256 c = a / b;
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         require(b <= a);
25         uint256 c = a - b;
26 
27         return c;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a);
33         return c;
34     }
35 
36     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b != 0);
38         return a % b;
39     }
40 }
41 
42 contract Ownable {
43     
44     address public owner = address(0);
45     bool public stoped  = false;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48     event Stoped(address setter ,bool newValue);
49 
50     modifier onlyOwner() {
51         require(msg.sender == owner);
52         _;
53     }
54 
55     modifier whenNotStoped() {
56         require(!stoped);
57         _;
58     }
59 
60     function setStoped(bool _needStoped) public onlyOwner {
61         require(stoped != _needStoped);
62         stoped = _needStoped;
63         emit Stoped(msg.sender,_needStoped);
64     }
65 
66 
67     function renounceOwnership() public onlyOwner {
68         emit OwnershipTransferred(owner, address(0));
69         owner = address(0);
70     }
71 
72     function transferOwnership(address newOwner) public onlyOwner {
73         _transferOwnership(newOwner);
74     }
75 
76     function _transferOwnership(address newOwner) internal {
77         require(newOwner != address(0));
78         emit OwnershipTransferred(owner, newOwner);
79         owner = newOwner;
80     }
81 }
82 
83 contract Cmoable is Ownable {
84     address public cmo = address(0);
85 
86     event CmoshipTransferred(address indexed previousCmo, address indexed newCmo);
87 
88     modifier onlyCmo() {
89         require(msg.sender == cmo);
90         _;
91     }
92 
93     function renounceCmoship() public onlyOwner {
94         emit CmoshipTransferred(cmo, address(0));
95         owner = address(0);
96     }
97 
98     function transferCmoship(address newCmo) public onlyOwner {
99         _transferCmoship(newCmo);
100     }
101 
102     function _transferCmoship(address newCmo) internal {
103         require(newCmo != address(0));
104         emit CmoshipTransferred(cmo, newCmo);
105         cmo = newCmo;
106     }
107 }
108 
109 
110 contract BaseToken is Ownable, Cmoable {
111 
112     using SafeMath for uint256;
113 
114     string public name;
115     string public symbol;
116     uint8  public decimals;
117     uint256 public totalSupply;
118     uint256 public initedSupply = 0;
119 
120     mapping (address => uint256) public balanceOf;
121     mapping (address => mapping (address => uint256)) public allowance;
122 
123     event Transfer(address indexed from, address indexed to, uint256 value);
124     event Approval(address indexed owner, address indexed spender, uint256 value);
125 
126     modifier onlyOwnerOrCmo() {
127         require(msg.sender == cmo || msg.sender == owner);
128         _;
129     }
130 
131     function _transfer(address _from, address _to, uint256 _value) internal whenNotStoped {
132         require(_to != address(0x0));
133         require(balanceOf[_from] >= _value);
134         require(balanceOf[_to] + _value > balanceOf[_to]);
135         uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
136         balanceOf[_from] = balanceOf[_from].sub(_value);
137         balanceOf[_to] = balanceOf[_to].add(_value);
138         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
139         emit Transfer(_from, _to, _value);
140     }
141     
142     function _approve(address _spender, uint256 _value) internal whenNotStoped returns (bool success) {
143         allowance[msg.sender][_spender] = _value;
144         emit Approval(msg.sender, _spender, _value);
145         return true;
146     }
147 
148     function transfer(address _to, uint256 _value) public returns (bool success) {
149         _transfer(msg.sender, _to, _value);
150         return true;
151     }
152 
153     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
154         require(_value <= allowance[_from][msg.sender]);
155         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
156         _transfer(_from, _to, _value);
157         return true;
158     }
159     
160     function approve(address _spender, uint256 _value) public returns (bool success) {
161         return _approve(_spender, _value);
162     }
163 }
164 
165 
166 contract BurnToken is BaseToken {
167     uint256 public burnSupply = 0;
168     event Burn(address indexed from, uint256 value);
169 
170     function _burn(address _from, uint256 _value) internal whenNotStoped returns(bool success) {
171         require(balanceOf[_from] >= _value);
172         balanceOf[_from] = balanceOf[_from].sub(_value);
173         totalSupply = totalSupply.sub(_value);
174         burnSupply  = burnSupply.add(_value);
175         emit Burn(_from, _value);
176         return true;        
177     }
178 
179     function burn(uint256 _value) public returns (bool success) {
180         return _burn(msg.sender,_value);
181     }
182 
183     function burnFrom(address _from, uint256 _value) public returns (bool success) {
184         require(_value <= allowance[_from][msg.sender]);
185         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
186         return _burn(_from,_value);
187     }
188 }
189 
190 
191 
192 
193 
194  
195 contract LockToken is BaseToken {
196     struct LockMeta {
197         uint256 amount;
198         uint256 endtime;
199         bool    deleted;
200     }
201 
202     // 0 删除 1 静态 2 动态
203     event Locked(uint32 indexed _type, address indexed _who, uint256 _amounts, uint256 _endtimes);
204     event Released(uint32 indexed _type, address indexed _who, uint256 _amounts);
205     //  0 静态 1 动态 2 总的
206     mapping (address => mapping(uint32 => uint256)) public lockedAmount;
207      // 0 静态 1 动态
208     mapping (address => mapping(uint32 => LockMeta[])) public lockedDetail;
209 
210     function _transfer(address _from, address _to, uint _value) internal {
211         require(balanceOf[_from] >= _value + lockedAmount[_from][2]);
212         super._transfer(_from, _to, _value);
213     }
214 
215     function lockRelease() public whenNotStoped {
216         
217         require(lockedAmount[msg.sender][3] != 0);
218 
219         uint256 fronzed_released = 0;
220         uint256 dynamic_released = 0;
221 
222         if ( lockedAmount[msg.sender][0] != 0 )
223         {
224             for (uint256 i = 0; i < lockedDetail[msg.sender][0].length; i++) {
225 
226                 LockMeta storage _meta = lockedDetail[msg.sender][0][i];
227                 if ( !_meta.deleted && _meta.endtime <= now)
228                 {
229                     _meta.deleted = true;
230                     fronzed_released = fronzed_released.add(_meta.amount);
231                     emit Released(1, msg.sender, _meta.amount);
232                 }
233             }
234         }
235 
236         if ( lockedAmount[msg.sender][1] != 0 )
237         {
238             for (uint256 i = 0; i < lockedDetail[msg.sender][1].length; i++) {
239 
240                 LockMeta storage _meta = lockedDetail[msg.sender][0][i];
241                 if ( !_meta.deleted && _meta.endtime <= now)
242                 {
243                     _meta.deleted = true;
244                     dynamic_released = dynamic_released.add(_meta.amount);
245                     emit Released(2, msg.sender, _meta.amount);
246                     
247                 }
248             }
249         }
250 
251         if ( fronzed_released > 0 || dynamic_released > 0 ) {
252             lockedAmount[msg.sender][0] = lockedAmount[msg.sender][0].sub(fronzed_released);
253             lockedAmount[msg.sender][1] = lockedAmount[msg.sender][1].sub(dynamic_released);
254             lockedAmount[msg.sender][2] = lockedAmount[msg.sender][2].sub(dynamic_released).sub(fronzed_released);
255         }
256     }
257 
258     // type = 0 删除 1 静态  2 动态
259     function lock(uint32 _type, address _who, uint256[] memory _amounts, uint256[] memory _endtimes) public  onlyOwnerOrCmo {
260         require(_amounts.length == _endtimes.length);
261 
262         uint256 _total;
263 
264         if ( _type == 2 ) {
265             if ( lockedDetail[_who][1].length > 0 )
266             {
267                 emit Locked(0, _who, lockedAmount[_who][1], 0);
268                 delete lockedDetail[_who][1];
269             }
270 
271             for (uint256 i = 0; i < _amounts.length; i++) {
272                 _total = _total.add(_amounts[i]);
273                 lockedDetail[_who][1].push(LockMeta({
274                     amount: _amounts[i],
275                     endtime: _endtimes[i],
276                     deleted:false
277                 }));
278                 emit Locked(2, _who, _amounts[i], _endtimes[i]);
279             }
280             lockedAmount[_who][1] = _total;
281             lockedAmount[_who][2] = lockedAmount[_who][0].add(_total);
282             return;
283         }
284 
285 
286         if ( _type == 1 ) {
287             if ( lockedDetail[_who][0].length > 0 )
288             {
289                 revert();
290             }
291 
292             for (uint256 i = 0; i < _amounts.length; i++) {
293                 _total = _total.add(_amounts[i]);
294                 lockedDetail[_who][0].push(LockMeta({
295                     amount: _amounts[i],
296                     endtime: _endtimes[i],
297                     deleted:false
298                 }));
299                 emit Locked(1, _who, _amounts[i], _endtimes[i]);
300             }
301             lockedAmount[_who][0] = _total;
302             lockedAmount[_who][2] = lockedAmount[_who][1].add(_total);
303             return;
304         }
305 
306         if ( _type == 0 ) {
307             lockedAmount[_who][2] = lockedAmount[_who][2].sub(lockedAmount[_who][1]);
308             emit Locked(0, _who, lockedAmount[_who][1], 0);
309             delete lockedDetail[_who][1];
310             
311         }
312     }
313 }
314 
315 contract Proxyable is BaseToken,BurnToken{
316 
317     mapping (address => bool) public disabledProxyList;
318 
319     function enableProxy() public whenNotStoped {
320 
321         disabledProxyList[msg.sender] = false;
322     }
323 
324     function disableProxy() public whenNotStoped{
325         disabledProxyList[msg.sender] = true;
326     }
327 
328     function proxyBurnFrom(address _from, uint256 _value) public  onlyOwnerOrCmo returns (bool success) {
329         
330         require(!disabledProxyList[_from]);
331         super._burn(_from, _value);
332         return true;
333     }
334 
335     function proxyTransferFrom(address _from, address _to, uint256 _value) public onlyOwnerOrCmo returns (bool success) {
336         
337         require(!disabledProxyList[_from]);
338         super._transfer(_from, _to, _value);
339         return true;
340     }
341 
342   
343 }
344 
345  
346 
347 contract CustomToken is BaseToken,BurnToken,LockToken,Proxyable {
348 
349     constructor() public {
350         
351   
352         totalSupply  = 2000000000000000000000000000;
353         initedSupply = 2000000000000000000000000000;
354         name = 'Lionex Coin';
355         symbol = 'LIN';
356         decimals = 18;
357         balanceOf[0x441ca6D0Ae6567a128570DEA2a573A01e4f71e42] = 2000000000000000000000000000;
358         emit Transfer(address(0), 0x441ca6D0Ae6567a128570DEA2a573A01e4f71e42, 2000000000000000000000000000);
359 
360         // 管理者
361         owner = 0xbC8e1AcA830A37646cEDEb14c7158F3F1529C909;
362         cmo   = 0xA3A2B7d2Cb75D53FfAF710824a51a4B3cF30e9D1;
363         
364 
365 
366 
367 
368     }
369 
370 }