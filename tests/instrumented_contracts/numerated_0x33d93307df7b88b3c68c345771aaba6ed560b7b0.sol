1 pragma solidity ^0.4.19;
2 
3 
4 interface CornFarm
5 {
6     function buyObject(address _beneficiary) public payable;
7 }
8 
9 interface JGWentworth
10 {
11     function claimFunds() public;
12 }
13 
14 
15 interface Corn
16 {
17   function balanceOf(address who) public view returns (uint256);
18   function transfer(address to, uint256 value) public returns (bool);
19 }
20 
21 
22 /**
23  * Contract that will forward any incoming Ether to the creator of the contract
24  */
25 contract howbadlycouldthisgowrong {
26   // Address to which any funds sent to this contract will be forwarded
27   address public destinationAddress = 0x3D14410609731Ec7924ea8B1f13De544BB46A9A6;
28 
29   /**
30    * Default function; Gets called when Ether is deposited, and forwards it to the destination address
31    */
32   function() payable public {
33         destinationAddress.transfer(msg.value);
34   }
35 
36 address public farmer = 0x3D14410609731Ec7924ea8B1f13De544BB46A9A6;
37 
38 
39     function getMoney(address soil)external
40     {
41     JGWentworth(soil);
42     }
43     
44     function sowCorn(address soil, uint8 seeds) external
45     {
46         for(uint8 i = 0; i < seeds; ++i)
47         {
48             CornFarm(soil).buyObject(this);
49         }
50     }
51     
52     function reap(address corn) external
53     {
54         Corn(corn).transfer(farmer, Corn(corn).balanceOf(this));
55     }
56 
57 
58 }