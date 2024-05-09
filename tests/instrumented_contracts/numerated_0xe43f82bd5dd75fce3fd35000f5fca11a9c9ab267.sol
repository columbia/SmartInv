1 pragma solidity ^0.4.18;
2 
3 // File: contracts/token/ERC223.sol
4 
5 contract ERC223 {
6     function transfer(address _to, uint _value, bytes _data) public returns (bool);
7     function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool);
8     
9     event Transfer(address indexed from, address indexed to, uint value, bytes data);
10 }
11 
12 // File: zeppelin-solidity/contracts/math/SafeMath.sol
13 
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     if (a == 0) {
21       return 0;
22     }
23     uint256 c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   function Ownable() public {
66     owner = msg.sender;
67   }
68 
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78 
79   /**
80    * @dev Allows the current owner to transfer control of the contract to a newOwner.
81    * @param newOwner The address to transfer ownership to.
82    */
83   function transferOwnership(address newOwner) public onlyOwner {
84     require(newOwner != address(0));
85     OwnershipTransferred(owner, newOwner);
86     owner = newOwner;
87   }
88 
89 }
90 
91 // File: zeppelin-solidity/contracts/ownership/Contactable.sol
92 
93 /**
94  * @title Contactable token
95  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
96  * contact information.
97  */
98 contract Contactable is Ownable{
99 
100     string public contactInformation;
101 
102     /**
103      * @dev Allows the owner to set a string with their contact information.
104      * @param info The contact information to attach to the contract.
105      */
106     function setContactInformation(string info) onlyOwner public {
107          contactInformation = info;
108      }
109 }
110 
111 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
112 
113 /**
114  * @title ERC20Basic
115  * @dev Simpler version of ERC20 interface
116  * @dev see https://github.com/ethereum/EIPs/issues/179
117  */
118 contract ERC20Basic {
119   uint256 public totalSupply;
120   function balanceOf(address who) public view returns (uint256);
121   function transfer(address to, uint256 value) public returns (bool);
122   event Transfer(address indexed from, address indexed to, uint256 value);
123 }
124 
125 // File: zeppelin-solidity/contracts/token/ERC20.sol
126 
127 /**
128  * @title ERC20 interface
129  * @dev see https://github.com/ethereum/EIPs/issues/20
130  */
131 contract ERC20 is ERC20Basic {
132   function allowance(address owner, address spender) public view returns (uint256);
133   function transferFrom(address from, address to, uint256 value) public returns (bool);
134   function approve(address spender, uint256 value) public returns (bool);
135   event Approval(address indexed owner, address indexed spender, uint256 value);
136 }
137 
138 // File: contracts/token/MintableToken.sol
139 
140 contract MintableToken is ERC20, Contactable {
141     using SafeMath for uint;
142 
143     mapping (address => uint) balances;
144     mapping (address => uint) public holderGroup;
145     bool public mintingFinished = false;
146     address public minter;
147 
148     event MinterChanged(address indexed previousMinter, address indexed newMinter);
149     event Mint(address indexed to, uint amount);
150     event MintFinished();
151 
152     modifier canMint() {
153         require(!mintingFinished);
154         _;
155     }
156 
157     modifier onlyMinter() {
158         require(msg.sender == minter);
159         _;
160     }
161 
162       /**
163      * @dev Function to mint tokens
164      * @param _to The address that will receive the minted tokens.
165      * @param _amount The amount of tokens to mint.
166      * @return A boolean that indicates if the operation was successful.
167      */
168     function mint(address _to, uint _amount, uint _holderGroup) onlyMinter canMint public returns (bool) {
169         totalSupply = totalSupply.add(_amount);
170         balances[_to] = balances[_to].add(_amount);
171         holderGroup[_to] = _holderGroup;
172         Mint(_to, _amount);
173         Transfer(address(0), _to, _amount);
174         return true;
175     }
176 
177     /**
178      * @dev Function to stop minting new tokens.
179      * @return True if the operation was successful.
180      */
181     function finishMinting() onlyMinter canMint public returns (bool) {
182         mintingFinished = true;
183         MintFinished();
184         return true;
185     }
186 
187     function changeMinter(address _minter) external onlyOwner {
188         require(_minter != 0x0);
189         MinterChanged(minter, _minter);
190         minter = _minter;
191     }
192 }
193 
194 // File: contracts/token/TokenReciever.sol
195 
196 /*
197  * Contract that is working with ERC223 tokens
198  */
199  
200  contract TokenReciever {
201     function tokenFallback(address _from, uint _value, bytes _data) public pure {
202     }
203 }
204 
205 // File: contracts/token/HeroCoin.sol
206 
207 contract HeroCoin is ERC223, MintableToken {
208     using SafeMath for uint;
209 
210     string constant public name = "HeroCoin";
211     string constant public symbol = "HRO";
212     uint constant public decimals = 18;
213 
214     mapping(address => mapping (address => uint)) internal allowed;
215 
216     mapping (uint => uint) public activationTime;
217 
218     modifier activeForHolder(address holder) {
219         uint group = holderGroup[holder];
220         require(activationTime[group] <= now);
221         _;
222     }
223 
224     /**
225     * @dev transfer token for a specified address
226     * @param _to The address to transfer to.
227     * @param _value The amount to be transferred.
228     */
229     function transfer(address _to, uint _value) public returns (bool) {
230         bytes memory empty;
231         return transfer(_to, _value, empty);
232     }
233 
234     /**
235     * @dev transfer token for a specified address
236     * @param _to The address to transfer to.
237     * @param _value The amount to be transferred.
238     * @param _data Optional metadata.
239     */
240     function transfer(address _to, uint _value, bytes _data) public activeForHolder(msg.sender) returns (bool) {
241         require(_to != address(0));
242         require(_value <= balances[msg.sender]);
243 
244         // SafeMath.sub will throw if there is not enough balance.
245         balances[msg.sender] = balances[msg.sender].sub(_value);
246         balances[_to] = balances[_to].add(_value);
247 
248         if (isContract(_to)) {
249             TokenReciever receiver = TokenReciever(_to);
250             receiver.tokenFallback(msg.sender, _value, _data);
251         }
252 
253         Transfer(msg.sender, _to, _value);
254         Transfer(msg.sender, _to, _value, _data);
255         return true;
256     }
257 
258     /**
259     * @dev Gets the balance of the specified address.
260     * @param _owner The address to query the the balance of.
261     * @return An uint representing the amount owned by the passed address.
262     */
263     function balanceOf(address _owner) public view returns (uint balance) {
264         return balances[_owner];
265     }
266 
267     /**
268      * @dev Transfer tokens from one address to another
269      * @param _from address The address which you want to send tokens from
270      * @param _to address The address which you want to transfer to
271      * @param _value uint the amount of tokens to be transferred
272      */
273     function transferFrom(address _from, address _to, uint _value) activeForHolder(_from) public returns (bool) {
274         bytes memory empty;
275         return transferFrom(_from, _to, _value, empty);
276     }
277 
278     /**
279      * @dev Transfer tokens from one address to another
280      * @param _from address The address which you want to send tokens from
281      * @param _to address The address which you want to transfer to
282      * @param _value uint the amount of tokens to be transferred
283      * @param _data Optional metadata.
284      */
285     function transferFrom(address _from, address _to, uint _value, bytes _data) public returns (bool) {
286         require(_to != address(0));
287         require(_value <= balances[_from]);
288         require(_value <= allowed[_from][msg.sender]);
289 
290         balances[_from] = balances[_from].sub(_value);
291         balances[_to] = balances[_to].add(_value);
292         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
293 
294         if (isContract(_to)) {
295             TokenReciever receiver = TokenReciever(_to);
296             receiver.tokenFallback(msg.sender, _value, _data);
297         }
298 
299         Transfer(_from, _to, _value);
300         Transfer(_from, _to, _value, _data);
301         return true;
302     }
303 
304     /**
305      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
306      *
307      * Beware that changing an allowance with this method brings the risk that someone may use both the old
308      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
309      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
310      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
311      * @param _spender The address which will spend the funds.
312      * @param _value The amount of tokens to be spent.
313      */
314     function approve(address _spender, uint _value) public returns (bool) {
315         allowed[msg.sender][_spender] = _value;
316         Approval(msg.sender, _spender, _value);
317         return true;
318     }
319 
320     /**
321      * @dev Function to check the amount of tokens that an owner allowed to a spender.
322      * @param _owner address The address which owns the funds.
323      * @param _spender address The address which will spend the funds.
324      * @return A uint specifying the amount of tokens still available for the spender.
325      */
326     function allowance(address _owner, address _spender) public view returns (uint) {
327         return allowed[_owner][_spender];
328     }
329 
330     /**
331      * @dev Increase the amount of tokens that an owner allowed to a spender.
332      *
333      * approve should be called when allowed[_spender] == 0. To increment
334      * allowed value is better to use this function to avoid 2 calls (and wait until
335      * the first transaction is mined)
336      * From MonolithDAO Token.sol
337      * @param _spender The address which will spend the funds.
338      * @param _addedValue The amount of tokens to increase the allowance by.
339      */
340     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
341         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
342         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
343         return true;
344     }
345 
346     /**
347      * @dev Decrease the amount of tokens that an owner allowed to a spender.
348      *
349      * approve should be called when allowed[_spender] == 0. To decrement
350      * allowed value is better to use this function to avoid 2 calls (and wait until
351      * the first transaction is mined)
352      * From MonolithDAO Token.sol
353      * @param _spender The address which will spend the funds.
354      * @param _subtractedValue The amount of tokens to decrease the allowance by.
355      */
356     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
357         uint oldValue = allowed[msg.sender][_spender];
358         if (_subtractedValue > oldValue) {
359             allowed[msg.sender][_spender] = 0;
360         } else {
361             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
362         }
363         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
364         return true;
365     }
366 
367     function setActivationTime(uint _holderGroup, uint _activationTime) external onlyOwner {
368         activationTime[_holderGroup] = _activationTime;
369     }
370 
371     function setHolderGroup(address _holder, uint _holderGroup) external onlyOwner {
372         holderGroup[_holder] = _holderGroup;
373     }
374 
375     function isContract(address _addr) private view returns (bool) {
376         uint length;
377         assembly {
378               //retrieve the size of the code on target address, this needs assembly
379               length := extcodesize(_addr)
380         }
381         return (length>0);
382     }
383 }