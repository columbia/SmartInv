1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55     address public owner;
56 
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61     /**
62      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63      * account.
64      */
65     function Ownable() public {
66         owner = msg.sender;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(msg.sender == owner);
74         _;
75     }
76 
77     /**
78      * @dev Allows the current owner to transfer control of the contract to a newOwner.
79      * @param newOwner The address to transfer ownership to.
80      */
81     function transferOwnership(address newOwner) public onlyOwner {
82         require(newOwner != address(0));
83         emit OwnershipTransferred(owner, newOwner);
84         owner = newOwner;
85     }
86 
87 }
88 
89 contract ERC20Token {
90     function mintTokens(address _atAddress, uint256 _amount) public;
91 
92 }
93 
94 contract MultipleVesting is Ownable {
95     using SafeMath for uint256;
96 
97     struct Grant {
98         uint256 start;
99         uint256 cliff;
100         uint256 duration;
101         uint256 value;
102         uint256 transferred;
103         bool revocable;
104     }
105 
106     mapping (address => Grant) public grants;
107     mapping (uint256 => address) public indexedGrants;
108     uint256 public index;
109     uint256 public totalVesting;
110     ERC20Token token;
111 
112     event NewGrant(address indexed _address, uint256 _value);
113     event UnlockGrant(address indexed _holder, uint256 _value);
114     event RevokeGrant(address indexed _holder, uint256 _refund);
115 
116     function setToken(address _token) public onlyOwner {
117         token = ERC20Token(_token);
118     }
119 
120     /**
121      * @dev Allows the current owner to add new grant
122      * @param _address Address of grant
123      * @param _start Start time of vesting in timestamp
124      * @param _cliff Cliff in timestamp
125      * @param _duration End of vesting in timestamp
126      * @param _value Number of tokens to be vested
127      * @param _revocable Can grant be revoked
128      */
129     function newGrant(address _address, uint256 _start, uint256 _cliff, uint256 _duration, uint256 _value, bool _revocable) public onlyOwner {
130         if(grants[_address].value == 0) {
131             indexedGrants[index] = _address;
132             index = index.add(1);
133         }
134         grants[_address] = Grant({
135             start: _start,
136             cliff: _cliff,
137             duration: _duration,
138             value: _value,
139             transferred: 0,
140             revocable: _revocable
141             });
142 
143         totalVesting = totalVesting.add(_value);
144         emit NewGrant(_address, _value);
145     }
146 
147     /**
148      * @dev Allows the curretn owner to revoke grant
149      * @param _grant Address of grant to be revoked
150      */
151     function revoke(address _grant) public onlyOwner {
152         Grant storage grant = grants[_grant];
153         require(grant.revocable);
154 
155         uint256 refund = grant.value.sub(grant.transferred);
156 
157         // Remove the grant.
158         delete grants[_grant];
159         totalVesting = totalVesting.sub(refund);
160 
161         token.mintTokens(msg.sender, refund);
162         emit RevokeGrant(_grant, refund);
163     }
164 
165     /**
166      * @dev Number of veset token for _holder on _time
167      * @param _holder Address of holder
168      * @param _time Timestamp of time to check for vest amount
169      */
170     function vestedTokens(address _holder, uint256 _time) public constant returns (uint256) {
171         Grant storage grant = grants[_holder];
172         if (grant.value == 0) {
173             return 0;
174         }
175 
176         return calculateVestedTokens(grant, _time);
177     }
178 
179     /**
180      * @dev Calculate amount of vested tokens
181      * @param _grant Grant to calculate for
182      * @param _time Timestamp of time to check for
183      */
184     function calculateVestedTokens(Grant _grant, uint256 _time) private pure returns (uint256) {
185         // If we're before the cliff, then nothing is vested.
186         if (_time < _grant.cliff) {
187             return 0;
188         }
189 
190         // If we're after the end of the vesting period - everything is vested;
191         if (_time >= _grant.duration) {
192             return _grant.value;
193         }
194 
195         // Interpolate all vested tokens: vestedTokens = tokens/// (time - start) / (end - start)
196         return _grant.value.mul(_time.sub(_grant.start)).div(_grant.duration.sub(_grant.start));
197     }
198 
199     /**
200      * @dev Distribute tokens to grants
201      */
202     function vest() public onlyOwner {
203         for(uint16 i = 0; i < index; i++) {
204             Grant storage grant = grants[indexedGrants[i]];
205             if(grant.value == 0) continue;
206             uint256 vested = calculateVestedTokens(grant, now);
207             if (vested == 0) {
208                 continue;
209             }
210 
211             // Make sure the holder doesn't transfer more than what he already has.
212             uint256 transferable = vested.sub(grant.transferred);
213             if (transferable == 0) {
214                 continue;
215             }
216 
217             grant.transferred = grant.transferred.add(transferable);
218             totalVesting = totalVesting.sub(transferable);
219             token.mintTokens(indexedGrants[i], transferable);
220 
221             emit UnlockGrant(msg.sender, transferable);
222         }
223     }
224 
225     function unlockVestedTokens() public {
226         Grant storage grant = grants[msg.sender];
227         require(grant.value != 0);
228 
229         // Get the total amount of vested tokens, acccording to grant.
230         uint256 vested = calculateVestedTokens(grant, now);
231         if (vested == 0) {
232             return;
233         }
234 
235         // Make sure the holder doesn't transfer more than what he already has.
236         uint256 transferable = vested.sub(grant.transferred);
237         if (transferable == 0) {
238             return;
239         }
240 
241         grant.transferred = grant.transferred.add(transferable);
242         totalVesting = totalVesting.sub(transferable);
243         token.mintTokens(msg.sender, transferable);
244 
245         emit UnlockGrant(msg.sender, transferable);
246     }
247 }