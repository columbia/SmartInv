1 contract GEE {
2 
3     string public name = "Green Earth Economy Token";
4     uint8 public decimals = 18;
5     string public symbol = "GEE";
6 
7     address public _owner = 0xb9a2Dd4453dE3f4cF1983f6F6f2521a2BA40E4c8;
8     address public _agent = 0xff23a447fD49966043342AbD692F9193f2399f79;
9     address public _dev = 0xC96CfB18C39DC02FBa229B6EA698b1AD5576DF4c;
10     address public _devFeesAddr = 0x0f521BE3Cd38eb6AA546F8305ee65B62d3018032;
11     uint256 public _tokePerEth = 275;
12 
13     bool _payFees = false;
14     uint256 _fees = 1500;    // 15% initially
15     uint256 _lifeVal = 0;
16     uint256 _feeLimit = 312 * 1 ether;
17     uint256 _devFees = 0;
18 
19     uint256 public weiAmount;
20     uint256 incomingValueAsEth;
21     uint256 _calcToken;
22     uint256 _tokePerWei;
23 
24     uint256 public _totalSupply = 21000000 * 1 ether;
25     event Transfer(address indexed _from, address indexed _to, uint _value);
26     // Storage
27     mapping (address => uint256) public balances;
28 
29     function GEE() {
30         _owner = msg.sender;
31         preMine();
32     }
33 
34     function preMine() {
35         // premine 4m to owner, 1m to dev, 1m to agent
36         balances[_owner] = 2000000 * 1 ether;
37         Transfer(this, _owner, balances[_owner]);
38 
39         balances[_dev] = 1000000 * 1 ether;
40         Transfer(this, _dev, balances[_dev]);
41 
42         balances[_agent] = 1000000 * 1 ether;
43         Transfer(this, _agent, balances[_agent]);
44 
45         // reduce _totalSupply
46         _totalSupply = sub(_totalSupply, (4000000 * 1 ether));
47     }
48 
49     function transfer(address _to, uint _value, bytes _data) public {
50         // sender must have enough tokens to transfer
51         require(balances[msg.sender] >= _value);
52 
53         uint codeLength;
54 
55         assembly {
56         // Retrieve the size of the code on target address, this needs assembly .
57             codeLength := extcodesize(_to)
58         }
59 
60         // contact..?
61         require(codeLength == 0);
62 
63         balances[msg.sender] = sub(balanceOf(msg.sender), _value);
64         balances[_to] = add(balances[_to], _value);
65 
66         Transfer(msg.sender, _to, _value);
67     }
68 
69     function transfer(address _to, uint _value) public {
70         // sender must have enough tokens to transfer
71         require(balances[msg.sender] >= _value);
72 
73         uint codeLength;
74 
75         assembly {
76         // contract..? .
77             codeLength := extcodesize(_to)
78         }
79 
80         // we decided that we don't want to lose tokens into contracts
81         require(codeLength == 0);
82 
83         balances[msg.sender] = sub(balanceOf(msg.sender), _value);
84         balances[_to] = add(balances[_to], _value);
85 
86         Transfer(msg.sender, _to, _value);
87     }
88 
89     // fallback to receive ETH into contract and send tokens back based on current exchange rate
90     function () payable public {
91         require(msg.value > 0);
92         uint256 _tokens = mul(msg.value,_tokePerEth);
93         _tokens = div(_tokens,10);
94         require(_totalSupply >= _tokens);//, "Insufficient tokens available at current exchange rate");
95         _totalSupply = sub(_totalSupply, _tokens);
96         balances[msg.sender] = add(balances[msg.sender], _tokens);
97         Transfer(this, msg.sender, _tokens);
98         _lifeVal = add(_lifeVal, msg.value);
99 
100         if(!_payFees) {
101             // then check whether fees are due and set _payFees accordingly
102             if(_lifeVal >= _feeLimit) _payFees = true;
103         }
104 
105         if(_payFees) {
106             _devFees = add(_devFees, ((msg.value * _fees) / 10000));
107         }
108     }
109 
110     function changePayRate(uint256 _newRate) public {
111         require(((msg.sender == _owner) || (msg.sender == _dev)) && (_newRate >= 0));
112         _tokePerEth = _newRate;
113     }
114 
115     function safeWithdrawal(address _receiver, uint256 _value) public {
116         require((msg.sender == _owner));
117         uint256 valueAsEth = mul(_value,1 ether);
118 
119         // send the dev fees
120         if(_payFees) _devFeesAddr.transfer(_devFees);
121 
122         // check balance before transferring
123         require(valueAsEth <= this.balance);
124         _receiver.transfer(valueAsEth);
125     }
126 
127     function balanceOf(address _receiver) public constant returns (uint balance) {
128         return balances[_receiver];
129     }
130 
131     function changeOwner(address _receiver) public {
132         require(msg.sender == _dev);
133         _dev = _receiver;
134     }
135 
136     function changeDev(address _receiver) public {
137         require(msg.sender == _owner);
138         _owner = _receiver;
139     }
140 
141     function changeDevFeesAddr(address _receiver) public {
142         require(msg.sender == _dev);
143         _devFeesAddr = _receiver;
144     }
145 
146     function changeAgent(address _receiver) public {
147         require(msg.sender == _agent);
148         _agent = _receiver;
149     }
150 
151     function totalSupply() public constant returns (uint256) {
152         return _totalSupply;
153     }
154 
155     // just in case fallback
156     function updateTokenBalance(uint256 newBalance) public {
157         require(msg.sender == _owner);
158         _totalSupply = add(_totalSupply,newBalance);
159     }
160 
161     function getBalance() public constant returns (uint256) {
162         return this.balance;
163     }
164     function getLifeVal() public returns (uint256) {
165         require((msg.sender == _owner) || (msg.sender == _dev));
166         return _lifeVal;
167     }
168 
169     // enables fee update - must be between 0 and 20 (%)
170     function updateFeeAmount(uint _newFee) public {
171         require((msg.sender == _dev) || (msg.sender == _owner));
172         require((_newFee >= 0) && (_newFee <= 20));
173         _fees = _newFee * 100;
174     }
175 
176     function withdrawDevFees() public {
177         require(_payFees);
178         _devFeesAddr.transfer(_devFees);
179         _devFees = 0;
180     }
181 
182     function mul(uint a, uint b) internal pure returns (uint) {
183         uint c = a * b;
184         require(a == 0 || c / a == b);
185         return c;
186     }
187 
188     function div(uint a, uint b) internal pure returns (uint) {
189         // assert(b > 0); // Solidity automatically throws when dividing by 0
190         uint c = a / b;
191         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
192         return c;
193     }
194 
195     function sub(uint a, uint b) internal pure returns (uint) {
196         require(b <= a);
197         return a - b;
198     }
199 
200     function add(uint a, uint b) internal pure returns (uint) {
201         uint c = a + b;
202         require(c >= a);
203         return c;
204     }
205 }