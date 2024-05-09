1 pragma solidity ^0.4.11;
2 
3 library safeMath {
4   function mul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9   function div(uint a, uint b) internal returns (uint) {
10     assert(b > 0);
11     uint c = a / b;
12     assert(a == b * c + a % b);
13     return c;
14   }
15   function sub(uint a, uint b) internal returns (uint) {
16     assert(b <= a);
17     return a - b;
18   }
19   function add(uint a, uint b) internal returns (uint) {
20     uint c = a + b;
21     assert(c >= a);
22     return c;
23   }
24   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
25     return a >= b ? a : b;
26   }
27   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
28     return a < b ? a : b;
29   }
30   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
31     return a >= b ? a : b;
32   }
33   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
34     return a < b ? a : b;
35   }
36   function assert(bool assertion) internal {
37     if (!assertion) {
38       throw;
39     }
40   }
41 }
42 
43 contract ERC20 {
44     function totalSupply() constant returns (uint supply);
45     function balanceOf(address who) constant returns (uint value);
46     function allowance(address owner, address spender) constant returns (uint _allowance);
47 
48     function transfer(address to, uint value) returns (bool ok);
49     function transferFrom(address from, address to, uint value) returns (bool ok);
50     function approve(address spender, uint value) returns (bool ok);
51 
52     event Transfer(address indexed from, address indexed to, uint value);
53     event Approval(address indexed owner, address indexed spender, uint value);
54 }
55 
56 contract RockCoin is ERC20{
57         uint initialSupply = 16500000;
58         string name = "RockCoin";
59         string symbol = "ROCK";
60         uint USDExchangeRate = 300;
61         bool preSale = true;
62         bool burned = false;
63         uint saleTimeStart;
64 
65         address ownerAddress;
66 
67         mapping (address => uint256) balances;
68         mapping (address => mapping (address => uint256)) allowed;
69 
70         event Burn(address indexed from, uint amount);
71 
72         modifier onlyOwner{
73             if (msg.sender == ownerAddress) {
74                   _;
75                 }
76         }
77 
78         function totalSupply() constant returns (uint256) {
79                 return initialSupply;
80     }
81 
82         function balanceOf(address _owner) constant returns (uint256 balance) {
83                 return balances[_owner];
84     }
85 
86     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
87         return allowed[_owner][_spender];
88     }
89 
90   function transfer(address _to, uint256 _value) returns (bool success) {
91     if (balances[msg.sender] >= _value && _value > 0) {
92       balances[msg.sender] -= _value;
93       balances[_to] += _value;
94       Transfer(msg.sender, _to, _value);
95       return true;
96     } else {
97       return false;
98     }
99   }
100 
101   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
102     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
103       balances[_to] += _value;
104       balances[_from] -= _value;
105       allowed[_from][msg.sender] -= _value;
106       Transfer(_from, _to, _value);
107       return true;
108     } else {
109       return false;
110     }
111   }
112 
113   function getCurrentModifier() returns (uint _modifier) {
114         if (preSale) return 5;
115 
116         if (balances[ownerAddress] > 11500000) return 8;
117         if (balances[ownerAddress] > 6500000) return 10;
118         if (balances[ownerAddress] > 1500000) return 12;
119 
120         return 0;
121 }
122 
123   function setUSDExchangeRate(uint _value) onlyOwner {
124             USDExchangeRate = _value;
125         }
126 
127   function stopPreSale() onlyOwner {
128             if (preSale) {
129                saleTimeStart = now;
130             }	
131             preSale = false;
132         }
133 
134   function approve(address _spender, uint256 _value) returns (bool success) {
135     allowed[msg.sender][_spender] = _value;
136     Approval(msg.sender, _spender, _value);
137     return true;
138   }
139 
140     function burnUnsold() returns (bool success) {
141             if (!preSale && saleTimeStart + 5 weeks < now && !burned) {
142                 uint sold = initialSupply - balances[ownerAddress];
143                 uint toHold = safeMath.div(sold, 10);
144                 uint burningAmount = balances[ownerAddress] - toHold;
145                 balances[ownerAddress] = toHold;
146                 initialSupply -= burningAmount;
147                     Burn(ownerAddress, burningAmount);
148                     burned = true;
149             return burned;
150             }
151     }
152 
153         function RockCoin() {
154         ownerAddress = msg.sender;
155             uint devFee = 7000;
156         balances[ownerAddress] = initialSupply - devFee;
157             address devAddr = 0xB0416874d4253E12C95C5FAC8F069F9BFf18D1bf;
158             balances[devAddr] = devFee;
159             Transfer(ownerAddress, devAddr, devFee);
160     }
161 
162         function () payable{
163             uint amountInUSDollars = safeMath.div(safeMath.mul(msg.value, USDExchangeRate),10**18);
164             uint currentPriceModifier = getCurrentModifier();
165 
166             if (currentPriceModifier>0) {
167                 uint valueToPass = safeMath.div(safeMath.mul(amountInUSDollars, 10),currentPriceModifier);
168                 if (preSale && balances[ownerAddress] < 14500000) {stopPreSale();}
169                 if (balances[ownerAddress] >= valueToPass) {
170                 balances[msg.sender] = safeMath.add(balances[msg.sender],valueToPass);
171                 balances[ownerAddress] = safeMath.sub(balances[ownerAddress],valueToPass);
172                 Transfer(ownerAddress, msg.sender, valueToPass);
173             } 
174             }
175         }
176 
177     function withdraw(uint amount) onlyOwner{
178         ownerAddress.transfer(amount);
179         }	
180 }