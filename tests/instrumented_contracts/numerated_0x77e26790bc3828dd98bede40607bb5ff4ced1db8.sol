1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'M8' Solidity Contract Under (c) M8s World Sàrl
5 //
6 // Deployed to : 0x77e26790bc3828dd98bede40607bb5ff4ced1db8
7 // Symbol      : M8
8 // Name        : M8
9 // Total supply: 1,000,000,000,000 M8
10 // Decimals    : 8
11 //
12 //
13 // Copyright (c) M8s World Sàrl, all rights reserved 2019.
14 // ERC20 Smart Contract Provided By: SoftCode.space Blockchain Developer Team.
15 // ----------------------------------------------------------------------------
16 
17 // Total 10 Points Associated With This Solidity Contract, please read them carefully
18 // ----------------------------------------------------------------------------
19 // Point 1 Any social action taken in www.M8s.World can earn a user a point(s) or division of. A M8 or any division of can be offered in exchange for a point in M8s World. This concept remains the copyright of M8s World Sàrl, all rights reserved 2019.
20 // Point 2 A M8 is valued by human time and labour spent within and outside of M8s World social network by way of contribution or acts undertaken on behalf of M8s World as well as the same human's commitment to view a certain variable amount of commercial advertisements within and outside of M8s World on a variable timescale.
21 // Point 3 To earn M8 in M8s World our members must allow The M8s World administration & AI to use the data that they share so they can customise advertising relevant to the member, in the knowledge that the M8s World M8 should increase in value if it is backed by a commercial process as well and human time and labour.
22 // Point 4 Human time and labour is universally agreed by M8s World members that the M8 backed by such and supported by advertising revenue can not fall below the value of 1 x M8 = 1 x Swiss Franc although A M8 can increase by unlimited amounts more than the Swiss Franc.
23 // Point 5 A M8s world member must allow M8s World software to have access to parts of the hardware on their device used to access M8s World, ie a member's keyboard, camera, speakers, microphone etc to allow M8s World administration to reward members with the correct amount of M8s or any promotions held by M8s World Sàrl.
24 // Point 6 0.00001% of all M8 is to be retained by each of the 2 x M8s World Sàrl Founders, Mr Anthony Bain and Mr. Nigel Eyles.
25 // Point 7 A soft cap of CHF 10,000,000 needs to be raised to produce and promote the new M8s.World social network that is being designed to fully exploit the M8 and www.m8s.world, existing and future, on behalf of M8 users with a hard cap of CHF20,000,000.
26 // Point 8 A M8 can be borrowed or lent with or without interest using M8 smart contracts.
27 // Point 9 When all pre-mined M8s have been distributed, a M8 can be divisible up to 8 decimal points, M8 mining can be restored if demand exceeds supply.
28 // Point 10 If any M8 needs to be burned to assist in raising the value of M8 it will be burned at the discretion of the two founders or their representatives.
29 // Copyright (c) M8s World Sàrl, all rights reserved 2019.
30 // ----------------------------------------------------------------------------
31 
32 contract SafeMath {
33     function safeAdd(uint a, uint b) public pure returns (uint c) {
34         c = a + b;
35         require(c >= a);
36     }
37     function safeSub(uint a, uint b) public pure returns (uint c) {
38         require(b <= a);
39         c = a - b;
40     }
41     function safeMul(uint a, uint b) public pure returns (uint c) {
42         c = a * b;
43         require(a == 0 || c / a == b);
44     }
45     function safeDiv(uint a, uint b) public pure returns (uint c) {
46         require(b > 0);
47         c = a / b;
48     }
49 }
50 
51 
52 contract ERC20Interface {
53     function totalSupply() public constant returns (uint);
54     function balanceOf(address tokenOwner) public constant returns (uint balance);
55     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
56     function transfer(address to, uint tokens) public returns (bool success);
57     function approve(address spender, uint tokens) public returns (bool success);
58     function transferFrom(address from, address to, uint tokens) public returns (bool success);
59 
60     event Transfer(address indexed from, address indexed to, uint tokens);
61     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
62 }
63 
64 
65 contract ApproveAndCallFallBack {
66     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
67 }
68 
69 
70 contract Owned {
71     address public owner;
72     address public newOwner;
73 
74     event OwnershipTransferred(address indexed _from, address indexed _to);
75 
76     function Owned() public {
77         owner = msg.sender;
78     }
79 
80     modifier onlyOwner {
81         require(msg.sender == owner);
82         _;
83     }
84 
85     function transferOwnership(address _newOwner) public onlyOwner {
86         newOwner = _newOwner;
87     }
88     function acceptOwnership() public {
89         require(msg.sender == newOwner);
90         OwnershipTransferred(owner, newOwner);
91         owner = newOwner;
92         newOwner = address(0);
93     }
94 }
95 
96 
97 contract M8 is ERC20Interface, Owned, SafeMath {
98     string public symbol;
99     string public  name;
100     uint8 public decimals;
101     uint public _totalSupply;
102 
103     mapping(address => uint) balances;
104     mapping(address => mapping(address => uint)) allowed;
105 
106 
107     function M8() public {
108         symbol = "M8";
109         name = "M8";
110         decimals = 8;
111         _totalSupply = 100000000000000000000;
112         balances[0xd1bdf441811b2225E8AFc6eFe8cE53Df417ebA7C] = _totalSupply;
113         Transfer(address(0), 0xd1bdf441811b2225E8AFc6eFe8cE53Df417ebA7C, _totalSupply);
114     }
115 
116 
117     function totalSupply() public constant returns (uint) {
118         return _totalSupply  - balances[address(0)];
119     }
120 
121 
122     function balanceOf(address tokenOwner) public constant returns (uint balance) {
123         return balances[tokenOwner];
124     }
125 
126 
127     function transfer(address to, uint tokens) public returns (bool success) {
128         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
129         balances[to] = safeAdd(balances[to], tokens);
130         Transfer(msg.sender, to, tokens);
131         return true;
132     }
133 
134 
135     function approve(address spender, uint tokens) public returns (bool success) {
136         allowed[msg.sender][spender] = tokens;
137         Approval(msg.sender, spender, tokens);
138         return true;
139     }
140 
141 
142     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
143         balances[from] = safeSub(balances[from], tokens);
144         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
145         balances[to] = safeAdd(balances[to], tokens);
146         Transfer(from, to, tokens);
147         return true;
148     }
149 
150 
151     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
152         return allowed[tokenOwner][spender];
153     }
154 
155 
156     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
157         allowed[msg.sender][spender] = tokens;
158         Approval(msg.sender, spender, tokens);
159         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
160         return true;
161     }
162 
163 
164     function () public payable {
165         revert();
166     }
167 
168 
169     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
170         return ERC20Interface(tokenAddress).transfer(owner, tokens);
171     }
172 }