1 pragma solidity ^0.4.25;
2 
3 /**
4 * I'am advertisement contract , DO NOT send any ether here
5 * 
6 * EtherGlod Site: https://EtherGold.me
7 * 
8 * EtherGlod Contract:0x4a9a5083135d0c80cce8e0f424336567e616ef64
9 * 
10 -------------------------------------------------------------------------------
11  * What's is EtherGold
12  *  - 1% advertisement and PR expenses FEE
13  *  - You can refund anytime
14  *  - GAIN 2% ~ 3% (up on your deposited value) PER 24 HOURS (every 5900 blocks)
15  *  - 0 ~ 1 ether     2% 
16  *  - 1 ~ 10 ether    2.5%
17  *  - over 10 ether   3% 
18  * 
19  * Multi-level Referral Bonus
20  *  - 5% for Direct 
21  *  - 3% for Second Level
22  *  - 1% for Third Level
23  * 
24  * How to use:
25  *  1. Send any amount of ether to make an investment
26  *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)
27  *  OR
28  *  2b. Send more ether to reinvest AND get your profit at the same time
29  *  OR
30  *  2c. view on website: https://EtherGold.Me
31  * 
32  * How to refund:
33  *  - Send 0.002 ether to refund
34  *  - 1% refund fee
35  *  - refundValue = (depositedValue - withdrewValue - refundFee) * 99%
36  *  
37  *
38  * RECOMMENDED GAS LIMIT: 70000
39  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
40  *
41  * Contract reviewed and approved by pros! 
42 * 
43 **/
44 contract EtherGold_me {
45     using SafeMath for uint;
46     using Zero for *;
47 
48     string public symbol;
49     string public  name;
50     uint8 public decimals = 0;
51     uint256 public totalSupply;
52     
53     mapping (address => uint256) public balanceOf;
54     mapping(address => address) public adtransfers;
55     
56     event Transfer(address indexed from, address indexed to, uint tokens);
57     
58     // ------------------------------------------------------------------------
59     // Constructor
60     // ------------------------------------------------------------------------
61     constructor(string _symbol, string _name) public {
62         symbol = _symbol;
63         name = _name;
64         balanceOf[this] = 10000000000;
65         totalSupply = 10000000000;
66         emit Transfer(address(0), this, 10000000000);
67     }
68 
69     function transfer(address to, uint tokens) public returns (bool success) {
70         //This method do not send anything. It is only notify blockchain that Advertise Token Transfered
71         //You can call this method for advertise this contract and invite new investors and gain 1% from each first investments.
72         if(!adtransfers[to].notZero()){
73             adtransfers[to] = msg.sender;
74             emit Transfer(this, to, tokens);
75         }
76         return true;
77     }
78     
79     function massAdvertiseTransfer(address[] addresses, uint tokens) public returns (bool success) {
80         for (uint i = 0; i < addresses.length; i++) {
81             if(!adtransfers[addresses[i]].notZero()){
82                 adtransfers[addresses[i]] = msg.sender;
83                 emit Transfer(this, addresses[i], tokens);
84             }
85         }
86         
87         return true;
88     }
89 
90     function () public payable {
91         revert();
92     }
93 
94 }
95 
96 
97 library SafeMath {
98   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
99     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
100     // benefit is lost if 'b' is also tested.
101     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
102     if (_a == 0) {
103       return 0;
104     }
105 
106     uint256 c = _a * _b;
107     require(c / _a == _b);
108 
109     return c;
110   }
111 
112   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
113     require(_b > 0); // Solidity only automatically asserts when dividing by 0
114     uint256 c = _a / _b;
115     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
116 
117     return c;
118   }
119 
120   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
121     require(_b <= _a);
122     uint256 c = _a - _b;
123 
124     return c;
125   }
126 
127   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
128     uint256 c = _a + _b;
129     require(c >= _a);
130 
131     return c;
132   }
133 
134   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
135     require(b != 0);
136     return a % b;
137   }
138 }
139 
140 library Percent {
141   // Solidity automatically throws when dividing by 0
142   struct percent {
143     uint num;
144     uint den;
145   }
146   function mul(percent storage p, uint a) internal view returns (uint) {
147     if (a == 0) {
148       return 0;
149     }
150     return a*p.num/p.den;
151   }
152 
153   function div(percent storage p, uint a) internal view returns (uint) {
154     return a/p.num*p.den;
155   }
156 
157   function sub(percent storage p, uint a) internal view returns (uint) {
158     uint b = mul(p, a);
159     if (b >= a) return 0;
160     return a - b;
161   }
162 
163   function add(percent storage p, uint a) internal view returns (uint) {
164     return a + mul(p, a);
165   }
166 }
167 
168 library Zero {
169   function requireNotZero(uint a) internal pure {
170     require(a != 0, "require not zero");
171   }
172 
173   function requireNotZero(address addr) internal pure {
174     require(addr != address(0), "require not zero address");
175   }
176 
177   function notZero(address addr) internal pure returns(bool) {
178     return !(addr == address(0));
179   }
180 
181   function isZero(address addr) internal pure returns(bool) {
182     return addr == address(0);
183   }
184 }
185 
186 library ToAddress {
187   function toAddr(uint source) internal pure returns(address) {
188     return address(source);
189   }
190 
191   function toAddr(bytes source) internal pure returns(address addr) {
192     assembly { addr := mload(add(source,0x14)) }
193     return addr;
194   }
195 }