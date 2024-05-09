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
17 // - totalSupply() bugfix
18 // -------------------------------------------------
19 // Security reviews passed - cycle 20r
20 // Functional reviews passed - cycle 20r
21 // Final code revision and regression test cycle passed - cycle 20r
22 // -------------------------------------------------
23 
24 contract owned {
25   address public owner;
26 
27   function owned() internal {
28     owner = msg.sender;
29   }
30   modifier onlyOwner {
31     require(msg.sender == owner);
32     _;
33   }
34 }
35 
36 contract safeMath {
37   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
38     uint256 c = a * b;
39     safeAssert(a == 0 || c / a == b);
40     return c;
41   }
42 
43   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
44     safeAssert(b > 0);
45     uint256 c = a / b;
46     safeAssert(a == b * c + a % b);
47     return c;
48   }
49 
50   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
51     safeAssert(b <= a);
52     return a - b;
53   }
54 
55   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
56     uint256 c = a + b;
57     safeAssert(c>=a && c>=b);
58     return c;
59   }
60 
61   function safeAssert(bool assertion) internal pure {
62     if (!assertion) revert();
63   }
64 }
65 
66 contract ERC20Interface is owned, safeMath {
67   function balanceOf(address _owner) public constant returns (uint256 balance);
68   function transfer(address _to, uint256 _value) public returns (bool success);
69   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
70   function approve(address _spender, uint256 _value) public returns (bool success);
71   function increaseApproval (address _spender, uint _addedValue) public returns (bool success);
72   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success);
73   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
74   event Buy(address indexed _sender, uint256 _eth, uint256 _EPX);
75   event Transfer(address indexed _from, address indexed _to, uint256 _value);
76   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
77 }
78 
79 contract EPXToken is ERC20Interface {
80   // token setup variables
81   string  public constant name                  = "EthPoker.io EPX";
82   string  public constant standard              = "EPX";
83   string  public constant symbol                = "EPX";
84   uint8   public constant decimals              = 4;                              // 4 decimals for practicality
85   uint256 public constant totalSupply          = 2800000000000;                   // 280 000 000 (total supply of EPX tokens is 280,000,000) + 4 decimal points (2800000000000)
86 
87   // token mappings
88   mapping (address => uint256) balances;
89   mapping (address => mapping (address => uint256)) allowed;
90 
91   // ERC20 standard token possible events, matched to ICO and preSale contracts
92   event Buy(address indexed _sender, uint256 _eth, uint256 _EPX);
93   event Transfer(address indexed _from, address indexed _to, uint256 _value);
94   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
95 
96   // ERC20 token balanceOf query function
97   function balanceOf(address _owner) public constant returns (uint256 balance) {
98     return balances[_owner];
99   }
100 
101   // token balance normalised for display (4 decimals removed)
102   function EPXtokenSupply() public pure returns (uint256 totalEPXtokenCount) {
103     return safeDiv(totalSupply,10000); // div by 1,000 for display normalisation (4 decimals)
104   }
105 
106   // ERC20 token transfer function with additional safety
107   function transfer(address _to, uint256 _amount) public returns (bool success) {
108     require(!(_to == 0x0));
109     if ((balances[msg.sender] >= _amount)
110     && (_amount > 0)
111     && ((safeAdd(balances[_to],_amount) > balances[_to]))) {
112       balances[msg.sender] = safeSub(balances[msg.sender], _amount);
113       balances[_to] = safeAdd(balances[_to], _amount);
114       Transfer(msg.sender, _to, _amount);
115       return true;
116     } else {
117       return false;
118     }
119   }
120 
121   // ERC20 token transferFrom function with additional safety
122   function transferFrom(
123     address _from,
124     address _to,
125     uint256 _amount) public returns (bool success) {
126     require(!(_to == 0x0));
127     if ((balances[_from] >= _amount)
128     && (allowed[_from][msg.sender] >= _amount)
129     && (_amount > 0)
130     && (safeAdd(balances[_to],_amount) > balances[_to])) {
131       balances[_from] = safeSub(balances[_from], _amount);
132       allowed[_from][msg.sender] = safeSub((allowed[_from][msg.sender]),_amount);
133       balances[_to] = safeAdd(balances[_to], _amount);
134       Transfer(_from, _to, _amount);
135       return true;
136     } else {
137       return false;
138     }
139   }
140 
141   // ERC20 allow _spender to withdraw, multiple times, up to the _value amount
142   function approve(address _spender, uint256 _amount) public returns (bool success) {
143     //Fix for known double-spend https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/edit#
144     //Input must either set allow amount to 0, or have 0 already set, to workaround issue
145     require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
146     require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
147     allowed[msg.sender][_spender] = _amount;
148     Approval(msg.sender, _spender, _amount);
149     return true;
150   }
151 
152   // ERC20 return allowance for given owner spender pair
153   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
154     return allowed[_owner][_spender];
155   }
156 
157   // ERC20 Updated increase approval process (to prevent double-spend attack but remove need to zero allowance before setting)
158   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
159     allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender],_addedValue);
160 
161     // report new approval amount
162     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163     return true;
164   }
165 
166   // ERC20 Updated decrease approval process (to prevent double-spend attack but remove need to zero allowance before setting)
167   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
168     uint oldValue = allowed[msg.sender][_spender];
169 
170     if (_subtractedValue > oldValue) {
171       allowed[msg.sender][_spender] = 0;
172     } else {
173       allowed[msg.sender][_spender] = safeSub(oldValue,_subtractedValue);
174     }
175 
176     // report new approval amount
177     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
178     return true;
179   }
180 
181   // ERC20 Standard default function to assign initial supply variables and send balance to creator for distribution to EPX presale and ICO contract
182   function EPXToken() public onlyOwner {
183     balances[msg.sender] = totalSupply;
184   }
185 
186   // Reject sent ETH
187   function () public payable {
188     revert();
189   }
190 
191   // Contract owner able to transfer any airdropped or ERC20 tokens that are sent to the token contract address (mistakenly or as part of airdrop campaign)
192   function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
193     return ERC20Interface(tokenAddress).transfer(owner, tokens);
194   }
195 }