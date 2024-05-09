1 contract SafeMath {
2     uint256 constant public MAX_UINT256 =
3     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
4  
5     function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {
6         if (x > MAX_UINT256 - y) throw;
7         return x + y;
8     }
9  
10     function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {
11         if (x < y) throw;
12         return x - y;
13     }
14  
15     function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {
16         if (y == 0) return 0;
17         if (x > MAX_UINT256 / y) throw;
18         return x * y;
19     }
20 }
21 
22 contract ERC223ReceivingContract {
23      
24     struct iGn {
25         address sender;
26         uint value;
27         bytes data;
28         bytes4 sig;
29     }
30     
31       function tokenFallback(address _from, uint _value, bytes _data){
32       iGn memory ignite;
33       ignite.sender = _from;
34       ignite.value = _value;
35       ignite.data = _data;
36       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
37       ignite.sig = bytes4(u);
38  
39     }
40 }
41 
42 contract iGnite is SafeMath { 
43 
44     string public name;
45     bytes32 public symbol;
46     uint8 public decimals;
47     uint256 public rewardPerBlockPerAddress;
48     uint256 public totalGenesisAddresses;
49     address public genesisCallerAddress;
50     uint256 public genesisBlockCount;
51     uint256 private minedBlocks;
52     uint256 private iGnited;
53     uint256 private genesisSupplyPerAddress;
54     uint256 private totalMaxAvailableAmount;
55     uint256 private availableAmount;
56     uint256 private availableBalance;
57     uint256 private balanceOfAddress;
58     uint256 private genesisSupply;
59     uint256 private _totalSupply;
60    
61     mapping(address => uint256) public balanceOf;
62     mapping(address => uint) balances; //balances
63     mapping(address => bool) public genesisAddress;
64     mapping (address => mapping (address => uint)) internal _allowances;
65     
66     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
67     event Transfer(address indexed from, address indexed to, uint256 value);
68     event Burn(address indexed from, uint256 value);
69     event Approval(address indexed _owner, address indexed _spender, uint _value);
70 
71     function iGnite() {
72 
73         genesisSupplyPerAddress = 10000000000; //10000
74         genesisBlockCount = 4498200; 
75         rewardPerBlockPerAddress = 135;
76         totalGenesisAddresses = 1000;
77         genesisSupply = genesisSupplyPerAddress * totalGenesisAddresses; 
78 
79         genesisCallerAddress = 0x0000000000000000000000000000000000000000;
80     }
81 
82     function currentBlock() constant returns (uint256 blockNumber)
83     {
84         return block.number;
85     }
86 
87     function blockDiff() constant returns (uint256 blockNumber)
88     {
89         return block.number - genesisBlockCount;
90     }
91 
92     function assignGenesisAddresses(address[] _address) public returns (bool success)
93     {
94         if (block.number <= 4538447) 
95         { 
96             if (msg.sender == genesisCallerAddress)
97             {
98                 for (uint i = 0; i < _address.length; i++)
99                 {
100                     balanceOf[_address[i]] = genesisSupplyPerAddress;
101                     genesisAddress[_address[i]] = true;
102                 }
103                 return true;
104             }
105         }
106         return false;
107     }
108     
109 
110     function balanceOf(address _address) constant returns (uint256 Balance) //how much?
111     {
112         if (genesisAddress[_address]) {
113             minedBlocks = block.number - genesisBlockCount;
114 
115             if (minedBlocks >= 75000000) return balanceOf[_address]; //app. 2052
116 
117             availableAmount = rewardPerBlockPerAddress * minedBlocks;
118             availableBalance = balanceOf[_address] + availableAmount;
119 
120             return availableBalance;
121         }
122         else
123             return balanceOf[_address];
124     }
125 
126     function name() constant returns (string _name)
127     {
128         name = "iGnite";
129         return name;
130     }
131     
132     function symbol() constant returns (bytes32 _symbol)
133     {
134         symbol = "iGn";
135         return symbol;
136     }
137     
138     function decimals() constant returns (uint8 _decimals)
139     {
140         decimals = 6;
141         return decimals;
142     }
143     
144     function totalSupply() constant returns (uint256 totalSupply)
145     {
146         minedBlocks = block.number - genesisBlockCount;
147         availableAmount = rewardPerBlockPerAddress * minedBlocks;
148         iGnited = availableAmount * totalGenesisAddresses;
149         return iGnited + genesisSupply;
150     }
151     
152     function minedTotalSupply() constant returns (uint256 minedBlocks)
153     {
154         minedBlocks = block.number - genesisBlockCount;
155         availableAmount = rewardPerBlockPerAddress * minedBlocks;
156         return availableAmount * totalGenesisAddresses;
157     }
158 
159     function initialiGnSupply() constant returns (uint256 maxSupply)  
160     {
161         return genesisSupplyPerAddress * totalGenesisAddresses;
162     }
163 
164    
165     //burn tokens
166     function burn(uint256 _value) public returns(bool success) {
167         
168         //get sum
169         minedBlocks = block.number - genesisBlockCount;
170         availableAmount = rewardPerBlockPerAddress * minedBlocks;
171         iGnited = availableAmount * totalGenesisAddresses;
172         _totalSupply = iGnited + genesisSupply;
173         
174         //burn time
175         require(balanceOf[msg.sender] >= _value);
176         balanceOf[msg.sender] -= _value;
177         _totalSupply -= _value;
178         Burn(msg.sender, _value);
179         return true;
180     }//
181 
182     function assignGenesisCallerAddress(address _caller) public returns(bool success)
183     {
184         if (genesisCallerAddress != 0x0000000000000000000000000000000000000000) return false;
185 
186         genesisCallerAddress = _caller;
187 
188         return true;
189     }
190     
191     function transfer(address _to, uint _value) public returns (bool) {
192         if (_value > 0 && _value <= balanceOf[msg.sender] && !isContract(_to)) {
193             balanceOf[msg.sender] -= _value;
194             balanceOf[_to] += _value;
195             Transfer(msg.sender, _to, _value);
196             return true;
197         }
198         return false;
199     }
200 
201     function transfer(address _to, uint _value, bytes _data) public returns (bool) {
202         if (_value > 0 && _value <= balanceOf[msg.sender] && isContract(_to)) {
203             balanceOf[msg.sender] -= _value;
204             balanceOf[_to] += _value;
205             ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
206                 _contract.tokenFallback(msg.sender, _value, _data);
207             Transfer(msg.sender, _to, _value, _data);
208             return true;
209         }
210         return false;
211     }
212 
213     function isContract(address _addr) returns (bool) {
214         uint codeSize;
215         assembly {
216             codeSize := extcodesize(_addr)
217         }
218         return codeSize > 0;
219     }
220 
221     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
222         if (_allowances[_from][msg.sender] > 0 && _value > 0 && _allowances[_from][msg.sender] >= _value &&
223             balanceOf[_from] >= _value) {
224             balanceOf[_from] -= _value;
225             balanceOf[_to] += _value;
226             _allowances[_from][msg.sender] -= _value;
227             Transfer(_from, _to, _value);
228             return true;
229         }
230         return false;
231     }
232     
233     function approve(address _spender, uint _value) public returns (bool) {
234         _allowances[msg.sender][_spender] = _value;
235         Approval(msg.sender, _spender, _value);
236         return true;
237     }
238     
239     function allowance(address _owner, address _spender) public constant returns (uint) {
240         return _allowances[_owner][_spender];
241     }
242 }