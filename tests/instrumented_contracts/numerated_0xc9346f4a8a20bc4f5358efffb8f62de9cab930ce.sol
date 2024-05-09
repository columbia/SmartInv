1 pragma solidity ^0.4.21;
2 
3 // Written by EtherGuy
4 // UI: GasWar.surge.sh 
5 // Mail: etherguy@mail.com
6 
7 contract GasWar{
8     
9     
10     // OPEN 20:00 -> 22:00 UTC 
11   //  uint256 public UTCStart = (20 hours); 
12 //    uint256 public UTCStop = (22 hours);
13     
14     // dev 
15     uint256 public UTCStart = (2 hours);
16     uint256 public UTCStop = (4 hours);
17     
18     uint256 public RoundTime = (5 minutes);
19     uint256 public Price = (0.005 ether);
20     
21     uint256 public RoundEndTime;
22     
23     
24     uint256 public GasPrice = 0;
25     address public Winner;
26     //uint256 public  Pot;
27     
28     uint256 public TakePot = 8000; // 80% 
29     
30 
31     
32     event GameStart(uint256 EndTime);
33     event GameWon(address Winner, uint256 Take);
34     event NewGameLeader(address Leader, uint256 GasPrice, uint256 pot);
35     event NewTX(uint256 pot);
36     
37     address owner;
38 
39     function GasWar() public {
40         owner = msg.sender;
41     }
42     
43     function Open() public view returns (bool){
44         uint256 sliced = now % (1 days);
45         return (sliced >= UTCStart && sliced <= UTCStop);
46     }
47     
48     function NextOpen() public view returns (uint256, uint256){
49         
50         uint256 sliced = now % (1 days);
51         if (sliced > UTCStop){
52             uint256 ret2 = (UTCStop) - sliced + UTCStop;
53             return (ret2, now + ret2);
54         }
55         else{
56             uint256 ret1 = (UTCStart - sliced);
57             return (ret1, now + ret1);
58         }
59     }
60     
61     
62 
63 
64     
65     function Withdraw() public {
66        
67         //_withdraw(false);
68         // check game withdraws from now on, false prevent re-entrancy
69         CheckGameStart(false);
70     }
71     
72     // please no re-entrancy
73     function _withdraw(bool reduce_price) internal {
74         // One call. 
75          require((now > RoundEndTime));
76         require (Winner != 0x0);
77         
78         uint256 subber = 0;
79         if (reduce_price){
80             subber = Price;
81         }
82         uint256 Take = (mul(sub(address(this).balance,subber), TakePot)) / 10000;
83         Winner.transfer(Take);
84 
85         
86         emit GameWon(Winner, Take);
87         
88         Winner = 0x0;
89         GasPrice = 0;
90     }
91     
92     function CheckGameStart(bool remove_price) internal returns (bool){
93         if (Winner != 0x0){
94             // if game open remove price from balance 
95             // this is to make sure winner does not get extra eth from new round.
96             _withdraw(remove_price && Open()); // sorry mate, much gas.
97 
98         }
99         if (Winner == 0x0 && Open()){
100             Winner = msg.sender; // from withdraw the gas max is 0.
101             RoundEndTime = now + RoundTime;
102             emit GameStart(RoundEndTime);
103             return true;
104         }
105         return false;
106     }
107     
108     // Function to start game without spending gas. 
109     //function PublicCheckGameStart() public {
110     //    require(now > RoundEndTime);
111     //    CheckGameStart();
112     //}
113     // reverted; allows contract drain @ inactive, this should not be the case.
114         
115     function BuyIn() public payable {
116         // We are not going to do any retarded shit here 
117         // If you send too much or too less ETH you get rejected 
118         // Gas Price is OK but burning lots of it is BS 
119         // Sending a TX is 21k gas
120         // If you are going to win you already gotta pay 20k gas to set setting 
121         require(msg.value == Price);
122         
123         
124         if (now > RoundEndTime){
125             bool started = CheckGameStart(true);
126             require(started);
127             GasPrice = tx.gasprice;
128             emit NewGameLeader(msg.sender, GasPrice, address(this).balance + (Price * 95)/100);
129         }
130         else{
131             if (tx.gasprice > GasPrice){
132                 GasPrice = tx.gasprice;
133                 Winner = msg.sender;
134                 emit NewGameLeader(msg.sender, GasPrice, address(this).balance + (Price * 95)/100);
135             }
136         }
137         
138         // not reverted 
139         
140         owner.transfer((msg.value * 500)/10000); // 5%
141         
142         emit NewTX(address(this).balance + (Price * 95)/100);
143     }
144     
145     // Dev functions to change settings after this line 
146  
147      // dev close game 
148      // instructions 
149      // send v=10000 to this one 
150     function SetTakePot(uint256 v) public {
151         require(msg.sender==owner);
152         require (v <= 10000);
153         require(v >= 1000); // do not set v <10% prevent contract blackhole; 
154         TakePot = v;
155     }
156     
157     function SetTimes(uint256 NS, uint256 NE) public {
158         require(msg.sender==owner);
159         require(NS < (1 days));
160         require(NE < (1 days));
161         UTCStart = NS;
162         UTCStop = NE;
163     }
164     
165     function SetPrice(uint256 p) public {
166         require(msg.sender == owner);
167         require(!Open() && (Winner == 0x0)); // dont change game price while running you retard
168         Price = p;
169     }    
170     
171     function SetRoundTime(uint256 p) public{
172         require(msg.sender == owner);
173         require(!Open() && (Winner == 0x0));
174         RoundTime = p;
175     }   
176  
177  
178  
179  	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
180 		if (a == 0) {
181 			return 0;
182 		}
183 		uint256 c = a * b;
184 		assert(c / a == b);
185 		return c;
186 	}
187 
188 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
189 		// assert(b > 0); // Solidity automatically throws when dividing by 0
190 		uint256 c = a / b;
191 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
192 		return c;
193 	}
194 
195 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
196 		assert(b <= a);
197 		return a - b;
198 	}
199 
200 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
201 		uint256 c = a + b;
202 		assert(c >= a);
203 		return c;
204 	}
205  
206  
207     
208 }