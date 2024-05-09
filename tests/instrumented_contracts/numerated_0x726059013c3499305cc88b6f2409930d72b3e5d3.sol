1 //
2 // compiler: solcjs -o ./build/contracts --optimize --abi --bin <this file>
3 //  version: 0.4.19+commit.bbb8e64f.Emscripten.clang
4 //
5 pragma solidity ^0.4.19;
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
27 interface HashBux {
28   function transfer(address to, uint256 value);
29   function balanceOf( address owner ) constant returns (uint);
30 }
31 
32 contract HashBuxICO is owned {
33 
34   uint public constant STARTTIME = 1522072800;   // 26 MAR 2018 14:00:00 GMT
35   uint public constant ENDTIME = 1522764000;     // 03 APR 2018 14:00:00 GMT
36   uint public constant HASHPERETH = 1000;       // price: approx $0.65 ea
37 
38   HashBux public tokenSC = HashBux(0x06F8d7043F77E20DF94bc2fab39BF90d702CBd15);
39 
40   function HashBuxICO() {}
41 
42   function setToken( address tok ) onlyOwner {
43     if ( tokenSC == address(0) )
44       tokenSC = HashBux(tok);
45   }
46 
47   function() payable {
48     if (now < STARTTIME || now > ENDTIME)
49       revert();
50 
51     // (amountinwei/weipereth * hash/eth) * ( (100 + bonuspercent)/100 )
52     // = amountinwei*hashpereth/weipereth*(bonus+100)/100
53     uint qty =
54       div(mul(div(mul(msg.value, HASHPERETH),1000000000000000000),(bonus()+100)),100);
55 
56     if (qty > tokenSC.balanceOf(address(this)) || qty < 1)
57       revert();
58 
59     tokenSC.transfer( msg.sender, qty );
60   }
61 
62   // unsold tokens can be claimed by owner after sale ends
63   function claimUnsold() onlyOwner {
64     if ( now < ENDTIME )
65       revert();
66 
67     tokenSC.transfer( owner, tokenSC.balanceOf(address(this)) );
68   }
69 
70   function withdraw( uint amount ) onlyOwner returns (bool) {
71     if (amount <= this.balance)
72       return owner.send( amount );
73 
74     return false;
75   }
76 
77   function bonus() constant returns(uint) {
78     uint elapsed = now - STARTTIME;
79 
80     if (elapsed < 24 hours) return 50;
81     if (elapsed < 48 hours) return 30;
82     if (elapsed < 72 hours) return 20;
83     if (elapsed < 96 hours) return 10;
84     return 0;
85   }
86 
87   // ref:
88   // github.com/OpenZeppelin/zeppelin-solidity/
89   // blob/master/contracts/math/SafeMath.sol
90   function mul(uint256 a, uint256 b) constant returns (uint256) {
91     uint256 c = a * b;
92     assert(a == 0 || c / a == b);
93     return c;
94   }
95 
96   function div(uint256 a, uint256 b) constant returns (uint256) {
97     uint256 c = a / b;
98     return c;
99   }
100 }