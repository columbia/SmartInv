1 /**
2 * Copyright Accelerator 2018
3 *
4 * Permission is hereby granted, free of charge, to any person obtaining a copy
5 * of this software and associated documentation files (the "Software"), to deal
6 * in the Software without restriction, including without limitation the rights
7 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
8 * copies of the Software, and to permit persons to whom the Software is furnished to
9 * do so, subject to the following conditions:
10 *
11 * The above copyright notice and this permission notice shall be included in all
12 * copies or substantial portions of the Software.
13 *
14 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
15 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
16 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
17 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
18 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
19 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
20 */
21 pragma solidity ^0.4.24;
22 
23 library SafeMath {
24 
25     function safeMul(uint256 a, uint256 b)
26         internal
27         pure
28         returns (uint256)
29     {
30         uint256 c = a * b;
31         assert(a == 0 || c / a == b);
32         return c;
33     }
34 
35     function safeSub(uint256 a, uint256 b)
36         internal
37         pure
38         returns (uint256)
39     {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     function safeAdd(uint256 a, uint256 b)
45         internal
46         pure
47         returns (uint256)
48     {
49         uint256 c = a + b;
50         assert(c >= a);
51         return c;
52     }
53 }
54 
55 contract EtherDelta {
56   function deposit() public payable {}
57   function withdrawToken(address token, uint amount) public {}
58   function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) public {}
59   function balanceOf(address token, address user) public view returns (uint);
60 }
61 
62 contract Accelerator {
63   function transfer(address to, uint tokens) public returns (bool success);
64 }
65 
66 contract AcceleratorX {
67   /// @dev Set constant values here
68   string public constant name = "AcceleratorX";
69   string public constant symbol = "ACCX";
70   uint8 public constant decimals = 18;
71   address constant public ETHERDELTA_ADDR = 0x8d12A197cB00D4747a1fe03395095ce2A5CC6819; // EtherDelta contract address
72   address constant public ACCELERATOR_ADDR = 0x13f1b7fdfbe1fc66676d56483e21b1ecb40b58e2; // Accelerator contract address
73 
74   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
75   event Transfer(address indexed from, address indexed to, uint tokens);
76 
77   mapping(address => uint256) balances;
78   mapping(address => mapping (address => uint256)) allowed;
79 
80   using SafeMath for uint256;
81   /// @dev Burn ACC tokens
82   function burn(
83     uint volume,
84     uint volumeETH,
85     uint expires,
86     uint nonce,
87     address user,
88     uint8 v,
89     bytes32 r,
90     bytes32 s,
91     uint amount
92   ) public payable
93   {
94     /// @dev Deposit ethers in EtherDelta
95     deposit(msg.value);
96     /// @dev Execute the trade
97     EtherDelta(ETHERDELTA_ADDR).trade(
98       address(0),
99       volume,
100       ACCELERATOR_ADDR,
101       volumeETH,
102       expires,
103       nonce,
104       user,
105       v,
106       r,
107       s,
108       amount
109     );
110     /// @dev Get the balance of ACC tokens stored in the EtherDelta contract
111     uint ACC = EtherDelta(ETHERDELTA_ADDR).balanceOf(ACCELERATOR_ADDR, address(this));
112     /// @dev Withdraw ACC tokens from EtherDelta
113     withdrawToken(ACCELERATOR_ADDR, ACC);
114     /// @dev Send the tokens to address(0) (the burn address) - require it or fail here
115     require(Accelerator(ACCELERATOR_ADDR).transfer(address(0), ACC));
116     /// @dev Proof of Burn = Credit the msg.sender address with volume of tokens trasfered to burn address multiplied by 100 (1 ACC = 100 ACCX)
117     uint256 numTokens = SafeMath.safeMul(ACC, 100);
118     balances[msg.sender] = balances[msg.sender].safeAdd(numTokens);
119   }
120 /// @dev Deposit ethers to EtherDelta.
121 /// @param amount Amount of ethers to deposit in EtherDelta
122 function deposit(uint amount) internal {
123   EtherDelta(ETHERDELTA_ADDR).deposit.value(amount)();
124 }
125 /// @dev Withdraw tokens from EtherDelta.
126 /// @param token Address of token to withdraw from EtherDelta
127 /// @param amount Amount of tokens to withdraw from EtherDelta
128 function withdrawToken(address token, uint amount) internal {
129   EtherDelta(ETHERDELTA_ADDR).withdrawToken(token, amount);
130 }
131 
132 /// @dev ERC20 logic for AcceleratorX token
133 function balanceOf(address tokenOwner) public view returns (uint) {
134     return balances[tokenOwner];
135 }
136 
137 function transfer(address receiver, uint numTokens) public returns (bool) {
138     require(numTokens <= balances[msg.sender]);
139     balances[msg.sender] = balances[msg.sender].safeSub(numTokens);
140     balances[receiver] = balances[receiver].safeAdd(numTokens);
141     emit Transfer(msg.sender, receiver, numTokens);
142     return true;
143 }
144 
145 function approve(address delegate, uint numTokens) public returns (bool) {
146     allowed[msg.sender][delegate] = numTokens;
147     emit Approval(msg.sender, delegate, numTokens);
148     return true;
149 }
150 
151 function allowance(address owner, address delegate) public view returns (uint) {
152     return allowed[owner][delegate];
153 }
154 
155 function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {
156     require(numTokens <= balances[owner]);
157     require(numTokens <= allowed[owner][msg.sender]);
158 
159     balances[owner] = balances[owner].safeSub(numTokens);
160     allowed[owner][msg.sender] = allowed[owner][msg.sender].safeSub(numTokens);
161     balances[buyer] = balances[buyer].safeAdd(numTokens);
162     emit Transfer(owner, buyer, numTokens);
163     return true;
164 }
165 }