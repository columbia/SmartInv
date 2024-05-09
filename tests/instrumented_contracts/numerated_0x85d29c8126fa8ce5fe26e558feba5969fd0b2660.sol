1 pragma solidity ^0.4.18;
2 
3 
4 contract ERC20Basic {
5 }
6 
7 contract FreeItemFarm
8 {
9     ERC20Basic public object;
10     function buyObject(address _beneficiary) external payable;
11 }
12 
13 interface Item_token
14 {
15     function transfer(address to, uint256 value) external returns (bool);
16 }
17 
18 library SafeMath {
19 
20   /**
21   * @dev Multiplies two numbers, throws on overflow.
22   */
23   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24     if (a == 0) {
25       return 0;
26     }
27     uint256 c = a * b;
28     assert(c / a == b);
29     return c;
30   }
31 
32   /**
33   * @dev Adds two numbers, throws on overflow.
34   */
35   function add(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a + b;
37     assert(c >= a);
38     return c;
39   }
40 }
41 
42 contract Ownable {
43   address public owner;
44 
45 
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48 
49   /**
50    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51    * account.
52    */
53   function Ownable() public {
54     owner = msg.sender;
55   }
56 
57   /**
58    * @dev Throws if called by any account other than the owner.
59    */
60   modifier onlyOwner() {
61     require(msg.sender == owner);
62     _;
63   }
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address newOwner) public onlyOwner {
70     require(newOwner != address(0));
71     OwnershipTransferred(owner, newOwner);
72     owner = newOwner;
73   }
74 
75 }
76 
77 /*  In the event that the frontend goes down you will still be able to access the contract
78     through myetherwallet.  You go to myetherwallet, select the contract tab, then copy paste in the address
79     of the farming contract.  Then copy paste in the ABI and click access.  You will see the available functions 
80     in the drop down below.
81 
82     Quick instructions for each function. List of addresses for token and shops found here.  http://ethercraft.info/index.php/Addresses 
83 
84     farmItem:  shop_address is the address of the item shop you want to farm.  buy_amount is the amount you want to buy.
85     e.g. stone boots.  shop_address = 0xc5cE28De7675a3a4518F2F697249F1c90856d0F5, buy_amount = 100
86 
87     withdrawMultiTokens: takes in multiple token_addresses that you want to withdraw.  Token addresses can be found in the site above.
88     e.g. token_address1, token_address2, token_address3.
89 
90     If you want to view the balance of a token you have in the contract select tokenInventory in the dropdown on myetherwallet.
91     The first address box is the address you used to call the farm function from.
92     The second address box is the address of the token you want to check.
93     The result is the amount you have in the contract.*/   
94 
95 contract FlexiFarmv2 is Ownable {
96     using SafeMath for uint256;
97     
98     bool private reentrancy_lock = false;
99 
100     mapping(address => mapping(address => uint256)) public tokenInventory;
101     mapping(address => address) public shops;
102 
103     uint256 public total_buy;
104     uint256 public gas_amount;
105       
106     modifier nonReentrant() {
107         require(!reentrancy_lock);
108         reentrancy_lock = true;
109         _;
110         reentrancy_lock = false;
111     }
112 
113    
114     function set_Gas(uint256 gas_val) onlyOwner external{
115       gas_amount = gas_val;
116     }
117 
118     
119     function set_Total(uint256 buy_val) onlyOwner external{
120       total_buy = buy_val;
121     }
122 
123     //associating each shop with a token to prevent anyone gaming the system.  users can view these themselves to ensure the shops match the tokens
124     //if they want.  
125     function set_Shops(address[] shop_addresses, address[] token_addresses) onlyOwner nonReentrant external
126     {
127       require (shop_addresses.length == token_addresses.length);       
128 
129       for(uint256 i = 0; i < shop_addresses.length; i++){        
130           shops[shop_addresses[i]] = token_addresses[i];              
131       } 
132     }
133 
134     //populates contract with 1 of each farmable token to deal with storage creation gas cost
135 
136     function initialBuy(address[] shop_addresses) onlyOwner nonReentrant external
137     {
138       require (shop_addresses.length <= 15);       
139 
140       for(uint256 i = 0; i < shop_addresses.length; i++){        
141           FreeItemFarm(shop_addresses[i]).buyObject(this);              
142       } 
143     }
144 
145     function farmItems(address[] shop_addresses, uint256[] buy_amounts) nonReentrant external
146     {
147       require(shop_addresses.length == buy_amounts.length);
148       uint256 totals;
149       for (uint256 j = 0; j < buy_amounts.length; j++){  
150         totals+=buy_amounts[j];
151         assert(totals >= buy_amounts[j]);
152       }
153       require(totals <= total_buy);     
154       
155       for (uint256 i = 0; i < buy_amounts.length; i++){
156         farmSingle(shop_addresses[i], buy_amounts[i]);
157       }
158     }
159 
160     function farmSingle(address shop_address, uint256 buy_amount) private
161     {   
162       address token_address = shops[shop_address];
163                                
164       for (uint256 i = 0; i < buy_amount; i++) {
165             require(shop_address.call.gas(26290).value(0)() == true);
166       }
167       tokenInventory[msg.sender][token_address] = tokenInventory[msg.sender][token_address].add(buy_amount);   
168     } 
169 
170     function withdrawTokens(address[] token_addresses) nonReentrant external{
171       for(uint256 i = 0; i < token_addresses.length; i++){
172         withdrawToken(token_addresses[i]);
173       }
174     }
175 
176     function withdrawToken(address token_address) private {
177         require(tokenInventory[msg.sender][token_address] > 0);
178         uint256 tokenbal = tokenInventory[msg.sender][token_address].mul(1 ether);
179         tokenInventory[msg.sender][token_address] = 0;
180         Item_token(token_address).transfer(msg.sender, tokenbal);        
181     }  
182 
183     //just in case the amount of gas per item exceeds 26290.
184     function backupfarmItems(address[] shop_addresses, uint256[] buy_amounts) nonReentrant external
185     {
186       require(shop_addresses.length == buy_amounts.length);
187       uint256 totals;
188       for (uint256 j = 0; j < buy_amounts.length; j++){  
189         totals=buy_amounts[j];
190         assert(totals >= buy_amounts[j]);
191       }
192       require(totals <= total_buy);     
193       
194       for (uint256 i = 0; i < buy_amounts.length; i++){
195         backupfarmSingle(shop_addresses[i], buy_amounts[i]);
196       }
197     }        
198    
199     function backupfarmSingle(address shop_address, uint256 buy_amount) private
200     { 
201       address token_address = shops[shop_address]; 
202       for (uint256 i = 0; i < buy_amount; i++) {
203             require(shop_address.call.gas(gas_amount).value(0)() == true);
204       }
205       tokenInventory[msg.sender][token_address] = tokenInventory[msg.sender][token_address].add(buy_amount); 
206     } 
207 }