1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   uint256 public totalSupply;
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: zeppelin-solidity/contracts/token/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender) public view returns (uint256);
25   function transferFrom(address from, address to, uint256 value) public returns (bool);
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 // File: contracts/token/ERC223.sol
31 
32 contract ERC223 is ERC20 {
33     function transfer(address _to, uint _value, bytes _data) public returns (bool);
34     function transferFrom(address _from, address _to, uint _value, bytes _data) public returns (bool);
35     
36     event Transfer(address indexed from, address indexed to, uint value, bytes data);
37 }
38 
39 // File: contracts/token/TokenReciever.sol
40 
41 /*
42  * Contract that is working with ERC223 tokens
43  */
44  
45  contract TokenReciever {
46     function tokenFallback(address _from, uint _value, bytes _data) public pure {
47     }
48 }
49 
50 // File: zeppelin-solidity/contracts/math/SafeMath.sol
51 
52 /**
53  * @title SafeMath
54  * @dev Math operations with safety checks that throw on error
55  */
56 library SafeMath {
57   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58     if (a == 0) {
59       return 0;
60     }
61     uint256 c = a * b;
62     assert(c / a == b);
63     return c;
64   }
65 
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return c;
71   }
72 
73   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74     assert(b <= a);
75     return a - b;
76   }
77 
78   function add(uint256 a, uint256 b) internal pure returns (uint256) {
79     uint256 c = a + b;
80     assert(c >= a);
81     return c;
82   }
83 }
84 
85 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
86 
87 /**
88  * @title Ownable
89  * @dev The Ownable contract has an owner address, and provides basic authorization control
90  * functions, this simplifies the implementation of "user permissions".
91  */
92 contract Ownable {
93   address public owner;
94 
95 
96   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
97 
98 
99   /**
100    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
101    * account.
102    */
103   function Ownable() public {
104     owner = msg.sender;
105   }
106 
107 
108   /**
109    * @dev Throws if called by any account other than the owner.
110    */
111   modifier onlyOwner() {
112     require(msg.sender == owner);
113     _;
114   }
115 
116 
117   /**
118    * @dev Allows the current owner to transfer control of the contract to a newOwner.
119    * @param newOwner The address to transfer ownership to.
120    */
121   function transferOwnership(address newOwner) public onlyOwner {
122     require(newOwner != address(0));
123     OwnershipTransferred(owner, newOwner);
124     owner = newOwner;
125   }
126 
127 }
128 
129 // File: zeppelin-solidity/contracts/ownership/Contactable.sol
130 
131 /**
132  * @title Contactable token
133  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
134  * contact information.
135  */
136 contract Contactable is Ownable{
137 
138     string public contactInformation;
139 
140     /**
141      * @dev Allows the owner to set a string with their contact information.
142      * @param info The contact information to attach to the contract.
143      */
144     function setContactInformation(string info) onlyOwner public {
145          contactInformation = info;
146      }
147 }
148 
149 // File: contracts/token/PlayHallToken.sol
150 
151 contract PlayHallToken is ERC223, Contactable {
152     using SafeMath for uint;
153 
154     string constant public name = "PlayHall Token";
155     string constant public symbol = "PHT";
156     uint constant public decimals = 18;
157 
158     bool public isActivated = false;
159 
160     mapping (address => uint) balances;
161     mapping (address => mapping (address => uint)) internal allowed;
162     mapping (address => bool) public freezedList;
163     
164     // address, who is allowed to issue new tokens (presale and sale contracts)
165     address public minter;
166 
167     bool public mintingFinished = false;
168 
169     event Mint(address indexed to, uint amount);
170     event MintingFinished();
171 
172     modifier onlyMinter() {
173         require(msg.sender == minter);
174         _;
175     }
176 
177     modifier canMint() {
178         require(!mintingFinished);
179         _;
180     }
181 
182     modifier whenActivated() {
183         require(isActivated);
184         _;
185     }
186 
187     function PlayHallToken() public {
188         minter = msg.sender;
189     }
190 
191     /**
192     * @dev transfer token for a specified address
193     * @param _to The address to transfer to.
194     * @param _value The amount to be transferred.
195     */
196     function transfer(address _to, uint _value) public returns (bool) {
197         bytes memory empty;
198         return transfer(_to, _value, empty);
199     }
200 
201     /**
202     * @dev transfer token for a specified address
203     * @param _to The address to transfer to.
204     * @param _value The amount to be transferred.
205     * @param _data Optional metadata.
206     */
207     function transfer(address _to, uint _value, bytes _data) public whenActivated returns (bool) {
208         require(_to != address(0));
209         require(_value <= balances[msg.sender]);
210         require(!freezedList[msg.sender]);
211 
212         // SafeMath.sub will throw if there is not enough balance.
213         balances[msg.sender] = balances[msg.sender].sub(_value);
214         balances[_to] = balances[_to].add(_value);
215 
216         if (isContract(_to)) {
217             TokenReciever receiver = TokenReciever(_to);
218             receiver.tokenFallback(msg.sender, _value, _data);
219         }
220 
221         Transfer(msg.sender, _to, _value);
222         Transfer(msg.sender, _to, _value, _data);
223         return true;
224     }
225 
226     /**
227     * @dev Gets the balance of the specified address.
228     * @param _owner The address to query the the balance of.
229     * @return An uint representing the amount owned by the passed address.
230     */
231     function balanceOf(address _owner) public view returns (uint balance) {
232         return balances[_owner];
233     }
234 
235     /**
236      * @dev Transfer tokens from one address to another
237      * @param _from address The address which you want to send tokens from
238      * @param _to address The address which you want to transfer to
239      * @param _value uint the amount of tokens to be transferred
240      */
241     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
242         bytes memory empty;
243         return transferFrom(_from, _to, _value, empty);
244     }
245 
246     /**
247      * @dev Transfer tokens from one address to another
248      * @param _from address The address which you want to send tokens from
249      * @param _to address The address which you want to transfer to
250      * @param _value uint the amount of tokens to be transferred
251      * @param _data Optional metadata.
252      */
253     function transferFrom(address _from, address _to, uint _value, bytes _data) public whenActivated returns (bool) {
254         require(_to != address(0));
255         require(_value <= balances[_from]);
256         require(_value <= allowed[_from][msg.sender]);
257         require(!freezedList[_from]);
258 
259         balances[_from] = balances[_from].sub(_value);
260         balances[_to] = balances[_to].add(_value);
261         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
262 
263         if (isContract(_to)) {
264             TokenReciever receiver = TokenReciever(_to);
265             receiver.tokenFallback(_from, _value, _data);
266         }
267 
268         Transfer(_from, _to, _value);
269         Transfer(_from, _to, _value, _data);
270         return true;
271     }
272 
273     /**
274      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
275      *
276      * Beware that changing an allowance with this method brings the risk that someone may use both the old
277      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
278      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
279      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
280      * @param _spender The address which will spend the funds.
281      * @param _value The amount of tokens to be spent.
282      */
283     function approve(address _spender, uint _value) public returns (bool) {
284         require(_value == 0 || allowed[msg.sender][_spender] == 0);
285         allowed[msg.sender][_spender] = _value;
286         Approval(msg.sender, _spender, _value);
287         return true;
288     }
289 
290     /**
291      * @dev Function to check the amount of tokens that an owner allowed to a spender.
292      * @param _owner address The address which owns the funds.
293      * @param _spender address The address which will spend the funds.
294      * @return A uint specifying the amount of tokens still available for the spender.
295      */
296     function allowance(address _owner, address _spender) public view returns (uint) {
297         return allowed[_owner][_spender];
298     }
299 
300     /**
301      * @dev Increase the amount of tokens that an owner allowed to a spender.
302      *
303      * approve should be called when allowed[_spender] == 0. To increment
304      * allowed value is better to use this function to avoid 2 calls (and wait until
305      * the first transaction is mined)
306      * From MonolithDAO Token.sol
307      * @param _spender The address which will spend the funds.
308      * @param _addedValue The amount of tokens to increase the allowance by.
309      */
310     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
311         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
312         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
313         return true;
314     }
315 
316     /**
317      * @dev Decrease the amount of tokens that an owner allowed to a spender.
318      *
319      * approve should be called when allowed[_spender] == 0. To decrement
320      * allowed value is better to use this function to avoid 2 calls (and wait until
321      * the first transaction is mined)
322      * From MonolithDAO Token.sol
323      * @param _spender The address which will spend the funds.
324      * @param _subtractedValue The amount of tokens to decrease the allowance by.
325      */
326     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
327         uint oldValue = allowed[msg.sender][_spender];
328         if (_subtractedValue > oldValue) {
329             allowed[msg.sender][_spender] = 0;
330         } else {
331             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
332         }
333         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
334         return true;
335     }
336 
337       /**
338      * @dev Function to mint tokens
339      * @param _to The address that will receive the minted tokens.
340      * @param _amount The amount of tokens to mint.
341      * @return A boolean that indicates if the operation was successful.
342      */
343     function mint(address _to, uint _amount, bool freeze) canMint onlyMinter external returns (bool) {
344         totalSupply = totalSupply.add(_amount);
345         balances[_to] = balances[_to].add(_amount);
346         if (freeze) {
347             freezedList[_to] = true;
348         }
349         Mint(_to, _amount);
350         Transfer(address(0), _to, _amount);
351         return true;
352     }
353 
354     /**
355      * @dev Function to stop minting new tokens.
356      * @return True if the operation was successful.
357      */
358     function finishMinting() canMint onlyMinter external returns (bool) {
359         mintingFinished = true;
360         MintingFinished();
361         return true;
362     }
363     
364     /**
365      * Minter can pass it's role to another address
366      */
367     function setMinter(address _minter) external onlyMinter {
368         require(_minter != 0x0);
369         minter = _minter;
370     }
371 
372     /**
373      * Owner can unfreeze any address
374      */
375     function removeFromFreezedList(address user) external onlyOwner {
376         freezedList[user] = false;
377     }
378 
379     /**
380      * Activation of the token allows all tokenholders to operate with the token
381      */
382     function activate() external onlyOwner returns (bool) {
383         isActivated = true;
384         return true;
385     }
386 
387     function isContract(address _addr) private view returns (bool) {
388         uint length;
389         assembly {
390               //retrieve the size of the code on target address, this needs assembly
391               length := extcodesize(_addr)
392         }
393         return (length>0);
394     }
395 }