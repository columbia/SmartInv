1 pragma solidity ^0.4.15;
2 /* @file
3  * @title BTRCTOKEN
4  * @version 1.2.0
5 */
6 contract BTRCTOKEN {
7   
8   string public constant symbol = "BTRC";
9   string public constant name = "BİTUBER";
10   
11   uint8 public constant decimals = 18;
12   
13   uint256 public constant _maxSupply = 33000000000000000000000000; 
14   uint256 public _totalSupply = 0;
15   uint256 private price = 2400;
16   
17   bool public workingState = true;
18   bool public transferAllowed = true;
19   bool private generationState = true;
20   
21   address private owner;
22   address private cur_coin;
23   
24   mapping (address => uint256) balances;
25   mapping (address => mapping (address => uint256)) allowed;
26   mapping (address => uint256) private etherClients;
27 
28   event FundsGot(address indexed _sender, uint256 _value);
29   event Transfer(address indexed _from, address indexed _to, uint256 _value);
30   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
31   
32   event TokenGenerationEnabled();
33   event TokenGenerationDisabled();
34   
35   event ContractEnabled();
36   event ContractDisabled();
37   event TransferEnabled();
38   
39   event TransferDisabled();
40   event CurrentCoin(address coin);
41   event Refund(address client, uint256 amount, uint256 tokens);
42   event TokensSent(address client, uint256 amount);
43   event PaymentGot(bool result);
44   
45   modifier onlyOwner {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   modifier ownerAndCoin {
51     require((msg.sender == owner)||(msg.sender == cur_coin));
52     _;
53   }
54 
55   modifier producibleFlag {
56     require((generationState == true)&&(_totalSupply<_maxSupply));
57     _;
58   }
59 
60   modifier workingFlag {
61     require(workingState == true);
62     _;
63   }
64 
65 
66   modifier transferFlag {
67     require(transferAllowed == true);
68     _;
69   }
70 
71   function BTRCTOKEN() public payable {
72     owner = msg.sender;
73     enableContract();
74   }
75 
76 
77   function refund(address _client, uint256 _amount, uint256 _tokens) public workingFlag ownerAndCoin {
78     balances[_client] -= _tokens;
79     balances[address(this)] += _tokens;
80     _client.transfer(_amount);
81     Refund(_client, _amount, _tokens);
82   }
83 
84 
85   function kill() public onlyOwner {
86     require(workingState == false);
87     selfdestruct(owner);
88   }
89 
90 
91   function setCurrentCoin(address current) public onlyOwner workingFlag {
92     cur_coin = current;
93     CurrentCoin(cur_coin);
94   }
95 
96   //work controller functions
97   function enableContract() public onlyOwner {
98     workingState = true;
99     ContractEnabled();
100   }
101 
102 
103   function disableContract() public onlyOwner {
104     workingState = false;
105     ContractDisabled();
106   }
107 
108 
109   function contractState() public view returns (string state) {
110     if (workingState) {
111       state = "Working";
112     }
113     else {
114       state = "Stopped";
115     }
116   }
117 
118 
119   function enableGeneration() public onlyOwner {
120     if(_totalSupply<_maxSupply) {
121 		generationState = true;
122 		TokenGenerationEnabled();
123 	} else {
124 		generationState = false;
125 	}
126   }
127 
128   function disableGeneration() public onlyOwner {
129     generationState = false;
130     TokenGenerationDisabled();
131   }
132 
133   function tokenGenerationState() public view returns (string state) {
134     if (generationState) {
135       state = "Working";
136     }
137     else {
138       state = "Stopped";
139     }
140   }
141   
142   
143   //transfer controller functions
144   function enableTransfer() public onlyOwner {
145     transferAllowed = true;
146     TransferEnabled();
147   }
148   function disableTransfer() public onlyOwner {
149     transferAllowed = false;
150     TransferDisabled();
151   }
152   function transferState() public view returns (string state) {
153     if (transferAllowed) {
154       state = "Working";
155     }
156     else {
157       state = "Stopped";
158     }
159   }
160   
161 
162   //token controller functions
163   function generateTokens(address _client, uint256 _amount) public ownerAndCoin workingFlag producibleFlag {
164 	
165 	if(_totalSupply<=_maxSupply) {
166 	
167 		if(_totalSupply+_amount>_maxSupply) {
168 			_amount = (_totalSupply+_amount)-_maxSupply;
169 		}
170 		
171 		if (_client == address(this))
172 		{
173 			balances[address(this)] += _amount;
174 			_totalSupply += _amount;
175 		}
176 		else
177 		{
178 		  if (balances[address(this)] >= _amount)
179 		  {
180 			transferFrom(address(this), _client, _amount);
181 		  }
182 		  else
183 		  {
184 			uint256 de = _amount - balances[address(this)];
185 			transferFrom(address(this), _client, balances[address(this)]);
186 			_totalSupply += de;
187 			balances[_client] += de;
188 		  }
189 		}
190 		
191 		TokensSent(_client, _amount);
192 		
193 		if(_totalSupply>=_maxSupply) {
194 			generationState = false;
195 			TokenGenerationDisabled();
196 		}	
197 	
198 	} else {
199 		
200 			generationState = false;
201 			TokenGenerationDisabled();
202 		
203 	}
204 	
205 	
206   }
207   function setPrice(uint256 _price) public onlyOwner {
208     price = _price;
209   }
210   function getPrice() public view returns (uint256 _price) {
211     _price = price;
212   }
213   //send ether function (working)
214   function () public workingFlag payable {
215     bool ret = false;
216     if (generationState) {
217        ret = cur_coin.call(bytes4(keccak256("pay(address,uint256,uint256)")), msg.sender, msg.value, price);
218     }
219     PaymentGot(ret);
220   }
221   function totalSupply() public constant workingFlag returns (uint256 totalsupply) {
222 	totalsupply = _totalSupply;
223   }
224   //ERC20 Interface
225   function balanceOf(address _owner) public constant workingFlag returns (uint256 balance) {
226     return balances[_owner];
227   }
228   function transfer(address _to, uint256 _value) public workingFlag returns (bool success) {
229     if (balances[msg.sender] >= _value
230       && _value > 0
231       && balances[_to] + _value > balances[_to])
232       {
233         if ((msg.sender == address(this))||(_to == address(this))) {
234           balances[msg.sender] -= _value;
235           balances[_to] += _value;
236           Transfer(msg.sender, _to, _value);
237           return true;
238         }
239         else {
240           if (transferAllowed == true) {
241             balances[msg.sender] -= _value;
242             balances[_to] += _value;
243             Transfer(msg.sender, _to, _value);
244             return true;
245           }
246           else {
247             return false;
248           }
249         }
250       }
251       else {
252         return false;
253       }
254   }
255   function transferFrom(address _from, address _to, uint256 _value) public workingFlag returns (bool success) {
256     if ((msg.sender == cur_coin)||(msg.sender == owner)) {
257       allowed[_from][_to] = _value;
258     }
259     if (balances[_from] >= _value
260       && allowed[_from][_to] >= _value
261       && _value > 0
262       && balances[_to] + _value > balances[_to])
263       {
264         if ((_from == address(this))||(_to == address(this))) {
265           balances[_from] -= _value;
266           allowed[_from][_to] -= _value;
267           balances[_to] += _value;
268           Transfer(_from, _to, _value);
269           return true;
270         }
271         else {
272           if (transferAllowed == true) {
273             balances[_from] -= _value;
274             allowed[_from][_to] -= _value;
275             balances[_to] += _value;
276             Transfer(_from, _to, _value);
277             return true;
278           }
279           else {
280             return false;
281           }
282         }
283       }
284       else {
285         return false;
286       }
287   }
288   function approve(address _spender, uint256 _value) public returns (bool success) {
289     allowed[msg.sender][_spender] = _value;
290     Approval(msg.sender, _spender, _value);
291     return true;
292   }
293   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
294     return allowed[_owner][_spender];
295   }
296 }