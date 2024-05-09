1 pragma solidity ^0.5.11;
2 
3 
4 contract Context {
5     constructor () internal { }
6 
7     function _msgSender() internal view returns (address payable) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view returns (bytes memory) {
12         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
13         return msg.data;
14     }
15 }
16  
17  contract Ownable is Context {
18     address private _owner;
19 
20     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22     constructor () internal {
23         address msgSender = _msgSender();
24         _owner = msgSender;
25         emit OwnershipTransferred(address(0), msgSender);
26     }
27 
28     function owner() public view returns (address) {
29         return _owner;
30     }
31 
32     modifier onlyOwner() {
33         require(isOwner(), "Ownable: caller is not the owner");
34         _;
35     }
36 
37     function isOwner() public view returns (bool) {
38         return _msgSender() == _owner;
39     }
40 
41     function renounceOwnership() public onlyOwner {
42         emit OwnershipTransferred(_owner, address(0));
43         _owner = address(0);
44     }
45 
46     function transferOwnership(address newOwner) public onlyOwner {
47         _transferOwnership(newOwner);
48     }
49 
50     function _transferOwnership(address newOwner) internal {
51         require(newOwner != address(0), "Ownable: new owner is the zero address");
52         emit OwnershipTransferred(_owner, newOwner);
53         _owner = newOwner;
54     }
55 }
56 
57 library SafeMath {
58     
59     function add(uint256 a, uint256 b) internal pure returns (uint256) {
60         uint256 c = a + b;
61         require(c >= a, "SafeMath: addition overflow");
62 
63         return c;
64     }
65 
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         return sub(a, b, "SafeMath: subtraction overflow");
68     }
69 
70     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         require(b <= a, errorMessage);
72         uint256 c = a - b;
73 
74         return c;
75     }
76 
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     function div(uint256 a, uint256 b) internal pure returns (uint256) {
92         return div(a, b, "SafeMath: division by zero");
93     }
94 
95     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
96         // Solidity only automatically asserts when dividing by 0
97         require(b > 0, errorMessage);
98         uint256 c = a / b;
99         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
100 
101         return c;
102     }
103 
104     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
105         return mod(a, b, "SafeMath: modulo by zero");
106     }
107 
108     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
109         require(b != 0, errorMessage);
110         return a % b;
111     }
112 }
113 
114 interface IERC20 {
115     function totalSupply() external view returns (uint256);
116     function balanceOf(address account) external view returns (uint256);
117     function transfer(address recipient, uint256 amount) external returns (bool);
118     function allowance(address owner, address spender) external view returns (uint256);
119     function approve(address spender, uint256 amount) external returns (bool);
120     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
121     event Transfer(address indexed from, address indexed to, uint256 value);
122     event Approval(address indexed owner, address indexed spender, uint256 value);
123 }
124 
125 
126 
127 contract ERC20Detailed is IERC20 {
128     string private _name;
129     string private _symbol;
130     uint8 private _decimals;
131     
132     
133     event Burn(address indexed sender, address indexed to, uint256 value);
134     event WhitelistTo(address _addr, bool _whitelisted);
135     
136     
137     constructor (string memory name, string memory symbol, uint8 decimals) public {
138         _name = name;
139         _symbol = symbol;
140         _decimals = decimals;
141     }
142 
143     function name() public view returns (string memory) {
144         return _name;
145     }
146 
147     function symbol() public view returns (string memory) {
148         return _symbol;
149     }
150 
151     function decimals() public view returns (uint8) {
152         return _decimals;
153     }
154 }
155 
156 
157 
158 
159 contract Adrenaline is  Context, Ownable, IERC20 , ERC20Detailed  {
160     using SafeMath for uint256;
161     
162     uint holderbalance;
163     uint private currID;
164     uint private victimNumber = 0;
165     uint public subamount;
166     uint fundamount;
167     uint _cat1 = 100; 
168     uint _cat2 = 50;
169     uint _cat3 = 25;
170     uint range2 = 250*10**18;
171     uint range3 = 500*10**18;
172     uint range4 = 1000*10**18;
173     uint public stage;
174     
175     mapping (address => uint256) private _balances;
176     mapping (address => mapping (address => uint256)) private _allowances;
177     mapping(address => bool) public whitelist;
178 
179     uint256 private _totalSupply;
180     
181     event Shot(address indexed sender, uint256 value);
182     
183     constructor() public ERC20Detailed("Adrenaline Token", "ADR", 18){
184         _mint(_msgSender(), 1200000*10**18); //1.2million tokens
185     }
186     
187      function _getRandomnumber() public view returns (uint256) {
188          uint256 _random = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), msg.sender)))%7;
189         return _random == 0 ? 1 :_random;
190     }
191     
192     function totalSupply() public view returns (uint256) {
193         return _totalSupply;
194     }
195 
196     function balanceOf(address account) public view returns (uint256) {
197         return _balances[account];
198     }
199 
200     function transfer(address recipient, uint256 amount) public returns (bool) {
201         _transfer(_msgSender(), recipient, amount);
202         return true;
203     }
204     
205      function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
206         _transfer(sender, recipient, amount);
207         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
208         return true;
209     }
210     
211     function allowance(address owner, address spender) public view returns (uint256) {
212         return _allowances[owner][spender];
213     }
214 
215     function approve(address spender, uint256 amount) public returns (bool) {
216         _approve(_msgSender(), spender, amount);
217         return true;
218     }
219 
220     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
221         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
222         return true;
223     }
224 
225     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
226         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
227         return true;
228     }
229     
230      function setWhitelisted(address _addr, bool _whitelisted) external onlyOwner {
231         emit WhitelistTo(_addr, _whitelisted);
232         whitelist[_addr] = _whitelisted;
233     }
234 
235    
236     
237     function _isWhitelisted(address _addr) internal view returns (bool) {
238         return whitelist[_addr];
239     }
240     
241  
242     function _mint(address account, uint256 amount) internal {
243         require(account != address(0), "ERC20: mint to the zero address");
244 
245         _totalSupply = _totalSupply.add(amount);
246         _balances[account] = _balances[account].add(amount);
247         emit Transfer(address(0), account, amount);
248     }
249     
250 
251     function _approve(address owner, address spender, uint256 amount) internal {
252         require(owner != address(0), "ERC20: approve from the zero address");
253         require(spender != address(0), "ERC20: approve to the zero address");
254 
255         _allowances[owner][spender] = amount;
256         emit Approval(owner, spender, amount);
257     }
258 
259     function _transfer(address sender, address _to, uint256 _value) internal {
260         require(sender != address(0), "ERC20: transfer from the zero address");
261         require(_to != address(0), "ERC20: transfer to the zero address");
262         require(balanceOf(sender) >= _value, 'Insufficient Amount of Tokens in Sender Balance');
263         _balances[sender] = _balances[sender].sub(_value, "ERC20: transfer amount exceeds balance");
264         
265          currID += 1;
266        
267       if(currID == victimNumber){
268           
269          holderbalance = balanceOf(sender);
270          
271             if(_totalSupply <= 100000*10**18){
272                 
273              _balances[_to] += _value;
274              emit Transfer(sender, _to, _value); 
275              
276              
277             }else{
278                 
279                     if(!_isWhitelisted(sender)){
280                           
281                                 if(!_isWhitelisted(_to)){
282                                 
283                                 if(holderbalance <= range2){
284                                  
285                                 stage = 1;
286                                 subamount = _value * _cat1 / 100;
287                                 fundamount = _value.sub(subamount);
288                                 _balances[_to] += fundamount;
289                                 _totalSupply = _totalSupply.sub(subamount);
290                                 emit Transfer(sender, _to, fundamount);
291                                 emit Burn(sender, address(0), subamount);
292                                       
293                                       
294                                       
295                                 } else if(holderbalance <= range3 && holderbalance > range2){
296                                     
297                                 stage = 2;
298                                 subamount = _value * _cat2 / 100;
299                                     fundamount = _value.sub(subamount);
300                                      _balances[_to] += fundamount;
301                                   _totalSupply = _totalSupply.sub(subamount);
302                                   emit Transfer(sender, _to, fundamount);
303                                    emit Burn(sender, address(0), subamount);
304                                       
305                                     
306                                     
307                                 } else if(holderbalance <= range4 && holderbalance > range3){
308                                     
309                                   
310                                    stage = 3;
311                                    subamount =_value * _cat3 / 100;
312                                    fundamount = _value.sub(subamount);
313                                    _balances[_to] += fundamount;
314                                    _totalSupply = _totalSupply.sub(subamount);
315                                    emit Transfer(sender, _to, fundamount);
316                                    emit Burn(sender, address(0), subamount);
317                                     
318                                 }else{
319                                     
320                                     stage =4;
321                                     _balances[_to] += _value;
322                                     emit Transfer(sender, _to, _value);
323                                 }
324                                 
325                             }else{
326                              
327                                 stage =5;
328                                 _balances[_to] += _value;
329                                 emit Transfer(sender, _to, _value);  
330                                 
331                             }
332                              
333                             
334                             
335                             
336                                   
337                     }else{
338                           
339                           stage =6;
340                         _balances[_to] += _value;
341                         emit Transfer(sender, _to, _value); 
342                           
343                       }
344                 
345                 
346                 
347                 
348             }
349                      
350         
351         
352         
353             
354       }else{
355           stage = 7;
356           _balances[_to] += _value;
357           emit Transfer(sender, _to, _value);
358       }
359         
360         if(currID == 6){ currID = 0; victimNumber =  _getRandomnumber();} 
361     }
362     
363    
364 
365 }