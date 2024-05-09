1 pragma solidity ^0.4.24;
2 
3 
4 contract Owned {
5     address public owner;
6     address public newOwner;
7     event OwnershipTransferred(address indexed _from, address indexed _to);
8     constructor() public {
9         owner = msg.sender;
10     }
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15     function transferOwnership(address _newOwner) public onlyOwner {
16         newOwner = _newOwner;
17     }
18     function acceptOwnership() public {
19         require(msg.sender == newOwner);
20         emit OwnershipTransferred(owner, newOwner);
21         owner = newOwner;
22         newOwner = address(0);
23     }
24 }
25 
26 library SafeMath {
27     
28     /**
29     * @dev Multiplies two numbers, throws on overflow.
30     */
31     function mul(uint256 a, uint256 b) 
32         internal 
33         pure 
34         returns (uint256 c) 
35     {
36         if (a == 0) {
37             return 0;
38         }
39         c = a * b;
40         require(c / a == b, "SafeMath mul failed");
41         return c;
42     }
43     /**
44     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45     */
46     function sub(uint256 a, uint256 b)
47         internal
48         pure
49         returns (uint256) 
50     {
51         require(b <= a, "SafeMath sub failed");
52         return a - b;
53     }
54     /**
55     * @dev Adds two numbers, throws on overflow.
56     */
57     function add(uint256 a, uint256 b)
58         internal
59         pure
60         returns (uint256 c) 
61     {
62         c = a + b;
63         require(c >= a, "SafeMath add failed");
64         return c;
65     }
66     
67     /**
68      * @dev gives square root of given x.
69      */
70     function sqrt(uint256 x)
71         internal
72         pure
73         returns (uint256 y) 
74     {
75         uint256 z = ((add(x,1)) / 2);
76         y = x;
77         while (z < y) 
78         {
79             y = z;
80             z = ((add((x / z),z)) / 2);
81         }
82     }
83     
84     /**
85      * @dev gives square. multiplies x by x
86      */
87     function sq(uint256 x)
88         internal
89         pure
90         returns (uint256)
91     {
92         return (mul(x,x));
93     }
94     
95     /**
96      * @dev x to the power of y 
97      */
98     function pwr(uint256 x, uint256 y)
99         internal 
100         pure 
101         returns (uint256)
102     {
103         if (x==0)
104             return (0);
105         else if (y==0)
106             return (1);
107         else 
108         {
109             uint256 z = x;
110             for (uint256 i=1; i < y; i++)
111                 z = mul(z,x);
112             return (z);
113         }
114     }
115     
116 }
117 
118 
119 contract ERC20Interface {
120     function totalSupply() public constant returns (uint);
121     function balanceOf(address tokenOwner) public constant returns (uint balance);
122     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
123     function transfer(address to, uint tokens) public returns (bool success);
124     function approve(address spender, uint tokens) public returns (bool success);
125     function transferFrom(address from, address to, uint tokens) public returns (bool success);
126     function withdraw() public;
127 
128     event Transfer(address indexed from, address indexed to, uint tokens);
129     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
130 }
131 
132 contract ChickenMarket is Owned{
133     using SafeMath for *;
134     
135     modifier notContract() {
136         require (msg.sender == tx.origin);
137         _;
138     }
139     
140     struct Card{
141         uint256 price;
142         address owner;  
143         uint256 payout;
144         uint256 divdent;
145     }
146     
147     Card public card1;
148     Card public card2;
149     Card public card3;
150     
151     bool public isOpen = true;
152 
153     uint256 public updateTime;
154     address public mainContract = 0x211f3175e3632ed194368311223bd4f4e834fc33;
155     ERC20Interface ChickenParkCoin;
156 
157     event Buy(
158         address indexed from,
159         address indexed to,
160         uint tokens,
161         uint card
162     );
163 
164     event Reset(
165         uint time,
166         uint finalPriceCard1,
167         uint finalPriceCard2,
168         uint finalPriceCard3
169     );
170     
171     constructor() public{
172         card1 = Card(1000e18, msg.sender, 0, 10);
173         card2 = Card(1000e18, msg.sender, 0, 20);
174         card3 = Card(1000e18, msg.sender, 0, 70);
175         
176         ChickenParkCoin = ERC20Interface(mainContract);
177         updateTime = now;
178     }
179     
180     function() public payable{
181 
182     }
183     
184     function tokenFallback(address _from, uint _value, bytes _data) public {
185         require(_from == tx.origin);
186         require(msg.sender == mainContract);
187         require(isOpen);
188 
189         address oldowner;
190         
191         if(uint8(_data[0]) == 1){
192             withdraw(1);
193             require(card1.price == _value);
194             card1.price = _value.mul(2);
195             oldowner = card1.owner;
196             card1.owner = _from;            
197             
198             ChickenParkCoin.transfer(oldowner, _value.mul(80) / 100);
199         } else if(uint8(_data[0]) == 2){
200             withdraw(2);
201             require(card2.price == _value);
202             card2.price = _value.mul(2);
203             oldowner = card2.owner;
204             card2.owner = _from;            
205             
206             ChickenParkCoin.transfer(oldowner, _value.mul(80) / 100);
207         } else if(uint8(_data[0]) == 3){
208             withdraw(3);
209             require(card3.price == _value);
210             card3.price = _value.mul(2);
211             oldowner = card3.owner;
212             card3.owner = _from;            
213 
214             ChickenParkCoin.transfer(oldowner, _value.mul(80) / 100);
215         }
216     }
217     
218     function withdraw(uint8 card) public {
219         uint _revenue;
220         if(card == 1){
221             _revenue = (getAllRevenue().mul(card1.divdent) / 100) - card1.payout;
222             card1.payout = (getAllRevenue().mul(card1.divdent) / 100);
223             card1.owner.transfer(_revenue);
224         } else if(card == 2){
225             _revenue = (getAllRevenue().mul(card2.divdent) / 100) - card2.payout;
226             card2.payout = (getAllRevenue().mul(card2.divdent) / 100);
227             card2.owner.transfer(_revenue);
228         } else if(card == 3){
229             _revenue = (getAllRevenue().mul(card3.divdent) / 100) - card3.payout;
230             card3.payout = (getAllRevenue().mul(card3.divdent) / 100);
231             card3.owner.transfer(_revenue);
232         } 
233     }
234     
235     
236     function getCardRevenue(uint8 card) view public returns (uint256){
237         if(card == 1){
238             return (getAllRevenue().mul(card1.divdent) / 100) - card1.payout;
239         } else if(card == 2){
240             return (getAllRevenue().mul(card2.divdent) / 100) - card2.payout;
241         } else if(card == 3){
242             return (getAllRevenue().mul(card3.divdent) / 100) - card3.payout;
243         }
244     }
245     
246     function getAllRevenue() view public returns (uint256){
247         return card1.payout.add(card2.payout).add(card3.payout).add(address(this).balance);
248     }
249     
250     function reSet() onlyOwner public {
251         require(now >= updateTime + 7 days);
252         withdraw(1);
253         withdraw(2);
254         withdraw(3);
255         
256         card1.price = 1000e18;
257         card2.price = 1000e18;
258         card3.price = 1000e18;
259         
260         card1.owner = owner;
261         card2.owner = owner;
262         card3.owner = owner;
263         
264         card1.payout = 0;
265         card2.payout = 0;
266         card3.payout = 0;
267         
268         ChickenParkCoin.transfer(owner, ChickenParkCoin.balanceOf(address(this)));
269         owner.transfer(address(this).balance);
270         updateTime = now;
271     }
272     
273     function withdrawMainDivi() public onlyOwner {
274        ChickenParkCoin.withdraw();
275     }
276     
277     function setStatus(bool _status) onlyOwner public {
278         isOpen = _status;
279     }
280 }