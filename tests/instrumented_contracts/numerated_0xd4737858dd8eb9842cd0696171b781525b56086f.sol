1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title NoteChain
5  * @dev The NoteChain contract provides functions to store notes in blockchain
6  */
7 
8 contract NoteChain {
9 
10         // EVENTS
11         event NoteCreated(uint64 id, bytes2 publicKey);
12         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14         // CONSTANTS
15         uint8 constant Deleted = 1;
16         uint8 constant IsPrivateBitPosition = 1;
17 
18         address public owner;
19         uint public noteChainFee = 0.0002 ether; // fee for using noteChain
20 
21         struct Note {
22                 uint16 metadata;
23                 bytes2 publicKey; 
24                 // publicKey: generated client-side, 
25                 // it will create a code for share URL-> publicKey + hex(_noteId)
26 
27                 bytes12 title;
28                 bytes content;
29         }
30 
31         Note[] private notes;
32 
33         mapping (uint64 => address) private noteToOwner;
34         mapping (address => uint64[]) private ownerNotes;
35 
36         // PURE FUNCTIONS
37         function isPosBitOne(uint data, uint pos) internal pure returns (bool) {
38                 return data % (2**(pos+1)) >= (2**pos);
39         }
40 
41         // MODIFIERS
42         modifier onlyOwner() {
43                 require(msg.sender == owner);
44                 _;
45         }
46 
47         modifier onlyOwnerOf(uint64 _noteId) {
48                 require(msg.sender == noteToOwner[_noteId]);
49                 _;
50         }
51 
52         modifier payFee() {
53                 require(msg.value >= noteChainFee);
54                 _;
55         }
56 
57         modifier notDeleted(uint64 _noteId) {
58                 require(uint8(notes[_noteId].metadata) != Deleted);
59                 _;
60         }
61 
62         modifier notPrivate(uint64 _noteId) {
63                 require(isPosBitOne( uint( notes[_noteId].metadata), uint(IsPrivateBitPosition) ) == false );
64                 _;
65         }
66 
67         // constructor
68         constructor() public {
69                 owner = msg.sender;
70         }
71 
72         function setFee(uint _fee) external onlyOwner {
73                 noteChainFee = _fee;
74         }
75 
76         function withdraw(address _address, uint _amount) external onlyOwner {
77                 require(_amount <= address(this).balance);
78                 address(_address).transfer(_amount);
79         }
80 
81         function getBalance() external constant returns(uint){
82                 return address(this).balance;
83         }
84 
85         function transferOwnership(address newOwner) external onlyOwner {
86                 require(newOwner != address(0));
87                 emit OwnershipTransferred(owner, newOwner);
88                 owner = newOwner;
89         }
90 
91         // NOTES related functions
92         // payable functions
93         function createNote(uint16 _metadata, bytes2 _publicKey, bytes12 _title, bytes _content) external payable payFee {
94                 uint64 id = uint64(notes.push(Note(_metadata, _publicKey, _title, _content))) - 1;
95                 noteToOwner[id] = msg.sender;
96                 ownerNotes[msg.sender].push(id);
97                 emit NoteCreated(id, _publicKey);
98         }
99 
100         function deleteNote(uint64 _noteId) external notDeleted(_noteId) onlyOwnerOf(_noteId) payable payFee {
101                 notes[_noteId].metadata = Deleted;
102         }
103 
104         function updateNote(uint64 _noteId, uint16 _metadata, bytes12 _title, bytes _content) external notDeleted(_noteId) onlyOwnerOf(_noteId) payable payFee {
105                 Note storage myNote = notes[_noteId];
106                 myNote.title = _title;
107                 myNote.metadata = _metadata;
108                 myNote.content = _content;
109         }
110 
111         function updateNoteMetadata(uint64 _noteId, uint16 _metadata) external notDeleted(_noteId) onlyOwnerOf(_noteId) payable payFee {
112                 Note storage myNote = notes[_noteId];
113                 myNote.metadata = _metadata;
114         }
115 
116         function updateNoteContent(uint64 _noteId, bytes _content) external notDeleted(_noteId) onlyOwnerOf(_noteId) payable payFee {
117                 Note storage myNote = notes[_noteId];
118                 myNote.content = _content;
119         }
120 
121         function updateNoteTitle(uint64 _noteId, bytes12 _title) external notDeleted(_noteId) onlyOwnerOf(_noteId) payable payFee {
122                 Note storage myNote = notes[_noteId];
123                 myNote.title = _title;
124         }
125 
126         function updateNoteButContent(uint64 _noteId, uint16 _metadata, bytes12 _title) external notDeleted(_noteId) onlyOwnerOf(_noteId) payable payFee {
127                 Note storage myNote = notes[_noteId];
128                 myNote.metadata = _metadata;
129                 myNote.title = _title;
130         }
131 
132         // view functions
133         function getNotesCount() external view returns (uint64) {
134                 return uint64(notes.length);
135         }
136 
137         function getMyNote(uint64 _noteId) external notDeleted(_noteId) onlyOwnerOf(_noteId) view returns (uint16, bytes12, bytes) {
138                 return (notes[_noteId].metadata, notes[_noteId].title, notes[_noteId].content);
139         }
140 
141         function getMyNotes(uint64 _startFrom, uint64 _limit) external view returns (uint64[], uint16[], bytes2[], bytes12[], uint64) {
142                 uint64 len = uint64(ownerNotes[msg.sender].length);
143                 uint64 maxLoop = (len - _startFrom) > _limit ? _limit : (len - _startFrom);
144 
145                 uint64[] memory ids = new uint64[](maxLoop);
146                 uint16[] memory metadatas = new uint16[](maxLoop);
147                 bytes2[] memory publicKeys = new bytes2[](maxLoop);
148                 bytes12[] memory titles = new bytes12[](maxLoop);
149 
150                 for (uint64 i = 0; i < maxLoop; i++) {
151                         ids[i] = ownerNotes[msg.sender][i+_startFrom];
152                         metadatas[i] = notes[ ids[i] ].metadata;
153                         publicKeys[i] = notes[ ids[i] ].publicKey;
154                         titles[i] = notes[ ids[i] ].title;
155                 }
156                 return (ids, metadatas, publicKeys, titles, len);
157         }
158 
159         function publicGetNote(uint64 _noteId, bytes2 _publicKey) external notDeleted(_noteId) notPrivate(_noteId) view returns (uint16, bytes12, bytes) {
160                 require(notes[_noteId].publicKey == _publicKey); // for public to get the note's data, knowing the publicKey is needed
161                 return (notes[_noteId].metadata, notes[_noteId].title, notes[_noteId].content);
162         }
163 
164 }