1 pragma solidity ^0.4.11;
2 
3 contract IERC20 {
4     function totalSupply() constant returns (uint256 totalSupply);
5     function balanceOf(address _owner) constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8     function approve(address _spender, uint256 _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10     
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 }
14 
15 library SafeMath {
16   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
17     uint256 c = a * b;
18     assert(a == 0 || c / a == b);
19     return c;
20   }
21 
22   function div(uint256 a, uint256 b) internal constant returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   function add(uint256 a, uint256 b) internal constant returns (uint256) {
35     uint256 c = a + b;
36     assert(c >= a);
37     return c;
38   }
39 }
40 
41 contract Panel is IERC20 {
42     
43     using SafeMath for uint256;
44   
45     string public symbol = 'PAN';
46 
47     string public name = 'Panel';
48     
49     uint8 public constant decimals = 18;
50     
51     uint256 public constant tokensPerEther = 1000;
52     
53     uint256 public _totalSupply = 9999999000000000000000000;
54     
55     
56     uint256 public totalContribution = 0;
57     
58     uint256 public bonusSupply = 0;
59     
60     bool public purchasingAllowed = false;
61     
62     uint8 public currentSaleDay = 1; 
63     uint8 public currentBonus = 100;
64     
65     string public startDate = '2017-09-16 18:00';
66     
67     address public owner;
68     
69     modifier onlyOwner {
70         require(msg.sender == owner);
71         _;
72     }
73     
74     mapping(address => uint256) balances;
75     mapping (address => mapping (address => uint256)) public allowed;
76     
77     function Panel() {
78         owner = msg.sender;
79         balances[msg.sender] = _totalSupply;
80     }
81     
82     function changeStartDate(string _startDate){
83         require(
84             msg.sender==owner
85         );
86         startDate = _startDate;
87     }
88     
89     function totalSupply() constant returns (uint256 totalSupply) {
90         return _totalSupply;
91     }
92    
93     function getStats() constant returns (uint256, uint256, uint256,  bool, uint256, uint256, string) {
94         return (totalContribution, _totalSupply, bonusSupply, purchasingAllowed, currentSaleDay, currentBonus, startDate);
95     }
96     
97     function transferOwnership(address _newOwner) onlyOwner {
98         owner = _newOwner;
99     }
100     
101      function rebrand(string _symbol, string _name) onlyOwner {
102         symbol = _symbol;
103         name   = _name;
104      }
105 
106     
107     function withdraw() onlyOwner {
108         owner.transfer(this.balance);
109     }
110     /* 
111      * create payable token. Now you can purchase it
112      *
113      */
114     function () payable {
115         require(
116             msg.value > 0
117             && purchasingAllowed
118         );
119         /*  everything is in wei */
120         uint256 baseTokens  = msg.value.mul(tokensPerEther);
121         uint256 bonusTokens = msg.value.mul(currentBonus);
122         /* send tokens to buyer. Buyer gets baseTokens + bonusTokens */
123         balances[msg.sender] = balances[msg.sender].add(baseTokens).add(bonusTokens);
124         /* send eth to owner */
125         owner.transfer(msg.value);
126         
127         bonusSupply       = bonusSupply.add(bonusTokens);
128         totalContribution = totalContribution.add(msg.value);
129         _totalSupply      = _totalSupply.add(baseTokens).add(bonusTokens);
130 
131         Transfer(address(this), msg.sender, baseTokens.add(bonusTokens));
132     }
133     
134     function enablePurchasing() onlyOwner {
135         purchasingAllowed = true;
136     }
137     
138     function disablePurchasing() onlyOwner {
139         purchasingAllowed = false;
140     }
141     
142     function setCurrentSaleDayAndBonus(uint8 _day) onlyOwner {
143         require(
144             (_day > 0 && _day < 11) 
145         );
146 
147         currentBonus = 10; 
148         currentSaleDay = _day;
149 
150         if(_day==1) {
151             currentBonus = 100;
152         } 
153         if(_day==2) {
154             currentBonus = 75;
155         }
156         if(_day>=3 && _day<5) {
157             currentBonus = 50;
158         }
159         if(_day>=5 && _day<8) {
160             currentBonus = 25;
161         }
162 
163         
164     }
165 
166     function balanceOf(address _owner) constant returns (uint256 balance) {
167         return balances[_owner];
168     }
169 
170     function transfer(address _to, uint256 _value) returns (bool success) {
171         require(
172             (balances[msg.sender] >= _value)
173             && (_value > 0)
174             && (_to != address(0))
175             && (balances[_to].add(_value) >= balances[_to])
176             && (msg.data.length >= (2 * 32) + 4)
177         );
178 
179         balances[msg.sender] = balances[msg.sender].sub(_value);
180         balances[_to] = balances[_to].add(_value);
181         Transfer(msg.sender, _to, _value);
182         return true;
183     }
184 
185     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
186         require(
187             (allowed[_from][msg.sender] >= _value) // Check allowance
188             && (balances[_from] >= _value) // Check if the sender has enough
189             && (_value > 0) // Don't allow 0value transfer
190             && (_to != address(0)) // Prevent transfer to 0x0 address
191             && (balances[_to].add(_value) >= balances[_to]) // Check for overflows
192             && (msg.data.length >= (2 * 32) + 4) //mitigates the ERC20 short address attack
193             //most of these things are not necesary
194         );
195         balances[_from] = balances[_from].sub(_value);
196         balances[_to] = balances[_to].add(_value);
197         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
198         Transfer(_from, _to, _value);
199         return true;
200     }
201 
202     function approve(address _spender, uint256 _value) returns (bool success) {
203         
204         require(
205             (_value == 0) 
206             || (allowed[msg.sender][_spender] == 0)
207         );
208         allowed[msg.sender][_spender] = _value;
209         Approval(msg.sender, _spender, _value);
210         return true;
211     }
212 
213 
214     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
215         return allowed[_owner][_spender];
216     }
217 
218     
219     event Transfer(address indexed _from, address indexed _to, uint256 _value);
220     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
221 
222 }