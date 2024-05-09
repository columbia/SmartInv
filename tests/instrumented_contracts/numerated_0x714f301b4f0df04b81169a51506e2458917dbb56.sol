1 pragma solidity ^0.4.16;
2 
3 contract XBYR{
4 
5 
6 
7     uint256 constant private MAX_UINT256 = 2**256 - 1;
8 
9     mapping (address => uint256) public balances;
10 
11     mapping (address => mapping (address => uint256)) public allowed;
12 
13     /*
14 
15     NOTE:
16 
17     The following variables are OPTIONAL vanities. One does not have to include them.
18 
19     They allow one to customise the token contract & in no way influences the core functionality.
20 
21     Some wallets/interfaces might not even bother to look at this information.
22 
23     */
24 
25     uint256 public totalSupply;
26 
27     string public name;                   //fancy name: eg Simon Bucks
28 
29     uint8 public decimals;                //How many decimals to show.
30 
31     string public symbol;                 //An identifier: eg SBX
32 
33      event Transfer(address indexed _from, address indexed _to, uint256 _value); 
34 
35     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36 
37    
38 
39    
40 
41     function XBYR() public {
42 
43         balances[msg.sender] = 1000000000000;               // Give the creator all initial tokens
44 
45         totalSupply = 1000000000000;                        // Update total supply
46 
47         name = "YRCoin";                                   // Set the name for display purposes
48 
49         decimals =4;                            // Amount of decimals for display purposes
50 
51         symbol = "XBYR";                               // Set the symbol for display purposes
52 
53     }
54 
55 
56 
57 
58 
59     function transfer(address _to, uint256 _value) public returns (bool success) {
60 
61         require(balances[msg.sender] >= _value);
62 
63         balances[msg.sender] -= _value;
64 
65         balances[_to] += _value;
66 
67         Transfer(msg.sender, _to, _value);
68 
69         return true;
70 
71     }
72 
73 
74 
75     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
76 
77         uint256 allowance = allowed[_from][msg.sender];
78 
79         require(balances[_from] >= _value && allowance >= _value);
80 
81         balances[_to] += _value;
82 
83         balances[_from] -= _value;
84 
85         if (allowance < MAX_UINT256) {
86 
87             allowed[_from][msg.sender] -= _value;
88 
89         }
90 
91         Transfer(_from, _to, _value);
92 
93         return true;
94 
95     }
96 
97 
98 
99     function balanceOf(address _owner) public view returns (uint256 balance) {
100 
101         return balances[_owner];
102 
103     }
104 
105 
106 
107     function approve(address _spender, uint256 _value) public returns (bool success) {
108 
109         allowed[msg.sender][_spender] = _value;
110 
111         Approval(msg.sender, _spender, _value);
112 
113         return true;
114 
115     }
116 
117 
118 
119     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
120 
121         return allowed[_owner][_spender];
122 
123     }   
124 
125 }