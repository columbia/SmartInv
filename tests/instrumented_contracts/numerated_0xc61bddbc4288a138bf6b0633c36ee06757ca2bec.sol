1 pragma solidity ^0.4.23;
2 contract Ownable {
3   address public owner;
4 
5   constructor() public {
6     owner = msg.sender;
7   }
8 
9   modifier onlyOwner() {
10     require(msg.sender == owner);
11     _;
12   }
13 
14   function transferOwnership(address newOwner) public onlyOwner {
15     if (newOwner != address(0)) {
16       owner = newOwner;
17     }
18   }
19 
20   function withdraw() public onlyOwner{
21       owner.transfer(address(this).balance);
22   }
23 
24 }
25 
26 
27 contract SimpleERC721{
28     function ownerOf(uint256 _tokenId) external view returns (address owner);
29     function transferFrom(address _from, address _to, uint256 _tokenId) external;
30     function transfer(address _to, uint256 _tokenId) external;
31 }
32 
33 contract Solitaire is Ownable {
34     event NewAsset(uint256 index,address nft, uint256 token, address owner, string url,string memo);
35 
36     struct Asset{
37         address nft;
38         uint256 tokenId;
39         address owner;
40         string url;
41         string memo;
42     }
43     uint256 public fee = 5 finney;
44     Asset[] queue;
45 
46     function init(address _nft,uint256 _id,address _owner,string _url,string _memo) public onlyOwner{
47         require(queue.length<=1);
48         Asset memory a = Asset({
49             nft: _nft,
50             tokenId: _id,
51             owner: _owner,
52             url: _url,
53             memo: _memo
54         });
55         if (queue.length==0){
56             queue.push(a);
57         }else{
58             queue[0] = a;
59         }
60         emit NewAsset(0,_nft,_id,_owner,_url,_memo);
61     }
62     
63     function refund(address _nft,uint256 _id,address _owner) public onlyOwner{
64         require(_owner != address(0));
65         SimpleERC721 se = SimpleERC721(_nft);
66         require(se.ownerOf(_id) == address(this));
67         se.transfer(_owner,_id);
68     }
69     
70     function setfee(uint256 _fee) public onlyOwner{
71         require(_fee>=0);
72         fee = _fee;
73     }
74     
75     function totalAssets() public view returns(uint256){
76         return queue.length;
77     }
78     
79     function getAsset(uint256 _index) public view returns(address _nft,uint256 _id,address _owner,string _url,string _memo){
80         require(_index<queue.length);
81         Asset memory _a = queue[_index];
82         _nft = _a.nft;
83         _id = _a.tokenId;
84         _owner = _a.owner;
85         _url = _a.url;
86         _memo = _a.memo;
87     }
88     
89     function addLayer(address _nft,uint256 _id,string _url,string _memo) public payable{
90         require(msg.value >=fee);
91         require(_nft != address(0));
92         SimpleERC721 se = SimpleERC721(_nft);
93         require(se.ownerOf(_id) == msg.sender);
94         se.transferFrom(msg.sender,address(this),_id);
95         // double check
96         require(se.ownerOf(_id) == address(this));
97         Asset memory last = queue[queue.length -1];
98         SimpleERC721 lastse = SimpleERC721(last.nft);
99         lastse.transfer(msg.sender,last.tokenId);
100         Asset memory newasset = Asset({
101             nft: _nft,
102             tokenId: _id,
103             owner: msg.sender,
104             url: _url,
105             memo: _memo
106         });
107         uint256 index = queue.push(newasset) - 1;
108         emit NewAsset(index,_nft,  _id,  msg.sender,_url,_memo);
109     }
110 
111 }