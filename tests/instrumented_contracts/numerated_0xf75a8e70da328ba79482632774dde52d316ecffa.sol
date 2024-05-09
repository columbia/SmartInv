1 pragma solidity 0.4.18;
2 
3 /// @title User Comments
4 /// @author Mark Beylin <mark.beylin@consensys.net>
5 
6 contract UserComments {
7     event CommentAdded(string _comment, address _from, address _to, uint _time);
8 
9     struct Comment{
10       string comment;
11       address from;
12       address to;
13       bool aboutBounty;
14       uint bountyId;
15       uint time;
16     }
17 
18     Comment[] public comments;
19 
20     modifier isValidCommentIndex(uint i){
21       require (i < comments.length);
22       _;
23     }
24 
25     function addComment(string _comment, address _to, bool _aboutBounty, uint _bountyId)
26     public
27     {
28       if (_aboutBounty){
29         comments.push(Comment(_comment, msg.sender, address(0), _aboutBounty, _bountyId, block.timestamp));
30       } else {
31         comments.push(Comment(_comment, msg.sender, _to, _aboutBounty, _bountyId, block.timestamp));
32       }
33       CommentAdded(_comment, msg.sender, _to, block.timestamp);
34     }
35 
36     function numComments()
37     public
38     constant
39     returns (uint){
40       return comments.length;
41     }
42 
43     function getComment(uint _commentId)
44     isValidCommentIndex(_commentId)
45     public
46     constant
47     returns (string, address, address, bool, uint, uint){
48       return (comments[_commentId].comment,
49               comments[_commentId].from,
50               comments[_commentId].to,
51               comments[_commentId].aboutBounty,
52               comments[_commentId].bountyId,
53               comments[_commentId].time);
54     }
55 }