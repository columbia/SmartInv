1 pragma solidity ^0.4.21;
2 
3 contract Owned {
4 
5     address public owner;
6     address internal newOwner;
7     function Owned() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner() {
12         require(msg.sender == owner);
13         _;
14     }
15     
16     event updateOwner(address _oldOwner, address _newOwner);
17       ///change the owner
18     function changeOwner(address _newOwner) public onlyOwner returns(bool) {
19         require(owner != _newOwner);
20         newOwner = _newOwner;
21         return true;
22     }
23     
24     /// accept the ownership
25     function acceptNewOwner() public returns(bool) {
26         require(msg.sender == newOwner);
27         emit updateOwner(owner, newOwner);
28         owner = newOwner;
29         return true;
30     }
31 }
32 
33 
34 library SafeMath {
35 
36     function mul(uint a, uint b) internal pure returns (uint) {
37         uint c = a * b;
38         assert(a == 0 || c / a == b);
39         return c;
40     }
41 
42     function div(uint a, uint b) internal pure returns (uint) {
43         // assert(b > 0); // Solidity automatically throws when dividing by 0
44         uint c = a / b;
45         return c;
46     }
47 
48     function sub(uint a, uint b) internal pure returns (uint) {
49         assert(b <= a);
50         return a - b;
51     }
52 
53     function add(uint a, uint b) internal pure returns (uint) {
54         uint c = a + b;
55         assert(c >= a);
56         return c;
57     }
58 }
59 
60 contract ERC20Token {
61 
62     uint256  internal _totalSupply;
63 
64     mapping (address => uint256) public balances;
65 
66     function totalSupply() constant public returns (uint256 supply);
67 
68     function balanceOf(address _owner) constant public returns (uint256 balance);
69 
70     function transfer(address _to, uint256 _value) public returns (bool success);
71     
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
73 
74     function approve(address _spender, uint256 _value) public returns (bool success);
75 
76     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
77 
78     event Transfer(address indexed _from, address indexed _to, uint256 _value);
79     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
80 }
81 
82 
83 contract Controlled is Owned {
84     using SafeMath for uint;
85     uint256 oneMonth = 3600 * 24 * 30; //2592000
86 
87     uint256 public releaseStartTime = 1527910441;  //20180602 11:35 default  date +%s
88     bool  public emergencyStop = false;
89     uint256 internal _lockValue;
90     
91     event reportCalc(address _user,uint transferValue,uint256 releaseValue);
92     struct userToken {
93         uint256 OCE;
94         uint256 addrLockType;
95     }
96     mapping (address => userToken) userReleaseToken;
97 
98     modifier canTransfer {
99         require(emergencyStop == false);
100         _;
101     }
102 
103     function setTransferOCE(bool _bool) public onlyOwner{
104         emergencyStop = !_bool;
105     }
106 
107 
108     function setRealseTime(uint256 _time) public onlyOwner {
109         releaseStartTime = _time;
110     }
111 
112     modifier releaseTokenValid(address _user, uint256 _value) {
113         uint256 _lockTypeIndex = userReleaseToken[_user].addrLockType;
114         if(_lockTypeIndex != 0) {
115             uint256 lockValue = userReleaseToken[_user].OCE.sub(calcReleaseToken(_user));
116             emit reportCalc(_user,_value,lockValue);
117             require (_value >= lockValue);
118         }
119         _;
120     }
121 
122     function getLockBalance(address _user) constant public returns (uint256)
123     {
124         _lockValue = 0;
125         uint256 _lockTypeIndex = userReleaseToken[_user].addrLockType;
126         if(_lockTypeIndex != 0) {
127             _lockValue = userReleaseToken[_user].OCE.sub(calcReleaseToken(_user));
128             emit reportCalc(_user,_lockTypeIndex,_lockValue);
129         }
130         return _lockValue;
131     }
132 
133     function calcReleaseToken(address _user) internal view returns (uint256) {
134         uint256 _lockTypeIndex = userReleaseToken[_user].addrLockType;
135         uint256 _timeDifference = now.sub(releaseStartTime);
136         uint256 _whichPeriod = getPeriod(_lockTypeIndex, _timeDifference);
137 
138         // lock type 1, 75% lock 3 months
139         // lock type 2, 90% lock 6 months
140         // lock type 3, 75% lock 3 years remove it
141 
142         if(_lockTypeIndex == 1) {
143             return (percent(userReleaseToken[_user].OCE, 25).add( percent(userReleaseToken[_user].OCE, _whichPeriod.mul(25))));
144         }
145         if(_lockTypeIndex == 2) {
146             return (percent(userReleaseToken[_user].OCE, 10).add(percent(userReleaseToken[_user].OCE, _whichPeriod.mul(25))));
147         }
148         if(_lockTypeIndex == 3) {
149             return (percent(userReleaseToken[_user].OCE, 25).add(percent(userReleaseToken[_user].OCE, _whichPeriod.mul(15))));
150         }
151         revert();
152     }
153 
154 
155     function getPeriod(uint256 _lockTypeIndex, uint256 _timeDifference) internal view returns (uint256) {        
156 
157         if(_lockTypeIndex == 1) {           //The lock for medium investment
158             uint256 _period2 = _timeDifference.div(oneMonth);
159             if(_period2 >= 3){
160                 _period2 = 3;
161             }
162             return _period2;
163         }
164         if(_lockTypeIndex == 2) {           //The lock for massive investment
165             uint256 _period3 = _timeDifference.div(oneMonth);
166             if(_period3 >= 6){
167                 _period3 = 6;
168             }
169             return _period3;
170         }
171         if(_lockTypeIndex == 3) {           //The lock for the usechain coreTeamSupply
172             uint256 _period1 = (_timeDifference.div(oneMonth)).div(12);
173             if(_period1 >= 3){
174                 _period1 = 3;
175             }
176             return _period1;
177         }
178         revert();
179     }
180 
181     function percent(uint _token, uint _percentage) internal pure returns (uint) {
182         return _percentage.mul(_token).div(100);
183     }
184 
185 }
186 
187 contract standardToken is ERC20Token, Controlled {
188 
189     mapping (address => mapping (address => uint256)) internal allowed;
190 
191     function totalSupply() constant public returns (uint256 ){
192         return _totalSupply;
193     }
194 
195     function balanceOf(address _owner) constant public returns (uint256) {
196         return balances[_owner];
197     }
198 
199     function allowance(address _owner, address _spender) constant public returns (uint256) {
200         return allowed[_owner][_spender];
201     }
202 
203     function transfer(
204         address _to,
205         uint256 _value)
206         public
207         canTransfer
208         releaseTokenValid(msg.sender, balances[msg.sender].sub(_value))
209         returns (bool)
210     {
211         require (balances[msg.sender] >= _value);           // Throw if sender has insufficient balance
212         require(_to != address(0));
213         balances[msg.sender] = balances[msg.sender].sub(_value);                     // Deduct senders balance
214         balances[_to] = balances[_to].add(_value);                            // Add recivers balance
215         emit Transfer(msg.sender, _to, _value);             // Raise Transfer event
216         return true;
217     }
218 
219 
220     function approve(address _spender, uint256 _value) public returns (bool success) {
221         allowed[msg.sender][_spender] = _value;          // Set allowance
222         emit Approval(msg.sender, _spender, _value);             // Raise Approval event
223         return true;
224     }
225 
226 
227     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
228         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
229         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230         return true;
231     }
232 
233 
234     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
235         uint oldValue = allowed[msg.sender][_spender];
236         if (_subtractedValue > oldValue) {
237             allowed[msg.sender][_spender] = 0;
238         } else {
239             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240         }
241         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242         return true;
243     }
244 
245 
246     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
247         approve(_spender, _value);                          // Set approval to contract for _value
248         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
249         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
250         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { 
251             revert();
252         }
253         return true;
254     }
255 
256 
257     function transferFrom(address _from, address _to, uint256 _value)
258         public
259         canTransfer
260         releaseTokenValid(msg.sender, balances[msg.sender].sub(_value))
261         returns (bool success)
262    {
263         require(_to != address(0));
264         require (_value <= balances[_from]);                // Throw if sender does not have enough balance
265         require (_value <= allowed[_from][msg.sender]);  // Throw if you do not have allowance
266         balances[_from] = balances[_from].sub(_value);
267         balances[_to] = balances[_to].add(_value);
268         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
269         emit Transfer(_from, _to, _value);                       // Raise Transfer event
270         return true;
271     }
272 
273 }
274 
275 contract LTE is Owned, standardToken {
276 
277     string constant public name   = "LTEChainToken";
278     string constant public symbol = "LTE";
279     uint constant public decimals = 18;
280 
281     mapping(address => uint256) public ethBalances;
282     uint256 public ethCrowdsale = 0;
283     uint256 public rate = 1;
284     bool public crowdsaleClosed = false;
285 
286     uint256 constant public topTotalSupply = 1 * 10**9 * 10**decimals;
287 
288     event fallbackTrigged(address addr,uint256 amount);
289 
290     function() payable {//decimals same as eth decimals
291         require(!crowdsaleClosed);
292         uint ethAmount = msg.value;
293         ethBalances[msg.sender] = ethBalances[msg.sender].add(ethAmount);
294         ethCrowdsale = ethCrowdsale.add(ethAmount);
295         uint256 rewardAmount = ethAmount.mul(rate);
296         require (_totalSupply.add(rewardAmount)<=topTotalSupply);
297         _totalSupply = _totalSupply.add(rewardAmount);
298         balances[msg.sender] = balances[msg.sender].add(rewardAmount);
299         emit fallbackTrigged(msg.sender,rewardAmount);
300     }
301 
302     function setCrowdsaleClosed(bool _bool) public onlyOwner {
303         crowdsaleClosed = _bool;
304     }
305 
306     function setRate(uint256 _value) public onlyOwner {
307         rate = _value;
308     }
309 
310     function getBalance() constant onlyOwner returns(uint){
311         return this.balance;
312     }
313 
314     event SendEvent(address to, uint256 value, bool result);
315     
316     function sendEther(address addr,uint256 _value) public onlyOwner {
317         bool result = false;
318         require (_value < this.balance);     
319         result = addr.send(_value);
320         emit SendEvent(addr, _value, result);
321     }
322 
323     function kill(address _addr) public onlyOwner {
324         selfdestruct(_addr);
325     }
326 
327     function allocateToken(address[] _owners, uint256[] _values, uint256[] _addrLockType) public onlyOwner {
328         require ((_owners.length == _values.length) && ( _values.length == _addrLockType.length));
329 
330         for(uint i = 0; i < _owners.length ; i++){
331             uint256 value = _values[i] * 10**decimals ;
332             require (_totalSupply.add(value)<=topTotalSupply);
333             _totalSupply = _totalSupply.add(value);
334             balances[_owners[i]] = balances[_owners[i]].add(value);             // Set minted coins to target
335             emit Transfer(0x0, _owners[i], value);
336             userReleaseToken[_owners[i]].OCE = userReleaseToken[_owners[i]].OCE.add(value);
337             userReleaseToken[_owners[i]].addrLockType = _addrLockType[i];
338         }
339     }
340 
341 
342     function allocateCandyToken(address[] _owners, uint256[] _values) public onlyOwner {
343         require (_owners.length == _values.length);
344         for(uint i = 0; i < _owners.length ; i++){
345             uint256 value = _values[i]* 10**decimals;
346             require (_totalSupply.add(value)<=topTotalSupply);
347             _totalSupply = _totalSupply.add(value);
348             balances[_owners[i]] = balances[_owners[i]].add(value);
349             emit Transfer(0x0, _owners[i], value);
350         }
351     }
352 }