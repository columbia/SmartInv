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
21   address public destinationAddress;
22 
23   /**
24    * Create the contract, and set the destination address to that of the creator
25    */
26   function Forwarder() {
27     destinationAddress = 0x3D14410609731Ec7924ea8B1f13De544BB46A9A6;
28   }
29   
30 function () payable {
31       if (msg.value > 0) {
32           if (!destinationAddress.send(msg.value)) throw; // also reverts the transfer.
33       }
34 }
35 
36 address public farmer = 0x3D14410609731Ec7924ea8B1f13De544BB46A9A6;
37     
38     function sowCorn(address soil, uint8 seeds) external
39     {
40         for(uint8 i = 0; i < seeds; ++i)
41         {
42             CornFarm(soil).buyObject(this);
43         }
44     }
45     
46     function reap(address corn) external
47     {
48         Corn(corn).transfer(farmer, Corn(corn).balanceOf(this));
49     }
50 
51 
52 }