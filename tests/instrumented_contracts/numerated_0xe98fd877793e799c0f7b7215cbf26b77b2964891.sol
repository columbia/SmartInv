1 pragma solidity ^0.4.6;
2 
3 contract MetaPoc {
4     /* VARIABLES */
5     address public _owner;
6     address public _filiate;
7 
8     struct Execution {
9         uint dateCreated;
10         string hash;
11         bool validated;
12         uint dateValidated;
13     }
14     
15     mapping (string => uint) private mapExecs;
16     Execution[] private executions;
17     
18     /* PRIVATE CONST */
19     uint private nb_total = 0;
20     uint private nb_notVal = 0;
21     uint private nb_val = 0;
22     
23     string private last_exec = "none";
24     uint private last_execDateCreated = 0;
25     
26     string private notVal_list = "none";
27     uint private notVal_since = 0;
28     string private notVal_last = "none";
29     uint private notVal_lastDateCreated = 0;
30     
31     string private val_list = "none";
32     uint private val_since = 0;
33     string private val_last = "none";
34     uint private val_lastDateCreated = 0;
35     uint private val_lastDateValidated = 0;
36     
37     /* EVENTS */
38     event Executed(string Hash, uint Created);
39     event Validated(string Hash, uint Validated);
40     event Checked(string Hash, bool IsExit, uint Created, bool IsValidated, uint Validated);
41     event Listed_Validated(uint Since, string List);
42     event Listed_NotValidated(uint Since, string List);
43     event Owner_Changed(address Owner);
44     event Filiate_Changed(address Filiate);
45     
46     
47     /* CONSTRUCTOR */
48     function MetaPoc(address filiate) {
49         _owner = msg.sender;
50         _filiate = filiate;
51     }
52     
53     /* MAPPING */
54     function map(string hash) internal returns(uint) {
55         uint ret = mapExecs[hash];
56         if(ret >= executions.length || !strEqual(executions[ret].hash, hash)) throw;
57         return ret;
58     }
59     
60     /* MODIFIERS */
61     modifier bothAllowed() {
62         if(msg.sender != _owner && msg.sender != _filiate) throw;
63         _;
64     }
65     
66     modifier ownerAllowed() {
67         if(msg.sender != _owner) throw;
68         _;
69     }
70     
71     modifier filiateAllowed() {
72         if(msg.sender != _filiate) throw;
73         _;
74     }
75     
76     modifier notYetExist(string hash) {
77         uint num = mapExecs[hash];
78         if(num < executions.length && strEqual(executions[num].hash, hash)) throw;
79         _;
80     }
81     
82     modifier notYetValidated(string hash) {
83         Execution e = executions[map(hash)];
84         if(e.validated) throw;
85         _;
86     }
87     
88     modifier orderExist(string hash) {
89         Execution e = executions[map(hash)];
90         if(!strEqual(e.hash, hash)) throw;
91         _;
92     }
93     
94     /* INIT */
95     function ChangeOwner(address owner) ownerAllowed() {
96         if(owner.balance <= 0) throw;
97         
98         _owner = owner;
99         Owner_Changed(_owner);
100     }
101     
102     function ChangeFiliate(address filiate) bothAllowed() {
103         if(filiate.balance <= 0) throw;
104         
105         _filiate = filiate;
106         Filiate_Changed(_filiate);
107     }
108     
109     function kill() ownerAllowed() {
110         suicide(_owner);
111     }
112     
113     /* PUBLIC FUNCTIONS */
114     function AddExec(string Hash) public ownerAllowed() notYetExist(Hash) {
115         uint num = executions.length++;
116         mapExecs[Hash] = num;
117         Execution e = executions[num];
118         e.dateCreated = now;
119         e.hash = Hash;
120         executions[num] = e;
121         
122         /* màj public const */
123         nb_total++;
124         nb_notVal++;
125         notVal_last = e.hash;
126         notVal_lastDateCreated = e.dateCreated;
127         MajListAll();
128         
129         Executed(e.hash, e.dateCreated);
130     }
131     
132     function ValidateExec(string Hash) public filiateAllowed() notYetValidated(Hash) {
133         Execution e = executions[map(Hash)];
134         e.validated = true;
135         e.dateValidated = now;
136         executions[map(Hash)] = e;
137         
138         /* màj public const */
139         nb_val++;
140         nb_notVal--;
141         val_last = e.hash;
142         val_lastDateCreated = e.dateCreated;
143         val_lastDateValidated = e.dateValidated;
144         MajListAll();
145         MajLastNotVal();
146         
147         Validated(e.hash, e.dateValidated);
148     }
149     
150     function CheckExec(string Hash) public bothAllowed() {
151         uint ret = mapExecs[Hash];
152         if(ret >= executions.length || !strEqual(executions[ret].hash, Hash)) {
153             Checked(Hash, false, 0, false, 0);
154         } else {
155             Execution e = executions[ret];
156             Checked(e.hash, true, e.dateCreated, e.validated, e.dateValidated);
157         }
158     }
159     
160     function ListAllSince(uint timestampFrom) public bothAllowed() {
161         val_since = timestampFrom;
162         notVal_since = timestampFrom;
163         MajListAll();
164         Listed_Validated(val_since, val_list);
165         Listed_NotValidated(notVal_since, notVal_list);
166     }
167     
168     function ListNotValSince(uint timestampFrom) public bothAllowed() {
169         notVal_since = timestampFrom;
170         MajListNotVal();
171         Listed_NotValidated(notVal_since, notVal_list);
172     }
173     
174     function ListValSince(uint timestampFrom) public bothAllowed() {
175         val_since = timestampFrom;
176         MajListVal();
177         Listed_Validated(val_since, val_list);
178     }
179     
180     
181     /* CONSTANTS */
182     function CountExecs() public constant returns(uint Total, uint NbValidated, uint NbNotVal) {
183         return (nb_total, nb_val, nb_notVal);
184     }
185     
186     function LastExec() public constant returns(string Hash, uint Created) {
187         return (notVal_last, notVal_lastDateCreated);
188     }
189     
190     function LastValidated() public constant returns(string Hash, uint Created, uint Validated) {
191         return (val_last, val_lastDateCreated, val_lastDateValidated);
192     }
193     
194     function ListNotValidated() public constant returns(uint Since, string List) {
195         return (notVal_since, notVal_list);
196     }
197 
198     function ListValidated() public constant returns(uint Since, string List) {
199         return (val_since, val_list);
200     }
201     
202     /* PRIVATE FUNCTIONS */
203     function MajListAll() private {
204         MajListVal();
205         MajListNotVal();
206     }
207     
208     function MajListVal() private {
209         val_list = "none";
210         for(uint i = 0; i < executions.length; i++) {
211             if(executions[i].dateCreated >= val_since && executions[i].validated) {
212                 if(strEqual(val_list, "none")) val_list = executions[i].hash;
213                 else val_list = strConcat(val_list, " ; ", executions[i].hash);
214             }
215         }
216     }
217     
218     function MajListNotVal() private {
219         notVal_list = "none";
220         for(uint i = 0; i < executions.length; i++) {
221             if(executions[i].dateCreated >= notVal_since && !executions[i].validated) {
222                 if(strEqual(notVal_list, "none")) notVal_list = executions[i].hash;
223                 else notVal_list = strConcat(notVal_list, " ; ", executions[i].hash);
224             }
225         }
226     }
227     
228     function MajLastNotVal() private {
229         notVal_lastDateCreated = 0;
230         notVal_last = "none";
231         if(executions.length > 0) {
232             if(!executions[0].validated) {
233                 notVal_last = executions[0].hash;
234                 notVal_lastDateCreated = executions[0].dateCreated;
235             }
236             for(uint i = executions.length - 1; i > 0; i--) {
237                 if(!executions[i].validated && executions[i].dateCreated > notVal_lastDateCreated) {
238                     notVal_last = executions[i].hash;
239                     notVal_lastDateCreated = executions[i].dateCreated;
240                     break;
241                 }
242             }
243         }
244     }
245     
246     /* UTILS */
247     function strEqual(string _a, string _b) internal returns(bool) {
248 		bytes memory a = bytes(_a);
249 		bytes memory b = bytes(_b);
250 		if (a.length != b.length)
251 			return false;
252 
253 		for (uint i = 0; i < a.length; i ++)
254 			if (a[i] != b[i])
255 				return false;
256 		return true;
257 	}
258 	
259 	function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns(string) {
260         bytes memory _ba = bytes(_a);
261         bytes memory _bb = bytes(_b);
262         bytes memory _bc = bytes(_c);
263         bytes memory _bd = bytes(_d);
264         bytes memory _be = bytes(_e);
265         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
266         bytes memory babcde = bytes(abcde);
267         uint k = 0;
268         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
269         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
270         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
271         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
272         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
273         return string(babcde);
274     }
275     
276     function strConcat(string _a, string _b, string _c, string _d) internal returns(string) {
277         return strConcat(_a, _b, _c, _d, "");
278     }
279     
280     function strConcat(string _a, string _b, string _c) internal returns(string) {
281         return strConcat(_a, _b, _c, "", "");
282     }
283     
284     function strConcat(string _a, string _b) internal returns(string) {
285         return strConcat(_a, _b, "", "", "");
286     }
287     
288 }