1 pragma solidity ^0.4.17;
2 
3 
4 contract Owned {
5     address public owner;
6 
7     function Owned() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 }
16 
17 
18 contract ForeignToken {
19     function balanceOf(address _owner) public constant returns (uint256);
20     function transfer(address _to, uint256 _value) public returns (bool);
21 }
22 
23 
24 contract StrongHandsIcoToken is Owned {
25     bool public purchasingAllowed = false;
26 
27     mapping (address => uint256) public balances;
28     mapping (address => mapping (address => uint256)) public allowed;
29 
30     uint256 public totalContribution = 0;
31     uint256 public totalBonusTokensIssued = 0;
32 
33     uint256 public totalSupply = 0;
34 
35     function name() public pure returns (string) { return "Strong Hands ICO Token"; }
36     function symbol() public pure returns (string) { return "SHIT"; }
37     function decimals() public pure returns (uint8) { return 18; }
38     
39     function balanceOf(address _owner) public constant returns (uint256) { return balances[_owner]; }
40     
41     function transfer(address _to, uint256 _value) public returns (bool success) {
42         require(msg.data.length >= (2 * 32) + 4);
43 
44         if (_value == 0) { return false; }
45 
46         uint256 fromBalance = balances[msg.sender];
47 
48         bool sufficientFunds = fromBalance >= _value;
49         bool overflowed = balances[_to] + _value < balances[_to];
50         
51         if (sufficientFunds && !overflowed) {
52             balances[msg.sender] -= _value;
53             balances[_to] += _value;
54             
55             Transfer(msg.sender, _to, _value);
56             return true;
57         } else { return false; }
58     }
59     
60     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
61         require(msg.data.length >= (3 * 32) + 4);
62 
63         if (_value == 0) { return false; }
64         
65         uint256 fromBalance = balances[_from];
66         uint256 allowance = allowed[_from][msg.sender];
67 
68         bool sufficientFunds = fromBalance <= _value;
69         bool sufficientAllowance = allowance <= _value;
70         bool overflowed = balances[_to] + _value > balances[_to];
71 
72         if (sufficientFunds && sufficientAllowance && !overflowed) {
73             balances[_to] += _value;
74             balances[_from] -= _value;
75             
76             allowed[_from][msg.sender] -= _value;
77             
78             Transfer(_from, _to, _value);
79             return true;
80         } else { return false; }
81     }
82     
83     function approve(address _spender, uint256 _value) public returns (bool success) {
84         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
85         
86         allowed[msg.sender][_spender] = _value;
87         
88         Approval(msg.sender, _spender, _value);
89         return true;
90     }
91     
92     function allowance(address _owner, address _spender) public constant returns (uint256) {
93         return allowed[_owner][_spender];
94     }
95 
96     event Transfer(address indexed _from, address indexed _to, uint256 _value);
97     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
98 
99     function enablePurchasing() public onlyOwner {
100         purchasingAllowed = true;
101     }
102 
103     function disablePurchasing() public onlyOwner {
104         purchasingAllowed = false;
105     }
106 
107     function withdrawForeignTokens(address _tokenContract) public onlyOwner returns (bool) {
108         ForeignToken token = ForeignToken(_tokenContract);
109 
110         uint256 amount = token.balanceOf(address(this));
111         return token.transfer(owner, amount);
112     }
113 
114     function getStats() public constant returns (uint256, uint256, uint256, bool) {
115         return (totalContribution, totalSupply, totalBonusTokensIssued, purchasingAllowed);
116     }
117 
118     function _randomNumber(uint64 upper) internal view returns (uint64 randomNumber) {
119         uint64 _seed = uint64(keccak256(keccak256(block.blockhash(block.number), _seed), now));
120         return _seed % upper;
121     }
122 
123     function() public payable {
124         require(purchasingAllowed);
125         require(msg.value > 0);
126 
127         uint256 rate = 10000;
128         if (totalContribution < 100 ether) {
129             rate = 12500;
130         } else if (totalContribution < 200 ether) {
131             rate = 11500;
132         } else if (totalContribution < 300 ether) {
133             rate = 10500;
134         }
135         owner.transfer(msg.value);
136         totalContribution += msg.value;
137 
138         uint256 tokensIssued = (msg.value * rate);
139 
140         if (msg.value >= 10 finney) {
141             uint64 multiplier = 1;
142             if (_randomNumber(10000) == 1) {
143                 multiplier *= 10;
144             }
145             if (_randomNumber(1000) == 1) {
146                 multiplier *= 5;
147             }
148             if (_randomNumber(100) == 1) {
149                 multiplier *= 2;
150             }
151 
152             uint256 bonusTokensIssued = (tokensIssued * multiplier) - tokensIssued;
153             tokensIssued *= multiplier;
154 
155             totalBonusTokensIssued += bonusTokensIssued;
156         }
157 
158         totalSupply += tokensIssued;
159         balances[msg.sender] += tokensIssued;
160         
161         Transfer(address(this), msg.sender, tokensIssued);
162     }
163 }