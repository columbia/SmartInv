1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) public pure returns (uint256) {
9      if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert( c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) public pure returns (uint256) {
18     //assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     //assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) public pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) public pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 
35   function max64(uint64 a, uint64 b) public pure returns (uint64) {
36     return a >= b ? a : b;
37   }
38 
39   function min64(uint64 a, uint64 b) public pure returns (uint64) {
40     return a < b ? a : b;
41   }
42 
43   function max256(uint256 a, uint256 b) external pure returns (uint256) {
44     return a >= b ? a : b;
45   }
46 
47   function min256(uint256 a, uint256 b) external pure returns (uint256) {
48     return a < b ? a : b;
49   }
50 
51 }
52 
53 contract Owned {
54     address public owner;
55     address public newOwner;
56     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58      constructor() public {
59         owner = msg.sender;
60     }
61 
62     modifier onlyOwner {
63         require(msg.sender == owner);
64         _;
65     }
66 
67     function transferOwnership(address _newOwner) onlyOwner public{
68         newOwner = _newOwner;
69     }
70 
71     function acceptOnwership() public {
72         require(msg.sender == newOwner);
73         emit OwnershipTransferred(owner,newOwner);
74         owner=newOwner;
75         newOwner=address(0);
76     }
77 
78 }
79 
80 contract ContractReceiver { function tokenFallback(address _from,uint _value,bytes _data)  external;}
81 
82 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
83 
84 contract TokenERC223 is Owned{
85     //Use safemath library to check overflows and underflows
86     using SafeMath for uint256;
87 
88     // Public variables of the token
89 
90     string  public name="Littafi Token";
91     string  public symbol="LITT";
92     uint8   public decimals = 18;// 18 decimals is the strongly suggested default, avoid changing it
93     uint256 public totalSupply=1000000000; //1,000,000,000 tokens
94     address[] public littHolders;
95     uint256 public buyRate=10000;
96     bool    public saleIsOn=true;
97 
98      //Admin structure
99     struct Admin{
100         bool isAdmin;
101         address beAdmin;
102     }
103 
104     //Contract mutation access modifier
105     modifier onlyAdmin{
106         require(msg.sender == owner || admins[msg.sender].isAdmin);
107         _;
108     }
109 
110     //Create an array of admins
111     mapping(address => Admin) admins;
112     
113     // This creates an array with all balances
114     mapping (address => uint256) public balanceOf;
115     
116     mapping (address => mapping (address => uint256)) public allowance;
117 
118     mapping (address => bool) public frozenAccount;
119     
120     // This generates a public event on the blockchain that will notify clients
121     event FrozenFunds(address target, bool frozen);
122 
123     // This generates a public event on the blockchain that will notify clients
124     event Transfer(address indexed _from, address indexed _to, uint256 _value);
125 
126     event Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
127 
128     // This notifies clients about the amount burnt
129     event Burn(address indexed from, uint256 value);
130 
131     //This notifies clients about an approval request for transferFrom()
132     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
133 
134     //Notifies contract owner about a successfult terminated/destroyed contract
135     event LogContractDestroyed(address indexed contractAddress, bytes30 _extraData);
136 
137     //Notifies clients about token sale
138     event LogTokenSale(address indexed _client, uint256 _amountTransacted);
139 
140     //Notifies clients of newly set buy/sell prices
141     event LogNewPrices(address indexed _admin, uint256 _buyRate);
142 
143     //Notifies of newly minted tokensevent
144     event LogMintedTokens(address indexed _this, uint256 _amount);
145 
146     /**
147      * Constrctor function
148      *
149      * Initializes contract with initial supply tokens to the creator of the contract
150      */
151     constructor() public {
152         totalSupply = totalSupply*10**uint256(decimals);  // Update total supply with the decimal amount
153         balanceOf[this]=totalSupply;
154         Owned(msg.sender);
155     }
156     
157     function transfer(address _to, uint256 _value, bytes _data, string _custom_fallback) public returns (bool success) {
158      require(!frozenAccount[msg.sender] && !frozenAccount[_to]);
159 
160     if(isContract(_to)) {
161         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
162         balanceOf[_to] = balanceOf[_to].add(_value);
163         assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
164         emit Transfer(msg.sender, _to, _value);
165         emit Transfer(msg.sender, _to, _value, _data);
166 
167         return true;
168     }
169     else {
170         return transferToAddress(_to, _value, _data);
171      }
172    }
173     
174     function transfer(address _to, uint256 _value, bytes _data)public  returns (bool success) {
175      require(!frozenAccount[msg.sender] && !frozenAccount[_to]);
176      
177     if(isContract(_to)) {
178         return transferToContract(_to, _value, _data);
179     }
180     else {
181         return transferToAddress(_to, _value, _data);
182     }
183   }
184   
185     // Standard function transfer similar to ERC20 transfer with no _data .
186     // Added due to backwards compatibility reasons .
187     function transfer(address _to, uint256 _value)public returns (bool success) {
188      require(!frozenAccount[msg.sender] && !frozenAccount[_to]);
189       
190      bytes memory empty;
191      if(isContract(_to)) {
192         return transferToContract(_to, _value, empty);
193      }
194      else {
195         return transferToAddress(_to, _value, empty);
196      }
197    }
198 
199     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
200     function isContract(address _addr) public view returns (bool) {
201       uint length;
202       assembly {
203             //retrieve the size of the code on target address, this needs assembly
204             length := extcodesize(_addr)
205       }
206       return (length>0);
207     }
208 
209     //function that is called when transaction target is an address
210     function transferToAddress(address _to, uint256 _value, bytes _data) private returns (bool success) {
211      require(balanceOf[msg.sender] > _value); 
212      
213      balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
214      balanceOf[_to] = balanceOf[_to].add(_value);
215      emit Transfer(msg.sender, _to, _value, _data);
216      emit Transfer(msg.sender, _to, _value);
217      return true;
218     }
219   
220     //function that is called when transaction target is a contract
221     function transferToContract(address _to, uint256 _value, bytes _data) private returns (bool success) {
222      require(balanceOf[msg.sender] > _value); 
223        
224      balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
225      balanceOf[_to] = balanceOf[_to].add(_value);
226      ContractReceiver receiver = ContractReceiver(_to);
227      receiver.tokenFallback(msg.sender, _value, _data);
228      emit Transfer(msg.sender, _to, _value);
229      emit Transfer(msg.sender, _to, _value, _data);
230      return true;
231     }
232 
233     function transferToOwner(uint256 _amount) public onlyOwner(){
234         require(balanceOf[this] > convert(_amount));
235         uint256 amount=convert(_amount);
236         balanceOf[this]=balanceOf[this].sub(amount);
237         balanceOf[owner]=balanceOf[owner].add(amount);
238         emit Transfer(this,owner,amount);
239     }
240     /**
241      * Conversion
242      *
243      * @param _value convert to proper value for math operations
244      *///0x44b6782dde9118baafe20a39098b1b46589cd378
245     function convert(uint256 _value) internal view returns (uint256) {
246          return _value*10**uint256(decimals);
247      }
248 
249     /**
250      * Destroy tokens
251      *
252      * Remove `_value` tokens from the system irreversibly
253      *
254      * @param _value the amount of money to burn
255      */
256     function burn(uint256 _value) public onlyOwner {
257         require(balanceOf[this] >= convert(_value)); 
258         uint256 value=convert(_value);
259         // Check if the contract has enough
260         balanceOf[this]=balanceOf[this].sub(value);    // Subtract from the contract
261         totalSupply=totalSupply.sub(value);     // Updates totalSupply
262         emit Burn(this, value);
263     }
264 
265     function freezeAccount(address target, bool freeze) public onlyAdmin {
266         require(target != owner);
267         frozenAccount[target] = freeze;
268         emit FrozenFunds(target, freeze);
269     }
270 
271     function mintToken(uint256 mintedAmount) public onlyOwner {
272         uint256 mint=convert(mintedAmount);
273         balanceOf[this] =balanceOf[this].add(mint);
274         totalSupply =totalSupply.add(mint);
275 
276         emit LogMintedTokens(this, mint);
277     }
278 
279     function setPrices(uint256 newBuyRate) public onlyAdmin{
280         buyRate = newBuyRate;
281         emit LogNewPrices(msg.sender,buyRate);
282     }
283 
284     function buy() payable public {
285         require(msg.value > 0);
286         require(msg.sender != owner && saleIsOn == true);
287         uint256 amount=msg.value.mul(buyRate);
288         uint256 percentile=amount.add(getEthRate(msg.value).mul(amount).div(100));
289         balanceOf[msg.sender]=balanceOf[msg.sender].add(percentile);  // calculates the amount and makes the transaction
290         balanceOf[this]=balanceOf[this].sub(percentile);
291         littHolders.push(msg.sender);
292         owner.transfer(msg.value);
293         emit LogTokenSale(msg.sender,percentile);
294     }
295 
296     function () public payable {
297         buy();
298     }
299 
300     function destroyContract() public onlyOwner {
301        selfdestruct(owner);
302        transferOwnership(0x0);
303        emit LogContractDestroyed(this, "Contract has been destroyed");
304    }
305    
306     function getEthRate(uint256 _value) private pure returns(uint256){
307        require(_value > 0 );
308        if(_value < 3 ether)
309          return 10;
310        if(_value >= 3 ether && _value < 5 ether )
311          return 20;
312        if(_value >= 5 ether && _value < 24 ether )
313          return 30;
314        if(_value >= 24 ether )
315          return 40;
316    }
317    
318     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
319         require(_value <= allowance[_from][msg.sender]);     // Check allowance
320         allowance[_from][msg.sender] =allowance[_from][msg.sender].sub(_value);
321         transfer(_to, _value);
322         return true;
323     }
324     
325     function approve(address _spender, uint256 _value) public returns (bool success) {
326         allowance[msg.sender][_spender] = _value;
327         emit Approval(msg.sender,_spender,_value);
328         return true;
329     }
330     
331     function approveAndCall(address _spender, uint256 _value, bytes _extraData)public returns (bool success) {
332         tokenRecipient spender = tokenRecipient(_spender);
333         if (approve(_spender, _value)) {
334             spender.receiveApproval(msg.sender, _value, this, _extraData);
335             return true;
336         }
337     }
338    
339     function setName(string _name) public onlyOwner() returns (bool success) {
340         name=_name;
341         return true;
342     }
343     
344     function setSaleStatus(bool _bool) public onlyOwner() returns (bool success){
345         saleIsOn=_bool;
346         return true;
347     }
348 
349 
350 }