1 pragma solidity ^0.4.2;
2 contract blockcdn {
3     mapping (address => uint256) balances;
4 	mapping (address => uint256) fundValue;
5 	address public owner;
6     string public name;
7     string public symbol;
8     uint8 public decimals;
9     uint256 public totalSupply;
10     uint256 public minFundedValue;
11 	uint256 public maxFundedValue;
12     bool public isFundedMax;
13     bool public isFundedMini;
14     uint256 public closeTime;
15     uint256 public startTime;
16     
17      /* This generates a public event on the blockchain that will notify clients */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     
20     function blockcdn(
21 	    address _owner,
22         string _tokenName,
23         uint8 _decimalUnits,
24         string _tokenSymbol,
25 		uint256 _totalSupply,
26         uint256 _closeTime,
27         uint256 _startTime,
28 		uint256 _minValue,
29 		uint256 _maxValue
30         ) { 
31         owner = _owner;                                      // Set owner of contract 
32         name = _tokenName;                                   // Set the name for display purposes
33         symbol = _tokenSymbol;                               // Set the symbol for display purposes
34         decimals = _decimalUnits;                            // Amount of decimals for display purposes
35         closeTime = _closeTime;                              // Set fund closing time
36 		startTime = _startTime;                              // Set fund start time
37 		totalSupply = _totalSupply;                          // Total supply
38 		minFundedValue = _minValue;                          // Set minimum funding goal
39 		maxFundedValue = _maxValue;                          // Set max funding goal
40 		isFundedMax = false;                                 // Initialize fund minimum flag 
41 		isFundedMini = false;                                // Initialize fund max flag
42 		balances[owner] = _totalSupply;                      // Set owner balance equal totalsupply 
43     }
44     
45 	/*default-function called when values are sent */
46 	function () payable {
47        buyBlockCDN();
48     }
49 	
50     /*send ethereum and get BCDN*/
51     function buyBlockCDN() payable returns (bool success){
52 		if(msg.sender == owner) throw;
53         if(now > closeTime) throw; 
54         if(now < startTime) throw;
55         if(isFundedMax) throw;
56         uint256 token = 0;
57         if(closeTime - 2 weeks > now) {
58              token = msg.value;
59         }else {
60             uint day = (now - (closeTime - 2 weeks))/(2 days) + 1;
61             token = msg.value;
62             while( day > 0) {
63                 token  =   token * 95 / 100 ;    
64                 day -= 1;
65             }
66         }
67         
68         balances[msg.sender] += token;
69         if(balances[owner] < token) 
70             return false;
71         balances[owner] -= token;
72         if(this.balance >= minFundedValue) {
73             isFundedMini = true;
74         }
75         if(this.balance >= maxFundedValue) {
76             isFundedMax = true;   
77         }
78 		fundValue[msg.sender] += msg.value;
79         Transfer(owner, msg.sender, token);    
80         return true;
81     }    
82     
83      /*query BCDN balance*/
84     function balanceOf( address _owner) constant returns (uint256 value)
85     {
86         return balances[_owner];
87     }
88 	
89 	/*query fund ethereum balance */
90 	function balanceOfFund(address _owner) constant returns (uint256 value)
91 	{
92 		return fundValue[_owner];
93 	}
94 
95     /*refund 'msg.sender' in the case the Token Sale didn't reach ite minimum 
96     funding goal*/
97     function reFund() payable returns (bool success) {
98         if(now <= closeTime) throw;     
99 		if(isFundedMini) throw;             
100 		uint256 value = fundValue[msg.sender];
101 		fundValue[msg.sender] = 0;
102 		if(value <= 0) throw;
103         if(!msg.sender.send(value)) 
104             throw;
105         balances[owner] +=  balances[msg.sender];
106         balances[msg.sender] = 0;
107         Transfer(msg.sender, this, balances[msg.sender]); 
108         return true;
109     }
110 
111 	
112 	/*refund _fundaddr in the case the Token Sale didn't reach ite minimum 
113     funding goal*/
114 	function reFundByOther(address _fundaddr) payable returns (bool success) {
115 	    if(now <= closeTime) throw;    
116 		if(isFundedMini) throw;           
117 		uint256 value = fundValue[_fundaddr];
118 		fundValue[_fundaddr] = 0;
119 		if(value <= 0) throw;
120         if(!_fundaddr.send(value)) throw;
121         balances[owner] += balances[_fundaddr];
122         balances[_fundaddr] = 0;
123         Transfer(msg.sender, this, balances[_fundaddr]); 
124         return true;
125 	}
126 
127     
128     /* Send coins */
129     function transfer(address _to, uint256 _value) payable returns (bool success) {
130         if(_value <= 0 ) throw;                                      // Check send token value > 0;
131 		if (balances[msg.sender] < _value) throw;                    // Check if the sender has enough
132         if (balances[_to] + _value < balances[_to]) throw;           // Check for overflows
133 		if(now < closeTime ) {										 // unclosed allowed retrieval, Closed fund allow transfer   
134 			if(_to == address(this)) {
135 				fundValue[msg.sender] -= _value;
136 				balances[msg.sender] -= _value;
137 				balances[owner] += _value;
138 				if(!msg.sender.send(_value))
139 					return false;
140 				Transfer(msg.sender, _to, _value); 							// Notify anyone listening that this transfer took place
141 				return true;      
142 			}
143 		} 										
144 		
145 		balances[msg.sender] -= _value;                          // Subtract from the sender
146 		balances[_to] += _value;                                 // Add the same to the recipient                       
147 		 
148 		Transfer(msg.sender, _to, _value); 							// Notify anyone listening that this transfer took place
149 		return true;      
150     }
151     
152     /*send reward*/
153     function sendRewardBlockCDN(address rewarder, uint256 value) payable returns (bool success) {
154         if(msg.sender != owner) throw;
155 		if(now <= closeTime) throw;        
156 		if(!isFundedMini) throw;               
157         if( balances[owner] < value) throw;
158         balances[rewarder] += value;
159         uint256 halfValue  = value / 2;
160         balances[owner] -= halfValue;
161         totalSupply +=  halfValue;
162         Transfer(owner, rewarder, value);    
163         return true;
164        
165     }
166     
167     function modifyStartTime(uint256 _startTime) {
168 		if(msg.sender != owner) throw;
169         startTime = _startTime;
170     }
171     
172     function modifyCloseTime(uint256 _closeTime) {
173 		if(msg.sender != owner) throw;
174        closeTime = _closeTime;
175     }
176     
177     /*withDraw ethereum when closed fund*/
178     function withDrawEth(uint256 value) payable returns (bool success) {
179         if(now <= closeTime ) throw;
180         if(!isFundedMini) throw;
181         if(this.balance < value) throw;
182         if(msg.sender != owner) throw;
183         if(!msg.sender.send(value))
184             return false;
185         return true;
186     }
187 }