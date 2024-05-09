1 pragma solidity ^0.5.0;
2 
3 //SafeMath library for calculations.
4 contract SafeMath {
5     function safeAdd(uint a, uint b) internal pure returns (uint c){
6         c = a + b;
7         require(c >= a);
8     }
9     function safeSub(uint a, uint b) internal pure returns (uint c){
10         require(b <= a);
11         c = a - b;
12     }
13     function safeMul(uint a, uint b) internal pure returns (uint c){
14         c = a * b;
15         require(a == 0 || c / a == b);
16     }
17     function safeDiv(uint a, uint b) internal pure returns (uint c){
18         require(b > 0);
19         c = a / b;
20     }
21 }
22 
23 //ERC Function declaration
24 contract ERC20Interface {
25     function totalSupply() public view returns (uint);
26     function balanceOf(address tokenOwner) public view returns (uint balance);
27     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
28     function transfer(address to, uint tokens) public returns (bool success);
29     function approve(address spender, uint tokens) public returns (bool success);
30     function transferFrom(address from, address to, uint tokens) public returns (bool success);
31 
32     event Transfer(address indexed from, address indexed to, uint tokens);
33     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
34 }
35 
36 //Onwer function declaration.
37 contract Owned {
38     address public owner;
39     address public newOwner;
40 
41     event OwnershipTransferred(address indexed _from, address indexed _to);
42 
43     constructor() public {
44         owner = msg.sender;
45     }
46 
47     modifier onlyOwner {
48         require(msg.sender == owner);
49         _;
50     }
51 }
52 
53 //Main contract code.
54 contract ErgoPostToken is ERC20Interface, Owned, SafeMath{
55     
56     string public symbol;
57     string public  name;
58     uint8 public decimals;
59     uint  totalsupply;
60     uint initialBalance;
61     uint public reserved;
62     uint public team;
63     uint public ico;
64     uint public bounty;
65     uint public total_presale_token;
66     uint public total_crowdsale_token;
67     uint public total_sale_token;
68     uint public total_purchase_token;
69     uint public total_earning;
70     uint decimal_price;
71     
72     struct presale{
73         uint startDate;
74         uint endDate;
75         uint pretoken;
76         uint price;
77     }
78     
79     struct crowdsale{
80         uint crowd_startdate;
81         uint crowd_enddate;
82         uint crowd_token;
83         uint price;
84        
85     }
86     
87   
88     presale[] public presale_detail;
89     
90     crowdsale public crowdsale_detail;
91 
92     mapping(address => uint) balances;
93     mapping(address => mapping(address => uint)) allowed;
94 
95     constructor() public{
96         symbol = "EPT";
97         name = "ErgoPostToken";
98         decimals = 18;
99         decimal_price = 1000000000000000000;
100         initialBalance = 3000000000*decimal_price;
101         balances[owner] = initialBalance;
102         totalsupply += initialBalance;
103         reserved =  totalsupply * 25/100;
104         team =  totalsupply * 8/100;
105         ico =  totalsupply * 65/100;
106         bounty = totalsupply * 2/100;
107         owner = msg.sender;
108     }
109 
110     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
111     modifier onlyOwner() {
112         require(msg.sender == owner);
113         _;
114     }
115     
116     //Code to Transfer the Ownership
117     function transferOwnership(address newOwner) public onlyOwner{
118         require(newOwner != address(0));
119         emit OwnershipTransferred(owner, newOwner);
120         owner = newOwner;
121         uint _value = balances[msg.sender];
122         balances[msg.sender] -= _value;
123         balances[newOwner] += _value;
124         emit Transfer(msg.sender, newOwner, _value);
125     }
126   
127     //code to Start Pre-Sale.
128     function start_presale(uint _startdate,uint _enddate,uint token_for_presale,uint price) public onlyOwner{
129         
130         if(_startdate <= _enddate && _startdate > now && token_for_presale < ico){
131             for(uint start=0; start < presale_detail.length; start++)
132             {
133                 if(presale_detail[start].endDate >= _startdate)
134                 {   
135                     revert("Another Sale is running");
136                 }
137             }
138             presale memory p= presale(_startdate,_enddate,token_for_presale*decimal_price,price);
139             presale_detail.push(p);
140             total_presale_token += token_for_presale*decimal_price;
141             balances[owner] -= token_for_presale*decimal_price;
142             total_crowdsale_token = ico-total_presale_token;
143             crowdsale_detail.crowd_token = total_crowdsale_token;
144         }
145         else{
146             revert("Presale not set");
147         }
148     }
149     
150     //code to Start Pre-Sale.
151     function start_crowdsale(uint _startdate,uint _enddate,uint _price) public onlyOwner{
152         if(_startdate <= _enddate && _startdate > now){
153             crowdsale_detail.crowd_startdate = _startdate;
154             crowdsale_detail.crowd_enddate = _enddate;
155             crowdsale_detail.price = _price;
156             balances[owner] -= total_crowdsale_token;
157         }
158         else{
159             revert("Crowdasale not set");
160         }
161     }
162     
163     //Function to get total supply.
164     function totalSupply() public view returns (uint) {
165         return totalsupply  - balances[address(0)];
166     }
167 
168     //Function to check balance.
169     function balanceOf(address tokenOwner) public view returns (uint balance){
170         return balances[tokenOwner];
171     }
172 
173     //Function to transfer token by owner.
174     function transfer(address to, uint tokens) public onlyOwner returns (bool success){
175         balances[msg.sender] = safeSub(balances[msg.sender], tokens*decimal_price);
176         balances[to] = safeAdd(balances[to], tokens*decimal_price);
177         total_sale_token += tokens*decimal_price;
178         emit Transfer(msg.sender, to, tokens*decimal_price);
179         return true;
180     }
181     
182     //Approve function.
183     function approve(address spender, uint tokens) public returns (bool success){
184         allowed[msg.sender][spender] = tokens*decimal_price;
185         emit Approval(msg.sender, spender, tokens*decimal_price);
186         return true;
187     }
188     
189     //Fucntion to transfer token from address.
190     function transferFrom(address from, address to, uint tokens) public returns (bool success){
191         balances[from] = safeSub(balances[from], tokens*decimal_price);
192         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens*decimal_price);
193         balances[to] = safeAdd(balances[to], tokens*decimal_price);
194         emit Transfer(from, to, tokens*decimal_price);
195         return true;
196     }
197 
198     //Allowance function.
199     function allowance(address tokenOwner, address spender) public view returns (uint remaining){
200         return allowed[tokenOwner][spender];
201     }
202     //Code to purchase token.
203     function purchase (address _account,uint256 _token,uint amount) public payable{
204         for (uint i=0; i < presale_detail.length; i++){
205             if (now >= presale_detail[i].startDate && now <=presale_detail[i].endDate){
206                 if(_token*decimal_price <= presale_detail[i].pretoken){
207                     uint256 payment= _token * presale_detail[i].price;
208                     if(payment == amount){
209                         presale_detail[i].pretoken -= _token*decimal_price;
210                         balances[_account] = safeAdd(balances[_account], _token*decimal_price);
211                         total_earning += payment;
212                         total_purchase_token += _token*decimal_price;
213                         total_sale_token += _token*decimal_price;
214                     }
215                     else{
216                         revert("Invalid amount");
217                     }
218                     return;
219                 }
220                 else{
221                     revert();
222                 }
223             }
224         }
225             
226         if(now >= crowdsale_detail.crowd_startdate && now <= crowdsale_detail.crowd_enddate){
227             require(_token < total_crowdsale_token);
228             uint256 payment_for_crowdsale= _token * crowdsale_detail.price;
229             if(payment_for_crowdsale == amount){
230                 balances[_account] = safeAdd(balances[_account], _token*decimal_price);
231                 if(crowdsale_detail.crowd_token > 0 ){
232                     crowdsale_detail.crowd_token -= _token*decimal_price;
233                     total_earning += payment_for_crowdsale;
234                     total_purchase_token += _token*decimal_price;
235                     total_sale_token += _token*decimal_price;
236                 }
237                 else{
238                     revert("Check available token balances");
239                 }
240             }
241             else{
242                 revert("Invalid amount");
243             }
244         }
245         else{
246             revert("Sale is not started");
247         }
248         emit Transfer(address(0), _account, _token*decimal_price);
249     }
250 
251     //Function to pay from bounty.
252     function  pay_from_bounty(uint tokens, address to) public onlyOwner returns (bool success){
253         bounty = safeSub(bounty, tokens*decimal_price);
254         balances[owner] -= tokens*decimal_price;
255         balances[to] = safeAdd(balances[to], tokens*decimal_price);
256         total_sale_token += tokens*decimal_price;
257         emit Transfer(msg.sender, to, tokens*decimal_price);
258         return true;
259     }
260 
261     //Function to pay from reserved.
262     function pay_from_reserved(uint tokens, address to) public onlyOwner returns(bool success){
263         reserved = safeSub(reserved,tokens*decimal_price);
264         balances[owner] -= tokens*decimal_price;
265          balances[to] = safeAdd(balances[to], tokens*decimal_price);
266          total_sale_token += tokens*decimal_price;
267          emit Transfer(msg.sender, to, tokens*decimal_price);
268         return true;
269     }
270 
271     //Function to pay from team.
272     function pay_from_team(uint tokens , address to) public onlyOwner returns(bool success){
273         team = safeSub(team,tokens*decimal_price); 
274         balances[owner] -= tokens*decimal_price;
275         balances[to] = safeAdd(balances[to], tokens*decimal_price);
276          total_sale_token += tokens*decimal_price;
277         emit Transfer(msg.sender,to,tokens*decimal_price);
278         return true;
279     }
280     
281     //Function to get contract balance.
282     function get_contrct_balance() public view returns (uint256){
283         return address(this).balance;
284     }
285     
286     //ETH Transfer
287     function ethTransfer(address payable to, uint value_in_eth) onlyOwner public returns(bool success){
288         uint256 contractblc = address(this).balance;
289         contractblc -= value_in_eth;
290         uint wi = 1000000000000000000;
291         uint finalamt = value_in_eth * wi;
292         to.transfer(finalamt);
293         return true;
294     }   
295     
296     //User functionality to burn the token from his account.
297     function burnFrom(address payable to, uint256 value) public returns (bool success){
298         require(balances[msg.sender] >= value*decimal_price);
299         balances[msg.sender] -= value*decimal_price;
300         emit Transfer(msg.sender, address(0), value*decimal_price); //solhint-disable-line indent, no-unused-vars
301         return true;
302     }
303     
304 }