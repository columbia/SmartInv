1 pragma solidity > 0.4.99 <0.6.0;
2 
3 interface IAssetSplitContracts {
4  function addContract(address payable _contractAddress, address payable _creatorAddress, uint256 _contractType) external returns (bool success);
5 }
6 
7 interface IERC20Token {
8     function balanceOf(address owner) external returns (uint256);
9     function transfer(address to, uint256 amount) external returns (bool);
10     function burn(uint256 _value) external returns (bool);
11     function decimals() external returns (uint256);
12     function approve(address _spender, uint256 _value) external returns (bool success);
13     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
14 }
15 
16 contract Ownable {
17   address payable public _owner;
18 
19   event OwnershipTransferred(
20     address indexed previousOwner,
21     address indexed newOwner
22   );
23 
24   /**
25   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
26   * account.
27   */
28   constructor() internal {
29     _owner = tx.origin;
30     emit OwnershipTransferred(address(0), _owner);
31   }
32 
33   /**
34   * @return the address of the owner.
35   */
36   function owner() public view returns(address) {
37     return _owner;
38   }
39 
40   /**
41   * @dev Throws if called by any account other than the owner.
42   */
43   modifier onlyOwner() {
44     require(isOwner());
45     _;
46   }
47 
48   /**
49   * @return true if `msg.sender` is the owner of the contract.
50   */
51   function isOwner() public view returns(bool) {
52     return msg.sender == _owner;
53   }
54 
55   /**
56   * @dev Allows the current owner to relinquish control of the contract.
57   * @notice Renouncing to ownership will leave the contract without an owner.
58   * It will not be possible to call the functions with the `onlyOwner`
59   * modifier anymore.
60   */
61   function renounceOwnership() public onlyOwner {
62     emit OwnershipTransferred(_owner, address(0));
63     _owner = address(0);
64   }
65 
66   /**
67   * @dev Allows the current owner to transfer control of the contract to a newOwner.
68   * @param newOwner The address to transfer ownership to.
69   */
70   function transferOwnership(address payable newOwner) public onlyOwner {
71     _transferOwnership(newOwner);
72   }
73 
74   /**
75   * @dev Transfers control of the contract to a newOwner.
76   * @param newOwner The address to transfer ownership to.
77   */
78   function _transferOwnership(address payable newOwner) internal {
79     require(newOwner != address(0));
80     emit OwnershipTransferred(_owner, newOwner);
81     _owner = newOwner;
82   }
83 }
84 
85 /**
86  * @title SafeMath
87  * @dev Math operations with safety checks that throw on error
88  */
89 library SafeMath {
90 
91   /**
92   * @dev Multiplies two numbers, throws on overflow.
93   */
94   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
95     if (a == 0) {
96       return 0;
97     }
98     uint256 c = a * b;
99     assert(c / a == b);
100     return c;
101   }
102 
103   /**
104   * @dev Integer division of two numbers, truncating the quotient.
105   */
106   function div(uint256 a, uint256 b) internal pure returns (uint256) {
107     // assert(b > 0); // Solidity automatically throws when dividing by 0
108     uint256 c = a / b;
109     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110     return c;
111   }
112 
113   /**
114   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
115   */
116   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117     assert(b <= a);
118     return a - b;
119   }
120 
121   /**
122   * @dev Adds two numbers, throws on overflow.
123   */
124   function add(uint256 a, uint256 b) internal pure returns (uint256) {
125     uint256 c = a + b;
126     assert(c >= a);
127     return c;
128   }
129 }
130 contract ERC20Interface {
131     
132     string public name;
133     string public symbol;
134     uint8 public decimals;
135     uint public totalSupply;
136     
137 
138     function transfer(address _to, uint256 _value) public returns (bool success);
139     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
140     function approve(address _spender, uint256 _value) public returns (bool success);
141     function allowance(address _owner, address _spender) public returns (uint256 remaining);
142 
143 
144     event Transfer(address indexed _from, address indexed _to, uint256 _value);
145     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
146     
147 }
148 
149 contract ERC20 is ERC20Interface {
150     
151     mapping(address => uint256) public balanceOf;
152     mapping(address => mapping(address => uint256)) allowed;
153     
154 
155     constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _totalSupply) public {
156        name =  _name;
157        symbol = _symbol;
158        decimals = _decimals;
159        totalSupply = _totalSupply * 10 ** uint256(_decimals);
160        balanceOf[tx.origin] = totalSupply;
161     }
162 
163     function transfer(address _to, uint256 _value) public returns (bool success){
164         require(_to != address(0));
165         require(balanceOf[msg.sender] >= _value);
166         require(balanceOf[ _to] + _value >= balanceOf[ _to]); 
167 
168         balanceOf[msg.sender] -= _value;
169         balanceOf[_to] += _value;
170 
171         emit Transfer(msg.sender, _to, _value);
172 
173         return true;
174     }
175     
176     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
177         require(_to != address(0));
178         require(allowed[msg.sender][_from] >= _value);
179         require(balanceOf[_from] >= _value);
180         require(balanceOf[ _to] + _value >= balanceOf[ _to]);
181 
182         balanceOf[_from] -= _value;
183         balanceOf[_to] += _value;
184 
185         allowed[msg.sender][_from] -= _value;
186 
187         emit Transfer(msg.sender, _to, _value);
188         return true;
189     }
190     
191     function approve(address _spender, uint256 _value) public returns (bool success){
192         allowed[msg.sender][_spender] = _value;
193 
194         emit Approval(msg.sender, _spender, _value);
195         return true;
196     }
197     
198     function allowance(address _owner, address _spender) public returns (uint256 remaining){
199          return allowed[_owner][_spender];
200     }
201 
202 }
203 
204 contract ERC20Token is ERC20, Ownable {
205 
206     string public constant createdBy = "AssetSplit.org - the guys who cut the pizza";
207 
208     event AddSupply(uint amount);
209     event Burn(address target, uint amount);
210     event Sold(address buyer, uint256 amount);
211     
212     constructor (string memory _name, string memory _symbol, uint8 _decimals, uint _totalSupply) 
213         ERC20(_name, _symbol, _decimals, _totalSupply) public {
214         }
215    
216     function transfer(address _to, uint256 _value) public returns (bool success) {
217         success = _transfer(msg.sender, _to, _value);
218     }
219 
220     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
221         require(allowed[_from][msg.sender] >= _value);
222         success =  _transfer(_from, _to, _value);
223         allowed[_from][msg.sender]  -= _value;
224     }
225 
226     function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
227       require(_to != address(0));
228 
229       require(balanceOf[_from] >= _value);
230       require(balanceOf[ _to] + _value >= balanceOf[ _to]);
231 
232       balanceOf[_from] -= _value;
233       balanceOf[_to] += _value;
234 
235    
236       emit Transfer(_from, _to, _value);
237       return true;
238     }
239 
240     function burn(uint256 _value) public returns (bool success) {
241        require(balanceOf[msg.sender] >= _value);
242 
243        totalSupply -= _value; 
244        balanceOf[msg.sender] -= _value;
245 
246        emit Burn(msg.sender, _value);
247        return true;
248     }
249 
250     function burnFrom(address _from, uint256 _value)  public returns (bool success) {
251         require(balanceOf[_from] >= _value);
252         require(allowed[_from][msg.sender] >= _value);
253 
254         totalSupply -= _value; 
255         balanceOf[msg.sender] -= _value;
256         allowed[_from][msg.sender] -= _value;
257 
258         emit Burn(msg.sender, _value);
259         return true;
260     }
261     function () external payable {
262         
263     }
264 }
265 
266 contract TokenSale is Ownable {
267     
268     using SafeMath for uint256;
269     
270     string public constant createdBy = "AssetSplit.org - the guys who cut the pizza";
271     
272     IERC20Token public tokenContract;
273     uint256 public tokenPerEther;
274 
275     uint256 public tokensSold;
276     
277     uint256 public bonusStage1;
278     uint256 public bonusStage2;
279     uint256 public bonusStage3;
280     
281     uint256 public bonusPercentage1;
282     uint256 public bonusPercentage2;
283     uint256 public bonusPercentage3;
284 
285     event Sold(address buyer, uint256 amount);
286 
287     constructor(address _tokenContract, uint256 _tokenPerEther, uint256 _bonusStage1, uint256 _bonusPercentage1, uint256 _bonusStage2, uint256 _bonusPercentage2, uint256 _bonusStage3, uint256 _bonusPercentage3) public {
288         tokenContract = IERC20Token(_tokenContract);
289         tokenPerEther = _tokenPerEther;
290         
291         bonusStage1 = _bonusStage1.mul(1 ether);
292         bonusStage2 = _bonusStage2.mul(1 ether);
293         bonusStage3 = _bonusStage3.mul(1 ether);
294         bonusPercentage1 = _bonusPercentage1;
295         bonusPercentage2 = _bonusPercentage2;
296         bonusPercentage3 = _bonusPercentage3;
297     }
298     
299     function buyTokenWithEther() public payable {
300         address payable creator = _owner;
301         uint256 scaledAmount;
302         
303         require(msg.value > 0);
304         
305         if (msg.value < bonusStage1 || bonusStage1 == 0) {
306         scaledAmount = msg.value.mul(tokenPerEther).mul(uint256(10) ** tokenContract.decimals()).div(10 ** 18);
307         }
308         if (bonusStage1 != 0 && msg.value >= bonusStage1) {
309             scaledAmount = msg.value.mul(tokenPerEther).mul(uint256(10) ** tokenContract.decimals()).div(10 ** 18).mul(bonusPercentage1).div(100);
310         }
311         if (bonusStage2 != 0 && msg.value >= bonusStage2) {
312             scaledAmount = msg.value.mul(tokenPerEther).mul(uint256(10) ** tokenContract.decimals()).div(10 ** 18).mul(bonusPercentage2).div(100);
313         }
314         if (bonusStage3 != 0 && msg.value >= bonusStage3) {
315             scaledAmount = msg.value.mul(tokenPerEther).mul(uint256(10) ** tokenContract.decimals()).div(10 ** 18).mul(bonusPercentage3).div(100);
316         }
317         
318         require(tokenContract.balanceOf(address(this)) >= scaledAmount);
319         emit Sold(msg.sender, scaledAmount);
320         tokensSold = tokensSold.add(scaledAmount);
321         creator.transfer(address(this).balance);
322         require(tokenContract.transfer(msg.sender, scaledAmount));
323     }
324     
325     function () external payable {
326         buyTokenWithEther();
327     }
328 }
329 
330 contract ASNTokenGenerator is Ownable {
331       
332     IERC20Token public tokenContract;
333     IAssetSplitContracts public assetSplitContract;
334 
335     string public constant createdBy = "AssetSplit.org - the guys who cut the pizza";
336     
337     uint256 priceInEther = 1 ether;
338     uint256 priceInToken = 2;
339     
340     using SafeMath for uint256;
341     
342     constructor(address _tokenContract, address _AssetSplitContracts) public {
343         tokenContract = IERC20Token(_tokenContract);
344         assetSplitContract = IAssetSplitContracts(_AssetSplitContracts);
345     }
346     
347     function purchaseTokenContract(string memory _name, string memory _symbol, uint8 _decimals, uint256 _totalSupply) public payable returns (address) {
348         if (msg.value >= priceInEther) {
349             address c = newTokenContract(_name, _symbol, _decimals, _totalSupply);
350             _owner.transfer(address(this).balance);
351             return address(c);
352         } else {
353             require(tokenContract.balanceOf(msg.sender) >= priceInToken.mul(10 ** tokenContract.decimals()));
354             require(tokenContract.transferFrom(msg.sender, _owner, priceInToken.mul(10 ** tokenContract.decimals())));
355             address c = newTokenContract(_name, _symbol, _decimals, _totalSupply);
356             return address(c);
357         }
358     }
359     
360     function purchaseTokenSaleContract(address _tokenContractAddress, uint256 _tokenPerEther, uint256 _bonusStage1, uint _bonusPercentage1, uint256 _bonusStage2, uint _bonusPercentage2, uint256 _bonusStage3, uint _bonusPercentage3) public payable returns(address newContract) {
361         if (msg.value >= priceInEther) {
362             address c = newTokenSale(_tokenContractAddress, _tokenPerEther, _bonusStage1, _bonusPercentage1, _bonusStage2, _bonusPercentage2, _bonusStage3, _bonusPercentage3);
363             _owner.transfer(address(this).balance);
364             return address(c);
365         } else {
366             require(tokenContract.balanceOf(msg.sender) >= priceInToken.mul(10 ** tokenContract.decimals()));
367             require(tokenContract.transferFrom(msg.sender, _owner, priceInToken.mul(10 ** tokenContract.decimals())));
368             address c = newTokenSale(_tokenContractAddress, _tokenPerEther, _bonusStage1, _bonusPercentage1, _bonusStage2, _bonusPercentage2, _bonusStage3, _bonusPercentage3);
369             return address(c);
370         }
371         
372     }
373 
374     function newTokenContract(string memory _name, string memory _symbol, uint8 _decimals, uint256 _totalSupply) internal returns (address) {
375 		ERC20Token c = (new ERC20Token)(_name, _symbol, _decimals, _totalSupply);
376 	    assetSplitContract.addContract(address(c), msg.sender, 2);
377 		return address(c);
378 	}
379 	
380 	function newTokenSale(address _tokenContractAddress, uint256 _tokenPerEther, uint256 _bonusStage1, uint _bonusPercentage1, uint256 _bonusStage2, uint _bonusPercentage2, uint256 _bonusStage3, uint _bonusPercentage3) internal returns(address newContract) { 
381         TokenSale c = (new TokenSale)(_tokenContractAddress, _tokenPerEther, _bonusStage1, _bonusPercentage1, _bonusStage2, _bonusPercentage2, _bonusStage3, _bonusPercentage3);
382     	assetSplitContract.addContract(address(c), msg.sender, 3);
383         return address(c);
384     }
385     
386     function() external payable {
387         
388     } 
389 }