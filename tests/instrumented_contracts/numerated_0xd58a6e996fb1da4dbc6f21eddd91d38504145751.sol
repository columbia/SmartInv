1 pragma solidity ^0.5.0;
2 
3 contract BlncTreasure {
4 
5     address admin;
6 
7     string[] allTreasures;
8 
9     mapping(bytes32 => string) treasures;
10 
11     mapping(bytes32 => string) members;
12 
13     event NewTreasureEvent (
14         bytes32 md5OfTreasureName,
15         string treasureName          
16     );
17 
18     event DispatchMembersEvent (
19         bytes32 md5OfTreasureName,
20         string md5OfMembers
21     );
22 
23     constructor()
24         public 
25     {
26         admin = msg.sender;
27     }
28 
29     function newTreasure (
30         bytes32 md5OfTreasureName,
31         string memory treasureName        
32     )
33         public
34         onlyAdmin()
35         onlyWriteTreasureOneTime(md5OfTreasureName)
36     {
37        
38         allTreasures.push(treasureName);
39         treasures[md5OfTreasureName] = treasureName;
40         emit NewTreasureEvent(md5OfTreasureName,treasureName);
41     }
42 
43     function dispatchMembers (
44         bytes32 md5OfTreasureName,
45         string memory md5OfMembers
46     )
47         public 
48         onlyAdmin()
49         onlyOnceWriteMembersOneTime(md5OfTreasureName)
50     {
51         members[md5OfTreasureName] = md5OfMembers;
52     }
53 
54     function isAdmin (
55         address admin_
56     )
57         public
58         view
59         returns(bool)
60     {
61         if(admin_ == admin) {
62             return true;
63         }
64         return false;
65     }
66 
67     function isNotDuplicateTreasure(
68         bytes32 md5OfTreasureName
69     )
70         public
71         view
72         returns(bool) 
73     {
74         string memory treasureName = treasures[md5OfTreasureName];
75         return isEmptyString(treasureName);
76     }
77 
78     function isNotDuplicateMembers(
79         bytes32 md5OfTreasureName
80     )
81         public 
82         view 
83         returns(bool)
84     {
85         string memory memberHash = members[md5OfTreasureName];
86         return isEmptyString(memberHash);
87     }
88 
89     modifier onlyWriteTreasureOneTime (
90         bytes32 signature
91     ) {
92         require(isNotDuplicateTreasure(signature),"error : duplicate members of the treasure");
93         _;
94     }
95 
96     modifier onlyOnceWriteMembersOneTime (
97         bytes32 signature
98     ) {
99         require(isNotDuplicateMembers(signature),"error : duplicate treasure");
100         _;
101     }
102 
103     modifier onlyAdmin() {
104         require(isAdmin(msg.sender),"only the amdin has the permession");
105         _;
106     }
107 
108     function getTreasures ()
109         public
110         view
111         returns(byte[] memory) 
112     {
113         return concat(allTreasures,0); 
114     }
115 
116     function getTreasure (
117         bytes32 md5OfTreasureName
118     )
119         public
120         view 
121         returns(string memory)
122     {
123         return treasures[md5OfTreasureName];
124     }
125 
126     function getMembers (
127         bytes32 md5OfTreasureName
128     )
129         public
130         view
131 	    returns(string memory)
132 	{
133         return members[md5OfTreasureName];
134     }
135 
136     // 连接字符串数组
137     function concat(
138         string[] memory arrs,
139         uint256 index
140     )
141       private 
142       pure
143       returns(byte[] memory)
144     {
145         uint256 arrSize = arrs.length;
146         if(arrs.length == 0) {
147             return new byte[](0);
148         }
149         uint256 total = count(arrs,index);
150         byte[] memory result = new byte[](total); 
151         uint256 k = 0;
152         for(uint256 i = index; i < arrSize; i++) {
153             bytes memory arr = bytes(arrs[i]);
154             for(uint j = 0; j < arr.length; j++) {
155                 result[k] = arr[j];
156                 k++;
157             }
158         }
159         return result;
160     }
161 
162     // 统计长度
163     function count(
164         string[] memory arrs,
165         uint256 index
166     )
167         private
168         pure
169         returns(uint256) 
170     {
171         uint256 total = 0;    
172         uint256 len1 = arrs.length;
173         for(uint256 i = index;i < len1; i++) {
174             bytes memory arr = bytes(arrs[i]);
175             total = total + arr.length;
176         }
177         return total;
178     }
179 
180     function compare(
181         string memory _a, 
182         string memory _b
183     ) 
184         private
185         pure
186         returns (int) 
187     {
188         bytes memory a = bytes(_a);
189         bytes memory b = bytes(_b);
190         uint minLength = a.length;
191         if (b.length < minLength) minLength = b.length;
192         //@todo unroll the loop into increments of 32 and do full 32 byte comparisons
193         for (uint i = 0; i < minLength; i ++) {
194             if (a[i] < b[i])
195                 return -1;
196             else if (a[i] > b[i])
197                 return 1;
198         }  
199         if (a.length < b.length)
200             return -1;
201         else if (a.length > b.length)
202             return 1;
203         else
204             return 0;
205     }
206     
207     function equal(
208         string memory _a, 
209         string memory _b
210     ) 
211         private
212         pure
213         returns (bool) 
214     {
215         return compare(_a, _b) == 0;
216     }
217 
218     function isEmptyString (
219         string memory str
220     )
221         private 
222         pure
223         returns(bool)
224     {
225         bytes memory temp = bytes(str);
226         if(temp.length == 0) {
227             return true;
228         }
229         return false;
230     }
231 }