1 pragma solidity ^0.4.18;
2 
3 /**
4  * Utility library of inline functions on addresses
5  */
6 library AddressUtils {
7 
8   /**
9    * Returns whether there is code in the target address
10    * @dev This function will return false if invoked during the constructor of a contract,
11    *  as the code is not actually created until after the constructor finishes.
12    * @param addr address address to check
13    * @return whether there is code in the target address
14    */
15   function isContract(address addr) internal view returns (bool) {
16     uint256 size;
17     assembly { size := extcodesize(addr) }
18     return size > 0;
19   }
20 
21 }
22 pragma solidity ^0.4.18;
23 
24 
25 /**
26  * @title Ownable
27  * @dev The Ownable contract has an owner address, and provides basic authorization control
28  * functions, this simplifies the implementation of "user permissions".
29  */
30 contract Ownable {
31   address public owner;
32 
33 
34   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36 
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    * account.
40    */
41   function Ownable() public {
42     owner = msg.sender;
43   }
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53   /**
54    * @dev Allows the current owner to transfer control of the contract to a newOwner.
55    * @param newOwner The address to transfer ownership to.
56    */
57   function transferOwnership(address newOwner) public onlyOwner {
58     require(newOwner != address(0));
59     emit OwnershipTransferred(owner, newOwner);
60     owner = newOwner;
61   }
62 
63 }
64 pragma solidity 0.4.21;
65 
66 
67 contract Restricted is Ownable {
68     bool private isActive = true;    
69     
70     modifier contractIsActive() {
71         require(isActive);
72         _;
73     }
74 
75     function pauseContract() public onlyOwner {
76         isActive = false;
77     }
78 
79     function activateContract() public onlyOwner {
80         isActive = true;
81     }
82 
83     function withdrawContract() public onlyOwner {        
84         msg.sender.transfer(address(this).balance);
85     }
86 }pragma solidity 0.4.21;
87 
88 
89 
90 contract EtherPointers is Restricted {
91     using AddressUtils for address;
92     
93     Pointer[15] private pointers;  
94     
95     uint8 private useIndex = 0;
96 
97     uint256 private expirationTime = 1 hours;
98     uint256 private defaultPointerValue = 0.002 ether;
99 
100     struct Pointer {
101         bytes32 url;
102         byte[64] text;
103         uint256 timeOfPurchase;
104         address owner;
105     }
106 
107     function buyPointer(bytes32 url, byte[64] text) external payable contractIsActive {  
108         uint256 requiredPrice = getRequiredPrice();
109         uint256 pricePaid = msg.value;
110         address sender = msg.sender;
111 
112         require(!sender.isContract());
113         require(isPointerExpired(useIndex));
114         require(requiredPrice <= pricePaid);
115         
116         Pointer memory pointer = Pointer(url, text, now, msg.sender);
117         pointers[useIndex] = pointer;
118         setNewUseIndex();   
119     }
120 
121     function getPointer(uint8 index) external view returns(bytes32, byte[64], uint256) {
122         return (pointers[index].url, pointers[index].text, pointers[index].timeOfPurchase);
123     }
124 
125     function getPointerOwner(uint8 index) external view returns(address) {
126         return (pointers[index].owner);
127     }
128 
129     function getRequiredPrice() public view returns(uint256) {
130         uint8 numOfActivePointers = 0;        
131         for (uint8 index = 0; index < pointers.length; index++) {
132             if (!isPointerExpired(index)) {
133                 numOfActivePointers++;
134             }                       
135         }
136 
137         return defaultPointerValue + defaultPointerValue * numOfActivePointers;
138     }
139 
140     function isPointerExpired(uint8 pointerIndex) public view returns(bool) { 
141         uint256 expireTime = pointers[pointerIndex].timeOfPurchase + expirationTime;
142         uint256 currentTime = now;
143         return (expireTime < currentTime);
144     }  
145 
146     function setNewUseIndex() private {
147         useIndex = getNextIndex(useIndex);
148     }
149 
150     function getNextIndex(uint8 fromIndex) private pure returns(uint8) {
151         uint8 oldestIndex = fromIndex + 1;             
152         return oldestIndex % 15;
153     }    
154 }