1 pragma solidity ^0.4.25;
2 
3 contract EtherSesame{
4     function airdrop(uint256 _airdropPrice,uint256 _ethPayment) public returns(uint256 _airdropAmount);
5 }
6 
7 contract owned {
8     address public owner;
9 
10     constructor() public {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     function upgradeOwner(address newOwner) onlyOwner public {
20         owner = newOwner;
21     }
22 }
23 
24 contract IterableMapping
25 {
26   struct itmap
27   {
28     mapping(uint => IndexValue) data;
29     KeyFlag[] keys;
30     uint size;
31   }
32   struct IndexValue { uint keyIndex; uint value; }
33   struct KeyFlag { uint key; bool deleted; }
34   function insert(itmap storage self, uint key, uint value) internal returns (bool replaced)
35   {
36     uint keyIndex = self.data[key].keyIndex;
37     self.data[key].value = value;
38     if (keyIndex > 0)
39       return true;
40     else
41     {
42       keyIndex = self.keys.length++;
43       self.data[key].keyIndex = keyIndex + 1;
44       self.keys[keyIndex].key = key;
45       self.size++;
46       return false;
47     }
48   }
49   function remove(itmap storage self, uint key) internal returns (bool success)
50   {
51     uint keyIndex = self.data[key].keyIndex;
52     if (keyIndex == 0)
53       return false;
54     delete self.data[key];
55     self.keys[keyIndex - 1].deleted = true;
56     self.size --;
57   }
58   function contains(itmap storage self, uint key) internal view returns (bool)
59   {
60     return self.data[key].keyIndex > 0;
61   }
62   function iterate_start(itmap storage self) internal view returns (uint keyIndex)
63   {
64     return iterate_next(self, uint(-1));
65   }
66   function iterate_valid(itmap storage self, uint keyIndex) internal view returns (bool)
67   {
68     return keyIndex < self.keys.length;
69   }
70   function iterate_next(itmap storage self, uint keyIndex) internal view returns (uint r_keyIndex)
71   {
72     keyIndex++;
73     while (keyIndex < self.keys.length && self.keys[keyIndex].deleted)
74       keyIndex++;
75     return keyIndex;
76   }
77   function iterate_get(itmap storage self, uint keyIndex) internal view returns (uint key, uint value)
78   {
79     key = self.keys[keyIndex].key;
80     value = self.data[key].value;
81   }
82 }
83 
84 
85 contract Airdrop is IterableMapping,owned{
86 
87     //访问权限
88     itmap validAddress;
89     function setValidAddress(uint idx,address addr) public onlyOwner{
90         insert(validAddress,idx,uint(addr));
91     }
92     function removeValidAddress(uint idx) public onlyOwner{
93         remove(validAddress,idx);
94     }
95     function getValidAddress(uint idx) public view returns(address){
96       return address(validAddress.data[idx].value);
97     }
98     function getValidAddressConfig() public view returns(uint[],address[]){
99         uint size = validAddress.size;
100         uint[] memory indexes = new uint[](size);
101         address[] memory addresses = new address[](size);
102         uint idx = 0;
103         for (uint i = iterate_start(validAddress); iterate_valid(validAddress, i); i = iterate_next(validAddress, i))
104         {
105             uint _index;
106             uint _address;
107             (_index,_address) = iterate_get(validAddress, i);
108             indexes[idx] = _index;
109             addresses[idx] = address(_address);
110             idx++;
111         }
112         return (indexes,addresses);
113     }
114     modifier onlyValidAddress() {
115       bool valid = false;
116       if(msg.sender == owner)
117         valid = true;
118       else
119       {
120         for (uint i = iterate_start(validAddress); iterate_valid(validAddress, i); i = iterate_next(validAddress, i))
121         {
122             uint _address;
123             (,_address) = iterate_get(validAddress, i);
124             if(msg.sender==address(_address))
125             {
126               valid = true;
127               break;
128             }
129         }
130       }
131       require(valid);
132       _;
133     }
134     address public essTokenAddr = 0xe6ba7B7a7b6cb9F6116c8767C6323a32C8C86D50;
135     function airdrop(uint256 _airdropPrice,uint256 _ethPayment) public onlyValidAddress returns(uint256 _airdropAmount){
136         return EtherSesame(essTokenAddr).airdrop(_airdropPrice,_ethPayment);
137     }
138 }