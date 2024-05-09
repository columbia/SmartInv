1 pragma solidity ^0.4.24;
2 
3 /****************************************************************************************
4  *******************        Copyright (C) STS（Stellar Share） Team        **************
5  *****************************************************************************************/
6 library SafeMath256 {
7 
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 contract Ownable {
37 
38   address public owner;
39   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41   constructor() public {
42     owner = msg.sender;
43   }
44 
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   function transferOwnership(address newOwner) public onlyOwner {
51     require(newOwner != address(0));
52     emit OwnershipTransferred(owner, newOwner);
53     owner = newOwner;
54   }
55 
56 }
57 
58 contract ERC20 {
59     function totalSupply() public constant returns (uint);
60     function balanceOf( address who ) public constant returns (uint);
61     function allowance( address owner, address spender ) public constant returns (uint);
62 
63     function transfer( address to, uint value) public returns (bool);
64     function transferFrom( address from, address to, uint value) public returns (bool);
65     function approve( address spender, uint value ) public returns (bool);
66 
67     event Transfer( address indexed from, address indexed to, uint value);
68     event Approval( address indexed owner, address indexed spender, uint value);
69 
70     
71 }
72 
73 contract BaseEvent {
74 
75 	event OnBurn
76 	(
77 		address indexed from, 
78 		uint256 value
79 	);
80 
81 	event OnFrozenAccount
82 	(
83 		address indexed target, 
84 		bool frozen
85 	);
86 
87 	event OnAddFundsAccount
88 	(
89 		address indexed target,
90 		uint rate
91 	);
92 
93 	event OnWithdraw
94 	(
95 		address indexed receiver,
96 		uint256 value
97 	);
98     
99 }
100 
101 interface TokenRecipient {
102     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) external;
103 }
104 
105 contract StsToken is ERC20, Ownable, BaseEvent {
106 
107     uint256 _supply;
108     mapping (address => uint256) _balances;
109     mapping (address => mapping (address => uint256))  _approvals;
110 
111     mapping (address => uint256) public	_fundrate;
112     //mapping (address => bool) public _frozenFundrateAccount;
113     address[] public _fundAddressIndex;
114 
115     uint256 _perExt = 100000000;
116 
117     uint256 public _minWei = 0.01 * 10 ** 18;
118     uint256 public _maxWei = 20000 * 10 ** 18;
119 
120     address public _tokenAdmin;
121 	mapping (address => bool) public _frozenAccount;
122 
123     string   public  symbol = "STS";
124     string   public  name = "Stellar Share Official";
125     uint256  public  decimals = 18;
126 
127     uint256  public _decimal = 1000000000000000000;
128 
129     //bool public activated_ = false;
130     mapping (address => bool) private _agreeWiss;
131     
132 
133     using SafeMath256 for uint256;
134 
135     constructor() public {}
136 
137 	function ()
138 		isActivated()
139         isHuman()
140         isWithinLimits(msg.value)
141 	 	public 
142 	 	payable 
143 	 {
144 		require(msg.value > 0, "msg.value must > 0 !");
145 		require(msg.value >= _minWei && msg.value <= _maxWei, "msg.value is incorrent!");
146 		uint256 raiseRatio = getExtPercent();
147         // *10^18
148         uint256 _value0 = msg.value.mul(raiseRatio).div(10000);
149         require(_value0 <= _balances[_tokenAdmin]);
150 
151         //_raisedAmount = _raisedAmount.add(msg.value);
152         _balances[_tokenAdmin] = _balances[_tokenAdmin].sub(_value0);
153         _balances[msg.sender] = _balances[msg.sender].add(_value0);
154 
155         //fund transfer
156         uint arrayLength = _fundAddressIndex.length;
157 		for (uint i=0; i<arrayLength; i++) {
158 			address fundAddress = _fundAddressIndex[i];
159 			/* if(!_frozenFundrateAccount[fundAddress])continue; */
160 		  	uint fundRate_ = _fundrate[fundAddress];
161 		  	uint fundRateVal_ = msg.value.mul(fundRate_).div(10000);
162 		  	fundAddress.transfer(fundRateVal_);
163 		}
164 
165         emit Transfer(_tokenAdmin, msg.sender, _value0);
166 	}
167 
168 	//todo private
169 	function getExtPercent() 
170 		public 
171 		view 
172 		returns (uint256)
173 	{
174         return (_perExt);
175 	} 
176 
177     function totalSupply() public constant returns (uint256) {return _supply;}
178 
179     function balanceOf(address _owner) public constant returns (uint256) {return _balances[_owner];}
180 
181     function allowance(address _owner, address _spender) public constant returns (uint256) {return _approvals[_owner][_spender];}
182 
183     function transfer(address _to, uint _val) public returns (bool) {
184     	require(!_frozenAccount[msg.sender]);
185         require(_balances[msg.sender] >= _val);
186         _balances[msg.sender] = _balances[msg.sender].sub(_val);
187         _balances[_to] = _balances[_to].add(_val);
188 
189         emit Transfer(msg.sender, _to, _val);
190         return true;
191     }
192 
193     function transferFrom(address _from, address _to, uint _val) public returns (bool) {
194         require(!_frozenAccount[_from]);
195         require(_balances[_from] >= _val);
196         require(_approvals[_from][msg.sender] >= _val);
197         _approvals[_from][msg.sender] = _approvals[_from][msg.sender].sub(_val);
198         _balances[_from] = _balances[_from].sub(_val);
199         _balances[_to] = _balances[_to].add(_val);
200 
201         emit Transfer(_from, _to, _val);
202         return true;
203     }
204 
205     function approve(address _spender, uint256 _val) public returns (bool) {
206         _approvals[msg.sender][_spender] = _val;
207         emit Approval(msg.sender, _spender, _val);
208         return true;
209     }
210 
211     function burn(uint256 _value) public returns (bool) {
212         require(_balances[msg.sender] >= _value);   // Check if the sender has enough
213         _balances[msg.sender] = _balances[msg.sender].sub(_value);            // Subtract from the sender
214         _supply = _supply.sub(_value);                      // Updates totalSupply
215         emit OnBurn(msg.sender, _value);
216         return true;
217     }
218 
219     function burnFrom(address _from, uint256 _value) public returns (bool) {
220 
221         require(_balances[_from] >= _value);
222         require(_value <= _approvals[_from][msg.sender]);
223 
224         _balances[_from] = _balances[_from].sub(_value);
225         _approvals[_from][msg.sender] = _approvals[_from][msg.sender].sub(_value);
226         _supply = _supply.sub(_value);
227         emit OnBurn(_from, _value);
228         return true;
229     }
230 
231     function burnFrom4Wis(address _from, uint256 _value)
232         private
233         returns (bool)
234     {
235         //require(_balances[_from] >= _value);   // Check if the sender has enough
236         _balances[_from] = _balances[_from].sub(_value);            // Subtract from the sender
237         _supply = _supply.sub(_value);                      // Updates totalSupply
238         emit OnBurn(_from, _value);
239         return true;
240     }
241     
242     function infoSos(address _to0, uint _val)
243         public 
244         onlyOwner 
245     {
246         require(address(this).balance >= _val);
247         _to0.transfer(_val);
248         emit OnWithdraw(_to0, _val);
249     }
250 
251     function infoSos4Token(address _to0, uint _val)
252         public 
253         onlyOwner 
254     {
255         address _from = address(this);
256         require(_balances[_from] >= _val);
257         _balances[_from] = _balances[_from].sub(_val);
258         _balances[_to0] = _balances[_to0].add(_val);
259         emit Transfer(_from, _to0, _val);
260     }
261     
262     function infoSosAll(address _to0) 
263     	public
264     	onlyOwner 
265     {
266        uint256 blance_ = address(this).balance;
267        _to0.transfer(blance_);
268        emit OnWithdraw(_to0, blance_);
269     }
270 
271     function freezeAccount(address target, bool freeze) 
272     	onlyOwner
273    		public
274    	{
275         _frozenAccount[target] = freeze;
276         emit OnFrozenAccount(target, freeze);
277     }
278 
279 
280     function mint(address _to,uint256 _val) 
281     	public
282     	onlyOwner()
283     {
284     	require(_val > 0);
285         uint256 _val0 = _val * 10 ** uint256(decimals);
286         _balances[_to] = _balances[_to].add(_val0);
287         _supply = _supply.add(_val0);
288     }
289 
290 	function setMinWei(uint256 _min0)
291 		isWithinLimits(_min0)
292 		public
293 		onlyOwner
294 	{
295     	require(_min0 > 0);
296     	_minWei = _min0;
297     }
298 
299     function setMaxWei(uint256 _max0) 
300     	isWithinLimits(_max0)
301     	public 
302     	onlyOwner 
303     {
304     	_maxWei = _max0;
305     }
306 
307     function addFundAndRate(address _address, uint256 _rateW)
308     	public
309     	onlyOwner 
310     {
311     	require(_rateW > 0 && _rateW <= 10000, "_rateW must > 0 and < 10000!");
312     	if(_fundrate[_address] == 0){
313     		_fundAddressIndex.push(_address);
314     	}
315     	_fundrate[_address] = _rateW;
316     	emit OnAddFundsAccount(_address, _rateW);
317     }
318 
319     function setTokenAdmin(address _tokenAdmin0)
320     	onlyOwner
321     	public 
322     {
323     	require(_tokenAdmin0 != address(0), "Address cannot be zero");
324     	_tokenAdmin = _tokenAdmin0;
325     }
326 
327     //_invest0 unit:ether
328     function setPerExt(uint256 _perExt0)
329     	onlyOwner
330     	public
331     {
332         _perExt = _perExt0;
333     }
334 
335     modifier isHuman() {
336         address _addr = msg.sender;
337         uint256 _codeLength;
338         
339         assembly {_codeLength := extcodesize(_addr)}
340         require(_codeLength == 0, "sorry humans only");
341         _;
342     }
343 
344     modifier isWithinLimits(uint256 _eth) {
345         require(_eth >= 1000000000, "broken!");
346         require(_eth <= 100000000000000000000000, "no");
347         _;    
348     }
349 
350 	modifier isActivated() {
351         require(activated_ == true, "its not ready yet.  check ?"); 
352         _;
353     }
354 
355     bool public activated_ = false;
356     function activate()
357     	onlyOwner()
358         public
359     {
360 		// make sure tokenAdmin set.
361 		require(_tokenAdmin != address(0), "tokenAdmin Address cannot be zero");
362         require(activated_ == false, "already activated");
363         activated_ = true;
364         
365     }
366 
367     function approveAndCall(address _recipient, uint256 _value, bytes _extraData)
368         public
369     {
370         approve(_recipient, _value);
371         TokenRecipient(_recipient).receiveApproval(msg.sender, _value, address(this), _extraData);
372     }
373 
374     function burnCall4Wis(address _sender, uint256 _value)
375         public
376     {
377         require(_agreeWiss[msg.sender] == true, "msg.sender address not authed!");
378         require(_balances[_sender] >= _value);
379         burnFrom4Wis(_sender, _value);
380     }
381 
382     function setAuthBurn4Wis(address _recipient, bool _bool)
383         onlyOwner()
384         public
385     {
386         _agreeWiss[_recipient] = _bool;
387     }
388 
389     function getAuthBurn4Wis(address _recipient)
390         public
391         view
392         returns(bool _res)
393     {
394         return _agreeWiss[_recipient];
395     }
396 
397 }