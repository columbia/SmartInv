1 pragma solidity ^0.4.19;
2 
3 contract owned {
4   address public owner;
5 
6   function owned() { owner = msg.sender; }
7 
8   modifier onlyOwner {
9     if (msg.sender != owner) { revert(); }
10     _;
11   }
12 
13   function changeOwner( address newowner ) onlyOwner {
14     owner = newowner;
15   }
16 
17   function closedown() onlyOwner {
18     selfdestruct( owner );
19   }
20 }
21 
22 // "extern" declare functions from token contract
23 interface BitEther {
24   function transfer(address to, uint256 value);
25   function balanceOf( address owner ) constant returns (uint);
26 }
27 
28 contract BTTICO is owned {
29 
30   uint public constant STARTTIME = 1518703200; // 15 FEB 2018 00:00 GMT
31   uint public constant ENDTIME = 1520010000;   // 02 MAR 2018 00:00 GMT
32   uint public constant BTTPERETH = 680;       // price: approx $1.25 ea
33 
34   BitEther public tokenSC;
35 
36   function BTTICO() {}
37 
38   function setToken( address tok ) onlyOwner {
39     if ( tokenSC == address(0) )
40       tokenSC = BitEther(tok);
41   }
42 
43   function() payable {
44     if (now < STARTTIME || now > ENDTIME)
45       revert();
46 
47     // (amountinwei/weipereth * bitether/eth) * ( (100 + bonuspercent)/100 )
48     // = amountinwei*bitetherpereth/weipereth*(bonus+100)/100
49     uint qty =
50       div(mul(div(mul(msg.value, BTTPERETH),1000000000000000000),(bonus()+100)),100);
51 
52     if (qty > tokenSC.balanceOf(address(this)) || qty < 1)
53       revert();
54 
55     tokenSC.transfer( msg.sender, qty );
56   }
57 
58   // unsold tokens can be claimed by owner after sale ends
59   function claimUnsold() onlyOwner {
60     if ( now < ENDTIME )
61       revert();
62 
63     tokenSC.transfer( owner, tokenSC.balanceOf(address(this)) );
64   }
65 
66   function withdraw( uint amount ) onlyOwner returns (bool) {
67     if (amount <= this.balance)
68       return owner.send( amount );
69 
70     return false;
71   }
72 
73   function bonus() internal constant returns(uint) {
74     return 0;
75   }
76 
77   // ref:
78   // github.com/OpenZeppelin/zeppelin-solidity/
79   // blob/master/contracts/math/SafeMath.sol
80   function mul(uint256 a, uint256 b) constant returns (uint256) {
81     uint256 c = a * b;
82     assert(a == 0 || c / a == b);
83     return c;
84   }
85 
86   function div(uint256 a, uint256 b) constant returns (uint256) {
87     uint256 c = a / b;
88     return c;
89   }
90 }