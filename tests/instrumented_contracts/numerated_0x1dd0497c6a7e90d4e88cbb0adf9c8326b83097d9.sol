1 pragma solidity ^0.4.16;
2 
3 contract WEAToken {
4     using SetLibrary for SetLibrary.Set;
5 
6     string public name;
7     string public symbol;
8     uint8 public decimals = 0;
9 
10     uint256 public totalSupply;
11 
12 
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15     
16     SetLibrary.Set private allOwners;
17     function amountOfOwners() public view returns (uint256)
18     {
19         return allOwners.size();
20     }
21     function ownerAtIndex(uint256 _index) public view returns (address)
22     {
23         return address(allOwners.values[_index]);
24     }
25     function getAllOwners() public view returns (uint256[])
26     {
27         return allOwners.values;
28     }
29 
30     event Transfer(address indexed from, address indexed to, uint256 value);
31 
32     event Burn(address indexed from, uint256 value);
33 
34     function WEAToken() public {
35         totalSupply = 18000 * 10 ** uint256(decimals);
36         balanceOf[msg.sender] = totalSupply;
37         Transfer(0x0, msg.sender, totalSupply);
38         allOwners.add(msg.sender);
39         name = "Weaste Coin";
40         symbol = "WEA";
41     }
42 
43     function _transfer(address _from, address _to, uint _value) internal {
44         require(_to != 0x0);
45         require(balanceOf[_from] >= _value);
46         require(balanceOf[_to] + _value > balanceOf[_to]);
47         uint previousBalances = balanceOf[_from] + balanceOf[_to];
48         balanceOf[_from] -= _value;
49         balanceOf[_to] += _value;
50         Transfer(_from, _to, _value);
51         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
52         
53         // Update the owner tracking
54         if (balanceOf[_from] == 0)
55         {
56             allOwners.remove(_from);
57         }
58         if (_value > 0)
59         {
60             allOwners.add(_to);
61         }
62     }
63 
64     function transfer(address _to, uint256 _value) public {
65         _transfer(msg.sender, _to, _value);
66     }
67      
68     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
69         require(_value <= allowance[_from][msg.sender]);     
70         allowance[_from][msg.sender] -= _value;
71         _transfer(_from, _to, _value);
72         return true;
73     }
74      
75     function approve(address _spender, uint256 _value) public returns (bool success) {
76         allowance[msg.sender][_spender] = _value;
77         return true;
78     }
79      
80     function burn(uint256 _value) public returns (bool success) {
81         require(balanceOf[msg.sender] >= _value);   
82         balanceOf[msg.sender] -= _value;            
83         totalSupply -= _value;                      
84         Burn(msg.sender, _value);
85         return true;
86     }
87      
88     function burnFrom(address _from, uint256 _value) public returns (bool success) {
89         require(balanceOf[_from] >= _value);                
90         require(_value <= allowance[_from][msg.sender]);    
91         balanceOf[_from] -= _value;                         
92         allowance[_from][msg.sender] -= _value;             
93         totalSupply -= _value;                              
94         Burn(_from, _value);
95         return true;
96     }
97 }
98 
99 /*
100  * Written by Jesse Busman (info@jesbus.com) on 2017-11-30.
101  * This software is provided as-is without warranty of any kind, express or implied.
102  * This software is provided without any limitation to use, copy modify or distribute.
103  * The user takes sole and complete responsibility for the consequences of this software's use.
104  * Github repository: https://github.com/JesseBusman/SoliditySet
105  * Please note that this container does not preserve the order of its contents!
106  */
107 
108 pragma solidity ^0.4.18;
109 
110 library SetLibrary
111 {
112     struct ArrayIndexAndExistsFlag
113     {
114         uint256 index;
115         bool exists;
116     }
117     struct Set
118     {
119         mapping(uint256 => ArrayIndexAndExistsFlag) valuesMapping;
120         uint256[] values;
121     }
122     function add(Set storage self, uint256 value) public returns (bool added)
123     {
124         // If the value is already in the set, we don't need to do anything
125         if (self.valuesMapping[value].exists == true) return false;
126         
127         // Remember that the value is in the set, and remember the value's array index
128         self.valuesMapping[value] = ArrayIndexAndExistsFlag({index: self.values.length, exists: true});
129         
130         // Add the value to the array of unique values
131         self.values.push(value);
132         
133         return true;
134     }
135     function contains(Set storage self, uint256 value) public view returns (bool contained)
136     {
137         return self.valuesMapping[value].exists;
138     }
139     function remove(Set storage self, uint256 value) public returns (bool removed)
140     {
141         // If the value is not in the set, we don't need to do anything
142         if (self.valuesMapping[value].exists == false) return false;
143         
144         // Remember that the value is not in the set
145         self.valuesMapping[value].exists = false;
146         
147         // Now we need to remove the value from the array. To prevent leaking
148         // storage space, we move the last value in the array into the spot that
149         // contains the element we're removing.
150         if (self.valuesMapping[value].index < self.values.length-1)
151         {
152             uint256 valueToMove = self.values[self.values.length-1];
153             uint256 indexToMoveItTo = self.valuesMapping[value].index;
154             self.values[indexToMoveItTo] = valueToMove;
155             self.valuesMapping[valueToMove].index = indexToMoveItTo;
156         }
157         
158         // Now we remove the last element from the array, because we just duplicated it.
159         // We don't free the storage allocation of the removed last element,
160         // because it will most likely be used again by a call to add().
161         // De-allocating and re-allocating storage space costs more gas than
162         // just keeping it allocated and unused.
163         
164         // Uncomment this line to save gas if your use case does not call add() after remove():
165         // delete self.values[self.values.length-1];
166         self.values.length--;
167         
168         // We do free the storage allocation in the mapping, because it is
169         // less likely that the exact same value will added again.
170         delete self.valuesMapping[value];
171         
172         return true;
173     }
174     function size(Set storage self) public view returns (uint256 amountOfValues)
175     {
176         return self.values.length;
177     }
178     
179     // Also accept address and bytes32 types, so the user doesn't have to cast.
180     function add(Set storage self, address value) public returns (bool added) { return add(self, uint256(value)); }
181     function add(Set storage self, bytes32 value) public returns (bool added) { return add(self, uint256(value)); }
182     function contains(Set storage self, address value) public view returns (bool contained) { return contains(self, uint256(value)); }
183     function contains(Set storage self, bytes32 value) public view returns (bool contained) { return contains(self, uint256(value)); }
184     function remove(Set storage self, address value) public returns (bool removed) { return remove(self, uint256(value)); }
185     function remove(Set storage self, bytes32 value) public returns (bool removed) { return remove(self, uint256(value)); }
186 }