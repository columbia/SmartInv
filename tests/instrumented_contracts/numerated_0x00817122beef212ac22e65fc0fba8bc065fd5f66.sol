1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control
40  * functions, this simplifies the implementation of "user permissions".
41  */
42 contract Ownable {
43     address public owner;
44 
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48 
49     /**
50      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51      * account.
52      */
53     function Ownable() public {
54         owner = msg.sender;
55     }
56 
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(msg.sender == owner);
63         _;
64     }
65 
66 
67     /**
68      * @dev Allows the current owner to transfer control of the contract to a newOwner.
69      * @param newOwner The address to transfer ownership to.
70      */
71     function transferOwnership(address newOwner) public onlyOwner {
72         require(newOwner != address(0));
73         OwnershipTransferred(owner, newOwner);
74         owner = newOwner;
75     }
76 
77 }
78 
79 /**
80  * @title ERC20Basic
81  * @dev Simpler version of ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/179
83  */
84 contract ERC20Basic {
85     uint256 public totalSupply;
86     function balanceOf(address who) public view returns (uint256);
87     function transfer(address to, uint256 value) public returns (bool);
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 }
90 
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96     function allowance(address owner, address spender) public view returns (uint256);
97     function transferFrom(address from, address to, uint256 value) public returns (bool);
98     function approve(address spender, uint256 value) public returns (bool);
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 /**
103  * @title Basic token
104  * @dev Basic version of StandardToken, with no allowances.
105  */
106 contract BasicToken is ERC20Basic {
107     using SafeMath for uint256;
108 
109     mapping(address => uint256) balances;
110 
111     /**
112     * @dev transfer token for a specified address
113     * @param _to The address to transfer to.
114     * @param _value The amount to be transferred.
115     */
116     /**
117     function transfer(address _to, uint256 _value) public returns (bool) {
118         require(_to != address(0));
119         require(_value <= balances[msg.sender]);
120 
121         // SafeMath.sub will throw if there is not enough balance.
122         balances[msg.sender] = balances[msg.sender].sub(_value);
123         balances[_to] = balances[_to].add(_value);
124         emit Transfer(msg.sender, _to, _value);
125         return true;
126     }
127     **/
128     /**
129     * @dev Gets the balance of the specified address.
130     * @param _owner The address to query the the balance of.
131     * @return An uint256 representing the amount owned by the passed address.
132     */
133     function balanceOf(address _owner) public view returns (uint256 balance) {
134         return balances[_owner];
135     }
136 
137 }
138 
139 
140 /**
141  * @title Standard ERC20 token
142  *
143  * @dev Implementation of the basic standard token.
144  * @dev https://github.com/ethereum/EIPs/issues/20
145  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
146  */
147 contract StandardToken is ERC20, BasicToken {
148 
149     mapping (address => mapping (address => uint256)) internal allowed;
150 
151 
152     /**
153      * @dev Transfer tokens from one address to another
154      * @param _from address The address which you want to send tokens from
155      * @param _to address The address which you want to transfer to
156      * @param _value uint256 the amount of tokens to be transferred
157      */
158     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
159         require(_to != address(0));
160         require(_value <= balances[_from]);
161         require(_value <= allowed[_from][msg.sender]);
162 
163         balances[_from] = balances[_from].sub(_value);
164         balances[_to] = balances[_to].add(_value);
165         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
166         emit Transfer(_from, _to, _value);
167         return true;
168     }
169 
170     /**
171      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
172      *
173      * Beware that changing an allowance with this method brings the risk that someone may use both the old
174      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
175      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
176      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177      * @param _spender The address which will spend the funds.
178      * @param _value The amount of tokens to be spent.
179      */
180     function approve(address _spender, uint256 _value) public returns (bool) {
181         allowed[msg.sender][_spender] = _value;
182         //emit Approval(msg.sender, _spender, _value);
183         return true;
184     }
185 
186     /**
187      * @dev Function to check the amount of tokens that an owner allowed to a spender.
188      * @param _owner address The address which owns the funds.
189      * @param _spender address The address which will spend the funds.
190      * @return A uint256 specifying the amount of tokens still available for the spender.
191      */
192     function allowance(address _owner, address _spender) public view returns (uint256) {
193         return allowed[_owner][_spender];
194     }
195 
196     /**
197      * approve should be called when allowed[_spender] == 0. To increment
198      * allowed value is better to use this function to avoid 2 calls (and wait until
199      * the first transaction is mined)
200      * From MonolithDAO Token.sol
201      */
202     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
203         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
204         //emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
205         return true;
206     }
207 
208     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
209         uint oldValue = allowed[msg.sender][_spender];
210         if (_subtractedValue > oldValue) {
211             allowed[msg.sender][_spender] = 0;
212         } else {
213             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
214         }
215         //emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216         return true;
217     }
218 
219 }
220 
221 /**
222  * @title Mintable token
223  * @dev Simple ERC20 Token example, with mintable token creation
224  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
225  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
226  */
227 
228 contract MintableToken is StandardToken, Ownable {
229     event Mint(address indexed to, uint256 amount);
230     event MintFinished();
231 
232     bool public mintingFinished = false;
233 
234 
235     modifier canMint() {
236         require(!mintingFinished);
237         _;
238     }
239 
240     /**
241      * @dev Function to mint tokens
242      * @param _to The address that will receive the minted tokens.
243      * @param _amount The amount of tokens to mint.
244      * @return A boolean that indicates if the operation was successful.
245      */
246     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
247         totalSupply = totalSupply.add(_amount);
248         balances[_to] = balances[_to].add(_amount);
249         //emit Mint(_to, _amount);
250         //emit Transfer(address(0), _to, _amount);
251         return true;
252     }
253 
254     /**
255      * @dev Function to stop minting new tokens.
256      * @return True if the operation was successful.
257      */
258     function finishMinting() onlyOwner canMint public returns (bool) {
259         mintingFinished = true;
260         //emit MintFinished();
261         return true;
262     }
263 }
264 
265 contract UNTToken is MintableToken{
266 
267     string public constant name = "unttest";
268     string public constant symbol = "UNTTEST";
269     uint32 public constant decimals = 8;
270     mapping(address => uint256) public lockamount;
271     address[] lockaddress;
272     bool private isFreezed = false;
273 
274     function UNTToken() public {
275         totalSupply = 2000000000E3;
276         balances[msg.sender] = totalSupply; // Add all tokens to issuer balance (crowdsale in this case)
277     }
278 
279 
280     function transfer(address _to, uint256 _value) public returns (bool) {
281         require(_to != address(0));
282         require(_value <= balances[msg.sender]);
283         require(isFreezed == false);
284         if(msg.sender == owner)
285         {
286             if(hasAddress(_to) == true)
287             {
288                lockamount[_to]+= _value;
289             }
290             else
291             {
292                lockaddress.push(_to);
293                lockamount[_to] = _value;
294             }
295 
296         }
297         else if(hasAddress(msg.sender) == true)
298         {
299 
300              require(balanceOf(msg.sender)-lockamount[msg.sender]>=_value);
301 
302         }
303 
304 
305         // SafeMath.sub will throw if there is not enough balance.
306         balances[msg.sender] = balances[msg.sender].sub(_value);
307         balances[_to] = balances[_to].add(_value);
308         emit Transfer(msg.sender, _to, _value);
309         return true;
310     }
311 
312     function lockToken(address target, uint256 amount) public
313     {   require(owner == msg.sender);
314         if(hasAddress(target) == false)
315         {
316             if(balanceOf(target)>=amount)
317             {
318               lockaddress.push(target);
319               lockamount[target] = amount;
320             }
321 
322         }
323         else
324         {
325           if(balanceOf(target)-lockamount[target]>= amount)
326           {
327 
328               lockamount[target] += amount;
329 
330           }
331 
332         }
333 
334     }
335 
336     function unlockToken(address target, uint256 amount) public
337     {
338         require(owner == msg.sender);
339         if(hasAddress(target) == false)
340         {
341 
342         }
343         else
344         {
345           if(lockamount[target]>= amount)
346           {
347 
348             lockamount[target]=lockamount[target]-amount;
349 
350           }
351 
352         }
353 
354 
355     }
356 
357     function hasAddress(address target) private returns(bool)
358     {
359 
360           for(uint i = 0; i< lockaddress.length; i++)
361           {
362               if(lockaddress[i] == target)
363               {
364                 return true;
365               }
366 
367           }
368           return false;
369 
370     }
371 
372     function freezeToken() public
373     {
374        require(owner == msg.sender);
375        isFreezed = true;
376     }
377 
378     function unfreezeToken() public
379     {
380        require(owner == msg.sender);
381        isFreezed = false;
382 
383     }
384 
385 
386 
387 
388 }