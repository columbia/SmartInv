1 pragma solidity ^0.4.19;
2 /*
3 Name: Genesis
4 Dev: White Matrix co,. Ltd
5 */
6 
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     /**
32     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 contract Genesis {
50     using SafeMath for uint256;
51 
52     //mutabilityType
53     //Genesis parameter
54     uint public characterNo = 3;
55     uint public version = 1;
56 
57     struct Character {
58         string name;
59         uint hp;
60         uint mp;
61         uint str;
62         uint intelli;
63         uint san;
64         uint luck;
65         uint charm;
66         uint mt;
67         string optionalAttrs;
68     }
69 
70     Character[] characters;
71 
72     function Genesis() public {
73         characters.push(Character("Adam0", 100, 100, 50, 50, 50, 50, 50, 0, ""));
74         characters.push(Character("Adam1", 100, 100, 50, 50, 50, 50, 50, 1, ""));
75         characters.push(Character("Adam2", 100, 100, 50, 50, 50, 50, 50, 2, ""));
76     }
77 
78     function getCharacterNo() view returns (uint _characterNo){
79         return characterNo;
80     }
81 
82     function setCharacterAttributes(uint _id, uint _hp, uint _mp, uint _str, uint _intelli, uint _san, uint _luck, uint _charm, string _optionalAttrs){
83         //require check
84         require(characters[_id].mt == 2);
85         //read directly from mem
86         Character affectedCharacter = characters[_id];
87 
88         affectedCharacter.hp = _hp;
89         affectedCharacter.mp = _mp;
90         affectedCharacter.str = _str;
91         affectedCharacter.intelli = _intelli;
92         affectedCharacter.san = _san;
93         affectedCharacter.luck = _luck;
94         affectedCharacter.charm = _charm;
95         affectedCharacter.optionalAttrs = _optionalAttrs;
96 
97         //need rewrite as a function
98         if (affectedCharacter.hp < 0) {
99             affectedCharacter.hp = 0;
100         } else if (affectedCharacter.hp > 100) {
101             affectedCharacter.hp = 100;
102 
103         } else if (affectedCharacter.mp < 0) {
104             affectedCharacter.mp = 0;
105 
106         } else if (affectedCharacter.mp > 100) {
107             affectedCharacter.mp = 100;
108 
109         } else if (affectedCharacter.str < 0) {
110             affectedCharacter.str = 0;
111 
112         } else if (affectedCharacter.str > 100) {
113             affectedCharacter.str = 100;
114 
115         } else if (affectedCharacter.intelli < 0) {
116             affectedCharacter.intelli = 0;
117 
118         } else if (affectedCharacter.intelli > 100) {
119             affectedCharacter.intelli = 100;
120 
121         } else if (affectedCharacter.san < 0) {
122             affectedCharacter.san = 0;
123 
124         } else if (affectedCharacter.san > 100) {
125             affectedCharacter.san = 100;
126 
127         } else if (affectedCharacter.luck < 0) {
128             affectedCharacter.luck = 0;
129 
130         } else if (affectedCharacter.luck > 100) {
131             affectedCharacter.luck = 100;
132 
133         } else if (affectedCharacter.charm < 0) {
134             affectedCharacter.charm = 0;
135 
136         } else if (affectedCharacter.charm > 100) {
137             affectedCharacter.charm = 100;
138         }
139 
140         characters[_id] = affectedCharacter;
141     }
142 
143     function affectCharacter(uint _id, uint isPositiveEffect){
144         require(characters[_id].mt != 0);
145         Character affectedCharacter = characters[_id];
146         if (isPositiveEffect == 0) {
147             affectedCharacter.hp = affectedCharacter.hp - getRand();
148             affectedCharacter.mp = affectedCharacter.mp - getRand();
149             affectedCharacter.str = affectedCharacter.str - getRand();
150             affectedCharacter.intelli = affectedCharacter.intelli - getRand();
151             affectedCharacter.san = affectedCharacter.san - getRand();
152             affectedCharacter.luck = affectedCharacter.luck - getRand();
153             affectedCharacter.charm = affectedCharacter.charm - getRand();
154         } else if (isPositiveEffect == 1) {
155             affectedCharacter.hp = affectedCharacter.hp + getRand();
156             affectedCharacter.mp = affectedCharacter.mp + getRand();
157             affectedCharacter.str = affectedCharacter.str + getRand();
158             affectedCharacter.intelli = affectedCharacter.intelli + getRand();
159             affectedCharacter.san = affectedCharacter.san + getRand();
160             affectedCharacter.luck = affectedCharacter.luck + getRand();
161             affectedCharacter.charm = affectedCharacter.charm + getRand();
162         }
163         //need rewrite as a function
164         if (affectedCharacter.hp < 0) {
165             affectedCharacter.hp = 0;
166         } else if (affectedCharacter.hp > 100) {
167             affectedCharacter.hp = 100;
168 
169         } else if (affectedCharacter.mp < 0) {
170             affectedCharacter.mp = 0;
171 
172         } else if (affectedCharacter.mp > 100) {
173             affectedCharacter.mp = 100;
174 
175         } else if (affectedCharacter.str < 0) {
176             affectedCharacter.str = 0;
177 
178         } else if (affectedCharacter.str > 100) {
179             affectedCharacter.str = 100;
180 
181         } else if (affectedCharacter.intelli < 0) {
182             affectedCharacter.intelli = 0;
183 
184         } else if (affectedCharacter.intelli > 100) {
185             affectedCharacter.intelli = 100;
186 
187         } else if (affectedCharacter.san < 0) {
188             affectedCharacter.san = 0;
189 
190         } else if (affectedCharacter.san > 100) {
191             affectedCharacter.san = 100;
192 
193         } else if (affectedCharacter.luck < 0) {
194             affectedCharacter.luck = 0;
195 
196         } else if (affectedCharacter.luck > 100) {
197             affectedCharacter.luck = 100;
198 
199         } else if (affectedCharacter.charm < 0) {
200             affectedCharacter.charm = 0;
201 
202         } else if (affectedCharacter.charm > 100) {
203             affectedCharacter.charm = 100;
204         }
205 
206         characters[_id] = affectedCharacter;
207     }
208 
209 
210     function getRand() public view returns (uint256 _rand){
211         uint256 rand = uint256(sha256(block.timestamp, block.number - rand - 1)) % 10 + 1;
212         return rand;
213     }
214 
215     function insertCharacter(string _name, uint _hp, uint _mp, uint _str, uint _intelli, uint _san, uint _luck, uint _charm, uint _mt, string _optionalAttrs) returns (uint){
216         require(checkLegal(_hp, _mp, _str, _intelli, _san, _luck, _charm, _mt) == 1);
217         //需要check合法性
218         characterNo++;
219         characters.push(Character(_name, _hp, _mp, _str, _intelli, _san, _luck, _charm, _mt, _optionalAttrs));
220 
221         return characterNo;
222     }
223 
224     function checkLegal(uint _hp, uint _mp, uint _str, uint _intelli, uint _san, uint _luck, uint _charm, uint _mt) returns (uint _checkresult){
225         if ((_hp < 0) || (_hp > 9999)) {
226             return 0;
227         } else if ((_mp < 0) || (_mp > 9999)) {
228             return 0;
229         } else if ((_str < 0) || (_str > 9999)) {
230             return 0;
231         } else if ((_intelli < 0) || (_intelli > 9999)) {
232             return 0;
233         } else if ((_san < 0) || (_san > 9999)) {
234             return 0;
235         } else if ((_luck < 0) || (_luck > 9999)) {
236             return 0;
237         } else if ((_charm < 0) || (_charm > 9999)) {
238             return 0;
239         } else if ((_mt < 0) || (_mt > 2)) {
240             return 0;
241         }
242         return 1;
243     }
244 
245     // This function will return all of the details of the characters
246     function getCharacterDetails(uint _characterId) public view returns (
247         string _name,
248         uint _hp,
249         uint _mp,
250         uint _str,
251         uint _int,
252         uint _san,
253         uint _luck,
254         uint _charm,
255         uint _mt,
256         string _optionalAttrs
257     ) {
258 
259         Character storage _characterInfo = characters[_characterId];
260 
261         _name = _characterInfo.name;
262         _hp = _characterInfo.hp;
263         _mp = _characterInfo.mp;
264         _str = _characterInfo.str;
265         _int = _characterInfo.intelli;
266         _san = _characterInfo.san;
267         _luck = _characterInfo.luck;
268         _charm = _characterInfo.charm;
269         _mt = _characterInfo.mt;
270         _optionalAttrs = _characterInfo.optionalAttrs;
271     }
272 }