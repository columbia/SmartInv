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
20         string textOrImage;
21     }
22     
23     uint public notesLength;
24     mapping (uint256 => Note) public notes;
25    
26     event noteInfo(
27         bytes32 productID,
28         string textOrImage
29     );
30     
31     function addNote(bytes32 _productID, string _textOrImage) onlyOwner public returns (uint) {
32         Note storage note = notes[notesLength];
33         
34         note.productID = _productID;
35         note.textOrImage = _textOrImage;
36 		
37         emit noteInfo(_productID, _textOrImage);
38         
39         notesLength++;
40         return notesLength;
41     }
42     
43     function setNote(uint256 _id, bytes32 _productID, string _textOrImage) onlyOwner public {
44         Note storage note = notes[_id];
45         
46         note.productID = _productID;
47         note.textOrImage = _textOrImage;
48         
49         emit noteInfo(_productID, _textOrImage);
50     }
51     
52     function getNote(uint256 _id) view public returns (bytes32, string) {
53         return (notes[_id].productID, notes[_id].textOrImage);
54     }
55     
56     // comments section
57     
58     struct Comment {
59         bytes3 rating; 
60         string text;
61     }
62     
63     uint public commentsLength;
64     mapping (uint256 => Comment) public comments;
65     address[] public commentsAccounts;
66     
67     event commentInfo(
68         bytes3 rating,
69         string text
70     );
71     
72     function addComment(bytes3 _rating, string _text) public returns (uint) {
73         Comment storage comment = comments[commentsLength];
74         
75         comment.rating = _rating;
76         comment.text = _text;
77         
78         emit commentInfo(_rating, _text);
79         
80         commentsLength++;
81         return commentsLength;
82     }
83         
84     function setComment(uint256 _id, bytes3 _rating, string _text) public {
85         Comment storage comment = comments[_id];
86         
87         comment.rating = _rating;
88         comment.text = _text;
89         
90         emit commentInfo(_rating, _text);
91     }
92     
93     function getComment(uint256 _id) view public returns (bytes3, string) {
94         return (comments[_id].rating, comments[_id].text);
95     }
96     
97 }