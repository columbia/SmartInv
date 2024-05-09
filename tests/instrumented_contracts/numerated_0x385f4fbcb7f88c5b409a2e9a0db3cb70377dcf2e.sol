1 pragma solidity ^0.8.2;
2 
3 // SPDX-License-Identifier: MIT
4 
5 // ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
6 // ▓▓▀ ▀▓▌▐▓▓▓▓▓▀▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
7 // ▓▓▓ ▓▓▌▝▚▞▜▓ ▀▀ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
8 // ▓▓▓▄▀▓▌▐▓▌▐▓▄▀▀▀▓▓▓▓▓▓▓▓▓▓▛▀▀▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
9 // ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
10 // ▓▓▓▓▓▓▓▓▓▓▓▓       ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓       ▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
11 // ▓▓▓▓▓▓▓▓▛▀▀▀▄▄▄▄▄▄▄▛▀▀▀▓▓▓▛▀▀▀▓▓▓▙▄▄▄▛▀▀▀▓▓▓▛▀▀▀▙▄▄▄▓▓▓▛▀▀▀▄▄▄▄▄▄▄▛▀▀▀▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
12 // ▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▌   ▓▓▓▌   ▓▓▓▓▓▓▓▌   ▓▓▓▌   ▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▌   ▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
13 // ▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▌   ▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▀▀▀▜▓▓▓▓▓▓▓▓▓▓▌   ▀▀▀▀▀▀▀▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
14 // ▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▌   ▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓   ▐▓▓▓▓▓▓▓▓▓▓▌          ▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
15 // ▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▌   ▓▓▓▌   ▓▓▓▓▓▓▓▌   ▓▓▓▌   ▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
16 // ▓▓▓▓▓▓▓▓▌   ▀▀▀▀▀▀▀▓▓▓▓▓▓▓▌   ▓▓▓▛▀▀▀▙▄▄▄▓▓▓▙▄▄▄▛▀▀▀▓▓▓▓▓▓▓▀▀▀▀▀▀▀▀▀▀▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
17 // ▓▓▓▓▓▓▓▓▌          ▓▓▓▓▓▓▓▌   ▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓          ▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
18 // ▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
19 // ▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  ▐▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  ▐▓▓▓  ▐▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
20 // ▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓    ▓▓▓▓▓▓    ▐▓▓▓▓▓▌    ▐▓▓▓      ▐▓▓▓▌    ▐▓▓▓▓▓▌    ▓▓▓▓▓▓▓▌       ▓▓▓    ▓▓▓▓▓▓▓
21 // ▓▓▓▓▓▓▓▓▌   ▓▓▓▓▌  ▓▓▓▓  ▐▌  ▓▓▓▓▌  ▓  ▐▓▓▓▓▌  ▓▓▓  ▐▓▓▓  ▐▓▓▓▓▌  ▓▓▓▓▓▓▓▓  ▐▓  ▐▓▓▓  ▐▓▓▓▌  ▓▓▓▓▓▓▓▓▓▓
22 // ▓▓▓▓▓▓▓▓▙▄▄▄▓▓▓▓▌  ▓▓▓▓  ▐▌  ▓▓▓▓▌  ▓  ▐▓▓▓▓▓▓▓▓▓▓  ▐▓▓▓  ▐▓▓▓▓▓▓▓▓▓▓▌      ▐▓  ▐▓▓▓  ▐▓▓▓▓▓▓    ▓▓▓▓▓▓
23 // ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌  ▓▓▓▓  ▐▌  ▓▓▓▓▌  ▓  ▐▓▓▓▓▓▓▓▓▓▓  ▐▓▓▓  ▐▓▓▓▓▓▓▓▓   ▓▓▓▓  ▐▓  ▐▓▓▓  ▐▓▓▓▓▓▓▓▓▓▓  ▐▓▓▓
24 // ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌      ▓▓▓▓▓▓    ▐▓▓▓  ▐▓▓▓▓▓▓▓▓▓▓▓▓▌  ▓  ▐▓▓▓▓▓▓▓▓▓▓▌    ▓▓▓▓  ▐▓▓▓▓▓  ▐▓▓▓    ▓▓▓▓▓▓▓
25 // ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
26 // ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
27 // ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
28 //
29 //
30 //
31 //
32 //
33 //                     oOOOOOOOo °º¤øøøøøø¤º° ooOOOOOOOOOOOOOOoo °º¤øøøøøø¤º° oOOOOOOOo          
34 //                    OOOOOOOOOOOOOooooooooOOOOOOOOOOOOOOOOOOOOOOOOooooooooOOOOOOOOOOOOO         
35 //                    OOOOººººººººººººººººººººººººººººººººººººººººººººººººººººººººººOOOO         
36 //                    oOOO| ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ |OOOo         
37 //                     oOO| ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ |OOo          
38 //                    ¤ oO| ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ |Oo ¤         
39 //                    O¤ O| ░░░░░░░░((((((((((((░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ |O ¤O           
40 //                    O¤ O| ░░░░((((((((((((((((((░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ |O ¤O           
41 //                    O¤ O| ░░((((((((((((((((((((((░░░░░░░░XXXXXXXXXXXXXX░░░░░░░░ |O ¤O           
42 //                    O¤ O| ░░((((((             (((░░░░░░XXXXXXXXXXXXXXXXXX░░░░░░ |O ¤O          
43 //                    ¤ oO| ░░((((                ((░░░░XXXXXXXXXXXXXX  XXXXXX░░░░ |Oo ¤          
44 //                     oOO| ░░((((                ▓▓░░░░XXXXXXXX          XXXXXX░░ |OOo          
45 //                    oOOO| ░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░XXXXXXXX              XXXX░░ |OOOo         
46 //                    OOOO| ░░▓▓▓▓LLWWWW▓▓▓▓LLWWWW▓▓░░XXXX▓▓                ▓▓XX░░ |OOOO         
47 //                    OOOO| ▓▓  ((LL▓▓LL    LL▓▓LL▓▓░░XX▓▓    MMMM      MMMM▓▓XX░░ |OOOO         
48 //                    OOOO| ▓▓  ((LLLLLL    LLLLLL▓▓░░XX▓▓    ▓▓\\      ▓▓\\▓▓XX░░ |OOOO         
49 //                    oOOO| ░░▓▓((                ▓▓░░▓▓  ▓▓                ▓▓XX░░ |OOOo         
50 //                     oOO| ░░▓▓((        ▓▓▓▓    ▓▓░░XX▓▓▓▓                ▓▓OO░░ |OOo          
51 //                    ¤ oO| ░░▓▓((                ▓▓░░XX░░▓▓        ▓▓      ▓▓XX░░ |Oo ¤          
52 //                    O¤ O| ░░▓▓((    ▓▓((((((((  ▓▓░░XX░░▓▓   BB           ▓▓XX░░ |O ¤O           
53 //                    O¤ O| ░░▓▓((((  ((▓▓▓▓▓▓((  ▓▓░░XX░░▓▓     BBBBBB     ▓▓XX░░ |O ¤O           
54 //                    O¤ O| ░░▓▓((((((((  ((  ((((▓▓XXXX░░░░▓▓            ▓▓░░XXXX |O ¤O           
55 //                    O¤ O| ░░▓▓((((((((((((((((((░░XXXXXX░░▓▓  ▓▓      ▓▓░░XXXXXX |O ¤O           
56 //                    ¤ oO| ░░▓▓░░  ▓▓((((((((((░░░░XXXXXX░░▓▓    ▓▓▓▓▓▓░░░░XXXXXX |Oo ¤          
57 //                     oOO| ░░▓▓  ░░  ▓▓░░░░░░░░░░░░XXXXXX░░▓▓      ▓▓░░░░░░XXXXXX |OOo          
58 //                    oOOO| ░░▓▓    ░░▓▓░░░░░░░░░░░░XXXXXXHHHHHH    ▓▓HH░░░░XXXXXX |OOOo         
59 //                    OOOOøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøøOOOO   
60 //                    OOOOOOOOOOOOOººººººººOOOOOOOOOOOOOOOOOOOOOOOOººººººººOOOOOOOOOOOOO         
61 //                     ºOOOOOOOº ¸,øøøøøøøøø,¸ ººOOOOOOOOOOOOOOºº ¸,øøøøøøø,¸ ºOOOOOOOOº         
62 //                                         ___________________________                                     
63 //                                        |    Cloudedlogic & Lara    |                                    
64 //                                         ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
65 
66 
67 
68 library SafeMath {
69 
70   /**
71   * @dev Multiplies two numbers, throws on overflow.
72   */
73   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
74     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
75     // benefit is lost if 'b' is also tested.
76     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
77     if (a == 0) {
78       return 0;
79     }
80 
81     c = a * b;
82     assert(c / a == b);
83     return c;
84   }
85 
86   /**
87   * @dev Integer division of two numbers, truncating the quotient.
88   */
89   function div(uint256 a, uint256 b) internal pure returns (uint256) {
90     // assert(b > 0); // Solidity automatically throws when dividing by 0
91     // uint256 c = a / b;
92     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
93     return a / b;
94   }
95 
96   /**
97   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
98   */
99   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
100     assert(b <= a);
101     return a - b;
102   }
103 
104   /**
105   * @dev Adds two numbers, throws on overflow.
106   */
107   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
108     c = a + b;
109     assert(c >= a);
110     return c;
111   }
112 }
113 
114 contract ThePixelStudio {
115     
116     using SafeMath for uint256;
117     
118     enum CommissionStatus { queued, accepted, removed  }
119     
120     struct Commission {
121         address payable recipient;
122         uint bid;
123         CommissionStatus status;
124     }
125 
126 
127     uint MAX_INT = uint256(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
128 
129 
130     address payable public admin;
131     
132     mapping (uint => Commission) public commissions;
133     
134     uint public minBid; // the number of wei required to create a commission
135     uint public newCommissionIndex; // the index of the next commission which should be created in the mapping
136     bool public callStarted; // ensures no re-entrancy can occur
137 
138     modifier callNotStarted () {
139       require(!callStarted);
140       callStarted = true;
141       _;
142       callStarted = false;
143     }
144     
145     modifier onlyAdmin {
146         require(msg.sender == admin, "not an admin");
147         _;
148     }
149     
150     constructor(address payable _admin, uint _minBid) {
151         admin = _admin;
152         minBid = _minBid;
153         newCommissionIndex = 1;
154     }
155     
156      
157     function updateAdmin (address payable _newAdmin)
158     public
159     callNotStarted
160     onlyAdmin
161     {
162         admin = _newAdmin;
163         emit AdminUpdated(_newAdmin);
164     }
165     
166     function updateMinBid (uint _newMinBid)
167     public
168     callNotStarted
169     onlyAdmin
170     {
171         minBid = _newMinBid;
172         emit MinBidUpdated(_newMinBid);
173     }
174    
175     function commission (string memory _id) 
176     public
177     callNotStarted
178     payable
179     {
180         require(msg.value >= minBid, "bid below minimum"); // must send the proper amount of into the bid
181         
182         // Next, initialize the new commission
183         Commission storage newCommission = commissions[newCommissionIndex];
184         newCommission.recipient = payable(msg.sender);
185         newCommission.bid = msg.value;
186         newCommission.status = CommissionStatus.queued;
187               
188         emit NewCommission(newCommissionIndex, _id, msg.value, msg.sender);
189         
190         newCommissionIndex++; // for the subsequent commission to be added into the next slot 
191     }
192     
193     function batchCommission (string[] memory _ids, uint[] memory _bids ) 
194     public
195     callNotStarted
196     payable
197     {
198         require(_ids.length == _bids.length, "arrays unequal length");
199         uint sum = 0;
200         
201         for (uint i = 0; i < _ids.length; i++){
202           require(_bids[i] >= minBid, "bid below minimum"); // must send the proper amount of into the bid
203           // Next, initialize the new commission
204           Commission storage newCommission = commissions[newCommissionIndex];
205           newCommission.recipient = payable(msg.sender);
206           newCommission.bid = _bids[i];
207           newCommission.status = CommissionStatus.queued;
208                 
209           emit NewCommission(newCommissionIndex, _ids[i], _bids[i], msg.sender);
210           
211           newCommissionIndex++; // for the subsequent commission to be added into the next slot 
212           sum += _bids[i];
213         }
214         
215         require(msg.value == sum, "insufficient funds"); // must send the proper amount of into the bid
216     }
217     
218     function rescindCommission (uint _commissionIndex) 
219     public
220     callNotStarted
221     {
222         require(_commissionIndex < newCommissionIndex, "commission not valid"); // must be a valid previously instantiated commission
223         Commission storage selectedCommission = commissions[_commissionIndex];
224         require(msg.sender == selectedCommission.recipient, "commission not yours"); // may only be performed by the person who commissioned it
225         require(selectedCommission.status == CommissionStatus.queued, "commission not in queue"); // the commission must still be queued
226       
227         // we mark it as removed and return the individual their bid
228         selectedCommission.status = CommissionStatus.removed;
229         selectedCommission.recipient.transfer(selectedCommission.bid);
230         
231         emit CommissionRescinded(_commissionIndex);
232     }
233     
234     function increaseCommissionBid (uint _commissionIndex)
235     public
236     payable
237     callNotStarted
238     {
239         require(_commissionIndex < newCommissionIndex, "commission not valid"); // must be a valid previously instantiated commission
240         Commission storage selectedCommission = commissions[_commissionIndex];
241         require(msg.sender == selectedCommission.recipient, "commission not yours"); // may only be performed by the person who commissioned it
242         require(selectedCommission.status == CommissionStatus.queued, "commission not in queue"); // the commission must still be queued
243 
244         // then we update the commission's bid
245         selectedCommission.bid = msg.value + selectedCommission.bid;
246         
247         emit CommissionBidUpdated(_commissionIndex, selectedCommission.bid);
248     }
249     
250     function processCommissions(uint[] memory _commissionIndexes)
251     public
252     onlyAdmin
253     callNotStarted
254     {
255         for (uint i = 0; i < _commissionIndexes.length; i++){
256             Commission storage selectedCommission = commissions[_commissionIndexes[i]];
257             
258             require(selectedCommission.status == CommissionStatus.queued, "commission not in the queue"); // the queue my not be empty when processing more commissions 
259             
260             selectedCommission.status = CommissionStatus.accepted; // first, we change the status of the commission to accepted
261             admin.transfer(selectedCommission.bid); // next we accept the payment for the commission
262             
263             emit CommissionProcessed(_commissionIndexes[i], selectedCommission.status);
264         }
265     }
266     
267     event AdminUpdated(address _newAdmin);
268     event MinBidUpdated(uint _newMinBid);
269     event NewCommission(uint _commissionIndex, string _id, uint _bid, address _recipient);
270     event CommissionBidUpdated(uint _commissionIndex, uint _newBid);
271     event CommissionRescinded(uint _commissionIndex);
272     event CommissionProcessed(uint _commissionIndex, CommissionStatus _status);
273 }