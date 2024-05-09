1 pragma solidity ^0.4.17;
2 
3 /*
4     Utilities & Common Modifiers
5 */
6 contract Utils {
7     /**
8         constructor
9     */
10     function Utils() public {
11     }
12 
13     // verifies that an amount is greater than zero
14     modifier greaterThanZero(uint256 _amount) {
15         require(_amount > 0);
16         _;
17     }
18 
19     // validates an address - currently only checks that it isn't null
20     modifier validAddress(address _address) {
21         require(_address != 0x0);
22         _;
23     }
24 
25     // verifies that the address is different than this contract address
26     modifier notThis(address _address) {
27         require(_address != address(this));
28         _;
29     }
30 
31     // Overflow protected math functions
32 
33     /**
34         @dev returns the sum of _x and _y, asserts if the calculation overflows
35 
36         @param _x   value 1
37         @param _y   value 2
38 
39         @return sum
40     */
41     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
42         uint256 z = _x + _y;
43         assert(z >= _x);
44         return z;
45     }
46 
47     /**
48         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
49 
50         @param _x   minuend
51         @param _y   subtrahend
52 
53         @return difference
54     */
55     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
56         assert(_x >= _y);
57         return _x - _y;
58     }
59 
60     /**
61         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
62 
63         @param _x   factor 1
64         @param _y   factor 2
65 
66         @return product
67     */
68     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
69         uint256 z = _x * _y;
70         assert(_x == 0 || z / _x == _y);
71         return z;
72     }
73 }
74 
75 contract IOwned {
76     // this function isn't abstract since the compiler emits automatically generated getter functions as external
77     function owner() public pure returns (address) {}
78 
79     function transferOwnership(address _newOwner) public;
80     function acceptOwnership() public;
81 }
82 
83 
84 /*
85     owned 是一个管理者
86 */
87 contract Owned is IOwned {
88     address public owner;
89     address public newOwner;
90 
91     event OwnershipTransferred(address _prevOwner, address _newOwner);
92 
93     /**
94      * 初始化构造函数
95      */
96     function Owned() public {
97         owner = msg.sender;
98     }
99 
100     /**
101      * 判断当前合约调用者是否是管理员
102      */
103     modifier onlyOwner {
104         assert(msg.sender == owner);
105         _;
106     }
107 
108     /**
109      * 指派一个新的管理员
110      * @param  _newOwner address 新的管理员帐户地址
111      */
112     function transferOwnership(address _newOwner) public onlyOwner {
113         require(_newOwner != owner);
114         newOwner = _newOwner;
115     }
116 
117     function acceptOwnership() public {
118         require(msg.sender == newOwner);
119         emit OwnershipTransferred(owner, newOwner);
120         owner = newOwner;
121         newOwner = address(0);
122     }
123 }
124 
125 
126 contract IToken {
127     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
128     function name() public pure returns (string) {}
129     function symbol() public pure returns (string) {}
130     function decimals() public pure returns (uint8) {}
131     function totalSupply() public pure returns (uint256) {}
132     function balanceOf(address _owner) public pure returns (uint256) { _owner; }
133     function allowance(address _owner, address _spender) public pure returns (uint256) { _owner; _spender; }
134 
135     function _transfer(address _from, address _to, uint256 _value) internal;
136     function transfer(address _to, uint256 _value) public returns (bool success);
137     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
138     function approve(address _spender, uint256 _value) public returns (bool success);
139 
140 }
141 
142 
143 contract Token is IToken, Owned, Utils {
144     /* 公共变量 */
145     string public standard = '';
146     string public name = ''; //代币名称
147     string public symbol = ''; //代币符号比如'$'
148     uint8 public decimals = 0;  //代币单位
149     uint256 public totalSupply = 0; //代币总量
150 
151     /*记录所有余额的映射*/
152     mapping (address => uint256) public balanceOf;
153     mapping (address => mapping (address => uint256)) public allowance;
154 
155     /* 在区块链上创建一个事件，用以通知客户端*/
156     event Transfer(address indexed from, address indexed to, uint256 value);  //转帐通知事件
157     event Approval(address indexed _owner, address indexed _spender, uint256 _value); //设置允许用户支付最大金额通知
158 
159     function Token() public 
160     {
161         name = 'MCNC健康树';
162         symbol = 'MCNC';
163         decimals = 8;
164         totalSupply = 2000000000 * 10 ** uint256(decimals);
165 
166         balanceOf[owner] = totalSupply;
167     }
168 
169     function _transfer(address _from, address _to, uint256 _value)
170       internal
171       validAddress(_from)
172       validAddress(_to)
173     {
174 
175       require(balanceOf[_from] >= _value);
176       require(balanceOf[_to] + _value > balanceOf[_to]);
177       uint previousBalances = safeAdd(balanceOf[_from], balanceOf[_to]);
178       balanceOf[_from] = safeSub(balanceOf[_from], _value);
179       balanceOf[_to] += safeAdd(balanceOf[_to], _value);
180 
181       emit Transfer(_from, _to, _value);
182 
183       assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
184 
185     }
186 
187     function transfer(address _to, uint256 _value)
188       public
189       validAddress(_to)
190       returns (bool)
191     {
192         _transfer(msg.sender, _to, _value);
193         return true;
194     }
195 
196     function transferFrom(address _from, address _to, uint256 _value)
197         public
198         validAddress(_from)
199         validAddress(_to)
200         returns (bool)
201     {
202         //检查发送者是否拥有足够余额支出的设置
203         require(_value <= allowance[_from][msg.sender]);   // Check allowance
204 
205         allowance[_from][msg.sender] -= safeSub(allowance[_from][msg.sender], _value);
206 
207         _transfer(_from, _to, _value);
208 
209         return true;
210     }
211 
212     function approve(address _spender, uint256 _value)
213         public
214         validAddress(_spender)
215         returns (bool success)
216     {
217 
218         require(_value == 0 || allowance[msg.sender][_spender] == 0);
219 
220         allowance[msg.sender][_spender] = _value;
221         emit Approval(msg.sender, _spender, _value);
222         return true;
223     }
224 }
225 
226 contract IMCNC {
227 
228     function _transfer(address _from, address _to, uint256 _value) internal;
229     function freezeAccount(address target, bool freeze) public;
230 }
231 
232 
233 contract SmartToken is Owned, Token {
234 
235     string public version = '1.0';
236 
237     event NewSmartToken(address _token);
238 
239     function SmartToken()
240         public
241         Token ()
242     {
243         emit NewSmartToken(address(this));
244     }
245 
246 }
247 
248 
249 contract MCNC is IMCNC, Token {
250 
251     mapping (address => bool) public frozenAccount;
252 
253     event FrozenFunds(address target, bool frozen);
254 
255     // triggered when a smart token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory
256     event NewSmartToken(address _token);
257 
258 
259     function MCNC()
260       public
261       Token ()
262     {
263         emit NewSmartToken(address(this));
264     }
265 
266 
267     function _transfer(address _from, address _to, uint _value)
268         validAddress(_from)
269         validAddress(_to)
270         internal
271     {
272         require (balanceOf[_from] > _value);
273         require (balanceOf[_to] + _value > balanceOf[_to]);
274         require(!frozenAccount[_from]);
275         require(!frozenAccount[_to]);
276 
277         balanceOf[_from] = safeSub(balanceOf[_from], _value);
278         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
279 
280         //通知任何监听该交易的客户端
281         emit Transfer(_from, _to, _value);
282 
283     }
284 
285     function freezeAccount(address target, bool freeze)
286         validAddress(target)
287         public
288         onlyOwner
289     {
290         frozenAccount[target] = freeze;
291         emit FrozenFunds(target, freeze);
292     }
293 }