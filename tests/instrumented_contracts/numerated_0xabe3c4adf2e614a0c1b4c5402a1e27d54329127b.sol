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
27 contract ERC20Basic {
28     /**
29     * @dev 传输事件
30     */
31     event Transfer(address indexed _from,address indexed _to,uint256 value);
32 
33     //发送总量  
34     uint256 public  totalSupply;
35 
36     /**
37     *@dev 获取名称
38      */
39     function name() public view returns (string);
40 
41     /**
42     *@dev 获取代币符号
43      */
44     function symbol() public view returns (string);
45 
46     /**
47     *@dev 支持几位小数
48      */
49     function decimals() public view returns (uint8);
50 
51     /**
52     *@dev 获取发行量
53      */
54     function totalSupply() public view returns (uint256){
55         return totalSupply;
56     }
57 
58     /**
59     * @dev 获取余额
60     */
61     function balanceOf(address _owner) public view returns (uint256);
62 
63     /**
64     * @dev 转移代币
65     * @param _to 转移地址
66     * @param _value 数量
67     */
68     function transfer(address _to, uint256 _value) public returns (bool);
69 }
70 
71 pragma solidity ^0.4.24;
72 
73 contract ERC20 is ERC20Basic {
74     /**
75     * @dev 授予事件
76     */
77     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
78 
79      /**
80     * @dev 查看_owner地址还可以调用_spender地址多少代币
81     * @param _owner 当前
82     * @param _spender 地址
83     * @return uint256 可调用的代币数
84     */
85     function allowance(address _owner, address _spender) public view returns (uint256);
86 
87     /**
88     * @dev approve批准之后，当前帐号从_from账户转移_value代币
89     * @param _from 账户转移
90     * @param _to 转移地址
91     * @param _value 数量
92     */
93     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
94 
95     /**
96     * @dev 授权地批准_spender账户从自己的账户转移_value个代币
97     * @param _spender 授权地址
98     * @param _value 授权数量
99     */
100     function approve(address _spender, uint256 _value) public returns (bool);
101 }
102 
103 pragma solidity ^0.4.24;
104 
105 
106 /**
107  * @title Ownable
108  * @dev The Ownable contract has an owner address, and provides basic authorization control
109  * functions, this simplifies the implementation of "user permissions".
110  */
111 contract Ownable {
112     address public owner;
113     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
114 
115 
116     /**
117     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
118     * account.
119     */
120     constructor() public {
121         owner = msg.sender;
122     }
123 
124 
125     /**
126     * @dev Throws if called by any account other than the owner.
127     */
128     modifier onlyOwner() {
129         require(msg.sender == owner);
130         _;
131     }
132 
133     
134     /**
135     * @dev Allows the current owner to transfer control of the contract to a newOwner.
136     * @param _newOwner The address to transfer ownership to.
137     */
138     function transferOwnership(address _newOwner) public onlyOwner {
139         require(_newOwner != address(0));
140         emit    OwnershipTransferred(owner, _newOwner);
141         owner = _newOwner;
142     }
143 }
144 
145 pragma solidity ^0.4.24;
146 
147 
148 /**
149  * Math operations with safety checks
150  */
151 library SafeMathLib {
152 
153     /**
154     * @dev uint256乘法
155     */
156     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
157         uint256 c = a * b;
158         assert(a == 0 || c / a == b);
159         return c;
160     }
161 
162     /**
163     * @dev 除法
164     */
165     function div(uint256 a, uint256 b) internal pure returns (uint256) {
166         assert(0==b);
167         uint256 c = a / b;
168         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
169         return c;
170     }
171 
172     /**
173     * @dev 减法运算
174     */
175     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
176         assert(b <= a);
177         return a - b;
178     }
179 
180     /**
181     * @dev 加法运算
182     */
183     function add(uint256 a, uint256 b) internal pure returns (uint256) {
184         uint256 c = a + b;
185         assert(c >= a);
186         return c;
187     }
188 
189     /**
190     * @dev 64bit最大数
191     */
192     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
193         return a >= b ? a : b;
194     }
195 
196     /**
197     * @dev 64bit最小数
198     */
199     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
200         return a < b ? a : b;
201     }
202 
203     /**
204     * @dev uint256最大数
205     */
206     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
207         return a >= b ? a : b;
208     }
209 
210     /**
211     * @dev uint256最小数
212     */
213     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
214         return a < b ? a : b;
215     }
216 }
217 
218 pragma solidity ^0.4.24;
219 
220 /**
221  * @title Basic token
222  */
223 contract BasicToken is ERC20Basic {
224     //SafeMathLib接口
225     using SafeMathLib for uint256;
226     using AddressUtilsLib for address;
227     
228     //余额地址
229     mapping(address => uint256) public balances;
230 
231     /**
232     * @dev 指定地址传输
233     * @param _from 传送地址
234     * @param _to 传送地址
235     * @param _value 传送数量
236     */
237     function _transfer(address _from,address _to, uint256 _value) public returns (bool){
238         require(!_from.isContract());
239         require(!_to.isContract());
240         require(0 < _value);
241         require(balances[_from] >= _value);
242 
243         balances[_from] = balances[_from].sub(_value);
244         balances[_to] = balances[_to].add(_value);
245         emit Transfer(_from, _to, _value);
246         return true;
247     }
248 
249     /**
250     * @dev 指定地址传输
251     * @param _to 传送地址
252     * @param _value 传送数量
253     */
254     function transfer(address _to, uint256 _value) public returns (bool){
255         return   _transfer(msg.sender,_to,_value);
256     }
257 
258     
259 
260     /**
261     * @dev 查询地址余额
262     * @param _owner 查询地址 
263     * @return uint256 返回余额
264     */
265     function balanceOf(address _owner) public view returns (uint256 balance) {
266         return balances[_owner];
267     }
268 
269 }
270 
271 pragma solidity ^0.4.24;
272 
273 contract UCBasic is ERC20,BasicToken{
274     //
275     mapping (address => mapping (address => uint256)) allowed;
276 
277 
278     /**
279     * @dev approve批准之后，调用transferFrom函数来转移token
280     * @param _from 当前用户token
281     * @param _to 转移地址
282     * @param _value 数量
283     */
284     function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
285         //检测传输值是否为空
286         require(0 < _value);
287         //检测地址是否有效
288         require(address(0) != _from && address(0) != _to);
289         //检测是否有余额可以支付
290         require(allowed[_from][msg.sender] >= _value);
291         //检测账户余额是否够用
292         require(balances[_from] >= _value);
293         //检测地址是否有效
294         require(!_from.isContract());
295         //检测地址是否有效
296         require(!_to.isContract());
297 
298         //余额
299         uint256 _allowance = allowed[_from][msg.sender];
300 
301         balances[_to] = balances[_to].add(_value);
302         balances[_from] = balances[_from].sub(_value);
303         allowed[_from][msg.sender] = _allowance.sub(_value);
304         emit Transfer(_from, _to, _value);
305         return true;
306     }
307 
308     /**
309     * @dev 批准另一个人address来交易指定的代币
310     * @dev 0 address 表示没有授权的地址
311     * @dev 给定的时间内，一个token只能有一个批准的地址
312     * @dev 只有token的持有者或者授权的操作人才可以调用
313     * @param _spender 指定的地址
314     * @param _value uint256 可用余额
315     */
316     function approve(address _spender, uint256 _value) public returns (bool){
317         require(address(0) != _spender);
318         require(!_spender.isContract());
319         require(msg.sender != _spender);
320         require(0 != _value);
321 
322         allowed[msg.sender][_spender] = _value;
323         emit Approval(msg.sender, _spender, _value);
324         return true;
325     }
326 
327    /**
328     * @dev 查看_owner地址还可以调用_spender地址多少代币
329     * @param _owner 当前
330     * @param _spender 地址
331     * @return uint256 可调用的代币数
332     */
333     function allowance(address _owner, address _spender) public view returns (uint256) {
334         //检测地址是否有效
335         require(!_owner.isContract());
336         //检测地址是否有效
337         require(!_spender.isContract());
338 
339         return allowed[_owner][_spender];
340     }
341 }
342 
343 pragma solidity ^0.4.24;
344 
345 contract UCToken is UCBasic,Ownable{
346     using SafeMathLib for uint256;
347     //名称
348     string constant public tokenName = "STOCK";
349     //标识
350     string constant public tokenSymbol = "STO";
351     //发行量30亿
352     uint256 constant public totalTokens = 30*10000*10000;
353     //小数位
354     uint8 constant public  totalDecimals = 18;   
355     //版本号
356     string constant private version = "20180908";
357     //接收以太坊地址
358     address private wallet;
359 
360     constructor() public {
361         totalSupply = totalTokens*10**uint256(totalDecimals);
362         balances[msg.sender] = totalSupply;
363         wallet = msg.sender;
364     }
365 
366     /**
367     *@dev 获取名称
368      */
369     function name() public view returns (string){
370         return tokenName;
371     }
372 
373     /**
374     *@dev 获取代币符号
375      */
376     function symbol() public view returns (string){
377         return tokenSymbol;
378     }
379 
380     /**
381     *@dev 支持几位小数
382      */
383     function decimals() public view returns (uint8){
384         return totalDecimals;
385     }
386 }