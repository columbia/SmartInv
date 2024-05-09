1 pragma solidity ^0.4.19;
2 
3 contract EtherDelta {
4 
5   function deposit() payable {
6 
7   }
8 
9   function withdraw(uint amount) {
10 
11   }
12 
13   function depositToken(address token, uint amount) {
14   
15   }
16 
17   function withdrawToken(address token, uint amount) {
18 
19   }
20 
21   function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) {
22    
23   }
24 }
25 
26 contract ArbStation {
27     address deltaContract = 0x8d12A197cB00D4747a1fe03395095ce2A5CC6819;
28     EtherDelta delta;
29     
30     address owner;
31     
32     modifier onlyOwner {
33         require (msg.sender == owner);
34         _;
35     }
36     
37     function ArbStation() public {
38         delta = EtherDelta(deltaContract);
39         owner = msg.sender;
40     }
41     
42     function withdraw() external onlyOwner {
43         owner.transfer(this.balance);
44     }
45     
46     function depositDelta() payable external onlyOwner {
47         delta.deposit.value(msg.value)();
48     }
49     
50     function withdrawDelta(uint amount) external onlyOwner {
51         delta.withdraw(amount);
52     }
53     
54     function withdrawAtOnce(uint amount) external onlyOwner {
55         delta.withdraw(amount);
56         owner.transfer(this.balance);
57     }
58     
59     function arbTrade(address[] addressList, uint[] uintList, uint8[] uint8List, bytes32[] bytes32List) external {
60         //first trade
61         //tokenGet = addressList[0]
62         //amountGet = uintList[0]
63         //tokenGive = addressList[1]
64         //amountGive = uintList[1]
65         //expires = uintList[2]
66         //nonce = uintList[3]
67         //user = addressList[2]
68         //v = uint8List[0]
69         //r = bytes32List[0]
70         //s = bytes32List[1]
71         //amount = uintList[4]
72         
73         //second trade
74         //tokenGet = addressList[3]
75         //amountGet = uintList[5]
76         //tokenGive = addressList[4]
77         //amountGive = uintList[6]
78         //expires = uintList[7]
79         //nonce = uintList[8]
80         //user = addressList[5]
81         //v = uint8List[1]
82         //r = bytes32List[2]
83         //s = bytes32List[3]
84         //amount = uintList[9]
85         internalTrade(addressList, uintList, uint8List, bytes32List, 0);
86         internalTrade(addressList, uintList, uint8List, bytes32List, 1);
87     }
88     
89     function internalTrade(address[] addressList, uint[] uintList, uint8[] uint8List, bytes32[] bytes32List, uint flag) private {
90         delta.trade(addressList[0 + 3*flag], uintList[0 + 5*flag], addressList[1 + 3*flag], uintList[1 + 5*flag], uintList[2 + 5*flag], uintList[3 + 5*flag], addressList[2 + 3*flag], uint8List[0 + 1*flag], bytes32List[0 + 2*flag], bytes32List[1 + 2*flag], uintList[4 + 5*flag]);
91     }
92 }