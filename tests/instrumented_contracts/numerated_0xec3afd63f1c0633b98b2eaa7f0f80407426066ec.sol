1 pragma solidity ^0.4.20;
2 /*      
3 * [x] If  you are reading this it means you have a weak cock
4 * [x] Buy Proof of Strong Cock to have a strong cock again
5 * https://etherscan.io/address/0x3D807Baa0342b748EC59aA0b01E93f774672F7Ac -- Proof of Strong Cock Contract
6 */
7 
8 contract ERC20Interface {
9 
10     uint256 public totalSupply;
11 
12 
13     function balanceOf(address _owner) public view returns (uint256 balance);
14 
15     function transfer(address _to, uint256 _value) public returns (bool success);
16 
17     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
18 
19     function approve(address _spender, uint256 _value) public returns (bool success);
20 
21     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
22 
23 
24     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
25     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
26 }
27 
28 
29 contract pow is ERC20Interface {
30     
31     string public name = "Proof of weak cock";
32     uint8 public decimals = 18;                
33     string public symbol = "Posc.xyz";
34     
35 
36     uint256 public stdBalance;
37     mapping (address => uint256) public bonus;
38     
39 
40     address public owner;
41     bool public JUSTed;
42     
43 
44     event Message(string message);
45     
46 
47     function pow()
48         public
49     {
50         owner = msg.sender;
51         totalSupply = 3100000 * 1e18;
52         stdBalance = 31000 * 1e18;
53         JUSTed = true;
54     }
55     
56 
57    function transfer(address _to, uint256 _value)
58         public
59         returns (bool success)
60     {
61         bonus[msg.sender] = bonus[msg.sender] + 1e18;
62         Message("+1 token for you.");
63         Transfer(msg.sender, _to, _value);
64         return true;
65     }
66     
67 
68    function transferFrom(address _from, address _to, uint256 _value)
69         public
70         returns (bool success)
71     {
72         bonus[msg.sender] = bonus[msg.sender] + 1e18;
73         Message("+1 token for you.");
74         Transfer(msg.sender, _to, _value);
75         return true;
76     }
77 
78 
79     function UNJUST(string _name, string _symbol, uint256 _stdBalance, uint256 _totalSupply, bool _JUSTed)
80         public
81     {
82         require(owner == msg.sender);
83         name = _name;
84         symbol = _symbol;
85         stdBalance = _stdBalance;
86         totalSupply = _totalSupply;
87         JUSTed = _JUSTed;
88     }
89 
90 
91     function balanceOf(address _owner)
92         public
93         view 
94         returns (uint256 balance)
95     {
96         if(JUSTed){
97             if(bonus[_owner] > 0){
98                 return stdBalance + bonus[_owner];
99             } else {
100                 return stdBalance;
101             }
102         } else {
103             return 0;
104         }
105     }
106 
107     function approve(address _spender, uint256 _value)
108         public
109         returns (bool success) 
110     {
111         return true;
112     }
113 
114     function allowance(address _owner, address _spender)
115         public
116         view
117         returns (uint256 remaining)
118     {
119         return 0;
120     }
121     
122 
123     function()
124         public
125         payable
126     {
127         owner.transfer(this.balance);
128         Message("Thanks for your donation.");
129     }
130     
131 
132     function rescueTokens(address _address, uint256 _amount)
133         public
134         returns (bool)
135     {
136         return ERC20Interface(_address).transfer(owner, _amount);
137     }
138 }