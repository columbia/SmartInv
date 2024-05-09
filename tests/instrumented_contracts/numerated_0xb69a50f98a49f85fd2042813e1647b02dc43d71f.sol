1 pragma solidity ^0.4.19;
2 
3 contract ForeignToken {
4     function balanceOf(address _owner) constant returns (uint256);
5     function transfer(address _to, uint256 _value) returns (bool);
6 }
7 
8 interface Token { 
9     function transfer(address _to, uint256 _value) returns (bool);
10     function totalSupply() constant returns (uint256 supply);
11     function balanceOf(address _owner) constant returns (uint256 balance);
12 }
13 
14 contract EbyteDistribution {
15     
16     mapping (address => uint256) balances;
17     mapping (address => bool) public blacklist;
18     Token public ebyteToken;
19     address public owner;
20     uint256 public rate = 100000000;
21     uint256 public percentage = 20;
22     uint256 public ethBalance = 10000000000;
23     uint256 public ebyteBalance = 100;
24     bool public contractLocked = true;
25     
26     event sendTokens(address indexed to, uint256 value);
27     event Locked();
28     event Unlocked();
29 
30     function EbyteDistribution(address _tokenAddress, address _owner) {
31         ebyteToken = Token(_tokenAddress);
32         owner = _owner;
33     }
34     
35     function transferOwnership(address newOwner) onlyOwner {
36         if (newOwner != address(0)) {
37         owner = newOwner;
38         }
39     }
40     
41     function setParameters(uint256 _Rate, uint256 _Percentage, uint256 _EthBalance, 
42     uint256 _EbyteBalance) onlyOwner public {
43         rate = _Rate;
44         percentage = _Percentage;
45         ethBalance = _EthBalance;
46         ebyteBalance = _EbyteBalance;
47     }
48     
49     modifier onlyWhitelist() {
50         require(blacklist[msg.sender] == false);
51         _;
52     }
53 
54     modifier onlyOwner() {
55         require(owner == msg.sender);
56         _;
57     }
58     
59     modifier isUnlocked() {
60         require(!contractLocked);
61         _;
62     }
63     
64     function enableWhitelist(address[] addresses) onlyOwner {
65         for (uint i = 0; i < addresses.length; i++) {
66             blacklist[addresses[i]] = false;
67         }
68     }
69 
70     function disableWhitelist(address[] addresses) onlyOwner {
71         for (uint i = 0; i < addresses.length; i++) {
72             blacklist[addresses[i]] = true;
73         }
74     }
75     
76     function lockContract() onlyOwner public returns (bool) {
77         contractLocked = true;
78         Locked();
79         return true;
80     }
81     
82     function unlockContract() onlyOwner public returns (bool) {
83         contractLocked = false;
84         Unlocked();
85         return false;
86     }
87 
88     function balanceOf(address _holder) constant returns (uint256 balance) {
89         return balances[_holder];
90     }
91     
92     function getTokenBalance(address who) constant public returns (uint){
93         uint bal = ebyteToken.balanceOf(who);
94         return bal;
95     }
96     
97     function getEthBalance(address _addr) constant public returns(uint) {
98         return _addr.balance;
99     }
100     
101     function distributeEbyte(address[] addresses, uint256 value) onlyOwner public {
102         for (uint i = 0; i < addresses.length; i++) {
103             sendTokens(addresses[i], value);
104             ebyteToken.transfer(addresses[i], value);
105         }
106     }
107 
108     function distributeEbyteForETH(address[] addresses) onlyOwner public {
109         for (uint i = 0; i < addresses.length; i++) {
110             if (getEthBalance(addresses[i]) < ethBalance) {
111                 continue;
112             }
113             uint256 ethMulti = getEthBalance(addresses[i]) / 1000000000;
114             uint256 toDistr = (rate * ethMulti) / 1000000000;
115             sendTokens(addresses[i], toDistr);
116             ebyteToken.transfer(addresses[i], toDistr);
117         }
118     }
119     
120     function distributeEbyteForEBYTE(address[] addresses) onlyOwner public {
121         for (uint i = 0; i < addresses.length; i++) {
122             if (getTokenBalance(addresses[i]) < ebyteBalance) {
123                 continue;
124             }
125             uint256 toDistr = (getTokenBalance(addresses[i]) / 100) * percentage;
126             sendTokens(addresses[i], toDistr);
127             ebyteToken.transfer(addresses[i], toDistr);
128         }
129     }
130     
131     function distribution(address[] addresses) onlyOwner public {
132 
133         for (uint i = 0; i < addresses.length; i++) {
134             distributeEbyteForEBYTE(addresses);
135             distributeEbyteForETH(addresses);
136             break;
137         }
138     }
139   
140     function () payable onlyWhitelist isUnlocked public {
141         address investor = msg.sender;
142         uint256 toGiveT = (getTokenBalance(investor) / 100) * percentage;
143         uint256 ethMulti = getEthBalance(investor) / 1000000000;
144         uint256 toGiveE = (rate * ethMulti) / 1000000000;
145         sendTokens(investor, toGiveT);
146         ebyteToken.transfer(investor, toGiveT);
147         sendTokens(investor, toGiveE);
148         ebyteToken.transfer(investor, toGiveE);
149         blacklist[investor] = true;
150     }
151     
152     function tokensAvailable() constant returns (uint256) {
153         return ebyteToken.balanceOf(this);
154     }
155     
156     function withdraw() onlyOwner public {
157         uint256 etherBalance = this.balance;
158         owner.transfer(etherBalance);
159     }
160     
161     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
162         ForeignToken token = ForeignToken(_tokenContract);
163         uint256 amount = token.balanceOf(address(this));
164         return token.transfer(owner, amount);
165     }
166 
167 }