1 pragma solidity ^0.4.10;
2 
3 
4 contract WorthlessPieceOfShitBadge
5 {
6 
7 
8 	address 	public owner;
9 	address     public app;
10 
11 
12     string 		public standard = 'Token 0.1';
13 	string 		public name = "Worthless Piece of Shit Badge"; 
14 	string 		public symbol = "Worthless Piece of Shit Badge";
15 	uint8 		public decimals = 0; 
16 	uint256 	public totalSupply = 0;
17 	uint256     public price = 1 ether / 10; 
18 	uint256     public removalPrice = 1 ether;
19 	
20 
21 	mapping (address => uint256) balances;	
22 	mapping (address => mapping (address => uint256)) allowed;
23 
24 
25 	modifier ownerOnly() 
26 	{
27 		require(msg.sender == owner);
28 		_;
29 	}
30 	
31 	
32 	modifier appOrOwner() 
33 	{
34 		require(msg.sender == app || msg.sender == owner);
35 		_;
36 	}		
37 	
38 	
39 	function _setRemovalPrice(uint256 _price) public appOrOwner returns(bool success) 
40 	{
41 	    
42 	    removalPrice = _price;
43 	    RemovalPriceSet(_price);
44 	    
45 	    return true;
46 	}
47 	
48 	
49 	function _setBuyPrice(uint256 _price) public appOrOwner returns(bool success) 
50 	{
51 	    
52 	    price = _price;
53 	    BuyPriceSet(_price);
54 	    
55 	    return true;
56 	}
57 
58 
59 	function _changeName(string _name) public ownerOnly returns(bool success) 
60 	{
61 
62 		name = _name;
63 		NameChange(name);
64 
65 		return true;
66 	}
67 
68 
69 	function _changeSymbol(string _symbol) public ownerOnly returns(bool success) 
70 	{
71 
72 		symbol = _symbol;
73 		SymbolChange(symbol);
74 
75 		return true;
76 	}
77 	
78 	
79 	function _mint(address _sendTo, uint256 _amount) public appOrOwner returns(bool success) 
80 	{
81 	    
82 	    balances[_sendTo] += _amount;
83 	    totalSupply += _amount;
84 	    Transfer(address(this), _sendTo, _amount);
85 	    
86 	    return true;
87 	}
88 	
89 	
90 	function _clear(address _address) public appOrOwner returns(bool success) 
91 	{
92 	    
93 	    uint256 amount = balances[_address];
94 	    totalSupply -= amount;
95 	    Transfer(_address, 0x0, amount);
96 	    balances[_address] = 0;
97 	    
98 	    return true;
99 	}
100 
101 
102     function balanceOf(address _owner) public constant returns(uint256 tokens) 
103 	{
104 
105 		require(_owner != 0x0);
106 		return balances[_owner];
107 	}
108 	
109 	
110 	function _transferOwnership(address _to) ownerOnly public returns(bool success) 
111 	{
112 	    
113 	    require(_to != 0x0);
114 	    owner = _to;
115 	    
116 	    return true;
117 	}
118 	
119 	
120 	function _setApp(address _to) ownerOnly public returns(bool success) 
121 	{
122 	    
123 	    app = _to;
124 	    AppSet(_to);
125 	    
126 	    return true;
127 	}
128 	
129 	
130 	function _withdraw() ownerOnly public returns(bool success) 
131 	{
132 	    
133 	    address token = address(this);
134 	    msg.sender.transfer(token.balance);
135 	    
136 	    Withdrawal(token.balance);
137 	    
138 	    return true;
139 	}
140 	
141 	
142 	function buy(address _sendTo, uint256 _amount) public payable returns(bool success) 
143 	{
144 	    
145 	    uint256 ethRequired = _amount * price;
146 	    
147 	    if (msg.value < ethRequired) {
148 	        require(false);
149 	    }
150 	    
151 	    uint256 refund = msg.value - ethRequired;
152 	    msg.sender.transfer(refund);
153 	    balances[_sendTo] += _amount;
154 	    totalSupply += _amount;
155 	    
156 	    Buy(_sendTo, _amount);
157 	    Transfer(address(this), _sendTo, _amount);
158 	    
159 	    return true;
160 	}
161 	
162 	
163 	function remove(address _address, uint256 _amount) public payable returns(bool success) 
164 	{
165 	    
166 	    require(balances[_address] >= _amount);
167 	    uint256 ethRequired = _amount * removalPrice;
168 	    
169 	    if (msg.value < ethRequired) {
170 	        require(false);
171 	    }
172 	    
173 	    uint256 refund = msg.value - ethRequired;
174 	    msg.sender.transfer(refund);
175 	    balances[_address] -= _amount;
176 	    totalSupply -= _amount;
177 	    
178 	    Removal(_address, _amount);
179 	    Transfer(_address, address(this), _amount);
180 	    
181 	    return true;
182 	}
183 	
184 
185     function transfer(address _to, uint256 _value) appOrOwner public returns(bool success)
186 	{ 
187 
188         require(false);
189         return false;
190 	}
191 
192 	
193 	function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) 
194 	{
195 	    
196 	    require(false);
197     	return false;
198     }
199 
200     
201     function approve(address _spender, uint256 _value) appOrOwner public returns(bool success)  
202     {
203 
204         require(false);
205         return false;
206     }
207 
208 
209     function WorthlessPieceOfShitBadge() public
210 	{
211 		owner = msg.sender;
212 		TokenDeployed();
213 	}
214 
215 
216 	// ====================================================================================
217 	//
218     // List of all events
219 
220     event NameChange(string _name);
221     event SymbolChange(string _symbol);
222     event AppSet(address indexed _to);
223 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
224 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
225 	event TokenDeployed();
226 	event Buy(address indexed _to, uint256 _amount);
227 	event Removal(address indexed _address, uint256 _amount);
228 	event RemovalPriceSet(uint256 price);
229 	event BuyPriceSet(uint256 price);
230 	event Withdrawal(uint256 _value);
231 
232 }