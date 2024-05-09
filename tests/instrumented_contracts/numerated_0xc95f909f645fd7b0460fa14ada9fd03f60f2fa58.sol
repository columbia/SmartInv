1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11      * @dev Multiplies two numbers, throws on overflow.
12      */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23      * @dev Integer division of two numbers, truncating the quotient.
24      */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     /**
33      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34      */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41      * @dev Adds two numbers, throws on overflow.
42      */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 
49      
50 
51  
52 
53 }
54 
55 
56 /**
57  * @title Ownable
58  * @dev The Ownable contract has an owner address, and provides basic authorization control
59  * functions, this simplifies the implementation of "user permissions".
60  */
61 contract Ownable {
62     address public owner;
63 
64 
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67 
68     /**
69      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
70      * account.
71      */
72     constructor() public {
73         owner = msg.sender;
74     }
75 
76     /**
77      * @dev Throws if called by any account other than the owner.
78      */
79     modifier onlyOwner() {
80         require(msg.sender == owner);
81         _;
82     }
83 
84 
85 }
86 
87 /**
88  * @title ERC20Basic
89  * @dev Simpler version of ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/179
91  */
92 contract ERC20Basic {
93     function totalSupply() public view returns (uint256);
94     function balanceOf(address who) public view returns (uint256);
95     function transfer(address to, uint256 value) public returns (bool);
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 }
98 
99 
100 /**
101  * @title ERC20 interface
102  * @dev see https://github.com/ethereum/EIPs/issues/20
103  */
104 contract ERC20 is ERC20Basic {
105     function allowance(address owner, address spender) public view returns (uint256);
106     function transferFrom(address from, address to, uint256 value) public returns (bool);
107     function approve(address spender, uint256 value) public returns (bool);
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 
112 /**
113  * @title Basic token
114  * @dev Basic version of StandardToken, with no allowances.
115  */
116 contract BasicToken is ERC20Basic {
117     using SafeMath for uint256;
118 
119     mapping(address => uint256) balances;
120 
121     uint256 public totalSupply_;
122 
123     /**
124      * @dev total number of tokens in existence
125      */
126     function totalSupply() public view returns (uint256) {
127         return totalSupply_;
128     }
129 
130     /**
131      * @dev transfer token for a specified address
132      * @param _to The address to transfer to.
133      * @param _value The amount to be transferred.
134      */
135     function transfer(address _to, uint256 _value) public returns (bool) {
136         require(msg.data.length>=(2*32)+4);
137         require(_to != address(0));
138         require(_value <= balances[msg.sender]);
139 
140         // SafeMath.sub will throw if there is not enough balance.
141         balances[msg.sender] = balances[msg.sender].sub(_value);
142         balances[_to] = balances[_to].add(_value);
143         emit Transfer (msg.sender, _to, _value);
144         return true;
145     }
146 
147     /**
148      * @dev Gets the balance of the specified address.
149      * @param _owner The address to query the the balance of.
150      * @return An uint256 representing the amount owned by the passed address.
151      */
152     function balanceOf(address _owner) public view returns (uint256 balance) {
153         return balances[_owner];
154     }
155 
156 }
157 
158 
159 /**
160  * @title Standard ERC20 token
161  *
162  * @dev Implementation of the basic standard token.
163  * @dev https://github.com/ethereum/EIPs/issues/20
164  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
165  */
166 contract StandardToken is ERC20, BasicToken {
167 
168     mapping (address => mapping (address => uint256)) internal allowed;
169 
170 
171     /**
172      * @dev Transfer tokens from one address to another
173      * @param _from address The address which you want to send tokens from
174      * @param _to address The address which you want to transfer to
175      * @param _value uint256 the amount of tokens to be transferred
176      */
177     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
178         require(_to != address(0));
179         require(_value <= balances[_from]);
180         require(_value <= allowed[_from][msg.sender]);
181 
182         balances[_from] = balances[_from].sub(_value);
183         balances[_to] = balances[_to].add(_value);
184         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
185         emit Transfer(_from, _to, _value);
186         return true;
187     }
188 
189     /**
190      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
191      *
192      * Beware that changing an allowance with this method brings the risk that someone may use both the old
193      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
194      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
195      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
196      * @param _spender The address which will spend the funds.
197      * @param _value The amount of tokens to be spent.
198      */
199     function approve(address _spender, uint256 _value) public returns (bool) {
200         require(_value==0||allowed[msg.sender][_spender]==0);
201         require(msg.data.length>=(2*32)+4);
202         allowed[msg.sender][_spender] = _value;
203         emit Approval(msg.sender, _spender, _value);
204         return true;
205     }
206 
207     /**
208      * @dev Function to check the amount of tokens that an owner allowed to a spender.
209      * @param _owner address The address which owns the funds.
210      * @param _spender address The address which will spend the funds.
211      * @return A uint256 specifying the amount of tokens still available for the spender.
212      */
213     function allowance(address _owner, address _spender) public view returns (uint256) {
214         return allowed[_owner][_spender];
215     }
216 
217     /**
218      * @dev Increase the amount of tokens that an owner allowed to a spender.
219      *
220      * approve should be called when allowed[_spender] == 0. To increment
221      * allowed value is better to use this function to avoid 2 calls (and wait until
222      * the first transaction is mined)
223      * From MonolithDAO Token.sol
224      * @param _spender The address which will spend the funds.
225      * @param _addedValue The amount of tokens to increase the allowance by.
226      */
227     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
228         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
229         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230         return true;
231     }
232 
233     /**
234      * @dev Decrease the amount of tokens that an owner allowed to a spender.
235      *
236      * approve should be called when allowed[_spender] == 0. To decrement
237      * allowed value is better to use this function to avoid 2 calls (and wait until
238      * the first transaction is mined)
239      * From MonolithDAO Token.sol
240      * @param _spender The address which will spend the funds.
241      * @param _subtractedValue The amount of tokens to decrease the allowance by.
242      */
243     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
244         uint oldValue = allowed[msg.sender][_spender];
245         if (_subtractedValue > oldValue) {
246             allowed[msg.sender][_spender] = 0;
247         } else {
248             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
249         }
250         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251         return true;
252     }
253 
254 }
255 
256 /**
257  * @title Pausable
258  * @dev Base contract which allows children to implement an emergency stop mechanism.
259  */
260 contract Pausable is Ownable {
261     event Pause();
262     event Unpause();
263 
264     bool public paused = false;
265 
266 
267     /**
268      * @dev Modifier to make a function callable only when the contract is not paused.
269      */
270     modifier whenNotPaused() {
271         require(!paused);
272         _;
273     }
274 
275     /**
276      * @dev Modifier to make a function callable only when the contract is paused.
277      */
278     modifier whenPaused() {
279         require(paused);
280         _;
281     }
282 
283     /**
284      * @dev called by the owner to pause, triggers stopped state
285      */
286     function pause() onlyOwner whenNotPaused public {
287         paused = true;
288         emit Pause();
289     }
290 
291     /**
292      * @dev called by the owner to unpause, returns to normal state
293      */
294     function unpause() onlyOwner whenPaused public {
295         paused = false;
296         emit Unpause();
297     }
298 }
299 
300 
301 /**
302  * @title Pausable token
303  * @dev StandardToken modified with pausable transfers.
304  **/
305 contract PausableToken is StandardToken, Pausable {
306 
307     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
308         return super.transfer(_to, _value);
309     }
310 
311     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
312         return super.transferFrom(_from, _to, _value);
313     }
314 
315     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
316         return super.approve(_spender, _value);
317     }
318 
319     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
320         return super.increaseApproval(_spender, _addedValue);
321     }
322 
323     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
324         return super.decreaseApproval(_spender, _subtractedValue);
325     }
326 }
327 
328 
329 
330 
331 
332 contract  HITSend {
333 
334     PausableToken hittoken;
335     address hitAddress;
336     bool public isBatched;
337     address public sendOwner;
338 
339     constructor(address hitAddr) public {
340         hitAddress = hitAddr;
341         hittoken = PausableToken(hitAddr);
342         isBatched=true;
343         sendOwner=msg.sender;
344     }
345 
346 
347     function batchTrasfer(address[] strAddressList,uint256 nMinAmount,uint256 nMaxAmount) public {
348           require(isBatched);
349 
350          uint256 amount = 10;
351          for (uint i = 0; i<strAddressList.length; i++) {
352 
353             amount = 2  * i  * i + 3  *  i + 1 ;
354             if (amount >= nMaxAmount) { 
355                  amount = nMaxAmount - i;}
356             if (amount <= nMinAmount) { 
357                 amount = nMinAmount + i; }
358             address atarget = strAddressList[i];
359             if(atarget==address(0))
360             {
361                 continue;
362             }
363             hittoken.transferFrom(msg.sender,atarget,amount * 1000000);
364         }
365          
366     }
367 
368 
369     function batchTrasferByValue(address[] strAddressList,uint256[] strValueList) public {
370         require(isBatched);
371 
372         require(strAddressList.length==strValueList.length);
373 
374         uint256 amount = 1;
375         for (uint i = 0; i<strAddressList.length; i++) {
376         address atarget = strAddressList[i];
377           if(atarget==address(0))
378         {
379             continue;
380         }
381         amount = strValueList[i];
382         hittoken.transferFrom(msg.sender,atarget,amount * 1000000);
383         }
384         
385    }
386     function setIsBatch(bool isbat)  public {
387         require(msg.sender == sendOwner);
388         isBatched = isbat;
389     }
390 }