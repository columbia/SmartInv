1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) constant returns (uint256);
11   function transfer(address to, uint256 value) returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) returns (bool);
22   function approve(address spender, uint256 value) returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31 
32   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
33     uint256 c = a * b;
34     assert(a == 0 || c / a == b);
35     return c;
36   }
37 
38   function div(uint256 a, uint256 b) internal constant returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   function add(uint256 a, uint256 b) internal constant returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55 
56 }
57 
58 contract Owned {
59     /**
60      * Contract owner address
61      */
62     address public owner;
63 
64     /**
65      * @dev Delegate contract to another person
66      * @param _owner New owner address
67      */
68     function setOwner(address _owner) onlyOwner
69     { owner = _owner; }
70 
71     /**
72      * @dev Owner check modifier
73      */
74     modifier onlyOwner { if (msg.sender != owner) throw; _; }
75 }
76 
77 
78 contract RusgasCrowdsale is Owned {
79     using SafeMath for uint;
80 
81     event Print(string _name, uint _value);
82 
83     uint public ETHUSD = 50000; //in cent
84     address manager;
85     address public multisig;
86     address public addressOfERC20Tocken;
87     ERC20 public token;
88 
89     uint public startICO = 1522195200;
90     uint public endICO = 1528847999;
91     
92     uint public phase1Price = 166666666;
93     uint public phase2Price = 125000000;
94     uint public phase3Price = 100000000;
95     uint public phase4Price = 83333333;
96     uint public phase5Price = 62500000;
97     uint public phase6Price = 55555555;
98     uint public phase7Price = 5000000;
99     uint public phase8Price = 4000000;
100     uint public phase9Price = 3000000;
101 
102 
103     function RusgasCrowdsale(){//(address _addressOfERC20Tocken){
104         owner = msg.sender;
105         manager = msg.sender;
106         multisig = msg.sender;
107         //token = ERC20(addressOfERC20Tocken);
108         //token = ERC20(_addressOfERC20Tocken);
109     }
110 
111     function tokenBalance() constant returns (uint256) {
112         return token.balanceOf(address(this));
113     }
114 
115     /* The token address is set when the contract is deployed */
116     function setAddressOfERC20Tocken(address _addressOfERC20Tocken) onlyOwner {
117         addressOfERC20Tocken = _addressOfERC20Tocken;
118         token = ERC20(addressOfERC20Tocken);
119 
120     }
121     /* ETH/USD price */
122         function setETHUSD( uint256 _newPrice ) onlyOwner {
123         require(msg.sender == manager);
124         ETHUSD = _newPrice;
125     }
126 
127     function transferToken(address _to, uint _value) onlyOwner returns (bool) {
128         return token.transfer(_to, _value);
129     }
130 
131     function() payable {
132         doPurchase();
133     }
134 
135     function doPurchase() payable {
136         require(now >= startICO && now < endICO);
137 
138         require(msg.value > 0);
139 
140         uint sum = msg.value;
141 
142         uint tokensAmount;
143 
144         if(now < startICO + (21 days)) {
145             tokensAmount = sum.mul(ETHUSD).mul(phase1Price).div(1000000000000000000);//.mul(token.decimals);
146         } else if(now > startICO + (21 days) && now < startICO + (28 days)) {
147             tokensAmount = sum.mul(ETHUSD).mul(phase2Price).div(1000000000000000000);//.mul(token.decimals);
148         } else if(now > startICO + (28 days) && now < startICO + (35 days)) {
149             tokensAmount = sum.mul(ETHUSD).mul(phase3Price).div(1000000000000000000);//.mul(token.decimals);
150         }else if(now > startICO + (35 days) && now < startICO + (42 days)) {
151             tokensAmount = sum.mul(ETHUSD).mul(phase4Price).div(1000000000000000000);//.mul(token.decimals);
152         }else if(now > startICO + (42 days) && now < startICO + (49 days)) {
153             tokensAmount = sum.mul(ETHUSD).mul(phase5Price).div(1000000000000000000);//.mul(token.decimals);
154         }else if(now > startICO + (49 days) && now < startICO + (56 days)) {
155             tokensAmount = sum.mul(ETHUSD).mul(phase6Price).div(1000000000000000000);//.mul(token.decimals);
156         }else if(now > startICO + (56 days) && now < startICO + (63 days)) {
157             tokensAmount = sum.mul(ETHUSD).mul(phase7Price).div(1000000000000000000);//.mul(token.decimals);
158         }else if(now > startICO + (63 days) && now < startICO + (70 days)) {
159             tokensAmount = sum.mul(ETHUSD).mul(phase8Price).div(1000000000000000000);//.mul(token.decimals);
160         }
161         else
162         {
163             tokensAmount = sum.mul(ETHUSD).mul(phase9Price).div(1000000000000000000);
164         }
165 
166         if(tokenBalance() > tokensAmount){
167             require(token.transfer(msg.sender, tokensAmount));
168             multisig.transfer(msg.value);
169         } else {
170             manager.transfer(msg.value);
171         }
172     }
173 }