1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         require(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         require(b > 0);
16         uint256 c = a / b;
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         require(b <= a);
22         uint256 c = a - b;
23         return c;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a);
29         return c;
30     }
31 
32     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
33         require(b != 0);
34         return a % b;
35     }
36 }
37 
38 contract Ownable {
39     address public owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     modifier onlyOwner() {
44         require(msg.sender == owner);
45         _;
46     }
47 
48     function transferOwnership(address newOwner) public onlyOwner {
49         require(newOwner != address(0));
50         emit OwnershipTransferred(owner, newOwner);
51         owner = newOwner;
52     }
53 
54     function renounceOwnership() public onlyOwner {
55         emit OwnershipTransferred(owner, address(0));
56         owner = address(0);
57     }
58 }
59 
60 contract Pausable is Ownable {
61     bool public paused;
62     
63     event Paused(address account);
64     event Unpaused(address account);
65 
66     constructor() internal {
67         paused = false;
68     }
69 
70     modifier whenNotPaused() {
71         require(!paused);
72         _;
73     }
74 
75     modifier whenPaused() {
76         require(paused);
77         _;
78     }
79 
80     function pause() public onlyOwner whenNotPaused {
81         paused = true;
82         emit Paused(msg.sender);
83     }
84 
85     function unpause() public onlyOwner whenPaused {
86         paused = false;
87         emit Unpaused(msg.sender);
88     }
89 }
90 
91 contract BaseToken is Pausable {
92     using SafeMath for uint256;
93 
94     string public name;
95     string public symbol;
96     uint8 public decimals;
97     uint256 public totalSupply;
98     uint256 public _totalLimit;
99 
100     mapping (address => uint256) public balanceOf;
101     mapping (address => mapping (address => uint256)) public allowance;
102 
103     event Transfer(address indexed from, address indexed to, uint256 value);
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 
106     function _transfer(address from, address to, uint value) internal {
107         require(to != address(0));
108         balanceOf[from] = balanceOf[from].sub(value);
109         balanceOf[to] = balanceOf[to].add(value);
110         emit Transfer(from, to, value);
111     }
112 
113     function _mint(address account, uint256 value) internal {
114         require(account != address(0));
115         totalSupply = totalSupply.add(value);
116         require(_totalLimit >= totalSupply);
117         balanceOf[account] = balanceOf[account].add(value);
118         emit Transfer(address(0), account, value);
119     }
120 
121     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
122         _transfer(msg.sender, to, value);
123         return true;
124     }
125 
126     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
127         allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
128         _transfer(from, to, value);
129         return true;
130     }
131 
132     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
133         require(spender != address(0));
134         allowance[msg.sender][spender] = value;
135         emit Approval(msg.sender, spender, value);
136         return true;
137     }
138 
139     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
140         require(spender != address(0));
141         allowance[msg.sender][spender] = allowance[msg.sender][spender].add(addedValue);
142         emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
143         return true;
144     }
145 
146     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
147         require(spender != address(0));
148         allowance[msg.sender][spender] = allowance[msg.sender][spender].sub(subtractedValue);
149         emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
150         return true;
151     }
152 }
153 
154 contract BurnToken is BaseToken {
155     event Burn(address indexed from, uint256 value);
156 
157     function burn(uint256 value) public whenNotPaused returns (bool) {
158         balanceOf[msg.sender] = balanceOf[msg.sender].sub(value);
159         totalSupply = totalSupply.sub(value);
160         emit Burn(msg.sender, value);
161         return true;
162     }
163 
164     function burnFrom(address from, uint256 value) public whenNotPaused returns (bool) {
165         allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
166         balanceOf[from] = balanceOf[from].sub(value);
167         totalSupply = totalSupply.sub(value);
168         emit Burn(from, value);
169         return true;
170     }
171 }
172 
173 contract BatchToken is BaseToken {
174     
175     function batchTransfer(address[] addressList, uint256[] amountList) public returns (bool) {
176         uint256 length = addressList.length;
177         require(addressList.length == amountList.length);
178         require(length > 0 && length <= 20);
179 
180         for (uint256 i = 0; i < length; i++) {
181             transfer(addressList[i], amountList[i]);
182         }
183 
184         return true;
185     }
186 }
187 
188 contract LockToken is BaseToken {
189 
190     struct LockItem {
191         uint256 endtime;
192         uint256 remain;
193     }
194 
195     struct LockMeta {
196         uint8 lockType;
197         LockItem[] lockItems;
198     }
199 
200     mapping (address => LockMeta) public lockData;
201 
202     event Lock(address indexed lockAddress, uint8 indexed lockType, uint256[] endtimeList, uint256[] remainList);
203 
204     function _transfer(address from, address to, uint value) internal {
205         uint8 lockType = lockData[from].lockType;
206         if (lockType != 0) {
207             uint256 remain = balanceOf[from].sub(value);
208             uint256 length = lockData[from].lockItems.length;
209             for (uint256 i = 0; i < length; i++) {
210                 LockItem storage item = lockData[from].lockItems[i];
211                 if (block.timestamp < item.endtime && remain < item.remain) {
212                     revert();
213                 }
214             }
215         }
216         super._transfer(from, to, value);
217     }
218 
219     function lock(address lockAddress, uint8 lockType, uint256[] endtimeList, uint256[] remainList) public onlyOwner returns (bool) {
220         require(lockAddress != address(0));
221         require(lockType == 0 || lockType == 1 || lockType == 2);
222         require(lockData[lockAddress].lockType != 1);
223 
224         lockData[lockAddress].lockItems.length = 0;
225 
226         lockData[lockAddress].lockType = lockType;
227         if (lockType == 0) {
228             emit Lock(lockAddress, lockType, endtimeList, remainList);
229             return true;
230         }
231 
232         require(endtimeList.length == remainList.length);
233         uint256 length = endtimeList.length;
234         require(length > 0 && length <= 12);
235         uint256 thisEndtime = endtimeList[0];
236         uint256 thisRemain = remainList[0];
237         lockData[lockAddress].lockItems.push(LockItem({endtime: thisEndtime, remain: thisRemain}));
238         for (uint256 i = 1; i < length; i++) {
239             require(endtimeList[i] > thisEndtime && remainList[i] < thisRemain);
240             lockData[lockAddress].lockItems.push(LockItem({endtime: endtimeList[i], remain: remainList[i]}));
241             thisEndtime = endtimeList[i];
242             thisRemain = remainList[i];
243         }
244 
245         emit Lock(lockAddress, lockType, endtimeList, remainList);
246         return true;
247     }
248 }
249 
250 contract MintToken is BaseToken {
251     uint256 public mintMax;
252     uint256 public mintTotal;
253     uint256 public mintBegintime;
254     uint256 public mintPerday;
255 
256     event Mint(address indexed to, uint256 value);
257 
258     function mint(address to, uint256 value) public onlyOwner returns (bool) {
259         require(block.timestamp >= mintBegintime);
260         require(value > 0);
261 
262         if (mintPerday > 0) {
263             uint256 currentMax = (block.timestamp - mintBegintime).mul(mintPerday) / (3600 * 24);
264             uint256 leave = currentMax.sub(mintTotal);
265             require(leave >= value);
266         }
267 
268         mintTotal = mintTotal.add(value);
269         if (mintMax > 0 && mintTotal > mintMax) {
270             revert();
271         }
272 
273         _mint(to, value);
274         emit Mint(to, value);
275         return true;
276     }
277 
278     function mintToMax(address to) public onlyOwner returns (bool) {
279         require(block.timestamp >= mintBegintime);
280         require(mintMax > 0);
281 
282         uint256 value;
283         if (mintPerday > 0) {
284             uint256 currentMax = (block.timestamp - mintBegintime).mul(mintPerday) / (3600 * 24);
285             value = currentMax.sub(mintTotal);
286             uint256 leave = mintMax.sub(mintTotal);
287             if (value > leave) {
288                 value = leave;
289             }
290         } else {
291             value = mintMax.sub(mintTotal);
292         }
293 
294         require(value > 0);
295         mintTotal = mintTotal.add(value);
296         _mint(to, value);
297         emit Mint(to, value);
298         return true;
299     }
300 }
301 
302 contract CustomToken is BaseToken, BurnToken, BatchToken, LockToken, MintToken {
303     constructor() public {
304         name = '华夏全球通证';
305         symbol = 'HXT';
306         decimals = 18;
307         totalSupply = 999999999999000000000000000000;
308         _totalLimit = 100000000000000000000000000000000;
309         balanceOf[0xbCADE28d8C2F22345165f0e07C94A600f6C4e925] = totalSupply;
310         emit Transfer(address(0), 0xbCADE28d8C2F22345165f0e07C94A600f6C4e925, totalSupply);
311 
312         owner = 0xbCADE28d8C2F22345165f0e07C94A600f6C4e925;
313 
314         mintMax = 0;
315         mintBegintime = 1544381539;
316         mintPerday = 0;
317     }
318 }