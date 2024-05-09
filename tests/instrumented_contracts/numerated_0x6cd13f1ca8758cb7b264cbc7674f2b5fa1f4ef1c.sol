1 pragma solidity ^0.5;
2 
3 contract owned {
4     address payable public owner;
5 
6     constructor () public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address payable newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 contract limited is owned {
21     mapping (address => bool) canAsk ;
22     
23      modifier onlyCanAsk {
24         require(canAsk[msg.sender]);
25         _;
26     }
27     
28     function changeAsk (address a,bool allow) onlyOwner public {
29         canAsk[a] = allow;
30     }
31     
32 }
33 
34 interface ICampaign {
35     function update(bytes32 idRequest,uint64 likes,uint64 shares,uint64 views) external  returns (bool ok);
36 }
37 
38 interface IERC20 {
39    function transfer(address _to, uint256 _value) external;
40 }
41 
42 contract oracle is limited {
43     
44     
45     // social network ids: 
46     // 01 : facebook;
47     // 02 : youtube
48     // 03 : instagram
49     // 04 : twitter
50     // 05 : url TLS Notary
51     
52     event AskRequest(bytes32 indexed idRequest, uint8 typeSN, string idPost,string idUser);
53     event AnswerRequest(bytes32 indexed idRequest, uint64 likes, uint64 shares, uint64 views);
54     
55     function  ask (uint8 typeSN,string memory idPost,string memory idUser, bytes32 idRequest) public onlyCanAsk
56     {
57         emit AskRequest(idRequest, typeSN, idPost, idUser );
58     }
59     
60     function answer(address campaignContract,bytes32 idRequest,uint64 likes,uint64 shares, uint64 views) public onlyOwner {
61         ICampaign campaign = ICampaign(campaignContract);
62         campaign.update(idRequest,likes,shares,views);
63         emit AnswerRequest(idRequest,likes,shares,views);
64     }
65     
66     function() external payable {}
67     
68     function withdraw() onlyOwner public {
69         owner.transfer(address(this).balance);
70     }
71     
72     function transferToken (address token,address to,uint256 val) public onlyOwner {
73         IERC20 erc20 = IERC20(token);
74         erc20.transfer(to,val);
75     }
76     
77 }