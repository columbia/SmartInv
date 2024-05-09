1 pragma solidity ^0.4.21;
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
20         string text;
21 		string image;
22     }
23     
24     uint public notesLength;
25     mapping (uint256 => Note) public notes;
26    
27     event noteInfo(
28         bytes32 productID,
29         string text,
30 		string image
31     );
32     
33     function addNote(bytes32 _productID, string _text, string _image) onlyOwner public returns (uint) {
34         Note storage note = notes[notesLength];
35         
36         note.productID = _productID;        
37         note.text = _text;
38 		note.image = _image;
39         
40         emit noteInfo(_productID, _text, _image);
41         
42         notesLength++;
43         return notesLength;
44     }
45     
46     function setNote(uint256 _id, bytes32 _productID, string _text, string _image) onlyOwner public {
47         Note storage note = notes[_id];
48         
49         note.productID = _productID;        
50         note.text = _text;
51 		note.image = _image;
52         
53         emit noteInfo(_productID, _text, _image);
54     }
55     
56     function getNote(uint256 _id) view public returns (bytes32, string, string) {
57         return (notes[_id].productID, notes[_id].text, notes[_id].image);
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
68     mapping (uint256 => Comment) public comments;
69     address[] public commentsAccounts;
70     
71     event commentInfo(
72         bytes3 rating,
73         string text
74     );
75     
76     function addComment(bytes3 _rating, string _text) public returns (uint) {
77         Comment storage comment = comments[commentsLength];
78         
79         comment.rating = _rating;
80         comment.text = _text;
81         
82         emit commentInfo(_rating, _text);
83         
84         commentsLength++;
85         return commentsLength;
86     }
87         
88     function setComment(uint256 _id, bytes3 _rating, string _text) public {
89         Comment storage comment = comments[_id];
90         
91         comment.rating = _rating;
92         comment.text = _text;
93         
94         emit commentInfo(_rating, _text);
95     }
96     
97     function getComment(uint256 _id) view public returns (bytes3, string) {
98         return (comments[_id].rating, comments[_id].text);
99     }
100     
101 }