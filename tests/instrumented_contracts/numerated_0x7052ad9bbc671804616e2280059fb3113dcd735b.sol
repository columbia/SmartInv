1 pragma solidity ^0.4.18;
2 
3  /// @title Ownable contract - base contract with an owner
4 contract Ownable {
5   address public owner;
6 
7   function Ownable() public {
8     owner = msg.sender;
9   }
10 
11   modifier onlyOwner() {
12     require(msg.sender == owner);
13     _;
14   }
15 
16   function transferOwnership(address newOwner) public onlyOwner {
17     if (newOwner != address(0)) {
18       owner = newOwner;
19     }
20   }
21 }
22 
23  /// @title SafeMath contract - math operations with safety checks
24 contract SafeMath {
25   function safeMul(uint a, uint b) internal pure  returns (uint) {
26     uint c = a * b;
27     assert(a == 0 || c / a == b);
28     return c;
29   }
30 
31   function safeDiv(uint a, uint b) internal pure returns (uint) {
32     assert(b > 0);
33     uint c = a / b;
34     assert(a == b * c + a % b);
35     return c;
36   }
37 
38   function safeSub(uint a, uint b) internal pure returns (uint) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   function safeAdd(uint a, uint b) internal pure returns (uint) {
44     uint c = a + b;
45     assert(c>=a && c>=b);
46     return c;
47   }
48 
49   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
50     return a >= b ? a : b;
51   }
52 
53   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
54     return a < b ? a : b;
55   }
56 
57   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
58     return a >= b ? a : b;
59   }
60 
61   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
62     return a < b ? a : b;
63   }
64 }
65 
66  /// @title ERC20 interface see https://github.com/ethereum/EIPs/issues/20
67 contract ERC20 {
68   uint public totalSupply;
69   function balanceOf(address who) public constant returns (uint);
70   function allowance(address owner, address spender) public constant returns (uint);  
71   function transfer(address to, uint value) public returns (bool ok);
72   function transferFrom(address from, address to, uint value) public returns (bool ok);
73   function approve(address spender, uint value) public returns (bool ok);
74   function decimals() public constant returns (uint value);
75   event Transfer(address indexed from, address indexed to, uint value);
76   event Approval(address indexed owner, address indexed spender, uint value);
77 }
78 
79 contract SilentNotaryTokenStorage is SafeMath, Ownable {
80 
81   /// Information about frozen portion of tokens
82   struct FrozenPortion {
83     /// Earliest time when this portion will become available
84     uint unfreezeTime;
85 
86     /// Frozen balance portion, in percents
87     uint portionPercent;
88 
89     /// Frozen token amount
90     uint portionAmount;
91 
92     /// Is this portion unfrozen (withdrawn) after freeze period has finished
93     bool isUnfrozen;
94   }
95 
96   /// Specified amount of tokens was unfrozen
97   event Unfrozen(uint tokenAmount);
98 
99   /// SilentNotary token contract
100   ERC20 public token;
101 
102   /// All frozen portions of the contract token balance
103   FrozenPortion[] public frozenPortions;
104 
105   /// Team wallet to withdraw unfrozen tokens
106   address public teamWallet;
107 
108   /// Deployment time of this contract, which is also the start point to count freeze periods
109   uint public deployedTime;
110 
111   /// Is current token amount fixed (must be to unfreeze)
112   bool public amountFixed;
113 
114   /// @dev Constructor
115   /// @param _token SilentNotary token contract address
116   /// @param _teamWallet Wallet address to withdraw unfrozen tokens
117   /// @param _freezePeriods Ordered array of freeze periods
118   /// @param _freezePortions Ordered array of balance portions to freeze, in percents
119   function SilentNotaryTokenStorage (address _token, address _teamWallet, uint[] _freezePeriods, uint[] _freezePortions) public {
120     require(_token > 0);
121     require(_teamWallet > 0);
122     require(_freezePeriods.length > 0);
123     require(_freezePeriods.length == _freezePortions.length);
124 
125     token = ERC20(_token);
126     teamWallet = _teamWallet;
127     deployedTime = now;
128 
129     var cumulativeTime = deployedTime;
130     uint cumulativePercent = 0;
131     for (uint i = 0; i < _freezePeriods.length; i++) {
132       require(_freezePortions[i] > 0 && _freezePortions[i] <= 100);
133       cumulativePercent = safeAdd(cumulativePercent, _freezePortions[i]);
134       cumulativeTime = safeAdd(cumulativeTime, _freezePeriods[i]);
135       frozenPortions.push(FrozenPortion({
136         portionPercent: _freezePortions[i],
137         unfreezeTime: cumulativeTime,
138         portionAmount: 0,
139         isUnfrozen: false}));
140     }
141     assert(cumulativePercent == 100);
142   }
143 
144   /// @dev Unfreeze currently available amount of tokens
145   function unfreeze() public onlyOwner {
146     require(amountFixed);
147 
148     uint unfrozenTokens = 0;
149     for (uint i = 0; i < frozenPortions.length; i++) {
150       var portion = frozenPortions[i];
151       if (portion.isUnfrozen)
152         continue;
153       if (portion.unfreezeTime < now) {
154         unfrozenTokens = safeAdd(unfrozenTokens, portion.portionAmount);
155         portion.isUnfrozen = true;
156       }
157       else
158         break;
159     }
160     transferTokens(unfrozenTokens);
161   }
162 
163   /// @dev Fix current token amount (calculate absolute values of every portion)
164   function fixAmount() public onlyOwner {
165     require(!amountFixed);
166     amountFixed = true;
167 
168     uint currentBalance = token.balanceOf(this);
169     for (uint i = 0; i < frozenPortions.length; i++) {
170       var portion = frozenPortions[i];
171       portion.portionAmount = safeDiv(safeMul(currentBalance, portion.portionPercent), 100);
172     }
173   }
174 
175   /// @dev Withdraw remaining tokens after all freeze periods are over (in case there were additional token transfers)
176   function withdrawRemainder() public onlyOwner {
177     for (uint i = 0; i < frozenPortions.length; i++) {
178       if (!frozenPortions[i].isUnfrozen)
179         revert();
180     }
181     transferTokens(token.balanceOf(this));
182   }
183 
184   function transferTokens(uint tokenAmount) private {
185     require(tokenAmount > 0);
186     var transferSuccess = token.transfer(teamWallet, tokenAmount);
187     assert(transferSuccess);
188     Unfrozen(tokenAmount);
189   }
190 }