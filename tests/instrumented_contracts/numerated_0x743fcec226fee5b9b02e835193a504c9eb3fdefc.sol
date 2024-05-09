1 pragma solidity ^0.4.22;
2 
3 contract Owned {
4     address owner;
5     
6     function constuctor() public {
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
22 		string image;
23     }
24     
25     uint public notesLength;
26     mapping (uint256 => Note) public notes;
27    
28     event noteInfo(
29         bytes32 productID,
30         bytes20 serialNumber,
31         string text,
32 		string image
33     );
34     
35     function addNote(bytes32 _productID, bytes20 _serialNumber, string _text, string _image) onlyOwner public returns (uint) {
36         Note storage note = notes[notesLength];
37         
38         note.productID = _productID;
39         note.serialNumber = _serialNumber;
40         note.text = _text;
41 		note.image = _image;
42         
43         emit noteInfo(_productID, _serialNumber, _text, _image);
44         
45         notesLength++;
46         return notesLength;
47     }
48     
49     function setNote(uint256 _id, bytes32 _productID, bytes20 _serialNumber, string _text, string _image) onlyOwner public {
50         Note storage note = notes[_id];
51         
52         note.productID = _productID;
53         note.serialNumber = _serialNumber;
54         note.text = _text;
55 		note.image = _image;
56         
57         emit noteInfo(_productID, _serialNumber, _text, _image);
58     }
59     
60     function getNote(uint256 _id) view public returns (bytes32, bytes20, string, string) {
61         return (notes[_id].productID, notes[_id].serialNumber, notes[_id].text, notes[_id].image);
62     }
63     
64     // comments section
65     
66     struct Comment {
67         bytes3 rating; 
68         string text;
69     }
70     
71     uint public commentsLength;
72     mapping (uint256 => Comment) public comments;
73     address[] public commentsAccounts;
74     
75     event commentInfo(
76         bytes3 rating,
77         string text
78     );
79     
80     function addComment(bytes3 _rating, string _text) public returns (uint) {
81         Comment storage comment = comments[commentsLength];
82         
83         comment.rating = _rating;
84         comment.text = _text;
85         
86         emit commentInfo(_rating, _text);
87         
88         commentsLength++;
89         return commentsLength;
90     }
91         
92     function setComment(uint256 _id, bytes3 _rating, string _text) public {
93         Comment storage comment = comments[_id];
94         
95         comment.rating = _rating;
96         comment.text = _text;
97         
98         emit commentInfo(_rating, _text);
99     }
100     
101     function getComment(uint256 _id) view public returns (bytes3, string) {
102         return (comments[_id].rating, comments[_id].text);
103     }
104     
105 }