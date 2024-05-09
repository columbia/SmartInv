1 pragma solidity ^0.4.21;
2 /**
3  * Changes by https://www.docademic.com/
4  */
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 }
42 /**
43  * @title SafeMath
44  * @dev Math operations with safety checks that throw on error
45  */
46 library SafeMath {
47   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48     if (a == 0) {
49       return 0;
50     }
51     uint256 c = a * b;
52     assert(c / a == b);
53     return c;
54   }
55 
56   function div(uint256 a, uint256 b) internal pure returns (uint256) {
57     // assert(b > 0); // Solidity automatically throws when dividing by 0
58     uint256 c = a / b;
59     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60     return c;
61   }
62 
63   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64     assert(b <= a);
65     return a - b;
66   }
67 
68   function add(uint256 a, uint256 b) internal pure returns (uint256) {
69     uint256 c = a + b;
70     assert(c >= a);
71     return c;
72   }
73 }
74 contract Destroyable is Ownable{
75     /**
76      * @notice Allows to destroy the contract and return the tokens to the owner.
77      */
78     function destroy() public onlyOwner{
79         selfdestruct(owner);
80     }
81 }
82 interface Token {
83     function transfer(address _to, uint256 _value) external;
84 
85     function balanceOf(address who) view external returns (uint256);
86 }
87 
88 contract MultiVesting is Ownable, Destroyable {
89     using SafeMath for uint256;
90 
91     // beneficiary of tokens
92     struct Beneficiary {
93         string description;
94         uint256 vested;
95         uint256 released;
96         uint256 start;
97         uint256 cliff;
98         uint256 duration;
99         bool revoked;
100         bool revocable;
101         bool isBeneficiary;
102     }
103 
104     event Released(address _beneficiary, uint256 amount);
105     event Revoked(address _beneficiary);
106     event NewBeneficiary(address _beneficiary);
107     event BeneficiaryDestroyed(address _beneficiary);
108 
109 
110     mapping(address => Beneficiary) public beneficiaries;
111     address[] public addresses;
112     Token public token;
113     uint256 public totalVested;
114     uint256 public totalReleased;
115 
116     /*
117      *  Modifiers
118      */
119     modifier isNotBeneficiary(address _beneficiary) {
120         require(!beneficiaries[_beneficiary].isBeneficiary);
121         _;
122     }
123     modifier isBeneficiary(address _beneficiary) {
124         require(beneficiaries[_beneficiary].isBeneficiary);
125         _;
126     }
127 
128     modifier wasRevoked(address _beneficiary) {
129         require(beneficiaries[_beneficiary].revoked);
130         _;
131     }
132 
133     modifier wasNotRevoked(address _beneficiary) {
134         require(!beneficiaries[_beneficiary].revoked);
135         _;
136     }
137 
138     /**
139      * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
140      * beneficiary, gradually in a linear fashion until _start + _duration. By then all
141      * of the balance will have vested.
142      * @param _token address of the token of vested tokens
143      */
144     function MultiVesting (address _token) public {
145         require(_token != address(0));
146         token = Token(_token);
147     }
148 
149     function() payable public {
150         release(msg.sender);
151     }
152 
153     /**
154      * @notice Transfers vested tokens to beneficiary (alternative to fallback function).
155      */
156     function release() public {
157         release(msg.sender);
158     }
159 
160     /**
161      * @notice Transfers vested tokens to beneficiary.
162      * @param _beneficiary Beneficiary address
163      */
164     function release(address _beneficiary) private
165     isBeneficiary(_beneficiary)
166     {
167         Beneficiary storage beneficiary = beneficiaries[_beneficiary];
168 
169         uint256 unreleased = releasableAmount(_beneficiary);
170 
171         require(unreleased > 0);
172 
173         beneficiary.released = beneficiary.released.add(unreleased);
174 
175         totalReleased = totalReleased.add(unreleased);
176 
177         token.transfer(_beneficiary, unreleased);
178 
179         if ((beneficiary.vested - beneficiary.released) == 0) {
180             beneficiary.isBeneficiary = false;
181         }
182 
183         emit Released(_beneficiary, unreleased);
184     }
185 
186     /**
187      * @notice Allows the owner to transfers vested tokens to beneficiary.
188      * @param _beneficiary Beneficiary address
189      */
190     function releaseTo(address _beneficiary) public onlyOwner {
191         release(_beneficiary);
192     }
193 
194     /**
195      * @dev Add new beneficiary to start vesting
196      * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
197      * @param _start time in seconds which the tokens will vest
198      * @param _cliff time in seconds of the cliff in which tokens will begin to vest
199      * @param _duration duration in seconds of the period in which the tokens will vest
200      * @param _revocable whether the vesting is revocable or not
201      */
202     function addBeneficiary(address _beneficiary, uint256 _vested, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable, string _description)
203     onlyOwner
204     isNotBeneficiary(_beneficiary)
205     public {
206         require(_beneficiary != address(0));
207         require(_cliff >= _start);
208         require(token.balanceOf(this) >= totalVested.sub(totalReleased).add(_vested));
209         beneficiaries[_beneficiary] = Beneficiary({
210             released : 0,
211             vested : _vested,
212             start : _start,
213             cliff : _cliff,
214             duration : _duration,
215             revoked : false,
216             revocable : _revocable,
217             isBeneficiary : true,
218             description : _description
219             });
220         totalVested = totalVested.add(_vested);
221         addresses.push(_beneficiary);
222         emit NewBeneficiary(_beneficiary);
223     }
224 
225     /**
226      * @notice Allows the owner to revoke the vesting. Tokens already vested
227      * remain in the contract, the rest are returned to the owner.
228      * @param _beneficiary Beneficiary address
229      */
230     function revoke(address _beneficiary) public onlyOwner {
231         Beneficiary storage beneficiary = beneficiaries[_beneficiary];
232         require(beneficiary.revocable);
233         require(!beneficiary.revoked);
234 
235         uint256 balance = beneficiary.vested.sub(beneficiary.released);
236 
237         uint256 unreleased = releasableAmount(_beneficiary);
238         uint256 refund = balance.sub(unreleased);
239 
240         token.transfer(owner, refund);
241 
242         totalReleased = totalReleased.add(refund);
243 
244         beneficiary.revoked = true;
245         beneficiary.released = beneficiary.released.add(refund);
246 
247         emit Revoked(_beneficiary);
248     }
249 
250     /**
251      * @notice Allows the owner to destroy a beneficiary. Remain tokens are returned to the owner.
252      * @param _beneficiary Beneficiary address
253      */
254     function destroyBeneficiary(address _beneficiary) public onlyOwner {
255         Beneficiary storage beneficiary = beneficiaries[_beneficiary];
256 
257         uint256 balance = beneficiary.vested.sub(beneficiary.released);
258 
259         token.transfer(owner, balance);
260 
261         totalReleased = totalReleased.add(balance);
262 
263         beneficiary.isBeneficiary = false;
264         beneficiary.released = beneficiary.released.add(balance);
265 
266         for (uint i = 0; i < addresses.length - 1; i++)
267             if (addresses[i] == _beneficiary) {
268                 addresses[i] = addresses[addresses.length - 1];
269                 break;
270             }
271 
272         addresses.length -= 1;
273 
274         emit BeneficiaryDestroyed(_beneficiary);
275     }
276 
277     /**
278      * @notice Allows the owner to clear the contract. Remain tokens are returned to the owner.
279      */
280     function clearAll() public onlyOwner {
281 
282         token.transfer(owner, token.balanceOf(this));
283 
284         for (uint i = 0; i < addresses.length; i++) {
285             Beneficiary storage beneficiary = beneficiaries[addresses[i]];
286             beneficiary.isBeneficiary = false;
287             beneficiary.released = 0;
288             beneficiary.vested = 0;
289             beneficiary.start = 0;
290             beneficiary.cliff = 0;
291             beneficiary.duration = 0;
292             beneficiary.revoked = false;
293             beneficiary.revocable = false;
294             beneficiary.description = "";
295         }
296         addresses.length = 0;
297 
298     }
299 
300     /**
301      * @dev Calculates the amount that has already vested but hasn't been released yet.
302      * @param _beneficiary Beneficiary address
303      */
304     function releasableAmount(address _beneficiary) public view returns (uint256) {
305         return vestedAmount(_beneficiary).sub(beneficiaries[_beneficiary].released);
306     }
307 
308     /**
309      * @dev Calculates the amount that has already vested.
310      * @param _beneficiary Beneficiary address
311      */
312     function vestedAmount(address _beneficiary) public view returns (uint256) {
313         Beneficiary storage beneficiary = beneficiaries[_beneficiary];
314         uint256 totalBalance = beneficiary.vested;
315 
316         if (now < beneficiary.cliff) {
317             return 0;
318         } else if (now >= beneficiary.start.add(beneficiary.duration) || beneficiary.revoked) {
319             return totalBalance;
320         } else {
321             return totalBalance.mul(now.sub(beneficiary.start)).div(beneficiary.duration);
322         }
323     }
324 
325     /**
326      * @dev Get the remain MTC on the contract.
327      */
328     function Balance() view public returns (uint256) {
329         return token.balanceOf(address(this));
330     }
331 
332     /**
333      * @dev Get the numbers of beneficiaries in the vesting contract.
334      */
335     function beneficiariesLength() view public returns (uint256) {
336         return addresses.length;
337     }
338 
339     /**
340      * @notice Allows the owner to flush the eth.
341      */
342     function flushEth() public onlyOwner {
343         owner.transfer(address(this).balance);
344     }
345 
346     /**
347      * @notice Allows the owner to destroy the contract and return the tokens to the owner.
348      */
349     function destroy() public onlyOwner {
350         token.transfer(owner, token.balanceOf(this));
351         selfdestruct(owner);
352     }
353 }