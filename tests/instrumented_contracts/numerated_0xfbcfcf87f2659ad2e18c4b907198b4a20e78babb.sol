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
146         allowed[account][msg.sender] = allowed[account][msg.sender].sub(amount);
147         _burn(account, amount);
148     }
149 
150 }
151 
152 
153 contract BurnableToken is StandardToken, Ownable {
154 
155   function burn(uint256 value) public {
156     _burn(msg.sender, value);
157   }
158 
159   function burnFrom(address from, uint256 value) public {
160     _burnFrom(from, value);
161   }
162 
163   function _burn(address who, uint256 value) internal {
164     super._burn(who, value);
165   }
166 }
167 
168 contract initialSupplyToken is StandardToken, Ownable {
169     using SafeMath for uint256;
170 
171     function initialSupply(uint256 _amount) public onlyOwner returns (bool) {
172         totalSupply_ = totalSupply_.add(_amount);
173         balances[msg.sender] = balances[msg.sender].add(_amount);
174         return true;
175     }
176 
177 }
178 contract BidaCoin is  initialSupplyToken,BurnableToken  {
179     using SafeMath for uint256;
180 
181     string public name = "BidaCoin";
182     string public symbol = "BIDA";
183     uint8 constant public decimals = 18;
184     
185     constructor () public {
186         initialSupply(300000000 * (10 ** uint256(decimals)));
187     }
188 
189     struct LockParams {
190         uint256 TIME;
191         uint256 AMOUNT;
192     }
193 
194     mapping(address => LockParams[]) private holdAmounts;
195     address[] private holdAmountAccounts;
196 
197     function isValidAddress(address _address) public view returns (bool) {
198         return (_address != 0x0 && _address != address(0) && _address != 0 && _address != address(this));
199     }
200 
201     modifier validAddress(address _address) {
202         require(isValidAddress(_address));
203         _;
204     }
205 
206 
207     function transfer(address _to, uint256 _value) public validAddress(_to) returns (bool) {
208         require(checkAvailableAmount(msg.sender, _value));
209 
210         return super.transfer(_to, _value);
211     }
212 
213     function transferFrom(address _from, address _to, uint256 _value) public validAddress(_to) returns (bool) {
214         require(checkAvailableAmount(_from, _value));
215 
216         return super.transferFrom(_from, _to, _value);
217     }
218 
219     function approve(address _spender, uint256 _value) public returns (bool) {
220         return super.approve(_spender, _value);
221     }
222 
223     function setHoldAmount(address _address, uint256 _amount, uint256 _time) public onlyOwner {
224         _setHold(_address, _amount, _time);
225     }
226 
227     function _setHold(address _address, uint256 _amount, uint256 _time) internal {
228         LockParams memory lockdata;
229         lockdata.TIME = _time;
230         lockdata.AMOUNT = _amount;
231         holdAmounts[_address].push(lockdata);
232         holdAmountAccounts.push(_address) - 1;
233     }
234 
235     function getTotalHoldAmount(address _address) public view returns(uint256) {
236         uint256 totalHold = 0;
237         LockParams[] storage locks = holdAmounts[_address];
238         for (uint i = 0; i < locks.length; i++) {
239             if (locks[i].TIME >= now) {
240                 totalHold = totalHold.add(locks[i].AMOUNT);
241             }
242         }
243         return totalHold;
244     }
245     
246     function getNow() public view returns(uint256) {
247         return now;
248     }
249 
250     function getAvailableBalance(address _address) public view returns(uint256) {
251         return balanceOf(_address).sub(getTotalHoldAmount(_address));
252     }
253 
254     function checkAvailableAmount(address _address, uint256 _amount) public view returns (bool) {
255         return _amount <= getAvailableBalance(_address);
256     }
257 
258     function removeHoldByAddress(address _address) public onlyOwner {
259         delete holdAmounts[_address];
260     }
261 
262     function removeHoldByAddressIndex(address _address, uint256 _index) public onlyOwner {
263         LockParams[] memory nowLocks = holdAmounts[_address];
264         removeHoldByAddress(_address);
265         for (uint i = 0; i < nowLocks.length; i++) {
266             if (i != _index) {
267                  setHoldAmount(_address,nowLocks[i].AMOUNT,nowLocks[i].TIME);
268             }
269         }
270     }
271 
272 
273     function  changeHoldByAddressIndex(address _address, uint256 _index, uint256 _amount, uint256 _time) public onlyOwner {
274         holdAmounts[_address][_index].TIME = _time;
275         holdAmounts[_address][_index].AMOUNT = _amount;
276     }
277 
278 
279     function getHoldAmountAccounts() public view returns (address[]) {
280         return holdAmountAccounts;
281     }
282 
283     function countHoldAmount(address _address) public view returns (uint256) {
284         require(_address != 0x0 && _address != address(0));
285         return holdAmounts[_address].length;
286     }
287 
288     function getHoldAmount(address _address, uint256 _idx) public view  returns (uint256, uint256) {
289         require(_address != 0x0);
290         require(holdAmounts[_address].length>0);
291         return (holdAmounts[_address][_idx].TIME, holdAmounts[_address][_idx].AMOUNT);
292     }
293 
294     function burnFrom(address from, uint256 value) public {
295         require(checkAvailableAmount(from, value));
296         super.burnFrom(from, value);
297     }
298 
299     function burn(uint256 value) public {
300         require(checkAvailableAmount(msg.sender, value));
301         super.burn(value);
302     }
303 
304 }