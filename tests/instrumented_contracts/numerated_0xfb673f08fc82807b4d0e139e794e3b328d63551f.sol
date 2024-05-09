1 pragma solidity ^0.4.20;
2 
3 contract AccessAdmin {
4     bool public isPaused = false;
5     address public addrAdmin;  
6 
7     event AdminTransferred(address indexed preAdmin, address indexed newAdmin);
8 
9     function AccessAdmin() public {
10         addrAdmin = msg.sender;
11     }  
12 
13 
14     modifier onlyAdmin() {
15         require(msg.sender == addrAdmin);
16         _;
17     }
18 
19     modifier whenNotPaused() {
20         require(!isPaused);
21         _;
22     }
23 
24     modifier whenPaused {
25         require(isPaused);
26         _;
27     }
28 
29     function setAdmin(address _newAdmin) external onlyAdmin {
30         require(_newAdmin != address(0));
31         AdminTransferred(addrAdmin, _newAdmin);
32         addrAdmin = _newAdmin;
33     }
34 
35     function doPause() external onlyAdmin whenNotPaused {
36         isPaused = true;
37     }
38 
39     function doUnpause() external onlyAdmin whenPaused {
40         isPaused = false;
41     }
42 }
43 
44 
45 contract AccessService is AccessAdmin {
46     address public addrService;
47     address public addrFinance;
48 
49     modifier onlyService() {
50         require(msg.sender == addrService);
51         _;
52     }
53 
54     modifier onlyFinance() {
55         require(msg.sender == addrFinance);
56         _;
57     }
58 
59     function setService(address _newService) external {
60         require(msg.sender == addrService || msg.sender == addrAdmin);
61         require(_newService != address(0));
62         addrService = _newService;
63     }
64 
65     function setFinance(address _newFinance) external {
66         require(msg.sender == addrFinance || msg.sender == addrAdmin);
67         require(_newFinance != address(0));
68         addrFinance = _newFinance;
69     }
70 
71     function withdraw(address _target, uint256 _amount) 
72         external 
73     {
74         require(msg.sender == addrFinance || msg.sender == addrAdmin);
75         require(_amount > 0);
76         address receiver = _target == address(0) ? addrFinance : _target;
77         uint256 balance = this.balance;
78         if (_amount < balance) {
79             receiver.transfer(_amount);
80         } else {
81             receiver.transfer(this.balance);
82         }      
83     }
84 }
85 
86 interface tokenRecipient { 
87     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
88 }
89 
90 contract TokenTycoonIGO is AccessService {
91     uint8 public decimals = 18;
92     uint256 public totalSupply = 850 * (10 ** uint256(decimals));
93     string public name = "Token Tycoon Coin";
94     string public symbol = "TTC";
95     bytes32 private emptyHash;
96 
97     mapping (address => uint256) balances;
98     mapping (address => mapping(address => uint256)) allowed;
99     mapping (address => string) addressToAccount;
100     mapping (bytes32 => address) accHashToAddress;
101     
102 
103     event Transfer(address indexed _from, address indexed _to, uint256 _value);
104     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
105     event BuyIGO(address indexed _from, string _account, uint256 _ethVal, uint256 _tthVal);
106 
107     function TokenTycoonIGO() public {
108         addrAdmin = msg.sender;
109         addrService = msg.sender;
110         addrFinance = msg.sender;
111 
112         balances[this] = totalSupply;
113         emptyHash = keccak256("");
114     }
115 
116     function() external payable {
117 
118     }
119 
120     function balanceOf(address _owner) external view returns (uint256) {
121         return balances[_owner];
122     }
123 
124     function approve(address _spender, uint256 _value) public returns (bool) {
125         allowed[msg.sender][_spender] = _value;
126         Approval(msg.sender, _spender, _value);
127         return true;
128     }
129 
130     function allowance(address _owner, address _spender) external view returns (uint256) {
131         return allowed[_owner][_spender];
132     }
133 
134     function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
135         require(_value <= allowed[_from][msg.sender]);
136         allowed[_from][msg.sender] -= _value;
137         return _transfer(_from, _to, _value);
138     }
139 
140     function transfer(address _to, uint256 _value) external returns (bool) {
141         return _transfer(msg.sender, _to, _value);     
142     }
143 
144     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
145         external
146         returns (bool success) {
147         tokenRecipient spender = tokenRecipient(_spender);
148         if (approve(_spender, _value)) {
149             spender.receiveApproval(msg.sender, _value, this, _extraData);
150             return true;
151         }
152     }
153 
154     function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
155         require(_to != address(0));
156         uint256 oldFromVal = balances[_from];
157         require(_value > 0 && oldFromVal >= _value);
158         uint256 oldToVal = balances[_to];
159         uint256 newToVal = oldToVal + _value;
160         require(newToVal > oldToVal);
161         uint256 newFromVal = oldFromVal - _value;
162         balances[_from] = newFromVal;
163         balances[_to] = newToVal;
164 
165         assert((oldFromVal + oldToVal) == (newFromVal + newToVal));
166         Transfer(_from, _to, _value);
167 
168         return true;
169     }
170 
171     function buy(string _account) external payable whenNotPaused {  
172         uint256 val = msg.value;
173         uint256 tthVal;
174         if (val == 1 ether) {
175             tthVal = 1100000000000000000;
176         } else if (val == 3 ether) {
177             tthVal = 3600000000000000000;
178         } else if (val == 5 ether) {
179             tthVal = 6500000000000000000;
180         } else if (val == 10 ether) {
181             tthVal = 15000000000000000000;
182         } else if (val == 20 ether) {
183             tthVal = 34000000000000000000;
184         } else {
185             require(false);
186         }
187         uint256 b = balances[this];
188         require(b >= tthVal);
189 
190         bytes32 hashAccount = keccak256(_account);
191         require(hashAccount != emptyHash);
192 
193         address preAddr = accHashToAddress[hashAccount];
194         string storage preAcc = addressToAccount[msg.sender];
195         bytes32 hashPreAcc = keccak256(preAcc);
196 
197         if (preAddr == address(0)) {
198             require(hashPreAcc == emptyHash);
199             // first buy
200             accHashToAddress[hashAccount] = msg.sender;
201             addressToAccount[msg.sender] = _account;
202             _transfer(this, msg.sender, tthVal);
203         } else if(preAddr == msg.sender) {
204             require(hashPreAcc == hashAccount);
205             // multi buy
206             _transfer(this, msg.sender, tthVal);
207         } else {
208             require(false);
209         }
210 
211         BuyIGO(msg.sender, _account, val, tthVal);
212     }
213 
214     function getCanSellBalance() external view returns(uint256) {
215         return balances[this];
216     }
217 
218     function getBalanceByAccount(string _account) external view returns(uint256) {
219         bytes32 hashAccount = keccak256(_account);
220         address addr = accHashToAddress[hashAccount];
221         if (addr == address(0)) {
222             return 0;
223         } else {
224             return balances[addr];
225         }
226     }
227 
228     function getIGOAccoountByAddr(address _addr) external view returns(string) {
229         return addressToAccount[_addr];
230     }
231 }