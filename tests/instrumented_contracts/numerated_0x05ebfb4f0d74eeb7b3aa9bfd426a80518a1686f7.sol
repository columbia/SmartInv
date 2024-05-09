1 pragma solidity ^0.4.24;
2 
3 // DecentraList is a simple censorship-resistant posting engine.
4 //
5 // Any publisher(s) watch this contract for events. Each publisher selects the
6 // posts of interest based on locale and category.
7 //
8 // Locale:
9 //   . propose use IATA/airport code for city ex "YTO" = Toronto
10 //
11 // Category:
12 //   . ex "Vehicles" "Houses" "Animals"
13 //
14 // PostType:
15 //   . SELLING synonymous with "FOR SALE" or "FOR RENT"
16 //   . BUYING can also be "WANTED" or "IN SEARCH OF" or "HIRING"
17 //   . NOTICE is anything else, informational
18 //
19 // Post Text:
20 //   . text is any sequence of bytes, encoding/interpretation depends on
21 //     publisher
22 //
23 // Post Image:
24 //   . ex web-based publisher may use provided url as src in <img> tag
25 //   . use https://ipfs.io
26 //
27 // Payment:
28 //   . publishers should prioritise posts by amount paid
29 //   . image fee is the minimum per-image, text fee is per unit of length
30 
31 interface ERC20Compat {
32   function transfer( address to, uint256 quantity ) external;
33 }
34 
35 contract Ownable {
36   address public owner;
37   modifier isOwner {
38     require( msg.sender == owner );
39     _;
40   }
41   constructor() public { owner = msg.sender; }
42   function chown( address newowner ) isOwner public { owner = newowner; }
43 }
44 
45 contract DecentraList is Ownable {
46 
47   enum PostType { SELLING, BUYING, NOTICE }
48 
49   event ImagePosted( string   locale,
50                      string   category,
51                      PostType postType,
52                      string   url,
53                      uint256  payment );
54 
55   event TextPosted( string   locale,
56                     string   category,
57                     PostType postType,
58                     string   text,
59                     uint256  payment );
60 
61   uint256 public imageFee_;
62   uint256 public textFee_;
63 
64   constructor() public {
65     imageFee_ = 1 finney;
66     textFee_  = 5 szabo;
67   }
68 
69   function setTextFee( uint256 _tf ) isOwner public { textFee_ = _tf; }
70   function setImageFee( uint256 _if ) isOwner public { imageFee_ = _if; }
71 
72   function postImage( string   _locale,
73                       string   _category,
74                       PostType _ptype,
75                       string   _url ) public payable {
76 
77     require( msg.value >= imageFee_ );
78     emit ImagePosted( _locale, _category, _ptype, _url, msg.value );
79   }
80 
81   function postText( string   _locale,
82                      string   _category,
83                      PostType _ptype,
84                      string   _txt ) public payable {
85 
86     uint256 fee = bytes(_txt).length * textFee_;
87     require( msg.value >= fee );
88     emit TextPosted( _locale, _category, _ptype, _txt, fee );
89   }
90 
91   function retrieve( uint _amount ) isOwner public {
92     owner.transfer( _amount );
93   }
94 
95   function fwdTokens( address _toksca,
96                       address _to,
97                       uint256 _quantity ) isOwner public {
98     ERC20Compat(_toksca).transfer( _to, _quantity );
99   }
100 }
101 
102 // USE AT OWN RISK
103 // - Ethereum transaction data is public on the blockchain forever
104 // - Take care when using any network (ex use TOR)
105 // - Consider the strengths and weaknesses of IPFS
106 // - Some cameras and computer software can hide non-image data in image files