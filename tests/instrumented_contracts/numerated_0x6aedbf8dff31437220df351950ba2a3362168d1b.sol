1 pragma solidity ^0.4.13;
2 
3 contract ERC20Interface {
4 
5     // Get total token supply
6     function totalSupply()
7     public constant returns (uint256 _totalSupply);
8 
9     // Get specific account balance
10     function balanceOf(address _owner)
11     public constant returns (uint256 balance);
12 
13     // Send _value tokens to the address _to
14     function transfer(address _to, uint256 _value)
15     public returns (bool success);
16 
17     // Send _value of tokens from address one address to another (withdraw)
18     function transferFrom(address _from, address _to, uint256 _value)
19     public returns (bool success);
20 
21     // Allow _spender to withdraw from sender account _value times
22     function approve(address _spender, uint256 _value)
23     public returns (bool success);
24 
25     // Get the amount which _spender is allowed to withdraw from _owner
26     function allowance(address _owner, address _spender)
27     public constant returns (uint256 remaining);
28 
29     // Triggered when tokens are transferred.
30     event Transfer(address indexed _from, address indexed _to, uint256 _value);
31 
32     // Triggered whenever approve(...) is called.
33     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 }
35 
36 contract DGS is ERC20Interface {
37 
38     string public constant NAME = "Dragonglass";
39     string public constant SYMBOL = "DGS";
40     uint public constant DECIMALS = 8;
41 
42     uint256 supply = 0;
43     mapping(address => uint256) balances;
44     mapping(address => mapping (address => uint256)) allowed;
45 
46     mapping (address => uint) allowedToMine;
47 
48     address public allocationAddressICO;
49 
50     uint256 public mineableSupply = 0;
51 
52     address founder;
53 
54 
55     uint public constant DECIMAL_INDEX = 10**DECIMALS;
56 
57     // Miner constants
58     //Represents constant 0,25892541
59     uint private constant MINING_PERCENTAGE = 25892541;
60     uint private constant STAKE_PERCENTAGE = 5 * DECIMAL_INDEX / 100;
61 
62     function DGS (uint256 _initial,
63         address _founder) public {
64             supply = _initial;
65             mineableSupply = supply * 10;
66             founder = _founder;
67     }
68 
69     modifier onlyFounder {
70         require(msg.sender == founder);
71         _;
72     }
73 
74     function totalSupply()
75     public constant returns (uint256 _totalSupply) {
76         _totalSupply = supply;
77     }
78 
79     function balanceOf(address _owner)
80     public constant returns (uint256 balance) {
81         return balances[_owner];
82     }
83 
84     function getAllowedToMine(address _owner)
85     public constant returns (uint _allowedToMine) {
86         return allowedToMine[_owner];
87     }
88 
89     // Get available for mining supply
90     function getMineableSupply()
91     public constant returns (uint256 _mineableSupply){
92         _mineableSupply = mineableSupply;
93     }
94 
95     function transfer(address _to, uint256 _value)
96     public returns (bool success) {
97         require(_to != address(0));
98         require(balances[msg.sender] >= _value);
99         balances[msg.sender] -= _value;
100         mine(msg.sender, _to, _value);
101         balances[_to] += _value;
102         Transfer(msg.sender, _to, _value);
103         return true;
104     }
105 
106     function transferFrom(address _from, address _to, uint256 _value)
107     public returns (bool success) {
108         uint256 allowance = allowed[_from][msg.sender];
109         require(_to != address(0) && balances[_from] >= _value
110             && allowance >= _value);
111             balances[_from] -= _value;
112             mine(_from, _to, _value);
113             balances[_to] += _value;
114             allowed[_from][msg.sender] -= _value;
115             Transfer(_from, _to, _value);
116             return true;
117     }
118 
119     function approve(address _spender, uint256 _value)
120     public returns (bool success){
121         allowed[msg.sender][_spender] = _value;
122         Approval(msg.sender, _spender, _value);
123         return true;
124     }
125 
126     function allowance(address _owner, address _spender)
127     public constant returns (uint256 remaining){
128         return  allowed[_owner][_spender];
129     }
130 
131     function setIcoAddress(address _icoAddress) public onlyFounder() {
132         require(allocationAddressICO == address(0));
133         allocationAddressICO = _icoAddress;
134         balances[allocationAddressICO] = totalSupply();
135     }
136 
137     function calculateMinedCoinsForTX(uint stake, uint _value)
138     public pure returns (uint _minedAmount) {
139 
140         var _max = SafeMath.max256(_value, stake);
141         var _min = SafeMath.min256(_value, stake);
142 
143         uint factor = _min * DECIMAL_INDEX /_max;
144 
145         if(_value > stake)
146             factor += factor * STAKE_PERCENTAGE / DECIMAL_INDEX;
147         if(factor > DECIMAL_INDEX)
148             factor = DECIMAL_INDEX;
149 
150         var totalStake = stake + _value;
151         var factorInCoins = totalStake * factor / DECIMAL_INDEX;
152 
153         _minedAmount = factorInCoins *  MINING_PERCENTAGE / DECIMAL_INDEX;
154     }
155 
156     function mine
157     (address _sender, address _receiver, uint _transactionValue) private {
158         if(_sender == allocationAddressICO) {
159             // Allow to mine x10
160             allowedToMine[_receiver] += _transactionValue * 10;
161         } else {
162             doMining(_sender, _transactionValue);
163         }
164     }
165 
166     function doMining(address _miner, uint _transactionValue)
167     private {
168         uint _minedAmount = calculateMinedCoinsForTX(balanceOf(_miner), _transactionValue);
169         if(allowedToMine[_miner] <= _minedAmount) {
170             _minedAmount = allowedToMine[_miner];
171             allowedToMine[_miner] = 0;
172         } else {
173             allowedToMine[_miner] -= _minedAmount;
174         }
175         balances[_miner] += _minedAmount;
176         supply += _minedAmount;
177         mineableSupply -= _minedAmount;
178         Mined(_miner, _minedAmount);
179     }
180 
181     event Mined(address indexed _miner, uint256 _minedAmount);
182 }
183 
184 library SafeMath {
185   function mul(uint a, uint b) internal pure returns (uint) {
186     uint c = a * b;
187     assert(a == 0 || c / a == b);
188     return c;
189   }
190 
191   function div(uint a, uint b) internal pure returns (uint) {
192     uint c = a / b;
193     return c;
194   }
195 
196   function sub(uint a, uint b) internal pure returns (uint) {
197     assert(b <= a);
198     return a - b;
199   }
200 
201   function add(uint a, uint b) internal pure returns (uint) {
202     uint c = a + b;
203     assert(c >= a);
204     return c;
205   }
206 
207   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
208     return a >= b ? a : b;
209   }
210 
211   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
212     return a < b ? a : b;
213   }
214 
215   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
216     return a >= b ? a : b;
217   }
218 
219   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
220     return a < b ? a : b;
221   }
222 }