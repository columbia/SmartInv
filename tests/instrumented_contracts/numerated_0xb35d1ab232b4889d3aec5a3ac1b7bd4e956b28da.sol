1 pragma solidity ^0.5.0; 
2 contract InnovationAndCryptoventures {
3     string[] hashes;
4     string[] groups = ["A1","A2","A3","A4","A5","A6","A7","A8","A9","A10","A11","A12","A13","A14","A15","A16","A17","A18","A19","A20","B1","B2","B3","B4","B5","B6","B7","B8","B9","B10","B11","B12","B13","B14","B15","B16","B17","B18","B19","B20","C1","C2","C3","C4","C5","C6","C7","C8","C9","C10","C11","C12","C13","C14","C15","C16","C17","C18","C19","C20"];
5     
6     mapping(uint=>mapping(int=>string)) yearToGroupToHash;
7 
8     mapping(string=>uint) hashToYear;
9     mapping(string=>int) hashToGroup;
10     
11     event A1(uint year, string hash);
12     event A2(uint year, string hash);
13     event A3(uint year, string hash);
14     event A4(uint year, string hash);
15     event A5(uint year, string hash);
16     event A6(uint year, string hash);
17     event A7(uint year, string hash);
18     event A8(uint year, string hash);
19     event A9(uint year, string hash);
20     event A10(uint year, string hash);
21     event A11(uint year, string hash);
22     event A12(uint year, string hash);
23     event A13(uint year, string hash);
24     event A14(uint year, string hash);
25     event A15(uint year, string hash);
26     event A16(uint year, string hash);
27     event A17(uint year, string hash);
28     event A18(uint year, string hash);
29     event A19(uint year, string hash);
30     event A20(uint year, string hash);
31     
32     event B1(uint year, string hash);
33     event B2(uint year, string hash);
34     event B3(uint year, string hash);
35     event B4(uint year, string hash);
36     event B5(uint year, string hash);
37     event B6(uint year, string hash);
38     event B7(uint year, string hash);
39     event B8(uint year, string hash);
40     event B9(uint year, string hash);
41     event B10(uint year, string hash);
42     event B11(uint year, string hash);
43     event B12(uint year, string hash);
44     event B13(uint year, string hash);
45     event B14(uint year, string hash);
46     event B15(uint year, string hash);
47     event B16(uint year, string hash);
48     event B17(uint year, string hash);
49     event B18(uint year, string hash);
50     event B19(uint year, string hash);
51     event B20(uint year, string hash);
52      
53     event C1(uint year, string hash);
54     event C2(uint year, string hash);
55     event C3(uint year, string hash);
56     event C4(uint year, string hash);
57     event C5(uint year, string hash);
58     event C6(uint year, string hash);
59     event C7(uint year, string hash);
60     event C8(uint year, string hash);
61     event C9(uint year, string hash);
62     event C10(uint year, string hash);
63     event C11(uint year, string hash);
64     event C12(uint year, string hash);
65     event C13(uint year, string hash);
66     event C14(uint year, string hash);
67     event C15(uint year, string hash);
68     event C16(uint year, string hash);
69     event C17(uint year, string hash);
70     event C18(uint year, string hash);
71     event C19(uint year, string hash);
72     event C20(uint year, string hash);
73 
74     function publishDeck(uint year, string memory group, string memory hash) public {
75         int g = groupIndex(group);
76         require(g>=0);
77         yearToGroupToHash[year][g] = hash;
78         hashToYear[hash] = year;
79         hashToGroup[hash] = g;
80         
81         hashes.push(hash);
82         emitHash(year, g, hash);
83     }
84     
85     function emitHash(uint year, int group, string memory hash) internal {
86         
87         if(group==0) emit A1(year,hash);
88         if(group==1) emit A2(year,hash);
89         if(group==2) emit A3(year,hash);
90         if(group==3) emit A4(year,hash);
91         if(group==4) emit A5(year,hash);
92         if(group==5) emit A6(year,hash);
93         if(group==6) emit A7(year,hash);
94         if(group==7) emit A8(year,hash);
95         if(group==8) emit A9(year,hash);
96         if(group==9) emit A10(year,hash);
97         if(group==10) emit A11(year,hash);
98         if(group==11) emit A12(year,hash);
99         if(group==12) emit A13(year,hash);
100         if(group==13) emit A14(year,hash);
101         if(group==14) emit A15(year,hash);
102         if(group==15) emit A16(year,hash);
103         if(group==16) emit A17(year,hash);
104         if(group==17) emit A18(year,hash);
105         if(group==18) emit A19(year,hash);
106         if(group==19) emit A20(year,hash);
107         
108         if(group==20) emit B1(year,hash);
109         if(group==21) emit B2(year,hash);
110         if(group==22) emit B3(year,hash);
111         if(group==23) emit B4(year,hash);
112         if(group==24) emit B5(year,hash);
113         if(group==25) emit B6(year,hash);
114         if(group==26) emit B7(year,hash);
115         if(group==27) emit B8(year,hash);
116         if(group==28) emit B9(year,hash);
117         if(group==29) emit B10(year,hash);
118         if(group==30) emit B11(year,hash);
119         if(group==31) emit B12(year,hash);
120         if(group==32) emit B13(year,hash);
121         if(group==33) emit B14(year,hash);
122         if(group==34) emit B15(year,hash);
123         if(group==35) emit B16(year,hash);
124         if(group==36) emit B17(year,hash);
125         if(group==37) emit B18(year,hash);
126         if(group==38) emit B19(year,hash);
127         if(group==39) emit B20(year,hash);
128 
129         if(group==40) emit C1(year,hash);
130         if(group==41) emit C2(year,hash);
131         if(group==42) emit C3(year,hash);
132         if(group==43) emit C4(year,hash);
133         if(group==44) emit C5(year,hash);
134         if(group==45) emit C6(year,hash);
135         if(group==46) emit C7(year,hash);
136         if(group==47) emit C8(year,hash);
137         if(group==48) emit C9(year,hash);
138         if(group==49) emit C10(year,hash);
139         if(group==50) emit C11(year,hash);
140         if(group==51) emit C12(year,hash);
141         if(group==52) emit C13(year,hash);
142         if(group==53) emit C14(year,hash);
143         if(group==54) emit C15(year,hash);
144         if(group==55) emit C16(year,hash);
145         if(group==56) emit C17(year,hash);
146         if(group==57) emit C18(year,hash);
147         if(group==58) emit C19(year,hash);
148         if(group==59) emit C20(year,hash);
149     }
150     
151     function groupIndex(string memory group) public view  returns(int){
152         bytes32 g = keccak256(abi.encode(group));
153         int len = (int) (groups.length);
154         for(int i=0;i<len;i++){
155             uint j = (uint) (i);
156             bytes32 temp = keccak256(abi.encode(groups[j]));
157             if(g == temp){
158                 return i;
159             }
160         }
161         return -1;
162     }
163     
164     function checkExists(string memory hash) public view returns(bool){
165         bytes32 h = keccak256(abi.encode(hash));
166         for(uint i=0;i<hashes.length;i++){
167             bytes32 temp = keccak256(abi.encode(hashes[i]));
168             if(h == temp){
169                 return true;
170             }
171         }
172         return false;
173     }
174     
175     function _checkExists(uint year, int group) public view returns(bool){
176         bytes32 n = keccak256(abi.encode(_getHash(0,0)));
177         return n != keccak256(abi.encode(_getHash(year,group)));
178     }
179     
180     function checkExists(uint year, string memory group) public view  returns(bool){
181         int g = groupIndex(group);
182         return _checkExists(year,g);
183     }
184     
185     // Section A=0, B=1, C=2
186     function batchEmit(uint year,int section) public {
187         require(section>=0 && section<=2);
188         for(int i=section*20;i<(section+1)*20;i++){
189             if(_checkExists(year,i)){
190                 string memory hash = _getHash(year,i);
191                 emitHash(year,i,hash);
192             }
193         }
194     }
195     
196     function getHash(uint year, string memory group) public view returns(string memory){
197         int _group = groupIndex(group);
198         return _getHash(year, _group);
199     }
200     
201     function _getHash(uint _year, int _group) public view returns(string memory){
202         return yearToGroupToHash[_year][_group];  
203     }
204     
205     function getYear(string memory hash) public view returns(uint){
206         return hashToYear[hash]; 
207     }
208     
209     function getGroupString(string memory hash) public view returns(string memory){
210         uint g = (uint) (getGroup(hash));
211         return groups[g]; 
212     }
213     
214     function getGroup(string memory hash) public view returns(int){
215         return hashToGroup[hash];
216     }
217 }