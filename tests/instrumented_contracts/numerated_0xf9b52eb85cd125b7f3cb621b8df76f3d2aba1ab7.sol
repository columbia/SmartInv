1 pragma solidity ^0.4.4;
2 
3 contract BlockSpeech {
4 
5     event Keynote(address indexed _from, uint _speech_id, string _speech_title);
6     event Like(address indexed _from, address _addr, uint _speech_id);
7     event Reward(address indexed _from, address _addr, uint _speech_id, uint _value);
8 
9     struct Speech {
10         uint speech_id;
11         uint speech_type; // 1, for TA; 2, for the world
12         string speech_title;
13         string speech_content;
14         uint likes;
15         uint reward;
16         mapping(address=>uint) reward_detail;
17         mapping(address=>bool) is_like;
18     }
19 
20     mapping (address => mapping (uint => Speech)) _speeches;
21     mapping (address => uint[]) _speech_list;
22     address[] _writers;
23     mapping(address=>uint) _writer_num;
24     uint[] _speech_num;
25     uint _speech_total_likes;
26     mapping(address=>uint) _total_likes;
27     mapping(address=>uint) _total_reward;
28 
29     mapping(uint=>address[]) _like_addrs;
30     mapping(uint=>address[]) _reward_addrs;
31 
32     uint public DEV_TAX_DIVISOR;
33     address public blockAppAddr;
34 
35     function BlockSpeech(uint _tax_rate) public {
36         blockAppAddr = msg.sender;
37         DEV_TAX_DIVISOR = _tax_rate;
38     }
39 
40     function keynote(uint _speech_id, uint _speech_type, string _speech_title, string _speech_content) public returns(bool) {
41 
42         require(_speech_id > 0);
43         require(bytes(_speech_title).length > 0);
44         require(bytes(_speech_content).length > 0);
45 
46         if(_writer_num[msg.sender] == 0) {
47             uint num = _writers.length++;
48             _writers[num] = msg.sender;
49             _writer_num[msg.sender] = num;
50         }
51 
52         Speech memory speech = Speech(_speech_id, _speech_type, _speech_title, _speech_content, 0, 0);
53 
54         _speeches[msg.sender][_speech_id] = speech;
55         _speech_list[msg.sender][_speech_list[msg.sender].length++] = _speech_id;
56 
57         _speech_num[_speech_num.length++] = _speech_num.length++;
58 
59         emit Keynote(msg.sender, _speech_id, _speech_title);
60         return true;
61     }
62 
63     function like(address _addr, uint _speech_id) public returns(bool) {
64         require(_speech_id > 0);
65         require(_addr != address(0));
66 
67         Speech storage speech = _speeches[_addr][_speech_id];
68         require(speech.speech_id > 0);
69         require(!speech.is_like[msg.sender]);
70 
71         speech.is_like[msg.sender] = true;
72         speech.likes++;
73 
74         _like_addrs[_speech_id][_like_addrs[_speech_id].length++] = msg.sender;
75         _total_likes[_addr] = SafeMath.add(_total_likes[_addr], 1);
76         _speech_total_likes = SafeMath.add(_speech_total_likes, 1);
77 
78         emit Like(msg.sender, _addr, _speech_id);
79         return true;
80     }
81 
82     function reward(address _addr, uint _speech_id) public payable returns(bool) {
83         require(_speech_id > 0);
84         require(_addr != address(0));
85         require(msg.value > 0);
86 
87         Speech storage speech = _speeches[_addr][_speech_id];
88         require(speech.speech_id > 0);
89 
90         speech.reward = SafeMath.add(speech.reward, msg.value);
91         _reward_addrs[_speech_id][_reward_addrs[_speech_id].length++] = msg.sender;
92         _total_reward[_addr] = SafeMath.add(_total_reward[_addr], msg.value);
93 
94         uint devTax = SafeMath.div(msg.value, DEV_TAX_DIVISOR);
95         uint finalValue = SafeMath.sub(msg.value, devTax);
96 
97         assert(finalValue>0 && devTax>0);
98 
99         blockAppAddr.transfer(devTax);
100         _addr.transfer(finalValue);
101 
102         emit Reward(msg.sender, _addr, _speech_id, msg.value);
103         return true;
104     }
105 
106     function getMySpeechList() public constant returns (uint[] speech_list, uint[] speech_rewards, uint[] speech_likes, bool[] is_likes){
107 
108         speech_rewards = new uint[](_speech_list[msg.sender].length);
109         speech_likes = new uint[](_speech_list[msg.sender].length);
110         is_likes = new bool[](_speech_list[msg.sender].length);
111 
112         for(uint i=0; i<_speech_list[msg.sender].length; i++) {
113             Speech storage speech = _speeches[msg.sender][_speech_list[msg.sender][i]];
114             speech_rewards[i] = speech.reward;
115             speech_likes[i] = speech.likes;
116             is_likes[i] = speech.is_like[msg.sender];
117         }
118 
119         return (_speech_list[msg.sender], speech_rewards, speech_likes, is_likes);
120     }
121 
122     function getMySpeechList(address _addr) public constant returns (uint[] speech_list, uint[] speech_rewards, uint[] speech_likes, bool[] is_likes, uint[] speech_types){
123         require(_addr != address(0));
124 
125         speech_types = new uint[](_speech_list[_addr].length);
126         speech_rewards = new uint[](_speech_list[_addr].length);
127         speech_likes = new uint[](_speech_list[_addr].length);
128         is_likes = new bool[](_speech_list[_addr].length);
129 
130         for(uint i=0; i<_speech_list[_addr].length; i++) {
131             Speech storage speech = _speeches[_addr][_speech_list[_addr][i]];
132             speech_types[i] = speech.speech_type;
133             speech_rewards[i] = speech.reward;
134             speech_likes[i] = speech.likes;
135             is_likes[i] = speech.is_like[_addr];
136         }
137 
138         return (_speech_list[_addr], speech_rewards, speech_likes, is_likes, speech_types);
139     }
140 
141     function getMySpeech(uint _speech_id) public constant returns (uint speech_type, string speech_title, string speech_content, uint likes, uint rewards){
142         require(_speech_id > 0);
143 
144         Speech storage speech = _speeches[msg.sender][_speech_id];
145         assert(speech.speech_id > 0);
146 
147         return (speech.speech_type, speech.speech_title, speech.speech_content, speech.likes, speech.reward);
148     }
149 
150     function getMySpeech(uint _speech_id, address _addr) public constant returns (uint speech_type, string speech_title, string speech_content, uint likes, uint rewards){
151         require(_speech_id > 0);
152 
153         Speech storage speech = _speeches[_addr][_speech_id];
154         assert(speech.speech_id > 0);
155 
156         return (speech.speech_type, speech.speech_title, speech.speech_content, speech.likes, speech.reward);
157     }
158 
159     function getMe() public constant returns (uint num_writer, uint num_speech, uint total_likes, uint total_reward) {
160         return (_writer_num[msg.sender], _speech_list[msg.sender].length, _total_likes[msg.sender], _total_reward[msg.sender]);
161     }
162 
163     function getWriter(address _addr) public constant returns (uint num_writer, uint num_speech, uint total_likes, uint total_reward) {
164         require(_addr != address(0));
165         return (_writer_num[_addr], _speech_list[_addr].length, _total_likes[_addr], _total_reward[_addr]);
166     }
167 
168     function getWriter(address[] _addrs) public constant returns (uint[] num_writer, uint[] num_speech, uint[] total_likes, uint[] total_reward) {
169 
170         for(uint i=0; i<_addrs.length; i++) {
171             num_writer[i] = _writer_num[_addrs[i]];
172             num_speech[i] = _speech_list[_addrs[i]].length;
173             total_likes[i] = _total_likes[_addrs[i]];
174             total_reward[i] = _total_reward[_addrs[i]];
175         }
176         return (num_writer, num_speech, total_likes, total_reward);
177     }
178 
179     function getBlockSpeech() public constant returns (uint num_writers, uint num_speechs, uint speech_total_likes) {
180         return (_writers.length, _speech_num.length, _speech_total_likes);
181     }
182 
183 }
184 
185 library SafeMath {
186 
187     /**
188     * @dev Multiplies two numbers, throws on overflow.
189     */
190     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
191         if (a == 0) {
192             return 0;
193         }
194         uint256 c = a * b;
195         assert(c / a == b);
196         return c;
197     }
198 
199     /**
200     * @dev Integer division of two numbers, truncating the quotient.
201     */
202     function div(uint256 a, uint256 b) internal pure returns (uint256) {
203         assert(b > 0); // Solidity automatically throws when dividing by 0
204         uint256 c = a / b;
205         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
206         return c;
207     }
208 
209     /**
210     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
211     */
212     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
213         assert(b <= a);
214         return a - b;
215     }
216 
217     /**
218     * @dev Adds two numbers, throws on overflow.
219     */
220     function add(uint256 a, uint256 b) internal pure returns (uint256) {
221         uint256 c = a + b;
222         assert(c >= a);
223         return c;
224     }
225 
226     function isInArray(uint a, uint[] b) internal pure returns (bool) {
227 
228         for(uint i = 0; i < b.length; i++) {
229             if(b[i] == a) return true;
230         }
231 
232         return false;
233     }
234 }