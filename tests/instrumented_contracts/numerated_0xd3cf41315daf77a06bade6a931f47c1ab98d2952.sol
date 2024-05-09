1 pragma solidity ^0.5.3;
2 
3 interface Token {
4   function transfer( address to, uint amount ) external;
5   function transferFrom( address from, address to, uint amount ) external;
6 }
7 
8 interface Membership {
9   function isMember( address pusher ) external returns (bool);
10 }
11 
12 contract Owned
13 {
14   address payable public owner;
15   constructor() public { owner = msg.sender; }
16 
17   function changeOwner( address payable newOwner ) isOwner public {
18     owner = newOwner;
19   }
20 
21   modifier isOwner {
22     require( msg.sender == owner );
23     _;
24   }
25 }
26 
27 contract Publisher is Owned
28 {
29   event Published( string indexed receiverpubkey,
30                    string ipfshash,
31                    string redmeta );
32 
33   Membership public membership;
34 
35   address payable public treasury;
36   uint256 public fee;
37   uint256 dao;
38 
39   uint256 public tokenFee;
40   Token   public token;
41 
42   constructor() public {
43     dao = uint256(100);
44   }
45 
46   function setFee( uint256 _fee ) isOwner public {
47     fee = _fee;
48   }
49 
50   function setDao( uint256 _dao ) isOwner public {
51     dao = _dao;
52   }
53 
54   function setTreasury( address payable _treasury ) isOwner public {
55     treasury = _treasury;
56   }
57 
58   function setMembership( address _contract ) isOwner public {
59     membership = Membership(_contract);
60   }
61 
62   function setTokenFee( uint256 _fee ) isOwner public {
63     tokenFee = _fee;
64   }
65 
66   function setToken( address _token ) isOwner public {
67     token = Token(_token);
68   }
69 
70   function publish( string memory receiverpubkey,
71                     string memory ipfshash,
72                     string memory redmeta ) payable public {
73 
74     require(    msg.value >= fee
75              && membership.isMember(msg.sender) );
76 
77     if (treasury != address(0))
78       treasury.transfer( msg.value - msg.value / dao );
79 
80     emit Published( receiverpubkey, ipfshash, redmeta );
81   }
82 
83   function publish_t( string memory receiverpubkey,
84                       string memory ipfshash,
85                       string memory redmeta ) public {
86 
87     require( membership.isMember(msg.sender) );
88 
89     token.transferFrom( msg.sender, address(this), tokenFee );
90 
91     if (treasury != address(0)) {
92       token.transfer( treasury, tokenFee - tokenFee/dao );
93     }
94 
95     emit Published( receiverpubkey, ipfshash, redmeta );
96   }
97 
98   function withdraw( uint256 amount ) isOwner public {
99     owner.transfer( amount );
100   }
101 
102   function sendTok( address _tok, address _to, uint256 _qty ) isOwner public {
103     Token(_tok).transfer( _to, _qty );
104   }
105 }