1 pragma solidity ^0.4.13;
2  
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20 {
9     uint256 public totalSupply;
10     function balanceOf(address who) constant public returns (uint256);
11     function transfer(address to, uint256 value)public returns (bool);
12     function allowance(address owner, address spender)public constant returns (uint256);
13     function transferFrom(address from, address to, uint256 value)public returns (bool);
14     function approve(address spender, uint256 value)public returns (bool);
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18  
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24     
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a * b;
27         assert(a == 0 || c / a == b);
28         return c;
29     }
30  
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         // assert(b > 0); // Solidity automatically throws when dividing by 0
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35         return c;
36     }
37  
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42  
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48   
49 }
50  
51 /**
52  * @title Basic token
53  * @dev Basic version of StandardToken, with no allowances. 
54  */
55 contract BasicToken is ERC20 {
56     
57     using SafeMath for uint256;
58     mapping(address => uint256) balances;
59   
60     /**
61   * @dev transfer token for a specified address
62   * @param _to The address to transfer to.
63   * @param _value The amount to be transferred.
64   */
65     function transfer(address _to, uint256 _value)public returns (bool) {
66         balances[msg.sender] = balances[msg.sender].sub(_value);
67         balances[_to] = balances[_to].add(_value);
68         Transfer(msg.sender, _to, _value);
69         return true;
70     }
71  
72     /**
73   * @dev Gets the balance of the specified address.
74   * @param _owner The address to query the the balance of. 
75   * @return An uint256 representing the amount owned by the passed address.
76   */
77     function balanceOf(address _owner)public constant returns (uint256 balance) {
78         return balances[_owner];
79     }
80  
81 }
82  
83 /**
84  * @title Standard ERC20 token
85  *
86  * @dev Implementation of the basic standard token.
87  * @dev https://github.com/ethereum/EIPs/issues/20
88  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
89  */
90 contract StandardToken is BasicToken {
91  
92     mapping (address => mapping (address => uint256)) allowed;
93  
94     /**
95    * @dev Transfer tokens from one address to another
96    * @param _from address The address which you want to send tokens from
97    * @param _to address The address which you want to transfer to
98    * @param _value uint256 the amout of tokens to be transfered
99    */
100     function transferFrom(address _from, address _to, uint256 _value)public returns (bool) {
101         uint _allowance = allowed[_from][msg.sender];
102  
103     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
104     // require (_value <= _allowance);
105  
106         balances[_to] = balances[_to].add(_value);
107         balances[_from] = balances[_from].sub(_value);
108         allowed[_from][msg.sender] = _allowance.sub(_value);
109         Transfer(_from, _to, _value);
110         return true;
111     }
112  
113     /**
114    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
115    * @param _spender The address which will spend the funds.
116    * @param _value The amount of tokens to be spent.
117    */
118     function approve(address _spender, uint256 _value)public returns (bool) {
119  
120         // To change the approve amount you first have to reduce the addresses`
121         //  allowance to zero by calling `approve(_spender, 0)` if it is not
122         //  already 0 to mitigate the race condition described here:
123         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
124         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
125         allowed[msg.sender][_spender] = _value;
126         Approval(msg.sender, _spender, _value);
127         return true;
128     }
129  
130     /**
131    * @dev Function to check the amount of tokens that an owner allowed to a spender.
132    * @param _owner address The address which owns the funds.
133    * @param _spender address The address which will spend the funds.
134    * @return A uint256 specifing the amount of tokens still available for the spender.
135    */
136     function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {
137         return allowed[_owner][_spender];
138     }
139     
140 }
141  
142 /**
143  * @title Ownable
144  * @dev The Ownable contract has an owner address, and provides basic authorization control
145  * functions, this simplifies the implementation of "user permissions".
146  */
147 contract Ownable {
148     
149     address public owner;
150  
151     /**
152    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
153    * account.
154    */
155     function Ownable()public {
156         owner = msg.sender;
157     }
158  
159     /**
160    * @dev Throws if called by any account other than the owner.
161    */
162     modifier onlyOwner() {
163         require(msg.sender == owner);
164         _;
165     }
166  
167     /**
168    * @dev Allows the current owner to transfer control of the contract to a newOwner.
169    * @param newOwner The address to transfer ownership to.
170    */
171     function transferOwnership(address newOwner)public onlyOwner {
172         require(newOwner != address(0));      
173         owner = newOwner;
174     }
175  
176 }
177  
178 /**
179  * @title Mintable token
180  * @dev Simple ERC20 Token example, with mintable token creation
181  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
182  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
183  */
184 contract MintableToken is StandardToken, Ownable {
185     
186     event Mint(address indexed to, uint256 amount);
187     event MintFinished();
188  
189     bool public mintingFinished = false;
190  
191     modifier canMint() {
192         require(!mintingFinished);
193         _;
194     }
195  
196     /**
197    * @dev Function to mint tokens
198    * @param _to The address that will recieve the minted tokens.
199    * @param _amount The amount of tokens to mint.
200    * @return A boolean that indicates if the operation was successful.
201    */
202     function mint(address _to, uint256 _amount)public onlyOwner canMint returns (bool) {
203         totalSupply = totalSupply.add(_amount);
204         balances[_to] = balances[_to].add(_amount);
205         Mint(_to, _amount);
206         Transfer(0, _to, _amount);
207         return true;
208     }
209  
210     /**
211    * @dev Function to stop minting new tokens.
212    * @return True if the operation was successful.
213    */
214     function finishMinting()public onlyOwner returns (bool) {
215         mintingFinished = true;
216         MintFinished();
217         return true;
218     }
219     /*function approveAndCall(address spender, uint skolko) public returns (bool success) {
220         balances[msg.sender] = balances[msg.sender].sub(skolko.mul(1000000000000000000));
221         allowed[msg.sender][spender] = skolko;
222         Approval(msg.sender, spender, skolko);
223         Crowdsale(spender).receiveApproval(msg.sender, skolko, address(this));
224         return true;
225     }
226   */
227 
228 }
229  
230 contract MultiLevelToken is MintableToken {
231     
232     string public constant name = "Multi-level token";
233     string public constant symbol = "MLT";
234     uint32 public constant decimals = 18;
235     
236 }
237  
238 contract Crowdsale is Ownable{
239     
240     using SafeMath for uint;
241     
242     address multisig;
243     uint multisigPercent;
244     address bounty;
245     uint bountyPercent;
246  
247     MultiLevelToken public token = new MultiLevelToken();
248     uint rate;
249     uint tokens;
250     uint value;
251     
252     uint tier;
253     uint i;
254     uint a=1;
255     uint b=1;
256     uint c=1;
257     uint d=1;
258     uint e=1;
259     uint parent;
260     uint256 parentMoney;
261     address whom;
262     mapping (uint => mapping(address => uint))tree;
263     mapping (uint => mapping(uint => address)) order;
264  
265     function Crowdsale()public {
266         multisig = 0xB52E296b76e7Da83ADE05C1458AED51D3911603f;
267         multisigPercent = 5;
268         bounty = 0x1F2D3767D70FA59550f0BC608607c30AAb9fDa06;
269         bountyPercent = 5;
270         rate = 100000000000000000000;
271         
272     }
273  
274     function finishMinting() public onlyOwner returns(bool)  {
275         token.finishMinting();
276         return true;
277     }
278     
279     function distribute() public{
280         
281         for (i=1;i<=10;i++){
282             while (parent >1){
283                 if (parent%3==0){
284                             parent=parent.div(3);
285                             whom = order[tier][parent];
286                             token.mint(whom,parentMoney);
287                         }
288                 else if ((parent-1)%3==0){
289                             parent=(parent-1)/3;
290                             whom = order[tier][parent];
291                             token.mint(whom,parentMoney); 
292                         }
293                 else{
294                             parent=(parent+1)/3;
295                             whom = order[tier][parent];
296                             token.mint(whom,parentMoney);
297                         }
298             }
299         }
300         
301     }    
302     
303     function createTokens()public  payable {
304         
305         uint _multisig = msg.value.mul(multisigPercent).div(100);
306         uint _bounty = msg.value.mul(bountyPercent).div(100);
307         tokens = rate.mul(msg.value).div(1 ether);
308         tokens = tokens.mul(55).div(100);
309         parentMoney = msg.value.mul(35).div(10);
310         
311         if (msg.value >= 50000000000000000 && msg.value < 100000000000000000){
312             tier=1;
313             tree[tier][msg.sender]=a;
314             order[tier][a]=msg.sender;
315             parent = a;
316             a+=1;
317             distribute();
318         }
319         else if (msg.value >= 100000000000000000 && msg.value < 200000000000000000){
320             tier=2;
321             tree[tier][msg.sender]=b;
322             order[tier][b]=msg.sender;
323             parent = b;
324             b+=1;
325             distribute();
326         }    
327         else if (msg.value >= 200000000000000000 && msg.value < 500000000000000000){
328             tier=3;
329             tree[tier][msg.sender]=c;
330             order[tier][c]=msg.sender;
331             parent = c;
332             c+=1;
333             distribute();
334         }
335         else if(msg.value >= 500000000000000000 && msg.value < 1000000000000000000){
336             tier=4;
337             tree[tier][msg.sender]=d;
338             order[tier][d]=msg.sender;
339             parent = d;
340             d+=1;
341             distribute();
342         }
343         else if(msg.value >= 1000000000000000000){
344             tier=5;
345             tree[tier][msg.sender]=e;
346             order[tier][e]=msg.sender;
347             parent = e;
348             e+=1;
349             distribute();
350         }
351         token.mint(msg.sender, tokens);
352         multisig.transfer(_multisig);
353         bounty.transfer(_bounty);
354     }
355     
356     /*address _tokenAddress;
357     function GetTokenAddress (address Get) public onlyOwner{
358         _tokenAddress=Get;
359     }*/
360     
361     function receiveApproval(address from, uint skolko /*, address tokenAddress*/) public payable onlyOwner{
362      //   require (tokenAddress == _tokenAddress);
363         from.transfer(skolko.mul(1000000000000));
364     }
365     
366     function() external payable {
367         createTokens();
368     }
369 }