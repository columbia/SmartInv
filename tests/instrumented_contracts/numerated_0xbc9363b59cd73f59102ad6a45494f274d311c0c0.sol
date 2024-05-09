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
44 contract Share is Control {    /**
45      * the holds of every holder
46      * the total holds stick to total
47      */
48     mapping (address => uint) public holds;
49 
50     /**
51      * since we don't record holders' address in a list
52      * and we don't want to loop holders list everytime when there is income
53      *
54      * we use a mechanism called 'watermark'
55      * 
56      * the watermark indicates the value that brought into each holds from the begining
57      * it only goes up when new income send to the contract
58 
59      * fullfilled indicate the amount that the holder has withdrawaled from his share
60      * it goes up when user withdrawal bonus
61      * and it goes up when user sell holds, goes down when user buy holds, since the total bonus of him stays the same.
62      */
63     mapping (address => uint256) public fullfilled;
64 
65     /**
66      * any one can setup a price to sell his holds
67      * if set to 0, means not on sell
68      */
69     mapping (address => uint256) public sellPrice;
70     mapping (address => uint256) public toSell;
71     mapping (address => mapping(address => uint256)) public allowance;
72     uint256 public watermark;
73     uint256 public total;
74     uint256 public decimals;
75     
76     string public symbol;
77     string public name;
78     
79     event Transfer(address indexed from, address indexed to, uint256 tokens);
80     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
81     event INCOME(uint256);
82     event PRICE_SET(address holder, uint shares, uint256 price, uint sell);
83     event WITHDRAWAL(address owner, uint256 amount);
84     event SELL_HOLDS(address from, address to, uint amount, uint256 price);
85     event SEND_HOLDS(address from, address to, uint amount);
86 
87     /**
88      * at start the owner has 100% share, which is 10,000 holds
89      */
90     constructor(string _symbol, string _name, uint256 _total) public {        
91         symbol = _symbol;
92         name = _name;
93         owner = msg.sender;
94         total = _total;
95         holds[owner] = total;
96         decimals = 0;
97         pause = false;
98     }
99 
100     /**
101      * when there's income, the water mark goes up
102      */
103     function onIncome() public payable {
104         if (msg.value > 0) {
105             watermark += (msg.value / total);
106             assert(watermark * total > watermark);
107             emit INCOME(msg.value);
108         }
109     }
110 
111     /**
112      * automatically split income
113      */
114     function() public payable {
115         onIncome();
116     }
117 
118     function bonus() public view returns (uint256) {
119         return (watermark - fullfilled[msg.sender]) * holds[msg.sender];
120     }
121     
122     function setPrice(uint256 price, uint256 sell) public {
123         sellPrice[msg.sender] = price;
124         toSell[msg.sender] = sell;
125         emit PRICE_SET(msg.sender, holds[msg.sender], price, sell);
126     }
127 
128     /**
129      * withdrawal the bonus
130      */
131     function withdrawal() public whenNotPaused {
132         if (holds[msg.sender] == 0) {
133             //you don't have any, don't bother
134             return;
135         }
136         uint256 value = bonus();
137         fullfilled[msg.sender] = watermark;
138 
139         msg.sender.transfer(value);
140 
141         emit WITHDRAWAL(msg.sender, value);
142     }
143 
144     /**
145      * transfer holds from => to (only holds, no bouns)
146      * this will withdrawal the holder bonus of these holds
147      * and the to's fullfilled will go up, since total bonus unchanged, but holds goes more
148      */
149     function transferHolds(address from, address to, uint256 amount) internal {
150         require(holds[from] >= amount);
151         require(holds[to] + amount > holds[to]);
152 
153         uint256 fromBonus = (watermark - fullfilled[from]) * amount;
154         uint256 toBonus = (watermark - fullfilled[to]) * holds[to];
155         
156 
157         holds[from] -= amount;
158         holds[to] += amount;
159         fullfilled[to] = watermark - toBonus / holds[to];
160 
161         from.transfer(fromBonus);
162 
163         emit Transfer(from, to, amount);
164         emit WITHDRAWAL(from, fromBonus);
165     }
166 
167     /**
168      * one can buy holds from anyone who set up an price,
169      * and u can buy @ price higher than he setup
170      */
171     function buyFrom(address from) public payable whenNotPaused {
172         require(sellPrice[from] > 0);
173         uint256 amount = msg.value / sellPrice[from];
174 
175         if (amount >= holds[from]) {
176             amount = holds[from];
177         }
178 
179         if (amount >= toSell[from]) {
180             amount = toSell[from];
181         }
182 
183         require(amount > 0);
184 
185         toSell[from] -= amount;
186         transferHolds(from, msg.sender, amount);
187         
188         from.transfer(msg.value);
189         emit SELL_HOLDS(from, msg.sender, amount, sellPrice[from]);
190     }
191     
192     function balanceOf(address _addr) public view returns (uint256) {
193         return holds[_addr];
194     }
195     
196     function transfer(address to, uint amount) public whenNotPaused returns(bool) {
197         transferHolds(msg.sender, to, amount);
198         return true;
199     }
200     
201     function transferFrom(address from, address to, uint256 amount) public whenNotPaused returns (bool) {
202         require(allowance[from][msg.sender] >= amount);
203         
204         allowance[from][msg.sender] -= amount;
205         transferHolds(from, to, amount);
206         
207         return true;
208     }
209     
210     function approve(address to, uint256 amount) public returns (bool) {
211         allowance[msg.sender][to] = amount;
212         
213         emit Approval(msg.sender, to, amount);
214         return true;
215     }
216     
217     function totalSupply() public view returns (uint256) {
218         return total;
219     }
220     
221     function allowance(address owner, address spender) public view returns (uint256) {
222         return allowance[owner][spender];
223     }
224 }