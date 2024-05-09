1 /**
2  * Copyright (C) Siousada.io
3  * All rights reserved.
4  * Author: info@siousada.io
5  *
6  * MIT License
7  *
8  * Permission is hereby granted, free of charge, to any person obtaining a copy 
9  * of this software and associated documentation files (the ""Software""), to 
10  * deal in the Software without restriction, including without limitation the 
11  * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or 
12  * sell copies of the Software, and to permit persons to whom the Software is 
13  * furnished to do so, subject to the following conditions: 
14  *  The above copyright notice and this permission notice shall be included in 
15  *  all copies or substantial portions of the Software.
16  *
17  * THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
18  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
19  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
20  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
21  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
22  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
23  * THE SOFTWARE.
24  *
25  */
26 pragma solidity ^0.4.11;
27 
28 /**
29  * Guards is a handful of modifiers to be used throughout this project
30  */
31 contract Guarded {
32 
33     modifier isValidAmount(uint256 _amount) { 
34         require(_amount > 0); 
35         _; 
36     }
37 
38     // ensure address not null, and not this contract address
39     modifier isValidAddress(address _address) {
40         require(_address != 0x0 && _address != address(this));
41         _;
42     }
43 
44 }
45 
46 contract Ownable {
47     address public owner;
48 
49     /** 
50      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51      * account.
52      */
53     function Ownable() {
54         owner = msg.sender;
55     }
56 
57     /**
58      * @dev Throws if called by any account other than the owner. 
59      */
60     modifier onlyOwner() {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     /**
66      * @dev Allows the current owner to transfer control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to. 
68      */
69     function transferOwnership(address newOwner) onlyOwner {
70         if (newOwner != address(0)) {
71             owner = newOwner;
72         }
73     }
74 }
75 
76 /**
77  * @title SafeMath
78  * @dev Math operations with safety checks that throw on error
79  */
80 library SafeMath {
81     function mul(uint256 a, uint256 b) internal returns (uint256) {
82         uint256 c = a * b;
83         assert(a == 0 || c / a == b);
84         return c;
85     }
86 
87     function div(uint256 a, uint256 b) internal returns (uint256) {
88         // assert(b > 0); // Solidity automatically throws when dividing by 0
89         uint256 c = a / b;
90         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91         return c;
92     }
93 
94     function sub(uint256 a, uint256 b) internal returns (uint256) {
95         assert(b <= a);
96         return a - b;
97     }
98 
99     function add(uint256 a, uint256 b) internal returns (uint256) {
100         uint256 c = a + b;
101         assert(c >= a);
102         return c;
103     }
104 }
105 
106 
107 contract SSDTokenSwap is Guarded, Ownable {
108 
109     using SafeMath for uint256;
110 
111     mapping(address => uint256) contributions;          // contributions from public
112     uint256 contribCount = 0;
113 
114     string public version = '0.1.2';
115 
116     uint256 public startBlock = 4303063;                // 22nd September 2017, 08:00:00 - 1506067200
117     uint256 public endBlock = 4324663;                  // 28nd September 2017, 08:00:00 - 1506585600
118 
119     uint256 public totalEtherCap = 200222 ether;       // Total raised for ICO, at USD 211/ether
120     uint256 public weiRaised = 0;                       // wei raised in this ICO
121     uint256 public minContrib = 0.05 ether;             // min contribution accepted
122 
123     address public wallet = 0xe53df71148021F280Eb13FcD8679b01200e0C348;
124 
125     event Contribution(address indexed _contributor, uint256 _amount);
126 
127     function SSDTokenSwap() {
128     }
129 
130     // function to start the Token Sale
131     /// start the token sale at `_starBlock`
132     function setStartBlock(uint256 _startBlock) onlyOwner public {
133         startBlock = _startBlock;
134     }
135 
136     // function to stop the Token Swap 
137     /// stop the token swap at `_endBlock`
138     function setEndBlock(uint256 _endBlock) onlyOwner public {
139         endBlock = _endBlock;
140     }
141 
142     // this function is to add the previous token sale balance.
143     /// set the accumulated balance of `_weiRaised`
144     function setWeiRaised(uint256 _weiRaised) onlyOwner public {
145         weiRaised = weiRaised.add(_weiRaised);
146     }
147 
148     // set the wallet address
149     /// set the wallet at `_wallet`
150     function setWallet(address _wallet) onlyOwner public {
151         wallet = _wallet;
152     }
153 
154     /// set the minimum contribution to `_minContrib`
155     function setMinContribution(uint256 _minContrib) onlyOwner public {
156         minContrib = _minContrib;
157     }
158 
159     // @return true if token swap event has ended
160     function hasEnded() public constant returns (bool) {
161         return block.number >= endBlock;
162     }
163 
164     // @return true if the token swap contract is active.
165     function isActive() public constant returns (bool) {
166         return block.number >= startBlock && block.number <= endBlock;
167     }
168 
169     function () payable {
170         processContributions(msg.sender, msg.value);
171     }
172 
173     /**
174      * Okay, we changed the process flow a bit where the actual SSD to ETH
175      * mapping shall be calculated, and pushed to the contract once the
176      * crowdsale is over.
177      *
178      * Then, the user can pull the tokens to their wallet.
179      *
180      */
181     function processContributions(address _contributor, uint256 _weiAmount) payable {
182         require(validPurchase());
183 
184         uint256 updatedWeiRaised = weiRaised.add(_weiAmount);
185 
186         // update state
187         weiRaised = updatedWeiRaised;
188 
189         // notify event for this contribution
190         contributions[_contributor] = contributions[_contributor].add(_weiAmount);
191         contribCount += 1;
192         Contribution(_contributor, _weiAmount);
193 
194         // forware the funds
195         forwardFunds();
196     }
197 
198     // @return true if the transaction can buy tokens
199     function validPurchase() internal constant returns (bool) {
200         uint256 current = block.number;
201 
202         bool withinPeriod = current >= startBlock && current <= endBlock;
203         bool minPurchase = msg.value >= minContrib;
204 
205         // add total wei raised
206         uint256 totalWeiRaised = weiRaised.add(msg.value);
207         bool withinCap = totalWeiRaised <= totalEtherCap;
208 
209         // check all 3 conditions met
210         return withinPeriod && minPurchase && withinCap;
211     }
212 
213     // send ether to the fund collection wallet
214     // override to create custom fund forwarding mechanisms
215     function forwardFunds() internal {
216         wallet.transfer(msg.value);
217     }
218 
219 }