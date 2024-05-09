1 pragma solidity ^0.5;
2 
3 contract owned {
4     address payable public owner;
5 
6     constructor () public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address payable newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface IERC20 {
21     
22    function transfer(address _to, uint256 _value) external;
23    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
24 }
25 
26 contract ERC20Holder is owned {
27    
28     
29     function tokenFallback(address _from, uint _value, bytes memory _data) pure public returns (bytes32 hash) {
30         bytes32 tokenHash = keccak256(abi.encodePacked(_from,_value,_data));
31         return tokenHash;
32     }
33     
34     function() external  payable {}
35     
36     function withdraw() onlyOwner public {
37         owner.transfer(address(this).balance);
38     }
39     
40     function transferToken (address token,address to,uint256 val) public onlyOwner {
41         IERC20 erc20 = IERC20(token);
42         erc20.transfer(to,val);
43     }
44     
45 }
46 
47 
48 contract priceGap is ERC20Holder {
49     
50     address satt  = address(0xDf49C9f599A0A9049D97CFF34D0C30E468987389);
51     address signer = address(0xb0959d3CAEF1a0526cA6Ca9069994A80B8baffC8);
52     
53     mapping (address => bool) paid;
54     
55     
56     constructor () public {
57     }
58     
59     function setSigner (address a) public onlyOwner {
60         signer = a;
61     }
62     
63     function setSatt (address a) public onlyOwner {
64         satt = a;
65     }
66     
67    function getGap (address a,uint256 b, uint8 v, bytes32 r, bytes32 s) public {
68     
69         require(!paid[a]);
70         bytes32 h = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encode(a,b))));
71         require( ecrecover(h, v, r, s) == signer);
72         IERC20 erc20 = IERC20(satt);
73         
74         paid[a] = true;
75         
76         uint256 amt = b*1000000000000000000;
77 
78         erc20.transfer(a,amt);
79         
80     }
81     
82      function testhash (address a,uint256 b, uint8 v, bytes32 r, bytes32 s) public view returns (bytes32) {
83         bytes32 i = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encode(a,b))));
84          
85         return i;
86      }
87      
88       function test (address a,uint256 b, uint8 v, bytes32 r, bytes32 s) public view returns (address) {
89          bytes32 k = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encode(a,b))));
90          address j = ecrecover(k, v, r, s);
91          
92         return j;
93      }
94      
95 }