1 /*
2 Implements DET token standard ERC20
3 POWER BY DET
4 .*/
5 
6 pragma solidity ^0.4.21;
7 
8 contract EIP20Interface {
9     /* This is a slight change to the ERC20 base standard.
10     function totalSupply() constant returns (uint256 supply);
11     is replaced with:
12     uint256 public totalSupply;
13     This automatically creates a getter function for the totalSupply.
14     This is moved to the base contract since public getter functions are not
15     currently recognised as an implementation of the matching abstract
16     function by the compiler.
17     */
18     /// total amount of tokens
19     uint256 public totalSupply;
20 
21     /// @param _owner The address from which the balance will be retrieved
22     /// @return The balance
23     function balanceOf(address _owner) public view returns (uint256 balance);
24 
25     /// @notice send `_value` token to `_to` from `msg.sender`
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transfer(address _to, uint256 _value) public returns (bool success);
30 
31     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
32     /// @param _from The address of the sender
33     /// @param _to The address of the recipient
34     /// @param _value The amount of token to be transferred
35     /// @return Whether the transfer was successful or not
36     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
37 
38     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
39     /// @param _spender The address of the account able to transfer the tokens
40     /// @param _value The amount of tokens to be approved for transfer
41     /// @return Whether the approval was successful or not
42     function approve(address _spender, uint256 _value) public returns (bool success);
43 
44     /// @param _owner The address of the account owning tokens
45     /// @param _spender The address of the account able to transfer the tokens
46     /// @return Amount of remaining tokens allowed to spent
47     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
48 
49     // solhint-disable-next-line no-simple-event-func-name
50     event Transfer(address indexed _from, address indexed _to, uint256 _value);
51     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
52 }
53 
54 // ERC2.0 代币
55 contract DET is EIP20Interface {
56     uint256 constant private MAX_UINT256 = 2**256 - 1;
57     //创始者
58     address public god;
59     // 点卡余额
60     mapping (address => uint256) public balances;
61     // 点卡授权维护
62     mapping (address => mapping (address => uint256)) public allowed;
63 
64     //服务节点
65     struct ServiceStat {
66         address user;
67         uint64 serviceId;
68         string serviceName;
69         uint256 timestamp; 
70     }
71 
72     //每个用户状态状态
73     mapping (address => mapping (uint64 => ServiceStat)) public serviceStatMap;
74 
75     //服务价格
76     struct ServiceConfig{
77         uint64 serviceId;
78         string serviceName;
79         uint256 price;
80         uint256 discount;
81         address fitAddr;
82         string detail;
83     }
84     //服务价格配置
85     mapping (uint64 => ServiceConfig) public serviceConfgMap;
86     mapping (uint64 => uint256) public serviceWin;
87     /*
88     NOTE:
89     The following variables are OPTIONAL vanities. One does not have to include them.
90     They allow one to customise the token contract & in no way influences the core functionality.
91     Some wallets/interfaces might not even bother to look at this information.
92     */
93     string public name;                   //fancy name: eg Simon Bucks
94     uint8 public decimals;                //How many decimals to show.
95     string public symbol;                 //An identifier: eg SBX
96     //兑换比例
97     uint256 public tokenPrice;
98     
99     //以下为ERC20的规范
100     constructor(
101         uint256 _initialAmount,
102         string _tokenName,
103         uint8 _decimalUnits,
104         string _tokenSymbol
105     ) public {
106         god = msg.sender;
107         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
108         totalSupply = _initialAmount;                        // Update total supply
109         name = _tokenName;                                   // Set the name for display purposes
110         decimals = _decimalUnits;                            // Amount of decimals for display purposes
111         symbol = _tokenSymbol;                               // Set the symbol for display purposes
112     }
113 
114     function transfer(address _to, uint256 _value) public returns (bool success) {
115         require(balances[msg.sender] >= _value);
116         balances[msg.sender] -= _value;
117         balances[_to] += _value;
118         emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
119         return true;
120     }
121 
122     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
123         uint256 allowance = allowed[_from][msg.sender];
124         require(balances[_from] >= _value && allowance >= _value);
125         balances[_to] += _value;
126         balances[_from] -= _value;
127         if (allowance < MAX_UINT256) {
128             allowed[_from][msg.sender] -= _value;
129         }
130         emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
131         return true;
132     }
133 
134     function balanceOf(address _owner) public view returns (uint256 balance) {
135         return balances[_owner];
136     }
137 
138     function approve(address _spender, uint256 _value) public returns (bool success) {
139         allowed[msg.sender][_spender] = _value;
140         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
141         return true;
142     }
143 
144     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
145         return allowed[_owner][_spender];
146     }
147 
148     //以下为服务相关
149     function getMsgSender() public view returns(address sender){
150         return msg.sender;
151     }
152 
153     //设置服务价格配置
154     function setConfig(uint64 _serviceId, string _serviceName, uint256 _price, uint256 _discount, address _fitAddr, string _desc) public returns (bool success){
155         require(msg.sender==god);
156         serviceConfgMap[_serviceId].serviceId = _serviceId;
157         serviceConfgMap[_serviceId].serviceName = _serviceName;
158         serviceConfgMap[_serviceId].price = _price;
159         serviceConfgMap[_serviceId].discount = _discount;
160         serviceConfgMap[_serviceId].fitAddr = _fitAddr;
161         serviceConfgMap[_serviceId].detail = _desc;
162         return true;
163     }
164 
165     //获取服务价格
166     function configOf(uint64 _serviceId) public view returns (string serviceName, uint256 price, uint256 discount, address addr, string desc){
167         serviceName = serviceConfgMap[_serviceId].serviceName;
168         price = serviceConfgMap[_serviceId].price;
169         discount = serviceConfgMap[_serviceId].discount;
170         addr = serviceConfgMap[_serviceId].fitAddr;
171         desc = serviceConfgMap[_serviceId].detail;
172     }
173 
174     //购买服务
175     function buyService(uint64 _serviceId,uint64 _count) public returns (uint256 cost, uint256 timestamp){
176         require(_count >= 1);
177         //计算多少点卡
178         //ServiceConfig storage config = serviceConfgMap[_serviceId];
179         cost = serviceConfgMap[_serviceId].price * serviceConfgMap[_serviceId].discount * _count / 100;
180         address fitAddr = serviceConfgMap[_serviceId].fitAddr;
181         //require(balances[msg.sender]>need);
182         if( transfer(fitAddr,cost ) == true ){
183             uint256 timeEx = serviceStatMap[msg.sender][_serviceId].timestamp;
184             if(timeEx == 0){
185                 serviceStatMap[msg.sender][_serviceId].serviceId = _serviceId;
186                 serviceStatMap[msg.sender][_serviceId].serviceName = serviceConfgMap[_serviceId].serviceName;
187                 serviceStatMap[msg.sender][_serviceId].user = msg.sender;
188                 serviceStatMap[msg.sender][_serviceId].timestamp = now + (_count * 86400);
189                 serviceWin[_serviceId] += cost;
190                 timestamp = serviceStatMap[msg.sender][_serviceId].timestamp;
191             }else{
192                 if(timeEx < now){
193                     timeEx = now;
194                 }
195                 timeEx += (_count * 86400);
196                 serviceStatMap[msg.sender][_serviceId].timestamp = timeEx;
197                 timestamp = timeEx;
198             }
199         }else{
200             timestamp = 0;
201         }
202         
203     }
204 
205     //购买服务
206     function buyServiceByAdmin(uint64 _serviceId,uint64 _count,address addr) public returns (uint256 cost, uint256 timestamp){
207         require(msg.sender==god);
208         require(_count >= 1);
209         //计算多少点卡
210         //ServiceConfig storage config = serviceConfgMap[_serviceId];
211         cost = serviceConfgMap[_serviceId].price * serviceConfgMap[_serviceId].discount * _count / 100;
212         address fitAddr = serviceConfgMap[_serviceId].fitAddr;
213         timestamp = 0;
214         require(balances[addr] >= cost);
215         balances[fitAddr] += cost;
216         balances[addr] -= cost;
217         emit Transfer(addr, fitAddr, cost); 
218 
219         uint256 timeEx = serviceStatMap[addr][_serviceId].timestamp;
220         if(timeEx == 0){
221             serviceStatMap[addr][_serviceId].serviceId = _serviceId;
222             serviceStatMap[addr][_serviceId].serviceName = serviceConfgMap[_serviceId].serviceName;
223             serviceStatMap[addr][_serviceId].user = addr;
224             serviceStatMap[addr][_serviceId].timestamp = now + (_count * 86400); 
225             serviceWin[_serviceId] += cost;
226             timestamp = serviceStatMap[addr][_serviceId].timestamp;
227         }else{
228             if(timeEx < now){
229                 timeEx = now;
230             }
231             timeEx += (_count * 86400);
232             serviceStatMap[addr][_serviceId].timestamp = timeEx;
233             timestamp = timeEx;
234         }    
235     }
236 
237     //获取服务时长
238     function getServiceStat(uint64 _serviceId) public view returns (uint256 timestamp){
239         timestamp = serviceStatMap[msg.sender][_serviceId].timestamp;
240     }
241     
242     //获取服务时长
243     function getServiceStatByAddr(uint64 _serviceId,address addr) public view returns (uint256 timestamp){
244         require(msg.sender==god);
245         timestamp = serviceStatMap[addr][_serviceId].timestamp;
246     }
247 
248     //admin
249     function getWin(uint64 _serviceId) public view returns (uint256 win){
250         require(msg.sender==god);
251         win = serviceWin[_serviceId];
252         return win;
253     }
254     //设置token price
255     function setPrice(uint256 _price) public returns (bool success){
256         require(msg.sender==god);
257         tokenPrice = _price;
258         return true;
259     }
260 
261     //get token price
262     function getPrice() public view returns (uint256 _price){
263         require(msg.sender==god);
264         _price = tokenPrice;
265         return tokenPrice;
266     }
267 }