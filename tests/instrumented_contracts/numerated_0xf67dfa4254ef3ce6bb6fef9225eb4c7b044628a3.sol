1 //
2 // compiler: solcjs
3 //  version: 0.4.19+commit.c4cbbb05.Emscripten.clang
4 //
5 pragma solidity ^0.4.19;
6 
7 contract owned {
8   address public owner;
9 
10   function owned() public { owner = msg.sender; }
11 
12   modifier onlyOwner {
13     if (msg.sender != owner) { revert(); }
14     _;
15   }
16 
17   function changeOwner( address newowner ) public onlyOwner {
18     owner = newowner;
19   }
20 
21   function closedown() public onlyOwner {
22     selfdestruct( owner );
23   }
24 }
25 
26 // "extern" declare functions from token contract
27 interface BitEther {
28   function transfer(address to, uint256 value) public;
29   function balanceOf( address owner ) public constant returns (uint);
30 }
31 
32 contract BTTPREICO is owned {
33 
34   uint public constant STARTTIME = 1515794400; // 12 JAN 2017 00:00 GMT
35   uint public constant ENDTIME = 1517104800;   // 27 JAN 2017 00:00 GMT
36   uint public constant BTTPERETH = 1550;       // price: approx $0.65 ea
37 
38   BitEther public tokenSC;
39 
40   function BTTPREICO() public {}
41 
42   function setToken( address tok ) public onlyOwner {
43     if ( tokenSC == address(0) )
44       tokenSC = BitEther(tok);
45   }
46 
47   function() public payable {
48     if (now < STARTTIME || now > ENDTIME)
49       revert();
50 
51     // (amountinwei/weipereth * bitether/eth) * ( (100 + bonuspercent)/100 )
52     // = amountinwei*bitetherpereth/weipereth*(bonus+100)/100
53     uint qty =
54       div(mul(div(mul(msg.value, BTTPERETH),1000000000000000000),(bonus()+100)),100);
55 
56     if (qty > tokenSC.balanceOf(address(this)) || qty < 1)
57       revert();
58 
59     tokenSC.transfer( msg.sender, qty );
60   }
61 
62   // unsold tokens can be claimed by owner after sale ends
63   function claimUnsold() public onlyOwner {
64     if ( now < ENDTIME )
65       revert();
66 
67     tokenSC.transfer( owner, tokenSC.balanceOf(address(this)) );
68   }
69 
70   function withdraw( uint amount ) public onlyOwner returns (bool) {
71     if (amount <= this.balance)
72       return owner.send( amount );
73 
74     return false;
75   }
76 
77   function bonus() pure private returns(uint) {
78     return 0;
79   }
80 
81   // ref:
82   // github.com/OpenZeppelin/zeppelin-solidity/
83   // blob/master/contracts/math/SafeMath.sol
84   function mul(uint256 a, uint256 b) pure private returns (uint256) {
85     uint256 c = a * b;
86     assert(a == 0 || c / a == b);
87     return c;
88   }
89 
90   function div(uint256 a, uint256 b) pure private returns (uint256) {
91     uint256 c = a / b;
92     return c;
93   }
94 }