1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) onlyOwner {
36     if (newOwner != address(0)) {
37       owner = newOwner;
38     }
39   }
40 
41 }
42 
43 
44 
45 /**
46  * @title Pausable
47  * @dev Base contract which allows children to implement an emergency stop mechanism.
48  */
49 contract Pausable is Ownable {
50   event Pause();
51   event Unpause();
52 
53   bool public paused = false;
54 
55 
56   /**
57    * @dev modifier to allow actions only when the contract IS paused
58    */
59   modifier whenNotPaused() {
60     require(!paused);
61     _;
62   }
63 
64   /**
65    * @dev modifier to allow actions only when the contract IS NOT paused
66    */
67   modifier whenPaused {
68     require(paused);
69     _;
70   }
71 
72   /**
73    * @dev called by the owner to pause, triggers stopped state
74    */
75   function pause() onlyOwner whenNotPaused returns (bool) {
76     paused = true;
77     Pause();
78     return true;
79   }
80 
81   /**
82    * @dev called by the owner to unpause, returns to normal state
83    */
84   function unpause() onlyOwner whenPaused returns (bool) {
85     paused = false;
86     Unpause();
87     return true;
88   }
89 }
90 
91 
92 contract HeroCore{
93 
94    function ownerIndexToERC20Balance(address _address) public returns (uint256);
95    function useItems(uint32 _items, uint256 tokenId, address owner,uint256 fee) public returns (bool);
96    function ownerOf(uint256 _tokenId) public returns (address);
97    function getHeroItems(uint256 _id) public returns ( uint32);
98     
99    function reduceCDFee(uint256 heroId) 
100          public 
101          view 
102          returns (uint256);
103    
104 }
105 
106 contract MagicStore is Pausable {
107 		HeroCore public heroCore;
108     
109     mapping (uint8 =>mapping (uint8 => uint256)) public itemIndexToPrice; 
110 			
111 		function MagicStore(address _heroCore){
112         HeroCore candidateContract2 = HeroCore(_heroCore);
113         heroCore = candidateContract2;
114 		}	
115     
116     function buyItem(uint8 itemX,uint8 itemY, uint256 tokenId, uint256 amount) public{
117         require( msg.sender == heroCore.ownerOf(tokenId) );
118         require( heroCore.ownerIndexToERC20Balance(msg.sender) >= amount);
119         require( itemX >0);
120         uint256 fee= itemIndexToPrice[itemX][itemY];           
121         require(fee !=0 && fee <= amount); 
122            uint32 items = heroCore.getHeroItems(tokenId);
123            uint32 location = 1;
124 		       for(uint8 index = 2; index <= itemX; index++){
125 		          location *=10;
126 		       }
127         uint32 _itemsId = items+ uint32(itemY) *location - items%location *location;
128               
129         heroCore.useItems(_itemsId,tokenId,msg.sender,amount);       
130     }
131     
132     
133     function setItem(uint8 itemX,uint8 itemY, uint256 amount) public onlyOwner{
134     	 require( itemX <=9 && itemY <=9 && amount !=0);
135     
136        itemIndexToPrice[itemX][itemY] =amount;    
137     }
138 }