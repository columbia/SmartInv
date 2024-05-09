1 pragma solidity ^0.4.18;
2 /**
3  * Changes by https://www.docademic.com/
4  */
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 contract Ownable {
40   address public owner;
41 
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   function Ownable() public {
49     owner = msg.sender;
50   }
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) public onlyOwner {
65     require(newOwner != address(0));
66     OwnershipTransferred(owner, newOwner);
67     owner = newOwner;
68   }
69 }
70 
71 contract Destroyable is Ownable{
72     /**
73      * @notice Allows to destroy the contract and return the tokens to the owner.
74      */
75     function destroy() public onlyOwner{
76         selfdestruct(owner);
77     }
78 }
79 
80 interface Token {
81     function transfer(address _to, uint256 _value) public;
82 
83     function balanceOf(address who) public returns (uint256);
84 }
85 
86 contract MultiVesting is Ownable, Destroyable {
87     using SafeMath for uint256;
88 
89     // beneficiary of tokens
90     struct Beneficiary {
91         uint256 released;
92         uint256 vested;
93         uint256 start;
94         uint256 cliff;
95         uint256 duration;
96         bool revoked;
97         bool revocable;
98         bool isBeneficiary;
99     }
100 
101     event Released(address _beneficiary, uint256 amount);
102     event Revoked(address _beneficiary);
103     event NewBeneficiary(address _beneficiary);
104     event BeneficiaryDestroyed(address _beneficiary);
105 
106 
107     mapping(address => Beneficiary) public beneficiaries;
108     Token public token;
109     uint256 public totalVested;
110     uint256 public totalReleased;
111 
112     /*
113      *  Modifiers
114      */
115     modifier isNotBeneficiary(address _beneficiary) {
116         require(!beneficiaries[_beneficiary].isBeneficiary);
117         _;
118     }
119     modifier isBeneficiary(address _beneficiary) {
120         require(beneficiaries[_beneficiary].isBeneficiary);
121         _;
122     }
123 
124     modifier wasRevoked(address _beneficiary) {
125         require(beneficiaries[_beneficiary].revoked);
126         _;
127     }
128 
129     modifier wasNotRevoked(address _beneficiary) {
130         require(!beneficiaries[_beneficiary].revoked);
131         _;
132     }
133 
134     /**
135      * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
136      * beneficiary, gradually in a linear fashion until _start + _duration. By then all
137      * of the balance will have vested.
138      * @param _token address of the token of vested tokens
139      */
140     function MultiVesting(address _token) public {
141         require(_token != address(0));
142         token = Token(_token);
143     }
144 
145     function() payable public {
146         release(msg.sender);
147     }
148 
149     /**
150      * @notice Transfers vested tokens to beneficiary (alternative to fallback function).
151      */
152     function release() public {
153         release(msg.sender);
154     }
155 
156     /**
157      * @notice Transfers vested tokens to beneficiary.
158      * @param _beneficiary Beneficiary address
159      */
160     function release(address _beneficiary) private
161     isBeneficiary(_beneficiary)
162     {
163         Beneficiary storage beneficiary = beneficiaries[_beneficiary];
164 
165         uint256 unreleased = releasableAmount(_beneficiary);
166 
167         require(unreleased > 0);
168 
169         beneficiary.released = beneficiary.released.add(unreleased);
170 
171         totalReleased = totalReleased.add(unreleased);
172 
173         token.transfer(_beneficiary, unreleased);
174 
175         if((beneficiary.vested - beneficiary.released) == 0){
176             beneficiary.isBeneficiary = false;
177         }
178 
179         Released(_beneficiary, unreleased);
180     }
181 
182     /**
183      * @notice Allows the owner to transfers vested tokens to beneficiary.
184      * @param _beneficiary Beneficiary address
185      */
186     function releaseTo(address _beneficiary) public onlyOwner {
187         release(_beneficiary);
188     }
189 
190     /**
191      * @dev Add new beneficiary to start vesting
192      * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
193      * @param _start time in seconds which the tokens will vest
194      * @param _cliff time in seconds of the cliff in which tokens will begin to vest
195      * @param _duration duration in seconds of the period in which the tokens will vest
196      * @param _revocable whether the vesting is revocable or not
197      */
198     function addBeneficiary(address _beneficiary, uint256 _vested, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable)
199     onlyOwner
200     isNotBeneficiary(_beneficiary)
201     public {
202         require(_beneficiary != address(0));
203         require(_cliff >= _start);
204         require(token.balanceOf(this) >= totalVested.sub(totalReleased).add(_vested));
205         beneficiaries[_beneficiary] = Beneficiary({
206             released : 0,
207             vested : _vested,
208             start : _start,
209             cliff : _cliff,
210             duration : _duration,
211             revoked : false,
212             revocable : _revocable,
213             isBeneficiary : true
214             });
215         totalVested = totalVested.add(_vested);
216         NewBeneficiary(_beneficiary);
217     }
218 
219     /**
220      * @notice Allows the owner to revoke the vesting. Tokens already vested
221      * remain in the contract, the rest are returned to the owner.
222      * @param _beneficiary Beneficiary address
223      */
224     function revoke(address _beneficiary) public onlyOwner {
225         Beneficiary storage beneficiary = beneficiaries[_beneficiary];
226         require(beneficiary.revocable);
227         require(!beneficiary.revoked);
228 
229         uint256 balance = beneficiary.vested.sub(beneficiary.released);
230 
231         uint256 unreleased = releasableAmount(_beneficiary);
232         uint256 refund = balance.sub(unreleased);
233 
234         token.transfer(owner, refund);
235 
236         totalReleased = totalReleased.add(refund);
237 
238         beneficiary.revoked = true;
239         beneficiary.released = beneficiary.released.add(refund);
240 
241         Revoked(_beneficiary);
242     }
243 
244     /**
245      * @notice Allows the owner to destroy a beneficiary. Remain tokens are returned to the owner.
246      * @param _beneficiary Beneficiary address
247      */
248     function destroyBeneficiary(address _beneficiary) public onlyOwner {
249         Beneficiary storage beneficiary = beneficiaries[_beneficiary];
250 
251         uint256 balance = beneficiary.vested.sub(beneficiary.released);
252 
253         token.transfer(owner, balance);
254 
255         totalReleased = totalReleased.add(balance);
256 
257         beneficiary.isBeneficiary = false;
258         beneficiary.released = beneficiary.released.add(balance);
259 
260         BeneficiaryDestroyed(_beneficiary);
261     }
262 
263     /**
264      * @dev Calculates the amount that has already vested but hasn't been released yet.
265      * @param _beneficiary Beneficiary address
266      */
267     function releasableAmount(address _beneficiary) public view returns (uint256) {
268         return vestedAmount(_beneficiary).sub(beneficiaries[_beneficiary].released);
269     }
270 
271     /**
272      * @dev Calculates the amount that has already vested.
273      * @param _beneficiary Beneficiary address
274      */
275     function vestedAmount(address _beneficiary) public view returns (uint256) {
276         Beneficiary storage beneficiary = beneficiaries[_beneficiary];
277         uint256 totalBalance = beneficiary.vested;
278 
279         if (now < beneficiary.cliff) {
280             return 0;
281         } else if (now >= beneficiary.start.add(beneficiary.duration) || beneficiary.revoked) {
282             return totalBalance;
283         } else {
284             return totalBalance.mul(now.sub(beneficiary.start)).div(beneficiary.duration);
285         }
286     }
287 
288     /**
289      * @notice Allows the owner to flush the eth.
290      */
291     function flushEth() public onlyOwner {
292         owner.transfer(this.balance);
293     }
294 
295     /**
296      * @notice Allows the owner to destroy the contract and return the tokens to the owner.
297      */
298     function destroy() public onlyOwner {
299         token.transfer(owner, token.balanceOf(this));
300         selfdestruct(owner);
301     }
302 }