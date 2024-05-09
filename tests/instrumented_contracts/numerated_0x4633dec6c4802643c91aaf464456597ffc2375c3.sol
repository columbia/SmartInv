1 pragma solidity ^0.4.24; // 23 May 2018
2 
3 /*    Copyright © 2018  -  All Rights Reserved
4   High-Capacity IonChain Transactional System
5 */
6 
7 contract InCodeWeTrust {
8   modifier onlyPayloadSize(uint256 size) {
9     if(msg.data.length < size + 4) {
10        throw;
11      }
12      _;
13   }
14   uint256 public totalSupply;
15   uint256 public RealTotalSupply;
16   event Transfer(address indexed from, address indexed to, uint256 value);
17   function transfer_Different_amounts_of_assets_to_many (address[] _recipients, uint[] _amount_comma_space_amount) public payable;
18   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public payable;
19   function early_supporters_distribution (address[] address_to_comma_space_address_to_, uint256 _value) public payable;
20   function balanceOf(address _owner) constant public returns (uint256 balance);
21   function buy_fromContract() payable public returns (uint256 _amount_);                                    
22   function show_Balance_available_for_Sale_in_ETH_equivalent () constant public returns (uint256 you_can_buy_all_the_available_assets_with_this_amount_in_ETH);
23   function show_automated_Buy_price() constant public returns (uint256 assets_per_1_ETH);
24   
25 
26   function developer_edit_text_price (string edit_text_Price)   public;
27   function developer_edit_text_crowdsale (string string_crowdsale)   public;
28   function developer_edit_text_Exchanges_links (string update_links)   public;
29   function developer_string_contract_verified (string string_contract_verified) public;
30   function developer_update_Terms_of_service (string update_text_Terms_of_service)   public;
31   function developer_edit_name (string edit_text_name)   public;
32   function developer_How_To  (string edit_text_How_to)   public;
33   function totally_decrease_the_supply(uint256 amount_to_burn_from_supply) public payable;
34  }
35 
36 contract investor is InCodeWeTrust {
37   address internal owner; 
38 
39   mapping(address => uint256) balances;
40 }
41 /*  SafeMath - the lowest risk library
42   Math operations with safety checks
43  */
44 library SafeMath {
45   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
46     uint256 c = a * b;
47     assert(a == 0 || c / a == b);
48     return c;
49   }
50   function div(uint256 a, uint256 b) internal constant returns (uint256) {
51     uint256 c = a / b;
52     return c;
53   }
54   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58   function add(uint256 a, uint256 b) internal constant returns (uint256) {
59     uint256 c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 
66 contract Satoshi is investor {
67   using SafeMath for uint256;
68   uint256 totalFund = (10 ** 15)  - 2 * (10 ** 14); 
69   uint256 buyPrice = 5 * 10 ** 6;  
70  
71     /* Batch assets transfer. Used  to distribute  assets to holders */
72   function transfer_Different_amounts_of_assets_to_many (address[] _recipients, uint[] _amount_comma_space_amount) public payable {
73         require( _recipients.length > 0 && _recipients.length == _amount_comma_space_amount.length);
74 
75         uint256 total = 0;
76         for(uint i = 0; i < _amount_comma_space_amount.length; i++){
77             total = total.add(_amount_comma_space_amount[i]);
78         }
79         require(total <= balances[msg.sender]);
80 
81         for(uint j = 0; j < _recipients.length; j++){
82             balances[_recipients[j]] = balances[_recipients[j]].add(_amount_comma_space_amount[j]);
83             Transfer(msg.sender, _recipients[j], _amount_comma_space_amount[j]);
84         }
85         balances[msg.sender] = balances[msg.sender].sub(total);
86        
87   } 
88  
89   function early_supporters_distribution (address[] address_to_comma_space_address_to_, uint256 _value) public payable { 
90         require(_value <= balances[msg.sender]);
91         for (uint i = 0; i < address_to_comma_space_address_to_.length; i++){
92          if(balances[msg.sender] >= _value)  { 
93          balances[msg.sender] = balances[msg.sender].sub(_value);
94          balances[address_to_comma_space_address_to_[i]] = balances[address_to_comma_space_address_to_[i]].add(_value);
95            Transfer(msg.sender, address_to_comma_space_address_to_[i], _value);
96          }
97         }
98   }
99 }
100  
101 contract Inventor is Satoshi {
102  function Inventor() internal {
103     owner = msg.sender;
104  }
105  modifier onlyOwner() {
106     require(msg.sender == owner);
107     _;
108  }
109  function developer_Transfer_ownership(address newOwner) onlyOwner public {
110     require(newOwner != address(0));      
111     owner = newOwner;
112  }
113  function developer_increase_price (uint256 increase) onlyOwner public {
114    buyPrice = increase;
115  }
116 } 
117 
118 contract Transparent is Inventor {
119   
120     function show_automated_Buy_price() constant public returns (uint256 assets_per_1_ETH) {
121         assets_per_1_ETH = 1e12 / buyPrice;
122         return assets_per_1_ETH;
123     }   
124     
125     function balanceOf(address _owner) constant public returns (uint256 balance) {
126         return balances[_owner];
127     }
128 }
129 
130 contract TheSmartAsset is Transparent {
131   uint256 initialSupply;
132   uint burned;
133   function totally_decrease_the_supply(uint256 amount_to_burn_from_supply) public payable {
134         require(balances[msg.sender] >= amount_to_burn_from_supply);
135         balances[msg.sender] = balances[msg.sender].sub(amount_to_burn_from_supply);
136         burned = amount_to_burn_from_supply / 10 ** 6;
137         totalSupply = totalSupply.sub(amount_to_burn_from_supply);
138         RealTotalSupply = RealTotalSupply.sub(burned);
139   }
140 }
141 
142 contract ERC20 is TheSmartAsset {
143  string public name = "IonChain";
144  string public positive_terms_of_Service;
145  string public crowdsale;
146  string public alternative_Exchanges_links;
147  string public How_to_interact_with_Smartcontract;
148  string public Price;  
149  string public contract_verified;
150  uint public constant decimals = 6;
151  string public symbol = "IONC";
152   function ERC20 () {
153       balances[this] = 200 * (10 ** 6) * 10 ** decimals;  // this is the total initial assets sale limit
154       balances[owner] =  totalFund;  // total amount for all bounty programs
155       initialSupply =  balances[owner] / 10 ** decimals;
156       totalSupply  =  (balances[this]  + balances[owner]);
157       RealTotalSupply  =  (balances[this]  + balances[owner]) / 10 ** decimals;
158       Transfer(this, owner, totalFund);    
159   }
160   
161   //Show_Available_balance_for_Sale_in_ETH_equivalent
162   function show_Balance_available_for_Sale_in_ETH_equivalent () constant public returns (uint256 you_can_buy_all_the_available_assets_with_this_amount_in_ETH) {
163      you_can_buy_all_the_available_assets_with_this_amount_in_ETH =  buyPrice * balances[this] / 1e18;
164   }
165   
166 } 
167 
168 
169 contract Functions is ERC20 {
170  
171    function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public payable {
172         if (balances[msg.sender] < _value) {
173             _value = balances[msg.sender];
174         }
175         balances[msg.sender] = balances[msg.sender].sub(_value);
176         balances[_to] = balances[_to].add(_value);
177         Transfer(msg.sender, _to, _value);
178        
179   }
180  
181   function developer_string_symbol (string symbol_new)   public {
182     if (msg.sender == owner) symbol = symbol_new;
183   }
184   function developer_edit_text_price (string edit_text_Price)   public {
185     if (msg.sender == owner) Price = edit_text_Price;
186   }
187   
188   function developer_edit_text_crowdsale (string string_crowdsale)   public {
189     if (msg.sender == owner) crowdsale = string_crowdsale;
190   }
191   function developer_edit_text_Exchanges_links (string update_links)   public {
192     if (msg.sender == owner) alternative_Exchanges_links = update_links;
193   }
194   function developer_string_contract_verified (string string_contract_verified) public {
195     if (msg.sender == owner) contract_verified = string_contract_verified;
196   }
197   function developer_update_Terms_of_service (string update_text_Terms_of_service)   public {
198     if (msg.sender == owner) positive_terms_of_Service = update_text_Terms_of_service;
199   }
200   function developer_edit_name (string edit_text_name)   public {
201     if (msg.sender == owner) name = edit_text_name;
202   }
203   function developer_How_To  (string edit_text_How_to)   public {
204     if (msg.sender == owner) How_to_interact_with_Smartcontract = edit_text_How_to;
205   }
206  
207 
208  function () payable {
209     uint256 assets =  msg.value/(buyPrice);
210      if (assets > (balances[this])) {
211         assets = balances[this];
212         uint valueWei = assets * buyPrice ;
213         msg.sender.transfer(msg.value - valueWei);
214     }
215     require(msg.value >= (10 ** 17)); // min 0.1 ETH
216     balances[msg.sender] += assets;
217     balances[this] -= assets;
218     Transfer(this, msg.sender, assets);
219  }
220 }
221 
222 
223 contract Ion_Chain is Functions {
224 
225  function buy_fromContract() payable public returns (uint256 _amount_) {
226         require (msg.value >= 0);
227         _amount_ =  msg.value / buyPrice;                 // calculates the amount
228         if (_amount_ > balances[this]) {
229             _amount_ = balances[this];
230             uint256 valueWei = _amount_ * buyPrice;
231             msg.sender.transfer(msg.value - valueWei);
232         }
233         balances[msg.sender] += _amount_;                  // adds the amount to buyer's balance
234         balances[this] -= _amount_;                        // subtracts amount from seller's balance
235         Transfer(this, msg.sender, _amount_);              
236         
237         return _amount_;                                    
238  }
239 
240  
241  /* 
242   High-Capacity IonChain Transactional System
243 */
244 }
245 
246 contract IonChain is Ion_Chain {
247     function IonChain() payable ERC20() {}
248     function developer_withdraw_ETH() onlyOwner {
249         owner.transfer(this.balance);
250     }
251 
252 }