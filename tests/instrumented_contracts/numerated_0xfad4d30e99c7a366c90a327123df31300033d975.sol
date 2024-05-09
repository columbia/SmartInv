1 /* 一个相对比较完善的代币合约 */
2 pragma solidity ^0.4.24;
3 /* 创建一个父类， 账户管理员 */
4 contract owned {
5 
6     address public owner;
7 
8     function owned() public {
9         owner = msg.sender;
10     }
11 
12     /* modifier是修改标志 */
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     /* 修改管理员账户， onlyOwner代表只能是用户管理员来修改 */
19     function transferOwnership(address newOwner) onlyOwner public {
20         owner = newOwner;
21     }
22 
23 }
24 
25 /* receiveApproval服务合约指示代币合约将代币从发送者的账户转移到服务合约的账户（通过调用服务合约的 */
26 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
27 
28 contract TokenERC20 {
29     // 代币（token）的公共变量
30     string public name;             //代币名字
31     string public symbol;           //代币符号
32     uint8 public decimals = 18;     //代币小数点位数， 18是默认， 尽量不要更改
33 
34     uint256 public totalSupply;     //代币总量
35 
36     // 记录各个账户的代币数目
37     mapping (address => uint256) public balanceOf;
38 
39     // A账户存在B账户资金
40     mapping (address => mapping (address => uint256)) public allowance;
41 
42     // 转账通知事件
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 
45     // 销毁金额通知事件
46     event Burn(address indexed from, uint256 value);
47 
48     /* 构造函数 */
49     function TokenERC20(
50         uint256 initialSupply,
51         string tokenName,
52         string tokenSymbol
53     ) public {
54         totalSupply = initialSupply * 10 ** uint256(decimals);  // 根据decimals计算代币的数量
55         balanceOf[msg.sender] = totalSupply;                    // 给生成者所有的代币数量
56         name = tokenName;                                       // 设置代币的名字
57         symbol = tokenSymbol;                                   // 设置代币的符号
58     }
59 
60     /* 私有的交易函数 */
61     function _transfer(address _from, address _to, uint _value) internal {
62         // 防止转移到0x0， 用burn代替这个功能
63         require(_to != 0x0);
64         // 检测发送者是否有足够的资金
65         require(balanceOf[_from] >= _value);
66         // 检查是否溢出（数据类型的溢出）
67         require(balanceOf[_to] + _value > balanceOf[_to]);
68         // 将此保存为将来的断言， 函数最后会有一个检验
69         uint previousBalances = balanceOf[_from] + balanceOf[_to];
70         // 减少发送者资产
71         balanceOf[_from] -= _value;
72         // 增加接收者的资产
73         balanceOf[_to] += _value;
74         Transfer(_from, _to, _value);
75         // 断言检测， 不应该为错
76         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
77     }
78 
79     /* 传递tokens */
80     function transfer(address _to, uint256 _value) public {
81         _transfer(msg.sender, _to, _value);
82     }
83 
84     /* 从其他账户转移资产 */
85     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
86         require(_value <= allowance[_from][msg.sender]);     // Check allowance
87         allowance[_from][msg.sender] -= _value;
88         _transfer(_from, _to, _value);
89         return true;
90     }
91 
92     /*  授权第三方从发送者账户转移代币，然后通过transferFrom()函数来执行第三方的转移操作 */
93 //    function approve(address _spender, uint256 _value) public
94 //    returns (bool success) {
95 //        allowance[msg.sender][_spender] = _value;
96 //        return true;
97 //    }
98 
99     /*
100     为其他地址设置津贴， 并通知
101     发送者通知代币合约, 代币合约通知服务合约receiveApproval, 服务合约指示代币合约将代币从发送者的账户转移到服务合约的账户（通过调用服务合约的transferFrom)
102     */
103 
104 //    function approveAndCall(address _spender, uint256 _value, bytes _extraData)
105 //    public
106 //    returns (bool success) {
107 //        tokenRecipient spender = tokenRecipient(_spender);
108 //        if (approve(_spender, _value)) {
109 //            spender.receiveApproval(msg.sender, _value, this, _extraData);
110 //            return true;
111 //        }
112 //    }
113 
114     /**
115     * 销毁代币
116     */
117     function burn(uint256 _value) public returns (bool success) {
118         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
119         balanceOf[msg.sender] -= _value;            // Subtract from the sender
120         totalSupply -= _value;                      // Updates totalSupply
121         Burn(msg.sender, _value);
122         return true;
123     }
124 
125     /**
126     * 从其他账户销毁代币
127     */
128     function burnFrom(address _from, uint256 _value) public returns (bool success) {
129         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
130         require(_value <= allowance[_from][msg.sender]);    // Check allowance
131         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
132         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
133         totalSupply -= _value;                              // Update totalSupply
134         Burn(_from, _value);
135         return true;
136     }
137 }
138 
139 /******************************************/
140 /*       ADVANCED TOKEN STARTS HERE       */
141 /******************************************/
142 
143 contract MyAdvancedToken is owned, TokenERC20 {
144 
145     uint256 public sellPrice;
146     uint256 public buyPrice;
147 
148     /* 冻结账户 */
149     mapping (address => bool) public frozenAccount;
150 
151     /*
152     * 冻结账户金额
153     * 涉及到frozenAccountCoin, freezeAccountCoin
154     */
155     // mapping (address => uint256) public frozenAccountCoin;
156 
157     /*
158     * 根据时间冻结账户金额
159     */
160     mapping(address => uint[]) public frozenAccountCoinList;
161 
162 
163     /* This generates a public event on the blockchain that will notify clients */
164     event FrozenFunds(address target, bool frozen);
165     // event FrozenCoins(address target, uint256 coinNum);
166     event FrozenCoinsByTime(address target, uint256 coinNum, uint256 timestamp);
167 
168     /* 构造函数 */
169     function MyAdvancedToken(
170         uint256 initialSupply,
171         string tokenName,
172         string tokenSymbol
173     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
174 
175     /* 转账， 比父类加入了账户冻结 */
176     function _transfer(address _from, address _to, uint256 _value) internal {
177         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
178         require (balanceOf[_from] >= _value);               // Check if the sender has enough
179         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
180         require(!frozenAccount[_from]);                     // Check if sender is frozen
181         require(!frozenAccount[_to]);                       // Check if recipient is frozen
182         uint frozenAccountCoin = _calFrozenAccountCoin(_from);
183         // 确保账户锁
184         require(frozenAccountCoin == 0 || (balanceOf[_from] - _value) >= frozenAccountCoin);
185 
186         balanceOf[_from] -= _value;                         // Subtract from the sender
187         balanceOf[_to] += _value;                           // Add the same to the recipient
188         Transfer(_from, _to, _value);
189     }
190 
191     /// 向指定账户增发资金
192     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
193         balanceOf[target] += mintedAmount;
194         totalSupply += mintedAmount;
195         Transfer(0, this, mintedAmount);
196         Transfer(this, target, mintedAmount);
197 
198     }
199 
200     /// 冻结 or 解冻账户
201     function freezeAccount(address target, bool freeze) onlyOwner public {
202         frozenAccount[target] = freeze;
203         FrozenFunds(target, freeze);
204     }
205 
206 
207     /// 冻结 or 解冻账户
208 //    function freezeAccountCoin(address target, uint256 coinNum) onlyOwner public {
209 //        frozenAccountCoin[target] = coinNum;
210 //        FrozenCoins(target, coinNum);
211 //    }
212 
213 
214     function frozenAccountCoinByTime(address target, uint timestamp, uint256 num) onlyOwner public{
215         // 根据时间冻结货币
216         frozenAccountCoinList[target].push(timestamp);
217         frozenAccountCoinList[target].push(num);
218         FrozenCoinsByTime(target, num, timestamp);
219     }
220 
221     function frozenAccountCoinByHour(address target, uint hourCount, uint256 num) onlyOwner public{
222         // 规定小时内冻结货币
223         uint timestamp = now + hourCount * 3600;
224         frozenAccountCoinList[target].push(timestamp);
225         frozenAccountCoinList[target].push(num);
226         FrozenCoinsByTime(target, num, timestamp);
227     }
228 
229     function _calFrozenAccountCoin(address target) public returns(uint num){
230         for(uint i = 0; i < frozenAccountCoinList[target].length; i++) {
231             if (now <= frozenAccountCoinList[target][i]){
232                 i = i + 1;
233                 num = num + frozenAccountCoinList[target][i];
234             }else{
235                 i = i + 1;
236             }
237         }
238         return num;
239     }
240 
241     function getFrozenAccountCoinCount(address target) onlyOwner view public returns(uint num){
242         num = _calFrozenAccountCoin(target);
243         return num;
244     }
245 
246     /* 从其他账户转移资产 */
247     function transferFrom(address _from, address _to, uint256 _value) onlyOwner public returns (bool success) {
248         _transfer(_from, _to, _value);
249         return true;
250     }
251 
252     /**
253      * 销毁其他账户代币
254      */
255     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
256         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
257         //require(_value <= allowance[_from][msg.sender]);    // Check allowance
258         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
259         //allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
260         totalSupply -= _value;                              // Update totalSupply
261         Burn(_from, _value);
262         return true;
263     }
264 
265 //    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
266 //        sellPrice = newSellPrice;
267 //        buyPrice = newBuyPrice;
268 //    }
269 //
270 //    /// @notice Buy tokens from contract by sending ether
271 //    function buy() payable public {
272 //        uint amount = msg.value / buyPrice;               // calculates the amount
273 //        _transfer(this, msg.sender, amount);              // makes the transfers
274 //    }
275 //
276 //    function sell(uint256 amount) public {
277 //        require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
278 //        _transfer(msg.sender, this, amount);              // makes the transfers
279 //        msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
280 //    }
281 
282 //    function aa() view public returns(address aa){
283 //        return msg.sender;
284 //    }
285 //
286 //    function bb() view public returns(address bb){
287 //        return owner;
288 //    }
289 }