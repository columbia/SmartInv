1 contract Mapoc {
2     address _owner;
3     address _filiate;
4 
5     mapping (string => uint) private mapExecs;
6     Execution[] private executions;
7     event Executed(string Hash);
8     event Validated(string Hash);
9     
10     struct Execution {
11         uint dateCreated;
12         string hash;
13         bool validated;
14         uint dateValidated;
15     }
16     
17     
18     /* CONSTRUCTOR */
19     function Mapoc(/*address filiate*/) {
20         _owner = msg.sender;
21         _filiate = msg.sender;
22     }
23     
24     function kill() ownerAllowed() {
25         suicide(_owner);
26     }
27     
28     /* MAPPING */
29     function map(string hash) internal returns(uint) {
30         uint ret = mapExecs[hash];
31         if(ret >= executions.length || !strEqual(executions[ret].hash, hash)) throw;
32         return ret;
33     }
34     
35     /* MODIFIERS */
36     modifier bothAllowed() {
37         if(msg.sender != _owner && msg.sender != _filiate) throw;
38         _;
39     }
40     
41     modifier ownerAllowed() {
42         if(msg.sender != _owner) throw;
43         _;
44     }
45     
46     modifier filiateAllowed() {
47         if(msg.sender != _filiate) throw;
48         _;
49     }
50     
51     modifier notYetExist(string hash) {
52         uint num = mapExecs[hash];
53         if(num < executions.length && strEqual(executions[num].hash, hash)) throw;
54         _;
55     }
56     
57     modifier notYetValidated(string hash) {
58         Execution e = executions[map(hash)];
59         if(e.validated) throw;
60         _;
61     }
62     
63     modifier orderExist(string hash) {
64         Execution e = executions[map(hash)];
65         if(!strEqual(e.hash, hash)) throw;
66         _;
67     }
68     
69     /* FONCTIONS */
70     function AddExec(string Hash) public ownerAllowed() notYetExist(Hash) {
71         uint num = executions.length++;
72         mapExecs[Hash] = num;
73         Execution e = executions[num];
74         e.dateCreated = now;
75         e.hash = Hash;
76         Executed(Hash);
77     }
78     
79     function ValidateExec(string Hash) public filiateAllowed() notYetValidated(Hash) {
80         Execution e = executions[map(Hash)];
81         e.validated = true;
82         e.dateValidated = now;
83         Validated(Hash);
84     }
85     
86     function CheckExecution(string Hash) public bothAllowed() constant returns(bool IsExist, uint DateCreated, bool Validated, uint DateValidated){
87         uint ret = mapExecs[Hash];
88         if(ret >= executions.length || !strEqual(executions[ret].hash, Hash)) return (false, 0, false, 0);
89         Execution e = executions[ret];
90         return (true, e.dateCreated, e.validated, e.dateValidated);
91     }
92     
93     function IsValidated(string Hash) public bothAllowed() constant returns(bool) {
94         Execution e = executions[map(Hash)];
95         return e.validated;
96     }
97     
98     function LastExecuted() public bothAllowed() constant returns(string Hash, uint DateCreated) {
99         DateCreated = 0;
100         if(executions.length > 0) {
101             if(!executions[0].validated) {
102                 Hash = executions[0].hash;
103                 DateCreated = executions[0].dateCreated;
104             }
105             for(uint i = executions.length - 1; i > 0; i--) {
106                 if(!executions[i].validated && executions[i].dateCreated > DateCreated) {
107                     Hash = executions[i].hash;
108                     DateCreated = executions[i].dateCreated;
109                     break;
110                 }
111             }
112         }
113         return (Hash, DateCreated);
114     }
115     
116     function LastValidated() public bothAllowed() constant returns(string Hash, uint DateValidated) {
117         DateValidated = 0;
118         for(uint i = 0; i < executions.length; i++) {
119             if(executions[i].validated && executions[i].dateValidated > DateValidated) {
120                 Hash = executions[i].hash;
121                 DateValidated = executions[i].dateValidated;
122             }
123         }
124         return (Hash, DateValidated);
125     }
126     
127     function CountExecs() public bothAllowed() constant returns(uint Total, uint NotVal) {
128         uint nbNotVal = 0;
129         for(uint i = 0; i < executions.length; i++) {
130             if(!executions[i].validated) nbNotVal++;
131         }
132         return (executions.length, nbNotVal);
133     }
134     
135     function NotValSince(uint timestampFrom) public bothAllowed() constant returns(uint Count, string First, uint DateFirst, string Last, uint DateLast) {
136         Count = 0;
137         DateFirst = now;
138         DateLast = 0;
139         for(uint i = 0; i < executions.length; i++) {
140             if(!executions[i].validated && executions[i].dateCreated >= timestampFrom) {
141                 Count++;
142                 if(executions[i].dateCreated < DateFirst) {
143                     First = executions[i].hash;
144                     DateFirst = executions[i].dateCreated;
145                 }
146                 else if(executions[i].dateCreated > DateLast) {
147                     Last = executions[i].hash;
148                     DateLast = executions[i].dateCreated;
149                 }
150             }
151         }
152         return (Count, First, DateFirst, Last, DateLast);
153     }
154     
155     function ListNotValSince(uint timestampFrom) public bothAllowed() constant returns(uint Count, string List, uint OldestTime) {
156         Count = 0;
157         List = "\n";
158         OldestTime = now;
159         for(uint i = 0; i < executions.length; i++) {
160             if(!executions[i].validated && executions[i].dateCreated >= timestampFrom) {
161                 Count++;
162                 List = strConcat(List, executions[i].hash, " ;\n");
163                 if(executions[i].dateCreated < OldestTime)
164                     OldestTime = executions[i].dateCreated;
165             }
166         }
167         return (Count, List, OldestTime);
168     }
169     
170     function ListAllSince(uint timestampFrom) public bothAllowed() constant returns(uint Count, string List) {
171         List = "\n";
172         for(uint i = 0; i < executions.length; i++) {
173             string memory val;
174             if(executions[i].validated)
175                 val = "confirmed\n";
176             else
177                 val = "published\n";
178                 
179             List = strConcat(List, executions[i].hash, " : ", val);
180         }
181         return (executions.length, List);
182     }
183     
184     /* UTILS */
185     function strEqual(string _a, string _b) internal returns(bool) {
186 		bytes memory a = bytes(_a);
187 		bytes memory b = bytes(_b);
188 		if (a.length != b.length)
189 			return false;
190 
191 		for (uint i = 0; i < a.length; i ++)
192 			if (a[i] != b[i])
193 				return false;
194 		return true;
195 	}
196 	
197 	function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns(string) {
198         bytes memory _ba = bytes(_a);
199         bytes memory _bb = bytes(_b);
200         bytes memory _bc = bytes(_c);
201         bytes memory _bd = bytes(_d);
202         bytes memory _be = bytes(_e);
203         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
204         bytes memory babcde = bytes(abcde);
205         uint k = 0;
206         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
207         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
208         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
209         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
210         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
211         return string(babcde);
212     }
213     
214     function strConcat(string _a, string _b, string _c, string _d) internal returns(string) {
215         return strConcat(_a, _b, _c, _d, "");
216     }
217     
218     function strConcat(string _a, string _b, string _c) internal returns(string) {
219         return strConcat(_a, _b, _c, "", "");
220     }
221     
222     function strConcat(string _a, string _b) internal returns(string) {
223         return strConcat(_a, _b, "", "", "");
224     }
225     
226 }