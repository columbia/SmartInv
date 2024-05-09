1 pragma solidity ^0.4.21;
2 
3 interface IERC20 {
4     function totalSupply() constant returns (uint256 totalSupply);
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
15 
16 
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that throw on error
21  */
22 library SafeMath {
23 
24   /**
25   * @dev Multiplies two numbers, throws on overflow.
26   */
27   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28     if (a == 0) {
29       return 0;
30     }
31     uint256 c = a * b;
32     assert(c / a == b);
33     return c;
34   }
35 
36   /**
37   * @dev Integer division of two numbers, truncating the quotient.
38   */
39   function div(uint256 a, uint256 b) internal pure returns (uint256) {
40     // assert(b > 0); // Solidity automatically throws when dividing by 0
41     uint256 c = a / b;
42     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43     return c;
44   }
45 
46   /**
47   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
48   */
49   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50     assert(b <= a);
51     return a - b;
52   }
53 
54   /**
55   * @dev Adds two numbers, throws on overflow.
56   */
57   function add(uint256 a, uint256 b) internal pure returns (uint256) {
58     uint256 c = a + b;
59     assert(c >= a);
60     return c;
61   }
62 }
63 
64 
65 
66 contract BroFistCoin is IERC20 {
67     
68     using SafeMath for uint256;
69     
70     uint public _totalSupply = 0; // Begins with 0 Coins
71     
72     string public constant symbol = "BRO";
73     string public constant name = "BroFistCoin";
74     uint8 public constant decimals = 18;  
75          
76     uint public startDate = 1520776800; // GMT/UTC: Sunday, 11. March 2018 2pm 
77     uint public endDate = 1525096800; // GMT/UTC: Monday, 30. April 2018 2pm 
78     
79     uint256 public constant maxSupply = 500000000 * 10**uint(decimals); // Max possible coins while crowdsale 500000000
80     uint256 public RATE = 50000; // 1 BRO = 0.00002 ETH --- 1 ETH = 50000 BRO 
81     
82     uint256 public constant pewdiepie = 5000000 * 10**uint(decimals); // 1% reserved for Pewdiepie 5000000
83     
84     address public owner;
85     
86     mapping(address => uint256) balances;
87     mapping(address => mapping(address => uint256)) allowed;
88     
89    
90     // Bonus     
91     function applyBonus(uint256 tokens) returns (uint256){
92         uint genesisDuration = now - startDate;
93         if (genesisDuration <= 168 hours) {   
94             tokens = (tokens.mul(150).div(100)); // First 7 days 50% Bonus
95         } 
96         else if (genesisDuration <= 336 hours) {  
97             tokens = (tokens.mul(130).div(100)); // First 14 days 30% Bonus
98         }  
99         else if (genesisDuration <= 504 hours) {  
100             tokens = (tokens.mul(120).div(100)); // First 21 days 20% Bonus
101         } 
102         else if (genesisDuration <= 672 hours) {  
103             tokens = (tokens.mul(110).div(100)); // First 28 days 10% Bonus
104         } 
105         else {
106             tokens = tokens;
107         }  
108         return tokens;
109     } 
110     function () payable {
111         createTokens();
112     }
113     
114     function BroFistCoin(){  
115         owner = msg.sender;  
116         balances[msg.sender] = pewdiepie;  
117         _totalSupply = _totalSupply.add(pewdiepie);
118     }  
119     function createTokens() payable{
120         require(msg.value > 0);  
121         require(now >= startDate && now <= endDate);  
122         require(_totalSupply < maxSupply);   
123           
124         uint256 tokens = msg.value.mul(RATE); 
125         tokens = applyBonus(tokens); 
126         balances[msg.sender] = balances[msg.sender].add(tokens);
127         _totalSupply = _totalSupply.add(tokens);
128         
129         owner.transfer(msg.value);
130     }
131     
132     function totalSupply() constant returns (uint256 totalSupply){
133         return _totalSupply;
134     }
135     
136     function balanceOf(address _owner) constant returns (uint256 balance){
137         return balances[_owner];  
138     }
139     
140     function transfer(address _to, uint256 _value) returns (bool success){
141         require(
142             balances[msg.sender] >= _value
143             && _value > 0
144         );
145         balances[msg.sender] = balances[msg.sender].sub(_value);
146         balances[_to] = balances[_to].add(_value);
147         Transfer(msg.sender, _to, _value);
148         return true;
149     }
150     
151     function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
152         require(
153             allowed[_from][msg.sender] >= _value
154             && balances[_from] >= _value
155             && _value > 0
156         );
157         balances[_from] = balances[_from].sub(_value);
158         balances[_to] = balances[_to].add(_value);
159         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
160         Transfer(_from, _to, _value);
161         return true;
162     }
163     
164     function approve(address _spender, uint256 _value) returns (bool success){
165         allowed[msg.sender][_spender] = _value;
166         Approval(msg.sender, _spender, _value);
167         return true;
168     }
169     
170     function allowance(address _owner, address _spender) constant returns (uint256 remaining){
171         return allowed[_owner][_spender];
172     }
173     
174     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
175     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
176     
177 }