1 pragma solidity ^0.4.23;
2 
3 // File: contracts/zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: contracts/Acceptable.sol
46 
47 // @title Acceptable
48 // @author Takayuki Jimba
49 // @dev Provide basic access control.
50 contract Acceptable is Ownable {
51     address public sender;
52 
53     // @dev Throws if called by any address other than the sender.
54     modifier onlyAcceptable {
55         require(msg.sender == sender);
56         _;
57     }
58 
59     // @dev Change acceptable address
60     // @param _sender The address to new sender
61     function setAcceptable(address _sender) public onlyOwner {
62         sender = _sender;
63     }
64 }
65 
66 // File: contracts/ExchangeBase.sol
67 
68 // @title ExchangeBase
69 // @author Takayuki Jimba
70 // @dev create, remove and succeed are supposed to be called from CryptoCrystal contract only.
71 contract ExchangeBase is Acceptable {
72     struct Exchange {
73         address owner;
74         uint256 tokenId;
75         uint8 kind;
76         uint128 weight;
77         uint64 createdAt;
78     }
79 
80     Exchange[] exchanges;
81 
82     mapping(uint256 => Exchange) tokenIdToExchange;
83 
84     event ExchangeCreated(
85         uint256 indexed id,
86         address owner,
87         uint256 ownerTokenId,
88         uint256 ownerTokenGene,
89         uint256 ownerTokenKind,
90         uint256 ownerTokenWeight,
91         uint256 kind,
92         uint256 weight,
93         uint256 createdAt
94     );
95     event ExchangeRemoved(uint256 indexed id, uint256 removedAt);
96 
97     function create(
98         address _owner,
99         uint256 _ownerTokenId,
100         uint256 _ownerTokenGene,
101         uint256 _ownerTokenKind,
102         uint256 _ownerTokenWeight,
103         uint256 _kind,
104         uint256 _weight,
105         uint256 _createdAt
106     ) public onlyAcceptable returns(uint256) {
107         require(!isOnExchange(_ownerTokenId));
108         require(_ownerTokenWeight > 0);
109         require(_weight > 0);
110         require(_createdAt > 0);
111         require(_weight <= 1384277343750);
112 
113         Exchange memory _exchange = Exchange({
114             owner: _owner,
115             tokenId: _ownerTokenId,
116             kind: uint8(_kind),
117             weight: uint128(_weight),
118             createdAt: uint64(_createdAt)
119             });
120         uint256 _id = exchanges.push(_exchange) - 1;
121         tokenIdToExchange[_ownerTokenId] = _exchange;
122         emit ExchangeCreated(
123             _id,
124             _owner,
125             _ownerTokenId,
126             _ownerTokenGene,
127             _ownerTokenKind,
128             _ownerTokenWeight,
129             _kind,
130             _weight,
131             _createdAt
132         );
133         return _id;
134     }
135 
136     function remove(uint256 _id) public onlyAcceptable {
137         require(isOnExchangeById(_id));
138 
139         Exchange memory _exchange = exchanges[_id];
140         delete tokenIdToExchange[_exchange.tokenId];
141         delete exchanges[_id];
142 
143         emit ExchangeRemoved(_id, now);
144     }
145 
146     function getExchange(uint256 _id) public view returns(
147         address owner,
148         uint256 tokenId,
149         uint256 kind,
150         uint256 weight,
151         uint256 createdAt
152     ) {
153         require(isOnExchangeById(_id));
154 
155         Exchange memory _exchange = exchanges[_id];
156         owner = _exchange.owner;
157         tokenId = _exchange.tokenId;
158         kind = _exchange.kind;
159         weight = _exchange.weight;
160         createdAt = _exchange.createdAt;
161     }
162 
163     function getTokenId(uint256 _id) public view returns(uint256) {
164         require(isOnExchangeById(_id));
165 
166         Exchange memory _exchange = exchanges[_id];
167         return _exchange.tokenId;
168     }
169 
170     function ownerOf(uint256 _id) public view returns(address) {
171         require(isOnExchangeById(_id));
172 
173         return exchanges[_id].owner;
174     }
175 
176     function isOnExchange(uint256 _tokenId) public view returns(bool) {
177         return tokenIdToExchange[_tokenId].createdAt > 0;
178     }
179 
180     function isOnExchangeById(uint256 _id) public view returns(bool) {
181         return (_id < exchanges.length) && (exchanges[_id].createdAt > 0);
182     }
183 }