1 pragma solidity ^0.4.6;
2 /*
3     Copyright 2017, Vojtech Simetka
4 
5     This program is free software: you can redistribute it and/or modify
6     it under the terms of the GNU General Public License as published by
7     the Free Software Foundation, either version 3 of the License, or
8     (at your option) any later version.
9 
10     This program is distributed in the hope that it will be useful,
11     but WITHOUT ANY WARRANTY; without even the implied warranty of
12     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13     GNU General Public License for more details.
14 
15     You should have received a copy of the GNU General Public License
16     along with this program.  If not, see <http://www.gnu.org/licenses/>.
17  */
18 
19 /// @title Donation Doubler
20 /// @authors Vojtech Simetka, Jordi Baylina, Dani Philia
21 /// @notice This contract is used to double a donation to a Giveth Campaign as
22 ///  long as there is enough ether in this contract to do it. If not, the
23 ///  donated value is just sent directly to designated Campaign with any ether
24 ///  that may still be in this contract. The `msg.sender` doubling their
25 ///  donation will receive twice the expected Campaign tokens and the Donor that
26 ///  deposited the inital funds will not receive any donation tokens. 
27 ///  WARNING: This contract only works for ether. A token based contract will be
28 ///  developed in the future. Any tokens sent to this contract will be lost.
29 ///  Next Version: Upgrade the EscapeHatch to be able to remove tokens.
30 
31 
32 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
33 ///  later changed
34 
35 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
36 
37 // Licensed under the Apache License, Version 2.0 (the "License").
38 // You may not use this file except in compliance with the License.
39 
40 // Unless required by applicable law or agreed to in writing, software
41 // distributed under the License is distributed on an "AS IS" BASIS,
42 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
43 // 
44 // Thank you to @zandy and the Dappsys team for writing this beautiful library
45 // Their math.sol was modified to remove and rename functions and add many
46 // comments for clarification.
47 // See their original library here: https://github.com/dapphub/ds-math
48 //
49 // Also the OpenZepplin team deserves gratitude and recognition for making
50 // their own beautiful library which has been very well utilized in solidity
51 // contracts across the Ethereum ecosystem and we used their max64(), min64(),
52 // multiply(), and divide() functions. See their library here:
53 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/SafeMath.sol
54 
55 pragma solidity ^0.4.6;
56 
57 contract SafeMath {
58 
59     // ensure that the result of adding x and y is accurate 
60     function add(uint x, uint y) internal constant returns (uint z) {
61         assert( (z = x + y) >= x);
62     }
63  
64     // ensure that the result of subtracting y from x is accurate 
65     function subtract(uint x, uint y) internal constant returns (uint z) {
66         assert( (z = x - y) <= x);
67     }
68 
69     // ensure that the result of multiplying x and y is accurate 
70     function multiply(uint x, uint y) internal constant returns (uint z) {
71         z = x * y;
72         assert(x == 0 || z / x == y);
73         return z;
74     }
75 
76     // ensure that the result of dividing x and y is accurate
77     // note: Solidity now throws on division by zero, so a check is not needed
78     function divide(uint x, uint y) internal constant returns (uint z) {
79         z = x / y;
80         assert(x == ( (y * z) + (x % y) ));
81         return z;
82     }
83     
84     // return the lowest of two 64 bit integers
85     function min64(uint64 x, uint64 y) internal constant returns (uint64) {
86       return x < y ? x: y;
87     }
88     
89     // return the largest of two 64 bit integers
90     function max64(uint64 x, uint64 y) internal constant returns (uint64) {
91       return x >= y ? x : y;
92     }
93 
94     // return the lowest of two values
95     function min(uint x, uint y) internal constant returns (uint) {
96         return (x <= y) ? x : y;
97     }
98 
99     // return the largest of two values
100     function max(uint x, uint y) internal constant returns (uint) {
101         return (x >= y) ? x : y;
102     }
103 
104     function assert(bool assertion) internal {
105         if (!assertion) {
106             throw;
107         }
108     }
109 
110 }
111 
112 contract Owned {
113     /// @dev `owner` is the only address that can call a function with this
114     /// modifier; the function body is inserted where the special symbol
115     /// "_;" in the definition of a modifier appears.
116     modifier onlyOwner { if (msg.sender != owner) throw; _; }
117 
118     address public owner;
119 
120     /// @notice The Constructor assigns the message sender to be `owner`
121     function Owned() { owner = msg.sender;}
122 
123     /// @notice `owner` can step down and assign some other address to this role
124     /// @param _newOwner The address of the new owner. 0x0 can be used to create
125     ///  an unowned neutral vault, however that cannot be undone
126     function changeOwner(address _newOwner) onlyOwner {
127         owner = _newOwner;
128         NewOwner(msg.sender, _newOwner);
129     }
130     
131     /// @dev Events make it easier to see that something has happend on the
132     ///   blockchain
133     event NewOwner(address indexed oldOwner, address indexed newOwner);
134 }
135 /// @dev `Escapable` is a base level contract built off of the `Owned`
136 ///  contract that creates an escape hatch function to send its ether to
137 ///  `escapeHatchDestination` when called by the `escapeHatchCaller` in the case
138 ///  that something unexpected happens
139 contract Escapable is Owned {
140     address public escapeHatchCaller;
141     address public escapeHatchDestination;
142 
143     /// @notice The Constructor assigns the `escapeHatchDestination` and the
144     ///  `escapeHatchCaller`
145     /// @param _escapeHatchDestination The address of a safe location (usu a
146     ///  Multisig) to send the ether held in this contract
147     /// @param _escapeHatchCaller The address of a trusted account or contract to
148     ///  call `escapeHatch()` to send the ether in this contract to the
149     ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller` cannot
150     ///  move funds out of `escapeHatchDestination`
151     function Escapable(address _escapeHatchCaller, address _escapeHatchDestination) {
152         escapeHatchCaller = _escapeHatchCaller;
153         escapeHatchDestination = _escapeHatchDestination;
154     }
155 
156     /// @dev The addresses preassigned the `escapeHatchCaller` role
157     ///  is the only addresses that can call a function with this modifier
158     modifier onlyEscapeHatchCallerOrOwner {
159         if ((msg.sender != escapeHatchCaller)&&(msg.sender != owner))
160             throw;
161         _;
162     }
163 
164     /// @notice The `escapeHatch()` should only be called as a last resort if a
165     /// security issue is uncovered or something unexpected happened
166     function escapeHatch() onlyEscapeHatchCallerOrOwner {
167         uint total = this.balance;
168         // Send the total balance of this contract to the `escapeHatchDestination`
169         if (!escapeHatchDestination.send(total)) {
170             throw;
171         }
172         EscapeHatchCalled(total);
173     }
174     /// @notice Changes the address assigned to call `escapeHatch()`
175     /// @param _newEscapeHatchCaller The address of a trusted account or contract to
176     ///  call `escapeHatch()` to send the ether in this contract to the
177     ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller` cannot
178     ///  move funds out of `escapeHatchDestination`
179     function changeEscapeCaller(address _newEscapeHatchCaller) onlyEscapeHatchCallerOrOwner {
180         escapeHatchCaller = _newEscapeHatchCaller;
181     }
182 
183     event EscapeHatchCalled(uint amount);
184 }
185 
186 /// @dev This is an empty contract to declare `proxyPayment()` to comply with
187 ///  Giveth Campaigns so that tokens will be generated when donations are sent
188 contract Campaign {
189 
190     /// @notice `proxyPayment()` allows the caller to send ether to the Campaign and
191     /// have the tokens created in an address of their choosing
192     /// @param _owner The address that will hold the newly created tokens
193     function proxyPayment(address _owner) payable returns(bool);
194 }
195 
196 /// @dev Finally! The main contract which doubles the amount donated.
197 contract DonationDoubler is Escapable, SafeMath {
198     Campaign public beneficiary; // expected to be a Giveth campaign
199 
200     /// @notice The Constructor assigns the `beneficiary`, the
201     ///  `escapeHatchDestination` and the `escapeHatchCaller` as well as deploys
202     ///  the contract to the blockchain (obviously)
203     /// @param _beneficiary The address of the CAMPAIGN CONTROLLER for the Campaign
204     ///  that is to receive donations
205     /// @param _escapeHatchDestination The address of a safe location (usually a
206     ///  Multisig) to send the ether held in this contract
207     /// @param _escapeHatchCaller The address of a trusted account or contract
208     ///  to call `escapeHatch()` to send the ether in this contract to the 
209     ///  `escapeHatchDestination` it would be ideal that `escapeHatchCaller`
210     ///  cannot move funds out of `escapeHatchDestination`
211     function DonationDoubler(
212             Campaign _beneficiary,
213             // person or legal entity that receives money or other benefits from a benefactor
214             address _escapeHatchCaller,
215             address _escapeHatchDestination
216         )
217         Escapable(_escapeHatchCaller, _escapeHatchDestination)
218     {
219         beneficiary = _beneficiary;
220     }
221 
222     /// @notice Simple function to deposit more ETH to Double Donations
223     function depositETH() payable {
224         DonationDeposited4Doubling(msg.sender, msg.value);
225     }
226 
227     /// @notice Donate ETH to the `beneficiary`, and if there is enough in the 
228     ///  contract double it. The `msg.sender` is rewarded with Campaign tokens
229     // depending on how one calls into this fallback function, i.e. with .send ( hard limit of 2300 gas ) vs .value (provides fallback with all the available gas of the caller), it may throw
230     function () payable {
231         uint amount;
232 
233         // When there is enough ETH in the contract to double the ETH sent
234         if (this.balance >= multiply(msg.value, 2)){
235             amount = multiply(msg.value, 2); // do it two it!
236             // Send the ETH to the beneficiary so that they receive Campaign tokens
237             if (!beneficiary.proxyPayment.value(amount)(msg.sender))
238                 throw;
239             DonationDoubled(msg.sender, amount);
240         } else {
241             amount = this.balance;
242             // Send the ETH to the beneficiary so that they receive Campaign tokens
243             if (!beneficiary.proxyPayment.value(amount)(msg.sender))
244                 throw;
245             DonationSentButNotDoubled(msg.sender, amount);
246         }
247     }
248 
249     event DonationDeposited4Doubling(address indexed sender, uint amount);
250     event DonationDoubled(address indexed sender, uint amount);
251     event DonationSentButNotDoubled(address indexed sender, uint amount);
252 }