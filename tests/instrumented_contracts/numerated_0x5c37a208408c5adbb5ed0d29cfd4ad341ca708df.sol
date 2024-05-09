1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 
28   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
29     return a >= b ? a : b;
30   }
31 
32   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a < b ? a : b;
34   }
35 
36   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
37     return a >= b ? a : b;
38   }
39 
40   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a < b ? a : b;
42   }
43 
44 }
45 
46 // Interfacting Deployed Nertia Token 
47 contract KairosToken{
48   function getExchangeRate() returns (uint256 exchangeRate);
49   function balanceOf(address _owner) constant returns (uint256 balance);
50   function getOwner() returns (address owner);
51   function getDecimals() returns (uint256 decimals);
52   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
53 }
54 
55 
56 /**
57  * ICO contract for the Nertia Token
58  */
59 contract Crowdsale {
60 
61   using SafeMath for uint256;
62 
63   address public ethOwner;
64   address public kairosOwner;
65 
66   KairosToken public token;
67 
68   mapping(address => uint256) etherBlance;
69 
70   uint256 public decimals;
71   uint256 public icoMinCap;
72     
73   bool public isFinalized;
74   uint256 public icoStartBlock;
75   uint256 public icoEndBlock;
76   uint256 public icoStartTime;
77   uint256 public totalSupply;
78   uint256 public exchangeRate;
79 
80   event Refund(address indexed _to, uint256 _value);
81   event RefundError(address indexed _to, uint256 _value);
82     
83   function Crowdsale() {
84     token          = KairosToken(0xa6C9e4D4B34D432d4aea793Fa8C380b9940a5279);
85     decimals       = token.getDecimals();
86     exchangeRate   = 20;
87     isFinalized    = false;
88     icoStartTime   = now;
89     icoStartBlock  = block.number.add(15247);
90     icoEndBlock    = icoStartBlock.add(152470);
91     ethOwner       = 0x0fe777FA444Fae128169754877d51b665eE557Ee;
92     kairosOwner    = 0xa6C9e4D4B34D432d4aea793Fa8C380b9940a5279;
93     icoMinCap      = 15 * (10**6) * 10**decimals;
94   }
95 
96 
97   /// @dev Ends the funding period and sends the ETH home
98   function finalize() external {
99     if(isFinalized) throw;
100     if(msg.sender != ethOwner) throw; // locks finalize to the ultimate ETH owner
101     //if(totalSupply < icoMinCap) throw;      // have to sell minimum to move to operational
102     if(block.number <= icoEndBlock) throw;
103     
104     // move to operational
105     isFinalized = true;
106     if(!ethOwner.send(this.balance)) throw;  // send the eth to Nertia Owner
107   }
108 
109 
110   function refund(){
111     if(isFinalized) throw;
112     if(block.number <= icoEndBlock) throw;
113     if(msg.sender == token.getOwner() ) throw;
114 
115     uint256 userBalance = token.balanceOf(msg.sender);
116     if(userBalance == 0) throw;
117 
118     uint256 userEthers = etherBlance[msg.sender];
119     if(userEthers == 0) throw;    
120     
121     etherBlance[msg.sender] = 0;
122     
123     if(!token.transferFrom(msg.sender,kairosOwner, userBalance)) throw;
124 
125     if(msg.sender.send(userEthers)){
126       Refund(msg.sender, userEthers);
127     }else{
128       etherBlance[msg.sender] = userEthers;
129       RefundError(msg.sender, userEthers);
130       throw;
131     }
132   }
133 
134 
135   function () payable {
136     if(isFinalized && msg.value <= 0) throw;
137 
138     if(block.number < icoStartBlock) throw;
139     if(block.number > icoEndBlock) throw;
140 
141     // storing user ethers;
142     etherBlance[msg.sender] += msg.value;
143 
144     // calculating bonus
145     uint256 val = msg.value;
146     uint256 bonus  =  calcBonus(val);
147     uint256 level2bonus = calcLevel2Bonus(val);
148     uint256 tokens = msg.value.add(level2bonus).add(bonus).mul(exchangeRate);    
149     uint256 checkedSupply = totalSupply.add(tokens);
150     totalSupply = checkedSupply;
151     bool transfer = token.transferFrom( token.getOwner(),msg.sender, tokens);
152     if(!transfer){
153         totalSupply = totalSupply.sub(tokens);
154         throw;
155     }
156   }
157   
158   // Calculating bounus tokens
159   function calcBonus(uint256 _val) private constant returns (uint256){
160     return _val.div(100).mul(getPercentage());            
161   }  
162 
163   // Calculating bonus percentage 
164   function getPercentage() private constant returns (uint){
165     uint duration = now.sub(icoStartTime);
166     if(duration > 21 days){
167       return 0;
168     } else if(duration <= 21 days && duration > 14 days){
169       return 1;
170     } else if(duration <= 14 days && duration > 7 days){
171       return 3;
172     } else {
173       return 5;
174     }
175   }
176 
177   function calcLevel2Bonus(uint256 _val) private constant returns(uint256) {
178     return _val.div(100).mul(level2Bonus(_val));
179   }
180 
181   // calculating 2nd level bonus
182   function level2Bonus(uint256 tokens) private constant returns(uint256) {
183       if(tokens > 1000000){
184         return 5;   
185       }else if(tokens <= 999999 && tokens >= 100000){
186         return 3;
187       }else if(tokens <= 99999 && tokens >= 50000 ){
188         return 2;
189       }else if( tokens <= 49999 && tokens >= 10000){
190         return 1;
191       }
192       return 0;
193   }
194 
195 
196 }