1 /*
2  * Written by Jesse Busman (info@jesbus.com) on 2017-11-30.
3  * This software is provided as-is without warranty of any kind, express or implied.
4  * This software is provided without any limitation to use, copy modify or distribute.
5  * The user takes sole and complete responsibility for the consequences of this software's use.
6  * Github repository: https://github.com/JesseBusman/SoliditySet
7  */
8 
9 pragma solidity ^0.4.18;
10 
11 library SetLibrary
12 {
13     struct ArrayIndexAndExistsFlag
14     {
15         uint256 index;
16         bool exists;
17     }
18     struct Set
19     {
20         mapping(uint256 => ArrayIndexAndExistsFlag) valuesMapping;
21         uint256[] values;
22     }
23     function add(Set storage self, uint256 value) public returns (bool added)
24     {
25         // If the value is already in the set, we don't need to do anything
26         if (self.valuesMapping[value].exists == true) return false;
27         
28         // Remember that the value is in the set, and remember the value's array index
29         self.valuesMapping[value] = ArrayIndexAndExistsFlag({index: self.values.length, exists: true});
30         
31         // Add the value to the array of unique values
32         self.values.push(value);
33         
34         return true;
35     }
36     function contains(Set storage self, uint256 value) public view returns (bool contained)
37     {
38         return self.valuesMapping[value].exists;
39     }
40     function remove(Set storage self, uint256 value) public returns (bool removed)
41     {
42         // If the value is not in the set, we don't need to do anything
43         if (self.valuesMapping[value].exists == false) return false;
44         
45         // Remember that the value is not in the set
46         self.valuesMapping[value].exists = false;
47         
48         // Now we need to remove the value from the array. To prevent leaking
49         // storage space, we move the last value in the array into the spot that
50         // contains the element we're removing.
51         if (self.valuesMapping[value].index < self.values.length-1)
52         {
53             uint256 valueToMove = self.values[self.values.length-1];
54             uint256 indexToMoveItTo = self.valuesMapping[value].index;
55             self.values[indexToMoveItTo] = valueToMove;
56             self.valuesMapping[valueToMove].index = indexToMoveItTo;
57         }
58         
59         // Now we remove the last element from the array, because we just duplicated it.
60         // We don't free the storage allocation of the removed last element,
61         // because it will most likely be used again by a call to add().
62         // De-allocating and re-allocating storage space costs more gas than
63         // just keeping it allocated and unused.
64         
65         // Uncomment this line to save gas if your use case does not call add() after remove():
66         // delete self.values[self.values.length-1];
67         self.values.length--;
68         
69         // We do free the storage allocation in the mapping, because it is
70         // less likely that the exact same value will added again.
71         delete self.valuesMapping[value];
72         
73         return true;
74     }
75     function size(Set storage self) public view returns (uint256 amountOfValues)
76     {
77         return self.values.length;
78     }
79     
80     // Also accept address and bytes32 types, so the user doesn't have to cast.
81     function add(Set storage self, address value) public returns (bool added) { return add(self, uint256(value)); }
82     function add(Set storage self, bytes32 value) public returns (bool added) { return add(self, uint256(value)); }
83     function contains(Set storage self, address value) public view returns (bool contained) { return contains(self, uint256(value)); }
84     function contains(Set storage self, bytes32 value) public view returns (bool contained) { return contains(self, uint256(value)); }
85     function remove(Set storage self, address value) public returns (bool removed) { return remove(self, uint256(value)); }
86     function remove(Set storage self, bytes32 value) public returns (bool removed) { return remove(self, uint256(value)); }
87 }
88 
89 contract SetUsageExample
90 {
91     using SetLibrary for SetLibrary.Set;
92     
93     SetLibrary.Set private numberCollection;
94     
95     function addNumber(uint256 number) external
96     {
97         numberCollection.add(number);
98     }
99     
100     function removeNumber(uint256 number) external
101     {
102         numberCollection.remove(number);
103     }
104     
105     function getSize() external view returns (uint256 size)
106     {
107         return numberCollection.size();
108     }
109     
110     function containsNumber(uint256 number) external view returns (bool contained)
111     {
112         return numberCollection.contains(number);
113     }
114     
115     function getNumberAtIndex(uint256 index) external view returns (uint256 number)
116     {
117         return numberCollection.values[index];
118     }
119 }