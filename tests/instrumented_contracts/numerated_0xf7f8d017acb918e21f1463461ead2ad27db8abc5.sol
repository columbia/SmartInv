1 pragma solidity 0.4.23;
2 
3 
4 library SafeMath {
5 
6   /**
7   * @dev Multiplies two numbers, throws on overflow.
8   */
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13         uint256 c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18   /**
19   * @dev Integer division of two numbers, truncating the quotient.
20   */
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return c;
26     }
27 
28   /**
29   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30   */
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         assert(b <= a);
33         return a - b;
34     }
35 
36     /**
37     * @dev Adds two numbers, throws on overflow.
38     */
39     function add(uint256 a, uint256 b) internal pure returns (uint256) {
40         uint256 c = a + b;
41         assert(c >= a);
42         return c;
43     }
44 }
45 
46 
47 contract ERC20Basic {
48     function totalSupply() public view returns (uint256);
49     function balanceOf(address who) public view returns (uint256);
50     function transfer(address to, uint256 value) public returns (bool);
51     event Transfer(address indexed from, address indexed to, uint256 value);
52 }
53 
54 
55 contract ERC20 is ERC20Basic {
56     function allowance(address owner, address spender) public view returns (uint256);
57     function transferFrom(address from, address to, uint256 value) public returns (bool);
58     function approve(address spender, uint256 value) public returns (bool);
59     event Approval(address indexed owner, address indexed spender, uint256 value);
60 }
61 
62 
63 /// @title Escrow contract
64 /// @author Farah Brunache
65 /// @notice It's an escrow contract for creating, claiming and rewarding jobs.
66 
67 contract Escrow{
68 
69     using SafeMath for uint;
70     enum JobStatus { Open, inProgress, Completed, Cancelled }
71 
72     struct Job{
73         string description;               // description of job
74         // uint JobID;                       // Id of the job
75         address manager;                  // address of manager
76         uint salaryDeposited;             // salary deposited by manager
77         address worker;                   // address of worker
78         JobStatus status;                 // current status of the job
79         uint noOfTotalPayments;           // total number of Payments set by the manager
80         uint noOfPaymentsMade;            // number of payments that have already been made
81         uint paymentAvailableForWorker;   // amount of DAI tokens available for the worker as claimable
82         uint totalPaidToWorker;           // total amount of DAI tokens paid to worker so far for this job
83         address evaluator;                // address of evaluator for this job
84         bool proofOfLastWorkVerified;     // status of the proof of work for the last milestone
85         uint sponsoredTokens;             // amount of DAI tokens sponsored to the job
86         mapping(address => uint) sponsors; // mapping of all the sponsors with their contributions for a job
87         address[] sponsorList;             // List of addresses for all sponsors for iterations
88         uint sponsorsCount;                // total number of contributors for this job
89     }
90 
91     Job[] public Jobs;                    // List of all the jobs
92 
93 
94     mapping(address => uint[]) public JobsByManager;        // all the jobs held by a manager
95     mapping(address => uint[]) public JobsByWorker;         // all the jobs held by a worker
96 
97 
98     ERC20 public DAI;
99 
100     uint public jobCount = 0;     // current count of the total Jobs
101 
102     address public arbitrator;     // address of arbitrator
103 
104     constructor(address _DAI, address _arbitrator) public{
105         DAI = ERC20(_DAI);
106         arbitrator = _arbitrator;
107     }
108 
109 
110     modifier onlyArbitrator{
111         require(msg.sender == arbitrator);
112         _;
113     }
114 
115     event JobCreated(address manager, uint salary, uint noOfTotalPayments, uint JobID, string description, address _evaluator);
116 
117     /// @notice this function creates a job
118     /// @dev Uses transferFrom on the DAI token contract
119     /// @param _salary is the amount of salary deposited by the manager
120     /// @param _noOfTotalPayments is the number of total payments iterations set by the manager
121     function createJob(string _description, uint _salary, uint _noOfTotalPayments, address _evaluator) public {
122         require(_salary > 0);
123         require(_noOfTotalPayments > 0);
124 
125         address[] memory empty;
126         uint finalSalary = _salary.sub(_salary.mul(1).div(10));
127 
128         Job memory newJob = Job(_description, msg.sender, finalSalary, 0x0, JobStatus.Open, _noOfTotalPayments, 0, 0, 0, _evaluator, false, 0, empty, 0);
129         Jobs.push(newJob);
130         JobsByManager[msg.sender].push(jobCount);
131 
132         require(DAI.allowance(msg.sender, address(this)) >= _salary);
133 
134         emit JobCreated(msg.sender, finalSalary, _noOfTotalPayments, jobCount, _description, _evaluator);
135         jobCount++;
136 
137         DAI.transferFrom(msg.sender, address(this), _salary);
138 
139     }
140 
141 
142     event JobClaimed(address worker, uint JobID);
143 
144     /// @notice this function lets the worker claim the job
145     /// @dev Uses transferFrom on the DAI token contract
146     /// @param _JobID is the ID of the job to be claimed by the worker
147     function claimJob(uint _JobID) public {
148         require(_JobID >= 0);
149 
150         Job storage job = Jobs[_JobID];
151 
152         require(msg.sender != job.manager);
153         require(msg.sender != job.evaluator);
154 
155         require(job.status == JobStatus.Open);
156 
157         job.worker = msg.sender;
158         job.status = JobStatus.inProgress;
159 
160         JobsByWorker[msg.sender].push(_JobID);
161         emit JobClaimed(msg.sender, _JobID);
162 
163 
164     }
165 
166 
167     event EvaluatorSet(uint JobID, address evaluator);
168 
169     /// @notice this function lets a registered address become an evaluator for a job
170     /// @param _JobID is the ID of the job for which the sender wants to become an evaluator
171     function setEvaluator(uint _JobID) public {
172         require(_JobID >= 0);
173 
174         Job storage job = Jobs[_JobID];
175 
176         require(msg.sender != job.manager);
177         require(msg.sender != job.worker);
178 
179         job.evaluator = msg.sender;
180         emit EvaluatorSet(_JobID, msg.sender);
181 
182     }
183 
184 
185     event JobCancelled(uint JobID);
186 
187     /// @notice this function lets the manager or arbitrator cancel the job
188     /// @dev Uses transfer on the DAI token contract to return DAI from escrow to manager
189     /// @param _JobID is the ID of the job to be cancelled
190     function cancelJob(uint _JobID) public {
191         require(_JobID >= 0);
192 
193         Job storage job = Jobs[_JobID];
194 
195         if(msg.sender != arbitrator){
196             require(job.manager == msg.sender);
197             require(job.worker == 0x0);
198             require(job.status == JobStatus.Open);
199         }
200 
201         job.status = JobStatus.Cancelled;
202         uint returnAmount = job.salaryDeposited;
203 
204         emit JobCancelled(_JobID);
205         DAI.transfer(job.manager, returnAmount);
206     }
207 
208 
209     event PaymentClaimed(address worker, uint amount, uint JobID);
210 
211     /// @notice this function lets the worker claim the approved payment
212     /// @dev Uses transfer on the DAI token contract to send DAI from escrow to worker
213     /// @param _JobID is the ID of the job from which the worker intends to claim the DAI tokens
214     function claimPayment(uint _JobID) public {
215         require(_JobID >= 0);
216         Job storage job = Jobs[_JobID];
217 
218         require(job.worker == msg.sender);
219         require(job.noOfPaymentsMade > 0);
220 
221         uint payment = job.paymentAvailableForWorker;
222         require(payment > 0);
223 
224         job.paymentAvailableForWorker = 0;
225         job.totalPaidToWorker = job.totalPaidToWorker + payment;
226         emit PaymentClaimed(msg.sender, payment, _JobID);
227         DAI.transfer(msg.sender, payment);
228 
229     }
230 
231 
232     event PaymentApproved(address manager, uint JobID, uint amount);
233 
234     /// @notice this function lets the manager to approve payment
235     /// @param _JobID is the ID of the job for which the payment is approved
236     function approvePayment(uint _JobID) public {
237         require(_JobID >= 0);
238 
239         Job storage job = Jobs[_JobID];
240 
241         if(msg.sender != arbitrator){
242             require(job.manager == msg.sender);
243             require(job.proofOfLastWorkVerified == true);
244         }
245         require(job.noOfTotalPayments > job.noOfPaymentsMade);
246 
247         uint currentPayment = job.salaryDeposited.div(job.noOfTotalPayments);
248 
249         job.paymentAvailableForWorker = job.paymentAvailableForWorker + currentPayment;
250         job.salaryDeposited = job.salaryDeposited - currentPayment;
251         job.noOfPaymentsMade++;
252 
253         if(job.noOfTotalPayments == job.noOfPaymentsMade){
254             job.status = JobStatus.Completed;
255         }
256 
257         emit PaymentApproved(msg.sender, _JobID, currentPayment);
258 
259     }
260 
261 
262     event EvaluatorPaid(address manager, address evaluator, uint JobID, uint payment);
263 
264     /// @notice this function lets the manager pay DAI to arbitrator
265     /// @dev Uses transferFrom on the DAI token contract to send DAI from manager to evaluator
266     /// @param _JobID is the ID of the job for which the evaluator is to be paid
267     /// @param _payment is the amount of DAI tokens to be paid to evaluator
268     function payToEvaluator(uint _JobID, uint _payment) public {
269         require(_JobID >= 0);
270         require(_payment > 0);
271 
272         Job storage job = Jobs[_JobID];
273         require(msg.sender == job.manager);
274 
275         address evaluator = job.evaluator;
276 
277         require(DAI.allowance(job.manager, address(this)) >= _payment);
278 
279         emit EvaluatorPaid(msg.sender, evaluator, _JobID, _payment);
280         DAI.transferFrom(job.manager, evaluator, _payment);
281 
282 
283     }
284 
285 
286     event ProofOfWorkConfirmed(uint JobID, address evaluator, bool proofVerified);
287 
288     /// @notice this function lets the evaluator confirm the proof of work provided by worker
289     /// @param _JobID is the ID of the job for which the evaluator confirms proof of work
290     function confirmProofOfWork(uint _JobID) public {
291         require(_JobID >= 0);
292 
293         Job storage job = Jobs[_JobID];
294         require(msg.sender == job.evaluator);
295 
296         job.proofOfLastWorkVerified = true;
297 
298         emit ProofOfWorkConfirmed(_JobID, job.evaluator, true);
299 
300     }
301 
302     event ProofOfWorkProvided(uint JobID, address worker, bool proofProvided);
303 
304     /// @notice this function lets the worker provide proof of work
305     /// @param _JobID is the ID of the job for which worker provides proof
306     function provideProofOfWork(uint _JobID) public {
307         require(_JobID >= 0);
308 
309         Job storage job = Jobs[_JobID];
310         require(msg.sender == job.worker);
311 
312         job.proofOfLastWorkVerified = false;
313         emit ProofOfWorkProvided(_JobID, msg.sender, true);
314 
315     }
316 
317 
318     event TipMade(address from, address to, uint amount);
319 
320     /// @notice this function lets any registered address send DAI tokens to any other address
321     /// @dev Uses transferFrom on the DAI token contract to send DAI from sender's address to receiver's address
322     /// @param _to is the address of the receiver receiving the DAI tokens
323     /// @param _amount is the amount of DAI tokens to be paid to receiving address
324     function tip(address _to, uint _amount) public {
325         require(_to != 0x0);
326         require(_amount > 0);
327         require(DAI.allowance(msg.sender, address(this)) >= _amount);
328 
329         emit TipMade(msg.sender, _to, _amount);
330         DAI.transferFrom(msg.sender, _to, _amount);
331     }
332 
333 
334     event DAISponsored(uint JobID, uint amount, address sponsor);
335 
336     /// @notice this function lets any registered address send DAI tokens to any Job as sponsored tokens
337     /// @dev Uses transferFrom on the DAI token contract to send DAI from sender's address to Escrow
338     /// @param _JobID is the ID of the job for which the sponsor contributes DAI
339     /// @param _amount is the amount of DAI tokens to be sponsored to the Job
340     function sponsorDAI(uint _JobID, uint _amount) public {
341         require(_JobID >= 0);
342         require(_amount > 0);
343 
344         Job storage job = Jobs[_JobID];
345         require(job.status == JobStatus.inProgress);
346 
347         if(job.sponsors[msg.sender] == 0){
348             job.sponsorList.push(msg.sender);
349         }
350 
351         job.sponsors[msg.sender] = job.sponsors[msg.sender] + _amount;
352         job.sponsoredTokens = job.sponsoredTokens + _amount;
353 
354         job.paymentAvailableForWorker = job.paymentAvailableForWorker + _amount;
355 
356 
357         job.sponsorsCount = job.sponsorsCount + 1;
358         emit DAISponsored(_JobID, _amount, msg.sender);
359 
360         require(DAI.allowance(msg.sender, address(this)) >= _amount);
361         DAI.transferFrom(msg.sender, address(this), _amount);
362     }
363 
364     event DAIWithdrawn(address receiver,uint amount);
365 
366     /// @notice this function lets arbitrator withdraw DAI to the provided address
367     /// @dev Uses transfer on the DAI token contract to send DAI from Escrow to the provided address
368     /// @param _receiver is the receiving the withdrawn DAI tokens
369     /// @param _amount is the amount of DAI tokens to be withdrawn
370     function withdrawDAI(address _receiver, uint _amount) public onlyArbitrator {
371         require(_receiver != 0x0);
372         require(_amount > 0);
373 
374         require(DAI.balanceOf(address(this)) >= _amount);
375 
376         DAI.transfer(_receiver, _amount);
377         emit DAIWithdrawn(_receiver, _amount);
378     }
379 
380 
381     /// @notice this function lets get an amount of sponsored DAI by an address in a given job
382     /// @param _JobID is the Job for the job
383     /// @param _sponsor is the address of sponsor for which we are retreiving the sponsored tokens amount
384     function get_Sponsored_Amount_in_Job_By_Address(uint _JobID, address _sponsor) public view returns (uint) {
385         require(_JobID >= 0);
386         require(_sponsor != 0x0);
387 
388         Job storage job = Jobs[_JobID];
389 
390         return job.sponsors[_sponsor];
391     }
392 
393 
394     /// @notice this function lets retrieve the list of all sponsors in a given job
395     /// @param _JobID is the Job for the job for which we are retrieving the list of sponsors
396     function get_Sponsors_list_by_Job(uint _JobID) public view returns (address[] list) {
397         require(_JobID >= 0);
398 
399         Job storage job = Jobs[_JobID];
400 
401         list = new address[](job.sponsorsCount);
402 
403         list = job.sponsorList;
404     }
405 
406 
407     function getJob(uint _JobID) public view returns ( string _description, address _manager, uint _salaryDeposited, address _worker, uint _status, uint _noOfTotalPayments, uint _noOfPaymentsMade, uint _paymentAvailableForWorker, uint _totalPaidToWorker, address _evaluator, bool _proofOfLastWorkVerified, uint _sponsoredTokens, uint _sponsorsCount) {
408         require(_JobID >= 0);
409 
410         Job storage job = Jobs[_JobID];
411         _description = job.description;
412         _manager = job.manager;
413         _salaryDeposited = job.salaryDeposited;
414         _worker = job.worker;
415         _status = uint(job.status);
416         _noOfTotalPayments = job.noOfTotalPayments;
417         _noOfPaymentsMade = job.noOfPaymentsMade;
418         _paymentAvailableForWorker = job.paymentAvailableForWorker;
419         _totalPaidToWorker = job.totalPaidToWorker;
420         _evaluator = job.evaluator;
421         _proofOfLastWorkVerified = job.proofOfLastWorkVerified;
422         _sponsoredTokens = job.sponsoredTokens;
423         _sponsorsCount = job.sponsorsCount;
424     }
425 
426 }