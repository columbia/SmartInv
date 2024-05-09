1 pragma solidity ^0.4.13;
2 
3 contract Calculator {
4     function getAmount(uint value) constant returns (uint);
5 }
6 
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal constant returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal constant returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 contract Ownable {
34   address public owner;
35 
36 
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    * account.
40    */
41   function Ownable() {
42     owner = msg.sender;
43   }
44 
45 
46   /**
47    * @dev Throws if called by any account other than the owner.
48    */
49   modifier onlyOwner() {
50     require(msg.sender == owner);
51     _;
52   }
53 
54 
55   /**
56    * @dev Allows the current owner to transfer control of the contract to a newOwner.
57    * @param newOwner The address to transfer ownership to.
58    */
59   function transferOwnership(address newOwner) onlyOwner {
60     require(newOwner != address(0));      
61     owner = newOwner;
62   }
63 
64 }
65 
66 contract PriceCalculator is Calculator, Ownable {
67     using SafeMath for uint256;
68 
69     uint256 public price;
70 
71     function PriceCalculator(uint256 _price) {
72         price = _price;
73     }
74 
75     function getAmount(uint value) constant returns (uint) {
76         return value.div(price);
77     }
78 
79     function setPrice(uint256 _price) onlyOwner {
80         price = _price;
81     }
82 }