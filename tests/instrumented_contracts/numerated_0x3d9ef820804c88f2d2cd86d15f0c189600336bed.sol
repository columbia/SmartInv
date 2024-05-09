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
41 
42 contract RTcoin {
43     using SafeMath for uint256;
44     
45 	address public owner;
46     address public saleAgent;
47     uint256 public totalSupply;
48 	string public name;
49 	uint8 public decimals;
50 	string public symbol;
51 	bool private allowEmission = true;
52 	mapping (address => uint256) balances;
53     
54     
55     function RTcoin(string _name, string _symbol, uint8 _decimals) public {
56 		decimals = _decimals;
57 		name = _name;
58 		symbol = _symbol;
59 		owner = msg.sender;
60 	}
61 	
62 	
63     function changeSaleAgent(address newSaleAgent) public onlyOwner {
64         require (newSaleAgent!=address(0));
65         uint256 tokenAmount = balances[saleAgent];
66         if (tokenAmount>0) {
67             balances[newSaleAgent] = balances[newSaleAgent].add(tokenAmount);
68             balances[saleAgent] = balances[saleAgent].sub(tokenAmount);
69             Transfer(saleAgent, newSaleAgent, tokenAmount);
70         }
71         saleAgent = newSaleAgent;
72     }
73 	
74 	
75 	function emission(uint256 amount) public onlyOwner {
76 	    require(allowEmission);
77 	    require(saleAgent!=address(0));
78 	    totalSupply = amount * (uint256(10) ** decimals);
79 		balances[saleAgent] = totalSupply;
80 		Transfer(0x0, saleAgent, totalSupply);
81 		allowEmission = false;
82 	}
83     
84     
85     function burn(uint256 _value) public {
86         require(_value > 0);
87         address burner;
88         if (msg.sender==owner)
89             burner = saleAgent;
90         else
91             burner = msg.sender;
92         balances[burner] = balances[burner].sub(_value);
93         totalSupply = totalSupply.sub(_value);
94         Burn(burner, _value);
95     }
96      
97     event Burn(address indexed burner, uint indexed value);
98 	
99 	
100 	function transfer(address _to, uint256 _value) public returns (bool) {
101         balances[msg.sender] = balances[msg.sender].sub(_value);
102         balances[_to] = balances[_to].add(_value);
103         Transfer(msg.sender, _to, _value);
104         return true;
105     }
106     
107     
108     function balanceOf(address _owner) public constant returns (uint256 balance) {
109         return balances[_owner];
110     }
111 	
112 	
113 	function transferOwnership(address newOwner) onlyOwner public {
114         require(newOwner != address(0));
115         owner = newOwner; 
116     }
117     
118     modifier onlyOwner() {
119         require(msg.sender == owner);
120         _;
121     }
122 
123 
124 	
125 	event Transfer(
126 		address indexed _from,
127 		address indexed _to,
128 		uint _value
129 	);
130 }
131 
132 contract Crowdsale {
133     
134     using SafeMath for uint256;
135     address fundsWallet;
136     RTcoin public token;
137     address public owner;
138 	bool public open = false;
139     uint256 public tokenLimit;
140     
141     uint256 public rate = 20000;  
142     
143     
144     function Crowdsale(address _fundsWallet, address tokenAddress, 
145                        uint256 _rate, uint256 _tokenLimit) public {
146         fundsWallet = _fundsWallet;
147         token = RTcoin(tokenAddress);
148         rate = _rate;
149         owner = msg.sender;
150         tokenLimit = _tokenLimit * (uint256(10) ** token.decimals());
151     }
152     
153     
154     function() external isOpen payable {
155         require(tokenLimit>0);
156         fundsWallet.transfer(msg.value);
157         uint256 tokens = calculateTokenAmount(msg.value);
158         token.transfer(msg.sender, tokens);
159         tokenLimit = tokenLimit.sub(tokens);
160     }
161   
162     
163     function changeFundAddress(address newAddress) public onlyOwner {
164         require(newAddress != address(0));
165         fundsWallet = newAddress;
166 	}
167 	
168 	
169     function changeRate(uint256 newRate) public onlyOwner {
170         require(newRate>0);
171         rate = newRate;
172     }
173     
174     
175     function calculateTokenAmount(uint256 weiAmount) public constant returns(uint256) {
176         if (token.decimals()!=18){
177             uint256 tokenAmount = weiAmount.mul(rate).div(uint256(10) ** (18-token.decimals())); 
178             return tokenAmount;
179         }
180         else return weiAmount.mul(rate);
181     }
182     
183     modifier onlyOwner() {
184         require(msg.sender == owner);
185         _;
186     }
187     
188     
189     function allowSale() public onlyOwner {
190         open = true;
191     }
192     
193    
194     function disallowSale() public onlyOwner {
195         open = false;
196     }
197     
198     modifier isOpen() {
199         require(open == true);
200         _;
201     }
202 }