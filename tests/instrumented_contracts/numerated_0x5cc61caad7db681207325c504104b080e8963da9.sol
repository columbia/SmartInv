1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) public onlyOwner {
33     require(newOwner != address(0));
34     OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36   }
37 
38 }
39 
40 contract BbillerBallot is Ownable {
41     BbillerToken public token;
42     mapping(uint => Issue) public issues;
43 
44     uint issueDoesNotExistFlag = 0;
45     uint issueVotingFlag = 1;
46     uint issueAcceptedFlag = 2;
47     uint issueRejectedFlag = 3;
48 
49     struct Issue {
50         uint votingStartDate;
51         uint votingEndDate;
52         mapping(address => bool) isVoted;
53         uint forCounter;
54         uint againstCounter;
55         uint flag;
56     }
57 
58     event CreateIssue(uint _issueId, uint _votingStartDate, uint _votingEndDate, address indexed creator);
59     event Vote(uint issueId, bool forVote, address indexed voter);
60     event IssueAccepted(uint issueId);
61     event IssueRejected(uint issueId);
62 
63     function BbillerBallot(BbillerToken _token) public {
64         token = _token;
65     }
66 
67     function createIssue(uint issueId, uint _votingStartDate, uint _votingEndDate) public onlyOwner {
68         require(issues[issueId].flag == issueDoesNotExistFlag);
69 
70         Issue memory issue = Issue(
71             {votingEndDate : _votingEndDate,
72             votingStartDate : _votingStartDate,
73             forCounter : 0,
74             againstCounter : 0,
75             flag : issueVotingFlag});
76         issues[issueId] = issue;
77 
78         CreateIssue(issueId, _votingStartDate, _votingEndDate, msg.sender);
79     }
80 
81     function vote(uint issueId, bool forVote) public {
82         require(token.isTokenUser(msg.sender));
83 
84         Issue storage issue = issues[issueId];
85         require(!issue.isVoted[msg.sender]);
86         require(issue.flag == issueVotingFlag);
87         require(issue.votingEndDate > now);
88         require(issue.votingStartDate < now);
89 
90         issue.isVoted[msg.sender] = true;
91         if (forVote) {
92             issue.forCounter++;
93         }
94         else {
95             issue.againstCounter++;
96         }
97         Vote(issueId, forVote, msg.sender);
98 
99         uint tokenUserCounterHalf = getTokenUserCounterHalf();
100         if (issue.forCounter >= tokenUserCounterHalf) {
101             issue.flag = issueAcceptedFlag;
102             IssueAccepted(issueId);
103         }
104         if (issue.againstCounter >= tokenUserCounterHalf) {
105             issue.flag = issueRejectedFlag;
106             IssueRejected(issueId);
107         }
108     }
109 
110     function getVoteResult(uint issueId) public view returns (string) {
111         Issue storage issue = issues[issueId];
112         if (issue.flag == issueVotingFlag) {
113             return 'Voting';
114         }
115         if (issue.flag == issueAcceptedFlag) {
116             return 'Accepted';
117         }
118         if (issue.flag == issueRejectedFlag) {
119             return 'Rejected';
120         }
121         if (issue.flag == issueDoesNotExistFlag) {
122             return 'DoesNotExist';
123         }
124     }
125 
126     function getTokenUserCounterHalf() internal returns (uint) {
127         // for division must be of uint type
128         uint half = 2;
129         uint tokenUserCounter = token.getTokenUserCounter();
130         uint tokenUserCounterHalf = tokenUserCounter / half;
131         if (tokenUserCounterHalf * half != tokenUserCounter) {
132             // odd case
133             tokenUserCounterHalf++;
134         }
135         return tokenUserCounterHalf;
136     }
137 }
138 
139 contract ERC20Basic {
140   uint256 public totalSupply;
141   function balanceOf(address who) public view returns (uint256);
142   function transfer(address to, uint256 value) public returns (bool);
143   event Transfer(address indexed _from, address indexed _to, uint256 _value);
144 }
145 
146 contract ERC20 is ERC20Basic {
147   function allowance(address owner, address spender) public view returns (uint256);
148   function transferFrom(address from, address to, uint256 value) public returns (bool);
149   function approve(address spender, uint256 value) public returns (bool);
150   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
151 }
152 
153 library SafeMath {
154   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
155     if (a == 0) {
156       return 0;
157     }
158     uint256 c = a * b;
159     assert(c / a == b);
160     return c;
161   }
162 
163   function div(uint256 a, uint256 b) internal pure returns (uint256) {
164     // assert(b > 0); // Solidity automatically throws when dividing by 0
165     uint256 c = a / b;
166     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
167     return c;
168   }
169 
170   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
171     assert(b <= a);
172     return a - b;
173   }
174 
175   function add(uint256 a, uint256 b) internal pure returns (uint256) {
176     uint256 c = a + b;
177     assert(c >= a);
178     return c;
179   }
180 }
181 
182 contract BasicToken is ERC20Basic {
183     using SafeMath for uint256;
184 
185     mapping(address => uint256) balances;
186 
187     /**
188     * @dev transfer token for a specified address
189     * @param _to The address to transfer to.
190     * @param _value The amount to be transferred.
191     */
192     function transfer(address _to, uint256 _value) public returns (bool) {
193         require(_to != address(0));
194         require(_value <= balances[msg.sender]);
195 
196         // SafeMath.sub will throw if there is not enough balance.
197         balances[msg.sender] = balances[msg.sender].sub(_value);
198         balances[_to] = balances[_to].add(_value);
199         Transfer(msg.sender, _to, _value);
200         return true;
201     }
202 
203     /**
204     * @dev Gets the balance of the specified address.
205     * @param _owner The address to query the the balance of.
206     * @return An uint256 representing the amount owned by the passed address.
207     */
208     function balanceOf(address _owner) public view returns (uint256 balance) {
209         return balances[_owner];
210     }
211 
212 }
213 
214 contract StandardToken is ERC20, BasicToken {
215 
216   mapping (address => mapping (address => uint256)) internal allowed;
217 
218 
219   /**
220    * @dev Transfer tokens from one address to another
221    * @param _from address The address which you want to send tokens from
222    * @param _to address The address which you want to transfer to
223    * @param _value uint256 the amount of tokens to be transferred
224    */
225   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
226     require(_to != address(0));
227     require(_value <= balances[_from]);
228     require(_value <= allowed[_from][msg.sender]);
229 
230     balances[_from] = balances[_from].sub(_value);
231     balances[_to] = balances[_to].add(_value);
232     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
233     Transfer(_from, _to, _value);
234     return true;
235   }
236 
237   /**
238    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
239    *
240    * Beware that changing an allowance with this method brings the risk that someone may use both the old
241    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
242    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
243    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
244    * @param _spender The address which will spend the funds.
245    * @param _value The amount of tokens to be spent.
246    */
247   function approve(address _spender, uint256 _value) public returns (bool) {
248     allowed[msg.sender][_spender] = _value;
249     Approval(msg.sender, _spender, _value);
250     return true;
251   }
252 
253   /**
254    * @dev Function to check the amount of tokens that an owner allowed to a spender.
255    * @param _owner address The address which owns the funds.
256    * @param _spender address The address which will spend the funds.
257    * @return A uint256 specifying the amount of tokens still available for the spender.
258    */
259   function allowance(address _owner, address _spender) public view returns (uint256) {
260     return allowed[_owner][_spender];
261   }
262 
263   /**
264    * @dev Increase the amount of tokens that an owner allowed to a spender.
265    *
266    * approve should be called when allowed[_spender] == 0. To increment
267    * allowed value is better to use this function to avoid 2 calls (and wait until
268    * the first transaction is mined)
269    * From MonolithDAO Token.sol
270    * @param _spender The address which will spend the funds.
271    * @param _addedValue The amount of tokens to increase the allowance by.
272    */
273   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
274     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
275     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
276     return true;
277   }
278 
279   /**
280    * @dev Decrease the amount of tokens that an owner allowed to a spender.
281    *
282    * approve should be called when allowed[_spender] == 0. To decrement
283    * allowed value is better to use this function to avoid 2 calls (and wait until
284    * the first transaction is mined)
285    * From MonolithDAO Token.sol
286    * @param _spender The address which will spend the funds.
287    * @param _subtractedValue The amount of tokens to decrease the allowance by.
288    */
289   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
290     uint oldValue = allowed[msg.sender][_spender];
291     if (_subtractedValue > oldValue) {
292       allowed[msg.sender][_spender] = 0;
293     } else {
294       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
295     }
296     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
297     return true;
298   }
299 
300 }
301 
302 contract MintableToken is StandardToken, Ownable {
303   event Mint(address indexed _to, uint256 _amount);
304   event MintFinished();
305 
306   bool public mintingFinished = false;
307 
308 
309   modifier canMint() {
310     require(!mintingFinished);
311     _;
312   }
313 
314   /**
315    * @dev Function to mint tokens
316    * @param _to The address that will receive the minted tokens.
317    * @param _amount The amount of tokens to mint.
318    * @return A boolean that indicates if the operation was successful.
319    */
320   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
321     totalSupply = totalSupply.add(_amount);
322     balances[_to] = balances[_to].add(_amount);
323     Mint(_to, _amount);
324     Transfer(address(0), _to, _amount);
325     return true;
326   }
327 
328   /**
329    * @dev Function to stop minting new tokens.
330    * @return True if the operation was successful.
331    */
332   function finishMinting() onlyOwner canMint public returns (bool) {
333     mintingFinished = true;
334     MintFinished();
335     return true;
336   }
337 }
338 
339 contract BbillerToken is MintableToken {
340     string public symbol = 'BBILLER';
341     uint public decimals = 18;
342     uint public tokenUserCounter;  // number of users that owns this token
343 
344     mapping(address => bool) public isTokenUser;
345 
346     event CountTokenUser(address _tokenUser, uint _tokenUserCounter, bool increment);
347 
348     function getTokenUserCounter() public view returns (uint) {
349         return tokenUserCounter;
350     }
351 
352     function countTokenUser(address tokenUser) internal {
353         if (!isTokenUser[tokenUser]) {
354             isTokenUser[tokenUser] = true;
355             tokenUserCounter++;
356         }
357         CountTokenUser(tokenUser, tokenUserCounter, true);
358     }
359 
360     function transfer(address to, uint256 value) public returns (bool) {
361         bool res = super.transfer(to, value);
362         countTokenUser(to);
363         return res;
364     }
365 
366     function transferFrom(address from, address to, uint256 value) public returns (bool) {
367         bool res = super.transferFrom(from, to, value);
368         countTokenUser(to);
369         if (balanceOf(from) <= 0) {
370             isTokenUser[from] = false;
371             tokenUserCounter--;
372             CountTokenUser(from, tokenUserCounter, false);
373         }
374         return res;
375     }
376 
377     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
378         bool res = super.mint(_to, _amount);
379         countTokenUser(_to);
380         return res;
381     }
382 }