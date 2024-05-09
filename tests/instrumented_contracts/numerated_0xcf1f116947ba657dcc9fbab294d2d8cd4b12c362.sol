1 pragma solidity 0.4.24;
2 
3 // File: contracts\safe_math_lib.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11     /**
12     * @dev Multiplies two numbers, reverts on overflow.
13     */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16         // benefit is lost if 'b' is also tested.
17         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18         if (a == 0) {
19             return 0;
20         }
21 
22         uint256 c = a * b;
23         require(c / a == b);
24 
25         return c;
26     }
27 
28     /**
29     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30     */
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         require(b > 0); // Solidity only automatically asserts when dividing by 0
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two numbers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: contracts\database.sol
70 
71 contract database {
72 
73     /* libraries */
74     using SafeMath for uint256;
75 
76     /* struct declarations */
77     struct participant {
78         address eth_address; // your eth address
79         uint256 topl_address; // your topl address
80         uint256 arbits; // the amount of a arbits you have
81         uint256 num_of_pro_rata_tokens_alloted;
82         bool arbits_kyc_whitelist; // if you pass arbits level kyc you get this
83         uint8 num_of_uses;
84     }
85 
86     /* variable declarations */
87     // permission variables
88     mapping(address => bool) public sale_owners;
89     mapping(address => bool) public owners;
90     mapping(address => bool) public masters;
91     mapping(address => bool) public kycers;
92 
93     // database mapping
94     mapping(address => participant) public participants;
95     address[] public participant_keys;
96 
97     // sale open variables
98     bool public arbits_presale_open = false; // Presale variables
99     bool public iconiq_presale_open = false; // ^^^^^^^^^^^^^^^^^
100     bool public arbits_sale_open = false; // Main sale variables
101 
102     // sale state variables
103     uint256 public pre_kyc_bonus_denominator;
104     uint256 public pre_kyc_bonus_numerator;
105     uint256 public pre_kyc_iconiq_bonus_denominator;
106     uint256 public pre_kyc_iconiq_bonus_numerator;
107 
108     uint256 public contrib_arbits_min;
109     uint256 public contrib_arbits_max;
110 
111     // presale variables
112     uint256 public presale_arbits_per_ether;        // two different prices, but same cap
113     uint256 public presale_iconiq_arbits_per_ether; // and sold values
114     uint256 public presale_arbits_total = 18000000;
115     uint256 public presale_arbits_sold;
116 
117     // main sale variables
118     uint256 public sale_arbits_per_ether;
119     uint256 public sale_arbits_total;
120     uint256 public sale_arbits_sold;
121 
122     /* constructor */
123     constructor() public {
124         owners[msg.sender] = true;
125     }
126 
127     /* permission functions */
128     function add_owner(address __subject) public only_owner {
129         owners[__subject] = true;
130     }
131 
132     function remove_owner(address __subject) public only_owner {
133         owners[__subject] = false;
134     }
135 
136     function add_master(address _subject) public only_owner {
137         masters[_subject] = true;
138     }
139 
140     function remove_master(address _subject) public only_owner {
141         masters[_subject] = false;
142     }
143 
144     function add_kycer(address _subject) public only_owner {
145         kycers[_subject] = true;
146     }
147 
148     function remove_kycer(address _subject) public only_owner {
149         kycers[_subject] = false;
150     }
151 
152     /* modifiers */
153     modifier log_participant_update(address __eth_address) {
154         participant_keys.push(__eth_address); // logs the given address in participant_keys
155         _;
156     }
157 
158     modifier only_owner() {
159         require(owners[msg.sender]);
160         _;
161     }
162 
163     modifier only_kycer() {
164         require(kycers[msg.sender]);
165         _;
166     }
167 
168     modifier only_master_or_owner() {
169         require(masters[msg.sender] || owners[msg.sender]);
170         _;
171     }
172 
173     /* database functions */
174     // GENERAL VARIABLE getters & setters
175     // getters    
176     function get_sale_owner(address _a) public view returns(bool) {
177         return sale_owners[_a];
178     }
179     
180     function get_contrib_arbits_min() public view returns(uint256) {
181         return contrib_arbits_min;
182     }
183 
184     function get_contrib_arbits_max() public view returns(uint256) {
185         return contrib_arbits_max;
186     }
187 
188     function get_pre_kyc_bonus_numerator() public view returns(uint256) {
189         return pre_kyc_bonus_numerator;
190     }
191 
192     function get_pre_kyc_bonus_denominator() public view returns(uint256) {
193         return pre_kyc_bonus_denominator;
194     }
195 
196     function get_pre_kyc_iconiq_bonus_numerator() public view returns(uint256) {
197         return pre_kyc_iconiq_bonus_numerator;
198     }
199 
200     function get_pre_kyc_iconiq_bonus_denominator() public view returns(uint256) {
201         return pre_kyc_iconiq_bonus_denominator;
202     }
203 
204     function get_presale_iconiq_arbits_per_ether() public view returns(uint256) {
205         return (presale_iconiq_arbits_per_ether);
206     }
207 
208     function get_presale_arbits_per_ether() public view returns(uint256) {
209         return (presale_arbits_per_ether);
210     }
211 
212     function get_presale_arbits_total() public view returns(uint256) {
213         return (presale_arbits_total);
214     }
215 
216     function get_presale_arbits_sold() public view returns(uint256) {
217         return (presale_arbits_sold);
218     }
219 
220     function get_sale_arbits_per_ether() public view returns(uint256) {
221         return (sale_arbits_per_ether);
222     }
223 
224     function get_sale_arbits_total() public view returns(uint256) {
225         return (sale_arbits_total);
226     }
227 
228     function get_sale_arbits_sold() public view returns(uint256) {
229         return (sale_arbits_sold);
230     }
231 
232     // setters
233     function set_sale_owner(address _a, bool _v) public only_master_or_owner {
234         sale_owners[_a] = _v;
235     }
236 
237     function set_contrib_arbits_min(uint256 _v) public only_master_or_owner {
238         contrib_arbits_min = _v;
239     }
240 
241     function set_contrib_arbits_max(uint256 _v) public only_master_or_owner {
242         contrib_arbits_max = _v;
243     }
244 
245     function set_pre_kyc_bonus_numerator(uint256 _v) public only_master_or_owner {
246         pre_kyc_bonus_numerator = _v;
247     }
248 
249     function set_pre_kyc_bonus_denominator(uint256 _v) public only_master_or_owner {
250         pre_kyc_bonus_denominator = _v;
251     }
252 
253     function set_pre_kyc_iconiq_bonus_numerator(uint256 _v) public only_master_or_owner {
254         pre_kyc_iconiq_bonus_numerator = _v;
255     }
256 
257     function set_pre_kyc_iconiq_bonus_denominator(uint256 _v) public only_master_or_owner {
258         pre_kyc_iconiq_bonus_denominator = _v;
259     }
260 
261     function set_presale_iconiq_arbits_per_ether(uint256 _v) public only_master_or_owner {
262         presale_iconiq_arbits_per_ether = _v;
263     }
264 
265     function set_presale_arbits_per_ether(uint256 _v) public only_master_or_owner {
266         presale_arbits_per_ether = _v;
267     }
268 
269     function set_presale_arbits_total(uint256 _v) public only_master_or_owner {
270         presale_arbits_total = _v;
271     }
272 
273     function set_presale_arbits_sold(uint256 _v) public only_master_or_owner {
274         presale_arbits_sold = _v;
275     }
276 
277     function set_sale_arbits_per_ether(uint256 _v) public only_master_or_owner {
278         sale_arbits_per_ether = _v;
279     }
280 
281     function set_sale_arbits_total(uint256 _v) public only_master_or_owner {
282         sale_arbits_total = _v;
283     }
284 
285     function set_sale_arbits_sold(uint256 _v) public only_master_or_owner {
286         sale_arbits_sold = _v;
287     }
288 
289     // PARTICIPANT SPECIFIC getters and setters
290     // getters
291     function get_participant(address _a) public view returns(
292         address,
293         uint256,
294         uint256,
295         uint256,
296         bool,
297         uint8
298     ) {
299         participant storage subject = participants[_a];
300         return (
301             subject.eth_address,
302             subject.topl_address,
303             subject.arbits,
304             subject.num_of_pro_rata_tokens_alloted,
305             subject.arbits_kyc_whitelist,
306             subject.num_of_uses
307         );
308     }
309 
310     function get_participant_num_of_uses(address _a) public view returns(uint8) {
311         return (participants[_a].num_of_uses);
312     }
313 
314     function get_participant_topl_address(address _a) public view returns(uint256) {
315         return (participants[_a].topl_address);
316     }
317 
318     function get_participant_arbits(address _a) public view returns(uint256) {
319         return (participants[_a].arbits);
320     }
321 
322     function get_participant_num_of_pro_rata_tokens_alloted(address _a) public view returns(uint256) {
323         return (participants[_a].num_of_pro_rata_tokens_alloted);
324     }
325 
326     function get_participant_arbits_kyc_whitelist(address _a) public view returns(bool) {
327         return (participants[_a].arbits_kyc_whitelist);
328     }
329 
330     // setters
331     function set_participant(
332         address _a,
333         uint256 _ta,
334         uint256 _arbits,
335         uint256 _prta,
336         bool _v3,
337         uint8 _nou
338     ) public only_master_or_owner log_participant_update(_a) {
339         participant storage subject = participants[_a];
340         subject.eth_address = _a;
341         subject.topl_address = _ta;
342         subject.arbits = _arbits;
343         subject.num_of_pro_rata_tokens_alloted = _prta;
344         subject.arbits_kyc_whitelist = _v3;
345         subject.num_of_uses = _nou;
346     }
347 
348     function set_participant_num_of_uses(
349         address _a,
350         uint8 _v
351     ) public only_master_or_owner log_participant_update(_a) {
352         participants[_a].num_of_uses = _v;
353     }
354 
355     function set_participant_topl_address(
356         address _a,
357         uint256 _ta
358     ) public only_master_or_owner log_participant_update(_a) {
359         participants[_a].topl_address = _ta;
360     }
361 
362     function set_participant_arbits(
363         address _a,
364         uint256 _v
365     ) public only_master_or_owner log_participant_update(_a) {
366         participants[_a].arbits = _v;
367     }
368 
369     function set_participant_num_of_pro_rata_tokens_alloted(
370         address _a,
371         uint256 _v
372     ) public only_master_or_owner log_participant_update(_a) {
373         participants[_a].num_of_pro_rata_tokens_alloted = _v;
374     }
375 
376     function set_participant_arbits_kyc_whitelist(
377         address _a,
378         bool _v
379     ) public only_kycer log_participant_update(_a) {
380         participants[_a].arbits_kyc_whitelist = _v;
381     }
382 
383 
384     //
385     // STATE FLAG FUNCTIONS: Getter, setter, and toggling functions for state flags.
386 
387     // GETTERS
388     function get_iconiq_presale_open() public view only_master_or_owner returns(bool) {
389         return iconiq_presale_open;
390     }
391 
392     function get_arbits_presale_open() public view only_master_or_owner returns(bool) {
393         return arbits_presale_open;
394     }
395 
396     function get_arbits_sale_open() public view only_master_or_owner returns(bool) {
397         return arbits_sale_open;
398     }
399 
400     // SETTERS
401     function set_iconiq_presale_open(bool _v) public only_master_or_owner {
402         iconiq_presale_open = _v;
403     }
404 
405     function set_arbits_presale_open(bool _v) public only_master_or_owner {
406         arbits_presale_open = _v;
407     }
408 
409     function set_arbits_sale_open(bool _v) public only_master_or_owner {
410         arbits_sale_open = _v;
411     }
412 
413 }