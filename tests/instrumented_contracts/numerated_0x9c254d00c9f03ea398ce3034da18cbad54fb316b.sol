1 pragma solidity ^0.4.13;
2 
3 contract IndexManager {
4 
5   bytes32 managerName;
6   address owner;
7 
8   struct IndexStruct {
9     address indexAddress;
10     uint indexCategory;
11     string label;
12     uint index;
13   }
14   
15   mapping(address=>bool) public delegatinglist;
16   mapping(bytes32 => IndexStruct) private indexStructs;
17   bytes32[] private indexIndex;
18 
19   event LogNewIndex   (bytes32 indexed indexName, uint index, address indexAddress, uint indexCategory);
20   event LogUpdateIndex(bytes32 indexed indexName, uint index, address indexAddress, uint indexCategory, string label);
21   event LogDeleteIndex(bytes32 indexed indexName, uint index);
22 
23   event indexInitialized(uint32 _date, bytes32 _indexName);
24   event Authorized(address authorized, uint timestamp);
25   event Revoked(address authorized, uint timestamp);
26 
27   modifier onlyAuthorized(){
28       require(isdelegatinglisted(msg.sender));
29       _;
30   }
31 
32   function authorize(address authorized) public onlyAuthorized {
33       delegatinglist[authorized] = true;
34       emit Authorized(authorized, now);
35   }
36 
37   // also if not in the list..
38   function revoke(address authorized) public onlyAuthorized {
39       delegatinglist[authorized] = false;
40       emit Revoked(authorized, now);
41   }
42 
43   function authorizeMany(address[50] authorized) public onlyAuthorized {
44       for(uint i = 0; i < authorized.length; i++) {
45           authorize(authorized[i]);
46       }
47   }
48 
49   function isdelegatinglisted(address authorized) public view returns(bool) {
50     return delegatinglist[authorized];
51   }
52 
53   constructor(bytes32 _name) public{        
54       owner = msg.sender;
55       delegatinglist[owner] = true;
56       owner = msg.sender;
57       managerName = _name;
58   }
59 
60   function isIndex(bytes32 indexName)
61     public
62     constant
63     returns(bool isIndeed)
64   {
65     if(indexIndex.length == 0) return false;
66     return (indexIndex[indexStructs[indexName].index] == indexName);
67   }
68 
69   function insertIndex(
70     bytes32 indexName,
71     address indexAddress,
72     uint    indexCategory,
73     string label)
74     onlyAuthorized
75     public
76     returns(uint index)
77   {
78     if(isIndex(indexName)) revert();
79     indexStructs[indexName].indexAddress = indexAddress;
80     indexStructs[indexName].indexCategory   = indexCategory;
81     indexStructs[indexName].label   = label;
82     indexStructs[indexName].index     = indexIndex.push(indexName)-1;
83     emit LogNewIndex(
84         indexName,
85         indexStructs[indexName].index,
86         indexAddress,
87         indexCategory);
88     return indexIndex.length-1;
89   }
90 
91   function deleteIndex(bytes32 indexName)
92     onlyAuthorized
93     public
94     returns(uint index)
95   {
96     if(!isIndex(indexName)) revert();
97     uint rowToDelete = indexStructs[indexName].index;
98     bytes32 keyToMove = indexIndex[indexIndex.length-1];
99     indexIndex[rowToDelete] = keyToMove;
100     indexStructs[keyToMove].index = rowToDelete;
101     indexIndex.length--;
102     emit LogDeleteIndex(
103         indexName,
104         rowToDelete);
105     emit LogUpdateIndex(
106         keyToMove,
107         rowToDelete,
108         indexStructs[keyToMove].indexAddress,
109         indexStructs[keyToMove].indexCategory,
110         indexStructs[keyToMove].label);
111     return rowToDelete;
112   }
113 
114   function getIndex(bytes32 indexName)
115     public
116     constant
117     returns(address indexAddress, uint indexCategory, uint index, string label)
118   {
119     if(!isIndex(indexName)) revert();
120     return(
121       indexStructs[indexName].indexAddress,
122       indexStructs[indexName].indexCategory,
123       indexStructs[indexName].index,
124       indexStructs[indexName].label);
125   }
126 
127   function updateIndexAddress(bytes32 indexName, address indexAddress)
128     onlyAuthorized
129     public
130     returns(bool success)
131   {
132     if(!isIndex(indexName)) revert();
133     indexStructs[indexName].indexAddress = indexAddress;
134     emit LogUpdateIndex(
135       indexName,
136       indexStructs[indexName].index,
137       indexAddress,
138       indexStructs[indexName].indexCategory,
139       indexStructs[indexName].label);
140     return true;
141   }
142 
143   function updateIndexCategory(bytes32 indexName, uint indexCategory)
144     onlyAuthorized
145     public
146     returns(bool success)
147   {
148     if(!isIndex(indexName)) revert();
149     indexStructs[indexName].indexCategory = indexCategory;
150     emit LogUpdateIndex(
151       indexName,
152       indexStructs[indexName].index,
153       indexStructs[indexName].indexAddress,
154       indexCategory,
155       indexStructs[indexName].label);
156     return true;
157   }
158 
159   function updateIndexLabel(bytes32 indexName, string newLabel)
160     onlyAuthorized
161     public
162     returns(bool success)
163   {
164     if(!isIndex(indexName)) revert();
165     indexStructs[indexName].label = newLabel;
166     emit LogUpdateIndex(
167       indexName,
168       indexStructs[indexName].index,
169       indexStructs[indexName].indexAddress,
170       indexStructs[indexName].indexCategory,
171       newLabel);
172     return true;
173   }
174 
175   function getIndexCount()
176     public
177     constant
178     returns(uint count)
179   {
180     return indexIndex.length;
181   }
182 
183   function getIndexAtIndex(uint index)
184     public
185     constant
186     returns(bytes32 indexName)
187   {
188     return indexIndex[index];
189   }
190 
191   function addIndexInitialization(uint32 _date, bytes32 _indexName) public onlyAuthorized {
192     emit indexInitialized(_date, _indexName);
193   }
194 
195 }