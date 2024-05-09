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
42 
43 contract DataRegister is Operations {
44     bytes32 Institute; 
45     address owner;
46     mapping(bytes10 => bytes) Instructor;
47     mapping(uint => bytes10) InstructorUIds;
48     uint InstructorCount = 0;
49     struct course {
50         bytes CourseName;
51         bytes10 StartDate;
52         bytes10 EndDate;
53         uint Hours;
54     }
55     struct courseInstructor {
56         uint CourseId;
57         uint InstructorId;
58     }
59     courseInstructor[] CourseInstructor;
60     mapping(bytes10 => course) Course;
61     mapping(uint => bytes10) CourseUIds;
62     uint CourseCount = 0;
63     mapping(bytes10 => bytes) Student;
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
98         require(Student[StudentUIds[StudentId]].length > 0);
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
114         require(Student[bytes10(stringToBytes32(_studentUId))].length == 0);
115         _;
116     }
117     function RegisterInstructor(
118         string memory NationalId, 
119         string memory instructor
120         ) public onlyOwner notEmpty(NationalId) notEmpty(instructor) uniqueInstructorUId(NationalId) returns(bool) {
121             bytes10 _instructorUId = bytes10(stringToBytes32(NationalId));
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
136             course memory _course = setCourseElements(CourseName, StartDate, EndDate, Hours);
137             CourseCount++;
138             bytes10 _courseUId = bytes10(stringToBytes32(CourseUId));
139             CourseUIds[CourseCount] = _courseUId;
140             Course[_courseUId] = _course;
141             courseInstructor memory _courseInstructor;
142             _courseInstructor.CourseId = CourseCount;
143             _courseInstructor.InstructorId = InstructorId;
144             CourseInstructor.push(_courseInstructor);
145     }
146     function AddCourseInstructor(
147         uint CourseId,
148         uint InstructorId
149         ) public onlyOwner haveCourse(CourseId) haveInstructor(InstructorId) {
150             courseInstructor memory _courseInstructor;
151             _courseInstructor.CourseId = CourseId;
152             _courseInstructor.InstructorId = InstructorId;
153             CourseInstructor.push(_courseInstructor);
154         }
155     function setCourseElements(
156         string memory CourseName, 
157         string memory StartDate, 
158         string memory EndDate,
159         uint Hours
160         ) internal pure returns(course memory) {
161         course memory _course;
162         _course.CourseName = bytes(CourseName);
163         _course.StartDate = bytes10(stringToBytes32(StartDate));
164         _course.EndDate = bytes10(stringToBytes32(EndDate));
165         _course.Hours = Hours;
166         return(_course);
167     }
168     function RegisterStudent(
169         string memory NationalId,
170         string memory Name
171         ) public onlyOwner notEmpty(Name) notEmpty(NationalId) uniqueStudentUId(NationalId) returns(bool) {
172             StudentCount++;
173             StudentUIds[StudentCount] = bytes10(stringToBytes32(NationalId));
174             Student[StudentUIds[StudentCount]]=bytes(Name);
175         return(true);
176     }
177     function RegisterCertificate(
178         string memory CertificateUId,
179         uint CourseId,
180         uint StudentId,
181         uint CertificateType,
182         string memory Result
183         ) public onlyOwner haveStudent(StudentId) haveCourse(CourseId) 
184         uniqueCertificateUId(CertificateUId) isPositive(CertificateType) returns(bool) {
185             certificate memory _certificate;
186             _certificate.CourseId = CourseId;
187             _certificate.StudentId = StudentId;
188             _certificate.CertificateType = CertificateType;
189             _certificate.Result = bytes10(stringToBytes32(Result));
190             _certificate.Enabled = true;
191             bytes10 cert_uid = bytes10(stringToBytes32(CertificateUId));
192             CertificateCount++;
193             Certificate[cert_uid] = _certificate;
194             CertificateUIds[CertificateCount] = cert_uid;
195             return(true);
196     }
197     function EnableCertificate(string memory CertificateId) public onlyOwner notEmpty(CertificateId) returns(bool) {
198         bytes10 _certificateId = bytes10(stringToBytes32(CertificateId));
199         certificate memory _certificate = Certificate[_certificateId];
200         require(_certificate.Result != '');
201         require(! _certificate.Enabled);
202         Certificate[_certificateId].Enabled = true;
203         return(true);
204     }
205     function DisableCertificate(string memory CertificateId) public onlyOwner notEmpty(CertificateId) returns(bool) {
206         bytes10 _certificateId = bytes10(stringToBytes32(CertificateId));
207         certificate memory _certificate = Certificate[_certificateId];
208         require(_certificate.Result != '');
209         require(_certificate.Enabled);
210         Certificate[_certificateId].Enabled = false;
211         return(true);
212     }
213 }
214 
215 contract CryptoClassCertificate is DataRegister {
216     constructor(string memory _Institute) public notEmpty(_Institute) {
217         owner = msg.sender;
218         Institute = stringToBytes32(_Institute);
219     }
220     function GetInstitute() public view returns(string  memory) {
221         uint[1] memory pointer;
222         pointer[0]=0;
223         bytes memory institute=new bytes(48);
224         copyBytesToBytes('{"Institute":"', institute, pointer);
225         copyBytesNToBytes(Institute, institute, pointer);
226         copyBytesToBytes('"}', institute, pointer);
227         return(string(institute));
228     }
229     function GetInstructors() public view onlyOwner returns(string memory) {
230         uint len = 40;
231         uint i;
232         for (i=1 ; i <= InstructorCount ; i++) 
233             len += 40 + Instructor[InstructorUIds[i]].length;
234         bytes memory instructors = new bytes(len);
235         uint[1] memory pointer;
236         pointer[0]=0;
237         copyBytesNToBytes('{ "Instructors":[', instructors, pointer);
238         for (i=1 ; i <= InstructorCount ; i++) {
239             if (i > 1) 
240                 copyBytesNToBytes(',', instructors, pointer);
241             copyBytesNToBytes('{"NationalId":"', instructors, pointer);
242             copyBytesNToBytes(InstructorUIds[i], instructors, pointer);
243             copyBytesNToBytes('","Name":"', instructors, pointer);
244             copyBytesToBytes(Instructor[InstructorUIds[i]], instructors, pointer);
245             copyBytesNToBytes('"}', instructors, pointer);
246         }
247         copyBytesNToBytes(']}', instructors, pointer);
248         return(string(instructors));
249     }
250     function GetInstructor(string memory InstructorNationalId) public view notEmpty(InstructorNationalId) returns(string memory) {
251         bytes10 _instructorUId = bytes10(stringToBytes32(InstructorNationalId));
252         require(Instructor[_instructorUId].length > 0);
253         uint len = 70;
254         len += Instructor[_instructorUId].length;
255         bytes memory _instructor = new bytes(len);
256         uint[1] memory pointer;
257         pointer[0]=0;
258         copyBytesNToBytes('{ "Instructor":{"NationalId":"', _instructor, pointer);
259         copyBytesNToBytes(_instructorUId, _instructor, pointer);
260         copyBytesNToBytes('","Name":"', _instructor, pointer);
261         copyBytesToBytes(Instructor[_instructorUId], _instructor, pointer);
262         copyBytesNToBytes('"}}', _instructor, pointer);
263         return(string(_instructor));
264     }
265     function GetInstructorCourses(string memory InstructorNationalId) public view notEmpty(InstructorNationalId) returns(string memory) {
266         bytes10 _instructorNationalId = bytes10(stringToBytes32(InstructorNationalId));
267         require(Instructor[_instructorNationalId].length > 0);
268         uint _instructorId = 0;
269         uint i;
270         for (i = 1; i <= InstructorCount; i++)
271             if (InstructorUIds[i] == _instructorNationalId) {
272                 _instructorId = i;
273                 break;
274             }
275         uint len = 30;
276         course memory _course;
277         for (i=0; i< CourseInstructor.length; i++) {
278             if (CourseInstructor[i].InstructorId == _instructorId) { 
279                 _course = Course[CourseUIds[CourseInstructor[i].CourseId]];
280                 len += 180 + Institute.length + _course.CourseName.length + Instructor[InstructorUIds[_instructorId]].length;
281             }
282         }
283         bytes memory courseInfo = new bytes(len);
284         uint[1] memory pointer;
285         pointer[0]=0;
286         copyBytesNToBytes('{"Courses":[', courseInfo, pointer);
287         bool first = true;
288         for (i=0; i< CourseInstructor.length; i++) {
289             if (CourseInstructor[i].InstructorId == _instructorId) { 
290                 _course = Course[CourseUIds[CourseInstructor[i].CourseId]];
291                 if (first)
292                     first = false;
293                 else
294                     copyBytesNToBytes(',', courseInfo, pointer);
295                 copyBytesNToBytes('{"CourseId":"', courseInfo, pointer);
296                 copyBytesNToBytes(CourseUIds[CourseInstructor[i].CourseId], courseInfo, pointer);
297                 copyBytesNToBytes('","CourseName":"', courseInfo, pointer);
298                 copyBytesToBytes(_course.CourseName, courseInfo, pointer);
299                 copyBytesNToBytes('","StartDate":"', courseInfo, pointer);
300                 copyBytesNToBytes(_course.StartDate, courseInfo, pointer);
301                 copyBytesNToBytes('","EndDate":"', courseInfo, pointer);
302                 copyBytesNToBytes(_course.EndDate, courseInfo, pointer);
303                 copyBytesNToBytes('","DurationHours":"', courseInfo, pointer);
304                 copyBytesNToBytes( uintToBytesN(_course.Hours), courseInfo, pointer);
305                 copyBytesNToBytes('"}', courseInfo, pointer);
306             }
307         }
308         copyBytesNToBytes(']}', courseInfo, pointer);
309         return(string(courseInfo));
310     }
311     function CourseIdByUId(bytes10 CourseUId) private view returns(uint CourseId) {
312         CourseId = 0;
313         for (uint i=1; i<=CourseCount;i++)
314             if (CourseUIds[i] == CourseUId) {
315                 CourseId = i;
316                 break;
317             }
318         require(CourseId > 0);
319     }
320     function GetCourseInfo(string memory CourseUId) public view notEmpty(CourseUId) returns(string memory) {
321         bytes10 _courseUId=bytes10(stringToBytes32(CourseUId));
322         course memory _course;
323         _course = Course[_courseUId];
324         require(_course.CourseName.length > 0);
325         uint _courseId=CourseIdByUId(_courseUId);
326         uint i;
327         uint len = 110;
328         uint courseInstructorCount = 0;
329         for (i=0; i< CourseInstructor.length; i++)
330             if (CourseInstructor[i].CourseId == _courseId)
331                 courseInstructorCount++;
332         uint[] memory courseInstructors = new uint[](courseInstructorCount); 
333         courseInstructorCount = 0;
334         for (i=0; i< CourseInstructor.length; i++)
335             if (CourseInstructor[i].CourseId == _courseId) {
336                 courseInstructors[courseInstructorCount] = CourseInstructor[i].InstructorId;
337                 courseInstructorCount++;
338                 len += Instructor[InstructorUIds[CourseInstructor[i].InstructorId]].length + 5;
339             }
340         len += Institute.length + 10 + _course.CourseName.length + 10 + 10;
341         bytes memory courseInfo = new bytes(len);
342         uint[1] memory pointer;
343         pointer[0]=0;
344         copyBytesNToBytes('{"Course":', courseInfo, pointer);
345         copyBytesNToBytes('{"Issuer":"', courseInfo, pointer);
346         copyBytesNToBytes(Institute, courseInfo, pointer);
347         copyBytesNToBytes('","CourseUId":"', courseInfo, pointer);
348         copyBytesNToBytes(_courseUId, courseInfo, pointer);
349         copyBytesNToBytes('","CourseName":"', courseInfo, pointer);
350         copyBytesToBytes(_course.CourseName, courseInfo, pointer);
351         if (courseInstructorCount == 1) {
352             copyBytesNToBytes('","Instructor":"', courseInfo, pointer);
353             copyBytesToBytes(Instructor[InstructorUIds[courseInstructors[0]]], courseInfo, pointer);
354             copyBytesNToBytes('"', courseInfo, pointer);
355         }
356         else {
357             copyBytesNToBytes('","Instructors":[', courseInfo, pointer);
358             for (i=0; i<courseInstructorCount; i++){
359                 if (i > 0)
360                     copyBytesNToBytes(',', courseInfo, pointer);
361                 copyBytesNToBytes('"', courseInfo, pointer);
362                 copyBytesToBytes(Instructor[InstructorUIds[courseInstructors[i]]], courseInfo, pointer);
363                 copyBytesNToBytes('"', courseInfo, pointer);
364             }
365             copyBytesNToBytes(']', courseInfo, pointer);
366         }
367         copyBytesNToBytes(',"StartDate":"', courseInfo, pointer);
368         copyBytesNToBytes(_course.StartDate, courseInfo, pointer);
369         copyBytesNToBytes('","EndDate":"', courseInfo, pointer);
370         copyBytesNToBytes(_course.EndDate, courseInfo, pointer);
371         copyBytesNToBytes('","DurationHours":"', courseInfo, pointer);
372         copyBytesNToBytes( uintToBytesN(_course.Hours), courseInfo, pointer);
373         copyBytesNToBytes('"}}', courseInfo, pointer);
374         return(string(courseInfo));
375     }
376     function GetCourses() public view returns(string memory) {
377         uint len = 30;
378         uint i;
379         course memory _course;
380         for (i=1 ; i <= CourseCount ; i++) {
381             _course = Course[CourseUIds[i]];
382             len += 90 + 10 + _course.CourseName.length + 10 + 12 + 12 + 6;
383         }
384         bytes memory courses = new bytes(len);
385         uint[1] memory pointer;
386         pointer[0]=0;
387         bytes32 hrs;
388         copyBytesNToBytes('{"Courses":[', courses, pointer);
389         for (i=1 ; i <= CourseCount ; i++) {
390             if (i > 1)
391                 copyBytesNToBytes(',', courses, pointer);
392             _course = Course[CourseUIds[i]];
393             copyBytesNToBytes('{"UId":"', courses, pointer);
394             copyBytesNToBytes(CourseUIds[i], courses, pointer);
395             copyBytesNToBytes('","Name":"', courses, pointer);
396             copyBytesToBytes(_course.CourseName, courses, pointer);
397             copyBytesNToBytes('","StartDate":"', courses, pointer);
398             copyBytesNToBytes(_course.StartDate, courses, pointer);
399             copyBytesNToBytes('","EndDate":"', courses, pointer);
400             copyBytesNToBytes(_course.EndDate, courses, pointer);
401             copyBytesNToBytes('","Duration":"', courses, pointer);
402             hrs = uintToBytesN(_course.Hours);
403             copyBytesNToBytes(hrs, courses, pointer);
404             copyBytesNToBytes(' Hours"}', courses, pointer);
405         }
406         copyBytesNToBytes(']}', courses, pointer);
407         return(string(courses));
408     }
409     function GetStudentInfo(string memory NationalId) public view notEmpty(NationalId) returns(string memory) {
410         bytes10 _nationalId=bytes10(stringToBytes32(NationalId));
411         bytes memory _student = Student[_nationalId];
412         require(_student.length > 0);
413         uint len = 110;
414         len += Institute.length + 10 + _student.length + 10 ;
415         bytes memory studentInfo = new bytes(len);
416         uint[1] memory pointer;
417         pointer[0]=0;
418         copyBytesNToBytes('{"Student":', studentInfo, pointer);
419         copyBytesNToBytes('{"Issuer":"', studentInfo, pointer);
420         copyBytesNToBytes(Institute, studentInfo, pointer);
421         copyBytesNToBytes('","NationalId":"', studentInfo, pointer);
422         copyBytesNToBytes(_nationalId, studentInfo, pointer);
423         copyBytesNToBytes('","Name":"', studentInfo, pointer);
424         copyBytesToBytes(_student, studentInfo, pointer);
425         copyBytesNToBytes('"}}', studentInfo, pointer);
426         return(string(studentInfo));
427     }
428     function GetStudents() public view onlyOwner returns(string memory) {
429         uint len = 30;
430         uint i;
431         for (i=1 ; i <= StudentCount ; i++) 
432             len += 50 + 3 + Student[StudentUIds[i]].length;
433         bytes memory students = new bytes(len);
434         uint[1] memory pointer;
435         pointer[0]=0;
436         copyBytesNToBytes('{"Students":[', students, pointer);
437         for (i=1 ; i <= StudentCount ; i++) {
438             if (i > 1)
439                 copyBytesNToBytes(',', students, pointer);
440             bytes memory _student = Student[StudentUIds[i]];
441             copyBytesNToBytes('{"NationalId":"', students, pointer);
442             copyBytesNToBytes(StudentUIds[i], students, pointer);
443             copyBytesNToBytes('","Name":"', students, pointer);
444             copyBytesToBytes(_student, students, pointer);
445             copyBytesNToBytes('"}', students, pointer);
446         }
447         copyBytesNToBytes(']}', students, pointer);
448         return(string(students));
449     }
450     function GetCertificates() public view onlyOwner returns(string memory) {
451         uint len = 30;
452         uint i;
453         len += CertificateCount * 40;
454         bytes memory certificates = new bytes(len);
455         uint[1] memory pointer;
456         pointer[0]=0;
457         copyBytesNToBytes('{"Certificates":[', certificates, pointer);
458         for (i = 1 ; i <= CertificateCount ; i++) {
459             if (i > 1)
460                 copyBytesNToBytes(',', certificates, pointer);
461             copyBytesNToBytes('{"CertificateId":"', certificates, pointer);
462             copyBytesNToBytes(CertificateUIds[i], certificates, pointer);
463             copyBytesNToBytes('"}', certificates, pointer);
464         }
465         copyBytesNToBytes(']}', certificates, pointer);
466         return(string(certificates));
467     }
468     function GetStudentCertificates(string memory NationalId) public view notEmpty(NationalId) returns(string memory) {
469         uint len = 30;
470         uint i;
471         bytes10 _nationalId=bytes10(stringToBytes32(NationalId));
472         for (i = 1 ; i <= CertificateCount ; i++) {
473             if (StudentUIds[i] == _nationalId) {
474                 len += 50 + Course[CourseUIds[Certificate[CertificateUIds[i]].CourseId]].CourseName.length;
475             }
476         }
477         bytes memory certificates = new bytes(len);
478         uint[1] memory pointer;
479         pointer[0]=0;
480         copyBytesNToBytes('{"Certificates":[', certificates, pointer);
481         bool first=true;
482         for (i = 1 ; i <= CertificateCount ; i++) {
483             if (StudentUIds[i] == _nationalId) {
484                 if (first)
485                     first = false;
486                 else
487                     copyBytesNToBytes(',', certificates, pointer);
488                 copyBytesNToBytes('{"CertificateId":"', certificates, pointer);
489                 copyBytesNToBytes(CertificateUIds[i], certificates, pointer);
490                 copyBytesNToBytes('","CourseName":"', certificates, pointer);
491                 copyBytesToBytes(Course[CourseUIds[Certificate[CertificateUIds[i]].CourseId]].CourseName, certificates, pointer);
492                 copyBytesNToBytes('"}', certificates, pointer);
493             }
494         }
495         copyBytesNToBytes(']}', certificates, pointer);
496         return(string(certificates));
497     }
498     function GetCertificate(string memory CertificateId) public view notEmpty(CertificateId) returns(string memory) {
499         bytes10 _certificateId = bytes10(stringToBytes32(CertificateId));
500         certificate memory _certificate = Certificate[_certificateId];
501         course memory _course = Course[CourseUIds[_certificate.CourseId]];
502         bytes memory _student = Student[StudentUIds[_certificate.StudentId]];
503         bytes memory certSpec;
504         uint len = 500;
505         uint i;
506         uint courseInstructorCount = 0;
507         for (i=0; i< CourseInstructor.length; i++)
508             if (CourseInstructor[i].CourseId == _certificate.CourseId)
509                 courseInstructorCount++;
510         uint[] memory courseInstructors = new uint[](courseInstructorCount); 
511         courseInstructorCount = 0;
512         for (i=0; i< CourseInstructor.length; i++)
513             if (CourseInstructor[i].CourseId == _certificate.CourseId) {
514                 courseInstructors[courseInstructorCount] = CourseInstructor[i].InstructorId;
515                 courseInstructorCount++;
516                 len += Instructor[InstructorUIds[CourseInstructor[i].InstructorId]].length + 5;
517             }
518         uint[1] memory pointer;
519         pointer[0] = 0;
520         len += _course.CourseName.length;
521         certSpec = new bytes(len);
522         require(_certificate.StudentId > 0);
523         require(_certificate.Enabled);
524         copyBytesNToBytes('{"Certificate":{"Issuer":"', certSpec, pointer);
525         copyBytesNToBytes(Institute, certSpec, pointer);
526         copyBytesNToBytes('","CertificateId":"', certSpec, pointer);
527         copyBytesNToBytes(_certificateId, certSpec, pointer);
528         copyBytesNToBytes('","Name":"', certSpec, pointer);
529         copyBytesToBytes(_student, certSpec, pointer);
530         copyBytesNToBytes('","NationalId":"', certSpec, pointer);
531         copyBytesNToBytes( StudentUIds[_certificate.StudentId], certSpec, pointer);
532         copyBytesNToBytes('","CourseId":"', certSpec, pointer);
533         copyBytesNToBytes(CourseUIds[_certificate.CourseId], certSpec, pointer);
534         copyBytesNToBytes('","CourseName":"', certSpec, pointer);
535         copyBytesToBytes(_course.CourseName, certSpec, pointer);
536         copyBytesNToBytes('","StartDate":"', certSpec, pointer);
537         copyBytesNToBytes(_course.StartDate, certSpec, pointer);
538         copyBytesNToBytes('","EndDate":"', certSpec, pointer);
539         copyBytesNToBytes(_course.EndDate, certSpec, pointer);
540         copyBytesNToBytes('","DurationHours":"', certSpec, pointer);
541         copyBytesNToBytes(uintToBytesN(_course.Hours), certSpec, pointer);
542         if (courseInstructorCount == 1) {
543             copyBytesNToBytes('","Instructor":"', certSpec, pointer);
544             copyBytesToBytes(Instructor[InstructorUIds[courseInstructors[0]]], certSpec, pointer);
545             copyBytesNToBytes('"', certSpec, pointer);
546         }
547         else {
548             copyBytesNToBytes('","Instructors":[', certSpec, pointer);
549             for (i=0; i<courseInstructorCount; i++){
550                 if (i > 0)
551                     copyBytesNToBytes(',', certSpec, pointer);
552                 copyBytesNToBytes('"', certSpec, pointer);
553                 copyBytesToBytes(Instructor[InstructorUIds[courseInstructors[i]]], certSpec, pointer);
554                 copyBytesNToBytes('"', certSpec, pointer);
555             }
556             copyBytesNToBytes(']', certSpec, pointer);
557         }
558         bytes10 _certType = GetCertificateTypeDescription(_certificate.CertificateType);
559         copyBytesNToBytes(',"CourseType":"', certSpec, pointer);
560         copyBytesNToBytes(_certType, certSpec, pointer);
561         copyBytesNToBytes('","Result":"', certSpec, pointer);
562         copyBytesNToBytes(_certificate.Result, certSpec, pointer);
563         copyBytesNToBytes('"}}', certSpec, pointer);
564         return(string(certSpec));
565     }
566     function GetCertificateTypeDescription(uint Type) pure internal returns(bytes10) {
567         if (Type == 1) 
568             return('Attendance');
569         else if (Type == 2)
570             return('Online');
571         else if (Type == 3)
572             return('Video');
573         else if (Type == 4)
574             return('ELearning');
575         else
576             return(bytes10(uintToBytesN(Type)));
577     } 
578 }