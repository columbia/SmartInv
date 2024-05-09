1 pragma solidity ^0.4.25;
2 
3 contract ERC20Interface 
4 {
5     function balanceOf(address tokenOwner) public view returns (uint balance);
6     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
7     function transfer(address to, uint tokens) public returns (bool success);
8     function approve(address spender, uint tokens) public returns (bool success);
9     function transferFrom(address from, address to, uint tokens) public returns (bool success);
10 
11     event Transfer(address indexed from, address indexed to, uint tokens);
12     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
13     mapping(address => mapping(address => uint)) allowed;
14 }
15 
16 contract lottrygame{
17     //base setting
18     uint256 public people;
19     uint numbers;
20     uint256 public tickamount = 100;
21     uint256 public winnergetETH1 = 0.05 ether;
22     uint256 public winnergetETH2 = 0.03 ether;
23     uint256 public winnergetETH3 = 0.02 ether;
24     uint public gamecount = 0;
25     uint public inputsbt = 100;
26     uint  black=1;
27     uint  red=2;
28     uint  yellow=3;
29     
30     address[] public tickplayers;
31     address public owner;
32     address tokenAddress = 0x503F9794d6A6bB0Df8FBb19a2b3e2Aeab35339Ad;//ttt
33     address poolwallet;
34     
35     bool public tickgamelock = true;
36     bool public full = true;
37     event tickwinner(uint,address,address,address,uint,uint,uint);
38     event ticksell(uint gettick,uint paytick);   
39     
40     modifier ownerOnly() {
41     require(msg.sender == owner);
42     _;
43 }
44     constructor() public {
45         owner = msg.sender;
46 }
47     //function can get ETH
48 function () external payable ownerOnly{
49     tickgamelock=false;
50     owner = msg.sender;
51     poolwallet = msg.sender;
52 }
53     //change winner can get ETH
54 function changewinnerget(uint ethamount) public ownerOnly{
55     require(ethamount!=0);
56     require(msg.sender==owner);
57     if(ethamount==1){
58     winnergetETH1 = 0.05 ether;
59     winnergetETH2 = 0.03 ether;
60     winnergetETH3 = 0.02 ether;
61     inputsbt = 100;
62     }
63     else if(ethamount==10){
64     winnergetETH1 = 0.12 ether;
65     winnergetETH2 = 0.08 ether;
66     winnergetETH3 = 0.05 ether;
67     inputsbt = 250;
68     }
69     else if(ethamount==100){
70     winnergetETH1 = 1 ether;
71     winnergetETH2 = 0.6 ether;
72     winnergetETH3 = 0.4 ether;
73     inputsbt = 1500;
74     }
75 }
76     //change tick amount
77 function changetickamount(uint256 _tickamount) public ownerOnly{
78     require(msg.sender==poolwallet);
79     tickamount = _tickamount;
80 }
81 
82     //players joingame
83 function jointickgame(uint gettick) public {
84     require(tickgamelock == false);
85     require(gettick<=tickamount&&gettick>0);
86     require(gettick<=10&&people<=100);
87     if(people<tickamount){
88         uint paytick=uint(inputsbt)*1e18*gettick;
89         uint i;
90         ERC20Interface(tokenAddress).transferFrom(msg.sender,address(this),paytick);
91         for (i=0 ;i<gettick;i++){
92         tickplayers.push(msg.sender);
93         people ++;}
94         emit ticksell(gettick,paytick);
95     }
96     else if (people<=tickamount){
97         paytick=uint(inputsbt)*1e18*gettick;
98         ERC20Interface(tokenAddress).transferFrom(msg.sender,address(this),paytick);
99         for (i=0 ;i<gettick;i++){
100         tickplayers.push(msg.sender);
101         people ++;}
102         emit ticksell(gettick,paytick);
103         require(full==false);
104         pictickWinner();
105     }
106 }
107 
108 //===================random====================\\
109 function changerandom(uint b,uint y,uint r)public ownerOnly{
110     require(msg.sender==owner);
111     black=b;
112     yellow=y;
113     red=r;
114 }
115 function tickrandom()private view returns(uint) {
116     return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp,tickamount+black))); 
117 }
118 function tickrandom1()private view returns(uint) {
119     return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp,tickamount+yellow)));
120 }
121 function tickrandom2()private view returns(uint) {
122     return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp,tickamount+red))); 
123 }
124 //===============================================\\
125 
126     //get winner in players
127 function pictickWinner()public ownerOnly{
128     require(msg.sender==poolwallet);
129     require(tickgamelock == false);
130     require(people>0);
131     uint tickindex = tickrandom() % (tickplayers.length);
132     uint tickindex1 = tickrandom1() % (tickplayers.length);
133     uint tickindex2 = tickrandom2() % (tickplayers.length);
134     address sendwiner = tickplayers[tickindex];
135     address sendwiner1 = tickplayers[tickindex1];
136     address sendwiner2 = tickplayers[tickindex2];
137     address(sendwiner).transfer(winnergetETH1);
138     address(sendwiner1).transfer(winnergetETH2);
139     address(sendwiner2).transfer(winnergetETH3);
140     tickplayers = new address[](0);
141     people = 0;
142     tickamount = 100;
143     gamecount++;
144     emit tickwinner(gamecount,sendwiner,sendwiner1,sendwiner2,tickindex,tickindex1,tickindex2);
145     
146     
147 }
148     //destory game
149 function killgame()public ownerOnly {
150     require(msg.sender==poolwallet);
151     selfdestruct(owner);
152 }
153 function changefull()public ownerOnly{
154     require(msg.sender==poolwallet);
155     if(full== true){
156         full=false;
157     }else if(full==false){
158         full=true;
159     }
160 }
161 
162     //setgamelock true=lock,false=unlock
163 function settickgamelock() public ownerOnly{
164     require(msg.sender==poolwallet);
165        if(tickgamelock == true){
166         tickgamelock = false;
167        }
168        else if(tickgamelock==false){
169            tickgamelock =true;
170        }
171     }
172     //transfer contract inside tokens to owner
173 function transferanyERC20token(address _tokenAddress,uint tokens)public ownerOnly{
174     require(msg.sender==poolwallet);
175     ERC20Interface(_tokenAddress).transfer(owner, tokens);
176 }
177 }