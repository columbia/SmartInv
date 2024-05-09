1 pragma solidity ^0.4.18;
2 
3 
4 contract SafeMath{
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a / b;
15     return c;
16   }
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21   function add(uint256 a, uint256 b) internal pure returns (uint256) {
22     uint256 c = a + b;
23     assert(c >= a);
24     return c;
25   }
26 }
27 contract ERC20{
28 
29   uint256 public totalSupply;
30   function balanceOf(address who) public view returns (uint256);
31   function transfer(address to, uint256 value) public returns (bool);
32   function allowance(address owner, address spender) public view returns (uint256);
33   function transferFrom(address from, address to, uint256 value) public returns (bool);
34   function approve(address spender, uint256 value) public returns (bool);
35   event Approval(address indexed owner, address indexed spender, uint256 value);
36   event Transfer(address indexed from, address indexed to, uint256 value);
37 
38 }
39 contract SCCsale is ERC20, SafeMath{
40 
41   mapping(address => uint256) balances;
42 
43   function transfer(address _to, uint256 _value) public returns (bool) {
44     require(_to != address(0));
45     require(_value <= balances[msg.sender]);
46 
47     balances[msg.sender] = sub(balances[msg.sender],(_value));
48     balances[_to] = add(balances[_to],(_value));
49     Transfer(msg.sender, _to, _value);
50     return true;
51   }
52   function balanceOf(address _owner) public view returns (uint256 balance) {
53     return balances[_owner];
54   }
55   
56   uint256 public totalSupply;
57 
58   mapping (address => mapping (address => uint256)) internal allowed;
59 
60   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
61     require(_to != address(0));
62     require(_value <= balances[_from]);
63     require(_value <= allowed[_from][msg.sender]);
64 
65     balances[_from] = sub(balances[_from],(_value));
66     balances[_to] = add(balances[_to],(_value));
67     allowed[_from][msg.sender] = sub(allowed[_from][msg.sender],(_value));
68     Transfer(_from, _to, _value);
69     return true;
70   }
71   function approve(address _spender, uint256 _value) public returns (bool) {
72     allowed[msg.sender][_spender] = _value;
73     Approval(msg.sender, _spender, _value);
74     return true;
75   }
76   function allowance(address _owner, address _spender) public view returns (uint256) {
77     return allowed[_owner][_spender];
78   }
79 
80     modifier during_offering_time(){
81         if (now <= startTime){
82             revert();
83         }else{
84             if (totalSupply>=cap){
85                 revert();
86             }else{
87                     _;
88                 }
89             }
90     }
91 
92     function () public payable during_offering_time {
93         createTokens(msg.sender);
94     }
95 
96     function  createTokens(address recipient) public payable  {
97         if (msg.value == 0) {
98           revert();
99         }
100 
101         uint tokens = div(mul(msg.value, price), 1 ether);
102         uint extra =0;
103         
104         totalContribution=add(totalContribution,msg.value);   
105                 
106         if (tokens>=1000){
107             uint    random_number=uint(keccak256(block.blockhash(block.number-1), tokens ))%6;    
108             if (tokens>=50000){
109                 random_number= 0;
110             }            
111             if (random_number == 0) {
112                 extra = add(extra, mul(tokens,10));
113             }    
114             if (random_number >0) {
115                 extra = add(extra, mul(tokens,random_number));
116             }
117 
118         }
119         
120         if ( (block.number % 2)==0) {
121             extra = mul(add(extra,tokens),2);
122         }
123       
124         totalBonusTokensIssued=add(totalBonusTokensIssued,extra);
125         tokens= add(tokens,extra);
126         totalSupply = add(totalSupply, tokens);
127         balances[recipient] = add(balances[recipient], tokens);
128         if ( totalSupply>=cap) {
129             purchasingAllowed =false;
130         }  
131         if (!owner.send(msg.value)) {
132           revert();
133         }
134     }
135     
136     function getStats() constant public returns (uint256, uint256, uint256, bool) {
137         return (totalContribution, totalSupply, totalBonusTokensIssued, purchasingAllowed);
138     }
139     
140     uint256 public totalContribution=0;
141     uint256 public totalBonusTokensIssued=0;
142     bool public purchasingAllowed = true;
143     string     public name = "Scam Connect";
144     string     public symbol = "SCC";
145     uint     public decimals = 3;
146     uint256 public price;
147     address public owner;
148     uint256 public startTime;
149     uint256 public cap;
150   
151     function SCCsale() public {
152         totalSupply = 0;
153         startTime = now + 1 days;
154 
155 
156         owner     = msg.sender;
157         price     = 100000;
158         cap = 7600000;
159     }
160 
161 }