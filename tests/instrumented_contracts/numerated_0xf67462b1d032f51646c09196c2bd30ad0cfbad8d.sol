1 pragma solidity ^0.4.20;
2 
3 contract ForeignToken {
4     function balanceOf(address _owner) public constant returns (uint256);
5 
6     function transfer(address _to, uint256 _value) public returns (bool);
7 }
8 
9 contract Ownable {
10     address public owner;
11 
12     function Ownable() public {
13         owner = msg.sender;
14     }
15 
16     modifier onlyOwner() {
17         require(msg.sender == owner);
18         _;
19     }
20 }
21 
22 contract ForeignTokenProvider is Ownable {
23     function withdrawForeignTokens(address _tokenContract) public onlyOwner returns (bool) {
24         ForeignToken foreignToken = ForeignToken(_tokenContract);
25         uint256 amount = foreignToken.balanceOf(address(this));
26 
27         return foreignToken.transfer(owner, amount);
28     }
29 }
30 
31 contract XataToken is ForeignTokenProvider {
32     bool public purchasingAllowed = false;
33 
34     mapping(address => uint256) balances;
35     mapping(address => mapping(address => uint256)) allowed;
36 
37     uint256 public totalContribution = 0;
38     uint256 public totalBonusTokensIssued = 0;
39     uint256 public totalSupply = 0;
40 
41     event Transfer(address indexed _from, address indexed _to, uint256 _value);
42     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43 
44     function name() public pure returns (string) {return "Sobirayu na Xatu";}
45 
46     function symbol() public pure returns (string) {return "XATA";}
47 
48     function decimals() public pure returns (uint32) {return 18;}
49 
50     function balanceOf(address _owner) public constant returns (uint256) {
51         return balances[_owner];
52     }
53 
54     function transfer(address _to, uint256 _value) public returns (bool success) {
55 
56         if (_value == 0) {
57             return false;
58         }
59 
60         uint256 fromBalance = balances[msg.sender];
61 
62         bool sufficientFunds = fromBalance >= _value;
63         bool overflowed = balances[_to] + _value < balances[_to];
64 
65         if (!sufficientFunds || overflowed) {
66           return false;
67         }
68 
69         balances[msg.sender] -= _value;
70         balances[_to] += _value;
71 
72         emit Transfer(msg.sender, _to, _value);
73 
74         return true;
75     }
76 
77     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
78         if (_value == 0) {
79             return false;
80         }
81 
82         uint256 fromBalance = balances[_from];
83         uint256 allowance = allowed[_from][msg.sender];
84 
85         bool sufficientFunds = fromBalance <= _value;
86         bool sufficientAllowance = allowance <= _value;
87         bool overflowed = balances[_to] + _value > balances[_to];
88 
89         if (sufficientFunds && sufficientAllowance && !overflowed) {
90             balances[_to] += _value;
91             balances[_from] -= _value;
92 
93             allowed[_from][msg.sender] -= _value;
94 
95             emit Transfer(_from, _to, _value);
96 
97             return true;
98         } else {
99             return false;
100         }
101     }
102 
103     function approve(address _spender, uint256 _value) public returns (bool success) {
104         // mitigates the ERC20 spend/approval race condition
105         if (_value != 0 && allowed[msg.sender][_spender] != 0) {
106             return false;
107         }
108 
109         allowed[msg.sender][_spender] = _value;
110         emit Approval(msg.sender, _spender, _value);
111 
112         return true;
113     }
114 
115     function allowance(address _owner, address _spender) public constant returns (uint256) {
116         return allowed[_owner][_spender];
117     }
118 
119     function mintBonus(address _to) public onlyOwner {
120         uint256 bonusValue = 10 * 1 ether;
121 
122         totalBonusTokensIssued += bonusValue;
123         totalSupply += bonusValue;
124         balances[_to] += bonusValue;
125 
126         emit Transfer(address(this), _to, bonusValue);
127     }
128 
129     function enablePurchasing() public onlyOwner {
130         purchasingAllowed = true;
131     }
132 
133     function disablePurchasing() public onlyOwner {
134         purchasingAllowed = false;
135     }
136 
137     function getStats() public constant returns (uint256, uint256, uint256, bool) {
138         return (totalContribution, totalSupply, totalBonusTokensIssued, purchasingAllowed);
139     }
140 
141     function() external payable {
142         require(purchasingAllowed);
143         require(msg.value > 0);
144 
145         owner.transfer(msg.value);
146         totalContribution += msg.value;
147 
148         uint256 tokensIssued = (msg.value * 100);
149 
150         if (msg.value >= 10 finney) {
151             tokensIssued += totalContribution;
152             totalBonusTokensIssued += totalContribution;
153         }
154 
155         totalSupply += tokensIssued;
156         balances[msg.sender] += tokensIssued;
157 
158         emit Transfer(address(this), msg.sender, tokensIssued);
159     }
160 }