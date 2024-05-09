1 pragma solidity ^0.4.25;
2 pragma experimental "v0.5.0";
3 pragma experimental ABIEncoderV2;
4 
5 contract ERC20 {
6   function transferFrom (address from, address to, uint256 value) public returns (bool);
7 }
8 
9 contract SpecialCampaign {
10 
11   address public owner;
12   address public rcv;
13 
14   uint256 constant public fstPerWei = 3000;
15 
16   uint256 constant private min = 0;
17   uint256 constant private max = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
18 
19   ERC20   public FST;
20   address public fstCentral;
21 
22   bytes32 public sh;
23   bool    public finalized = false;
24 
25   event RCVDeclare (address rcv);
26   event Finalize   (uint256 fstkReceivedEtherWei, uint256 rcvReceivedFSTWei);
27 
28   struct Bonus {
29     uint256 gte;
30     uint256 lt;
31     uint256 bonusPercentage;
32   }
33 
34   Bonus[] public bonusArray;
35 
36   constructor (ERC20 _FST, address _fstCentral, bytes32 _secretHash) public {
37     owner = msg.sender;
38     rcv = address(0);
39 
40     bonusArray.push(Bonus(       min,  300 ether,   0));
41     bonusArray.push(Bonus( 300 ether,  900 ether, 120));
42     bonusArray.push(Bonus( 900 ether, 1500 ether, 128));
43     bonusArray.push(Bonus(1500 ether,        max, 132));
44 
45     FST = _FST;
46     fstCentral = _fstCentral;
47 
48     sh = _secretHash;
49   }
50 
51   // Epoch timestamp: 1538323201
52   // Timestamp in milliseconds: 1538323201000
53   // Human time (GMT): Sunday, September 30, 2018 4:00:01 PM
54   // Human time (your time zone): Monday, October 1, 2018 12:00:01 AM GMT+08:00
55 
56   function () external payable {
57     require(now <= 1538323201);
58   }
59 
60   function declareRCV(string _secret) public {
61     require(
62       sh  == keccak256(abi.encodePacked(_secret)) &&
63       rcv == address(0)
64     );
65 
66     rcv = msg.sender;
67 
68     emit RCVDeclare(rcv);
69   }
70 
71   function finalize () public {
72     require(
73       msg.sender == owner &&
74       rcv        != address(0) &&
75       now        >  1538323201 &&
76       finalized  == false
77     );
78 
79     finalized = true;
80 
81     uint256 fstkReceivedEtherWei = address(this).balance;
82     uint256 rcvReceivedFSTWei = 0;
83 
84     // rollback
85     if (fstkReceivedEtherWei < 300 ether) {
86       rcv.transfer(fstkReceivedEtherWei);
87       emit Finalize(0, 0);
88       return;
89     }
90 
91     for (uint8 i = 0; i < bonusArray.length; i++) {
92       Bonus storage b = bonusArray[i];
93 
94       if (fstkReceivedEtherWei >= b.gte && fstkReceivedEtherWei < b.lt) {
95         rcvReceivedFSTWei = fstkReceivedEtherWei * b.bonusPercentage * fstPerWei / 100;
96       }
97     }
98 
99     require(FST.transferFrom(fstCentral, rcv, rcvReceivedFSTWei));
100     fstCentral.transfer(fstkReceivedEtherWei);
101 
102     emit Finalize(fstkReceivedEtherWei, rcvReceivedFSTWei);
103   }
104 
105 }