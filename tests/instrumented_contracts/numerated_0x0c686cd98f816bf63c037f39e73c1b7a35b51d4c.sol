1 pragma solidity ^0.4.18;
2 // -------------------------------------------------
3 // ethPoker.io EPX token - ERC20 token smart contract
4 // contact admin@ethpoker.io for queries
5 // Revision 20b
6 // Full test suite 20r passed
7 // -------------------------------------------------
8 // ERC Token Standard #20 interface:
9 // https://github.com/ethereum/EIPs/issues/20
10 // EPX contract sources:
11 // https://github.com/EthPokerIO/ethpokerIO
12 // ------------------------------------------------
13 // 2018 improvements:
14 // - added transferAnyERC20Token function to capture airdropped tokens
15 // - added revert() rejection of any Eth sent to the token address itself
16 // - additional gas optimisation performed (round 3)
17 // -------------------------------------------------
18 // Security reviews passed - cycle 20r
19 // Functional reviews passed - cycle 20r
20 // Final code revision and regression test cycle passed - cycle 20r
21 // -------------------------------------------------
22 
23 contract owned {
24   address public owner;
25 
26   function owned() internal {
27     owner = msg.sender;
28   }
29   modifier onlyOwner {
30     require(msg.sender == owner);
31     _;
32   }
33 }
34 
35 contract safeMath {
36   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a * b;
38     safeAssert(a == 0 || c / a == b);
39     return c;
40   }
41 
42   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
43     safeAssert(b > 0);
44     uint256 c = a / b;
45     safeAssert(a == b * c + a % b);
46     return c;
47   }
48 
49   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
50     safeAssert(b <= a);
51     return a - b;
52   }
53 
54   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     safeAssert(c>=a && c>=b);
57     return c;
58   }
59 
60   function safeAssert(bool assertion) internal pure {
61     if (!assertion) revert();
62   }
63 }
64 
65 contract ERC20Interface is owned, safeMath {
66   function balanceOf(address _owner) public constant returns (uint256 balance);
67   function transfer(address _to, uint256 _value) public returns (bool success);
68   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
69   function approve(address _spender, uint256 _value) public returns (bool success);
70   function increaseApproval (address _spender, uint _addedValue) public returns (bool success);
71   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success);
72   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
73   event Buy(address indexed _sender, uint256 _eth, uint256 _EPX);
74   event Transfer(address indexed _from, address indexed _to, uint256 _value);
75   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
76 }
77 
78 contract EPXToken is ERC20Interface {
79   // token setup variables
80   string  public constant name                  = "EthPoker.io EPX";
81   string  public constant standard              = "EPX";
82   string  public constant symbol                = "EPX";
83   uint8   public constant decimals              = 4;                               // 4 decimals for practicality
84   uint256 private constant totalSupply          = 2800000000000;                   // 280 000 000 (total supply of EPX tokens is 280,000,000) + 4 decimal points (2800000000000)
85 
86   // token mappings
87   mapping (address => uint256) balances;
88   mapping (address => mapping (address => uint256)) allowed;
89 
90   // ERC20 standard token possible events, matched to ICO and preSale contracts
91   event Buy(address indexed _sender, uint256 _eth, uint256 _EPX);
92   event Transfer(address indexed _from, address indexed _to, uint256 _value);
93   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
94 
95   // ERC20 token balanceOf query function
96   function balanceOf(address _owner) public constant returns (uint256 balance) {
97     return balances[_owner];
98   }
99 
100   // token balance normalised for display (4 decimals removed)
101   function EPXtokenSupply() public pure returns (uint256 totalEPXtokenCount) {
102     return safeDiv(totalSupply,10000); // div by 1,000 for display normalisation (4 decimals)
103   }
104 
105   // ERC20 token transfer function with additional safety
106   function transfer(address _to, uint256 _amount) public returns (bool success) {
107     require(!(_to == 0x0));
108     if ((balances[msg.sender] >= _amount)
109     && (_amount > 0)
110     && ((safeAdd(balances[_to],_amount) > balances[_to]))) {
111       balances[msg.sender] = safeSub(balances[msg.sender], _amount);
112       balances[_to] = safeAdd(balances[_to], _amount);
113       Transfer(msg.sender, _to, _amount);
114       return true;
115     } else {
116       return false;
117     }
118   }
119 
120   // ERC20 token transferFrom function with additional safety
121   function transferFrom(
122     address _from,
123     address _to,
124     uint256 _amount) public returns (bool success) {
125     require(!(_to == 0x0));
126     if ((balances[_from] >= _amount)
127     && (allowed[_from][msg.sender] >= _amount)
128     && (_amount > 0)
129     && (safeAdd(balances[_to],_amount) > balances[_to])) {
130       balances[_from] = safeSub(balances[_from], _amount);
131       allowed[_from][msg.sender] = safeSub((allowed[_from][msg.sender]),_amount);
132       balances[_to] = safeAdd(balances[_to], _amount);
133       Transfer(_from, _to, _amount);
134       return true;
135     } else {
136       return false;
137     }
138   }
139 
140   // ERC20 allow _spender to withdraw, multiple times, up to the _value amount
141   function approve(address _spender, uint256 _amount) public returns (bool success) {
142     //Fix for known double-spend https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/edit#
143     //Input must either set allow amount to 0, or have 0 already set, to workaround issue
144     require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
145     require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
146     allowed[msg.sender][_spender] = _amount;
147     Approval(msg.sender, _spender, _amount);
148     return true;
149   }
150 
151   // ERC20 return allowance for given owner spender pair
152   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
153     return allowed[_owner][_spender];
154   }
155 
156   // ERC20 Updated increase approval process (to prevent double-spend attack but remove need to zero allowance before setting)
157   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
158     allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender],_addedValue);
159 
160     // report new approval amount
161     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162     return true;
163   }
164 
165   // ERC20 Updated decrease approval process (to prevent double-spend attack but remove need to zero allowance before setting)
166   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
167     uint oldValue = allowed[msg.sender][_spender];
168 
169     if (_subtractedValue > oldValue) {
170       allowed[msg.sender][_spender] = 0;
171     } else {
172       allowed[msg.sender][_spender] = safeSub(oldValue,_subtractedValue);
173     }
174 
175     // report new approval amount
176     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177     return true;
178   }
179 
180   // ERC20 Standard default function to assign initial supply variables and send balance to creator for distribution to EPX presale and ICO contract
181   function EPXToken() public onlyOwner {
182     balances[msg.sender] = totalSupply;
183   }
184 
185   // Reject sent ETH
186   function () public payable {
187     revert();
188   }
189 
190   // Contract owner able to transfer any airdropped or ERC20 tokens that are sent to the token contract address (mistakenly or as part of airdrop campaign)
191   function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
192     return ERC20Interface(tokenAddress).transfer(owner, tokens);
193   }
194 }