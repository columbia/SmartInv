1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 contract ERC20Basic {
51   function totalSupply() public view returns (uint256);
52   function balanceOf(address who) public view returns (uint256);
53   function transfer(address to, uint256 value) public returns (bool);
54   event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 contract ERC20 is ERC20Basic {
58   function allowance(address owner, address spender) public view returns (uint256);
59   function transferFrom(address from, address to, uint256 value) public returns (bool);
60   function approve(address spender, uint256 value) public returns (bool);
61   event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 contract WETH9 {
65     string public name     = "Wrapped Ether";
66     string public symbol   = "WETH";
67     uint8  public decimals = 18;
68 
69     event  Approval(address indexed src, address indexed guy, uint wad);
70     event  Transfer(address indexed src, address indexed dst, uint wad);
71     event  Deposit(address indexed dst, uint wad);
72     event  Withdrawal(address indexed src, uint wad);
73 
74     mapping (address => uint)                       public  balanceOf;
75     mapping (address => mapping (address => uint))  public  allowance;
76 
77     function() public payable {
78         deposit();
79     }
80     function deposit() public payable {
81         balanceOf[msg.sender] += msg.value;
82         Deposit(msg.sender, msg.value);
83     }
84     function withdraw(uint wad) public {
85         require(balanceOf[msg.sender] >= wad);
86         balanceOf[msg.sender] -= wad;
87         msg.sender.transfer(wad);
88         Withdrawal(msg.sender, wad);
89     }
90 
91     function totalSupply() public view returns (uint) {
92         return this.balance;
93     }
94 
95     function approve(address guy, uint wad) public returns (bool) {
96         allowance[msg.sender][guy] = wad;
97         Approval(msg.sender, guy, wad);
98         return true;
99     }
100 
101     function transfer(address dst, uint wad) public returns (bool) {
102         return transferFrom(msg.sender, dst, wad);
103     }
104 
105     function transferFrom(address src, address dst, uint wad)
106         public
107         returns (bool)
108     {
109         require(balanceOf[src] >= wad);
110 
111         if (src != msg.sender && allowance[src][msg.sender] != uint(-1)) {
112             require(allowance[src][msg.sender] >= wad);
113             allowance[src][msg.sender] -= wad;
114         }
115 
116         balanceOf[src] -= wad;
117         balanceOf[dst] += wad;
118 
119         Transfer(src, dst, wad);
120 
121         return true;
122     }
123 }
124 
125 
126 interface Registry {
127     function isAffiliated(address _affiliate) external returns (bool);
128 }
129 
130 contract Affiliate {
131   struct Share {
132       address shareholder;
133       uint stake;
134   }
135 
136   Share[] shares;
137   uint public totalShares;
138   string public relayerName;
139   address registry;
140   WETH9 weth;
141 
142   event Payout(address indexed token, uint amount);
143 
144   function init(address _registry, address[] shareholders, uint[] stakes, address _weth, string _name) public returns (bool) {
145     require(totalShares == 0);
146     require(shareholders.length == stakes.length);
147     weth = WETH9(_weth);
148     totalShares = 0;
149     for(uint i=0; i < shareholders.length; i++) {
150         shares.push(Share({shareholder: shareholders[i], stake: stakes[i]}));
151         totalShares += stakes[i];
152     }
153     relayerName = _name;
154     registry = _registry;
155     return true;
156   }
157   function payout(address[] tokens) public {
158       // Payout all stakes at once, so we don't have to do bookkeeping on who has
159       // claimed their shares and who hasn't. If the number of shareholders is large
160       // this could run into some gas limits. In most cases, I expect two
161       // shareholders, but it could be a small handful. This also means the caller
162       // must pay gas for everyone's payouts.
163       for(uint i=0; i < tokens.length; i++) {
164           ERC20 token = ERC20(tokens[i]);
165           uint balance = token.balanceOf(this);
166           for(uint j=0; j < shares.length; j++) {
167               token.transfer(shares[j].shareholder, SafeMath.mul(balance, shares[j].stake) / totalShares);
168           }
169           emit Payout(tokens[i], balance);
170       }
171   }
172   function isAffiliated(address _affiliate) public returns (bool)
173   {
174       return Registry(registry).isAffiliated(_affiliate);
175   }
176 
177   function() public payable {
178     // If we get paid in ETH, convert to WETH so payouts work the same.
179     // Converting to WETH also makes payouts a bit safer, as we don't have to
180     // worry about code execution if the stakeholder is a contract.
181     weth.deposit.value(msg.value)();
182   }
183 
184 }