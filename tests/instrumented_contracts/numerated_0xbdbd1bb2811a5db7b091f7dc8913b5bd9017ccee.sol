1 /**
2  *Submitted for verification at Etherscan.io on 2019-08-16
3 */
4 
5 pragma solidity 0.5.10;
6 
7 /**
8  * @title Ownable
9  * @dev The Ownable contract has an owner address, and provides basic authorization control
10  * functions, this simplifies the implementation of "user permissions".
11  */
12 contract Ownable {
13     address public owner;
14 
15 
16     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18 
19     /**
20      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21      * account.
22      */
23     constructor() public {
24         owner = msg.sender;
25     }
26 
27     /**
28      * @dev Throws if called by any account other than the owner.
29      */
30     modifier onlyOwner() {
31         require(msg.sender == owner);
32         _;
33     }
34 
35     /**
36      * @dev Allows the current owner to transfer control of the contract to a newOwner.
37      * @param newOwner The address to transfer ownership to.
38      */
39     function transferOwnership(address newOwner) public onlyOwner {
40         require(newOwner != address(0));
41         emit OwnershipTransferred(owner, newOwner);
42         owner = newOwner;
43     }
44 
45 }
46 contract IERC721 {
47     mapping (uint256 => address) public kittyIndexToApproved;
48     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
49     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
50     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
51 
52     function balanceOf(address owner) public view returns (uint256 balance);
53 
54     function ownerOf(uint256 tokenId) public view returns (address owner);
55 
56     function approve(address to, uint256 tokenId) public;
57 
58     function getApproved(uint256 tokenId) public view returns (address operator);
59     
60     function approvedFor(uint256 _tokenId) public view returns (address);
61 
62     function setApprovalForAll(address operator, bool _approved) public;
63 
64     function isApprovedForAll(address owner, address operator) public view returns (bool);
65 
66     function transfer(address to, uint256 tokenId) public;
67 
68     function transferFrom(address from, address to, uint256 tokenId) public;
69 
70     function safeTransferFrom(address from, address to, uint256 tokenId) public;
71 
72     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
73 }
74 contract ERC20BasicInterface {
75     function totalSupply() public view returns (uint256);
76 
77     function balanceOf(address who) public view returns (uint256);
78 
79     function transfer(address to, uint256 value) public returns (bool);
80 
81     function transferFrom(address from, address to, uint256 value) public returns (bool);
82 
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 
85     uint8 public decimals;
86 }
87 contract Gacha is Ownable {
88     struct item {
89         uint256[] tokenIds;
90     }
91     struct items {
92         mapping(address => item) items;
93         uint8 totalItem;
94     }
95     // bool public isEnded;
96     mapping(address => items) public awardDatas;
97 
98     event _setAward(address _from, address _game, uint256 tokenId);
99     constructor() public {}
100     function isApprovedForAll(address _game, uint256 _tokenId) public view returns (bool){
101         IERC721 erc721 = IERC721(_game);
102         
103         return (erc721.approvedFor(_tokenId) == address(this) || 
104         erc721.getApproved(_tokenId) == address(this) || 
105         erc721.isApprovedForAll(erc721.ownerOf(_tokenId), address(this)));
106     }
107     function getTokenIdByIndex(address _game, uint8 _index) public view returns (uint256){
108         return awardDatas[msg.sender].items[_game].tokenIds[_index];
109     }
110     function getGameBalance(address _game) public view returns (uint256){
111         return awardDatas[msg.sender].items[_game].tokenIds.length;
112     }
113     function setAward(address _user, address _game, uint256 _tokenId) public onlyOwner{
114         awardDatas[_user].items[_game].tokenIds.push(_tokenId);
115         awardDatas[_user].totalItem +=1;
116         emit _setAward(_user, _game, _tokenId);
117     }
118 
119     function withdraw(address _game, uint256 _tokenId) public {
120         IERC721 erc721 = IERC721(_game);
121         require(checkowner(_game, _tokenId));
122         erc721.transferFrom(erc721.ownerOf(_tokenId), msg.sender, _tokenId);
123     }
124     function checkowner(address _game, uint256 _tokenId) internal returns(bool) {
125         bool valid;
126         uint256[] storage ids = awardDatas[msg.sender].items[_game].tokenIds;
127         for(uint8 i = 0; i< ids.length; i++){
128             if(ids[i] == _tokenId) {
129                 valid = true;
130                 _burnArrayTokenId(_game, i);
131             }
132         }
133         return valid;
134     }
135     function _burnArrayTokenId(address _game, uint256 index)  internal {
136         if (index >= awardDatas[msg.sender].items[_game].tokenIds.length) return;
137 
138         for (uint i = index; i<awardDatas[msg.sender].items[_game].tokenIds.length-1; i++){
139             awardDatas[msg.sender].items[_game].tokenIds[i] = awardDatas[msg.sender].items[_game].tokenIds[i+1];
140         }
141         delete awardDatas[msg.sender].items[_game].tokenIds[awardDatas[msg.sender].items[_game].tokenIds.length-1];
142         awardDatas[msg.sender].items[_game].tokenIds.length--;
143         awardDatas[msg.sender].totalItem -=1;
144     }
145 
146 }