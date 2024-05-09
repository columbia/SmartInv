1 pragma solidity ^0.4.4;
2 
3 contract ERC20 {
4     uint public totalSupply;
5     function balanceOf(address _owner) constant returns (uint balance);
6     function transfer(address _to, uint _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint _value) returns (bool success);
8     function approve(address _spender, uint _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint remaining);
10     event Transfer(address indexed _from, address indexed _to, uint _value);
11     event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 
15 contract MichCoin is ERC20 {
16 
17     string public constant name = "Mich Coin";
18     string public constant symbol = "MCH";
19     uint public constant decimals = 8;
20 
21     uint public tokenToEtherRate;
22 
23     uint public startTime;
24     uint public endTime;
25     uint public bonusEndTime;
26 
27     uint public minTokens;
28     uint public maxTokens;
29     bool public frozen;
30 
31     address owner;
32     address reserve;
33     address main;
34 
35     mapping(address => uint256) balances;
36     mapping(address => uint256) incomes;
37     mapping(address => mapping(address => uint256)) allowed;
38 
39     uint public tokenSold;
40 
41     function MichCoin(uint _tokenCount, uint _minTokenCount, uint _tokenToEtherRate,
42                       uint _beginDurationInSec, uint _durationInSec, uint _bonusDurationInSec,
43                       address _mainAddress, address _reserveAddress) {
44         require(_minTokenCount <= _tokenCount);
45         require(_bonusDurationInSec <= _durationInSec);
46         require(_mainAddress != _reserveAddress);
47 
48         tokenToEtherRate = _tokenToEtherRate;
49         totalSupply = _tokenCount*(10**decimals);
50         minTokens = _minTokenCount*(10**decimals);
51         maxTokens = totalSupply*85/100;
52 
53         owner = msg.sender;
54         balances[this] = totalSupply;
55 
56         startTime = now + _beginDurationInSec;
57         bonusEndTime = startTime + _bonusDurationInSec;
58         endTime = startTime + _durationInSec;
59 
60         reserve = _reserveAddress;
61         main = _mainAddress;
62         frozen = false;
63         tokenSold = 0;
64     }
65 
66     //modifiers
67 
68     modifier ownerOnly {
69         require(msg.sender == owner);
70         _;
71     }
72 
73     modifier canFreeze {
74         require(frozen == false);
75         _;
76     }
77 
78     modifier waitForICO {
79         require(now >= startTime);
80         _;
81     }
82 
83     modifier afterICO {
84         //if ico period over or all token sold
85         require(now > endTime || balances[this] <= totalSupply - maxTokens);
86         _;
87     }
88 
89     //owner functions
90 
91     function freeze() ownerOnly {
92         frozen = true;
93     }
94 
95     function unfreeze() ownerOnly {
96         frozen = false;
97     }
98 
99     //erc20
100 
101     function balanceOf(address _owner) constant returns (uint balance) {
102         return balances[_owner];
103     }
104 
105     function transfer(address _to, uint _value) canFreeze returns (bool success) {
106         require(balances[msg.sender] >= _value);
107         require(balances[_to] + _value > balances[_to]);
108 
109         balances[msg.sender] -= _value;
110         balances[_to] += _value;
111 
112         Transfer(msg.sender, _to, _value);
113 
114         return true;
115     }
116 
117     function transferFrom(address _from, address _to, uint _value) canFreeze returns (bool success) {
118         require(balances[msg.sender] >= _value);
119         require(allowed[_from][_to] >= _value);
120         require(balances[_to] + _value > balances[_to]);
121 
122         balances[_from] -= _value;
123         balances[_to] += _value;
124         allowed[_from][_to] -= _value;
125 
126         Transfer(_from, _to, _value);
127 
128         return true;
129     }
130 
131     function approve(address _spender, uint _value) canFreeze returns (bool success) {
132         allowed[msg.sender][_spender] = _value;
133         Approval(msg.sender, _spender, _value);
134         return true;
135     }
136 
137     function allowance(address _owner, address _spender) constant returns (uint remaining) {
138         return allowed[_owner][_spender];
139     }
140 
141     //ether operations
142 
143     function () payable canFreeze waitForICO {
144         uint tokenAmount = weiToToken(msg.value);
145         uint bonusAmount = 0;
146         //add bonus token if bought on bonus period
147         if (now < bonusEndTime) {
148             bonusAmount = tokenAmount / 10;
149             tokenAmount += bonusAmount;
150         }
151 
152         require(now < endTime);
153         require(balances[this] >= tokenAmount);
154         require(balances[this] - tokenAmount >= totalSupply - maxTokens);
155         require(balances[msg.sender] + tokenAmount > balances[msg.sender]);
156 
157         balances[this] -= tokenAmount;
158         balances[msg.sender] += tokenAmount;
159         incomes[msg.sender] += msg.value;
160         tokenSold += tokenAmount;
161     }
162 
163     function refund(address _sender) canFreeze afterICO {
164         require(balances[this] >= totalSupply - minTokens);
165         require(incomes[_sender] > 0);
166 
167         balances[_sender] = 0;
168         _sender.transfer(incomes[_sender]);
169         incomes[_sender] = 0;
170     }
171 
172     function withdraw() canFreeze afterICO {
173         require(balances[this] < totalSupply - minTokens);
174         require(this.balance > 0);
175 
176         balances[reserve] = (totalSupply - balances[this]) * 15 / 85;
177         balances[this] = 0;
178         main.transfer(this.balance);
179     }
180 
181     //utility
182 
183     function tokenToWei(uint _tokens) constant returns (uint) {
184         return _tokens * (10**18) / tokenToEtherRate / (10**decimals);
185     }
186 
187     function weiToToken(uint _weis) constant returns (uint) {
188         return tokenToEtherRate * _weis * (10**decimals) / (10**18);
189     }
190 
191     function tokenAvailable() constant returns (uint) {
192         uint available = balances[this] - (totalSupply - maxTokens);
193         if (balances[this] < (totalSupply - maxTokens)) {
194             available = 0;
195         }
196         return available;
197     }
198 
199 }