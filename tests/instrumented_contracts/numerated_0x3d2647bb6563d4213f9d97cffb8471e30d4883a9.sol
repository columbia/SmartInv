1 pragma solidity ^0.5.1;
2 contract Operations {
3     function copyBytesNToBytes(bytes32 source, bytes memory destination, uint[1] memory pointer) internal pure {
4         for (uint i=0; i < 32; i++) {
5             if (source[i] == 0)
6                 break;
7             else {
8                 destination[pointer[0]]=source[i];
9                 pointer[0]++;
10             }
11         }
12     }
13     function copyBytesToBytes(bytes memory source, bytes memory destination, uint[1] memory pointer) internal pure {
14         for (uint i=0; i < source.length; i++) {
15             destination[pointer[0]]=source[i];
16             pointer[0]++;
17         }
18     }
19     function uintToBytesN(uint v) internal pure returns (bytes32 ret) {
20         if (v == 0) {
21             ret = '0';
22         }
23         else {
24             while (v > 0) {
25 //                ret = bytes32(uint(ret) / (2 ** 8));
26 //                ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
27                 ret = bytes32(uint(ret) >> 8);
28                 ret |= bytes32(((v % 10) + 48) << (8 * 31));
29                 v /= 10;
30             }
31         }
32         return ret;
33     }
34     function stringToBytes32(string memory str) internal pure returns(bytes32) {
35         bytes32 bStrN;
36         assembly {
37             bStrN := mload(add(str, 32))
38         }
39         return(bStrN);
40     }
41 }
42 contract DataRegister is Operations {
43     bytes32 Institute; 
44     address owner;
45     mapping(bytes10 => bytes) Instructor;
46     mapping(uint => bytes10) InstructorUIds;
47     uint InstructorCount = 0;
48     struct course {
49 //        bytes10 CourseNumber;
50         bytes CourseName;
51         bytes10 StartDate;
52         bytes10 EndDate;
53         uint Hours;
54         uint InstructorId;
55     }
56     mapping(bytes10 => course) Course;
57     mapping(uint => bytes10) CourseUIds;
58     uint CourseCount = 0;
59     struct student {
60         bytes Name;
61         bytes10 NationalId;
62     }
63     mapping(bytes10 => student) Student;
64     mapping(uint => bytes10) StudentUIds;
65     uint StudentCount = 0;
66     struct certificate {
67         uint CourseId;
68         uint StudentId;
69         uint CertificateType;
70         bytes10 Result;
71         bool Enabled;
72     }
73     mapping(bytes10 => certificate) Certificate;
74     uint CertificateCount = 0;
75     mapping(uint => bytes10) CertificateUIds;
76     modifier onlyOwner() {
77         require(msg.sender==owner);
78         _;
79     }
80     modifier notEmpty(string memory str) {
81         bytes memory bStr = bytes(str);
82         require(bStr.length > 0);
83         _;
84     }
85     modifier isPositive(uint number) {
86         require(number > 0);
87         _;
88     }
89     modifier haveInstructor(uint InstructorId) {
90         require(Instructor[InstructorUIds[InstructorId]].length > 0);
91         _;
92     }
93     modifier haveCourse(uint CourseId) {
94         require(CourseUIds[CourseId].length > 0);
95         _;
96     }
97     modifier haveStudent(uint StudentId) {
98         require(Student[StudentUIds[StudentId]].Name.length > 0);
99         _;
100     }
101     modifier uniqueCertificateUId(string memory certificateUId) {
102         require(Certificate[bytes10(stringToBytes32(certificateUId))].CourseId == 0);
103         _;
104     }
105     modifier uniqueInstructorUId(string memory _instructorUId) {
106         require(Instructor[bytes10(stringToBytes32(_instructorUId))].length == 0);
107         _;
108     }
109     modifier uniqueCourseUId(string memory _courseUId) {
110         require(Course[bytes10(stringToBytes32(_courseUId))].CourseName.length == 0);
111         _;
112     }
113     modifier uniqueStudentUId(string memory _studentUId) {
114         require(Student[bytes10(stringToBytes32(_studentUId))].Name.length == 0);
115         _;
116     }
117     function RegisterInstructor(
118         string memory instructorUId, 
119         string memory instructor
120         ) public onlyOwner notEmpty(instructorUId) notEmpty(instructor) uniqueInstructorUId(instructorUId) returns(bool) {
121             bytes10 _instructorUId = bytes10(stringToBytes32(instructorUId));
122             InstructorCount++;
123             Instructor[_instructorUId] = bytes(instructor);
124             InstructorUIds[InstructorCount]=_instructorUId;
125             return(true);
126     }
127     function RegisterCourse(
128         string memory CourseUId,
129         string memory CourseName,
130         string memory StartDate,
131         string memory EndDate,
132         uint Hours,
133         uint InstructorId
134         ) public onlyOwner notEmpty(CourseUId) notEmpty(CourseName) 
135             isPositive(Hours) haveInstructor(InstructorId) uniqueCourseUId(CourseUId) {
136             course memory _course = setCourseElements(CourseName, StartDate, EndDate, Hours, InstructorId);
137             CourseCount++;
138             bytes10 _courseUId = bytes10(stringToBytes32(CourseUId));
139             CourseUIds[CourseCount] = _courseUId;
140             Course[_courseUId] = _course;
141     }
142     function setCourseElements(
143         string memory CourseName, 
144         string memory StartDate, 
145         string memory EndDate,
146         uint Hours,
147         uint InstructorId
148         ) internal pure returns(course memory) {
149         course memory _course;
150         _course.CourseName = bytes(CourseName);
151         _course.StartDate = bytes10(stringToBytes32(StartDate));
152         _course.EndDate = bytes10(stringToBytes32(EndDate));
153         _course.Hours = Hours;
154         _course.InstructorId = InstructorId;
155         return(_course);
156     }
157     function RegisterStudent(
158         string memory StudentUId,
159         string memory Name,
160         string memory NationalId
161         ) public onlyOwner notEmpty(Name) notEmpty(NationalId) notEmpty(StudentUId) uniqueStudentUId(StudentUId) returns(bool) {
162             StudentCount++;
163             StudentUIds[StudentCount] = bytes10(stringToBytes32(StudentUId));
164             student memory _student;
165             _student.Name = bytes(Name);
166             _student.NationalId = bytes10(stringToBytes32(NationalId));
167             Student[StudentUIds[StudentCount]]=_student;
168         return(true);
169     }
170     function RegisterCertificate(
171         string memory CertificateUId,
172         uint CourseId,
173         uint StudentId,
174         uint CertificateType,
175         string memory Result
176         ) public onlyOwner haveStudent(StudentId) haveCourse(CourseId) 
177         uniqueCertificateUId(CertificateUId) isPositive(CertificateType) returns(bool) {
178             certificate memory _certificate;
179             _certificate.CourseId = CourseId;
180             _certificate.StudentId = StudentId;
181             _certificate.CertificateType = CertificateType;
182             _certificate.Result = bytes10(stringToBytes32(Result));
183             _certificate.Enabled = true;
184             bytes10 cert_uid = bytes10(stringToBytes32(CertificateUId));
185             CertificateCount++;
186             Certificate[cert_uid] = _certificate;
187             CertificateUIds[CertificateCount] = cert_uid;
188             return(true);
189     }
190     function EnableCertificate(string memory CertificateId) public onlyOwner notEmpty(CertificateId) returns(bool) {
191         bytes10 _certificateId = bytes10(stringToBytes32(CertificateId));
192         certificate memory _certificate = Certificate[_certificateId];
193         require(_certificate.Result != '');
194         require(! _certificate.Enabled);
195         Certificate[_certificateId].Enabled = true;
196         return(true);
197     }
198     function DisableCertificate(string memory CertificateId) public onlyOwner notEmpty(CertificateId) returns(bool) {
199         bytes10 _certificateId = bytes10(stringToBytes32(CertificateId));
200         certificate memory _certificate = Certificate[_certificateId];
201         require(_certificate.Result != '');
202         require(_certificate.Enabled);
203         Certificate[_certificateId].Enabled = false;
204         return(true);
205     }
206 }
207 contract CryptoClassCertificate is DataRegister {
208     constructor(string memory _Institute) public notEmpty(_Institute) {
209         owner = msg.sender;
210         Institute = stringToBytes32(_Institute);
211     }
212     function GetInstitute() public view returns(string  memory) {
213         uint[1] memory pointer;
214         pointer[0]=0;
215         bytes memory institute=new bytes(48);
216         copyBytesToBytes('{"Institute":"', institute, pointer);
217         copyBytesNToBytes(Institute, institute, pointer);
218         copyBytesToBytes('"}', institute, pointer);
219         return(string(institute));
220     }
221     function GetInstructors() public view onlyOwner returns(string memory) {
222         uint len = 30;
223         uint i;
224         for (i=1 ; i <= InstructorCount ; i++) 
225             len += 30 + Instructor[InstructorUIds[i]].length;
226         bytes memory instructors = new bytes(len);
227         uint[1] memory pointer;
228         pointer[0]=0;
229         copyBytesNToBytes('{ "Instructors":[', instructors, pointer);
230         for (i=1 ; i <= InstructorCount ; i++) {
231             if (i > 1) 
232                 copyBytesNToBytes(',', instructors, pointer);
233             copyBytesNToBytes('{"Id":"', instructors, pointer);
234             copyBytesNToBytes(InstructorUIds[i], instructors, pointer);
235             copyBytesNToBytes('","Name":"', instructors, pointer);
236             copyBytesToBytes(Instructor[InstructorUIds[i]], instructors, pointer);
237             copyBytesNToBytes('"}', instructors, pointer);
238         }
239         copyBytesNToBytes(']}', instructors, pointer);
240         return(string(instructors));
241     }
242     function GetInstructor(string memory InstructorUId) public view notEmpty(InstructorUId) returns(string memory) {
243         bytes10 _instructorId = bytes10(stringToBytes32(InstructorUId));
244         require(Instructor[_instructorId].length > 0);
245         uint len = 30;
246         len += Instructor[_instructorId].length;
247         bytes memory _instructor = new bytes(len);
248         uint[1] memory pointer;
249         pointer[0]=0;
250         copyBytesNToBytes('{ "Instructor":"', _instructor, pointer);
251         copyBytesToBytes(Instructor[_instructorId], _instructor, pointer);
252         copyBytesNToBytes('"}', _instructor, pointer);
253         return(string(_instructor));
254     }
255     function GetInstructorCourses(string memory InstructorUId) public view notEmpty(InstructorUId) returns(string memory) {
256         bytes10 _instructorUId = bytes10(stringToBytes32(InstructorUId));
257         require(Instructor[_instructorUId].length > 0);
258         uint _instructorId = 0;
259         for (uint i = 1; i <= InstructorCount; i++)
260             if (InstructorUIds[i] == _instructorUId) {
261                 _instructorId = i;
262                 break;
263             }
264         uint len = 30;
265         course memory _course;
266         uint i;
267         for (i=1; i<=CourseCount; i++) {
268             if (Course[CourseUIds[i]].InstructorId == _instructorId) { 
269                 _course = Course[CourseUIds[i]];
270                 len += 180 + Institute.length + _course.CourseName.length + Instructor[InstructorUIds[_course.InstructorId]].length;
271             }
272         }
273         bytes memory courseInfo = new bytes(len);
274         uint[1] memory pointer;
275         pointer[0]=0;
276         copyBytesNToBytes('{"Courses":[', courseInfo, pointer);
277         bool first = true;
278         for (i=1; i<=CourseCount; i++) {
279             _course = Course[CourseUIds[i]];
280             if (_course.InstructorId == _instructorId) {
281                 if (first)
282                     first = false;
283                 else
284                     copyBytesNToBytes(',', courseInfo, pointer);
285                 copyBytesNToBytes('{"CourseId":"', courseInfo, pointer);
286                 copyBytesNToBytes(CourseUIds[i], courseInfo, pointer);
287                 copyBytesNToBytes('","CourseName":"', courseInfo, pointer);
288                 copyBytesToBytes(_course.CourseName, courseInfo, pointer);
289                 copyBytesNToBytes('","StartDate":"', courseInfo, pointer);
290                 copyBytesNToBytes(_course.StartDate, courseInfo, pointer);
291                 copyBytesNToBytes('","EndDate":"', courseInfo, pointer);
292                 copyBytesNToBytes(_course.EndDate, courseInfo, pointer);
293                 copyBytesNToBytes('","DurationHours":"', courseInfo, pointer);
294                 copyBytesNToBytes( uintToBytesN(_course.Hours), courseInfo, pointer);
295                 copyBytesNToBytes('"}', courseInfo, pointer);
296             }
297         }
298         copyBytesNToBytes(']}', courseInfo, pointer);
299         return(string(courseInfo));
300     }
301     function GetCourseInfo(string memory CourseUId) public view notEmpty(CourseUId) returns(string memory) {
302         bytes10 _courseUId=bytes10(stringToBytes32(CourseUId));
303         course memory _course;
304         _course = Course[_courseUId];
305         require(_course.CourseName.length > 0);
306         uint len = 110;
307         len += Institute.length + 10 + _course.CourseName.length + 10 + 10 + Instructor[InstructorUIds[_course.InstructorId]].length;
308         bytes memory courseInfo = new bytes(len);
309         uint[1] memory pointer;
310         pointer[0]=0;
311         copyBytesNToBytes('{"Course":', courseInfo, pointer);
312         copyBytesNToBytes('{"Issuer":"', courseInfo, pointer);
313         copyBytesNToBytes(Institute, courseInfo, pointer);
314         copyBytesNToBytes('","CourseUId":"', courseInfo, pointer);
315         copyBytesNToBytes(_courseUId, courseInfo, pointer);
316         copyBytesNToBytes('","CourseName":"', courseInfo, pointer);
317         copyBytesToBytes(_course.CourseName, courseInfo, pointer);
318         copyBytesNToBytes('","StartDate":"', courseInfo, pointer);
319         copyBytesNToBytes(_course.StartDate, courseInfo, pointer);
320         copyBytesNToBytes('","EndDate":"', courseInfo, pointer);
321         copyBytesNToBytes(_course.EndDate, courseInfo, pointer);
322         copyBytesNToBytes('","DurationHours":"', courseInfo, pointer);
323         copyBytesNToBytes( uintToBytesN(_course.Hours), courseInfo, pointer);
324         copyBytesNToBytes('"}}', courseInfo, pointer);
325         return(string(courseInfo));
326     }
327     function GetCourses() public view onlyOwner returns(string memory) {
328         uint len = 30;
329         uint i;
330         course memory _course;
331         for (i=1 ; i <= CourseCount ; i++) {
332             _course = Course[CourseUIds[i]];
333             len += 90 + 10 + _course.CourseName.length + 10 + 12 + 12 + 6 + Instructor[InstructorUIds[_course.InstructorId]].length;
334         }
335         bytes memory courses = new bytes(len);
336         uint[1] memory pointer;
337         pointer[0]=0;
338         bytes32 hrs;
339         copyBytesNToBytes('{"Courses":[', courses, pointer);
340         for (i=1 ; i <= CourseCount ; i++) {
341             if (i > 1)
342                 copyBytesNToBytes(',', courses, pointer);
343             _course = Course[CourseUIds[i]];
344             copyBytesNToBytes('{"UId":"', courses, pointer);
345             copyBytesNToBytes(CourseUIds[i], courses, pointer);
346             copyBytesNToBytes('","Name":"', courses, pointer);
347             copyBytesToBytes(_course.CourseName, courses, pointer);
348             copyBytesNToBytes('","InstructorId":"', courses, pointer);
349             copyBytesToBytes(Instructor[InstructorUIds[_course.InstructorId]], courses, pointer);
350             copyBytesNToBytes('","StartDate":"', courses, pointer);
351             copyBytesNToBytes(_course.StartDate, courses, pointer);
352             copyBytesNToBytes('","EndDate":"', courses, pointer);
353             copyBytesNToBytes(_course.EndDate, courses, pointer);
354             copyBytesNToBytes('","Duration":"', courses, pointer);
355             hrs = uintToBytesN(_course.Hours);
356             copyBytesNToBytes(hrs, courses, pointer);
357             copyBytesNToBytes(' Hours"}', courses, pointer);
358         }
359         copyBytesNToBytes(']}', courses, pointer);
360         return(string(courses));
361     }
362     function GetStudentInfo(string memory StudentUId) public view notEmpty(StudentUId) returns(string memory) {
363         bytes10 _studentUId=bytes10(stringToBytes32(StudentUId));
364         student memory _student;
365         _student = Student[_studentUId];
366         require(_student.Name.length > 0);
367         uint len = 110;
368         len += Institute.length + 10 + _student.Name.length + 10 ;
369         bytes memory studentInfo = new bytes(len);
370         uint[1] memory pointer;
371         pointer[0]=0;
372         copyBytesNToBytes('{"Student":', studentInfo, pointer);
373         copyBytesNToBytes('{"Issuer":"', studentInfo, pointer);
374         copyBytesNToBytes(Institute, studentInfo, pointer);
375         copyBytesNToBytes('","StudentUId":"', studentInfo, pointer);
376         copyBytesNToBytes(_studentUId, studentInfo, pointer);
377         copyBytesNToBytes('","Name":"', studentInfo, pointer);
378         copyBytesToBytes(_student.Name, studentInfo, pointer);
379         copyBytesNToBytes('","NationalId":"', studentInfo, pointer);
380         copyBytesNToBytes(_student.NationalId, studentInfo, pointer);
381         copyBytesNToBytes('"}}', studentInfo, pointer);
382         return(string(studentInfo));
383     }
384     function GetStudents() public view onlyOwner returns(string memory) {
385         uint len = 30;
386         uint i;
387         for (i=1 ; i <= StudentCount ; i++) 
388             len += 50 + 3 + Student[StudentUIds[i]].Name.length;
389         bytes memory students = new bytes(len);
390         uint[1] memory pointer;
391         pointer[0]=0;
392         copyBytesNToBytes('{"Students":[', students, pointer);
393         for (i=1 ; i <= StudentCount ; i++) {
394             if (i > 1)
395                 copyBytesNToBytes(',', students, pointer);
396             student memory _student = Student[StudentUIds[i]];
397             copyBytesNToBytes('{"UId":"', students, pointer);
398             copyBytesNToBytes(StudentUIds[i], students, pointer);
399             copyBytesNToBytes('","NationalId":"', students, pointer);
400             copyBytesNToBytes(_student.NationalId, students, pointer);
401             copyBytesNToBytes('","Name":"', students, pointer);
402             copyBytesToBytes(_student.Name, students, pointer);
403             copyBytesNToBytes('"}', students, pointer);
404         }
405         copyBytesNToBytes(']}', students, pointer);
406         return(string(students));
407     }
408     function GetCertificates() public view onlyOwner returns(string memory) {
409         uint len = 30;
410         uint i;
411         len += CertificateCount * 40;
412         bytes memory certificates = new bytes(len);
413         uint[1] memory pointer;
414         pointer[0]=0;
415         copyBytesNToBytes('{"Certificates":[', certificates, pointer);
416         for (i = 1 ; i <= CertificateCount ; i++) {
417             if (i > 1)
418                 copyBytesNToBytes(',', certificates, pointer);
419             copyBytesNToBytes('{"CertificateId":"', certificates, pointer);
420             copyBytesNToBytes(CertificateUIds[i], certificates, pointer);
421             copyBytesNToBytes('"}', certificates, pointer);
422         }
423         copyBytesNToBytes(']}', certificates, pointer);
424         return(string(certificates));
425     }
426     function GetCertificate(string memory CertificateId) public view notEmpty(CertificateId) returns(string memory) {
427         bytes memory certSpec;
428         uint len;
429         uint[1] memory pointer;
430         pointer[0] = 0;
431         bytes10 _certificateId = bytes10(stringToBytes32(CertificateId));
432         certificate memory _certificate = Certificate[_certificateId];
433         course memory _course = Course[CourseUIds[_certificate.CourseId]];
434         student memory _student = Student[StudentUIds[_certificate.StudentId]];
435         bytes memory _instructor = Instructor[InstructorUIds[_course.InstructorId]];
436         len = 500;
437         len += _course.CourseName.length + _instructor.length;
438         certSpec = new bytes(len);
439         require(_certificate.StudentId > 0);
440         require(_certificate.Enabled);
441         copyBytesNToBytes('{"Certificate":{"Issuer":"', certSpec, pointer);
442         copyBytesNToBytes(Institute, certSpec, pointer);
443         copyBytesNToBytes('","CertificateId":"', certSpec, pointer);
444         copyBytesNToBytes(_certificateId, certSpec, pointer);
445         copyBytesNToBytes('","Name":"', certSpec, pointer);
446         copyBytesToBytes(_student.Name, certSpec, pointer);
447         copyBytesNToBytes('","NationalId":"', certSpec, pointer);
448         copyBytesNToBytes( _student.NationalId, certSpec, pointer);
449         copyBytesNToBytes('","CourseId":"', certSpec, pointer);
450         copyBytesNToBytes(CourseUIds[_certificate.CourseId], certSpec, pointer);
451         copyBytesNToBytes('","CourseName":"', certSpec, pointer);
452         copyBytesToBytes(_course.CourseName, certSpec, pointer);
453         copyBytesNToBytes('","StartDate":"', certSpec, pointer);
454         copyBytesNToBytes(_course.StartDate, certSpec, pointer);
455         copyBytesNToBytes('","EndDate":"', certSpec, pointer);
456         copyBytesNToBytes(_course.EndDate, certSpec, pointer);
457         copyBytesNToBytes('","DurationHours":"', certSpec, pointer);
458         copyBytesNToBytes(uintToBytesN(_course.Hours), certSpec, pointer);
459         copyBytesNToBytes('","Instructor":"', certSpec, pointer);
460         copyBytesToBytes(_instructor, certSpec, pointer);
461         bytes10 _certType = GetCertificateTypeDescription(_certificate.CertificateType);
462         copyBytesNToBytes('","CourseType":"', certSpec, pointer);
463         copyBytesNToBytes(_certType, certSpec, pointer);
464         copyBytesNToBytes('","Result":"', certSpec, pointer);
465         copyBytesNToBytes(_certificate.Result, certSpec, pointer);
466         copyBytesNToBytes('"}}', certSpec, pointer);
467         return(string(certSpec));
468     }
469     function GetCertificateTypeDescription(uint Type) pure internal returns(bytes10) {
470         if (Type == 1) 
471             return('Attendance');
472         else if (Type == 2)
473             return('Online');
474         else if (Type == 3)
475             return('Video');
476         else if (Type == 4)
477             return('ELearning');
478         else
479             return(bytes10(uintToBytesN(Type)));
480     } 
481 }