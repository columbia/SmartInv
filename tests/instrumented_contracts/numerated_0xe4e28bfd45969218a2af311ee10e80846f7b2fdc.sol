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
55   uint public hardCap;
56 
57   uint public raised;
58 
59   uint public bonus;
60 
61   address public benefit;
62 
63   uint public start;
64 
65   TrimpoToken token;
66 
67   address public tokenAddress;
68 
69   uint public tokensPerEther;
70 
71   mapping (address => uint) public balanceOf;
72 
73   modifier goodDate {
74     require(start > 0);
75     require(start <= now);
76     require((start+duration) > now);
77     _;
78   }
79 
80   modifier belowHardCap {
81     require(raised < hardCap);
82     _;
83   }
84 
85   event Investing(address investor, uint investedFunds, uint tokensWithoutBonus, uint tokens);
86   event Raise(address to, uint funds);
87 
88 
89   function Presale(
90   address _tokenAddress,
91   address a1,
92   address a2,
93   address a3
94   ) Admins(a1, a2, a3) public {
95 
96     hardCap = 1000 ether;
97 
98     bonus = 50; //percents bonus
99 
100     duration = 61 days;
101 
102     tokensPerEther = 400; //base price without bonus
103 
104     tokenAddress = _tokenAddress;
105 
106     token = TrimpoToken(_tokenAddress);
107 
108     start = 1526342400; //15 May
109 
110   }
111 
112   function() payable public goodDate belowHardCap {
113 
114     uint tokenAmountWithoutBonus = msg.value * tokensPerEther;
115 
116     uint tokenAmount = tokenAmountWithoutBonus + (tokenAmountWithoutBonus * bonus/100);
117 
118     token.transferPresale(msg.sender, tokenAmount);
119 
120     raised+=msg.value;
121 
122     balanceOf[msg.sender]+= msg.value;
123 
124     Investing(msg.sender, msg.value, tokenAmountWithoutBonus, tokenAmount);
125 
126   }
127 
128   function setBenefit(address _benefit) public onlyAdmins {
129     benefit = _benefit;
130   }
131 
132   function getFunds(uint amount) public onlyAdmins {
133     require(benefit != 0x0);
134     require(amount <= this.balance);
135     Raise(benefit, amount);
136     benefit.send(amount);
137   }
138 
139 
140 }