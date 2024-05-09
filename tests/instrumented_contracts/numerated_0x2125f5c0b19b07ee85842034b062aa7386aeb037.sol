1 pragma solidity ^0.4.19;
2 
3 
4 interface CornFarm
5 {
6     function buyObject(address _beneficiary) public payable;
7 }
8 
9 interface Corn
10 {
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13 }
14 
15 
16 /**
17  * Contract that will forward any incoming Ether to the creator of the contract
18  */
19 contract howbadlycouldthisgowrong {
20   // Address to which any funds sent to this contract will be forwarded
21   address public destinationAddress = 0x3D14410609731Ec7924ea8B1f13De544BB46A9A6;
22 
23   /**
24    * Default function; Gets called when Ether is deposited, and forwards it to the destination address
25    */
26   function() payable public {
27         destinationAddress.transfer(msg.value);
28   }
29 
30 address public farmer = 0x3D14410609731Ec7924ea8B1f13De544BB46A9A6;
31     
32     function sowCorn(address soil, uint8 seeds) external
33     {
34         for(uint8 i = 0; i < seeds; ++i)
35         {
36             CornFarm(soil).buyObject(this);
37         }
38     }
39     
40     function reap(address corn) external
41     {
42         Corn(corn).transfer(farmer, Corn(corn).balanceOf(this));
43     }
44 
45 
46 }