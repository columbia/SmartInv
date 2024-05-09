1 pragma solidity ^0.4.8;
2 
3 contract ERC20Interface {
4     function totalSupply() public constant returns (uint256 supply);
5     function balance() public constant returns (uint256);
6     function balanceOf(address _owner) public constant returns (uint256);
7     function transfer(address _to, uint256 _value) public returns (bool success);
8     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
9     function approve(address _spender, uint256 _value) public returns (bool success);
10     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
11 
12     event Transfer(address indexed _from, address indexed _to, uint256 _value);
13     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14 }
15 
16 contract Santal is ERC20Interface {
17     string public constant symbol = "TXQ";
18     string public constant name = "santal";
19     uint8  public constant decimals = 18;
20 
21     uint256 public _airdropTotal = 0;
22     uint256 public _airdropLimit = 10 * 10000 * 1000000000000000000;
23     uint256 public _airdropAmount = 10 * 1000000000000000000; 
24     uint256 public totalSupply = 50000 * 10000 * 1000000000000000000;
25     uint safeGas = 2300;
26     
27     uint256 public unitsOneEthCanBuy = 8000 * 1000000000000000000;
28     uint256 public canBuyLimit = 1000 * 10000 * 1000000000000000000;
29     uint256 public hasBuyTotal = 0;
30     uint256 public totalEthInWei;
31     uint256 constant public unitEthWei = 1000000000000000000;
32     address public owner;
33     bool public isBuyStopped;
34     bool public isAirdropStopped;
35 
36     mapping(address => uint256) balances;
37     mapping(address => bool) initialized;
38     mapping(address => bool) hasBuyed;
39 
40 
41     mapping(address => mapping (address => uint256)) allowed;
42     
43     event LOG_SuccessfulSend(address addr, uint amount);
44     event LOG_FailedSend(address receiver, uint amount);
45     event LOG_ZeroSend();
46     
47     event LOG_BuyStopped();
48     event LOG_BuyResumed();
49     
50     event LOG_AirdropStopped();
51     event LOG_AirdropResumed();
52     
53     event LOG_OwnerAddressChanged(address oldAddr, address newOwnerAddress);
54     
55     modifier onlyOwner {
56         if (owner != msg.sender) throw;
57         _;
58     }
59 
60     function Santal() {
61         owner = msg.sender;
62         initialized[msg.sender] = true;
63         balances[msg.sender] = totalSupply - _airdropLimit - canBuyLimit;
64     }
65     
66     function() payable{
67         
68         if (isBuyStopped) throw;
69         
70         if (!hasBuyed[msg.sender]) {
71             hasBuyed[msg.sender] = true;
72         }
73 
74         totalEthInWei = totalEthInWei + msg.value;
75         uint256 amount = msg.value * (unitsOneEthCanBuy / unitEthWei);
76         
77         hasBuyTotal += amount;
78          
79         if(amount > canBuyLimit || hasBuyTotal > canBuyLimit) throw;
80         
81         balances[msg.sender] = balances[msg.sender] + amount;
82 
83         Transfer(owner, msg.sender, amount);
84 
85         safeSend(owner, msg.value);
86     }
87     
88     function safeSend(address addr, uint value)
89         private {
90 
91         if (value == 0) {
92             LOG_ZeroSend();
93             return;
94         }
95 
96         if (!(addr.call.gas(safeGas).value(value)())) {
97             LOG_FailedSend(addr, value);
98         }
99 
100         LOG_SuccessfulSend(addr,value);
101     }
102 
103     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
104         allowed[msg.sender][_spender] = _value;
105         Approval(msg.sender, _spender, _value);
106 
107         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
108         return true;
109     }
110 
111     function totalSupply() constant returns (uint256 supply) {
112         return totalSupply;
113     }
114 
115     function balance() constant returns (uint256) {
116         return getBalance(msg.sender);
117     }
118 
119     function balanceOf(address _address) constant returns (uint256) {
120         return getBalance(_address);
121     }
122 
123     function transfer(address _to, uint256 _amount) returns (bool success) {
124         initialize(msg.sender);
125 
126         if (balances[msg.sender] >= _amount
127             && _amount > 0) {
128             initialize(_to);
129             if (balances[_to] + _amount > balances[_to]) {
130 
131                 balances[msg.sender] -= _amount;
132                 balances[_to] += _amount;
133 
134                 Transfer(msg.sender, _to, _amount);
135 
136                 return true;
137             } else {
138                 return false;
139             }
140         } else {
141             return false;
142         }
143     }
144 
145     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success) {
146         initialize(_from);
147 
148         if (balances[_from] >= _amount
149             && allowed[_from][msg.sender] >= _amount
150             && _amount > 0) {
151             initialize(_to);
152             if (balances[_to] + _amount > balances[_to]) {
153 
154                 balances[_from] -= _amount;
155                 allowed[_from][msg.sender] -= _amount;
156                 balances[_to] += _amount;
157 
158                 Transfer(_from, _to, _amount);
159 
160                 return true;
161             } else {
162                 return false;
163             }
164         } else {
165             return false;
166         }
167     }
168 
169     function approve(address _spender, uint256 _amount) returns (bool success) {
170         allowed[msg.sender][_spender] = _amount;
171         Approval(msg.sender, _spender, _amount);
172         return true;
173     }
174 
175     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
176         return allowed[_owner][_spender];
177     }
178 
179     function initialize(address _address) internal returns (bool success) {
180         if (!isAirdropStopped && _airdropTotal < _airdropLimit && !initialized[_address]) {
181             initialized[_address] = true;
182             balances[_address] = _airdropAmount;
183             _airdropTotal += _airdropAmount;
184         }
185         return true;
186     }
187 
188     function getBalance(address _address) internal returns (uint256) {
189         if (_airdropTotal < _airdropLimit && !initialized[_address] && !hasBuyed[_address]) {
190             return balances[_address] + _airdropAmount;
191         }
192         else {
193             return balances[_address];
194         }
195     }
196     
197     function stopBuy()
198         onlyOwner {
199 
200         isBuyStopped = true;
201         LOG_BuyStopped();
202     }
203 
204     function resumeBuy()
205         onlyOwner {
206 
207         isBuyStopped = false;
208         LOG_BuyResumed();
209     }
210     
211     function stopAirdrop()
212         onlyOwner {
213 
214         isAirdropStopped = true;
215         LOG_AirdropStopped();
216     }
217 
218     function resumeAirdrop()
219         onlyOwner {
220 
221         isAirdropStopped = false;
222         LOG_AirdropResumed();
223     }
224     
225         function changeOwnerAddress(address newOwner)
226         onlyOwner {
227 
228         if (newOwner == address(0x0)) throw;
229         owner = newOwner;
230         LOG_OwnerAddressChanged(owner, newOwner);
231     }
232 }