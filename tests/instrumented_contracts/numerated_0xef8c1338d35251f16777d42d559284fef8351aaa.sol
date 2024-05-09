1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9 
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27 
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33 
34   function add(uint256 a, uint256 b) internal pure returns (uint256) {
35     uint256 c = a + b;
36     assert(c >= a);
37     return c;
38   }
39 }
40 
41 contract RTCoin {
42     using SafeMath for uint256;
43     
44 	address public owner;
45     address public saleAgent;
46     uint256 public totalSupply;
47 	string public name;
48 	uint8 public decimals;
49 	string public symbol;
50 	bool private allowEmission = true;
51 	mapping (address => uint256) balances;
52     
53     
54     function RTCoin(string _name, string _symbol, uint8 _decimals) public {
55 		decimals = _decimals;
56 		name = _name;
57 		symbol = _symbol;
58 		owner = msg.sender;
59 	}
60 	
61 
62     function changeSaleAgent(address newSaleAgent) public onlyOwner {
63         require (newSaleAgent!=address(0));
64         uint256 tokenAmount = balances[saleAgent];
65         if (tokenAmount>0) {
66             balances[newSaleAgent] = balances[newSaleAgent].add(tokenAmount);
67             balances[saleAgent] = balances[saleAgent].sub(tokenAmount);
68             Transfer(saleAgent, newSaleAgent, tokenAmount);
69         }
70         saleAgent = newSaleAgent;
71     }
72 	
73 	
74 	function emission(uint256 amount) public onlyOwner {
75 	    require(allowEmission);
76 	    require(saleAgent!=address(0));
77 	    totalSupply = amount * (uint256(10) ** decimals);
78 		balances[saleAgent] = totalSupply;
79 		Transfer(0x0, saleAgent, totalSupply);
80 		allowEmission = false;
81 	}
82     
83    
84     function burn(uint256 _value) public {
85         require(_value > 0);
86         address burner;
87         if (msg.sender==owner)
88             burner = saleAgent;
89         else
90             burner = msg.sender;
91         balances[burner] = balances[burner].sub(_value);
92         totalSupply = totalSupply.sub(_value);
93         Burn(burner, _value);
94     }
95     
96     event Burn(address indexed burner, uint indexed value);
97 	
98 	
99 	function transfer(address _to, uint256 _value) public returns (bool) {
100         balances[msg.sender] = balances[msg.sender].sub(_value);
101         balances[_to] = balances[_to].add(_value);
102         Transfer(msg.sender, _to, _value);
103         return true;
104     }
105     
106     
107     function balanceOf(address _owner) public constant returns (uint256 balance) {
108         return balances[_owner];
109     }
110 	
111 	
112 	function transferOwnership(address newOwner) onlyOwner public {
113         require(newOwner != address(0));
114         owner = newOwner; 
115     }
116 	
117 	
118 	function close() public onlyOwner {
119         selfdestruct(owner);
120     }
121     
122     modifier onlyOwner() {
123         require(msg.sender == owner);
124         _;
125     }
126 
127 
128 	
129 	event Transfer(
130 		address indexed _from,
131 		address indexed _to,
132 		uint _value
133 	);
134 }
135 
136 contract Crowdsale {
137     
138     using SafeMath for uint256;
139     address fundsWallet;
140     RTCoin public token;
141     address public owner;
142 	bool public open = false;
143     uint256 public tokenLimit;
144     
145     uint256 public rate = 20000; //
146     
147    
148     function Crowdsale(address _fundsWallet, address tokenAddress, 
149                        uint256 _rate, uint256 _tokenLimit) public {
150         fundsWallet = _fundsWallet;
151         token = RTCoin(tokenAddress);
152         rate = _rate;
153         owner = msg.sender;
154         tokenLimit = _tokenLimit * (uint256(10) ** token.decimals());
155     }
156     
157     
158     function() external isOpen payable {
159         require(tokenLimit>0);
160         fundsWallet.transfer(msg.value);
161         uint256 tokens = calculateTokenAmount(msg.value);
162         token.transfer(msg.sender, tokens);
163         tokenLimit = tokenLimit.sub(tokens);
164     }
165   
166     
167     function changeFundAddress(address newAddress) public onlyOwner {
168         require(newAddress != address(0));
169         fundsWallet = newAddress;
170 	}
171 	
172 	
173     function changeRate(uint256 newRate) public onlyOwner {
174         require(newRate>0);
175         rate = newRate;
176     }
177     
178    
179     function calculateTokenAmount(uint256 weiAmount) public constant returns(uint256) {
180         if (token.decimals()!=18){
181             uint256 tokenAmount = weiAmount.mul(rate).div(uint256(10) ** (18-token.decimals())); 
182             return tokenAmount;
183         }
184         else return weiAmount.mul(rate);
185     }
186     
187     modifier onlyOwner() {
188         require(msg.sender == owner);
189         _;
190     }
191     
192     
193     function allowSale() public onlyOwner {
194         open = true;
195     }
196     
197     
198     function disallowSale() public onlyOwner {
199         open = false;
200     }
201     
202     modifier isOpen() {
203         require(open == true);
204         _;
205     }
206 }