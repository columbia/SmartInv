1 pragma solidity ^0.5.1;
2 
3 // This token latch uses buy and sell orders to operate
4 
5 // Follows the Tr100c protocol
6 
7 contract ERC20 {
8 	function totalSupply() public view returns (uint);
9 	function balanceOf(address tokenOwner) public view returns (uint balance);
10 	function allowance(address tokenOwner, address spender) public view returns (uint remaining);
11 	function transfer(address to, uint tokens) public returns (bool success);
12 	function approve(address spender, uint tokens) public returns (bool success);
13 	function transferFrom(address from, address to, uint tokens) public returns (bool success);
14 
15 	event Transfer(address indexed from, address indexed to, uint tokens);
16 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
17 }
18 
19 contract ERC20TokenLatch {
20     
21     uint64 trade_increment = 1;
22 	
23 	uint public fee;	    		// fee for trades
24 	
25 	address payable public owner;
26     
27     address payable public latched_contract;
28     
29     mapping(uint32 => address payable) public buy_order_owners;
30     mapping(uint32 => uint256)   public  buy_order_qty;
31     mapping(uint32 => uint64)   public  buy_order_price;
32     uint32 public num_buy_orders = 0;
33     uint32 public max_buy_price_idx;
34     
35     mapping(uint32 => address payable) public sell_order_owners;
36     mapping(uint32 => uint256)   public  sell_order_qty;
37     mapping(uint32 => uint64)   public  sell_order_price;
38     uint32 public num_sell_orders = 0;
39     uint32 public min_sell_price_idx;
40     
41     function rmBuyOrder(uint32 idx) private {
42         buy_order_owners[idx]=buy_order_owners[num_buy_orders];
43         buy_order_qty[idx]=buy_order_qty[num_buy_orders];
44         buy_order_price[idx]=buy_order_price[num_buy_orders];
45         num_buy_orders--;
46         if(max_buy_price_idx==idx){
47             max_buy_price_idx=0;
48             for(uint32 i=1;i<num_buy_orders;i++){
49                 if(buy_order_price[max_buy_price_idx]<buy_order_price[i])max_buy_price_idx=i;
50             }
51         }
52     }
53     
54     function rmSellOrder(uint32 idx) private {
55         sell_order_owners[idx]=sell_order_owners[num_sell_orders];
56         sell_order_qty[idx]=sell_order_qty[num_sell_orders];
57         sell_order_price[idx]=sell_order_price[num_sell_orders];
58         num_sell_orders--;
59         if(min_sell_price_idx==idx){
60             min_sell_price_idx=0;
61             for(uint32 i=1;i<num_sell_orders;i++){
62                 if(sell_order_price[min_sell_price_idx]>sell_order_price[i])min_sell_price_idx=i;
63             }
64         }
65     }
66     
67     function addBuyOrder(address payable adr, uint256 qty, uint64 price) private {
68         buy_order_owners[num_buy_orders] = adr;
69         buy_order_qty[num_buy_orders] = qty;
70         buy_order_price[num_buy_orders] = price;
71         if(price>buy_order_price[max_buy_price_idx])max_buy_price_idx = num_buy_orders;
72         if(num_buy_orders==0)max_buy_price_idx = 0;
73         num_buy_orders++;
74     }
75     
76     function addSellOrder(address payable adr, uint256 qty, uint64 price) private {
77         sell_order_owners[num_sell_orders] = adr;
78         sell_order_qty[num_sell_orders] = qty;
79         sell_order_price[num_sell_orders] = price;
80         if(price<sell_order_price[min_sell_price_idx])min_sell_price_idx = num_sell_orders;
81         if(num_sell_orders==0)min_sell_price_idx = 0;
82         num_sell_orders++;
83     }
84     
85     function maxBuyPrice() public view returns (uint64 price){
86         return buy_order_price[max_buy_price_idx];
87     }
88     
89     function minSellPrice() public view returns (uint64 price){
90         return sell_order_price[min_sell_price_idx];
91     }
92     
93     function getPrice() public view returns (uint64){
94         if(num_sell_orders==0){
95             if(num_buy_orders==0)return 1000;
96             else return maxBuyPrice();
97         }else if(num_buy_orders==0) return minSellPrice();
98         return (minSellPrice()+maxBuyPrice())/2;
99     }
100     
101     constructor(address payable latch) public {
102         latched_contract=latch;
103         owner = msg.sender;
104 		fee = .0001 ether;
105     }
106     
107     function balanceOf(address tokenOwner) public view returns (uint balance){
108         return ERC20(latched_contract).balanceOf(tokenOwner);
109     }
110     
111     function totalSupply() public view returns (uint){
112         return ERC20(latched_contract).totalSupply();
113     }
114     
115     function transfer(address target, uint qty) private{
116         ERC20(latched_contract).transfer(target, qty);
117     }
118     
119 	function getFee() public view returns (uint){
120 		return fee;
121 	}
122 	
123 	function getBuyPrice() public view returns (uint64){
124 	    if(num_buy_orders>0)return maxBuyPrice()+trade_increment;
125 	    else return getPrice();
126 	}
127 	
128 	function getSellPrice() public view returns (uint64){
129 	    if(num_sell_orders>0)return minSellPrice()-trade_increment;
130 	    else return getPrice();
131 	}
132 	
133 	function getSellReturn(uint amount) public view returns (uint){	// ether for selling amount tokens
134 	    // computing fees for selling is difficult and expensive, so I'm not doing it.  Not worth it.
135 		return (getSellPrice()*amount)/10000;
136 	}
137 	
138 	function getBuyCost(uint amount) public view returns (uint){		// ether cost for buying amount tokens
139 	    return ((amount*getBuyPrice())/10000) + fee;
140 	}
141 	
142 	function buy(uint tokens)public payable{
143 		placeBuyOrder(tokens, getBuyPrice());
144 	}
145 	
146 	function placeBuyOrder(uint tokens, uint64 price10000) public payable{
147 	    uint cost = fee + ((tokens*price10000)/10000);
148 	    require(msg.value>=cost);
149 		
150 		// handle fee and any extra funds
151 		msg.sender.transfer(msg.value-cost);
152 		owner.transfer(fee);
153 		
154 	    uint left = tokens;
155 	    
156 		// now try to fulfill the order
157 		for(uint32 i=0;i<num_sell_orders;i++){
158 		    if(price10000<minSellPrice())
159 		        break; // cannot fulfill order because there is not a sell order that would satisfy
160 		    
161 		    if(sell_order_price[i]<=price10000){
162 		        // we can trade some!
163 		        if(sell_order_qty[i]>left){
164 		            // we can trade all!
165 		            sell_order_qty[i]-=left;
166 		            sell_order_owners[i].transfer((sell_order_price[i]*left)/10000);
167 		            transfer(msg.sender, left);
168 		            
169 		            // send the owner any extra funds
170 		            owner.transfer(((price10000-sell_order_price[i])*left)/10000);
171 		            
172 		            // order fully fulfilled
173 		            return;
174 		        }else{
175     		        // will complete a single sell order, but buy order will have some left over
176     		        uint qty = sell_order_qty[i];
177     		        left-=qty;
178     	            sell_order_owners[i].transfer((sell_order_price[i]*qty)/10000);
179     	            transfer(msg.sender, qty);
180     	            
181     	            // send the owner any extra funds
182     	            owner.transfer(((price10000-sell_order_price[i])*qty)/10000);
183     	            
184     	            // delete the order that was completed
185     	            rmSellOrder(i);
186     		    }
187 		    }
188 		}
189 		
190 		// if we are here then some of the order is left.  Place the order in the queue.
191 		addBuyOrder(msg.sender, left, price10000);
192 		
193 	}
194 	
195 	function sell(uint tokens)public{
196 	    placeSellOrder(tokens, getSellPrice());
197 	}
198 	    
199 	function placeSellOrder(uint tokens, uint64 price10000) public payable{
200 	    require(ERC20(latched_contract).allowance(msg.sender, address(this))>=tokens);
201 		
202 		// handle fee and any extra funds
203 		ERC20(latched_contract).transferFrom(msg.sender,address(this),tokens);
204 		
205 		// get info needed for trading
206 	    uint64 sell_price = price10000;
207 	    uint left = tokens;
208 	    
209 		// now try to fulfill the order
210 		for(uint32 i=0;i<num_buy_orders;i++){
211 		    if(sell_price>maxBuyPrice())
212 		        break; // cannot fulfill order because there is not a buy order that would satisfy
213 		    
214 		    if(buy_order_price[i]>=sell_price){
215 		        // we can trade some!
216 		        if(buy_order_qty[i]>left){
217 		            // we can trade all!
218 		            buy_order_qty[i]-=left;
219 		            transfer(buy_order_owners[i],left);
220 		            msg.sender.transfer((sell_price*left)/10000);
221 		            
222 		            // send the owner any extra funds
223 		            owner.transfer(((buy_order_price[i]-sell_price)*left)/10000);
224 		            
225 		            // order fully fulfilled
226 		            return;
227 		        }else{
228     		        // will complete a single sell order, but buy order will have some left over
229     		        uint qty = buy_order_qty[i];
230     		        left-=qty;
231     	            
232 		            transfer(buy_order_owners[i],qty);
233     	            msg.sender.transfer((sell_price*qty)/10000);
234     	            
235     	            // send the owner any extra funds
236     	            owner.transfer(((buy_order_price[i]-sell_price)*qty)/10000);
237     	            
238     	            // delete the order that was completed
239     	            rmBuyOrder(i);
240     		    }
241 		    }
242 		}
243 		
244 		// if we are here then some of the order is left.  Place the order in the queue.
245 		addSellOrder(msg.sender, left, sell_price);
246 	}
247     
248     function canBuy(uint amount) public pure returns (bool possible){			// returns true if this amount of token can be bought - does not account for Ethereum account balance
249         return true;
250     }
251     
252     function canSell(uint amount) public pure returns (bool possible){			// returns true if this amount of token can be sold - does not account for token account balance
253 	    return true;
254     }
255 	
256 	function get_tradable() public view returns (uint){
257         return ERC20(latched_contract).totalSupply();
258     }
259 	
260 	function setFee(uint new_fee) public{
261 	    require(msg.sender==owner);
262 	    fee=new_fee;
263 	}
264 	
265 	function destroy() public {
266 	    require(msg.sender==owner);
267 	    require(address(this).balance<0.1 ether);
268 	    require(ERC20(latched_contract).balanceOf(address(this))==0);
269 	    selfdestruct(msg.sender);
270 	}
271 }