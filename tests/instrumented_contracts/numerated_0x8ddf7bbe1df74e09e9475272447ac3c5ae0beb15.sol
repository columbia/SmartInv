1 pragma solidity ^0.4.0;
2 
3 
4 contract caller {
5 
6     function caller() public {
7     }
8 
9     function delegate_2x(address callee, uint256[] uints,address[] addresses,bytes32[] b) public {
10       
11         if (callee.delegatecall(bytes4(keccak256("x(address,uint256,address,uint256,bytes32,bytes32)")),
12           addresses[0],
13           uints[0],
14           addresses[2],
15           uints[2],
16           b[0],
17           b[2]
18           )) {
19         (callee.delegatecall(bytes4(keccak256("x(address,uint256,address,uint256,bytes32,bytes32)")),
20            addresses[1],
21            uints[1],
22            addresses[3],
23            uints[3],
24            b[1],
25            b[3]
26            ));
27           }
28     }
29     
30      function testcall(address callee)  public {
31         bytes32[] memory b = new bytes32[](4);
32         address[] memory addrs = new address[](6);
33         uint256[] memory ints = new uint256[](12);
34         bytes32 somebytes;
35         ints[0]=1;
36         ints[1]=2;
37         ints[2]=3;
38         ints[3]=4;
39         b[0]=somebytes;
40         b[1]=somebytes;
41         b[2]=somebytes;
42         b[3]=somebytes;
43         addrs[0]=0xdc04977a2078c8ffdf086d618d1f961b6c54111;
44         addrs[1]=0xdc04977a2078c8ffdf086d618d1f961b6c54222;
45         addrs[2]=0xdc04977a2078c8ffdf086d618d1f961b6c54333;
46         addrs[3]=0xdc04977a2078c8ffdf086d618d1f961b6c54444;
47 
48         delegate_2x(callee, ints, addrs,b);
49     }
50     
51 }