1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5 
6 
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 contract RTCoin {
39     using SafeMath for uint256;
40     
41 	address public owner;
42     address public saleAgent;
43     uint256 public totalSupply;
44 	string public name;
45 	uint8 public decimals;
46 	string public symbol;
47 	bool private allowEmission = true;
48 	mapping (address => uint256) balances;
49     
50     
51     function RTCoin(string _name, string _symbol, uint8 _decimals) public {
52 		decimals = _decimals;
53 		name = _name;
54 		symbol = _symbol;
55 		owner = msg.sender;
56 	}
57 	
58 	
59     function changeSaleAgent(address newSaleAgent) public onlyOwner {
60         require (newSaleAgent!=address(0));
61         uint256 tokenAmount = balances[saleAgent];
62         if (tokenAmount>0) {
63             balances[newSaleAgent] = balances[newSaleAgent].add(tokenAmount);
64             balances[saleAgent] = balances[saleAgent].sub(tokenAmount);
65             Transfer(saleAgent, newSaleAgent, tokenAmount);
66         }
67         saleAgent = newSaleAgent;
68     }
69 	
70 	
71 	function emission(uint256 amount) public onlyOwner {
72 	    require(allowEmission);
73 	    require(saleAgent!=address(0));
74 	    totalSupply = amount * (uint256(10) ** decimals);
75 		balances[saleAgent] = totalSupply;
76 		Transfer(0x0, saleAgent, totalSupply);
77 		allowEmission = false;
78 	}
79     
80     
81     function burn(uint256 _value) public {
82         require(_value > 0);
83         address burner;
84         if (msg.sender==owner)
85             burner = saleAgent;
86         else
87             burner = msg.sender;
88         balances[burner] = balances[burner].sub(_value);
89         totalSupply = totalSupply.sub(_value);
90         Burn(burner, _value);
91     }
92      
93     event Burn(address indexed burner, uint indexed value);
94 	
95 	
96 	function transfer(address _to, uint256 _value) public returns (bool) {
97         balances[msg.sender] = balances[msg.sender].sub(_value);
98         balances[_to] = balances[_to].add(_value);
99         Transfer(msg.sender, _to, _value);
100         return true;
101     }
102     
103     
104     function balanceOf(address _owner) public constant returns (uint256 balance) {
105         return balances[_owner];
106     }
107 	
108 	
109 	function transferOwnership(address newOwner) onlyOwner public {
110         require(newOwner != address(0));
111         owner = newOwner; 
112     }
113     
114     modifier onlyOwner() {
115         require(msg.sender == owner);
116         _;
117     }
118 
119 
120 	
121 	event Transfer(
122 		address indexed _from,
123 		address indexed _to,
124 		uint _value
125 	);
126 }
127 
128 contract Crowdsale {
129     
130     using SafeMath for uint256;
131     address fundsWallet;
132     RTCoin public token;
133     address public owner;
134 	bool public open = false;
135     uint256 public tokenLimit;
136     
137     uint256 public rate = 20000; //значение для pre ICO, 0.00005 ETH = 1 RTC 
138     
139     
140     function Crowdsale(address _fundsWallet, address tokenAddress, 
141                        uint256 _rate, uint256 _tokenLimit) public {
142         fundsWallet = _fundsWallet;
143         token = RTCoin(tokenAddress);
144         rate = _rate;
145         owner = msg.sender;
146         tokenLimit = _tokenLimit * (uint256(10) ** token.decimals());
147     }
148     
149     
150     function() external isOpen payable {
151         require(tokenLimit>0);
152         fundsWallet.transfer(msg.value);
153         uint256 tokens = calculateTokenAmount(msg.value);
154         token.transfer(msg.sender, tokens);
155         tokenLimit = tokenLimit.sub(tokens);
156     }
157   
158     
159     function changeFundAddress(address newAddress) public onlyOwner {
160         require(newAddress != address(0));
161         fundsWallet = newAddress;
162 	}
163 	
164 	
165     function changeRate(uint256 newRate) public onlyOwner {
166         require(newRate>0);
167         rate = newRate;
168     }
169     
170     
171     function calculateTokenAmount(uint256 weiAmount) public constant returns(uint256) {
172         if (token.decimals()!=18){
173             uint256 tokenAmount = weiAmount.mul(rate).div(uint256(10) ** (18-token.decimals())); 
174             return tokenAmount;
175         }
176         else return weiAmount.mul(rate);
177     }
178     
179     function transferTo(address _to, uint256 _value) public onlyOwner returns (bool) {
180         require(tokenLimit>0);
181         token.transfer(_to, _value);
182         tokenLimit = tokenLimit.sub(_value);
183     }
184     
185     modifier onlyOwner() {
186         require(msg.sender == owner);
187         _;
188     }
189     
190     
191     function allowSale() public onlyOwner {
192         open = true;
193     }
194     
195     
196     function disallowSale() public onlyOwner {
197         open = false;
198     }
199     
200     modifier isOpen() {
201         require(open == true);
202         _;
203     }
204 }