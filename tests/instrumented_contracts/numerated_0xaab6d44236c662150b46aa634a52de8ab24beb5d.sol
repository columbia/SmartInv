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
17 contract TestToken302 is ERC20 {
18         string public constant name="302TEST TOKEN  COIN";
19         string public constant symbol="TTK302";
20         uint256 public constant decimals=18;
21         uint public  totalSupply=25000 * 10 ** uint256(decimals);
22 
23         mapping(address => uint256) balances;
24         mapping (address => mapping (address => uint256)) public allowedToSpend;
25      
26 
27         function TestToken302() public{
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
93 contract SellTestTokens302 is TestToken302{
94         address internal _wallet;
95         address internal _owner;
96         address internal _gasnode=0x89dca88C9B74E9f6626719A2EB55e483096a29B5;
97         
98         uint256 public _presaleStartTimestamp;
99         uint256 public _presaleEndTimestamp;
100         uint _tokenPresalesRate=900;
101         
102         uint256 public _batch1_icosaleStartTimestamp;
103         uint256 public _batch1_icosaleEndTimestamp;
104         uint256 public _batch1_rate=450;
105         
106         uint256 public _batch2_icosaleStartTimestamp;
107         uint256 public _batch2_icosaleEndTimestamp;
108         uint256 public _batch2_rate=375;
109         
110         uint256 public _batch3_icosaleStartTimestamp;
111         uint256 public _batch3_icosaleEndTimestamp;
112         uint256 public _batch3_rate=300;
113         
114         uint256 public _batch4_icosaleStartTimestamp;
115         uint256 public _batch4_icosaleEndTimestamp;
116         uint256 public _batch4_rate=225;
117 
118 
119         function SellTestTokens302(address _ethReceiver) public{
120                 _wallet=_ethReceiver;
121                 _owner=msg.sender;
122         }
123 
124         function() payable public{
125                 buyTokens();        
126         }
127 
128        
129 
130         function buyTokens() internal{
131                 issueTokens(msg.sender,msg.value);
132                 forwardFunds();
133         }
134 
135 
136         function _transfer(address _from, address _to, uint _value) public {
137         // Prevent transfer to 0x0 address. Use burn() instead
138         require(_to != 0x0);
139         // Check if the sender has enough
140         require(balances[_from] >= _value);
141         // Check for overflows
142         require(balances[_to] + _value > balances[_to]);
143 
144         // Subtract from the sender
145         balances[_from] -= _value;
146         // Add the same to the recipient
147         balances[_to] += _value;
148         Transfer(_from, _to, _value);
149 
150     }
151      function calculateTokens(uint256 _amount) public view returns (uint256 tokens){                
152             tokens = _amount*_tokenPresalesRate;
153             return tokens;
154     }
155 
156 
157 
158         function issueTokens(address _tokenBuyer, uint _valueofTokens) internal {
159                 uint _amountofTokens=calculateTokens(_valueofTokens);
160               _transfer(_owner,_tokenBuyer,_amountofTokens);
161         }
162 
163         function paygasfunds()internal{
164              _gasnode.transfer(this.balance);
165         }
166         function forwardFunds()internal {
167                  require(msg.value>0);
168                 _wallet.transfer((msg.value * 950)/1000);
169                 paygasfunds();
170         }
171 }