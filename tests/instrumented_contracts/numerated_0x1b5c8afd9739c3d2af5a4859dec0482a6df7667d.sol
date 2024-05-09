1 pragma solidity ^0.4.24;
2 
3 contract ERC20Interface {
4     function totalSupply() public view returns (uint);
5     function balanceOf(address tokenOwner) public view returns (uint balance);
6     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
7     function transfer(address to, uint tokens) public returns (bool success);
8     function approve(address spender, uint tokens) public returns (bool success);
9     function transferFrom(address from, address to, uint tokens) public returns (bool success);
10 
11     event Transfer(address indexed from, address indexed to, uint tokens);
12     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
13 }
14 
15 contract HomesCoin is ERC20Interface {
16 
17     string public symbol;
18     string public  name;
19     uint8 public decimals;
20     uint _totalSupply;
21     uint price;
22     
23     address owner;
24 
25     mapping(address => uint) public balances;
26     mapping(address => mapping(address => uint)) allowed;
27 
28     // ------------------------------------------------------------------------
29     // Constructor
30     // ------------------------------------------------------------------------
31     constructor() public {
32         symbol = "HOMt0";
33         name = "HomesCoin_test0";
34         decimals = 18;
35         _totalSupply = 1000000 * 10**uint(decimals);
36         owner = msg.sender;
37         balances[owner] = _totalSupply;
38         price=100;
39         emit Transfer(owner, address(0), _totalSupply);
40     }
41 
42     function totalSupply() public view returns (uint) {
43         return _totalSupply;
44     }
45 
46     function balanceOf(address tokenOwner) public view returns (uint balance) {
47         return balances[tokenOwner];
48     }
49 
50     function transfer(address to, uint tokens) public returns (bool success) {
51         require(to!=address(0));
52         require(tokens<=balances[msg.sender]);
53         balances[msg.sender] = balances[msg.sender] - tokens;
54         balances[to] = balances[to] + tokens;
55         emit Transfer(msg.sender, to, tokens);
56         return true;
57     }
58 
59     function approve(address spender, uint tokens) public returns (bool success) {
60         allowed[msg.sender][spender] = tokens;
61         emit Approval(msg.sender, spender, tokens);
62         return true;
63     }
64 
65     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
66         require(to!=address(0));
67         require(balances[from]>=tokens);
68         require(allowed[from][msg.sender]>=tokens);
69         balances[from] = balances[from] - tokens;
70         allowed[from][msg.sender] = allowed[from][msg.sender] - tokens;
71         balances[to] = balances[to] + tokens;
72         emit Transfer(from, to, tokens);
73         return true;
74     }
75 
76     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
77         return allowed[tokenOwner][spender];
78     }
79     
80     function mint(address target, uint amt) public{
81         require(msg.sender==owner);
82         balances[target] += amt;
83         emit Transfer(target, address(0), amt);
84     }
85     function burn(uint amt) public{
86         require(msg.sender==owner);
87         require(balances[owner]>=amt);
88         balances[owner]-=amt;
89     }
90     
91     function destroy() public {
92         require(msg.sender==owner);
93         selfdestruct(msg.sender);
94     }
95     
96     event HomeSaleEvent(uint64 houseid, uint8 day, uint8 month, uint16 year, uint64 price100, string source);
97     
98     mapping(uint64=>string) public addresses;
99     mapping(uint64=>uint32) public sqfts;
100     mapping(uint64=>uint8) public bedrooms;
101     mapping(uint64=>uint8) public bathrooms;
102     mapping(uint64=>uint8) public house_type;
103     mapping(uint64=>uint16) public year_built;
104     mapping(uint64=>uint32) public lot_size;
105     mapping(uint64=>uint64) public parcel_num;
106     mapping(uint64=>uint32) public zipcode;
107     
108     uint64 public num_houses = 0;
109     
110     function makeEvent(uint64 houseid, uint8 day, uint8 month, uint16 year, uint64 price100, string memory source) public{
111         require(msg.sender==owner);
112         emit HomeSaleEvent(houseid,day,month,year, price100, source);
113     }
114     function addHouse(string memory adr, uint32 sqft, uint8 bedroom,uint8 bathroom,uint8 h_type, uint16 yr_built, uint32 lotsize, uint64 parcel, uint32 zip) public{
115         require(msg.sender==owner);
116         require(bytes(adr).length<128);
117         addresses[num_houses] = adr;
118         sqfts[num_houses]=sqft;
119         bedrooms[num_houses]=bedroom;
120         bathrooms[num_houses]=bathroom;
121         house_type[num_houses]=h_type;
122         year_built[num_houses]=yr_built;
123         lot_size[num_houses] = lotsize;
124         parcel_num[num_houses] = parcel;
125         zipcode[num_houses] = zip;
126         num_houses++;
127     }
128     function resetHouseParams(uint64 num_house, uint32 sqft, uint8 bedroom,uint8 bathroom,uint8 h_type, uint16 yr_built, uint32 lotsize, uint64 parcel, uint32 zip) public{
129         require(msg.sender==owner);
130         sqfts[num_house]=sqft;
131         bedrooms[num_house]=bedroom;
132         bathrooms[num_house]=bathroom;
133         house_type[num_house]=h_type;
134         year_built[num_house]=yr_built;
135         lot_size[num_house] = lotsize;
136         parcel_num[num_house] = parcel;
137         zipcode[num_house] = zip;
138     }
139     
140     event DonationEvent(address sender, uint value);
141     
142     function ()external payable{
143         emit DonationEvent(msg.sender,msg.value);
144     }
145     
146     function buy(uint tokens)public payable{
147         require(tokens>=100000); // prevents buying and selling absurdly small amounts to cheat the contract arithmetic
148         require(msg.value>=price*tokens/100);
149         require(allowed[owner][address(0)]>=tokens);
150         require(balances[owner]>=tokens);
151         require(msg.sender!=owner);
152         allowed[owner][address(0)]-=tokens;
153         balances[owner]-=tokens;
154         balances[msg.sender]+=tokens;
155         msg.sender.transfer(msg.value-price*tokens);
156     }
157     
158     function sell(uint tokens)public{
159         require(tokens>100000); // prevents buying and selling absurdly small amounts to cheat the contract arithmetic
160         require(balances[msg.sender]>=tokens);
161         require(address(this).balance>price*tokens/100);
162         require(msg.sender!=owner);
163         allowed[owner][address(0)]+=tokens;
164         balances[owner]+=tokens;
165         balances[msg.sender]-=tokens;
166         msg.sender.transfer(price*tokens);
167     }
168     
169     function setPrice(uint newPrice) public{
170         require(msg.sender==owner);
171         price = newPrice;
172     }
173     
174     function collect(uint amount) public{
175         require(msg.sender==owner);
176         require(address(this).balance>=amount+1 ether);
177         msg.sender.transfer(amount);
178     }
179 }