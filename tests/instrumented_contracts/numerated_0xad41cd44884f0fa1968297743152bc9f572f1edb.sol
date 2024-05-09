1 pragma solidity ^0.4.11;
2 
3 contract Initable {
4     function init(address token);
5 }
6 
7 /**
8  * @title ERC20Basic
9  * @dev Simpler version of ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/179
11  */
12 contract ERC20Basic {
13   uint256 public totalSupply;
14   function balanceOf(address who) constant returns (uint256);
15   function transfer(address to, uint256 value) returns (bool);
16   event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 
20 // Time-locked wallet for Genesis Vision team tokens
21 contract GVTTeamAllocator is Initable {
22     // Address of team member to allocations mapping
23     mapping (address => uint256) allocations;
24 
25     ERC20Basic gvt;
26     uint unlockedAt;
27     uint tokensForAllocation;
28     address owner;
29 
30     function GVTTeamAllocator() {
31         unlockedAt = now + 12 * 30 days;
32         owner = msg.sender;
33         
34         allocations[0x3787C4A087fd3226959841828203D845DF21610c] = 38;
35         allocations[0xb205b75E932eC8B5582197052dB81830af372480] = 25;
36         allocations[0x8db451a2e2A2F7bE92f186Dc718CF98F49AaB719] = 15;
37         allocations[0x3451310558D3487bfBc41C674719a6B09B7C3282] = 7;
38         allocations[0x36f3dAB9a9408Be0De81681eB5b50BAE53843Fe7] = 5; 
39         allocations[0x3dDc2592B66821eF93FF767cb7fF89c9E9C060C6] = 3; 
40         allocations[0xfD3eBadDD54cD61e37812438f60Fb9494CBBe0d4] = 2;
41         allocations[0xfE8B87Ae4fe6A565791B0cBD5418092eb2bE9647] = 2;
42         allocations[0x04FF8Fac2c0dD1EB5d28B0D7C111514055450dDC] = 1;           
43         allocations[0x1cd5B39373F52eEFffb5325cE4d51BCe3d1353f0] = 1;       
44         allocations[0xFA9930cbCd53c9779a079bdbE915b11905DfbEDE] = 1;        
45               
46     }
47 
48     function init(address token) {
49         require(msg.sender == owner);
50         gvt = ERC20Basic(token);
51     }
52 
53     // Unlock team member's tokens by transferring them to his address
54     function unlock() external {
55         require (now >= unlockedAt);
56 
57         // Update total number of locked tokens with the first unlock attempt
58         if (tokensForAllocation == 0)
59             tokensForAllocation = gvt.balanceOf(this);
60 
61         var allocation = allocations[msg.sender];
62         allocations[msg.sender] = 0;
63         var amount = tokensForAllocation * allocation / 100;
64 
65         if (!gvt.transfer(msg.sender, amount)) {
66             revert();
67         }
68     }
69 }