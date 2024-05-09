1 pragma solidity ^0.4.11;
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
29 }
30 
31 // Base ERC2.0 Token 
32 contract BaseToken is ERC20, DSMath {
33     uint256                                            _supply;
34     mapping (address => uint256)                       _balances;
35     mapping (address => mapping (address => uint256))  _approvals;
36     
37     function totalSupply() constant returns (uint256) {
38         return _supply;
39     }
40 
41     function balanceOf(address src) constant returns (uint256) {
42         return _balances[src];
43     }
44 
45     function allowance(address src, address guy) constant returns (uint256) {
46         return _approvals[src][guy];
47     }
48     
49     function transfer(address dst, uint wad) returns (bool) {
50         assert(_balances[msg.sender] >= wad);
51         
52         _balances[msg.sender] = sub(_balances[msg.sender], wad);
53         _balances[dst] = add(_balances[dst], wad);
54         
55         Transfer(msg.sender, dst, wad);
56         
57         return true;
58     }
59     
60     function transferFrom(address src, address dst, uint wad) returns (bool) {
61         assert(_balances[src] >= wad);
62         assert(_approvals[src][msg.sender] >= wad);
63         
64         _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
65         _balances[src] = sub(_balances[src], wad);
66         _balances[dst] = add(_balances[dst], wad);
67         
68         Transfer(src, dst, wad);
69         
70         return true;
71     }
72     
73     function approve(address guy, uint256 wad) returns (bool) {
74         _approvals[msg.sender][guy] = wad;
75         
76         Approval(msg.sender, guy, wad);
77         
78         return true;
79     }
80 }
81 
82 
83 
84 contract GMSToken is BaseToken {
85 
86     string public standard = 'GMSToken 1.0';
87     string public name;
88     string public symbol;
89     uint8 public decimals;
90 
91 	function () {
92         //if ether is sent to this address, send it back.
93         revert();
94     }
95 
96     function GMSToken(
97         uint256 initialSupply,
98         string tokenName,
99         uint8 decimalUnits,
100         string tokenSymbol
101         ) {
102         _balances[msg.sender] = initialSupply;              // Give the creator all initial tokens
103         _supply = initialSupply;                        // Update total supply
104         name = tokenName;                                   // Set the name for display purposes
105         symbol = tokenSymbol;                               // Set the symbol for display purposes
106         decimals = decimalUnits;                            // Amount of decimals for display purposes
107     }
108 }