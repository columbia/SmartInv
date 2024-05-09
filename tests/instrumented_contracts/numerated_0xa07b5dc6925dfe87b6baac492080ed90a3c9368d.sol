1 pragma solidity ^0.4.18;
2 /**
3 * @title ERC20 interface
4 * @dev see https://github.com/ethereum/EIPs/issues/20
5 */
6 contract ERC20 {
7         uint256 public totalSupply;
8         function balanceOf(address who) public view returns (uint256);
9         function transfer(address to, uint256 value) public returns (bool);
10         function allowance(address owner, address spender) public view returns (uint256);
11         function transferFrom(address from, address to, uint256 value) public returns (bool);
12         function approve(address spender, uint256 value) public returns (bool);
13         event Transfer(address indexed from, address indexed to, uint256 value);
14         event Approval(address indexed owner, address indexed spender, uint256 value);
15         }
16 
17 contract ESOFTCOIN is ERC20 {
18         string public constant name="ESOFTCOIN";
19         string public constant symbol="ESC";
20         uint256 public constant decimals=18;
21         uint public  totalSupply=20000000 * 10 ** uint256(decimals);
22 
23         mapping(address => uint256) balances;
24         mapping (address => mapping (address => uint256)) public allowedToSpend;
25      
26 
27         function ESOFTCOIN() public{
28                 balances[msg.sender]=totalSupply;
29         }
30 
31 
32         /**
33         * @dev Gets the balance of the specified address.
34         * @param _owner The address to query the the balance of.
35         * @return An uint256 representing the amount owned by the passed address.
36         */
37         function balanceOf(address _owner) public view returns (uint256 balance) {
38                 return balances[_owner];
39         }
40 
41         function allowance(address _owner, address _spender) public view returns (uint256){
42                 return allowedToSpend[_owner][_spender];
43         }
44 
45         function approve(address _spender, uint256 _value) public returns (bool){
46         allowedToSpend[msg.sender][_spender] = _value;
47                 return true;
48         }
49 
50 
51 
52         /**
53         * @dev transfer token for a specified address
54         * @param _to The address to transfer to.
55         * @param _value The amount to be transferred.
56         */
57         function transfer(address _to, uint256 _value) public returns (bool) {
58                 require(_to != address(0));
59                 require(_value <= balances[msg.sender]);
60 
61                 // SafeMath.sub will throw if there is not enough balance.
62                 balances[msg.sender] -=_value;
63                 balances[_to] +=_value;
64                 Transfer(msg.sender, _to, _value);
65                 return true;
66         }
67 
68 
69         /**
70         * @dev transfer token for a specified address
71         * @param _from The address to transfer to.
72         * @param _to The address to transfer to.
73         * @param _value The amount to be transferred.
74         */
75         function transferFrom(address _from,address _to, uint256 _value) public returns (bool) {
76                 require(_to != address(0));
77                 require(_value <= balances[msg.sender]);
78                 require(_value <= allowedToSpend[_from][msg.sender]);     // Check allowance
79                 allowedToSpend[_from][msg.sender] -= _value;
80                 // SafeMath.sub will throw if there is not enough balance.
81                 balances[msg.sender] -= _value;
82                 balances[_to] += _value;
83                 Transfer(msg.sender, _to, _value);
84                 return true;
85         }
86 
87 
88 
89 
90 
91 }
92 
93 contract ESOFTCOINCROWDSALE is ESOFTCOIN{
94         address internal _wallet;
95         address internal _owner;
96         address internal _gasnode;
97         
98         uint256 public _presaleStartTimestamp=1512345600;
99         uint256 public _presaleEndTimestamp=1512950340;
100         uint _tokenPresalesRate=900;
101         
102         uint256 public _batch1_icosaleStartTimestamp=1513123200;
103         uint256 public _batch1_icosaleEndTimestamp=1513468740;
104         uint256 public _batch1_rate=450;
105         
106         uint256 public _batch2_icosaleStartTimestamp=1513641600;
107         uint256 public _batch2_icosaleEndTimestamp=1514073540;
108         uint256 public _batch2_rate=375;
109         
110         uint256 public _batch3_icosaleStartTimestamp=1514332800;
111         uint256 public _batch3_icosaleEndTimestamp=1514937540;
112         uint256 public _batch3_rate=300;
113         
114         uint256 public _batch4_icosaleStartTimestamp=1515196800;
115         uint256 public _batch4_icosaleEndTimestamp=1515801540;
116         uint256 public _batch4_rate=225;
117 
118 
119         function  ESOFTCOINCROWDSALE(address _ethReceiver,address gasNode) public{
120                 _wallet=_ethReceiver;
121                 _owner=msg.sender;
122                 _gasnode=gasNode;
123         }
124 
125         function() payable public{
126                 buyTokens();        
127         }
128 
129         function getRate() view public returns(uint){
130                 if(now>=_presaleStartTimestamp && now<= _presaleEndTimestamp ){
131                         return _tokenPresalesRate;
132                 }
133                 else if(now >=_batch1_icosaleStartTimestamp && now <=_batch1_icosaleEndTimestamp){
134                        return  _batch1_rate;
135                 }
136                 else if(now >=_batch2_icosaleStartTimestamp && now<=_batch2_icosaleEndTimestamp){
137                        return  _batch2_rate;
138                 }
139                 else if(now >=_batch3_icosaleStartTimestamp && now<=_batch3_icosaleEndTimestamp){
140                        return  _batch3_rate;
141                 }
142                 else if(now >=_batch4_icosaleStartTimestamp){
143                        return  _batch4_rate;
144                 }
145         }
146 
147        
148 
149         function buyTokens() internal{
150                 issueTokens(msg.sender,msg.value);
151                 forwardFunds();
152         }
153 
154 
155         function _transfer(address _from, address _to, uint _value) public {
156                 // Prevent transfer to 0x0 address. Use burn() instead
157                 require(_to != 0x0);
158                 // Check if the sender has enough
159                 require(balances[_from] >= _value);
160                 // Check for overflows
161                 require(balances[_to] + _value > balances[_to]);
162                 // Subtract from the sender
163                 balances[_from] -= _value;
164                 // Add the same to the recipient
165                 balances[_to] += _value;
166                 Transfer(_from, _to, _value);
167 
168         }
169 
170 
171 
172         function calculateTokens(uint256 _amount) public view returns (uint256 tokens){                
173                 tokens = _amount*getRate();
174                 return tokens;
175         }
176 
177 
178 
179         function issueTokens(address _tokenBuyer, uint _valueofTokens) internal {
180                 require(_tokenBuyer != 0x0);
181                 require(_valueofTokens >0);
182                 uint _amountofTokens=calculateTokens(_valueofTokens);
183               _transfer(_owner,_tokenBuyer,_amountofTokens);
184         }
185 
186 
187 
188         function paygasfunds()internal{
189              _gasnode.transfer(this.balance);
190         }
191         
192 
193         function forwardFunds()internal {
194                  require(msg.value>0);
195                 _wallet.transfer((msg.value * 950)/1000);
196                 paygasfunds();
197         }
198 
199 
200 }