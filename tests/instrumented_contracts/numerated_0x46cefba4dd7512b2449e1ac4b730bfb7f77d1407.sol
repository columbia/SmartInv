1 pragma solidity ^0.4.21;
2 
3 /// @author MinakoKojima (https://github.com/lychees)
4 contract DecentralizedExchangeHotPotato {
5   address private owner;
6   mapping (address => bool) private admins;
7   
8   struct Order {
9     address creator;    
10     address owner;
11     address issuer;    
12     uint256 tokenId;    
13     uint256 price;
14     uint256 startTime;
15     uint256 endTime;
16   }  
17   Order[] private orderBook;
18   uint256 private orderBookSize;
19 
20   function DecentralizedExchangeHotPotato() public {
21     owner = msg.sender;
22     admins[owner] = true;    
23   }
24 
25   /* Modifiers */
26   modifier onlyOwner() {
27     require(owner == msg.sender);
28     _;
29   }
30 
31   modifier onlyAdmins() {
32     require(admins[msg.sender]);
33     _;
34   }
35 
36   /* Owner */
37   function setOwner (address _owner) onlyOwner() public {
38     owner = _owner;
39   }
40 
41   function addAdmin (address _admin) onlyOwner() public {
42     admins[_admin] = true;
43   }
44 
45   function removeAdmin (address _admin) onlyOwner() public {
46     delete admins[_admin];
47   }
48 
49   /* Withdraw */
50   function withdrawAll () onlyAdmins() public {
51    msg.sender.transfer(address(this).balance);
52   }
53 
54   function withdrawAmount (uint256 _amount) onlyAdmins() public {
55     msg.sender.transfer(_amount);
56   }
57 
58   /* ERC721 */
59   function name() public pure returns (string _name) {
60     return "dapdap.io | HotPotatoExchange";
61   }
62 
63   /* Read */
64   function isAdmin(address _admin) public view returns (bool _isAdmin) {
65     return admins[_admin];
66   }
67   function totalOrder() public view returns (uint256 _totalOrder) {
68     return orderBookSize;
69   }  
70   function allOf (uint256 _id) public view returns (address _creator, address _owner, address _issuer, uint256 _tokenId, uint256 _price, uint256 _startTime, uint256 _endTime) {
71     return (orderBook[_id].creator, orderBook[_id].owner, orderBook[_id].issuer, orderBook[_id].tokenId, orderBook[_id].price, orderBook[_id].startTime, orderBook[_id].endTime);
72   }  
73   
74   /* Util */
75   function isContract(address addr) internal view returns (bool) {
76     uint size;
77     assembly { size := extcodesize(addr) } // solium-disable-line
78     return size > 0;
79   }
80 
81   function getNextPrice (uint256 _price) public pure returns (uint256 _nextPrice) {
82     return _price * 123 / 100;
83   }  
84 
85   /* Buy */
86   function put(address _issuer, uint256 _tokenId, uint256 _price,
87                uint256 _startTime, uint256 _endTime) public {
88     require(_startTime <= _endTime);                 
89     Issuer issuer = Issuer(_issuer);
90     require(issuer.ownerOf(_tokenId) == msg.sender);
91     issuer.transferFrom(msg.sender, address(this), _tokenId);
92     if (orderBookSize == orderBook.length) {
93       orderBook.push(Order(msg.sender, msg.sender,  _issuer, _tokenId, _price, _startTime, _endTime));
94     } else {    
95       orderBook[orderBookSize] = Order(msg.sender, msg.sender,  _issuer, _tokenId, _price, _startTime, _endTime);
96     }
97     orderBookSize += 1;
98   }
99   function buy(uint256 _id) public payable{
100     require(msg.value >= orderBook[_id].price);
101     require(msg.sender != orderBook[_id].owner);
102     require(!isContract(msg.sender));
103     require(orderBook[_id].startTime <= now && now <= orderBook[_id].endTime);
104     orderBook[_id].owner.transfer(orderBook[_id].price*24/25); // 96%
105     orderBook[_id].creator.transfer(orderBook[_id].price/50);  // 2%    
106     if (msg.value > orderBook[_id].price) {
107         msg.sender.transfer(msg.value - orderBook[_id].price);
108     }
109     orderBook[_id].owner = msg.sender;
110     orderBook[_id].price = getNextPrice(orderBook[_id].price);
111   }
112   function revoke(uint256 _id) public {
113     require(msg.sender == orderBook[_id].owner);
114     require(orderBook[_id].endTime <= now);
115     
116     Issuer issuer = Issuer(orderBook[_id].issuer);
117     issuer.transfer(msg.sender, orderBook[_id].tokenId);    
118     orderBook[_id] = orderBook[orderBookSize-1];
119     orderBookSize -= 1;
120   }
121 }
122 
123 interface Issuer {
124   function transferFrom(address _from, address _to, uint256 _tokenId) external;  
125   function transfer(address _to, uint256 _tokenId) external;
126   function ownerOf (uint256 _tokenId) external view returns (address _owner);
127 }