1 pragma solidity ^0.4.15;
2 
3 // Token standard API
4 // https://github.com/ethereum/EIPs/issues/20
5 contract ERC20 {
6     function totalSupply() constant returns (uint supply);
7     function balanceOf( address who ) constant returns (uint value);
8     function allowance( address owner, address spender ) constant returns (uint _allowance);
9     function transfer( address to, uint value) returns (bool ok);
10     function transferFrom( address from, address to, uint value) returns (bool ok);
11     function approve( address spender, uint value ) returns (bool ok);
12     event Transfer( address indexed from, address indexed to, uint value);
13     event Approval( address indexed owner, address indexed spender, uint value);
14 }
15 
16 
17 // Safe Math 
18 // From https://github.com/dapphub/ds-math
19 contract DSMath {
20     /*
21     standard uint256 functions
22      */
23     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
24         assert((z = x + y) >= x);
25     }
26     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
27         assert((z = x - y) <= x);
28     }
29     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
30         z = x * y;
31         assert(x == 0 || z / x == y);
32     }
33     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
34         z = x / y;
35     }
36     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
37         return x <= y ? x : y;
38     }
39     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
40         return x >= y ? x : y;
41     }
42 }
43 
44 // Base ERC2.0 Token 
45 contract BaseToken is ERC20, DSMath {
46     uint256                                            _supply;
47     mapping (address => uint256)                       _balances;
48     mapping (address => mapping (address => uint256))  _approvals;
49     
50     function totalSupply() constant returns (uint256) {
51         return _supply;
52     }
53 
54     function balanceOf(address src) constant returns (uint256) {
55         return _balances[src];
56     }
57 
58     function allowance(address src, address guy) constant returns (uint256) {
59         return _approvals[src][guy];
60     }
61     
62     function transfer(address dst, uint wad) returns (bool) {
63         assert(_balances[msg.sender] >= wad);
64         
65         _balances[msg.sender] = sub(_balances[msg.sender], wad);
66         _balances[dst] = add(_balances[dst], wad);
67         
68         Transfer(msg.sender, dst, wad);
69         
70         return true;
71     }
72     
73     function transferFrom(address src, address dst, uint wad) returns (bool) {
74         assert(_balances[src] >= wad);
75         assert(_approvals[src][msg.sender] >= wad);
76         
77         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
78         _balances[src] = sub(_balances[src], wad);
79         _balances[dst] = add(_balances[dst], wad);
80         
81         Transfer(src, dst, wad);
82         
83         return true;
84     }
85     
86     function approve(address guy, uint256 wad) returns (bool) {
87         _approvals[msg.sender][guy] = wad;
88         
89         Approval(msg.sender, guy, wad);
90         
91         return true;
92     }
93 }
94 
95 
96 
97 contract GMSToken is BaseToken {
98 
99     string public standard = 'GMSToken 1.0';
100     string public name;
101     string public symbol;
102     uint8 public decimals;
103 
104 
105     function GMSToken(
106         uint256 initialSupply,
107         string tokenName,
108         uint8 decimalUnits,
109         string tokenSymbol
110         ) {
111         _balances[msg.sender] = initialSupply;              // Give the creator all initial tokens
112         _supply = initialSupply;                        // Update total supply
113         name = tokenName;                                   // Set the name for display purposes
114         symbol = tokenSymbol;                               // Set the symbol for display purposes
115         decimals = decimalUnits;                            // Amount of decimals for display purposes
116     }
117 }