1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address private _owner;
10 
11   event OwnershipTransferred(
12     address indexed previousOwner,
13     address indexed newOwner
14   );
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() internal {
21     _owner = msg.sender;
22     emit OwnershipTransferred(address(0), _owner);
23   }
24 
25   /**
26    * @return the address of the owner.
27    */
28   function owner() public view returns(address) {
29     return _owner;
30   }
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(isOwner());
37     _;
38   }
39 
40   /**
41    * @return true if `msg.sender` is the owner of the contract.
42    */
43   function isOwner() public view returns(bool) {
44     return msg.sender == _owner;
45   }
46 
47   /**
48    * @dev Allows the current owner to relinquish control of the contract.
49    * @notice Renouncing to ownership will leave the contract without an owner.
50    * It will not be possible to call the functions with the `onlyOwner`
51    * modifier anymore.
52    */
53   function renounceOwnership() public onlyOwner {
54     emit OwnershipTransferred(_owner, address(0));
55     _owner = address(0);
56   }
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address newOwner) public onlyOwner {
63     _transferOwnership(newOwner);
64   }
65 
66   /**
67    * @dev Transfers control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function _transferOwnership(address newOwner) internal {
71     require(newOwner != address(0));
72     emit OwnershipTransferred(_owner, newOwner);
73     _owner = newOwner;
74   }
75 }
76 
77 //import "../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";
78 
79 contract PixelStorage is Ownable{
80 
81     uint32[] coordinates;
82     uint32[] rgba;
83     address[] owners;
84     uint256[] prices;
85 
86     // simple counter used for indexing
87     uint32 public pixelCount;
88 
89     // maps (x | y) to index in the flat arrays
90     // Example for first pixel at (5,3)
91     // (5|3) =>  (5 << 16 | 3) => (327680 | 3) => 327683  
92     // stores 1 as index the first index
93     // since 0 is default mapping value
94     // coordinatesToIndex[327683] -> 1;
95 
96     mapping(uint32 => uint32) coordinatesToIndex;
97 
98     constructor () public
99     {
100         pixelCount = 0;
101     }
102     
103     function getBalance() public view returns (uint256) {
104         return address(this).balance;
105     }
106     
107     function withdraw() onlyOwner public {
108         msg.sender.transfer(address(this).balance);
109     }
110     
111     function buyPixel(uint16 _x, uint16 _y, uint32 _rgba) public payable {
112 
113         require(0 <= _x && _x < 0x200, "X should be in range 0-511");
114         require(0 <= _y && _y < 0x200, "Y should be in range 0-511");
115 
116         uint32 coordinate = uint32(_x) << 16 | _y;
117         uint32 index = coordinatesToIndex[coordinate];
118         if(index == 0)
119         {
120             // pixel not owned yet
121             // check funds
122             require(msg.value >= 1 finney, "Send atleast one finney!");
123             
124             // bump the pixelCount before usage so it starts with 1 and not the default array value 0
125             pixelCount += 1;
126             // store the index in mapping
127             coordinatesToIndex[coordinate] = pixelCount;
128             
129             // push values to flat-arrays
130             coordinates.push(coordinate);
131             rgba.push(_rgba);
132             prices.push(msg.value);
133             owners.push(msg.sender);
134         }
135         else
136         {
137             // pixel is already owned
138             require(msg.value >= prices[index-1] + 1 finney , "Insufficient funds send(atleast price + 1 finney)!");
139             prices[index-1] = msg.value;
140             owners[index-1] = msg.sender;
141             rgba[index-1] = _rgba;
142         }
143         
144     }
145     
146     
147     function getPixels() public view returns (uint32[],  uint32[], address[],uint256[]) {
148         return (coordinates,rgba,owners,prices);
149     }
150     
151     function getPixel(uint16 _x, uint16 _y) public view returns (uint32, address, uint256){
152         uint32 coordinate = uint32(_x) << 16 | _y;
153         uint32 index = coordinatesToIndex[coordinate];
154         if(index == 0){
155             return (0, address(0x0), 0);
156         }else{
157             return (
158                 rgba[index-1], 
159                 owners[index-1],
160                 prices[index-1]
161             );
162         }
163     }
164 }