1 pragma solidity ^0.6.2;
2 
3 library Address {
4 
5     function isContract(address account) internal view returns (bool) {
6 
7         bytes32 codehash;
8         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
9         assembly { codehash := extcodehash(account) }
10         return (codehash != accountHash && codehash != 0x0);
11     }
12 
13     function sendValue(address payable recipient, uint256 amount) internal {
14         require(address(this).balance >= amount, "Address: insufficient balance");
15 
16         (bool success, ) = recipient.call{ value: amount }("");
17         require(success, "Address: unable to send value, recipient may have reverted");
18     }
19 
20     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
21       return functionCall(target, data, "Address: low-level call failed");
22     }
23 
24     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
25         return _functionCallWithValue(target, data, 0, errorMessage);
26     }
27 
28     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
29         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
30     }
31 
32     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
33         require(address(this).balance >= value, "Address: insufficient balance for call");
34         return _functionCallWithValue(target, data, value, errorMessage);
35     }
36 
37     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
38         require(isContract(target), "Address: call to non-contract");
39 
40         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
41         if (success) {
42             return returndata;
43         } else {
44             if (returndata.length > 0) {
45                 assembly {
46                     let returndata_size := mload(returndata)
47                     revert(add(32, returndata), returndata_size)
48                 }
49             } else {
50                 revert(errorMessage);
51             }
52         }
53     }
54 }
55 
56 pragma solidity ^0.6.0;
57 
58 abstract contract Context {
59     function _msgSender() internal view virtual returns (address payable) {
60         return msg.sender;
61     }
62 
63     function _msgData() internal view virtual returns (bytes memory) {
64         this;
65         return msg.data;
66     }
67 }
68 
69 interface IERC20 {
70     
71     function totalSupply() external view returns (uint256);
72 
73     function balanceOf(address account) external view returns (uint256);
74 
75     function transfer(address recipient, uint256 amount) external returns (bool);
76 
77     function allowance(address owner, address spender) external view returns (uint256);
78     
79     function approve(address spender, uint256 amount) external returns (bool);
80 
81     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
82 
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 library SafeMath {
89    
90     function add(uint256 a, uint256 b) internal pure returns (uint256) {
91         uint256 c = a + b;
92         require(c >= a, "SafeMath: addition overflow");
93 
94         return c;
95     }
96 
97     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98         return sub(a, b, "SafeMath: subtraction overflow");
99     }
100   
101     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
102         require(b <= a, errorMessage);
103         uint256 c = a - b;
104 
105         return c;
106     }
107 
108     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
109         
110         if (a == 0) {
111             return 0;
112         }
113 
114         uint256 c = a * b;
115         require(c / a == b, "SafeMath: multiplication overflow");
116 
117         return c;
118     }
119   
120     function div(uint256 a, uint256 b) internal pure returns (uint256) {
121         return div(a, b, "SafeMath: division by zero");
122     }
123 
124     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
125         require(b > 0, errorMessage);
126         uint256 c = a / b;
127         return c;
128     }
129 
130     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
131         return mod(a, b, "SafeMath: modulo by zero");
132     }
133 
134     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b != 0, errorMessage);
136         return a % b;
137     }
138 
139     function toInt256Safe(uint256 a) internal pure returns (int256) {
140     int256 b = int256(a);
141     require(b >= 0);
142     return b;
143   }
144 }
145 
146 
147 library SignedSafeMath {
148     int256 constant private _INT256_MIN = -2**255;
149 
150     function mul(int256 a, int256 b) internal pure returns (int256) {
151         if (a == 0) {
152             return 0;
153         }
154 
155         require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");
156 
157         int256 c = a * b;
158         require(c / a == b, "SignedSafeMath: multiplication overflow");
159 
160         return c;
161     }
162 
163     function div(int256 a, int256 b) internal pure returns (int256) {
164         require(b != 0, "SignedSafeMath: division by zero");
165         require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");
166 
167         int256 c = a / b;
168 
169         return c;
170     }
171 
172     function sub(int256 a, int256 b) internal pure returns (int256) {
173         int256 c = a - b;
174         require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
175 
176         return c;
177     }
178 
179     function add(int256 a, int256 b) internal pure returns (int256) {
180         int256 c = a + b;
181         require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
182 
183         return c; 
184     }
185 
186     function toUint256Safe(int256 a) internal pure returns (uint256) {
187         require(a >= 0);
188         return uint256(a);
189   }
190 }
191 
192 
193 contract Halloween is Context, IERC20 {
194     using SafeMath for uint256;
195     using SignedSafeMath for int256;
196     using Address for address;
197 
198     
199 
200     uint256 private _totalSupply;
201 
202     string private _name;
203     string private _symbol;
204     uint8 private _decimals;
205     address private _owner;
206 
207     IERC20 public pumpkin;
208     uint256 public totalPumpkinRewards;
209     uint256 constant internal multiplier = 2**64;
210     uint256 public pumpkinMultiple;
211     uint256 public lastPumpkinBalance;
212     address private pumpkinSetter;
213     
214 	mapping(address => int256) public correctionPumpkin;
215 	mapping(address => uint256) public withdrawnPumpkin;
216 	
217 	mapping (address => uint256) private _balances;
218 
219     mapping (address => mapping (address => uint256)) private _allowances;
220     
221     event PumpkinWithdrawn(address indexed user, uint256 amount);
222     event Transfer(address indexed from, address indexed to, uint256 value);
223     event Approval(address indexed owner, address indexed spender, uint256 value);
224 
225     constructor () public {
226         _name = "Halloween.finance";
227         _symbol = "HALLOWEEN";
228         _decimals = 18;
229         pumpkinMultiple = multiplier;
230         uint256 supply = 13000 ether;
231         _mint(msg.sender, supply);
232         pumpkinSetter = msg.sender;
233 
234     }
235 
236     function name() public view returns (string memory) {
237         return _name;
238     }
239 
240     function symbol() public view returns (string memory) {
241         return _symbol;
242     }
243 
244     function decimals() public view returns (uint8) {
245         return _decimals;
246     }
247 
248     function totalSupply() public view override returns (uint256) {
249         return _totalSupply;
250     }
251 
252     function balanceOf(address account) public view override returns (uint256) {
253         return _balances[account];
254     }
255 
256     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
257         _transfer(_msgSender(), recipient, amount);
258         return true;
259     }
260 
261     function allowance(address owner, address spender) public view virtual override returns (uint256) {
262         return _allowances[owner][spender];
263     }
264 
265     function approve(address spender, uint256 amount) public virtual override returns (bool) {
266         _approve(_msgSender(), spender, amount);
267         return true;
268     }
269 
270     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
271         _transfer(sender, recipient, amount);
272         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
273         return true;
274     }
275 
276     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
277         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
278         return true;
279     }
280 
281     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
282         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
283         return true;
284     }
285 
286     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
287         require(sender != address(0), "ERC20: transfer from the zero address");
288         require(recipient != address(0), "ERC20: transfer to the zero address");
289         require(amount >= 1000000, "ERC20: minimum transfer is 1.000.000 wei");
290         updateHalloweenRewards();
291         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
292         _balances[recipient] = _balances[recipient].add(amount);
293         		correctionPumpkin[sender] = correctionPumpkin[sender]
294 			.add( (pumpkinMultiple.mul(amount)).toInt256Safe() );
295 		correctionPumpkin[recipient] = correctionPumpkin[recipient]
296 			.sub( (pumpkinMultiple.mul(amount)).toInt256Safe() );
297         emit Transfer(sender, recipient, amount);
298     }
299 
300     function _approve(address owner, address spender, uint256 amount) internal virtual {
301         require(owner != address(0), "ERC20: approve from the zero address");
302         require(spender != address(0), "ERC20: approve to the zero address");
303 
304         _allowances[owner][spender] = amount;
305         emit Approval(owner, spender, amount);
306     }
307     
308     function _mint(address account, uint256 amount) internal virtual {
309         require(account != address(0), "ERC20: mint to the zero address");
310 
311         _totalSupply = _totalSupply.add(amount);
312         _balances[account] = _balances[account].add(amount);
313         correctionPumpkin[account] = correctionPumpkin[account]
314 			.sub( (pumpkinMultiple.mul(amount)).toInt256Safe() );
315         emit Transfer(address(0), account, amount);
316     }
317 
318 
319 
320     function setPumpkinAddress(address _pumpkinAddress) public {
321         require(msg.sender == pumpkinSetter);
322         pumpkin = IERC20(_pumpkinAddress);
323     }
324  
325     function updateHalloweenRewards() internal {
326         
327         if( getBalancePumpkin() > lastPumpkinBalance) {
328         uint256 difference = getBalancePumpkin().sub(lastPumpkinBalance);
329 		uint256 updateReward = difference.mul(multiplier).div(totalSupply());
330 
331 		pumpkinMultiple = pumpkinMultiple.add(updateReward);
332 		}
333     }
334     
335     function getBalancePumpkin() public view returns (uint256) {
336 		return pumpkin.balanceOf(address(this));
337 	}
338 	
339 	function getPumpkinReward() public {
340 	    
341 	    updateHalloweenRewards();
342 	    uint256 amount = withdrawablePumpkin(msg.sender);
343 	    withdrawnPumpkin[msg.sender] = withdrawnPumpkin[msg.sender].add(amount);
344         totalPumpkinRewards = totalPumpkinRewards.add(amount);
345 	    require(pumpkin.transfer(msg.sender, amount));
346 	    lastPumpkinBalance = getBalancePumpkin();
347 	    emit PumpkinWithdrawn(msg.sender, amount);
348 	}
349 
350 	function withdrawablePumpkin(address user) internal view returns(uint256) {
351 		return accumulativePumpkin(user).sub(withdrawnPumpkin[user]);
352 	}
353 	
354 	function accumulativePumpkin(address _user) internal view returns(uint256) {
355 		return (pumpkinMultiple.mul(balanceOf(_user)).toInt256Safe()
356 			.add(correctionPumpkin[_user]).toUint256Safe()).div(multiplier);
357 	}
358 	
359 }