1 pragma solidity ^0.4.4;
2 
3 
4 /*
5  * Ownable
6  *
7  * Base contract with an owner.
8  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
9  */
10 contract Ownable {
11   address public owner;
12 
13   function Ownable() {
14     owner = msg.sender;
15   }
16 
17   modifier onlyOwner() {
18     if (msg.sender != owner) throw;
19     _;
20   }
21 
22   function transferOwnership(address newOwner) onlyOwner {
23     if (newOwner != address(0)) owner = newOwner;
24   }
25 
26 }
27 
28 contract SafeMath {
29   function safeMul(uint a, uint b) internal returns (uint) {
30     uint c = a * b;
31     assert(a == 0 || c / a == b);
32     return c;
33   }
34 
35   function safeSub(uint a, uint b) internal returns (uint) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function safeAdd(uint a, uint b) internal returns (uint) {
41     uint c = a + b;
42     assert(c>=a && c>=b);
43     return c;
44   }
45 
46   function assert(bool assertion) internal {
47     if (!assertion) throw;
48   }
49 }
50 
51 contract ERC20 {
52   uint public totalSupply;
53   function balanceOf(address who) constant returns (uint);
54   function allowance(address owner, address spender) constant returns (uint);
55 
56   function transfer(address to, uint value) returns (bool ok);
57   function transferFrom(address from, address to, uint value) returns (bool ok);
58   function approve(address spender, uint value) returns (bool ok);
59   event Transfer(address indexed from, address indexed to, uint value);
60   event Approval(address indexed owner, address indexed spender, uint value);
61 }
62 
63 contract StandardToken is ERC20, SafeMath {
64 
65   mapping(address => uint) balances;
66   mapping (address => mapping (address => uint)) allowed;
67 
68   function transfer(address _to, uint _value) returns (bool success) {
69     balances[msg.sender] = safeSub(balances[msg.sender], _value);
70     balances[_to] = safeAdd(balances[_to], _value);
71     Transfer(msg.sender, _to, _value);
72     return true;
73   }
74 
75   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
76     var _allowance = allowed[_from][msg.sender];
77     
78     balances[_to] = safeAdd(balances[_to], _value);
79     balances[_from] = safeSub(balances[_from], _value);
80     allowed[_from][msg.sender] = safeSub(_allowance, _value);
81     Transfer(_from, _to, _value);
82     return true;
83   }
84 
85   function balanceOf(address _owner) constant returns (uint balance) {
86     return balances[_owner];
87   }
88 
89   function approve(address _spender, uint _value) returns (bool success) {
90     allowed[msg.sender][_spender] = _value;
91     Approval(msg.sender, _spender, _value);
92     return true;
93   }
94 
95   function allowance(address _owner, address _spender) constant returns (uint remaining) {
96     return allowed[_owner][_spender];
97   }
98 
99 }
100 
101 contract Lockable is Ownable {
102     bool donationLock;
103 
104     function Lockable() {
105         donationLock = false;
106     }
107 
108     modifier onlyWhenDonationOpen {
109         if (donationLock) throw;
110         _;
111     }
112 
113     function stopAcceptingDonation() onlyOwner {
114         if (donationLock) throw;
115         donationLock = true;
116     }
117 
118     function startAcceptingDonation() onlyOwner {
119         if (!donationLock) throw;
120         donationLock = false;
121     }
122 }
123 
124 contract SmartPoolToken is StandardToken, Lockable {
125     string public name = "SmartPool";
126     string public symbol = "SPT";
127     uint public decimals = 0;
128 
129     address public beneficial;
130     mapping(address => uint) public donationAmountInWei;
131     mapping(uint => address) public donors;
132     uint public donorCount;
133     uint public totalFundRaised;
134     uint _rate;
135 
136     uint ETHER = 1 ether;
137 
138     event TokenMint(address newTokenHolder, uint tokensAmount);
139     event Donated(address indexed from, uint amount, uint tokensAmount, uint blockNumber);
140 
141     function SmartPoolToken(uint preminedTokens, address wallet) {
142         totalSupply = 0;
143         _rate = 100;
144         beneficial = wallet;
145         totalFundRaised = 0;
146         mintTokens(owner, safeMul(preminedTokens, ETHER / _rate));
147     }
148 
149     function mintTokens(address newTokenHolder, uint weiAmount) internal returns (uint){
150         uint tokensAmount = safeMul(_rate, weiAmount) / ETHER;
151 
152         if (tokensAmount >= 1) {
153             balances[newTokenHolder] = safeAdd(
154                 balances[newTokenHolder], tokensAmount);
155             totalSupply = safeAdd(totalSupply, tokensAmount);
156 
157             TokenMint(newTokenHolder, tokensAmount);
158             return tokensAmount;
159         }
160         return 0;
161     }
162 
163     function () payable onlyWhenDonationOpen {
164         uint weiAmount = msg.value;
165         if (weiAmount <= 0) throw;
166 
167         if (donationAmountInWei[msg.sender] == 0) {
168             donors[donorCount] = msg.sender;
169             donorCount += 1;
170         }
171 
172         donationAmountInWei[msg.sender] = safeAdd(
173             donationAmountInWei[msg.sender], weiAmount);
174         totalFundRaised = safeAdd(
175             totalFundRaised, weiAmount);
176         uint tokensCreated = mintTokens(msg.sender, weiAmount);
177         Donated(msg.sender, weiAmount, tokensCreated, block.number);
178     }
179 
180     function getDonationAmount() constant returns (uint donation) {
181         return donationAmountInWei[msg.sender];
182     }
183 
184     function getTokenBalance() constant returns (uint tokens) {
185         return balances[msg.sender];
186     }
187 
188     function tokenRate() constant returns (uint tokenRate) {
189         return _rate;
190     }
191 
192     function changeRate(uint newRate) onlyOwner returns (bool success) {
193         _rate = newRate;
194         return true;
195     }
196 
197     function withdraw() onlyOwner {
198         if (!beneficial.send(this.balance)) {
199             throw;
200         }
201     }
202 }