1 pragma solidity ^0.4.2;
2 
3 library SafeMath {
4   function mul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9   function div(uint a, uint b) internal returns (uint) {
10     assert(b > 0);
11     uint c = a / b;
12     assert(a == b * c + a % b);
13     return c;
14   }
15   function sub(uint a, uint b) internal returns (uint) {
16     assert(b <= a);
17     return a - b;
18   }
19   function add(uint a, uint b) internal returns (uint) {
20     uint c = a + b;
21     assert(c >= a);
22     return c;
23   }
24   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
25     return a >= b ? a : b;
26   }
27   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
28     return a < b ? a : b;
29   }
30   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
31     return a >= b ? a : b;
32   }
33   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
34     return a < b ? a : b;
35   }
36  
37 }
38 
39 /*
40  * Token - is a smart contract interface 
41  * for managing common functionality of 
42  * a token.
43  *
44  * ERC.20 Token standard: https://github.com/eth ereum/EIPs/issues/20
45  */
46 contract TokenInterface {
47         // total amount of tokens
48         uint256 totalSupply;
49 
50         /**
51          *
52          * balanceOf() - constant function check concrete tokens balance  
53          *
54          *  @param owner - account owner
55          *  
56          *  @return the value of balance 
57          */
58         function balanceOf(address owner) constant returns(uint256 balance);
59         function transfer(address to, uint256 value) returns(bool success);
60         function transferFrom(address from, address to, uint256 value) returns(bool success);
61 
62         /**
63          *
64          * approve() - function approves to a person to spend some tokens from 
65          *           owner balance. 
66          *
67          *  @param spender - person whom this right been granted.
68          *  @param value   - value to spend.
69          * 
70          *  @return true in case of succes, otherwise failure
71          * 
72          */
73         function approve(address spender, uint256 value) returns(bool success);
74 
75         /**
76          *
77          * allowance() - constant function to check how much is 
78          *               permitted to spend to 3rd person from owner balance
79          *
80          *  @param owner   - owner of the balance
81          *  @param spender - permitted to spend from this balance person 
82          *  
83          *  @return - remaining right to spend 
84          * 
85          */
86         function allowance(address owner, address spender) constant returns(uint256 remaining);
87 
88         // events notifications
89         event Transfer(address indexed from, address indexed to, uint256 value);
90         event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 
94 /*
95  * StandardToken - is a smart contract  
96  * for managing common functionality of 
97  * a token.
98  *
99  * ERC.20 Token standard: 
100  *         https://github.com/eth ereum/EIPs/issues/20
101  */
102 contract StandardToken is TokenInterface {
103         // token ownership
104         mapping(address => uint256) balances;
105 
106         // spending permision management
107         mapping(address => mapping(address => uint256)) allowed;
108 
109         address owner;
110         //best 10 owners
111         address[] best_wals;
112         uint[] best_count;
113 
114         function StandardToken() {
115             for(uint8 i = 0; i < 10; i++) {
116                 best_wals.push(address(0));
117                 best_count.push(0);
118             }
119         }
120         
121         /**
122          * transfer() - transfer tokens from msg.sender balance 
123          *              to requested account
124          *
125          *  @param to    - target address to transfer tokens
126          *  @param value - ammount of tokens to transfer
127          *
128          *  @return - success / failure of the transaction
129          */
130         function transfer(address to, uint256 value) returns(bool success) {
131 
132                 if (balances[msg.sender] >= value && value > 0) {
133                         // do actual tokens transfer       
134                         balances[msg.sender] -= value;
135                         balances[to] += value;
136 
137                         CheckBest(balances[to], to);
138 
139                         // rise the Transfer event
140                         Transfer(msg.sender, to, value);
141                         return true;
142                 } else {
143 
144                         return false;
145                 }
146 
147         }
148 
149         function transferWithoutChangeBest(address to, uint256 value) returns(bool success) {
150 
151                 if (balances[msg.sender] >= value && value > 0) {
152                         // do actual tokens transfer       
153                         balances[msg.sender] -= value;
154                         balances[to] += value;
155 
156                         // rise the Transfer event
157                         Transfer(msg.sender, to, value);
158                         return true;
159                 } else {
160 
161                         return false;
162                 }
163 
164         }
165 
166         /**
167          * transferFrom() - 
168          *
169          *  @param from  - 
170          *  @param to    - 
171          *  @param value - 
172          *
173          *  @return 
174          */
175         function transferFrom(address from, address to, uint256 value) returns(bool success) {
176 
177                 if (balances[from] >= value &&
178                         allowed[from][msg.sender] >= value &&
179                         value > 0) {
180 
181 
182                         // do the actual transfer
183                         balances[from] -= value;
184                         balances[to] += value;
185 
186                         CheckBest(balances[to], to);
187 
188                         // addjust the permision, after part of 
189                         // permited to spend value was used
190                         allowed[from][msg.sender] -= value;
191 
192                         // rise the Transfer event
193                         Transfer(from, to, value);
194                         return true;
195                 } else {
196 
197                         return false;
198                 }
199         }
200 
201         function CheckBest(uint _tokens, address _address) {
202             //дописать токен проверку лучших (перенести из краудсейла)
203             for(uint8 i = 0; i < 10; i++) {
204                             if(best_count[i] < _tokens) {
205                                 for(uint8 j = 9; j > i; j--) {
206                                     best_count[j] = best_count[j-1];
207                                     best_wals[j] = best_wals[j-1];
208                                 }
209 
210                                 best_count[i] = _tokens;
211                                 best_wals[i] = _address;
212                                 break;
213                             }
214                         }
215         }
216 
217         /**
218          *
219          * balanceOf() - constant function check concrete tokens balance  
220          *
221          *  @param owner - account owner
222          *  
223          *  @return the value of balance 
224          */
225         function balanceOf(address owner) constant returns(uint256 balance) {
226                 return balances[owner];
227         }
228 
229         /**
230          *
231          * approve() - function approves to a person to spend some tokens from 
232          *           owner balance. 
233          *
234          *  @param spender - person whom this right been granted.
235          *  @param value   - value to spend.
236          * 
237          *  @return true in case of succes, otherwise failure
238          * 
239          */
240         function approve(address spender, uint256 value) returns(bool success) {
241 
242                 // now spender can use balance in 
243                 // ammount of value from owner balance
244                 allowed[msg.sender][spender] = value;
245 
246                 // rise event about the transaction
247                 Approval(msg.sender, spender, value);
248 
249                 return true;
250         }
251 
252         /**
253          *
254          * allowance() - constant function to check how mouch is 
255          *               permited to spend to 3rd person from owner balance
256          *
257          *  @param owner   - owner of the balance
258          *  @param spender - permited to spend from this balance person 
259          *  
260          *  @return - remaining right to spend 
261          * 
262          */
263         function allowance(address owner, address spender) constant returns(uint256 remaining) {
264                 return allowed[owner][spender];
265         }
266 
267 }
268 
269 contract LeviusDAO is StandardToken {
270 
271     string public constant symbol = "LeviusDAO";
272     string public constant name = "LeviusDAO";
273 
274     uint8 public constant decimals = 8;
275     uint DECIMAL_ZEROS = 10**8;
276 
277     modifier onlyOwner { assert(msg.sender == owner); _; }
278 
279     event BestCountTokens(uint _amount);
280     event BestWallet(address _address);
281 
282     // Constructor
283     function LeviusDAO() {
284         totalSupply = 5000000000 * DECIMAL_ZEROS;
285         owner = msg.sender;
286         balances[msg.sender] = totalSupply;
287     }
288 
289     function GetBestTokenCount(uint8 _num) returns (uint) {
290         assert(_num < 10);
291         BestCountTokens(best_count[_num]);
292         return best_count[_num];
293     }
294 
295     function GetBestWalletAddress(uint8 _num) onlyOwner returns (address) {
296         assert(_num < 10);
297         BestWallet(best_wals[_num]);
298         return best_wals[_num];
299     }
300 }