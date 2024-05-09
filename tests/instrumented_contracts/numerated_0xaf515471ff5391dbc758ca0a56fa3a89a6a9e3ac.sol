1 pragma solidity ^0.4.18;
2 
3 contract BinksBucks  {
4     // Token Vars
5     string public constant name = "Binks Bucks";
6     string public constant symbol = "BNKS";
7     uint8 internal _decimals = 18;
8     uint internal _totalSupply = 0;
9     mapping(address => uint256) internal _balances;
10     mapping(address => mapping (address => uint256)) _allowed;
11 
12     // Code Entry Vars
13     address internal imperator;
14     uint internal _code = 0;
15     uint internal _distribution_size = 1000000000000000000000;
16     uint internal _max_distributions = 100;
17     uint internal _distributions_left = 100;
18     uint internal _distribution_number = 0;
19     mapping(address => uint256) internal _last_distribution;
20     
21     function BinksBucks(address bossman) public {
22         imperator = msg.sender;
23         _balances[this] += 250000000000000000000000000;
24         _totalSupply += 250000000000000000000000000;
25         _balances[bossman] += 750000000000000000000000000;
26         _totalSupply += 750000000000000000000000000;
27     }
28 
29     function totalSupply() public constant returns (uint) {return _totalSupply;}
30     function decimals() public constant returns (uint8) {return _decimals;}
31     function balanceOf(address owner) public constant returns (uint) {return _balances[owner];}
32 
33     // Helper Functions
34     function hasAtLeast(address adr, uint amount) constant internal returns (bool) {
35         if (amount <= 0) {return false;}
36         return _balances[adr] >= amount;
37 
38     }
39 
40     function canRecieve(address adr, uint amount) constant internal returns (bool) {
41         if (amount <= 0) {return false;}
42         uint balance = _balances[adr];
43         return (balance + amount > balance);
44     }
45 
46     function hasAllowance(address proxy, address spender, uint amount) constant internal returns (bool) {
47         if (amount <= 0) {return false;}
48         return _allowed[spender][proxy] >= amount;
49     }
50 
51     function canAdd(uint x, uint y) pure internal returns (bool) {
52         uint total = x + y;
53         if (total > x && total > y) {return true;}
54         return false;
55     }
56     
57     // End Helper Functions
58 
59     function transfer(address to, uint amount) public returns (bool) {
60         require(canRecieve(to, amount));
61         require(hasAtLeast(msg.sender, amount));
62         _balances[msg.sender] -= amount;
63         _balances[to] += amount;
64         Transfer(msg.sender, to, amount);
65         return true;
66     }
67 
68     function allowance(address proxy, address spender) public constant returns (uint) {
69         return _allowed[proxy][spender];
70     }
71 
72     function approve(address spender, uint amount) public returns (bool) {
73         _allowed[msg.sender][spender] = amount;
74         Approval(msg.sender, spender, amount);
75         return true;
76     }
77 
78     function transferFrom(address from, address to, uint amount) public returns (bool) {
79         require(hasAllowance(msg.sender, from, amount));
80         require(canRecieve(to, amount));
81         require(hasAtLeast(from, amount));
82         _allowed[from][msg.sender] -= amount;
83         _balances[from] -= amount;
84         _balances[to] += amount;
85         Transfer(from, to, amount);
86         return true;
87     }
88     
89     function transferEmpire(address newImperator) public {
90             require(msg.sender == imperator);
91             imperator = newImperator;
92         }
93 
94     function setCode(uint code) public {
95         require(msg.sender == imperator);
96         _code = code;
97         _distributions_left = _max_distributions;
98         _distribution_number += 1;
99     }
100 
101     function setMaxDistributions(uint num) public {
102         require(msg.sender == imperator);
103         _max_distributions = num;
104     }
105 
106     function setDistributionSize(uint num) public {
107         require(msg.sender == imperator);
108         _distribution_size = num;
109     }
110 
111     function CodeEligible() public view returns (bool) {
112         return (_code != 0 && _distributions_left > 0 && _distribution_number > _last_distribution[msg.sender]);
113     }
114 
115     function EnterCode(uint code) public {
116         require(CodeEligible());
117         if (code == _code) {
118             _last_distribution[msg.sender] = _distribution_number;
119             _distributions_left -= 1;
120             require(canRecieve(msg.sender, _distribution_size));
121             require(hasAtLeast(this, _distribution_size));
122             _balances[this] -= _distribution_size;
123             _balances[msg.sender] += _distribution_size;
124             Transfer(this, msg.sender, _distribution_size);
125         }
126     }
127 
128     event Transfer(address indexed, address indexed, uint);
129     event Approval(address indexed proxy, address indexed spender, uint amount);
130 }