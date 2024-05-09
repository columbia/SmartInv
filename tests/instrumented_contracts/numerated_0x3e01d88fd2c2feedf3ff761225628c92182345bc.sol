1 pragma solidity ^0.4.20;
2 
3 ///ETHERICH Contract
4 
5 /*
6 Copyright 2018 etherich.co
7 
8 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
9 
10 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
11 
12 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
13 */
14 
15 contract Etherich {
16     address public owner;
17     
18     uint constant public PARTICIPATION_FEE = 0.1 ether;
19     uint[] public REFERRAL_RATE = [40, 25, 15, 10, 5];
20 
21     mapping (address => address) members;
22     mapping (string => address) referralCodes;
23     uint public memberCount;
24 
25     event HasNewMember(uint memberCount);
26     
27     function Etherich() public {
28         owner = msg.sender;
29         members[owner] = 1;
30 
31         string memory alphabetHash = hash(owner);
32         referralCodes[alphabetHash] = owner;
33 
34         memberCount = 1;
35     }
36     
37     function participate(string referral) public payable {
38         require(referralCodes[referral] != 0);
39         require(members[msg.sender] == 0);
40         require(msg.value == PARTICIPATION_FEE);
41         
42         address referrer = referralCodes[referral];
43         members[msg.sender] = referrer;
44         string memory alphabetHash = hash(msg.sender);
45         referralCodes[alphabetHash] = msg.sender;
46         
47         for (uint16 i = 0; i<5; i++) {
48             if (referrer == 1) {
49                 break;
50             }
51             
52             uint256 amount = SafeMath.div(SafeMath.mul(msg.value, REFERRAL_RATE[i]), 100);
53             referrer.transfer(amount);
54             referrer = members[referrer];
55         }
56 
57         memberCount++;
58         HasNewMember(memberCount);
59     }
60     
61     function isMember(address a) public view returns(bool) {
62         return !(members[a] == 0);
63     }
64     
65     function doesReferralCodeValid(string code) public view returns(bool) {
66         return !(referralCodes[code] == 0);
67     }
68     
69     function referralCodeFromAddress(address a) public view returns (string) {
70         if (this.isMember(a)) {
71             return hash(a);
72         } else {
73             return "";
74         }
75     }
76 
77     function getReferralRates() public view returns (uint[]) {
78         return REFERRAL_RATE;
79     }
80     
81     function payout(address receiver, uint amount) public restricted {
82         if (amount > this.balance) {
83             receiver.transfer(this.balance);
84         } else {
85             receiver.transfer(amount);
86         }
87     }
88 
89     function changeOwner(address newOwner) public restricted {
90         owner = newOwner;
91     }
92     
93     function hash(address a) private pure returns (string) {
94         bytes32 sha3Hash = keccak256(bytes20(a));
95         return bytes32ToAlphabetString(sha3Hash);
96     }
97     
98     function bytes32ToAlphabetString(bytes32 x) private pure returns (string) {
99         bytes memory bytesString = new bytes(32);
100         uint8 charCount = 0;
101 
102         for (uint j = 0; j < 32; j++) {
103             uint8 value = uint8(x[j]) % 24;
104             byte char = byte(65 + value);
105             bytesString[charCount] = char;
106             charCount++;
107         }
108 
109         return string(bytesString);
110     } 
111     
112     modifier restricted() {
113         require(msg.sender == owner);
114         _;
115     }
116 }
117 
118 library SafeMath {
119   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
120     if (a == 0) {
121       return 0;
122     }
123     uint256 c = a * b;
124     assert(c / a == b);
125     return c;
126   }
127   function div(uint256 a, uint256 b) internal pure returns (uint256) {
128     uint256 c = a / b;
129     return c;
130   }
131   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
132     assert(b <= a);
133     return a - b;
134   }
135   function add(uint256 a, uint256 b) internal pure returns (uint256) {
136     uint256 c = a + b;
137     assert(c >= a);
138     return c;
139   }
140 }