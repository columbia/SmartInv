1 pragma solidity 0.4.25;
2 
3  
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11  function div(uint256 a, uint256 b) internal pure returns (uint256) {
12     assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint256 c = a / b;
14     assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29  
30 contract Ownable {
31   address public owner;
32 
33 
34   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36 
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    * account.
40    */
41    constructor() public {
42     owner = msg.sender;
43   }
44 
45 
46   /**
47    * @dev Throws if called by any account other than the owner.
48    */
49   modifier onlyOwner() {
50     require(msg.sender == owner);
51     _;
52   }
53 
54 
55   /**
56    * @dev Allows the current owner to transfer control of the contract to a newOwner.
57    * @param newOwner The address to transfer ownership to.
58    */
59   function transferOwnership(address newOwner) onlyOwner public {
60     require(newOwner != address(0));
61     emit OwnershipTransferred(owner, newOwner);
62     owner = newOwner;
63   }
64 
65 }
66 
67 contract ERC20Interface {
68      function totalSupply() public constant returns (uint);
69      function balanceOf(address tokenOwner) public constant returns (uint balance);
70      function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
71      function transfer(address to, uint tokens) public returns (bool success);
72      function approve(address spender, uint tokens) public returns (bool success);
73      function transferFrom(address from, address to, uint tokens) public returns (bool success);
74      event Transfer(address indexed from, address indexed to, uint tokens);
75      event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
76 }
77 
78 contract Buyers{
79    
80     struct Buyer{
81         
82         string   name;  
83         string   country;
84         string   city; 
85         string   b_address;
86         string   mobile;  
87     }
88     mapping(address=>Buyer) public registerbuyer;
89     event BuyerAdded(address  from, string name,string country,string city,string b_address,string mobile);
90     
91     
92       
93     function registerBuyer(string _name,string _country,string _city,string _address,string _mobile) public returns(bool){
94       
95          require(bytes(_name).length!=0 &&
96              bytes(_country).length!=0 &&
97              bytes(_city).length!=0 &&
98              bytes(_address).length!=0 &&
99              bytes(_mobile).length!=0  
100              
101         );
102         registerbuyer[msg.sender]=Buyer(_name,_country,_city,_address,_mobile);
103         emit BuyerAdded(msg.sender,_name,_country,_city,_address,_mobile);
104         return true;
105         
106     }
107    
108     function getBuyer() public constant returns(string name,string country, string city,string _address,string mobile ){
109         return (registerbuyer[msg.sender].name,registerbuyer[msg.sender].country,registerbuyer[msg.sender].city,registerbuyer[msg.sender].b_address,registerbuyer[msg.sender].mobile);
110     }
111     
112     function getBuyerbyaddress(address _useraddress) public constant returns(string name,string country, string city,string _address,string mobile ){
113         return (registerbuyer[_useraddress].name,registerbuyer[_useraddress].country,registerbuyer[_useraddress].city,registerbuyer[_useraddress].b_address,registerbuyer[_useraddress].mobile);
114     }
115     
116 }
117 
118 contract ProductsInterface {
119      
120     struct Product { // Struct
121         uint256  id;
122         string   name;  
123         string   image;
124         uint256  price;
125         string   detail;
126         address  _seller;
127          
128     }
129     event ProductAdded(uint256 indexed id,address seller, string  name,string  image, uint256  price,string  detail );
130    
131    
132     function addproduct(string _name,string _image,uint256 _price,string _detail)   public   returns (bool success);
133     function updateprice(uint _index, uint _price) public returns (bool success);
134   
135    function getproduuct(uint _index) public constant returns(uint256 id,string name,string image,uint256  price,string detail, address _seller);
136    function getproductprices() public constant returns(uint256[]);
137    
138 }
139 
140 contract OrderInterface{
141     struct Order { // Struct
142         uint256  id;
143         uint256   quantity;  
144         uint256   product_index;  
145         uint256  price;
146        
147         address  buyer;
148         address  seller;
149         uint256 status;
150          
151     }
152     uint256 public order_counter;
153     mapping (uint => Order) public orders;
154      
155     function placeorder(  uint256   quantity,uint256   product_index)  public returns(uint256);
156     event OrderPlace(uint256 indexed id, uint256   quantity,uint256   product_index,string   name,address  buyer, address  seller );
157    
158 }
159 
160 contract FeedToken is  ProductsInterface,OrderInterface, ERC20Interface,Ownable,Buyers {
161 
162    using SafeMath for uint256;
163    //------------------------------------------------------------------------
164     uint256 public counter=0;
165     mapping (uint => Product) public seller_products;
166     mapping (uint => uint) public products_price;
167     mapping (address=> uint) public seller_total_products;
168    //------------------------------------------------------------------------
169    string public name;
170    string public symbol;
171    uint256 public decimals;
172 
173    uint256 public _totalSupply;
174    uint256 order_counter=0;
175    mapping(address => uint256) tokenBalances;
176    address ownerWallet;
177    // Owner of account approves the transfer of an amount to another account
178    mapping (address => mapping (address => uint256)) allowed;
179    
180    /**
181    * @dev Contructor that gives msg.sender all of existing tokens.
182    */
183     constructor(address wallet) public {
184         owner = wallet;
185         name  = "Feed";
186         symbol = "FEED";
187         decimals = 18;
188         _totalSupply = 1000000000 * 10 ** uint(decimals);
189         tokenBalances[ msg.sender] = _totalSupply;   //Since we divided the token into 10^18 parts
190     }
191     
192      // Get the token balance for account `tokenOwner`
193      function balanceOf(address tokenOwner) public constant returns (uint balance) {
194          return tokenBalances[tokenOwner];
195      }
196   
197      // Transfer the balance from owner's account to another account
198      function transfer(address to, uint tokens) public returns (bool success) {
199          require(to != address(0));
200          require(tokens <= tokenBalances[msg.sender]);
201          //checkTokenVesting(msg.sender, tokens);
202          tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(tokens);
203          tokenBalances[to] = tokenBalances[to].add(tokens);
204          emit Transfer(msg.sender, to, tokens);
205          return true;
206      }
207      function checkUser() public constant returns(string ){
208          require(bytes(registerbuyer[msg.sender].name).length!=0);
209           
210              return "Register User";
211      }
212      
213   /**
214    * @dev Transfer tokens from one address to another
215    * @param _from address The address which you want to send tokens from
216    * @param _to address The address which you want to transfer to
217    * @param _value uint256 the amount of tokens to be transferred
218    */
219    
220   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
221     require(_to != address(0));
222     require(_value <= tokenBalances[_from]);
223     require(_value <= allowed[_from][msg.sender]);
224     //checkTokenVesting(_from,_value);
225     tokenBalances[_from] = tokenBalances[_from].sub(_value);
226     tokenBalances[_to] = tokenBalances[_to].add(_value);
227     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
228     emit Transfer(_from, _to, _value);
229     return true;
230   }
231   
232   /**
233    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
234    *
235    * @param _spender The address which will spend the funds.
236    * @param _value The amount of tokens to be spent.
237    */
238   function approve(address _spender, uint256 _value) public returns (bool) {
239     allowed[msg.sender][_spender] = _value;
240     emit Approval(msg.sender, _spender, _value);
241     return true;
242   }
243 
244      // ------------------------------------------------------------------------
245      // Total supply
246      // ------------------------------------------------------------------------
247      function totalSupply() public constant returns (uint) {
248          return _totalSupply  - tokenBalances[address(0)];
249      }
250      
251     
252      
253      // ------------------------------------------------------------------------
254      // Returns the amount of tokens approved by the owner that can be
255      // transferred to the spender's account
256      // ------------------------------------------------------------------------
257      function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
258          return allowed[tokenOwner][spender];
259      }
260      
261      /**
262    * @dev Increase the amount of tokens that an owner allowed to a spender.
263    *
264    * @param _spender The address which will spend the funds.
265    * @param _addedValue The amount of tokens to increase the allowance by.
266    */
267   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
268     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
269     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270     return true;
271   }
272 
273   /**
274    * @dev Decrease the amount of tokens that an owner allowed to a spender.
275    *
276    * @param _spender The address which will spend the funds.
277    * @param _subtractedValue The amount of tokens to decrease the allowance by.
278    */
279   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
280     uint oldValue = allowed[msg.sender][_spender];
281     if (_subtractedValue > oldValue) {
282       allowed[msg.sender][_spender] = 0;
283     } else {
284       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
285     }
286     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
287     return true;
288   }
289 
290      
291      // ------------------------------------------------------------------------
292      // Don't accept ETH
293      // ------------------------------------------------------------------------
294      function () public payable {
295          revert();
296      }
297  
298  
299      // ------------------------------------------------------------------------
300      // Owner can transfer out any accidentally sent ERC20 tokens
301      // ------------------------------------------------------------------------
302      function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
303          return ERC20Interface(tokenAddress).transfer(owner, tokens);
304      }
305      
306     
307      function placeorder( uint256   quantity,uint256   product_index)  public  returns(uint256) {
308          
309         require(counter>=product_index && product_index>0);
310         require(bytes(registerbuyer[msg.sender].name).length!=0);//to place order you first register yourself
311          
312         transfer(seller_products[product_index]._seller,seller_products[product_index].price*quantity);
313         orders[order_counter] = Order(order_counter,quantity,product_index,seller_products[product_index].price, msg.sender,seller_products[product_index]._seller,0);
314         
315         emit OrderPlace(order_counter,quantity, product_index,  seller_products[product_index].name, msg.sender, seller_products[product_index]._seller );
316         order_counter++;
317         return counter;
318     }
319     
320     //------------------------------------------------------------------------
321     // product methods
322     //------------------------------------------------------------------------
323    
324    
325     function addproduct(string _name,string _image,uint256 _price,string _detail)   public   returns (bool success){
326           require(bytes(_name).length!=0 &&
327              bytes(_image).length!=0 &&
328              bytes(_detail).length!=0 
329             
330              
331         );
332         counter++;
333         seller_products[counter] = Product(counter,_name,_image, _price,_detail,msg.sender);
334         products_price[counter]=_price;
335         emit ProductAdded(counter,msg.sender,_name,_image,_price,_detail);
336         return true;
337    }
338   
339    function updateprice(uint _index, uint _price) public returns (bool success){
340       require(seller_products[_index]._seller==msg.sender);
341        
342      
343       seller_products[_index].price=_price;
344       products_price[_index]=_price;
345       return true;
346   }
347   
348    function getproduuct(uint _index) public constant returns(uint256 ,string ,string ,uint256  ,string , address )
349    {
350        return(seller_products[_index].id,seller_products[_index].name,seller_products[_index].image,products_price[_index],seller_products[_index].detail,seller_products[_index]._seller);
351    }
352    
353    function getproductprices() public constant returns(uint256[])
354    {
355        uint256[] memory price = new uint256[](counter);
356         
357         for (uint i = 0; i <counter; i++) {
358            
359             price[i]=products_price[i+1];
360              
361         }
362       return price;
363    }
364 }