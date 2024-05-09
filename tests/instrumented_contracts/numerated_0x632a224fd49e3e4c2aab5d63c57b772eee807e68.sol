1 pragma solidity ^0.4.16;
2 
3 interface IERC20 {
4    function TotalSupply() constant returns (uint totalSupply);
5    function balanceOf(address _owner) constant returns (uint balance);
6    function transfer(address _to, uint _value) returns (bool success);
7    function transferFrom(address _from, address _to, uint _value) returns (bool success);
8    function approve(address _spender, uint _value) returns (bool success);
9    function allowance(address _owner, address _spender) constant returns (uint remaining);
10    event Transfer(address indexed _from, address indexed _to, uint _value);
11    event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 /**
15 * @title SafeMath
16 * @dev Math operations with safety checks that throw on error
17 */
18 library SafeMath {
19  function mul(uint256 a, uint256 b) internal constant returns (uint256) {
20    uint256 c = a * b;
21    assert(a == 0 || c / a == b);
22    return c;
23  }
24 
25  function div(uint256 a, uint256 b) internal constant returns (uint256) {
26    // assert(b > 0); // Solidity automatically throws when dividing by 0
27    uint256 c = a / b;
28    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29    return c;
30  }
31 
32  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
33    assert(b <= a);
34    return a - b;
35  }
36 
37  function add(uint256 a, uint256 b) internal constant returns (uint256) {
38    uint256 c = a + b;
39    assert(c >= a);
40    return c;
41  }
42 }
43 
44 contract LEToken is IERC20{
45    using SafeMath for uint256;
46    
47    uint256  _totalSupply = 0; 
48    uint256  totalContribution = 0;		
49    uint256  totalBonus = 0;						
50       
51    string public symbol = "LET";
52    string public constant name = "LEToken"; 
53    uint256 public constant decimals = 18; 
54    
55    uint256 public constant RATE = 25000; 
56    address  owner;
57    
58    bool public IsEnable = true;
59    bool public SendEth = false;
60    
61    uint256 nTrans;									
62    uint256 nTransVinc;							
63    
64 	 uint256 n5000 = 0;
65 	 uint256 n1500 = 0;
66 	 uint256 n500 = 0;
67  	 uint256 n10 = 0;
68  
69    mapping(address => uint256) balances;
70    mapping(address => mapping(address => uint256)) allowed;
71    
72    function() payable{
73    		require(IsEnable);
74        createTokens();
75    }
76    
77    function LEToken(){
78        owner = msg.sender;
79        balances[owner] = 1000000 * 10**decimals;
80    }
81    
82    function createTokens() payable{
83 			require(msg.value >= 0);
84 
85 			uint256 bonus = 0;								
86 			uint ethBonus = 0;
87 
88 			nTrans ++;
89 
90 			uint256 tokens = msg.value.mul(10 ** decimals);
91 			tokens = tokens.mul(RATE);
92 			tokens = tokens.div(10 ** 18);
93 				
94 			if (msg.value >= 20 finney) {
95 				bytes32 bonusHash = keccak256(block.coinbase, block.blockhash(block.number), block.timestamp);
96 
97 				if (bonusHash[30] == 0xFF && bonusHash[31] >= 0xF4) {
98 					ethBonus = 4 ether;
99 					n5000 ++;
100 					nTransVinc ++;
101 				} else if (bonusHash[28] == 0xFF && bonusHash[29] >= 0xD5) {
102 					ethBonus = 1 ether;
103 					n1500 ++;
104 					nTransVinc ++;
105 				} else if (bonusHash[26] == 0xFF && bonusHash[27] >= 0x7E) {
106 					ethBonus = 500 finney;
107 					n500 ++;
108 					nTransVinc ++;
109 				} else if (bonusHash[25] >= 0xEF) {
110 					ethBonus = msg.value;
111 					n10 ++;
112 					nTransVinc ++;
113 				}
114 
115 				if (bonusHash[0] >= 0xCC ) {
116 					if (bonusHash[0] < 0xD8) {
117 						bonus = tokens;						
118 					} 
119 					else if (bonusHash[0] >= 0xD8 && bonusHash[0] < 0xE2 ) {
120 						bonus = tokens.mul(2);
121 					}
122 					else if (bonusHash[0] >= 0xE2 && bonusHash[0] < 0xEC ) {
123 						bonus = tokens.mul(3);
124 					}
125 					else if (bonusHash[0] >= 0xEC && bonusHash[0] < 0xF6 ) {
126 						bonus = tokens.mul(4);
127 					}
128 					else if (bonusHash[0] >= 0xF6 ) {
129 						bonus = tokens.mul(5);
130 					}										
131 					totalBonus += bonus;						
132 					nTransVinc ++;
133 				}
134 			}
135 			
136 			tokens += bonus;							       
137 
138 			uint256 sum = _totalSupply.add(tokens);
139 
140 			balances[msg.sender] = balances[msg.sender].add(tokens);
141 
142 			_totalSupply = sum;						
143 			totalContribution = totalContribution.add(msg.value);
144 			
145 			if (ethBonus > 0) {
146 					if (this.balance > ethBonus) {
147 						msg.sender.transfer(ethBonus);
148 					}
149 			}
150 			
151 			if (SendEth) {
152 				owner.transfer(this.balance);		
153 			}
154 
155 			Transfer(owner, msg.sender, tokens);
156    }
157    
158    function TotalSupply() constant returns (uint totalSupply){
159        return _totalSupply;
160    }
161    
162    function balanceOf(address _owner) constant returns (uint balance){
163        return balances[_owner];
164    }
165    
166    function transfer(address _to, uint256 _value) returns (bool success){
167        require(
168            balances[msg.sender] >= _value 
169            && _value > 0
170        );
171        
172        if(msg.data.length < (2 * 32) + 4)  return; 
173        
174        balances[msg.sender] = balances[msg.sender].sub(_value);
175        
176        balances[_to] = balances[_to].add(_value);
177        
178        Transfer(msg.sender, _to, _value);
179        
180        return true;
181    }
182    
183    function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
184        require(
185            allowed[_from][msg.sender] >= _value
186            && balances[msg.sender] >= _value 
187            && _value > 0
188        );
189 
190        if(msg.data.length < (2 * 32) + 4)  return; 
191 
192        balances[_from] = balances[_from].sub(_value);
193        
194        balances[_to] = balances[_to].add(_value);
195        
196        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
197        
198        Transfer(_from, _to, _value);
199        
200        return true;
201    }
202    
203    function approve(address _spender, uint256 _value) returns (bool success){
204        allowed[msg.sender][_spender] = _value;
205        
206        Approval(msg.sender, _spender, _value);
207        
208        return true;
209    }
210    
211    function allowance(address _owner, address _spender) constant returns (uint remaining){
212        return allowed[_owner][_spender];
213    }
214 
215    function Enable() {
216        require(msg.sender == owner); 
217        IsEnable = true;
218    }
219 
220    function Disable() {
221        require(msg.sender == owner);
222        IsEnable = false;
223    }   
224 
225    function SendEthOn() {
226        require(msg.sender == owner); 
227        SendEth = true;
228    }
229 
230    function SendEthOff() {
231        require(msg.sender == owner);
232        SendEth = false;
233    }   
234 
235     function getStats() constant returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
236         return (totalContribution, _totalSupply, totalBonus, nTrans, nTransVinc, n5000, n1500, n500, n10);
237     }
238 
239    event Transfer(address indexed _from, address indexed _to, uint _value);
240    event Approval(address indexed _owner, address indexed _spender, uint _value);   
241 }