1 pragma solidity ^0.4.16;
2 
3 contract BMToken {
4     string  public  name = "BMChain Token";
5     string  public  symbol = "BMT";
6     uint256  public  decimals = 18;
7 
8     uint256 _supply = 0;
9     mapping (address => uint256) _balances;
10     mapping (address => mapping (address => uint256)) _approvals;
11 
12     event Transfer( address indexed from, address indexed to, uint value);
13     event Approval( address indexed owner, address indexed spender, uint value);
14 
15     address ico_contract;
16     address public owner;
17 
18     function BMToken(){
19         ico_contract = address(0x0);
20         owner = msg.sender;
21     }
22 
23     modifier isOwner()
24     {
25         assert(msg.sender == owner);
26         _;
27     }
28 
29     function changeOwner(address new_owner) isOwner
30     {
31         assert(new_owner!=address(0x0));
32         assert(new_owner!=address(this));
33         owner = new_owner;
34     }
35 
36     function setICOContract(address new_address) isOwner
37     {
38         assert(ico_contract==address(0x0));
39         assert(new_address!=address(0x0));
40         assert(new_address!=address(this));
41         ico_contract = new_address;
42     }
43 
44     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
45         assert((z = x + y) >= x);
46     }
47 
48     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
49         assert((z = x - y) <= x);
50     }
51 
52     function totalSupply() constant external returns (uint256) {
53         return _supply;
54     }
55 
56     function balanceOf(address src) constant external returns (uint256) {
57         return _balances[src];
58     }
59 
60     function allowance(address src, address where) constant external returns (uint256) {
61         return _approvals[src][where];
62     }
63 
64     function transfer(address where, uint amount) external returns (bool) {
65         assert(where != address(this));
66         assert(where != address(0));
67         assert(_balances[msg.sender] >= amount);
68 
69         _balances[msg.sender] = sub(_balances[msg.sender], amount);
70         _balances[where] = add(_balances[where], amount);
71 
72         Transfer(msg.sender, where, amount);
73 
74         return true;
75     }
76 
77     function transferFrom(address src, address where, uint amount) external returns (bool) {
78         assert(where != address(this));
79         assert(where != address(0));
80         assert(_balances[src] >= amount);
81         assert(_approvals[src][msg.sender] >= amount);
82 
83         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], amount);
84         _balances[src] = sub(_balances[src], amount);
85         _balances[where] = add(_balances[where], amount);
86 
87         Transfer(src, where, amount);
88 
89         return true;
90     }
91 
92     function approve(address where, uint256 amount) external returns (bool) {
93         assert(where != address(this));
94         assert(where != address(0));
95         _approvals[msg.sender][where] = amount;
96 
97         Approval(msg.sender, where, amount);
98 
99         return true;
100     }
101 
102     function mintTokens(address holder, uint256 amount) external
103     {
104         assert(msg.sender == ico_contract);
105         _balances[holder] = add(_balances[holder], amount);
106         _supply = add(_supply, amount);
107         Transfer(address(0x0), holder, amount);
108     }
109 }