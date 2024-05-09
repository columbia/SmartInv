1 pragma solidity ^0.4.18;
2 
3 contract Owned {
4     address owner;
5     
6     function Owned() public {
7         owner = msg.sender;
8     }
9     
10 	modifier onlyOwner {
11 		require(msg.sender == owner);
12 		_;
13 	}
14 }
15 
16 contract Aeromart is Owned {
17     
18     struct Note {
19         bytes32 productID;
20         bytes20 serialNumber;
21         string text;
22     }
23     
24     uint public notesLength;
25     mapping (uint256 => Note) public notes;
26    
27     event noteInfo(
28         bytes32 productID,
29         bytes20 serialNumber,
30         string text
31     );
32     
33     function addNote(bytes32 _productID, bytes20 _serialNumber, string _text) onlyOwner public returns (uint) {
34         Note storage note = notes[notesLength];
35         
36         note.productID = _productID;
37         note.serialNumber = _serialNumber;
38         note.text = _text;
39         
40         emit noteInfo(_productID, _serialNumber, _text);
41         
42         notesLength++;
43         return notesLength;
44     }
45     
46     function setNote(uint256 _id, bytes32 _productID, bytes20 _serialNumber, string _text) onlyOwner public {
47         Note storage note = notes[_id];
48         
49         note.productID = _productID;
50         note.serialNumber = _serialNumber;
51         note.text = _text;
52         
53         emit noteInfo(_productID, _serialNumber, _text);
54     }
55     
56     function getNote(uint256 _id) view public returns (bytes32, bytes20, string) {
57         return (notes[_id].productID, notes[_id].serialNumber, notes[_id].text);
58     }
59     
60     // comments section
61     
62     struct Comment {
63         bytes3 rating; 
64         string text;
65     }
66     
67     uint public commentsLength;
68     mapping (address => Comment) public comments;
69     address[] public commentsAccounts;
70     
71     event commentInfo(
72         bytes3 rating,
73         string text
74     );
75     
76     /*
77     function addComment(bytes3 _rating, string _text) public returns (uint) {
78         Comment storage comment = comments[msg.sender];
79         
80         comment.rating = _rating;
81         comment.text = _text;
82         
83         emit commentInfo(_rating, _text);
84         
85         commentsLength++;
86         return commentsLength;
87         // commentsAccounts.push(msg.sender) -1;
88     }
89     */
90     
91     function setComment(bytes3 _rating, string _text) public {
92         Comment storage comment = comments[msg.sender];
93         
94         comment.rating = _rating;
95         comment.text = _text;
96         
97         emit commentInfo(_rating, _text);
98         
99         commentsAccounts.push(msg.sender) -1;
100     }
101     
102     function getComment(address _address) view public returns (bytes3, string) {
103         return (comments[_address].rating, comments[_address].text);
104     }
105     
106     function getCommentAccounts() view public returns (address[]) {
107         return commentsAccounts;
108     }
109     
110     function getCommentAccountsLength() view public returns (uint) {
111         return commentsAccounts.length;
112     }
113     
114 }