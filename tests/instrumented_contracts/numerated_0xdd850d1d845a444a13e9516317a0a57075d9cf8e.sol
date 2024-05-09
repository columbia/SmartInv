1 // 定义语言和版本
2 pragma solidity ^0.4.16;
3 
4 // 调用人合约
5 contract owned {
6 
7     //地址
8     address public owner;
9 
10     constructor () public {
11         owner = msg.sender;
12     }
13 
14     //必须是自己
15     modifier onlyOwner {
16         require(msg.sender == owner);
17         _;
18     }
19 
20     //转移所有权
21     function transferOwnership(address newOwner) onlyOwner public {
22         owner = newOwner;
23     }
24 }
25 
26 // 定义令牌接收接口
27 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
28 
29 // 合约主要逻辑
30 contract TokenERC20 {
31 
32     // Public variables of the token
33     // 令牌的公共变量
34     
35     // 令牌的名称
36     string public name;
37 
38     // 令牌的标识
39     string public symbol;
40 
41     // 18 decimals is the strongly suggested default, avoid changing it
42     // 强烈建议18位小数
43     uint8 public decimals = 18;
44     
45     // 总供应量
46     uint256 public totalSupply;
47 
48     // This creates an array with all balances
49     // 创建一个map保存所有代币持有者的余额
50     mapping (address => uint256) public balanceOf;
51 
52     // 地址配额
53     mapping (address => mapping (address => uint256)) public allowance;
54 
55     // This generates a public event on the blockchain that will notify clients
56     // 这将在区块链上生成将通知客户的公共事件
57     event Transfer(address indexed from, address indexed to, uint256 value);
58     
59     // This generates a public event on the blockchain that will notify clients
60     // 这将在区块链上生成将通知客户的公共事件
61     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
62 
63     // This notifies clients about the amount burnt
64     // 通知客户销毁的总量
65     event Burn(address indexed from, uint256 value);
66 
67     /**
68      * Constrctor function
69      * 构造函数
70      *
71      * Initializes contract with initial supply tokens to the creator of the contract
72      */
73     constructor ( uint256 initialSupply, string tokenName, string tokenSymbol ) public {               
74         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
75         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens 给令牌创建者所有初始化的数量
76         name = tokenName;                                   // Set the name for display purposes
77         symbol = tokenSymbol;                               // Set the symbol for display purposes
78     }
79 
80     /**
81      * Internal transfer, only can be called by this contract
82      * 内部转账，私有函数，内部调用
83      */
84     function _transfer( address _from, address _to, uint _value ) internal {
85 
86         // Prevent transfer to 0x0 address. Use burn() instead
87         // 检查地址格式
88         require(_to != 0x0);
89 
90         // Check if the sender has enough
91         // 检查转账者是否有足够token
92         require(balanceOf[_from] >= _value);
93 
94         // Check for overflows
95         // 检查是否超过最大量
96         require(balanceOf[_to] + _value > balanceOf[_to]);
97 
98         // Save this for an assertion in the future
99         uint previousBalances = balanceOf[_from] + balanceOf[_to];
100 
101         // Subtract from the sender
102         // 转出人减少
103         balanceOf[_from] -= _value;
104 
105         // Add the same to the recipient
106         // 转入人增加
107         balanceOf[_to] += _value;
108         emit Transfer(_from, _to, _value);
109 
110         // Asserts are used to use static analysis to find bugs in your code. They should never fail
111         // 该断言用于使用静态分析来查找代码中的错误，他们永远不应该失败
112         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
113     }
114 
115     /**
116      * Transfer tokens
117      * 转账
118      *
119      * Send `_value` tokens to `_to` from your account
120      *
121      * @param _to The address of the recipient
122      * @param _value the amount to send
123      */
124     function transfer( address _to, uint256 _value ) public returns (bool success) {
125 
126         //这里注意发送者就是合约调用者
127         _transfer(msg.sender, _to, _value);
128 
129         return true;
130     }
131 
132     /**
133      * Transfer tokens from other address
134      * 从另一个地址转移一定配额的token
135      *
136      * Send `_value` tokens to `_to` in behalf of `_from`
137      *
138      * @param _from The address of the sender
139      * @param _to The address of the recipient
140      * @param _value the amount to send
141      */
142     function transferFrom( address _from, address _to, uint256 _value ) public returns (bool success) {
143 
144         require(_value <= allowance[_from][msg.sender]);     // Check allowance 检查从from地址中转移一定配额的token到to地址
145 
146         allowance[_from][msg.sender] -= _value; //转入地址的数量减少
147         _transfer(_from, _to, _value);
148 
149         return true;
150     }
151 
152     /**
153      * Set allowance for other address
154      * 设置配额给其他地址
155      *
156      * Allows `_spender` to spend no more than `_value` tokens in your behalf
157      *
158      * @param _spender The address authorized to spend
159      * @param _value the max amount they can spend
160      */
161     function approve( address _spender, uint256 _value) public returns (bool success) {
162 
163         allowance[msg.sender][_spender] = _value;   //调用地址给指定地址一定数量的配额
164         emit Approval(msg.sender, _spender, _value);
165         
166         return true;
167     }
168 
169     /**
170      * Set allowance for other address and notify
171      * 设置配额给其他地址，并且触发
172      *
173      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
174      *
175      * @param _spender The address authorized to spend
176      * @param _value the max amount they can spend
177      * @param _extraData some extra information to send to the approved contract
178      */
179     function approveAndCall( address _spender, uint256 _value, bytes _extraData ) public returns (bool success) {
180 
181         tokenRecipient spender = tokenRecipient(_spender);
182         if (approve(_spender, _value)) {
183             spender.receiveApproval(msg.sender, _value, this, _extraData);
184             return true;
185         }
186     }
187 
188     /**
189      * Destroy tokens
190      * 销毁令牌
191      *
192      * Remove `_value` tokens from the system irreversibly
193      *
194      * @param _value the amount of money to burn
195      */
196     function burn(uint256 _value) public returns (bool success) {
197 
198         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough 检查销毁地址余额
199         balanceOf[msg.sender] -= _value;            // Subtract from the sender 账户里减少
200         totalSupply -= _value;                      // Updates totalSupply 总供应量减少
201         emit Burn(msg.sender, _value);              // 销毁
202 
203         return true;
204     }
205 
206     /**
207      * Destroy tokens from other account
208      * 从指定账户销毁令牌
209      *
210      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
211      *
212      * @param _from the address of the sender       地址
213      * @param _value the amount of money to burn    数量
214      */
215     function burnFrom(address _from, uint256 _value) public returns (bool success) {
216 
217         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough 检查余额
218         require(_value <= allowance[_from][msg.sender]);    // Check allowance 检查配额
219 
220         balanceOf[_from] -= _value;                         // Subtract from the targeted balance 
221         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
222         totalSupply -= _value;                              // Update totalSupply 总供应量减少
223         emit Burn(_from, _value);                           // 销毁
224 
225         return true;
226     }
227 }
228 
229 /******************************************/
230 /*       ADVANCED TOKEN STARTS HERE       */
231 /******************************************/
232 // 高级版本
233 contract FOMOWINNER is owned, TokenERC20 {
234 
235     // 销售价格
236     uint256 public sellPrice;
237 
238     // 购买价格
239     uint256 public buyPrice;
240 
241     // 定义冻结账户
242     mapping (address => bool) public frozenAccount;
243 
244     /* This generates a public event on the blockchain that will notify clients */
245     // 冻结消息通知
246     event FrozenFunds(address target, bool frozen);
247 
248     /* Initializes contract with initial supply tokens to the creator of the contract */
249     // 构造
250     constructor ( uint256 initialSupply, string tokenName, string tokenSymbol ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
251 
252     /* Internal transfer, only can be called by this contract */
253     // 转账，内部私有函数
254     function _transfer( address _from, address _to, uint _value  ) internal {
255         
256         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead 检查转账地址格式
257         require (balanceOf[_from] >= _value);               // Check if the sender has enough 检查转出地址余额
258         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows           检查转入金额不能为负
259 
260         require(!frozenAccount[_from]);                     // Check if sender is frozen  转出地址不在冻结账户中
261         require(!frozenAccount[_to]);                       // Check if recipient is frozen 转入地址不在冻结账户中
262         balanceOf[_from] -= _value;                         // Subtract from the spender  转出地址减少
263         balanceOf[_to] += _value;                           // Add the same to the recipient 转入地址增加
264 
265         emit Transfer(_from, _to, _value);
266     }
267 
268     /// @notice Create `mintedAmount` tokens and send it to `target`
269     /// @param target Address to receive the tokens
270     /// @param mintedAmount the amount of tokens it will receive
271     /// 蒸发
272     function mintToken( address target, uint256 mintedAmount ) onlyOwner public {
273 
274         balanceOf[target] += mintedAmount;
275         totalSupply += mintedAmount;
276         emit Transfer(0, this, mintedAmount);
277         emit Transfer(this, target, mintedAmount);
278     }
279 
280     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
281     /// @param target Address to be frozen
282     /// @param freeze either to freeze it or not
283     /// 冻结账户
284     function freezeAccount( address target, bool freeze ) onlyOwner public { 
285 
286         frozenAccount[target] = freeze;
287         emit FrozenFunds(target, freeze);
288     }
289 
290     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
291     /// @param newSellPrice Price the users can sell to the contract
292     /// @param newBuyPrice Price users can buy from the contract
293     /// 设置价格，针对eth
294     function setPrices( uint256 newSellPrice, uint256 newBuyPrice ) onlyOwner public {
295 
296         sellPrice = newSellPrice;
297         buyPrice = newBuyPrice;
298     }
299 
300     /// @notice Buy tokens from contract by sending ether
301     /// 从合约中购买令牌
302     function buy() payable public {
303         uint amount = msg.value / buyPrice;               // calculates the amount 计算收到的eth能换多少token
304         _transfer(this, msg.sender, amount);              // makes the transfers  token转账
305     }
306 
307     /// @notice Sell `amount` tokens to contract
308     /// @param amount amount of tokens to be sold
309     /// 向合约卖出令牌
310     function sell(uint256 amount) public {
311         address myAddress = this;
312         require(myAddress.balance >= amount * sellPrice); // checks if the contract has enough ether to buy 检查合约地址是否有足够的eth
313         _transfer(msg.sender, this, amount);              // makes the transfers  token转账
314         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks 向对方发送eth
315     }
316 }