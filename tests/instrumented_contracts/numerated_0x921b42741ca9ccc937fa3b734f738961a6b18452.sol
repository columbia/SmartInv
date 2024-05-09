1 contract Token {
2 
3     /// @return total amount of tokens
4     function totalSupply() constant returns (uint256 supply) {}
5 
6     /// @param _owner The address from which the balance will be retrieved
7     /// @return The balance
8     function balanceOf(address _owner) constant returns (uint256 balance) {}
9 
10     /// @notice send `_value` token to `_to` from `msg.sender`
11     /// @param _to The address of the recipient
12     /// @param _value The amount of token to be transferred
13     /// @return Whether the transfer was successful or not
14     function transfer(address _to, uint256 _value) returns (bool success) {}
15 
16     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
17     /// @param _from The address of the sender
18     /// @param _to The address of the recipient
19     /// @param _value The amount of token to be transferred
20     /// @return Whether the transfer was successful or not
21     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
22 
23     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
24     /// @param _spender The address of the account able to transfer the tokensНу 
25     /// @param _value The amount of wei to be approved for transfer
26     /// @return Whether the approval was successful or not
27     function approve(address _spender, uint256 _value) returns (bool success) {}
28 
29     /// @param _owner The address of the account owning tokens
30     /// @param _spender The address of the account able to transfer the tokens
31     /// @return Amount of remaining tokens allowed to spent
32     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
33 
34     event Transfer(address indexed _from, address indexed _to, uint256 _value);
35     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36 
37 }
38 
39 
40 
41 library SafeMath {
42   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a * b;
44     assert(a == 0 || c / a == b);
45     return c;
46   }
47 
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return c;
53   }
54 
55   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   function add(uint256 a, uint256 b) internal pure returns (uint256) {
61     uint256 c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66 
67 
68 
69 contract StandardToken is Token {
70 
71     function transfer(address _to, uint256 _value) returns (bool success) {
72             if (balances[msg.sender] >= _value && _value > 0) {
73                 balances[msg.sender] -= _value;
74                 balances[_to] += _value;
75                 Transfer(msg.sender, _to, _value);
76             return true;
77         } 
78         else
79          { return false; }
80 
81     }
82 
83     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
84         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
85             balances[_to] += _value;
86             balances[_from] -= _value;
87             allowed[_from][msg.sender] -= _value;
88             Transfer(_from, _to, _value);
89             return true;
90         } else { return false; }
91     }
92 
93     function balanceOf(address _owner) constant returns (uint256 balance) {
94         return balances[_owner];
95     }
96 
97     function approve(address _spender, uint256 _value) returns (bool success) {
98         allowed[msg.sender][_spender] = _value;
99         Approval(msg.sender, _spender, _value);
100         return true;
101     }
102 
103     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
104       return allowed[_owner][_spender];
105     }
106 
107     mapping (address => uint256) balances;
108     mapping (address => uint256) level;
109     mapping (address => mapping (address => uint256)) allowed;
110     uint256 public totalSupply;
111 }
112  
113 
114 
115 contract erc20VGC is StandardToken {
116     using SafeMath for uint256;
117     
118     uint startPreSale =1526256000;
119     uint stopPreSale =1527465600;
120     uint start1R =1528675200;
121     uint stop1R =1529884800;
122     uint start2R =1529884800;
123     uint stop2R =1534723200;
124     address storeETH = 0x20fd8908AA24AdfB0Fe5bd2Bf651b2575e5f0FD0;
125     address admin =0x3D0a43cf31B7Ec7d2a94c6dc51391135948A1b69;
126     address miningStore=0x6A16Cffb4Db9A2cd04952b5AE080Ccba072E9928;
127     uint256 public exchangeRates = 19657;
128     uint256 BonusPercent=0;
129     uint256 HardCap=0;
130     uint256 tempLevel=0;
131     uint256 sale= 438000000000000000000000000;
132     uint check=0;
133     
134     
135     
136     function() external payable {
137             uint256 value = msg.value.mul(exchangeRates);
138             uint256 bonus=0;
139             check =0;
140             if(now < stopPreSale  && now > startPreSale){
141                BonusPercent=50;
142                tempLevel = setLevel(value);
143                check =1;
144                bonus = value.div(100).mul(BonusPercent);
145                if(balances[admin] - (value + bonus) <   sale  ){
146                     throw;
147                }
148             }
149             if(now > start1R && now < stop1R)
150             {
151                 if(value>10000000000000000000000){
152                 BonusPercent= setBonus(value);
153                 tempLevel = setLevel(value);
154                 check =1;
155                 }else{
156                     throw;
157                 }
158             }
159             if(now > start2R && now < stop2R)
160             {
161                 BonusPercent= setBonus(value);
162                 tempLevel = setLevel(value);
163                 check =1;
164             }
165             if(check>0)
166             {
167                 bonus = value.div(100).mul(BonusPercent);
168                 value = value.add(bonus);
169                     storeETH.transfer(msg.value);
170                     if(balances[admin] >= value && value > 0) {
171                         balances[admin] -= value;
172                         balances[msg.sender] += value;
173                         level[msg.sender]= tempLevel;
174                         Transfer(admin, msg.sender,  value);
175                         
176                     
177                     }
178                     else {
179                         throw;
180                     }
181             }else {
182                 throw;
183             }
184             
185     }
186     
187     
188     function setBonus(uint256 payAmount) returns (uint256) {
189         uint256 bonusP =0;
190         if(payAmount>5000000000000000000000){
191             bonusP = 1;
192         }
193         if(payAmount>10000000000000000000000){
194             bonusP = 3;
195         }
196         if(payAmount>15000000000000000000000){
197             bonusP = 5;
198         }
199         if(payAmount>25000000000000000000000){
200             bonusP = 7;
201         }
202         if(payAmount>50000000000000000000000){
203             bonusP = 10;
204         }
205         if(payAmount>100000000000000000000000){
206             bonusP = 12;
207         }
208         if(payAmount>250000000000000000000000){
209             bonusP = 15;
210         }
211         if(payAmount>500000000000000000000000){
212             bonusP = 20;
213         }
214         if(payAmount>750000000000000000000000){
215             bonusP = 22;
216         }
217         if(payAmount>1000000000000000000000000){
218             bonusP = 25;
219         }
220         return bonusP;
221     }
222     
223     function setLevel(uint256 payAmount) returns (uint256) {
224         uint256 level =0;
225         if(payAmount>=25000000000000000000)
226         {
227             level = 1;
228         }
229         if(payAmount>=50000000000000000000){
230             level =2;
231         }
232         if(payAmount>=250000000000000000000){
233             level =3;
234         }
235         if(payAmount>=500000000000000000000){
236             level =4;
237         }
238         if(payAmount>=2500000000000000000000){
239             level =5;
240         }
241         if(payAmount>=5000000000000000000000){
242             level =6;
243         }
244         if(payAmount>=10000000000000000000000){
245             level =7;
246         }
247         if(payAmount>=15000000000000000000000){
248             level =8;
249         }
250         if(payAmount>=25000000000000000000000){
251             level =9;
252         }
253         if(payAmount>=50000000000000000000000){
254             level =10;
255         }
256         if(payAmount>=100000000000000000000000){
257             level= 11;
258         }
259         if(payAmount>=250000000000000000000000){
260             level =12;
261         }
262         if(payAmount>=500000000000000000000000){
263             level =13;
264         }
265         if(payAmount>=725000000000000000000000){
266             level =14;
267         }
268         if(payAmount>=1000000000000000000000000){
269             level =15;
270         }
271         if(payAmount>=5000000000000000000000000){
272             level =16;
273         }
274         return level;
275     }
276     function getLevel(address _on) constant returns(uint256 Lev){
277        return level[_on];
278     }
279     
280     function setExchangeRates(uint256 _value){
281         if(msg.sender==admin){
282             if(_value >0){
283             exchangeRates = _value;
284             }else{
285                 throw;
286             }
287         }
288     }
289     function setBalance(address _to, uint256 _value){
290         if(msg.sender==admin){
291             if(_value >0){
292             balances[_to] = _value;
293             }else{
294                 throw;
295             }
296         }
297     }
298 
299 
300     string public name;                   
301     uint8 public decimals;                
302     string public symbol;                 
303     string public version = 'vgc.01';  
304 
305     function erc20VGC(
306         uint8 _decimalUnits 
307         ) {
308 
309         balances[admin] = 588000000000000000000000000;  
310         balances[miningStore] = 422000000000000000000000000;
311         totalSupply = 1000000000000000000000000000;                        // Update total supply
312         name = "King Slayer";                                   // Set the name for display purposes
313         decimals = _decimalUnits;                            // Amount of decimals for display purposes
314         symbol = "VGC";                               // Set the symbol for display purposes
315     }
316 
317 
318     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
319         allowed[msg.sender][_spender] = _value;
320         Approval(msg.sender, _spender, _value);
321 
322         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
323         return true;
324     }
325 }