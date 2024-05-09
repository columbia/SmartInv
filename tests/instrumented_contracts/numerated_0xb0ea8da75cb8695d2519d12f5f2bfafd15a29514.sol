1 pragma solidity ^0.4.16;
2 
3 /* 
4  * Giga Giving Coin and ICO Contract.
5  * 15,000,000 Coins Total.
6  * 12,000,000 Coins available for purchase.
7  */
8 contract Token {   
9     uint256 public totalSupply;
10     function balanceOf(address _owner) public constant returns (uint256 balance);
11     function transfer(address _to, uint256 _value) public returns (bool success);
12     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
13     function approve(address _spender, uint256 _value) public returns (bool success);
14     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
15     event Transfer(address indexed _from, address indexed _to, uint256 _value);
16     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17 }
18 
19 contract StandardToken is Token {
20     mapping (address => uint256) balances;
21     mapping (address => mapping (address => uint256)) allowed;
22 
23     function transfer(address _to, uint256 _value) public returns (bool success) {       
24         address sender = msg.sender;
25         require(balances[sender] >= _value);
26         balances[sender] -= _value;
27         balances[_to] += _value;
28         Transfer(sender, _to, _value);
29         return true;
30     }
31 
32     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {      
33         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
34         balances[_to] += _value;
35         balances[_from] -= _value;
36         allowed[_from][msg.sender] -= _value;
37         Transfer(_from, _to, _value);
38         return true;
39     }
40 
41     function balanceOf(address _owner) public constant returns (uint256 balance) {
42         return balances[_owner];
43     }
44 
45     function approve(address _spender, uint256 _value) public returns (bool success) {
46         allowed[msg.sender][_spender] = _value;
47         Approval(msg.sender, _spender, _value);
48         return true;
49     }
50 
51     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
52       return allowed[_owner][_spender];
53     }    
54 }
55 
56 library SafeMath {
57   function mul(uint256 a, uint256 b) internal returns (uint256) {
58     uint256 c = a * b;
59     assert(a == 0 || c / a == b);
60     return c;
61   }
62 
63   function div(uint256 a, uint256 b) internal returns (uint256) {    
64     uint256 c = a / b;    
65     return c;
66   }
67 
68   function sub(uint256 a, uint256 b) internal returns (uint256) {
69     assert(b <= a);
70     return a - b;
71   }
72 
73   function add(uint256 a, uint256 b) internal returns (uint256) {
74     uint256 c = a + b;
75     assert(c >= a);
76     return c;
77   }
78 }
79 
80 contract GigaGivingToken is StandardToken {
81     using SafeMath for uint256;
82          
83     uint256 private fundingGoal = 0 ether;
84     uint256 private amountRaised;
85 
86     uint256 private constant PHASE_1_PRICE = 1600000000000000;
87     uint256 private constant PHASE_2_PRICE = 2000000000000000; 
88     uint256 private constant PHASE_3_PRICE = 2500000000000000; 
89     uint256 private constant PHASE_4_PRICE = 4000000000000000;
90     uint256 private constant PHASE_5_PRICE = 5000000000000000; 
91     uint256 private constant DURATION = 5 weeks;  
92 
93     uint256 public constant TOTAL_TOKENS = 15000000;
94     uint256 public constant  CROWDSALE_TOKENS = 12000000;  
95     
96 
97     uint256 public startTime;
98     uint256 public tokenSupply;
99  
100     address public creator;
101     address public beneficiary;
102 
103     string public name = "Giga Coin";
104     string public symbol = "GC";
105     string public version = "GC.7";
106     uint256 public decimals = 0;  
107     
108     // GigaGivingToken public tokenReward;
109     mapping(address => uint256) public ethBalanceOf;
110     bool public fundingGoalReached = false;
111     bool public crowdsaleClosed = false;   
112     bool public refundsOpen = false;   
113 
114     function GigaGivingToken (address icoBeneficiary) public {
115         creator = msg.sender;
116         beneficiary = icoBeneficiary;
117         totalSupply = TOTAL_TOKENS;         
118         
119         balances[beneficiary] = TOTAL_TOKENS.sub(CROWDSALE_TOKENS);
120         Transfer(0x0, icoBeneficiary, TOTAL_TOKENS.sub(CROWDSALE_TOKENS));
121 
122         balances[this] = CROWDSALE_TOKENS;
123         Transfer(0x0, this, CROWDSALE_TOKENS);              
124         tokenSupply = CROWDSALE_TOKENS;
125         
126         startTime = 1510765200;
127     }   
128   
129     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
130         allowed[msg.sender][_spender] = _value;
131         Approval(msg.sender, _spender, _value);
132         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
133         return true;
134     } 
135   
136     function () public payable {
137         require(now >= startTime);
138         require(now <= startTime + DURATION);
139         require(!crowdsaleClosed);
140         require(msg.value > 0);
141         uint256 amount = msg.value;
142         uint256 coinTotal = 0;      
143         
144         if (now > startTime + 4 weeks) {
145             coinTotal = amount.div(PHASE_5_PRICE);
146         } else if (now > startTime + 3 weeks) {
147             coinTotal = amount.div(PHASE_4_PRICE);
148         } else if (now > startTime + 2 weeks) {
149             coinTotal = amount.div(PHASE_3_PRICE);
150         } else if (now > startTime + 1 weeks) {
151             coinTotal = amount.div(PHASE_2_PRICE);
152         } else {
153             coinTotal = amount.div(PHASE_1_PRICE);
154         }
155 
156         ethBalanceOf[msg.sender] = ethBalanceOf[msg.sender].add(amount);              
157         balances[msg.sender] = balances[msg.sender].add(coinTotal);
158         balances[this] = balances[this].sub(coinTotal);
159         amountRaised = amountRaised.add(amount);
160         tokenSupply = tokenSupply.sub(coinTotal);
161         transfer(msg.sender, coinTotal);
162     }  
163 
164     modifier afterDeadline() { 
165         if (now >= (startTime + DURATION)) {
166             _;
167         }
168     }
169 
170     function checkGoalReached() public afterDeadline {
171         if (amountRaised >= fundingGoal) {
172             fundingGoalReached = true;
173         }
174         crowdsaleClosed = true;
175     }
176 
177     function safeWithdrawal() public afterDeadline {
178         if (refundsOpen) {
179             uint amount = ethBalanceOf[msg.sender];
180             ethBalanceOf[msg.sender] = 0;
181             if (amount > 0) {
182                 if (!msg.sender.send(amount)) {
183                     ethBalanceOf[msg.sender] = amount;
184                 }
185             }
186         }
187 
188         if (fundingGoalReached && beneficiary == msg.sender) {
189             if (beneficiary.send(amountRaised)) {
190                 this.transfer(msg.sender, tokenSupply);
191             } else {               
192                 fundingGoalReached = false;
193             }
194         }
195     }
196 
197     function enableRefunds() public afterDeadline {
198         require(msg.sender == beneficiary);
199         refundsOpen = true;
200     }
201 }