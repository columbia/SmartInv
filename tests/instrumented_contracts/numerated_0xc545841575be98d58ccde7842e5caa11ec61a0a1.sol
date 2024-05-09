1 pragma solidity ^0.4.16;
2 
3 interface TrimpoToken {
4 
5   function presaleAddr() constant returns (address);
6   function transferPresale(address _to, uint _value) public;
7 
8 }
9 
10 contract Admins {
11   address public admin1;
12 
13   address public admin2;
14 
15   address public admin3;
16 
17   function Admins(address a1, address a2, address a3) public {
18     admin1 = a1;
19     admin2 = a2;
20     admin3 = a3;
21   }
22 
23   modifier onlyAdmins {
24     require(msg.sender == admin1 || msg.sender == admin2 || msg.sender == admin3);
25     _;
26   }
27 
28   function setAdmin(address _adminAddress) onlyAdmins public {
29 
30     require(_adminAddress != admin1);
31     require(_adminAddress != admin2);
32     require(_adminAddress != admin3);
33 
34     if (admin1 == msg.sender) {
35       admin1 = _adminAddress;
36     }
37     else
38     if (admin2 == msg.sender) {
39       admin2 = _adminAddress;
40     }
41     else
42     if (admin3 == msg.sender) {
43       admin3 = _adminAddress;
44     }
45   }
46 
47 }
48 
49 
50 contract Presale is Admins {
51 
52 
53   uint public duration;
54 
55   uint public period;
56 
57   uint public periodAmount;
58 
59   uint public hardCap;
60 
61   uint public raised;
62 
63   address public benefit;
64 
65   uint public start;
66 
67   TrimpoToken token;
68 
69   address public tokenAddress;
70 
71   uint public tokensPerEther;
72 
73   mapping (address => uint) public balanceOf;
74 
75   mapping (uint => uint) public periodBonuses;
76 
77   struct amountBonusStruct {
78   uint value;
79   uint bonus;
80   }
81 
82   mapping (uint => amountBonusStruct)  public amountBonuses;
83 
84 
85   modifier goodDate {
86     require(start > 0);
87     require(start <= now);
88     require((start+duration) > now);
89     _;
90   }
91 
92   modifier belowHardCap {
93     require(raised < hardCap);
94     _;
95   }
96 
97   event Investing(address investor, uint investedFunds, uint tokensWithoutBonus, uint periodBounus, uint amountBonus, uint tokens);
98   event Raise(address to, uint funds);
99 
100 
101   function Presale(
102   address _tokenAddress,
103   address a1,
104   address a2,
105   address a3
106   ) Admins(a1, a2, a3) public {
107 
108     hardCap = 5000 ether;
109 
110     period = 7 days;
111 
112     periodAmount = 4;
113 
114     periodBonuses[0] = 20;
115     periodBonuses[1] = 15;
116     periodBonuses[2] = 10;
117     periodBonuses[3] = 5;
118 
119     duration = periodAmount * (period);
120 
121     amountBonuses[0].value = 125 ether;
122     amountBonuses[0].bonus = 5;
123 
124     amountBonuses[1].value = 250 ether;
125     amountBonuses[1].bonus = 10;
126 
127     amountBonuses[2].value = 375 ether;
128     amountBonuses[2].bonus = 15;
129 
130     amountBonuses[3].value = 500 ether;
131     amountBonuses[3].bonus = 20;
132 
133     tokensPerEther = 400;
134 
135     tokenAddress = _tokenAddress;
136 
137     token = TrimpoToken(_tokenAddress);
138 
139     start = 1526342400; //15 May UTC 00:00
140 
141   }
142 
143 
144   function getPeriodBounus() public returns (uint bonus) {
145     if (start == 0) {return 0;}
146     else if (start + period > now) {
147       return periodBonuses[0];
148     } else if (start + period * 2 > now) {
149       return periodBonuses[1];
150     } else if (start + period * 3 > now) {
151       return periodBonuses[2];
152     } else if (start + period * 4 > now) {
153       return periodBonuses[3];
154     }
155     return 0;
156 
157 
158   }
159 
160   function getAmountBounus(uint value) public returns (uint bonus) {
161     if (value >= amountBonuses[3].value) {
162       return amountBonuses[3].bonus;
163     } else if (value >= amountBonuses[2].value) {
164       return amountBonuses[2].bonus;
165     } else if (value >= amountBonuses[1].value) {
166       return amountBonuses[1].bonus;
167     } else if (value >= amountBonuses[0].value) {
168       return amountBonuses[0].bonus;
169     }
170     return 0;
171   }
172 
173   function() payable public goodDate belowHardCap {
174 
175     uint tokenAmountWithoutBonus = msg.value * tokensPerEther;
176 
177     uint periodBonus = getPeriodBounus();
178 
179     uint amountBonus = getAmountBounus(msg.value);
180 
181     uint tokenAmount = tokenAmountWithoutBonus + (tokenAmountWithoutBonus * (periodBonus + amountBonus)/100);
182 
183     token.transferPresale(msg.sender, tokenAmount);
184 
185     raised+=msg.value;
186 
187     balanceOf[msg.sender]+= msg.value;
188 
189     Investing(msg.sender, msg.value, tokenAmountWithoutBonus, periodBonus, amountBonus, tokenAmount);
190 
191   }
192 
193   function setBenefit(address _benefit) public onlyAdmins {
194     benefit = _benefit;
195   }
196 
197   function getFunds(uint amount) public onlyAdmins {
198     require(benefit != 0x0);
199     require(amount <= this.balance);
200     Raise(benefit, amount);
201     benefit.send(amount);
202   }
203 
204 
205 
206 
207 }