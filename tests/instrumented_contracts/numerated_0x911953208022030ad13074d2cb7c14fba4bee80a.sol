1 contract WeeMath {
2 
3     function subtractWee(uint256 x, uint256 y) internal returns(uint256) {
4       assert(x >= y);
5       uint256 z = x - y;
6       return z;
7     }
8 
9     function multWee(uint256 x, uint256 y) internal returns(uint256) {
10       uint256 z = x * y;
11       assert((x == 0)||(z/x == y));
12       return z;
13     }
14 
15 }
16 
17 contract ERC20Token {
18     function totalSupply() constant returns (uint256 supply) {}
19     function balanceOf(address _owner) constant returns (uint256 balance) {}
20     function transfer(address _to, uint256 _value) returns (bool success) {}
21     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
22     function approve(address _spender, uint256 _value) returns (bool success) {}
23     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
24     event Transfer(address indexed _from, address indexed _to, uint256 _value);
25     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
26 }
27 
28 contract StandardToken is ERC20Token {
29 
30     function transfer(address _to, uint256 _value) returns (bool success) {
31       if (balances[msg.sender] >= _value && _value > 0) {
32         balances[msg.sender] -= _value;
33         balances[_to] += _value;
34         Transfer(msg.sender, _to, _value);
35         return true;
36       } else {
37         return false;
38       }
39     }
40 
41     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
42       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
43         balances[_to] += _value;
44         balances[_from] -= _value;
45         allowed[_from][msg.sender] -= _value;
46         Transfer(_from, _to, _value);
47         return true;
48       } else {
49         return false;
50       }
51     }
52 
53     function balanceOf(address _owner) constant returns (uint256 balance) {
54         return balances[_owner];
55     }
56 
57     function approve(address _spender, uint256 _value) returns (bool success) {
58         allowed[msg.sender][_spender] = _value;
59         Approval(msg.sender, _spender, _value);
60         return true;
61     }
62 
63     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
64       return allowed[_owner][_spender];
65     }
66 
67     mapping (address => uint256) balances;
68     mapping (address => mapping (address => uint256)) allowed;
69 	uint256 public totalSupply;
70 }
71 
72 
73 contract WEECoin is StandardToken, WeeMath {
74 
75     string public constant name = "WEE Token";
76     string public constant symbol = "WEE";
77     uint256 public constant decimals = 18;
78     string public version = "1.0";
79 	
80     address public WEEFundWallet;      
81     address public account1Address;      
82     address public account2Address;
83     address public account3Address;
84     
85     bool public isFinalized;
86     bool public isPreSale;    
87     bool public isMainSale;
88     uint public preSalePeriod;    
89     uint256 public weeOneEthCanBuy = 0; 	
90     uint256 public constant tokenSaleCap =  500 * (10**6) * 10**decimals;
91     uint256 public constant tokenPreSaleCap = 150 * (10**6) * 10**decimals; 
92 	uint256 public constant tokensForFinalize =  150 * (10**6) * 10**decimals;
93 	uint256 public totalEthInWei;  
94 	
95     event LogWEE(address indexed _to, uint256 _value);
96 
97     function WEECoin()
98     {                      
99       WEEFundWallet =  msg.sender;
100       account1Address = 0xe98FF512B5886Ef34730b0C84624f63bAD0A5212;	                    
101       account2Address = 0xDaB2365752B3Fe5E630d68F357293e26873288ff;	                    
102       account3Address = 0xfF5706dcCbA47E12d8107Dcd3CA5EF62e355b31E;	                    
103       isPreSale = false;
104       isMainSale = false;
105 	  isFinalized = false;   
106       totalSupply = ( (10**9) * 10**decimals ) + ( 100 * (10**6) * 10**decimals );
107 	  balances[WEEFundWallet] = totalSupply;         
108     }
109 
110     function () payable 
111 	{      
112       if ( (isFinalized) || (!isPreSale && !isMainSale) || (msg.value == 0) ) throw;
113       
114       uint256 tokens = multWee(msg.value, weeOneEthCanBuy); 
115       uint256 verifiedLeftTokens = subtractWee(balances[WEEFundWallet], tokens);
116 
117 	  if( (isMainSale) && (verifiedLeftTokens < (totalSupply - tokenSaleCap)) ) throw;
118 	  if (balances[WEEFundWallet] < tokens) throw;
119 	  
120       if( (isPreSale) && (verifiedLeftTokens < (totalSupply - tokenPreSaleCap) ) )
121 	  {			
122 		isMainSale = true;
123 		weeOneEthCanBuy = 10000; 	
124 		isPreSale = false;		
125 	  }     	  
126      
127       balances[msg.sender] += tokens;  
128 	  balances[WEEFundWallet] -= tokens;
129       LogWEE(msg.sender, tokens);  
130 	  
131       WEEFundWallet.transfer(msg.value);   	 
132 	  totalEthInWei = totalEthInWei + msg.value;	  
133     }
134 
135     function finalize() external {
136       if( (isFinalized) || (msg.sender != WEEFundWallet) ) throw;
137               
138       balances[account1Address] += tokensForFinalize;
139 	  LogWEE(account1Address, tokensForFinalize);
140 	  
141       balances[account2Address] += tokensForFinalize;
142       LogWEE(account2Address, tokensForFinalize);
143      
144 	  balances[account3Address] += tokensForFinalize;
145 	  LogWEE(account3Address, tokensForFinalize);
146 	  
147 	  balances[WEEFundWallet] -= (tokensForFinalize * 3);
148 	  
149       isFinalized = true;  
150     }
151 	
152     function switchStage() external {
153       if ( (isMainSale) || (msg.sender != WEEFundWallet) ) throw;
154       	  
155       if (!isPreSale){
156         isPreSale = true;
157         weeOneEthCanBuy = 20000;
158       }
159       else if (!isMainSale){
160         isMainSale = true;
161 		isPreSale = false;
162         weeOneEthCanBuy = 10000;       
163       }
164     }
165 }