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
15             if (source[i] == 0)
16                 break;
17             destination[pointer[0]]=source[i];
18             pointer[0]++;
19         }
20     }
21     function uintToBytesN(uint v) internal pure returns (bytes32 ret) {
22         if (v == 0) {
23             ret = '0';
24         }
25         else {
26             while (v > 0) {
27 //                ret = bytes32(uint(ret) / (2 ** 8));
28 //                ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
29                 ret = bytes32(uint(ret) >> 8);
30                 ret |= bytes32(((v % 10) + 48) << (8 * 31));
31                 v /= 10;
32             }
33         }
34         return ret;
35     }
36     function stringToBytes32(string memory str) internal pure returns(bytes32) {
37         bytes32 bStrN;
38         assembly {
39             bStrN := mload(add(str, 32))
40         }
41         return(bStrN);
42     }
43 }
44 
45 contract DataRegister is Operations {
46     bytes32 Institute; 
47     address owner;
48     mapping(bytes10 => bytes) Instructor;
49     mapping(uint => bytes10) InstructorUIds;
50     uint public InstructorCount = 0;
51     struct course {
52         bytes CourseName;
53         bytes10 StartDate;
54         bytes10 EndDate;
55         uint Hours;
56     }
57     struct courseInstructor {
58         uint CourseId;
59         uint InstructorId;
60     }
61     courseInstructor[] CourseInstructor;
62     mapping(bytes10 => course) Course;
63     mapping(uint => bytes10) CourseUIds;
64     uint CourseCount = 0;
65     mapping(bytes10 => bytes) Student;
66     mapping(uint => bytes10) StudentUIds;
67     uint StudentCount = 0;
68     struct certificate {
69         uint CourseId;
70         uint StudentId;
71         uint CertificateType;
72         bytes10 Result;
73         bool Enabled;
74     }
75     mapping(bytes10 => certificate) Certificate;
76     uint CertificateCount = 0;
77     mapping(uint => bytes10) CertificateUIds;
78     modifier onlyOwner() {
79         require(msg.sender==owner);
80         _;
81     }
82     modifier notEmpty(string memory str) {
83         bytes memory bStr = bytes(str);
84         require(bStr.length > 0);
85         _;
86     }
87     modifier isPositive(uint number) {
88         require(number > 0);
89         _;
90     }
91     modifier haveInstructor(uint InstructorId) {
92         require(Instructor[InstructorUIds[InstructorId]].length > 0);
93         _;
94     }
95     modifier haveCourse(uint CourseId) {
96         require(CourseUIds[CourseId].length > 0);
97         _;
98     }
99     modifier haveStudent(uint StudentId) {
100         require(Student[StudentUIds[StudentId]].length > 0);
101         _;
102     }
103     modifier uniqueCertificateUId(string memory certificateUId) {
104         require(Certificate[bytes10(stringToBytes32(certificateUId))].CourseId == 0);
105         _;
106     }
107     modifier uniqueInstructorUId(string memory _instructorUId) {
108         require(Instructor[bytes10(stringToBytes32(_instructorUId))].length == 0);
109         _;
110     }
111     modifier uniqueCourseUId(string memory _courseUId) {
112         require(Course[bytes10(stringToBytes32(_courseUId))].CourseName.length == 0);
113         _;
114     }
115     modifier uniqueStudentUId(string memory _studentUId) {
116         require(Student[bytes10(stringToBytes32(_studentUId))].length == 0);
117         _;
118     }
119     modifier notRepeat(uint CourseId, uint InstructorId) {
120         bool found = false;
121         for (uint i = 0; i < CourseInstructor.length; i++) {
122             if (CourseInstructor[i].CourseId == CourseId && CourseInstructor[i].InstructorId == InstructorId) {
123                 found = true;
124                 break;
125             }
126         }
127         require(! found);
128         _;
129     }
130     function RegisterInstructor(
131         string memory NationalId, 
132         string memory instructor
133         ) public onlyOwner notEmpty(NationalId) notEmpty(instructor) uniqueInstructorUId(NationalId) returns(bool) {
134             bytes10 _instructorUId = bytes10(stringToBytes32(NationalId));
135             InstructorCount++;
136             Instructor[_instructorUId] = bytes(instructor);
137             InstructorUIds[InstructorCount]=_instructorUId;
138             return(true);
139     }
140     function RegisterCourse(
141         string memory CourseUId,
142         string memory CourseName,
143         string memory StartDate,
144         string memory EndDate,
145         uint Hours,
146         uint InstructorId
147         ) public onlyOwner notEmpty(CourseUId) notEmpty(CourseName) 
148             isPositive(Hours) haveInstructor(InstructorId) uniqueCourseUId(CourseUId) {
149             course memory _course = setCourseElements(CourseName, StartDate, EndDate, Hours);
150             CourseCount++;
151             bytes10 _courseUId = bytes10(stringToBytes32(CourseUId));
152             CourseUIds[CourseCount] = _courseUId;
153             Course[_courseUId] = _course;
154             courseInstructor memory _courseInstructor;
155             _courseInstructor.CourseId = CourseCount;
156             _courseInstructor.InstructorId = InstructorId;
157             CourseInstructor.push(_courseInstructor);
158     }
159     function AddCourseInstructor(
160         uint CourseId,
161         uint InstructorId
162         ) public onlyOwner haveCourse(CourseId) notRepeat(CourseId, InstructorId) haveInstructor(InstructorId) {
163             courseInstructor memory _courseInstructor;
164             _courseInstructor.CourseId = CourseId;
165             _courseInstructor.InstructorId = InstructorId;
166             CourseInstructor.push(_courseInstructor);
167         }
168     function setCourseElements(
169         string memory CourseName, 
170         string memory StartDate, 
171         string memory EndDate,
172         uint Hours
173         ) internal pure returns(course memory) {
174         course memory _course;
175         _course.CourseName = bytes(CourseName);
176         _course.StartDate = bytes10(stringToBytes32(StartDate));
177         _course.EndDate = bytes10(stringToBytes32(EndDate));
178         _course.Hours = Hours;
179         return(_course);
180     }
181     function RegisterStudent(
182         string memory NationalId,
183         string memory Name
184         ) public onlyOwner notEmpty(Name) notEmpty(NationalId) uniqueStudentUId(NationalId) returns(bool) {
185             StudentCount++;
186             StudentUIds[StudentCount] = bytes10(stringToBytes32(NationalId));
187             Student[StudentUIds[StudentCount]]=bytes(Name);
188         return(true);
189     }
190     function RegisterCertificate(
191         string memory CertificateUId,
192         uint CourseId,
193         uint StudentId,
194         uint CertificateType,
195         string memory Result
196         ) public onlyOwner haveStudent(StudentId) haveCourse(CourseId) 
197         uniqueCertificateUId(CertificateUId) isPositive(CertificateType) returns(bool) {
198             certificate memory _certificate;
199             _certificate.CourseId = CourseId;
200             _certificate.StudentId = StudentId;
201             _certificate.CertificateType = CertificateType;
202             _certificate.Result = bytes10(stringToBytes32(Result));
203             _certificate.Enabled = true;
204             bytes10 cert_uid = bytes10(stringToBytes32(CertificateUId));
205             CertificateCount++;
206             Certificate[cert_uid] = _certificate;
207             CertificateUIds[CertificateCount] = cert_uid;
208             return(true);
209     }
210     function EnableCertificate(string memory CertificateId) public onlyOwner notEmpty(CertificateId) returns(bool) {
211         bytes10 _certificateId = bytes10(stringToBytes32(CertificateId));
212         certificate memory _certificate = Certificate[_certificateId];
213         require(_certificate.Result != '');
214         require(! _certificate.Enabled);
215         Certificate[_certificateId].Enabled = true;
216         return(true);
217     }
218     function DisableCertificate(string memory CertificateId) public onlyOwner notEmpty(CertificateId) returns(bool) {
219         bytes10 _certificateId = bytes10(stringToBytes32(CertificateId));
220         certificate memory _certificate = Certificate[_certificateId];
221         require(_certificate.Result != '');
222         require(_certificate.Enabled);
223         Certificate[_certificateId].Enabled = false;
224         return(true);
225     }
226 }
227 
228 contract CryptoClassCertificate is DataRegister {
229     constructor(string memory _Institute) public notEmpty(_Institute) {
230         owner = msg.sender;
231         Institute = stringToBytes32(_Institute);
232     }
233     function GetInstitute() public view returns(string  memory) {
234         uint[1] memory pointer;
235         pointer[0]=0;
236         bytes memory institute=new bytes(48);
237         copyBytesToBytes('{"Institute":"', institute, pointer);
238         copyBytesNToBytes(Institute, institute, pointer);
239         copyBytesToBytes('"}', institute, pointer);
240         return(string(institute));
241     }
242     function GetInstructors() public view onlyOwner returns(string memory) {
243         uint len = 70;
244         uint i;
245         for (i=1 ; i <= InstructorCount ; i++) 
246             len += 100 + Instructor[InstructorUIds[i]].length;
247         bytes memory instructors = new bytes(len);
248         uint[1] memory pointer;
249         pointer[0]=0;
250         copyBytesNToBytes('{ "Instructors":[', instructors, pointer);
251         for (i=1 ; i <= InstructorCount ; i++) {
252             if (i > 1) 
253                 copyBytesNToBytes(',', instructors, pointer);
254             copyBytesNToBytes('{"National Id":"', instructors, pointer);
255             copyBytesNToBytes(InstructorUIds[i], instructors, pointer);
256             copyBytesNToBytes('","Name":"', instructors, pointer);
257             copyBytesToBytes(Instructor[InstructorUIds[i]], instructors, pointer);
258             copyBytesNToBytes('"}', instructors, pointer);
259         }
260         copyBytesNToBytes(']}', instructors, pointer);
261         return(string(instructors));
262     }
263     function GetInstructor(string memory InstructorNationalId) public view notEmpty(InstructorNationalId) returns(string memory) {
264         bytes10 _instructorUId = bytes10(stringToBytes32(InstructorNationalId));
265         require(Instructor[_instructorUId].length > 0);
266         uint len = 100 + Instructor[_instructorUId].length;
267         bytes memory _instructor = new bytes(len);
268         uint[1] memory pointer;
269         pointer[0]=0;
270         copyBytesNToBytes('{ "Instructor":{"NationalId":"', _instructor, pointer);
271         copyBytesNToBytes(_instructorUId, _instructor, pointer);
272         copyBytesNToBytes('","Name":"', _instructor, pointer);
273         copyBytesToBytes(Instructor[_instructorUId], _instructor, pointer);
274         copyBytesNToBytes('"}}', _instructor, pointer);
275         return(string(_instructor));
276     }
277     function GetInstructorCourses(string memory InstructorNationalId) public view notEmpty(InstructorNationalId) returns(string memory) {
278         bytes10 _instructorNationalId = bytes10(stringToBytes32(InstructorNationalId));
279         require(Instructor[_instructorNationalId].length > 0);
280         uint _instructorId = 0;
281         uint i;
282         for (i = 1; i <= InstructorCount; i++)
283             if (InstructorUIds[i] == _instructorNationalId) {
284                 _instructorId = i;
285                 break;
286             }
287         uint len = 50;
288         course memory _course;
289         for (i=0; i< CourseInstructor.length; i++) {
290             if (CourseInstructor[i].InstructorId == _instructorId) { 
291                 _course = Course[CourseUIds[CourseInstructor[i].CourseId]];
292                 len += 200 + Institute.length + _course.CourseName.length + Instructor[InstructorUIds[_instructorId]].length;
293             }
294         }
295         bytes memory courseInfo = new bytes(len);
296         uint[1] memory pointer;
297         pointer[0]=0;
298         copyBytesNToBytes('{"Courses":[', courseInfo, pointer);
299         bool first = true;
300         for (i=0; i< CourseInstructor.length; i++) {
301             if (CourseInstructor[i].InstructorId == _instructorId) { 
302                 _course = Course[CourseUIds[CourseInstructor[i].CourseId]];
303                 if (first)
304                     first = false;
305                 else
306                     copyBytesNToBytes(',', courseInfo, pointer);
307                 copyBytesNToBytes('{"Course Id":"', courseInfo, pointer);
308                 copyBytesNToBytes(CourseUIds[CourseInstructor[i].CourseId], courseInfo, pointer);
309                 copyBytesNToBytes('","Course Name":"', courseInfo, pointer);
310                 copyBytesToBytes(_course.CourseName, courseInfo, pointer);
311                 copyBytesNToBytes('","Start Date":"', courseInfo, pointer);
312                 copyBytesNToBytes(_course.StartDate, courseInfo, pointer);
313                 copyBytesNToBytes('","End Date":"', courseInfo, pointer);
314                 copyBytesNToBytes(_course.EndDate, courseInfo, pointer);
315                 copyBytesNToBytes('","Duration":"', courseInfo, pointer);
316                 copyBytesNToBytes( uintToBytesN(_course.Hours), courseInfo, pointer);
317                 copyBytesNToBytes(' Hours"}', courseInfo, pointer);
318             }
319         }
320         copyBytesNToBytes(']}', courseInfo, pointer);
321         return(string(courseInfo));
322     }
323     function CourseIdByUId(bytes10 CourseUId) private view returns(uint CourseId) {
324         CourseId = 0;
325         for (uint i=1; i<=CourseCount;i++)
326             if (CourseUIds[i] == CourseUId) {
327                 CourseId = i;
328                 break;
329             }
330         require(CourseId > 0);
331     }
332     function GetCourseInfo(string memory CourseUId) public view notEmpty(CourseUId) returns(string memory) {
333         bytes10 _courseUId=bytes10(stringToBytes32(CourseUId));
334         course memory _course;
335         _course = Course[_courseUId];
336         require(_course.CourseName.length > 0);
337         uint len = 200;
338         bytes memory instructorsList = CourseInstructorDescription(_courseUId);
339         len += instructorsList.length + Institute.length + _course.CourseName.length;
340         bytes memory courseInfo = new bytes(len);
341         uint[1] memory pointer;
342         pointer[0]=0;
343         copyBytesNToBytes('{"Course":', courseInfo, pointer);
344         copyBytesNToBytes('{"Issuer":"', courseInfo, pointer);
345         copyBytesNToBytes(Institute, courseInfo, pointer);
346         copyBytesNToBytes('","Course Id":"', courseInfo, pointer);
347         copyBytesNToBytes(_courseUId, courseInfo, pointer);
348         copyBytesNToBytes('","Course Name":"', courseInfo, pointer);
349         copyBytesToBytes(_course.CourseName, courseInfo, pointer);
350         copyBytesNToBytes('",', courseInfo, pointer);
351         copyBytesToBytes(instructorsList, courseInfo, pointer);
352         copyBytesNToBytes(',"Start Date":"', courseInfo, pointer);
353         copyBytesNToBytes(_course.StartDate, courseInfo, pointer);
354         copyBytesNToBytes('","End Date":"', courseInfo, pointer);
355         copyBytesNToBytes(_course.EndDate, courseInfo, pointer);
356         copyBytesNToBytes('","Duration":"', courseInfo, pointer);
357         copyBytesNToBytes( uintToBytesN(_course.Hours), courseInfo, pointer);
358         copyBytesNToBytes(' Hours"}}', courseInfo, pointer);
359         return(string(courseInfo));
360     }
361     function GetCourses() public view returns(string memory) {
362         uint len = 50;
363         uint i;
364         course memory _course;
365         for (i=1 ; i <= CourseCount ; i++) {
366             _course = Course[CourseUIds[i]];
367             len += 200 + _course.CourseName.length;
368         }
369         bytes memory courses = new bytes(len);
370         uint[1] memory pointer;
371         pointer[0]=0;
372         bytes32 hrs;
373         copyBytesNToBytes('{"Courses":[', courses, pointer);
374         for (i=1 ; i <= CourseCount ; i++) {
375             if (i > 1)
376                 copyBytesNToBytes(',', courses, pointer);
377             _course = Course[CourseUIds[i]];
378             copyBytesNToBytes('{"Id":"', courses, pointer);
379             copyBytesNToBytes(CourseUIds[i], courses, pointer);
380             copyBytesNToBytes('","Name":"', courses, pointer);
381             copyBytesToBytes(_course.CourseName, courses, pointer);
382             copyBytesNToBytes('","Start Date":"', courses, pointer);
383             copyBytesNToBytes(_course.StartDate, courses, pointer);
384             copyBytesNToBytes('","End Date":"', courses, pointer);
385             copyBytesNToBytes(_course.EndDate, courses, pointer);
386             copyBytesNToBytes('","Duration":"', courses, pointer);
387             hrs = uintToBytesN(_course.Hours);
388             copyBytesNToBytes(hrs, courses, pointer);
389             copyBytesNToBytes(' Hours"}', courses, pointer);
390         }
391         copyBytesNToBytes(']}', courses, pointer);
392         return(string(courses));
393     }
394     function GetStudentInfo(string memory NationalId) public view notEmpty(NationalId) returns(string memory) {
395         bytes10 _nationalId=bytes10(stringToBytes32(NationalId));
396         bytes memory _student = Student[_nationalId];
397         require(_student.length > 0);
398         uint len = 150 + Institute.length + _student.length;
399         bytes memory studentInfo = new bytes(len);
400         uint[1] memory pointer;
401         pointer[0]=0;
402         copyBytesNToBytes('{"Student":', studentInfo, pointer);
403         copyBytesNToBytes('{"Issuer":"', studentInfo, pointer);
404         copyBytesNToBytes(Institute, studentInfo, pointer);
405         copyBytesNToBytes('","National Id":"', studentInfo, pointer);
406         copyBytesNToBytes(_nationalId, studentInfo, pointer);
407         copyBytesNToBytes('","Name":"', studentInfo, pointer);
408         copyBytesToBytes(_student, studentInfo, pointer);
409         copyBytesNToBytes('"}}', studentInfo, pointer);
410         return(string(studentInfo));
411     }
412     function GetStudents() public view onlyOwner returns(string memory) {
413         uint len = 50;
414         uint i;
415         for (i=1 ; i <= StudentCount ; i++) 
416             len += 50 + Student[StudentUIds[i]].length;
417         bytes memory students = new bytes(len);
418         uint[1] memory pointer;
419         pointer[0]=0;
420         copyBytesNToBytes('{"Students":[', students, pointer);
421         for (i=1 ; i <= StudentCount ; i++) {
422             if (i > 1)
423                 copyBytesNToBytes(',', students, pointer);
424             bytes memory _student = Student[StudentUIds[i]];
425             copyBytesNToBytes('{"National Id":"', students, pointer);
426             copyBytesNToBytes(StudentUIds[i], students, pointer);
427             copyBytesNToBytes('","Name":"', students, pointer);
428             copyBytesToBytes(_student, students, pointer);
429             copyBytesNToBytes('"}', students, pointer);
430         }
431         copyBytesNToBytes(']}', students, pointer);
432         return(string(students));
433     }
434     function GetCertificates() public view onlyOwner returns(string memory) {
435         uint len = 50;
436         uint i;
437         len += CertificateCount * 60;
438         bytes memory certificates = new bytes(len);
439         uint[1] memory pointer;
440         pointer[0]=0;
441         copyBytesNToBytes('{"Certificates":[', certificates, pointer);
442         for (i = 1 ; i <= CertificateCount ; i++) {
443             if (i > 1)
444                 copyBytesNToBytes(',', certificates, pointer);
445             copyBytesNToBytes('{"Certificate Id":"', certificates, pointer);
446             copyBytesNToBytes(CertificateUIds[i], certificates, pointer);
447             copyBytesNToBytes('","Active":', certificates, pointer);
448             if (Certificate[CertificateUIds[i]].Enabled)
449                 copyBytesNToBytes('true}', certificates, pointer);
450             else
451                 copyBytesNToBytes('false}', certificates, pointer);
452         }
453         copyBytesNToBytes(']}', certificates, pointer);
454         return(string(certificates));
455     }
456     function GetStudentCertificates(string memory NationalId) public view notEmpty(NationalId) returns(string memory) {
457         uint len = 50;
458         uint i;
459         bytes10 _nationalId=bytes10(stringToBytes32(NationalId));
460         require(Student[_nationalId].length > 0);
461         for (i = 1 ; i <= CertificateCount ; i++) {
462             if (StudentUIds[Certificate[CertificateUIds[i]].StudentId] == _nationalId && 
463                 Certificate[CertificateUIds[i]].Enabled) {
464                 len += 100 + Course[CourseUIds[Certificate[CertificateUIds[i]].CourseId]].CourseName.length;
465             }
466         }
467         bytes memory certificates = new bytes(len);
468         uint[1] memory pointer;
469         pointer[0]=0;
470         copyBytesNToBytes('{"Certificates":[', certificates, pointer);
471         bool first=true;
472         for (i = 1 ; i <= CertificateCount ; i++) {
473             if (StudentUIds[Certificate[CertificateUIds[i]].StudentId] == _nationalId && 
474                 Certificate[CertificateUIds[i]].Enabled) {
475                 if (first)
476                     first = false;
477                 else
478                     copyBytesNToBytes(',', certificates, pointer);
479                 copyBytesNToBytes('{"Certificate Id":"', certificates, pointer);
480                 copyBytesNToBytes(CertificateUIds[i], certificates, pointer);
481                 copyBytesNToBytes('","Course Name":"', certificates, pointer);
482                 copyBytesToBytes(Course[CourseUIds[Certificate[CertificateUIds[i]].CourseId]].CourseName, certificates, pointer);
483                 copyBytesNToBytes('"}', certificates, pointer);
484             }
485         }
486         copyBytesNToBytes(']}', certificates, pointer);
487         return(string(certificates));
488     }
489     function GetCertificate(string memory CertificateId) public view notEmpty(CertificateId) returns(string memory) {
490         bytes10 _certificateId = bytes10(stringToBytes32(CertificateId));
491         require(Certificate[_certificateId].Enabled);
492         certificate memory _certificate = Certificate[_certificateId];
493         course memory _course = Course[CourseUIds[_certificate.CourseId]];
494         bytes memory _student = Student[StudentUIds[_certificate.StudentId]];
495         bytes memory certSpec;
496         bytes memory instructorsList = CourseInstructorDescription(CourseUIds[_certificate.CourseId]);
497         uint len = 500;
498         len += _course.CourseName.length + instructorsList.length;
499         uint[1] memory pointer;
500         pointer[0] = 0;
501         certSpec = new bytes(len);
502         require(_certificate.StudentId > 0);
503         require(_certificate.Enabled);
504         copyBytesNToBytes('{"Certificate":{"Issuer":"', certSpec, pointer);
505         copyBytesNToBytes(Institute, certSpec, pointer);
506         copyBytesNToBytes('","Certificate Id":"', certSpec, pointer);
507         copyBytesNToBytes(_certificateId, certSpec, pointer);
508         copyBytesNToBytes('","Name":"', certSpec, pointer);
509         copyBytesToBytes(_student, certSpec, pointer);
510         copyBytesNToBytes('","National Id":"', certSpec, pointer);
511         copyBytesNToBytes( StudentUIds[_certificate.StudentId], certSpec, pointer);
512         copyBytesNToBytes('","Course Id":"', certSpec, pointer);
513         copyBytesNToBytes(CourseUIds[_certificate.CourseId], certSpec, pointer);
514         copyBytesNToBytes('","Course Name":"', certSpec, pointer);
515         copyBytesToBytes(_course.CourseName, certSpec, pointer);
516         copyBytesNToBytes('","Start Date":"', certSpec, pointer);
517         copyBytesNToBytes(_course.StartDate, certSpec, pointer);
518         copyBytesNToBytes('","End Date":"', certSpec, pointer);
519         copyBytesNToBytes(_course.EndDate, certSpec, pointer);
520         copyBytesNToBytes('","Duration":"', certSpec, pointer);
521         copyBytesNToBytes(uintToBytesN(_course.Hours), certSpec, pointer);
522         copyBytesNToBytes(' Hours",', certSpec, pointer);
523         copyBytesToBytes(instructorsList, certSpec, pointer);
524         bytes10 _certType = CertificateTypeDescription(_certificate.CertificateType);
525         copyBytesNToBytes(',"Course Type":"', certSpec, pointer);
526         copyBytesNToBytes(_certType, certSpec, pointer);
527         copyBytesNToBytes('","Result":"', certSpec, pointer);
528         copyBytesNToBytes(_certificate.Result, certSpec, pointer);
529         copyBytesNToBytes('"}}', certSpec, pointer);
530         return(string(certSpec));
531     }
532     function CertificateTypeDescription(uint Type) pure internal returns(bytes10) {
533         if (Type == 1) 
534             return('Attendance');
535         else if (Type == 2)
536             return('Online');
537         else if (Type == 3)
538             return('Video');
539         else if (Type == 4)
540             return('ELearning');
541         else
542             return(bytes10(uintToBytesN(Type)));
543     }
544     function GetAdminStats() public view onlyOwner returns(string memory) {
545         bytes memory stat;
546         uint[1] memory pointer;
547         pointer[0] = 0;
548         stat = new bytes(400);
549         copyBytesNToBytes('{"Instructors":', stat, pointer);
550         copyBytesNToBytes(uintToBytesN(InstructorCount), stat, pointer);
551         copyBytesNToBytes(',"Courses":', stat, pointer);
552         copyBytesNToBytes(uintToBytesN(CourseCount), stat, pointer);
553         copyBytesNToBytes(',"Students":', stat, pointer);
554         copyBytesNToBytes(uintToBytesN(StudentCount), stat, pointer);
555         copyBytesNToBytes(',"Certificates":', stat, pointer);
556         copyBytesNToBytes(uintToBytesN(CertificateCount), stat, pointer);
557         copyBytesNToBytes('}', stat, pointer);
558         return(string(stat));
559     }
560     function GetStats() public view returns(string memory) {
561         bytes memory stat;
562         uint[1] memory pointer;
563         pointer[0] = 0;
564         stat = new bytes(200);
565         copyBytesNToBytes('{"Instructors":', stat, pointer);
566         copyBytesNToBytes(uintToBytesN(InstructorCount), stat, pointer);
567         copyBytesNToBytes(',"Courses":', stat, pointer);
568         copyBytesNToBytes(uintToBytesN(CourseCount), stat, pointer);
569         copyBytesNToBytes('}', stat, pointer);
570         return(string(stat));
571     }
572     function GetCourseStudents(string memory InstructorUId, string memory CourseUId) public view notEmpty(CourseUId) returns(string memory) {
573         bytes10 _instructorUId = bytes10(stringToBytes32(InstructorUId));
574         bytes10 _courseUId = bytes10(stringToBytes32(CourseUId));
575         uint i;
576         uint _instructorId = 0;
577 
578         for (i = 1;  i<= InstructorCount; i++)
579             if (InstructorUIds[i] == _instructorUId) {
580                 _instructorId = i;
581                 break;
582             }
583 //        require(_instructorId != 0);
584         uint _courseId = 0;
585 
586         for (i = 1;  i<= CourseCount; i++)
587             if (CourseUIds[i] == _courseUId) {
588                 _courseId = i;
589                 break;
590             }
591 
592         require(_courseId != 0);
593         bool found = false;
594         for (i = 0; i < CourseInstructor.length; i++)
595             if (CourseInstructor[i].InstructorId == _instructorId && CourseInstructor[i].CourseId == _courseId) {
596                 found = true;
597                 break;
598             }
599         require(found || (msg.sender == owner));
600         course memory _course = Course[_courseUId];
601         bytes memory students;
602         uint[1] memory pointer;
603         pointer[0] = 0;
604         bytes memory studentsList = CourseStudentDescription(_courseId);
605         bytes memory instructorsList = CourseInstructorDescription(CourseUIds[_courseId]);
606         uint len = 150 + studentsList.length + instructorsList.length + Institute.length + _course.CourseName.length;
607         students = new bytes(len);
608         copyBytesNToBytes('{"Course":{"Issuer":"', students, pointer);
609         copyBytesNToBytes(Institute, students, pointer);
610         copyBytesNToBytes('","Course Id":"', students, pointer);
611         copyBytesNToBytes(_courseUId, students, pointer);
612         copyBytesNToBytes('","Course Name":"', students, pointer);
613         copyBytesToBytes(_course.CourseName, students, pointer);
614         copyBytesNToBytes('",', students, pointer);
615         copyBytesToBytes(instructorsList, students, pointer);
616         copyBytesNToBytes(',"Start Date":"', students, pointer);
617         copyBytesNToBytes(_course.StartDate, students, pointer);
618         copyBytesNToBytes('","End Date":"', students, pointer);
619         copyBytesNToBytes(_course.EndDate, students, pointer);
620         copyBytesNToBytes('","Duration":"', students, pointer);
621         copyBytesNToBytes( uintToBytesN(_course.Hours), students, pointer);
622         copyBytesNToBytes(' Hours",', students, pointer);
623         copyBytesToBytes(studentsList, students, pointer);
624         copyBytesNToBytes('}}', students, pointer);
625         return(string(students));
626     }
627     function CourseStudentDescription(uint CourseId) internal view returns(bytes memory) {
628         bytes memory students;
629         uint[1] memory pointer;
630         pointer[0] = 0;
631         uint i;
632         bytes10 _studentId;
633         uint len = 20;
634         for (i = 1; i <= CertificateCount; i++)
635             if (Certificate[CertificateUIds[i]].CourseId == CourseId) {
636                 _studentId = StudentUIds[Certificate[CertificateUIds[i]].StudentId];
637                 len += 60 + Student[_studentId].length;
638             }
639         students = new bytes(len);
640         copyBytesNToBytes('"Students":[', students, pointer);
641         bool first = true;
642         for (i = 1; i <= CertificateCount; i++) {
643             if (Certificate[CertificateUIds[i]].CourseId == CourseId) {
644                 if (first)
645                     first = false;
646                 else
647                     copyBytesNToBytes(',', students, pointer);
648                 _studentId = StudentUIds[Certificate[CertificateUIds[i]].StudentId];
649                 copyBytesNToBytes('{"National Id":"', students, pointer);
650                 copyBytesNToBytes(_studentId, students, pointer);
651                 copyBytesNToBytes('","Name":"', students, pointer);
652                 copyBytesToBytes(Student[_studentId], students, pointer);
653                 copyBytesNToBytes('"}', students, pointer);
654             }
655         }
656         copyBytesNToBytes(']', students, pointer);
657         return(students);
658    }
659    function CourseInstructorDescription(bytes10 CourseUId) internal view returns(bytes memory) {
660         bytes memory instructors;
661         uint[1] memory pointer;
662         uint len=100;
663         uint i;
664         uint courseInstructorCount = 0;
665         for (i=0; i< CourseInstructor.length; i++)
666             if (CourseUIds[CourseInstructor[i].CourseId] == CourseUId)
667                 courseInstructorCount++;
668         uint[] memory courseInstructors = new uint[](courseInstructorCount); 
669         courseInstructorCount = 0;
670         for (i=0; i< CourseInstructor.length; i++)
671             if (CourseUIds[CourseInstructor[i].CourseId] == CourseUId) {
672                 courseInstructors[courseInstructorCount] = CourseInstructor[i].InstructorId;
673                 courseInstructorCount++;
674                 len += Instructor[InstructorUIds[CourseInstructor[i].InstructorId]].length + 20;
675             }
676         instructors = new bytes(len);
677         if (courseInstructorCount == 1) {
678             copyBytesNToBytes('"Instructor":"', instructors, pointer);
679             copyBytesToBytes(Instructor[InstructorUIds[courseInstructors[0]]], instructors, pointer);
680             copyBytesNToBytes('"', instructors, pointer);
681         }
682         else {
683             copyBytesNToBytes('"Instructors":[', instructors, pointer);
684             for (i=0; i<courseInstructorCount; i++){
685                 if (i > 0)
686                     copyBytesNToBytes(',', instructors, pointer);
687                 copyBytesNToBytes('"', instructors, pointer);
688                 copyBytesToBytes(Instructor[InstructorUIds[courseInstructors[i]]], instructors, pointer);
689                 copyBytesNToBytes('"', instructors, pointer);
690             }
691             copyBytesNToBytes(']', instructors, pointer);
692         }
693         return(instructors);
694    }
695 }