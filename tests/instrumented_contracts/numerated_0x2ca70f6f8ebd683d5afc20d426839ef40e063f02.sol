1 /**
2  * Copyright (C) Virtue Fintech FZ-LLC, Dubai
3  * All rights reserved.
4  * Author: mhi@virtue.finance 
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
74 
75 }
76 
77 
78 /**
79  * @title SafeMath
80  * @dev Math operations with safety checks that throw on error
81  */
82 library SafeMath {
83     function mul(uint256 a, uint256 b) internal returns (uint256) {
84         uint256 c = a * b;
85         assert(a == 0 || c / a == b);
86         return c;
87     }
88 
89     function div(uint256 a, uint256 b) internal returns (uint256) {
90         // assert(b > 0); // Solidity automatically throws when dividing by 0
91         uint256 c = a / b;
92         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
93         return c;
94     }
95 
96     function sub(uint256 a, uint256 b) internal returns (uint256) {
97         assert(b <= a);
98         return a - b;
99     }
100 
101     function add(uint256 a, uint256 b) internal returns (uint256) {
102         uint256 c = a + b;
103         assert(c >= a);
104         return c;
105     }
106 }
107 
108 
109 contract FaradTokenSwap is Guarded, Ownable {
110 
111     using SafeMath for uint256;
112 
113     mapping(address => uint256) contributions;          // contributions from public
114     uint256 contribCount = 0;
115 
116     string public version = '0.1.2';
117 
118     uint256 public startBlock = 4280263;                // 16th September 2017, 00:00:00
119     uint256 public endBlock = 4445863;                  // 30th October 2017, 23:59:59
120 
121     uint256 public totalEtherCap = 1184834 ether;       // Total raised for ICO, at USD 211/ether
122     uint256 public weiRaised = 0;                       // wei raised in this ICO
123     uint256 public minContrib = 0.05 ether;             // min contribution accepted
124 
125     address public wallet = 0x82bF3620e9c73AC57C3b9bA4F7d89E1A40641E6e;
126 
127     event Contribution(address indexed _contributor, uint256 _amount);
128 
129     function FaradTokenSwap() {
130     }
131 
132     // function to start the Token Sale
133     /// start the token sale at `_starBlock`
134     function setStartBlock(uint256 _startBlock) onlyOwner public {
135         startBlock = _startBlock;
136     }
137 
138     // function to stop the Token Swap 
139     /// stop the token swap at `_endBlock`
140     function setEndBlock(uint256 _endBlock) onlyOwner public {
141         endBlock = _endBlock;
142     }
143 
144     // this function is to add the previous token sale balance.
145     /// set the accumulated balance of `_weiRaised`
146     function setWeiRaised(uint256 _weiRaised) onlyOwner public {
147         weiRaised = weiRaised.add(_weiRaised);
148     }
149 
150     // set the wallet address
151     /// set the wallet at `_wallet`
152     function setWallet(address _wallet) onlyOwner public {
153         wallet = _wallet;
154     }
155 
156     /// set the minimum contribution to `_minContrib`
157     function setMinContribution(uint256 _minContrib) onlyOwner public {
158         minContrib = _minContrib;
159     }
160 
161     // @return true if token swap event has ended
162     function hasEnded() public constant returns (bool) {
163         return block.number >= endBlock;
164     }
165 
166     // @return true if the token swap contract is active.
167     function isActive() public constant returns (bool) {
168         return block.number >= startBlock && block.number <= endBlock;
169     }
170 
171     function () payable {
172         processContributions(msg.sender, msg.value);
173     }
174 
175     /**
176      * Okay, we changed the process flow a bit where the actual FRD to ETH
177      * mapping shall be calculated, and pushed to the contract once the
178      * crowdsale is over.
179      *
180      * Then, the user can pull the tokens to their wallet.
181      *
182      */
183     function processContributions(address _contributor, uint256 _weiAmount) payable {
184         require(validPurchase());
185 
186         uint256 updatedWeiRaised = weiRaised.add(_weiAmount);
187 
188         // update state
189         weiRaised = updatedWeiRaised;
190 
191         // notify event for this contribution
192         contributions[_contributor] = contributions[_contributor].add(_weiAmount);
193         contribCount += 1;
194         Contribution(_contributor, _weiAmount);
195 
196         // forware the funds
197         forwardFunds();
198     }
199 
200     // @return true if the transaction can buy tokens
201     function validPurchase() internal constant returns (bool) {
202         uint256 current = block.number;
203 
204         bool withinPeriod = current >= startBlock && current <= endBlock;
205         bool minPurchase = msg.value >= minContrib;
206 
207         // add total wei raised
208         uint256 totalWeiRaised = weiRaised.add(msg.value);
209         bool withinCap = totalWeiRaised <= totalEtherCap;
210 
211         // check all 3 conditions met
212         return withinPeriod && minPurchase && withinCap;
213     }
214 
215     // send ether to the fund collection wallet
216     // override to create custom fund forwarding mechanisms
217     function forwardFunds() internal {
218         wallet.transfer(msg.value);
219     }
220 
221 }