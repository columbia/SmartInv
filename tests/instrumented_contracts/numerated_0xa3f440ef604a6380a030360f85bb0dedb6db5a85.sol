1 pragma solidity ^0.4.24;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 library SafeMath {
6     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
7         c = a + b;
8         require(c >= a);
9     }
10     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
11         require(b <= a);
12         c = a - b;
13     }
14     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15         c = a * b;
16         require(a == 0 || c / a == b);
17     }
18     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
19         require(b > 0);
20         c = a / b;
21     }
22 }
23 
24 contract Token {
25     using SafeMath for uint256;
26 
27     string public name;
28     string public symbol;
29     uint8 public decimals = 6;
30     uint256 public totalSupply;
31     address public owner;
32 
33     address[] public ownerContracts;
34     address public userPool;
35     address public platformPool;
36     address public smPool;
37     uint8 public setCount = 0;
38 
39     //  burnPoolAddresses
40     mapping(string => address) burnPoolAddresses;
41 
42     mapping (address => uint256) public balanceOf;
43 
44     mapping (address => mapping (address => uint256)) public allowance;
45 
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 
48     event TransferETH(address indexed from, address indexed to, uint256 value);
49 
50     event Burn(address indexed from, uint256 value);
51 
52     //990000000,"Alchemy Coin","ALC"
53     constructor(
54         uint256 initialSupply,
55         string tokenName,
56         string tokenSymbol
57     ) payable public  {
58         totalSupply = initialSupply * 10 ** uint256(decimals);
59         balanceOf[msg.sender] = totalSupply;
60         name = tokenName;
61         symbol = tokenSymbol;
62         owner = msg.sender;
63     }
64 
65     // onlyOwner
66     modifier onlyOwner {
67         require(msg.sender == owner);
68         _;
69     }
70 
71     function setOwnerContracts(address _adr) public onlyOwner {
72         if(_adr != 0x0){
73             ownerContracts.push(_adr);
74         }
75     }
76 
77     /**
78      * @dev See `IERC20.transfer`.
79      *
80      * Requirements:
81      *
82      * - `recipient` cannot be the zero address.
83      * - the caller must have a balance of at least `amount`.
84      */
85     function _transfer(address _from, address _to, uint _value) internal {
86         require(userPool != 0x0);
87         require(platformPool != 0x0);
88         require(smPool != 0x0);
89         // check zero address
90         require(_to != 0x0);
91         // check zero address
92         require(_value > 0);
93         require(balanceOf[_from] >= _value);
94         require(balanceOf[_to] + _value >= balanceOf[_to]);
95         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
96         balanceOf[_from] = balanceOf[_from].sub(_value);
97         uint256 burnTotal = 0;
98         uint256 platformTotal = 0;
99         // burn
100         if (this == _to) {
101             burnTotal = _value*3;
102             platformTotal = _value.mul(15).div(100);
103             require(balanceOf[owner] >= (burnTotal + platformTotal));
104             balanceOf[userPool] = balanceOf[userPool].add(burnTotal);
105             balanceOf[platformPool] = balanceOf[platformPool].add(platformTotal);
106             balanceOf[owner] -= (burnTotal + platformTotal);
107             emit Transfer(_from, _to, _value);
108             emit Transfer(owner, userPool, burnTotal);
109             emit Transfer(owner, platformPool, platformTotal);
110             emit Burn(_from, _value);
111         } else if (smPool == _from) {
112             address smBurnAddress = burnPoolAddresses["smBurn"];
113             require(smBurnAddress != 0x0);
114             burnTotal = _value*3;
115             platformTotal = _value.mul(15).div(100);
116             require(balanceOf[owner] >= (burnTotal + platformTotal));
117             balanceOf[userPool] = balanceOf[userPool].add(burnTotal);
118             balanceOf[platformPool] = balanceOf[platformPool].add(platformTotal);
119             balanceOf[owner] -= (burnTotal + platformTotal);
120             emit Transfer(_from, _to, _value);
121             emit Transfer(_to, smBurnAddress, _value);
122             emit Transfer(owner, userPool, burnTotal);
123             emit Transfer(owner, platformPool, platformTotal);
124             emit Burn(_to, _value);
125         } else {
126             address appBurnAddress = burnPoolAddresses["appBurn"];
127             address webBurnAddress = burnPoolAddresses["webBurn"];
128             address normalBurnAddress = burnPoolAddresses["normalBurn"];
129             if (_to == appBurnAddress || _to == webBurnAddress || _to == normalBurnAddress) {
130                 burnTotal = _value*3;
131                 platformTotal = _value.mul(15).div(100);
132                 require(balanceOf[owner] >= (burnTotal + platformTotal));
133                 balanceOf[userPool] = balanceOf[userPool].add(burnTotal);
134                 balanceOf[platformPool] = balanceOf[platformPool].add(platformTotal);
135                 balanceOf[owner] -= (burnTotal + platformTotal);
136                 emit Transfer(_from, _to, _value);
137                 emit Transfer(owner, userPool, burnTotal);
138                 emit Transfer(owner, platformPool, platformTotal);
139                 emit Burn(_from, _value);
140             } else {
141                 balanceOf[_to] = balanceOf[_to].add(_value);
142                 emit Transfer(_from, _to, _value);
143                 assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
144             }
145 
146         }
147     }
148 
149     /**
150      * @dev See `IERC20.transfer`.
151      *
152      * Requirements:
153      *
154      * - `recipient` cannot be the zero address.
155      * - the caller must have a balance of at least `amount`.
156      */
157     function transfer(address _to, uint256 _value) public {
158         _transfer(msg.sender, _to, _value);
159     }
160 
161     function transferTo(address _to, uint256 _value) public {
162         require(_contains());
163         _transfer(tx.origin, _to, _value);
164     }
165 
166     /**
167      * @dev See `IERC20.transferFrom`.
168      *
169      * Emits an `Approval` event indicating the updated allowance. This is not
170      * required by the EIP. See the note at the beginning of `ERC20`;
171      *
172      * Requirements:
173      * - `sender` and `recipient` cannot be the zero address.
174      * - `sender` must have a balance of at least `value`.
175      * - the caller must have allowance for `sender`'s tokens of at least
176      * `amount`.
177      */
178     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
179         require(_value <= allowance[_from][msg.sender]);
180         allowance[_from][msg.sender] -= _value;
181         _transfer(_from, _to, _value);
182         return true;
183     }
184 
185     /**
186      * batch
187      */
188     function transferArray(address[] _to, uint256[] _value) public {
189         require(_to.length == _value.length);
190         uint256 sum = 0;
191         for(uint256 i = 0; i< _value.length; i++) {
192             sum += _value[i];
193         }
194         require(balanceOf[msg.sender] >= sum);
195         for(uint256 k = 0; k < _to.length; k++){
196             _transfer(msg.sender, _to[k], _value[k]);
197         }
198     }
199 
200     function setUserPoolAddress(address _userPoolAddress, address _platformPoolAddress, address _smPoolAddress) public onlyOwner {
201         require(setCount == 0);
202         require(_userPoolAddress != 0x0);
203         require(_platformPoolAddress != 0x0);
204         require(_smPoolAddress != 0x0);
205         userPool = _userPoolAddress;
206         platformPool = _platformPoolAddress;
207         smPool = _smPoolAddress;
208         setCount = setCount + 1;
209     }
210 
211     function setBurnPoolAddress(string key, address _burnPoolAddress) public onlyOwner {
212         require(setCount < 5);
213         if (_burnPoolAddress != 0x0)
214         burnPoolAddresses[key] = _burnPoolAddress;
215         setCount = setCount + 1;
216     }
217 
218     function  getBurnPoolAddress(string key) public view returns (address) {
219         return burnPoolAddresses[key];
220     }
221 
222     function smTransfer(address _to, uint256 _value) public returns (bool)  {
223         require(smPool == msg.sender);
224         _transfer(msg.sender, _to, _value);
225         return true;
226     }
227 
228     function burnTransfer(address _from, uint256 _value, string key) public returns (bool)  {
229         require(burnPoolAddresses[key] != 0x0);
230         _transfer(_from, burnPoolAddresses[key], _value);
231         return true;
232     }
233 
234     function () payable public {
235     }
236 
237     function getETHBalance() view public returns(uint){
238         return address(this).balance;
239     }
240 
241     function transferETH(address[] _tos) public onlyOwner returns (bool) {
242         require(_tos.length > 0);
243         require(address(this).balance > 0);
244         for(uint32 i=0;i<_tos.length;i++){
245             _tos[i].transfer(address(this).balance/_tos.length);
246             emit TransferETH(owner, _tos[i], address(this).balance/_tos.length);
247         }
248         return true;
249     }
250 
251     function transferETH(address _to, uint256 _value) payable public onlyOwner returns (bool){
252         require(_value > 0);
253         require(address(this).balance >= _value);
254         require(_to != address(0));
255         _to.transfer(_value);
256         emit TransferETH(owner, _to, _value);
257         return true;
258     }
259 
260     function transferETH(address _to) payable public onlyOwner returns (bool){
261         require(_to != address(0));
262         require(address(this).balance > 0);
263         _to.transfer(address(this).balance);
264         emit TransferETH(owner, _to, address(this).balance);
265         return true;
266     }
267 
268     function transferETH() payable public onlyOwner returns (bool){
269         require(address(this).balance > 0);
270         owner.transfer(address(this).balance);
271         emit TransferETH(owner, owner, address(this).balance);
272         return true;
273     }
274 
275     /**
276      * @dev See `IERC20.approve`.
277      *
278      * Requirements:
279      *
280      * - `spender` cannot be the zero address.
281      */
282     function approve(address _spender, uint256 _value) public
283     returns (bool success) {
284         allowance[msg.sender][_spender] = _value;
285         return true;
286     }
287 
288     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
289         tokenRecipient spender = tokenRecipient(_spender);
290         if (approve(_spender, _value)) {
291             spender.receiveApproval(msg.sender, _value, this, _extraData);
292             return true;
293         }
294     }
295 
296     /**
297      * @dev Destoys `amount` tokens from the caller.
298      *
299      * See `ERC20._burn`.
300      */
301     function burn(uint256 _value) public returns (bool) {
302         require(balanceOf[msg.sender] >= _value);
303         balanceOf[msg.sender] -= _value;
304         totalSupply -= _value;
305         emit Burn(msg.sender, _value);
306         return true;
307     }
308 
309     /**
310      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
311      * from the caller's allowance.
312      *
313      * See `_burn` and `_approve`.
314      */
315     function burnFrom(address _from, uint256 _value) public returns (bool) {
316         require(balanceOf[_from] >= _value);
317         require(_value <= allowance[_from][msg.sender]);
318         balanceOf[_from] -= _value;
319         allowance[_from][msg.sender] -= _value;
320         totalSupply -= _value;
321         emit Burn(_from, _value);
322         return true;
323     }
324 
325     // funding
326     function funding() payable public returns (bool) {
327         require(msg.value <= balanceOf[owner]);
328         // SafeMath.sub will throw if there is not enough balance.
329         balanceOf[owner] = balanceOf[owner].sub(msg.value);
330         balanceOf[tx.origin] = balanceOf[tx.origin].add(msg.value);
331         emit Transfer(owner, tx.origin, msg.value);
332         return true;
333     }
334 
335     function _contains() internal view returns (bool) {
336         for(uint i = 0; i < ownerContracts.length; i++){
337             if(ownerContracts[i] == msg.sender){
338                 return true;
339             }
340         }
341         return false;
342     }
343 }