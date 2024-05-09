1 pragma solidity ^0.4.13;
2 
3 
4 
5 library SafeMath {
6 
7     function mul(uint a, uint b) internal returns (uint) {
8         uint c = a * b;
9         assert(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function div(uint a, uint b) internal returns (uint) {
14         assert(b > 0);
15         uint c = a / b;
16         assert(a == b * c + a % b);
17         return c;
18     }
19 
20     function add(uint a, uint b) internal returns (uint) {
21         uint c = a + b;
22         assert(c >= a && c >= b);
23         return c;
24     }
25 
26 }
27 
28 
29 
30 contract Token {
31 
32 	/// total amount of tokens
33     uint public totalSupply;
34 
35 	/// return tokens balance
36     function balanceOf(address _owner) constant returns (uint balance);
37 
38 	/// tranfer successful or not
39     function transfer(address _to, uint _value) returns (bool success);
40 
41 	/// tranfer successful or not
42     function transferFrom(address _from, address _to, uint _value) returns (bool success);
43 
44 	/// approval successful or not
45     function approve(address _spender, uint _value) returns (bool success);
46 
47 	/// amount of remaining tokens
48     function allowance(address _owner, address _spender) constant returns (uint remaining);
49 
50 	/// events
51     event Transfer(address indexed _from, address indexed _to, uint _value);
52     event Approval(address indexed _owner, address indexed _spender, uint _value);
53 
54 }
55 
56 
57 
58 contract StandardToken is Token {
59 
60     function transfer(address _to, uint _value) returns (bool success) {
61 		require( msg.data.length >= (2 * 32) + 4 );
62 		require( _value > 0 );
63 		require( balances[msg.sender] >= _value );
64 		require( balances[_to] + _value > balances[_to] );
65 
66         balances[msg.sender] -= _value;
67         balances[_to] += _value;
68         Transfer(msg.sender, _to, _value);
69         return true;
70     }
71 
72     function transferFrom(address _from, address _to, uint _value) returns (bool success) {
73 		require( msg.data.length >= (3 * 32) + 4 );
74 		require( _value > 0 );
75 		require( balances[_from] >= _value );
76 		require( allowed[_from][msg.sender] >= _value );
77 		require( balances[_to] + _value > balances[_to] );
78 
79         balances[_from] -= _value;
80 		allowed[_from][msg.sender] -= _value;
81 		balances[_to] += _value;
82         Transfer(_from, _to, _value);
83         return true;
84     }
85 
86     function balanceOf(address _owner) constant returns (uint balance) {
87         return balances[_owner];
88     }
89 
90     function approve(address _spender, uint _value) returns (bool success) {
91 		require( _value == 0 || allowed[msg.sender][_spender] == 0 );
92 
93         allowed[msg.sender][_spender] = _value;
94         Approval(msg.sender, _spender, _value);
95         return true;
96     }
97 
98     function allowance(address _owner, address _spender) constant returns (uint remaining) {
99         return allowed[_owner][_spender];
100     }
101 
102     mapping (address => uint) balances;
103     mapping (address => mapping (address => uint)) allowed;
104 
105 }
106 
107 
108 
109 contract LudumToken is StandardToken {
110 
111     using SafeMath for uint;
112 
113 	string public constant name = "Ludum"; // Ludum tokens name
114     string public constant symbol = "LDM"; // Ludum tokens ticker
115     uint8 public constant decimals = 18; // Ludum tokens decimals
116 	uint public constant maximumSupply =  100000000000000000000000000; // Maximum 100M Ludum tokens can be created
117 
118     address public ethDepositAddress;
119     address public teamFundAddress;
120 	address public operationsFundAddress;
121 	address public marketingFundAddress;
122 
123     bool public isFinalized;
124 	uint public constant crowdsaleStart = 1503921600;
125 	uint public constant crowdsaleEnd = 1506340800;
126 	
127 	uint public constant teamPercent = 10;
128 	uint public constant operationsPercent = 10;
129 	uint public constant marketingPercent = 5;
130 
131 
132     function ludumTokensPerEther() constant returns(uint) {
133 
134 		if (now < crowdsaleStart || now > crowdsaleEnd) {
135 			return 0;
136 		} else {
137 			if (now < crowdsaleStart + 1 days) return 15000; // Ludum token sale with 50% bonus
138 			if (now < crowdsaleStart + 7 days) return 13000; // Ludum token sale with 30% bonus
139 			if (now < crowdsaleStart + 14 days) return 11000; // Ludum token sale with 10% bonus
140 			return 10000; // Ludum token sale
141 		}
142 
143     }
144 
145 
146     // events
147     event CreateLudumTokens(address indexed _to, uint _value);
148 
149     // Ludum token constructor
150     function LudumToken(
151         address _ethDepositAddress,
152         address _teamFundAddress,
153 		address _operationsFundAddress,
154 		address _marketingFundAddress
155 	)
156     {
157         isFinalized = false;
158         ethDepositAddress = _ethDepositAddress;
159         teamFundAddress = _teamFundAddress;
160 	    operationsFundAddress = _operationsFundAddress;
161 	    marketingFundAddress = _marketingFundAddress;
162     }
163 
164 
165     function makeTokens() payable  {
166 		require( !isFinalized );
167 		require( now >= crowdsaleStart );
168 		require( now < crowdsaleEnd );
169 		require( msg.value >= 10 finney );
170 
171         uint tokens = msg.value.mul(ludumTokensPerEther());
172 	    uint teamTokens = tokens.mul(teamPercent).div(100);
173 	    uint operationsTokens = tokens.mul(operationsPercent).div(100);
174 	    uint marketingTokens = tokens.mul(marketingPercent).div(100);
175 
176 	    uint currentSupply = totalSupply.add(tokens).add(teamTokens).add(operationsTokens).add(marketingTokens);
177 
178 		require( maximumSupply >= currentSupply );
179 
180         totalSupply = currentSupply;
181 
182         balances[msg.sender] += tokens;
183         CreateLudumTokens(msg.sender, tokens);
184 	  
185 	    balances[teamFundAddress] += teamTokens;
186         CreateLudumTokens(teamFundAddress, teamTokens);
187 	  
188 	    balances[operationsFundAddress] += operationsTokens;
189         CreateLudumTokens(operationsFundAddress, operationsTokens);
190 	  
191 	    balances[marketingFundAddress] += marketingTokens;
192         CreateLudumTokens(marketingFundAddress, marketingTokens);
193     }
194 
195 
196     function() payable {
197         makeTokens();
198     }
199 
200 
201     function finalizeCrowdsale() external {
202 		require( !isFinalized );
203 		require( msg.sender == ethDepositAddress );
204 		require( now >= crowdsaleEnd || totalSupply == maximumSupply );
205 
206         isFinalized = true;
207 
208 		require( ethDepositAddress.send(this.balance) );
209     }
210 
211 }