1 pragma solidity ^0.4.24;
2 
3 contract Control {
4     address public owner;
5     bool public pause;
6 
7     event PAUSED();
8     event STARTED();
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     modifier whenPaused {
16         require(pause);
17         _;
18     }
19 
20     modifier whenNotPaused {
21         require(!pause);
22         _;
23     }
24 
25     function setOwner(address _owner) onlyOwner public {
26         owner = _owner;
27     }
28 
29     function setState(bool _pause) onlyOwner public {
30         pause = _pause;
31         if (pause) {
32             emit PAUSED();
33         } else {
34             emit STARTED();
35         }
36     }
37 
38 }
39 /**
40  * this contract stands for the holds of WestIndia group
41  * all income will be split to holders according to their holds
42  * user can buy holds from shareholders at his will
43  */
44 contract Share is Control {    
45     /**
46      * the holds of every holder
47      * the total holds stick to total
48      */
49     mapping (address => uint) public holds;
50 
51     /**
52      * since we don't record holders' address in a list
53      * and we don't want to loop holders list everytime when income
54      *
55      * we use a mechanism called 'watermark'
56      * 
57      * the watermark indicates the value that brought into each holds from the begining
58      * it only goes up when new income send to the contract
59 
60      * fullfilled indicate the amount that the holder has withdrawaled from his share
61      * it goes up when user withdrawal bonus
62      * and it goes up when user sell holds, goes down when user buy holds, since the total bonus of him stays the same.
63      */
64     mapping (address => uint256) public fullfilled;
65 
66     /**
67      * any one can setup a price to sell his holds
68      * if set to 0, means not on sell
69      */
70     mapping (address => uint256) public sellPrice;
71     mapping (address => uint256) public toSell;
72     
73     mapping (address => mapping(address => uint256)) public allowance;
74     uint256 public watermark;
75     uint256 public total;
76     uint256 public decimals;
77     
78     string public symbol;
79     string public name;
80     
81     event Transfer(address indexed from, address indexed to, uint256 tokens);
82     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
83     event INCOME(uint256);
84     event PRICE_SET(address holder, uint shares, uint256 price, uint sell);
85     event WITHDRAWAL(address owner, uint256 amount);
86     event SELL_HOLDS(address from, address to, uint amount, uint256 price);
87     event SEND_HOLDS(address from, address to, uint amount);
88 
89     /**
90      * at start the owner has 100% share, which is 10,000 holds
91      */
92     constructor(string _symbol, string _name, uint256 _total) public {        
93         symbol = _symbol;
94         name = _name;
95         owner = msg.sender;
96         total = _total;
97         holds[owner] = total;
98         decimals = 0;
99         pause = false;
100     }
101 
102     /**
103      * when there's income, the water mark goes up
104      */
105     function onIncome() public payable {
106         if (msg.value > 0) {
107             watermark += (msg.value / total);
108             assert(watermark * total > watermark);
109             emit INCOME(msg.value);
110         }
111     }
112 
113     /**
114      * automatically split income
115      */
116     function() public payable {
117         onIncome();
118     }
119 
120     function bonus() public view returns (uint256) {
121         return (watermark - fullfilled[msg.sender]) * holds[msg.sender];
122     }
123     
124     function setPrice(uint256 price, uint256 sell) public {
125         sellPrice[msg.sender] = price;
126         toSell[msg.sender] = sell;
127         emit PRICE_SET(msg.sender, holds[msg.sender], price, sell);
128     }
129 
130     /**
131      * withdrawal the bonus
132      */
133     function withdrawal() public whenNotPaused {
134         if (holds[msg.sender] == 0) {
135             //you don't have any, don't bother
136             return;
137         }
138         uint256 value = bonus();
139         fullfilled[msg.sender] = watermark;
140 
141         msg.sender.transfer(value);
142 
143         emit WITHDRAWAL(msg.sender, value);
144     }
145 
146     /**
147      * transfer holds from => to (only holds, no bouns)
148      * this will withdrawal the holder bonus of these holds
149      * and the to's fullfilled will go up, since total bonus unchanged, but holds goes more
150      */
151     function transferHolds(address from, address to, uint256 amount) internal {
152         require(holds[from] >= amount);
153         require(holds[to] + amount > holds[to]);
154 
155         uint256 fromBonus = (watermark - fullfilled[from]) * amount;
156         uint256 toBonus = (watermark - fullfilled[to]) * holds[to];
157         
158 
159         holds[from] -= amount;
160         holds[to] += amount;
161         fullfilled[to] = watermark - toBonus / holds[to];
162 
163         from.transfer(fromBonus);
164 
165         emit Transfer(from, to, amount);
166         emit WITHDRAWAL(from, fromBonus);
167     }
168 
169     /**
170      * one can buy holds from anyone who set up an price,
171      * and u can buy @ price higher than he setup
172      */
173     function buyFrom(address from) public payable whenNotPaused {
174         require(sellPrice[from] > 0);
175         uint256 amount = msg.value / sellPrice[from];
176 
177         if (amount >= holds[from]) {
178             amount = holds[from];
179         }
180 
181         if (amount >= toSell[from]) {
182             amount = toSell[from];
183         }
184 
185         require(amount > 0);
186 
187         toSell[from] -= amount;
188         transferHolds(from, msg.sender, amount);
189         
190         from.transfer(msg.value);
191         emit SELL_HOLDS(from, msg.sender, amount, sellPrice[from]);
192     }
193     
194     function balanceOf(address _addr) public view returns (uint256) {
195         return holds[_addr];
196     }
197     
198     function transfer(address to, uint amount) public whenNotPaused returns(bool) {
199         transferHolds(msg.sender, to, amount);
200         return true;
201     }
202     
203     function transferFrom(address from, address to, uint256 amount) public whenNotPaused returns (bool) {
204         require(allowance[from][msg.sender] >= amount);
205         
206         allowance[from][msg.sender] -= amount;
207         transferHolds(from, to, amount);
208         
209         return true;
210     }
211     
212     function approve(address to, uint256 amount) public returns (bool) {
213         allowance[msg.sender][to] = amount;
214         
215         emit Approval(msg.sender, to, amount);
216         return true;
217     }
218 }