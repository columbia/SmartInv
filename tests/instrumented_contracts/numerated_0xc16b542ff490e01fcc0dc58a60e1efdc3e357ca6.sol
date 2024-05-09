1 pragma solidity ^0.4.18;
2 
3 library itMaps {
4 
5     /* itMapAddressUint
6          address =>  Uint
7     */
8     struct entryAddressUint {
9     // Equal to the index of the key of this item in keys, plus 1.
10     uint keyIndex;
11     uint value;
12     }
13 
14     struct itMapAddressUint {
15     mapping(address => entryAddressUint) data;
16     address[] keys;
17     }
18 
19     function insert(itMapAddressUint storage self, address key, uint value) internal returns (bool replaced) {
20         entryAddressUint storage e = self.data[key];
21         e.value = value;
22         if (e.keyIndex > 0) {
23             return true;
24         } else {
25             e.keyIndex = ++self.keys.length;
26             self.keys[e.keyIndex - 1] = key;
27             return false;
28         }
29     }
30 
31     function remove(itMapAddressUint storage self, address key) internal returns (bool success) {
32         entryAddressUint storage e = self.data[key];
33         if (e.keyIndex == 0)
34         return false;
35 
36         if (e.keyIndex <= self.keys.length) {
37             // Move an existing element into the vacated key slot.
38             self.data[self.keys[self.keys.length - 1]].keyIndex = e.keyIndex;
39             self.keys[e.keyIndex - 1] = self.keys[self.keys.length - 1];
40             self.keys.length -= 1;
41             delete self.data[key];
42             return true;
43         }
44     }
45 
46     function destroy(itMapAddressUint storage self) internal  {
47         for (uint i; i<self.keys.length; i++) {
48             delete self.data[ self.keys[i]];
49         }
50         delete self.keys;
51         return ;
52     }
53 
54     function contains(itMapAddressUint storage self, address key) internal constant returns (bool exists) {
55         return self.data[key].keyIndex > 0;
56     }
57 
58     function size(itMapAddressUint storage self) internal constant returns (uint) {
59         return self.keys.length;
60     }
61 
62     function get(itMapAddressUint storage self, address key) internal constant returns (uint) {
63         return self.data[key].value;
64     }
65 
66     function getKeyByIndex(itMapAddressUint storage self, uint idx) internal constant returns (address) {
67         return self.keys[idx];
68     }
69 
70     function getValueByIndex(itMapAddressUint storage self, uint idx) internal constant returns (uint) {
71         return self.data[self.keys[idx]].value;
72     }
73 }
74 
75 contract ERC20 {
76     function totalSupply() public constant returns (uint256 supply);
77     function balanceOf(address who) public constant returns (uint value);
78     function allowance(address owner, address spender) public constant returns (uint _allowance);
79 
80     function transfer(address to, uint value) public returns (bool ok);
81     function transferFrom(address from, address to, uint value) public returns (bool ok);
82     function approve(address spender, uint value) public returns (bool ok);
83 
84     event Transfer(address indexed from, address indexed to, uint value);
85     event Approval(address indexed owner, address indexed spender, uint value);
86 }
87 
88 contract IceRockMining is ERC20{
89     using itMaps for itMaps.itMapAddressUint;
90 
91 
92     uint256 initialSupply = 20000000;
93     string public constant name = "ICE ROCK MINING";
94     string public constant symbol = "ROCK2";
95     uint currentUSDExchangeRate = 1340;
96     uint bonus = 0;
97     uint priceUSD = 1;
98     address IceRockMiningAddress;
99 
100     itMaps.itMapAddressUint balances;
101 
102 
103     mapping (address => mapping (address => uint256)) allowed;
104     mapping (address => uint256) approvedDividends;
105 
106     event Burned(address indexed from, uint amount);
107     event DividendsTransfered(address to, uint amount);
108 
109 
110     modifier onlyOwner {
111         if (msg.sender == IceRockMiningAddress) {
112             _;
113         }
114     }
115 
116     function totalSupply() public constant returns (uint256) {
117         return initialSupply;
118     }
119 
120     function balanceOf(address tokenHolder) public view returns (uint256 balance) {
121         return balances.get(tokenHolder);
122     }
123 
124     function allowance(address owner, address spender) public constant returns (uint256) {
125         return allowed[owner][spender];
126     }
127 
128 
129     function transfer(address to, uint value) public returns (bool success) {
130         if (balances.get(msg.sender) >= value && value > 0) {
131 
132             balances.insert(msg.sender, balances.get(msg.sender)-value);
133 
134             if (balances.contains(to)) {
135                 balances.insert(to, balances.get(to)+value);
136             }
137             else {
138                 balances.insert(to, value);
139             }
140 
141             Transfer(msg.sender, to, value);
142 
143             return true;
144 
145         } else return false;
146     }
147 
148     function transferFrom(address from, address to, uint256 value) public returns (bool success) {
149         if (balances.get(from) >= value && allowed[from][msg.sender] >= value && value > 0) {
150 
151             uint amountToInsert = value;
152 
153             if (balances.contains(to))
154             amountToInsert = amountToInsert+balances.get(to);
155 
156             balances.insert(to, amountToInsert);
157             balances.insert(from, balances.get(from) - value);
158             allowed[from][msg.sender] = allowed[from][msg.sender] - value;
159             Transfer(from, to, value);
160             return true;
161         } else
162         return false;
163     }
164 
165     function approve(address spender, uint value) public returns (bool success) {
166         if ((value != 0) && (balances.get(msg.sender) >= value)){
167             allowed[msg.sender][spender] = value;
168             Approval(msg.sender, spender, value);
169             return true;
170         } else{
171             return false;
172         }
173     }
174 
175     function IceRockMining() public {
176         IceRockMiningAddress = msg.sender;
177         balances.insert(IceRockMiningAddress, initialSupply);
178     }
179 
180     function setCurrentExchangeRate (uint rate) public onlyOwner{
181         currentUSDExchangeRate = rate;
182     }
183 
184     function setBonus (uint value) public onlyOwner{
185         bonus = value;
186     }
187 
188     function send(address addr, uint amount) public onlyOwner {
189         sendp(addr, amount);
190     }
191 
192     function sendp(address addr, uint amount) internal {
193         require(addr != IceRockMiningAddress);
194         require(amount > 0);
195         require (balances.get(IceRockMiningAddress)>=amount);
196 
197 
198         if (balances.contains(addr)) {
199             balances.insert(addr, balances.get(addr)+amount);
200         }
201         else {
202             balances.insert(addr, amount);
203         }
204 
205         balances.insert(IceRockMiningAddress, balances.get(IceRockMiningAddress)-amount);
206         Transfer(IceRockMiningAddress, addr, amount);
207     }
208 
209     function () public payable{
210         uint amountInUSDollars = msg.value * currentUSDExchangeRate / 10**18;
211         uint valueToPass = amountInUSDollars / priceUSD;
212         valueToPass = (valueToPass * (100 + bonus))/100;
213 
214         if (balances.get(IceRockMiningAddress) >= valueToPass) {
215             if (balances.contains(msg.sender)) {
216                 balances.insert(msg.sender, balances.get(msg.sender)+valueToPass);
217             }
218             else {
219                 balances.insert(msg.sender, valueToPass);
220             }
221             balances.insert(IceRockMiningAddress, balances.get(IceRockMiningAddress)-valueToPass);
222             Transfer(IceRockMiningAddress, msg.sender, valueToPass);
223         }
224     }
225 
226     function approveDividends (uint totalDividendsAmount) public onlyOwner {
227         uint256 dividendsPerToken = totalDividendsAmount*10**18 / initialSupply;
228         for (uint256 i = 0; i<balances.size(); i += 1) {
229             address tokenHolder = balances.getKeyByIndex(i);
230             if (balances.get(tokenHolder)>0)
231             approvedDividends[tokenHolder] = balances.get(tokenHolder)*dividendsPerToken;
232         }
233     }
234 
235     function burnUnsold() public onlyOwner returns (bool success) {
236         uint burningAmount = balances.get(IceRockMiningAddress);
237         initialSupply -= burningAmount;
238         balances.insert(IceRockMiningAddress, 0);
239         Burned(IceRockMiningAddress, burningAmount);
240         return true;
241     }
242 
243     function approvedDividendsOf(address tokenHolder) public view returns (uint256) {
244         return approvedDividends[tokenHolder];
245     }
246 
247     function transferAllDividends() public onlyOwner{
248         for (uint256 i = 0; i< balances.size(); i += 1) {
249             address tokenHolder = balances.getKeyByIndex(i);
250             if (approvedDividends[tokenHolder] > 0)
251             {
252                 tokenHolder.transfer(approvedDividends[tokenHolder]);
253                 DividendsTransfered (tokenHolder, approvedDividends[tokenHolder]);
254                 approvedDividends[tokenHolder] = 0;
255             }
256         }
257     }
258 
259     function withdraw(uint amount) public onlyOwner{
260         IceRockMiningAddress.transfer(amount);
261     }
262 }