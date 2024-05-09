1 contract META {
2 
3     string public name = "Dunaton Metacurrency";
4     uint8 public decimals = 18;
5     string public symbol = "META";
6 
7     address public _owner;
8     address public dev = 0xC96CfB18C39DC02FBa229B6EA698b1AD5576DF4c;
9     uint256 _tokePerEth = 156;
10     uint256 weIn;
11 
12     uint public _totalSupply = 21000000;  // 21m, 18dp - one token is 1000000000000000000 therefore
13     event Transfer(address indexed from, address indexed to, uint value, bytes data);
14 
15     // Storage
16     mapping (address => uint256) balances;
17 
18     function META() {
19         _owner = msg.sender;
20         balances[_owner] = 5800000;    // premine 5.8m tokens to _owner
21         _totalSupply = sub(_totalSupply,balances[_owner]);
22     }
23 
24     function transfer(address _to, uint _value, bytes _data) public {
25         // sender must have enough tokens to transfer
26         require(balances[msg.sender] >= _value);
27 
28         uint codeLength;
29 
30         assembly {
31         // Retrieve the size of the code on target address, this needs assembly .
32             codeLength := extcodesize(_to)
33         }
34 
35         balances[msg.sender] = sub(balanceOf(msg.sender), _value);
36         balances[_to] = add(balances[_to], _value);
37         
38         Transfer(msg.sender, _to, _value, _data);
39     }
40 
41     function transfer(address _to, uint _value) public {
42         // sender must have enough tokens to transfer
43         require(balances[msg.sender] >= _value);
44 
45         uint codeLength;
46         bytes memory empty;
47 
48         assembly {
49         // Retrieve the size of the code on target address, this needs assembly .
50             codeLength := extcodesize(_to)
51         }
52 
53         balances[msg.sender] = sub(balanceOf(msg.sender), _value);
54         balances[_to] = add(balances[_to], _value);
55 
56         Transfer(msg.sender, _to, _value, empty);
57     }
58 
59     // fallback to receive ETH into contract and send tokens back based on current exchange rate
60     function () payable public {
61         bytes memory empty;
62         require(msg.value > 0);
63 
64         uint incomingValueAsEth = msg.value / 1 ether;
65 
66         weIn = incomingValueAsEth;
67 
68         uint256 _calcToken = (incomingValueAsEth * _tokePerEth); // value of payment in tokens
69 
70         require(_totalSupply >= _calcToken);
71         _totalSupply = sub(_totalSupply, _calcToken);
72 
73         balances[msg.sender] = add(balances[msg.sender], _calcToken);
74 
75         Transfer(this, msg.sender, _calcToken, empty);
76     }
77 
78     function changePayRate(uint256 _newRate) public {
79         require((msg.sender == _owner) && (_newRate >= 0));
80         _tokePerEth = _newRate;
81     }
82 
83     function safeWithdrawal(address _receiver, uint256 _value) public {
84         require((msg.sender == _owner));
85         uint256 valueAsEth = _value * 1 ether;
86         require((valueAsEth * 1 ether) < this.balance);
87         _receiver.send(valueAsEth);
88     }
89 
90     function balanceOf(address _receiver) public constant returns (uint balance) {
91         return balances[_receiver];
92     }
93 
94     function changeOwner(address _receiver) public {
95         require(msg.sender == _owner);
96         _owner = _receiver;
97     }
98 
99     function tokens() public constant returns (uint) {
100         return _totalSupply;
101     }
102 
103     function updateTokenBalance(uint256 newBalance) public {
104         require(msg.sender == _owner);
105         _totalSupply = add(_totalSupply,newBalance);
106     }
107 
108     function mul(uint a, uint b) internal returns (uint) {
109         uint c = a * b;
110         assert(a == 0 || c / a == b);
111         return c;
112     }
113 
114     function div(uint a, uint b) internal returns (uint) {
115         // assert(b > 0); // Solidity automatically throws when dividing by 0
116         uint c = a / b;
117         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118         return c;
119     }
120 
121     function sub(uint a, uint b) internal returns (uint) {
122         assert(b <= a);
123         return a - b;
124     }
125 
126     function add(uint a, uint b) internal returns (uint) {
127         uint c = a + b;
128         assert(c >= a);
129         return c;
130     }
131 
132     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
133         return a >= b ? a : b;
134     }
135 
136     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
137         return a < b ? a : b;
138     }
139 
140     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
141         return a >= b ? a : b;
142     }
143 
144     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
145         return a < b ? a : b;
146     }
147 
148     function assert(bool assertion) internal {
149         if (!assertion) {
150             revert();
151         }
152     }
153 }