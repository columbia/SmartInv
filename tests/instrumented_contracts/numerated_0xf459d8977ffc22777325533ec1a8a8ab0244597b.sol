1 pragma solidity ^0.4.13;
2 
3 library safeMath {
4   function mul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint a, uint b) internal returns (uint) {
11     uint c = a / b;
12     return c;
13   }
14 
15   function sub(uint a, uint b) internal returns (uint) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint a, uint b) internal returns (uint) {
21     uint c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 
26   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
27     return a >= b ? a : b;
28   }
29 
30   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
31     return a < b ? a : b;
32   }
33 
34   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
35     return a >= b ? a : b;
36   }
37 
38   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
39     return a < b ? a : b;
40   }
41 }
42 
43 contract DBC {
44 
45     // MODIFIERS
46 
47     modifier pre_cond(bool condition) {
48         require(condition);
49         _;
50     }
51 
52     modifier post_cond(bool condition) {
53         _;
54         assert(condition);
55     }
56 
57     modifier invariant(bool condition) {
58         require(condition);
59         _;
60         assert(condition);
61     }
62 }
63 
64 contract ERC20Interface {
65 
66     // EVENTS
67 
68     event Transfer(address indexed _from, address indexed _to, uint256 _value);
69     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
70 
71     // CONSTANT METHODS
72 
73     function totalSupply() constant returns (uint256 totalSupply) {}
74     function balanceOf(address _owner) constant returns (uint256 balance) {}
75     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
76 
77     // NON-CONSTANT METHODS
78 
79     function transfer(address _to, uint256 _value) returns (bool success) {}
80     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
81     function approve(address _spender, uint256 _value) returns (bool success) {}
82 }
83 
84 contract ERC20 is ERC20Interface {
85 
86     function transfer(address _to, uint256 _value) returns (bool success) {
87         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
88             balances[msg.sender] -= _value;
89             balances[_to] += _value;
90             Transfer(msg.sender, _to, _value);
91             return true;
92         } else { throw; }
93     }
94 
95     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
96         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
97             balances[_to] += _value;
98             balances[_from] -= _value;
99             allowed[_from][msg.sender] -= _value;
100             Transfer(_from, _to, _value);
101             return true;
102         } else { throw; }
103     }
104 
105     function balanceOf(address _owner) constant returns (uint256 balance) {
106         return balances[_owner];
107     }
108 
109     function approve(address _spender, uint256 _value) returns (bool success) {
110         // See: https://github.com/ethereum/EIPs/issues/20#issuecomment-263555598
111         if (_value > 0) {
112             require(allowed[msg.sender][_spender] == 0);
113         }
114         allowed[msg.sender][_spender] = _value;
115         Approval(msg.sender, _spender, _value);
116         return true;
117     }
118 
119     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
120         return allowed[_owner][_spender];
121     }
122 
123     mapping (address => uint256) balances;
124 
125     mapping (address => mapping (address => uint256)) allowed;
126 
127     uint256 public totalSupply;
128 
129 }
130 
131 contract Vesting is DBC {
132     using safeMath for uint;
133 
134     // FIELDS
135 
136     // Constructor fields
137     ERC20 public MELON_CONTRACT; // Melon as ERC20 contract
138     // Methods fields
139     uint public totalVestedAmount; // Quantity of vested Melon in total
140     uint public vestingStartTime; // Timestamp when vesting is set
141     uint public vestingPeriod; // Total vesting period in seconds
142     address public beneficiary; // Address of the beneficiary
143     uint public withdrawn; // Quantity of Melon withdrawn so far
144 
145     // CONSTANT METHODS
146 
147     function isBeneficiary() constant returns (bool) { return msg.sender == beneficiary; }
148     function isVestingStarted() constant returns (bool) { return vestingStartTime != 0; }
149 
150     /// @notice Calculates the quantity of Melon asset that's currently withdrawable
151     /// @return withdrawable Quantity of withdrawable Melon asset
152     function calculateWithdrawable() constant returns (uint withdrawable) {
153         uint timePassed = now.sub(vestingStartTime);
154 
155         if (timePassed < vestingPeriod) {
156             uint vested = totalVestedAmount.mul(timePassed).div(vestingPeriod);
157             withdrawable = vested.sub(withdrawn);
158         } else {
159             withdrawable = totalVestedAmount.sub(withdrawn);
160         }
161     }
162 
163     // NON-CONSTANT METHODS
164 
165     /// @param ofMelonAsset Address of Melon asset
166     function Vesting(address ofMelonAsset) {
167         MELON_CONTRACT = ERC20(ofMelonAsset);
168     }
169 
170     /// @param ofBeneficiary Address of beneficiary
171     /// @param ofMelonQuantity Address of Melon asset
172     /// @param ofVestingPeriod Vesting period in seconds from vestingStartTime
173     function setVesting(address ofBeneficiary, uint ofMelonQuantity, uint ofVestingPeriod)
174         pre_cond(!isVestingStarted())
175         pre_cond(ofMelonQuantity > 0)
176     {
177         require(MELON_CONTRACT.transferFrom(msg.sender, this, ofMelonQuantity));
178         vestingStartTime = now;
179         totalVestedAmount = ofMelonQuantity;
180         vestingPeriod = ofVestingPeriod;
181         beneficiary = ofBeneficiary;
182     }
183 
184     /// @notice Withdraw
185     function withdraw()
186         pre_cond(isBeneficiary())
187         pre_cond(isVestingStarted())
188     {
189         uint withdrawable = calculateWithdrawable();
190         withdrawn = withdrawn.add(withdrawable);
191         require(MELON_CONTRACT.transfer(beneficiary, withdrawable));
192     }
193 
194 }