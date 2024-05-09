1 // SPDX-License-Identifier: GPL-3.0-only
2 
3 pragma solidity 0.7.4;
4 
5 library SafeMathLib {
6   function times(uint a, uint b) public pure returns (uint) {
7     uint c = a * b;
8     require(a == 0 || c / a == b, 'Overflow detected');
9     return c;
10   }
11 
12   function minus(uint a, uint b) public pure returns (uint) {
13     require(b <= a, 'Underflow detected');
14     return a - b;
15   }
16 
17   function plus(uint a, uint b) public pure returns (uint) {
18     uint c = a + b;
19     require(c>=a && c>=b, 'Overflow detected');
20     return c;
21   }
22 
23 }
24 
25 
26 
27 contract Token {
28     using SafeMathLib for uint;
29 
30     mapping (address => uint) balances;
31     mapping (address => mapping (address => uint)) allowed;
32     mapping (uint => FrozenTokens) public frozenTokensMap;
33 
34     event Transfer(address indexed sender, address indexed receiver, uint value);
35     event Approval(address approver, address spender, uint value);
36     event TokensFrozen(address indexed freezer, uint amount, uint id, uint lengthFreezeDays);
37     event TokensUnfrozen(address indexed unfreezer, uint amount, uint id);
38     event TokensBurned(address burner, uint amount);
39     event TokensMinted(address recipient, uint amount);
40     event BankUpdated(address oldBank, address newBank);
41 
42     uint8 constant public decimals = 18;
43     string constant public symbol = "FVT";
44     string constant public name = "Finance.Vote Token";
45     uint public totalSupply;
46     uint numFrozenStructs;
47     address public bank;
48 
49     struct FrozenTokens {
50         uint id;
51         uint dateFrozen;
52         uint lengthFreezeDays;
53         uint amount;
54         bool frozen;
55         address owner;
56     }
57 
58     // simple initialization, giving complete token supply to one address
59     constructor(address _bank) {
60         bank = _bank;
61         require(bank != address(0), 'Must initialize with nonzero address');
62         uint totalInitialBalance = 1e9 * 1 ether;
63         balances[bank] = totalInitialBalance;
64         totalSupply = totalInitialBalance;
65         emit Transfer(address(0), bank, totalInitialBalance);
66     }
67 
68     modifier bankOnly() {
69         require (msg.sender == bank, 'Only bank address may call this');
70         _;
71     }
72 
73     function setBank(address newBank) public bankOnly {
74         address oldBank = bank;
75         bank = newBank;
76         emit BankUpdated(oldBank, newBank);
77     }
78 
79     // freeze tokens for a certain number of days
80     function freeze(uint amount, uint freezeDays) public {
81         require(amount > 0, 'Cannot freeze 0 tokens');
82         // move tokens into this contract's address from sender
83         balances[msg.sender] = balances[msg.sender].minus(amount);
84         balances[address(this)] = balances[address(this)].plus(amount);
85         numFrozenStructs = numFrozenStructs.plus(1);
86         frozenTokensMap[numFrozenStructs] = FrozenTokens(numFrozenStructs, block.timestamp, freezeDays, amount, true, msg.sender);
87         emit Transfer(msg.sender, address(this), amount);
88         emit TokensFrozen(msg.sender, amount, numFrozenStructs, freezeDays);
89     }
90 
91     // unfreeze frozen tokens
92     function unFreeze(uint id) public {
93         FrozenTokens storage f = frozenTokensMap[id];
94         require(f.dateFrozen + (f.lengthFreezeDays * 1 days) < block.timestamp, 'May not unfreeze until freeze time is up');
95         require(f.frozen, 'Can only unfreeze frozen tokens');
96         f.frozen = false;
97         // move tokens back into owner's address from this contract's address
98         balances[f.owner] = balances[f.owner].plus(f.amount);
99         balances[address(this)] = balances[address(this)].minus(f.amount);
100         emit Transfer(address(this), msg.sender, f.amount);
101         emit TokensUnfrozen(f.owner, f.amount, id);
102     }
103 
104     // burn tokens, taking them out of supply
105     function burn(uint amount) public {
106         balances[msg.sender] = balances[msg.sender].minus(amount);
107         totalSupply = totalSupply.minus(amount);
108         emit Transfer(msg.sender, address(0), amount);
109         emit TokensBurned(msg.sender, amount);
110     }
111 
112     function mint(address recipient, uint amount) public bankOnly {
113         uint totalAmount = amount * 1 ether;
114         balances[recipient] = balances[recipient].plus(totalAmount);
115         totalSupply = totalSupply.plus(totalAmount);
116         emit Transfer(address(0), recipient, totalAmount);
117         emit TokensMinted(recipient, totalAmount);
118     }
119 
120     // burn tokens for someone else, subject to approval
121     function burnFor(address burned, uint amount) public {
122         uint currentAllowance = allowed[burned][msg.sender];
123 
124         // deduct
125         balances[burned] = balances[burned].minus(amount);
126 
127         // adjust allowance
128         allowed[burned][msg.sender] = currentAllowance.minus(amount);
129 
130         totalSupply = totalSupply.minus(amount);
131 
132         emit Transfer(burned, address(0), amount);
133         emit TokensBurned(burned, amount);
134     }
135 
136     // transfer tokens
137     function transfer(address to, uint value) public returns (bool success)
138     {
139         if (to == address(0)) {
140             burn(value);
141         } else {
142             // deduct
143             balances[msg.sender] = balances[msg.sender].minus(value);
144             // add
145             balances[to] = balances[to].plus(value);
146 
147             emit Transfer(msg.sender, to, value);
148         }
149         return true;
150     }
151 
152     // transfer someone else's tokens, subject to approval
153     function transferFrom(address from, address to, uint value) public returns (bool success)
154     {
155         if (to == address(0)) {
156             burnFor(from, value);
157         } else {
158             uint currentAllowance = allowed[from][msg.sender];
159 
160             // deduct
161             balances[from] = balances[from].minus(value);
162 
163             // add
164             balances[to] = balances[to].plus(value);
165 
166             // adjust allowance
167             allowed[from][msg.sender] = currentAllowance.minus(value);
168 
169             emit Transfer(from, to, value);
170         }
171         return true;
172     }
173 
174     // retrieve the balance of address
175     function balanceOf(address owner) public view returns (uint balance) {
176         return balances[owner];
177     }
178 
179     // approve another address to transfer a specific amount of tokens
180     function approve(address spender, uint value) public returns (bool success) {
181         allowed[msg.sender][spender] = value;
182         emit Approval(msg.sender, spender, value);
183         return true;
184     }
185 
186     // incrementally increase approval, see https://github.com/ethereum/EIPs/issues/738
187     function increaseApproval(address spender, uint value) public returns (bool success) {
188         allowed[msg.sender][spender] = allowed[msg.sender][spender].plus(value);
189         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
190         return true;
191     }
192 
193     // incrementally decrease approval, see https://github.com/ethereum/EIPs/issues/738
194     function decreaseApproval(address spender, uint decreaseValue) public returns (bool success) {
195         uint oldValue = allowed[msg.sender][spender];
196         // allow decreasing too much, to prevent griefing via front-running
197         if (decreaseValue >= oldValue) {
198             allowed[msg.sender][spender] = 0;
199         } else {
200             allowed[msg.sender][spender] = oldValue.minus(decreaseValue);
201         }
202         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
203         return true;
204     }
205 
206     // retrieve allowance for a given owner, spender pair of addresses
207     function allowance(address owner, address spender) public view returns (uint remaining) {
208         return allowed[owner][spender];
209     }
210 
211     function numCoinsFrozen() public view returns (uint) {
212         return balances[address(this)];
213     }}