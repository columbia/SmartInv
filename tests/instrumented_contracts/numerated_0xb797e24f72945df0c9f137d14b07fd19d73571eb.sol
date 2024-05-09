1 pragma solidity ^0.4.11;
2 
3 contract Ownable {
4 
5   address public owner;
6 
7   function Ownable() public {
8     owner = msg.sender;
9   }
10 
11   function transferOwnership(address newOwner) onlyOwner public {
12     require(newOwner != address(0));
13     owner = newOwner;
14   }
15 
16   modifier onlyOwner() {
17     require(msg.sender == owner);
18     _;
19   }
20 
21 }
22 
23 contract ColorsData is Ownable {
24 
25     struct Color {
26 	    string label;
27 		uint64 creationTime;
28     }
29 
30 	event Transfer(address from, address to, uint256 colorId);
31     event Sold(uint256 colorId, uint256 priceWei, address winner);
32 	
33     Color[] colors;
34 
35     mapping (uint256 => address) public ColorIdToOwner;
36     mapping (uint256 => uint256) public ColorIdToLastPaid;
37     
38 }
39 
40 contract ColorsApis is ColorsData {
41 
42     function getColor(uint256 _id) external view returns (string label, uint256 lastPaid, uint256 price) {
43         Color storage color1 = colors[_id];
44 		label = color1.label;
45         lastPaid = ColorIdToLastPaid[_id];
46 		price = lastPaid + ((lastPaid * 2) / 10);
47     }
48 
49     function registerColor(string label, uint256 startingPrice) external onlyOwner {        
50         Color memory _Color = Color({
51 		    label: label,
52             creationTime: uint64(now)
53         });
54 
55         uint256 newColorId = colors.push(_Color) - 1;
56 		ColorIdToLastPaid[newColorId] = startingPrice;
57         _transfer(0, msg.sender, newColorId);
58     }
59     
60     function transfer(address _to, uint256 _ColorId) external {
61         require(_to != address(0));
62         require(_to != address(this));
63         require(ColorIdToOwner[_ColorId] == msg.sender);
64         _transfer(msg.sender, _to, _ColorId);
65     }
66 
67     function ownerOf(uint256 _ColorId) external view returns (address owner) {
68         owner = ColorIdToOwner[_ColorId];
69         require(owner != address(0));
70     }
71         
72     function bid(uint256 _ColorId) external payable {
73         uint256 lastPaid = ColorIdToLastPaid[_ColorId];
74         require(lastPaid > 0);
75 		
76 		uint256 price = lastPaid + ((lastPaid * 2) / 10);
77         require(msg.value >= price);
78 		
79 		address colorOwner = ColorIdToOwner[_ColorId];
80 		uint256 colorOwnerPayout = lastPaid + (lastPaid / 10);
81         colorOwner.transfer(colorOwnerPayout);
82 		
83 		// Transfer whatever is left to owner
84         owner.transfer(msg.value - colorOwnerPayout);
85 		
86 		ColorIdToLastPaid[_ColorId] = msg.value;
87 		ColorIdToOwner[_ColorId] = msg.sender;
88 
89 		// Trigger sold event
90         Sold(_ColorId, msg.value, msg.sender); 
91     }
92 
93     function _transfer(address _from, address _to, uint256 _ColorId) internal {
94         ColorIdToOwner[_ColorId] = _to;        
95         Transfer(_from, _to, _ColorId);
96     }
97 }
98 
99 contract ColorsMain is ColorsApis {
100 
101     function ColorsMain() public payable {
102         owner = msg.sender;
103     }
104 
105     function() external payable {
106         require(msg.sender == address(0));
107     }
108 }