1 pragma solidity ^0.4.23;
2 
3 contract ArtStamp { 
4     
5     /************************** */
6     /*        STORAGE           */
7     /************************** */
8     struct Piece {
9         string metadata;
10         string title;
11         bytes32 proof;
12         address owner;
13         //this currently does nothing, but i believe it will make it much easier if/when we make a future 
14         //version of this app in which buying and selling pieces with ethereum is allowed
15         bool forSale; 
16         //witnesses have to sign off on any transfer or sale, but have no rights to initiate them
17         //typically the witness will be the artist or anyone with rights to the pieces
18         //as of right now witnesses can only be added when a piece is created and cannot be altered
19         address witness;
20     }
21 
22     //structure to keep track of a party to a contract and whether they have signed or not,
23     //  and how much ether they have contributed
24     struct Signature {
25         address signee;
26         bool hasSigned;
27     }
28 
29     //structure to represent escrow situation and keep track of all parties to contract
30     struct Escrow {
31         Signature sender;
32         Signature recipient;
33         Signature witness;
34         //block number when escrow is initiated, recorded so that escrow can timeout
35         uint blockNum;
36     }
37     
38     //contains all pieces on the market
39     mapping (uint => Piece) pieces;
40 
41     //number of pieces
42     uint piecesLength;
43 
44     //list of all escrow situations currently in progress
45     mapping (uint => Escrow) escrowLedger;
46 
47     //this is used to ensure that no piece can be uploaded twice. 
48     //dataRecord[(hash of a piece goes here)] will be true if that piece has already been uploaded
49     mapping (bytes32 => bool) dataRecord;
50 
51     /************************** */
52     /*         LOGIC            */
53     /************************** */
54 
55 
56     //
57 
58 
59 
60     /****** PUBLIC READ */
61 
62     //get data relating to escrow
63     function getEscrowData(uint i) view public returns (address, bool, address, bool, address, bool, uint){
64         return (escrowLedger[i].sender.signee, escrowLedger[i].sender.hasSigned, 
65         escrowLedger[i].recipient.signee, escrowLedger[i].recipient.hasSigned, 
66         escrowLedger[i].witness.signee, escrowLedger[i].witness.hasSigned, 
67         escrowLedger[i].blockNum);
68     }
69 
70     //returns total number of pieces
71     function getNumPieces() view public returns (uint) {
72         return piecesLength;
73     }
74 
75     function getOwner(uint id) view public returns (address) {
76         return pieces[id].owner;
77     }
78 
79     function getPiece(uint id) view public returns (string, string, bytes32, bool, address, address) {
80         Piece memory piece = pieces[id];
81         return (piece.metadata, piece.title, piece.proof, piece.forSale, piece.owner, piece.witness);
82     }
83     
84     function hashExists(bytes32 proof) view public returns (bool) {
85         return dataRecord[proof];
86     }
87 
88     function hasOwnership(uint id) view public returns (bool)
89     {
90         return pieces[id].owner == msg.sender;
91     }
92 
93 
94     //
95 
96 
97 
98 
99     /****** PUBLIC WRITE */
100 
101     function addPieceAndHash(string _metadata, string _title, string data, address witness) public {
102         bytes32 _proof = keccak256(abi.encodePacked(data));
103         //check for hash collisions to see if the piece has already been uploaded
104         addPiece(_metadata,_title,_proof,witness);
105     }
106     
107     function addPiece(string _metadata, string _title, bytes32 _proof, address witness) public {
108         bool exists = hashExists(_proof);
109         require(!exists, "This piece has already been uploaded");
110         dataRecord[_proof] = true;
111         pieces[piecesLength] = Piece(_metadata,  _title, _proof, msg.sender, false, witness);
112         piecesLength++;
113     }
114 
115     //edit both title and metadata with one transaction, will make things easier on the front end
116     function editPieceData(uint id, string newTitle, string newMetadata) public {
117         bool ownership = hasOwnership(id);
118         require(ownership, "You don't own this piece");
119         pieces[id].metadata = newMetadata;
120         pieces[id].title = newTitle;
121     }
122 
123     function editMetadata(uint id, string newMetadata) public {
124         bool ownership = hasOwnership(id);
125         require(ownership, "You don't own this piece");
126         pieces[id].metadata = newMetadata;
127     }
128 
129     function editTitle(uint id, string newTitle) public {
130         bool ownership = hasOwnership(id);
131         require(ownership, "You don't own this piece");
132         pieces[id].title = newTitle;
133     }
134 
135     function escrowTransfer(uint id, address recipient) public {
136         bool ownership = hasOwnership(id);
137         require(ownership, "You don't own this piece");
138 
139         //set owner of piece to artstamp smart contract
140         pieces[id].owner = address(this);
141 
142         //upadte escrow ledger
143         escrowLedger[id] = Escrow({
144             sender: Signature(msg.sender,false),
145             recipient: Signature(recipient,false),
146             witness: Signature(pieces[id].witness,false),
147             blockNum: block.number});
148     }
149     
150 
151     //100000 blocks should be about 20 days which seems reasonable
152     //TODO: should make it so contracts owner can change this
153     uint timeout = 100000; 
154 
155     //timeout where piece will be returned to original owner if people dont sign
156     function retrievePieceFromEscrow(uint id) public {
157         //reject transaction if piece is not in escrow 
158         require(pieces[id].owner == address(this));
159 
160         require(block.number > escrowLedger[id].blockNum + timeout);
161 
162         address sender = escrowLedger[id].sender.signee;
163 
164         delete escrowLedger[id];
165 
166         pieces[id].owner = sender;
167 
168     } 
169 
170     function signEscrow(uint id) public {
171         //reject transaction if piece is not in escrow 
172         require(pieces[id].owner == address(this));
173 
174         //reject transaction if signee isnt any of the parties involved
175         require(msg.sender == escrowLedger[id].sender.signee ||
176             msg.sender == escrowLedger[id].recipient.signee || 
177             msg.sender == escrowLedger[id].witness.signee, 
178             "You don't own this piece");
179 
180         bool allHaveSigned = true;
181 
182         if(msg.sender == escrowLedger[id].sender.signee){
183             escrowLedger[id].sender.hasSigned = true;
184         }  
185         allHaveSigned = allHaveSigned && escrowLedger[id].sender.hasSigned;
186         
187         if(msg.sender == escrowLedger[id].recipient.signee){
188             escrowLedger[id].recipient.hasSigned = true;
189         }
190         allHaveSigned = allHaveSigned && escrowLedger[id].recipient.hasSigned;
191         
192 
193         if(msg.sender == escrowLedger[id].witness.signee){
194             escrowLedger[id].witness.hasSigned = true;
195         }        
196         
197         allHaveSigned = allHaveSigned && 
198             (escrowLedger[id].witness.hasSigned || 
199             escrowLedger[id].witness.signee == 0x0000000000000000000000000000000000000000);
200 
201         //transfer the pieces
202         if(allHaveSigned)
203         {
204             address recipient = escrowLedger[id].recipient.signee;
205             delete escrowLedger[id];
206             pieces[id].owner = recipient;
207         }
208     }
209 
210 
211 
212     function transferPiece(uint id, address _to) public
213     {
214         bool ownership = hasOwnership(id);
215         require(ownership, "You don't own this piece");
216 
217         //check if there is a witness, if so initiate escrow
218         if(pieces[id].witness != 0x0000000000000000000000000000000000000000){
219             escrowTransfer(id, _to);
220             return;
221         }
222 
223         pieces[id].owner = _to;
224     }
225 
226 
227 
228 }