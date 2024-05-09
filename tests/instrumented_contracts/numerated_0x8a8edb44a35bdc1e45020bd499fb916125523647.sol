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
69 	uint256 public constant DURATION = 30 days; 
70     string public constant name = "SMET";
71     string public constant symbol = "SMET";
72     uint256 public constant decimals = 0;
73     string public version = "1.0";
74 	
75 	address account1 = '0xcD4fC8e4DA5B25885c7d80b6C846afb6b170B49b';  //50%   Use Cases and Business Applications
76 	address account2 = '0x005CD1194C1F088d9bd8BF9e70e5e44D2194C029';  //24%   Blockchain Technology
77     address account3 = '0x00d0ACA6D3D07B3546Fc76E60a90ccdccC7c0e0C';  //6%    Mobile APP,SDK Technology
78 	address account4 = '0x5CA7F20427e4D202777Ea8006dc8f614a289Be2F';  //10%   Mobile Internet Technology
79 	address account5 = '0x7d49c6a86FDE3dE9c47544c58b7b0F035197415b';  //10%   Marketing
80 
81 
82     uint256 val1 = 1 wei;    // 1
83     uint256 val2 = 1 szabo;  // 1 * 10 ** 12
84     uint256 val3 = 1 finney; // 1 * 10 ** 15
85     uint256 val4 = 1 ether;  // 1 * 10 ** 18
86 	
87 	address public creator;
88 	uint256 public sellPrice;
89 	uint256 public totalSupply;
90 	uint256 public startTime = 0;   // unix timestamp seconds
91 	uint256 public endTime = 0;     // unix timestamp seconds
92 	
93     uint256 public constant tokenExchangeRate = 1000; // 1000 SME tokens per 1 ETH
94 
95     function setPrices(uint256 newSellPrice) {
96         if (msg.sender != creator) throw;
97         sellPrice = newSellPrice;
98     }
99 	
100 	function issue(uint256 amount) {
101 	    if (msg.sender != creator) throw;
102 		totalSupply += amount;
103 	}
104 	
105 	function burn(uint256 amount) {
106 	    if (msg.sender != creator) throw;
107 		totalSupply -= amount;
108 	}
109 	
110 	function getBalance() returns (uint) {
111         return this.balance;
112     } 
113 	
114 	function getFunder(uint index) public constant returns(address, uint) {
115         Funder f = funder_list[index];
116         
117         return (
118             f.addr,
119             f.amount
120         ); 
121     }
122 
123     // constructor
124     function SMEToken(
125 	    uint256 initialSupply,
126         uint256 initialPrice,
127 		uint256 initialStartTime
128 		) {
129 	    creator = msg.sender;
130 		totalSupply = initialSupply;
131 		balances[msg.sender] = initialSupply;
132 		sellPrice = initialPrice;
133 		startTime = initialStartTime;
134 		endTime = initialStartTime + DURATION;
135     }
136 
137     /// @dev Accepts ether and creates new SME tokens.
138     function createTokens() payable {
139 	    if (now < startTime) throw;
140 		if (now > endTime) throw;
141 	    if (msg.value < val4) throw;
142 		if (msg.value % val4 != 0) throw;
143 		var new_funder = Funder({addr: msg.sender, amount: msg.value / val4});
144 		funder_list.push(new_funder);
145 		
146 	    uint256 smecAmount = msg.value / sellPrice;
147         if (totalSupply < smecAmount) throw;
148         if (balances[msg.sender] + smecAmount < balances[msg.sender]) throw; 
149         totalSupply -= smecAmount;                     
150         balances[msg.sender] += smecAmount;
151 		
152         if(!account1.send(msg.value*50/100)) throw;
153 		if(!account2.send(msg.value*24/100)) throw;
154 		if(!account3.send(msg.value*6/100)) throw;
155 		if(!account4.send(msg.value*10/100)) throw;
156 		if(!account5.send(msg.value*10/100)) throw;
157     }
158 	
159 	// fallback
160     function() payable {
161         createTokens();
162     }
163 
164 }