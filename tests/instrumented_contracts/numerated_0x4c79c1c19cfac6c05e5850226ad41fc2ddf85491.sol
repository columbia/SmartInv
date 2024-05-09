1 pragma solidity ^0.4.19;
2 
3 contract StandardToken {
4     function balanceOf(address _owner) constant public returns (uint256);
5     function transfer(address _to, uint256 _value) public returns (bool);
6 }
7 
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     uint256 c = a / b;
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 interface Token { 
33     function transfer(address _to, uint256 _value) public returns (bool);
34     function totalSupply() constant public returns (uint256 supply);
35     function balanceOf(address _owner) constant public returns (uint256 balance);
36 }
37 
38 contract CslTokenDistribution {
39     
40     using SafeMath for uint256;
41     mapping (address => uint256) balances;
42     Token public cslToken;
43     address public owner;
44     uint256 public decimals = 10e17;      //token decimals
45     uint256 public value = 50000;         //50000 tokens for 1 ETH
46     uint256 public bonus = 5000;          //5000 tokens for 1 ETH
47     uint256 public drop;                  //tokens for airdrop
48     bool public contractLocked = true;    //crowdsale locked
49     bool public bonusTime = true;         //bonus true for early investors
50     
51     event sendTokens(address indexed to, uint256 value);
52     event Locked();
53     event Unlocked();
54     event Bonustimer();
55     event NoBonustimer();
56 
57     function CslTokenDistribution(address _tokenAddress, address _owner) public {
58         cslToken = Token(_tokenAddress);
59         owner = _owner;
60     }
61     
62     function transferOwnership(address newOwner) onlyOwner public {
63         if (newOwner != address(0)) {
64         owner = newOwner;
65         }
66     }
67     
68     function setAirdrop(uint256 _Drop) onlyOwner public {
69         drop = _Drop;
70     }
71     
72     function setCrowdsale(uint256 _value, uint256 _bonus) onlyOwner public {
73         value = _value;
74         bonus = _bonus;
75     }
76     
77     modifier onlyOwner() {
78         require(owner == msg.sender);
79         _;
80     }
81     
82     modifier isUnlocked() {
83         require(!contractLocked);
84         _;
85     }
86     
87     function lockContract() onlyOwner public returns (bool) {
88         contractLocked = true;
89         Locked();
90         return true;
91     }
92     
93     function unlockContract() onlyOwner public returns (bool) {
94         contractLocked = false;
95         Unlocked();
96         return false;
97     }
98     
99     function bonusOn() onlyOwner public returns (bool) {
100         bonusTime = true;
101         Bonustimer();
102         return true;
103     }
104     
105     function bonusOff() onlyOwner public returns (bool) {
106         bonusTime = false;
107         NoBonustimer();
108         return false;
109     }
110 
111     function balanceOf(address _holder) constant public returns (uint256 balance) {
112         return balances[_holder];
113     }
114     
115     function getTokenBalance(address who) constant public returns (uint){
116         uint bal = cslToken.balanceOf(who);
117         return bal;
118     }
119     
120     function getEthBalance(address _addr) constant public returns(uint) {
121         return _addr.balance;
122     }
123     
124     function airdrop(address[] addresses) onlyOwner public {
125         
126         require(addresses.length <= 255);
127         
128         for (uint i = 0; i < addresses.length; i++) {
129             sendTokens(addresses[i], drop);
130             cslToken.transfer(addresses[i], drop);
131         }
132 	
133     }
134     
135     function distribution(address[] addresses, uint256 amount) onlyOwner public {
136         
137         require(addresses.length <= 255);
138 
139         for (uint i = 0; i < addresses.length; i++) {
140             sendTokens(addresses[i], amount);
141             cslToken.transfer(addresses[i], amount);
142         }
143 
144     }
145     
146     function distributeAmounts(address[] addresses, uint256[] amounts) onlyOwner public {
147 
148         require(addresses.length <= 255);
149         require(addresses.length == amounts.length);
150         
151         for (uint8 i = 0; i < addresses.length; i++) {
152             sendTokens(addresses[i], amounts[i]);
153             cslToken.transfer(addresses[i], amounts[i]);
154         }
155         
156     }
157     
158     function () external payable {
159             getTokens();
160     }
161     
162     function getTokens() payable isUnlocked public {
163         address investor = msg.sender;
164         uint256 weiAmount = msg.value;
165         uint256 tokens = weiAmount.mul(value);
166         
167         if (msg.value == 0) { return; }
168         if (bonusTime == true) {
169             uint256 bonusTokens = weiAmount.mul(bonus);
170             tokens = tokens.add(bonusTokens);
171         }
172         
173         sendTokens(investor, tokens);
174         cslToken.transfer(investor, tokens);
175     
176     }
177     
178     function tokensAvailable() constant public returns (uint256) {
179         return cslToken.balanceOf(this);
180     }
181     
182     function withdraw() onlyOwner public {
183         uint256 etherBalance = this.balance;
184         owner.transfer(etherBalance);
185     }
186     
187     function withdrawStandardTokens(address _tokenContract) onlyOwner public returns (bool) {
188         StandardToken token = StandardToken(_tokenContract);
189         uint256 amount = token.balanceOf(address(this));
190         return token.transfer(owner, amount);
191     }
192 
193 }