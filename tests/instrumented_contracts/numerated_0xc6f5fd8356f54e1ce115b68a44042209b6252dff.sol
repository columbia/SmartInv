1 pragma solidity ^0.5.3;
2 
3 interface Membership {
4   function isMember( address who ) external returns (bool);
5 }
6 
7 interface Token {
8   function transfer( address to, uint amount ) external;
9   function transferFrom( address from, address to, uint amount ) external;
10 }
11 
12 contract Owned {
13   address payable public owner_;
14   constructor() public { owner_ = msg.sender; }
15   function changeOwner( address payable newOwner ) isOwner public {
16     owner_ = newOwner;
17   }
18 
19   modifier isOwner {
20     require( msg.sender == owner_ );
21     _;
22   }
23 }
24 
25 contract Votes is Owned {
26 
27   event Vote( address indexed voter,
28               uint    indexed blocknum,
29               string          hash );
30 
31   Membership      public membership_;
32   address payable public treasury_;
33   Token           public token_;
34 
35   uint256 public fee_;
36   uint256 public tokenFee_;
37   uint256 public dao_;
38 
39   constructor() public {
40     dao_ = uint256(100);
41   }
42 
43   function setMembership( address _contract ) isOwner public {
44     membership_ = Membership( _contract );
45   }
46 
47   function setTreasury( address payable _treasury ) isOwner public {
48     treasury_ = _treasury;
49   }
50 
51   function setToken( address _token ) isOwner public {
52     token_ = Token(_token);
53   }
54 
55   function setFee( uint _newfee ) isOwner public {
56     fee_ = _newfee;
57   }
58 
59   function setTokenFee( uint256 _fee ) isOwner public {
60     tokenFee_ = _fee;
61   }
62 
63   function setDao( uint _dao ) isOwner public {
64     dao_ = _dao;
65   }
66 
67   function vote( uint _blocknum, string memory _hash ) payable public {
68     require( msg.value >= fee_ );
69 
70     if (treasury_ != address(0))
71       treasury_.transfer( msg.value - msg.value / dao_ );
72 
73     vote_int( _blocknum, _hash );
74   }
75 
76   function vote_t( uint _blocknum, string memory _hash ) public {
77     token_.transferFrom( msg.sender, address(this), tokenFee_ );
78 
79     if (treasury_ != address(0)) {
80       token_.transfer( treasury_, tokenFee_ - tokenFee_/dao_ );
81     }
82 
83     vote_int( _blocknum, _hash );
84   }
85 
86   function vote_int( uint _blocknum, string memory _hash ) internal {
87     require( membership_.isMember(msg.sender) );
88 
89     emit Vote( msg.sender, _blocknum, _hash );
90   }
91 
92   function withdraw( uint amt ) isOwner public {
93     owner_.transfer( amt );
94   }
95 
96   function sendTok( address _tok, address _to, uint _qty ) isOwner public {
97     Token(_tok).transfer( _to, _qty );
98   }
99 }