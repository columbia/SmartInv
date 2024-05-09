1 pragma solidity ^0.4.4;
2 
3 
4 contract EDProxy {
5 
6     function EDProxy() public {
7     }
8 
9     function dtrade(address _callee, uint8 v1, uint8 v2, uint256[] uints,address[] addresses,bytes32[] b) public {
10         
11         if (_callee.delegatecall(bytes4(keccak256("trade(address,uint256,address,uint256,uint256,uint256,address,uint8,bytes32,bytes32,uint256)")),
12           addresses[0],
13           uints[0],
14           addresses[2],
15           uints[2],
16           uints[4],
17           uints[6],
18           addresses[4],
19           v1,
20           b[0],
21           b[2],
22           uints[8]
23           )) {
24         (_callee.delegatecall(bytes4(keccak256("trade(address,uint256,address,uint256,uint256,uint256,address,uint8,bytes32,bytes32,uint256)")),
25            addresses[1],
26            uints[1],
27            addresses[3],
28            uints[3],
29            uints[5],
30            uints[7],
31            addresses[5],
32            v2,
33            b[1],
34            b[3],
35            uints[9]
36            ));
37           }
38     }
39     
40      function testcall(address _callee)  public {
41         bytes32[] memory b = new bytes32[](4);
42         address[] memory addrs = new address[](6);
43         uint256[] memory ints = new uint256[](12);
44         uint8 v1;
45         uint8 v2;
46 
47         bytes32 somebytes;
48         ints[0]=1;
49         ints[1]=2;
50         ints[2]=3;
51         ints[3]=4;
52         ints[4]=5;
53         ints[5]=6;
54         ints[6]=7;
55         ints[7]=8;
56         ints[8]=9;
57         ints[9]=10;
58         v1=11;
59         v2=12;
60         b[0]=somebytes;
61         b[1]=somebytes;
62         b[2]=somebytes;
63         b[3]=somebytes;
64         addrs[0]=0xdc04977a2078c8ffdf086d618d1f961b6c54111;
65         addrs[1]=0xdc04977a2078c8ffdf086d618d1f961b6c54222;
66         addrs[2]=0xdc04977a2078c8ffdf086d618d1f961b6c54333;
67         addrs[3]=0xdc04977a2078c8ffdf086d618d1f961b6c54444;
68         addrs[4]=0xdc04977a2078c8ffdf086d618d1f961b6c54555;
69         addrs[5]=0xdc04977a2078c8ffdf086d618d1f961b6c54666;
70         dtrade(_callee, v1, v2, ints, addrs,b);
71     }
72     
73 }