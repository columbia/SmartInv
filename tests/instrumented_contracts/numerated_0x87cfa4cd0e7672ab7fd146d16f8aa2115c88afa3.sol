1 pragma solidity ^0.4.16;
2 
3 contract SafeMath {
4     function safeMul(uint a, uint b) pure internal returns (uint) {
5         uint c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function safeSub(uint a, uint b) pure internal returns (uint) {
11         assert(b <= a);
12         return a - b;
13     }
14 
15     function safeAdd(uint a, uint b) pure internal returns (uint) {
16         uint c = a + b;
17         assert(c >= a && c >= b);
18         return c;
19     }
20 }
21 
22 contract HXC is SafeMath {
23 
24     string public name = "HXC";        //  token name
25     string public symbol = "HXC";      //  token symbol
26     uint public decimals = 18;           //  token digit
27 
28     address public admin = 0x0;
29     uint256 public dailyRelease = 6000 * 10 ** 18;
30     uint256 public totalRelease = 0;
31     uint256 constant totalValue = 1000 * 10000 * 10 ** 18;
32 
33 
34     uint256 public totalSupply = 0;
35     mapping (address => uint) balances;
36     mapping (address => mapping (address => uint)) allowed;
37 
38     modifier isAdmin 
39     {
40         assert(admin == msg.sender);
41         _;
42     }
43 
44     modifier validAddress(address _address) 
45     {
46         assert(0x0 != _address);
47         _;
48     }
49 
50     function HXC(address _addressFounder)
51         public
52     {
53         admin = msg.sender;
54         totalSupply = totalValue;
55         balances[_addressFounder] = totalValue;
56         Transfer(0x0, _addressFounder, totalValue); 
57     }
58 
59     function releaseSupply()
60         isAdmin
61         returns (bool)
62     {
63         totalRelease = safeAdd(totalRelease,dailyRelease);
64         return true;
65     }
66 
67     function updateRelease(uint256 amount)
68         isAdmin
69         returns (bool)
70     {
71         totalRelease = safeAdd(totalRelease,amount);
72         return true;
73     }
74 
75     function transfer(address _to, uint256 _value) 
76         public 
77         validAddress(_to) 
78         returns (bool success)
79     {
80         require(balances[msg.sender] >= _value);
81         require(balances[_to] + _value >= balances[_to]);
82         balances[msg.sender] -= _value;
83         balances[_to] += _value;
84         Transfer(msg.sender, _to, _value);
85         return true;
86     }
87 
88     function transferFrom(address _from, address _to, uint256 _value) 
89         public
90         validAddress(_from)
91         validAddress(_to)
92         returns (bool success) 
93     {
94         require(balances[_from] >= _value);
95         require(balances[_to] + _value >= balances[_to]);
96         require(allowed[_from][msg.sender] >= _value);
97         balances[_to] += _value;
98         balances[_from] -= _value;
99         allowed[_from][msg.sender] -= _value;
100         Transfer(_from, _to, _value);
101         return true;
102     }
103 
104     function approve(address _spender, uint _value)
105         public
106         validAddress(_spender)
107         returns (bool success)
108     {
109         require(_value == 0 || allowed[msg.sender][_spender] == 0);
110         allowed[msg.sender][_spender] = _value;
111         Approval(msg.sender, _spender, _value);
112         return true;
113     }   
114 
115     function balanceOf(address _owner) constant returns (uint256 balance) 
116     {
117         return balances[_owner];
118     }
119 
120     function allowance(address _owner, address _spender) constant returns (uint256 remaining) 
121     {
122         return allowed[_owner][_spender];
123     }
124 
125 
126     function() 
127     {
128         throw;
129     }
130 
131     event Transfer(address indexed _from, address indexed _to, uint _value);
132     event Approval(address indexed _owner, address indexed _spender, uint _value);
133 }