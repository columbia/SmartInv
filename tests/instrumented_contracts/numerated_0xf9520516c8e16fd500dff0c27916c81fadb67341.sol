1 /**
2  *Submitted for verification at Etherscan.io on 2019-08-16
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2019-08-14
7 */
8 
9 pragma solidity ^0.4.26;
10     
11     library SafeMath {
12     /**
13      * @dev Multiplies two unsigned integers, reverts on overflow.
14      */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
17         // benefit is lost if 'b' is also tested.
18         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19         if (a == 0) {
20             return 0;
21         }
22   
23         uint256 c = a * b;
24         require(c / a == b);
25  
26         return c;
27     }
28  
29     /**
30      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
31      */
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         // Solidity only automatically asserts when dividing by 0
34         require(b > 0);
35         uint256 c = a / b;
36         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37  
38         return c;
39     }
40  
41     /**
42      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a);
46         uint256 c = a - b;
47  
48         return c;
49     }
50  
51     /**
52      * @dev Adds two unsigned integers, reverts on overflow.
53      */
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         require(c >= a);
57  
58         return c;
59     }
60  
61     /**
62      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
63      * reverts when dividing by zero.
64      */
65     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
66         require(b != 0);
67         return a % b;
68     }
69 }
70 
71  
72     contract token {
73        
74      
75             string public name;
76             string public symbol;
77             uint256 public decimals = 8;  
78             uint256 public _totalSupply; 
79             uint256 public startTime=1567958400;
80  
81         function totalSupply() constant returns (uint256 supply) {
82             return _totalSupply;
83         }
84  
85         function changeStartTime(uint256 _startTime) returns (bool success) {
86             require(msg.sender==founder);
87             startTime=_startTime;
88             return true;
89         }
90  
91         function approve(address _spender, uint256 _value) returns (bool success) {
92             allowed[msg.sender][_spender] = _value;
93             Approval(msg.sender, _spender, _value);
94             return true;
95         }
96         
97  
98         function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
99           return allowed[_owner][_spender];
100         }
101  
102         mapping(address => uint256) public  balanceOf;         
103         mapping(address => uint256) public distBalances;
104         
105         mapping(address => bool) public distTeam;
106         
107            
108         mapping(address => bool) public lockAddrs;           
109         mapping(address => mapping (address => uint256)) allowed;
110  
111  
112         address public founder;
113         uint256 public distributed = 0;
114  
115         event AllocateFounderTokens(address indexed sender);
116         event Transfer(address indexed _from, address indexed _to, uint256 _value);
117         event Approval(address indexed _owner, address indexed _spender, uint256 _value);
118       
119  
120     function token(uint256 initialSupply, string tokenName, string tokenSymbol) public {
121         founder = msg.sender;
122         _totalSupply = initialSupply * 10 ** uint256(decimals); 
123         name = tokenName;
124         symbol = tokenSymbol;
125         balanceOf[msg.sender]=_totalSupply;
126     }
127  
128 
129         
130      
131         function lockAddr(address user) returns (bool success) {
132             if (msg.sender != founder) revert();
133             lockAddrs[user]=true;
134             return true;
135         }
136         
137       
138         function unLockAddr(address user) returns (bool success) {
139             if (msg.sender != founder) revert();
140             lockAddrs[user]=false;
141             return true;
142         }
143  
144 
145         function distribute(uint256 _amount, address[] _to,bool isteam) {
146             if (msg.sender!=founder) revert();
147             if (SafeMath.add(distributed,SafeMath.mul(_to.length,_amount)) > _totalSupply) revert();
148             
149             for(uint j=0;j<_to.length;j++){
150                 if(distBalances[_to[j]]>0) revert();
151             }
152             
153             for(uint i=0;i<_to.length;i++){
154                 distributed= SafeMath.add(distributed, _amount);
155                 distBalances[_to[i]] =SafeMath.add(distBalances[_to[i]], _amount);
156                 if(isteam){
157                     distTeam[_to[i]]=true;
158                 }
159                 transfer(_to[i],_amount);
160              }
161            
162         }
163         
164         function transfer(address _to, uint256 _value) public {
165  
166             require(lockAddrs[msg.sender]==false);
167             require(balanceOf[msg.sender] >= _value);
168             require(SafeMath.add(balanceOf[_to],_value) > balanceOf[_to]);
169           
170             uint _freeAmount = freeAmount(msg.sender);
171             require (_freeAmount > _value);
172 
173             balanceOf[msg.sender]=SafeMath.sub(balanceOf[msg.sender], _value);
174             balanceOf[_to]=SafeMath.add(balanceOf[_to], _value);
175             Transfer(msg.sender, _to, _value);
176         }
177         
178     
179        
180         function freeAmount(address user) constant  returns (uint256 amount) {
181           
182             if (user == founder) {
183                 return balanceOf[user];
184             }
185             uint monthDiff;
186             bool isteam;
187             if(distTeam[user]){
188                 isteam=true;
189             }
190             if(startTime<now){
191                if(isteam){
192                      monthDiff= (now-startTime) / 90 days;
193                     if(monthDiff==0){
194                         return  balanceOf[user]-distBalances[user];
195                     }else if(monthDiff>0 && monthDiff<12){
196                         return  distBalances[user]/12*monthDiff+balanceOf[user]-distBalances[user];
197                     }else{
198                         return distBalances[user]+balanceOf[user]-distBalances[user];
199                     }
200                }else{
201                     uint256 direct=distBalances[user]/10;
202                      monthDiff= (now-startTime) /30 days;
203                     if(monthDiff==0){
204                         return  direct+balanceOf[user]-distBalances[user];
205                     }else if(monthDiff>0 && monthDiff<4){
206                         return  direct+(distBalances[user]-direct)/4*monthDiff+balanceOf[user]-distBalances[user];
207                     }else{
208                         return distBalances[user]+balanceOf[user]-distBalances[user];
209                     }
210                }
211             }else{
212                 return balanceOf[user]-distBalances[user];
213             }
214         }
215  
216         
217        function unLockAmount(address user) constant returns (uint256 amount) {
218  
219             uint monthDiff;
220             bool isteam;
221             if(distTeam[user]){
222                 isteam=true;
223             }
224             if(startTime<now){
225                 if(isteam){
226                         monthDiff= (now-startTime) / 90 days;
227                         if(monthDiff==0){
228                             return  0;
229                         }else if(monthDiff>0 && monthDiff<12){
230                             return  distBalances[user]/12*monthDiff;
231                         }else{
232                             return distBalances[user];
233                         }
234                 }else{
235                         uint256 direct=distBalances[user]/10;
236                         monthDiff= (now-startTime)/30 days;
237                         if(monthDiff==0){
238                             return  direct;
239                         }else if(monthDiff>0 && monthDiff<4){
240                             return  direct+(distBalances[user]-direct)/4*monthDiff;
241                         }else{
242                             return distBalances[user];
243                         }
244                 }
245             }else{
246                 return 0;
247             }
248         }
249  
250 
251         function changeFounder(address newFounder) {
252             if (msg.sender!=founder) revert();
253             founder = newFounder; 
254         }
255  
256    
257         function transferFrom(address _from, address _to, uint256 _value) {
258          
259             require(lockAddrs[_from]==false);
260             require(balanceOf[_from] >= _value);
261             require(allowed[_from][msg.sender] >= _value);
262             require(balanceOf[_to] + _value > balanceOf[_to]);
263           
264             uint _freeAmount = freeAmount(_from);
265             require (_freeAmount > _value);
266             
267             balanceOf[_to]=SafeMath.add(balanceOf[_to],_value);
268             balanceOf[_from]=SafeMath.sub(balanceOf[_from],_value);
269             allowed[_from][msg.sender]=SafeMath.sub(allowed[_from][msg.sender], _value);
270             Transfer(_from, _to, _value);
271 
272         }
273  
274         function() payable {
275             if (!founder.call.value(msg.value)()) revert(); 
276         }
277     }