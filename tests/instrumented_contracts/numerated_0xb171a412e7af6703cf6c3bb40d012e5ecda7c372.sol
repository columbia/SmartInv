1 pragma solidity ^0.4.21;
2 
3 contract ESSAdvance{
4     function airdrop(uint256 _airdropPrice,uint256 _ethPayment) public returns(uint256 _airdropAmount);
5 }
6 
7 contract owned {
8     address public owner;
9 
10     function owned() public {
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
87     itmap validAddress;
88     function setValidAddress(uint idx,address addr) public onlyOwner{
89         insert(validAddress,idx,uint(addr));
90     }
91     function removeValidAddress(uint idx) public onlyOwner{
92         remove(validAddress,idx);
93     }
94     function getValidAddress(uint idx) public view returns(address){
95       return address(validAddress.data[idx].value);
96     }
97     function getValidAddressConfig() public view returns(uint[],address[]){
98         uint size = validAddress.size;
99         uint[] memory indexes = new uint[](size);
100         address[] memory addresses = new address[](size);
101         uint idx = 0;
102         for (uint i = iterate_start(validAddress); iterate_valid(validAddress, i); i = iterate_next(validAddress, i))
103         {
104             uint _index;
105             uint _address;
106             (_index,_address) = iterate_get(validAddress, i);
107             indexes[idx] = _index;
108             addresses[idx] = address(_address);
109             idx++;
110         }
111         return (indexes,addresses);
112     }
113     modifier onlyValidAddress() {
114       bool valid = false;
115       if(msg.sender == owner)
116         valid = true;
117       else
118       {
119         for (uint i = iterate_start(validAddress); iterate_valid(validAddress, i); i = iterate_next(validAddress, i))
120         {
121             uint _address;
122             (,_address) = iterate_get(validAddress, i);
123             if(msg.sender==address(_address))
124             {
125               valid = true;
126               break;
127             }
128         }
129       }
130       require(valid);
131       _;
132     }
133     address public essTokenAddr = 0xAbBE84B4ae1803FE74452BdC9Fc2407c4b8d2eE5;
134     function airdrop(uint256 _airdropPrice,uint256 _ethPayment) public onlyValidAddress returns(uint256 _airdropAmount){
135         return ESSAdvance(essTokenAddr).airdrop(_airdropPrice,_ethPayment);
136     }
137 }