1 pragma solidity ^0.4.18;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract BGXToken {
6     // 以下参数测试时会临时修改，在正式发布时需要修正为正式参数 ======>
7     string public name = "BIT GAME EXCHANGE";
8     string public symbol = "BGX";
9 
10     address ethFundAddress = 0x7C235ac7b006d829990384018B0E98fDf0bA5EF7; // 以太坊轉存地址
11     address icoAddress = 0xC817a2afe8F6ba1a697dAaA1df834e18Be9403e7; // ICO地址
12     address[] foundationAddresses = [0xBc9d9A1EE11dC2803BA2daaAa892483052Ed97f5,
13                                      0x3CA55e25C110b175B6622586aC31a6682a916670,
14                                      0xF13b2d7c5d6d6E93f79D41FA72cFD33A75c0607d,
15                                      0xc321Cf1D0ab11743cB5dDB4d77F6Ede8a08D3281,
16                                      0xf7179c8A47F511E4fcAcA9b6187ED4052cBBB7BB,
17                                      0x516c06F2A390E62c2F6cB3C2E38c5c6dF5A17141,
18                                      0xE71a86f7FFa3E3aA92e5cA6b6df8B56d8600c7D9]; // 基金会地址，7个
19     address[] teamAddresses = [0x3CFdEC9041b04a7eEb07a732B964a5B33f9Ebe1F]; // 团队地址，1个
20     address[] miningAddresses = [0x710967a31D79BCFBF053292aB21Bbc559e288407,
21                                  0x7bF52Ef4b6e8bEeB24c4Dea4c8e94177739561a0]; // 挖矿地址，2个
22     address[] angelAddresses = [0x122399734D64d6c4aa46b85959A3304CA812161f]; // 天使地址，1个
23     address[] cornerstoneAddresses = [0x9d35F83982A479F611fa893452f6876972Ec6348,
24                                       0x1EAf530897EB1D93fF4373889d9cfd5a1E405D1B,
25                                       0x377221D5b7776C1Ba4B8e8d11a32CF9a7469A095,
26                                       0xc4381bc9dDFaa8A9954CF2615F80F8Fc145E024F,
27                                       0x699a3be17F729F3eB965fBb7d71Db185016B1215,
28                                       0x9F793B134E41Bb404142B598E05Ea6ed5477D392,
29                                       0xA7FF388DAfD240505f9a1d3ca37c15E058B9D4ea]; // 基石地址，7个
30     address[] preIcoAddresses = [0x4d1Ffd49d47552adcaf1729b9C4A2320419b81E1]; // PreICO地址，1个
31 
32     uint256 startTime = 1525708800; // 开始时间戳，2018/5/8 0:0:0 UTC-0
33     uint256 endTime = 1528473600; // 结束时间戳，2018/6/9 0:0:0 UTC-0
34     uint256 lockEndTime = 1528473600; // 锁定结束时间戳，2018/6/9 0:0:0 UTC-0
35     // <====== 正式发布需要修正的参数
36 
37     uint256 public decimals = 18;
38     uint256 DECIMALSFACTOR = 10 ** decimals;
39     uint256 constant weiDECIMALS = 18; // 以太币的小数位
40     uint256 weiFACTOR = 10 ** weiDECIMALS; // 以太币的单位换算值
41 
42     uint256[] foundationAmounts = [5 * (10**8) * DECIMALSFACTOR,
43                                    5 * (10**8) * DECIMALSFACTOR,
44                                    1 * (10**8) * DECIMALSFACTOR,
45                                    1 * (10**8) * DECIMALSFACTOR,
46                                    1 * (10**8) * DECIMALSFACTOR,
47                                    1 * (10**8) * DECIMALSFACTOR,
48                                    1 * (10**8) * DECIMALSFACTOR];
49     uint256[] teamAmounts = [15 * (10**8) * DECIMALSFACTOR];
50     uint256[] miningAmounts = [15 * (10**8) * DECIMALSFACTOR,
51                                15 * (10**8) * DECIMALSFACTOR];
52     uint256[] angelAmounts = [5 * (10**8) * DECIMALSFACTOR];
53     uint256[] cornerstoneAmounts = [1 * (10**8) * DECIMALSFACTOR,
54                                     1 * (10**8) * DECIMALSFACTOR,
55                                     1 * (10**8) * DECIMALSFACTOR,
56                                     1 * (10**8) * DECIMALSFACTOR,
57                                     1 * (10**8) * DECIMALSFACTOR,
58                                     2 * (10**8) * DECIMALSFACTOR,
59                                     3 * (10**8) * DECIMALSFACTOR];
60     uint256[] preIcoAmounts = [5 * (10**8) * DECIMALSFACTOR];
61 
62     address contractOwner;
63     uint256 ethRaised = 0; // 收到的ETH总数量，单位Wei
64     uint256 donationCount; // 参与的总次数
65 
66     uint256 public totalSupply = 100 * (10**8) * DECIMALSFACTOR; // 总量100亿
67     uint256 public availableSupply = totalSupply; // 剩余的代币数量
68     uint256 hardCap = 30000 * weiFACTOR; // 硬顶3万ETH
69     uint256 minimumDonation = 1 * 10 ** (weiDECIMALS - 1); // 最低参与0.1ETH才能参与
70 
71     bool public finalised = false;
72 
73     // 存储所有用户的代币余额值
74     mapping (address => uint256) public balanceOf;
75     mapping (address => mapping (address => uint256)) public allowance;
76 
77     // This generates a public event on the blockchain that will notify clients
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     // This notifies clients about the amount burnt
81     event Burn(address indexed from, uint256 value);
82 
83     function BGXToken() public {
84         contractOwner = msg.sender;
85 
86         // 采用累加方式，防止有地址重复
87         uint i = 0;
88         for (i = 0; i < foundationAddresses.length; i++){
89             balanceOf[foundationAddresses[i]] += foundationAmounts[i];
90             availableSupply -= foundationAmounts[i];
91             emit Transfer(address(0), foundationAddresses[i], foundationAmounts[i]);
92         }
93         for (i = 0; i < teamAddresses.length; i++){
94             balanceOf[teamAddresses[i]] += teamAmounts[i];
95             availableSupply -= teamAmounts[i];
96             emit Transfer(address(0), teamAddresses[i], teamAmounts[i]);
97         }
98         for (i = 0; i < miningAddresses.length; i++){
99             balanceOf[miningAddresses[i]] += miningAmounts[i];
100             availableSupply -= miningAmounts[i];
101             emit Transfer(address(0), miningAddresses[i], miningAmounts[i]);
102         }
103         for (i = 0; i < angelAddresses.length; i++){
104             balanceOf[angelAddresses[i]] += angelAmounts[i];
105             availableSupply -= angelAmounts[i];
106             emit Transfer(address(0), angelAddresses[i], angelAmounts[i]);
107         }
108         for (i = 0; i < cornerstoneAddresses.length; i++){
109             balanceOf[cornerstoneAddresses[i]] += cornerstoneAmounts[i];
110             availableSupply -= cornerstoneAmounts[i];
111             emit Transfer(address(0), cornerstoneAddresses[i], cornerstoneAmounts[i]);
112         }
113         for (i = 0; i < preIcoAddresses.length; i++){
114             balanceOf[preIcoAddresses[i]] += preIcoAmounts[i];
115             availableSupply -= preIcoAmounts[i];
116             emit Transfer(address(0), preIcoAddresses[i], preIcoAmounts[i]);
117         }
118 
119         // 剩下的代币初始都存在ICO的地址上
120         balanceOf[icoAddress] = availableSupply;
121         emit Transfer(address(0), icoAddress, availableSupply);
122     }
123 
124     // fallback方法，如果用户未在转账data中添加数据，默认是走这个方法
125     function () payable public {
126         require(!finalised);
127 
128         // 判断是否在项目规定的时间范围内
129         require(block.timestamp >= startTime);
130         require(block.timestamp <= endTime);
131 
132         // 判断硬顶
133         require(ethRaised < hardCap);
134 
135         // 达到最低捐赠额度才能继续，否则失败
136         require(msg.value >= minimumDonation);
137 
138         uint256 etherValue = msg.value;
139 
140         // 边界条件，未超过部分的ETH正常收纳，超过的部分退回给用户
141         if (ethRaised + etherValue > hardCap){
142             etherValue = hardCap - ethRaised;
143             // 超过的部分退回给用户
144             assert(msg.value > etherValue);
145             msg.sender.transfer(msg.value - etherValue);
146         }
147 
148         // 转移ETH到指定ETH存币地址
149         ethFundAddress.transfer(etherValue);
150 
151         donationCount += 1;
152         ethRaised += etherValue;
153     }
154 
155     /**
156      * Internal transfer, only can be called by this contract
157      */
158     function _transfer(address _from, address _to, uint _value) internal {
159         // Prevent transfer to 0x0 address. Use burn() instead
160         require(_to != 0x0);
161         // Check if the sender has enough
162         require(balanceOf[_from] >= _value);
163         // Check for overflows
164         require(balanceOf[_to] + _value > balanceOf[_to]);
165         // Save this for an assertion in the future
166         uint previousBalances = balanceOf[_from] + balanceOf[_to];
167         // Subtract from the sender
168         balanceOf[_from] -= _value;
169         // Add the same to the recipient
170         balanceOf[_to] += _value;
171         emit Transfer(_from, _to, _value);
172         // Asserts are used to use static analysis to find bugs in your code. They should never fail
173         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
174     }
175 
176     function _isInWhiteAddresses(address _from) internal view returns (bool success) {
177         if (icoAddress == _from){
178             return true;
179         }
180         uint i = 0;
181         for (i = 0; i < foundationAddresses.length; i++){
182             if (foundationAddresses[i] == _from){
183                 return true;
184             }
185         }
186         for (i = 0; i < teamAddresses.length; i++){
187             if (teamAddresses[i] == _from){
188                 return true;
189             }
190         }
191         for (i = 0; i < miningAddresses.length; i++){
192             if (miningAddresses[i] == _from){
193                 return true;
194             }
195         }
196         for (i = 0; i < angelAddresses.length; i++){
197             if (angelAddresses[i] == _from){
198                 return true;
199             }
200         }
201         for (i = 0; i < cornerstoneAddresses.length; i++){
202             if (cornerstoneAddresses[i] == _from){
203                 return true;
204             }
205         }
206         for (i = 0; i < preIcoAddresses.length; i++){
207             if (preIcoAddresses[i] == _from){
208                 return true;
209             }
210         }
211         return false;
212     }
213 
214     function transfer(address _to, uint256 _value) public {
215         require(block.timestamp > lockEndTime || _isInWhiteAddresses(msg.sender));
216         _transfer(msg.sender, _to, _value);
217     }
218 
219     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
220         require(block.timestamp > lockEndTime || _isInWhiteAddresses(_from));
221         require(_value <= allowance[_from][msg.sender]);     // Check allowance
222         allowance[_from][msg.sender] -= _value;
223         _transfer(_from, _to, _value);
224         return true;
225     }
226 
227     function approve(address _spender, uint256 _value) public returns (bool success) {
228         allowance[msg.sender][_spender] = _value;
229         return true;
230     }
231 
232     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
233         tokenRecipient spender = tokenRecipient(_spender);
234         if (approve(_spender, _value)) {
235             spender.receiveApproval(msg.sender, _value, this, _extraData);
236             return true;
237         }
238     }
239 
240     function burn(uint256 _value) public returns (bool success) {
241         require(block.timestamp > lockEndTime);
242         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
243         balanceOf[msg.sender] -= _value;            // Subtract from the sender
244         totalSupply -= _value;                      // Update totalSupply
245         emit Burn(msg.sender, _value);
246         return true;
247     }
248 
249     function burnFrom(address _from, uint256 _value) public returns (bool success) {
250         require(block.timestamp > lockEndTime);
251         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
252         require(_value <= allowance[_from][msg.sender]);    // Check allowance
253         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
254         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
255         totalSupply -= _value;                              // Update totalSupply
256         emit Burn(_from, _value);
257         return true;
258     }
259 
260     function finalise() public {
261         require(msg.sender == contractOwner);
262         require(!finalised);
263 
264         finalised = true;
265     }
266 
267     function setLockEndTime(uint256 t) public {
268         require(msg.sender == contractOwner);
269         lockEndTime = t;
270     }
271 }