1 pragma solidity ^0.8.2;
2 // SPDX-License-Identifier: MIT
3 // ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
4 // ▓▓▀ ▀▓▌▐▓▓▓▓▓▀▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
5 // ▓▓▓ ▓▓▌▝▚▞▜▓ ▀▀ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
6 // ▓▓▓▄▀▓▌▐▓▌▐▓▄▀▀▀▓▓▓▓▓▓▓▓▓▓▛▀▀▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
7 // ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
8 // ▓▓▓▓▓▓▓▓▓▓▓▓       ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓       ▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
9 // ▓▓▓▓▓▓▓▓▛▀▀▀▄▄▄▄▄▄▄▛▀▀▀▓▓▓▛▀▀▀▓▓▓▙▄▄▄▛▀▀▀▓▓▓▛▀▀▀▙▄▄▄▓▓▓▛▀▀▀▄▄▄▄▄▄▄▛▀▀▀▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
10 // ▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▌   ▓▓▓▌   ▓▓▓▓▓▓▓▌   ▓▓▓▌   ▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▌   ▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
11 // ▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▌   ▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▀▀▀▜▓▓▓▓▓▓▓▓▓▓▌   ▀▀▀▀▀▀▀▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
12 // ▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▌   ▓▓▓▌   ▓▓▓▓▓▓▓▓███   ▐███▓▓▓▓▓▓▓▌          ▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
13 // ▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▌   ▓▓▓▌   ▓▓▓▓▓▓▓▌   ▓▓▓▌   ▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
14 // ▓▓▓▓▓▓▓▓▌   ▀▀▀▀▀▀▀▓▓▓▓▓▓▓▌   ▓▓▓▛▀▀▀▙▄▄▄▓▓▓▙▄▄▄▛▀▀▀▓▓▓▓▓▓▓▀▀▀▀▀▀▀▀▀▀▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
15 // ▓▓▓▓▓▓▓▓▌          ▓▓▓▓▓▓▓▌   ▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓          ▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
16 // ▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
17 // ▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  ▐▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  ▐▓▓▓  ▐▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
18 // ▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▓▓    ▓▓▓▓▓▓    ▐▓▓▓▓▓▌    ▐▓▓▓      ▐▓▓▓▌    ▐▓▓▓▓▓▌    ▓▓▓▓▓▓▓▌       ▓▓▓    ▓▓▓▓▓▓▓
19 // ▓▓▓▓▓▓▓▓▌   ▓▓▓▓▌  ▓▓▓▓  ▐▌  ▓▓▓▓▌  ▓  ▐▓▓▓▓▌  ▓▓▓  ▐▓▓▓  ▐▓▓▓▓▌  ▓▓▓▓▓▓▓▓  ▐▓  ▐▓▓▓  ▐▓▓▓▌  ▓▓▓▓▓▓▓▓▓▓
20 // ▓▓▓▓▓▓▓▓▙▄▄▄▓▓▓▓▌  ▓▓▓▓  ▐▌  ▓▓▓▓▌  ▓  ▐▓▓▓▓▓▓▓▓▓▓  ▐▓▓▓  ▐▓▓▓▓▓▓▓▓▓▓▌      ▐▓  ▐▓▓▓  ▐▓▓▓▓▓▓    ▓▓▓▓▓▓
21 // ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌  ▓▓▓▓  ▐▌  ▓▓▓▓▌  ▓  ▐▓▓▓▓▓▓▓▓▓▓  ▐▓▓▓  ▐▓▓▓▓▓▓▓▓   ▓▓▓▓  ▐▓  ▐▓▓▓  ▐▓▓▓▓▓▓▓▓▓▓  ▐▓▓▓
22 // ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌      ▓▓▓▓▓▓    ▐▓▓▓  ▐▓▓▓▓▓▓▓▓▓▓▓▓▌  ▓  ▐▓▓▓▓▓▓▓▓▓▓▌    ▓▓▓▓  ▐▓▓▓▓▓  ▐▓▓▓    ▓▓▓▓▓▓▓
23 // ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
24 // ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
25 // ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
26 
27 library SafeMath {
28 
29   /**
30   * @dev Multiplies two numbers, throws on overflow.
31   */
32   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
33     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
34     // benefit is lost if 'b' is also tested.
35     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36     if (a == 0) {
37       return 0;
38     }
39 
40     c = a * b;
41     assert(c / a == b);
42     return c;
43   }
44 
45   /**
46   * @dev Integer division of two numbers, truncating the quotient.
47   */
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     // uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return a / b;
53   }
54 
55   /**
56   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57   */
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   /**
64   * @dev Adds two numbers, throws on overflow.
65   */
66   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
67     c = a + b;
68     assert(c >= a);
69     return c;
70   }
71 }
72 
73 contract ThePixelPortraits {
74     
75     using SafeMath for uint256;
76     
77     enum CommissionStatus { queued, accepted, removed  }
78     
79     struct Commission {
80         string name;
81         address payable recipient;
82         uint bid;
83         CommissionStatus status;
84     }
85 
86     uint MAX_INT = uint256(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
87 
88     address payable public admin;
89     
90     mapping (string => uint) public names;
91     mapping (uint => Commission) public commissions;
92     
93     uint public minBid; // the number of wei required to create a commission
94     uint public newCommissionIndex; // the index of the next commission which should be created in the mapping
95     bool public callStarted; // ensures no re-entrancy can occur
96 
97     modifier callNotStarted () {
98       require(!callStarted);
99       callStarted = true;
100       _;
101       callStarted = false;
102     }
103     
104     modifier onlyAdmin {
105         require(msg.sender == admin, "not an admin");
106         _;
107     }
108     
109     constructor(address payable _admin, uint _minBid) {
110         admin = _admin;
111         minBid = _minBid;
112         newCommissionIndex = 1;
113     }
114      
115     function updateAdmin (address payable _newAdmin)
116     public
117     callNotStarted
118     onlyAdmin
119     {
120         admin = _newAdmin;
121         emit AdminUpdated(_newAdmin);
122     }
123     
124     function updateMinBid (uint _newMinBid)
125     public
126     callNotStarted
127     onlyAdmin
128     {
129         minBid = _newMinBid;
130         emit MinBidUpdated(_newMinBid);
131     }
132 
133     function registerNames (string[] memory _names)
134     public
135     callNotStarted
136     onlyAdmin
137     {
138         for (uint i = 0; i < _names.length; i++){
139             require(names[toLower(_names[i])] == 0, "name not available"); // ensures the name is not taken
140             names[toLower(_names[i])] = MAX_INT;
141         }
142         emit NamesRegistered(_names);
143     }
144    
145     function commission (string memory _name) 
146     public
147     callNotStarted
148     payable
149     {
150         require(validateName(_name), "name not valid"); // ensures the name is valid
151         require(names[toLower(_name)] == 0, "name not available"); // the name cannot be taken when you create your commission
152         require(msg.value >= minBid, "bid below minimum"); // must send the proper amount of into the bid
153         
154         // Next, initialize the new commission
155         Commission storage newCommission = commissions[newCommissionIndex];
156         newCommission.name = _name;
157         newCommission.recipient = payable(msg.sender);
158         newCommission.bid = msg.value;
159         newCommission.status = CommissionStatus.queued;
160               
161         emit NewCommission(newCommissionIndex, _name, msg.value, msg.sender);
162         
163         newCommissionIndex++; // for the subsequent commission to be added into the next slot 
164     }
165     
166     
167     function updateCommissionName (uint _commissionIndex, string memory _newName) 
168     public
169     callNotStarted
170     {
171         require(_commissionIndex < newCommissionIndex, "commission not valid"); // must be a valid previously instantiated commission
172         Commission storage selectedCommission = commissions[_commissionIndex];
173         require(msg.sender == selectedCommission.recipient, "commission not yours"); // may only be performed by the person who commissioned it
174         require(selectedCommission.status == CommissionStatus.queued, "commission not in queue"); // the commission must still be queued
175         require(validateName(_newName), "name not valid"); // ensures the name is valid
176         require(names[toLower(_newName)] == 0, "name not available"); // the name cannot be taken when you create your commission
177 
178         selectedCommission.name = _newName;
179 
180         emit CommissionNameUpdated(_commissionIndex, _newName);
181     }
182     
183     function rescindCommission (uint _commissionIndex) 
184     public
185     callNotStarted
186     {
187         require(_commissionIndex < newCommissionIndex, "commission not valid"); // must be a valid previously instantiated commission
188         Commission storage selectedCommission = commissions[_commissionIndex];
189         require(msg.sender == selectedCommission.recipient, "commission not yours"); // may only be performed by the person who commissioned it
190         require(selectedCommission.status == CommissionStatus.queued, "commission not in queue"); // the commission must still be queued
191       
192         // we mark it as removed and return the individual their bid
193         selectedCommission.status = CommissionStatus.removed;
194         selectedCommission.recipient.transfer(selectedCommission.bid);
195         
196         emit CommissionRescinded(_commissionIndex);
197     }
198     
199     function increaseCommissionBid (uint _commissionIndex)
200     public
201     payable
202     callNotStarted
203     {
204         require(_commissionIndex < newCommissionIndex, "commission not valid"); // must be a valid previously instantiated commission
205         Commission storage selectedCommission = commissions[_commissionIndex];
206         require(msg.sender == selectedCommission.recipient, "commission not yours"); // may only be performed by the person who commissioned it
207         require(selectedCommission.status == CommissionStatus.queued, "commission not in queue"); // the commission must still be queued
208 
209         // then we update the commission's bid
210         selectedCommission.bid = msg.value + selectedCommission.bid;
211         
212         emit CommissionBidUpdated(_commissionIndex, selectedCommission.bid);
213     }
214     
215     function processCommissions(uint[] memory _commissionIndexes)
216     public
217     onlyAdmin
218     callNotStarted
219     {
220         for (uint i = 0; i < _commissionIndexes.length; i++){
221             Commission storage selectedCommission = commissions[_commissionIndexes[i]];
222             
223             require(selectedCommission.status == CommissionStatus.queued, "commission not in the queue"); // the queue my not be empty when processing more commissions 
224             require(names[toLower(selectedCommission.name)] == 0); // admins can't process commissions with names which are taken
225             
226             // the name isn't taken yet and will be accepted
227             selectedCommission.status = CommissionStatus.accepted; // first, we change the status of the commission to accepted
228             names[toLower(selectedCommission.name)] = _commissionIndexes[i]; // finally, we reserve the name for this commission
229             admin.transfer(selectedCommission.bid); // next we accept the payment for the commission
230             
231             emit CommissionProcessed(_commissionIndexes[i], selectedCommission.status);
232         }
233     }
234     
235     // Credit to Hashmasks for the following functions
236     function validateName (string memory str)
237     public 
238     pure 
239     returns (bool)
240     {
241         bytes memory b = bytes(str);
242         if(b.length < 1) return false;
243         if(b.length > 25) return false; // Cannot be longer than 25 characters
244         if(b[0] == 0x20) return false; // Leading space
245         if (b[b.length - 1] == 0x20) return false; // Trailing space
246 
247         bytes1 lastChar = b[0];
248 
249         for(uint i; i<b.length; i++){
250             bytes1 char = b[i];
251 
252             if (char == 0x20 && lastChar == 0x20) return false; // Cannot contain continous spaces
253 
254             if(
255                 !(char >= 0x30 && char <= 0x39) && //9-0
256                 !(char >= 0x41 && char <= 0x5A) && //A-Z
257                 !(char >= 0x61 && char <= 0x7A) && //a-z
258                 !(char == 0x20) //space
259             )
260                 return false;
261 
262             lastChar = char;
263         }
264 
265         return true;
266     }
267     
268     function toLower (string memory str)
269     public 
270     pure 
271     returns (string memory)
272     {
273         bytes memory bStr = bytes(str);
274         bytes memory bLower = new bytes(bStr.length);
275         for (uint i = 0; i < bStr.length; i++) {
276             // Uppercase character
277             if ((uint8(bStr[i]) >= 65) && (uint8(bStr[i]) <= 90)) {
278                 bLower[i] = bytes1(uint8(bStr[i]) + 32);
279             } else {
280                 bLower[i] = bStr[i];
281             }
282         }
283         return string(bLower);
284     }
285     
286     event AdminUpdated(address _newAdmin);
287     event MinBidUpdated(uint _newMinBid);
288     event NamesRegistered(string[] _names);
289     event NewCommission(uint _commissionIndex, string _name, uint _bid, address _recipient);
290     event CommissionNameUpdated(uint _commissionIndex, string _newName);
291     event CommissionBidUpdated(uint _commissionIndex, uint _newBid);
292     event CommissionRescinded(uint _commissionIndex);
293     event CommissionProcessed(uint _commissionIndex, CommissionStatus _status);
294 }