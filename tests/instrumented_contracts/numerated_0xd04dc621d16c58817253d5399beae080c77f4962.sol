1 pragma solidity ^0.4.21;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) 
12     {
13         if (a == 0) 
14         {
15             return 0;
16         }
17         c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) 
26     {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return a / b;
31     }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
37     {
38         assert(b <= a);
39         return a - b;
40     }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45     function add(uint256 a, uint256 b) internal pure returns (uint256 c) 
46     {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 /**
54  * @title 项目管理员基类
55  * @dev 可持有合同具有所有者地址，并提供基本的授权控制
56 *      函数，这简化了“用户权限”的实现。
57  */
58 contract Ownable {
59     address public owner;
60 
61 
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65 
66 // @dev Ownable构造函数将合约的原始“所有者”设置为发件人帐户。
67 
68     function Ownable() public {
69         owner = msg.sender;
70     }
71 
72 //@dev如果由所有者以外的任何帐户调用，则抛出异常。
73     modifier onlyOwner() {
74         require(msg.sender == owner);
75         _;
76     }
77 
78 //@dev允许当前所有者将合同的控制权转移给新的用户。
79 //@param newOwner将所有权转让给的地址。
80     function transferOwnership(address newOwner) public onlyOwner {
81         require(newOwner != address(0));
82         emit OwnershipTransferred(owner, newOwner);
83         owner = newOwner;
84     }
85 
86 }
87 
88 //@title可用
89 //@dev基地合同允许实施紧急停止机制。
90 
91 contract Pausable is Ownable {
92     event Pause();
93     event Unpause();
94 
95     bool public paused = false;
96 
97 
98 //@dev修饰符仅在合约未暂停时才可调用函数。
99     modifier whenNotPaused() {
100         require(!paused);
101         _;
102     }
103 
104 //@dev修饰符只有在合约被暂停时才可以调用函数。
105     modifier whenPaused() {
106         require(paused);
107         _;
108     }
109 
110 //@dev由所有者调用暂停，触发器停止状态
111     function pause() onlyOwner whenNotPaused public {
112         paused = true;
113         emit Pause();
114     }
115 
116 //@dev被所有者调用以取消暂停，恢复到正常状态
117     function unpause() onlyOwner whenPaused public {
118         paused = false;
119         emit Unpause();
120     }
121 }
122 
123 contract ERC20Basic {
124     function totalSupply() public view returns (uint256);
125     function balanceOf(address who) public view returns (uint256);
126     function transfer(address to, uint256 value) public returns (bool);
127     event Transfer(address indexed from, address indexed to, uint256 value);
128 }
129 
130 //@title基本令牌
131 //@dev StandardToken的基本版本，没有限制。
132 
133 contract BasicToken is ERC20Basic {
134     using SafeMath for uint256;
135 
136     mapping(address => uint256) balances;
137     string public name;
138     string public symbol;
139     uint8 public decimals = 18;
140     uint256 totalSupply_;
141 
142 //@dev token总数
143     function totalSupply() public view returns (uint256) {
144         return totalSupply_;
145     }
146 
147 
148 //指定地址的@dev转移令牌
149 //@param _to要转移到的地址。
150 //@param _value要转移的金额。
151     function transfer(address _to, uint256 _value) public returns (bool) {
152         require(_to != address(0));
153         require(_value <= balances[msg.sender]);
154 
155         balances[msg.sender] = balances[msg.sender].sub(_value);
156         balances[_to] = balances[_to].add(_value);
157         emit Transfer(msg.sender, _to, _value);
158         return true;
159     }
160 
161 //
162 //@dev获取指定地址的余额。
163 //@param _owner查询余额的地址。
164 //@return uint256表示通过地址所拥有的金额。
165     function balanceOf(address _owner) public view returns (uint256) 
166     {
167         return balances[_owner];
168     }
169 
170 }
171 
172 // @title ERC20 interface
173 // @dev see https://github.com/ethereum/EIPs/issues/20
174 
175 contract ERC20 is ERC20Basic {
176     function allowance(address owner, address spender) public view returns (uint256);
177     function transferFrom(address from, address to, uint256 value) public returns (bool);
178     function approve(address spender, uint256 value) public returns (bool);
179     event Approval(address indexed owner, address indexed spender, uint256 value);
180 }
181 
182 contract BurnableToken is BasicToken {
183 
184     event Burn(address indexed burner, uint256 value);
185 
186 
187 //@dev 销毁特定数量的令牌。
188 //@param _value要销毁的令牌数量。
189 
190     function burn(uint256 _value) public {
191         _burn(msg.sender, _value);
192     }
193 
194     function _burn(address _who, uint256 _value) internal {
195         require(_value <= balances[_who]);  
196     //不需要value <= totalSupply，因为这意味着
197     //发件人的余额大于totalSupply，这应该是断言失败
198 
199         balances[_who] = balances[_who].sub(_value);
200         totalSupply_ = totalSupply_.sub(_value);
201         emit Burn(_who, _value);
202         emit Transfer(_who, address(0), _value);
203     }
204 }
205 
206 //@title Standard ERC20 token
207 //@dev Implementation of the basic standard token.
208 //@dev https://github.com/ethereum/EIPs/issues/20
209 //@dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
210 
211 contract StandardToken is ERC20, BasicToken,Ownable{
212 
213     mapping (address => mapping (address => uint256)) internal allowed;
214 
215 
216 
217 //@dev将令牌从一个地址转移到另一个地址
218 //@param _to地址您想要转移到的地址
219 //@param _value uint256要传输的令牌数量
220     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
221         require(_to != address(0));
222         require(_value <= balances[_from]);
223         require(_value <= allowed[_from][msg.sender]);
224 
225         balances[_from] = balances[_from].sub(_value);
226         balances[_to] = balances[_to].add(_value);
227         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
228         emit Transfer(_from, _to, _value);
229         return true;
230     }
231 
232 //@dev批准传递的地址以代表msg.sender花费指定数量的令牌。
233 //请注意，使用此方法更改津贴会带来有人可能同时使用旧版本的风险
234 //以及由不幸交易订购的新补贴。 一种可能的解决方案来减轻这一点
235 //比赛条件是首先将分配者的津贴减至0，然后设定所需的值：
236 // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
237 // @param _spender将花费资金的地址。
238 // @param _value花费的令牌数量。
239 
240     function approve(address _spender, uint256 _value) public returns (bool) {
241         allowed[msg.sender][_spender] = _value;
242         emit Approval(msg.sender, _spender, _value);
243         return true;
244     }
245 
246 //@dev函数来检查所有者允许购买的代币数量。
247 // @param _owner地址拥有资金的地址。
248 //@param _spender地址将花费资金的地址。
249 // @return一个uint256，指定仍可用于该支付者的令牌数量。
250 
251     function allowance(address _owner, address _spender) public view returns (uint256) {
252         return allowed[_owner][_spender];
253     }
254 
255 
256 // @dev增加所有者允许购买的代币数量。
257 //批准时应允许调用[_spender] == 0.要增加
258 //允许值最好使用这个函数来避免2次调用（并等待
259 //第一笔交易是开采的）
260 //来自MonolithDAO Token.sol
261 // @param _spender将花费资金的地址。
262 // @param _addedValue用于增加津贴的令牌数量。
263 
264     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
265         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
266         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
267         return true;
268     }
269 
270 
271 // @dev减少所有者允许购买的代币数量。
272 //允许时调用批准[_spender] == 0.递减
273 //允许值最好使用这个函数来避免2次调用（并等待
274 //第一笔交易是开采的）
275 //来自MonolithDAO Token.sol
276 // @param _spender将花费资金的地址。
277 // @param _subtractedValue用于减少津贴的令牌数量。
278 
279     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
280         uint oldValue = allowed[msg.sender][_spender];
281         if (_subtractedValue > oldValue) 
282         {
283             allowed[msg.sender][_spender] = 0;
284         } else {
285             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
286         }
287         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
288         return true;
289     }
290 
291 }
292 
293 /*  自定义的最终Token代码 */
294 contract NDT2Token is BurnableToken, StandardToken,Pausable {
295     /*这会在区块链上产生一个公共事件，通知客户端*/
296     mapping (address => bool) public frozenAccount;
297     event FrozenFunds(address target, bool frozen);
298     function NDT2Token() public 
299     {
300         totalSupply_ = 10000000000 ether;//代币总量,单位eth
301         balances[msg.sender] = totalSupply_;               //为创建者提供所有初始令牌
302         name = "NDT2Token";             //为显示目的设置交易名称
303         symbol = "NDT2";                               //为显示目的设置交易符号简称
304     }
305 
306 //@dev从目标地址和减量津贴中焚烧特定数量的标记
307 //@param _from地址您想从中发送令牌的地址
308 //@param _value uint256要被刻录的令牌数量
309 
310     function burnFrom(address _from, uint256 _value) public {
311         require(_value <= allowed[_from][msg.sender]);
312         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
313         //此功能需要发布具有更新批准的事件。
314         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
315         _burn(_from, _value);
316     }
317     //锁定一个账号,只有管理员才能执行
318     function freezeAccount(address target, bool freeze) onlyOwner public {
319         frozenAccount[target] = freeze;
320         emit FrozenFunds(target, freeze);
321     }
322     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
323         require(!frozenAccount[msg.sender]);               //检查发送人是否被冻结
324         return super.transfer(_to, _value);
325     }
326     //发送代币到某个账号并且马上锁定这个账号,只有管理员才能执行
327     function transferAndFrozen(address _to, uint256 _value) onlyOwner public whenNotPaused returns (bool) {
328         require(!frozenAccount[msg.sender]);               //检查发送人是否被冻结
329         bool Result = transfer(_to,_value);
330         freezeAccount(_to,true);
331         return Result;
332     }
333     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
334         require(!frozenAccount[_from]);                     //检查发送人是否被冻结
335         return super.transferFrom(_from, _to, _value);
336     }
337 
338     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
339         return super.approve(_spender, _value);
340     }
341 
342     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
343         return super.increaseApproval(_spender, _addedValue);
344     }
345 
346     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
347         return super.decreaseApproval(_spender, _subtractedValue);
348     }
349 }