1 pragma solidity ^0.4.13;
2 
3 contract DBC {
4 
5     // MODIFIERS
6 
7     modifier pre_cond(bool condition) {
8         require(condition);
9         _;
10     }
11 
12     modifier post_cond(bool condition) {
13         _;
14         assert(condition);
15     }
16 
17     modifier invariant(bool condition) {
18         require(condition);
19         _;
20         assert(condition);
21     }
22 }
23 
24 contract ERC20Interface {
25 
26     // EVENTS
27 
28     event Transfer(address indexed _from, address indexed _to, uint256 _value);
29     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
30 
31     // CONSTANT METHODS
32 
33     function totalSupply() constant returns (uint256 totalSupply) {}
34     function balanceOf(address _owner) constant returns (uint256 balance) {}
35     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
36 
37     // NON-CONSTANT METHODS
38 
39     function transfer(address _to, uint256 _value) returns (bool success) {}
40     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
41     function approve(address _spender, uint256 _value) returns (bool success) {}
42 }
43 
44 contract ERC20 is ERC20Interface {
45 
46     function transfer(address _to, uint256 _value) returns (bool success) {
47         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
48             balances[msg.sender] -= _value;
49             balances[_to] += _value;
50             Transfer(msg.sender, _to, _value);
51             return true;
52         } else { throw; }
53     }
54 
55     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
56         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
57             balances[_to] += _value;
58             balances[_from] -= _value;
59             allowed[_from][msg.sender] -= _value;
60             Transfer(_from, _to, _value);
61             return true;
62         } else { throw; }
63     }
64 
65     function balanceOf(address _owner) constant returns (uint256 balance) {
66         return balances[_owner];
67     }
68 
69     function approve(address _spender, uint256 _value) returns (bool success) {
70         // See: https://github.com/ethereum/EIPs/issues/20#issuecomment-263555598
71         if (_value > 0) {
72             require(allowed[msg.sender][_spender] == 0);
73         }
74         allowed[msg.sender][_spender] = _value;
75         Approval(msg.sender, _spender, _value);
76         return true;
77     }
78 
79     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
80         return allowed[_owner][_spender];
81     }
82 
83     mapping (address => uint256) balances;
84 
85     mapping (address => mapping (address => uint256)) allowed;
86 
87     uint256 public totalSupply;
88 
89 }
90 
91 contract Owned {
92 
93     // FIELDS
94 
95     address public owner;
96 
97     // PRE, POST, INVARIANT CONDITIONS
98 
99     function isOwner() internal returns (bool) { return msg.sender == owner; }
100 
101     // NON-CONSTANT METHODS
102 
103     function Owned() { owner = msg.sender; }
104 
105 }
106 
107 contract Vesting is DBC, Owned {
108     using safeMath for uint;
109 
110     // FIELDS
111 
112     // Constructor fields
113     ERC20 public MELON_CONTRACT; // Melon as ERC20 contract
114     // Methods fields
115     uint public totalVestedAmount; // Quantity of vested Melon in total
116     uint public vestingStartTime; // Timestamp when vesting is set
117     uint public vestingPeriod; // Total vesting period
118     address public beneficiary; // Address of the beneficiary
119     bool public revoked; // Whether vesting is revoked
120     uint public withdrawnByBeneficiary; // To keep track of Melon withdrawn only by the beneficiary (Set only in the case of revoke)
121 
122     // CONSTANT METHODS
123 
124     function isBeneficiary() constant returns (bool) { return msg.sender == beneficiary; }
125     function isVestingStarted() constant returns (bool) { return totalVestedAmount != 0; }
126     function isVestingRevoked() constant returns (bool) { return revoked; }
127     function withdrawnMelon() constant returns (uint) {
128         return revoked ? withdrawnByBeneficiary : totalVestedAmount.sub(MELON_CONTRACT.balanceOf(this));
129     }
130 
131     /// @notice Calculates the quantity of Melon asset that's currently withdrawable
132     /// @return withdrawable Quantity of withdrawable Melon asset
133     function calculateWithdrawable() constant returns (uint withdrawable) {
134         uint timePassed = now.sub(vestingStartTime);
135 
136         if (timePassed < vestingPeriod) {
137             uint vested = totalVestedAmount.mul(timePassed).div(vestingPeriod);
138             withdrawable = vested.sub(withdrawnMelon());
139         } else {
140             withdrawable = totalVestedAmount.sub(withdrawnMelon());
141         }
142     }
143 
144     // NON-CONSTANT METHODS
145 
146     /// @param ofMelonAsset Address of Melon asset
147     function Vesting(address ofMelonAsset) {
148         MELON_CONTRACT = ERC20(ofMelonAsset);
149     }
150 
151     /// @param ofBeneficiary Address of beneficiary
152     /// @param ofMelonQuantity Address of Melon asset
153     /// @param ofVestingPeriod Address of Melon asset
154     function setVesting(address ofBeneficiary, uint ofMelonQuantity, uint ofVestingPeriod)
155         pre_cond(!isVestingStarted())
156     {
157         assert(MELON_CONTRACT.transferFrom(msg.sender, this, ofMelonQuantity));
158         vestingStartTime = now;
159         totalVestedAmount = ofMelonQuantity;
160         vestingPeriod = ofVestingPeriod;
161         beneficiary = ofBeneficiary;
162     }
163 
164     /// @notice Withdraw
165     function withdraw()
166         pre_cond(isBeneficiary())
167         pre_cond(isVestingStarted())
168     {
169         uint withdrawable = revoked ? MELON_CONTRACT.balanceOf(this) : calculateWithdrawable();
170         assert(MELON_CONTRACT.transfer(beneficiary, withdrawable));
171     }
172 
173     /// @notice Stops vesting and transfers the totalVestedAmount minus the withdrawable amount at the current time to the contract creator
174     function revokeAndReclaim()
175         pre_cond(isOwner())
176         pre_cond(!isVestingRevoked())
177     {
178         uint reclaimable = totalVestedAmount.sub(calculateWithdrawable());
179         withdrawnByBeneficiary = withdrawnMelon();
180         revoked = true;
181         assert(MELON_CONTRACT.transfer(owner, reclaimable));
182     }
183 
184 }
185 
186 library safeMath {
187   function mul(uint a, uint b) internal returns (uint) {
188     uint c = a * b;
189     assert(a == 0 || c / a == b);
190     return c;
191   }
192 
193   function div(uint a, uint b) internal returns (uint) {
194     uint c = a / b;
195     return c;
196   }
197 
198   function sub(uint a, uint b) internal returns (uint) {
199     assert(b <= a);
200     return a - b;
201   }
202 
203   function add(uint a, uint b) internal returns (uint) {
204     uint c = a + b;
205     assert(c >= a);
206     return c;
207   }
208 
209   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
210     return a >= b ? a : b;
211   }
212 
213   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
214     return a < b ? a : b;
215   }
216 
217   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
218     return a >= b ? a : b;
219   }
220 
221   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
222     return a < b ? a : b;
223   }
224 }