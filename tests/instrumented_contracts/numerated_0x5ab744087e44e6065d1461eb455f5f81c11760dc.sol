1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4     function add(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function sub(uint a, uint b) internal pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function mul(uint a, uint b) internal pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function div(uint a, uint b) internal pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     } 
20 }
21 
22 library SafeMath8{
23      function add(uint8 a, uint8 b) internal pure returns (uint8) {
24         uint8 c = a + b;
25         require(c >= a);
26         return c;
27     }  
28 
29     function sub(uint8 a, uint8 b) internal pure returns (uint8) {
30         require(b <= a);
31         uint8 c = a - b;
32         return c;
33     }
34 
35      function mul(uint8 a, uint8 b) internal pure returns (uint8) {
36         if (a == 0) {
37             return 0;
38         }
39         uint8 c = a * b;
40         require(c / a == b);
41         return c;
42     }
43 
44     function div(uint8 a, uint8 b) internal pure returns (uint8) {
45         require(b > 0);
46         uint8 c = a / b;
47         return c;
48     }
49  }
50  
51  
52 interface ERC20 {
53   function decimals() external view returns(uint8);
54   function totalSupply() external view returns (uint256);
55   function balanceOf(address who) external view returns (uint256);
56 
57   function transfer(address to, uint256 value) external returns(bool);
58   function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) ;
59 }
60 
61 interface material{
62     function controlSearchCount(uint8 boxIndex, uint8 materialIndex,address target)external view returns (uint);
63     function MaterialTokens(uint8 _boxIndex, uint8 _materialIndex) external view returns (address);
64 }
65 
66 interface master{
67     function addressToName(address awarder) external view returns(bytes32);
68     function bytes32ToString(bytes32 x)external view  returns (string);
69 }
70  
71 contract owned{
72 
73     address public manager;
74 
75     constructor() public{
76         manager = msg.sender;
77     }
78 
79     modifier onlymanager{
80         require(msg.sender == manager);
81         _;
82     } 
83 
84     function transferownership(address _new_manager) public onlymanager {
85         manager = _new_manager;
86     }
87 } 
88 
89 
90 contract activity is owned{
91     
92     address materialFactory_address = 0x65844f2e98495b6c8780f689c5d13bb7f4975d65;
93     address master_address = 0x0ac10bf0342fa2724e93d250751186ba5b659303;
94     
95     mapping(uint8 => mapping(uint8 => uint)) public awardAmount;
96     mapping(uint8 => mapping(uint8 => uint)) public awardPrice;
97     uint8 public action;
98     uint8 public require_value;
99     using SafeMath8 for uint8;
100     using SafeMath for uint;
101     event awardResult(address indexed awarder,string awardName,uint8 boxIndex, uint8 material_index,uint price,uint8 action);
102     
103     constructor() public{
104         awardAmount[0][27] = 1;     awardPrice[0][27] = 1 ether;
105         awardAmount[1][9] = 1;      awardPrice[1][9] = 1 ether;
106         awardAmount[2][19] = 1;     awardPrice[2][19] = 1 ether;   
107         awardAmount[3][6] = 1;      awardPrice[3][6] = 1 ether;
108         awardAmount[4][19] = 1;     awardPrice[4][19] = 1 ether;
109         awardAmount[0][21] = 10;    awardPrice[0][21] = 0.1 ether;
110         awardAmount[1][8] = 10;     awardPrice[1][8] = 0.1 ether;
111         awardAmount[2][12] = 10;    awardPrice[2][12] = 0.1 ether;
112         awardAmount[3][4] = 10;     awardPrice[3][4] = 0.1 ether;
113         awardAmount[4][15] = 10;    awardPrice[4][15] = 0.1 ether;  
114         action = 1;
115         require_value = 5;
116     }
117     
118     function() public payable{}
119 
120     function receiveApproval(address _sender, uint256 _value,
121     address _tokenContract, bytes memory _extraData) public{
122         
123         uint8 boxIndex;
124         uint8 material_index;
125         bytes32 byteName;
126         string memory awardName;
127 
128         boxIndex = uint8(_extraData[1]); 
129         material_index = uint8(_extraData[2]);
130  
131         address material_address = material(materialFactory_address).MaterialTokens(boxIndex,material_index);
132         
133         require(_tokenContract == material_address);
134         require(_value == require_value);
135         require(_value <= materialAmount(boxIndex,material_index,_sender));
136         require(awardAmount[boxIndex][material_index] != 0);
137         require(ERC20(material_address).transferFrom(_sender, address(this), _value),"交易失敗");
138  
139         awardAmount[boxIndex][material_index] = awardAmount[boxIndex][material_index].sub(1);
140         
141         byteName = master(master_address).addressToName(_sender);
142         awardName =  master(master_address).bytes32ToString(byteName);
143          
144         _sender.transfer(awardPrice[boxIndex][material_index]); 
145         emit awardResult(_sender,awardName, boxIndex, material_index,awardPrice[boxIndex][material_index],action);
146         
147     }
148     
149     function materialAmount(uint8 boxIndex, uint8 material_index, address _sender) private  view returns (uint) {    
150         return material(materialFactory_address).controlSearchCount(boxIndex,material_index,_sender);
151     } 
152     
153     function inquireAddress(uint8 boxIndex, uint8 material_index) public view returns (address) {    
154         return material(materialFactory_address).MaterialTokens(boxIndex,material_index);
155     } 
156     
157     function inquireEth() public view returns (uint){
158         return address(this).balance;
159     }
160    
161     function setAciton(uint8 _action) public onlymanager{
162         action = _action;
163     }
164     
165     function set_require_value(uint8 _require_value) public onlymanager{
166         require_value = _require_value;
167     }
168      
169     function resetAward(uint8 boxIndex, uint8 material_index) public onlymanager{
170         awardAmount[boxIndex][material_index] = 0;
171         awardPrice[boxIndex][material_index] = 0;
172     } 
173   
174     function setNewMulAward(uint8[] boxIndex, uint8[] material_index , uint8[] amount, uint[] price) public onlymanager{
175         require(boxIndex.length == material_index.length && material_index.length == amount.length && amount.length == price.length);
176         for(uint8 i = 0;i<boxIndex.length;i++){
177             awardAmount[boxIndex[i]][material_index[i]] = amount[i];
178             awardPrice[boxIndex[i]][material_index[i]] = price[i] * 10 ** 18;
179         } 
180     }
181     
182     function set_master_address(address _master_address) public onlymanager{
183         master_address = _master_address;
184     }
185     
186     function set_materialFactory_address(address _materialFactory_address) public onlymanager{
187         materialFactory_address = _materialFactory_address;
188     }
189 
190     function withdraw_all_ETH() public onlymanager{
191         manager.transfer(address(this).balance);
192     }
193  
194 
195 }