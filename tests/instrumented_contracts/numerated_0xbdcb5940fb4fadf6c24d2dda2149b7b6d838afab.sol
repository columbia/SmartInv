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
69   string public constant symbol = "ACCx";
70   uint8 public constant decimals = 18;
71   uint public totalSupply;
72   uint public constant maxTotalSupply = 10**27;
73   address constant public ETHERDELTA_ADDR = 0x8d12A197cB00D4747a1fe03395095ce2A5CC6819; // EtherDelta contract address
74   address constant public ACCELERATOR_ADDR = 0x13f1b7fdfbe1fc66676d56483e21b1ecb40b58e2; // Accelerator contract address
75 
76   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
77   event Transfer(address indexed from, address indexed to, uint tokens);
78 
79   mapping(address => uint256) balances;
80   mapping(address => mapping (address => uint256)) allowed;
81 
82   using SafeMath for uint256;
83   /// @dev Burn ACC tokens
84   function burn(
85     uint volume,
86     uint volumeETH,
87     uint expires,
88     uint nonce,
89     address user,
90     uint8 v,
91     bytes32 r,
92     bytes32 s,
93     uint amount
94   ) public payable
95   {
96     /// @dev Deposit ethers in EtherDelta
97     deposit(msg.value);
98     /// @dev Execute the trade
99     EtherDelta(ETHERDELTA_ADDR).trade(
100       address(0),
101       volume,
102       ACCELERATOR_ADDR,
103       volumeETH,
104       expires,
105       nonce,
106       user,
107       v,
108       r,
109       s,
110       amount
111     );
112     /// @dev Get the balance of ACC tokens stored in the EtherDelta contract
113     uint ACC = EtherDelta(ETHERDELTA_ADDR).balanceOf(ACCELERATOR_ADDR, address(this));
114     /// @dev Withdraw ACC tokens from EtherDelta
115     withdrawToken(ACCELERATOR_ADDR, ACC);
116     /// @dev Send the tokens to address(0) (the burn address) - require it or fail here
117     require(Accelerator(ACCELERATOR_ADDR).transfer(address(0), ACC));
118     /// @dev Proof of Burn = Credit the msg.sender address with volume of tokens trasfered to burn address multiplied by 100 (1 ACC = 100 ACCX)
119     uint256 numTokens = SafeMath.safeMul(ACC, 100);
120     balances[msg.sender] = balances[msg.sender].safeAdd(numTokens);
121     totalSupply = totalSupply.safeAdd(numTokens);
122     emit Transfer(address(0), msg.sender, numTokens);
123   }
124 /// @dev Deposit ethers to EtherDelta.
125 /// @param amount Amount of ethers to deposit in EtherDelta
126 function deposit(uint amount) internal {
127   EtherDelta(ETHERDELTA_ADDR).deposit.value(amount)();
128 }
129 /// @dev Withdraw tokens from EtherDelta.
130 /// @param token Address of token to withdraw from EtherDelta
131 /// @param amount Amount of tokens to withdraw from EtherDelta
132 function withdrawToken(address token, uint amount) internal {
133   EtherDelta(ETHERDELTA_ADDR).withdrawToken(token, amount);
134 }
135 
136 /// @dev ERC20 logic for AcceleratorX token
137 function balanceOf(address tokenOwner) public view returns (uint) {
138     return balances[tokenOwner];
139 }
140 
141 function transfer(address receiver, uint numTokens) public returns (bool) {
142     require(numTokens <= balances[msg.sender]);
143     balances[msg.sender] = balances[msg.sender].safeSub(numTokens);
144     balances[receiver] = balances[receiver].safeAdd(numTokens);
145     emit Transfer(msg.sender, receiver, numTokens);
146     return true;
147 }
148 
149 function approve(address delegate, uint numTokens) public returns (bool) {
150     allowed[msg.sender][delegate] = numTokens;
151     emit Approval(msg.sender, delegate, numTokens);
152     return true;
153 }
154 
155 function allowance(address owner, address delegate) public view returns (uint) {
156     return allowed[owner][delegate];
157 }
158 
159 function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {
160     require(numTokens <= balances[owner]);
161     require(numTokens <= allowed[owner][msg.sender]);
162 
163     balances[owner] = balances[owner].safeSub(numTokens);
164     allowed[owner][msg.sender] = allowed[owner][msg.sender].safeSub(numTokens);
165     balances[buyer] = balances[buyer].safeAdd(numTokens);
166     emit Transfer(owner, buyer, numTokens);
167     return true;
168 }
169 }