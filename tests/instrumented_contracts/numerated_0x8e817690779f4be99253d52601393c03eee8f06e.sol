1 /**
2  * Overflow aware uint math functions.
3  *
4  * Inspired by https://github.com/MakerDAO/maker-otc/blob/master/contracts/simple_market.sol
5  */
6 contract SafeMath {
7   //internals
8 
9   function safeMul(uint a, uint b) internal returns (uint) {
10     uint c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function safeSub(uint a, uint b) internal returns (uint) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function safeAdd(uint a, uint b) internal returns (uint) {
21     uint c = a + b;
22     assert(c>=a && c>=b);
23     return c;
24   }
25 
26   function assert(bool assertion) internal {
27     if (!assertion) throw;
28   }
29 }
30 
31 /**
32  * ERC 20 token
33  *
34  * https://github.com/ethereum/EIPs/issues/20
35  */
36 contract Token {
37 
38     /// @return total amount of tokens
39     function totalSupply() constant returns (uint256 supply) {}
40 
41     /// @param _owner The address from which the balance will be retrieved
42     /// @return The balance
43     function balanceOf(address _owner) constant returns (uint256 balance) {}
44 
45     /// @notice send `_value` token to `_to` from `msg.sender`
46     /// @param _to The address of the recipient
47     /// @param _value The amount of token to be transferred
48     /// @return Whether the transfer was successful or not
49     function transfer(address _to, uint256 _value) returns (bool success) {}
50 
51     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
52     /// @param _from The address of the sender
53     /// @param _to The address of the recipient
54     /// @param _value The amount of token to be transferred
55     /// @return Whether the transfer was successful or not
56     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
57 
58     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
59     /// @param _spender The address of the account able to transfer the tokens
60     /// @param _value The amount of wei to be approved for transfer
61     /// @return Whether the approval was successful or not
62     function approve(address _spender, uint256 _value) returns (bool success) {}
63 
64     /// @param _owner The address of the account owning tokens
65     /// @param _spender The address of the account able to transfer the tokens
66     /// @return Amount of remaining tokens allowed to spent
67     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
68 
69     event Transfer(address indexed _from, address indexed _to, uint256 _value);
70     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
71 
72 }
73 
74 /**
75  * ERC 20 token
76  *
77  * https://github.com/ethereum/EIPs/issues/20
78  */
79 contract StandardToken is Token {
80 
81     /**
82      * Reviewed:
83      * - Interger overflow = OK, checked
84      */
85     function transfer(address _to, uint256 _value) returns (bool success) {
86         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
87             balances[msg.sender] -= _value;
88             balances[_to] += _value;
89             Transfer(msg.sender, _to, _value);
90             return true;
91         } else { return false; }
92     }
93 
94     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
95         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
96             balances[_to] += _value;
97             balances[_from] -= _value;
98             allowed[_from][msg.sender] -= _value;
99             Transfer(_from, _to, _value);
100             return true;
101         } else { return false; }
102     }
103 
104     function balanceOf(address _owner) constant returns (uint256 balance) {
105         return balances[_owner];
106     }
107 
108     function approve(address _spender, uint256 _value) returns (bool success) {
109         allowed[msg.sender][_spender] = _value;
110         Approval(msg.sender, _spender, _value);
111         return true;
112     }
113 
114     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
115       return allowed[_owner][_spender];
116     }
117 
118     mapping(address => uint256) balances;
119 
120     mapping (address => mapping (address => uint256)) allowed;
121 
122     uint256 public totalSupply;
123 
124 }
125 
126 
127 /**
128  * CTest1 crowdsale contract.
129  *
130  * Security criteria evaluated against http://ethereum.stackexchange.com/questions/8551/methodological-security-review-of-a-smart-contract
131  *
132  *
133  */
134 contract CTest1 is StandardToken, SafeMath {
135 
136     string public name = "CTest1 Token";
137     string public symbol = "CTest1";
138     uint public decimals = 18;
139     
140     uint256 public totalSupply = 1000000;
141 
142 
143     // Set the contract controller address
144     // Set the 3 Founder addresses
145     address public owner = msg.sender;
146     address public Founder1 = 0xB5D39A8Ea30005f9114Bf936025De2D6f353813E;
147     address public Founder2 = 0x00A591199F53907480E1f5A00958b93B43200Fe4;
148     address public Founder3 = 0x0d19C131400e73c71bBB2bC1666dBa8Fe22d242D;
149 
150 
151     event Buy(address indexed sender, uint eth, uint fbt);
152 
153 
154     /**
155      * ERC 20 Standard Token interface transfer function
156      */
157     function transfer(address _to, uint256 _value) returns (bool success) {
158         return super.transfer(_to, _value);
159     }
160     /**
161      * ERC 20 Standard Token interface transfer function
162      *
163      */
164     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
165         return super.transferFrom(_from, _to, _value);
166     }
167     
168     
169    
170 // CTest1 TOKEN FOUNDER ETH ADDRESSES 
171 // 0xB5D39A8Ea30005f9114Bf936025De2D6f353813E
172 // 0x00A591199F53907480E1f5A00958b93B43200Fe4
173 // 0x0d19C131400e73c71bBB2bC1666dBa8Fe22d242D
174     
175     
176     function () payable {
177         
178         
179         //If all the tokens are gone, stop!
180         if (totalSupply < 1)
181         {
182             throw;
183         }
184         
185         
186         uint256 rate = 0;
187         address recipient = msg.sender;
188         
189         
190         //Set the price to 0.0003 ETH/CTest1
191         //$0.10 per
192         if (totalSupply > 975000)
193         {
194             rate = 3340;
195         }
196         
197         //Set the price to 0.0015 ETH/CTest1
198         //$0.50 per
199         if (totalSupply < 975001)
200         {
201             rate = 668;
202         }
203         
204         //Set the price to 0.0030 ETH/CTest1
205         //$1.00 per
206         if (totalSupply < 875001)
207         {
208             rate = 334;
209         }
210         
211         //Set the price to 0.0075 ETH/CTest1
212         //$2.50 per
213         if (totalSupply < 475001)
214         {
215             rate = 134;
216         }
217         
218         
219        
220 
221         
222         uint256 tokens = safeMul(msg.value, rate);
223         tokens = tokens/1 ether;
224         
225         
226         //Make sure they send enough to buy atleast 1 token.
227         if (tokens < 1)
228         {
229             throw;
230         }
231         
232         
233         //Make sure someone isn't buying more than the remaining supply
234         uint256 check = safeSub(totalSupply, tokens);
235         if (check < 0)
236         {
237             throw;
238         }
239         
240         
241         //Make sure someone isn't buying more than the current tier
242         if (totalSupply > 975000 && check < 975000)
243         {
244             throw;
245         }
246         
247         //Make sure someone isn't buying more than the current tier
248         if (totalSupply > 875000 && check < 875000)
249         {
250             throw;
251         }
252         
253         //Make sure someone isn't buying more than the current tier
254         if (totalSupply > 475000 && check < 475000)
255         {
256             throw;
257         }
258         
259         
260         //Prevent any ETH address from buying more than 50 CTest1 during the pre-sale
261         if ((balances[recipient] + tokens) > 50 && totalSupply > 975000)
262         {
263             throw;
264         }
265         
266         
267         balances[recipient] = safeAdd(balances[recipient], tokens);
268         
269         totalSupply = safeSub(totalSupply, tokens);
270 
271     
272 	    Founder1.transfer((msg.value/3));					//Send the ETH
273 	    Founder2.transfer((msg.value/3));					//Send the ETH
274 	    Founder3.transfer((msg.value/3));					//Send the ETH
275 
276         Buy(recipient, msg.value, tokens);
277         
278     }
279     
280     
281     
282     //Burn all remaining tokens.
283     //Only contract creator can do this.
284     function Burn () {
285         
286         if (msg.sender == owner && totalSupply > 0)
287         {
288             totalSupply = 0;
289         } else {throw;}
290 
291     }
292     
293     
294 
295 }