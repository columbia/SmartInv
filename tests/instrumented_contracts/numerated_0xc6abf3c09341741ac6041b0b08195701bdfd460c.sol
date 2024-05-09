1 pragma solidity 0.4.24;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6         if (a == 0) {
7             return 0;
8         }
9         c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a / b;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24         c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 contract Ownable {
31     address public owner;
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34     constructor() public {
35         owner = msg.sender;
36     }
37 
38     modifier onlyOwner() {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     function transferOwnership(address newOwner) public onlyOwner {
44         require(newOwner != address(0));
45         emit OwnershipTransferred(owner, newOwner);
46         owner = newOwner;
47     }
48 
49 }
50 
51 contract ERC20Basic {
52     function totalSupply() public view returns (uint256);
53     function balanceOf(address who) public view returns (uint256);
54     function transfer(address to, uint256 value) public returns (bool);
55     event Transfer(address indexed from, address indexed to, uint256 value);
56 }
57 
58 contract ERC20 is ERC20Basic {
59     function allowance(address owner, address spender) public view returns (uint256);
60     function transferFrom(address from, address to, uint256 value) public returns (bool);
61     function approve(address spender, uint256 value) public returns (bool);
62     event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
64 
65 contract BasicToken is ERC20Basic {
66     using SafeMath for uint256;
67 
68     mapping(address => uint256) balances;
69 
70     uint256 totalSupply_;
71 
72     function totalSupply() public view returns (uint256) {
73         return totalSupply_;
74     }
75 
76     function transfer(address _to, uint256 _value) public returns (bool) {
77         require(_to != address(0));
78         require(_value <= balances[msg.sender]);
79 
80         balances[msg.sender] = balances[msg.sender].sub(_value);
81         balances[_to] = balances[_to].add(_value);
82         emit Transfer(msg.sender, _to, _value);
83         return true;
84     }
85 
86     function balanceOf(address _owner) public view returns (uint256) {
87         return balances[_owner];
88     }
89 
90 }
91 
92 contract StandardToken is ERC20, BasicToken {
93 
94     mapping (address => mapping (address => uint256)) internal allowed;
95 
96     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
97         require(_to != address(0));
98         require(_value <= balances[_from]);
99         require(_value <= allowed[_from][msg.sender]);
100 
101         balances[_from] = balances[_from].sub(_value);
102         balances[_to] = balances[_to].add(_value);
103         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
104         emit Transfer(_from, _to, _value);
105         return true;
106     }
107 
108     function approve(address _spender, uint256 _value) public returns (bool) {
109         allowed[msg.sender][_spender] = _value;
110         emit Approval(msg.sender, _spender, _value);
111         return true;
112     }
113 
114     function allowance(address _owner, address _spender) public view returns (uint256) {
115         return allowed[_owner][_spender];
116     }
117 
118     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
119         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
120         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
121         return true;
122     }
123 
124     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
125         uint oldValue = allowed[msg.sender][_spender];
126         if (_subtractedValue > oldValue) {
127             allowed[msg.sender][_spender] = 0;
128         } else {
129             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
130         }
131         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
132         return true;
133     }
134 
135     function _burn(address account, uint256 amount) internal {
136         require(account != 0);
137         require(amount <= balances[account]);
138 
139         totalSupply_ = totalSupply().sub(amount);
140         balances[account] = balances[account].sub(amount);
141         emit Transfer(account, address(0), amount);
142     }
143 
144     function _burnFrom(address account, uint256 amount) internal {
145         require(amount <= allowed[account][msg.sender]);
146 
147         allowed[account][msg.sender] = allowed[account][msg.sender].sub(amount);
148         _burn(account, amount);
149     }
150 
151 }
152 
153 contract MintableToken is StandardToken, Ownable {
154     using SafeMath for uint256;
155 
156     event Mint(address indexed to, uint256 amount);
157     event MintFinished();
158 
159     bool public isMinting = true;
160     uint256 public lockCountingFromTime = 0;
161 
162     modifier canMint() {
163         require(isMinting);
164         _;
165     }
166 
167     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
168         totalSupply_ = totalSupply_.add(_amount);
169         balances[_to] = balances[_to].add(_amount);
170         emit Mint(_to, _amount);
171         emit Transfer(address(0), _to, _amount);
172         return true;
173     }
174 
175     function finishMinting() public onlyOwner canMint returns (bool) {
176         isMinting = false;
177         lockCountingFromTime = now;
178         emit MintFinished();
179         return true;
180     }
181 }
182 
183 contract BurnableToken is StandardToken {
184 
185   function burn(uint256 value) public {
186     _burn(msg.sender, value);
187   }
188 
189   function burnFrom(address from, uint256 value) public {
190     _burnFrom(from, value);
191   }
192 
193   function _burn(address who, uint256 value) internal {
194     super._burn(who, value);
195   }
196 }
197 
198 contract OSAToken is MintableToken, BurnableToken {
199     using SafeMath for uint256;
200 
201     string public name = "OSAToken";
202     string public symbol = "OSA";
203     uint8 constant public decimals = 18;
204 
205     uint256 constant public MAX_TOTAL_SUPPLY = 5777999888 * (10 ** uint256(decimals));
206 
207     struct LockParams {
208         uint256 TIME;
209         uint256 AMOUNT;
210     }
211 
212     mapping(address => LockParams[]) private holdAmounts;
213     address[] private holdAmountAccounts;
214 
215     function isValidAddress(address _address) public view returns (bool) {
216         return (_address != 0x0 && _address != address(0) && _address != 0 && _address != address(this));
217     }
218 
219     modifier validAddress(address _address) {
220         require(isValidAddress(_address));
221         _;
222     }
223 
224     function mint(address _to, uint256 _amount) public validAddress(_to) onlyOwner canMint returns (bool) {
225         if (totalSupply_.add(_amount) > MAX_TOTAL_SUPPLY) {
226             return false;
227         }
228         return super.mint(_to, _amount);
229     }
230 
231     function transfer(address _to, uint256 _value) public validAddress(_to) returns (bool) {
232         require(checkAvailableAmount(msg.sender, _value));
233     
234         return super.transfer(_to, _value);
235     }
236 
237     function transferFrom(address _from, address _to, uint256 _value) public validAddress(_to) returns (bool) {
238         require(checkAvailableAmount(_from, _value));
239 
240         return super.transferFrom(_from, _to, _value);
241     }
242 
243     function approve(address _spender, uint256 _value) public returns (bool) {
244         return super.approve(_spender, _value);
245     }
246 
247     function setHoldAmount(address _address, uint256 _amount, uint256 _time) public onlyOwner {
248         require(getAvailableBalance(_address) >= _amount);
249         _setHold(_address, _amount, _time);
250     }
251 
252     function _setHold(address _address, uint256 _amount, uint256 _time) internal {
253         LockParams memory lockdata;
254         if (lockCountingFromTime == 0) {
255             lockdata.TIME = _time;
256         } else {
257             lockdata.TIME = now.sub(lockCountingFromTime).add(_time);
258         }
259         lockdata.AMOUNT = _amount;
260 
261         holdAmounts[_address].push(lockdata);
262         holdAmountAccounts.push(_address) - 1;
263     }
264 
265     function getTotalHoldAmount(address _address) public view returns(uint256) {
266         uint256 totalHold = 0;
267         LockParams[] storage locks = holdAmounts[_address];
268         for (uint i = 0; i < locks.length; i++) {
269             if (lockCountingFromTime == 0 || lockCountingFromTime.add(locks[i].TIME) >= now) {
270                 totalHold = totalHold.add(locks[i].AMOUNT);
271             }
272         }
273         return totalHold;
274     }
275 
276     function getAvailableBalance(address _address) public view returns(uint256) {
277         return balanceOf(_address).sub(getTotalHoldAmount(_address));
278     }
279 
280     function checkAvailableAmount(address _address, uint256 _amount) public view returns (bool) {
281         return _amount <= getAvailableBalance(_address);
282     }
283 
284     function removeHoldByAddress(address _address) public onlyOwner {
285         delete holdAmounts[_address];
286     }
287 
288     function removeHoldByAddressIndex(address _address, uint256 _index) public onlyOwner {
289         delete holdAmounts[_address][_index];
290     }
291 
292     function changeHoldByAddressIndex(
293         address _address, uint256 _index, uint256 _amount, uint256 _time
294     ) public onlyOwner {
295         if (_amount > 0) {
296             holdAmounts[_address][_index].AMOUNT = _amount;
297         }
298         if (_time > 0) {
299             if (lockCountingFromTime == 0) {
300                 holdAmounts[_address][_index].TIME = _time;
301             } else {
302                 holdAmounts[_address][_index].TIME = now.sub(lockCountingFromTime).add(_time);
303             }
304         }
305     }
306 
307     function getHoldAmountAccounts() public view onlyOwner returns (address[]) {
308         return holdAmountAccounts;
309     }
310 
311     function countHoldAmount(address _address) public view onlyOwner returns (uint256) {
312         require(_address != 0x0 && _address != address(0));
313         return holdAmounts[_address].length;
314     }
315 
316     function getHoldAmount(address _address, uint256 _idx) public view onlyOwner returns (uint256, uint256) {
317         require(_address != 0x0);
318         require(holdAmounts[_address].length>0);
319 
320         return (holdAmounts[_address][_idx].TIME, holdAmounts[_address][_idx].AMOUNT);
321     }
322 
323     function transferHoldFrom(
324         address _from, address _to, uint256 _value
325     ) public onlyOwner returns (bool) {
326         require(_to != address(0));
327         require(getTotalHoldAmount(_from) >= _value);
328         require(_value <= allowed[_from][tx.origin]);
329 
330         balances[_from] = balances[_from].sub(_value);
331         balances[_to] = balances[_to].add(_value);
332         allowed[_from][tx.origin] = allowed[_from][tx.origin].sub(_value);
333         emit Transfer(_from, _to, _value);
334 
335         uint256 lockedSourceAmount = 0;
336         uint lockedSourceAmountCount = 0;
337 
338         LockParams[] storage locks = holdAmounts[_from];
339 
340         for (uint i = 0; i < locks.length; i++) {
341             if (lockCountingFromTime == 0 || lockCountingFromTime.add(locks[i].TIME) >= now) {
342             	lockedSourceAmount = lockedSourceAmount.add(locks[i].AMOUNT);
343                 lockedSourceAmountCount++;
344             }
345         }
346 
347         uint256 tosend = 0;
348         uint256 acc = 0;
349         uint j = 0;
350 
351         for (i = 0; i < locks.length; i++) {
352             if (lockCountingFromTime == 0 || lockCountingFromTime.add(locks[i].TIME) >= now) {
353             	if (j < lockedSourceAmountCount - 1) {
354     	            tosend = locks[i].AMOUNT.mul(_value).div(lockedSourceAmount);
355     	        } else {
356         	        tosend = _value.sub(acc);
357     	        }
358     	        locks[i].AMOUNT = locks[i].AMOUNT.sub(tosend);
359     	        acc = acc.add(tosend);
360     	        _setHold(_to, tosend, locks[i].TIME);
361     	        j++;
362             }
363         }
364         return true;
365     }
366 
367     function burnMintFrom(address _from, uint256 _amount) public onlyOwner canMint {
368         require(checkAvailableAmount(_from, _amount));
369         super._burn(_from, _amount);
370     }
371 
372     function burnFrom(address from, uint256 value) public {
373         require(!isMinting);
374         require(checkAvailableAmount(from, value));
375         super.burnFrom(from, value);
376     }
377 
378     function burn(uint256 value) public {
379         require(!isMinting);
380         require(checkAvailableAmount(msg.sender, value));
381         super.burn(value);
382     }
383 
384 }