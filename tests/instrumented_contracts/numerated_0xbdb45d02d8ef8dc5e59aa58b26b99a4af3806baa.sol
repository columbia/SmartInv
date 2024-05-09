1 pragma solidity ^0.4.16;        
2    
3   contract CentraSale { 
4 
5     using SafeMath for uint; 
6 
7     address public contract_address = 0x96a65609a7b84e8842732deb08f56c3e21ac6f8a; 
8 
9     address public owner;
10     uint public cap;
11     uint public constant cap_max = 90000*10**18;
12     uint public constant min_value = 10**18*1/10; 
13     uint public constant max_value = 10**18*3000; 
14     uint public operation;
15     mapping(uint => address) public operation_address;
16     mapping(uint => uint) public operation_amount;
17 
18     uint256 public constant token_price = 10**18*1/200;  
19     uint256 public tokens_total;  
20 
21     uint public constant contract_start = 1505793600;
22     uint public constant contract_finish = 1507176000;
23 
24     uint public constant card_titanium_minamount = 500*10**18;
25     uint public constant card_titanium_first = 200;
26     mapping(address => uint) cards_titanium_check; 
27     address[] public cards_titanium;
28 
29     uint public constant card_black_minamount = 100*10**18;
30     uint public constant card_black_first = 500;
31     mapping(address => uint) public cards_black_check; 
32     address[] public cards_black;
33 
34     uint public constant card_metal_minamount = 40*10**18;
35     uint public constant card_metal_first = 750;
36     mapping(address => uint) cards_metal_check; 
37     address[] public cards_metal;      
38 
39     uint public constant card_gold_minamount = 30*10**18;
40     uint public constant card_gold_first = 1000;
41     mapping(address => uint) cards_gold_check; 
42     address[] public cards_gold;      
43 
44     uint public constant card_blue_minamount = 5/10*10**18;
45     uint public constant card_blue_first = 100000000;
46     mapping(address => uint) cards_blue_check; 
47     address[] public cards_blue;
48 
49     uint public constant card_start_minamount = 1/10*10**18;
50     uint public constant card_start_first = 100000000;
51     mapping(address => uint) cards_start_check; 
52     address[] public cards_start;
53       
54    
55     // Functions with this modifier can only be executed by the owner
56     modifier onlyOwner() {
57         if (msg.sender != owner) {
58             throw;
59         }
60         _;
61     }      
62  
63     // Constructor
64     function CentraSale() {
65         owner = msg.sender; 
66         operation = 0; 
67         cap = 0;        
68     }
69       
70     //default function for crowdfunding
71     function() payable {    
72 
73       if(msg.value <= min_value) throw;
74       if(msg.value >= max_value) throw;
75       if(now < contract_start) throw;
76       if(now > contract_finish) throw;                     
77 
78       if(cap + msg.value > cap_max) throw;         
79 
80       tokens_total = msg.value*10**18/token_price;
81       if(!(tokens_total > 0)) throw; 
82       
83       if(!contract_transfer(tokens_total)) throw;                
84 
85       cap = cap.add(msg.value); 
86       operations();
87       get_card();      
88     }    
89 
90     //Update operations
91     function operations() private returns (bool) {
92         operation_address[operation] = msg.sender;
93         operation_amount[operation] = msg.value;        
94         operation = operation.add(1);        
95         return true;
96     } 
97 
98     //Contract execute
99     function contract_transfer(uint _amount) private returns (bool) {      
100 
101       if(!contract_address.call(bytes4(sha3("transfer(address,uint256)")),msg.sender,_amount)) {    
102         return false;
103       }
104       return true;
105     }        
106 
107     //Withdraw money from contract balance to owner
108     function withdraw() onlyOwner returns (bool result) {
109         owner.send(this.balance);
110         return true;
111     }
112 
113     //get total titanium cards
114     function cards_titanium_total() constant returns (uint) { 
115       return cards_titanium.length;
116     }  
117     //get total black cards
118     function cards_black_total() constant returns (uint) { 
119       return cards_black.length;
120     }
121     //get total metal cards
122     function cards_metal_total() constant returns (uint) { 
123       return cards_metal.length;
124     }        
125     //get total gold cards
126     function cards_gold_total() constant returns (uint) { 
127       return cards_gold.length;
128     }        
129     //get total blue cards
130     function cards_blue_total() constant returns (uint) { 
131       return cards_blue.length;
132     }
133 
134     //get total start cards
135     function cards_start_total() constant returns (uint) { 
136       return cards_start.length;
137     }
138 
139     /*
140     * User get card(titanium, black, gold metal, gold and other), if amount eth sufficient for this.
141     */
142     function get_card() private returns (bool) {
143 
144       if((msg.value >= card_titanium_minamount)
145         &&(cards_titanium.length < card_titanium_first)
146         &&(cards_titanium_check[msg.sender] != 1)
147         ) {
148         cards_titanium.push(msg.sender);
149         cards_titanium_check[msg.sender] = 1;
150       }
151 
152       if((msg.value >= card_black_minamount)
153         &&(msg.value < card_titanium_minamount)
154         &&(cards_black.length < card_black_first)
155         &&(cards_black_check[msg.sender] != 1)
156         ) {
157         cards_black.push(msg.sender);
158         cards_black_check[msg.sender] = 1;
159       }                
160 
161       if((msg.value >= card_metal_minamount)
162         &&(msg.value < card_black_minamount)
163         &&(cards_metal.length < card_metal_first)
164         &&(cards_metal_check[msg.sender] != 1)
165         ) {
166         cards_metal.push(msg.sender);
167         cards_metal_check[msg.sender] = 1;
168       }               
169 
170       if((msg.value >= card_gold_minamount)
171         &&(msg.value < card_metal_minamount)
172         &&(cards_gold.length < card_gold_first)
173         &&(cards_gold_check[msg.sender] != 1)
174         ) {
175         cards_gold.push(msg.sender);
176         cards_gold_check[msg.sender] = 1;
177       }               
178 
179       if((msg.value >= card_blue_minamount)
180         &&(msg.value < card_gold_minamount)
181         &&(cards_blue.length < card_blue_first)
182         &&(cards_blue_check[msg.sender] != 1)
183         ) {
184         cards_blue.push(msg.sender);
185         cards_blue_check[msg.sender] = 1;
186       }
187 
188       if((msg.value >= card_start_minamount)
189         &&(msg.value < card_blue_minamount)
190         &&(cards_start.length < card_start_first)
191         &&(cards_start_check[msg.sender] != 1)
192         ) {
193         cards_start.push(msg.sender);
194         cards_start_check[msg.sender] = 1;
195       }
196 
197       return true;
198     }    
199       
200  }
201 
202  /**
203    * Math operations with safety checks
204    */
205   library SafeMath {
206     function mul(uint a, uint b) internal returns (uint) {
207       uint c = a * b;
208       assert(a == 0 || c / a == b);
209       return c;
210     }
211 
212     function div(uint a, uint b) internal returns (uint) {
213       // assert(b > 0); // Solidity automatically throws when dividing by 0
214       uint c = a / b;
215       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
216       return c;
217     }
218 
219     function sub(uint a, uint b) internal returns (uint) {
220       assert(b <= a);
221       return a - b;
222     }
223 
224     function add(uint a, uint b) internal returns (uint) {
225       uint c = a + b;
226       assert(c >= a);
227       return c;
228     }
229 
230     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
231       return a >= b ? a : b;
232     }
233 
234     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
235       return a < b ? a : b;
236     }
237 
238     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
239       return a >= b ? a : b;
240     }
241 
242     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
243       return a < b ? a : b;
244     }
245 
246     function assert(bool assertion) internal {
247       if (!assertion) {
248         throw;
249       }
250     }
251   }