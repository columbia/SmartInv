1 pragma solidity ^0.5.3;
2 
3 library SafeMath {
4     /**
5     * @dev Multiplies two unsigned integers, reverts on overflow.
6     */
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
9         // benefit is lost if 'b' is also tested.
10         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
11         if (a == 0) {
12             return 0;
13         }
14 
15         uint256 c = a * b;
16         require(c / a == b);
17 
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // Solidity only automatically asserts when dividing by 0
26         require(b > 0);
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 
30         return c;
31     }
32 
33     /**
34     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b <= a);
38         uint256 c = a - b;
39 
40         return c;
41     }
42 
43     /**
44     * @dev Adds two unsigned integers, reverts on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a);
49 
50         return c;
51     }
52 
53     /**
54     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
55     * reverts when dividing by zero.
56     */
57     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58         require(b != 0);
59         return a % b;
60     }
61 }
62 
63 contract Ownable {
64     address private _owner;
65 
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68     /**
69      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
70      * account.
71      */
72     constructor () internal {
73         _owner = msg.sender;
74         emit OwnershipTransferred(address(0), _owner);
75     }
76 
77     /**
78      * @return the address of the owner.
79      */
80     function owner() public view returns (address) {
81         return _owner;
82     }
83 
84     /**
85      * @dev Throws if called by any account other than the owner.
86      */
87     modifier onlyOwner() {
88         require(isOwner());
89         _;
90     }
91 
92     /**
93      * @return true if `msg.sender` is the owner of the contract.
94      */
95     function isOwner() public view returns (bool) {
96         return msg.sender == _owner;
97     }
98 
99     /**
100      * @dev Allows the current owner to relinquish control of the contract.
101      * @notice Renouncing to ownership will leave the contract without an owner.
102      * It will not be possible to call the functions with the `onlyOwner`
103      * modifier anymore.
104      */
105     function renounceOwnership() public onlyOwner {
106         emit OwnershipTransferred(_owner, address(0));
107         _owner = address(0);
108     }
109 
110     /**
111      * @dev Allows the current owner to transfer control of the contract to a newOwner.
112      * @param newOwner The address to transfer ownership to.
113      */
114     function transferOwnership(address newOwner) public onlyOwner {
115         _transferOwnership(newOwner);
116     }
117 
118     /**
119      * @dev Transfers control of the contract to a newOwner.
120      * @param newOwner The address to transfer ownership to.
121      */
122     function _transferOwnership(address newOwner) internal {
123         require(newOwner != address(0));
124         emit OwnershipTransferred(_owner, newOwner);
125         _owner = newOwner;
126     }
127 }
128 
129 contract SuperOwner is Ownable{
130     event Execution(address destination,uint value,bytes data);
131     event ExecutionFailure(address destination,uint value);
132 
133     /**
134     * @notice Proxy function which allows sending of transactions
135     * in behalf of the contract
136     */
137     function executeTransaction(
138         address payable destination,
139         uint value,
140         bytes memory data
141     ) public onlyOwner {
142         (
143             bool executed,
144             bytes memory responseData
145         ) = destination.call.value(value)(data);
146         if (executed) {
147             emit Execution(destination,value,responseData);
148         } else {
149             emit ExecutionFailure(destination,value);
150         }
151     }
152 }
153 
154 contract ProvenanceDocuments is Ownable, SuperOwner{
155     using SafeMath for uint256;
156 
157     struct Document {
158         string name;
159         bytes32 hash_;
160         uint256 createdAt;
161         bool exist;
162     }
163 
164     struct Type {
165         string name;
166         uint256 versionsCount;
167         bool exist;
168         mapping (uint256 => Document) versions;
169     }
170 
171     mapping (bytes32 => Type) private document_types_;
172 
173     uint256 private document_types_count_;
174 
175     event TypeAdded(string name, bytes32 hash_);
176     event TypeRemoved(string name, bytes32 hash_, uint256 versions);
177 
178     event DocumentAdded(string name, bytes32 hash_, uint256 version);
179 
180     constructor () public Ownable(){
181         string[5] memory baseTypes = [
182             "AuthenticityCertificate",
183             "ConditionReport",
184             "IdentifiedDamages",
185             "ArtworkInsuranceCertificate",
186             "CertificateOfValuation"
187         ];
188         for (uint256 i; i < baseTypes.length; i++){
189             addType(baseTypes[i]);
190         }
191     }
192 
193     // Modifiers
194 
195     modifier onlyNonexistentTypeName(string memory name){
196         require(!typeNameExist(name), "Document type exists");
197         _;
198     }
199 
200     modifier onlyNonexistentType(bytes32 hash_){
201         require(!typeExist(hash_), "Document type exists");
202         _;
203     }
204 
205     modifier onlyExistentType(bytes32 hash_){
206         require(typeExist(hash_), "Document type not exists");
207         _;
208     }
209 
210     modifier onlyExistentTypeVersion(bytes32 hash_, uint256 version){
211         require(typeVersionExist(hash_, version), "Document version not exist");
212         _;
213     }
214 
215     // Getters
216 
217     function typeExist(bytes32 hash_) public view returns (bool){
218         return document_types_[hash_].exist;
219     }
220     
221     function typeNameExist(string memory name) public view returns (bool){
222         bytes32 hash_ = keccak256(abi.encodePacked(name));
223         return typeExist(hash_);
224     }
225 
226     function typeVersionExist(bytes32 hash_, uint256 version) public view onlyExistentType(hash_) returns (bool){
227         if (typeExist(hash_)){
228             if (version < document_types_[hash_].versionsCount){
229                 return document_types_[hash_].versions[version].exist;
230             }
231         }
232         return false;
233     }
234 
235     function typesCount() public view returns(uint256){
236         return document_types_count_;
237     }
238 
239     function typeHash(string memory name) public view onlyNonexistentTypeName(name) returns(bytes32){
240         bytes32 hash_ = keccak256(abi.encodePacked(name));
241         require(typeExist(hash_), "Document type not exists");
242         return hash_;
243     }
244 
245     function typeVersionsCount(bytes32 hash_) public view onlyExistentType(hash_) returns(uint256){
246         return document_types_[hash_].versionsCount;
247     }
248 
249     function getDocumentVersion(
250         bytes32 type_,
251         uint256 version) 
252         public view onlyExistentType(type_) onlyExistentTypeVersion(type_, version) 
253     returns(
254         string memory name,
255         bytes32 hash_,
256         uint256 createdAt
257     ){
258         Document memory document = document_types_[type_].versions[version];
259         name = document.name;
260         hash_ = document.hash_;
261         createdAt = document.createdAt;
262     }
263 
264     function getDocument(bytes32 type_) public view onlyExistentType(type_)
265     returns(
266         string memory name,
267         bytes32 hash_,
268         uint256 version,
269         uint256 createdAt
270     ){
271         version = document_types_[type_].versionsCount.sub(1);
272 
273         Document memory document = document_types_[type_].versions[version];
274 
275         name = document.name;
276         hash_ = document.hash_;
277         createdAt = document.createdAt;
278     }
279     
280     // Public
281 
282     function addType(string memory name) public onlyOwner onlyNonexistentTypeName(name){
283         bytes32 hash_ = keccak256(abi.encodePacked(name));
284         document_types_[hash_] = Type(name, 0, true);
285         document_types_count_ = document_types_count_.add(1);
286         emit TypeAdded(name, hash_);
287     }
288 
289     function removeType(bytes32 hash_) public onlyOwner onlyExistentType(hash_){
290         uint256 versions = document_types_[hash_].versionsCount;
291         string memory name = document_types_[hash_].name;
292         document_types_[hash_] = Type("", 0, false);
293         document_types_count_ = document_types_count_.sub(1);
294         emit TypeRemoved(name, hash_, versions);
295     }
296 
297     function addDocument(bytes32 type_, string memory name, bytes32 hash_) public onlyOwner onlyExistentType(type_){
298         uint256 versionNumber = document_types_[type_].versionsCount;
299         document_types_[type_].versions[versionNumber] = Document(
300             name,
301             hash_,
302             now,
303             true
304         );
305         document_types_[type_].versionsCount = versionNumber.add(1);
306         emit DocumentAdded(
307             name,
308             hash_,
309             versionNumber
310         );
311     }
312 
313 }