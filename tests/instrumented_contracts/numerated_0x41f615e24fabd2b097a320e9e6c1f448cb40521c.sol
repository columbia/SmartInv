1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title Crowdsale
6  * @dev Crowdsale is a base contract for managing a token crowdsale.
7  * Crowdsales have a start and end timestamps, where investors can make
8  * token purchases and the crowdsale will assign them tokens based
9  * on a token per ETH rate. Funds collected are forwarded to a wallet
10  * as they arrive.
11  */
12  
13  
14 library SafeMath {
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     uint256 c = a * b;
17     assert(a == 0 || c / a == b);
18     return c;
19   }
20 
21  function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b > 0); // Solidity automatically throws when dividing by 0
23     uint256 c = a / b;
24     assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return c;
26   }
27 
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint256 a, uint256 b) internal pure returns (uint256) {
34     uint256 c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39  
40 contract Ownable {
41   address public owner;
42 
43 
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51    constructor() public {
52     owner = msg.sender;
53   }
54 
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address newOwner) onlyOwner public {
70     require(newOwner != address(0));
71     emit OwnershipTransferred(owner, newOwner);
72     owner = newOwner;
73   }
74 
75 }
76 
77 contract ERC20Interface {
78      function totalSupply() public constant returns (uint);
79      function balanceOf(address tokenOwner) public constant returns (uint balance);
80      function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
81      function transfer(address to, uint tokens) public returns (bool success);
82      function approve(address spender, uint tokens) public returns (bool success);
83      function transferFrom(address from, address to, uint tokens) public returns (bool success);
84      event Transfer(address indexed from, address indexed to, uint tokens);
85      event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
86 }
87 
88 contract Buyers{
89    
90     struct Buyer{
91         
92         string   name;  
93         string   country;
94         string   city; 
95         string   b_address;
96         string   mobile;  
97     }
98     mapping(address=>Buyer) public registerbuyer;
99     event BuyerAdded(address  from, string name,string country,string city,string b_address,string mobile);
100     
101     
102       
103     function registerBuyer(string _name,string _country,string _city,string _address,string _mobile) public returns(bool){
104       
105          require(bytes(_name).length!=0 &&
106              bytes(_country).length!=0 &&
107              bytes(_city).length!=0 &&
108              bytes(_address).length!=0 &&
109              bytes(_mobile).length!=0  
110              
111         );
112         registerbuyer[msg.sender]=Buyer(_name,_country,_city,_address,_mobile);
113         emit BuyerAdded(msg.sender,_name,_country,_city,_address,_mobile);
114         return true;
115         
116     }
117    
118     function getBuyer() public constant returns(string name,string country, string city,string _address,string mobile ){
119         return (registerbuyer[msg.sender].name,registerbuyer[msg.sender].country,registerbuyer[msg.sender].city,registerbuyer[msg.sender].b_address,registerbuyer[msg.sender].mobile);
120     }
121     
122     function getBuyerbyaddress(address _useraddress) public constant returns(string name,string country, string city,string _address,string mobile ){
123         return (registerbuyer[_useraddress].name,registerbuyer[_useraddress].country,registerbuyer[_useraddress].city,registerbuyer[_useraddress].b_address,registerbuyer[_useraddress].mobile);
124     }
125     
126 }
127 
128 contract ProductsInterface {
129      
130     struct Product { // Struct
131         uint256  id;
132         string   name;  
133         string   image;
134         uint256  price;
135         string   detail;
136         address  _seller;
137          
138     }
139     event ProductAdded(uint256 indexed id,address seller, string  name,string  image, uint256  price,string  detail );
140    
141    
142     function addproduct(string _name,string _image,uint256 _price,string _detail)   public   returns (bool success);
143     function updateprice(uint _index, uint _price) public returns (bool success);
144   
145    function getproduuct(uint _index) public constant returns(uint256 id,string name,string image,uint256  price,string detail, address _seller);
146    function getproductprices() public constant returns(uint256[]);
147    
148 }
149 
150 contract OrderInterface{
151     struct Order { // Struct
152         uint256  id;
153         uint256   quantity;  
154         uint256   product_index;  
155         uint256  price;
156        
157         address  buyer;
158         address  seller;
159         uint256 status;
160          
161     }
162     uint256 public order_counter;
163     mapping (uint => Order) public orders;
164      
165     function placeorder(  uint256   quantity,uint256   product_index)  public returns(uint256);
166     event OrderPlace(uint256 indexed id, uint256   quantity,uint256   product_index,string   name,address  buyer, address  seller );
167    
168 }
169 
170 contract FeedToken is  ProductsInterface,OrderInterface, ERC20Interface,Ownable,Buyers {
171 
172 
173 
174    using SafeMath for uint256;
175    //------------------------------------------------------------------------
176     uint256 public counter=0;
177     mapping (uint => Product) public seller_products;
178     mapping (uint => uint) public products_price;
179     mapping (address=> uint) public seller_total_products;
180    //------------------------------------------------------------------------
181    string public name;
182    string public symbol;
183    uint256 public decimals;
184 
185    uint256 public _totalSupply;
186    uint256 order_counter=0;
187    mapping(address => uint256) tokenBalances;
188    address ownerWallet;
189    // Owner of account approves the transfer of an amount to another account
190    mapping (address => mapping (address => uint256)) allowed;
191    
192    mapping (address=>uint) privateSaleBuyerTokens;
193    address[] privateSaleBuyers;
194    
195    mapping (address=>uint) preSaleBuyerTokens;
196    address[] preSaleBuyers;
197    
198    mapping(address=>uint) teamMembers;
199    
200    uint privateSaleEndDate;
201    uint preSaleEndDate;
202    uint icoEndDate;
203    /**
204    * @dev Contructor that gives msg.sender all of existing tokens.
205    */
206     constructor(address wallet) public {
207         owner = wallet;
208         name  = "Feed";
209         symbol = "FEED";
210         decimals = 18;
211         _totalSupply = 1000000000 * 10 ** uint(decimals);
212         tokenBalances[ msg.sender] = _totalSupply;   //Since we divided the token into 10^18 parts
213     }
214     
215      // Get the token balance for account `tokenOwner`
216      function balanceOf(address tokenOwner) public constant returns (uint balance) {
217          return tokenBalances[tokenOwner];
218      }
219   
220      // Transfer the balance from owner's account to another account
221      function transfer(address to, uint tokens) public returns (bool success) {
222          require(to != address(0));
223          require(tokens <= tokenBalances[msg.sender]);
224          checkTokenVesting(msg.sender, tokens);
225          tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(tokens);
226          tokenBalances[to] = tokenBalances[to].add(tokens);
227          emit Transfer(msg.sender, to, tokens);
228          return true;
229      }
230      function checkUser() public constant returns(string ){
231          require(bytes(registerbuyer[msg.sender].name).length!=0);
232           
233              return "Register User";
234      }
235      
236      function checkTokenVesting(address sender, uint tokens) internal {
237          uint lockupTime;
238          uint daysPassedSinceEndDate;
239          uint lockedTokens;
240          if (preSaleBuyerTokens[sender] > 0 || privateSaleBuyerTokens[sender]>0 || teamMembers[sender]>0)
241          {
242              if (teamMembers[sender]>0)
243              {
244                 lockupTime = uint(24).mul(uint(30)).mul(1 days);
245                 if (now<icoEndDate.add(lockupTime))
246                 {
247                     lockedTokens = teamMembers[sender];
248                     if (lockedTokens.add(tokens)>tokenBalances[sender])
249                         revert();
250                 }   
251              }
252              else if (privateSaleBuyerTokens[sender]>0)
253              {
254                 lockupTime = uint(12).mul(uint(30)).mul(1 days);
255                 uint daysPassedSincePrivateSaleEnd = now.sub(privateSaleEndDate);
256                 daysPassedSincePrivateSaleEnd = daysPassedSincePrivateSaleEnd.div(1 days);
257                 uint monthsPassedSinceICOEnd = daysPassedSincePrivateSaleEnd.div(30);
258                 uint unlockedTokens = privateSaleBuyerTokens[sender].div(12).mul(monthsPassedSinceICOEnd);
259                 lockedTokens = privateSaleBuyerTokens[sender].sub(unlockedTokens);
260                 if (lockedTokens.add(tokens)>tokenBalances[sender])
261                     revert();
262                 
263              }
264              else if (preSaleBuyerTokens[sender]>0)
265              {
266                lockupTime = uint(3).mul(uint(30)).mul(1 days);
267                if (now<preSaleEndDate.add(lockupTime))
268                 {
269                     lockedTokens = preSaleBuyerTokens[sender];
270                     if (lockedTokens.add(tokens)>tokenBalances[sender])
271                         revert();
272                 }   
273              }
274          }
275      }
276      /**
277    * @dev Transfer tokens from one address to another
278    * @param _from address The address which you want to send tokens from
279    * @param _to address The address which you want to transfer to
280    * @param _value uint256 the amount of tokens to be transferred
281    */
282    
283   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
284     require(_to != address(0));
285     require(_value <= tokenBalances[_from]);
286     require(_value <= allowed[_from][msg.sender]);
287     checkTokenVesting(_from,_value);
288     tokenBalances[_from] = tokenBalances[_from].sub(_value);
289     tokenBalances[_to] = tokenBalances[_to].add(_value);
290     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
291     emit Transfer(_from, _to, _value);
292     return true;
293   }
294   
295      /**
296    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
297    *
298    * @param _spender The address which will spend the funds.
299    * @param _value The amount of tokens to be spent.
300    */
301   function approve(address _spender, uint256 _value) public returns (bool) {
302     allowed[msg.sender][_spender] = _value;
303     emit Approval(msg.sender, _spender, _value);
304     return true;
305   }
306 
307      // ------------------------------------------------------------------------
308      // Total supply
309      // ------------------------------------------------------------------------
310      function totalSupply() public constant returns (uint) {
311          return _totalSupply  - tokenBalances[address(0)];
312      }
313      
314     
315      
316      // ------------------------------------------------------------------------
317      // Returns the amount of tokens approved by the owner that can be
318      // transferred to the spender's account
319      // ------------------------------------------------------------------------
320      function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
321          return allowed[tokenOwner][spender];
322      }
323      
324      /**
325    * @dev Increase the amount of tokens that an owner allowed to a spender.
326    *
327    * @param _spender The address which will spend the funds.
328    * @param _addedValue The amount of tokens to increase the allowance by.
329    */
330   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
331     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
332     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
333     return true;
334   }
335 
336   /**
337    * @dev Decrease the amount of tokens that an owner allowed to a spender.
338    *
339    * @param _spender The address which will spend the funds.
340    * @param _subtractedValue The amount of tokens to decrease the allowance by.
341    */
342   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
343     uint oldValue = allowed[msg.sender][_spender];
344     if (_subtractedValue > oldValue) {
345       allowed[msg.sender][_spender] = 0;
346     } else {
347       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
348     }
349     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
350     return true;
351   }
352 
353      
354      // ------------------------------------------------------------------------
355      // Don't accept ETH
356      // ------------------------------------------------------------------------
357      function () public payable {
358          revert();
359      }
360  
361  
362      // ------------------------------------------------------------------------
363      // Owner can transfer out any accidentally sent ERC20 tokens
364      // ------------------------------------------------------------------------
365      function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
366          return ERC20Interface(tokenAddress).transfer(owner, tokens);
367      }
368      
369     
370      function placeorder( uint256   quantity,uint256   product_index)  public  returns(uint256) {
371          
372         require(counter>=product_index && product_index>0);
373         require(bytes(registerbuyer[msg.sender].name).length!=0);//to place order you first register yourself
374          
375         transfer(seller_products[product_index]._seller,seller_products[product_index].price*quantity);
376         orders[order_counter] = Order(order_counter,quantity,product_index,seller_products[product_index].price, msg.sender,seller_products[product_index]._seller,0);
377         
378         emit OrderPlace(order_counter,quantity, product_index,  seller_products[product_index].name, msg.sender, seller_products[product_index]._seller );
379         order_counter++;
380         return counter;
381     }
382     
383     //------------------------------------------------------------------------
384     // product methods
385     //------------------------------------------------------------------------
386    
387    
388     function addproduct(string _name,string _image,uint256 _price,string _detail)   public   returns (bool success){
389           require(bytes(_name).length!=0 &&
390              bytes(_image).length!=0 &&
391              bytes(_detail).length!=0 
392             
393              
394         );
395         counter++;
396         seller_products[counter] = Product(counter,_name,_image, _price,_detail,msg.sender);
397         products_price[counter]=_price;
398         emit ProductAdded(counter,msg.sender,_name,_image,_price,_detail);
399         return true;
400    }
401   
402    function updateprice(uint _index, uint _price) public returns (bool success){
403       require(seller_products[_index]._seller==msg.sender);
404        
405      
406       seller_products[_index].price=_price;
407       products_price[_index]=_price;
408       return true;
409   }
410   
411    function getproduuct(uint _index) public constant returns(uint256 ,string ,string ,uint256  ,string , address )
412    {
413        return(seller_products[_index].id,seller_products[_index].name,seller_products[_index].image,products_price[_index],seller_products[_index].detail,seller_products[_index]._seller);
414    }
415    function getproductprices() public constant returns(uint256[])
416    {
417        uint256[] memory price = new uint256[](counter);
418         
419         for (uint i = 0; i <counter; i++) {
420            
421             price[i]=products_price[i+1];
422              
423         }
424       return price;
425    }
426     
427     //------------------------------------------------------------------------
428     //end Products
429     //------------------------------------------------------------------------
430     
431     function addPrivateSaleEndDate(uint256 endDate) public onlyOwner {
432         privateSaleEndDate = endDate;
433     }
434     
435     function addPreSaleEndDate(uint256 endDate) public onlyOwner {
436         preSaleEndDate = endDate;
437     }
438     
439     function addICOEndDate(uint256 endDate) public onlyOwner {
440         icoEndDate = endDate;
441     }
442     
443     function addTeamAndAdvisoryMembers(address[] members) public onlyOwner 
444     {
445         uint totalTeamShare = uint(100000000).mul(10**uint(decimals));
446         uint oneTeamMemberShare = totalTeamShare.div(members.length);
447         for (uint i=0;i<members.length;i++)
448         {
449             teamMembers[members[i]] = oneTeamMemberShare;
450             tokenBalances[owner] = tokenBalances[owner].sub(oneTeamMemberShare);
451             tokenBalances[members[i]] = tokenBalances[members[i]].add(oneTeamMemberShare);
452             emit Transfer(owner,members[i],oneTeamMemberShare);
453         }    
454     }
455     function addPrivateSaleBuyer(address buyer,uint value) public onlyOwner 
456     {
457         privateSaleBuyerTokens[buyer] = value;        
458     }
459     function addPreSaleBuyer(address buyer,uint value) public onlyOwner 
460     {
461         preSaleBuyerTokens[buyer] = value;
462     }
463 }