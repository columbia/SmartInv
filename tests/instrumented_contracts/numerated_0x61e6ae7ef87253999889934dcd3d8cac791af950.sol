1 pragma solidity 0.4.24;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 
34 
35 contract Ownable {
36 
37     address public owner;
38 
39     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41     constructor() internal {
42         owner = msg.sender;
43     }
44 
45     modifier onlyOwner() {
46         require(msg.sender == owner);
47         _;
48     }
49 
50     function transferOwnership(address newOwner) public onlyOwner {
51         require(newOwner != address(0));
52         emit OwnershipTransferred(owner, newOwner);
53         owner = newOwner;
54     }
55 }
56 
57 
58 
59 ////////////////////////////////////////////////////////
60 //:                                                  ://
61 //:          SpaceImpulse Public Engagement          ://
62 //:..................................................://
63 ////////////////////////////////////////////////////////
64 
65 
66 
67 
68 contract TokenCHK {
69 
70   function balanceOf(address _owner) public pure returns (uint256 balance) {}
71   function transfer(address to, uint256 value) public returns (bool);
72 }
73 
74 
75 
76 
77 contract SpaceImpulse is Ownable {
78 
79     using SafeMath for uint256;
80 
81     string public name = "SpaceImpulse Public Engagement";      // Extended name of this contract
82     uint256 public tokenPrice;            // Set the fixed SpaceImpulse token price
83     uint256 public maxCap = 0;            // Set the target maximum cap in ETH
84     address public FWDaddrETH;            // Set the address to forward the received ETH to
85     address public SpaceImpulseERC20;     // Set the SpaceImpulse ERC20 contract address
86     uint256 public totalSold;             // Keep track of the contributions total
87     uint256 public minPersonalCap;        // Set the minimal cap in ETH
88     uint256 public decimals = 18;         // The decimals to consider
89 
90     mapping (address => uint256) public sold;         // Map the SpaceImpulse token allcations
91 
92     uint256 public pubEnd;                            // Set the unixtime END for the public engagement
93     address contractAddr = this;                      // Better way to point to this from this
94 
95     // Constant to simplify the conversion of token amounts into integer form
96     uint256 public tokenUnit = uint256(10)**decimals;
97 
98 
99 
100     //
101     // "toETHaddr" is the address to which the ETH contributions are forwarded to, aka FWDaddrETH
102     // "SpaceImpulseERC20" is the address of the SpaceImpulseERC20 token contract.
103     //
104     // NOTE: this contract will sell only its token balance on the ERC20 specified in SpaceImpulseERC20
105     //       the maxCap in ETH and the tokenPrice will indirectly set the SpaceImpulse token amount on sale
106     //
107     // NOTE: this contract should have sufficient SpaceImpulse token balance to be > maxCap / tokenPrice
108     //
109     // NOTE: this contract will stop REGARDLESS of the above (maxCap) when its token balance is all sold
110     //
111     // The Owner of this contract can set: Price, End, MaxCap, SpaceImpulseERC20 and ETH Forward address
112     //
113     // The received ETH are directly forwarded to the external FWDaddrETH address
114     // The SpaceImpulse tokens are transferred to the contributing addresses once withdrawPUB is executed
115     //
116 
117 
118     constructor
119         (
120         address SpaceImpulse_ERC20
121         ) public {
122         FWDaddrETH = 0x69587ed6f526f8B3FD9eB01d4F1FCC86f0394c8f;
123         SpaceImpulseERC20 = SpaceImpulse_ERC20;
124         tokenPrice = 150000000000000;
125         minPersonalCap = 150000000000000000;
126         pubEnd = 1540987140;
127 
128     }
129 
130     function () public payable {
131         buy();               // Allow to buy tokens sending ETH directly to the contract, fallback
132     }
133 
134     function setFWDaddrETH(address _value) public onlyOwner {
135       FWDaddrETH = _value;     // Set the forward address default toETHaddr
136 
137     }
138 
139 
140     function setSpaceImpulse(address _value) public onlyOwner {
141       SpaceImpulseERC20 = _value;     // Set the SpaceImpulseERC20 contract address
142 
143     }
144 
145 
146     function setMaxCap(uint256 _value) public onlyOwner {
147       maxCap = _value;         // Set the max cap in ETH default 0
148 
149     }
150 
151 
152     function setPrice(uint256 _value) public onlyOwner {
153       tokenPrice = _value;     // Set the token price default 0
154 
155     }
156 
157 
158     function setPubEnd(uint256 _value) public onlyOwner {
159       pubEnd = _value;         // Set the END of the public engagement unixtime default 0
160 
161     }
162 
163     function setMinPersonalCap(uint256 _value) public onlyOwner {
164       minPersonalCap = _value;  // Set min amount to buy
165     }
166 
167 
168 
169     function buy() public payable {
170 
171         require(block.timestamp < pubEnd);          // Require the current unixtime to be lower than the END unixtime
172         require(msg.value > 0);                     // Require the sender to send an ETH tx higher than 0
173         require(msg.value <= msg.sender.balance + msg.value);   // Require the sender to have sufficient ETH balance for the tx
174         require(msg.value >= minPersonalCap);        // Require sender eth amount be higher than minPersonalCap
175 
176         // Requiring this to avoid going out of tokens, aka we are getting just true/false from the transfer call
177         require(msg.value + totalSold <= maxCap);
178 
179         // Calculate the amount of tokens per contribution
180         uint256 tokenAmount = (msg.value * tokenUnit) / tokenPrice;
181 
182         // Requiring sufficient token balance on this contract to accept the tx
183         require(tokenAmount + ((totalSold * tokenUnit) / tokenPrice)<=TokenCHK(SpaceImpulseERC20).balanceOf(contractAddr));
184 
185         transferBuy(msg.sender, tokenAmount);       // Instruct the accounting function
186         totalSold = totalSold.add(msg.value);       // Account for the total contributed/sold
187         FWDaddrETH.transfer(msg.value);             // Forward the ETH received to the external address
188 
189     }
190 
191 
192 
193 
194     function withdrawPUB() public returns(bool){
195 
196         require(block.timestamp > pubEnd);          // Require the SpaceImpulse to be over - actual time higher than end unixtime
197         require(sold[msg.sender] > 0);              // Require the SpaceImpulseERC20 token balance to be sent to be higher than 0
198 
199         // Send SpaceImpulseERC20 tokens to the contributors proportionally to their contribution/s
200         if(!SpaceImpulseERC20.call(bytes4(keccak256("transfer(address,uint256)")), msg.sender, sold[msg.sender])){revert();}
201 
202         delete sold[msg.sender];
203         return true;
204 
205     }
206 
207 
208 
209 
210     function transferBuy(address _to, uint256 _value) internal returns (bool) {
211 
212         require(_to != address(0));                 // Require the destination address being non-zero
213 
214         sold[_to] = sold[_to].add(_value);            // Account for multiple txs from the same address
215 
216         return true;
217 
218     }
219 
220 
221 
222         //
223         // Probably the sky would fall down first but, in case skynet feels funny..
224         // ..we try to make sure anyway that no ETH would get stuck in this contract
225         //
226     function EMGwithdraw(uint256 weiValue) external onlyOwner {
227         require(block.timestamp > pubEnd);          // Require the public engagement to be over
228         require(weiValue > 0);                      // Require a non-zero value
229 
230         FWDaddrETH.transfer(weiValue);              // Transfer to the external ETH forward address
231     }
232 
233     function sweep(address _token, uint256 _amount) public onlyOwner {
234         TokenCHK token = TokenCHK(_token);
235 
236         if(!token.transfer(owner, _amount)) {
237             revert();
238         }
239     }
240 
241 }