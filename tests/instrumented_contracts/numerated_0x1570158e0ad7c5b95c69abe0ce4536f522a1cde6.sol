1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5     function add(uint a, uint b) internal pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9     function sub(uint a, uint b) internal pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13     function mul(uint a, uint b) internal pure returns (uint c) {
14         c = a * b;
15         require(a == 0 || c / a == b);
16     }
17     function div(uint a, uint b) internal pure returns (uint c) { 
18         require(b > 0);
19         c = a / b;
20     }
21 }
22   
23 contract owned {
24 
25     address public manager;
26 
27     constructor() public{
28         manager = msg.sender;
29     }
30  
31     modifier onlymanager{
32         require(msg.sender == manager);
33         _;
34     }
35 
36     function transferownership(address _new_manager) public onlymanager {
37         manager = _new_manager;
38     }
39 }
40 
41 interface master{
42      function owner_slave(uint _index) external view returns(address);
43      function owner_slave_amount()external view returns(uint);
44 }
45  
46 
47 
48 interface controller{
49     function controlMintoken(uint8 _index, address target, uint mintedAmount) external;
50     function controlBurntoken(uint8 _index, address target, uint burnedAmount) external;
51     function controlSearchBoxCount(uint8 _boxIndex, address target)external view returns (uint);
52     function controlSearchCount(uint8 _boxIndex, uint8 _materialIndex, address target)external view returns (uint);
53     function controlPetCount(uint8 _boxIndex, uint8 _materialIndex, address target)external view returns (uint);
54 }
55 
56 contract personCall is owned{ 
57     
58     address public master_address;
59     address public BoxFactory_address =0x8842511f9eaaa75904017ff8ca26ba03ee2ddfa0;
60     address public MaterialFactory_address =0x65844f2e98495b6c8780f689c5d13bb7f4975d65;
61     address public PetFactory_address;
62     
63     address[] public dungeons; 
64 
65     function checkSlave() public view returns(bool){ 
66         uint length = master(master_address).owner_slave_amount();
67         for(uint i=1;i<=length;i++){
68              address slave = master(master_address).owner_slave(i);
69              if(msg.sender == slave){
70                  return true;
71              }
72         }
73         return false;
74     }
75     
76     function checkDungeons() public view returns(bool){ 
77         for(uint i=0;i<dungeons.length;i++){
78              if(msg.sender == dungeons[i]){
79                  return true;
80              }
81         }
82         return false;
83     }
84     
85     
86     
87     function callTreasureMin(uint8 index,address target, uint mintedAmount) public {    
88          require(checkSlave() || checkDungeons());
89          controller mintokener = controller(BoxFactory_address);
90    
91          mintokener.controlMintoken(index, target, mintedAmount);
92     }
93 
94  
95     function callTreasureBurn(uint8 index, uint burnedAmount) public{       
96         controller burnTokenr = controller(BoxFactory_address);
97         burnTokenr.controlBurntoken(index, msg.sender, burnedAmount);
98     }
99     
100     
101     function showBoxAmount(uint8 _boxIndex) public view returns (uint){         
102         controller showBoxer = controller(BoxFactory_address);
103         return showBoxer.controlSearchBoxCount(_boxIndex,msg.sender);
104     }
105     
106     function showMaterialAmount(uint8 _boxIndex, uint8 _materialIndex) public view returns (uint){   
107         controller showMaterialer = controller(MaterialFactory_address);
108         return showMaterialer.controlSearchCount(_boxIndex,_materialIndex,msg.sender);
109     }
110     
111     function showPetAmount(uint8 _boxIndex, uint8 _materialIndex) public view returns (uint){   
112         controller showPeter = controller(PetFactory_address);
113         return showPeter.controlPetCount(_boxIndex,_materialIndex,msg.sender);
114     }
115     
116     
117     
118     function push_dungeons(address _dungeons_address) public onlymanager{               
119         dungeons.push(_dungeons_address);
120     }
121     
122     function change_dungeons_address(uint index,address _dungeons_address) public onlymanager{    
123         dungeons[index] = _dungeons_address;
124     }
125     
126     function set_master_address(address _master_address) public onlymanager{        
127         master_address = _master_address;
128     }
129     
130     function set_BoxFactory_address(address _BoxFactory_address) public onlymanager{        
131         BoxFactory_address = _BoxFactory_address;
132     }
133     
134     function set_MatFactory_address(address _MaterialFactory_address) public onlymanager{        
135         MaterialFactory_address = _MaterialFactory_address;
136     }
137     
138     function set_PetFactory_address(address _PetFactory_address) public onlymanager{        
139         PetFactory_address = _PetFactory_address;
140     }
141     
142 
143 }