1 pragma solidity ^0.4.18;
2 
3 contract owned {
4 	address public owner;
5 	address public server;
6 
7 	function owned() {
8 		owner = msg.sender;
9 		server = msg.sender;
10 	}
11 
12 	function changeOwner(address newOwner) onlyOwner {
13 		owner = newOwner;
14 	}
15 
16 	function changeServer(address newServer) onlyOwner {
17 		server = newServer;
18 	}
19 
20 	modifier onlyOwner {
21 		require(msg.sender == owner);
22 		_;
23 	}
24 
25 	modifier onlyServer {
26 		require(msg.sender == server);
27 		_;
28 	}
29 }
30 
31 
32 contract Utils {
33 
34 	function Utils() {
35 	}
36 
37 	// Validates an address - currently only checks that it isn't null
38 	modifier validAddress(address _address) {
39 		require(_address != 0x0);
40 		_;
41 	}
42 }
43 
44 contract Crowdsale is owned,Utils {
45     
46     //*** Pre-sale ***//
47     uint preSaleStart=1513771200;
48     uint preSaleEnd=1515585600;
49     uint256 preSaleTotalTokens=30000000;
50     uint256 preSaleTokenCost=6000;
51     address preSaleAddress;
52     
53      //*** ICO ***//
54     uint icoStart;
55     uint256 icoSaleTotalTokens=400000000;
56     address icoAddress;
57     
58     //*** Advisers,Consultants ***//
59     uint256 advisersConsultantTokens=15000000;
60     address advisersConsultantsAddress;
61     
62     //*** Bounty ***//
63     uint256 bountyTokens=15000000;
64     address bountyAddress=0xD53E82Aea770feED8e57433D3D61674caEC1D1Be;
65     
66     //*** Founders ***//
67     uint256 founderTokens=40000000;
68     address founderAddress;
69     
70     //***Balance***//
71     mapping (address => uint256) public balanceOf;
72     
73     //*** Tranfer ***//
74     event Transfer(address indexed from, address indexed to, uint256 value);
75     
76     //*** GraphenePowerCrowdsale ***//
77     function GraphenePowerCrowdsale(){
78         balanceOf[this]=500000000;
79         preSaleAddress=0xC07850969A0EC345A84289f9C5bb5F979f27110f;
80         icoAddress=0x1C21Cf57BF4e2dd28883eE68C03a9725056D29F1;
81         advisersConsultantsAddress=0xe8B6dA1B801b7F57e3061C1c53a011b31C9315C7;
82         bountyAddress=0xD53E82Aea770feED8e57433D3D61674caEC1D1Be;
83         founderAddress=0xDA0D3Dad39165EA2d7386f18F96664Ee2e9FD8db;
84     }
85     
86     //*** Start ico ***//
87     function startIco() onlyOwner internal{
88         icoStart=now;
89     }
90     
91     //*** Is ico closed ***//
92     function isIcoClosed() constant returns (bool closed) {
93 		return ((icoStart+(35*24*60*60)) >= now);
94 	}
95     
96     //*** Is preSale closed ***//
97     function isPreSaleClosed() constant returns (bool closed) {
98 		return (preSaleEnd >= now);
99 	}
100 	
101 	//*** Get Bounty Tokens ***//
102 	function getBountyTokens() onlyOwner{
103 	    require(bountyTokens>0);
104 	    payment(bountyAddress,bountyTokens);
105 	    bountyTokens=0;
106 	}
107 	
108 	//*** Get Founders Tokens ***//
109 	function getFoundersTokens() onlyOwner{
110 	    require(founderTokens>0);
111 	    payment(founderAddress,founderTokens);
112 	    founderTokens=0;
113 	}
114 	
115 	//*** Get Advisers,Consultants Tokens ***//
116 	function getAdvisersConsultantsTokens() onlyOwner{
117 	    require(advisersConsultantTokens>0);
118 	    payment(advisersConsultantsAddress,advisersConsultantTokens);
119 	    advisersConsultantTokens=0;
120 	}
121 	
122 	//*** Payment ***//
123     function payment(address _from,uint256 _tokens) internal{
124         if(balanceOf[this] > _tokens){
125             balanceOf[msg.sender] += _tokens;
126             balanceOf[this] -= _tokens;
127             Transfer(this, _from, _tokens);
128         }
129     }
130     
131     //*** Payable ***//
132     function() payable {
133         require(msg.value>0);
134         
135         if(!isPreSaleClosed()){
136             uint256 tokensPreSale = preSaleTotalTokens * msg.value / 1000000000000000000;
137             require(preSaleTotalTokens >= tokensPreSale);
138             payment(msg.sender,tokensPreSale);
139         }
140         else if(!isIcoClosed()){
141              if((icoStart+(7*24*60*60)) >= now){
142                  uint256 tokensWeek1 = 4000 * msg.value / 1000000000000000000;
143                  require(icoSaleTotalTokens >= tokensWeek1);
144                  payment(msg.sender,tokensWeek1);
145                  icoSaleTotalTokens-=tokensWeek1;
146             }
147             else if((icoStart+(14*24*60*60)) >= now){
148                  uint256 tokensWeek2 = 3750 * msg.value / 1000000000000000000;
149                  require(icoSaleTotalTokens >= tokensWeek2);
150                  payment(msg.sender,tokensWeek2);
151                  icoSaleTotalTokens-=tokensWeek2;
152             }
153             else if((icoStart+(21*24*60*60)) >= now){
154                  uint256 tokensWeek3 = 3500 * msg.value / 1000000000000000000;
155                  require(icoSaleTotalTokens >= tokensWeek3);
156                  payment(msg.sender,tokensWeek3);
157                  icoSaleTotalTokens-=tokensWeek3;
158             }
159             else if((icoStart+(28*24*60*60)) >= now){
160                  uint256 tokensWeek4 = 3250 * msg.value / 1000000000000000000;
161                  require(icoSaleTotalTokens >= tokensWeek4);
162                  payment(msg.sender,tokensWeek4);
163                  icoSaleTotalTokens-=tokensWeek4;
164             }
165             else if((icoStart+(35*24*60*60)) >= now){
166                  uint256 tokensWeek5 = 3000 * msg.value / 1000000000000000000;
167                  require(icoSaleTotalTokens >= tokensWeek5);
168                  payment(msg.sender, tokensWeek5);
169                  icoSaleTotalTokens-=tokensWeek5;
170             }
171         }
172 	}
173 }
174 
175 contract GraphenePowerToken is Crowdsale {
176     
177     /* Public variables of the token */
178 	string public standard = 'Token 0.1';
179 
180 	string public name = 'Graphene Power';
181 
182 	string public symbol = 'GRP';
183 
184 	uint8 public decimals = 18;
185 
186 	uint256 _totalSupply =500000000;
187 
188 	/* This creates an array with all balances */
189 	mapping (address => uint256) balances;
190 
191 	/* This generates a public event on the blockchain that will notify clients */
192 	event Transfer(address from, address to, uint256 value);
193 
194     bool transfersEnable=false;
195     
196 	//*** Total Supply ***//
197 	function totalSupply() constant returns (uint256 totalSupply) {
198 		totalSupply = _totalSupply;
199 	}
200 	
201 	/*** Send coins ***/
202 	function transfer(address _to, uint256 _value) returns (bool success) {
203 		if (transfersEnable) {
204 	       require(balanceOf[msg.sender] >= _value);
205            balanceOf[msg.sender] -= _value;
206            balanceOf[_to] += _value;
207            Transfer(msg.sender, _to, _value);
208 		   return true;
209 		}
210       	else{
211 	           return false;
212 	        }
213 	}
214 	
215 	//*** Transfer Enabled ***//
216 	function transfersEnabled() onlyOwner{
217 	    require(!transfersEnable);
218 	    transfersEnable=true;
219 	}
220 }