1 contract ERC223ReceivingContract {
2      
3     struct iGn {
4         address sender;
5         uint value;
6         bytes data;
7         bytes4 sig;
8     }
9     
10       function tokenFallback(address _from, uint _value, bytes _data){
11       iGn memory ignite;
12       ignite.sender = _from;
13       ignite.value = _value;
14       ignite.data = _data;
15       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
16       ignite.sig = bytes4(u);
17  
18     }
19 }
20 
21 
22 contract SafeMath {
23     uint256 constant public MAX_UINT256 =
24     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
25  
26     function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {
27         if (x > MAX_UINT256 - y) throw;
28         return x + y;
29     }
30  
31     function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {
32         if (x < y) throw;
33         return x - y;
34     }
35  
36     function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {
37         if (y == 0) return 0;
38         if (x > MAX_UINT256 / y) throw;
39         return x * y;
40     }
41 }
42  
43 contract iGnite is SafeMath { 
44 
45     string public name;
46     bytes32 public symbol;
47     uint8 public decimals;
48     uint256 public rewardPerBlockPerAddress;
49     uint256 public totalGenesisAddresses;
50     address public genesisCallerAddress;
51     uint256 public initialSupplyPerAddress;
52     uint256 public genesisBlockCount;
53     uint256 private minedBlocks;
54     uint256 private iGnited;
55     uint256 private genesisSupplyPerAddress;
56     uint256 private totalMaxAvailableAmount;
57     uint256 private availableAmount;
58     uint256 private availableBalance;
59     uint256 private balanceOfAddress;
60     uint256 private genesisSupply;
61     uint256 private _totalSupply;
62    
63     mapping(address => uint256) public balanceOf;
64     mapping(address => uint) balances; //balances
65     mapping(address => bool) public genesisAddress;
66     mapping (address => mapping (address => uint)) internal _allowances;
67     
68     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
69     event Transfer(address indexed from, address indexed to, uint256 value);
70     event Burn(address indexed from, uint256 value);
71     event Approval(address indexed _owner, address indexed _spender, uint _value);
72 
73     function iGnite() {
74 
75         genesisSupplyPerAddress = 10000000000; //10000
76         genesisBlockCount = 4498200; 
77         rewardPerBlockPerAddress = 135;
78         totalGenesisAddresses = 1000;
79         genesisSupply = initialSupplyPerAddress * totalGenesisAddresses; 
80 
81         genesisCallerAddress = 0x0000000000000000000000000000000000000000;
82     }
83 
84     function currentBlock() constant returns (uint256 blockNumber)
85     {
86         return block.number;
87     }
88 
89     function blockDiff() constant returns (uint256 blockNumber)
90     {
91         return block.number - genesisBlockCount;
92     }
93 
94     function assignGenesisAddresses(address[] _address) public returns (bool success)
95     {
96         if (block.number <= 4538447) 
97         { 
98             if (msg.sender == genesisCallerAddress)
99             {
100                 for (uint i = 0; i < _address.length; i++)
101                 {
102                     balanceOf[_address[i]] = genesisSupplyPerAddress;
103                     genesisAddress[_address[i]] = true;
104                 }
105                 return true;
106             }
107         }
108         return false;
109     }
110     
111 
112     function balanceOf(address _address) constant returns (uint256 Balance) //how much?
113     {
114         if (genesisAddress[_address]) {
115             minedBlocks = block.number - genesisBlockCount;
116 
117             if (minedBlocks >= 75000000) return balanceOf[_address]; //app. 2052
118 
119             availableAmount = rewardPerBlockPerAddress * minedBlocks;
120             availableBalance = balanceOf[_address] + availableAmount;
121 
122             return availableBalance;
123         }
124         else
125             return balanceOf[_address];
126     }
127 
128     function name() constant returns (string _name)
129     {
130         name = "iGnite";
131         return name;
132     }
133     
134     function symbol() constant returns (bytes32 _symbol)
135     {
136         symbol = "iGn";
137         return symbol;
138     }
139     
140     function decimals() constant returns (uint8 _decimals)
141     {
142         decimals = 6;
143         return decimals;
144     }
145     
146     function totalSupply() constant returns (uint256 totalSupply)
147     {
148         minedBlocks = block.number - genesisBlockCount;
149         availableAmount = rewardPerBlockPerAddress * minedBlocks;
150         iGnited = availableAmount * totalGenesisAddresses;
151         return iGnited + genesisSupply;
152     }
153     
154     function minedTotalSupply() constant returns (uint256 minedBlocks)
155     {
156         minedBlocks = block.number - genesisBlockCount;
157         availableAmount = rewardPerBlockPerAddress * minedBlocks;
158         return availableAmount * totalGenesisAddresses;
159     }
160 
161     function initialiGnSupply() constant returns (uint256 maxSupply)  
162     {
163         return genesisSupplyPerAddress * totalGenesisAddresses;
164     }
165 
166    
167     //burn tokens
168     function burn(uint256 _value) public returns(bool success) {
169         
170         //get sum
171         minedBlocks = block.number - genesisBlockCount;
172         availableAmount = rewardPerBlockPerAddress * minedBlocks;
173         iGnited = availableAmount * totalGenesisAddresses;
174         _totalSupply = iGnited + genesisSupply;
175         
176         //burn time
177         require(balanceOf[msg.sender] >= _value);
178         balanceOf[msg.sender] -= _value;
179         _totalSupply -= _value;
180         Burn(msg.sender, _value);
181         return true;
182     }//
183 
184     function assignGenesisCallerAddress(address _caller) public returns(bool success)
185     {
186         if (genesisCallerAddress != 0x0000000000000000000000000000000000000000) return false;
187 
188         genesisCallerAddress = _caller;
189 
190         return true;
191     }
192     
193     function transfer(address _to, uint _value) public returns (bool) {
194         if (_value > 0 && _value <= balanceOf[msg.sender] && !isContract(_to)) {
195             balanceOf[msg.sender] -= _value;
196             balanceOf[_to] += _value;
197             Transfer(msg.sender, _to, _value);
198             return true;
199         }
200         return false;
201     }
202 
203     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
204         if (_value > 0 && _value <= balanceOf[msg.sender] && isContract(_to)) {
205             balanceOf[msg.sender] -= _value;
206             balanceOf[_to] += _value;
207             ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
208                 _contract.tokenFallback(msg.sender, _value, _data);
209             Transfer(msg.sender, _to, _value, _data);
210             return true;
211         }
212         return false;
213     }
214 
215     function isContract(address _addr) returns (bool) {
216         uint codeSize;
217         assembly {
218             codeSize := extcodesize(_addr)
219         }
220         return codeSize > 0;
221     }
222 
223     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
224         if (_allowances[_from][msg.sender] > 0 && _value > 0 && _allowances[_from][msg.sender] >= _value &&
225             balanceOf[_from] >= _value) {
226             balanceOf[_from] -= _value;
227             balanceOf[_to] += _value;
228             _allowances[_from][msg.sender] -= _value;
229             Transfer(_from, _to, _value);
230             return true;
231         }
232         return false;
233     }
234     
235     function approve(address _spender, uint _value) public returns (bool) {
236         _allowances[msg.sender][_spender] = _value;
237         Approval(msg.sender, _spender, _value);
238         return true;
239     }
240     
241     function allowance(address _owner, address _spender) public constant returns (uint) {
242         return _allowances[_owner][_spender];
243     }
244 }