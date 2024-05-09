1 pragma solidity ^0.4.23;
2 
3 contract DrewsReviews {
4     
5     uint public reviewIndex;
6     uint public userReviewIndex;
7     address public owner = 0x7753233bfe961eC770602e3F80900E26A5357F36;
8     
9     mapping (uint => Review) reviewList;
10     mapping (uint => userReview) userReviewList;
11 
12 
13 	struct Review {
14 		string name;
15 		string review;
16 		uint reviewDate;
17 		uint score;
18 		string imageSource;
19 		uint deleted;
20 	}
21 
22 	struct userReview {
23 		uint filmId;
24 		string userName;
25 		string review;
26 		uint score;
27 		uint deleted;
28 	}
29 	
30 constructor () public {
31     reviewIndex = 0;
32     userReviewIndex = 0;
33 }
34 
35 event newReview(uint _filmId, string _name, string _review, string _imageSource, uint _score);
36 
37 event editedReview(uint _filmId, string _name, string _review, string _imageSource, uint _score, uint _deleted);
38 
39 event newUserReview(uint _filmId, uint _userReviewId, string _userName, string _review, uint _score);
40 
41 event editedUserReview(uint _filmId, uint _userReviewId, string _userName, string _review, uint _score, uint _deleted);
42 
43 function addReview(string _name, string _review, uint _reviewdate, uint _score, string _imageSource) public {
44 	assert(msg.sender == owner);
45 
46     reviewIndex += 1;
47     Review memory review = Review (_name, _review, _reviewdate, _score, _imageSource, 0 );
48     reviewList[reviewIndex] = review;
49     emit newReview(reviewIndex, _name, _review, _imageSource, _score);
50 }
51 
52 function editReview(uint _filmId, string _name, string _review, uint _reviewdate, uint _score, string _imageSource, uint _deleted) public {
53 	assert(msg.sender == owner);
54     
55     Review memory review = Review (_name, _review, _reviewdate, _score, _imageSource, _deleted );
56 
57     reviewList[_filmId] = review;
58     emit editedReview(_filmId, _name, _review, _imageSource, _score, _deleted);
59 }
60 
61 function deleteUserReview(uint _userReviewId) public {
62 	assert(msg.sender == owner);
63 
64 	userReview memory _originalReview = userReviewList[_userReviewId];
65     
66     userReview memory _userReview = userReview ( _originalReview.filmId, _originalReview.userName, _originalReview.review, _originalReview.score, 1);
67     userReviewList[_userReviewId] = _userReview;
68     emit editedUserReview(_originalReview.filmId, _userReviewId, _originalReview.userName, _originalReview.review, _originalReview.score, 1);
69 }
70 
71 function addUserReview(uint _filmId, string _username, string _review, uint _score) public {
72     userReviewIndex += 1;
73     
74     userReview memory _userReview = userReview (_filmId, _username, _review, _score, 0);
75     userReviewList[userReviewIndex] = _userReview;
76     emit newUserReview(_filmId, userReviewIndex, _username, _review, _score);
77 }
78 
79 function getReview(uint _filmId) view public returns (string, string, uint, uint, string, uint) {
80 	Review memory review = reviewList[_filmId];
81 	return (review.name, review.review, review.reviewDate, review.score, review.imageSource, review.deleted);
82 }
83 
84 function getUserReview(uint _userReviewId) view public returns (uint, string, string, uint, uint) {
85 	userReview memory _userReview = userReviewList[_userReviewId];
86 	return (_userReview.filmId, _userReview.userName, _userReview.review, _userReview.score, _userReview.deleted);
87 }
88 
89 }