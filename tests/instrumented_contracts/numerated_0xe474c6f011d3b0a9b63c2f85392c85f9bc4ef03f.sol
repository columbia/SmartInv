1 pragma solidity >=0.4.22 <0.7.0;
2 
3 contract POCBGHToken{
4 
5 
6     // -------------------------SafeMath Start-----------------------------------------------
7     //
8     function safeAdd(uint a, uint b) private pure returns (uint c) { c = a + b; require(c >= a); }
9     function safeSub(uint a, uint b) private pure returns (uint c) { require(b <= a); c = a - b; }
10     function safeMul(uint a, uint b) private pure returns (uint c) { c = a * b; require(a == 0 || c / a == b);}
11     function safeDiv(uint a, uint b) private pure returns (uint c) { require(b > 0); c = a / b; }
12     //
13     // -------------------------SafeMath End-------------------------------------------------
14 
15     // -------------------------Owned Start-----------------------------------------------
16     //
17     address public owner;
18     address public newOwner;
19 
20     // constructor() public {
21     //     owner = msg.sender;
22     // }
23 
24     event OwnershipTransferred(address indexed _from, address indexed _to);
25     modifier onlyOwner { require(msg.sender == owner); _; }
26 
27     function transferOwnership(address _newOwner) public onlyOwner {
28         newOwner = _newOwner;
29     }
30     function acceptOwnership() public {
31         require(msg.sender == newOwner);
32         emit OwnershipTransferred(owner, newOwner);
33         owner = newOwner;
34         newOwner = address(0);
35     }
36     //
37     // -------------------------Owned End-------------------------------------------------
38 
39     // -------------------------ERC20Interface Start-----------------------------------------------
40     //
41     string public symbol = "POCBGH";
42     string public name = "POC Big Gold Hammer";
43     uint8 public decimals = 18;
44     uint public totalSupply = 21e24;//总量2100万
45     bool public allowTransfer = true;//是否允许交易
46 
47     mapping(address => uint) private balances;
48 
49     event Transfer(address indexed from, address indexed to, uint tokens);
50     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
51 
52     address private retentionAddress = 0xB4c5baF0450Af948DEBbe8aA8A20B9A05a3475c0;
53 
54     constructor() public {
55         owner = msg.sender;
56 
57         balances[owner] = 7e24;
58         balances[retentionAddress] = 14e24;
59         emit Transfer(address(0), owner, balances[owner]);
60         emit Transfer(address(0), retentionAddress, balances[retentionAddress]);
61     }
62     function balanceOf(address tokenOwner) public view returns (uint balance) {
63         balance = balances[tokenOwner];
64     }
65     function allowance(address tokenOwner, address spender) public pure returns (uint remaining) {
66         require(tokenOwner != spender);
67         //------do nothing------
68         remaining = 0;
69     }
70     function transfer(address to, uint tokens) public returns (bool success) {
71         require(allowTransfer && tokens > 0);
72         require(to != msg.sender);
73 
74         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
75         balances[to] = safeAdd(balances[to], tokens);
76         emit Transfer(msg.sender, to, tokens);
77         success = true;
78     }
79     function approve(address spender, uint tokens) public pure returns (bool success) {
80         require(address(0) != spender);
81         require(tokens > 0);
82         //------do nothing------
83         success = false;
84     }
85     function transferFrom(address from, address to, uint tokens) public pure returns (bool success) {
86         require(from != to);
87         require(tokens > 0);
88         //------do nothing------
89         success = false;
90     }
91     //
92     // -------------------------ERC20Interface End-------------------------------------------------
93 
94     // -------------------------Others-----------------------------------------------
95     //
96     function chAllowTransfer(bool _allowTransfer) public onlyOwner {
97         allowTransfer = _allowTransfer;
98     }
99     function sendToken(address[] memory _to, uint[] memory _tokens) public onlyOwner {
100         if (_to.length != _tokens.length) {
101             revert();
102         }
103         uint count = 0;
104         for (uint i = 0; i < _tokens.length; i++) {
105             count = safeAdd(count, _tokens[i]);
106         }
107         if (count > balances[msg.sender]) {
108             revert();
109         }
110         for (uint i = 0; i < _to.length; i++) {
111             transfer(_to[i], _tokens[i]);
112         }
113     }
114 }