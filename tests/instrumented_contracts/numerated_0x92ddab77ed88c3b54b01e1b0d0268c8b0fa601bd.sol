1 pragma solidity ^0.4.18;
2  
3 //Never Mind :P
4 /* @dev The Ownable contract has an owner address, and provides basic authorization control
5 * functions, this simplifies the implementation of "user permissions".
6 */
7 contract Ownable {
8   address public owner;
9 
10 
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   function Ownable() {
16     owner = msg.sender;
17   }
18 
19 
20   /**
21    * @dev Throws if called by any account other than the owner.
22    */
23   modifier onlyOwner() {
24     require(msg.sender == owner);
25     _;
26   }
27 
28 
29   /**
30    * @dev Allows the current owner to transfer control of the contract to a newOwner.
31    * @param newOwner The address to transfer ownership to.
32    */
33   function transferOwnership(address newOwner) onlyOwner {
34     if (newOwner != address(0)) {
35       owner = newOwner;
36     }
37   }
38 
39 }
40 library SafeMath {
41 
42   /**
43   * @dev Multiplies two numbers, throws on overflow.
44   */
45   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46     if (a == 0) {
47       return 0;
48     }
49     uint256 c = a * b;
50     assert(c / a == b);
51     return c;
52   }
53 
54   /**
55   * @dev Integer division of two numbers, truncating the quotient.
56   */
57   function div(uint256 a, uint256 b) internal pure returns (uint256) {
58     // assert(b > 0); // Solidity automatically throws when dividing by 0
59     uint256 c = a / b;
60     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61     return c;
62   }
63 
64   /**
65   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
66   */
67   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68     assert(b <= a);
69     return a - b;
70   }
71 
72   /**
73   * @dev Adds two numbers, throws on overflow.
74   */
75   function add(uint256 a, uint256 b) internal pure returns (uint256) {
76     uint256 c = a + b;
77     assert(c >= a);
78     return c;
79   }
80 }
81 
82 contract NVT {
83     function transfer(address _to, uint _value) public returns (bool);
84 }
85 
86 contract NVTDrop is Ownable{
87   mapping(address => bool) getDropped;
88   bool public halted = true;
89   uint256 public amout = 1 * 10 ** 4;
90   address public NVTAddr;
91   NVT NVTFace;
92   function setNVTface(address _nvt) public onlyOwner {
93     NVTFace = NVT(_nvt);
94   }
95   function setAmout(uint _amout) onlyOwner {
96     amout = _amout;
97   }
98 
99   function () public payable{
100     require(getDropped[msg.sender] == false);
101     require(halted == false);
102     getDropped[msg.sender] = true;
103     NVTFace.transfer(msg.sender, amout);
104   }
105 
106 
107 
108   function getStuckCoin (address _to, uint _amout) onlyOwner{
109     _to.transfer(_amout);
110   }
111   function halt() onlyOwner{
112     halted = true;
113   }
114   function unhalt() onlyOwner{
115     halted = false;
116   }
117 }