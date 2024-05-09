1 pragma solidity ^0.5.7;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath 
8 {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) 
10     {
11         uint256 c = a * b;
12         assert(a == 0 || c / a == b);
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) 
17     {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
25     {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) 
31     {
32         uint256 c = a + b;
33         assert(c >= a);
34         return c;
35     }
36 }
37 
38 
39 /**
40  * @title Ownable
41  * @dev The Ownable contract has an owner address, and provides basic authorization control
42  * functions, this simplifies the implementation of "user permissions".
43  */
44 contract Ownable 
45 {
46     address public owner;
47 
48     /**
49      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50      * account.
51      */
52     constructor() public
53     {
54         owner = msg.sender;
55     }
56 
57     /**
58      * @dev Throws if called by any account other than the owner.
59      */
60     modifier onlyOwner() 
61     {
62         assert(msg.sender == owner);
63         _;
64     }
65 
66     /**
67      * @dev Allows the current owner to transfer control of the contract to a newOwner.
68      * @param newOwner The address to transfer ownership to.
69      */
70     function transferOwnership(address newOwner) onlyOwner public
71     {
72         assert(newOwner != address(0));
73         owner = newOwner;
74     }
75 }
76 
77 /**
78  * @title ERC20Basic
79  * @dev Simpler version of ERC20 interface
80  * @dev see https://github.com/ethereum/EIPs/issues/179
81  */
82 contract ERC20Basic 
83 {
84     uint256 public totalSupply;
85     function balanceOf(address who) public view returns (uint256);
86     function transfer(address to, uint256 value) public returns (bool);
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  */
94 contract ERC20 is ERC20Basic 
95 {
96     function allowance(address owner, address spender) public view returns (uint256);
97     function transferFrom(address from, address to, uint256 value) public returns (bool);
98     function approve(address spender, uint256 value) public returns (bool);
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 /**
103  * @title POS
104  * @dev the interface of Proof-Of-Stake
105  */
106 contract POS 
107 {
108     uint256 public stakeStartTime;
109     uint256 public stakeMinAge;
110     uint256 public stakeMaxAge;
111     function pos() public returns (bool);
112     function coinAge() public view returns (uint);
113     function annualPos() public view returns (uint256);
114     event Mint(address indexed _address, uint _reward);
115 }
116 
117 contract CraftR is ERC20,POS,Ownable 
118 {
119     using SafeMath for uint256;
120 
121     string public name = "CraftR";
122     string public symbol = "CRAFTR";
123     uint public decimals = 18;
124 
125     uint public chainStartTime; 
126     uint public chainStartBlockNumber;
127     uint public stakeStartTime;
128     uint public stakeMinAge = 1 days;
129     uint public stakeMaxAge = 90 days;
130     uint public defaultPOS = 10**17; // default 10% annual interest
131 
132     uint public totalSupply;
133     uint public maxTotalSupply;
134     uint public totalInitialSupply;
135 
136     struct transferInStruct
137     {
138         uint128 amount;
139         uint64 time;
140     }
141 
142     mapping(address => uint256) balances;
143     mapping(address => mapping (address => uint256)) allowed;
144     mapping(address => transferInStruct[]) txIns;
145 
146     event Burn(address indexed burner, uint256 value);
147 
148     /**
149      * @dev Fix for the ERC20 short address attack.
150      */
151     modifier onlyPayloadSize(uint size) 
152     {
153         assert(msg.data.length >= size + 4);
154         _;
155     }
156 
157     modifier canRunPos() 
158     {
159         assert(totalSupply < maxTotalSupply);
160         _;
161     }
162 
163     constructor () public 
164     {
165         maxTotalSupply = 100*10**24; // 100 Mil
166         totalInitialSupply = 60*10**24; // 60 Mil
167 
168         chainStartTime = now;
169         chainStartBlockNumber = block.number;
170         stakeStartTime = now;
171 
172         balances[msg.sender] = totalInitialSupply;
173         totalSupply = totalInitialSupply;
174     }
175 
176     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) 
177     {
178         if(msg.sender == _to) return pos();
179         balances[msg.sender] = balances[msg.sender].sub(_value);
180         balances[_to] = balances[_to].add(_value);
181         emit Transfer(msg.sender, _to, _value);
182         if(txIns[msg.sender].length > 0) delete txIns[msg.sender];
183         uint64 _now = uint64(now);
184         txIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
185         txIns[_to].push(transferInStruct(uint128(_value),_now));
186         return true;
187     }
188 
189     function balanceOf(address _owner) public view returns (uint256 balance) 
190     {
191         return balances[_owner];
192     }
193 
194     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public returns (bool) 
195     {
196         require(_to != address(0));
197 
198         uint256 _allowance = allowed[_from][msg.sender];
199 
200         balances[_from] = balances[_from].sub(_value);
201         balances[_to] = balances[_to].add(_value);
202         allowed[_from][msg.sender] = _allowance.sub(_value);
203         emit Transfer(_from, _to, _value);
204         if(txIns[_from].length > 0) delete txIns[_from];
205         uint64 _now = uint64(now);
206         txIns[_from].push(transferInStruct(uint128(balances[_from]),_now));
207         txIns[_to].push(transferInStruct(uint128(_value),_now));
208         return true;
209     }
210 
211     function approve(address _spender, uint256 _value) public returns (bool) 
212     {
213         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
214 
215         allowed[msg.sender][_spender] = _value;
216         emit Approval(msg.sender, _spender, _value);
217         return true;
218     }
219 
220     function allowance(address _owner, address _spender) public view returns (uint256 remaining) 
221     {
222         return allowed[_owner][_spender];
223     }
224 
225     function pos() canRunPos public returns (bool) 
226     {
227         if(balances[msg.sender] <= 0) return false;
228         if(txIns[msg.sender].length <= 0) return false;
229 
230         uint reward = getPosReward(msg.sender);
231         if(reward <= 0) return false;
232 
233         totalSupply = totalSupply.add(reward);
234         balances[msg.sender] = balances[msg.sender].add(reward);
235         delete txIns[msg.sender];
236         txIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
237 
238         emit Mint(msg.sender, reward);
239         return true;
240     }
241 
242     function getCraftrBlockNumber() public view returns (uint blockNumber) 
243     {
244         blockNumber = block.number.sub(chainStartBlockNumber);
245     }
246 
247     function coinAge() public view returns (uint myCoinAge) 
248     {
249         myCoinAge = getCoinAge(msg.sender,now);
250     }
251 
252     function annualPos() public view returns(uint interest) 
253     {
254         uint _now = now;
255         interest = defaultPOS;
256         if((_now.sub(stakeStartTime)).div(365 days) == 0)
257         {
258             interest = (435 * defaultPOS).div(100);
259         }
260     }
261 
262     function getPosReward(address _address) internal view returns (uint) 
263     {
264         require( (now >= stakeStartTime) && (stakeStartTime > 0) );
265 
266         uint _now = now;
267         uint _coinAge = getCoinAge(_address, _now);
268         if(_coinAge <= 0) return 0;
269 
270         uint interest = defaultPOS;
271         // Due to the high interest rate for the first two years, compounding should be taken into account.
272         // Effective annual interest rate = (1 + (nominal rate / number of compounding periods)) ^ (number of compounding periods) - 1
273         if((_now.sub(stakeStartTime)).div(365 days) == 0) 
274         {
275             // 2nd year effective annual interest rate is 50% when we select the stakeMaxAge (90 days) as the compounding period.
276             // 1st year has already been calculated through the old contract
277             interest = (435 * defaultPOS).div(100);
278         }
279         return (_coinAge * interest).div(365 * (10**decimals));
280     }
281 
282     function getCoinAge(address _address, uint _now) internal view returns (uint _coinAge) 
283     {
284         if(txIns[_address].length <= 0) return 0;
285 
286         for (uint i = 0; i < txIns[_address].length; i++){
287             if( _now < uint(txIns[_address][i].time).add(stakeMinAge) ) continue;
288 
289             uint nCoinSeconds = _now.sub(uint(txIns[_address][i].time));
290             if( nCoinSeconds > stakeMaxAge ) nCoinSeconds = stakeMaxAge;
291 
292             _coinAge = _coinAge.add(uint(txIns[_address][i].amount) * nCoinSeconds.div(1 days));
293         }
294     }
295 
296     function ownerMultiSend(address[] memory _recipients, uint[] memory _values) onlyOwner public returns (bool) 
297     {
298         require( _recipients.length > 0 && _recipients.length == _values.length);
299 
300         uint total = 0;
301         for(uint i = 0; i < _values.length; i++)
302         {
303             total = total.add(_values[i]);
304         }
305         require(total <= balances[msg.sender]);
306 
307         uint64 _now = uint64(now);
308         for(uint j = 0; j < _recipients.length; j++)
309         {
310             balances[_recipients[j]] = balances[_recipients[j]].add(_values[j]);
311             txIns[_recipients[j]].push(transferInStruct(uint128(_values[j]),_now));
312             emit Transfer(msg.sender, _recipients[j], _values[j]);
313         }
314 
315         balances[msg.sender] = balances[msg.sender].sub(total);
316         if(txIns[msg.sender].length > 0) delete txIns[msg.sender];
317         if(balances[msg.sender] > 0) txIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
318 
319         return true;
320     }
321 
322     function ownerBurnTokens(uint _value) onlyOwner public 
323     {
324         require(_value > 0);
325 
326         balances[msg.sender] = balances[msg.sender].sub(_value);
327         delete txIns[msg.sender];
328         txIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));
329 
330         totalSupply = totalSupply.sub(_value);
331         totalInitialSupply = totalInitialSupply.sub(_value);
332         maxTotalSupply = maxTotalSupply.sub(_value*10);
333 
334         emit Burn(msg.sender, _value);
335     }   
336 }