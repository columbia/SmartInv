1 //
2 // compiler: solcjs -o ../build/contracts --optimize --abi --bin OX_TOKEN.sol
3 //  version: 0.4.11+commit.68ef5810.Emscripten.clang
4 //
5 pragma solidity ^0.4.11;
6 
7 contract owned {
8   address public owner;
9 
10   function owned() { owner = msg.sender; }
11 
12   modifier onlyOwner {
13     if (msg.sender != owner) { throw; }
14     _;
15   }
16   function changeOwner( address newowner ) onlyOwner {
17     owner = newowner;
18   }
19 }
20 
21 contract OX_TOKEN is owned {
22 
23   string public constant name = "OX";
24   string public constant symbol = "FIXED";
25 
26   event Transfer( address indexed _from,
27                   address indexed _to,
28                    uint256 _value );
29 
30   event Approval( address indexed _owner,
31                   address indexed _spender,
32                   uint256 _value);
33 
34   event Receipt( address indexed _to,
35                  uint _oxen,
36                  uint _paymentwei );
37 
38   uint public starttime;
39   uint public inCirculation;
40   mapping( address => uint ) public oxen;
41   mapping( address => mapping (address => uint256) ) allowed;
42 
43   function OX_TOKEN() {
44     starttime = 0;
45     inCirculation = 0;
46   }
47 
48   function closedown() onlyOwner {
49     selfdestruct( owner );
50   }
51 
52   function() payable {
53     buyOx(); // forwards value, gas
54   }
55 
56   function withdraw( uint amount ) onlyOwner returns (bool success) {
57     if (amount <= this.balance)
58       success = owner.send( amount );
59     else
60       success = false;
61   }
62 
63   function startSale() onlyOwner {
64     if (starttime != 0) return;
65 
66     starttime = now; // now is block timestamp in unix-seconds
67     inCirculation = 500000000; // reserve for org
68     oxen[owner] = inCirculation;
69     Transfer( address(this), owner, inCirculation );
70   }
71 
72   function buyOx() payable {
73 
74     // min purchase .1 E = 10**17 wei
75     if (!saleOn() || msg.value < 100 finney) {
76       throw; // returns caller's Ether and unused gas
77     }
78 
79     // rate: 1 eth <==> 3000 ox
80     // to buy: msg.value * 3000 * (100 + bonus)
81     //         ---------          -------------
82     //          10**18                 100
83     uint ox = div( mul(mul(msg.value,3), 100 + bonus()), 10**17 );
84 
85     if (inCirculation + ox > 1000000000) {
86       throw;
87     }
88 
89     inCirculation += ox;
90     oxen[msg.sender] += ox;
91     Receipt( msg.sender, ox, msg.value );
92   }
93 
94   function totalSupply() constant returns (uint256 totalSupply) {
95     return inCirculation;
96   }
97 
98   function balanceOf(address _owner) constant returns (uint256 balance) {
99     balance = oxen[_owner];
100   }
101 
102   function approve(address _spender, uint256 _amount) returns (bool success) {
103     if (saleOn()) return false;
104 
105     allowed[msg.sender][_spender] = _amount;
106     Approval(msg.sender, _spender, _amount);
107     return true;
108   }
109 
110   function allowance(address _owner, address _spender) constant returns
111   (uint256 remaining) {
112     return allowed[_owner][_spender];
113   }
114 
115   function transfer( address to, uint ox ) returns (bool success) {
116     if ( ox > oxen[msg.sender] || saleOn() ) {
117       return false;
118     }
119 
120     oxen[msg.sender] -= ox;
121     oxen[to] += ox;
122     Transfer( msg.sender, to, ox );
123     return true;
124   }
125 
126   function transferFrom(address _from, address _to, uint256 _amount)
127   returns (bool success) {
128     if (    oxen[_from] >= _amount
129          && allowed[_from][msg.sender] >= _amount
130          && _amount > 0
131          && oxen[_to] + _amount > oxen[_to]
132        )
133     {
134       oxen[_from] -= _amount;
135       allowed[_from][msg.sender] -= _amount;
136       oxen[_to] += _amount;
137       Transfer(_from, _to, _amount);
138       success = true;
139     }
140     else
141     {
142       success = false;
143     }
144   }
145 
146   function saleOn() constant returns(bool) {
147     return now - starttime < 31 days;
148   }
149 
150   function bonus() constant returns(uint) {
151     uint elapsed = now - starttime;
152 
153     if (elapsed < 1 days) return 25;
154     if (elapsed < 1 weeks) return 20;
155     if (elapsed < 2 weeks) return 15;
156     if (elapsed < 3 weeks) return 10;
157     if (elapsed < 4 weeks) return 5;
158     return 0;
159   }
160 
161   // ref:
162   // github.com/OpenZeppelin/zeppelin-solidity/
163   // blob/master/contracts/SafeMath.sol
164   function mul(uint256 a, uint256 b) constant returns (uint256) {
165     uint256 c = a * b;
166     if (a == 0 || c / a == b)
167     return c;
168     else throw;
169   }
170   function div(uint256 a, uint256 b) constant returns (uint256) {
171     uint256 c = a / b;
172     return c;
173   }
174 
175   address public constant AUTHOR = 0x008e9342eb769c4039aaf33da739fb2fc8af9afdc1;
176 }