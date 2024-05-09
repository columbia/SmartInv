1 pragma solidity ^0.6.0;
2 
3 
4 
5 library SafeMath {
6     
7     function add(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a + b;
9         require(c >= a, "SafeMath: addition overflow");
10 
11         return c;
12     }
13 
14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15         return sub(a, b, "SafeMath: subtraction overflow");
16     }
17 
18     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
19         require(b <= a, errorMessage);
20         uint256 c = a - b;
21 
22         return c;
23     }
24 
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
27         // benefit is lost if 'b' is also tested.
28         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
29         if (a == 0) {
30             return 0;
31         }
32 
33         uint256 c = a * b;
34         require(c / a == b, "SafeMath: multiplication overflow");
35 
36         return c;
37     }
38 
39     function div(uint256 a, uint256 b) internal pure returns (uint256) {
40         return div(a, b, "SafeMath: division by zero");
41     }
42 
43     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         // Solidity only automatically asserts when dividing by 0
45         require(b > 0, errorMessage);
46         uint256 c = a / b;
47         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48 
49         return c;
50     }
51 
52     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
53         return mod(a, b, "SafeMath: modulo by zero");
54     }
55 
56     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b != 0, errorMessage);
58         return a % b;
59     }
60 }
61 
62 
63  interface ERC20 {
64   function balanceOf(address who) external view returns (uint256);
65   function allowance(address owner, address spender) external  view returns (uint256);
66   function transfer(address to, uint256 value) external  returns (bool ok);
67   function transferFrom(address from, address to, uint256 value) external returns (bool ok);
68   function approve(address spender, uint256 value)external returns (bool ok);
69 }
70 
71 
72 contract Sale {
73     using SafeMath for uint256;
74 
75    uint256 public totalTokenForSell=5200000000000000000000000; //52,00,000 SWG for sell
76   
77     uint256 public totalTokensSold;
78     ERC20 public Token;
79     address payable public owner;
80   
81     uint256 public collectedETH;
82     uint256 public startDate;
83     bool public startDistribution;
84     mapping(address=>uint256)public tokensBought;
85    
86     
87     modifier onlyOwner(){
88         require(msg.sender==owner,"You aren't owner");
89         _;
90     }
91     
92     
93    
94     
95     modifier distributionStarted(){
96         require(startDistribution==true,"Token distribution has not started yet");
97         _;
98     }
99   
100   
101 
102     constructor(address _wallet) public {
103         owner=msg.sender;
104         Token=ERC20(_wallet);
105 
106     }
107 
108    
109     // receive FUNCTION
110     // converts ETH to TOKEN and sends new TOKEN to the sender
111     receive () payable external {
112         require(startDate>0 && now.sub(startDate) <= 7 days);
113         require(unsoldTokens()>0 && availableSWG()>=unsoldTokens());
114         require(msg.value>= 1 ether && msg.value <= 50 ether);
115          
116           uint256 amount;
117           
118       if(now.sub(startDate)  <= 1 days)
119       {
120          amount = msg.value.mul(1400);
121       }
122       else if(now.sub(startDate) > 1 days && now.sub(startDate) <= 2 days)
123       {
124            amount = msg.value.mul(1375);
125       }
126       else if(now.sub(startDate) > 2 days && now.sub(startDate) <= 3 days)
127       {
128            amount = msg.value.mul(1350);
129       }
130       else if(now.sub(startDate) > 3 days && now.sub(startDate) <= 4 days)
131       {
132            amount = msg.value.mul(1325);
133       }
134       else if(now.sub(startDate) > 4 days && now.sub(startDate) <= 5 days)
135       {
136            amount = msg.value.mul(1300);
137       }
138        else if(now.sub(startDate) > 5 days && now.sub(startDate) <= 6 days)
139       {
140            amount = msg.value.mul(1275);
141       }
142        else if(now.sub(startDate) > 6 days)
143       {
144            amount = msg.value.mul(1250);
145       }
146         require(amount<=unsoldTokens() && amount<=availableSWG());
147         totalTokensSold =totalTokensSold.add(amount);
148         collectedETH=collectedETH.add(msg.value);
149         tokensBought[msg.sender]=tokensBought[msg.sender].add(amount);
150     }
151 
152     // CONTRIBUTE FUNCTION
153     // converts ETH to TOKEN and sends new TOKEN to the 
154     
155     function contribute() external payable {
156        require(startDate>0 && now.sub(startDate) <= 7 days);
157         require(unsoldTokens()>0 && availableSWG()>=unsoldTokens());
158         require(msg.value>= 1 ether && msg.value <= 50 ether);
159         
160         uint256 amount;
161         
162        if(now.sub(startDate)  <= 1 days)
163       {
164          amount = msg.value.mul(1400);
165       }
166       else if(now.sub(startDate) > 1 days && now.sub(startDate) <= 2 days)
167       {
168            amount = msg.value.mul(1375);
169       }
170       else if(now.sub(startDate) > 2 days && now.sub(startDate) <= 3 days)
171       {
172            amount = msg.value.mul(1350);
173       }
174       else if(now.sub(startDate) > 3 days && now.sub(startDate) <= 4 days)
175       {
176            amount = msg.value.mul(1325);
177       }
178       else if(now.sub(startDate) > 4 days && now.sub(startDate) <= 5 days)
179       {
180            amount = msg.value.mul(1300);
181       }
182        else if(now.sub(startDate) > 5 days && now.sub(startDate) <= 6 days)
183       {
184            amount = msg.value.mul(1275);
185       }
186        else if(now.sub(startDate) > 6 days)
187       {
188            amount = msg.value.mul(1250);
189       }
190    
191        require(amount<=unsoldTokens()  && amount<=availableSWG());
192        totalTokensSold =totalTokensSold.add(amount);
193        collectedETH=collectedETH.add(msg.value);
194        tokensBought[msg.sender]=tokensBought[msg.sender].add(amount);
195     }
196     
197     
198     //function to claim tokens bought during the sale.
199     function claimTokens()public distributionStarted{
200         require(tokensBought[msg.sender]>0);
201         uint256 amount=tokensBought[msg.sender];
202         tokensBought[msg.sender]=0;
203         Token.transfer(msg.sender,amount);
204     }
205     
206     //function to get the current price of token per ETH
207     
208     function getPrice()public view returns(uint256){
209         if(startDate==0)
210         {
211             return 0;
212         }
213         else if(now.sub(startDate)  <= 1 days)
214         {
215          return 1400;
216         }
217         else if(now.sub(startDate) > 1 days && now.sub(startDate) <= 2 days)
218         {
219            return 1375;
220         }
221         else if(now.sub(startDate) > 2 days && now.sub(startDate) <= 3 days)
222         {
223            return 1350;
224         }
225         else if(now.sub(startDate) > 3 days && now.sub(startDate) <= 4 days)
226         {
227            return 1325;
228         }
229          else if(now.sub(startDate) > 4 days && now.sub(startDate) <= 5 days)
230         {
231            return 1300;
232         }
233          else if(now.sub(startDate) > 5 days && now.sub(startDate) <= 6 days){
234             return 1275;
235         }
236           else if(now.sub(startDate) > 6 days){
237              return 1250;
238          }
239     }
240     
241     //function to withdraw collected ETH
242      //only owner can call this function
243      
244     function withdrawCollectedETH()public onlyOwner{
245         require(collectedETH>0 && address(this).balance>=collectedETH);
246         uint256 amount=collectedETH;
247         collectedETH=0;
248         owner.transfer(amount);
249     }
250     
251     //function to withdraw unsold SWG in this contract
252      //only owner can call this function
253      
254     function withdrawUnsoldSWG()public onlyOwner{
255         require(unsoldTokens()>0 && availableSWG()>=unsoldTokens());
256         Token.transfer(owner,unsoldTokens());
257     }
258     
259     //function to start the Sale
260     //only owner can call this function
261      
262     function startSale()public onlyOwner{
263         require(startDate==0);
264         startDate=now;
265     }
266     //function to start the token distribution 
267     //only owner can call this function
268     function startTokenDistribution()public onlyOwner{
269         require(startDistribution==false,"Distribution is already started");
270         startDistribution=true;
271     }
272     
273     //function to return the available SWG in the contract
274     function availableSWG()public view returns(uint256){
275         return Token.balanceOf(address(this));
276     }
277     
278     //function to return the amount of unsold SWG tokens
279     function unsoldTokens()public view returns(uint256){
280         return totalTokenForSell.sub(totalTokensSold);
281     }
282 
283 }