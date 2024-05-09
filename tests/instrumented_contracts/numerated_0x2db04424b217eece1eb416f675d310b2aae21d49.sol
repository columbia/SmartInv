1 //
2 // compiler: solcjs -o ./build/contracts --optimize --abi --bin <this file>
3 //  version: 0.4.15+commit.bbb8e64f.Emscripten.clang
4 //
5 pragma solidity ^0.4.15;
6 
7 contract owned {
8   address public owner;
9 
10   function owned() { owner = msg.sender; }
11 
12   modifier onlyOwner {
13     if (msg.sender != owner) { revert(); }
14     _;
15   }
16 
17   function changeOwner( address newowner ) onlyOwner {
18     owner = newowner;
19   }
20 
21   function closedown() onlyOwner {
22     selfdestruct( owner );
23   }
24 }
25 
26 // "extern" declare functions from token contract
27 interface JBX {
28   function transfer(address to, uint256 value);
29   function balanceOf( address owner ) constant returns (uint);
30 }
31 
32 contract JBXICO is owned {
33 
34   uint public constant STARTTIME = 1510099200; // 08 NOV 2017 00:00 GMT
35   uint public constant ENDTIME = 1512691200;   // 08 DEC 2017 00:00 GMT
36   uint public constant JBXPERETH = 1500;       // price: approx $0.20 ea
37 
38   JBX public tokenSC;
39 
40   function JBXICO() {}
41 
42   function setToken( address tok ) {
43     tokenSC = JBX(tok);
44   }
45 
46   function() payable {
47     if (now < STARTTIME || now > ENDTIME)
48       revert();
49 
50     // (amountinwei/weipereth * jbx/eth) * ( (100 + bonuspercent)/100 )
51     // = amountinwei*jbxpereth/weipereth*(bonus+100)/100
52     uint qty =
53       div(mul(div(mul(msg.value, JBXPERETH),1000000000000000000),(bonus()+100)),100);
54 
55     if (qty > tokenSC.balanceOf(address(this)) || qty < 1)
56       revert();
57 
58     tokenSC.transfer( msg.sender, qty );
59   }
60 
61   // unsold tokens can be claimed by owner after sale ends
62   function claimUnsold() onlyOwner {
63     if ( now < ENDTIME )
64       revert();
65 
66     tokenSC.transfer( owner, tokenSC.balanceOf(address(this)) );
67   }
68 
69   function withdraw( uint amount ) onlyOwner returns (bool) {
70     if (amount <= this.balance)
71       return owner.send( amount );
72 
73     return false;
74   }
75 
76   function bonus() constant returns(uint) {
77     uint elapsed = now - STARTTIME;
78 
79     if (elapsed < 48 hours) return 50;
80     if (elapsed < 2 weeks) return 20;
81     if (elapsed < 3 weeks) return 10;
82     if (elapsed < 4 weeks) return 5;
83     return 0;
84   }
85 
86   // ref:
87   // github.com/OpenZeppelin/zeppelin-solidity/
88   // blob/master/contracts/math/SafeMath.sol
89   function mul(uint256 a, uint256 b) constant returns (uint256) {
90     uint256 c = a * b;
91     assert(a == 0 || c / a == b);
92     return c;
93   }
94 
95   function div(uint256 a, uint256 b) constant returns (uint256) {
96     uint256 c = a / b;
97     return c;
98   }
99 }