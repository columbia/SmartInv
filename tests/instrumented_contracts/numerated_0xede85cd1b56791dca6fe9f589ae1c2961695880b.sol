1 /*
2 Binks Bucks Solidity Code:
3 Created for Doug Polk
4 Authored by Chris Digirolamo
5 **/
6 pragma solidity ^0.4.18;
7 
8 contract BinksBucksToken {
9     /*
10     This class implements the ERC20 Functionality for Binks Bucks
11     along with other standard token helpers (e.g. Name, symbol, etc.).
12     **/
13     string public constant name = "Binks Bucks";
14     string public constant symbol = "BINX";
15     uint8 public constant decimals = 18;
16     uint internal _totalSupply = 0;
17     mapping(address => uint256) internal _balances;
18     mapping(address => mapping (address => uint256)) _allowed;
19 
20     function totalSupply() public constant returns (uint) {
21         /*
22         Gets the total supply of Binks Bucks.
23         **/
24         return _totalSupply;
25     }
26 
27     function balanceOf(address owner) public constant returns (uint) {
28         /*
29         Get the balance of an account.
30         **/
31         return _balances[owner];
32     }
33 
34     // Helper Functions
35     function hasAtLeast(address adr, uint amount) constant internal returns (bool) {
36         if (amount <= 0) {return false;}
37         return _balances[adr] >= amount;
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
60         /*
61         Sends tokens to an address if you have the balance
62         **/
63         require(canRecieve(to, amount));
64         require(hasAtLeast(msg.sender, amount));
65         _balances[msg.sender] -= amount;
66         _balances[to] += amount;
67         Transfer(msg.sender, to, amount);
68         return true;
69     }
70 
71    function allowance(address proxy, address spender) public constant returns (uint) {
72        /*
73        Returns the amount which spender is still allowed to withdraw from
74        proxy allowance.
75        **/
76         return _allowed[proxy][spender];
77     }
78 
79     function approve(address spender, uint amount) public returns (bool) {
80         /*
81         Allows spender to withdraw from your account, multiple times,
82         up to the _value amount. If this function is called again it
83         overwrites the current allowance with _value
84         **/
85         _allowed[msg.sender][spender] = amount;
86         Approval(msg.sender, spender, amount);
87         return true;
88     }
89 
90     function transferFrom(address from, address to, uint amount) public returns (bool) {
91         /*
92         Sends an amount of tokens from address an address if proxy allowance exists.
93         **/
94         require(hasAllowance(msg.sender, from, amount));
95         require(canRecieve(to, amount));
96         require(hasAtLeast(from, amount));
97         _allowed[from][msg.sender] -= amount;
98         _balances[from] -= amount;
99         _balances[to] += amount;
100         Transfer(from, to, amount);
101         return true;
102     }
103 
104     event Transfer(address indexed, address indexed, uint);
105     event Approval(address indexed proxy, address indexed spender, uint amount);
106 }
107 
108 contract Giveaway is BinksBucksToken {
109     /*
110     This class implements giveaway code functionality.
111     The tokens actually stored in the contracts address are able
112     to be given away.
113     **/
114     address internal giveaway_master;
115     address internal imperator;
116     uint32 internal _code = 0;
117     uint internal _distribution_size = 1000000000000000000000;
118     uint internal _max_distributions = 100;
119     uint internal _distributions_left = 100;
120     uint internal _distribution_number = 0;
121     mapping(address => uint256) internal _last_distribution;
122 
123     function transferAdmin(address newImperator) public {
124             require(msg.sender == imperator);
125             imperator = newImperator;
126         }
127 
128     function transferGiveaway(address newaddress) public {
129         require(msg.sender == imperator || msg.sender == giveaway_master);
130         giveaway_master = newaddress;
131     }
132 
133     function startGiveaway(uint32 code, uint max_distributions) public {
134         /*
135         Starts a giveaway using a code. Only max_distributions will be given
136         out.
137         **/
138         require(msg.sender == imperator || msg.sender == giveaway_master);
139         _code = code;
140         _max_distributions = max_distributions;
141         _distributions_left = max_distributions;
142         _distribution_number += 1;
143     }
144 
145     function setDistributionSize(uint num) public {
146         /*
147         Sets the size, remember, the amount is in the smallest decimal increment.
148         num=1000000000000000000000 is 1000 BINX.
149         Disables the current giveaway when changed.
150         **/
151         require(msg.sender == imperator || msg.sender == giveaway_master);
152         _code = 0;
153         _distribution_size = num;
154     }
155 
156     function CodeEligible() public view returns (bool) {
157         /*
158         Checks if you can enter a code yet.
159         **/
160         return (_code != 0 && _distributions_left > 0 && _distribution_number > _last_distribution[msg.sender]);
161     }
162 
163     function EnterCode(uint32 code) public {
164         /*
165         Enters a code in a giveaway.
166         **/
167         require(CodeEligible());
168         if (code == _code) {
169             _last_distribution[msg.sender] = _distribution_number;
170             _distributions_left -= 1;
171             require(canRecieve(msg.sender, _distribution_size));
172             require(hasAtLeast(this, _distribution_size));
173             _balances[this] -= _distribution_size;
174             _balances[msg.sender] += _distribution_size;
175             Transfer(this, msg.sender, _distribution_size);
176         }
177     }
178 }
179 
180 contract BinksBucks is BinksBucksToken, Giveaway {
181     /*
182     The Binks Bucks contract.
183     **/
184     function BinksBucks(address bossman) public {
185         imperator = msg.sender;
186         giveaway_master = bossman;
187         // The contract itself is given a balance for giveaways
188         _balances[this] += 240000000000000000000000000;
189         _totalSupply += 240000000000000000000000000;
190         // Bossman gets the rest
191         _balances[bossman] += 750000000000000000000000000;
192         _totalSupply += 750000000000000000000000000;
193         // For first transfer back into contract
194         _balances[msg.sender] += 10000000000000000000000000;
195         _totalSupply += 10000000000000000000000000;
196     }
197 }