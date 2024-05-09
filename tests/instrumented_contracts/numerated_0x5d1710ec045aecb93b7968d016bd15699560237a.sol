1 pragma solidity ^0.5.3;
2 
3 interface Token {
4   function transfer( address to, uint amount ) external;
5   function transferFrom( address from, address to, uint quantity ) external;
6 }
7 
8 contract Owned
9 {
10   address payable public owner;
11   constructor() public { owner = msg.sender; }
12 
13   function changeOwner( address payable newOwner ) isOwner public {
14     owner = newOwner;
15   }
16 
17   modifier isOwner {
18     require( msg.sender == owner );
19     _;
20   }
21 }
22 
23 contract Membership is Owned
24 {
25   event Approval( address indexed member, bool status );
26   event Receipt( address indexed member, uint256 amount );
27   event ReceiptTokens( address indexed member, uint256 amount );
28 
29   mapping( address => bool ) public approvals;
30 
31   address payable public treasury;
32   uint256 public fee;
33   Token   public token;
34   uint256 public tokenFee;
35   uint256 dao;
36 
37   constructor() public {
38     dao = uint256(100);
39   }
40 
41   function setFee( uint256 _fee ) isOwner public {
42     fee = _fee;
43   }
44 
45   function setDao( uint256 _dao ) isOwner public {
46     dao = _dao;
47   }
48 
49   function setTreasury( address payable _treasury ) isOwner public {
50     treasury = _treasury;
51   }
52 
53   function setToken( address _token ) isOwner public {
54     token = Token(_token);
55   }
56 
57   function setTokenFee( uint _tfee ) isOwner public {
58     tokenFee = _tfee;
59   }
60 
61   function setApproval( address _member, bool _status ) isOwner public {
62     approvals[_member] = _status;
63     emit Approval( _member, _status );
64   }
65 
66   function isMember( address _addr ) view public returns (bool) {
67     return approvals[_addr];
68   }
69 
70   function() payable external {
71     require( msg.value >= fee, "Insufficient value." );
72 
73     if (treasury != address(0))
74       treasury.transfer( msg.value - msg.value / dao );
75 
76     emit Receipt( msg.sender, msg.value );
77   }
78 
79   function payWithTokens() public {
80     require( token != Token(0) && tokenFee > 0, "Token not set up." );
81 
82     token.transferFrom( msg.sender, address(this), tokenFee );
83 
84     if (treasury != address(0))
85       token.transfer( treasury, tokenFee - tokenFee / dao );
86 
87     emit ReceiptTokens( msg.sender, tokenFee );
88   }
89 
90   function withdraw( uint256 amount ) isOwner public {
91     owner.transfer( amount );
92   }
93 
94   function sendTok( address _tok, address _to, uint256 _qty ) isOwner public {
95     Token(_tok).transfer( _to, _qty );
96   }
97 }