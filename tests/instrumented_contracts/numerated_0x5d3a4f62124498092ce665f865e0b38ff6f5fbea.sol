1 //SPDX-License-Identifier: UNLICENSE
2 pragma solidity 0.7.0;
3 
4 //SafeMath library for calculations.
5 contract SafeMath {
6     function safeAdd(uint a, uint b) internal pure returns (uint c){
7         c = a + b;
8         require(c >= a);
9     }
10     function safeSub(uint a, uint b) internal pure returns (uint c){
11         require(b <= a);
12         c = a - b;
13     }
14     function safeMul(uint a, uint b) internal pure returns (uint c){
15         c = a * b;
16         require(a == 0 || c / a == b);
17     }
18     function safeDiv(uint a, uint b) internal pure returns (uint c){
19         require(b > 0);
20         c = a / b;
21     }
22 }
23 
24 //ideaology main contract code.
25 contract ideaology is SafeMath{
26     
27     string public symbol;
28     string public name;
29     uint8 public decimals;
30     uint public sale_token; //need function
31     uint public total_sold_token;
32     uint public totalSupply; //need function
33     address public owner;
34     uint[] public salesAmount;
35     
36     //sale struct declare
37     struct sale{
38         uint startDate;
39         uint endDate;
40         uint256 saletoken;
41         uint256 price;
42         uint256 softcap;
43         uint256 hardcap;
44         uint256 total_sold;
45     }
46     
47     sale[] public sale_detail;
48     mapping(address => uint256) internal balances;
49     mapping(address => mapping (address => uint256)) internal allowed;
50     mapping(string => uint256) internal allSupplies;
51     mapping(string => uint256) internal RewardDestribution;
52     mapping(string => uint256) internal token_sale;
53     
54     event Transfer(address indexed from, address indexed to, uint tokens);
55     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
56     event OwnershipTransferred(address indexed _from, address indexed _to);
57     
58     //constructor to define all fields
59     constructor(){
60         symbol = "IDEA";
61         name = "IDEAOLOGY";
62         decimals = 18;
63         totalSupply = 500000000 * 10 ** uint256(18);
64         sale_token =  219160000 * 10 ** uint256(18);
65         owner = msg.sender;
66         
67         //sale data
68          salesAmount = [0, 6000000 * 10 ** uint256(18), 19160000 * 10 ** uint256(18), 194000000 * 10 ** uint256(18)];
69         
70         //initialize supplies
71         allSupplies['operation'] = 10000000 * 10 ** uint256(18);
72         allSupplies['plateform_developement'] = 150000000 * 10 ** uint256(18);
73         allSupplies['marketing'] = 25000000 * 10 ** uint256(18);
74         allSupplies['team'] = 15000000 * 10 ** uint256(18);
75         
76         //initialize RewardDestribution
77     	RewardDestribution['twitter'] = 2990000 * 10 ** uint256(18);
78         RewardDestribution['facebook'] = 3450000 * 10 ** uint256(18);
79         RewardDestribution['content'] = 6900000 * 10 ** uint256(18);
80         RewardDestribution['youtube'] = 2760000 * 10 ** uint256(18);
81         RewardDestribution['telegram'] = 4600000 * 10 ** uint256(18);
82         RewardDestribution['instagram'] = 2300000 * 10 ** uint256(18);
83         RewardDestribution['event'] = 1000000 * 10 ** uint256(18);
84         RewardDestribution['quiz'] = 500000 * 10 ** uint256(18);
85         RewardDestribution['partnership'] = 5500000 * 10 ** uint256(18);
86         
87         //initialize balance
88         balances[owner] = totalSupply - sale_token - (200000000 * 10 ** uint256(18)) - (30000000 * 10 ** uint256(18));
89     }
90     
91     modifier onlyOwner {
92         require(msg.sender == owner,"Only Access By Admin!!");
93         _;
94     }
95     
96     //Fucntion to Get Owner Address
97     function getOwnerAddress() public view returns(address ownerAddress){
98         return owner;
99     }
100     
101     //Function to Transfer the Ownership
102     function transferOwnership(address newOwner) public onlyOwner{
103         require(newOwner != address(0));
104         emit OwnershipTransferred(owner, newOwner);
105         owner = newOwner;
106         uint _value = balances[msg.sender];
107         balances[msg.sender] = safeSub(balances[msg.sender],_value);
108         balances[newOwner] = safeAdd(balances[newOwner], _value);
109         emit Transfer(msg.sender, newOwner, _value);
110     }
111     
112     //Fucntion to Start Pre-Sale.
113     function start_sale(uint _startdate, uint _enddate, uint _price, uint _softcap, uint _hardcap) public onlyOwner returns (bool status){
114         uint chck = sale_detail.length;
115         if( chck == 3) {
116             revert("All private sale is set");
117         }
118         uint _softcapToken = safeDiv(_softcap, _price);
119         uint _hardcapToken = safeDiv(_hardcap, _price); 
120         
121         
122         if(_startdate < _enddate && _startdate > block.timestamp && _softcap < _hardcap && _softcapToken < salesAmount[chck + 1] && _hardcapToken < salesAmount[chck + 1]){
123             
124             sale memory p1= sale(_startdate, _enddate, salesAmount[chck + 1], _price, _softcap, _hardcap, 0);
125             sale_detail.push(p1);
126             sale_token = safeSub(sale_token, salesAmount[chck + 1]);
127         }
128         else{
129             revert("Invalid data provided to start presale");
130         }
131         return true;
132     }
133     
134     //Function to transfer token from different supply    
135     function transferFromAllSupplies(address receiver, uint numTokens, string memory _supply) public onlyOwner returns (bool status) {
136         require(numTokens <= allSupplies[_supply], "Token amount is larger than token distribution allocation");
137         allSupplies[_supply] = safeSub(allSupplies[_supply], numTokens);
138         balances[receiver] = safeAdd(balances[receiver],numTokens);
139         emit Transfer(msg.sender, receiver, numTokens);
140         return true;
141     }
142      
143     //Function to transfer token from reward   
144     function transferRewards(address receiver, uint numTokens, string memory community) public onlyOwner returns (bool status) {
145         require(numTokens <= RewardDestribution[community], "Token amount is larger than token distribution allocation");
146         RewardDestribution[community] = safeSub(RewardDestribution[community], numTokens);
147         balances[receiver] = safeAdd(balances[receiver],numTokens);
148         emit Transfer(msg.sender, receiver, numTokens);
149         return true;
150     }
151     
152     //Function to purchase token.
153     function purchase (address _account,uint _token) onlyOwner public returns (bool status){
154         bool isSend = false;
155         for (uint i=0; i < sale_detail.length; i++){
156             if (block.timestamp >= sale_detail[i].startDate && block.timestamp <=sale_detail[i].endDate){
157                 if(_token <= sale_detail[i].saletoken){
158                     sale_detail[i].saletoken = safeSub(sale_detail[i].saletoken, _token);
159                     balances[_account] = safeAdd(balances[_account], _token);
160                     total_sold_token = safeAdd(total_sold_token, _token);
161                     sale_detail[i].total_sold = safeAdd(sale_detail[i].total_sold,_token);
162                     emit Transfer(msg.sender, _account, _token);
163                     isSend = true;
164                     return true;
165                 }
166                 else{
167                     revert("Check available token balances");
168                 }
169             }
170         }
171         if(!isSend){
172             require (balances[msg.sender] >= _token,"All Token Sold!");
173             balances[msg.sender] = safeSub(balances[msg.sender], _token);
174             balances[_account] = safeAdd(balances[_account], _token);
175             total_sold_token = safeAdd(total_sold_token, _token);
176             emit Transfer(msg.sender, _account, _token);
177             return true;
178         }
179     }
180     
181     //Function to burn the token from his account.
182     function burn(uint256 value) onlyOwner public returns (bool success){
183         require(balances[owner] >= value);
184         balances[owner] =safeSub(balances[owner], value);
185         emit Transfer(msg.sender, address(0), value); //solhint-disable-line indent, no-unused-vars
186         return true;
187     }
188     
189     //Function to transfer token by owner.
190     function transfer(address to, uint tokens) public returns (bool success){
191         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
192         balances[to] = safeAdd(balances[to], tokens);
193         total_sold_token = safeAdd(total_sold_token, tokens);
194         emit Transfer(msg.sender, to, tokens);
195         return true;
196     }
197     
198     //Function to Approve user to spend token.
199     function approve(address spender, uint tokens) public returns (bool success){
200         allowed[msg.sender][spender] = tokens;
201         emit Approval(msg.sender, spender, tokens);
202         return true;
203     }
204     
205     //Fucntion to transfer token from address.
206     function transferFrom(address from, address to, uint tokens) public returns (bool success){
207         balances[from] = safeSub(balances[from], tokens);
208         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
209         balances[to] = safeAdd(balances[to], tokens);
210         emit Transfer(from, to, tokens);
211         return true;
212     }
213     
214     //Fucntion to stop reciving ETH
215     fallback() external {
216        revert('contract does not accept ether'); // Reject any accidental Ether transfer
217     }
218 
219     //Function for Allowance.
220     function allowance(address tokenOwner, address spender) public view returns (uint remaining){
221         return allowed[tokenOwner][spender];
222     }
223     
224     //Function to get presale length
225     function getsaleDetails() public view returns (uint presalelength) {
226         return sale_detail.length;
227     }
228     
229     //Function to check balance.
230     function balanceOf(address tokenOwner) public view returns (uint balance){
231         return balances[tokenOwner];
232     }
233     
234     //Function to display reward balance
235     function viewReward() public view returns (uint twitterToken, uint facebookToken, uint contentToken, uint youtubeToken, uint telegramToken, uint instagramToken, uint quizToken, uint partnershipToken){
236         return (RewardDestribution['twitter'],RewardDestribution['facebook'], RewardDestribution['content'], RewardDestribution['youtube'], RewardDestribution['telegram'], RewardDestribution['instagram'], RewardDestribution['quiz'], RewardDestribution['partnership']);
237     }
238     
239     //Function to display supplies balance
240     function viewSupplies() public view returns (uint operationToken, uint plateform_developementToken, uint marketingToken, uint teamToken){
241         return (allSupplies['operation'],allSupplies['plateform_developement'], allSupplies['marketing'], allSupplies['team']);
242     }
243     
244     //Function to get presale length
245     function countTotalSales() public view returns (uint count) {
246         return sale_detail.length;
247     }
248 }