1 pragma solidity ^0.4.24;
2 
3 /**
4  * Utility library of inline functions on addresses
5  */
6 library AddressUtilsLib {
7 
8     /**
9     * Returns whether there is code in the target address
10     * @dev This function will return false if invoked during the constructor of a contract,
11     *  as the code is not actually created until after the constructor finishes.
12     * @param _addr address address to check
13     * @return bool whether there is code in the target address
14     */
15     function isContract(address _addr) internal view returns (bool) {
16         uint256 size;
17         assembly {
18             size := extcodesize(_addr)
19         }
20 
21         return size > 0;
22     }
23     
24 }
25 
26 pragma solidity ^0.4.24;
27 
28 
29 /**
30  * Math operations with safety checks
31  */
32 library SafeMathLib {
33 
34     /**
35     * @dev uint256乘法
36     */
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a * b;
39         assert(a == 0 || c / a == b);
40         return c;
41     }
42 
43     /**
44     * @dev 除法
45     */
46     function div(uint256 a, uint256 b) internal pure returns (uint256) {
47         assert(0==b);
48         uint256 c = a / b;
49         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50         return c;
51     }
52 
53     /**
54     * @dev 减法运算
55     */
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57         assert(b <= a);
58         return a - b;
59     }
60 
61     /**
62     * @dev 加法运算
63     */
64     function add(uint256 a, uint256 b) internal pure returns (uint256) {
65         uint256 c = a + b;
66         assert(c >= a);
67         return c;
68     }
69 
70     /**
71     * @dev 64bit最大数
72     */
73     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
74         return a >= b ? a : b;
75     }
76 
77     /**
78     * @dev 64bit最小数
79     */
80     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
81         return a < b ? a : b;
82     }
83 
84     /**
85     * @dev uint256最大数
86     */
87     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
88         return a >= b ? a : b;
89     }
90 
91     /**
92     * @dev uint256最小数
93     */
94     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
95         return a < b ? a : b;
96     }
97 }
98 
99 pragma solidity ^0.4.24;
100 
101 
102 /**
103  * @title Ownable
104  * @dev The Ownable contract has an owner address, and provides basic authorization control
105  * functions, this simplifies the implementation of "user permissions".
106  */
107 contract Ownable {
108     address public owner;
109     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
110 
111 
112     /**
113     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
114     * account.
115     */
116     constructor() public {
117         owner = msg.sender;
118     }
119 
120 
121     /**
122     * @dev Throws if called by any account other than the owner.
123     */
124     modifier onlyOwner() {
125         require(msg.sender == owner);
126         _;
127     }
128 
129     
130     /**
131     * @dev Allows the current owner to transfer control of the contract to a newOwner.
132     * @param _newOwner The address to transfer ownership to.
133     */
134     function transferOwnership(address _newOwner) public onlyOwner {
135         require(_newOwner != address(0));
136         emit    OwnershipTransferred(owner, _newOwner);
137         owner = _newOwner;
138     }
139 }
140 
141 pragma solidity ^0.4.24;
142 contract ERC20Basic {
143     /**
144     * @dev 传输事件
145     */
146     event Transfer(address indexed _from,address indexed _to,uint256 value);
147 
148     //发送总量  
149     uint256 public  totalSupply;
150 
151     /**
152     *@dev 获取名称
153      */
154     function name() public view returns (string);
155 
156     /**
157     *@dev 获取代币符号
158      */
159     function symbol() public view returns (string);
160 
161     /**
162     *@dev 支持几位小数
163      */
164     function decimals() public view returns (uint8);
165 
166     /**
167     *@dev 获取发行量
168      */
169     function totalSupply() public view returns (uint256){
170         return totalSupply;
171     }
172 
173     /**
174     * @dev 获取余额
175     */
176     function balanceOf(address _owner) public view returns (uint256);
177 
178     /**
179     * @dev 转移代币
180     * @param _to 转移地址
181     * @param _value 数量
182     */
183     function transfer(address _to, uint256 _value) public returns (bool);
184 }
185 pragma solidity ^0.4.24;
186 
187 contract ERC20 is ERC20Basic {
188     /**
189     * @dev 授予事件
190     */
191     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
192 
193      /**
194     * @dev 查看_owner地址还可以调用_spender地址多少代币
195     * @param _owner 当前
196     * @param _spender 地址
197     * @return uint256 可调用的代币数
198     */
199     function allowance(address _owner, address _spender) public view returns (uint256);
200 
201     /**
202     * @dev approve批准之后，当前帐号从_from账户转移_value代币
203     * @param _from 账户转移
204     * @param _to 转移地址
205     * @param _value 数量
206     */
207     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
208 
209     /**
210     * @dev 授权地批准_spender账户从自己的账户转移_value个代币
211     * @param _spender 授权地址
212     * @param _value 授权数量
213     */
214     function approve(address _spender, uint256 _value) public returns (bool);
215 }
216 
217 pragma solidity ^0.4.24;
218 
219 /**
220  * @title Basic token
221  */
222 contract BasicToken is ERC20Basic {
223     //SafeMathLib接口
224     using SafeMathLib for uint256;
225     using AddressUtilsLib for address;
226     
227     //余额地址
228     mapping(address => uint256) public balances;
229 
230     /**
231     * @dev 指定地址传输
232     * @param _from 传送地址
233     * @param _to 传送地址
234     * @param _value 传送数量
235     */
236     function _transfer(address _from,address _to, uint256 _value) public returns (bool){
237         require(!_from.isContract());
238         require(!_to.isContract());
239         require(0 < _value);
240         require(balances[_from] > _value);
241 
242         balances[_from] = balances[_from].sub(_value);
243         balances[_to] = balances[_to].add(_value);
244         emit Transfer(_from, _to, _value);
245         return true;
246     }
247 
248     /**
249     * @dev 指定地址传输
250     * @param _to 传送地址
251     * @param _value 传送数量
252     */
253     function transfer(address _to, uint256 _value) public returns (bool){
254         return   _transfer(msg.sender,_to,_value);
255     }
256 
257     
258 
259     /**
260     * @dev 查询地址余额
261     * @param _owner 查询地址 
262     * @return uint256 返回余额
263     */
264     function balanceOf(address _owner) public view returns (uint256 balance) {
265         return balances[_owner];
266     }
267 
268 }
269 pragma solidity ^0.4.24;
270 
271 contract UCBasic is ERC20,BasicToken{
272     //
273     mapping (address => mapping (address => uint256)) allowed;
274 
275 
276     /**
277     * @dev approve批准之后，调用transferFrom函数来转移token
278     * @param _from 当前用户token
279     * @param _to 转移地址
280     * @param _value 数量
281     */
282     function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
283         //检测传输值是否为空
284         require(0 < _value);
285         //检测地址是否有效
286         require(address(0) != _from && address(0) != _to);
287         //检测是否有余额可以支付
288         require(allowed[_from][msg.sender] > _value);
289         //检测账户余额是否够用
290         require(balances[_from] > _value);
291         //检测地址是否有效
292         require(!_from.isContract());
293         //检测地址是否有效
294         require(!_to.isContract());
295 
296         //余额
297         uint256 _allowance = allowed[_from][msg.sender];
298 
299         balances[_to] = balances[_to].add(_value);
300         balances[_from] = balances[_from].sub(_value);
301         allowed[_from][msg.sender] = _allowance.sub(_value);
302         emit Transfer(_from, _to, _value);
303         return true;
304     }
305 
306     /**
307     * @dev 批准另一个人address来交易指定的代币
308     * @dev 0 address 表示没有授权的地址
309     * @dev 给定的时间内，一个token只能有一个批准的地址
310     * @dev 只有token的持有者或者授权的操作人才可以调用
311     * @param _spender 指定的地址
312     * @param _value uint256 可用余额
313     */
314     function approve(address _spender, uint256 _value) public returns (bool){
315         require(address(0) != _spender);
316         require(!_spender.isContract());
317         require(msg.sender != _spender);
318         require(0 != _value);
319 
320         allowed[msg.sender][_spender] = _value;
321         emit Approval(msg.sender, _spender, _value);
322         return true;
323     }
324 
325    /**
326     * @dev 查看_owner地址还可以调用_spender地址多少代币
327     * @param _owner 当前
328     * @param _spender 地址
329     * @return uint256 可调用的代币数
330     */
331     function allowance(address _owner, address _spender) public view returns (uint256) {
332         //检测地址是否有效
333         require(!_owner.isContract());
334         //检测地址是否有效
335         require(!_spender.isContract());
336 
337         return allowed[_owner][_spender];
338     }
339 }
340 pragma solidity ^0.4.24;
341 
342 contract STOToken is UCBasic,Ownable{
343     using SafeMathLib for uint256;
344     //名称
345     string constant public tokenName = "STOCK";
346     //标识
347     string constant public tokenSymbol = "STO";
348     //发行量30亿
349     uint256 constant public totalTokens = 30*10000*10000;
350     //小数位
351     uint8 constant public  totalDecimals = 18;   
352     //版本号
353     string constant private version = "20180908";
354     //接收以太坊地址
355     address private wallet;
356 
357     constructor() public {
358         totalSupply = totalTokens*10**uint256(totalDecimals);
359         balances[msg.sender] = totalSupply;
360         wallet = msg.sender;
361     }
362 
363     /**
364     *@dev 获取名称
365      */
366     function name() public view returns (string){
367         return tokenName;
368     }
369 
370     /**
371     *@dev 获取代币符号
372      */
373     function symbol() public view returns (string){
374         return tokenSymbol;
375     }
376 
377     /**
378     *@dev 支持几位小数
379      */
380     function decimals() public view returns (uint8){
381         return totalDecimals;
382     }
383 }