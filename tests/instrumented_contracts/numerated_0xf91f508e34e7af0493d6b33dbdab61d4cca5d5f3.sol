1 pragma solidity >=0.4.21;
2 
3 
4 library sMath {
5     function multiply(uint256 a, uint256 b) internal pure returns(uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14 
15     function division(uint256 a, uint256 b) internal pure returns(uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22 
23     function subtract(uint256 a, uint256 b) internal pure returns(uint256) {
24         assert(b <= a);
25         return a - b;
26     }
27 
28 
29     function plus(uint256 a, uint256 b) internal pure returns(uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 
37 contract owned {
38     address public owner;
39     address public crowdOwner;
40 
41     constructor() public {
42         owner = msg.sender;
43     }
44 
45     modifier onlyOwner {
46         require(msg.sender == owner);
47         _;
48     }
49 
50     function transferOwnership(address newOwner) onlyOwner public {
51         owner = newOwner;
52     }
53     
54     function transferCrowdOwner(address newCrowdOwner) onlyOwner public {
55         crowdOwner = newCrowdOwner;
56     }
57 }
58 
59 /**
60  * @title ERC20
61  * @dev see https://github.com/ethereum/EIPs/issues/179
62  */
63 contract ERC20 {
64     function totalSupply() public view returns(uint256);
65     function balanceOf(address who) public view returns(uint256);
66     function transfer(address to, uint256 value) public returns(bool);
67     function allowance(address owner, address spender) public view returns(uint256);
68     function transferFrom(address from, address to, uint256 value) public returns(bool);
69     function approve(address spender, uint256 value) public returns(bool);
70 
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 }
74 
75 
76 /**
77  * @title Standard ERC20 token
78  *
79  * @dev Implementation of the basic standard token.
80  * @dev https://github.com/ethereum/EIPs/issues/20
81  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
82  */
83 
84 
85 contract StandardToken is ERC20{
86     using sMath
87     for uint256;
88 
89     mapping(address => uint256) balances;
90     mapping(address => uint256) balances_crowd;
91     mapping(address => mapping(address => uint256)) internal allowed;
92     uint256 totalSupply_;
93 
94 
95     function totalSupply() public view returns(uint256) {
96         return totalSupply_;
97     }
98 
99     function _transfer(address _from, address _to, uint _value) internal {
100         require(_to != address(0x0));
101         require(balances[_from] >= _value);
102         require(balances[_to].plus(_value) > balances[_to]);
103         uint previousBalances = balances[_from].plus(balances[_to]);
104         balances[_from] = balances[_from].subtract(_value);
105         balances[_to] = balances[_to].plus(_value);
106         emit Transfer(_from, _to, _value);
107         assert(balances[_from].plus(balances[_to]) == previousBalances);
108     }
109 
110     function transfer(address _to, uint256 _value) public returns(bool) {
111         _transfer(msg.sender, _to, _value);
112         return true;
113     }
114 
115     function balanceOfDef(address _owner) public view returns(uint256 balance) {
116         return balances[_owner];
117     }
118      
119     function balanceOf(address _owner) public view returns(uint256 balance) {
120         return balances[_owner].plus(balances_crowd[_owner]);
121     }
122     
123     function balanceOfCrowd(address _owner) public view returns(uint256 balance) {
124         return balances_crowd[_owner];
125     }
126 
127     function allowance(address _owner, address _spender) public view returns(uint256) {
128         return allowed[_owner][_spender];
129     }
130 
131 
132     function increaseApproval(address _spender, uint _addedValue) public returns(bool) {
133         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].plus(_addedValue);
134         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
135         return true;
136     }
137 
138     function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {
139         uint oldValue = allowed[msg.sender][_spender];
140         if (_subtractedValue > oldValue) {
141             allowed[msg.sender][_spender] = 0;
142         } else {
143             allowed[msg.sender][_spender] = oldValue.subtract(_subtractedValue);
144         }
145         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
146         return true;
147     }
148 }
149 
150 /**
151  * @title 2Percent
152  */
153 
154 contract TWOPercent is StandardToken, owned {
155     uint public INITIAL_SUPPLY = 2500000000;
156 	string public name = 'TWOPercent';
157 	string public symbol = 'TPCT';
158 	uint public decimals = 18;
159     
160 
161     bool public frozenAll = false;
162 
163     mapping(address => bool) public frozenAccount;
164 
165     event FrozenFunds(address target, bool frozen);
166     event FrozenAll(bool stop);
167     event Burn(address indexed from, uint256 value);
168     event LockEvent(address from, address to, uint startLock, uint endLock, uint256 value);
169     event Aborted();
170     
171     struct transForAddr {
172         address fromAddr;
173         address toAddr;
174         uint8 sendFlag ; // 1 send, 0 receive
175         uint256 amount;
176         uint256 balances;
177         uint256 balance_crowd;
178         uint regdate;
179     }
180     
181     struct lockForAddr {
182         uint startLock;
183         uint endLock;
184     }
185     
186     mapping(address => transForAddr[]) transForAddrs;
187     mapping(address => lockForAddr) lockForAddrs;
188     
189     
190     function setLockForAddr(address _address, uint _startLock, uint _endLock) onlyOwner public {
191         lockForAddrs[_address] = lockForAddr(_startLock, _endLock);
192     }
193     
194     function getLockForAddr(address _address)  public view returns (uint, uint) {
195         lockForAddr storage _lockForAddr = lockForAddrs[_address];
196         return (_lockForAddr.startLock, _lockForAddr.endLock);
197     }
198     
199     function getLockStartForAddr(address _address)  public view returns (uint) {
200         lockForAddr storage _lockForAddr = lockForAddrs[_address];
201         return _lockForAddr.startLock;
202     }
203     
204     function getLockEndForAddr(address _address)  public view returns (uint) {
205         lockForAddr storage _lockForAddr = lockForAddrs[_address];
206         return _lockForAddr.endLock;
207     }
208 
209 
210     constructor() public {
211         
212         totalSupply_ = INITIAL_SUPPLY * 10 ** uint256(decimals);
213         balances[msg.sender] = totalSupply_;
214         
215         emit Transfer(address(0x0), msg.sender, totalSupply_);
216     }
217     
218     
219     function transForAddrsCnt(address _address) public view returns (uint) {
220         return transForAddrs[_address].length;
221     }
222     
223 
224     function _transfer(address _from, address _to, uint _value) internal {
225         require(_to != address(0x0)); // Prevent transfer to 0x0 address. Use burn() instead
226         //require(balances[_from] >= _value); 
227         require(balances[_from].plus(balances_crowd[_from]) >= _value); 
228         require(balances[_to].plus(_value) >= balances[_to]); 
229         require(!frozenAccount[_from]); 
230         require(!frozenAccount[_to]); 
231         require(!frozenAll); 
232 
233         if(balances[_from] >= _value) {
234             balances[_from] = balances[_from].subtract(_value);    
235         } else {
236             if(getLockStartForAddr(_from) > 0) {
237             
238                 uint kstNow = now + 32400;
239                 
240                 if(!(getLockStartForAddr(_from) < kstNow &&  kstNow < getLockEndForAddr(_from))) {
241                     uint firstValue = _value.subtract(balances[_from]);
242                     uint twiceValue = _value.subtract(firstValue);
243                     
244                     balances_crowd[_from] = balances_crowd[_from].subtract(firstValue);
245                     balances[_from] = balances[_from].subtract(twiceValue);
246                 }else {
247                     emit LockEvent(_from, _to, getLockStartForAddr(_from), getLockEndForAddr(_from), _value);
248                     emit Aborted();
249                     //emit Transfer(_from, _to, _value);
250                     return;
251                 }
252             }else {
253                 emit LockEvent(_from, _to, getLockStartForAddr(_from), getLockEndForAddr(_from), _value);
254                 emit Aborted();
255                 //emit Transfer(_from, _to, _value);
256                 return;
257             }
258         }
259         
260         if(msg.sender == crowdOwner)  balances_crowd[_to] = balances_crowd[_to].plus(_value);
261         else balances[_to] = balances[_to].plus(_value);
262         
263         // addTransForAddrs(_from, _to, 1, _value, balances[_from], balances_crowd[_from]);
264         // addTransForAddrs(_to, _from, 0, _value, balances[_to], balances_crowd[_to]);        
265         
266         emit Transfer(_from, _to, _value);
267     }
268 
269     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
270         balances[target] = balances[target].plus(mintedAmount);
271         totalSupply_ = totalSupply_.plus(mintedAmount);
272         emit Transfer(address(0), address(this), mintedAmount);
273         emit Transfer(address(this), target, mintedAmount);
274     }
275 
276     function burn(uint256 _value) public returns(bool success) {
277         require(balances[msg.sender] >= _value); // Check if the sender has enough
278         balances[msg.sender] = balances[msg.sender].subtract(_value); // Subtract from the sender
279         totalSupply_ = totalSupply_.subtract(_value); // Updates totalSupply
280         emit Burn(msg.sender, _value);
281         return true;
282     }
283 
284     function freezeAccount(address target, bool freeze) onlyOwner public {
285         frozenAccount[target] = freeze;
286         emit FrozenFunds(target, freeze);
287     }
288 
289     function frozenAllChange(bool stop) onlyOwner public {
290         frozenAll = stop;
291         emit FrozenAll(frozenAll);
292     }
293         
294     // function addTransForAddrs(address _fromAddr, address _toAddr, uint8 _status, uint256 _amount, uint256 _balances, uint256 _balances_crowd) internal {
295     //     transForAddrs[_fromAddr].push(transForAddr(_fromAddr, _toAddr, _status, _amount, _balances, _balances_crowd, now));
296     // }
297     
298     // function getTransForAddrs(address _address, uint256 _index) onlyOwner public view returns (address, address, uint8, uint256, uint256, uint256, uint) {
299     //     if(_index > 0) require(transForAddrsCnt(_address) >= _index.subtract(1));
300         
301     //     transForAddr storage _transForAddr = transForAddrs[_address][_index];
302     //     return (_transForAddr.fromAddr, _transForAddr.toAddr, _transForAddr.sendFlag, _transForAddr.amount, _transForAddr.balances, _transForAddr.balance_crowd, _transForAddr.regdate);
303     // }  
304     
305     
306     // function getTransForAddrsAll(address _address) onlyOwner public view returns (address[] memory, uint8[] memory, uint256[] memory, uint256[] memory, uint256[] memory, uint[] memory) {
307     //     address[] memory _addressTwo = new address[](transForAddrs[_address].length);
308     //     uint8[] memory _status = new uint8[](transForAddrs[_address].length);
309     //     uint256[] memory _amount = new uint256[](transForAddrs[_address].length);
310     //     uint256[] memory _balances = new uint256[](transForAddrs[_address].length);
311     //     uint256[] memory _balances_crowd = new uint256[](transForAddrs[_address].length);
312     //     uint[] memory _regdate = new uint[](transForAddrs[_address].length);
313      
314     //     for(uint i = 0; i < transForAddrs[_address].length; i++){
315     //       // _addressOne[i] = transForAddrs[_address][i].fromAddr;
316     //         _addressTwo[i] = transForAddrs[_address][i].toAddr;            
317     //         _status[i] = transForAddrs[_address][i].sendFlag;
318     //         _amount[i] = transForAddrs[_address][i].amount;
319     //         _balances[i] = transForAddrs[_address][i].balances;
320     //         _balances_crowd[i] = transForAddrs[_address][i].balance_crowd;
321     //         _regdate[i] = transForAddrs[_address][i].regdate;
322     //     }
323         
324     //     return ( _addressTwo, _status, _amount, _balances, _balances_crowd, _regdate);
325     // }
326     
327     function approve(address _spender, uint256 _value) public returns(bool) {
328         require(!frozenAccount[_spender]); 
329         allowed[msg.sender][_spender] = _value;
330         emit Approval(msg.sender, _spender, _value);
331         return true;
332     }
333     
334     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
335         require(_to != address(0));
336         require(_value <= balances[_from]);
337         require(_value <= allowed[_from][msg.sender]);
338         require(!frozenAccount[_from]); 
339         require(!frozenAccount[_to]); 
340 
341         balances[_from] = balances[_from].subtract(_value);
342         balances[_to] = balances[_to].plus(_value);
343         allowed[_from][msg.sender] = allowed[_from][msg.sender].subtract(_value);
344         emit Transfer(_from, _to, _value);
345         return true;
346     }
347 }