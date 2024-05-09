1 pragma solidity ^0.5.1;
2 
3 contract ERC20Interface {
4 	function totalSupply() public view returns (uint);
5 	function balanceOf(address tokenOwner) public view returns (uint balance);
6 	function allowance(address tokenOwner, address spender) public view returns (uint remaining);
7 	function transfer(address to, uint tokens) public returns (bool success);
8 	function approve(address spender, uint tokens) public returns (bool success);
9 	function transferFrom(address from, address to, uint tokens) public returns (bool success);
10 
11 	event Transfer(address indexed from, address indexed to, uint tokens);
12 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
13 }
14 
15 contract HomesCoin is ERC20Interface {
16 
17 	string public symbol;
18 	string public  name;
19 	uint8 public decimals;
20 	uint _totalSupply;
21 	
22 	uint public base_price;			// base price in 1/10000 ether
23 	uint public min_fee;			// min fee for trades
24 	uint public fee_div;			// divisor for the fee
25 	uint public min_balance;		// minimum balance for the fee acceptor account
26 	
27 	address payable public oracle_adr;	// address to send fees to
28 	
29 	address payable public owner;
30 
31 	mapping(address => uint) public balances;
32 	mapping(address => mapping(address => uint)) allowed;
33 
34 	// ------------------------------------------------------------------------
35 	// Constructor
36 	// ------------------------------------------------------------------------
37 	constructor() public {
38 		symbol = "HOM";
39 		name = "HOM Coin";
40 		decimals = 18;
41 		_totalSupply = 10000000 * 10**uint(decimals);
42 		owner = msg.sender;
43 		balances[address(this)] = _totalSupply;
44 		emit Transfer(address(0), address(this), _totalSupply);
45 		base_price=100000;
46 		oracle_adr = address(uint160(owner));
47 		min_balance = .02 ether;
48 		fee_div = 100;
49 		min_fee = .000001 ether;
50 	}
51 
52 	function totalSupply() public view returns (uint) {
53 		return _totalSupply;
54 	}
55 	
56 	function getCirculatingSupply() public view returns (uint) {
57 	    return _totalSupply - balances[address(this)];
58 	}
59 	
60 	uint public lastTradedPrice = 0;
61 
62 	function balanceOf(address tokenOwner) public view returns (uint balance) {
63 		return balances[tokenOwner];
64 	}
65 
66 	function transfer(address to, uint tokens) public returns (bool success) {
67 		require(to!=address(0));
68 		require(tokens<=balances[msg.sender]);
69 		balances[msg.sender] = balances[msg.sender] - tokens;
70 		balances[to] = balances[to] + tokens;
71 		emit Transfer(msg.sender, to, tokens);
72 		return true;
73 	}
74 
75 	function approve(address spender, uint tokens) public returns (bool success) {
76 		allowed[msg.sender][spender] = tokens;
77 		emit Approval(msg.sender, spender, tokens);
78 		return true;
79 	}
80 
81 	function transferFrom(address from, address to, uint tokens) public returns (bool success) {
82 		require(to!=address(0));
83 		require(balances[from]>=tokens);
84 		require(allowed[from][msg.sender]>=tokens);
85 		balances[from] = balances[from] - tokens;
86 		allowed[from][msg.sender] = allowed[from][msg.sender] - tokens;
87 		balances[to] = balances[to] + tokens;
88 		emit Transfer(from, to, tokens);
89 		return true;
90 	}
91 
92 	function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
93 		return allowed[tokenOwner][spender];
94 	}
95 	
96 	function mint(uint amt) public{
97 		require(msg.sender==owner);
98 		balances[address(this)] += amt;
99 		emit Transfer(address(0), address(this), amt);
100 	}
101 	function burn(uint amt) public{
102 		require(msg.sender==owner);
103 		require(balances[owner]>=amt);
104 		balances[owner]-=amt;
105 		emit Transfer(owner, address(0), amt);
106 	}
107 	
108 	function destroy(address payable receiver) public {
109 		require(msg.sender==owner);
110 		selfdestruct(receiver);
111 	}
112 	
113 	event HomeSaleEvent(uint64 houseid, uint8 day, uint8 month, uint16 year, uint64 price100, string source);
114 	
115 	mapping(uint64=>string) public addresses;
116 	mapping(uint64=>uint32) public sqfts;
117 	mapping(uint64=>uint8) public bedrooms;
118 	mapping(uint64=>uint8) public bathrooms;
119 	mapping(uint64=>uint8) public house_type;
120 	mapping(uint64=>uint16) public year_built;
121 	mapping(uint64=>uint32) public lot_size;
122 	mapping(uint64=>uint64) public parcel_num;
123 	mapping(uint64=>uint32) public zipcode;
124 	
125 	uint64 public num_houses = 0;
126 	
127 	function makeEvent(uint64 houseid, uint8 day, uint8 month, uint16 year, uint64 price100, string memory source) public{
128 		require(msg.sender==owner);
129 		emit HomeSaleEvent(houseid,day,month,year, price100, source);
130 	}
131 	
132 	function addHouse(string memory adr, uint32 sqft, uint8 bedroom,uint8 bathroom,uint8 h_type, uint16 yr_built, uint32 lotsize, uint64 parcel, uint32 zip) public{
133 		require(msg.sender==owner);
134 		require(bytes(adr).length<128);
135 		addresses[num_houses] = adr;
136 		sqfts[num_houses]=sqft;
137 		bedrooms[num_houses]=bedroom;
138 		bathrooms[num_houses]=bathroom;
139 		house_type[num_houses]=h_type;
140 		year_built[num_houses]=yr_built;
141 		lot_size[num_houses] = lotsize;
142 		parcel_num[num_houses] = parcel;
143 		zipcode[num_houses] = zip;
144 		num_houses++;
145 	}
146 	function resetHouseParams(uint64 num_house, uint32 sqft, uint8 bedroom,uint8 bathroom,uint8 h_type, uint16 yr_built, uint32 lotsize, uint64 parcel, uint32 zip) public{
147 		require(msg.sender==owner);
148 		sqfts[num_house]=sqft;
149 		bedrooms[num_house]=bedroom;
150 		bathrooms[num_house]=bathroom;
151 		house_type[num_house]=h_type;
152 		year_built[num_house]=yr_built;
153 		lot_size[num_house] = lotsize;
154 		parcel_num[num_house] = parcel;
155 		zipcode[num_house] = zip;
156 	}
157 	
158 	event DonationEvent(address sender, uint value);
159 	
160 	function ()external payable{
161 		emit DonationEvent(msg.sender,msg.value);
162 	}
163 	
164 	function getFee() public view returns (uint fee){
165 		uint a = oracle_adr.balance;
166 		if(a>min_balance)return min_fee;
167 		return (min_balance-a)/fee_div;
168 	}
169 	
170 	function getSellReturn(uint amount) public view returns (uint value){	// ether for selling amount tokens
171 		uint a = getFee();
172 		if(a>(amount*base_price/10000))return 0; // if the fee outweighs the return
173 		return (amount*base_price/10000) - a;
174 	}
175 	function getBuyCost(uint amount) public view returns (uint cost){		// ether cost for buying amount tokens
176 	    return (amount*base_price/10000) + getFee();
177 	}
178 	
179 	event SellEvent(uint tokens);
180 	event BuyEvent(uint tokens);
181 	
182 	function buy(uint tokens)public payable{
183 	    uint cost = getBuyCost(tokens);
184 	    require(tokens>0);
185 		require(msg.value>=cost);
186 		require(balances[address(this)]>=tokens);
187 		
188 		balances[address(this)]-=tokens;
189 		balances[msg.sender]+=tokens;
190 		msg.sender.transfer(msg.value-cost);
191 		
192 		if(oracle_adr.balance<min_balance)
193 		    oracle_adr.transfer(getFee());
194 		else
195 		    owner.transfer(getFee()/2);
196 		    
197 		lastTradedPrice = base_price;
198 		    
199 		emit Transfer(address(this), msg.sender, tokens);
200 		emit BuyEvent(tokens);
201 	}
202 	
203 	function sell(uint tokens)public{
204 	    uint result = getSellReturn(tokens);
205 	    require(balances[msg.sender]>=tokens);
206 	    require(tokens>0);
207 		require(address(this).balance>result);
208 		
209 		balances[address(this)]+=tokens;
210 		balances[msg.sender]-=tokens;
211 		msg.sender.transfer(result);
212 		if(oracle_adr.balance<min_balance)
213 		    oracle_adr.transfer(getFee());
214 		else
215 		    owner.transfer(getFee()/2);
216 		    
217 		lastTradedPrice = base_price;
218 		    
219 		emit Transfer(msg.sender, address(this), tokens);
220 		emit SellEvent(tokens);
221 	}
222 	
223 	function forsale(uint tokens)public{
224 		require(msg.sender==owner);
225 		allowed[owner][address(0)] = tokens;
226 		emit Approval(owner, address(0), tokens);
227 	}
228 	
229 	function get_tradable() public view returns (uint tradable){
230 		return balances[address(this)];
231 	}
232 	
233 	function setPrice(uint newPrice) public{
234 		require(msg.sender==oracle_adr);
235 		base_price = newPrice;
236 	}
237 	
238 	function setFeeParams(uint new_min_fee, uint new_fee_div, uint new_min_bal) public{
239 	    require(msg.sender==owner);
240 	    min_fee = new_min_fee;
241 	    min_balance = new_min_bal;
242 	    fee_div = new_fee_div;
243 	}
244 	
245 	function setOracleAddress(address payable adr) public {
246 	    oracle_adr = adr;
247 	}
248 }