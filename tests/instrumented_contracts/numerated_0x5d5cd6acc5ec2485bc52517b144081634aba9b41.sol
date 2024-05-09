1 pragma solidity ^0.4.24;
2 
3 /////設定管理者/////
4 
5 contract owned {
6     address public owner;
7 
8     function owned() {
9         owner = msg.sender;
10     }
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15     function transferOwnership(address newOwner) onlyOwner {
16         owner = newOwner;
17     }
18 }    
19 
20 contract ERC20Basic {
21   uint256 public totalSupply;
22   function balanceOf(address who) public constant returns (uint256);
23   function transfer(address to, uint256 value) public returns(bool);
24   event Transfer(address indexed from, address indexed to, uint256 value);
25 }
26 
27 /////遊戲合約/////
28 
29 contract game is owned{
30     
31 //初始設定
32     address public tokenAddress = 0x340e85491c5F581360811d0cE5CC7476c72900Ba;
33     
34     mapping (address => uint) readyTime;
35     uint public amount = 1000*10**18 ;  //*100為10^2，幣為兩位小數
36     uint public cooldown = 300;  //冷卻時間(秒)
37     mapping (address => uint8) record;
38 
39 //管理權限
40     function set_amount(uint new_amount)onlyOwner{
41         amount = new_amount*10**18;
42     }
43     
44     function set_address(address new_address)onlyOwner{
45         tokenAddress = new_address;
46     }
47     
48     function set_cooldown(uint new_cooldown)onlyOwner{
49         cooldown = new_cooldown;
50     }
51     
52     function withdraw(uint _amount)onlyOwner{
53         require(ERC20Basic(tokenAddress).transfer(owner, _amount*10**18));
54     }
55     
56 //來猜拳!!! 
57     function (){
58         play_game(0);
59     }
60     
61     function play_paper(){
62         play_game(0);
63     }
64     
65     function play_scissors(){
66         play_game(1);
67     }
68     
69     function play_stone(){
70         play_game(2);
71     }
72     
73     function play_game(uint8 play) internal{
74         require(readyTime[msg.sender] < block.timestamp);
75         require(play <= 2);
76         
77         uint8 comp=uint8(uint(keccak256(block.difficulty, block.timestamp))%3);
78         uint8 result = compare(play, comp);
79         
80         record[msg.sender] = result * 9 + play * 3 + comp ;
81         
82         if (result == 2){ //玩家贏
83             require(ERC20Basic(tokenAddress).transfer(msg.sender, amount));
84         }
85         
86         else if(result == 1){ //平手
87         }
88         
89         else if(result == 0) //玩家輸
90             readyTime[msg.sender] = block.timestamp + cooldown;
91     }
92     
93     function compare(uint8 player,uint computer) internal returns(uint8 result){
94         // input     0 => 布   1 => 剪刀   2 => 石頭
95         // output    0 => 輸   1 => 平手   2 => 贏
96         uint8 _result;
97         
98         if (player==0 && computer==2){  //布贏石頭 (玩家贏)
99             _result = 2;
100         }
101         
102         else if(player==2 && computer==0){ //石頭輸布(玩家輸)
103             _result = 0;
104         }
105         
106         else if(player == computer){ //平手
107             _result = 1;
108         }
109         
110         else{
111             if (player > computer){ //玩家贏 (玩家贏)
112                 _result = 2;
113             }
114             else{ //玩家輸
115                 _result = 0;
116             }
117         }
118         return _result;
119     }
120     
121 //判斷function
122 
123     function judge(uint8 orig) internal returns(uint8 result, uint8 play, uint8 comp){
124         uint8 _result = orig/9;
125         uint8 _play = (orig%9)/3;
126         uint8 _comp = orig%3;
127         return(_result, _play, _comp);
128     }
129     
130     function mora(uint8 orig) internal returns(string _mora){
131         // 0 => 布   1 => 剪刀   2 => 石頭
132             if (orig == 0){
133                 return "paper";
134             }
135             else if (orig == 1){
136                 return "scissors";
137             }
138             else if (orig == 2){
139                 return "stone";
140             }
141             else {
142                 return "error";
143             }
144         }
145         
146     function win(uint8 _result) internal returns(string result){
147         // 0 => 輸   1 => 平手   2 => 贏
148         if (_result == 0){
149                 return "lose!!";
150             }
151             else if (_result == 1){
152                 return "draw~~";
153             }
154             else if (_result == 2){
155                 return "win!!!";
156             }
157             else {
158                 return "error";
159             }
160     }
161     
162     function resolve(uint8 orig) internal returns(string result, string play, string comp){
163         (uint8 _result, uint8 _play, uint8 _comp) = judge(orig);
164         return(win(_result), mora(_play), mora(_comp));
165     }
166     
167 //查詢
168 
169     function view_last_result(address _address) view public returns(string result, string player, string computer){
170         return resolve(record[_address]);
171     }
172         
173     function self_last_result() view public returns(string result, string player, string computer){
174         view_last_result(msg.sender);
175     }
176     
177     function view_readyTime(address _address) view public returns(uint _readyTime){
178         if (block.timestamp >= readyTime[_address]){
179         return 0 ;
180         }
181         else{
182         return readyTime[_address] - block.timestamp ;
183         }
184     }
185     
186     function self_readyTime() view public returns(uint _readyTime){
187         view_readyTime(msg.sender);
188     }
189     
190 }