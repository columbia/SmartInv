1 pragma solidity ^0.4.25;
2 
3 //2018.12.03
4 
5 /////設定管理者/////
6 
7 contract owned {
8     address public owner;
9 
10     constructor() public{
11         owner = msg.sender;
12     }
13     modifier onlyOwner{
14         require(msg.sender == owner);
15         _;
16     }
17     function transferOwnership(address newOwner) public onlyOwner {
18         owner = newOwner;
19     }
20 }
21 
22 contract ERC20Basic {
23   uint256 public totalSupply;
24   function balanceOf(address who) public constant returns (uint256);
25   function transfer(address to, uint256 value) public returns(bool);
26 }
27 
28 /////遊戲合約/////
29 
30 contract game is owned{
31 
32 //初始設定
33     
34     bool public stop = false;
35     
36     address public tokenAddress_GIC = 0x340e85491c5F581360811d0cE5CC7476c72900Ba;
37     address public tokenAddress_Arina = 0xE6987CD613Dfda0995A95b3E6acBAbECecd41376;
38     
39     address public address_A = 0xcC22f3Bd8c684463c0Ed6659a001AA62e0a7A146;
40     address public address_B = 0xb0D63Fcfb2101C8a1B9b2f0Ff96A13CfEA1A2E65;
41 
42     mapping (address => uint) readyTime;
43     uint public airdrop_GIC = 25*10**18 ;  //酷紅幣為18位小數
44     uint public airdrop_Arina = 500*10**8 ;  //Arina幣為6位小數
45     
46     uint public total_airdrop_GIC = 21000000*10**18; //酷紅幣發送上限為2100萬顆 (小數點18位)
47     uint public total_airdrop_Arina = 84000000*10**8; //Arina發送上限為8400萬顆 (小數點6位)
48     
49     uint public sent_times = 0; //發送次數(初始為零)
50     uint public sent_limit = total_airdrop_GIC/airdrop_GIC; //發送幣上限次數
51 
52     uint public cooldown = 600;  //////冷卻時間(秒)600秒
53     uint24 public Probability = 1000000;  /////中獎機率1/1000000
54     
55     uint random_source = uint(keccak256(msg.sender, block.difficulty, now));
56     
57     event Play_game(address indexed from, uint8 player, uint8 comp, uint8 record);
58     //紀錄遊戲結果
59     event Random(address indexed from, uint24 random_player, uint24 random_lottery);
60     //記錄兩個亂數
61     
62 
63 //管理權限
64     
65 
66     function stop_game()onlyOwner public{
67         stop = true ;
68     }
69     
70     function start_game()onlyOwner public{
71         stop = false ;
72     }
73 
74     function set_address_GIC(address new_address)onlyOwner public{
75         tokenAddress_GIC = new_address;
76     }
77     
78     function set_address_Arina(address new_address)onlyOwner public{
79         tokenAddress_Arina = new_address;
80     }
81     
82     function set_address_A(address new_address)onlyOwner public{
83         address_A = new_address;
84     }
85     
86     function set_address_B(address new_address)onlyOwner public{
87         address_B = new_address;
88     }
89 
90     function set_cooldown(uint new_cooldown)onlyOwner public{
91         cooldown = new_cooldown;
92     }
93 
94     function withdraw_GIC(uint _amount)onlyOwner public{
95         require(ERC20Basic(tokenAddress_GIC).transfer(owner, _amount*10**18));
96     }
97     
98     function withdraw_Arina(uint _amount)onlyOwner public{
99         require(ERC20Basic(tokenAddress_Arina).transfer(owner, _amount*10**8));
100     }
101     
102     function withdraw_eth()onlyOwner public{
103         owner.transfer(address(this).balance);
104     }
105 
106 //來猜拳!!!
107     function () payable public{
108         if (msg.value == 0){
109         play_game(0);
110         }
111     }
112 
113     function play_paper()public{
114         play_game(0);
115     }
116 
117     function play_scissors()public{
118         play_game(1);
119     }
120 
121     function play_stone()public{
122         play_game(2);
123     }
124 
125     function play_game(uint8 player) internal{
126         require(stop == false);
127         
128         require(readyTime[msg.sender] < block.timestamp);
129         require(player <= 2);
130         
131         require(sent_times <= sent_limit);
132         //檢查遊戲次數未小於限制次數
133         
134         random_source += 1;
135 
136         uint8 comp=uint8(uint(keccak256(random_source, block.difficulty, block.timestamp))%3);
137         uint8 result = compare(player, comp);
138         
139 
140         if (result == 2){ //玩家贏
141             sent_times +=1 ;
142             require(ERC20Basic(tokenAddress_GIC).transfer(msg.sender, airdrop_GIC));
143             
144             (uint _player_amount,uint addressA_amount, uint addressB_amount)
145              = Arina_amount();
146              
147             require(ERC20Basic(tokenAddress_Arina).transfer(msg.sender, _player_amount));
148             require(ERC20Basic(tokenAddress_Arina).transfer(address_A , addressA_amount));
149             require(ERC20Basic(tokenAddress_Arina).transfer(address_B, addressB_amount));
150         }
151         
152         else if(result == 1){ //平手
153         }
154         
155         else if(result == 0){ //玩家輸
156             readyTime[msg.sender] = block.timestamp + cooldown;
157         }
158         
159         else revert();
160         
161         uint bal = ERC20Basic(tokenAddress_GIC).balanceOf(this) + ERC20Basic(tokenAddress_Arina).balanceOf(this);
162         
163         uint24 random_player = uint24(keccak256(msg.sender, now, random_source))%Probability;
164         uint24 random_lottery = uint24(keccak256(random_source, block.difficulty, bal))%Probability;
165         
166         emit Play_game(msg.sender, player, comp, result);
167         emit Random(msg.sender, random_player, random_lottery);
168         
169         //0-999999的亂數
170         
171         if (random_player == random_lottery){
172             uint8 _level = level_judgment(msg.sender);
173             uint _eth = eth_amount_judgment(_level);
174             if (address(this).balance >= _eth){
175                 msg.sender.transfer(_eth);
176             }
177             else{
178                 msg.sender.transfer(address(this).balance);
179             }
180             
181             //中獎的話傳送eth
182         }
183         
184     }
185 
186 //判斷用function
187 
188     function compare(uint8 _player,uint _comp) pure internal returns(uint8 result){
189         // input     0 => 布   1 => 剪刀   2 => 石頭
190         // output    0 => 輸   1 => 平手   2 => 贏
191         uint8 _result;
192 
193         if (_player==0 && _comp==2){  //布贏石頭 (玩家贏)
194             _result = 2;
195         }
196 
197         else if(_player==2 && _comp==0){ //石頭輸布(玩家輸)
198             _result = 0;
199         }
200 
201         else if(_player == _comp){ //平手
202             _result = 1;
203         }
204 
205         else{
206             if (_player > _comp){ //玩家贏 (玩家贏)
207                 _result = 2;
208             }
209             else{ //玩家輸
210                 _result = 0;
211             }
212         }
213         return _result;
214     }
215 
216 
217     function Arina_judgment() view public returns(uint _amount){
218         uint Arina_totBalance = ERC20Basic(tokenAddress_Arina).balanceOf(this);
219         if (Arina_totBalance >= total_airdrop_Arina/2){
220             return airdrop_Arina;
221         }
222         else if(total_airdrop_Arina/2 > Arina_totBalance
223         && Arina_totBalance >= total_airdrop_Arina/4){
224             return airdrop_Arina/2;
225         }
226         else if(total_airdrop_Arina/4 > Arina_totBalance
227         && Arina_totBalance >= total_airdrop_Arina/8){
228             return airdrop_Arina/4;
229         }
230         else if(total_airdrop_Arina/8 > Arina_totBalance
231         && Arina_totBalance >= total_airdrop_Arina/16){
232             return airdrop_Arina/8;
233         }
234         else if(total_airdrop_Arina/16 > Arina_totBalance
235         && Arina_totBalance >= total_airdrop_Arina/32){
236             return airdrop_Arina/16;
237         }
238         else if(total_airdrop_Arina/32 > Arina_totBalance
239         && Arina_totBalance >= total_airdrop_Arina/64){
240             return airdrop_Arina/32;
241         }
242         else if(total_airdrop_Arina/64 > Arina_totBalance
243         && Arina_totBalance >= total_airdrop_Arina/128){
244             return airdrop_Arina/64;
245         }
246         else if(total_airdrop_Arina/128 > Arina_totBalance
247         && Arina_totBalance >= total_airdrop_Arina/256){
248             return airdrop_Arina/128;
249         }
250         else if(total_airdrop_Arina/256 > Arina_totBalance
251         && Arina_totBalance >= total_airdrop_Arina/512){
252             return airdrop_Arina/256;
253         }
254         else if(total_airdrop_Arina/512 > Arina_totBalance){
255             return airdrop_Arina/512;
256         }
257         else revert();
258     }
259     
260     function level_judgment(address _address) view public returns(uint8 _level){
261         uint GIC_balance = ERC20Basic(tokenAddress_GIC).balanceOf(_address);
262         if (GIC_balance <= 1000*10**18){
263             return 1;
264         }
265         else if(1000*10**18 < GIC_balance && GIC_balance <=10000*10**18){
266             return 2;
267         }
268         else if(10000*10**18 < GIC_balance && GIC_balance <=100000*10**18){
269             return 3;
270         }
271         else if(100000*10**18 < GIC_balance && GIC_balance <=500000*10**18){
272             return 4;
273         }
274         else if(500000*10**18 < GIC_balance){
275             return 5;
276         }
277         else revert();
278     }
279     
280     function eth_amount_judgment(uint8 _level) pure public returns(uint _eth){
281         if (_level == 1){
282             return 1 ether;
283         }
284         else if (_level == 2){
285             return 3 ether;
286         }
287         else if (_level == 3){
288             return 5 ether;
289         }
290         else if (_level == 4){
291             return 10 ether;
292         }
293         else if (_level == 5){
294             return 20 ether;
295         }
296         else revert();
297     }
298     
299     function Arina_amount_judgment(uint8 _level, uint _Arina) 
300     pure public returns(uint _player, uint _addressA, uint _addressB){
301         if (_level == 1){
302             return (_Arina*5/10, _Arina*1/10, _Arina*4/10);
303         }
304         else if (_level == 2){
305             return (_Arina*6/10, _Arina*1/10, _Arina*3/10);
306         }
307         else if (_level == 3){
308             return (_Arina*7/10, _Arina*1/10, _Arina*2/10);
309         }
310         else if (_level == 4){
311             return (_Arina*8/10, _Arina*1/10, _Arina*1/10);
312         }
313         else if (_level == 5){
314             return (_Arina*9/10, _Arina*1/10, 0);
315         }
316         else revert();
317     }
318     
319     function Arina_amount() view public returns(uint _player, uint _addressA, uint _addressB){
320         uint8 _level = level_judgment(msg.sender);
321         uint _amount = Arina_judgment();
322         return Arina_amount_judgment(_level, _amount);
323     }
324     
325     function Arina_balance() view public returns(uint _balance){
326         return ERC20Basic(tokenAddress_Arina).balanceOf(this);
327     }
328 
329 
330 //查詢
331     
332     function view_readyTime(address _address) view public returns(uint _readyTime){
333         if (block.timestamp >= readyTime[_address]){
334             return 0 ;
335         }
336         else{
337             return readyTime[_address] - block.timestamp ;
338         }
339     }
340     function self_readyTime() view public returns(uint _readyTime){
341         return view_readyTime(msg.sender);
342     }
343 
344 }