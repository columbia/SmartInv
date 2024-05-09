1 pragma solidity ^0.4.0;
2 
3 contract CrypteloERC20{
4   function transfer(address to, uint amount);
5 }
6 
7 contract CrypteloPreSale {
8     using SafeMath for uint256;
9     mapping (address => bool) private owners;
10     mapping (address => uint) private WhiteListed; 
11     //if 1 its the first group, if 2 second group
12     //1st group minimum = 0.1 Ether
13     //2st group minimum = 40 Ether
14     
15     mapping (address => uint256) private vestedTokens;
16     mapping (address => uint256) private dateInvested;
17     mapping (address => uint256) private firstDeadline;
18 
19     uint private firstGminimumWeiAmount =  100000000000000000; //0.1 ether
20     uint private secondGminimumWeiAmount = 40000000000000000000; //40 ether
21     uint public weiHardCap = 3625000000000000000000; //3625 ether
22     uint public weiRaised = 0;
23     uint private weiLeft = weiHardCap;
24     uint private CRLTotal = 9062500000000000;
25     uint private CRLToSell = CRLTotal.div(2);
26     uint private totalVesting = 0;
27     uint private totalCRLDistributed = 0;
28     uint private CRLLeft = CRLTotal;
29     uint public CRLperEther = 1250000000000; //with full decimals
30     uint public CRLperMicroEther = CRLperEther.div(1000000);
31     
32     
33     address public CrypteloERC20Address = 0x7123027d76a5135e66b3a365efaba2b55de18a62;
34     address private forwardFundsWallet = 0xd6c56d07665D44159246517Bb4B2aC9bBeb040cf;
35     
36     
37     uint firstTimeOffset = 1 years;
38 
39     //events
40     event eRefund(address _addr, uint _weiAmount, string where);
41     event eTokensToSend(address _addr, uint _CRLTokens);
42     event eSendTokens(address _addr, uint _amount);
43 
44     
45     
46     function CrypteloPreSale(){
47         owners[msg.sender] = true;
48     }
49 
50     function () payable {
51         uint amountEthWei = msg.value;
52         address sender = msg.sender;
53         uint totalAmountWei;
54         uint tokensToSend = 0;
55         uint limit = 0;
56 
57         if ( WhiteListed[sender] == 0 || amountEthWei > weiLeft){
58             refund(sender, amountEthWei);
59             eRefund(sender, amountEthWei, "L 58");
60         }else{
61             if(WhiteListed[sender] == 1){ //sender is first group
62                 limit = firstGminimumWeiAmount;
63             }else{
64                 limit = secondGminimumWeiAmount;
65             }
66             if(amountEthWei >= limit){
67                 uint amountMicroEther = amountEthWei.div(1000000000000);
68                 tokensToSend = amountMicroEther.mul(CRLperMicroEther);
69                 eTokensToSend(sender, tokensToSend);
70                 if (totalCRLDistributed.add(tokensToSend) <= CRLToSell){
71                     sendTokens(sender, tokensToSend);
72                     totalCRLDistributed = totalCRLDistributed.add(tokensToSend);
73                     vestTokens(sender, tokensToSend); //vest the same amount
74                     forwardFunds(amountEthWei);
75                     weiRaised = weiRaised.add(amountEthWei);
76                     assert(weiLeft >= amountEthWei);
77                     weiLeft = weiLeft.sub(amountEthWei);
78                 }else{
79                     refund(sender, amountEthWei);
80                     eRefund(sender, amountEthWei, "L 84");
81                 }
82                 
83             }else{
84                 refund(sender, amountEthWei);
85                 eRefund(sender, amountEthWei, "L 75");
86             }
87         }
88     }
89     
90     
91     function forwardFunds(uint _amountEthWei) private{
92         forwardFundsWallet.send(_amountEthWei);  //find balance
93     }
94     
95     function getTotalVesting() public returns (uint _totalvesting){
96         return totalVesting;
97     }
98     
99     function getTotalDistributed() public returns (uint _totalvesting){
100         return totalCRLDistributed;
101     }
102     
103     function vestTokens(address _addr, uint _amountCRL) private returns (bool _success){
104         totalVesting = totalVesting.add(_amountCRL);
105         vestedTokens[_addr] = _amountCRL;  
106         dateInvested[_addr] = now;
107         firstDeadline[_addr] = now.add(firstTimeOffset);
108     }
109     function sendTokens(address _to, uint _amountCRL) private returns (address _addr, uint _amount){
110         //invoke call on token address
111        CrypteloERC20 _crypteloerc20;
112         _crypteloerc20 = CrypteloERC20(CrypteloERC20Address);
113         _crypteloerc20.transfer(_to, _amountCRL);
114         eSendTokens(_to, _amountCRL);
115     }
116     
117     function checkMyTokens() public returns (uint256 _CRLtokens) {
118         return vestedTokens[msg.sender];
119     }
120     
121     function checkMyVestingPeriod() public returns (uint256 _first){
122         return (firstDeadline[msg.sender]);
123     }
124     
125     function claimTokens(address _addr){ //add wallet here
126         uint amount = 0;
127 
128         if (dateInvested[_addr] > 0 && vestedTokens[_addr] > 0 && now > firstDeadline[_addr]){
129             amount = amount.add(vestedTokens[_addr]); //allow half of the tokens to be transferred
130             vestedTokens[_addr] = 0;
131             if (amount > 0){
132                 //transfer amount to owner
133                 sendTokens(msg.sender, amount); 
134                 totalVesting = totalVesting.sub(amount);
135             }
136         }
137     }
138      
139     function refund(address _sender, uint _amountWei) private{
140         //refund ether to sender minus transaction fees
141         _sender.send(_amountWei);
142     }
143     function addWhiteList(address _addr, uint group){
144         if (owners[msg.sender] && group <= 2){
145             WhiteListed[_addr] = group; 
146         }
147     }
148     
149     function removeWhiteList(address _addr){
150         if (owners[msg.sender]){
151             WhiteListed[_addr] = 0; 
152         }
153     }
154     
155     function isWhiteList(address _addr) public returns (uint _group){
156         return WhiteListed[_addr];
157     }
158     
159     function withdrawDistributionCRL(){
160         if (owners[msg.sender]){
161             uint amount = CRLTotal.sub(totalCRLDistributed).sub(totalCRLDistributed);
162             sendTokens(msg.sender, amount);
163         }
164     }
165     
166     function withdrawAllEther(){
167         if (owners[msg.sender]){
168             msg.sender.send(this.balance);
169         }
170     }
171 }
172 
173 /**
174  * @title SafeMath
175  * @dev Math operations with safety checks that throw on error
176  */
177 library SafeMath {
178 
179   /**
180   * @dev Multiplies two numbers, throws on overflow.
181   */
182   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
183     if (a == 0) {
184       return 0;
185     }
186     uint256 c = a * b;
187     assert(c / a == b);
188     return c;
189   }
190 
191   /**
192   * @dev Integer division of two numbers, truncating the quotient.
193   */
194   function div(uint256 a, uint256 b) internal pure returns (uint256) {
195     // assert(b > 0); // Solidity automatically throws when dividing by 0
196     uint256 c = a / b;
197     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
198     return c;
199   }
200 
201   /**
202   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
203   */
204   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
205     assert(b <= a);
206     return a - b;
207   }
208 
209   /**
210   * @dev Adds two numbers, throws on overflow.
211   */
212   function add(uint256 a, uint256 b) internal pure returns (uint256) {
213     uint256 c = a + b;
214     assert(c >= a);
215     return c;
216   }
217 }