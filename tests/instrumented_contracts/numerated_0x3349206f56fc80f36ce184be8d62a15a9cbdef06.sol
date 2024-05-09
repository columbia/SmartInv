1 pragma solidity 0.4.25;
2 
3 contract ERC20Basic {
4     function totalSupply() public view returns (uint256);
5     function balanceOf(address who) public view returns (uint256);
6     function transfer(address  to, uint256 value) public returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11     function allowance(address owner, address spender) public view returns (uint256);
12     function transferFrom(address from, address  to, uint256 value) public returns (bool);
13     function approve(address  spender, uint256 value) public returns (bool);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract DetailedERC20 is ERC20 {
18     string public name;
19     string public symbol;
20     uint8 public decimals;
21     
22     constructor(string _name, string _symbol, uint8 _decimals) public {
23         name = _name;
24         symbol = _symbol;
25         decimals = _decimals;
26     }
27 }
28 
29 contract BasicToken is ERC20Basic {
30     using SafeMath for uint256;
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32     mapping(address => uint256) public balances;
33     uint256 public _totalSupply;
34     
35     function totalSupply() public view returns (uint256) {
36         return _totalSupply;
37     }
38     
39     
40     function transfer(address _to, uint256 _value) public returns (bool) {
41         require(_to != address(0) && _value != 0 &&_value <= balances[msg.sender],"Please check the amount of transmission error and the amount you send.");
42         balances[msg.sender] = balances[msg.sender].sub(_value);
43         balances[_to] = balances[_to].add(_value);
44         emit Transfer(msg.sender, _to, _value);
45         
46         return true;
47     }
48     
49     function balanceOf(address _owner) public view returns (uint256 balance) {
50         return balances[_owner];
51     }
52 }
53 
54 contract ERC20Token is BasicToken, ERC20 {
55     using SafeMath for uint256;
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57     mapping (address => mapping (address => uint256)) public allowed;
58     mapping (address => uint256) public freezeOf;
59 
60     function approve(address _spender, uint256 _value) public returns (bool) {
61         
62         require(_value == 0 || allowed[msg.sender][_spender] == 0,"Please check the amount you want to approve.");
63         allowed[msg.sender][_spender] = _value;
64         emit Approval(msg.sender, _spender, _value);
65         return true;
66     }
67     
68     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
69         return allowed[_owner][_spender];
70     }
71     
72     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
73         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
74         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
75         return true;
76     }
77     
78     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
79         uint256 oldValue = allowed[msg.sender][_spender];
80         if (_subtractedValue >= oldValue) {
81             allowed[msg.sender][_spender] = 0;
82         } else {
83             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
84         }
85         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
86         return true;
87     }
88 }
89 
90 contract Ownable {
91     
92     address public owner;
93     mapping (address => bool) public admin;
94     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
95     
96     constructor() public {
97         owner = msg.sender;
98     }
99     
100     modifier onlyOwner() {
101         require(msg.sender == owner,"I am not the owner of the wallet.");
102         _;
103     }
104     
105     modifier onlyOwnerOrAdmin() {
106         require(msg.sender == owner || admin[msg.sender] == true,"It is not the owner or manager wallet address.");
107         _;
108     }
109     
110     function transferOwnership(address newOwner) onlyOwner public {
111         require(newOwner != address(0) && newOwner != owner && admin[newOwner] == true,"It must be the existing manager wallet, not the existing owner's wallet.");
112         emit OwnershipTransferred(owner, newOwner);
113         owner = newOwner;
114     }
115     
116     function setAdmin(address newAdmin) onlyOwner public {
117         require(admin[newAdmin] != true && owner != newAdmin,"It is not an existing administrator wallet, and it must not be the owner wallet of the token.");
118         admin[newAdmin] = true;
119     }
120     
121     function unsetAdmin(address Admin) onlyOwner public {
122         require(admin[Admin] != false && owner != Admin,"This is an existing admin wallet, it must not be a token holder wallet.");
123         admin[Admin] = false;
124     }
125 
126 }
127 
128 contract Pausable is Ownable {
129     event Pause();
130     event Unpause();
131     bool public paused = false;
132     
133     modifier whenNotPaused() {
134         require(!paused,"There is a pause.");
135         _;
136     }
137     
138     modifier whenPaused() {
139         require(paused,"It is not paused.");
140         _;
141     }
142     
143     function pause() onlyOwner whenNotPaused public {
144         paused = true;
145         emit Pause();
146     }
147     
148     function unpause() onlyOwner whenPaused public {
149         paused = false;
150         emit Unpause();
151     }
152 
153 }
154 
155 library SafeMath {
156     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
157         if (a == 0) {return 0; }	
158         uint256 c = a * b;
159         require(c / a == b,"An error occurred in the calculation process");
160         return c;
161     }
162     
163     function div(uint256 a, uint256 b) internal pure returns (uint256) {
164         require(b !=0,"The number you want to divide must be non-zero.");
165         uint256 c = a / b;
166         require(c * b == a,"An error occurred in the calculation process");
167         return c;
168     }
169     
170     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
171         require(b <= a,"There are more to deduct.");
172         return a - b;
173     }
174     
175     function add(uint256 a, uint256 b) internal pure returns (uint256) {
176         uint256 c = a + b;
177         require(c >= a,"The number did not increase.");
178         return c;
179     }
180 }
181 
182 contract BurnableToken is BasicToken, Ownable {
183     
184     event Burn(address indexed burner, uint256 amount);
185 
186     function burn(uint256 _value) onlyOwner public {
187         balances[msg.sender] = balances[msg.sender].sub(_value);
188         _totalSupply = _totalSupply.sub(_value);
189         emit Burn(msg.sender, _value);
190         emit Transfer(msg.sender, address(0), _value);
191     }
192 
193     function burnAddress(address _from, uint256 _value) onlyOwner public {
194         balances[_from] = balances[_from].sub(_value);
195         _totalSupply = _totalSupply.sub(_value);
196         emit Burn(_from, _value);
197         emit Transfer(_from, address(0), _value);
198     }
199 }
200 
201 
202 contract FreezeToken is BasicToken, Ownable {
203     
204     event Freezen(address indexed freezer, uint256 amount);
205     event UnFreezen(address indexed freezer, uint256 amount);
206     mapping (address => uint256) public freezeOf;
207     
208     function freeze(uint256 _value) onlyOwner public {
209         balances[msg.sender] = balances[msg.sender].sub(_value);
210         freezeOf[msg.sender] = freezeOf[msg.sender].add(_value);
211         _totalSupply = _totalSupply.sub(_value);
212         emit Freezen(msg.sender, _value);
213     }
214     
215     function unfreeze(uint256 _value) onlyOwner public {
216         require(_value <= _totalSupply && freezeOf[msg.sender] >= _value,"The number to be processed is more than the total amount and the number currently frozen.");
217         balances[msg.sender] = balances[msg.sender].add(_value);
218         freezeOf[msg.sender] = freezeOf[msg.sender].sub(_value);
219         _totalSupply = _totalSupply.add(_value);
220         emit Freezen(msg.sender, _value);
221     }
222 }
223 
224 
225 contract KhaiInfinityCoin is BurnableToken,FreezeToken, DetailedERC20, ERC20Token,Pausable{
226     using SafeMath for uint256;
227     
228     event Approval(address indexed owner, address indexed spender, uint256 value);
229     event LockerChanged(address indexed owner, uint256 amount);
230     event Recall(address indexed owner, uint256 amount);
231     event TimeLockerChanged(address indexed owner, uint256 time, uint256 amount);
232     event TimeLockerChangedTime(address indexed owner, uint256 time);
233     event TimeLockerChangedBalance(address indexed owner, uint256 amount);
234     
235     mapping(address => uint) public locked;
236     mapping(address => uint) public time;
237     mapping(address => uint) public timeLocked;
238     mapping(address => uint) public unLockAmount;
239     
240     string public s_symbol = "KHAI";
241     string public s_name = "Khai Infinity Coin";
242     uint8 public s_decimals = 18;
243     uint256 public TOTAL_SUPPLY = 20*(10**8)*(10**uint256(s_decimals));
244     
245     constructor() DetailedERC20(s_name, s_symbol, s_decimals) public {
246         _totalSupply = TOTAL_SUPPLY;
247         balances[owner] = _totalSupply;
248         emit Transfer(address(0x0), msg.sender, _totalSupply);
249     }
250     
251     function transfer(address _to, uint256 _value)  public whenNotPaused returns (bool){
252         require(balances[msg.sender].sub(_value) >= locked[msg.sender].add(timeLocked[msg.sender]),"Attempting to send more than the locked number");
253         return super.transfer(_to, _value);
254     }
255     
256     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool){
257         balances[_from] = balances[_from].sub(_value);
258         balances[_to] = balances[_to].add(_value);
259         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
260         emit Transfer(_from, _to, _value);
261         
262         return true;
263         
264     }
265     
266     function lockOf(address _address) public view returns (uint256 _locker) {
267         return locked[_address];
268     }
269     
270     function setLock(address _address, uint256 _value) public onlyOwnerOrAdmin {
271         require(_value <= _totalSupply &&_address != address(0),"It is the first wallet or attempted to lock an amount greater than the total holding.");
272         locked[_address] = _value;
273         emit LockerChanged(_address, _value);
274     }
275     
276     function unlock(address _address, uint256 _value) public onlyOwnerOrAdmin {
277         require(_value <= _totalSupply &&_address != address(0),"It is the first wallet or attempted to lock an amount greater than the total holding.");
278         locked[_address] = locked[_address].sub(_value);
279         emit LockerChanged(_address, _value);
280     }
281     
282     function recall(address _from, uint256 _amount) public onlyOwnerOrAdmin {
283         require(_amount != 0 ,"The number you want to retrieve is not zero, it must be greater than zero.");
284         uint256 currentLocker = locked[_from];
285         uint256 currentBalance = balances[_from];
286         require(currentLocker >= _amount && currentBalance >= _amount,"The number you wish to collect must be greater than the holding amount and greater than the locked number.");
287         
288         uint256 newLock = currentLocker.sub(_amount);
289         locked[_from] = newLock;
290         emit LockerChanged(_from, newLock);
291         
292         balances[_from] = balances[_from].sub(_amount);
293         balances[owner] = balances[owner].add(_amount);
294         emit Transfer(_from, owner, _amount);
295         emit Recall(_from, _amount);
296         
297     }
298     
299     function transferList(address[] _addresses, uint256[] _balances) public onlyOwnerOrAdmin{
300         require(_addresses.length == _balances.length,"The number of wallet arrangements and the number of amounts are different.");
301         
302         for (uint i=0; i < _addresses.length; i++) {
303             balances[msg.sender] = balances[msg.sender].sub(_balances[i]);
304             balances[_addresses[i]] = balances[_addresses[i]].add(_balances[i]);
305             emit Transfer(msg.sender,_addresses[i],_balances[i]);
306         }
307     }
308     
309     function setLockList(address[] _recipients, uint256[] _balances) public onlyOwnerOrAdmin{
310         require(_recipients.length == _balances.length,"The number of wallet arrangements and the number of amounts are different.");
311         
312         for (uint i=0; i < _recipients.length; i++) {
313             locked[_recipients[i]] = _balances[i];
314             emit LockerChanged(_recipients[i], _balances[i]);
315         }
316     }
317     /**
318 	* @dev timeLock 10% of the lock quantity is deducted from the customer's wallet every specific time.
319 	* @param _address Lockable wallet
320 	* @param _time The time the lock is released
321 	* @param _value Number of locks
322 	*/
323  
324 	
325     function timeLock(address _address,uint256 _time, uint256 _value) public onlyOwnerOrAdmin{
326         require(_address != address(0),"Same as the original wallet address.");
327         
328 		// Divide by 10 to find the number to be subtracted.
329         uint256 unlockAmount = _value.div(10);
330         
331         time[_address] = _time;
332 		
333 		//Add the locked count.
334         timeLocked[_address] = timeLocked[_address].add(_value);
335 		
336 		//unLockAmount Adds the number to be released.
337         unLockAmount[_address] = unLockAmount[_address].add(unlockAmount);
338 		
339         emit TimeLockerChanged(_address,_time,_value);
340     }
341     
342     function lockTimeStatus(address _address) public view returns (uint256 _time) {
343         return time[_address];
344     }
345     
346     function lockTimeAmountOf(address _address) public view returns (uint256 _value) {
347         return unLockAmount[_address];
348     }
349     
350     function lockTimeBalanceOf(address _address) public view returns (uint256 _value) {
351         return timeLocked[_address];
352     }
353     
354     function untimeLock(address _address) public onlyOwnerOrAdmin{
355         require(_address != address(0),"Same as the original wallet address.");
356         
357         uint256 unlockAmount = unLockAmount[_address];
358         uint256 nextTime = block.timestamp + 30 days;
359         time[_address] = nextTime;
360         timeLocked[_address] = timeLocked[_address].sub(unlockAmount);
361         
362         emit TimeLockerChanged(_address,nextTime,unlockAmount);
363     }
364     
365     function timeLockList(address[] _addresses,uint256[] _time, uint256[] _value) public onlyOwnerOrAdmin{
366         require(_addresses.length == _value.length && _addresses.length == _time.length); 
367         
368         for (uint i=0; i < _addresses.length; i++) {
369             uint256 unlockAmount = _value[i].div(10);
370             time[_addresses[i]] = _time[i];
371             timeLocked[_addresses[i]] = timeLocked[_addresses[i]].add(_value[i]);
372             unLockAmount[_addresses[i]] = unLockAmount[_addresses[i]].add(unlockAmount);
373             emit TimeLockerChanged(_addresses[i],_time[i],_value[i]);    
374         }
375     }
376     
377     function unTimeLockList(address[] _addresses) public onlyOwnerOrAdmin{
378         
379         for (uint i=0; i < _addresses.length; i++) {
380             uint256 unlockAmount = unLockAmount[_addresses[i]];
381             uint256 nextTime = block.timestamp + 30 days;
382             time[_addresses[i]] = nextTime;
383             timeLocked[_addresses[i]] = timeLocked[_addresses[i]].sub(unlockAmount);
384             emit TimeLockerChanged(_addresses[i],nextTime,unlockAmount);
385         }
386     }
387     
388     function timeLockSetTime(address _address,uint256 _time) public onlyOwnerOrAdmin{
389         require(_address != address(0),"Same as the original wallet address.");
390         
391         time[_address] = _time;
392         emit TimeLockerChangedTime(_address,_time);
393 
394     }
395     
396     function timeLockSetBalance(address _address,uint256 _value) public onlyOwnerOrAdmin{
397         require(_address != address(0),"Same as the original wallet address.");
398         
399         timeLocked[_address] = _value;
400         emit TimeLockerChangedBalance(_address,_value);
401     }
402     
403     function() public payable {
404         revert();
405     }
406 }