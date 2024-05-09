1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   /**
8    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
9    * account.
10    */
11   function Ownable() {
12     owner = msg.sender;
13   }
14 
15 
16   /**
17    * @dev Throws if called by any account other than the owner.
18    */
19   modifier onlyOwner() {
20     require(msg.sender == owner);
21     _;
22   }
23 
24 
25   /**
26    * @dev Allows the current owner to transfer control of the contract to a newOwner.
27    * @param newOwner The address to transfer ownership to.
28    */
29   function transferOwnership(address newOwner) onlyOwner {
30     require(newOwner != address(0));      
31     owner = newOwner;
32   }
33 
34 }
35 
36 contract BonusCalculator {
37     function getBonus() constant returns (uint);
38 }
39 
40 contract GoldeaBonusCalculator is BonusCalculator, Ownable {
41     uint public start;
42     uint public end;
43     uint constant period = 86400 * 7;
44     mapping (uint => uint8) bonuses;
45 
46     function GoldeaBonusCalculator(uint256 _start, uint256 _end) {
47         start = _start;
48         end = _end;
49         bonuses[0] = 30;
50         bonuses[1] = 20;
51         bonuses[3] = 10;
52     }
53 
54     function getBonus() constant returns (uint) {
55         assert(now > start);
56         assert(now < end);
57 
58         uint week = (now - start) / period;
59         uint8 foundBonus = bonuses[week];
60         if (foundBonus != 0) {
61             return foundBonus;
62         } else {
63             return 5;
64         }
65     }
66 
67     function setStart(uint256 _start) onlyOwner() {
68         start = _start;
69     }
70 
71     function setEnd(uint256 _end) onlyOwner() {
72         end = _end;
73     }
74 }