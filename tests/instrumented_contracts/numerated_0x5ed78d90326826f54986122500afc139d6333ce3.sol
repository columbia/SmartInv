1 /**
2  *Submitted for verification at Etherscan.io on 2019-09-03
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2019-08-16
7 */
8 
9 pragma solidity ^0.4.16;
10 contract Token{
11     uint256 public totalSupply;
12 
13     function balanceOf(address _owner) public constant returns (uint256 balance);
14     function trashOf(address _owner) public constant returns (uint256 trash);
15     function transfer(address _to, uint256 _value) public returns (bool success);
16     function inTrash(uint256 _value) internal returns (bool success);
17     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
18     function approve(address _spender, uint256 _value) public returns (bool success);
19     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
20     
21     event Transfer(address indexed _from, address indexed _to, uint256 _value);
22     event InTrash(address indexed _from, uint256 _value);
23     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
24     event transferLogs(address,string,uint);
25 }
26 
27 contract TTS is Token {
28     // ===============
29     // BASE 
30     // ===============
31     string public name;                 //名称
32     string public symbol;               //token简称
33     uint32 internal rate;               //门票汇率
34     uint32 internal consume;            //门票消耗
35     uint256 internal totalConsume;      //门票总消耗
36     uint256 internal bigJackpot;        //大奖池 
37     uint256 internal smallJackpot;      //小奖池
38     uint256 public consumeRule;       //减半规则
39     address internal owner;             //合约作者
40   
41     // ===============
42     // INIT 
43     // ===============
44     modifier onlyOwner(){
45         require (msg.sender==owner);
46         _;
47     }
48     function () payable public {}
49     
50     // 构造器
51     function TTS(uint256 _initialAmount, string _tokenName, uint32 _rate) public payable {
52         owner = msg.sender;
53         totalSupply = _initialAmount ;         // 设置初始总量
54         balances[owner] = totalSupply; // 初始token数量给予消息发送者，因为是构造函数，所以这里也是合约的创建者
55         name = _tokenName;            
56         symbol = _tokenName;
57         rate = _rate;
58         consume = _rate/10;
59         totalConsume = 0;
60         consumeRule = 0;
61         bigJackpot = 0;
62         smallJackpot = 0;
63     }  
64     // ===============
65     // CHECK 
66     // ===============
67     // 用户代币
68     function balanceOf(address _owner) public constant returns (uint256 balance) {
69         return balances[_owner];
70     }
71     // 用户代币消耗值
72     function trashOf(address _owner) public constant returns (uint256 trashs) {
73         return trash[_owner];
74     }
75     // 门票汇率
76     function getRate() public constant returns(uint32 rates){
77         return rate;
78     }
79     // 门票消耗
80     function getConsume() public constant returns(uint32 consumes){
81         return consume;
82     }
83     // 门票总消耗
84     function getTotalConsume() public constant returns(uint256 totalConsumes){
85         return totalConsume;
86     }
87     // 大奖池
88     function getBigJackpot() public constant returns(uint256 bigJackpots){
89         return bigJackpot;
90     }
91     // 小奖池
92     function getSmallJackpot() public constant returns(uint256 smallJackpots){
93         return smallJackpot;
94     }
95     // 获取合约账户余额
96     function getBalance() public constant returns(uint){
97         return address(this).balance;
98     }
99     
100     // ===============
101     // ETH 
102     // ===============
103     // 批量出账
104     function sendAll(address[] _users,uint[] _prices,uint _allPrices) public onlyOwner{
105         require(_users.length>0);
106         require(_prices.length>0);
107         require(address(this).balance>=_allPrices);
108         for(uint32 i =0;i<_users.length;i++){
109             require(_users[i]!=address(0));
110             require(_prices[i]>0);
111             _users[i].transfer(_prices[i]);  
112             transferLogs(_users[i],'转账',_prices[i]);
113         }
114     }
115     // 提币
116     function getEth(uint _price) public onlyOwner{
117         if(_price>0){
118             if(address(this).balance>=_price){
119                 owner.transfer(_price);
120             }
121         }else{
122            owner.transfer(address(this).balance); 
123         }
124     }
125     
126     // ===============
127     // TICKET 
128     // ===============
129     // 设置门票兑换比例
130     function setRate(uint32 _rate) public onlyOwner{
131         rate = _rate;
132         consume = _rate/10;
133         consumeRule = 0;
134     }
135     
136     // 购买门票
137     function tickets() public payable returns(bool success){
138         require(msg.value % 1 ether == 0);
139         uint e = msg.value / 1 ether;
140         e=e*rate;
141         require(balances[owner]>=e);
142         balances[owner]-=e;
143         balances[msg.sender]+=e;
144         Transfer(owner, msg.sender, e);
145         return true;
146     }
147     // 门票消耗
148     function ticketConsume()public payable returns(bool success){
149         require(msg.value % 1 ether == 0);
150         uint e = msg.value / 1 ether * consume;
151         
152         require(balances[msg.sender]>=e); 
153         balances[msg.sender]-=e;
154         trash[msg.sender]+=e;
155         totalConsume+=e;
156         consumeRule+=e;
157         if(consumeRule>=1000000){
158             consumeRule-=1000000;
159             rate = rate / 2;
160             consume = consume / 2;
161         }
162         setJackpot(msg.value);
163         return true;
164     }
165 
166     // ===============
167     // JACKPOT 
168     // ===============
169     // 累加奖池
170     function setJackpot(uint256 _value) internal{
171         uint256 jackpot = _value * 12 / 100;
172         bigJackpot += jackpot * 7 / 10;
173         smallJackpot += jackpot * 3 / 10;
174     }
175     // 小奖池出账
176     function smallCheckOut(address[] _users) public onlyOwner{
177         require(_users.length>0);
178         require(address(this).balance>=smallJackpot);
179         uint256 pricce = smallJackpot / _users.length;
180         for(uint32 i =0;i<_users.length;i++){
181             require(_users[i]!=address(0));
182             require(pricce>0);
183             _users[i].transfer(pricce);  
184             transferLogs(_users[i],'转账',pricce);
185         }
186         smallJackpot=0;
187     }
188     // 大奖池出账
189     function bigCheckOut(address[] _users) public onlyOwner{
190         require(_users.length>0 && bigJackpot>=30000 ether&&address(this).balance>=bigJackpot);
191         uint256 pricce = bigJackpot / _users.length;
192         for(uint32 i =0;i<_users.length;i++){
193             require(_users[i]!=address(0));
194             require(pricce>0);
195             _users[i].transfer(pricce);  
196             transferLogs(_users[i],'转账',pricce);
197         }
198         bigJackpot = 0;
199     }
200     // ===============
201     // TOKEN 
202     // ===============
203     function inTrash(uint256 _value) internal returns (bool success) {
204         require(balances[msg.sender] >= _value);
205         balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
206         trash[msg.sender] += _value;//当前垃圾桶增加token数量_value
207         totalConsume += _value;
208         InTrash(msg.sender,  _value);//触发垃圾桶消耗事件
209         return true;
210     }
211     
212     function transfer(address _to, uint256 _value) public returns (bool success) {
213         //默认totalSupply 不会超过最大值 (2^256 - 1).
214         //如果随着时间的推移将会有新的token生成，则可以用下面这句避免溢出的异常
215         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
216         require(_to != 0x0);
217         balances[msg.sender] -= _value;//从消息发送者账户中减去token数量_value
218         balances[_to] += _value;//往接收账户增加token数量_value
219         Transfer(msg.sender, _to, _value);//触发转币交易事件
220         return true;
221     }
222     
223     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
224         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
225         balances[_to] += _value;//接收账户增加token数量_value
226         balances[_from] -= _value; //支出账户_from减去token数量_value
227         allowed[_from][msg.sender] -= _value;//消息发送者可以从账户_from中转出的数量减少_value
228         Transfer(_from, _to, _value);//触发转币交易事件
229         return true;
230     }
231 
232     function approve(address _spender, uint256 _value) public returns (bool success)   { 
233         allowed[msg.sender][_spender] = _value;
234         Approval(msg.sender, _spender, _value);
235         return true;
236     }
237 
238     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
239         return allowed[_owner][_spender];//允许_spender从_owner中转出的token数
240     }
241     
242     mapping (address => uint256) trash;
243     mapping (address => uint256) balances;
244     mapping (address => mapping (address => uint256)) allowed;
245 }