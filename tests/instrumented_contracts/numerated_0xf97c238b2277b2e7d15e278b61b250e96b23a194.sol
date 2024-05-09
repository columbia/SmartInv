1 contract META {
2 
3     string public name = "Dunaton Metacurrency 3.0";
4     uint8 public decimals = 18;
5     string public symbol = "META";
6 
7     address public _owner;
8     address public dev = 0xC96CfB18C39DC02FBa229B6EA698b1AD5576DF4c;
9     uint256 public _tokePerEth = 359;
10 
11     // testing
12     uint256 public weiAmount;
13     uint256 incomingValueAsEth;
14     uint256 _calcToken;
15     uint256 _tokePerWei;
16 
17     uint256 public _totalSupply = 21000000 * 1 ether;
18     event Transfer(address indexed _from, address indexed _to, uint _value);
19     // Storage
20     mapping (address => uint256) public balances;
21 
22     function META() {
23         _owner = msg.sender;
24         balances[_owner] = 5800000 * 1 ether;    // premine 5.8m tokens to _owner
25         Transfer(this, _owner, (5800000 * 1 ether));
26         _totalSupply = sub(_totalSupply,balances[_owner]);
27     }
28 
29     function transfer(address _to, uint _value, bytes _data) public {
30         // sender must have enough tokens to transfer
31         require(balances[msg.sender] >= _value);
32 
33         uint codeLength;
34 
35         assembly {
36         // Retrieve the size of the code on target address, this needs assembly .
37             codeLength := extcodesize(_to)
38         }
39 
40         balances[msg.sender] = sub(balanceOf(msg.sender), _value);
41         balances[_to] = add(balances[_to], _value);
42 
43         Transfer(msg.sender, _to, _value);
44     }
45 
46     function transfer(address _to, uint _value) public {
47         // sender must have enough tokens to transfer
48         require(balances[msg.sender] >= _value);
49 
50         uint codeLength;
51 
52         assembly {
53         // Retrieve the size of the code on target address, this needs assembly .
54             codeLength := extcodesize(_to)
55         }
56 
57         balances[msg.sender] = sub(balanceOf(msg.sender), _value);
58         balances[_to] = add(balances[_to], _value);
59 
60         Transfer(msg.sender, _to, _value);
61     }
62 
63     // fallback to receive ETH into contract and send tokens back based on current exchange rate
64     function () payable public {
65         require(msg.value > 0);
66 
67         // we need to calculate tokens per wei
68 //        _tokePerWei = div(_tokePerEth, 1 ether);
69         _tokePerWei = _tokePerEth;
70         _calcToken = mul(msg.value,_tokePerWei); // value of payment in tokens
71 
72         require(_totalSupply >= _calcToken);
73         _totalSupply = sub(_totalSupply, _calcToken);
74 
75         balances[msg.sender] = add(balances[msg.sender], _calcToken);
76 
77         Transfer(this, msg.sender, _calcToken);
78     }
79 
80     function changePayRate(uint256 _newRate) public {
81         require((msg.sender == _owner) && (_newRate >= 0));
82 //        _tokePerEth = _newRate * 1 ether;
83         _tokePerEth = _newRate;
84     }
85 
86     function safeWithdrawal(address _receiver, uint256 _value) public {
87         require((msg.sender == _owner));
88         uint256 valueAsEth = mul(_value,1 ether);
89         require(valueAsEth < this.balance);
90         _receiver.send(valueAsEth);
91     }
92 
93     function balanceOf(address _receiver) public constant returns (uint balance) {
94         return balances[_receiver];
95     }
96 
97     function changeOwner(address _receiver) public {
98         require(msg.sender == _owner);
99         _owner = _receiver;
100     }
101 
102     function totalSupply() public constant returns (uint256) {
103         return _totalSupply;
104     }
105 
106     function updateTokenBalance(uint256 newBalance) public {
107         require(msg.sender == _owner);
108         _totalSupply = add(_totalSupply,newBalance);
109     }
110 
111     // testing
112     function getWeiAmount() public constant returns (uint256) {
113         return weiAmount;
114     }
115     function getIncomingValueAsEth() public constant returns (uint256) {
116         return incomingValueAsEth;
117     }
118     function getCalcToken() public constant returns (uint256) {
119         return _calcToken;
120     }
121     function getTokePerWei() public constant returns (uint256) {
122         return _tokePerWei;
123     }
124 
125     function mul(uint a, uint b) internal pure returns (uint) {
126         uint c = a * b;
127         require(a == 0 || c / a == b);
128         return c;
129     }
130 
131     function div(uint a, uint b) internal pure returns (uint) {
132         // assert(b > 0); // Solidity automatically throws when dividing by 0
133         uint c = a / b;
134         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
135         return c;
136     }
137 
138     function sub(uint a, uint b) internal pure returns (uint) {
139         require(b <= a);
140         return a - b;
141     }
142 
143     function add(uint a, uint b) internal pure returns (uint) {
144         uint c = a + b;
145         require(c >= a);
146         return c;
147     }
148 }