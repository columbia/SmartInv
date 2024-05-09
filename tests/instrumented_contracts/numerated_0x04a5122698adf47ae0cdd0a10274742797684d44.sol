1 pragma solidity ^0.4.23;
2 /**
3  * @title Ownable
4  * @dev The Ownable contract has an owner address, and provides basic authorization control
5  * functions, this simplifies the implementation of "user permissions".
6  */
7 contract Ownable {
8     address public owner;
9     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
10 
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15     constructor() public {
16         owner = msg.sender;
17     }
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22     modifier onlyOwner() {
23         require(msg.sender == owner);
24         _;
25     }
26 
27   /**
28    * @dev Allows the current owner to transfer control of the contract to a newOwner.
29    * @param newOwner The address to transfer ownership to.
30    */
31     function transferOwnership(address newOwner) public onlyOwner {
32         require(newOwner != address(0));
33         emit OwnershipTransferred(owner, newOwner);
34         owner = newOwner;
35     }
36 }
37 
38 /**
39  * @title SafeMath
40  * @dev Math operations with safety checks that throw on error
41  */
42 library SafeMath {
43 
44     /**
45     * @dev Multiplies two numbers, throws on overflow.
46     */
47     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48         if (a == 0) {
49             return 0;
50         }
51         uint256 c = a * b;
52         assert(c / a == b);
53         return c;
54     }
55 
56     /**
57     * @dev Integer division of two numbers, truncating the quotient.
58     */
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         // assert(b > 0); // Solidity automatically throws when dividing by 0
61         uint256 c = a / b;
62         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63         return c;
64     }
65 
66     /**
67     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
68     */
69     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70         assert(b <= a);
71         return a - b;
72     }
73 
74     /**
75     * @dev Adds two numbers, throws on overflow.
76     */
77     function add(uint256 a, uint256 b) internal pure returns (uint256) {
78         uint256 c = a + b;
79         assert(c >= a);
80         return c;
81     }
82 }
83 /**
84  * @title SafeMath32
85  * @dev SafeMath library implemented for uint32
86  */
87 library SafeMath32 {
88 
89     function mul(uint32 a, uint32 b) internal pure returns (uint32) {
90         if (a == 0) {
91             return 0;
92        }
93         uint32 c = a * b;
94         assert(c / a == b);
95         return c;
96     }
97 
98     function div(uint32 a, uint32 b) internal pure returns (uint32) {
99         // assert(b > 0); // Solidity automatically throws when dividing by 0
100         uint32 c = a / b;
101         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
102         return c;
103     }
104 
105     function sub(uint32 a, uint32 b) internal pure returns (uint32) {
106         assert(b <= a);
107         return a - b;
108     }
109 
110     function add(uint32 a, uint32 b) internal pure returns (uint32) {
111         uint32 c = a + b;
112         assert(c >= a);
113         return c;
114     }
115 }
116 
117 /**
118  * @title SafeMath16
119  * @dev SafeMath library implemented for uint16
120  */
121 library SafeMath16 {
122 
123     function mul(uint16 a, uint16 b) internal pure returns (uint16) {
124         if (a == 0) {
125             return 0;
126         }
127         uint16 c = a * b;
128         assert(c / a == b);
129         return c;
130     }
131 
132     function div(uint16 a, uint16 b) internal pure returns (uint16) {
133         // assert(b > 0); // Solidity automatically throws when dividing by 0
134         uint16 c = a / b;
135         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
136         return c;
137     }
138 
139     function sub(uint16 a, uint16 b) internal pure returns (uint16) {
140         assert(b <= a);
141         return a - b;
142     }
143 
144     function add(uint16 a, uint16 b) internal pure returns (uint16) {
145         uint16 c = a + b;
146         assert(c >= a);
147         return c;
148     }
149 }
150 contract StudentFactory is Ownable{
151 
152     struct Student{
153         string name;// 姓名
154         string nation;// 民族
155         string id;// 证件号
156         uint32 birth;// 生日
157         bytes1 gender;// 性别
158     } 
159     
160     struct Undergraduate{
161         string studentId; // 学籍号
162         string school;// 学校 
163         string major;// 专业
164         uint8 length;// 学制
165         uint8 eduType;// 学历类别
166         uint8 eduForm;// 学习形式
167         uint8 class;// 班级
168         uint8 level;// 层次(专/本/硕/博)
169         uint8 state;// 学籍状态
170         uint32 admissionDate;// 入学日期
171         uint32 departureDate;// 离校日期
172     }
173 
174     struct Master{
175         string studentId; // 学籍号
176         string school;// 学校 
177         string major;// 专业
178         uint8 length;// 学制
179         uint8 eduType;// 学历类别
180         uint8 eduForm;// 学习形式
181         uint8 class;// 班级
182         uint8 level;// 层次(专/本/硕/博)
183         uint8 state;// 学籍状态
184         uint32 admissionDate;// 入学日期
185         uint32 departureDate;// 离校日期
186     }
187 
188     struct Doctor{
189         string studentId; // 学籍号
190         string school;// 学校 
191         string major;// 专业
192         uint8 length;// 学制
193         uint8 eduType;// 学历类别
194         uint8 eduForm;// 学习形式
195         uint8 class;// 班级
196         uint8 level;// 层次(专/本/硕/博)
197         uint8 state;// 学籍状态
198         uint32 admissionDate;// 入学日期
199         uint32 departureDate;// 离校日期
200     }
201 
202     struct CET4{
203         uint32 time; //时间，如2017年12月
204         uint32 grade;// 分数
205     }
206 
207     struct CET6{
208         uint32 time; //时间，如2017年12月
209         uint32 grade;// 分数
210     }
211 
212     Student[] students;// 学生列表
213     CET4[] CET4List; // 四级成绩列表
214     CET6[] CET6List; // 六级成绩列表
215     mapping (address=>Student) public addrToStudent;// 地址到学生的映射
216     mapping (uint=>address) internal CET4IndexToAddr; // 四级成绩序号到地址的映射
217     mapping (uint=>address) internal CET6IndexToAddr; // 六级成绩序号到地址的映射
218     mapping (address=>uint) public addrCET4Count; //地址到四级成绩数量映射
219     mapping (address=>uint) public addrCET6Count; //地址到六级成绩数量映射
220     mapping (address=>Undergraduate) public addrToUndergaduate;// 地址到本科学籍的映射
221     mapping (address=>Master) public addrToMaster;// 地址到硕士学籍的映射
222     mapping (address=>Doctor) public addrToDoctor;// 地址到博士学籍的映射
223    
224     // 定义判断身份证是否被使用的modifier
225     modifier availableIdOf(string _id) {
226         require(_isIdExisted(_id));
227         _;
228     }
229 
230     // 判断证件号码是否已注册
231     function _isIdExisted(string _id) private view returns(bool){
232         for(uint i = 0;i<students.length;i++){
233             if(keccak256(students[i].id)==keccak256(_id)){
234                 return false;
235             }
236         }
237         return true;
238     }
239 
240     // 创建学生
241     function createStudent(string _name,string _nation,string _id,uint32 _birth,bytes1 _gender) public availableIdOf(_id){
242         Student memory student = Student(_name,_nation,_id,_birth,_gender);
243         addrToStudent[msg.sender] = student;
244         students.push(student);
245     }
246 }
247 contract StudentHelper is StudentFactory{
248     using SafeMath for uint;
249     // 给某个地址的人添加本科学籍信息
250     function addUndergraduateTo(address _addr,string _studentId,string _school,string _major,uint8 _length,uint8 _eduType,uint8 _eduForm,uint8 _class,uint8 _level,uint8 _state,uint32 _admissionDate,uint32 _departureDate) 
251     public onlyOwner{
252         addrToUndergaduate[_addr] = Undergraduate(_studentId,_school,_major,_length,_eduType,_eduForm,_class,_level,_state,_admissionDate,_departureDate);
253     }
254 
255     // 给某个地址的人添加硕士学籍信息
256     function addMasterTo(address _addr,string _studentId,string _school,string _major,uint8 _length,uint8 _eduType,uint8 _eduForm,uint8 _class,uint8 _level,uint8 _state,uint32 _admissionDate,uint32 _departureDate) 
257     public onlyOwner{
258         addrToMaster[_addr] = Master(_studentId,_school,_major,_length,_eduType,_eduForm,_class,_level,_state,_admissionDate,_departureDate);
259     }
260 
261     // 给某个地址的人添加博士学籍信息
262     function addDoctorTo(address _addr,string _studentId,string _school,string _major,uint8 _length,uint8 _eduType,uint8 _eduForm,uint8 _class,uint8 _level,uint8 _state,uint32 _admissionDate,uint32 _departureDate) 
263     public onlyOwner{
264         addrToDoctor[_addr] = Doctor(_studentId,_school,_major,_length,_eduType,_eduForm,_class,_level,_state,_admissionDate,_departureDate);
265     }
266 
267     // 给某个地址添加四级成绩记录
268     function addCET4To(address _addr,uint32 _time,uint32 _grade) public onlyOwner{
269         uint index = CET4List.push(CET4(_time,_grade))-1;
270         CET4IndexToAddr[index] = _addr;
271         addrCET4Count[_addr]++;
272     }
273 
274     // 给某个地址添加六级成绩记录
275     function addCET6To(address _addr,uint32 _time,uint32 _grade) public onlyOwner{
276         uint index = CET6List.push(CET6(_time,_grade))-1;
277         CET6IndexToAddr[index] = _addr;
278         addrCET6Count[_addr]++;
279     }
280 
281     // 获得某个地址的四级成绩
282     function getCET4ByAddr(address _addr) view public returns (uint32[],uint32[]) {
283         uint32[] memory timeList = new uint32[](addrCET4Count[_addr]); 
284         uint32[] memory gradeList = new uint32[](addrCET4Count[_addr]);
285         uint counter = 0;    
286         for (uint i = 0; i < CET4List.length; i++) {
287             if(CET4IndexToAddr[i]==_addr){
288                 timeList[counter] = CET4List[i].time;
289                 gradeList[counter] = CET4List[i].grade;
290                 counter++;
291             }
292         }
293         return(timeList,gradeList);
294     }
295 
296     // 获得某个地址的六级成绩
297     function getCET6ByAddr(address _addr) view public returns (uint32[],uint32[]) {
298         uint32[] memory timeList = new uint32[](addrCET6Count[_addr]); 
299         uint32[] memory gradeList = new uint32[](addrCET6Count[_addr]);
300         uint counter = 0;    
301         for (uint i = 0; i < CET6List.length; i++) {
302             if(CET6IndexToAddr[i]==_addr){
303                 timeList[counter] = CET6List[i].time;
304                 gradeList[counter] = CET6List[i].grade;
305                 counter++;
306             }
307         }
308         return(timeList,gradeList);
309     }
310 }