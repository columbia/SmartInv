1 pragma solidity >=0.6.0;
2 
3 
4 contract Context {
5   
6     constructor () internal { }
7 
8     function _msgSender() internal view virtual returns (address payable) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes memory) {
13         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
14         return msg.data;
15     }
16 }
17 
18 interface IERC20 {
19    
20     function totalSupply() external view returns (uint256);
21 
22   
23     function balanceOf(address account) external view returns (uint256);
24 
25     
26     function transfer(address recipient, uint256 amount) external returns (bool);
27     function transferWithoutDeflationary(address recipient, uint256 amount) external returns (bool) ;
28    
29     function allowance(address owner, address spender) external view returns (uint256);
30 
31     
32     function approve(address spender, uint256 amount) external returns (bool);
33 
34     
35     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
36 
37     
38     event Transfer(address indexed from, address indexed to, uint256 value);
39 
40     
41     event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 
44 library SafeMath {
45    
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a, "SafeMath: addition overflow");
49 
50         return c;
51     }
52 
53    
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         return sub(a, b, "SafeMath: subtraction overflow");
56     }
57 
58     
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66    
67     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
69         // benefit is lost if 'b' is also tested.
70         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
71         if (a == 0) {
72             return 0;
73         }
74 
75         uint256 c = a * b;
76         require(c / a == b, "SafeMath: multiplication overflow");
77 
78         return c;
79     }
80 
81     
82     function div(uint256 a, uint256 b) internal pure returns (uint256) {
83         return div(a, b, "SafeMath: division by zero");
84     }
85 
86     
87     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
88         // Solidity only automatically asserts when dividing by 0
89         require(b > 0, errorMessage);
90         uint256 c = a / b;
91         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92 
93         return c;
94     }
95 
96     
97     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
98         return mod(a, b, "SafeMath: modulo by zero");
99     }
100 
101     
102     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
103         require(b != 0, errorMessage);
104         return a % b;
105     }
106 }
107 
108 contract ERC20 is Context, IERC20 {
109     using SafeMath for uint256;
110 
111     struct PoolAddress{
112         address poolReward;
113         bool isActive;
114         bool isExist;
115 
116     }
117 
118     struct WhitelistTransfer{
119         address waddress;
120         bool isActived;
121         string name;
122 
123     }
124     mapping (address => uint256) private _balances;
125 
126     mapping (address => WhitelistTransfer) public whitelistTransfer;
127 
128     mapping (address => mapping (address => uint256)) private _allowances;
129 
130     uint256 private _totalSupply;
131     address[] rewardPool;
132     mapping(address=>PoolAddress) mapRewardPool;
133    
134     address internal tokenOwner;
135     uint256 internal beginFarming;
136 
137     function addRewardPool(address add) public {
138         require(_msgSender() == tokenOwner, "ERC20: Only owner can init");
139         require(!mapRewardPool[add].isExist,"Pool already exist");
140         mapRewardPool[add].poolReward=add;
141         mapRewardPool[add].isActive=true;
142         mapRewardPool[add].isExist=true;
143         rewardPool.push(add);
144     }
145 
146     function addWhitelistTransfer(address add, string memory name) public{
147          require(_msgSender() == tokenOwner, "ERC20: Only owner can init");
148          whitelistTransfer[add].waddress=add;
149         whitelistTransfer[add].isActived=true;
150         whitelistTransfer[add].name=name;
151 
152     }
153 
154      function removeWhitelistTransfer(address add) public{
155          require(_msgSender() == tokenOwner, "ERC20: Only owner can init");
156         
157         whitelistTransfer[add].isActived=false;
158         
159 
160     }
161 
162 
163 
164     function removeRewardPool(address add) public {
165         require(_msgSender() == tokenOwner, "ERC20: Only owner can init");
166         mapRewardPool[add].isActive=false;
167        
168         
169     }
170 
171     function countActiveRewardPool() public  view returns (uint256){
172         uint length=0;
173      for(uint i=0;i<rewardPool.length;i++){
174          if(mapRewardPool[rewardPool[i]].isActive){
175              length++;
176          }
177      }
178       return  length;
179     }
180    function getRewardPool(uint index) public view  returns (address){
181     
182         return rewardPool[index];
183     }
184 
185    
186     
187     function totalSupply() public view override returns (uint256) {
188         return _totalSupply;
189     }
190 
191     
192     function balanceOf(address account) public view override returns (uint256) {
193         return _balances[account];
194     }
195 
196    
197     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
198         if(whitelistTransfer[recipient].isActived || whitelistTransfer[_msgSender()].isActived){//withdraw from exchange will not effect
199             _transferWithoutDeflationary(_msgSender(), recipient, amount);
200         }
201         else{
202             _transfer(_msgSender(), recipient, amount);
203         }
204         
205         return true;
206     }
207  function transferWithoutDeflationary(address recipient, uint256 amount) public virtual override returns (bool) {
208         _transferWithoutDeflationary(_msgSender(), recipient, amount);
209         return true;
210     }
211     
212     function allowance(address owner, address spender) public view virtual override returns (uint256) {
213         return _allowances[owner][spender];
214     }
215 
216  
217     function approve(address spender, uint256 amount) public virtual override returns (bool) {
218         _approve(_msgSender(), spender, amount);
219         return true;
220     }
221 
222  
223     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
224         _transfer(sender, recipient, amount);
225         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
226         return true;
227     }
228 
229     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
230         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
231         return true;
232     }
233 
234    
235     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
236         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
237         return true;
238     }
239 
240    
241     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
242         require(sender != address(0), "ERC20: transfer from the zero address");
243         require(recipient != address(0), "ERC20: transfer to the zero address");
244 
245         _beforeTokenTransfer(sender, recipient, amount);
246         uint256 burnAmount;
247         uint256 rewardAmount;
248          uint totalActivePool=countActiveRewardPool();
249          if (block.timestamp > beginFarming && totalActivePool>0) {
250             (burnAmount,rewardAmount)=_caculateExtractAmount(amount);
251 
252         }     
253         //div reward
254         if(rewardAmount>0){
255            
256             uint eachPoolShare=rewardAmount.div(totalActivePool);
257             for(uint i=0;i<rewardPool.length;i++){
258                  if(mapRewardPool[rewardPool[i]].isActive){
259                     _balances[rewardPool[i]] = _balances[rewardPool[i]].add(eachPoolShare);
260                     emit Transfer(sender, rewardPool[i], eachPoolShare);
261 
262                  }
263                 
264        
265             }
266         }
267 
268 
269         //burn token
270         if(burnAmount>0){
271           _burn(sender,burnAmount);
272             _balances[sender] = _balances[sender].add(burnAmount);//because sender balance already sub in burn
273 
274         }
275       
276         
277         uint256 newAmount=amount-burnAmount-rewardAmount;
278 
279         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
280       
281         _balances[recipient] = _balances[recipient].add(newAmount);
282         emit Transfer(sender, recipient, newAmount);
283 
284         
285         
286     }
287     
288  function _transferWithoutDeflationary(address sender, address recipient, uint256 amount) internal virtual {
289           require(sender != address(0), "ERC20: transfer from the zero address");
290         require(recipient != address(0), "ERC20: transfer to the zero address");
291 
292         _beforeTokenTransfer(sender, recipient, amount);
293 
294         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
295         _balances[recipient] = _balances[recipient].add(amount);
296         emit Transfer(sender, recipient, amount);
297         
298     }
299     
300     function _deploy(address account, uint256 amount,uint256 beginFarmingDate) internal virtual {
301         require(account != address(0), "ERC20: mint to the zero address");
302         tokenOwner = account;
303         beginFarming=beginFarmingDate;
304 
305         _beforeTokenTransfer(address(0), account, amount);
306 
307         _totalSupply = _totalSupply.add(amount);
308         _balances[account] = _balances[account].add(amount);
309         emit Transfer(address(0), account, amount);
310     }
311 
312     
313     function _burn(address account, uint256 amount) internal virtual {
314         require(account != address(0), "ERC20: burn from the zero address");
315 
316         _beforeTokenTransfer(account, address(0), amount);
317 
318         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
319         _totalSupply = _totalSupply.sub(amount);
320         emit Transfer(account, address(0), amount);
321     }
322 
323     
324     function _approve(address owner, address spender, uint256 amount) internal virtual {
325         require(owner != address(0), "ERC20: approve from the zero address");
326         require(spender != address(0), "ERC20: approve to the zero address");
327 
328         _allowances[owner][spender] = amount;
329         emit Approval(owner, spender, amount);
330     }
331 
332     
333     function _burnFrom(address account, uint256 amount) internal virtual {
334         _burn(account, amount);
335         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
336     }
337 
338     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
339 
340     
341     function _caculateExtractAmount(uint256 amount)
342         internal
343         
344         returns (uint256, uint256)
345     {
346        
347             uint256 extractAmount = (amount * 5) / 1000;
348 
349             uint256 burnAmount = (extractAmount * 10) / 100;
350             uint256 rewardAmount = (extractAmount * 90) / 100;
351 
352             return (burnAmount, rewardAmount);
353       
354     }
355 
356     function setBeginDeflationFarming(uint256 beginDate) public {
357         require(msg.sender == tokenOwner, "ERC20: Only owner can call");
358         beginFarming = beginDate;
359     }
360 
361     function getBeginDeflationary() public view returns (uint256) {
362         return beginFarming;
363     }
364 
365     
366 
367 }
368 
369 contract ERC20Burnable is Context, ERC20 {
370     
371     function burn(uint256 amount) public virtual {
372         _burn(_msgSender(), amount);
373     }
374 
375   
376     function burnFrom(address account, uint256 amount) public virtual {
377         _burnFrom(account, amount);
378     }
379 }
380 
381 abstract contract ERC20Detailed is IERC20 {
382     string private _name;
383     string private _symbol;
384     uint8 private _decimals;
385 
386 
387     constructor (string memory name, string memory symbol, uint8 decimals) public {
388         _name = name;
389         _symbol = symbol;
390         _decimals = decimals;
391     }
392 
393     
394     function name() public view returns (string memory) {
395         return _name;
396     }
397 
398    
399     function symbol() public view returns (string memory) {
400         return _symbol;
401     }
402 
403     
404     function decimals() public view returns (uint8) {
405         return _decimals;
406     }
407 }
408 
409 contract PolkaBridge is ERC20, ERC20Detailed, ERC20Burnable {
410     constructor(uint256 initialSupply)
411         public
412         ERC20Detailed("PolkaBridge", "PBR", 18)
413     {
414         _deploy(msg.sender, initialSupply, 1616630400); //25 Mar 2021 1616630400
415     }
416 
417     //withdraw contract token
418     //use for someone send token to contract
419     //recuse wrong user
420 
421     function withdrawErc20(IERC20 token) public {
422         token.transfer(tokenOwner, token.balanceOf(address(this)));
423     }
424 }