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
65   function allowance(address owner, address spender) external  view returns (uint);
66   function transfer(address to, uint value) external  returns (bool ok);
67   function transferFrom(address from, address to, uint value) external returns (bool ok);
68   function approve(address spender, uint value)external returns (bool ok);
69 }
70 
71 
72 contract Sale {
73     using SafeMath for uint256;
74 
75   
76     uint256 public totalSold;
77     ERC20 public Token;
78     address payable public owner;
79   
80     uint256 public collectedETH;
81     uint256 public startDate;
82 
83   
84   
85 
86     constructor(address _wallet) public {
87         owner=msg.sender;
88         Token=ERC20(_wallet);
89 
90     }
91 
92    
93     // receive FUNCTION
94     // converts ETH to TOKEN and sends new TOKEN to the sender
95     receive () payable external {
96         require(startDate>0 && now.sub(startDate) <= 7 days);
97         require(Token.balanceOf(address(this))>0);
98         require(msg.value>= 1 ether && msg.value <= 50 ether);
99          
100           uint256 amount;
101           
102       if(now.sub(startDate)  <= 1 days)
103       {
104          amount = msg.value.mul(35);
105       }
106       else if(now.sub(startDate) > 1 days && now.sub(startDate) <= 2 days)
107       {
108            amount = msg.value.mul(34);
109       }
110       else if(now.sub(startDate) > 2 days && now.sub(startDate) <= 3 days)
111       {
112            amount = msg.value.mul(33);
113       }
114       else if(now.sub(startDate) > 3 days && now.sub(startDate) <= 4 days)
115       {
116            amount = msg.value.mul(32);
117       }
118       else if(now.sub(startDate) > 4 days)
119       {
120            amount = msg.value.mul(31);
121       }
122         require(amount<=Token.balanceOf(address(this)));
123         totalSold =totalSold.add(amount);
124         collectedETH=collectedETH.add(msg.value);
125         Token.transfer(msg.sender, amount);
126     }
127 
128     // CONTRIBUTE FUNCTION
129     // converts ETH to TOKEN and sends new TOKEN to the 
130     
131     function contribute() external payable {
132        require(startDate>0 && now.sub(startDate) <= 7 days);
133         require(Token.balanceOf(address(this))>0);
134         require(msg.value>= 1 ether && msg.value <= 50 ether);
135         
136         uint256 amount;
137         
138        if(now.sub(startDate)  <= 1 days)
139        {
140          amount = msg.value.mul(35);
141         }
142         else if(now.sub(startDate) > 1 days && now.sub(startDate) <= 2 days)
143         {
144            amount = msg.value.mul(34);
145         }
146         else if(now.sub(startDate) > 2 days && now.sub(startDate) <= 3 days)
147         {
148             amount = msg.value.mul(33);
149         }
150         else if(now.sub(startDate) > 3 days && now.sub(startDate) <= 4 days)
151         {
152            amount = msg.value.mul(32);
153         }
154         else if(now.sub(startDate) > 4 days)
155         {
156            amount = msg.value.mul(31);
157         }
158    
159         require(amount<=Token.balanceOf(address(this)));
160         totalSold =totalSold.add(amount);
161         collectedETH=collectedETH.add(msg.value);
162         Token.transfer(msg.sender, amount);
163     }
164     
165     //function to get the current price of token per ETH
166     
167     function getPrice()public view returns(uint256){
168         if(startDate==0)
169         {
170             return 0;
171         }
172         else if(now.sub(startDate)  <= 1 days)
173         {
174          return 35;
175         }
176         else if(now.sub(startDate) > 1 days && now.sub(startDate) <= 2 days)
177         {
178            return 34;
179         }
180         else if(now.sub(startDate) > 2 days && now.sub(startDate) <= 3 days)
181         {
182            return 33;
183         }
184         else if(now.sub(startDate) > 3 days && now.sub(startDate) <= 4 days)
185         {
186            return 32;
187         }
188          else if(now.sub(startDate) > 4 days)
189         {
190            return 31;
191         }
192     }
193     
194     
195     //function to change the owner
196     //only owner can call this function
197     
198     function changeOwner(address payable _owner) public {
199         require(msg.sender==owner);
200         owner=_owner;
201     }
202     
203     //function to withdraw collected ETH
204      //only owner can call this function
205      
206     function withdrawETH()public {
207         require(msg.sender==owner && address(this).balance>0 && collectedETH>0);
208         uint256 amount=collectedETH;
209         collectedETH=0;
210         owner.transfer(amount);
211     }
212     
213     //function to withdraw available JUl in this contract
214      //only owner can call this function
215      
216     function withdrawJUL()public{
217          require(msg.sender==owner && Token.balanceOf(address(this))>0);
218          Token.transfer(owner,Token.balanceOf(address(this)));
219     }
220     
221     //function to start the Sale
222     //only owner can call this function
223      
224     function startSale()public{
225         require(msg.sender==owner && startDate==0);
226         startDate=now;
227     }
228     
229     //function to return the available JUL in the contract
230     function availableJUL()public view returns(uint256){
231         return Token.balanceOf(address(this));
232     }
233 
234 }