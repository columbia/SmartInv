1 pragma solidity ^0.4.10;
2 
3 contract Token {
4     uint256 public totalSupply;
5     function balanceOf(address _owner) constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8     function approve(address _spender, uint256 _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 
15 /*  ERC 20 token */
16 contract StandardToken is Token {
17 
18     function transfer(address _to, uint256 _value) returns (bool success) {
19       if (balances[msg.sender] >= _value && _value > 0) {		
20         balances[msg.sender] -= _value;
21         balances[_to] += _value;
22         Transfer(msg.sender, _to, _value);
23         return true;
24       } else {
25         return false;
26       }
27     }
28 
29     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
30       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
31         balances[_to] += _value;
32         balances[_from] -= _value;
33         allowed[_from][msg.sender] -= _value;
34         Transfer(_from, _to, _value);
35         return true;
36       } else {
37         return false;
38       }
39     }
40 
41     function balanceOf(address _owner) constant returns (uint256 balance) {
42         return balances[_owner];
43     }
44 
45     function approve(address _spender, uint256 _value) returns (bool success) {
46         allowed[msg.sender][_spender] = _value;
47         Approval(msg.sender, _spender, _value);
48         return true;
49     }
50 
51     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
52       return allowed[_owner][_spender];
53     }
54 
55     mapping (address => uint256) balances;
56     mapping (address => mapping (address => uint256)) allowed;
57 }
58 
59 contract SMEToken is StandardToken {
60 
61     struct Funder{
62         address addr;
63         uint amount;
64     }
65 	
66     Funder[] funder_list;
67 	
68     // metadata
69 	string public constant name = "Sumerian Token";
70     string public constant symbol = "SUMER";
71     uint256 public constant decimals = 18;
72     string public version = "1.0";
73 	
74 	uint256 public constant LOCKPERIOD = 730 days;
75 	uint256 public constant LOCKAMOUNT1 = 4000000 * 10**decimals;   //LOCK1
76 	uint256 public constant LOCKAMOUNT2 = 4000000 * 10**decimals;   //LOCK2
77 	uint256 public constant LOCKAMOUNT3 = 4000000 * 10**decimals;   //LOCK3
78 	uint256 public constant LOCKAMOUNT4 = 4000000 * 10**decimals;   //LOCK4
79 	uint256 public constant CORNERSTONEAMOUNT = 2000000 * 10**decimals; //cornerstone
80     uint256 public constant PLATAMOUNT = 8000000 * 10**decimals;        //crowdfunding plat	
81 
82                         
83     address account1 = '0x5a0A46f082C4718c73F5b30667004AC350E2E140';  //7.5%  First Game	
84 	address account2 = '0xcD4fC8e4DA5B25885c7d80b6C846afb6b170B49b';  //30%   Management Team ,Game Company ,Law Support 	
85 	address account3 = '0x3d382e76b430bF8fd65eA3AD9ADfc3741D4746A4';  //10%   Technology Operation
86 	address account4 = '0x005CD1194C1F088d9bd8BF9e70e5e44D2194C029';  //22.5%  Blockchain Technology
87 	address account5 = '0x5CA7F20427e4D202777Ea8006dc8f614a289Be2F';  //30%    Exchange Listing , Marketing , Finance
88 						
89     uint256 val1 = 1 wei;    // 1
90     uint256 val2 = 1 szabo;  // 1 * 10 ** 12
91     uint256 val3 = 1 finney; // 1 * 10 ** 15
92     uint256 val4 = 1 ether;  // 1 * 10 ** 18
93 	
94 	address public creator;
95 	
96 	
97 	uint256 public gcStartTime = 0;     // unix timestamp seconds, 2017/07/15 19:00, 1500116400
98 	uint256 public gcEndTime = 0;       // unix timestamp seconds, 2017/08/15 19:00, 1502794800
99 	
100 	uint256 public ccStartTime = 0;     // unix timestamp seconds, 2017/07/01 19:00, 1498906800
101 	uint256 public ccEndTime = 0;       // unix timestamp seconds, 2017/07/15 19:00, 1500116400
102 
103 
104 	uint256 public gcSupply = 10000000 * 10**decimals;                 // 10000000 for general customer
105 	uint256 public constant gcExchangeRate=1000;                       // 1000 SMET per 1 ETH
106 	
107 	uint256 public ccSupply = 4000000 * 10**decimals;                 // 4000000 for corporate customer 
108 	uint256 public constant ccExchangeRate=1250;                      // 1250 SMET per 1 ETH      
109 	
110 	uint256 public totalSupply=0;
111 	
112 	function getFunder(uint index) public constant returns(address, uint) {
113         Funder f = funder_list[index];
114         
115         return (
116             f.addr,
117             f.amount
118         ); 
119     }
120 	
121 	function clearSmet(){
122 	    if (msg.sender != creator) throw;
123 		balances[creator] += ccSupply;
124 		balances[creator] += gcSupply;
125 		ccSupply = 0;
126 		gcSupply = 0;
127 		totalSupply = 0;
128 	}
129 
130     // constructor
131     function SMEToken(
132 		uint256 _gcStartTime,
133 		uint256 _gcEndTime,
134 		uint256 _ccStartTime,
135 		uint256 _ccEndTime
136 		) {
137 	    creator = msg.sender;
138 		totalSupply = gcSupply + ccSupply;
139 		balances[msg.sender] = CORNERSTONEAMOUNT + PLATAMOUNT;    //for cornerstone investors and crowdfunding plat
140 		balances[account1] = LOCKAMOUNT1;                         //10%   Game Company 
141 		balances[account2] = LOCKAMOUNT2;                         //10%   Management Team
142 		balances[account3] = LOCKAMOUNT3;                         //10%   Technology Operation
143 		balances[account4] = LOCKAMOUNT4;                         //10%   Blockchain Technology
144 		gcStartTime = _gcStartTime;
145 		gcEndTime = _gcEndTime;
146 		ccStartTime = _ccStartTime;
147 		ccEndTime = _ccEndTime;
148     }
149 	
150 	function transfer(address _to, uint256 _value) returns (bool success) {
151       if (balances[msg.sender] >= _value && _value > 0) {	
152 	    if(msg.sender == account1 || msg.sender == account2 || msg.sender == account3 || msg.sender == account4){
153 			if(now < gcStartTime + LOCKPERIOD){
154 			    return false;
155 			}
156 		}
157 		else{
158 			balances[msg.sender] -= _value;
159 			balances[_to] += _value;
160 			Transfer(msg.sender, _to, _value);
161 			return true;
162 		}
163         
164       } else {
165         return false;
166       }
167     }
168 	
169 
170     function createTokens() payable {
171 	    if (now < ccStartTime) throw;
172 		if (now > gcEndTime) throw;
173 	    if (msg.value < val3) throw;
174 		
175 		uint256 smtAmount;
176 		if (msg.value >= 10*val4 && now <= ccEndTime){
177 			smtAmount = msg.value * ccExchangeRate;
178 			if (totalSupply < smtAmount) throw;
179             if (ccSupply < smtAmount) throw;
180             totalSupply -= smtAmount;  
181             ccSupply -= smtAmount;    			
182             balances[msg.sender] += smtAmount;
183 		    var new_cc_funder = Funder({addr: msg.sender, amount: msg.value / val3});
184 		    funder_list.push(new_cc_funder);
185 		}
186         else{
187 		    if(now < gcStartTime) throw;
188 			smtAmount = msg.value * gcExchangeRate;
189 			if (totalSupply < smtAmount) throw;
190             if (gcSupply < smtAmount) throw;
191             totalSupply -= smtAmount;  
192             gcSupply -= smtAmount;    			
193             balances[msg.sender] += smtAmount;
194 		    var new_gc_funder = Funder({addr: msg.sender, amount: msg.value / val3});
195 		    funder_list.push(new_gc_funder);
196 		}		
197 		
198         if(!account1.send(msg.value*75/1000)) throw;
199 		if(!account2.send(msg.value*300/1000)) throw;
200 		if(!account3.send(msg.value*100/1000)) throw;
201 		if(!account4.send(msg.value*225/1000)) throw;
202 		if(!account5.send(msg.value*300/1000)) throw;
203     }
204 	
205 	// fallback
206     function() payable {
207         createTokens();
208     }
209 
210 }