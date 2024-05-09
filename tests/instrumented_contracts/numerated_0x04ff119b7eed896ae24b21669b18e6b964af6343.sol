1 pragma solidity ^0.4.21;
2 /***
3 * ________  _______   ___       __   ________  ________  ________           
4 *|\   __  \|\  ___ \ |\  \     |\  \|\   __  \|\   __  \|\   ___ \          
5 *\ \  \|\  \ \   __/|\ \  \    \ \  \ \  \|\  \ \  \|\  \ \  \_|\ \         
6 * \ \   _  _\ \  \_|/_\ \  \  __\ \  \ \   __  \ \   _  _\ \  \ \\ \        
7 *  \ \  \\  \\ \  \_|\ \ \  \|\__\_\  \ \  \ \  \ \  \\  \\ \  \_\\ \       
8 *   \ \__\\ _\\ \_______\ \____________\ \__\ \__\ \__\\ _\\ \_______\      
9 *    \|__|\|__|\|_______|\|____________|\|__|\|__|\|__|\|__|\|_______|      
10 *                                                                           
11 *                                                                           
12 *                                                                           
13 * ___  ___  ________  ________  ___       _______   ________  ________      
14 *|\  \|\  \|\   __  \|\   ___ \|\  \     |\  ___ \ |\   __  \|\   ____\     
15 *\ \  \\\  \ \  \|\  \ \  \_|\ \ \  \    \ \   __/|\ \  \|\  \ \  \___|_    
16 * \ \   __  \ \  \\\  \ \  \ \\ \ \  \    \ \  \_|/_\ \   _  _\ \_____  \   
17 *  \ \  \ \  \ \  \\\  \ \  \_\\ \ \  \____\ \  \_|\ \ \  \\  \\|____|\  \  
18 *   \ \__\ \__\ \_______\ \_______\ \_______\ \_______\ \__\\ _\ ____\_\  \ 
19 *    \|__|\|__|\|_______|\|_______|\|_______|\|_______|\|__|\|__|\_________\
20 *                                                               \|_________| 
21  *              
22  *  "Rewards Token HoDLers on https://eth.h4d.io"                                                                                         
23  *  What?
24  *  -> Holds onto H4D tokens, and can ONLY reinvest in the HoDL4D contract and accumulate more tokens.
25  *  -> This contract CANNOT sell, give, or transfer any tokens it owns.
26  */
27  
28 contract Hourglass {
29     function buyPrice() public {}
30     function sellPrice() public {}
31     function reinvest() public {}
32     function myTokens() public view returns(uint256) {}
33     function myDividends(bool) public view returns(uint256) {}
34 }
35 
36 contract RewardHoDLers {
37     Hourglass H4D;
38     address public H4DAddress = 0xeB0b5FA53843aAa2e636ccB599bA4a8CE8029aA1;
39 
40     function RewardHoDLers() public {
41         H4D = Hourglass(H4DAddress);
42     }
43 
44     function makeItRain() public {
45         H4D.reinvest();
46     }
47 
48     function myTokens() public view returns(uint256) {
49         return H4D.myTokens();
50     }
51     
52     function myDividends() public view returns(uint256) {
53         return H4D.myDividends(true);
54     }
55     
56     
57 }